$( function () {
	var data, coords, loc,
		$map = $( '#nimiarkistokartta--keruumerkinta' );

	if ( !$map.length ) {
		return;
	}

	// Start loading immediately
	mw.loader.using( 'nimiarkistokartta' )

	data = $map.children( '.mapdata' ).html().split( '###' );
	coords = data[0].split( ', ' );

	loc = {
		text: data[1],
		lat: coords[0],
		lon: coords[1]
	};

	mw.loader.using( 'nimiarkistokartta' ).done ( function () {
		KotusMap.init( 'nimiarkistokartta--keruumerkinta', { locations: [ loc ] } );
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
