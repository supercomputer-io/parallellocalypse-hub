{% extends '../layout.swig' %}

{% block content %}
	<div class="header">
		<nav class="navbar navbar-default navbar-fixed-top">
			<div class="container">
				<a class="navbar-brand">Resin Parallellocalypse</a>
			</div>
		</nav>
	</div>
	<div class="container">
		<div class="row">
			<div class="col-xs-12">
				<form class='form form-inline' method='POST' action='/api/images' enctype="multipart/form-data">
					<input type="text" name="name" />
					<input type="file" name="image" size="50" />
					<button class='btn btn-default' type="submit">Upload</button>
				</form>
			</div>
		</div>
	</div>
{% endblock %}
