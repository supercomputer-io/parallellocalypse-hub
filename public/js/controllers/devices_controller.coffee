define [
	'angular',
	'restangular'
], (angular, Restangular) ->
	return ['$scope', 'Restangular', '$routeParams',
		($scope, Restangular, $routeParams) ->
			$scope.macAddress = $routeParams.mac or ''
			$scope.device = null
			$scope.getDevice = () ->
				console.log('getting device')
				console.log($scope.macAddress)
				Restangular.one('devices/by_mac_address', $scope.macAddress).get().then (data) ->
					$scope.device = data

			if $routeParams.mac
				$scope.getDevice()
	]
	
