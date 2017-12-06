<?php

require 'vendor/autoload.php';
use Symfony\Component\Yaml\Yaml;

$IN = isset( $argv[1] ) ? $argv[1] : 'data';
$OUT = isset( $argv[2] ) ? $argv[2] : '.';

define( 'ID', 0 );
define( 'LOCATIONNAME', 1 );
define( 'LOCATIONTYPE', 2 );
define( 'MAPNUMBER', 3 );
define( 'COLLECTORMAPNUMBER', 4 );
define( 'MAPX', 5 );
define( 'MAPY', 6 );
define( 'MAPREF', 7 );
define( 'PITÄJÄ', 8 );
define( 'COLLECTOR', 9 );
define( 'YEAR', 10 );
define( 'LETTER', 11 );
define( 'IMAGEFILE', 12 );
define( 'CONTINUATION', 13 );
define( 'PEX', 14 );
define( 'OTHERNAMES', 15 );
define( 'REALPITÄJÄ', 16 );
define( 'MAPID', 17 );
define( 'XCOORD', 18 );
define( 'YCOORD', 19 );
define( 'KOTUS', 20 );
define( 'IMAGEINFO', 21 );

process( $IN, $OUT );

class NimiarkistoConverter {
	public function getFiles( $IN ) {
		$files = [];
		$iter = new DirectoryIterator( $IN );
		foreach ( $iter as $entry ) {
			if ( !$entry->isFile() || $entry->getExtension() !== 'csv' ) {
				continue;
			}

			$files[] = "$IN/{$entry->getFilename()}";
		}
		return $files;
	}

	public function parseCSV( $filename ) {
		$data = file( $filename );

		$section = [];
		foreach ( $data as $index => $rawline ) {
			$line = str_getcsv( $rawline );
			if ( $index !== 0 && $line[ ID ] === 'ID' ) {
				yield $section;
				$section = [];
			}

			if ( count( $line ) < 16 ) {
				var_dump( "Skipping unparseable line:", json_encode( $line ) );
			} else {
				$section[] = $line;
			}
			unset( $data[ $index ] );
		}
	}

	public function preprocessSection( array $lines ) {
		// Fix types
		foreach ( $lines as $index => $line ) {
			$lines[ $index ][ ID ] = (int)$line[ ID ];
			foreach ( $line as $column => $value ) {
				if ( $value === '' ) {
					$lines[ $index ][ $column ] = null;
				}
			}
		}


		// Merge backsides to the main rows
		$lines = mergeBacksides( $lines );
		// Merge additional nimilippu to the main rows
		$lines = mergeContinuations( $lines );
		// Re-number indexes
		$lines = array_values( $lines );
		// Add coordinateshttps://github.com/CSCfi/Kielipankki-palvelut/pulls
		$lines = addWSG( $lines );

		return $lines;
	}

	private $entityMap = [];
	private $freeId = 1000000;
	public function getEntityId( $ref = null ) {
		if ( $ref !== null && isset( $this->entityMap[ $ref ] ) ) {
			return $this->entityMap[ $ref ];
		} else {
			$id = "Q{$this->freeId}";
			if ( $ref !== null ) {
				$this->entityMap[ $ref ] = $id;
			}

			$this->freeId++;
			return $id;
		}
	}

	public function createPitäjäEntity( $name ) {
		$data = [
			'labels' => [
				'fi' => $name,
			],
			'statements' => [
				'P31' => [ 'Q6' ],
				'P460' => [ 'Q2' ],
			],
		];

		return $data;
	}

	public function createKerääjäEntity( $name ) {
		$data = [
			'labels' => [
				'fi' => $name,
			],
			'statements' => [
				'P31' => [ 'Q8' ],
			],
		];

		return $data;
	}

	public function createNimilippuEntity( $name, $extId ) {
		$data = [
			'labels' => [
				'fi' => $name,
			],
			'statements' => [
				'P31' => [ 'Q7' ],
				'P10020' => [ $extId ],
				'P10041' => [ 'Q26' ], // unpublished
			],
		];

		return $data;
	}

	public function createMapEntity( $name, $line ) {
		$data = [
			'labels' => [
				'fi' => $name,
			],
			'statements' => [
				'P31' => [ 'Q3' ],
				'P10045' => [ $line[ MAPNUMBER ] ],
				'P10018' => [ $line[ COLLECTORMAPNUMBER ] ],
			],
		];

		foreach ( $data[ 'statements' ] as $index => $value ) {
			if ( $value === [ null ] ) {
				unset( $data[ 'statements' ][ $index ] );
			}
		}

		return $data;
	}

