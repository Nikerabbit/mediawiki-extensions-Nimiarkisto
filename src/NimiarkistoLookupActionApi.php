<?php
declare( strict_types = 1 );

namespace MediaWiki\Extensions\Nimiarkisto;

use ApiBase;
use Override;
use Wikimedia\ParamValidator\ParamValidator;

/**
 * @author Niklas Laxström
 * @license GPL-2.0-or-later
 */
class NimiarkistoLookupActionApi extends ApiBase {
	#[Override]
	public function execute(): void {
		$params = $this->extractRequestParams();
		$matches = ( new SMWPropertyValueLookup() )->searchProperties( $params['property'], $params['query'] );
		$matches = array_slice( $matches, 0, 50 );
		$formatter = ( static fn ( $m ): array => [ 'title' => $m ] );
		$matches = array_map( $formatter, $matches );
		$result = $this->getResult();
		$result->addValue( null, 'pfautocomplete', $matches );
	}

	#[Override]
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
