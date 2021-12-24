{*******************************************************}
{                                                       }
{                    Nemp API                           }
{                                                       }
{       Copyright (c) 2007, Daniel Gaußmann             }
{                  www.gausi.de                         }
{                                                       }
{*******************************************************}

{
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following condition
is met:

Redistributions of source code must retain the above
copyright notice, this list of conditions and the following disclaimer.
  
THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS
“AS IS” AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
}


unit NempApi;

{$I ..\xe.inc}

interface

uses Windows, Messages, SysUtils, AnsiStrings;

// Ober-Prozedur fürs Setzen eines Wertes in Nemp/Winamp per WM_USER Nachricht
procedure SetNemp_User(value, kind: Integer);
// Ober-Prozedur fürs auslesen eines Wertes per WM_USER
function GetNemp_User(param, kind: Integer): Integer;

// Index des aktuellen Stückes in der Playlist bestimmen
function GetNempPlayListPos: Integer;                    // Nemp / Winamp
// Index setzen
procedure SetNempPlayListPos(idx: Integer);              // Nemp / Winamp (!)   // (!): Nemp spielt diesen Titel dann auch ab
                                                                                //      Winamp macht dann nix weiter.
                                                                                
// Strings aus der Playlist auslesen...
function GetNemp_PlaylistString(param, kind: Integer): AnsiString;  // -
function GetNempPlaylistFilename(data:Integer): AnsiString;         // Nemp / Winamp
function GetNempPlaylistTitel(data:Integer): AnsiString;            // Nemp / Winamp
function GetNempPlaylistAlbum(data:Integer): AnsiString;            // Nemp
function GetNempPlaylistArtist(data:Integer): AnsiString;           // Nemp
function GetNempPlaylistTitleOnly(data:Integer): AnsiString;        // Nemp
// ... und aus der Anzeigeliste
function GetNemp_SearchListString(param, kind: Integer): AnsiString;  // -
function GetNempSearchlistFilename(data:Integer): AnsiString;         // Nemp
function GetNempSearchlistTitel(data:Integer): AnsiString;            // Nemp
function GetNempSearchlistAlbum(data:Integer): AnsiString;            // Nemp
function GetNempSearchlistArtist(data:Integer): AnsiString;           // Nemp
function GetNempSearchlistTitleOnly(data:Integer): AnsiString;        // Nemp

function GetNempCurrentTitle(kind: Integer): AnsiString;  // Nemp (version 4.6)

function GetNempNextTitel:AnsiString;                // Nemp / Winamp
function GetNempPrevTitel:AnsiString;                // Nemp / Winamp

// WideString-Variante
// aus der Playlist auslesen
function GetNemp_PlaylistStringW(param, kind: Integer): WideString;  // -
function GetNempPlaylistFilenameW(data:Integer): WideString;         // Nemp
function GetNempPlaylistTitelW(data:Integer): WideString;            // Nemp
function GetNempPlaylistAlbumW(data:Integer): WideString;            // Nemp
function GetNempPlaylistArtistW(data:Integer): WideString;           // Nemp
function GetNempPlaylistTitleOnlyW(data:Integer): WideString;        // Nemp
// aus der Anzeigeliste auslesen
function GetNemp_SearchListStringW(param, kind: Integer): WideString;  // -
function GetNempSearchlistFilenameW(data:Integer): WideString;         // Nemp
function GetNempSearchlistTitelW(data:Integer): WideString;            // Nemp
function GetNempSearchlistAlbumW(data:Integer): WideString;            // Nemp
function GetNempSearchlistArtistW(data:Integer): WideString;           // Nemp
function GetNempSearchlistTitleOnlyW(data:Integer): WideString;        // Nemp

function GetNempCurrentTitleW(kind: Integer): WideString;  // Nemp (version 4.6)

function GetNempNextTitelW:WideString;           // Nemp
function GetNempPrevTitelW:WideString;           // Nemp

// Länge der Playlist/Searchlist in Tracks
function GetNempPlayListLength: Integer;        // Nemp / Winamp
function GetNempSearchListLength: Integer;      // Nemp
// Länge der Stücke in der Liste
function GetNempPlaylistTrackLength(idx: Integer): Integer;       // Nemp
function GetNempSearchlistTrackLength(idx: Integer): Integer;     // Nemp

// Position des aktuellen Tracks in Millisekunden
function GetNemp_TrackPosition: integer;                   // Nemp / Winamp
//Länge des aktuellen Tracks in Sekunden
function GetNemp_TrackLength: integer;                     // Nemp / Winamp
// Setzt Position im aktuellen Track neu
function SetNemp_TrackPosition(NewPos: Integer): Integer;  // Nemp / Winamp

// Volume setzen
procedure SetNemp_Volume(Vol: Byte);       // Nemp / Winamp
function GetNemp_Volume:Integer;           // Nemp

function GetNemp_Samplerate: Integer;      // Nemp / Winamp
function GetNemp_Bitrate: Integer;         // Nemp / Winamp
function GetNemp_Channels: Integer;        // Nemp / Winamp

// Equalizer setzen
procedure SetNemp_Equalizer(Band: Integer; Value: Integer);    // Nemp / Winamp (!)     // Value zwischen  0..60  (Winamp: 0..63)
// Equalizer auslesen                                                                   // Band zwischen 0..9
function GetNemp_Equalizer(Band: Integer): Integer;            // Nemp / Winamp (!)     // Winamp: Version 2.92 oder höher benötigt!

