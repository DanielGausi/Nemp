{

    Unit ShoutcastUtils

    - a class for Shoutcast-Support

    Note: This Unit _IS NOT_ the same as the "ShoutcastUtils" that can be downloaded
          at my website. Here are some minor changes done, e.g. in the TuneIn-Method.

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

unit ShoutcastUtils;

interface

uses Windows, SysUtils, Messages, Classes, StrUtils, ContNrs, Math,
    IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
    dialogs, Nemp_RessourceStrings;

const
    // Messages für ShoutcastQuery:
    WM_Shoutcast = WM_USER + 700;
    SCQ_BeginDownload = 1;
    SCQ_ProgressDownload = 2;
    SCQ_FinishedDownload = 3;
    SCQ_AbortedDownload = 4;
    SCQ_ConnectionFailed = 5;
    SCQ_ParsedList = 6;

    ST_PlaylistDownloadConnecting = 20;
    ST_PlaylistDownloadBegins = 21;
    ST_PlaylistDownloadComplete = 22;
    ST_PlaylistDownloadFailed = 23;

    ST_PlaylistStreamLink = 24;


Type
    TSCQueryMode = (QM_Genre, QM_Search);

    TStation = class
        private
            fWindowHandle: HWnd;
            fThread: Integer;

            fName         : String;
            fMediaType    : String;  // mp3, ogg, aac...
            fURL          : String;  // da gehts rein, wenn man manuell was eingibt.
            fBitrate      : Integer;
            fGenre        : String;
            fCurrentTitle : String;
            fCount        : Integer; // Anzahl der Hörer
            fSortIndex    : Integer; // used for a custom sorting of the favorite stations in nemp

            function fGetURL: String;
            procedure fSetURL(Value: String);
            function fGetFormat: String;
            // Rückgabewert: erfolgreich Infos gefunden (True),
            // oder sinnfreier String, d.h. keine Station drinne (False)
            function GetInfoFromString(s: String): Boolean;
            procedure fDownloadPlaylist;

            procedure fStationDownloadWorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);

        public
            property Name: String           read fName         write fName;
            property MediaType: String      read fMediaType    write fMediaType;
            //property ID : String            read fID           ;
            property Bitrate: Integer       read fBitrate      write fBitrate;
            property Format: String         read fGetFormat    ;
            property Genre: String          read fGenre        write fGenre;
            property CurrentTitle: String   read fCurrentTitle ;
            property Count: Integer         read fCount        ;
            property SortIndex: Integer     read fSortIndex    write fSortIndex;
            property URL: String       read fGetURL   write fSetURL;

            constructor Create(aHandle: HWnd);
            destructor Destroy; override;
            procedure Assign(aStation: TStation);

            // Parameter LetBassDoEverything:
            // The bass.dll can handle playlistfiles by itself.
            // Effect: True  -> only one entry will appear in the Nemp Playlist
            //         False -> all mirrors will appear in the Playlist
            procedure TuneIn(LetBassDoEverything: Boolean);
            function GetInfoString: String;

            procedure LoadFromStream(aStream: TStream);
            procedure SaveToStream(aStream: TStream);
    end;

    TShoutcastQuery = class
        private
            fWindowHandle: Hwnd;
            fThread: Integer;
            fDownloadString: String;

            // Threadsafe arbeiten!
            fStatus: Integer;
            fCancelDownload: LongBool;
            fQueryString: String;
            fStationList: TObjectList;

            procedure SetStatus(Value: Integer);
            function GetStatus: Integer;

            procedure SetCancelDownload(Value: LongBool);
            function GetCancelDownload: LongBool;

            procedure SetQueryString(Value: String);
            function GetQueryString: String;

            // Methoden, die im Nebenthread ablaufen:
            procedure fDownloadStationList;
            procedure fParseStationList;

            procedure fDownloadWorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
            procedure fDownloadWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);

            // private Properties
            property QueryString: String read GetQueryString write SetQueryString;


        public
            property Status: Integer read GetStatus write SetStatus;
            property CancelDownload: LongBool read GetCancelDownload write SetCancelDownload;

            constructor Create(aHandle: HWnd);
            destructor Destroy; override;

            procedure DownloadStationList(aQuery: String; aMode: TSCQueryMode);

    end;

    procedure StartPrivateDownloadProcedure(SQ: TShoutcastQuery);
    procedure StartDownloadPlaylist(St: TStation);

    // Überprüft, ob die URL einer Station ein PLaylist-Datei ist
    // oder eine direkte Stream-Adresse
    function UrlIsPlaylist(aURL: String): Boolean;

    function GetProperFilenameForPlaylist(s: AnsiString): String;

    function Sort_Name_Asc(Item1, Item2: Pointer): Integer;
    function Sort_Name_Desc(Item1, Item2: Pointer): Integer;
    function Sort_MediaType_Asc(Item1, Item2: Pointer): Integer;
    function Sort_MediaType_Desc(Item1, Item2: Pointer): Integer;
    function Sort_Genre_Asc(Item1, Item2: Pointer): Integer;
    function Sort_Genre_Desc(Item1, Item2: Pointer): Integer;
    function Sort_CurrentTitle_Asc(Item1, Item2: Pointer): Integer;
    function Sort_CurrentTitle_Desc(Item1, Item2: Pointer): Integer;
    function Sort_Count_Asc(Item1, Item2: Pointer): Integer;
    function Sort_Count_Desc(Item1, Item2: Pointer): Integer;
    function Sort_URL_Asc(Item1, Item2: Pointer): Integer;
    function Sort_URL_Desc(Item1, Item2: Pointer): Integer;


    function Sort_Custom(Item1, Item2: Pointer): Integer;



