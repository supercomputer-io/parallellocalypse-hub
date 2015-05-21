<div class="container">
	<div class="row">
		<div class="col-xs-12">
			<div class="col-sm-6 col-sm-offset-1">
				<div class='download-form'>
					<form class="form form-horizontal" action="{{downloadUrl}}" method="get">
						<div class="form-group">
							<label class="col-sm-5 control-label">Network connection:</label>
							<div class="col-sm-7">
								<label class="radio-inline">
									<input type="radio" name="network" value="ethernet" ng-model="parallella.networkConfig.type"> Ethernet cable
								</label>
								<label class="radio-inline">
									<input type="radio" name="network" value="wifi" ng-model="parallella.networkConfig.type"> Wireless LAN
								</label>
							</div>
						</div>
						<div ng-show="parallella.networkConfig.type == 'wifi'" class="ng-hide">
							<div class="form-group">
								<label class="col-sm-5 control-label">SSID:</label>
								<div class="col-sm-7">
									<input class="form-control" name="wifiSsid" ng-model="parallella.networkConfig.wifiSsid">
								</div>
							</div>
							<div class="form-group">
								<label class="col-sm-5 control-label">Passphrase:</label>
								<div class="col-sm-7">
									<div class="input-group">
										<input show-password="" class="form-control" type="password" name="wifiKey" ng-model="parallella.networkConfig.wifiKey">
									</div>
								</div>
							</div>
						</div>
						<hr class='horizontal-line'/>
						
						<div class="form-group">
							<label class="col-sm-5 control-label">Processor:</label>
							<div class="col-sm-7">
								<select name="processorType" ng-model='parallella.processorType' class="form-control">
									<option value="Z7010" class="">Z7010</option>
									<option value="Z7020" class="">Z7020</option>
								</select>
							</div>
						</div>

						<div class="form-group">
							<label class="col-sm-5 control-label">Coprocessor cores:</label>
							<div class="col-sm-7">
								<select name="coprocessorCore" ng-model='parallella.coprocessorCore' class="form-control">
									<option value="16" class="">16</option>
									<option value="64"  ng-if="parallella.processorType == 'Z7020'" class="">64</option>
								</select>
							</div>
						</div>
						<div class="form-group">
							<div class="col-sm-7 col-sm-offset-5 checkbox">
								<label>
									<input type="checkbox" name="hdmi" ng-model='parallella.hdmi' value="1"> HDMI
								</label>
							</div>
						</div>
						<div class="form-group">
							<div class="col-sm-offset-5 col-sm-7">
								<button class="btn btn-primary btn-block" type="submit">  Download OS File  <span ng-show="::downloadSize">(~1.4 GB)</span></button>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>
