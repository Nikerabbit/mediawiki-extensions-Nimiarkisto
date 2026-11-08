<?php

declare( strict_types = 1 );

use Rector\CodingStyle\Rector\ClassLike\NewlineBetweenClassLikeStmtsRector;
use Rector\Config\RectorConfig;
use Rector\TypeDeclaration\Rector\ClassMethod\StrictArrayParamDimFetchRector;

return RectorConfig::configure()
	->withPaths( [
		__DIR__ . '/Nimiarkisto.magic.php',
		__DIR__ . '/maintenance',
		__DIR__ . '/src',
	] )
	->withPhpSets()
	->withComposerBased()
	->withSkip( [
		// Keep consecutive class member declarations together.
		NewlineBetweenClassLikeStmtsRector::class,
		// MediaWiki hook interfaces can intentionally leave array parameters untyped.
		StrictArrayParamDimFetchRector::class,
	] )
	->withPreparedSets(
		deadCode: true,
		codeQuality: true,
		codingStyle: true,
		typeDeclarations: true,
		typeDeclarationDocblocks: true,
		privatization: true,
	);