procedure SetNemp_EchoTime(Time: Integer);       // Nemp  //Time zwischen 100...2000
procedure SetNemp_EchoMix(Mix: Integer);         // Nemp  //Mix zwischen 0..50
function GetNemp_EchoTime: Integer;              // Nemp
function GetNemp_EchoMix: Integer;               // Nemp

procedure SetNemp_Hall(value: Integer);         // Nemp   // Value zwischen -96..0
function GetNemp_Hall: Integer;                 // Nemp

procedure SetNemp_Speed(value:Integer);         // Nemp   // Value zwischen 67..133
function GetNemp_Speed: Integer;                // Nemp

function GetNempRandomMode: Integer;            // Nemp / Winamp  (!)
                                                // Ergebnis N/W:   0 : Zufallswiedergabe aus
                                                //                 1 : Zufallswiedergabe an
                                                // Ergebnis Nemp:  2 : Repeat-Titel
                                                //                 3 : No Repeat

// Function GetRepeatMode: Integer
// Bei Nemp ist repeat IMMER an. Wiedergabemodus der Playlist:
// Repeat-Alles, Zufallswiedergabe, Repeat-Titel

// Result: 1: Playing, 3: Paused, 0: Not Playing
function GetNempState: integer;                   // Nemp / Winamp

procedure NempPlayNext;    // Nemp / Winamp
procedure NempPlayPrev;    // Nemp / Winamp
procedure NempPlay;        // Nemp / Winamp
procedure NempPause;       // Nemp / Winamp
procedure NempStop;        // Nemp / Winamp
procedure NempVolumeUp;    // Nemp / Winamp
procedure NempVolumeDown;  // Nemp / Winamp
procedure NempRestore;     // Nemp


// Routinen für die Suche - Das Fremdprogramm kann hiermit Strings/WideStrings an Nemp senden
procedure Nemp_SendSearchString(Source: HWND; aString: AnsiString);  // Nemp
// Mode gibt an: Enqueue, PlayNext, Play
procedure Nemp_SendFileForPlaylist(Source: HWND; aFilename: AnsiString; Mode: Cardinal);  // Nemp

// WideString-Variante der Suche
procedure Nemp_SendSearchStringW(Source: HWND; aWideString: WideString);                    // Nemp
procedure Nemp_SendFileForPlaylistW(Source: HWND; aFilename: WideString; Mode: Cardinal);   // Nemp

// result: 1: Suche beendet, Abfragen der Ergebnisliste kann anfangen
//         0: Suche läuft noch  
function Nemp_GetSearchStatus: Integer;                          // Nemp

// Anfrage an Nemp bzgl. des Covers zum aktuellen Lied
// True: Bild existiert, wird per WM_CopyData nachgeliefert
// False: Nemp hat kein Bild zum Lied.
function Nemp_QueryCover(QueryHnd: HWND): Integer;

procedure Nemp_SetDisplayApp(value: Boolean);


