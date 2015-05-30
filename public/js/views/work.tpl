<div class="container">
	<div class="row">
		<div class='col-xs-12'>
			<div class='row'>
				<div class='image-progress col-sm-6'>
					<div class='uibox'>
						<div ng-show="authenticated">
							<div ngf-select ngf-drop ngf-accept="'image/*'" ng-model='file'>
								<!--<img ng-if="work.status" ng-src='{{ "/images/" + work.targetImage.original_img }}' class='col-sm-12'>-->
								<div ng-show="!work.status" class='drop-box'>
									<img src="/img/drag-drop.png" style="">
									<div class="instructions">
										<div><h4>drag & drop</h4><br>your image here or <span style="text-decoration: underline">browse</span></div>
									</div>
								</div>
							</div>
						</div>
						<div ng-if='!authenticated && !work.status'>
							<h2>Nothing going on yet. Stay online for when the action begins!</h2>	
						</div>
						<div ng-if="work.status">
							<div class='row'>
								<img ng-src='{{ targetImageUrl }}' class="target-image">
								<div class="progress-loader">
									<h4 ng-show='!result.name'>Searching Database...</h4>
									<h4 ng-show='result.name'>The image is:</h4>
									<img ng-if='!result.name' src="/img/loader.gif" class="loader">
									<h2 ng-if='result.name' class="result-name">{{result.name}}</h2>
									<div class='progress'><div class='progress-bar' ng-style="progress"></div></div>
								</div>
								<img ng-src='{{ targetImageResizedUrl }}' class="target-image result">
								
							</div>
							<div class='row'>
								<div ng-if='result.name'>Elapsed: {{minutes == '00' ? '' : (minutes + ' minutes,') }}{{seconds}} seconds</div>
								<div ng-show="(result.name || work.status == 'Stopped') && authenticated">
									<div ngf-select ngf-drop ngf-accept="'image/*'" ngf-change='uploadFile($files)'><div class='btn btn-success'>Upload another</div></div>
								</div>
								<a ng-if="(!(result.name || work.status == 'Stopped')) && authenticated" class='btn btn-danger' ng-click='stopWork()' >Stop</a>

							</div>
						</div>
					</div>
				</div>
				<div class='online-devices col-sm-3'>
					<div class='uibox'>
						<h4>Devices Online</h4>
						<div class='number-in-box'>
							<h1>{{numDevices || 0 | number}}</h1>
						</div>
					</div>
				</div>
				<div class='images-per-device col-sm-3'>
					<div class='uibox'>
						<h4>Images per device</h4>
						<div class='number-in-box'>
							<h1>{{work.chunkSize || 0 | number}}</h1>
						</div>
					</div>
				</div>
			</div>
			<div class='row'>
				<div class='work-progress col-sm-7'>
					<div class='uibox'>
						<div class="title">Devices</div>
						<div class="container matrix-box">
							<div class="span12 matrix">
								<div ng-repeat='(key, val) in chunks' class='device-box {{chunkStyle[key]}}'></div>
							</div>
							<hr class="separator">
							<div class="legends">
								<div class="legend"><span class="device-box"></span><span class="text">Unassigned</span></div>
								<div class="legend"><span class="device-box assigned"></span><span class="text">Assigned</span></div>
								<div class="legend"><span class="device-box solved"></span><span class="text">Solved</span></div>
							</div>
						</div>
					</div>
				</div>
				<div class='locations col-sm-5'>
					<div class='uibox'>
						<div class="title">Locations</div>
						<div class="world-map">
							<ui-gmap-google-map center='map.center' zoom='map.zoom'>
								<ui-gmap-circle ng-repeat='marker in markers' center='marker.center'
								                radius='100000'
								                fill='marker.fill'
								                stroke='marker.stroke'
								        >

								</ui-gmap-circle>
							</ui-gmap-google-map>
						</div>
						<table class="device-stats hidden">
							<tr><th>Location</th><th>Devices</th></tr>
							<tr ng-repeat="(countryState, device) in countryDevices" class="content f16">
								<td><span class="flag {{device.country | lowercase}}"></span>{{countryState}}</td><td>{{device.count}}</td>
							</tr>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
