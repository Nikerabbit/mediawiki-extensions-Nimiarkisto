/* globals KotusMap */

$( function () {
	// eslint-disable-next-line no-jquery/no-global-selector
	const $map = $( '#nimiarkistokartta--keruumerkinta' );

	if ( !$map.length ) {
		return;
	}

	// Start loading immediately
	mw.loader.using( 'nimiarkistokartta' );

	const data = $map.children( '.mapdata' ).html().split( '###' );
	const coords = data[ 0 ].split( ', ' );

	const options = { locations: [ {
		text: data[ 1 ],
		lat: coords[ 0 ],
		lon: coords[ 1 ]
	} ] };

	// eslint-disable-next-line no-jquery/no-global-selector
	const mapid = $( '.mapdata-id' ).data( 'mapid' );
	if ( mapid ) {
		options.mapId = String( mapid ).replace( '_', '.' );
	}

	mw.loader.using( 'nimiarkistokartta' ).done( function () {
		KotusMap.init( 'nimiarkistokartta--keruumerkinta', options );
	} );
} );

$( function () {
	// eslint-disable-next-line no-jquery/no-global-selector
	const $map = $( '#nimiarkistokartta--luokkakartta' );

	if ( !$map.length ) {
		return;
	}

	// Start loading immediately
	mw.loader.using( 'nimiarkistokartta' );

	const api = new mw.Api();
	const query = [
		'[[{page}]][[Pistekoordinaatti::+]]'.replace( '{page}', mw.config.get( 'wgPageName' ) ),
		'?Pistekoordinaatti',
		'limit=10000'
	].join( '|' );

	api.get( {
		action: 'ask',
		query: query
	} ).done( function ( res ) {
		const locations = ( res.query.results || [] ).map( function ( value ) {
			return {
				text: $( '<a>' ).prop( 'href', value.fullurl ).text( value.displaytitle )[ 0 ],
				lat: value.printouts.Pistekoordinaatti[ 0 ].lat,
				lon: value.printouts.Pistekoordinaatti[ 0 ].lon
			};
		} );

		mw.loader.using( 'nimiarkistokartta' ).done( function () {
			KotusMap.init( 'nimiarkistokartta--luokkakartta', { locations: locations } );
		} );
	} );
} );

// https://github.com/SemanticMediaWiki/SemanticMediaWiki/issues/4882
$( function () {
	// eslint-disable-next-line no-jquery/no-global-selector
	if ( $( '.maps-leaflet' ).length ) {
		mw.loader.load( 'ext.maps.leaflet.loader' );
	}
} );