const
        // Konstanten, die auch für Winamp genutzt werden können
        Nemp_BUTTON1   =  40044; // previous title
        Nemp_BUTTON2   =  40045; // play
        Nemp_BUTTON3   =  40046; // pause
        Nemp_BUTTON4   =  40047; // stop
        Nemp_BUTTON5   =  40048; // next title
        Nemp_VOLUMEUP  =  40058; // volume up
        Nemp_VOLUMEDOWN=  40059; // volume down

        IPC_MODE_SAMPLERATE = 0;
        IPC_MODE_BITRATE = 1;
        IPC_MODE_CHANNELS = 2;

        IPC_PLAYFILE    = 100;      // In der Winamp-Api auch doppelt.
        IPC_ENQUEUEFILE = 100;      //

        IPC_ISPLAYING  = 104;
        IPC_GETOUTPUTTIME = 105;
        IPC_JUMPTOTIME = 106;

        IPC_SETPLAYLISTPOS = 121;

        IPC_SETVOLUME  = 122;
        IPC_GETLISTLENGTH  = 124;
        IPC_GETLISTPOS  = 125;

        IPC_GETINFO = 126;
        IPC_GETEQDATA = 127;
        IPC_SETEQDATA = 128;

        IPC_GETPLAYLISTFILE  = 211;
        IPC_GETPLAYLISTTITLE = 212;

        IPC_GET_SHUFFLE  = 250;
        IPC_GET_REPEAT  = 251;
        IPC_SET_SHUFFLE = 252;

        //Nemp-Spezifisch. Gibts nicht bei Winamp
        IPC_GETREVERB = 42001;           
        IPC_SETREVERB = 42002;
        IPC_GETECHOTIME = 42003;         
        IPC_SETECHOTIME = 42004;
        IPC_GETECHOMIX = 42005;          
        IPC_SETECHOMIX = 42006;
        IPC_GETSPEED = 42007;
        IPC_SETSPEED = 42008;
        //Suchanfragen
        IPC_QUERY_SEARCHSTATUS = 42009;
        IPC_SEND_SEARCHSTRING = 42010;
        IPC_SEND_FILEFORPLAYLIST = 42040;
        // WideStringSuche
        IPC_SEND_SEARCHSTRING_W = 52010;
        IPC_SEND_FILEFORPLAYLIST_W = 52040;

        IPC_GETSEARCHLISTLENGTH  = 42124;
        IPC_GETSEARCHLISTFILE  = 42211;
        IPC_GETSEARCHLISTTITLE = 42212;

        // Details zu Playlist/Searchlist
        IPC_GETPLAYLISTARTIST     = 42213;
        IPC_GETPLAYLISTALBUM      = 42214;
        IPC_GETPLAYLISTTITLEONLY  = 42215;
        IPC_GETSEARCHLISTARTIST    = 42216;
        IPC_GETSEARCHLISTALBUM     = 42217;
        IPC_GETSEARCHLISTTITLEONLY = 42218;

        // Unterschied zu GetOutputTime: Im Parameter kommt der Trackindex, nicht ein Flag für Dauer/Pos
        IPC_GETPLAYLISTTRACKLENGTH = 42219;
        IPC_GETSEARCHLISTTRACKLENGTH = 42220;

        // WideString-Varianten
        // --------------------------------------
        IPC_GETPLAYLISTFILE_W   = 51211;
        IPC_GETPLAYLISTTITLE_W  = 51212;
        IPC_GETSEARCHLISTFILE_W  = 52211;
        IPC_GETSEARCHLISTTITLE_W = 52212;
        // Details zu Playlist/Searchlist
        IPC_GETPLAYLISTARTIST_W     = 52213;
        IPC_GETPLAYLISTALBUM_W      = 52214;
        IPC_GETPLAYLISTTITLEONLY_W  = 52215;
        IPC_GETSEARCHLISTARTIST_W    = 52216;
        IPC_GETSEARCHLISTALBUM_W     = 52217;
        IPC_GETSEARCHLISTTITLEONLY_W = 52218;

        // Nemp_Only (4.6, December 2012)
        IPC_GETCURRENTTITLEDATA = 42222;     // Filename/Title/Artist/... by second parameter
        IPC_GETCURRENTTITLEDATA_W = 52222;   // IPC_CF_***
        IPC_CF_FILENAME  = 0;
        IPC_CF_TITLE     = 1;
        IPC_CF_ARTIST    = 2;
        IPC_CF_TITLEONLY = 3;
        IPC_CF_ALBUM     = 4;

        // Nemp 4.7
        // Notify Nemp Window to set the Display-App-Setting
        // True/False in second Parameter
        IPC_SETUSEDISPLAYAPP = 52500;


        // Anfrage zum Cover:
        IPC_QUERYCOVER = 52400;
        IPC_SENDCOVER = 52401;

        // Eine SetVolume-Konstante scheint es bei Winamp nicht zu geben
        IPC_GETVOLUME = 42221;

        // Stellt das Nemp-Fenster wieder her
        COMMAND_RESTORE = 43001;

        //----------------------------------------

        // Aus dem Nemp-Code
        // Konstanten für den Modus, wie die Dateien abgespielt werden sollen
        PLAYER_ENQUEUE_FILES = 0;
        PLAYER_PLAY_FILES = 1;
        PLAYER_PLAY_NEXT = 2;
        PLAYER_PLAY_NOW = 3;
        PLAYER_PLAY_DEFAULT = 4;
        PLAYER_PLAY_ABORT = 5;

        NEMP_API_STOPPED = 0;
        NEMP_API_PLAYING = 1;
        NEMP_API_PAUSED = 3;
        NEMP_API_REPEATALL = 0;
        NEMP_API_REPEATTITEL = 1;
        NEMP_API_SHUFFLE = 2;
        NEMP_API_NOREPEAT = 3;  // Neu in Nemp 3.1

        NEMP_WINDOW_NAME = 'TNemp_MainForm';
        WINAMP_WINDOW_NAME = 'Winamp v1.x';

        // Strings zur Registrierung diverser Messages, die Nemp an ein Deskband (!) sendet
        // Klassenname der Hauptform des Deskbandes muss "TNempDeskBand" sein
        NEMP_DESKBAND_ACTIVATE: array [0..MAX_PATH] of Char = 'NEMP - Deskband Activate'#0;
        NEMP_DESKBAND_DEACTIVATE: array [0..MAX_PATH] of Char = 'NEMP - Deskband Deactivate'#0;
        NEMP_DESKBAND_UPDATE: array [0..MAX_PATH] of Char = 'NEMP - Deskband Update'#0;

var
    NempDeskbandActivateMessage: UINT = 0;
    NempDeskbandDeActivateMessage: UINT = 0;
    NempDeskbandUpdateMessage: UINT = 0;

    WINDOW_NAME : String =  NEMP_WINDOW_NAME;


implementation



procedure SetNemp_User(value, kind: Integer);
var hwndNemp:THandle;
begin
  hwndNemp := FindWindow(PChar(WINDOW_NAME),nil);
  if hwndNemp <> 0 then
      SendMessage(hwndNemp, WM_USER, value, kind);
end;

function GetNemp_User(param, kind: Integer): Integer;
var hwndNemp:THandle;
begin
  hwndNemp:= FindWindow(PChar(WINDOW_NAME),nil);
  if hwndNemp = 0 then
    result:=-1
  else
    result := SendMessage(hwndNemp,WM_USER, param , kind);
end;

function GetNempPlayListPos: Integer;
begin
  result := GetNemp_User(0,IPC_GETLISTPOS);
end;

procedure SetNempPlayListPos(idx: Integer);
begin
  SetNemp_User(idx, IPC_SETPLAYLISTPOS);
end;

function GetNemp_PlaylistString(param, kind: Integer): AnsiString;
var hwndNemp, TempHandle : THandle;
    dat2: array[0..500] of AnsiChar;
    TrackPos: Integer;
    MPointer: Integer;

    {$IFDEF OLDREADPROCESSMEMORY}
    temp: Cardinal;
    {$ELSE}
    temp: NativeUInt;
    {$ENDIF}
