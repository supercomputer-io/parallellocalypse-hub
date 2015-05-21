<!DOCTYPE html>
<html>
	<head>
		<title>parallellocalypse</title>

		<link rel="shortcut icon" href="/img/favicon.png">

		<!-- build:remove -->
		<link rel="stylesheet/less" href="/css/main.less">
		<script>
			less = {
				env: "development",
				poll: 1000,
				relativeUrls: true
			};
		</script>
		<script src="/bower_components/less/dist/less.js"></script>
		<!-- /build -->

		<!-- build:include ../views/build/css.html --><!-- /build -->
	</head>
	<body>
		{% block content %}{% endblock %}

		<!-- build:remove -->
		<script type="text/javascript" src="/bower_components/requirejs/require.js"></script>
		<script type="text/javascript" src="/js/main.js"></script>
		<!-- /build -->

		<!-- build:include ../views/build/js.html --><!-- /build -->

	</body>
</html>
