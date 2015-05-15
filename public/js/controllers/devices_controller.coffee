define [
	'angular',
	'restangular'
], (angular, Restangular) ->
	return ['$scope', 'Restangular', '$routeParams', 'createPoll', '$location'
		($scope, Restangular, $routeParams, createPoll, $location) ->

			$scope.macAddress = $routeParams.mac or ''
			$scope.mac = $routeParams.mac or ''
			$scope.device = null

			$scope.getDevice = ->
				if $scope.macAddress? && $scope.macAddress != ''
					Restangular.one('devices/by_mac_address', $scope.macAddress).get().then (data) ->
						$scope.device = data
						console.log(data)

			$scope.goToDevice = ->
				$location.path('/devices/' + $scope.mac)

			poll = createPoll($scope.getDevice)
			poll.start()
	]
