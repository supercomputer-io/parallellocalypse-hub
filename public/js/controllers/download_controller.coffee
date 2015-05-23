define [
	'angular-bootstrap'
], ->
	return ['$scope', '$sce', 'config', '$anchorScroll', '$location', '$modal', '$rootScope',
		($scope, $sce, config, $anchorScroll, $location, $modal, $rootScope) ->
			$scope.downloadUrl = '/api/download'

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
							Z7010: $sce.trustAsResourceUrl(config.s3url + 'os/resin-supercomputer-0.1.0-0.0.14-Z7010-16.img')
							Z7020: $sce.trustAsResourceUrl(config.s3url + 'os/resin-supercomputer-0.1.0-0.0.14-Z7020-16.img')
						}
						$scope.close = ->
							$modalInstance.dismiss()
					]
				}

			$rootScope.openDownloadModal = $scope.openDownloadModal

			if $location.path() == '/download'
				$scope.openDownloadModal()
	]
