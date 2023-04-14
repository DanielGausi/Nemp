<div class="mainitem">	
	<div class="textcontainer">
		<p class="maininfo">	
			<a class="fileartist" title="Show all titles of this artist" href="library?mode=artist&amp;id={{ArtistID}}">{{Artist}} <img src="images/search.png" width="16" height="16" alt="search"></a><br>	
			<span class="filetitle">{{Title}}</span><br>
			<span class="fileduration">{{Duration}}</span>
		</p>
		<p class="playlistinfo">
			Position in playlist: {{Index}}
			<span class="{{PrebookClass}}"><br>Position in prebook list: {{PrebookIndex}}*</span>
		</p>
		<p class="additionalinfo">
			<a class="album" title="Show all titles on this album" href="library?mode=album&amp;id={{AlbumID}}">Album: {{Album}} <img src="images/search.png" width="16" height="16" alt="search"></a><br>	
			<a class="genre" title="Show all titles of this genre" href="library?mode=genre&amp;id={{GenreID}}">Genre: {{Genre}} <img src="images/search.png" width="16" height="16" alt="search"></a><br>	
			<span class="year">Release Year: {{Year}}</span>
		</p>
		<p class="techinfo">
			<span class="size">{{Size}}mb</span><br>	
			<span class="quality">{{Quality}}, {{Filetype}}</span>
		</p>
		<p class="warning">{{Warning}}</p>
	</div>
	<div class="cover"><img src="cover?id={{CoverID}}" alt="cover art"></div>
	<div style="clear:both;"></div>	
</div>

<div class="controls">
	<div>{{BtnFileDownload}}</div>
	<div>{{BtnFileVote}}</div>
	<div>{{BtnFilePlayNow}}</div>	
</div>

<div class="{{PrebookClass}}">
<p>* Tracks in the so called 'prebook list' will be played next.
</p>
</div>