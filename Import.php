<?php
/**
 * @author Niklas Laxström
 * @license GPL-2.0+
 * @file
 */

use DataValues\Geo\Values\GlobeCoordinateValue;
use DataValues\Geo\Values\LatLongValue;
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
use Wikibase\Repo\WikibaseRepo;

$IP = getenv( 'MW_INSTALL_PATH' ) ?: '../..';
require_once "$IP/maintenance/Maintenance.php";

class NimiarkistoImport extends Maintenance {
	private $map = [];

	public function __construct() {
		parent::__construct();
		$this->mDescription = 'Imports things to Wikibase';
		$this->path = __DIR__;
	}

	public function execute() {
		// Autoloader is not yet available on __constuct
		$repo = WikibaseRepo::getDefaultInstance();
		$this->editEntityFactory = $repo->newEditEntityFactory();
		$this->entityStore = $repo->getEntityStore();
		$this->guidGenerator = new GuidGenerator();
		$this->user = User::newFromId( 1 );

		// First the support stuff, then the actual data
		foreach ( [ 'entities', 'dataentities' ] as $dir ) {
			$iter = new RecursiveIteratorIterator( new RecursiveDirectoryIterator( "{$this->path}/$dir" ) );
			foreach ( $iter as $entry ) {
				if ( !$entry->isFile() || $entry->getExtension() !== 'json' ) {
					continue;
				}

				echo $dir . '/' . $iter->getSubPathName() . "\n";
				$data = $this->loadEntityData( "{$this->path}/$dir/" . $iter->getSubPathName() );
				$this->processEntityData( $data );
			}
		}

		echo "\n^___^\n";
	}

	private function loadEntityData( $filename ) {
		if ( !is_readable( $filename ) ) {
			throw new Exception( "File $filename not readable" );
		}

		$data = json_decode( file_get_contents( $filename ), true );
		if ( !is_array( $data ) ) {
			throw new Exception( "Invalid JSON file $filename" );
		}

		$data['filename'] = $filename;

		$idFilename = preg_replace( '~\.json$~', '.id', $filename );
		$id = file_exists( $idFilename ) ? trim( file_get_contents( $idFilename ) ) : null;
		$data['id'] = $id;
		$data['idFilename'] = $idFilename;

		$guidsFilename = preg_replace( '~\.json$~', '.guids', $filename );
		$guids = file_exists( $guidsFilename ) ? json_decode( file_get_contents( $guidsFilename ), true ) : [];
		$data['guids'] = $guids;
		$data['guidsFilename'] = $guidsFilename;

		$templateFilename = dirname( $filename ) . '/template';
		$template = file_exists( $templateFilename ) ? file_get_contents( $templateFilename ) : null;
		$data['template'] = $template;

		$categoryFilename = dirname( $filename ) . '/category';
		$category = file_exists( $categoryFilename ) ? file_get_contents( $categoryFilename ) : null;
		$data['category'] = $category;

		return $data;
	}

	private function processEntityData( array $data ) {
		$this->checkPrerequisites( $data );

		$isProperty = isset( $data['datatype'] );

		if ( $isProperty ) {
			$entity = Property::newFromType( $data['datatype'] );
			if ( $data['id'] !== null ) {
				$entity->setId( new PropertyId( $data['id'] ) );
			}
		} else {
			$entity = new Item();
			if ( $data['id'] !== null ) {
				$entity->setId( new ItemId( $data['id'] ) );
			}
		}

		if ( $entity->getId() === null ) {
			$this->entityStore->assignFreshId( $entity );
		}

		$entity = $this->populateEntity( $entity, $data );

		$status = $this->saveEntity( $entity, 'Massatuonti' );

		if ( !$status->isOk() ) {
			throw new Exception( $status->getMessage() );
		}

		if ( !file_exists( $data['idFilename'] ) ) {
			file_put_contents( $data['idFilename'], $entity->getId() . "\n" );
		}


		$guids = [];
		foreach ( $entity->getStatements() as $statement ) {
			$snak = $statement->getMainSnak();
			$guids[$snak->getPropertyId()->getNumericId()] = $statement->getGuid();
		}

		if ( $guids ) {
			file_put_contents( $data['guidsFilename'], json_encode( $guids, JSON_PRETTY_PRINT ) );
		}

		if ( !isset( $data['root'] ) ) {
			$this->map[$data['filename']] = $entity;
		}

		if ( isset( $data['template'] ) ) {
			$title = Title::newFromText( (string)$entity->getId() );
			$content = ContentHandler::makeContent( $data['template'], $title );

			$page = new WikiPage( $title );
			$page->doEditContent( $content, 'Massatuonti', false, false, $this->user );
		}

		if ( isset( $data['category'] ) ) {
			$title = Title::newFromText( 'Category:' . $data['labels']['fi'] );
			$content = ContentHandler::makeContent( $data['category'], $title );

			$page = new WikiPage( $title );
			$page->doEditContent( $content, 'Massatuonti', false, false, $this->user );
		}

		return $entity;
	}

