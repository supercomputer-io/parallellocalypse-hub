define [
	'angular',
	'restangular'
], (angular, Restangular) ->
	return ['$scope', 'Restangular', '$routeParams', 'createPoll',
		($scope, Restangular, $routeParams, createPoll) ->

			$scope.macAddress = $routeParams.mac or ''
			$scope.device = null
			console.log(createPoll)
			$scope.getDevice = () ->
				console.log("Getting device")
				if $scope.macAddress? && $scope.macAddress != ''
					Restangular.one('devices/by_mac_address', $scope.macAddress).get().then (data) ->
						$scope.device = data
						console.log(data)

			poll = createPoll($scope.getDevice)
			poll.start()
	]
	
