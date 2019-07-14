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

const COUNT_LYRIC_SEARCH_METHODS = 2;

  type
      {TTitle = class
          private
              fTitle: String;
              fLink: String;
          public
              constructor Create(aTitle, aLink: String);
      end;}

      TLyricFunctionsEnum = (LYR_NONE, LYR_LYRICWIKI, LYR_CHARTLYRICS);
      TLyricGetFunction = function(aInt, aTitle: String): Boolean of object;
      TLyricGetFunctions = Array[1..COUNT_LYRIC_SEARCH_METHODS] of TLyricGetFunction;


      TLyrics = class
          private
              fInterpret: String;  // the current artist we are searching for
              fTitle: String;      // the current title we are searching for
              fCurrentLyrics: String;

              fExceptionOccured: Boolean;
              fExceptionMessage: String;

              fLyricGetFunctions: TLyricGetFunctions;

              // Get the HTML-Code and parse it
              function GetLyrics_LyricWiki(aInterpret, aTitle: String): Boolean;
              function GetLyrics_Chartlyrics(aInterpret, aTitle: String): Boolean;
              // a Dummy-function
              function GetLyrics_Dummy(aInterpret, aTitle: String): Boolean;

          public
              constructor Create;
              destructor Destroy; override;
              property ExceptionOccured: Boolean read fExceptionOccured;
              property ExceptionMessage: String read fExceptionMessage;

              // main method of the class
              // everything else is done in the subroutines
              function GetLyrics(aInterpret, aTitle: String): String;

              procedure SetLyricSearchPriorities(aFirst, aSecond: TLyricFunctionsEnum);

              // temporary only
              // for testing: Show Lyric-Priorities
              function PriorityString: String;
      end;


// create the URL for the Lyrics
function BuildURL_LyricWiki(aInterpret, aTitle: String): String;
function BuildURL_ChartLyrics(aInterpret, aTitle: String): String; // for use with the API
function BuildURL_ChartLyricsManual(aInterpret, aTitle: String): String; // for the website

function GetBaseURL_LyricWiki: String;
function GetBaseURL_ChartLyrics: String;

// generate a String containing the search methods. used for the Hint-Text of the "GetLyrics"-Button (Form Details)
function GetGenericPriorityString(Prio1, Prio2: TLyricFunctionsEnum): String;


implementation

uses HtmlHelper, Nemp_RessourceStrings;

function GetBaseURL_LyricWiki: String;
begin
    result := 'https://lyrics.fandom.com/wiki/LyricWiki';
end;
function GetBaseURL_ChartLyrics: String;
begin
    result := 'http://www.chartlyrics.com';
end;


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


function BuildURL_LyricWiki(aInterpret, aTitle: String): String;
begin
    // october 2016: + 'wiki/'
    //'http://lyrics.wikia.com/wiki/'
    // April 2019: "fandom"
    result := 'https://lyrics.fandom.com/wiki/'
                        + URLEncode_LyricWiki(WordUppercase(aInterpret))
                  + ':' + URLEncode_LyricWiki(WordUppercase(aTitle));
end;

(*
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
*)

(*
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
end;*)

{ TLyrics }

constructor TLyrics.Create;
begin
    inherited;
    // set Default Lyric-Search-Methods
    fLyricGetFunctions[1] := self.GetLyrics_LyricWiki;
    fLyricGetFunctions[2] := self.GetLyrics_Chartlyrics;
end;

destructor TLyrics.Destroy;
begin
    inherited;
end;


{
    --------------------------------------------------------
    SetLyricSearchPriorities
    - Set the order of Lyric-Search-Functions
      (if another method is implemented, the parameter-list must be extended)
    --------------------------------------------------------
}

procedure TLyrics.SetLyricSearchPriorities(aFirst, aSecond: TLyricFunctionsEnum);
    function EnumToFunction(aEnum: TLyricFunctionsEnum): TLyricGetFunction;
    begin
        case aEnum of
          LYR_NONE:        result := self.GetLyrics_Dummy;
          LYR_LYRICWIKI:   result := self.GetLyrics_LyricWiki;
          LYR_CHARTLYRICS: result := self.GetLyrics_Chartlyrics;
        end;
    end;

begin
    fLyricGetFunctions[1] := EnumToFunction(aFirst);
    fLyricGetFunctions[2] := EnumToFunction(aSecond);