var
    CSQueryString: RTL_CRITICAL_SECTION;
    CSGetStationList: RTL_CRITICAL_SECTION;

const
    SC_GenreSearchTemplate = 'http://yp.shoutcast.com/sbin/newxml.phtml?genre=';
    SC_SearchTemplate = 'http://yp.shoutcast.com/sbin/newxml.phtml?search=';

    SC_PlaylistTemplate = 'http://yp.shoutcast.com/sbin/tunein-station.pls?id=';

implementation


function DecodeShoutcastString(s: String): String;
var beginPos, endPos: Integer;
    nStr: String;
    n: Integer;
begin
    beginPos := pos('&#', s);
    while beginPos <> 0 do
    begin
        endPos := PosEx(';', s, beginPos);
        nStr := Copy(s, beginPos + 2, endPos - beginPos - 2);
        n := StrToIntDef(nStr, 32);
        s := StringReplace(s, '&#' + nstr + ';', chr(n), [rfReplaceAll]);
        beginPos := pos('&#', s);
    end;
    s := StringReplace(s, '&amp;', '&', [rfReplaceAll]);
    result := s;
end;

function UrlIsPlaylist(aURL: String): Boolean;
var //slash, doubleslash, dp: Integer;
    fz: Integer;
    p: String;
begin
    // Idee: zwischen // und dem ersten / darf kein : (für den Port) stehen.
{    doubleslash := Pos('//', aURL);
    slash := PosEx('/', aURL, doubleslash + 3);
    if slash = 0 then slash := length(aURL);
    dp := PosEx(':', aURL, 6);
    result := (dp = 0) or (dp > slash);
}

  // neue Idee: Am Ende schauen
  if AnsiEndsText('.m3u', aURL) or AnsiEndsText('.pls', aURL)
      or AnsiEndsText('.php', aURL)
      or AnsiEndsText('.asx', aURL)
      or AnsiEndsText('.wax', aURL)

  then
      result := true
  else
  begin
      // ggf. Parameter wegschneiden
      fz := pos('?', aURL);
      if fz > 0 then
      begin
          p := copy(aURL, 1, fz-1);
          result := AnsiEndsText('.m3u', p) or AnsiEndsText('.pls', p)
                  or AnsiEndsText('.php', p)
                  or AnsiEndsText('.asx', p)
                  or AnsiEndsText('.wax', p);
      end else
          result := false;
  end;
