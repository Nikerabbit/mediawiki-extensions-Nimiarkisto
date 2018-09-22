<?php
/**
 * @author Niklas Laxström
 * @license GPL-2.0-or-later
 * @file
 */

namespace MediaWiki\Extension\Nimiarkisto;

use RuntimeException;
use SpecialPage;
use Html;
use Wikibase\Client\WikibaseClient;
use Wikibase\DataModel\Entity\PropertyId;

class Hooks {
	public static function onBeforePageDisplay( $out, $skin ) {
		$user = $out->getUser();

		$out->addModuleStyles( [ 'nimiarkisto', 'nimiarkistokartta.styles' ] );
		$out->addModules( 'nimiarkistokartta.init' );

		if ( !$user->isAllowed( 'alledit' ) ) {
			$out->addBodyClasses( 'na-user--limited' );
		}

		if ( $user->isAnon() ) {
			$out->addBodyClasses( 'na-user--anon' );
		}
	}

	public static function onParserFirstCallInit( $parser ) {
		$parser->setFunctionHook( 'nac', function ( $parser, $param1 = '' ) {
			$output = \Sanitizer::decodeCharReferences( $param1 );
			$output = str_replace( [ "'", '"' ], [ '′', '″' ], $output );
			return [ $output ];
		} );

		// Use JavaScript to move the title in the DOM
		$parser->setFunctionHook( 'mytitle', function ( $parser ) {
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

	private static function getImages( $input ) {
		$wbc = WikibaseClient::getDefaultInstance();

		// kl = keruulippu, nl = nimilippu
		$klEntityId = $wbc->getEntityIdParser()->parse( $input );
		$klEntity = $wbc->getStore()->getEntityLookup()->getEntity( $klEntityId );
		$P10037 = new PropertyId( 'P10037' );
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

		$P10025 = new PropertyId( 'P10025' );
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

		$group = 'Kotus';
		$images = [];

		$P10029 = new PropertyId( 'P10029' );
		$klStatements = $klEntity->getStatements()->getByPropertyId( $P10029 );
		foreach ( $klStatements as $klStatement ) {
			$nlEntityId = $klStatement->getMainSnak()->getDataValue()->getEntityId();
			$nlEntity = $wbc->getStore()->getEntityLookup()->getEntity( $nlEntityId );

			// Whether image is hidden or not
			$P10041 = new PropertyId( 'P10041' );
			$jsStatements = $nlEntity->getStatements()->getByPropertyId( $P10041 );
			foreach ( $jsStatements as $jsStatement ) {
				$status = $jsStatement->getMainSnak()->getDataValue()->getEntityId()->getLocalPart();
				if ( $status === 'Q28' ) {
					continue 2;
				}
			}

			$P10020 = new PropertyId( 'P10020' );
			$nlStatements = $nlEntity->getStatements()->getByPropertyId( $P10020 );
			foreach ( $nlStatements as $nlStatement ) {
				$name = $nlStatement->getMainSnak()->getDataValue()->getValue();
				$name = mb_strtoupper( $name );
				$name = str_replace( 'KOTUS-', 'kotus-', $name );
				$name = str_replace( '.JPG', '.jpg', $name );
				$images[] = [
					'group' => $group,
					'file' => $name,
				];
			}
		}

		return $images;
	}

	public static function onLanguageGetMagic( &$raw ) {
		// Convert formatted coordinates to plain coordinates
		$raw['nac'] = [ 1, 'NAC' ];
		// Allows moving the page title to different location
		$raw['mytitle'] = [ 0, 'mytitle' ];

		$raw['nimilippukuvat'] = [ 0, 'nimilippukuvat' ];
	}

	/**
	 * When core requests certain messages, change the key to a custom version.
	 *
	 * @see https://www.mediawiki.org/wiki/Manual:Hooks/MessageCache::get
	 * @param String &$lcKey message key to check and possibly convert
	 */
	public static function onMessageCacheGet( &$lcKey ) {
		$keys = json_decode( file_get_contents( __DIR__ . '/../i18n/en.json' ), true );

		$overrideKey = "nimiarkisto-override-$lcKey";
		if ( isset( $keys[ $overrideKey ] ) ) {
			$lcKey = $overrideKey;
		}
	}
}
