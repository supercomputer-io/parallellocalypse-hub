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
					# Force mac in aa:bb:cc:dd:ee:ff format
					mac = $scope.macAddress.replace(/(..):?/g, '$1:').toLowerCase().slice(0, 17)
					Restangular.one('devices/by_mac_address', mac).get().then (data) ->
						$scope.device = data
						console.log(data)

			$scope.goToDevice = ->
				# Force mac in aa:bb:cc:dd:ee:ff format
				mac = $scope.mac.replace(/(..):?/g, '$1:').toLowerCase().slice(0, 17)
				$location.path('/devices/' + mac)

			poll = createPoll($scope.getDevice)
			poll.start()
	]
