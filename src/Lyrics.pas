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
    Copyright (C) 2005-2019, Daniel Gaussmann
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

uses Windows, Contnrs, Sysutils,  Classes, dialogs, Messages, StrUtils, System.Net.HttpClient ;

  type
      TLyrics = class
          private
              // fInterpret: String;  // the current artist we are searching for
              // fTitle: String;      // the current title we are searching for
              // fCurrentLyrics: String;

              // fExceptionOccured: Boolean;
              // fExceptionMessage: String;

              // Get the HTML-Code and parse it
              //function GetLyrics_Chartlyrics(aInterpret, aTitle: String): Boolean;
              // main method of the class
              // everything else is done in the subroutines
              //function GetLyrics(aInterpret, aTitle: String): String;

          public
              constructor Create;
              destructor Destroy; override;
              // property ExceptionOccured: Boolean read fExceptionOccured;
              // property ExceptionMessage: String read fExceptionMessage;

              class procedure GetLyricSources(dest: TStrings);
              class function GetLyricsURL(SourceIndex: Integer; aInterpret, aTitle: String): String;
      end;


implementation

uses HtmlHelper, Nemp_RessourceStrings;


function BuildURL_ChartLyrics(aInterpret, aTitle: String): String;
begin
    result := 'http://api.chartlyrics.com/apiv1.asmx/SearchLyricDirect?'
                  + 'artist=' + URLEncode_LyricWiki(WordUppercase(aInterpret))
                  + '&song=' + URLEncode_LyricWiki(WordUppercase(aTitle));
end;

function BuildURL_ChartLyricsManual(aInterpret, aTitle: String): String;
begin
    result := 'http://www.chartlyrics.com/search.aspx?q='
                  + URLEncode_ChartLyricsManual(WordUppercase(aInterpret, '+'))
                  + '+' + URLEncode_ChartLyricsManual(WordUppercase(aTitle, '+'));
end;


function RemoveSpaces(source: String): String;
begin
  result := Stringreplace(Source, ' ', '', [rfReplaceAll]);
end;

function RemovePunctuationAndSpace(source: String): String;
begin
  result := Stringreplace(Source, ' ', '', [rfReplaceAll]);
  result := Stringreplace(result, ',', '', [rfReplaceAll]);
  result := Stringreplace(result, ';', '', [rfReplaceAll]);
  result := Stringreplace(result, '.', '', [rfReplaceAll]);
  result := Stringreplace(result, ':', '', [rfReplaceAll]);
end;


function SpacesToPlus(source: String): String;
begin
  result := Stringreplace(Source, ' ', '+', [rfReplaceAll]);
end;

function SearchURL_AZLyricsDirectURL(aInterpret, aTitle: String): String;
begin
  result := 'https://www.azlyrics.com/lyrics/'
    +  URLEncode_LyricWiki(Lowercase(RemovePunctuationAndSpace(aInterpret)))
    + '/' + URLEncode_LyricWiki(Lowercase(RemovePunctuationAndSpace(aTitle))) + '.html';
end;

function SearchURL_AZLyrics(aInterpret, aTitle: String): String;
begin
  result := 'https://search.azlyrics.com/search.php?q='
    + URLEncode_SpaceToPlus(Lowercase(aInterpret))
    + '+' + URLEncode_SpaceToPlus(Lowercase(aTitle));
end;

function SearchURL_Google(aInterpret, aTitle: String): String;
begin
  result := 'https://www.google.com/search?q='
    + URLEncode_SpaceToPlus(Lowercase(aInterpret))
    + '+' + URLEncode_SpaceToPlus(Lowercase(aTitle))
    + '+lyrics';
end;

function SearchURL_Bing(aInterpret, aTitle: String): String;
begin
  result := 'https://www.bing.com/search?q='
    + URLEncode_SpaceToPlus(Lowercase(aInterpret))
    + '+' + URLEncode_SpaceToPlus(Lowercase(aTitle))
    + '+lyrics';
end;

function SearchURL_DuckDuckGo(aInterpret, aTitle: String): String;
begin
  result := 'https://duckduckgo.com/?q='
    + URLEncode_SpaceToPlus(Lowercase(aInterpret))
    + '+' + URLEncode_SpaceToPlus(Lowercase(aTitle))
    + '+lyrics';
end;

{ TLyrics }

constructor TLyrics.Create;
begin
    inherited;
end;

destructor TLyrics.Destroy;
begin
    inherited;
end;


class procedure TLyrics.GetLyricSources(dest: TStrings);
begin
  dest.Clear;
  dest.Add('AZLyrics');
  dest.Add('Google');
  dest.Add('Bing');
  dest.Add('DuckDuckGo');
end;

class function TLyrics.GetLyricsURL(SourceIndex: Integer; aInterpret,
  aTitle: String): String;
begin
  case SourceIndex of
    0: result := SearchURL_AZLyricsDirectURL(aInterpret, aTitle);
    1: result := SearchURL_Google(aInterpret, aTitle);
    2: result := SearchURL_Bing(aInterpret, aTitle);
    3: result := SearchURL_DuckDuckGo(aInterpret, aTitle);
  else
    result := '';
  end;

end;

{
    --------------------------------------------------------
    GetLyrics (Main Method)
    (removed)
    --------------------------------------------------------
}
(*
function TLyrics.GetLyrics(aInterpret, aTitle: String): String;
var Success: Boolean;
begin
    fInterpret := aInterpret;
    fTitle := aTitle;
    fCurrentLyrics := '';
    success := False;

    fExceptionOccured := False;
    fExceptionMessage := '';

    /// ----------
    // Do some stuff (removed)
    /// ----------

    if Success then
        result := fCurrentLyrics
    else
        result := '';
end;*)


{
    --------------------------------------------------------
    GetLyrics_Chartlyrics
    --------------------------------------------------------
}
(*
function TLyrics.GetLyrics_Chartlyrics(aInterpret, aTitle: String): Boolean;
var code, rawLyrics, aURL: String;
    lStart, LEnd: Integer;

const LyricStart = '<Lyric>';
      LyricsEnd = '</Lyric>';
begin
    aURL := BuildURL_ChartLyrics(aInterpret, aTitle);
    try
        code := GetURLAsString(aURL);
        if code = '' then
            result := false
        else
        begin
            // parse code and get lyrics
            lStart := Pos(LyricStart, code);
            if lStart > 0 then
                // inc Start, so at Start is the first interesting letter
                lStart := lStart + length(LyricStart);

            // search for the "end marker"
            if lStart > 0 then
                lEnd := PosEx(LyricsEnd, code, lStart)
            else
                lEnd := 0;

            if (lStart > 0) and (lEnd > 0) then
            begin
                // copy the matching part into a string
                rawLyrics := Copy(code, lStart, lEnd - lStart);
                fCurrentLyrics := ReplaceGeneralEntities(rawLyrics);
                result := True;
            end
            else
                // no Lyric-Tags found :(
                result := False;
        end;
    except
        on E: ENetHTTPClientException do
        begin
            result := false;
            fExceptionOccured := True;
            fExceptionMessage := Format(HTTP_Connection_Error, [GetDomainFromURL(aURL), E.Message]);
        end;
    end;
end;
*)

end.
