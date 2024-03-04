<?php
declare( strict_types = 1 );

namespace MediaWiki\Extensions\Nimiarkisto;

use Html;
use MediaWiki\Cache\Hook\MessageCache__getHook;
use MediaWiki\Hook\BeforePageDisplayHook;
use MediaWiki\Hook\ParserFirstCallInitHook;
use MediaWiki\Permissions\PermissionManager;
use RuntimeException;
use Sanitizer;
use SpecialPage;
use Wikibase\Client\WikibaseClient;
use Wikibase\DataModel\Entity\NumericPropertyId;

/**
 * @author Niklas Laxström
 * @license GPL-2.0-or-later
 */
class Hooks implements BeforePageDisplayHook, MessageCache__getHook, ParserFirstCallInitHook {
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
		if ( !$klEntity ) {
			return [];
		}

		$P10037 = new NumericPropertyId( 'P10037' );
		$producerStatements = $klEntity->getStatements()->getByPropertyId( $P10037 )->toArray();
		if ( $producerStatements === [] ) {
			return [];
		}

		$producer = $producerStatements[ 0 ]
			->getMainSnak()
			->getDataValue()
			->getEntityId()
			->getLocalPart();
		// Q23 is Kotus
		if ( $producer !== 'Q23' ) {
			return [];
		}

		$P10025 = new NumericPropertyId( 'P10025' );
		$nameTypeStatements = $klEntity->getStatements()->getByPropertyId( $P10025 )->toArray();
		if ( $nameTypeStatements === [] ) {
			return [];
		}

		$type = $nameTypeStatements[ 0 ]
			->getMainSnak()
			->getDataValue()
			->getEntityId()
			->getLocalPart();
		// Q11 is "person name"
		if ( $type === 'Q11' ) {
			return [];
		}

		$P10014 = new NumericPropertyId( 'P10014' );
		$collectionStatements = $klEntity->getStatements()->getByPropertyId( $P10014 )->toArray();
		if ( $collectionStatements === [] ) {
			return [];
		}
		$collection = $collectionStatements[ 0 ]
			->getMainSnak()
			->getDataValue()
			->getEntityId()
			->getLocalPart();

		$group = 'Kotus';
		$images = [];

		$P10029 = new NumericPropertyId( 'P10029' );
		$klStatements = $klEntity->getStatements()->getByPropertyId( $P10029 );
		foreach ( $klStatements as $klStatement ) {
			$nlEntityId = $klStatement->getMainSnak()->getDataValue()->getEntityId();
			$nlEntity = $entityLookup->getEntity( $nlEntityId );
			if ( !$nlEntity ) {
				continue;
			}

			// Whether image is hidden or not
			$P10041 = new NumericPropertyId( 'P10041' );
			$jsStatements = $nlEntity->getStatements()->getByPropertyId( $P10041 );
			foreach ( $jsStatements as $jsStatement ) {
				$status = $jsStatement->getMainSnak()->getDataValue()->getEntityId()->getLocalPart();
				if ( $status === 'Q28' ) {
					continue 2;
				}
			}

			$P10020 = new NumericPropertyId( 'P10020' );
			$nlStatements = $nlEntity->getStatements()->getByPropertyId( $P10020 );
			foreach ( $nlStatements as $nlStatement ) {
				$name = $nlStatement->getMainSnak()->getDataValue()->getValue();
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

	/** @inheritDoc */
	public function onMessageCache__get( &$key ): void {
		static $keys = null;
		if ( $keys === null ) {
			$keys = json_decode( file_get_contents( __DIR__ . '/../i18n/en.json' ), true );
		}

		$overrideKey = "nimiarkisto-override-$key";
		if ( isset( $keys[ $overrideKey ] ) ) {
			$key = $overrideKey;
		}
	}
}
