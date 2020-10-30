/* Tämän sivun JavaScript-koodi liitetään jokaiseen sivulataukseen */
mw.loader.load( [
	'oojs-ui-core.styles',
	'oojs-ui.styles.icons-accessibility',
	'oojs-ui.styles.icons-alerts',
	'oojs-ui.styles.icons-content',
	'oojs-ui.styles.icons-editing-advanced',
	'oojs-ui.styles.icons-editing-core',
	'oojs-ui.styles.icons-editing-list',
	'oojs-ui.styles.icons-editing-styling',
	'oojs-ui.styles.icons-interactions',
	'oojs-ui.styles.icons-layout',
	'oojs-ui.styles.icons-location',
	'oojs-ui.styles.icons-media',
	'oojs-ui.styles.icons-moderation',
	'oojs-ui.styles.icons-movement',
	'oojs-ui.styles.icons-user',
	'oojs-ui.styles.icons-wikimedia'
] );

mw.hook( 'wikibase.entityPage.entityLoaded' ).add( function ( item ) {
	if (
		mw.config.get( 'wgUserGroups' ).length === 1 && // Anonymous
		item.claims.P31 &&
		item.claims.P31[ 0 ].mainsnak.datavalue.value.id === 'Q5'
	) {
		mw.notify( 'Hetki... ladataan merkintää' );
		location.href = location.href.replace( /Item:/, '' );
	}
} );

$( function () {
	// eslint-disable-next-line no-jquery/no-global-selector
	$( '#p-navigation li a' )
		.filter( "[href^='http://'], [href^='https://']" )
		.prop( 'target', '_blank' );
} );
