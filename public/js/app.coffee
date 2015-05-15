define [
	'angular',
	'lodash',
	'restangular',
	'cs!js/controllers/devices_controller',
	'cs!js/controllers/download_controller',
	'cs!js/controllers/work_controller',
	'cs!js/controllers/login_controller',
	'cs!js/helpers/create_poll',
	'cs!js/helpers/auth',
	'angular-route',
	'angular-timeago',
	'ng-file-upload',
	'pubnub-angular'
],
(angular, _, Restangular, devicesController, downloadController,
workController, loginController, createPoll, Auth) ->

	angular
		.module('app', [
			'restangular',
			'ngRoute',
			'createPoll',
			'Auth',
			'yaru22.angular-timeago',
			'ngFileUpload',
			'pubnub.angular.service'
		])

		.run([ '$rootScope', 'Restangular' , 'PubNub', 'Auth', '$location',
		($rootScope, Restangular, PubNub, Auth, $location) ->
			PubNub.init
				subscribe_key: 'sub-c-1faf9860-f5c0-11e4-b21e-02ee2ddab7fe'

			Restangular.setErrorInterceptor (response) ->
				if response.status == 401
					Auth.logout()
					return false
				return true

			$rootScope.logout = Auth.logout
		])
		.config [ '$routeProvider', ($routeProvider) ->
			$routeProvider
				.when '/login',
					controller: loginController
					templateUrl: 'views/login.html'
				.when '/dashboard',
					controller: workController
					templateUrl: 'views/work.html'
				.when '/download',
					controller: downloadController
					templateUrl: 'views/download.html'
				.when '/',
					controller: devicesController
					templateUrl: 'views/devices.html'
				.when '/devices',
					controller: devicesController
					templateUrl: 'views/devices.html'
				.when '/devices/:mac',
					controller: devicesController
					templateUrl: 'views/devices.html'
				.otherwise
					templateUrl: 'views/404.html'

		]
		.config [ 'RestangularProvider', (RestangularProvider) ->
			RestangularProvider.setBaseUrl('api')
		]

