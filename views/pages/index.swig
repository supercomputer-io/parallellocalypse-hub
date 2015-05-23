{% extends '../layout.swig' %}

{% block content %}

	<nav class="navbar navbar-default navbar-fixed-top">
		<div class="container">
			<div class='navbar-header'>
				<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#mainNavbar">
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span> 
				</button>
				<a class="navbar-brand" href="#/">
					<span>
						<img src='/img/logo.svg' class='logo'>
					</span>
					<span>
						<img src='/img/parallella.svg' class='logo'>
					</span>
					<span>
						supercomputer.io
					</span>
				</a>
			</div>
			<div class="collapse navbar-collapse" id="mainNavbar">
				<ul class="nav navbar-nav" ng-cloak>
					<li ng-class="{ active: isActive('dashboard') }" ng-if='authenticated'><a href='#/dashboard'>Dashboard</a></li>
					<li ng-class="{ active: isActive('download') }"><a ng-click='openDownloadModal()'>Download OS</a></li>
					<li ng-class="{ active: isActive('faq') }"><a href='#/faq'>FAQ</a></li>
					<li ng-class="{ active: isActive('devices') }"><a href='#/devices'>Search device</a></li>
				</ul>
				<ul class='nav navbar-nav navbar-right' ng-if='authenticated' ng-cloak>
					<li><a ng-click='logout()'>Logout</a></li>
				</ul>
			</div>
		</div>
	</nav>


	<div ng-cloak ng-view>

	</div>

	<div class='container'>
		<div class='row'>
			<img class="col-xs-offset-6 ng-hide" src="/img/loading.gif">
		</div>
	</div>
	<footer class='footer'>
	</footer>
{% endblock %}
