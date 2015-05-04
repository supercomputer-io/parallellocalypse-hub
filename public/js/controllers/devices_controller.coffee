define [
	'angular',
	'restangular'
], (angular, Restangular) ->
	return ['$scope', 'Restangular',
		($scope, Restangular) ->
			$scope.macAddress = ''
			$scope.getDevice = () ->
				console.log('getting device')
				console.log($scope.macAddress)
				Restangular.one('devices/by_mac_address', $scope.macAddress).get().then (data) ->
					$scope.device = data
	]
	
