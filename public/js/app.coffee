define [
	'angular',
	'lodash',
	'restangular',
	'cs!js/controllers/devices_controller',
	'cs!js/controllers/download_controller',
	'angular-route'
], (angular, _, Restangular, devicesController, downloadController) ->

	angular
		.module('app', [
			'restangular',
			'ngRoute'
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
		]
		.config [ 'RestangularProvider', (RestangularProvider) ->
			RestangularProvider.setBaseUrl('api')
		]

