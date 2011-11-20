{

  unit CustomizedScrobbler

  Part of
  ScrobblerUtils

  A Borland/Codegear/Embarcadero Delphi-Class for Last.Fm scrobbling support.
  See http://www.last.fm in case you dont know what "scrobbling" means

}


unit CustomizedScrobbler;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, ShellApi, DateUtils,
  IniFiles, Contnrs, ScrobblerUtils, md5, AudioFileClass,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IdStack, IdException;

type

    // class TMyApplicationScrobbler

    // Example how to use ScrobblerUtils in an application
    // You MUST use your own class "TMyApplicationScrobbler",
    // where you manage ApiKey/Secret and UserData the way you want

    TNempScrobbler = class(TApplicationScrobbler)
        private
            fLastCall: TDateTime;

            function EncodeSessionKey(PlainKey: String): String;
            function DecodeSessionKey(CryptedKey: String): String;

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
    // 'f7fa672081fb6bf5a1e9ae618dcd4fdf';
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
    // MyAPISecret = 'a8e2b589b4ef051044fabc287f9e09bd';

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
        result := PlainKey;
end;

function TNempScrobbler.DecodeSessionKey(CryptedKey: String): String;
var cryptedDigest, VolumeSrnNrDigest, FolderDigest, resultDigest: TMD5Digest;
    i: Integer;
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
            resultDigest.v[i] := (cryptedDigest.v[i] + 256 + 256 - VolumeSrnNrDigest.v[i] - FolderDigest.v[i]) Mod 256;

        result := Lowercase(MD5DigestToStr(resultDigest));
    end
    else
        result := CryptedKey;
end;


procedure TNempScrobbler.LoadFromIni(Ini: TMemIniFile);
var cryptedKey: String;
begin
    // Der quasi allzeit gültige Session-Key
    cryptedKey := Ini.ReadString('Scrobbler', 'SessionKey', '');
    SessionKey := DecodeSessionKey(cryptedKey);

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
        LogList.Add('Sessionkey: ' + Sessionkey);
    end;

    AlwaysScrobble := Ini.ReadBool('Scrobbler', 'AlwaysScrobble', False);
    DoScrobble := AlwaysScrobble;
    IgnoreErrors := Ini.ReadBool('Scrobbler', 'IgnoreErrors', True);


   {
    // The SessionKey (unfinite lifetime)
    SessionKey := AnsiString(Ini.ReadString('Scrobbler', 'SessionKey', ''));
    // Username of the lastFM user
    Username   := Ini.ReadString('Scrobbler', 'Username', '');
    if (Username = '') or (SessionKey = '') then
    begin
        LogList.Add('Loading Settings: No username/sessionkey found.');
    end
    else
    begin
        LogList.Add('Username: ' + Username);
        LogList.Add('Sessionkey: ' + String(Sessionkey));
    end;

    AlwaysScrobble := Ini.ReadBool('Scrobbler', 'AlwaysScrobble', False);
    DoScrobble := AlwaysScrobble;
    }
end;
procedure TNempScrobbler.SaveToIni(Ini: TMemIniFile);
var cryptedKey: String;
begin
    cryptedKey := EncodeSessionKey(SessionKey);
    Ini.WriteString('Scrobbler', 'SessionKey', cryptedKey);
    Ini.WriteString('Scrobbler', 'Username', Username);

    Ini.WriteBool('Scrobbler', 'AlwaysScrobble', AlwaysScrobble);
    Ini.WriteBool('Scrobbler', 'IgnoreErrors', IgnoreErrors);

    //Ini.WriteString('Scrobbler', 'SessionKey', String(SessionKey));
    //Ini.WriteString('Scrobbler', 'Username', Username);
    //Ini.WriteBool('Scrobbler', 'AlwaysScrobble', AlwaysScrobble);
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
        fPlayingFile.TrackNr := UTF8Encode(IntToStr(aAudioFile.Track))
    else
        fPlayingFile.TrackNr := '';

    // zusätzlich fürs Submitten:
    StartTimeDelphi := EncodeDateTime(s.wYear, s.wMonth, s.wDay, s.wHour, s.wMinute, s.wSecond, s.wMilliSeconds);
    diff := Round((StartTimeDelphi - UnixStartDate) * 86400); // 86400: Sekunden pro Tag
    fPlayingFile.StartTime := UTF8Encode(IntToStr(Diff));


    fNewFile := True;
    fCurrentFileAdded := False;
end;

function TNempScrobbler.GetTags(aAudioFile: tAudioFile): UnicodeString;
var url: UTF8String;
    aIDHttp: TIdHttp;
    raw: String;
    n: Dword;
begin
    if not assigned(aAudioFile) then
    begin
        result := '';
        exit;
    end;

{    // We MUST NOT call this methode more than 5x per second.
    // So: Sleep for a while before the next call.
    // DO NOT Change this - Otherwise Nemp could be banned from LastFM-Services!
    n := GetTickCount;
    if n - fLastCall < 250 then  // ok, this will result in 3-4 calls per second.
        sleep(250);

    fLastCall := GetTickCount;
    url := 'http://ws.audioscrobbler.com/2.0/?method=track.gettoptags'
    + '&artist=' + StringToURLStringAnd(AnsiLowerCase(aAudioFile.Artist))
    + '&track='  + StringToURLStringAnd(AnsiLowerCase(aAudioFile.Titel))
    + '&api_key=' + api_key;


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
}
end;

end.