end;

{
    --------------------------------------------------------
    GetLyrics (Main Method)
    - try to get the lyrics directly
      // nope, not anymore. or try to get it through the artist-page
    --------------------------------------------------------
}

function TLyrics.GetLyrics(aInterpret, aTitle: String): String;
var Success: Boolean;
    i: Integer;
begin
    // fExceptionOccured := False;
    fInterpret := aInterpret;
    fTitle := aTitle;
    fCurrentLyrics := '';
    success := False;

    fExceptionOccured := False;
    fExceptionMessage := '';

    for i := 1 to COUNT_LYRIC_SEARCH_METHODS do
    begin
        if (not success) then
            success := fLyricGetFunctions[i](aInterpret, aTitle);
    end;

    if Success then
        result := fCurrentLyrics
    else
        result := '';
end;

{
    --------------------------------------------------------
    GetLyrics_Dummy
     - Dummy method, does nothing
    --------------------------------------------------------
}
function TLyrics.GetLyrics_Dummy(aInterpret, aTitle: String): Boolean;
begin
    fCurrentLyrics := '';
    result := false;
end;

{
    --------------------------------------------------------
    GetLyrics_Chartlyrics
    --------------------------------------------------------
}
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

{
    --------------------------------------------------------
    GetLyrics_LyricWiki
    --------------------------------------------------------
}

function TLyrics.GetLyrics_LyricWiki(aInterpret, aTitle: String): Boolean;
var code: String;
    lStart, LEnd, i: Integer;
    rawLyrics, charcode, newline, aURL: String;
    sl: TStringList;
    a,b, c: Integer;
const LyricBox = '<div class=''lyricbox''>';
      LyricBoxEnd = '<div class=''lyricsbreak''>';
      //ScriptEnd = '</script>';
begin
    aURL := BuildURL_LyricWiki(aInterpret, aTitle);
    try
        code := GetURLAsString(aURL);
        if code = '' then
            result := false
        else
        begin
            ///  April 2019
            ///  <div class='lyricbox'>
            ///  LYRICS
            ///  <div class='lyricsbreak'>

            // search for <div class=''lyricbox''>
            lStart := Pos(LyricBox, code);

            if lStart > 0 then
                // inc Start, so at Start is the first interesting letter
                lStart := lStart + length(LyricBox);

            // search for the "end marker"
            if lStart > 0 then
                lEnd := PosEx(LyricBoxEnd, code, lStart)
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
    except
        on E: ENetHTTPClientException do
        begin
            result := false;
            fExceptionOccured := True;
            fExceptionMessage := Format(HTTP_Connection_Error, [GetDomainFromURL(aURL), E.Message]);
        end;
    end;
end;

function GetGenericPriorityString(Prio1, Prio2: TLyricFunctionsEnum): String;
begin
    result := '';
    case Prio1 of
      //LYR_NONE        : result := result + 'N/A' +#13#10;
      LYR_LYRICWIKI   : result := result + ' - ' + Options_LyricPriority_LYRICWIKI   +#13#10;
      LYR_CHARTLYRICS : result := result + ' - ' + Options_LyricPriority_CHARTLYRICS +#13#10;
    end;

    case Prio2 of
      //LYR_NONE        : result := result + 'N/A' +#13#10;
      LYR_LYRICWIKI   : result := result + ' - ' + Options_LyricPriority_LYRICWIKI   +#13#10;
      LYR_CHARTLYRICS : result := result + ' - ' + Options_LyricPriority_CHARTLYRICS +#13#10;
    end;
end;



function TLyrics.PriorityString: String;
var i: Integer;
    f1, f2, f3: TLyricGetFunction;
    fi: TLyricGetFunction;
begin
    f1 := GetLyrics_LyricWiki;
    f2 := GetLyrics_Chartlyrics;
    f3 := GetLyrics_Dummy;

    result := '';
    for i := 1 to COUNT_LYRIC_SEARCH_METHODS do
    begin
        fi := fLyricGetFunctions[i];
        if (@f1 = @fi) then
            result := result + IntToStr(i) + ' : LyricWiki' + #13#10;

        if (@f2 = @fi) then
            result := result + IntToStr(i) + ' : Chartlyrics' + #13#10;

        if (@f3 = @fi) then
            result := result + IntToStr(i) + ' : N/A' + #13#10;
    end;
end;

end.
