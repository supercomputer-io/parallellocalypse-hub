module.exports = (grunt) ->
	grunt.initConfig

		copy:
			src:
				files: [
					expand: true
					cwd: 'public'
					src: '**/*.{png,jpg,jpeg,gif,swf,svg,eot,ttf,otf,woff,woff2}'
					dest: 'build'
				]

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
		'copy'
	]
