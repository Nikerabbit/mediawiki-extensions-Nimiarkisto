<?php

namespace MediaWiki\Extension\Nimiarkisto;

class Hooks {
	public static function onBeforePageDisplay( $out, $skin ) {
		$out->addModuleStyles( 'nimiarkistokartta.styles' );
		$skin->getOutput()->addModules( 'nimiarkistokartta.init' );
	}

	public static function onParserFirstCallInit( $parser ) {
		$parser->setFunctionHook( 'nac', function ( $parser, $param1 = '' ) {
			$output = html_entity_decode( $param1 );
			// Some sanitization
			$output = preg_replace( '/[<>&:]/', '', $output );
			return [ $output, 'noparse' => true ];
		} );

		$parser->setFunctionHook( 'mytitle', function ( $parser ) {
			$output = <<<HTML
<div id="mytitleplaceholder"></div>
<script>document.getElementById( 'mytitleplaceholder' ).appendChild( document.getElementById( 'firstHeading' ) );</script>
HTML;
			return [ $output, 'noparse' => true, 'isHTML' => true ];
		} );
	}

	public static function onLanguageGetMagic( &$raw ) {
		$raw['nac'] = [ 1, 'NAC' ];
		$raw['mytitle'] = [ 0, 'mytitle' ];
	}
}