begin
    hwndNemp := FindWindow(PChar(WINDOW_NAME),nil);
    if hwndNemp = 0 then
    begin
        result := ''
    end else
    begin
        if param < 0 then
          TrackPos := SendMessage(hwndNemp, WM_USER,0 , IPC_GETLISTPOS)
        else
          TrackPos := param;
        MPointer := SendMessage(hwndNemp, WM_USER, TrackPos , kind);
        if MPointer = -1 then
        begin
          result := '';
          exit;
        end;
        GetWindowThreadProcessId(hwndNemp, @TempHandle);
        hwndNemp := OpenProcess(PROCESS_VM_READ, False, TempHandle);
        ReadProcessMemory(hwndNemp, Pointer(MPointer), @dat2, 500, temp);
        CloseHandle(hwndNemp);
        Result := AnsiString(dat2);
    end;
end;

function GetNempPlaylistFilename(data:Integer): AnsiString;
begin
  result := GetNemp_PlaylistString(data, IPC_GETPLAYLISTFILE);
end;

function GetNempPlaylistTitel(data:Integer): AnsiString;
begin
  result := GetNemp_PlaylistString(data, IPC_GETPLAYLISTTITLE);
end;

function GetNempPlaylistAlbum(data:Integer): AnsiString;
begin
  result := GetNemp_PlaylistString(data, IPC_GETPLAYLISTALBUM);
end;
function GetNempPlaylistArtist(data:Integer): AnsiString;
begin
  result := GetNemp_PlaylistString(data, IPC_GETPLAYLISTARTIST);
end;
function GetNempPlaylistTitleOnly(data:Integer): AnsiString;
begin
  result := GetNemp_PlaylistString(data, IPC_GETPLAYLISTTITLEONLY);
end;

function GetNemp_SearchListString(param, kind: Integer): AnsiString;
var hwndNemp, TempHandle : THandle;
    dat2: array[0..500] of AnsiChar;
    MPointer: Integer;

    {$IFDEF OLDREADPROCESSMEMORY}
    temp: Cardinal;
    {$ELSE}
    temp: NativeUInt;
    {$ENDIF}
begin
    hwndNemp:= FindWindow(PChar(WINDOW_NAME),nil);
    if hwndNemp= 0 then
      result:=''
    else
    begin
        MPointer := SendMessage(hwndNemp, WM_USER, param, kind);
        if MPointer = -1 then
        begin
          result := '';
          exit;
        end;
        GetWindowThreadProcessId(hwndNemp, @TempHandle);
        hwndNemp:= OpenProcess(PROCESS_VM_READ,False,TempHandle);
        ReadProcessMemory(hwndNemp, Pointer(MPointer), @dat2,500,temp);
        CloseHandle(hwndNemp);
        Result:= AnsiString(dat2);
    end;
end;


function GetNempSearchlistFilename(data:Integer): AnsiString;
begin
  result := GetNemp_SearchListString(data, IPC_GETSEARCHLISTFILE);
end;
function GetNempSearchlistTitel(data:Integer): AnsiString;
begin
    result := GetNemp_SearchListString(data, IPC_GETSEARCHLISTTITLE);
end;
function GetNempSearchlistAlbum(data:Integer): AnsiString;
begin
    result := GetNemp_SearchListString(data, IPC_GETSEARCHLISTALBUM);
end;
function GetNempSearchlistArtist(data:Integer): AnsiString;
begin
    result := GetNemp_SearchListString(data, IPC_GETSEARCHLISTARTIST);
end;
function GetNempSearchlistTitleOnly(data:Integer): AnsiString;
begin
    result := GetNemp_SearchListString(data, IPC_GETSEARCHLISTTITLEONLY);
end;

function GetNempCurrentTitle(kind: Integer): AnsiString;  // Nemp (version 4.6)
var hwndNemp, TempHandle : THandle;
    dat2: array[0..500] of AnsiChar;
    MPointer: Integer;
    {$IFDEF OLDREADPROCESSMEMORY}
    temp: Cardinal;
    {$ELSE}
    temp: NativeUInt;
    {$ENDIF}
begin
    hwndNemp := FindWindow(PChar(WINDOW_NAME),nil);
    if hwndNemp = 0 then
    begin
        result := ''
    end else
    begin
        MPointer := SendMessage(hwndNemp, WM_USER, kind, IPC_GETCURRENTTITLEDATA);
        if MPointer = -1 then
        begin
          result := '';
          exit;
        end;
        GetWindowThreadProcessId(hwndNemp, @TempHandle);
        hwndNemp := OpenProcess(PROCESS_VM_READ, False, TempHandle);
        ReadProcessMemory(hwndNemp, Pointer(MPointer), @dat2, 500, temp);
        CloseHandle(hwndNemp);
        Result := AnsiString(dat2);
    end;
end;


function GetNempNextTitel:AnsiString;
var hwndNemp, TempHandle : THandle;
    dat2: array[0..500] of AnsiChar;
    TrackPos,maxpos: Integer;
    MPointer: Integer;
    {$IFDEF OLDREADPROCESSMEMORY}
    temp: Cardinal;
    {$ELSE}
    temp: NativeUInt;
    {$ENDIF}
