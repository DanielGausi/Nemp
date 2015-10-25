{

    Unit Lyrics

    a class for downloading Lyrics from http://lyrics.wikia.com
    The API of this site is down, so we need to parse the html-code

    This class uses some ideas from "unit Interpret", (c) Bergmann89,
    which is used in his "MP3Updater".
    However, my intended use is a bit different, so I have rewritten
    the code completely. But ... all the ideas are belong to Bergmann89 :D

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2005-2010, Daniel Gaussmann
    http://www.gausi.de
    mail@gausi.de
    ---------------------------------------------------------------
    This program is free software; you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by the
    Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful, but
    WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
    for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin St, Fifth Floor, Boston, MA 02110, USA

    See license.txt for more information

    ---------------------------------------------------------------
}

unit Lyrics;

interface

uses Windows, Contnrs, Sysutils,  Classes, dialogs, Messages, StrUtils,
     //Indys:
     IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
     IdStack, IdException;

  type
      TTitle = class
          private
              fTitle: String;
              fLink: String;
          public
              constructor Create(aTitle, aLink: String);
      end;

      TLyrics = class
          private
              fIdHttp: TIdHttp;
              fInterpret: String;  // the current artist we are searching for
              fTitle: String;      // the current title we are searching for
              fTitleList: TObjectList;   // List of all titles for the current artist
              fCurrentLyrics: String;
              fExceptionOccured: Boolean;

              function DownloadCode(Source: String): String;

              // Get the HTML-Code and parse it
              function GetLyricsFromURL(aURL: String): Boolean;

              // if this fails: Get all titles for the artist
              procedure GetAllTitlesFromArtist;
              procedure AddAllTitlesFromAlbum(AlbumCode: String);
              // ... and get the best matching title
              function GetBestTitle: TTitle;

          public
              constructor Create;
              destructor Destroy; override;
              property ExceptionOccured: Boolean read fExceptionOccured;

              // main method of the class
              // everything else is done in the subroutines
              function GetLyrics(aInterpret, aTitle: String): String;
      end;

implementation

uses HtmlHelper;

{ Get the Minimum of 3 Integers}

function min3(a, b, c: Integer): Integer;
begin
  result := a;
  if b < result then result := b;
  if c < result then result := c;
end;

{ Compute the Edit/Levenshtein-Distance by dynamic-programming  }

function LevenshteinDistance(const AText, AOther: String): Integer;
var i, im, n, m: Integer;
    C: Array of Integer;
    pC, nC: Integer;
begin
  n := length(AText);
  m := length(AOther);

  if m = 0 then
      result := n
  else begin
      setlength(C, m+1);
      for i := 0 to m do C[i] := i;

      for i := 1 to n do
      begin
          pC := i-1;
          nC := i;
          for im  := 1 to m do
          begin
              if AText[i] = AOther[im] then
                  nC := pC
              else
                  nC := 1 + min3(nC, pC, C[im]);
              pC := C[im];
              C[im] := nC;
          end;
      end;
      result := C[m];
  end;
end;


{ TTitle }

{
    --------------------------------------------------------
    Constructor TTitle.Create
    - replace stuff entities like '&amp;' in the title
    - store title lowercase
    - add website-adress to intenal link
    --------------------------------------------------------
}
constructor TTitle.Create(aTitle, aLink: String);
begin
    fTitle := ReplaceGeneralEntities(aTitle);
    fTitle := AnsiLowerCase(fTitle);
    fLink  := 'http://lyrics.wikia.com' + aLink;
end;

{ TLyrics }

constructor TLyrics.Create;
begin
    inherited;
    fIdHTTP := TIdHTTP.Create;
    fIDHttp.ConnectTimeout:= 5000;
    fIDHttp.ReadTimeout:= 5000;
    fIDHttp.Request.UserAgent := 'Mozilla/3.0';
    fIDHttp.HTTPOptions :=  [hoForceEncodeParams];
    fTitleList := TObjectList.Create;
end;

destructor TLyrics.Destroy;
begin
    fTitleList.Free;
    fIdHTTP.Free;
    inherited;
end;

{
    --------------------------------------------------------
    GetLyrics (Main Method)
    - try to get the lyrics directly
      or try to get it through the artist-page
    --------------------------------------------------------
}
function TLyrics.GetLyrics(aInterpret, aTitle: String): String;
var LyricQuery: String;
    Success: Boolean;
    bestTitle: TTitle;
