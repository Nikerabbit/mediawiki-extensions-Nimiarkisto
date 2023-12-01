<?php
declare( strict_types = 1 );

namespace MediaWiki\Extensions\Nimiarkisto;

use Wikimedia\ParamValidator\ParamValidator;

/**
 * @author Niklas Laxström
 * @license GPL-2.0-or-later
 */
class NimiarkistoLookupActionApi extends \ApiBase {
	/** @inheritDoc */
	public function execute() {
		$params = $this->extractRequestParams();
		$matches = ( new SMWPropertyValueLookup() )->searchProperties( $params['property'], $params['query'] );
		$matches = array_slice( $matches, 0, 50 );
		$formatter = static function ( $m ) {
			return [ 'title' => $m ];
		};
		$matches = array_map( $formatter, $matches );
		$result = $this->getResult();
		$result->addValue( null, 'pf_autocomplete', $matches );
	}

	/** @inheritDoc */
	public function getAllowedParams() {
		return [
			'property' => [
				ParamValidator::PARAM_REQUIRED => true
			],
			'query' => [
				ParamValidator::PARAM_REQUIRED => true
			],
		];
	}
}