begin
    hwndNemp:= FindWindow(PChar(WINDOW_NAME),nil);
    if hwndNemp= 0 then
    begin
        result:=''
    end else
    begin
        if SendMessage(hwndNemp,WM_USER,0 , IPC_GET_SHUFFLE)=1 then
            result:='N/A [random]'
        else
        begin
            TrackPos := SendMessage(hwndNemp,WM_USER,0 , IPC_GETLISTPOS);
            maxpos   := SendMessage(hwndNemp,WM_USER,0 , IPC_GETLISTLENGTH);
            if maxpos-1 > Trackpos then inc(TrackPos)
            else begin
                if SendMessage(hwndNemp,WM_USER,0 , IPC_GET_REPEAT)=1
                then TrackPos:=0 else
                begin
                    result:='N/A [no repeat]';
                    exit;
                end;
            end;
            MPointer:= SendMessage(hwndNemp,WM_USER,TrackPos , IPC_GETPLAYLISTTITLE);
            if MPointer = -1 then
            begin
              result := '';
              exit;
            end;
            GetWindowThreadProcessId(hwndNemp, @TempHandle);
            hwndNemp:= OpenProcess(PROCESS_VM_READ,False,TempHandle);
            ReadProcessMemory(hwndNemp, Pointer(MPointer), @dat2,500,temp);
            CloseHandle(hwndNemp);
            if fileexists(GetNempPlaylistFilenameW(Trackpos)) then
                Result := AnsiString(dat2)
            else Result := 'N/A [File not found]';
        end;
    end;
end;

function GetNempPrevTitel:AnsiString;
var hwndNemp, TempHandle : THandle;
    dat2: array[0..500] of AnsiChar;
    TrackPos,maxpos: Integer;
    MPointer: Integer;
    {$IFDEF OLDREADPROCESSMEMORY}
    temp: Cardinal;
    {$ELSE}
    temp: NativeUInt;
    {$ENDIF}
begin
    hwndNemp:= FindWindow(PChar(WINDOW_NAME),nil);
    if hwndNemp= 0 then
    begin
        result:=''
    end else
    begin
        if SendMessage(hwndNemp,WM_USER,0 , IPC_GET_SHUFFLE)=1 then
            result:='N/A [random]'
        else
        begin
            TrackPos := SendMessage(hwndNemp,WM_USER,0 , IPC_GETLISTPOS);
            maxpos   := SendMessage(hwndNemp,WM_USER,0 , IPC_GETLISTLENGTH);
            if Trackpos > 0 then dec(TrackPos)
            else begin
                if SendMessage(hwndNemp,WM_USER,0 , IPC_GET_REPEAT)=1
                then TrackPos:=maxpos-1 else
                begin
                    result:='N/A [no repeat]';
                    exit;
                end;
            end;
            MPointer:= SendMessage(hwndNemp,WM_USER,TrackPos , IPC_GETPLAYLISTTITLE);
            if MPointer = -1 then
            begin
              result := '';
              exit;
            end;
            GetWindowThreadProcessId(hwndNemp, @TempHandle);
            hwndNemp:= OpenProcess(PROCESS_VM_READ,False,TempHandle);
            ReadProcessMemory(hwndNemp, Pointer(MPointer), @dat2,500,temp);
            CloseHandle(hwndNemp);
            if fileexists(GetNempPlaylistFilenameW(Trackpos)) then
                Result := AnsiString(dat2)
            else Result := 'N/A [File not found]';
        end;
    end;
end;

function GetNemp_PlaylistStringW(param, kind: Integer): WideString;
var hwndNemp, TempHandle : THandle;
    dat2: array[0..500] of WideChar;
    TrackPos: Integer;
    MPointer: Integer;
    {$IFDEF OLDREADPROCESSMEMORY}
    temp: Cardinal;
    {$ELSE}
    temp: NativeUInt;
    {$ENDIF}
begin
    hwndNemp := FindWindow(PChar(WINDOW_NAME),nil);
    if hwndNemp = 0 then
    begin
        result := ''
    end else
    begin
        if param < 0 then
          TrackPos := SendMessage(hwndNemp, WM_USER,0 , IPC_GETLISTPOS)
        else
          TrackPos := param;
        MPointer := SendMessage(hwndNemp, WM_USER, TrackPos , kind);
        if MPointer = -1 then
        begin
          result := '';
          exit;
        end;
        GetWindowThreadProcessId(hwndNemp, @TempHandle);
        hwndNemp := OpenProcess(PROCESS_VM_READ, False, TempHandle);
        ReadProcessMemory(hwndNemp, Pointer(MPointer), @dat2, 1000, temp);
        CloseHandle(hwndNemp);
        Result := WideString(dat2);
    end;
end;

function GetNempPlaylistFilenameW(data:Integer):WideString;
begin
  result := GetNemp_PlaylistStringW(data, IPC_GETPLAYLISTFILE_W);
end;

function GetNempPlaylistTitelW(data:Integer): WideString;
begin
  result := GetNemp_PlaylistStringW(data, IPC_GETPLAYLISTTITLE_W);
end;

function GetNempPlaylistAlbumW(data:Integer): WideString;
begin
  result := GetNemp_PlaylistStringW(data, IPC_GETPLAYLISTALBUM_W);
end;
function GetNempPlaylistArtistW(data:Integer): WideString;
begin
  result := GetNemp_PlaylistStringW(data, IPC_GETPLAYLISTARTIST_W);
end;
function GetNempPlaylistTitleOnlyW(data:Integer): WideString;
begin
  result := GetNemp_PlaylistStringW(data, IPC_GETPLAYLISTTITLEONLY_W);
end;

// Strings aus der Anzeigeliste auslesen
function GetNemp_SearchListStringW(param, kind: Integer): WideString;
var hwndNemp, TempHandle : THandle;
    dat2: array[0..500] of WideChar;
    MPointer: Integer;
    {$IFDEF OLDREADPROCESSMEMORY}
    temp: Cardinal;
    {$ELSE}
    temp: NativeUInt;
    {$ENDIF}
