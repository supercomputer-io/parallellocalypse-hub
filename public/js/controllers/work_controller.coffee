define [
	'angular',
	'lodash'
], (angular, _) ->
	return ['$scope', 'Restangular', '$routeParams', 'createPoll', 'Upload', 'PubNub', 'Auth'
		($scope, Restangular, $routeParams, createPoll, Upload, PubNub, Auth) ->

			Auth.check ->

				$scope.minutes = '00'
				$scope.seconds = '00'
				$scope.updateClock = ->
					if $scope.work? && $scope.work.startTime?
						startTime = Date.parse($scope.work.startTime)
						finishTime = Date.parse($scope.work.finishTime) or Date.now()
					else
						startTime = 0
						finishTime = 0
					elapsed = (finishTime - startTime) / 1000
					minutes = Math.floor(elapsed / 60)
					if minutes < 10
						$scope.minutes = '0' + minutes
					else
						$scope.minutes = '' + minutes
					seconds = Math.floor(elapsed % 60)
					if seconds < 10
						$scope.seconds = '0' + seconds
					else
						$scope.seconds = '' + seconds

				timerPoll = createPoll($scope.updateClock, 1000)
				timerPoll.start()

				populateWork = (work) ->
					$scope.work = work
					if $scope.work.numChunks?
						$scope.chunks = new Array($scope.work.numChunks)
						$scope.chunkStyle = []
						
						_.each $scope.chunks, (chunk, ind) ->
							if $scope.work.results[ind]?
								$scope.chunks[ind] = 'green'
								$scope.chunkStyle[ind] = {'background-color': 'green'}
							else if $scope.work.assigned[ind]?
								$scope.chunks[ind] = 'yellow'
								$scope.chunkStyle[ind] = {'background-color': 'yellow'}
							else
								$scope.chunks[ind] = 'blue'
								$scope.chunkStyle[ind] = {'background-color': 'blue'}

					else
						$scope.chunks = []
						$scope.chunkStyle = []
					console.log($scope.chunks)
					if $scope.work.status == 'Done'
						$scope.result =
							image: '/images/' + $scope.work.finalResult.imageUrl
							name: $scope.work.finalResult.name
							correlation: $scope.work.finalResult.value
					else
						$scope.result = {}

				PubNub.ngSubscribe
					channel: 'status'
					callback: (data) ->
						console.log(data)
						populateWork(data.workload)
						

				$scope.getDevices = ->
					PubNub.ngHereNow
						channel: 'work'
						presence: (data) ->
							$scope.numDevices = data[0].occupancy

				devicesPoll = createPoll($scope.getDevices)
				devicesPoll.start()

				$scope.getWork = ->
					Restangular.one('work/current').get().then (data) ->
						populateWork(data)

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
						#poll.start()
					.error ->
						#poll.start()

				$scope.$watch 'file', (file) ->
					if (file?)
						#poll.stop()
						$scope.uploadFile()
						$scope.result = {}


				#poll = createPoll($scope.getWork)
				#poll.start()
				$scope.getWork()
				
	]
