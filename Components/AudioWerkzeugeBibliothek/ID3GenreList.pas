unit ID3GenreList;

interface

uses classes;

var
  ID3Genres: TStringList;

implementation


initialization

  ID3Genres := TStringList.Create;
  ID3Genres.CaseSensitive := False;
  // Standard-Genres (ID3v1 Standard)
  ID3Genres.Add('Blues');
  ID3Genres.Add('Classic Rock');
  ID3Genres.Add('Country');
  ID3Genres.Add('Dance');
  ID3Genres.Add('Disco');
  ID3Genres.Add('Funk');
  ID3Genres.Add('Grunge');
  ID3Genres.Add('Hip-Hop');
  ID3Genres.Add('Jazz');
  ID3Genres.Add('Metal');
  ID3Genres.Add('New Age');
  ID3Genres.Add('Oldies');
  ID3Genres.Add('Other');
  ID3Genres.Add('Pop');
  ID3Genres.Add('R&B');
  ID3Genres.Add('Rap');
  ID3Genres.Add('Reggae');
  ID3Genres.Add('Rock');
  ID3Genres.Add('Techno');
  ID3Genres.Add('Industrial');
  ID3Genres.Add('Alternative');
  ID3Genres.Add('Ska');
  ID3Genres.Add('Death Metal');
  ID3Genres.Add('Pranks');
  ID3Genres.Add('Soundtrack');
  ID3Genres.Add('Euro-Techno');
  ID3Genres.Add('Ambient');
  ID3Genres.Add('Trip-Hop');
  ID3Genres.Add('Vocal');
  ID3Genres.Add('Jazz+Funk');
  ID3Genres.Add('Fusion');
  ID3Genres.Add('Trance');
  ID3Genres.Add('Classical');
  ID3Genres.Add('Instrumental');
  ID3Genres.Add('Acid');
  ID3Genres.Add('House');
  ID3Genres.Add('Game');
  ID3Genres.Add('Sound Clip');
  ID3Genres.Add('Gospel');
  ID3Genres.Add('Noise');
  ID3Genres.Add('AlternRock');
  ID3Genres.Add('Bass');
  ID3Genres.Add('Soul');
  ID3Genres.Add('Punk');
  ID3Genres.Add('Space');
  ID3Genres.Add('Meditative');
  ID3Genres.Add('Instrumental Pop');
  ID3Genres.Add('Instrumental Rock');
  ID3Genres.Add('Ethnic');
  ID3Genres.Add('Gothic');
  ID3Genres.Add('Darkwave');
  ID3Genres.Add('Techno-Industrial');
  ID3Genres.Add('Electronic');
  ID3Genres.Add('Pop-Folk');
  ID3Genres.Add('Eurodance');
  ID3Genres.Add('Dream');
  ID3Genres.Add('Southern Rock');
  ID3Genres.Add('Comedy');
  ID3Genres.Add('Cult');
  ID3Genres.Add('Gangsta');
  ID3Genres.Add('Top 40');
  ID3Genres.Add('Christian Rap');
  ID3Genres.Add('Pop/Funk');
  ID3Genres.Add('Jungle');
  ID3Genres.Add('Native American');
  ID3Genres.Add('Cabaret');
  ID3Genres.Add('New Wave');
  ID3Genres.Add('Psychadelic');
  ID3Genres.Add('Rave');
  ID3Genres.Add('Showtunes');
  ID3Genres.Add('Trailer');
  ID3Genres.Add('Lo-Fi');
  ID3Genres.Add('Tribal');
  ID3Genres.Add('Acid Punk');
  ID3Genres.Add('Acid Jazz');
  ID3Genres.Add('Polka');
  ID3Genres.Add('Retro');
  ID3Genres.Add('Musical');
  ID3Genres.Add('Rock & Roll');
  ID3Genres.Add('Hard Rock');

  // WinAmp-genres
  ID3Genres.Add('Folk');
  ID3Genres.Add('Folk-Rock');
  ID3Genres.Add('National Folk');
  ID3Genres.Add('Swing');
  ID3Genres.Add('Fast Fusion');
  ID3Genres.Add('Bebob');
  ID3Genres.Add('Latin');
  ID3Genres.Add('Revival');
  ID3Genres.Add('Celtic');
  ID3Genres.Add('Bluegrass');
  ID3Genres.Add('Avantgarde');
  ID3Genres.Add('Gothic Rock');
  ID3Genres.Add('Progessive Rock');
  ID3Genres.Add('Psychedelic Rock');
  ID3Genres.Add('Symphonic Rock');
  ID3Genres.Add('Slow Rock');
  ID3Genres.Add('Big Band');
  ID3Genres.Add('Chorus');
  ID3Genres.Add('Easy Listening');
  ID3Genres.Add('Acoustic');
  ID3Genres.Add('Humour');
  ID3Genres.Add('Speech');
  ID3Genres.Add('Chanson');
  ID3Genres.Add('Opera');
  ID3Genres.Add('Chamber Music');
  ID3Genres.Add('Sonata');
  ID3Genres.Add('Symphony');
  ID3Genres.Add('Booty Bass');
  ID3Genres.Add('Primus');
  ID3Genres.Add('Porn Groove');
  ID3Genres.Add('Satire');
  ID3Genres.Add('Slow Jam');
  ID3Genres.Add('Club');
  ID3Genres.Add('Tango');
  ID3Genres.Add('Samba');
  ID3Genres.Add('Folklore');
  ID3Genres.Add('Ballad');
  ID3Genres.Add('Power Ballad');
  ID3Genres.Add('Rhythmic Soul');
  ID3Genres.Add('Freestyle');
  ID3Genres.Add('Duet');
  ID3Genres.Add('Punk Rock');
  ID3Genres.Add('Drum Solo');
  ID3Genres.Add('A capella');
  ID3Genres.Add('Euro-House');
  ID3Genres.Add('Dance Hall');
  // some more genres, source: http://www.steffen-hanske.de/mp3_genre.htm
  ID3Genres.Add('Goa');
  ID3Genres.Add('Drum & Bass');
  ID3Genres.Add('Club-House');
  ID3Genres.Add('Hardcore');
  ID3Genres.Add('Terror');
  ID3Genres.Add('Indie');
  ID3Genres.Add('BritPop');
  ID3Genres.Add('Negerunk');
  ID3Genres.Add('Polsk Punk');
  ID3Genres.Add('Beat');
  ID3Genres.Add('Christian Gangsta Rap');
  ID3Genres.Add('Heavy Metal');
  ID3Genres.Add('Black Metal');
  ID3Genres.Add('Crossover');
  ID3Genres.Add('Contemporary Christian');
  ID3Genres.Add('Christian Rock');
  ID3Genres.Add('Merengue');
  ID3Genres.Add('Salsa');
  ID3Genres.Add('Trash Metal');
  ID3Genres.Add('Anime');
  ID3Genres.Add('JPop');
  ID3Genres.Add('Synthpop');

finalization

 ID3Genres.Free;

end.
