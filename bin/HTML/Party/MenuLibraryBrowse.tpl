<div class="browsemenu">
		
<ul class="browsemenu">
	<li class="{{ArtistClass}}"><a href="browse?mode=artist&amp;l=a">Artists</a></li>
	<li class="{{AlbumClass}}"><a href="browse?mode=album&amp;l=a">Albums</a></li>
	<li class="{{GenreClass}}"><a href="browse?mode=genre">Genres</a></li>
</ul>
<form action="library" method="get">
			Search <input class="text" type="text" name="query" size=30 maxlength=100 value="{{SearchString}}">
			<input type="submit" value="ok" class="button">		
</form>
{{BrowseSubmenu}}
</div>