	public function createMerkintäEntity( $x, $merkintäId, $pitäjäId, $kerääjäId, $nimilippuIds, $mapId ) {
		$label = $x[ LOCATIONNAME ];
		if ( isset( $x[ LOCATIONTYPE ] ) ) {
			$label .= " ({$x[ LOCATIONTYPE ]})";
		}
		$description = "Keruukortti {$x[ ID ]}, {$x[ PITÄJÄ ]}, {$x[ YEAR ]}";

		$data = [
			'labels' => [
				'fi' => $label,
			],
			'descriptions' => [
				'fi' => $description
			],
			'statements' => [
				'P31' => [ 'Q5' ],
				'P10015' => [ $x[ LOCATIONNAME ] ],
				'P10016' => [ $x[ LOCATIONTYPE ] ],
				'P10007' => [ $x[ MAPX ] ],
				'P10008' => [ $x[ MAPY ] ],
				'P10034' => [ $x[ MAPREF ] ],
				'P10013' => [ $pitäjäId ],
				'P10017' => [ $kerääjäId ],
				'P10009' => [ [
					'time' => "+{$x[ YEAR ]}-01-01T00:00:00Z",
					'timezone' => 0,
					'before' => 0,
					'after' => 0,
					'precision' => 9, // year
					'calendarmodel' => 'http://www.wikidata.org/entity/Q1985727',
				] ],
				'P10032' => [ 'Q14' ],
				'P10029' => $nimilippuIds,
				'P10045' => [ $x[ MAPID ] ],
				'P10047' => [ $x[ KOTUS ] ],
				'P10011' => [ $mapId ],
			],
			'creates' => [
				$merkintäId => '{{Keruumerkintä}}',
			],
		];

		if ( $x[ XCOORD ] != -1 && $x[ MAPREF ] !== null && $x[ MAPY ] !== null && $x[ MAPX ] !== null ) {
			$data[ 'statements' ][ 'P10032' ] = [ 'Q14' ];
		} elseif ( $x[ MAPREF ] === null && $x[ MAPY ] !== null && $x[ MAPX ] !== null ) {
			$data[ 'statements' ][ 'P10032' ] = [ 'Q15' ];
		} // TODO: Q16?


		if ( $x[ PEX ] === 'L' ) {
			$data[ 'statements'][ 'P10032' ] = [ 'Q17' ];
		} elseif ( $x[ PEX ] === 'N' ) {
			$data[ 'statements'][ 'P10032' ] = [ 'Q18' ];
		}

		if ( isset( $x['wsg'] ) ) {
			list( $long, $lat ) = $x['wsg'];
			$data[ 'statements' ][ 'P10012' ] = [ [ (float)$lat, (float)$long, 0.000000001 ] ];
		}

		if ( $x[ YEAR ] === null ) {
			unset( $data[ 'statements' ][ 'P10009' ] );
		}

		foreach ( $data[ 'statements' ] as $index => $value ) {
			if ( $value === [ null ] ) {
				unset( $data[ 'statements' ][ $index ] );
			}
		}

		return $data;
	}
}

function process( $IN, $OUT ) {
	// Data is split into "pitäjä", but some entities that surface from the data, like "kerääjä"
	// are shared across all "pitäjä".
	$globalEntities = $localEntities = [];

	$converter = new NimiarkistoConverter();
	$files = $converter->getFiles( $IN );
	foreach ( $files as $file ) {
		foreach ( $converter->parseCSV( $file ) as $section ) {
			$localEntities = [];
			$batch = 0;

			$header = array_shift( $section );
			$lines = $converter->preprocessSection( $section );
			$sectionId = trim( $header[ IMAGEINFO ] );

			foreach ( $lines as $line ) {
				$pitäjäName = $line[ REALPITÄJÄ ] ?: $line[ PITÄJÄ ];
				if ( $pitäjäName === null ) {
					echo "Did not find pitäjä for: {$line[ ID ]} {$line[ IMAGEINFO ]}\n";
					continue;
				}

				$pitäjäId = $converter->getEntityId( "pitäjä/$pitäjäName" );
				$globalEntities[ 'pitäjä' ][ $pitäjäId ] =
					$globalEntities[ 'pitäjä' ][ $pitäjäId ] ??
					$converter->createPitäjäEntity( $pitäjäName );


				if ( (int)$pitäjäName > 0 || $pitäjäName === 'X' ) {
					echo "Skipping invalid pitäjä {$line[ ID ]} {$line[ IMAGEINFO ]}\n";
					continue;
				}

				$kerääjäName = $line[ COLLECTOR ] ?? false;
				$kerääjäId = null;
				if ( $kerääjäName ) {
					$kerääjäId = $converter->getEntityId( "kerääjä/$kerääjäName" );
					$globalEntities[ 'kerääjä' ][ $kerääjäId ] =
						$globalEntities[ 'kerääjä' ][ $kerääjäId ] ??
						$converter->createKerääjäEntity( $kerääjäName );
				}

				$nimilippuIds = [];
				foreach ( (array)$line[ IMAGEFILE ] as $file ) {
					$nimilippuId = $converter->getEntityId( null );
					$localEntities[ $nimilippuId ] = $converter->createNimilippuEntity( $file, $sectionId );
					$nimilippuIds[] = $nimilippuId;
				}

				$mapName = $line[ MAPID ] ?? false;
				$mapId = null;
				if ( $mapName ) {
					$mapId = $converter->getEntityId( "mapid/$mapName" );
					$globalEntities[ 'maps' ][ $mapId ] =
						$globalEntities[ 'maps' ][ $mapId ] ??
						$converter->createMapEntity( $mapName, $line );
				}

				$merkintäId = $converter->getEntityId( null );
				$localEntities[ $merkintäId ] = $converter->createMerkintäEntity(
					$line,
					$merkintäId,
					$pitäjäId,
					$kerääjäId,
					$nimilippuIds,
					$mapId
				);

				if ( count( $localEntities ) > 1000 ) {
					echo "$OUT/$sectionId-$batch.yaml\n";
					file_put_contents( "$OUT/$sectionId-$batch.yaml", Yaml::dump( $localEntities ) );
					$batch++;
					$localEntities = [];
				}
			}

			echo "$OUT/$sectionId-$batch.yaml\n";
			file_put_contents( "$OUT/$sectionId-$batch.yaml", Yaml::dump( $localEntities ) );
		}
	}

	foreach ( $globalEntities as $type => $entities ) {
		file_put_contents( "$OUT/$type.yaml", Yaml::dump( $entities ) );
	}
}

