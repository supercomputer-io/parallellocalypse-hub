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
	'ng-file-upload',
	'pubnub-angular'
], (angular, _, Restangular, devicesController, downloadController, workController, createPoll, pubnub) ->

	angular
		.module('app', [
			'restangular',
			'ngRoute',
			'createPoll',
			'yaru22.angular-timeago',
			'ngFileUpload',
			'pubnub.angular.service'
		])

		.run([ '$rootScope', 'Restangular' , 'PubNub', ($rootScope, Restangular, PubNub) ->
			PubNub.init
				subscribe_key: 'sub-c-1faf9860-f5c0-11e4-b21e-02ee2ddab7fe'
		])
		.config [ '$routeProvider', ($routeProvider) ->
			$routeProvider
				.when '/dashboard',
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

