<div class="library">
{{Menu}}
<h2>Nemp: Library</h2>

<form action="/library" method="get">
<table width="100%">
<tr><td>Search for:</td></tr>
<tr><td width="100%"><input class="text" type="text" name="query" size=30 maxlength=100 value="{{SearchString}}"></td></tr>
<tr><td><input type="submit" value="Search" class="button"></td></tr>
</table>
</form>

<h2>Search results for {{SearchString}}: {{SearchCount}}</h2>
<table class="search" cellpadding="0" cellspacing="0">
{{SearchResultItems}}
</table>
</div>
<div style="clear:both;"></div>