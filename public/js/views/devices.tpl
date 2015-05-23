<div class='container'>
	<div class='row'>
		<div class='col-sm-8 col-sm-offset-2'>
			<div class="row mac-search-form">
				<form class="form" ng-submit='goToDevice()'>
					<div class='col-sm-9'>
						<input class='mac-input' ng-model='mac' type='text' placeholder="Enter your MAC Address...">
					</div>
					<div class="col-sm-3">
						<button class="btn mac-search-button pull-right" type="submit">SEARCH</button>
					</div>
				</form>
			</div>
			<hr class='horizontal-line'>
			<div class='row' ng-if="device == null && macAddress != ''">
				<div class='col-sm-6 col-sm-offset-2 text-white'>
					<h3>No device yet...</h3>
					<p>Please check you entered the correct MAC Address. Otherwise, the device will appear here after it goes online. It might take a while for the device to download the latest application code.</p>
				</div>
			</div>
			<div class="row" ng-if="device != null">
				<div class='table-header-box'>
					Device
				</div>
				<table class='ui-table table'>
					<thead>
						<tr>
							<th>Status</th>
							<th>MAC Address</th>
							<th>Images processed</th>
							<th>Location</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td ng-show="device.resinDevice.is_online"><i class="device-status__icon glyphicon glyphicon-ok-circle text-success"></i> {{ device.resinDevice.status }}</td>
							<td ng-hide="device.resinDevice.is_online"><i class="device-status__icon glyphicon glyphicon-remove-circle text-danger"></i> Offline<span ng-if="device.resinDevice.last_seen_time"> (last seen: {{ device.resinDevice.last_seen_time | timeAgo }})</span></td>
							<td>{{device.device.macAddress}}</td>
							<td>{{device.device.totalProcessed}}</td>
							<td class='f16'><span class="flag {{ device.device.location.country | lowercase }}"></span>{{device.device.location.city}}, {{device.device.location.country}}</td>

						</tr>
					</tbody>
				</table>
			</div>
			<div class="row" ng-if="device == null">
			</div>
		</div>
	</div>
</div>
