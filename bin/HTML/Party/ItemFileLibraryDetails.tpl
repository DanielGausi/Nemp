<div class="fileinfo">	
<div class="info">
<p class="maininfo">	
	<a class="button lineartist" title="Show all titles of this artist" href="library?mode=artist&amp;id={{ArtistID}}">{{Artist}} <img src="images/search.png" width="16" height="16" alt="search"></a><br>	
	<span class="linetitle">{{Title}}</span><br>
	<span class="count">{{Duration}}</span>
</p>
<p class="moreinfo">
	<a class="button linealbum" title="Show all titles on this album" href="library?mode=album&amp;id={{AlbumID}}">Album: {{Album}} <img src="images/search.png" width="16" height="16" alt="search"></a><br>	
	<a class="button genre" title="Show all titles of this genre" href="library?mode=genre&amp;id={{GenreID}}">Genre: {{Genre}} <img src="images/search.png" width="16" height="16" alt="search"></a><br>	
	<span class="year">Release Year: {{Year}}</span>
</p>
<p class="techinfo">
	<span class="size">{{Size}}mb</span><br>	
	<span class="quality">{{Quality}}, {{Filetype}}</span>
</p>
<p class="htmlplayer">	
	{{HtmlFileAudio}}
</p>
<p class="warning">{{Warning}}</p>
</div>
<div class="cover"><img src="cover?id={{CoverID}}" alt="cover art"></div>
<div style="clear:both;"></div>
</div>

<div class="controls">
	{{BtnFileDownload}}	<br>
	{{BtnFileVote}}	
</div>