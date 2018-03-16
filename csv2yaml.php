<?php

require 'Parish.php';
require 'vendor/autoload.php';
use Symfony\Component\Yaml\Yaml;

$IN = isset( $argv[1] ) ? $argv[1] : 'data';
$OUT = isset( $argv[2] ) ? $argv[2] : 'out' . date( 'c' );

define( 'ID', 0 ); // ID
define( 'LOCATIONNAME', 1 ); // Paikannimi
define( 'LOCATIONTYPE', 2 ); // Paikan laji
define( 'MAPNUMBER', 3 ); // Kartan numero
define( 'COLLECTORMAPNUMBER', 4 ); // Kerääjän kartta-numero
define( 'MAPX', 5 ); // X
define( 'MAPY', 6 ); // Y
define( 'MAPREF', 7 ); // Pistesij. viite
define( 'PITÄJÄ', 8 ); // Pitäjä
define( 'COLLECTOR', 9 ); // Kerääjä
define( 'YEAR', 10 ); // Vuosi
define( 'LETTER', 11 ); // Aakkonen
define( 'IMAGEFILE', 12 ); // Kuvatiedosto
define( 'CONTINUATION', 13 ); // Jatko
define( 'PEX', 14 ); // PEX
define( 'OTHERNAMES', 15 ); // Muut nimet
define( 'REALPITÄJÄ', 16 ); // Todellinen pitäjä
define( 'MAPID', 17 ); // Kartta ID
define( 'XCOORD', 18 ); // X_euref
define( 'YCOORD', 19 ); // Y_euref
define( 'KOTUS', 20 ); // HuomioKotus
define( 'COLLECTION', 21 ); // Kokoelma
define( 'IMAGEINFO', 22 ); // Kuvalinkki
define( 'RECSER', 23 ); // RecSer
define( 'PARENT', 24 ); // Emolippu

