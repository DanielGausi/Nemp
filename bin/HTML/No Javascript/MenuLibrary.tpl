<div class="browsemenu">
		
<ul class="browsemenu">
	<li class="{{ArtistClass}}"><a href="library?mode=artist&amp;l=a">Artists</a></li>
	<li class="{{AlbumClass}}"><a href="library?mode=album&amp;l=a">Albums</a></li>
	<li class="{{GenreClass}}"><a href="library?mode=genre">Genres</a></li>
</ul>
<form action="/search" method="get">
			Search <input class="text" type="text" name="query" size=30 maxlength=100 value="{{SearchString}}">
			<input type="submit" value="ok" class="button">		
</form>
{{BrowseSubmenu}}
</div>