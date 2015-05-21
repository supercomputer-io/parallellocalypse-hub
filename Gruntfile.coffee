module.exports = (grunt) ->
	grunt.initConfig

		clean:
			build: [ 'build' ]
			templateCache: [ 'build/js/templateCache.js' ]

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

	require('load-grunt-tasks')(grunt)

	grunt.registerTask 'build', [
		'clean:build'
		'copy'
		'less'
		'swig_render'
		'processhtml'

	]
