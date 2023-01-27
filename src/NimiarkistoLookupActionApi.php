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
		$result = $this->getResult();
		foreach ( $matches as $match ) {
			$result->addValue( 'pfautocomplete', null, [ 'title' => $match ] );
		}
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
