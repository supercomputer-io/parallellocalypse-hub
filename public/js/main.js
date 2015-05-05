require.config({
	paths: {
		angular: '/bower_components/angular/angular',
		'angular-route': '/bower_components/angular-route/angular-route.min',
		'angular-timeago': '/bower_components/angular-timeago/src/timeAgo',
		cache: '/bower_components/require-cache/cache',
		'coffee-script': './bower_components/coffee-script/extras/coffee-script',
		cs: '/bower_components/require-cs/cs',
		lodash: '/bower_components/lodash/lodash.min',
		restangular: '/bower_components/restangular/dist/restangular.min',
		bluebird: '/bower_components/bluebird/js/browser/bluebird.min',
		jquery: '/bower_components/jquery/dist/jquery.min',
		bootstrap: '/bower_components/bootstrap/dist/js/bootstrap.min',
		visibilityjs: '/bower_components/visibilityjs/lib/visibility.core'
	},
	shim: {
		angular: {
			exports: 'angular',
			deps: [ 'jquery' ]
		},
		'angular-route': {
			deps: [ 'angular' ]
		},
		bootstrap: {
			deps: [ 'jquery' ]
		},
		cs: {
			deps: [ 'cache' ]
		},
		restangular: {
			deps: [ 'lodash', 'angular' ]
		},
		visibilityjs: {
			exports: 'Visibility'
		}
	}
})

require([ 'angular', 'cs!js/app' ], function (angular, app) {
	if (document.readyState === 'complete') {
		angular.bootstrap(document, [ 'app' ])
	} else {
		// Not ready yet.
		angular.element(document).ready(function () {
			angular.bootstrap(document, [ 'app' ])
		})
	}
})
