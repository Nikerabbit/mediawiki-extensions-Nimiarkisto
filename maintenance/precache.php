<?php

namespace MediaWiki\Extension\Nimiarkisto;

use MediaWiki\Extensions\Nimiarkisto\SMWPropertyValueLookup;

$env = getenv( 'MW_INSTALL_PATH' );
$IP = $env !== false ? $env : __DIR__ . '/../../..';
require_once "$IP/maintenance/Maintenance.php";

class Precache extends Maintenance {
	public function __construct() {
		parent::__construct();
		$this->addDescription( 'Caches property lookup values' );

		$this->addOption(
			'properties',
			'Comma-separated list of property names',
			true, /*required*/ true /*has arg*/
		);
	}

	public function execute() {
		$names = array_map( 'trim', explode( ',', $this->getOption( 'properties' ) ) );
		$lookup = new SMWPropertyValueLookup();
		foreach ( $names as $name ) {
			$lookup->searchProperties( $name, '!' );
		}
	}
}

$maintClass = Precache::class;
require_once RUN_MAINTENANCE_IF_MAIN;
