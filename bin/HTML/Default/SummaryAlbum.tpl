<div class="summary">	
<div class="info">
<p class="maininfo">
	<span class="lineartist">{{Artist}}</span><br>
	<span class="linealbum">{{Album}}</span>
</p>
<p>
	<span class="count">{{Count}} Tracks, {{Duration}}</span><br>
	<span class="genre">Genre: {{Genre}}</span><br>	
	<span class="year">Release Year: {{Year}}</span>
</p>
</div>
<div class="cover"><img src="cover?id={{CoverID}}" alt="cover art"></div>
<div style="clear:both;"></div>

<div class="PlaylistPlayer">
<audio id="htmlaudioplaylist" controls>		
<source id="PlaylistSource" src="test.mp3?id=18713&amp;action=file_stream" type="audio/mpeg">
</audio>
</div>

</div>