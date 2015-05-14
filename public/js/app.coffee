define [
	'angular',
	'lodash',
	'restangular',
	'cs!js/controllers/devices_controller',
	'cs!js/controllers/download_controller',
	'cs!js/controllers/work_controller',
	'cs!js/helpers/create_poll',
	'angular-route',
	'angular-timeago',
	'ng-file-upload'
], (angular, _, Restangular, devicesController, downloadController, workController, createPoll) ->

	angular
		.module('app', [
			'restangular',
			'ngRoute',
			'createPoll',
			'yaru22.angular-timeago',
			'ngFileUpload'
		])

		.run([ '$rootScope', 'Restangular' , ($rootScope, Restangular) ->


		])
		.config [ '$routeProvider', ($routeProvider) ->
			$routeProvider
				.when '/work',
					controller: workController
					templateUrl: 'views/work.html'
				.when '/download',
					controller: downloadController
					templateUrl: 'views/download.html'
				.when '/devices',
					controller: devicesController
					templateUrl: 'views/devices.html'
				.when '/devices/:mac',
					controller: devicesController
					templateUrl: 'views/devices.html'
		]
		.config [ 'RestangularProvider', (RestangularProvider) ->
			RestangularProvider.setBaseUrl('api')
		]