mkdir( $OUT );
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
			if ( $index !== 0 && $line[ ID ] === '1' ) {
				yield $section;
				$section = [];
			}

			if ( count( $line ) < 16 ) {
				echo "Skipping unparseable line: $rawline\n";
			} else {
				$section[] = $line;
			}
			unset( $data[ $index ] );
		}

		yield $section;
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

			// Manual correction to known issue with the data
			if ( (int)$lines[ $index ][ REALPITÄJÄ ] > 0 ) {
				$lines[ $index ][ MAPID ] = $lines[ $index ][ REALPITÄJÄ ];
				$lines[ $index ][ REALPITÄJÄ ] = null;
			}

			// Ditto
			if ( $lines[ $index ][ XCOORD ] === null ) {
				$lines[ $index ][ XCOORD ] = $lines[ $index ][ YCOORD ] = -1;
			}

			// Dittoo
			if ( $lines[ $index ][ PEX ] === '<' ) {
				$lines[ $index ][ PEX ] = null;
			}

			if ( $lines[ $index ][ REALPITÄJÄ ] === 'X' ) {
				 $lines[ $index ][ REALPITÄJÄ ] = null;
			}

			if ( $lines[ $index ][ RECSER ] === '2014078' && $lines[ $index ][ PITÄJÄ ] === null ) {
				$lines[ $index ][ PITÄJÄ ] = 'Vörå';
			}

			// Dittooo
			$imageFixes = [
				'80678'   => [ 'I00000174_F.jpg', '00000174_F.jpg' ],
				'573568'  => [ 't00000103_F.jpg', '00000103_F.jpg' ],
				'694220'  => [ 'I00000060_F.jpg', '00000060_F.jpg' ],
				'847074'  => [ 'J00000002_F.jpg', '00000002_F.jpg' ],
				'847215'  => [ 'H00000143_F.jpg', '00000143_F.jpg' ],
				'847301'  => [ 'B00000229_F.jpg', '00000229_F.jpg' ],
				'1000037' => [ 'E00000756_F.jpg', '00000756_F.jpg' ],
				'1061596' => [ 'Iv00000847_F.jpg', '00000847_F.jpg' ],
				'1851507' => [ 'I00000059_F.jpg', '00000059_F.jpg' ],
				'2018254' => [ '00000047_F.jp', '00000047_F.jpg' ],
				'2045108' => [ '0000000247.jpg', '00000247_F.jpg' ],
				'2086858' => [ '00000069_F.jpgN', '00000069_F.jpg' ],
				'2094653' => [ '00000060_F.jpg+M1045', '00000060_F.jpg' ],
				'2104780' => [ '00000199_F.Jpg', '00000199_F.jpg' ],
				'2207306' => [ 'SOMERNIEMI_A_r', 'SOMERNIEMI_A_00000001_F.jpg' ],
			];

			$recser = $lines[ $index ][ RECSER ];
			if ( isset( $imageFixes[ $recser ] ) ) {
				list( $from, $to ) = $imageFixes[ $recser ];
				$lines[ $index ][ IMAGEFILE ] = str_replace( $from, $to, $lines[ $index ][ IMAGEFILE ] );
				$lines[ $index ][ IMAGEINFO ] = str_replace( $from, $to, $lines[ $index ][ IMAGEINFO ] );
			}
		}

		// Merge backsides to the main rows
		$lines = mergeBacksides( $lines );
		// Merge additional nimilippu to the main rows
		$lines = mergeContinuations( $lines );
		// Re-number indexes
		$lines = array_values( $lines );
		// Add coordinates
		$lines = addWSG( $lines );


		return $lines;
	}

	private $entityMap = [];
	private $freeId = 5000000;
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
			'descriptions' => [
				'fi' => 'pitäjänkokoelma',
				'en' => 'parish collection',
				'sv' => 'sockensamling',
			],
			'statements' => [
				'P31' => [ 'Q6' ],
				'P460' => [ 'Q2' ],
			],
		];

		return $data;
	}

	public function createKerääjäEntity( $name ) {
		// TODO label Susannan tiedostosta
		// https://drive.google.com/file/d/1OfmA2hdF1xLQFtT0N_UJOyVs3bSeC_QD/view
		// etunimi ja sukunimi jos on (P10054 + P10055)
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

	public function createNimilippuEntity( $extId, $placename, $recser ) {
		$data = [
			'labels' => [
				'fi' => "$placename $recser",
			],
			'statements' => [
				'P31' => [ 'Q7' ],
				'P10030' => [ (string)$recser ],
				'P10020' => [ $extId ],
				// ei oletusarvoa enää? oletuksena julkinen
				//'P10041' => [ 'Q26' ], // unpublished
			],
		];

		return $data;
	}

	public function createMapEntity( $name, $line ) {
		// TODO: Handle + and , (low prio) in MAPNUMBER (MML)
		// TODO SLS MAPNUMBER => COLLECTORMAPNUMBER

		$data = [
			'labels' => [
				'fi' => $name,
			],
			'statements' => [
				'P31' => [ 'Q3' ],
				'P10045' => [ $line[ MAPNUMBER ] ],
				'P10049' => [ $name ],
				'P10018' => [ $line[ COLLECTORMAPNUMBER ] ],
				'P10037' => [ 'Q24' ], // TODO only if MAPNUMBER
			],
		];

		if ( $line[ COLLECTION ] === 'SLS' ) {
			$data[ 'statements' ][ 'P10018' ] = $line[ MAPNUMBER ];
			unset( $data[ 'statements' ][ 'P10045' ] );
		}

		foreach ( $data[ 'statements' ] as $index => $value ) {
			if ( $value === [ null ] ) {
				unset( $data[ 'statements' ][ $index ] );
			}
		}

		return $data;
	}

	public function createMerkintäEntity(
		array $x,
		$merkintäId,
		$pitäjäId,
		$kerääjäId,
		array $nimilippuIds,
		$mapId
	) {
/*
TODO label:  Jokienhaara-aho (alue, jolla niittyjä) – Kotus, 1972

TODO uniquecheck

TODO wikibase-linkki
*/

		$label = $x[ LOCATIONNAME ];
		if ( isset( $x[ LOCATIONTYPE ] ) ) {
			// TODO Kirjaimet -> aukikirjoitettu
			$label .= " ({$x[ LOCATIONTYPE ]})";
		}

		if ( isset( $x[ YEAR ] ) ) {
			$label .= " – Kotus, {$x[ YEAR ]}";
		} else {
			$label .= " – Kotus";
		}

		$data = [
			'labels' => [
				'fi' => $label,
			],
			'descriptions' => [
				'fi' => "Keruumerkintä {$x[ RECSER ]}",
				'sv' => "Fältanteckning {$x[ RECSER ]}",
				'en' => "Field note {$x[ RECSER ]}",
			],
			'statements' => [
				'P31' => [ 'Q4' ],
				'P10053' => [ $x[ RECSER ] ],
				'P10015' => [ $x[ LOCATIONNAME ] ],
				'P10007' => [ $x[ MAPX ] ],
				'P10008' => [ $x[ MAPY ] ],
				'P10034' => [ $x[ MAPREF ] ],
				'P10013' => [ $pitäjäId ],
				'P10017' => [ $kerääjäId ],
				'P10029' => $nimilippuIds,
				'P10011' => [ $mapId ],
			],
			'creates' => [
				$merkintäId => '{{Keruumerkintä}}',
			],
		];

		if ( $x[ LOCATIONTYPE ] === 'H' ) {
			// henkilönnimi
			$data[ 'statements' ][ 'P10025' ] = [ 'Q11' ];
		} elseif ( $x[ LOCATIONTYPE ] === 'A' ) {
			// yleisnimi
			$data[ 'statements' ][ 'P10025' ] = [ 'Q12' ];
		} elseif ( $x[ LOCATIONTYPE ] === 'M' ) {
			// virheellinen karttanimi
			$data[ 'statements' ][ 'P10025' ] = [ 'Q32' ];
		} else {
			// paikannimi
			$data[ 'statements' ][ 'P10016' ] = [ $x[ LOCATIONTYPE ] ];
			$data[ 'statements' ][ 'P10025' ] = [ 'Q10' ];
		}

		// TODO label

		switch ( $x[ PEX ] ) {
			case 'K':
			case 'I':
			case 'P':
			case 'X':
			case 'S':
			case 'T':
				$data[ 'statements' ][ 'P10052' ][] = "PEX: {$x[ PEX ]}";
				break;
			case 'L':
				$data[ 'statements' ][ 'P10032' ] = [ 'Q17' ];
				break;
			case 'N':
				$data[ 'statements' ][ 'P10032' ] = [ 'Q18' ];
				break;
			case 'E':
				$data[ 'statements' ][ 'P10047' ][] = 'Q37';
				break;
			case 'V':
				$data[ 'statements' ][ 'P10047' ][] = 'Q31';
				break;
			case 'Vl':
			case 'V,L':
			case 'L,V':
				$data[ 'statements' ][ 'P10032' ] = [ 'Q17' ];
				$data[ 'statements' ][ 'P10047' ][] = 'Q31';
				break;
			case 'V,N':
				$data[ 'statements' ][ 'P10032' ] = [ 'Q18' ];
				$data[ 'statements' ][ 'P10047' ][] = 'Q31';
				break;
			case 'V,N':
				$data[ 'statements' ][ 'P10032' ] = [ 'Q18' ];
				$data[ 'statements' ][ 'P10047' ][] = 'Q31';
				break;
			case 'L,N':
				$data[ 'statements' ][ 'P10032' ] = [ 'Q17', 'Q18' ];
				break;
			case 'K,N':
			case 'K, N':
			case 'N,K':
				$data[ 'statements' ][ 'P10032' ] = [ 'Q18' ];
				$data[ 'statements' ][ 'P10052' ][] = 'PEX: K';
				break;
			case 'V?':
				$data[ 'statements' ][ 'P10047' ][] = 'Q31';
				$data[ 'statements' ][ 'P10052' ][] = 'PEX: V?';
				break;
			case 'K,V':
				$data[ 'statements' ][ 'P10047' ][] = 'Q31';
				$data[ 'statements' ][ 'P10052' ][] = 'PEX: K';
				break;
			case 'V,I':
				$data[ 'statements' ][ 'P10047' ][] = 'Q31';
				$data[ 'statements' ][ 'P10052' ][] = 'PEX: I';
				break;
			case 'N,V':
				$data[ 'statements' ][ 'P10032' ] = [ 'Q18' ];
				$data[ 'statements' ][ 'P10047' ][] = 'Q31';
				break;
			case null:
				break;
			default:
				var_dump( $x );
				throw new InvalidArgumentException( $x[ PEX ] );
		}

		if ( $x[ OTHERNAMES ] ) {
			$data[ 'statements' ][ 'P10047' ][] = 'Q36';
		}

		if ( isset( $x[ 'ParishID' ] ) ) {
			$data[ 'statements' ][ 'P10056' ] = [ $x[ 'ParishID' ] ];
		}

		if ( isset( $x['wsg'] ) ) {
			list( $long, $lat ) = $x['wsg'];
			$data[ 'statements' ][ 'P10012' ] = [ [ (float)$lat, (float)$long, 0.000000001 ] ];
			$data[ 'statements' ][ 'P10050' ] = [ $x[ XCOORD ] ];
			$data[ 'statements' ][ 'P10051' ] = [ $x[ YCOORD ] ];
		}

		$isMulti = function ( $x ) {
			return $x !== null && preg_match( '/[,-]/', $x ) === 1;
		};

		if ( isset( $x['wsg'] ) && $x[ MAPREF ] !== null && $x[ MAPY ] !== null && $x[ MAPX ] !== null ) {
			$data[ 'statements' ][ 'P10032' ] = [ 'Q14' ];
		} elseif ( $x[ MAPREF ] === null && ( $isMulti( $x[ MAPY ] ) || $isMulti( $x[ MAPX ] ) ) ) {
			$data[ 'statements' ][ 'P10032' ] = [ 'Q16' ];
		} elseif ( $x[ MAPREF ] === null && $x[ MAPY ] !== null && $x[ MAPX ] !== null ) {
			$data[ 'statements' ][ 'P10032' ] = [ 'Q15' ];
		} else {
			$data[ 'statements' ][ 'P10032' ] = [ 'Q42' ];
		}

		if ( $x[ KOTUS ] ) {
			$data[ 'statements' ][ 'P10052' ][] = "HuomioKotus: {$x[ KOTUS ]}";
		}

		if ( $x[ COLLECTION ] === 'SLS' ) {
			$data[ 'statements' ][ 'P10037' ] = [ 'Q33' ];
			$data[ 'statements' ][ 'P10014' ] = [ 'Q41' ];

			// Inventaarionumero
			$data[ 'statements' ][ 'P217'   ] = [ $x[ LETTER ] ];
			if ( $x[ CONTINUATION ] ) {
				$data[ 'statements' ][ 'P10052' ][] = "Kommentar: {$x[ CONTINUATION ]}";
			}

		} elseif ( $x[ COLLECTION ] === 'KotusNA1' ) {
			$data[ 'statements' ][ 'P10037' ] = [ 'Q23' ];
			$data[ 'statements' ][ 'P10014' ] = [ 'Q34' ];
		} elseif ( $x[ COLLECTION ] === 'KotusNA2' ) {
			$data[ 'statements' ][ 'P10037' ] = [ 'Q23' ];
			$data[ 'statements' ][ 'P10014' ] = [ 'Q43' ];
		} else {
			throw new InvalidArgumentException( $x[ COLLECTION ] );
		}

		if ( $x[ YEAR ] !== null ) {
			$year = $x[ YEAR ];
			$after = 0;
			if ( preg_match( '/(\d{4})-\d{2}/', $x[ YEAR ], $match ) ) {
				$year = $match[ 1 ];
				$after = 1;
			}

			$data[ 'statements' ][ 'P10009' ] = [ [
				'time' => "+$year-00-00T00:00:00Z",
				'timezone' => 0,
				'before' => 0,
				'after' => $after,
				'precision' => 9, // year
				'calendarmodel' => 'http://www.wikidata.org/entity/Q1985727',
			] ];
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

			$lines = $converter->preprocessSection( $section );
			$sectionId = 'XX_' . trim( $lines[ 0 ][ PITÄJÄ ] ?? 'XXXX' );

			while ( file_exists( "$OUT/$sectionId-$batch.yaml" ) ) {
				$batch += 10;
			}

			foreach ( $lines as $line ) {
				$pitäjäName = $line[ PITÄJÄ ];
				if ( $pitäjäName === null ) {
					echo "Did not find pitäjä for {$line[ RECSER ]}\n";
					#var_dump( $line );
					continue;
				}

				$pitäjäId = $converter->getEntityId( "pitäjä/$pitäjäName" );
				$globalEntities[ 'pitäjä' ][ $pitäjäId ] =
					$globalEntities[ 'pitäjä' ][ $pitäjäId ] ??
					$converter->createPitäjäEntity( $pitäjäName );

				if ( $line[ REALPITÄJÄ ] ) {
					if ( !isset( Parish::$map[ $line[ REALPITÄJÄ ] ] ) ) {
						echo "Funky realpitäjä\n";
						var_dump( $line );
					}
					$realRealPitäjäName = Parish::$map[ $line[ REALPITÄJÄ ] ];
					$realPitäjäId = $converter->getEntityId( "pitäjä/$realRealPitäjäName" );
					$globalEntities[ 'pitäjä' ][ $realPitäjäId ] =
						$globalEntities[ 'pitäjä' ][ $realPitäjäId ] ??
						$converter->createPitäjäEntity( $realRealPitäjäName );
					$line[ 'ParishID' ] = $realPitäjäId;
				}

				if ( (int)$pitäjäName > 0 || $pitäjäName === 'X' ) {
					echo "Skipping invalid pitäjä {$line[ RECSER ]}\n";
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
				if ( !is_array( $line[ IMAGEINFO ] ) ) {
					$line[ IMAGEINFO ] = [ $line[ RECSER ] => $line[ IMAGEINFO ] ];
				}

				foreach ( $line[ IMAGEINFO ] as $recser => $path ) {
					// kotus
					// ./0001_AHLAINEN/JPG/AHLAINEN/A/kotus-201214_0001_AHLAINEN_00000001_F.jpg
					// \\tiedostot.ds.kotus.fi\digiwork2\nadigi\GRANON LOPULLISET DIGITOINNIT\
					// 0001_AHLAINEN\JPG\Ahlainen\A\kotus-201214_0001_AHLAINEN_00000001_F.jpg
					// SLS
					// \\tiedostot.ds.kotus.fi\digiarkisto3\SLS namn\
					// 971_JPG\Malax\J.Ahlbäck\kotus-201214_SLS971_Malax_J.Ahlbäck_002_1425_001.jpg

					$path = str_replace( '\\', '/', $path );

					if ( $line[ COLLECTION ] === 'KotusNA1' || $line[ COLLECTION ] === 'KotusNA2' ) {
						// RAUMA I/J is really weird
						$ok = preg_match( '~([^/]+/[^/]+/[^/]+/[^/]+/[^/]+_[0-9]+(?:_[BFJ]|F_)\.jpg)$~', $path, $matches );

						// TODO: Taivalkoski has some _ moved next to the dot.
						if ( !$ok ) {
							#echo "Skipping invalid imagepath for {$line[ RECSER ]}: $path\n";
							continue;
						}

						$locator = str_replace( '\\', '/', $matches[1] );
					} elseif ( $line[ COLLECTION ] === 'SLS' ) {
						$locator = str_replace( '//tiedostot.ds.kotus.fi/digiarkisto3/SLS namn/', '', $path );
					} else {
						echo "Unknown collection {$line[ COLLECTION ]}\n";
						exit;
					}

					$nimilippuId = $converter->getEntityId( null );
					$localEntities[ $nimilippuId ] = $converter->createNimilippuEntity(
						$locator,
						$line[ LOCATIONNAME ],
						$recser
					);
					$nimilippuIds[] = $nimilippuId;
				}

				// TODO SLS mapid (!=0) + puolipiste
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
					#echo "$OUT/$sectionId-$batch.yaml\n";
					file_put_contents( "$OUT/$sectionId-$batch.yaml", Yaml::dump( $localEntities ) );
					$batch++;
					$localEntities = [];
				}
			}

			#echo "$OUT/$sectionId-$batch.yaml\n";
			file_put_contents( "$OUT/$sectionId-$batch.yaml", Yaml::dump( $localEntities ) );
		}
	}

	foreach ( $globalEntities as $type => $entities ) {
		$chunks = array_chunk( $entities, 1000, true );
		foreach ( $chunks as $chunkIndex => $chunkEntities ) {
			file_put_contents( "$OUT/AA_$type-$chunkIndex.yaml", Yaml::dump( $chunkEntities ) );
		}
	}
}

