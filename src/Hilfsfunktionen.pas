{

    Unit Hilfsfunktionen

    Some unsorted helpers

    Note to self: This should be splitted into several units
                 (which is partially already done)

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

unit Hilfsfunktionen;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, bass,  ShlObj, ActiveX, ClipBrd, ShellApi, StrUtils, WinSock,
  Inifiles, ExtCtrls, Jpeg, PNGImage, GifImg,
  math, contNrs, consts, OneInst, DateUtils,
  gnugettext, Nemp_RessourceStrings;



type TMyhelp = array[0..0] of TRGBQuad;
   TRGBArray = array[0..0] of TRGBTriple;
   pRGBArray = ^TRGBArray;



function BitrateToColor(bitrate:integer; MinColor, CenterColor, MaxColor: TColor; MiddleToMinComputing, MiddleToMaxComputing: Byte ):Tcolor;

//procedure BitmapDrehen_90Grad(const Bitmap: TBitmap);
//procedure HorizontalSpiegeln(const Bitmap: TBitmap);

Function BassErrorString(ErrorCode: Integer):string;

function GetStreamType(aStream: DWord): String;
function GetStreamExtension(aStream: DWord): String;

function ReplaceForbiddenFilenameChars(aString: UnicodeString): UnicodeString;

function PathSeemsToBeURL(apath: string): boolean;

function Explode(const Separator, S: String): TStringList;
function ExplodeWithQuoteMarks(const Separator, S: String): TStringList;

procedure Delay(dwMillSec: DWord);

function SekIntToMinStr(sek:integer; OnlyMinutes: Boolean = False):string;
  function InttoStrZero(i:integer):string;
  function SekToZeitString(dauer:int64; OnlyMinutes: Boolean = False):string;
  function SekToPlaylistZeitString(dauer:int64; OnlyMinutes: Boolean = False):string;

  Function SecToStr(Value: Double):String;

  function SizeToString(Value: Int64): String;

function SecondsUntil(aTime: TTime): Integer;

function EscapeAmpersAnd(aWs: UnicodeString): UnicodeString;

//Baut eine string in Uppercase-Wort um mit "_" als Trenner - für die LyricWiki-Abfrage
function ExtractRelativePathNew(const BaseName, DestName: UnicodeString): UnicodeString;

function StringToURLString(aUTF8String: UTF8String): AnsiString;




procedure Wuppdi(i: Integer = 0);

implementation


  (*
procedure BitmapDrehen_90Grad(const Bitmap: TBitmap);
var P: PRGBQuad; //^THelpRGB;
    x,y,b,h : Integer;
    RowOut: ^TMyHelp;
    help: TBitmap;
begin
  Bitmap.PixelFormat := pf32bit;
  help := TBitmap.Create;
  try
    help.PixelFormat := pf32bit;
    b := bitmap.Height;
    h := bitmap.Width;
    help.Width := b;
    help.height := h;
    for y := 0 to (h-1) do
    begin
      rowOut := help.ScanLine[y];
      P  := Bitmap.scanline[bitmap.height-1];
      inc(p,y);
      for x := 0 to (b-1) do
      begin
        rowout[x] := p^;
        inc(p,h);
      end;
    end;
  finally
    bitmap.Assign(help);
    help.Free;
  end;
end;

procedure HorizontalSpiegeln(const Bitmap: TBitmap);
var i,j,w: Integer;
    rowin,rowout: pRGBArray;
begin
  w := bitmap.width*sizeof(TRGBTriple);
  Getmem(rowIn,w);
  try
    for j:= 0 to Bitmap.Height-1 do
    begin
      move(Bitmap.Scanline[j]^,rowin^,w);
      rowout := Bitmap.Scanline[j];
      for i := 0 to Bitmap.Width-1 do
        rowout[i] := rowin[Bitmap.Width-1-i];
    end;
    bitmap.Assign(bitmap);
  finally
    Freemem(rowin);
  end;
end;
       *)
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


function PathSeemsToBeURL(apath: string): boolean;
begin
  result := (pos('://', apath) > 0);
{       AnsiStartsText('http://', Trim(aPath))
    OR (pos('http://', apath) > 0)
    OR AnsiStartsText('ftp://', Trim(aPath))
    OR (pos('ftp://', apath) > 0)}
end;

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
                tmpext := Explode(';', String(PLugInfo.Formats[i].exts));
                if tmpext.Count > 0 then
                  result := StringReplace(tmpext.Strings[0],'*', '',[]);
                FreeAndNil(tmpext);// im Explode wirds erzeugt
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

function Explode(const Separator, S: String): TStringList;
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
end;

function ExplodeWithQuoteMarks(const Separator, S: String): TStringList;
var
  SepLen: Integer;
  F, P: PChar;
  tmpstr, quote:String;

begin
  result := TStringList.Create;
  if (S = '') then Exit;
  quote := '"';
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
              Result.Add(tmpstr);
            if P^ <> #0 then Inc(P, SepLen);
        end
        else
        begin
            SetString(tmpstr, F+1, P - F-1);
            if trim(tmpstr) <> '' then
              Result.Add(tmpstr);
            if P^ <> #0 then Inc(P, Length(quote));
        end;
    end else
    begin
        P := StrPos(P, PChar(Separator));
        if (P = nil) then P := StrEnd(F);
        SetString(tmpstr, F, P - F);
        if trim(tmpstr) <> '' then
          Result.Add(tmpstr);
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


function SekIntToMinStr(sek:integer; OnlyMinutes: Boolean = False):string;
begin
    result:='';
    if sek < 0 then result := '0:00' else
    begin
      result:=inttostr(sek DIV 60);
      if Not OnlyMinutes then
      begin
          sek:=sek Mod 60;
          if sek<10 then result:=result+':0'+inttostr(sek)
              else result:=result+':'+inttostr(sek)
      end;
    end;
end;

function InttoStrZero(i:integer):string;
begin
  if i= 0 then result := '00'
    else if i<10 then result := '0'+inttostr(i)
      else result := inttostr(i);
end;

function SekToZeitString(dauer:int64; OnlyMinutes: Boolean = False):string;
var sek,min,std,tag:integer;
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
  std := dauer mod 24;
  dauer := dauer DIV 24;
  if dauer > 0 then inc(d); // std:min

  tag := dauer;

  case d of
    0: {nur Sekunden} result := Format('%d%s', [sek, (Time_SecShort)]);
    1: if OnlyMinutes then
          result := Format('%d%s', [min, (Time_MinuteShort)])
       else
          result := Format('%d%s%d%s', [min, (Time_MinuteShort), sek, (Time_SecShort)]);
    2: result := Format('%d%s%d%s', [std, (Time_HourShort), min, (Time_MinuteShort)]);
        //Inttostr(std) + 'h' + InttoStrZero(min) + 'm';
    3:  if tag <= 3 then
          result := Format('%d %s', [24 * tag + std, (Time_HoursLong)])
        else
          result :=  Format('%d %s', [tag, (Time_DaysLong)]);
  end;
end;

function SekToPlaylistZeitString(dauer:int64; OnlyMinutes: Boolean = False):string;
var sek,min,std,tag:integer;
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
  std := dauer mod 24;
  dauer := dauer DIV 24;
  if dauer > 0 then inc(d); // std:min

  tag := dauer;

  case d of
    0: {nur Sekunden} result := Format('%d%s', [sek, (Time_SecShort)]);
    1: if OnlyMinutes then
          result := Format('%d%s', [min, (Time_MinuteShort)])
       else
          result := Format('%d%s%d%s', [min, (Time_MinuteShort), sek, (Time_SecShort)]);
    2: result := Format('%d%s%d%s', [std, (Time_HourShort), min, (Time_MinuteShort)]);
       // Inttostr(std) + 'h' + InttoStrZero(min) + 'm';
    3:  if tag <= 3 then
          result := Format('%d %s', [24 * tag + std, (Time_HourShort)])
        else
          result :=  Format('%d %s', [tag, (Time_DaysLong)]);
  end;
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

function SizeToString(Value: Int64): String;
begin

  if Value <= 1024 then
      result := inttostr(Value) + ' Byte; '
  else
      if Value <= 1024*1024 then
          result :=  FloatToStrF((Value / 1024), ffFixed, 4, 0) + 'kb; '
      else
          if Value <= 1024*1024*1024 then
              result := FloatToStrF((Value / 1024 / 1024), ffFixed, 8, 0) + 'mb; '
          else
              result := FloatToStrF((Value / 1024 / 1024 / 1024), ffFixed, 4, 0) + 'gb; ';
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



procedure Wuppdi(i: Integer = 0);
begin
    if i=0 then
        ShowMessage('Wuppdi')
    else
        ShowMessage('Wuppdi '+ IntToStr(i));
end;


end.
