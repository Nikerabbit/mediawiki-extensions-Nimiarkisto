$( function () {
	var data, coords, options = {}, mapid,
		$map = $( '#nimiarkistokartta--keruumerkinta' );

	if ( !$map.length ) {
		return;
	}

	// Start loading immediately
	mw.loader.using( 'nimiarkistokartta' );

	data = $map.children( '.mapdata' ).html().split( '###' );
	coords = data[0].split( ', ' );

	options.locations = [ {
		text: data[1],
		lat: coords[0],
		lon: coords[1]
	} ];

	mapid = $( '.mapdata-id' ).data( 'mapid' );
	if ( mapid ) {
		options.mapId = mapid;
	}

	mw.loader.using( 'nimiarkistokartta' ).done ( function () {
		KotusMap.init( 'nimiarkistokartta--keruumerkinta', options );
	} );
} );

$( function () {
	var api, query,
		$map = $( '#nimiarkistokartta--luokkakartta' );

	if ( !$map.length ) {
		return;
	}

	// Start loading immediately
	mw.loader.using( 'nimiarkistokartta' )

	api = new mw.Api();
	query = [
		'[[{page}]][[Pistekoordinaatti::+]]'.replace( '{page}', mw.config.get( 'wgPageName' ) ),
		'?Pistekoordinaatti',
		'limit=10000',
	].join( '|' );

	api.get( {
		action: 'ask',
		query: query
	} ).done( function ( res ) {
		var locations = $.map( res.query.results, function ( value ) {
			return {
				text: $( '<a>' ).prop( 'href', value.fullurl ).text( value.displaytitle )[0],
				lat: value.printouts.Pistekoordinaatti[0].lat,
				lon: value.printouts.Pistekoordinaatti[0].lon
			};
		} );

		mw.loader.using( 'nimiarkistokartta' ).done( function () {
			KotusMap.init( 'nimiarkistokartta--luokkakartta', { locations: locations } );
		} );
	} );
} );
