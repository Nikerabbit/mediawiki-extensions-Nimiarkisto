<?php
/**
 * @author Niklas Laxström
 * @license GPL-2.0-or-later
 * @file
 */

// FIXME: this is no longer compatible with 1.33
use DataValues\Geo\Values\GlobeCoordinateValue;
use DataValues\Geo\Values\LatLongValue;
use DataValues\MonolingualTextValue;
use DataValues\StringValue;
use DataValues\TimeValue;
use Wikibase\DataModel\Entity\EntityDocument;
use Wikibase\DataModel\Entity\EntityIdValue;
use Wikibase\DataModel\Entity\Item;
use Wikibase\DataModel\Entity\ItemId;
use Wikibase\DataModel\Entity\Property;
use Wikibase\DataModel\Entity\PropertyId;
use Wikibase\DataModel\Services\Statement\GuidGenerator;
use Wikibase\DataModel\Snak\PropertyNoValueSnak;
use Wikibase\DataModel\Snak\PropertyValueSnak;
use Wikibase\DataModel\Statement\StatementList;
use Wikibase\DataModel\Term\Fingerprint;
use Wikibase\Repo\EditEntity\MediaWikiEditEntityFactory;
use Wikibase\Repo\WikibaseRepo;

require __DIR__ . '/vendor/autoload.php';
use Symfony\Component\Yaml\Yaml;

$IP = getenv( 'MW_INSTALL_PATH' ) ?: '../..';
require_once "$IP/maintenance/Maintenance.php";

class NimiarkistoImport extends Maintenance {
	/** @var User */
	private $user;
	/** @var array */
	private $data;
	/** @var MediaWikiEditEntityFactory */
	private $editEntityFactory;
	/** @var GuidGenerator */
	private $guidGenerator;

	public function __construct() {
		parent::__construct();
		$this->mDescription = 'Imports things to Wikibase';
		$this->addArg( 'file', 'THE FILE' );
	}

	public function execute() {
		// Autoloader is not yet available on __construct
		$repo = WikibaseRepo::getDefaultInstance();
		$this->editEntityFactory = $repo->newEditEntityFactory();
		$this->guidGenerator = new GuidGenerator();
		$this->user = User::newFromId( 1 );

		$this->data = $this->loadEntityData( __DIR__ . '/props.yaml' );
		$data = $this->loadEntityData( $this->getArg( 0 ) );
		foreach ( $data as $id => $entityData ) {
			try {
				$this->processEntityData( $id, $entityData );
			} catch ( Exception $e ) {
				echo $e;
			}
		}

		echo "\n^___^\n";
	}

	private function loadEntityData( $filename ) {
		if ( !is_readable( $filename ) ) {
			throw new Exception( "File $filename not readable" );
		}

		$data = Yaml::parse( file_get_contents( $filename ) );
		if ( !is_array( $data ) ) {
			throw new Exception( "Invalid YAML file $filename" );
		}

		return $data;
	}

	private function processEntityData( $entityId, array $data ) {
		// $this->checkPrerequisites( $data );

		echo "$entityId\n";
		$entity = $this->createEntity( $entityId, $data );
		$status = $this->saveEntity( $entity, 'Massatuonti' );

		if ( !$status->isOk() ) {
			throw new Exception( $status->getMessage() );
		}

		foreach ( $data[ 'creates' ] ?? [] as $name => $text ) {
			$title = Title::newFromText( $name );
			$content = ContentHandler::makeContent( $text, $title );

			$page = new WikiPage( $title );
			$page->doEditContent( $content, 'Massatuonti', false, false, $this->user );
		}

		return $entity;
	}

	private function createEntity( $id, $data ) {
		$isProperty = $id[ 0 ] === 'P';

		if ( $isProperty ) {
			if ( !isset( $data[ 'datatype' ] ) ) {
				var_dump( $id, $data );
			}

			$entity = Property::newFromType( $data['datatype'] );
			$entity->setId( new PropertyId( $id ) );
		} else {
			$entity = new Item();
			$entity->setId( new ItemId( $id ) );
		}

		return $this->populateEntity( $entity, $data );
	}

	private function populateEntity( EntityDocument $entity, array $data ) {
		$fingerprint = $this->createFingerprint(
			$data['labels'] ?? [],
			$data['descriptions'] ?? [],
			$data['aliases'] ?? []
		);

		$entity->setFingerprint( $fingerprint );
		if ( isset( $data['statements'] ) ) {
			$statements = $this->createStatements( $entity, $data );
			$entity->setStatements( $statements );
		}

		if ( isset( $data[ 'creates' ] ) ) {
			$entity->getSiteLinkList()->addNewSiteLink( 'nimiarkisto', (string)$entity->getId() );
		}

		return $entity;
	}

	private function createFingerprint( $labels, $descriptions, $aliases ) {
		$fingerprint = new Fingerprint();
		foreach ( $labels as $code => $value ) {
			$fingerprint->setLabel( $code, $value );
		}

		foreach ( $descriptions as $code => $value ) {
			$fingerprint->setDescription( $code, $value );
		}

		foreach ( $aliases as $code => $value ) {
			$fingerprint->setAliases( $code, $value );
		}

		return $fingerprint;
	}

	private function createStatements( EntityDocument $entity, $data ) {
		$list = new StatementList();

		foreach ( $data['statements'] as $propertyId => $values ) {
			foreach ( $values as $value ) {
				$property = $this->createEntity( $propertyId, $this->data[ $propertyId ] );
				$snak = $this->createSnak( $property, $value );

				$guid = $this->guidGenerator->newGuid( $entity->getId() );

				$list->addNewStatement( $snak, null, null, $guid );
			}
		}

		return $list;
	}

	private function createSnak( Property $property, $value ) {
		if ( $value === null ) {
			return new PropertyNoValueSnak( $property->getId() );
		}

		$datatype = $property->getDataTypeId();
		if ( $datatype === 'external-id' || $datatype === 'string' ) {
			// Stupid yaml parser converts strings to ints, maybe
			if ( is_int( $value ) ) {
				$value = (string)$value;
			}
			if ( !is_string( $value ) ) {
				var_dump( $value, $property->getId() );
			}
			$datavalue = new StringValue( $value );
		} elseif ( $datatype === 'monolingualtext' ) {
			if ( !is_array( $value ) || count( $value ) !== 1 ) {
				var_dump( $value, $property->getId() );
			}
			$text = current( $value );
			$code = key( $value );
			$datavalue = new MonolingualTextValue( $code, $text );
		} elseif ( $datatype === 'wikibase-item' ) {
			$datavalue = new EntityIdValue( new ItemId( $value ) );
		} elseif ( $datatype === 'time' ) {
			$datavalue = TimeValue::newFromArray( $value );
		} elseif ( $datatype === 'globe-coordinate' ) {
			$datavalue = new LatLongValue( $value[0], $value[1] );
			$datavalue = new GlobeCoordinateValue( $datavalue, $value[2] );
		} else {
			throw new Exception( "Unsupported datatype $datatype" );
		}

		return new PropertyValueSnak( $property->getId(), $datavalue );
	}

	private function saveEntity( EntityDocument $entity, $textSummary ) {
		$editEntity = $this->editEntityFactory->newEditEntity( $this->user, $entity->getId() );
		return $editEntity->attemptSave( $entity, $textSummary, 0, false );
	}
}

$maintClass = 'NimiarkistoImport';
require_once RUN_MAINTENANCE_IF_MAIN;