begin
    fExceptionOccured := False;
    fInterpret := aInterpret;
    fTitle := aTitle;
    fCurrentLyrics := '';
    fTitleList.Clear;

    // build proper URL
    // october 2016: + 'wiki/'
    LyricQuery := 'http://lyrics.wikia.com/wiki/'
                        + StringToURLStringAND(UTF8Encode(WordUppercase(fInterpret)))
                  + ':' + StringToURLStringAND(UTF8Encode(WordUppercase(fTitle)));
    // Try to get Lyrics from this URL
    Success := GetLyricsFromURL(LyricQuery);
    if Success then
        result := fCurrentLyrics
    else
    begin
        // try something else:
        // Get all titles for this Artist from the artist-page
        GetAllTitlesFromArtist;
        // search for the current title in the titlelist
        bestTitle := GetBestTitle;
        // if there is a "best title"
        if assigned(bestTitle) then
        begin
            // try to download it
            Success := GetLyricsFromURL(bestTitle.fLink);
            if Success then
                result := fCurrentLyrics
            else
                result := '';
        end else
            result := '';
    end;
end;

{
    --------------------------------------------------------
    DownloadCode
    - download a URL
      dont show any exceptions
    --------------------------------------------------------
}
function TLyrics.DownloadCode(Source: String): String;
begin
    try
        result := fIdHTTP.Get(Source);
    except
        on E: EIdSocketError do
        begin
            fExceptionOccured := True;
            result := '';
        end
        else
            result := '';
    end;
end;

{
    --------------------------------------------------------
    GetAllTitlesFromArtist
    - download the Artist-Page
    - split it into "album-parts"
    - add albummtracks to titlelist
    --------------------------------------------------------
}
procedure TLyrics.GetAllTitlesFromArtist;
var ArtistURL: String;
    code, AlbCode: String;
    currentPos, AlbStart, AlbEnd: Integer;
const AlbumHeadline = '<span class="mw-headline">';

begin
    {
    Artist-Page-Design
    ...
    <span class="mw-headline"> [...album-titel, cover,...]
    <ol>
        [Titles of the album]
    </ol>
    ...
    }
    ArtistURL := 'http://lyrics.wikia.com/'
                        + StringToURLStringAND(UTF8Encode(WordUppercase(fInterpret)));
    code := DownloadCode(ArtistURL);

    // find first album-Headline
    currentPos := Pos(AlbumHeadline, code);
    // while we have another album
    while currentPos <> 0 do
    begin
        AlbStart := PosEx('<ol>', code, currentPos);
        AlbEnd   := PosEx('</ol>', code, currentPos);
        if (AlbStart > 0) and (AlbEnd > 0) then
        begin
            AlbStart := AlbStart + 4;
            AlbCode := copy(code, AlbStart, AlbEnd - AlbStart);
            // we have seperated an album - parse it and add its titles to the list
            AddAllTitlesFromAlbum(AlbCode);
        end;
        currentPos := PosEx(AlbumHeadline, code, currentPos + 10);
    end;
end;


{
    --------------------------------------------------------
    AddAllTitlesFromAlbum
    - search for something like
      <a href="/Amy_Macdonald:Spark" title="Amy Macdonald:Spark">Spark</a>
      and get link and name from this string
    --------------------------------------------------------
}
procedure TLyrics.AddAllTitlesFromAlbum(AlbumCode: String);
var currentPos: Integer;
    href, name: String;
    a,b: Integer;
    newTitle: TTitle;
const LinkBegin = '<a href="';
begin
    currentPos := Pos(LinkBegin, AlbumCode);
    while currentPos <> 0 do
    begin
        // Get link
        a := currentPos + Length(LinkBegin); // there should be the "/" from the link
        b := PosEx('"', AlbumCode, a);       // closing " from href
        href := copy(AlbumCode, a, b-a);
        // get name
        a := PosEx('>', AlbumCode, a) + 1;   // first char of the title
        b := PosEx('</a>', AlbumCode, a);    // closing tag
        name := copy(AlbumCode, a, b-a);
        // create a new TTitle-Object and add it to the list
        newTitle := TTitle.Create(name, href);
        fTitleList.Add(newTitle);
        // Get next Link
        currentPos := PosEx(LinkBegin, AlbumCode, currentPos + 10);
    end;
end;

