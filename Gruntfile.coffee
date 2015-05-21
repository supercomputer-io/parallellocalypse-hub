module.exports = (grunt) ->
	grunt.initConfig

		clean:
			build: [ 'build' ]
			css:
				files: [
					expand: true
					cwd: 'build/css'
					src: '*'
					filter: (src) -> src.indexOf('main.css') is -1
				]
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
		'swig_render'
	]
