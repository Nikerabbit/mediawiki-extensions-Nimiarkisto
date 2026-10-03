<?php
declare( strict_types = 1 );

namespace MediaWiki\Extensions\Nimiarkisto;

use MediaWiki\MediaWikiServices;
use SMW\DataItems\Blob;
use SMW\DataItems\Property;
use SMW\DataItems\WikiPage;
use SMW\Store;
use Wikimedia\LightweightObjectStore\ExpirationAwareness;
use Wikimedia\ObjectCache\WANObjectCache;

/**
 * @author Niklas Laxström
 * @license GPL-2.0-or-later
 */
class SMWPropertyValueLookup {
	private readonly WANObjectCache $cache;
	private readonly Store $store;

	public function __construct() {
		$services = MediaWikiServices::getInstance();
		$this->cache = $services->getMainWANObjectCache();
		$this->store = $services->getService( 'SMW.Store' );
	}

	public function recache( string $propertyName ): void {
		$haystack = $this->getPropertyValues( $propertyName );
		$key = $this->cache->makeKey( 'Nimiarkisto', 'PropertyValues', $propertyName );
		$this->cache->set( $key, $haystack, ExpirationAwareness::TTL_WEEK );
	}

	public function searchProperties( string $propertyName, string $query ): array {
		$cache = $this->cache;
		$key = $cache->makeKey( 'Nimiarkisto', 'PropertyValues', $propertyName );
		$haystack = $cache->get( $key );
		if ( $haystack === false ) {
			return [];
		}

		$anything = '.';
		$query = preg_quote( $query, '/' );
		// Prefix match
		$pattern = "/^$query$anything*/miu";
		preg_match_all( $pattern, $haystack, $matches, PREG_PATTERN_ORDER );
		$results = $matches[0];

		// Word match
		$pattern = "/^$anything*\b$query$anything*/miu";
		preg_match_all( $pattern, $haystack, $matches, PREG_PATTERN_ORDER );
		$results += $matches[0];

		return array_unique( $results );
	}

	public function getPropertyValues( string $propertyName ): string {
		$property = new Property( $propertyName );

		$values = $this->store->getPropertyValues( null, $property );
		$output = '';
		foreach ( $values as $value ) {
			if ( $value instanceof WikiPage ) {
				$output .= $value->getTitle()->getPrefixedText() . "\n";
			} elseif ( $value instanceof Blob ) {
				$output .= $value->getString() . "\n";
			} else {
				$output .= $value->getSerialization() . "\n";
			}
		}

		return $output;
	}
}
