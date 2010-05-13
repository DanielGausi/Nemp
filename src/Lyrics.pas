{

    Unit Lyrics

    a class for downloading Lyrics from http://lyrics.wikia.com
    The API of this site is down, so we need to parse the html-code

    This class is based on "unit Interpret" from Bergmann89, which is used in
    his "MP3Updater".

    Note: This class here is designed to work completely in a secondary Thread.
          It should be created and destroyed there, not in the VCL.

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

uses Windows, Contnrs, Sysutils,  Classes,
     dialogs, Messages, Nemp_ConstantsAndTypes, Hilfsfunktionen,
     StrUtils, Nemp_RessourceStrings,

     //Indys:
     IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP;

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

              // Get the HTML-Code and parse it
              function GetLyricsFromURL(aURL: AnsiString): Boolean;

              // try to get lyrics directly via "http://lyrics.wikia.com/<Interpret>:<Title>"
              function GetLyricsDirect: String;

              // if this fails: Get all titles for the artist
              procedure GetAllTitlesFromArtist;
              // ... and get the best matching title
              function GetBestTitle: TTitle;

          public
              constructor Create;
              destructor Destroy; override;

              // main method of the class
              function GetLyrics(aInterpret, aTitle: String): String;
      end;

implementation

{ TTitle }

constructor TTitle.Create(aTitle, aLink: String);
begin
    fTitle := aTitle;
    fLink  := aLink;
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
    GetLyrics
    - Main Method
    --------------------------------------------------------
}
function TLyrics.GetLyrics(aInterpret, aTitle: String): String;
var LyricQuery: String;
    Success: Boolean;
begin
    fInterpret := aInterpret;
    fTitle := aTitle;
    fCurrentLyrics := '';
    fTitleList.Clear;
    // think positive :D
    Success := True;

    // build proper URL
    LyricQuery := 'http://lyrics.wikia.com/'
                        + StringToURLStringAND(UTF8Encode(WordUppercase(fInterpret)))
                  + ':' + StringToURLStringAND(UTF8Encode(WordUppercase(fTitle)));
    // Try to get Lyrics from this URL
    Success := GetLyricsFromURL(LyricQuery);
    if Success then
        result := fCurrentLyrics
    else
    begin
        // try something else
    end;
end;


procedure TLyrics.GetAllTitlesFromArtist;
begin

end;

function TLyrics.GetBestTitle: TTitle;
begin

end;


function TLyrics.GetLyricsDirect: String;
begin

end;

{
    --------------------------------------------------------
    GetLyricsFromURL
    - Download an URL
      try to get the LyricBox from the code
    --------------------------------------------------------
}
function TLyrics.GetLyricsFromURL(aURL: AnsiString): Boolean;
var code: String;
    lStart, LEnd, i: Integer;
    rawLyrics, charcode, newline: String;
    sl: TStringList;
    a,b, c: Integer;
const LyricBox = '<div class=''lyricbox''>';

begin
    try
        code := fIdHTTP.Get(aURL);
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
            lEnd := PosEx('<!--', code, lStart);

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
    except
        // Some Indy-Exception, probably 404 or stuff...
        result := False;
    end;
end;

end.
