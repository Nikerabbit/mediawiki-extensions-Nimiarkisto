<?php

$cfg = require __DIR__ . '/../vendor/mediawiki/mediawiki-phan-config/src/config.php';

$cfg['minimum_target_php_version'] = '8.3';

$cfg['directory_list'] = array_merge(
	$cfg['directory_list'],
	[
		'vendor/data-values/data-values/src',
		'../SemanticMediaWiki',
		'../Wikibase',
	]
);

$cfg['exclude_analysis_directory_list'] = array_merge(
	$cfg['exclude_analysis_directory_list'],
	[
		'vendor',
		'vendor/data-values/data-values/src',
		'../SemanticMediaWiki',
		'../Wikibase',
	]
);

return $cfg;