{
    --------------------------------------------------------
    GetBestTitle
    - Search in the title-list the best title
      (levenshtein-distance 1 or lower)
    --------------------------------------------------------
}
function TLyrics.GetBestTitle: TTitle;
var i: integer;
    bestValue, bestIndex, currentValue: Integer;
    lowerCaseTitle: String;
    allowedError: Integer;

begin
    bestValue := High(Integer);
    bestIndex := -1;
    lowerCaseTitle := AnsiLowerCase(fTitle);

    for i := 0 to fTitleList.Count - 1 do
    begin
        currentValue := LevenshteinDistance(TTitle(fTitleList[i]).fTitle, lowerCaseTitle);
        if currentValue < bestValue then
        begin
            bestValue := currentValue;
            bestIndex := i;
        end;
    end;

    if length(fTitle) > 5 then
        allowedError := 1
    else
        allowedError := 0;

    if (bestValue <= allowedError) and (bestIndex >= 0) then
    begin
        result := TTitle(fTitleList[bestIndex]);
    end else
        result := Nil;
end;


{
    --------------------------------------------------------
    GetLyricsFromURL
    - Download an URL
      try to get the LyricBox from the code
    --------------------------------------------------------
}
function TLyrics.GetLyricsFromURL(aURL: String): Boolean;
var code: String;
    lStart, LEnd, i: Integer;
    rawLyrics, charcode, newline: String;
    sl: TStringList;
    a,b, c: Integer;
const LyricBox = '<div class=''lyricbox''>';
      ScriptEnd = '</script>';

begin
    code := DownloadCode(aURL);
    if code = '' then
        result := false
    else
    begin
        (*
        // parse it
        // current design of the site:
        {
        <div class='lyricbox'>
              <div> ... some ringtone advertising
              </div>
              lalalala (the lyrics)
              <!-- some stuff
              <div> ... some ringtone advertising
              </div>
        </div>
        }
        // search for <div class=''lyricbox''>
        lStart := Pos(LyricBox, code);
        if lStart > 0 then
            // ... the closing </div> of the advertising-box
            lStart := PosEx('</div>', code, lStart + Length(LyricBox));
        if lStart > 0 then
            // inc Start, so at Start is the first interesting letter
            lStart := lStart + length('</div>');
        // search for the "end marker"
        if lStart > 0 then
            lEnd := PosEx('<!--', code, lStart)
        else
            lEnd := 0;
        *)

        // changes october, 2015
        // <div class='lyricbox'><script> ...
        // ... </script>
        // LYRICS
        // <!--

        // search for <div class=''lyricbox''>
        lStart := Pos(LyricBox, code);
        if lStart > 0 then
            // ... the closing tag of the script
            lStart := PosEx(ScriptEnd, code, lStart + Length(LyricBox));
        if lStart > 0 then
            // inc Start, so at Start is the first interesting letter
            lStart := lStart + length(ScriptEnd);
        // search for the "end marker"
        if lStart > 0 then
            lEnd := PosEx('<!--', code, lStart)
        else
            lEnd := 0;


        if (lStart > 0) and (lEnd > 0) then
        begin
            // copy the matching part into a string
            rawLyrics := Copy(code, lStart, lEnd - lStart);
            // Replace HTML Linebreaks with normal ones
            rawLyrics := StringReplace(rawLyrics, '<br />', #13#10, [rfReplaceAll]);

            sl := TStringList.Create;
            try
                // put the text into a StringList, line by line
                sl.Text := rawLyrics;
                for i := 0 to sl.count - 1 do
                begin
                    c := 1;
                    newline := '';
                    // for each line translate the &#111;-stuff into normal chars
                    while c < length(sl[i]) do
                    begin
                        a := PosEx('&#', sl[i], c) + 2;
                        b := PosEx(';',  sl[i], a+2) ;
                        if (a > 2) and (b > 3) then
                        begin
                            charcode := copy(sl[i], a, b - a);
                            newline := newline + chr(StrToIntDef(charcode, Ord('?')));
                            c := b;
                        end else
                            c := length(sl[i]) + 1;
                    end;
                    sl[i] := newLine;
                end;
                // Set Self.fCurrentLyrics to our parsed text
                fCurrentLyrics := sl.Text;
                // Success :D
                result := True;
            finally
              sl.Free;
            end;
        end
        else
            // no lyric-Box found :(
            result := False;
    end;
end;

end.
