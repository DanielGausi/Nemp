<div ID="js{{ID}}" class="listitem {{Class}}">
	<div class="controls">{{BtnFileVote}}{{BtnFileMoveDown}}{{BtnFileMoveUp}}{{BtnFileDelete}}{{BtnFilePlayNow}}</div>
	<div class="index"><span>{{Index}}</span><span class="{{PrebookClass}}"><br>{{PrebookIndex}}</span></div>		
	<div class="titleinfo" {{Anchor}}><a href="playlist_details?id={{ID}}" title="Show more details about this title"><span class="title">{{Title}}</span>&nbsp;<span class="duration">({{Duration}})</span><br><span class="artist">{{Artist}}</span><br><span class="{{VoteClass}}"><img src="images/votesmall.png" alt="vote">&nbsp;{{Votes}} votes for this track.</span></a>
	{{Progress}}
	</div>	
	<div class="cover">
	<a href="library?mode=album&amp;id={{AlbumID}}" title="Show all titles from this album"><img src="cover?id={{CoverID}}" alt="cover art" height="50"></a></div>	
</div>