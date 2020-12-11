<?php
declare( strict_types=1 );

namespace MediaWiki\Extensions\Nimiarkisto;

use GuzzleHttp\Client;
use GuzzleHttp\Exception\GuzzleException;
use SpecialPage;

/**
 * @author Niklas Laxström
 * @license GPL-2.0-or-later
 */
class MapProxySpecialPage extends SpecialPage {
	public function __construct() {
		parent::__construct( 'MapProxy' );
	}

	public function execute( $subPage ) {
		$output = $this->getOutput();
		$output->disable();

		$config = $this->getConfig()->get( 'NimiarkistoMapProxy' );
		$key = $config['key'];
		$url = $config['url'];

		foreach ( [ 'layer', 'z', 'y', 'x' ] as $p ) {
			$val = $this->getRequest()->getVal( $p );
			if ( $val === null ) {
				$output->setStatusCode( 404 );
				return;
			}

			$url = str_replace( '{' . $p . '}', $val, $url );
		}

		$copyHeaders = [
			'Date',
			'Expires',
			'Last-Modified',
			'Cache-Control',
			'Content-Type',
		];

		$data = [];
		$data['auth'] = [ $key, '' ];

		$client = new Client();
		$webResponse = $this->getRequest()->response();
		try {
			$proxyResponse = $client->request( 'GET', $url, $data );
			foreach ( $copyHeaders as $headerName ) {
				$proxyHeaderValues = $proxyResponse->getHeader( $headerName );
				foreach ( $proxyHeaderValues as $headerValue ) {
					$webResponse->header( "$headerName: $headerValue" );
				}
			}
			echo $proxyResponse->getBody();
		} catch ( GuzzleException $e ) {
			$output->setStatusCode( 502 );
			$webResponse->header( 'X-Error', $e->getMessage() );
		}
	}

	public function isListed(): bool {
		return false;
	}
}
