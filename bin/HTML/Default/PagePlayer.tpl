<div id="jsPlayer" class="player">
{{Menu}}

<div class="playercontrol">	
	<div id="playercontrol">{{PlayerControls}}</div>
	
	<div style="clear:both;"></div>
	
	<div class="volumecontainer">
		<div class="volume">
		<a class="button btnVolDown" onclick="playercontrol_VolumeDown()" title="-"><img src="images/volume-down.png" width="24" height="24" alt="pause"></a>
		</div>
		
		<div class="volume" id="volume"></div>
		
		<div class="volume">
		<a class="button btnVolUp" onclick="playercontrol_VolumeUp()" title="+"><img src="images/volume-up.png" width="24" height="24" alt="pause"></a> 
		</div>
	</div>	

	<div style="clear:both;"></div>
						
	<div class="progresscontainer"><div id="progress"></div></div>		
	
</div>

<div id="playerdata">
	{{ItemPlayer}}
</div>

</div>