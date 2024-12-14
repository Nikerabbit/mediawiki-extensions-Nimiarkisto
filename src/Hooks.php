<?php
declare( strict_types = 1 );

namespace MediaWiki\Extensions\Nimiarkisto;

use Html;
use MediaWiki\Cache\Hook\MessageCacheFetchOverridesHook;
use MediaWiki\Hook\BeforePageDisplayHook;
use MediaWiki\Hook\ParserFirstCallInitHook;
use MediaWiki\Permissions\PermissionManager;
use MediaWiki\Preferences\Hook\GetPreferencesHook;
use RuntimeException;
use Sanitizer;
use SpecialPage;
use Wikibase\Client\WikibaseClient;
use Wikibase\DataModel\Entity\EntityIdValue;
use Wikibase\DataModel\Entity\Item;
use Wikibase\DataModel\Entity\NumericPropertyId;
use Wikibase\DataModel\Snak\PropertyValueSnak;
use Wikibase\DataModel\Statement\Statement;

/**
 * @author Niklas Laxström
 * @license GPL-2.0-or-later
 */
class Hooks implements
	BeforePageDisplayHook,
	MessageCacheFetchOverridesHook,
	ParserFirstCallInitHook,
	GetPreferencesHook
{
	public function __construct(
		private readonly PermissionManager $permissionManager
	) {
	}

	/** @inheritDoc */
	public function onBeforePageDisplay( $out, $skin ): void {
		$user = $out->getUser();

		$out->addModuleStyles( [ 'nimiarkisto', 'nimiarkistokartta.styles' ] );
		$out->addModules( 'nimiarkistokartta.init' );

		if ( !$this->permissionManager->userHasRight( $user, 'alledit' ) ) {
			$out->addBodyClasses( 'na-user--limited' );
		}

		if ( $user->isAnon() ) {
			$out->addBodyClasses( 'na-user--anon' );
		}

		$overrides = [
			'sv' => 'sv',
			'sms' => 'sms',
			'smn' => 'smn',
			'se' => 'se',
		];

		$userLang = $out->getLanguage()->getCode();
		$lang = $overrides[ $userLang ] ?? 'fi';

		global $wgTimelessWordmark, $wgTimelessLogo;
		$wgTimelessWordmark = [
			'1x' => "/logo-$lang.svg",
			'width' => null,
			'height' => 35,
		];

		$wgTimelessLogo = [
			'1x' => "/logo-$lang.svg",
			'width' => 160,
			'height' => null,
		];
	}

	public function onParserFirstCallInit( $parser ): void {
		$parser->setFunctionHook( 'nac', static function ( $parser, $param1 = '' ) {
			$output = Sanitizer::decodeCharReferences( $param1 );
			$output = str_replace( [ "'", '"' ], [ '′', '″' ], $output );
			return [ $output ];
		} );

		// Use JavaScript to move the title in the DOM
		$parser->setFunctionHook( 'mytitle', static function () {
			$output = <<<HTML
<div id="mytitleplaceholder"></div>
<script>
document.getElementById( 'mytitleplaceholder' )
	.appendChild( document.getElementById( 'firstHeading' ) );
</script>
HTML;
			return [ $output, 'noparse' => true, 'isHTML' => true ];
		} );

		$parser->setFunctionHook( 'nimilippukuvat', function ( $parser, $param1 = '' ) {
			$out = '';

			try {
				$images = self::getImages( $param1 );
				$sp = SpecialPage::getTitleFor( 'FSIS' );
				foreach ( $images as $x ) {
					$out .= Html::element(
						'img',
						[ 'src' => $sp->getLocalUrl( [ 'g' => $x[ 'group' ], 'f' => $x[ 'file' ] ] ) ]
					);
				}
			} catch ( RuntimeException $e ) {
				$out = htmlspecialchars( "ERROR: {$e->getMessage()}" );
			}

			return [ $out, 'isHTML' => true ];
		} );
	}

	private static function getImages( string $input ): array {
		$entityLookup = WikibaseClient::getStore()->getEntityLookup();

		// kl = keruulippu, nl = nimilippu
		$klEntityId = WikibaseClient::getEntityIdParser()->parse( $input );
		$klEntity = $entityLookup->getEntity( $klEntityId );
		if ( !$klEntity instanceof Item ) {
			return [];
		}

		$P10037 = new NumericPropertyId( 'P10037' );
		$producerStatements = $klEntity->getStatements()->getByPropertyId( $P10037 )->toArray();
		if ( $producerStatements === [] ) {
			return [];
		}

		// Q23 is Kotus
		if ( self::getPropertyValueQid( $producerStatements[0] ) !== 'Q23' ) {
			return [];
		}

		$P10025 = new NumericPropertyId( 'P10025' );
		$nameTypeStatements = $klEntity->getStatements()->getByPropertyId( $P10025 )->toArray();
		if ( $nameTypeStatements === [] ) {
			return [];
		}

		// Q11 is "person name"
		if ( self::getPropertyValueQid( $nameTypeStatements[0] ) === 'Q11' ) {
			return [];
		}

		$P10014 = new NumericPropertyId( 'P10014' );
		$collectionStatements = $klEntity->getStatements()->getByPropertyId( $P10014 )->toArray();
		if ( $collectionStatements === [] ) {
			return [];
		}
		$collection = self::getPropertyValueQid( $collectionStatements[0] );

		$group = 'Kotus';
		$images = [];

		$P10029 = new NumericPropertyId( 'P10029' );
		$klStatements = $klEntity->getStatements()->getByPropertyId( $P10029 );
		foreach ( $klStatements as $klStatement ) {
			$klSnak = $klStatement->getMainSnak();
			if ( !$klSnak instanceof PropertyValueSnak ) {
				continue;
			}
			$klValue = $klSnak->getDataValue();
			if ( !$klValue instanceof EntityIdValue ) {
				continue;
			}
			$nlEntityId = $klValue->getEntityId();

			$nlEntity = $entityLookup->getEntity( $nlEntityId );
			if ( !$nlEntity instanceof Item ) {
				continue;
			}

			// Whether image is hidden or not
			$P10041 = new NumericPropertyId( 'P10041' );
			$jsStatements = $nlEntity->getStatements()->getByPropertyId( $P10041 );
			foreach ( $jsStatements as $jsStatement ) {
				if ( self::getPropertyValueQid( $jsStatement ) === 'Q28' ) {
					continue 2;
				}
			}

			$P10020 = new NumericPropertyId( 'P10020' );
			$nlStatements = $nlEntity->getStatements()->getByPropertyId( $P10020 );
			foreach ( $nlStatements as $nlStatement ) {
				$nlSnak = $nlStatement->getMainSnak();
				$name = $nlSnak->getDataValue()->getValue();
				if ( $collection === 'Q34' ) {
					// 1-kokoelma
					$name = mb_strtoupper( $name );
					$name = str_replace( 'KOTUS-', 'kotus-', $name );
					$name = str_replace( '.JPG', '.jpg', $name );
				}
				$images[] = [
					'group' => $group,
					'file' => $name,
				];
			}
		}

		return $images;
	}

	private static function getPropertyValueQid( Statement $statement ): ?string {
		$snak = $statement->getMainSnak();
		if ( !$snak instanceof PropertyValueSnak ) {
			return null;
		}

		$value = $snak->getDataValue();
		if ( $value instanceof EntityIdValue ) {
			return $value->getEntityId()->getSerialization();
		}

		return null;
	}

	/** @inheritDoc */
	public function onMessageCacheFetchOverrides( &$overrides ): void {
		static $locals = null;
		if ( $locals === null ) {
			$locals = json_decode( file_get_contents( __DIR__ . '/../i18n/en.json' ), true );
		}

		foreach ( array_keys( $locals ) as $key ) {
			$overrides[$key] = "nimiarkisto-override-$key";
		}
	}

	public function onGetPreferences( $user, &$preferences ): void {
		$preferences['requestvanish-link'] = [
			'type' => 'info',
			'raw' => true,
			'default' => \MediaWiki\Html\Html::element(
				'a',
				[ 'href' => SpecialPage::getTitleFor( 'RequestVanish' )->getLocalURL() ],
				wfMessage( 'requestvanish-preferences-link' )->text()
			),
			'label-message' => 'requestvanish-preferences-label',
			'section' => 'personal/info',
		];
	}
}
