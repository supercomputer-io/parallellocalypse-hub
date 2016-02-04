{% extends '../layout.swig' %}

{% block content %}

	<nav class="navbar navbar-default">
		<div class="container">
			<div class='navbar-header'>
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
		</div>
	</nav>

	<div ng-cloak ng-view></div>
	
{% endblock %}
