define [
	'angular'
	'visibilityjs'
], (angular, Visibility) ->

	createPoll = angular.module('createPoll', [])

	createPoll.factory 'createPoll', ['$interval', '$q', ($interval, $q) ->
		DEFAULT_INTERVAL = 3000
		DEFAULT_GRACE_RATIO = 0.33

		return (fn, interval = DEFAULT_INTERVAL, graceRatio = DEFAULT_GRACE_RATIO) ->

			graceInterval = interval * graceRatio

			pollPromise = null
			pollInProgress = false

			lastCompleteTime = 0

			poll = ->
				return if Visibility.hidden()
				return if pollInProgress
				return if Date.now() - lastCompleteTime < graceInterval
				# Set the poll as in progress, so we cannot have this multiple versions of this poll happening.
				pollInProgress = true
				$q.when(fn()).then ->
					pollInProgress = false
					lastCompleteTime = Date.now()

			return {
				start: ->
					# Only start polling if it is currently stopped.
					return if pollPromise?
					lastCompleteTime = 0
					pollPromise = $interval(poll, interval)
					# Also run a poll instantly, as we wanted to start it *now*, not X time in the future.
					poll()
				stop: ->
					$interval.cancel(pollPromise)
					pollPromise = null
					pollInProgress = false
					return
			}
	]
