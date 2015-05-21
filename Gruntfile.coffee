module.exports = (grunt) ->
	grunt.initConfig

		imagemin:
			src:
				files: [
					expand: true
					cwd: 'public/'
					src: [ '**/*.{png,jpg,gif}', '!**/bower_components/**' ]
					dest: 'public/'
				]

	require('load-grunt-tasks')(grunt)

	grunt.registerTask 'build', []
