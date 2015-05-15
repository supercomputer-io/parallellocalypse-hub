define [
	'angular'
], (angular) ->
	return ['$scope', 'Restangular', '$routeParams', 'createPoll', 'Upload', 'PubNub'
		($scope, Restangular, $routeParams, createPoll, Upload, PubNub) ->

			PubNub.ngSubscribe
				channel: 'status'
				callback: (data) ->
					$scope.work = data

			$scope.getDevices = ->
				PubNub.ngHereNow
					channel: 'work'
					presence: (data) ->
						$scope.numDevices = data[0].occupancy

			devicesPoll = createPoll($scope.getDevices)
			devicesPoll.start()

			$scope.getWork = ->
				Restangular.one('work/current').get().then (data) ->
					$scope.work = data

					if $scope.work.status == 'Done'
						$scope.result =
							image: '/images/' + $scope.work.finalResult.imageUrl
							name: $scope.work.finalResult.name
							correlation: $scope.work.finalResult.value
					else
						$scope.result = {}

			$scope.uploadFile = ->
				file = $scope.file
				Upload.upload
					url: '/api/work'
					fields: {}
					file: file
					fileFormDataName: 'image'
				.progress (evt) ->
					progressPercentage = parseInt(100.0 * evt.loaded / evt.total)
					console.log('progress: ' + progressPercentage + '% ' + evt.config.file.name)
				.success (data, status, headers, config) ->
					if data.error
						console.log('Dispatcher is busy')
					else
						$scope.work = data
					poll.start()
				.error ->
					poll.start()

			$scope.$watch 'file', (file) ->
				if (file?)
					poll.stop()
					$scope.uploadFile()
					$scope.result = {}


			poll = createPoll($scope.getWork)
			poll.start()
	]
