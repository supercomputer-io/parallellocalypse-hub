<div class='modal-header'>
	<button type="button" class="close" ng-click="close()">×</button>
	<h3 class='modal-title'>Installation instructions</h3>
</div>
<div class='modal-body'>
	<div class="row">		
		<tabset justified="true">
			<tab heading="Linux">
				<h4>1. Insert the micro-SD card in your regular computer</h4>

				<h4>2. Verify the device path of your SD card</h4>
				<p>The exact device path to your SD card depends on your Linux distribution and computer setup. Using the command below to get the right path. If it’s not clear from output which path is the right one, try the command with and without the SD card inserted. In Ubuntu, the path returned might be something like ‘/dev/mmcblk0p1′.</p>

				<pre>$ df -h</pre>

				<h4>3. Unmount the SD card</h4></h4>
				<p>You will need to unmount all partitions on the SD cards before burning the card. The &lt;sd-partition-path&gt; comes from the ‘df’ command in step 3.</p>

				<pre>$ umount &lt;sd-partition-path&gt;</pre>

				<h4>4. Burn the Ubuntu disk image on the micro-SD card</h4>
				<p>Burn the image onto the SD card using the ‘dd’ utility shown in the command example below. Please be careful and make sure you specify the path correctly as <b>this command is irreversible</b> and will overwrite anything in the path!  An example command in Ubuntu would be: ‘sudo dd bs=4M if=my_release.img of=/dev/mmcblk0′. Please be patient, this could take a while (many minutes) depending on the computer and SD card being used.</p>

				<pre>$ sudo dd bs=4M if=&lt;release-name&gt;.img of=&lt;sd-device-path&gt;</pre>

				<h4>5. Make sure all writes to the SD card have completed</h4>

				<pre>$ sync</pre>
			</tab>
			<tab heading="Mac">
				<h4>1. Insert the micro-SD card in your regular computer:</h4>
				<h4>2. Verify the device path of your SD card:</h4>
				<p>The following command will return the device path to your SD card. You will need to carefully determine from the output which path belongs to the SD card and which path belongs to your regular fixed drive. Please be careful! The ‘dd’ command in step 4 overwrites anything in its path.</p>
				<pre>$ diskutil list</pre>
				<h4>3. Unmount disk</h4>
				<pre>$ diskutil unmountDisk &lt;sd-device-path&gt;</pre>
				<h4>4. Copy the Ubuntu disk image to the micro-SD card</h4>
				<p>Burn the image onto the SD card using the ‘dd’ utility. Please be careful and make sure you specify the path correctly as <b>this action is irreversible!</b> In the terminal write the image to the card with the command below, making sure you replace the input file ‘if=’ argument with the path to your “*.img” file, and the &lt;sd-device-path&gt; in the ‘of=’ with the right device path output from the ‘diskutil’ command in step 2. Please be patient, this could take a while (many minutes) depending on the computer and SD card being used.</p>
				<pre>$ sudo dd if=&lt;release-name&gt;.img of=&lt;sd-device-path&gt; bs=1m</pre>
			</tab>
			<tab heading="Windows">
				<h4>1. Insert the micro-SD card in your regular computer:</h4>
				<h4>2. Burn the Ubuntu disk image to the micro-SD card</h4>
				<p>Use Win32 disk imager or equivalent program to burn the &lt;release-name&gt;.img to the micro-SD card</p>
			</tab>
		</tabset>

	</div>
</div>