function mergeBacksides( $lines ) {
	foreach ( $lines as $index => $backside ) {
		if ( !isBackside( $backside ) ) {
			continue;
		}

		for ( $i = $index - 1; $i > -1; $i-- ) {
			if ( !isset( $lines[ $i ] ) ) {
				continue;
			}

			$frontside = $lines[ $i ];

			if ( backsideMatchesFrontside( $backside, $frontside ) ) {
				$lines[ $i ] = mergeImage( $frontside, $backside );
				unset( $lines[ $index ] );
				continue 2;
			}
		}

		unset( $lines[ $index ] );
		echo "Did not find frontside for this backside: {$backside[ ID ]} {$backside[ IMAGEINFO ]}\n";
	}

	return $lines;
}

/**
 * Whether this row represents a scan of the backside of nimilippu.
 * @return bool
 */
function isBackside( $x ) {
	return preg_match( '/_B.jpg$/', $x[ IMAGEFILE ] ) === 1;
}

function backsideMatchesFrontside( $back, $front ) {
	$ok = true;
	$ok = $ok && $back[ ID ] === $front[ ID ] + 1;
	$ok = $ok && $back[ PITÄJÄ ] === $front[ PITÄJÄ ];
	$ok = $ok && ( $back[ LETTER ] === null || $back[ LETTER ] === $front[ LETTER ] );
	return $ok;
}

function mergeImage( array $front, array $back ) {
	$front[ IMAGEFILE ] = (array)$front[ IMAGEFILE ];
	$front[ IMAGEFILE ][] = $back[ IMAGEFILE ];

	return $front;
}

function mergeContinuations( $lines ) {
	foreach ( $lines as $index => $line ) {
		if ( $line[ CONTINUATION ] === null ) {
			continue;
		}

		if ( !$line[ CONTINUATION ] === 'J' ) {
			var_dump( 'Unknown continuation value', json_encode( $line ) );
			exit( 1 );
		}

		$shouldBeEmpty = [ MAPNUMBER, COLLECTORMAPNUMBER, MAPX, MAPY, MAPREF ];
		foreach ( $shouldBeEmpty as $type ) {
			if ( $line[ $type ] !== null ) {
				#var_dump( "Unexpected value $type in continuation", implode( ', ', $line  ) );
				//exit( 1 );
			}
		}

		for ( $i = $index - 1; $i > -1; $i-- ) {
			if ( !isset( $lines[ $i ] ) ) {
				continue;
			}

			$other = $lines[ $i ];

			if ( matchContinuation( $line, $other ) ) {
				$lines[ $i ] = mergeImage( $other, $line );
				unset( $lines[ $index ] );
				continue 2;
			}
		}

		unset( $lines[ $index ] );
		echo "Did not find main entry for continuation: {$line[ ID ]} {$line[ IMAGEINFO ]}\n";
	}

	return $lines;
}

function matchContinuation( $cont, $other ) {
	$ok = true;
	// Do not search arbitrarily far
	// There can be multiple continuations.
	$ok = $ok && $cont[ ID ] < $other[ ID ] + 10;
	$ok = $ok && $cont[ LOCATIONNAME ] === $other[ LOCATIONNAME ];
	// Sanity check
	$ok = $ok && ( $cont[ LOCATIONTYPE ] === null || $cont[ LOCATIONTYPE ] === $other[ LOCATIONTYPE ] );
	$ok = $ok && $cont[ PITÄJÄ ] === $other[ PITÄJÄ ];
	$ok = $ok && $cont[ COLLECTOR ] === $other[ COLLECTOR ];
	$ok = $ok && $cont[ YEAR ] === $other[ YEAR ];
	$ok = $ok && $cont[ LETTER ] === $other[ LETTER ];

	return $ok;
}

/**
 * Convert coordinates from EPSG:3067 to WGS84
 */
function addWSG( $lines ) {
	$epsg = [];

	foreach ( $lines as $line ) {
		if ( !isset( $line[ 18 ] ) ) {
			var_dump( $line ); die();
		}

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

