<?php

$cfg = require __DIR__ . '/../vendor/mediawiki/mediawiki-phan-config/src/config.php';

$cfg['minimum_target_php_version'] = '8.3';

$cfg['directory_list'] = array_merge(
	$cfg['directory_list'],
	[
		'../SemanticMediaWiki',
		'../Wikibase',
		'../Wikibase/vendor/data-values/data-values/src',
	]
);

$cfg['exclude_analysis_directory_list'] = array_merge(
	$cfg['exclude_analysis_directory_list'],
	[
		'vendor',
		'../SemanticMediaWiki',
		'../Wikibase',
		'../Wikibase/vendor/data-values/data-values/src',
	]
);

// Wikibase's other production dependencies overlap with MediaWiki core's vendor directory.
$cfg['exclude_file_regex'] = '@^\.\./Wikibase/vendor/(?!data-values/)@';

return $cfg;