begin
    hwndNemp:= FindWindow(PChar(WINDOW_NAME),nil);
    if hwndNemp= 0 then
      result:=''
    else
    begin
        MPointer := SendMessage(hwndNemp, WM_USER, param, kind);
        if MPointer = -1 then
        begin
          result := '';
          exit;
        end;
        GetWindowThreadProcessId(hwndNemp, @TempHandle);
        hwndNemp:= OpenProcess(PROCESS_VM_READ,False,TempHandle);
        ReadProcessMemory(hwndNemp, Pointer(MPointer), @dat2,1000,temp);
        CloseHandle(hwndNemp);
        Result:= WideString(dat2);
    end;
end;

function GetNempSearchlistFilenameW(data:Integer): WideString;
begin
  result := GetNemp_SearchListStringW(data, IPC_GETSEARCHLISTFILE_W);
end;
function GetNempSearchlistTitelW(data:Integer): WideString;
begin
    result := GetNemp_SearchListStringW(data, IPC_GETSEARCHLISTTITLE_W);
end;
function GetNempSearchlistAlbumW(data:Integer): WideString;
begin
    result := GetNemp_SearchListStringW(data, IPC_GETSEARCHLISTALBUM_W);
end;
function GetNempSearchlistArtistW(data:Integer): WideString;
begin
    result := GetNemp_SearchListStringW(data, IPC_GETSEARCHLISTARTIST_W);
end;
function GetNempSearchlistTitleOnlyW(data:Integer): WideString;
begin
    result := GetNemp_SearchListStringW(data, IPC_GETSEARCHLISTTITLEONLY_W);
end;

function GetNempCurrentTitleW(kind: Integer): WideString;  // Nemp (version 4.6)
var hwndNemp, TempHandle : THandle;
    dat2: array[0..500] of WideChar;
    MPointer: Integer;
    {$IFDEF OLDREADPROCESSMEMORY}
    temp: Cardinal;
    {$ELSE}
    temp: NativeUInt;
    {$ENDIF}
begin
    hwndNemp := FindWindow(PChar(WINDOW_NAME),nil);
    if hwndNemp = 0 then
    begin
        result := ''
    end else
    begin
        MPointer := SendMessage(hwndNemp, WM_USER, kind, IPC_GETCURRENTTITLEDATA_W);
        if MPointer = -1 then
        begin
          result := '';
          exit;
        end;
        GetWindowThreadProcessId(hwndNemp, @TempHandle);
        hwndNemp := OpenProcess(PROCESS_VM_READ, False, TempHandle);
        ReadProcessMemory(hwndNemp, Pointer(MPointer), @dat2, 1000, temp);
        CloseHandle(hwndNemp);
        Result := WideString(dat2);
    end;
end;

function GetNempNextTitelW:WideString;
var hwndNemp, TempHandle : THandle;
    dat2: array[0..500] of WideChar;
    TrackPos,maxpos: Integer;
    MPointer: Integer;
    {$IFDEF OLDREADPROCESSMEMORY}
    temp: Cardinal;
    {$ELSE}
    temp: NativeUInt;
    {$ENDIF}
begin
    hwndNemp:= FindWindow(PChar(WINDOW_NAME),nil);
    if hwndNemp= 0 then
    begin
        result:=''
    end else
    begin
        if SendMessage(hwndNemp,WM_USER,0 , IPC_GET_SHUFFLE)=1 then
            result:='N/A [random]'
        else
        begin
            TrackPos := SendMessage(hwndNemp,WM_USER,0 , IPC_GETLISTPOS);
            maxpos   := SendMessage(hwndNemp,WM_USER,0 , IPC_GETLISTLENGTH);
            if maxpos-1 > Trackpos then inc(TrackPos)
            else begin
                if SendMessage(hwndNemp,WM_USER,0 , IPC_GET_REPEAT)=1
                then TrackPos:=0 else
                begin
                    result:='N/A [no repeat]';
                    exit;
                end;
            end;
            MPointer:= SendMessage(hwndNemp,WM_USER,TrackPos , IPC_GETPLAYLISTTITLE_W);
            if MPointer = -1 then
            begin
              result := '';
              exit;
            end;
            GetWindowThreadProcessId(hwndNemp, @TempHandle);
            hwndNemp:= OpenProcess(PROCESS_VM_READ,False,TempHandle);
            ReadProcessMemory(hwndNemp, Pointer(MPointer), @dat2,1000,temp);
            CloseHandle(hwndNemp);
            if fileexists(GetNempPlaylistFilenameW(Trackpos)) then
                Result := WideString(dat2)
            else Result := 'N/A [File not found]';
        end;
    end;

end;
function GetNempPrevTitelW:WideString;
var hwndNemp, TempHandle : THandle;
    dat2: array[0..500] of WideChar;
    TrackPos,maxpos: Integer;
    MPointer: Integer;
    {$IFDEF OLDREADPROCESSMEMORY}
    temp: Cardinal;
    {$ELSE}
    temp: NativeUInt;
    {$ENDIF}
