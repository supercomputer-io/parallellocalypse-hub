define [
	'angular',
	'lodash',
	'restangular',
	'cs!js/controllers/devices_controller',
	'cs!js/controllers/download_controller',
	'angular-route',
	'cs!js/helpers/create_poll'
], (angular, _, Restangular, devicesController, downloadController, createPoll) ->

	angular
		.module('app', [
			'restangular',
			'ngRoute',
			'createPoll'
		])

		.run([ '$rootScope', 'Restangular' , ($rootScope, Restangular) ->


		])
		.config [ '$routeProvider', ($routeProvider) ->
			$routeProvider
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

