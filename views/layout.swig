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
		<script>
			(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
			(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
			m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
			})(window,document,'script','//www.google-analytics.com/analytics.js','ga');
			ga('create', 'UA-63317104-1', 'auto');
			ga('send', 'pageview');
		</script>
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
