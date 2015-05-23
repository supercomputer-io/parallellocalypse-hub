<div class='bg-white'>
	<div class="jumbotron landing-jumbotron">
		<div class='container'>
			<div class='col-sm-6'>
				<h2>The most efficient Supercomputer on the Planet</h2>
				<p>Help us democratize access to supercomputing for the scientists that need it. All you need is a Parallella computer to get started.</p>
				<p><a class="btn btn-success btn-lg" ng-click="scrollTo('participate')" role="button">Get started</a></p>
			</div>
		</div>
	</div>

	<div class='container'>
		<div class='row'>
			<div class='col-xs-8 col-xs-offset-2 text-center project-description'>
				<h2>We're out to build the world's most efficient distributed supercomputer using only Parallella boards.</h2>
				<h3>The first live test will be run at the <a href="{{conferenceLink}}" target='blank'>Parallella Technical Conference</a> in Tokyo on May 30th!</h3>
			</div>
			<hr class='col-xs-10 col-xs-offset-1'>
		</div>
		<div class='row'>
			<div class='col-sm-3 col-sm-offset-3'>
				<div class='uibox'>
					<h4>Total devices</h4>
					<div class='number-in-box'>
						<h1>{{totalDevices || 0 | number}}</h1>
					</div>
				</div>
			</div>
			<div class='col-sm-3'>
				<div class='uibox'>
					<h4>Devices Online right now</h4>
					<div class='number-in-box'>
						<h1>{{numDevices || 0 | number}}</h1>
					</div>
				</div>
			</div>
		</div>
		<div class='row'>
			<div class='col-xs-12 text-center'>
				<h2 class='landing-h'>How it works</h2>
				<h4>The supercomputer.io workflow:</h4>
			</div>
		</div>
		<div class='row'>
			<div class='col-xs-6 col-xs-offset-3'>
				<ol class='workflow-list'>
					<li><b>Developers</b> push applications to the supercomputer.io repository.</li>
					<li><b>Workers</b> contribute their unused Parallella boards to the cause.</li>
					<li><b>Scientists</b> put in work requests to use supercomputer.io applications.</li>
				</ol>
			</div>
		</div>
		<div class='row'>
			<div class='col-xs-4 col-xs-offset-4'>
				Cool diagram goes here
			</div>
			<hr class='col-xs-10 col-xs-offset-1'>
		</div>
		<div class='row' id='participate'>
			<div class='col-xs-12 text-center'>
				<h2 class='landing-h'>How to participate</h2>
			</div>
		</div>
		<div class='row text-center'>
			<div class='col-sm-4'>
				<div class='row'>
					<p class='step-title'>Step 1</p>
				</div>
				<div class='row box-step'>
					<div class='well'>
						<button class='btn btn-primary' ng-click='openDownloadModal()'>Download</button>
					</div>
					Download the OS image
				</div>
			</div>
			<div class='col-sm-4'>
				<div class='row'>
					<p class='step-title'>Step 2</p>
				</div>
				<div class='row box-step'>
					<a href="#/install">
						<div class='well'>
							<img src='/img/sdcard.png'>
						</div>
					</a>
					Write OS to SD card
				</div>
			</div>
			<div class='col-sm-4'>
				<div class='row'>
					<p class='step-title'>Step 3</p>
				</div>
				<div class='row box-step'>
					<div class='well'>
						<p>Power up</p>
					</div>
					Power up your board
				</div>

			</div>
		</div>
	</div>
</div>