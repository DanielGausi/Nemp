{

    Unit StringHelper

    - Some String-functions

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
unit StringHelper;

interface

uses Windows, Classes, SysUtils, StrUtils;

//
function IsValidFilenameFormat(aFormatString: String): Boolean;
function IsValidFilename(aFilename: String): Boolean;
function ConvertToFileName(aString: String): String;

// vergleicht die Strings zeichenweise und erlaubt dabei tolerance-viele Fehler
function SameString(string1, string2: UnicodeString; tolerance: Integer; var Fehlstelle: Integer): Boolean;
function GetCommonString(Strings: TStringList; tolerance: Integer; var Fehlstelle: Integer): UnicodeString;

function StrListValueDef(Source: TStringList; const Name, default: String): String;

implementation

function IsValidFilename(aFilename: String): Boolean;
begin
    result := (pos(':', aFilename) = 0) AND
              (pos('/', aFilename) = 0) AND
              (pos('\', aFilename) = 0) AND
              (pos('*', aFilename) = 0) AND
              (pos('?', aFilename) = 0) AND
              (pos('"', aFilename) = 0) AND
              (pos('<', aFilename) = 0) AND
              (pos('>', aFilename) = 0) AND
              (pos('|', aFilename) = 0);
end;

{
    --------------------------------------------------------
    IsValidFilenameFormat
    - Replace some Tags in aFormatString and check, whether
      the rest is a valid filename
    Used by OptionsForm to Check, whether Formatinput is valid
    for webradio-recordings
    --------------------------------------------------------
}
function IsValidFilenameFormat(aFormatString: String): Boolean;
begin
  aFormatString := StringReplace(aFormatString, '<date>', '', [rfReplaceAll, rfIgnoreCase]);
  aFormatString := StringReplace(aFormatString, '<time>', '', [rfReplaceAll, rfIgnoreCase]);
  aFormatString := StringReplace(aFormatString, '<title>', '', [rfReplaceAll, rfIgnoreCase]);
  aFormatString := StringReplace(aFormatString, '<streamname>', '', [rfReplaceAll, rfIgnoreCase]);
  result := (pos(':', aFormatString) = 0) AND
            (pos('/', aFormatString) = 0) AND
            (pos('\', aFormatString) = 0) AND
            (pos('*', aFormatString) = 0) AND
            (pos('?', aFormatString) = 0) AND
            (pos('"', aFormatString) = 0) AND
            (pos('<', aFormatString) = 0) AND
            (pos('>', aFormatString) = 0) AND
            (pos('|', aFormatString) = 0);
end;

function ConvertToFileName(aString: String): String;
var i: Integer;
begin
    result := aString;
    for i := 1 to Length(result) do
    begin
        if result[i] = ':' then result[i] := '-';
        if result[i] = '/' then result[i] := '-';
        if result[i] = '\' then result[i] := '-';
        if result[i] = '*' then result[i] := '-';
        if result[i] = '?' then result[i] := '-';
        if result[i] = '"' then result[i] := '_';
        if result[i] = '<' then result[i] := '-';
        if result[i] = '>' then result[i] := '-';
        if result[i] = '|' then result[i] := '_';
        // "." is not forbidden in Filenames, but replacing it here seems to be a good idea
        if result[i] = '.' then result[i] := '_';
    end;
end;

function SameString(string1, string2: UnicodeString; tolerance: Integer; var Fehlstelle: Integer): Boolean;
var tmp: UnicodeString;
    i, c: Integer;
begin
  // sicherstellen, dass Album2 mindestens so lang ist wie 1
  if length(string1) > length(string2) then
  begin
    tmp := string1;
    string1 := string2;
    string2 := tmp;
  end;
  c := 0;
  for i := 1 to length(string1) do
  begin
    if AnsiUpperCase(string1[i]) <> AnsiUpperCase(string2[i]) then
    begin
      inc(c);
      // erste Fehlerstelle zurückmelden!
      if Fehlstelle = 0 then Fehlstelle := i;
    end;
    if c > tolerance then break; // Abbruch. Zu viele Fehler
  end;
  result := c <= tolerance;
end;

function GetCommonString(Strings: TStringList; tolerance: Integer; var Fehlstelle: Integer): UnicodeString;
var minlength, minidx, i: Integer;
    checkStr: UnicodeString;
    durchlauf, durchlaufmax, errorCount: Integer;
begin
  durchlauf := 0;
  Fehlstelle := 0;
  CheckStr := '';
  case Strings.Count of
      0..1: durchlaufmax := 0;
      2..4: durchlaufmax := 1;
      5..9: durchlaufmax := 2
  else
      durchlaufmax := 3;
  end;

  if Strings.Count > 0 then
  begin
      repeat
            // Den String mit minimaler Länge bestimmen
            minlength := length(Strings[0]);
            minidx := 0;
            for i := 1 to Strings.Count - 1 do
            begin
              if length(Strings[i]) < minlength then
              begin
                minlength := length(Strings[i]);
                minidx := i;
              end;
            end;
            checkStr := Strings[minidx];
            // diesen String aus der Liste entfernen, damit er beim nächsten Durchlauf nicht wieder gefunden wird
            Strings.Delete(minidx);

            // Den Rest der Stringliste überprüfen, ob dieser String "passt"
            // ErrorCount zählt dabei die Strings, die nicht passen
            errorCount := 0;
            Fehlstelle := 0;
            for i := 0 to Strings.Count - 1 do
            begin
              if not SameString(checkStr, Strings[i], tolerance, Fehlstelle) then
                inc(errorCount);
              if errorCount > 1 then break;
            end;

            // Situation hier:
            // Wenn errorCount <= 1, dann ist CheckStr ein guter String für die Liste
            // Wenn nicht, dann probieren wir das nochmal.
            inc(durchlauf);
      until (durchlauf > durchlaufmax) or (errorCount <= 1) or (strings.Count = 0);

      if ErrorCount <= 1 then
          result := CheckStr
      else
      begin
          if fehlstelle <= length(CheckStr) Div 2 +1 then
              result := ''
          else
          begin
              result := copy(CheckStr, 1, fehlstelle - 1) + ' ... ';
              fehlstelle := 0;
          end;
      end;

  end
  else
  begin
      result := '';// '<N/A>'; // = AUDIOFILE_UNKOWN;
      Fehlstelle := 0;
  end;

end;

function StrListValueDef(Source: TStringList; const Name, default: String): String;
begin
  result := Source.Values[Name];
  if result = '' then
    result := default;
end;

end.
