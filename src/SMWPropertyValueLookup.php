<?php
declare( strict_types = 1 );

namespace MediaWiki\Extensions\Nimiarkisto;

use MediaWiki\MediaWikiServices;
use SMW\DIProperty;
use SMW\DIWikiPage;
use SMWDIBlob;
use SMWStore;
use WANObjectCache;
use Wikimedia\LightweightObjectStore\ExpirationAwareness;

/**
 * @author Niklas Laxström
 * @license GPL-2.0-or-later
 */
class SMWPropertyValueLookup {
	private WANObjectCache $cache;
	private SMWStore $store;

	public function __construct() {
		$this->cache = MediaWikiServices::getInstance()->getMainWANObjectCache();
		$this->store = smwfGetStore();
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
		$property = new DIProperty( $propertyName );

		$values = $this->store->getPropertyValues( null, $property );
		$output = '';
		foreach ( $values as $value ) {
			if ( $value instanceof DIWikiPage ) {
				$output .= $value->getTitle()->getPrefixedText() . "\n";
			} elseif ( $value instanceof SMWDIBlob ) {
				$output .= $value->getString() . "\n";
			} else {
				$output .= $value->getSerialization() . "\n";
			}
		}

		return $output;
	}
}
