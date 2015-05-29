define [
	'angular-bootstrap'
], ->
	return ['$scope', '$sce', 'config', '$anchorScroll', '$location',
		'$modal', '$rootScope', 'createPoll', 'PubNub', 'Restangular'
		($scope, $sce, config, $anchorScroll, $location, $modal, $rootScope, createPoll, PubNub, Restangular) ->

			$scope.scrollTo = (id) ->
				$location.hash(id)
				$anchorScroll.yOffset = 50
				$anchorScroll()


			$scope.conferenceLink = $sce.trustAsResourceUrl('https://www.parallella.org/2015/03/23/first-parallella-technical-conference-ptc-to-be-held-in-tokyo/')

			$scope.openDownloadModal = ->
				$scope.downloadModal = $modal.open {
					templateUrl: '/js/views/download.tpl'
					controller: ['$scope', '$modalInstance', ($scope, $modalInstance) ->
						$scope.downloadUrl = {
							Z7010: $sce.trustAsResourceUrl(config.s3url + '/os/resin-supercomputer-0.1.0-0.0.14-Z7010-16.img')
							Z7020: $sce.trustAsResourceUrl(config.s3url + '/os/resin-supercomputer-0.1.0-0.0.14-Z7020-16.img')
						}
						$scope.close = ->
							$modalInstance.dismiss()
					]
				}

			$rootScope.openDownloadModal = $scope.openDownloadModal

			if $location.path() == '/download'
				$scope.openDownloadModal()

			$scope.openInstructions = ->
				$scope.instructionsModal = $modal.open {
					templateUrl: '/js/views/install.tpl'
					controller: ['$scope', '$modalInstance', ($scope, $modalInstance) ->
						$scope.close = ->
							$modalInstance.dismiss()
							$location.path('/')
					]
				}

			$rootScope.openInstructions = $scope.openInstructions

			if $location.path() == '/install'
				$scope.openInstructions()

			$scope.getDevices = ->
					PubNub.ngHereNow
						channel: 'work'
						presence: (data) ->
							$scope.numDevices = data[0].occupancy
					Restangular.one('devices/count').get().then (data) ->
						if data.count
							$scope.totalDevices = data.count

			devicesPoll = createPoll($scope.getDevices)
			devicesPoll.start()
	]