begin
    hwndNemp:= FindWindow(PChar(WINDOW_NAME),nil);
    if hwndNemp= 0 then
    begin
        result:=''
    end else
    begin
        if SendMessage(hwndNemp,WM_USER,0 , IPC_GET_SHUFFLE)=1 then
            result:='N/A [random]'
        else
        begin
            TrackPos := SendMessage(hwndNemp,WM_USER,0 , IPC_GETLISTPOS);
            maxpos   := SendMessage(hwndNemp,WM_USER,0 , IPC_GETLISTLENGTH);
            if Trackpos > 0 then dec(TrackPos)
            else begin
                if SendMessage(hwndNemp,WM_USER,0 , IPC_GET_REPEAT)=1
                then TrackPos:=maxpos-1 else
                begin
                    result:='N/A [no repeat]';
                    exit;
                end;
            end;
            MPointer:= SendMessage(hwndNemp,WM_USER,TrackPos , IPC_GETPLAYLISTTITLE_W);
            if MPointer = -1 then
            begin
              result := '';
              exit;
            end;
            GetWindowThreadProcessId(hwndNemp, @TempHandle);
            hwndNemp:= OpenProcess(PROCESS_VM_READ,False,TempHandle);
            ReadProcessMemory(hwndNemp, Pointer(MPointer), @dat2,1000,temp);
            CloseHandle(hwndNemp);
            if fileexists(GetNempPlaylistFilenameW(Trackpos)) then
                Result := WideString(dat2)
            else Result := 'N/A [File not found]';
        end;
    end;

end;

function GetNempPlayListLength:integer;
begin
  result := GetNemp_User(0, IPC_GETLISTLENGTH);
end;

function GetNempSearchListLength: Integer;
begin
  result := GetNemp_User(0, IPC_GETSEARCHLISTLENGTH);
end;

function GetNempPlaylistTrackLength(idx: Integer): Integer;
begin
  result := GetNemp_User(idx, IPC_GETPLAYLISTTRACKLENGTH);
end;

function GetNempSearchlistTrackLength(idx: Integer): Integer;
begin
  result := GetNemp_User(idx, IPC_GETSEARCHLISTTRACKLENGTH);
end;


function GetNemp_TrackPosition: integer;
begin
  result := GetNemp_User(0, IPC_GETOUTPUTTIME);
end;

function GetNemp_TrackLength: integer;
begin
  result := GetNemp_User(1, IPC_GETOUTPUTTIME);
end;

function SetNemp_TrackPosition(NewPos: Integer): Integer;
begin
  result := GetNemp_User(NewPos, IPC_JUMPTOTIME);
end;

procedure SetNemp_Volume(Vol: Byte);
begin
  SetNemp_User(vol, IPC_SETVOLUME);
end;

function GetNemp_Volume:Integer;
begin
  result := GetNemp_User(0, IPC_GETVOLUME);
end;

function GetNemp_Samplerate: Integer;
begin
  result := GetNemp_User(IPC_MODE_SAMPLERATE, IPC_GETINFO);
end;

function GetNemp_Bitrate: Integer;
begin
  result := GetNemp_User(IPC_MODE_BITRATE, IPC_GETINFO);
end;

function GetNemp_Channels: Integer;
begin
  result := GetNemp_User(IPC_MODE_CHANNELS, IPC_GETINFO);
end;

// Value sollte zwischen 0 und 60 liegen
procedure SetNemp_Equalizer(Band: Integer; Value: Integer);
begin
  SetNemp_User(($DB shl 24)
           OR ((Band AND $FF) shl 16)
           OR (Value AND $FFFF)
             , IPC_SETEQDATA);
end;

function GetNemp_Equalizer(Band: Integer): Integer;
begin
  result := GetNemp_User(Band, IPC_GETEQDATA);
end;

procedure SetNemp_EchoTime(Time: Integer);
begin
  SetNemp_User(time, IPC_SETECHOTIME);
end;

function GetNemp_EchoTime: Integer;
begin
  result := GetNemp_User(0, IPC_GETECHOTIME);
end;

procedure SetNemp_EchoMix(Mix: Integer);
begin
  SetNemp_User(Mix, IPC_SETECHOMIX);
end;

function GetNemp_EchoMix: Integer;
begin
  result := GetNemp_User(0, IPC_GETECHOMIX);
end;


procedure SetNemp_Hall(value: Integer);
begin
  SetNemp_User(value, IPC_SETREVERB);
end;

function GetNemp_Hall: Integer;
begin
  result := GetNemp_User(0, IPC_GETREVERB);
end;

procedure SetNemp_Speed(value:Integer);
begin
  SetNemp_User(value, IPC_SETSPEED);
end;
function GetNemp_Speed: Integer;
begin
  result := GetNemp_User(0, IPC_GETSPEED);
end;


function GetNempState: integer;
begin
  result := GetNemp_User(0, IPC_ISPLAYING);
end;

function GetNempRandomMode: Integer;
begin
  result := GetNemp_User(0, IPC_GET_SHUFFLE);
end;


// WM_COMMAND - Nachrichten
procedure NempPlayPrev;
var hwndNemp: THandle;
begin
    hwndNemp:= FindWindow(PChar(WINDOW_NAME),nil);
    if hwndNemp<>0 then SendMessage(hwndNemp,WM_COMMAND, Nemp_Button1, 0);
end;

procedure NempPlay;
var hwndNemp: THandle;
begin
    hwndNemp:= FindWindow(PChar(WINDOW_NAME),nil);
    if hwndNemp<>0 then SendMessage(hwndNemp,WM_COMMAND, Nemp_Button2, 0);
end;

procedure NempPause;
var hwndNemp: THandle;
begin
    hwndNemp:= FindWindow(PChar(WINDOW_NAME),nil);
    if hwndNemp<>0 then SendMessage(hwndNemp,WM_COMMAND, Nemp_Button3, 0);
end;

