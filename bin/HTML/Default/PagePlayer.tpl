<div id="jsPlayer" class="player {{ClassPlayerStatus}}">
{{Menu}}

<div id="playerdata">
	{{ItemPlayer}}
</div>

<div id="playercontrol">	
	<div class="progresscontainer">
		<!-- <div id="progress" class="{{ClassControls}}"></div>-->
		<input type="range" min="0" max="100" value="0" class="playerslider slider {{ClassControls}}" id="playerprogress">
	</div>
	
	<div class="playerbuttons {{ClassControls}}">
		<a class="button btnplay" onclick="playercontrol_playpause()" title="Play"><img src="images/playback-start.png" width="32" height="32" alt="play"></a>
		<a class="button btnpause" onclick="playercontrol_playpause()" title="Pause"><img src="images/pause.png" width="32" height="32" alt="pause"></a>
		<a class="button btnstop" onclick="playercontrol_stop()" title="Stop playback"><img src="images/playback-stop.png" width="32" height="32" alt="stop"></a>
		<a class="button btnprev" onclick="playercontrol_playprevious()" title="Play the previous title in the playlist"><img src="images/skip-backward.png" width="32" height="32" alt="backward"></a>
		<a class="button btnnext" onclick="playercontrol_playnext()" title="Play the next title in the playlist"><img src="images/skip-forward.png" width="32" height="32" alt="forward"></a>		
	</div>
	
	<div style="clear:both;"></div>
	
	<div class="volumecontainer {{ClassControls}}">
		<div class="volumeup">
			<a class="button btnVolDown" onclick="playercontrol_VolumeDown()" title="-"><img src="images/volume-down.png" width="24" height="24" alt="pause"></a>
		</div>
		
		<div class="volumerange">
			<input type="range" min="0" max="100" value="50" class="volumeslider slider" id="volume">
		</div>
		
		<div class="volumedown">
			<a class="button btnVolUp" onclick="playercontrol_VolumeUp()" title="+"><img src="images/volume-up.png" width="24" height="24" alt="pause"></a> 
		</div>
	</div>	

	<div style="clear:both;"></div>
</div>



</div>