end;

function GetProperFilenameForPlaylist(s: AnsiString): String;
var p: integer;
    stmp: String;
    res: String;
begin
    Setlength(res, 256);
    FillChar(PChar(res)^, 256 * SizeOf(Char), 0);
    GetTempPath(256, PChar(res));
    res := trim(res);
    if res[Length(res)] <> '\' then
        res := res + '\';

    stmp := trim(LowerCase(copy(String(s), 1, 20)));
    if AnsiStartsText('<asx', stmp) then
        result := res + 'tmpStation.wax'
    else
    begin
        p := Pos('playlist', stmp);
        if (p <> 0) then
          result := res + 'tmpStation.pls'
        else
          result := res + 'tmpStation.m3u';
    end;
end;


function Sort_Name_Asc(Item1, Item2: Pointer): Integer;
begin
    result := AnsiCompareText(TStation(Item1).Name, TStation(Item2).Name);
end;
function Sort_Name_Desc(Item1, Item2: Pointer): Integer;
begin
    result := AnsiCompareText(TStation(Item2).Name, TStation(Item1).Name);
end;
function Sort_MediaType_Asc(Item1, Item2: Pointer): Integer;
var tmp: Integer;
begin
    tmp := AnsiCompareText(TStation(Item1).MediaType, TStation(Item2).Mediatype);
    if tmp = 0 then
        tmp := CompareValue(TStation(Item1).Bitrate, TStation(Item2).Bitrate);
    if tmp = 0 then
        tmp := AnsiCompareText(TStation(Item1).Name, TStation(Item2).Name);
    result := tmp;
end;
function Sort_MediaType_Desc(Item1, Item2: Pointer): Integer;
var tmp: Integer;
begin
    tmp := AnsiCompareText(TStation(Item2).MediaType, TStation(Item1).Mediatype);
    if tmp = 0 then
        tmp := CompareValue(TStation(Item2).Bitrate, TStation(Item1).Bitrate);
    if tmp = 0 then
        tmp := AnsiCompareText(TStation(Item1).Name, TStation(Item2).Name);
    result := tmp;
end;
function Sort_Genre_Asc(Item1, Item2: Pointer): Integer;
begin
    result := AnsiCompareText(TStation(Item1).Genre, TStation(Item2).Genre);
end;
function Sort_Genre_Desc(Item1, Item2: Pointer): Integer;
begin
    result := AnsiCompareText(TStation(Item2).Genre, TStation(Item1).Genre);
end;
function Sort_CurrentTitle_Asc(Item1, Item2: Pointer): Integer;
begin
    result := AnsiCompareText(TStation(Item1).CurrentTitle, TStation(Item2).CurrentTitle);
end;
function Sort_CurrentTitle_Desc(Item1, Item2: Pointer): Integer;
begin
    result := AnsiCompareText(TStation(Item2).CurrentTitle, TStation(Item1).CurrentTitle);
end;
function Sort_Count_Asc(Item1, Item2: Pointer): Integer;
var tmp: Integer;
begin
    tmp := CompareValue(TStation(Item1).Count, TStation(Item2).Count);
    if tmp = 0 then
        tmp := AnsiCompareText(TStation(Item1).Name, TStation(Item2).Name);
    result := tmp;
end;
function Sort_Count_Desc(Item1, Item2: Pointer): Integer;
var tmp: Integer;
begin
    tmp := CompareValue(TStation(Item2).Count, TStation(Item1).Count);
    if tmp = 0 then
        tmp := AnsiCompareText(TStation(Item1).Name, TStation(Item2).Name);
    result := tmp;
end;

function Sort_URL_Asc(Item1, Item2: Pointer): Integer;
begin
    result := AnsiCompareText(TStation(Item1).URL, TStation(Item2).URL);
end;
function Sort_URL_Desc(Item1, Item2: Pointer): Integer;
begin
    result := AnsiCompareText(TStation(Item2).URL, TStation(Item1).URL);
end;

function Sort_Custom(Item1, Item2: Pointer): Integer;
begin
    result := CompareValue(TStation(Item1).SortIndex, TStation(Item2).SortIndex);
