require.config({
	baseUrl: '/js',
	waitSeconds: 60,
	config: {
		'GA': {
			'id': 'UA-63317104-1'
		}
	},
	paths: {
		almond: '../bower_components//almond/almond',
		angular: '../bower_components//angular/angular',
		'angular-route': '../bower_components//angular-route/angular-route.min',
		'angular-timeago': '../bower_components//angular-timeago/src/timeAgo',
		cache: '../bower_components//require-cache/cache',
		'coffee-script': '../bower_components//coffee-script/extras/coffee-script',
		cs: '../bower_components//require-cs/cs',
		lodash: '../bower_components//lodash/lodash.min',
		restangular: '../bower_components//restangular/dist/restangular.min',
		bluebird: '../bower_components//bluebird/js/browser/bluebird.min',
		jquery: '../bower_components//jquery/dist/jquery.min',
		bootstrap: '../bower_components//bootstrap/dist/js/bootstrap.min',
		visibilityjs: '../bower_components//visibilityjs/lib/visibility.core',
		'ng-file-upload-shim': '../bower_components//ng-file-upload/ng-file-upload-shim.min',
		'ng-file-upload': '../bower_components//ng-file-upload/ng-file-upload.min',
		pubnub: '../bower_components//pubnub/web/pubnub.min',
		'pubnub-angular': '../bower_components//pubnub-angular/lib/pubnub-angular',
		'angular-bootstrap': '../bower_components/angular-bootstrap/ui-bootstrap-tpls.min',
		'angular-google-analytics': '../bower_components/angular-google-analytics/dist/angular-google-analytics.min',
		'reCAPTCHA': '//www.google.com/recaptcha/api.js?render=explicit'
	},
	shim: {
		angular: {
			exports: 'angular',
			deps: [ 'jquery' ]
		},
		'angular-route': {
			deps: [ 'angular' ]
		},
		'angular-timeago': {
			deps: [ 'angular' ]
		},
		bootstrap: {
			deps: [ 'jquery' ]
		},
		'angular-bootstrap': {
			deps: [ 'angular' ]
		},
		'angular-google-analytics': {
			deps: [ 'angular' ]
		},
		cs: {
			deps: [ 'cache' ]
		},
		restangular: {
			deps: [ 'lodash', 'angular' ]
		},
		visibilityjs: {
			exports: 'Visibility'
		},
		'ng-file-upload': {
			deps: [ 'angular', 'ng-file-upload-shim' ]
		},
		'pubnub-angular': {
			deps: [ 'angular', 'pubnub' ]
		}
	}
})

require([ 'angular', 'cs!./app' ], function (angular, app) {
	if (document.readyState === 'complete') {
		angular.bootstrap(document, [ 'app' ])
	} else {
		// Not ready yet.
		angular.element(document).ready(function () {
			angular.bootstrap(document, [ 'app' ])
		})
	}
})