	private function checkPrerequisites( array $data ) {
		if ( !isset( $data['statements'] ) ) {
			$data['statements'] = [];
		}

		foreach ( $data['statements'] as $name => $snakInfos ) {
			$this->checkEntity( "entities/properties/$name" );
			$property = $this->getEntityObject( "entities/properties/$name" );
			if ( $property->getDataTypeId() === 'wikibase-item' ) {
				$this->checkEntity( $snakInfos['value'] );
			}

			if ( !isset( $snakInfos['qualifiers'] ) ) {
				continue;
			}

			foreach ( $snakInfos['qualifiers'] as $qName => $qValue ) {
				$this->checkEntity( "entities/properties/$qName" );
				$property = $this->getEntityObject( "entities/properties/$qName" );
				if ( $property->getDataTypeId() === 'wikibase-item' ) {
					$this->checkEntity( $qValue );
				}
			}
		}
	}

	private function checkEntity( $name ) {
		$filename = "{$this->path}/$name.json";
		if ( !isset( $this->map[$filename] ) ) {
			$data = $this->loadEntityData( $filename );
			$this->processEntityData( $data );
		}
	}

	private function populateEntity( EntityDocument $entity, array $data ) {
		$fingerprint = $this->createFingerprint(
			isset( $data['labels'] ) ? $data['labels'] : [],
			isset( $data['descriptions'] ) ? $data['descriptions'] : [],
			isset( $data['aliases'] ) ? $data['aliases'] : []
		);

		$entity->setFingerprint( $fingerprint );
		if ( isset( $data['statements'] ) ) {
			$statements = $this->createStatements( $entity, $data );
			$entity->setStatements( $statements );
		}

		if ( isset( $data['template'] ) ) {
			$entity->getSiteLinkList()->addNewSiteLink( 'nimiarkisto', (string)$entity->getId() );
		}

		return $entity;
	}

	private function createFingerprint( $labels, $descriptions, $aliases ) {
		$fingerprint = new Fingerprint();
		foreach ( $labels as $code => $value ) {
			$fingerprint->setLabel( $code, $value );
		}

		foreach( $descriptions as $code => $value ) {
			$fingerprint->setDescription( $code, $value );
		}

		foreach ( $aliases as $code => $value ) {
			$fingerprint->setAliases( $code, $value );
		}

		return $fingerprint;
	}

	private function createStatements( EntityDocument $entity, $data ) {
		$list = new StatementList();

		foreach ( $data['statements'] as $name => $snakInfos ) {
			$property = $this->getEntityObject( "entities/properties/$name" );

			$snak = $this->createSnak( $property, $snakInfos['value'] );

			$pnid = $property->getId()->getNumericId();
			if ( isset( $data['guids'][$pnid] ) ) {
				$guid = $data['guids'][$pnid];
			} else {
				$guid = $this->guidGenerator->newGuid( $entity->getId() );
			}

			$qualifiers = [];
			$qualifierInfo = isset( $snakInfos['qualifiers'] ) ? $snakInfos['qualifiers'] : [];
			foreach ( $qualifierInfo as $qName => $qValue ) {
				$qProperty = $this->getEntityObject( "entities/properties/$qName" );
				$qualifiers[] = $this->createSnak( $qProperty, $qValue );
			}

			$list->addNewStatement( $snak, $qualifiers, null, $guid );
		}

		return $list;
	}

	private function createSnak( Property $property, $value ) {
		if ( $value === null ) {
			return new PropertyNoValueSnak( $property->getId() );
		}

		$datatype = $property->getDataTypeId();
		if ( $datatype === 'external-id' || $datatype === 'string' ) {
			$datavalue = new StringValue( $value );
		} elseif ( $datatype === 'wikibase-item' ) {
			$datavalue = new EntityIdValue( $this->getEntityObject( $value )->getId() );
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

	private function getEntityObject( $name ) {
		return $this->map[ "{$this->path}/$name.json"];
	}

	private function saveEntity( EntityDocument $entity, $textSummary ) {
		$editEntity = $this->editEntityFactory->newEditEntity( $this->user, $entity->getId(), false );
		$status = $editEntity->attemptSave( $entity, $textSummary, 0, false );

		return $status;
	}
}

$maintClass = 'NimiarkistoImport';
require_once RUN_MAINTENANCE_IF_MAIN;
