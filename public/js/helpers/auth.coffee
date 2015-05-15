define [
	'angular'
], (angular) ->

	authService = angular.module('Auth', [])

	authService.factory 'Auth', [ '$rootScope', '$location', '$http', ($rootScope, $location, $http) ->
		htmlEl = angular.element('html')

		auth = {
			check: (callback) ->
				$rootScope.authenticated = false

				$http.get('/who').then ->
					# user authenticated
					$rootScope.authenticated = true
					htmlEl.removeClass('login-page')

					if(callback)
						callback(true)
					else
						$location.path('/dashboard')
				, ->
					# user not authenticated
					console.log('Not logged in')
					auth.logout()

			logout: ->
				$rootScope.authenticated = false
				htmlEl.addClass('login-page')
				$http.post('/logout').then ->
					console.log('Logged out')
				$location.path('/login')
		}

		return auth

	]