procedure NempStop;
var hwndNemp: THandle;
begin
    hwndNemp:= FindWindow(PChar(WINDOW_NAME),nil);
    if hwndNemp<>0 then SendMessage(hwndNemp,WM_COMMAND, Nemp_Button4, 0);
end;

procedure NempPlayNext;
var hwndNemp: THandle;
begin
    hwndNemp:= FindWindow(PChar(WINDOW_NAME),nil);
    if hwndNemp<>0 then SendMessage(hwndNemp,WM_COMMAND, Nemp_Button5, 0);
end;

procedure NempVolumeUp;
var hwndNemp: THandle;
begin
    hwndNemp:= FindWindow(PChar(WINDOW_NAME),nil);
    if hwndNemp<>0 then SendMessage(hwndNemp,WM_COMMAND, Nemp_VOLUMEUP, 0);
end;

procedure NempVolumeDown;
var hwndNemp: THandle;
begin
    hwndNemp:= FindWindow(PChar(WINDOW_NAME),nil);
    if hwndNemp<>0 then SendMessage(hwndNemp,WM_COMMAND, Nemp_VOLUMEDOWN, 0);
end;

procedure NempRestore;
var hwndNemp: THandle;
begin
    hwndNemp:= FindWindow(PChar(WINDOW_NAME),nil);
    if hwndNemp<>0 then SendMessage(hwndNemp,WM_COMMAND, COMMAND_RESTORE, 0);
end;


procedure Nemp_SendSearchString(Source: HWND; aString: AnsiString);
var hwndNemp: THandle;
  MyCopyDataStruct: TCopyDataStruct;
begin
  hwndNemp:= FindWindow(PChar(WINDOW_NAME),nil);
  if hwndNemp<>0 then
  begin
    with MyCopyDataStruct do
    begin
      dwData := IPC_SEND_SEARCHSTRING;
      cbData := AnsiStrings.StrLen(PAnsiChar(aString)) + 1;  //Need to transfer terminating #0 as well
      lpData := PAnsiChar(aString);
    end;
    SendMessage(hwndNemp, WM_COPYDATA, Source, Longint(@MyCopyDataStruct))
  end;
end;

procedure Nemp_SendFileForPlaylist(Source: HWND; aFilename: AnsiString; Mode: Cardinal);
var hwndNemp: THandle;
  MyCopyDataStruct: TCopyDataStruct;
begin
  hwndNemp:= FindWindow(PChar(WINDOW_NAME),nil);
  if hwndNemp<>0 then
  begin
    with MyCopyDataStruct do
    begin
      dwData := IPC_SEND_FILEFORPLAYLIST + Mode;
      cbData :=
            AnsiStrings.StrLen(PAnsiChar(aFilename)) + 1; //Need to transfer terminating #0 as well
      lpData := PAnsiChar(aFilename);
    end;
    SendMessage(hwndNemp, WM_COPYDATA, Source, Longint(@MyCopyDataStruct))
  end;
end;

// WideString-Variante
procedure Nemp_SendSearchStringW(Source: HWND; aWideString: WideString);
var hwndNemp: THandle;
  MyCopyDataStruct: TCopyDataStruct;
begin
  hwndNemp:= FindWindow(PChar(WINDOW_NAME),nil);
  if hwndNemp<>0 then
  begin
    with MyCopyDataStruct do
    begin
      dwData := IPC_SEND_SEARCHSTRING_W;
      cbData := sizeof(WideChar) * (Length(aWideString) + 1);  //Need to transfer terminating #0 as well
      lpData := PWideChar(aWideString);
    end;
    SendMessage(hwndNemp, WM_COPYDATA, Source, Longint(@MyCopyDataStruct))
  end;
end;
procedure Nemp_SendFileForPlaylistW(Source: HWND; aFilename: WideString; Mode: Cardinal);
var hwndNemp: THandle;
  MyCopyDataStruct: TCopyDataStruct;
begin
  hwndNemp:= FindWindow(PChar(WINDOW_NAME),nil);
  if hwndNemp<>0 then
  begin
    with MyCopyDataStruct do
    begin
      dwData := IPC_SEND_FILEFORPLAYLIST_W + Mode;
      cbData :=
            sizeof(WideChar) * (Length(aFilename) + 1); //Need to transfer terminating #0 as well
      lpData := PWideChar(aFilename);
    end;
    SendMessage(hwndNemp, WM_COPYDATA, Source, Longint(@MyCopyDataStruct))
  end;
end;

function Nemp_GetSearchStatus: Integer;
begin
  result := GetNemp_User(0,IPC_QUERY_SEARCHSTATUS);
end;

function Nemp_QueryCover(QueryHnd: HWND): Integer;
var hwndNemp:THandle;
begin
  hwndNemp:= FindWindow(PChar(WINDOW_NAME),nil);
  if hwndNemp = 0 then
    result := -1
  else
    result := SendMessage(hwndNemp, WM_USER, QueryHnd, IPC_QUERYCOVER);
end;

procedure Nemp_SetDisplayApp(value: Boolean);
begin
  SetNemp_User(Integer(value), IPC_SETUSEDISPLAYAPP);
end;

initialization
  NempDeskbandActivateMessage := RegisterWindowMessage(NEMP_DESKBAND_ACTIVATE);
  NempDeskbandDeActivateMessage := RegisterWindowMessage(NEMP_DESKBAND_DEACTIVATE);
  NempDeskbandUpdateMessage := RegisterWindowMessage(NEMP_DESKBAND_UPDATE);

finalization
  // nothing todo

end.
