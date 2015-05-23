<div class='bg-white'>
	<div class="jumbotron landing-jumbotron">
		<div class='container'>
			<div class='col-sm-6'>
				<h1>The most efficient Supercomputer on the Planet</h1>
				<h2>Help us democratize access to supercomputing for the scientists that need it. All you need is a Parallella computer to get started.</h2>
				<p>
					<div class='col-sm-4'><a class="btn btn-block btn-landing-green" ng-click="scrollTo('participate')" role="button">Get started</a></div></p>
			</div>
		</div>
		<a href="https://github.com/supercomputer-io" target='blank'><img style="position: absolute; top: 50px; right: 0; border: 0;" src="https://camo.githubusercontent.com/365986a132ccd6a44c23a9169022c0b5c890c387/68747470733a2f2f73332e616d617a6f6e6177732e636f6d2f6769746875622f726962626f6e732f666f726b6d655f72696768745f7265645f6161303030302e706e67" alt="Fork me on GitHub" data-canonical-src="https://s3.amazonaws.com/github/ribbons/forkme_right_red_aa0000.png"></a>
	</div>

	<div class='container'>
		<div class='row'>
			<div class='col-xs-8 col-xs-offset-2 text-center project-description'>
				<h3>The first live test will be run at the <a href="{{conferenceLink}}" target='blank'>Parallella Technical Conference</a> in Tokyo on May 30th!</h3>
			</div>
			<hr class='col-xs-10 col-xs-offset-1'>
		</div>
		<div class='row'>
			<div class='col-xs-12 text-center project-description'>
				<h1 class='landing-h'>How it works</h1>
				<h3>The supercomputer.io workflow:</h3>
			</div>
		</div>
		<div class='row'>
			<div class='col-xs-7 col-xs-offset-3'>
				<ol class='workflow-list'>
					<li><b>Owners</b> contribute their unused Parallella boards to the cause.</li>
					<li><b>Scientists</b> put in requests to use supercomputer.io.</li>
				</ol>
			</div>
		</div>
		<div class='row'>
			<div class='col-xs-4 col-xs-offset-4'>
				<!-- Cool diagram goes here -->
			</div>
			<hr class='col-xs-10 col-xs-offset-1'>
		</div>
		<div class='row'>
			<div class='col-xs-12 text-center project-description'>
				<h1 class='landing-h'>Our numbers are growing. Join us!</h1>
			</div>
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
			<hr class='col-xs-10 col-xs-offset-1'>
		</div>
		<div class='row' id='participate'>
			<div class='col-xs-12 text-center project-description'>
				<h1 class='landing-h'>How to participate</h1>
			</div>
		</div>
		<div class='row text-center'>
			<div class='col-sm-4'>
				<div class='row'>
					<p class='step-title'>Step 1</p>
				</div>
				<div class='row box-step'>
					<div class='well'>
						<button class='btn btn-landing-green btn-block' id='open-download-btn' ng-click='openDownloadModal()'>Download</button>
					</div>
					<div class='step-description'>
						Download the OS image
					</div>
				</div>
			</div>
			<div class='col-sm-4'>
				<div class='row'>
					<p class='step-title'>Step 2</p>
				</div>
				<div class='row box-step'>
					<div class='well'>
						<div class='row'>
							<img src='/img/sdcard.png'>
						</div>
						<div class='row'>
							<div class='col-sm-8 col-sm-offset-2'>
								<a class='btn btn-primary btn-block' href="#/install">Instructions</a>
							</div>
						</div>
					</div>
					<div class='step-description'>
						Write OS to SD card
					</div>
				</div>
			</div>
			<div class='col-sm-4'>
				<div class='row'>
					<p class='step-title'>Step 3</p>
				</div>
				<div class='row box-step'>
					<div class='well'>
						<img src='/img/plug-parallella.jpg'>
					</div>
					<div class='step-description'>
						Power up your board
					</div>
				</div>

			</div>
		</div>
	</div>
</div>