end;




constructor TStation.Create(aHandle: HWnd);
begin
    inherited Create;
    fWindowHandle := aHandle;
    fThread := 0;
end;

destructor TStation.Destroy;
begin
  WaitForSingleObject(fThread, 5000);
  inherited destroy;
end;

procedure TStation.Assign(aStation: TStation);
begin
    fName         := aStation.Name         ;
    fMediaType    := aStation.MediaType    ;
//    fID           := aStation.ID           ;
    fURL          := aStation.fURL         ;
    fBitrate      := aStation.Bitrate      ;
    fGenre        := aStation.Genre        ;
    fCurrentTitle := aStation.CurrentTitle ;
    fCount        := aStation.Count        ;
end;

// Diese Methode bekommt eine Zeile aus dem DownloadString
function TStation.GetInfoFromString(s: String): Boolean;
var beginPos, endPos: Integer;
    IDtmp: String;
begin
    // Aufbau des Strings:
    //<station name="fName" mt="fMediaType" id="fID" br="fBitrate" genre="fGenre" ct="fCurrentTitle" lc="fCount"></station>

    if (pos('<station', s) = 0) or (pos('</station>', s) = 0) then
        result := false
    else
    begin
        beginPos := pos('name="', s);
        if beginPos > 0 then
        begin
            beginPos := beginPos + length('name="');
            endPos   := posEx('"', s, beginPos);
            fName    := DecodeShoutcastString(Copy(s, beginPos, EndPos - beginPos));
        end else
            fName := '';

        beginPos := pos('mt="', s);
        if beginPos > 0 then
        begin
            beginPos   := beginPos + length('mt="');
            endPos     := posEx('"', s, beginPos);
            fMediaType := DecodeShoutcastString(Copy(s, beginPos, EndPos - beginPos));
            if fMediaType = 'audio/mpeg' then
                fMediaType := 'mp3'
            else
                if fMediaType = 'audio/aacp' then
                  fMediaType := 'aac';
        end else
            fMediaType := '';

        beginPos := pos('id="', s);
        if beginPos > 0 then
        begin
            beginPos := beginPos + length('id="');
            endPos   := posEx('"', s, beginPos);
            IDtmp    := DecodeShoutcastString(Copy(s, beginPos, EndPos - beginPos));
            fURL  := SC_PlaylistTemplate + IDtmp;
        end else
        begin
            IDtmp := '';
            fURL := '';
        end;

        beginPos := pos('br="', s);
        if beginPos > 0 then
        begin
            beginPos := beginPos + length('br="');
            endPos   := posEx('"', s, beginPos);
            fBitrate := StrToIntDef(Copy(s, beginPos, EndPos - beginPos), 0);
        end else
            fBitrate := 0;

        beginPos := pos('genre="', s);
        if beginPos > 0 then
        begin
            beginPos := beginPos + length('genre="');
            endPos   := posEx('"', s, beginPos);
            fGenre   := DecodeShoutcastString(Copy(s, beginPos, EndPos - beginPos));
        end else
            fGenre := '';

        beginPos := pos('ct="', s);
        if beginPos > 0 then
        begin
            beginPos := beginPos + length('ct="');
            endPos   := posEx('"', s, beginPos);
            fCurrentTitle   := DecodeShoutcastString(Copy(s, beginPos, EndPos - beginPos));
        end else
            fCurrentTitle := '';

        beginPos := pos('lc="', s);
        if beginPos > 0 then
        begin
            beginPos := beginPos + length('lc="');
            endPos   := posEx('"', s, beginPos);
            fCount   := StrToIntDef(Copy(s, beginPos, EndPos - beginPos),0);
        end else
            fCount := 0;

        result := (fMediaType <> '')
               or (fURL <> '')
               or (fBitrate <> 0)
               or (fGenre <> '')
               or (fCurrentTitle <> '')
               or (fCount <> 0);
    end;
end;

