<?php

declare( strict_types = 1 );

use Rector\Config\RectorConfig;
use Rector\TypeDeclaration\Rector\ClassMethod\StrictArrayParamDimFetchRector;

return RectorConfig::configure()
	->withPaths( [
		__DIR__ . '/maintenance',
		__DIR__ . '/src',
	] )
	->withPhpSets()
	->withSkip( [
		// MediaWiki hook interfaces can intentionally leave array parameters untyped.
		StrictArrayParamDimFetchRector::class,
	] )
	->withPreparedSets(
		deadCode: true,
		codeQuality: true,
		earlyReturn: true,
		instanceOf: true,
		typeDeclarations: true,
		typeDeclarationDocblocks: true,
		privatization: true,
	);
