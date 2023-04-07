<div class="mainitem">	
	<div class="textcontainer">
		<p class="maininfo">	
			<span class="fileartist">{{Artist}}</span><br>	
			<span class="filetitle">{{Title}}</span><br>
			<span class="fileduration">{{Duration}}</span>
		</p>
		<p class="additionalinfo">
			<span class="album">Album: {{Album}}</span><br>	
			<span class="genre">Genre: {{Genre}}</span><br>	
			<span class="year">Release Year: {{Year}}</span>
		</p>
		
	</div>
	<div class="cover"><img src="cover?id={{CoverID}}" alt="cover art"></div>
	<div style="clear:both;"></div>
	<div class="htmlplayer {{HtmlFileAudioClass}}">	
		{{HtmlFileAudio}}
	</div>
	<div class="playerdownload">
		{{BtnFileDownload}}		
	</div>	
</div>