function TStation.fGetURL: String;
begin
    EnterCriticalSection(CSQueryString);
    Result := trim(fURL);
    LeaveCriticalSection(CSQueryString);
end;

procedure TStation.fSetURL(Value: String);
begin
    EnterCriticalSection(CSQueryString);
    fURL := trim(Value);
    LeaveCriticalSection(CSQueryString);
end;

function TStation.fGetFormat: String;
begin
    //if MediaType = 'audio/mpeg' then
    //    result := 'mp3, ' + IntToStr(Bitrate) + 'kbit/s'
    //else
        //if MediaType = 'audio/aacp' then
        //    result := 'aac, ' + IntToStr(Bitrate) + 'kbit/s'
        //else
    if (MediaType <> '') and (Bitrate > 0) then
        result := MediaType + ', ' + IntToStr(Bitrate) + 'kbit/s'
    else
        if Bitrate > 0 then
            result := IntToStr(Bitrate) + 'kbit/s'
        else
            result := Shoutcast_UnknownFormat;
end;


procedure TStation.TuneIn(LetBassDoEverything: Boolean);
var Dummy: Cardinal;
begin
    if LetBassDoEverything then
        // Send message with URL, Bass will handle playlist-stuff
        SendMessage(fWindowHandle, WM_Shoutcast, ST_PlaylistStreamLink, lParam(PChar((URL))))
    else
        // Download Playlist, and load this into NempPlaylist
        fThread := BeginThread(Nil, 0, @StartDownloadPlaylist, Self, 0, Dummy)
end;

procedure StartDownloadPlaylist(St: TStation);
begin
    St.fDownloadPlaylist;
end;

procedure TStation.fDownloadPlaylist;
var IDHttp: TIDHttp;
    s: AnsiString;
    //tmp: AnsiString;
begin
    //tmp := URL;
    //if UrlIsPlaylist(tmp) then
    if UrlIsPlaylist(URL) then
    begin
        // download ausführen
        IDHttp :=  TidHttp.Create;
        try
            IDHttp.ConnectTimeout:= 5000;
            IDHttp.ReadTimeout:= 5000;
            // Hinweis: Der originale Indy-Useragent scheint Probleme zu machen!
            IDHttp.Request.UserAgent := 'Mozilla/3.0';
            IDHttp.HTTPOptions :=  [hoForceEncodeParams];
            IDHttp.OnWorkBegin := fStationDownloadWorkBegin;

            SendMessage(fWindowHandle, WM_Shoutcast, ST_PlaylistDownloadConnecting, 0);
            s := AnsiString(IDHttp.Get(URL));
            SendMessage(fWindowHandle, WM_Shoutcast, ST_PlaylistDownloadComplete, lParam(PAnsiChar(s)));
        except
            SendMessage(fWindowHandle, WM_Shoutcast, ST_PlaylistDownloadFailed,  0);
        end;
        IDHttp.Free;
    end else

    begin
        // URL ist eine direkte Stream-Adresse
        SendMessage(fWindowHandle, WM_Shoutcast,
              ST_PlaylistStreamLink,
              lParam(PChar(String(URL))));
    end;
    CloseHandle(fThread);
    fThread := 0;
end;

procedure TStation.fStationDownloadWorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
begin
    SendMessage(fWindowHandle, WM_Shoutcast, ST_PlaylistDownloadBegins, 0);
end;

function TStation.GetInfoString: String;
begin
    result := Format;
    if Trim(Genre) <> '' then
        result := result + ', ' + Genre;
end;

procedure TStation.LoadFromStream(aStream: TStream);
var len: Integer;
    tmp: UTF8String;
