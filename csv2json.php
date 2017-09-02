<?php

$IN = isset( $argv[1] ) ? $argv[1] : 'data';
$OUT = isset( $argv[2] ) ? $argv[2] : '.';
process( $IN, $OUT );

function process( $IN, $OUT ) {
	$all = [];

	$iter = new DirectoryIterator( $IN );
	foreach ( $iter as $entry ) {
		if ( !$entry->isFile() || $entry->getExtension() !== 'csv' ) {
			continue;
		}

		$filename = $entry->getFilename();

		$parsed = array_map( 'str_getcsv', file( "$IN/$filename" ) );
		$header = array_shift( $parsed );

		$parsed = addWSG( $parsed );

		$pitäjä = $parsed[0][8];

		foreach ( $parsed as $line ) {
			$lineId = $line[0];
			$name = $line[1];
			$kerääjä = $line[9];

			if ( preg_match ( '/_B.jpg$/', $line[12] ) ) {
				//echo "\nIgnoring backside for $pitäjä:$lineId\n";
				continue;
			}

			if ( $name === '' ) {
				echo "\nNo name for $pitäjä:$lineId\n";
				var_dump( $line );
				continue;
			}

			if ( trim( $kerääjä ) !== '' ) {
				writeItem( $OUT, makeKerääjäName( $kerääjä ), makeKerääjä( $kerääjä ) );
			}

			$realPitäjä = $line[16] ?: $line[8];
			writeItem( $OUT, makePitäjäName( $realPitäjä ), makePitäjä( $realPitäjä ) );

			if ( (int)$line[17] !== 0 ) {
				writeItem( $OUT, makeKarttakuvaName( $line[17] ), makeKarttakuva( $line[17] ) );
			}
			writeItem( $OUT, makeKeruukorttiName( $line ), makeKeruukortti( $line ) );

			echo [ '_', '-' ][ mt_rand( 0, 1 ) ];
		}

		file_put_contents( "$OUT/dataentities/keruukortti/$pitäjä/template", '{{Keruumerkintä}}' );

		echo [ 'O', 'o' ][ mt_rand( 0, 1 ) ];
	}

	echo "\n^.^\n";
}

function writeItem( $OUT, $name, $data ) {
	$filename = "$OUT/$name.json";
	if ( !file_exists( dirname( $filename ) ) ) {
		mkdir( dirname( $filename ), 0777, true );
	}

	$jsonOptions = JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES;
	file_put_contents( $filename, json_encode( $data, $jsonOptions ) );
}

/**
 * Convert coordinates from EPSG:3067 to WGS84
 */
function addWSG( $lines ) {
	$epsg = [];

	foreach ( $lines as $line ) {
		$epsg[] = "{$line[18]} {$line[19]}";
	}

	$wsg = convertCoordinates( $epsg );
	for ( $i = 0; $i < count( $lines ); $i++ ) {
		if ( $epsg[$i] !== '-1 -1' ) {
			$lines[$i]['wsg'] = $wsg[$i];
		}
	}

	return $lines;
}

function convertCoordinates( array $list ) {
	$input = implode( "\n", $list );
	file_put_contents( '__input.txt', $input );

	// tarkkuus > 1m
	$command = "sh -c 'cs2cs -f %.9f +proj=utm +zone=35 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs < __input.txt'";
	$output = null;
	exec( $command, $output );
	unlink( '__input.txt' );

	$ret = array_map(
		function ( $line ) {
			// $output = [ "24.8085103565     62.7632414174 0.0000000000"];
			list( $x, $y, $z ) = preg_split( '~\s+~', $line );
			return [ $x, $y ];
		},
		$output
	);

	return $ret;
}


function makeKerääjäName( $x ) {
	$name = "dataentities/keraaja/$x";
	$name = strtr( $name, ' ', '_' );
	return $name;
}

function makePitäjäName( $x ) {
	$name = "dataentities/pitaja/$x";
	$name = strtr( $name, ' ', '_' );
	return $name;
}

function makeKarttakuvaName( $x ) {
	$name = "dataentities/karttakuva/$x";
	$name = strtr( $name, ' ', '_' );
	return $name;
}

function makeKeruukorttiName( $data ) {
	unset( $data['wsg'] );
	$hash = sha1( json_encode( $data ) );
	$name = "dataentities/keruukortti/{$data[8]}/$hash";
	$name = strtr( $name, ' ', '_' );
	return $name;
}

function makeKerääjä( $x ) {
	$data = [
		'labels' => [
			'fi' => $x,
		],
		'descriptions' => [
			'fi' => 'Nimiarkiston kerääjä',
		],
		'statements' => [
			'instanceof' => [ 'value' => 'entities/items/keraaja' ],
		],
	];

	return $data;
}

function makePitäjä( $x ) {
	$data = [
		'labels' => [
			'fi' => $x,
		],
		'statements' => [
			'instanceof' => [ 'value' => 'entities/items/paikka' ],
		],
	];

	return $data;
}


function makeKarttakuva( $x ) {
	$data = [
		'labels' => [
			'fi' => "Karttakuva $x",
		],
		'statements' => [
			'instanceof' => [ 'value' => 'entities/items/keruukartta' ],
		],
	];

	return $data;
}

function makeKeruukortti( $x ) {
	if ( $x[10] === '' ) {
		$keruuhetki = null;
	} else {
		$keruuhetki = [
			'time' => "+{$x[10]}-01-01T00:00:00Z",
			'timezone' => 0,
			'before' => 0,
			'after' => 0,
			'precision' => 9, // year
			'calendarmodel' => 'http://www.wikidata.org/entity/Q1985727',
		];
	}

	$orNull = function ( $x ) {
		return $x === '' ? null : $x;
	};

	$data = [
		'root' => true,
		'labels' => [
			'fi' => "$x[1] ($x[2])",
		],
		'descriptions' => [
			'fi' => "Keruukortti $x[0], $x[8], $x[10]",
		],
		'statements' => [
			'instanceof' => [ 'value' => 'entities/items/keruumerkinta' ],
			'pitaja' => [ 'value' => makePitäjäName( $x[16] ?: $x[8] ) ],
			'keruuhetki' => [ 'value' => $keruuhetki ],
			'keruukortintunnus' => [ 'value' => $x[0] ],
			'keruukortinkuva' => [ 'value' => $x[12] ],
			'keruumerkinta' => [ 'value' => $x[1] ],
			'paikkatyyppi' => [ 'value' => $orNull( $x[2] ) ],
			'karttaruutu-x' => [ 'value' => $orNull( $x[5] ) ],
			'karttaruutu-y' => [ 'value' => $orNull( $x[6] ) ],
			'keruumerkintakartalla' => [ 'value' => $orNull( $x[7] ) ],
		]
	];

	if ( $x[9] ) {
		$data['statements']['keraaja']['value'] = makeKerääjäName( $x[9] );
	}

	if ( (int)$x[17] !== 0 ) {
		$data['statements']['karttakuva']['value'] = makeKarttakuvaName( $x[17] );
	}

	if ( isset( $x['wsg'] ) ) {
		list( $long, $lat ) = $x['wsg'];
		$data['statements']['coordinates']['value'] = [ (float)$lat, (float)$long, 0.000000001 ];
	}

	return $data;
}

