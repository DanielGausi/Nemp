{

    Unit CustomizedScrobbler

    - a customized ApplicationScrobbler, for Nemp

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


unit CustomizedScrobbler;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, ShellApi, DateUtils,
  IniFiles, Contnrs, ScrobblerUtils, md5, NempAudioFiles, StrUtils,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  IdStack, IdException, HTMLHelper;

type

    TNempScrobbler = class(TApplicationScrobbler)
        private
            fLastCall: TDateTime;

            //function EncodeSessionKey(PlainKey: String): String;
            //function DecodeSessionKey(CryptedKey: String): String;

            // a poor replacement for the previous encodings, but it should be sufficient
            function Rot13(aString: String): String;

            function ParseRawTag(aRawString: String; aAudioFile: TAudioFile): String;
        protected
            function GenerateSignature(SortedParams: UnicodeString): UnicodeString; override;
        public
            IgnoreErrors: Boolean;

            procedure LoadFromIni(Ini: TMemIniFile);
            procedure SaveToIni(Ini: TMemIniFile);

            procedure InitScrobbler;
            procedure JobStarts;

            procedure ChangeCurrentPlayingFile(aAudioFile: TAudioFile);
            function GetTags(aAudioFile: tAudioFile): UnicodeString;
    end;


implementation

uses Systemhelper;

function MD5UTF8String(const S: UTF8String): TMD5Digest;
begin
  Result:=MD5Buffer(PAnsiChar(S)^, Length(S));
end;

function MD5StringToDigest(const aString: String): TMD5Digest;
var i: Integer;
    aByteStr: String;
begin
    if length(aString) <> 32 then
    begin
        for i := 0 to 15 do
            result.v[i] := 0;
    end
    else
        for i := 0 to 15 do
        begin
            aByteStr := '$' + aString[2*i + 1] + aString[2*i + 2];
            result.v[i] := StrToIntDef(aByteStr, 0);
        end;
end;


procedure TNempScrobbler.InitScrobbler;
begin
    {.$MESSAGE 'YOU MUST NOT USE THIS KEY/SECRET IN YOUR APPLICATION. GO TO LAST.FM AND GET YOUR OWN!'}
    ApiKey := '542ec0c3e5e7b84030181176f3d0f264'
end;

procedure TNempScrobbler.JobStarts;
begin
    BeginWork;
end;


function TNempScrobbler.GenerateSignature(
  SortedParams: UnicodeString): UnicodeString;
var RawSig: UTF8String;
const
    bd7fab7ec5900abf : Array[0..15] of Byte = ( $8a, $60, $99, $bf, $55, $74, $b4, $8a, $08, $46, $ff, $18, $49, $9e, $a2, $7c);
    effa65ecb689fccd : Array[0..15] of Byte = ( $95, $7b, $d2, $30, $20, $a0, $2c, $48, $d4, $4b, $3d, $25, $25, $e3, $4f, $4f);

    function faae65f530febc67: string;
    var i: integer;
    begin
        result := '';
        for i := 0 to 15 do
            result := result + IntToHex( (bd7fab7ec5900abf[i] + effa65ecb689fccd[i]) mod 256, 2);

        result := lowercase(result);
    end;

begin
    RawSig := UTF8Encode(SortedParams + faae65f530febc67);
    result := Lowercase(MD5DigestToStr(MD5UTF8String(RawSig)));
end;


(*
Session Keys are no longer md5-formatted strings. This method does not work anymore.
function TNempScrobbler.EncodeSessionKey(PlainKey: String): String;
var plainDigest, VolumeSrnNrDigest, FolderDigest, resultDigest: TMD5Digest;
    i: Integer;
const CSIDL_APPDATA = $001a;
begin
    if length(PlainKey) = 32 then
    begin
        //  PlainKey in Ziffern übersetzen
        plainDigest := MD5StringToDigest(PlainKey);
        //die anderen HashSummen ermitteln
        VolumeSrnNrDigest := MD5String(AnsiString(GetVolumeSerialNr('C')));
        FolderDigest      := MD5String(AnsiString(GetShellFolder(CSIDL_APPDATA)));

        // addieren
        for i := 0 to 15 do
            resultDigest.v[i] := (plainDigest.v[i] + VolumeSrnNrDigest.v[i] + FolderDigest.v[i]) Mod 256;

        result := Lowercase(MD5DigestToStr(resultDigest));
    end
    else
    begin
        result := PlainKey;
    end;
end;

function TNempScrobbler.DecodeSessionKey(CryptedKey: String): String;
var cryptedDigest, VolumeSrnNrDigest, FolderDigest, resultDigest: TMD5Digest;
    i, tmp: Integer;
const CSIDL_APPDATA = $001a;
begin
    if length(CryptedKey) = 32 then
    begin
        //  PlainKey in Ziffern übersetzen
        cryptedDigest := MD5StringToDigest(CryptedKey);
        //die anderen HashSummen ermitteln
        VolumeSrnNrDigest := MD5String(AnsiString(GetVolumeSerialNr('C')));
        FolderDigest      := MD5String(AnsiString(GetShellFolder(CSIDL_APPDATA)));

        // addieren
        for i := 0 to 15 do
        begin
            tmp := (cryptedDigest.v[i] + 256 + 256 - VolumeSrnNrDigest.v[i] - FolderDigest.v[i]);
            resultDigest.v[i] := tmp mod 256;
            //(cryptedDigest.v[i] {+ 256 + 256 }- VolumeSrnNrDigest.v[i] - FolderDigest.v[i]) Mod 256;
        end;
        result := Lowercase(MD5DigestToStr(resultDigest));
    end
    else
    begin
        result := CryptedKey;
    end;
end;
*)


procedure TNempScrobbler.LoadFromIni(Ini: TMemIniFile);
var cryptedKey: String;
begin
    // Der quasi allzeit gültige Session-Key
    cryptedKey := Ini.ReadString('Scrobbler', 'SessionKey', '');


    //SessionKey := AnsiString(DecodeSessionKey(cryptedKey));
    SessionKey := AnsiString(Rot13(cryptedKey));

    Username   := Ini.ReadString('Scrobbler', 'Username', '');
    if (Username = '') or (SessionKey = '') then
    begin
        //Status := hs_UNAUTHORIZED;
        LogList.Add('Loading Settings: No username/sessionkey found.');
    end
    else
    begin
        //Status := hs_OK;
        LogList.Add('Username: ' + Username);
        LogList.Add('Sessionkey: ' + UnicodeString(Sessionkey));
    end;

    AlwaysScrobble := Ini.ReadBool('Scrobbler', 'AlwaysScrobble', False);
    DoScrobble := AlwaysScrobble;
    IgnoreErrors := Ini.ReadBool('Scrobbler', 'IgnoreErrors', True);
end;
procedure TNempScrobbler.SaveToIni(Ini: TMemIniFile);
var cryptedKey: String;
begin
    //cryptedKey := EncodeSessionKey(UnicodeString(SessionKey));
    cryptedKey := Rot13(UnicodeString(SessionKey));

    Ini.WriteString('Scrobbler', 'SessionKey', cryptedKey);
    Ini.WriteString('Scrobbler', 'Username', Username);

    Ini.WriteBool('Scrobbler', 'AlwaysScrobble', AlwaysScrobble);
    Ini.WriteBool('Scrobbler', 'IgnoreErrors', IgnoreErrors);
end;

procedure TNempScrobbler.ChangeCurrentPlayingFile(aAudioFile: TAudioFile); // setzt das aktuelle Audiofile um und scrobbelt es ggf.
var s: TSystemTime;
    StartTimeDelphi: TDateTime;
    diff: LongInt;
begin
    GetSystemTime(s);


    fPlayingFile.DisplayTitle := aAudioFile.Artist + ' - ' + aAudioFile.Titel;

    fPlayingFile.Interpret := aAudioFile.Artist;
    fPlayingFile.Title     := aAudioFile.Titel;
    fPlayingFile.Album     := aAudioFile.Album;
    fPlayingFile.Length    := IntToStr(aAudioFile.Duration);
    fPlayingFile.MBTrackID := '';

    if aAudioFile.Track <> 0 then
        fPlayingFile.TrackNr := IntToStr(aAudioFile.Track)
    else
        fPlayingFile.TrackNr := '';

    // zusätzlich fürs Submitten:
    StartTimeDelphi := EncodeDateTime(s.wYear, s.wMonth, s.wDay, s.wHour, s.wMinute, s.wSecond, s.wMilliSeconds);
    diff := Round((StartTimeDelphi - UnixStartDate) * 86400); // 86400: Sekunden pro Tag
    fPlayingFile.StartTime := IntToStr(Diff);


    fNewFile := True;
    fCurrentFileAdded := False;
end;

function TNempScrobbler.ParseRawTag(aRawString: String; aAudioFile: TAudioFile): String;
var oneTag, name, c: String;
    tagBegin, tagEnd: Integer;
    name1, name2, c1, c2: Integer;
begin

    tagBegin := pos('<tag>', aRawString);
    tagEnd := pos('</tag>', aRawString);
    result := '';
    while (tagBegin <> 0) do
    begin
        oneTag := copy(aRawString, tagBegin + 5, tagEnd - tagBegin - 5);

        name1 := pos('<name>', oneTag);
        name2 := pos('</name>', oneTag);
        name := ParseHTMLChars(copy(oneTag, name1 + 6, name2 - name1 - 6));

        c1 := pos('<count>', oneTag);
        c2 := pos('</count>', oneTag);
        c := copy(oneTag, c1 + 7, c2 - c1 - 7);

        if StrToIntDef(c, -1) >= 10 then          // ToDo: MinValue veränderbar, settings
        if result = '' then
            result := name
        else
            result := result + #13#10 + name;
            // note: if we change the #13#10 here, we MUST also change it in TagCloud.RenameTag

        tagBegin := posEx('<tag>', aRawString, tagEnd);
        tagEnd := posEx('</tag>', aRawString, tagEnd + 4);
    end;
end;

function TNempScrobbler.Rot13(aString: String): String;
var i: Integer;
begin
    result := aString;
    for i := 1 to length(aString) do
    case aString[i] of
        'A'..'Z': result[i] := chr((ord(aString[i])-ord('A')+13) mod 26+ord('A'));
        'a'..'z': result[i] := chr((ord(aString[i])-ord('a')+13) mod 26+ord('a'));
        '0'..'9': result[i] := chr((ord(aString[i])-ord('0')+5) mod 10+ord('0'));
    end;
end;

function TNempScrobbler.GetTags(aAudioFile: tAudioFile): UnicodeString;
var url: String;
    aIDHttp: TIdHttp;
    raw: String;
    n: Dword;
begin
    if not assigned(aAudioFile) then
    begin
        result := '';
        exit;
    end;

    // We MUST NOT call this methode more than 5x per second.
    // So: Sleep for a while before the next call.
    // DO NOT Change this - Otherwise Nemp could be banned from LastFM-Services!
    n := GetTickCount;
    if n - fLastCall < 250 then  // ok, this will result in 3-4 calls per second.
        sleep(250);

    fLastCall := GetTickCount;
    url := 'http://ws.audioscrobbler.com/2.0/?method=track.gettoptags'
    + '&artist=' + StringToURLStringAnd(Utf8String(AnsiLowerCase(aAudioFile.Artist)))
    + '&track='  + StringToURLStringAnd(Utf8String(AnsiLowerCase(aAudioFile.Titel)))
    + '&api_key=' + String(ApiKey);

    aIDHttp := TIdHttp.Create;
    try
        aIDHttp.ConnectTimeout:= 20000;
        aIDHttp.ReadTimeout:= 20000;
        aIDHttp.Request.UserAgent := 'Mozilla/3.0';
        aIDHttp.HTTPOptions :=  [];
        try
            raw := aIDHttp.Get(url);
        except
            raw := '';
        end;
        result := ParseRawTag(raw, Nil);

    finally
        aIDhttp.Free;
    end;
end;

end.
