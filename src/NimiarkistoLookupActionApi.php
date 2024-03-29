<?php
declare( strict_types = 1 );

namespace MediaWiki\Extensions\Nimiarkisto;

use ApiBase;
use Wikimedia\ParamValidator\ParamValidator;

/**
 * @author Niklas Laxström
 * @license GPL-2.0-or-later
 */
class NimiarkistoLookupActionApi extends ApiBase {
	/** @inheritDoc */
	public function execute(): void {
		$params = $this->extractRequestParams();
		$matches = ( new SMWPropertyValueLookup() )->searchProperties( $params['property'], $params['query'] );
		$matches = array_slice( $matches, 0, 50 );
		$formatter = static function ( $m ) {
			return [ 'title' => $m ];
		};
		$matches = array_map( $formatter, $matches );
		$result = $this->getResult();
		$result->addValue( null, 'pfautocomplete', $matches );
	}

	/** @inheritDoc */
	public function getAllowedParams(): array {
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