function mergeBacksides( $lines ) {
	foreach ( $lines as $index => $backside ) {
		if ( isset( $backside[ 'parent' ] ) || !isBackside( $backside ) ) {
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

		#unset( $lines[ $index ] );
		#echo "Did not find frontside for this backside: {$backside[ RECSER ]} {$backside[ IMAGEINFO ]} – treating as main entry\n";
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
	if ( $back[ PARENT ] ) {
		return $back[ PARENT ] === $front[ RECSER ];
	}

	$ok = true;
	$ok = $ok && $back[ ID ] === $front[ ID ] + 1;
	$ok = $ok && $back[ PITÄJÄ ] === $front[ PITÄJÄ ];
	$ok = $ok && ( $back[ LETTER ] === null || $back[ LETTER ] === $front[ LETTER ] );
	return $ok;
}

function mergeImage( array $front, array $back ) {
	if ( !is_array( $front[ IMAGEINFO ] ) ) {
		$front[ IMAGEINFO ] = [ $front[ RECSER ] => $front[ IMAGEINFO ] ];
	}

	if ( !is_array( $back[ IMAGEINFO ] ) ) {
		$front[ IMAGEINFO ][ $back[ RECSER ] ] = $back[ IMAGEINFO ];
	} else {
		foreach ( $back[ IMAGEINFO ] as $recser => $info ) {
			$front[ IMAGEINFO ][ $recser ] = $info;
		}
	}

	return $front;
}

function mergeContinuations( $lines ) {
	foreach ( $lines as $index => $line ) {
		if ( $line[ CONTINUATION ] === null ) {
			continue;
		}

		if ( !$line[ CONTINUATION ] === 'J' ) {
			echo "Unknown continuation value in {$line[ RECSER ]}\n";
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

		#echo "Did not find main entry for continuation: {$line[ RECSER ]} {$line[ IMAGEINFO ]} – treating as a main entry\n";
	}

	return $lines;
}

function matchContinuation( $cont, $other ) {
	if ( $cont[ PARENT ] ) {
		return $cont[ PARENT ] === $other[ RECSER ];
	}

	$ok = true;
	// Do not search arbitrarily far
	// There can be multiple continuations.
	$ok = $ok && $cont[ ID ] < $other[ ID ] + 20;
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
		$epsg[] = "{$line[ XCOORD ]} {$line[ YCOORD ]}";
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