begin
    aStream.Read(fBitrate, SizeOf(Integer));
    aStream.Read(fCount, SizeOf(Integer));

    aStream.Read(len, SizeOf(len));
    // new in Nemp 4.0
    if len = High(Integer) then
    begin
        // we have a "Nemp 4.0 file" with sort-index here
        aStream.Read(fSortIndex, SizeOf(Integer));
        // read the length of the next part (= name)
        aStream.Read(len, SizeOf(len));
    end;
    // end of new in Nemp 4.0

    SetLength(tmp, len);
    aStream.Read(tmp[1], len);
    fName := UTF8ToString(tmp);

    aStream.Read(len, SizeOf(len));
    SetLength(tmp, len);
    aStream.Read(tmp[1], len);
    fMediaType := tmp;

    aStream.Read(len, SizeOf(len));
    SetLength(tmp, len);
    aStream.Read(tmp[1], len);
    fURL := tmp;

    aStream.Read(len, SizeOf(len));
    SetLength(tmp, len);
    aStream.Read(tmp[1], len);
    fGenre := tmp;

    aStream.Read(len, SizeOf(len));
    SetLength(tmp, len);
    aStream.Read(tmp[1], len);
    fCurrentTitle := tmp;
end;
procedure TStation.SaveToStream(aStream: TStream);
var len: Integer;
    tmps: UTF8String;
    tmpi: Integer;
begin
    tmpi := Bitrate;
    aStream.Write(tmpi, SizeOf(Integer));
    tmpi := Count;
    aStream.Write(tmpi, SizeOf(Integer));

    // New in Nemp 4.0
    // !!! Use Fileversion 4.1 (was 4.0 before)
    // determine old/new version by a leading High(Integer)
    tmpi := High(Integer);
    aStream.Write(tmpi, SizeOf(Integer));
    tmpi := SortIndex;
    aStream.Write(tmpi, SizeOf(Integer));
    // end of new in Nemp 4.0

    if Name = '' then tmps := ' ' else tmps := UTF8Encode(Name);
    len := length(tmps);
    aStream.Write(len, SizeOf(len));
    aStream.Write(tmps[1], len);

    if MediaType = '' then tmps := ' ' else tmps := UTF8Encode(MediaType);
    len := length(tmps);
    aStream.Write(len, SizeOf(len));
    aStream.Write(tmps[1], len);

    if URL = '' then tmps := ' ' else tmps := UTF8Encode(URL);
    len := length(tmps);
    aStream.Write(len, SizeOf(len));
    aStream.Write(tmps[1], len);

    if Genre = '' then tmps := ' ' else tmps := UTF8Encode(Genre);
    len := length(tmps);
    aStream.Write(len, SizeOf(len));
    aStream.Write(tmps[1], len);

    if CurrentTitle = '' then tmps := ' ' else tmps := UTF8Encode(CurrentTitle);
    len := length(tmps);
    aStream.Write(len, SizeOf(len));
    aStream.Write(tmps[1], len);
end;




constructor TShoutcastQuery.Create(aHandle: HWnd);
begin
    inherited Create;
    fWindowHandle := aHandle;
    fThread := 0;
    fStationList := TObjectList.Create(False);
end;

destructor TShoutcastQuery.Destroy;
begin
    CancelDownload := True;
    if fThread <> 0 then
        WaitForSingleObject(fThread, 5000);
    fStationList.Free;
    inherited Destroy;
end;

procedure TShoutcastQuery.SetStatus(Value: Integer);
begin
    InterLockedExchange(fStatus, Value);
end;

function TShoutcastQuery.GetStatus: Integer;
begin
    InterLockedExchange(Result, fStatus);
end;

procedure TShoutcastQuery.SetCancelDownload(Value: LongBool);
begin
    InterLockedExchange(Integer(fCancelDownload), Integer(Value));
end;

function TShoutcastQuery.GetCancelDownload: LongBool;
begin
    InterLockedExchange(Integer(Result), Integer(fCancelDownload));
end;

procedure TShoutcastQuery.SetQueryString(Value: String);
begin
    EnterCriticalSection(CSQueryString);
    fQueryString := Value;
    LeaveCriticalSection(CSQueryString);
end;

function TShoutcastQuery.GetQueryString: String;
begin
    EnterCriticalSection(CSQueryString);
    Result := fQueryString;
    LeaveCriticalSection(CSQueryString);
end;


procedure TShoutcastQuery.DownloadStationList(aQuery: String; aMode: TSCQueryMode);
var Dummy: Cardinal;
    s: String;
