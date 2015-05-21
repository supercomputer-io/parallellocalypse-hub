module.exports = (grunt) ->
	grunt.initConfig

		clean:
			build: [ 'build' ]
			templateCache: [ 'build/templateCache.js' ]

		copy:
			src:
				files: [
					expand: true
					cwd: 'public'
					src: '**/*.{png,jpg,jpeg,gif,swf,svg,eot,ttf,otf,woff,woff2}'
					dest: 'build'
				]

		swig_render:
			src:
				expand: true
				cwd: 'views/pages'
				ext: '.html'
				src: [ '*.swig' ]
				dest: 'build'

		processhtml:
			src:
				files: [
					expand: true
					cwd: 'build/'
					src: [ '*.html' ]
					dest: 'build/'
				]

		less:
			main:
				options:
					compress: true
					relativeUrls: true
				files:
					'build/main.css': 'public/css/main.less'

		imagemin:
			src:
				files: [
					expand: true
					cwd: 'public/'
					src: [ '**/*.{png,jpg,gif}', '!**/bower_components/**' ]
					dest: 'public/'
				]

		requirejs:
			main:
				options:
					baseUrl: 'public/js'
					mainConfigFile: 'public/js/main.js'
					out: 'build/main.js'
					name: 'main'
					optimize: 'none'
					preserveLicenseComments: false
					stubModules: [
						'text'
						'css'
						'cs'
						'json'
					]
					include: ['almond']
					excludeShallow: [
						'cache',
						'coffee-script'
						'uglify-js'
					]

		ngtemplates:
			templateCache:
				cwd: 'public'
				src: 'js/views/*.tpl'
				dest: 'build/templateCache.js'
				options:
					htmlmin:
						collapseBooleanAttributes: false
						collapseWhitespace: true
						removeAttributeQuotes: false
						removeComments: true
						removeEmptyAttributes: false
						removeRedundantAttributes: true
						removeScriptTypeAttributes: true
						removeStyleLinkTypeAttributes: true
					prefix: '/'
					standalone: true

		concat:
			templateCache:
				src: [ 'build/main.js', 'build/templateCache.js' ]
				dest: 'build/main.js'

		uglify:
			options:
				mangle: true
				compress: true
			src:
				files:
					'build/main.js': ['build/main.js']

	require('load-grunt-tasks')(grunt)

	grunt.registerTask 'build', [
		'clean:build'
		'copy'

		'less'

		'requirejs'
		'ngtemplates'
		'concat:templateCache'
		'clean:templateCache'
		'uglify'

		'swig_render'
		'processhtml'
	]
