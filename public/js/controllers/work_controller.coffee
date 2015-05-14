define [
	'angular',
	'restangular'
], (angular, Restangular) ->
	return ['$scope', 'Restangular', '$routeParams', 'createPoll', 'Upload'
		($scope, Restangular, $routeParams, createPoll, Upload) ->

			$scope.getWork = ->
				Restangular.one('work/current').get().then (data) ->
					console.log(data)
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
				console.log(file)
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
						console.log("Dispatcher is busy")
					else
						$scope.work = data


			poll = createPoll($scope.getWork)
			poll.start()
	]