begin
    if Status = 0 then
    begin
        Status := 1;
        s := StringReplace(aQuery, ' ', '+', [rfReplaceAll]);
        case aMode of
          QM_Genre : QueryString := SC_GenreSearchTemplate + s;
        else
          QueryString := SC_SearchTemplate + s;
        end;
        fThread := BeginThread(Nil, 0, @StartPrivateDownloadProcedure, Self, 0, Dummy);
    end // else
    // Exception? MessageDlg?
end;

procedure StartPrivateDownloadProcedure(SQ: TShoutcastQuery);
begin
    // wieder zurück zur Klasse, aber jetzt im Kontext eines anderen Threads.
    sQ.fDownloadStationList;
end;

// Diese Methode wird NICHT im VCL-Thread ausgeführt!
procedure TShoutcastQuery.fDownloadStationList;
var IDHttp: TIDHttp;
begin
  // hier in eine weitere CS eintreten, damit immer nur ein Thread runterlädt und analysiert
  EnterCriticalSection(CSGetStationList);

  CancelDownload := False;
  IDHttp :=  TidHttp.Create;
  try
      IDHttp.ConnectTimeout:= 5000;
      IDHttp.ReadTimeout:= 5000;
      IDHttp.Request.UserAgent := 'Mozilla/3.0';
      IDHttp.OnWork      := fDownloadWork;
      IDHttp.OnWorkBegin := fDownloadWorkBegin;
      IDHttp.HTTPOptions :=  [hoForceEncodeParams];
      // Daten herunterladen
      fDownloadString := '';
      fDownloadString := IDHttp.Get(QueryString);

      if not CancelDownload then
      begin
          SendMessage(fWindowHandle, WM_Shoutcast, SCQ_FinishedDownload, lParam(PChar(fDownloadString)));
          // Daten analysieren
          fParseStationList;
          SendMessage(fWindowHandle, WM_Shoutcast, SCQ_ParsedList, lParam(fStationList));
      end; // else nichts machen
  except
     if Status <> 0 then
        SendMessage(fWindowHandle, WM_Shoutcast, SCQ_ConnectionFailed, 0);
  end;
  IDHttp.Free;
  Status := 0;
  CloseHandle(fThread);
  fThread := 0;

  //CS wieder verlassen
  LeaveCriticalSection(CSGetStationList);
end;

procedure TShoutcastQuery.fDownloadWorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
begin
    SendMessage(fWindowHandle, WM_Shoutcast, SCQ_BeginDownload, lParam(AWorkCountMax));
end;

procedure TShoutcastQuery.fDownloadWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
begin
  if not CancelDownload then
      SendMessage(fWindowHandle, WM_Shoutcast, SCQ_ProgressDownload, lParam(AWorkCount))
  else
  begin
      // Cancel Download
      SendMessage(fWindowHandle, WM_Shoutcast, SCQ_AbortedDownload, 0);
      Status := 0;
      (ASender as TidHTTP).Disconnect;
  end;
end;

procedure TShoutcastQuery.fParseStationList;
var lbPos, beginPos: Integer;
    s: String;
    newStation: TStation;
begin
    // Alte Liste leeren
    fStationList.Clear;

    lbPos := Pos(#10, fDownloadString);
    beginPos := 1;
    while lbPos > 0 do
    begin
        s := Trim(Copy(fDownloadString, beginPos, lbPos - beginPos)); // nicht +1, das #10 lass ich direkt weg. ;-)

        newStation := TStation.Create(fWindowHandle);
        if newStation.GetInfoFromString(s) then
            // Station einfügen
            fStationList.Add(NewStation)
        else
            // War wohl nix. ;-)
            newStation.Free;

        beginPos := lbPos + 1;
        lbPos := PosEx(#10, fDownloadString, lbPos + 1);
    end;
end;


initialization

  InitializeCriticalSection(CSQueryString);
  InitializeCriticalSection(CSGetStationList);

finalization

  DeleteCriticalSection(CSQueryString);
  DeleteCriticalSection(CSGetStationList);

end.
