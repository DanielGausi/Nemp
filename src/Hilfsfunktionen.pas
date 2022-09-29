{

    Unit Hilfsfunktionen

    Some unsorted helpers

    Note to self: This should be splitted into several units
                 (which is partially already done)

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

unit Hilfsfunktionen;

interface

uses
  Windows, Messages, System.SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, bass,  ShlObj, ActiveX, ClipBrd, ShellApi, StrUtils, WinSock,
  Inifiles, ExtCtrls, Jpeg, PNGImage,
  math, contNrs, consts, OneInst, DateUtils,
  gnugettext, Nemp_RessourceStrings;



//type TMyhelp = array[0..0] of TRGBQuad;
//   TRGBArray = array[0..0] of TRGBTriple;
//   pRGBArray = ^TRGBArray;

procedure BackupComboboxes(aForm: TForm);
procedure RestoreComboboxes(aForm: TForm);


function BitrateToColor(bitrate:integer; MinColor, CenterColor, MaxColor: TColor; MiddleToMinComputing, MiddleToMaxComputing: Byte ):Tcolor;


Function BassErrorString(ErrorCode: Integer):string;
function GetStreamType(aStream: DWord): String;
function GetStreamExtension(aStream: DWord): String;

function ReplaceForbiddenFilenameChars(aString: UnicodeString): UnicodeString;

procedure Explode(const Separator, S: String; aStrings: TStrings);  overload;
//function Explode(const Separator, S: String): TStringList;  overload; Deprecated;
procedure ExplodeWithQuoteMarks(const Separator, S: String; aStrings: TStrings); //: TStringList;  // Deprecated;

procedure Delay(dwMillSec: DWord);

function IntToStrEmptyZero(Value: Integer): String;
function SekIntToMinStr(sek:integer; OnlyMinutes: Boolean = False):string;
function SekToZeitString(dauer:int64; OnlyMinutes: Boolean = False):string;
function SecToStr(Value: Double):String;
function GetFileSize(const FileName: string): Int64;
function SizeToString(Value: Int64): String;
function SizeToString2(Value: Int64): String;
function SecondsUntil(aTime: TTime): Integer;
function AddLeadingZeroes(const aNumber, Length : integer) : string;
function YearToDecade(aYear: Integer): Integer;
function YearToDecadeString(aYear: Integer): String;


function EscapeAmpersAnd(aWs: UnicodeString): UnicodeString;

// function ExtractRelativePathNew(const BaseName, DestName: UnicodeString): UnicodeString;
function StringToURLString(aUTF8String: UTF8String): AnsiString;

function GainStringToSingle(aGainString: String): Single;
function PeakStringToSingle(aPeakString: String): Single;

function GainValueToString(aGainValue: Single): String;
function PeakValueToString(aPeakValue: Single): String;

function AnsiCompareText_Nemp(const S1, S2: string): Integer;
function AnsiCompareText_NempIgnoreCase(const S1, S2: string): Integer;
function AnsiStartsText_Nemp(const ASubText, AText: string): Boolean;


procedure Wuppdi(i: Integer = 0);

implementation


procedure BackupComboboxes(aForm: TForm);
var i: Integer;
begin
    for i := 0 to aForm.ComponentCount - 1 do
      if (aForm.Components[i] is TComboBox) then
        aForm.Components[i].Tag := (aForm.Components[i] as TComboBox).ItemIndex;
end;
procedure RestoreComboboxes(aForm: TForm);
var i: Integer;
begin
  for i := 0 to aForm.ComponentCount - 1 do
      if (aForm.Components[i] is TComboBox) then
        (aForm.Components[i] as TComboBox).ItemIndex := aForm.Components[i].Tag;
end;


Function BassErrorString(ErrorCode: Integer):string;
begin
  Case ErrorCode of
    BASS_ERROR_INIT      : result := ( BASS_ERRORSTR_INIT      );
    BASS_ERROR_NOTAVAIL  : result := ( BASS_ERRORSTR_NOTAVAIL  );
    BASS_ERROR_NONET     : result := ( BASS_ERRORSTR_NONET     );
    BASS_ERROR_ILLPARAM  : result := ( BASS_ERRORSTR_ILLPARAM  );
    BASS_ERROR_TIMEOUT   : result := ( BASS_ERRORSTR_TIMEOUT   );
    BASS_ERROR_FILEOPEN  : result := ( BASS_ERRORSTR_FILEOPEN  );
    BASS_ERROR_FILEFORM  : result := ( BASS_ERRORSTR_FILEFORM  );
    BASS_ERROR_FORMAT    : result := ( BASS_ERRORSTR_FORMAT    );
    BASS_ERROR_SPEAKER   : result := ( BASS_ERRORSTR_SPEAKER   );
    BASS_ERROR_MEM       : result := ( BASS_ERRORSTR_MEM       );
    BASS_ERROR_NO3D      : result := ( BASS_ERRORSTR_NO3D      );
    BASS_ERROR_CODEC     : result := ( BASS_ERRORSTR_CODEC     );
    BASS_ERROR_UNKNOWN   : result := ( BASS_ERRORSTR_UNKNOWN   );
    0                    : result := ( BASS_ERRORSTR_NOERROR   );
    else result := Format('%d (%s)', [ErrorCode, (BASS_ERRORSTR_UNEXPECTED)]);
  end;
end;


//function PathSeemsToBeURL(apath: string): boolean;
//begin
//  result := (pos('://', apath) > 0);
{       AnsiStartsText('http://', Trim(aPath))
    OR (pos('http://', apath) > 0)
    OR AnsiStartsText('ftp://', Trim(aPath))
    OR (pos('ftp://', apath) > 0)}
//end;

function GetStreamType(aStream: Dword): String;
var Channelinfo: Bass_ChannelInfo;
  PlugInfo: PBass_PluginInfo;
  i: integer;
begin

  result := '';
  BASS_ChannelGetInfo(aStream,Channelinfo);

  if Channelinfo.plugin = 0 then
  begin
      case Channelinfo.ctype of
        BASS_CTYPE_STREAM_OGG        : result := 'Ogg';
        BASS_CTYPE_STREAM_MP1        : result := 'MP1';
        BASS_CTYPE_STREAM_MP2        : result := 'MP2';
        BASS_CTYPE_STREAM_MP3        : result := 'MP3';
        BASS_CTYPE_STREAM_AIFF       : result := 'Aiff';
        BASS_CTYPE_STREAM_WAV_PCM    : result := 'Wav(PCM)';
        BASS_CTYPE_STREAM_WAV_FLOAT  : result := 'Wav';
        BASS_CTYPE_MUSIC_MTM         : result := '';
        BASS_CTYPE_MUSIC_S3M         : result := '';
        BASS_CTYPE_MUSIC_XM          : result := '';
        BASS_CTYPE_MUSIC_IT          : result := '';
        else result := ''
      end;
  end else
  begin
    //plugin geladen
    PlugInfo := BASS_PluginGetInfo(Channelinfo.plugin);
    for i := 0 to PlugInfo.formatc-1 do
    begin
      if PLugInfo.formats[i].ctype = Channelinfo.ctype then
        result := String(PlugInfo.formats[i].name);
    end;
  end;
end;

function GetStreamExtension(aStream: DWord): String;
var Channelinfo: Bass_ChannelInfo;
  PlugInfo: PBass_PluginInfo;
  i: integer;
  tmpext: TStringList;
begin

  result := '';
  BASS_ChannelGetInfo(aStream,Channelinfo);

  if Channelinfo.plugin = 0 then
  begin
      case Channelinfo.ctype of
        BASS_CTYPE_STREAM_OGG        : result := '.ogg';
        BASS_CTYPE_STREAM_MP1        : result := '.mp3';
        BASS_CTYPE_STREAM_MP2        : result := '.mp3';
        BASS_CTYPE_STREAM_MP3        : result := '.mp3';
        BASS_CTYPE_STREAM_AIFF       : result := '.aiff';
        BASS_CTYPE_STREAM_WAV_PCM    : result := '.wav';
        BASS_CTYPE_STREAM_WAV_FLOAT  : result := '.wav';
        else result := ''
      end;
  end else
  begin
    //plugin geladen
    PlugInfo := BASS_PluginGetInfo(Channelinfo.plugin);
    for i := 0 to PlugInfo.formatc-1 do
    begin
      if PLugInfo.formats[i].ctype = Channelinfo.ctype then
      begin
          tmpext := TStringList.Create;
          try
            Explode(';', String(PlugInfo.Formats[i].exts), tmpext);
            if tmpext.Count > 0 then
              result := StringReplace(tmpext.Strings[0],'*', '',[]);
          finally
            tmpext.Free;
          end;
      end;
    end;
  end;

end;


function ReplaceForbiddenFilenameChars(aString: UnicodeString): UnicodeString;
var i: Integer;
begin
  result := aString;
  for i := 1 to length(result) do
  case result[i] of
      ':': result[i] := ';';
      '/': result[i] := '-';
      '\': result[i] := '-';
      '*': result[i] := '-';
      '?': result[i] := '-';
      '"': result[i] := '-';
      '<': result[i] := '[';
      '>': result[i] := ']';
      '|': result[i] := '!';
      #13: result[i] := ' ';
      #10: result[i] := ' ';
  end;
end;



{-----------------------------------------------------------------------------
  Procedure : Explode
  Purpose   : Seperates a CSV-line
  Arguments : const Separator, S: string;
  Result    : TStringList
-----------------------------------------------------------------------------}

procedure Explode(const Separator, S: String; aStrings: TStrings);
var
  SepLen: Integer;
  F, P: PChar;
  tmpstr: String;
begin
  aStrings.Clear;
  if (S = '') then exit;
  if Separator = '' then
  begin
    aStrings.Add(S);
    exit;
  end;
  SepLen := Length(Separator);
  P := PChar(S);
  while P^ <> #0 do
  begin
    F := P;
    P := StrPos(P, PChar(Separator));
    if (P = nil) then P := StrEnd(F);
    SetString(tmpstr, F, P - F);
    aStrings.Add(tmpstr);
    if P^ <> #0 then Inc(P, SepLen);
  end;

end;

(*function Explode(const Separator, S: String): TStringList;
var
  SepLen: Integer;
  F, P: PChar;
  tmpstr: String;
begin
  result := TStringList.Create;
  if (S = '') then Exit;
  if Separator = '' then
  begin
    Result.Add(S);
    Exit;
  end;
  SepLen := Length(Separator);
  P := PChar(S);
  while P^ <> #0 do
  begin
    F := P;
    P := StrPos(P, PChar(Separator));
    if (P = nil) then P := StrEnd(F);
    SetString(tmpstr, F, P - F);
    Result.Add(tmpstr);
    if P^ <> #0 then Inc(P, SepLen);
  end;
end;*)

//function ExplodeWithQuoteMarks(const Separator, S: String): TStringList;
procedure ExplodeWithQuoteMarks(const Separator, S: String; aStrings: TStrings);
var
  SepLen: Integer;
  F, P: PChar;
  tmpstr, quote:String;

begin
  if (S = '') then Exit;
  quote := '"';
  if Separator = '' then
  begin
    aStrings.Add(S);
    Exit;
  end;
  SepLen := Length(Separator);
  P := PChar(S);
  while P^ <> #0 do
  begin
    F := P;
    // Möglichkeit 1
    // Hier steht jetzt ein "-Zeichen
    if F^ = quote then
    begin
        // nächstes " Zeichen suchen
        P := StrPos(P+1, PChar(quote));
        if (P = nil) then
        begin
          // kein weiteres " gefunden => bis zum nächsten Seperator schneiden
            P := StrPos(F, PChar(Separator));
            if (P = nil) then P := StrEnd(F);
            SetString(tmpstr, F, P - F);
            if trim(tmpstr) <> '' then
              aStrings.Add(tmpstr);
            if P^ <> #0 then Inc(P, SepLen);
        end
        else
        begin
            SetString(tmpstr, F+1, P - F-1);
            if trim(tmpstr) <> '' then
              aStrings.Add(tmpstr);
            if P^ <> #0 then Inc(P, Length(quote));
        end;
    end else
    begin
        P := StrPos(P, PChar(Separator));
        if (P = nil) then P := StrEnd(F);
        SetString(tmpstr, F, P - F);
        if trim(tmpstr) <> '' then
          aStrings.Add(tmpstr);
        if P^ <> #0 then Inc(P, SepLen);
    end;
  end;
end;




function BitrateToColor(bitrate:integer; MinColor, CenterColor, MaxColor: TColor; MiddleToMinComputing, MiddleToMaxComputing: Byte ):Tcolor;
var r,g,b:byte;
  diff:integer;

      function RGBToColor(R, G, B : byte): TColor;
      begin
        Result := ((R and $FF) shl 16) +
          ((G and $FF) shl 8) + (B and $FF);
      end;

begin
  if Bitrate > 320 then Bitrate := 320;
  if Bitrate = 0 then Bitrate := 160;
  
  r := GetRValue(CenterColor);  //0;
  g := GetGValue(CenterColor);  //0;
  b := GetBValue(CenterColor);  //0;

  //r := GetRValue(result);

  if bitrate > 160 then
  begin
    //auf 0,200,25 (grün) hinarbeiten
    diff := bitrate - 160;
    //g := round(sqrt(diff/160) * 200);
    //b := round(sqrt(diff/160) * 25);
    case MiddleToMaxComputing of
        0: begin
          r := r + round(sqr(diff/160) * (GetRValue(MaxColor) - GetRValue(CenterColor))) ;  //  ;  //);
          g := g + round(sqr(diff/160) * (GetGValue(MaxColor) - GetGValue(CenterColor)));
          b := b + round(sqr(diff/160) * (GetBValue(MaxColor) - GetBValue(CenterColor)));
        end;
        1: begin
          r := r + round(diff/160 * (GetRValue(MaxColor) - GetRValue(CenterColor))) ;  //  ;  //);
          g := g + round(diff/160 * (GetGValue(MaxColor) - GetGValue(CenterColor)));
          b := b + round(diff/160 * (GetBValue(MaxColor) - GetBValue(CenterColor)));
        end;
        else begin
          r := r + round(sqrt(diff/160) * (GetRValue(MaxColor) - GetRValue(CenterColor))) ;  //  ;  //);
          g := g + round(sqrt(diff/160) * (GetGValue(MaxColor) - GetGValue(CenterColor)));
          b := b + round(sqrt(diff/160) * (GetBValue(MaxColor) - GetBValue(CenterColor)));
        end;
    end;
  end;
  if bitrate < 160 then
  begin
    // auf rot hinarbeiten
    diff := 160 - bitrate;
    case MiddleToMinComputing of
        0: begin
          r := r + round(sqr(diff/160) * (GetRValue(MinColor) - GetRValue(CenterColor)));
          g := g + round(sqr(diff/160) * (GetGValue(MinColor) - GetGValue(CenterColor)));
          b := b + round(sqr(diff/160) * (GetBValue(MinColor) - GetBValue(CenterColor)));
        end;
        1: begin
          r := r + round(diff/160 * (GetRValue(MinColor) - GetRValue(CenterColor)));
          g := g + round(diff/160 * (GetGValue(MinColor) - GetGValue(CenterColor)));
          b := b + round(diff/160 * (GetBValue(MinColor) - GetBValue(CenterColor)));
        end;
        else begin
          r := r + round(sqrt(diff/160) * (GetRValue(MinColor) - GetRValue(CenterColor)));
          g := g + round(sqrt(diff/160) * (GetGValue(MinColor) - GetGValue(CenterColor)));
          b := b + round(sqrt(diff/160) * (GetBValue(MinColor) - GetBValue(CenterColor)));
        end;
    end;
  end;
  result := rgbToColor(b,g,r)
end;



procedure Delay(dwMillSec: DWord);
var
  aHandle: THandle;
  dwStart:DWord;
begin
  aHandle  := GetCurrentThread;
  dwStart  := GetTickCount + dwMillSec;

  while MsgWaitForMultipleObjects(1, aHandle, False, dwMillSec, QS_ALLINPUT) <> WAIT_TIMEOUT do
  begin
    Application.ProcessMessages;
    dwMillSec := GetTickCount;
    if dwMillSec < dwStart then
      dwMillSec := dwStart - dwMillSec
    else
      Exit;
  end;
end;

function IntToStrEmptyZero(Value: Integer): String;
begin
  if Value = 0 then
    result := ''
  else
    result := IntToStr(Value)
end;

function SekIntToMinStr(sek:integer; OnlyMinutes: Boolean = False):string;
begin
    result:='';
    if sek <= 0 then
        result := '0:00'
    else begin
      if OnlyMinutes then
          result := inttostr(sek DIV 60)
      else
          result := Format('%d:%.2d', [sek DIV 60, sek MOD 60]);

      //if Not OnlyMinutes then
      //begin
      //    sek:=sek Mod 60;
      //    if sek<10 then result:=result+':0'+inttostr(sek)
      //        else result:=result+':'+inttostr(sek)
      //end;
    end;
end;


function SekToZeitString(dauer:int64; OnlyMinutes: Boolean = False):string;
var sek,min,std:integer;
  d:integer;
begin
  result := '';
  d := 0;
  // sekunden rausrechnen
  sek := dauer mod 60;
  dauer := dauer div 60;
  if dauer > 0 then inc(d); // nur sekunden

  // minuten rausrechnen
  min := dauer mod 60;
  dauer := dauer DIV 60;
  if dauer > 0 then inc(d); //  min:sek

  // Stunden ausrechnen
  ///std := dauer mod 24;
  ///dauer := dauer DIV 24;
  ///if dauer > 0 then inc(d); // std:min
  ///tag := dauer;
  ///

  std := dauer;

  case d of
    0: result := Format('0:%.2d%s', [sek, (Time_MinuteShort)]);
    1: if OnlyMinutes then
          result := Format('%d%s', [min, (Time_MinuteShort)])
       else
          result := Format('%d:%.2d%s', [min, sek, (Time_MinuteShort)]);
    2: begin
        if std < 72 then
            result := Format('%d:%.2d%s', [std, min,(Time_HourShort)])
        else
            result :=  Format('%d %s', [std div 24, (Time_DaysLong)]);
    end;
  end;


  {case d of
    0: nur Sekunden result := Format('0:%.2d %s', [sek, (Time_MinuteShort)]);
    1: if OnlyMinutes then
          result := Format('%d%s', [min, (Time_MinuteShort)])
       else
          result := Format('%d:%.2d%s', [min, sek, (Time_MinuteShort)]);
    2: result := Format('%d:%.2d%s', [std,  min, (Time_HourShort)]);
        //Inttostr(std) + 'h' + InttoStrZero(min) + 'm';
    3:  if tag <= 3 then
          result := Format('%d %s', [24 * tag + std, (Time_HoursLong)])
        else
          result :=  Format('%d %s', [tag, (Time_DaysLong)]);
  end;}
end;


// Diese Funktion wandelt eine Zeitangabe in Sekunden
// in einen String im Format 'HH:MM:SS' um.
Function SecToStr(Value: Double):String;

  // Erzeugte aus den Drei Variablen für Stunde,Minute und
  // Sekunde einen String im Format 'hh:mm:ss'
  Function MakeTime(M,S:Integer):String;

    // Wandelt eine Zahl in einen mindestens zweistelligen
    // string
    Function IntStr2(Val:Integer):String;
    Begin
      // Zahl in String verwandeln
      Result:=IntToStr(Val);
      // Falls der Wert kleiner als 10 ist eine '0' am
      // Stringanfang einfügen
      If Val<10 then Result:='0'+Result;
    End;

  Begin
    // Wandle Stunden, Minuten und Sekunden in einen String
    Result:=IntStr2(M)+':'+IntStr2(S);
  End;

Var
  T,M,S:Integer;
Begin
  T:=Round(Value+0.5);
  // Minuten berechnen
  M:=T div 60;
  // Sekunden sind der Rest
  S:=T mod 60;
  // In String verwandeln
  Result:=MakeTime(M,S);
End;


function GetFileSize(const FileName: string): Int64;
var
  FileInfo: TWin32FileAttributeData;
begin
  FillChar(FileInfo, SizeOf(FileInfo), 0);
  if GetFileAttributesEx(PChar(FileName), GetFileExInfoStandard, @FileInfo) then
  begin
    Int64Rec(Result).Hi := FileInfo.nFileSizeHigh;
    Int64Rec(Result).Lo := FileInfo.nFileSizeLow;
  end
  else
    Result := 0; // -1 wäre ein besserer Wert, da es Dateien gibt die Größe 0 haben
end;

function SizeToString(Value: Int64): String;
begin

  if Value <= 1024 then
      result := inttostr(Value) + ' Byte; '
  else
      if Value <= 1024*1024 then
          result :=  FloatToStrF((Value / 1024), ffFixed, 4, 0) + ' kB; '
      else
          if Value <= 1024*1024*1024 then
              result := FloatToStrF((Value / 1024 / 1024), ffFixed, 8, 0) + ' MB; '
          else
              result := FloatToStrF((Value / 1024 / 1024 / 1024), ffFixed, 4, 0) + ' GB; ';
end;

function SizeToString2(Value: Int64): String;
begin
  if Value <= 1024 then
      result := inttostr(Value) + ' Byte'
  else
      if Value <= 1024*1024 then
          result :=  FloatToStrF((Value / 1024), ffFixed, 4, 0) + ' kB'
      else
          if Value <= 1024*1024*1024 then
              result := FloatToStrF((Value / 1024 / 1024), ffFixed, 8, 0) + ' MB'
          else
              result := FloatToStrF((Value / 1024 / 1024 / 1024), ffFixed, 4, 0) + ' GB';
end;


function SecondsUntil(aTime: TTime): Integer;
var aNow: TTime;
begin
  aTime := TimeOf(aTime);
  aNow := TimeOf(Now);

  if aNow > aTime then
    // Ereignis ist erst wieder morgen
    aTime := aTime + 1;

  Result := SecondsBetween(aNow, aTime);
end;

function AddLeadingZeroes(const aNumber, Length : integer) : string;
begin
   result := Format('%.*d', [Length, aNumber]) ;
end;

function YearToDecade(aYear: Integer): Integer;
begin
  result := (aYear div 10) * 10;
end;
function YearToDecadeString(aYear: Integer): String;
begin
  result := AddLeadingZeroes(YearToDecade(aYear), 4);
end;


function EscapeAmpersAnd(aWs: UnicodeString): UnicodeString;
var i: Integer;
    lastCharWasAnd: Boolean;
begin
  lastCharWasAnd := False;
  result := '';
  for i := 1 to length(aWs) do
  begin
    result := result + aWs[i];
    if aWs[i] = '&' then
    begin
      // noch eins dranhängen
      result := result + '&';
      if Not lastCharWasAnd then
        result := result + '&';
      lastCharWasAnd := True;
    end else
      lastCharWasAnd := False;
  end;
end;



function StringToURLString(aUTF8String: UTF8String): AnsiString;
var i: integer;
begin
    result := '';
    for i := 1 to length(aUTF8String) do
    begin
        if aUTF8String[i] <> '&' then
            result := result + '%'  + AnsiString(IntToHex(Ord(aUTF8String[i]),2))
        else
            result := result + aUTF8String[i];
    end;
end;

(*
function ExtractRelativePathNew(const BaseName, DestName: UnicodeString): UnicodeString;
var
  BasePath, DestPath: UnicodeString;

  function ExtractFilePathNoDrive(const FileName: UnicodeString): UnicodeString;
  begin
    Result := ExtractFilePath(FileName);
    Delete(Result, 1, Length(ExtractFileDrive(FileName)));
  end;

begin
  if AnsiSameText(ExtractFileDrive(BaseName), ExtractFileDrive(DestName)) then
  begin
      // Beide Dateien auf demselben Laufwerk
      BasePath := ExtractFilePathNoDrive(BaseName); // Pfade inkl. \
      DestPath := ExtractFilePathNoDrive(DestName); // Pfad inkl. \

      if AnsiStartsStr(BasePath, DestPath) then
          result := ExtractRelativePath(BaseName, DestName)
      else
          result := DestPath + ExtractFileName(DestName);
  end
  else
      Result := DestName;
end;
*)


///  Convert a ReplayGainString (from the Metatags of an Audiofile) into a Single value
function GainStringToSingle(aGainString: String): Single;
var formatSettings: TFormatSettings;
begin
    // expected format:
    // "+/-xx.xxxxxx dB"  ->  always use "." as DecimalSeparator!
    if Length(aGainString) < 3 then
        result := 0
    else
    begin
        formatSettings := TFormatSettings.Create(GetThreadLocale);
        formatSettings.DecimalSeparator := '.';
        if not TryStrToFloat(Copy(aGainString, 1, Length(aGainString) - 3 ), result, formatSettings)
            then result := 0;
    end;
end;
function PeakStringToSingle(aPeakString: String): Single;
var formatSettings: TFormatSettings;
begin
    formatSettings := TFormatSettings.Create(GetThreadLocale);
    formatSettings.DecimalSeparator := '.';
    if not TryStrToFloat(aPeakString, result, formatSettings)
        then result := 1;
end;

function GainValueToString(aGainValue: Single): String;
var formatSettings: TFormatSettings;
begin
    if isZero(aGainValue) then
        result := ''
    else
    begin
        formatSettings := TFormatSettings.Create(GetThreadLocale);
        formatSettings.DecimalSeparator := '.';
        if aGainValue > 0 then
            result := Format('+%.2f dB', [aGainValue], formatSettings)
        else
            result := Format('%.2f dB', [aGainValue], formatSettings);
    end;
end;

function PeakValueToString(aPeakValue: Single): String;
var formatSettings: TFormatSettings;
begin
    if SameValue(aPeakValue, 1) then
        result := ''
    else
    begin
        formatSettings := TFormatSettings.Create(GetThreadLocale);
        formatSettings.DecimalSeparator := '.';
        result := Format('%.6f', [aPeakValue], formatSettings)
    end;
end;

procedure Wuppdi(i: Integer = 0);
begin
    if i=0 then
        ShowMessage('Wuppdi')
    else
        ShowMessage('Wuppdi '+ IntToStr(i));
end;

// AnsiCompareText_Nemp
// An version of AnsiCompareText which treats strings like "-sampler" and "--sampler" differently
// With the regular AnsiCompareText function browsing by Directory won't work with such folder names
// also: SORT_DIGITSASNUMBERS for a better sorting of sampler series (like "Bravo Hits 1,2,3,..,10" instead of "1,10,2,3,..")
function AnsiCompareText_Nemp(const S1, S2: string): Integer;
begin
  Result := CompareString(LOCALE_USER_DEFAULT, SORT_STRINGSORT or SORT_DIGITSASNUMBERS, PChar(S1),
    Length(S1), PChar(S2), Length(S2)) - CSTR_EQUAL;
end;

function AnsiCompareText_NempIgnoreCase(const S1, S2: string): Integer;
begin
  Result := CompareString(LOCALE_USER_DEFAULT, SORT_STRINGSORT or LINGUISTIC_IGNORECASE or SORT_DIGITSASNUMBERS, PChar(S1),
    Length(S1), PChar(S2), Length(S2)) - CSTR_EQUAL;
end;

// the same for AnsiStartsText
function AnsiStartsText_Nemp(const ASubText, AText: string): Boolean;
var
  L, L2: Integer;
begin
  L := Length(ASubText);
  L2 := Length(AText);
  if L > L2 then
    Result := False
  else
    Result := CompareString(LOCALE_USER_DEFAULT, SORT_STRINGSORT or SORT_DIGITSASNUMBERS,
      PChar(AText), L, PChar(ASubText), L) = 2;
end;


end.
