/* eslint-env node */
module.exports = function ( grunt ) {
	'use strict';

	var conf = grunt.file.readJSON( 'extension.json' );

	grunt.loadNpmTasks( 'grunt-eslint' );
	grunt.loadNpmTasks( 'grunt-banana-checker' );
	grunt.loadNpmTasks( 'grunt-stylelint' );

	grunt.initConfig( {
		eslint: {
			options: {
				cache: true,
				fix: grunt.option( 'fix' )
			},
			all: [
				'**/*.{js,json}',
				'!{vendor,node_modules,lib}/**',
				'!resources/map-component.js'
			]
		},
		stylelint: {
			src: [
				'**/*.{css,less}',
				'!{vendor,node_modules,lib}/**'
			]
		},
		// eslint-disable-next-line es/no-object-assign
		banana: Object.assign( conf.MessagesDirs, {
			options: {
				requireLowerCase: 'initial'
			}
		} )
	} );

	grunt.registerTask( 'test', [ 'eslint', 'banana', 'stylelint' ] );
	grunt.registerTask( 'default', 'test' );
};
