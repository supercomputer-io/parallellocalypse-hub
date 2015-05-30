define [
	'angular',
	'lodash',
	'angular-google-maps'
], (angular, _) ->
	return ['$scope', 'Restangular', '$routeParams', 'createPoll', 'Upload', 'PubNub', 'Auth', '$sce', 'config', 'uiGmapGoogleMapApi',
		($scope, Restangular, $routeParams, createPoll, Upload, PubNub, Auth, $sce, config, uiGmapGoogleMapApi) ->

			$scope.target = {}

			uiGmapGoogleMapApi.then (maps) ->
				$scope.map = { center: { latitude: 15, longitude: 0 }, zoom: 1 };
				$scope.markers = {}

				Restangular.all('devices').getList().then (data) ->

					for i in [0...data.length]
						loc = data[i].location.loc.split(',')
						$scope.markers[i] = {
							id: i,
							center: {latitude: loc[0], longitude: loc[1]},
							stroke: {
								color: '#222',
								weight: 2,
								opacity: 1
							},
							fill: {
								color: '#222',
								opacity: 0.5
							},
						}



				Auth.check (authenticated) ->
					$scope.authenticated = authenticated

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
						$scope.progress = { width: (Math.round(work.numResults / work.numChunks * 100)).toString() + '%'  }

						if work.targetImage?
							$scope.targetImageUrl = $sce.trustAsResourceUrl(config.s3url + work.targetImage.path)
							$scope.targetImageResizedUrl = $sce.trustAsResourceUrl(config.s3url + work.targetImage.image.resized.path)
						
						if $scope.work.status == 'Done'
							$scope.result =
								image: $sce.trustAsResourceUrl(config.s3url + $scope.work.finalResult.imageUrl)
								name: $scope.work.finalResult.name
								correlation: $scope.work.finalResult.value
						else
							$scope.result = {}

					PubNub.ngSubscribe
						channel: 'status'
						callback: (data) ->
							populateWork(data.workload)

					PubNub.ngSubscribe
						channel: 'results'
						callback: (result) ->
							$scope.chunks[result.device] = 'solved'
							$scope.chunkStyle[result.device] = {style: 'solved', uuid: dev.uuid}

					$scope.getDevices = ->
						PubNub.ngHereNow
							channel: 'work'
							presence: (data) ->
								$scope.numDevices = data[0].occupancy

								$scope.devices = data[0].uuids

								$scope.chunks = {}

								$scope.chunkStyle = {}

								_.each $scope.devices, (dev) ->
									if dev.state.status == 'Idle'
										$scope.chunks[dev.uuid] = ''
										$scope.chunkStyle[dev.uuid] = {style: '', uuid: dev.uuid}
									else if dev.state.status == 'Working'
										$scope.chunks[dev.uuid] = 'assigned'
										$scope.chunkStyle[dev.uuid] = {style: 'assigned', uuid: dev.uuid}
									else
										$scope.chunks[dev.uuid] = 'nocache'
										$scope.chunkStyle[dev.uuid] = {style: 'nocache', uuid: dev.uuid}

					devicesPoll = createPoll($scope.getDevices)
					devicesPoll.start()

					$scope.getWork = ->
						Restangular.one('work/current').get().then (data) ->
							populateWork(data) if data

					$scope.uploadFile = (file)->
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

					$scope.stopWork = ->
						Restangular.all('work/stop').post().then ->
							console.log('Work stopped')

					$scope.$watch 'file', ->
						console.log('fwatch')
						if ($scope.file?)
							#poll.stop()
							$scope.uploadFile($scope.file)
							$scope.result = {}
					, true

					$scope.$watch 'file2', ->
						console.log('fwatch2')
						if ($scope.file2?)
							#poll.stop()
							$scope.uploadFile($scope.file2)
							$scope.result = {}
					, true

					#poll = createPoll($scope.getWork)
					#poll.start()
					$scope.getWork()

	]
