{

    Unit WinampFunctions (Januar 2005)

    This _was_ one of the key-features in "Gausis Mp3-Verwaltung", which was
    the direct predecessor of Nemp. In this fine little program there
    was a library, and a Remote-Control for Winamp.

    It is based on some function written by "Caty":
    http://www.delphi-forum.de/viewtopic.php?t=4806

    See http://www.winamp.com/nsdn/winamp/sdk/ for details.

    Note: Most of this is not used any more. It is commented therefore.
    Only "Get Playlist" is used as an artefact from ancient times. ;-)


    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2009, Daniel Gaussmann
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

    Additional permissions

    If you modify this Program, or any covered work, by linking or combining it
    with
        - the bass.dll and it addons
          (including, but not limited to the bass_fx.dll)
        - MadExcept
        - DGL-OpenGL
        - FSPro Windows 7 Taskbar Components
    or a modified version of these libraries, the licensors of this Program
    grant you additional permission to convey the resulting work.

    ---------------------------------------------------------------
}

unit WinampFunctions;

interface
uses Windows, Messages, SysUtils;



function GetWinampFilename(data:Integer): String;  // Liefert den Dateinamen eines Eintrags in der Playlist
//function GetWinampTitel(data:Integer): AnsiString;     // Liefert einen PlayListeintrag
//function GetWinampNextTitel: AnsiString; // Liefert den NÄCHSTEN Titel, der abgespielt werden wird (nicht bei Shuffle)
//function GetWinampPrevTitel: AnsiString; // Liefert den VORIGEN Titel, der abgespielt werden wird (nicht bei Shuffle)
function GetWinampPlayListLength:integer; // Liefert die Anzahl de Einträge in der Playlist
//function GetWinampState: integer; // Liefert den Status - Play/Stop/Pause

//procedure SetWinampVolume(vol:byte); // Setzt die Lautstärke
//procedure WinampPlayNext; // simuliert ButtonKlick auf Next
//procedure WinampPlayPrev; // ...
//procedure WinampPlay;
//procedure WinampPause;
//procedure WinampStop;
//procedure WinampVolumeUp;
//procedure WinampVolumeDown;
//procedure WinampDeletePlayList;

const   //WINAMP_BUTTON1   : integer = 40044; // previous title
        //WINAMP_BUTTON2   : integer = 40045; // play
        //WINAMP_BUTTON3   : integer = 40046; // pause
        //WINAMP_BUTTON4   : integer = 40047; // stop
        //WINAMP_BUTTON5   : integer = 40048; // next title
        //WINAMP_VOLUMEUP  : integer = 40058; // volume up
        //WINAMP_VOLUMEDOWN: integer = 40059; // volume down

        //IPC_DELETE : integer = 101;
        //IPC_ISPLAYING : integer = 104;
        //IPC_SETVOLUME : integer = 122;
        IPC_GETLISTLENGTH : integer = 124;
        IPC_GETLISTPOS :integer = 125;
        IPC_GETPLAYLISTFILE : integer = 211;
        //IPC_GETPLAYLISTTITLE : integer = 212;

        //IPC_GET_SHUFFLE : integer = 250;
        //IPC_GET_REPEAT : integer = 251;


implementation


// function GetLongFilename by Christian Maas
// http://entwickler-forum.de/showthread.php?t=37217
function GetLongFilename(Path: string): string;
var i: integer;
  SearchHandle: THandle;
  FindData: TWin32FindData;
  IsBackSlash: boolean;
begin
    Path := ExpandFileName(Path);
    Result := ExtractFileDrive(Path);
    i := Length (Result);
    if Length (Path) <= I then
        Exit; // only drive

    if copy (Path, i + 1, 1) = '\' then
    begin // CM: copy statt if Path[I + 1] = '\' then begin
        Result := Result + '\';
        inc (i);
    end;
    Delete(Path, 1, i);

    repeat
        i := Pos ('\', Path);
        IsBackSlash := i > 0;
        if not IsBackSlash then
            i := Length (Path) + 1;

        SearchHandle := FindFirstFile (PChar (Result + copy (Path, 1, i - 1)), FindData);
        if SearchHandle <> INVALID_HANDLE_VALUE then
        begin
            try
                Result := Result + FindData.cFileName;
                if IsBackSlash then
                    Result := Result + '\';
            finally
                Windows.FindClose(SearchHandle);
            end;
        end
        else
        begin
            Result := Result + Path;
            Break;
        end;
        Delete (Path, 1, i);
    until Length (Path) = 0;
end;


(*
// Ist Data >=0, so wird der enstprechende Titel geliefert
// z.B. Data = 3: => der vierte Titel (Beginn der Zählung bei 0!) wird geliefert
// Ist Data < 0, so wird der aktuell gespielte Titel genommen
function GetWinampTitel(data:Integer): AnsiString;
var hwndWinamp, TempHandle : THandle;
    dat2: array[0..500] of AnsiChar;
    TrackPos: Integer;
    temp, MPointer: Cardinal;
begin
    // Prinzip ist fast immer dasselbe, daher nur einmal die Kommentare ;-)
    // Fenster suchen
    hwndWinamp:= FindWindow('Winamp v1.x',nil);
    if hwndWinamp= 0 then
    begin  // Kein Erfolg
        result:=''
    end else
    begin  // Erfolg - Winamp-Fenster gefunden
        if data<0 then
          // ermittle die aktuelle Position in der Playlist
          TrackPos:= SendMessage(hwndWinamp,WM_USER,0 , IPC_GETLISTPOS)
        else
          // sonst nehme die übergebene zahl als tracknummer
          TrackPos:=data;

        // Tja nu, halt ein paar Nachrichten an Winamp senden, um an die Daten zu kommen ;-)
        MPointer:= SendMessage(hwndWinamp,WM_USER,TrackPos , IPC_GETPLAYLISTTITLE);
        // Diese Info möchte Winamp nicht direkt rausrücken  - da muss man was tricksen ;-)
        GetWindowThreadProcessId(hwndWinamp,TempHandle);
        hwndWinamp:= OpenProcess(PROCESS_VM_READ, False,TempHandle);
        ReadProcessMemory(hwndWinamp, Pointer(MPointer), @dat2,500,temp);
        // warum ausgerechnet 500 kann ich nicht sagen. Habe das so übernommen.
        // Kann sein, dass auch kleinere Werte funktionieren.
        CloseHandle(hwndWinamp);
        Result:= AnsiString(dat2);
    end;
end;
*)

// Bedeutung von Data wie oben
function GetWinampFilename(data:Integer): String;
var hwndWinamp, TempHandle : THandle;
    dat2: array[0..500] of AnsiChar;
    TrackPos: Integer;
    temp, MPointer: Cardinal;
begin
    hwndWinamp:= FindWindow('Winamp v1.x',nil);
    if hwndWinamp= 0 then
    begin
        result:=''
    end else
    begin
        if data<0 then
          TrackPos:= SendMessage(hwndWinamp,WM_USER,0 , IPC_GETLISTPOS)
        else
          TrackPos:=data;

        MPointer:= SendMessage(hwndWinamp,WM_USER,TrackPos , IPC_GETPLAYLISTFILE);
        GetWindowThreadProcessId(hwndWinamp,TempHandle);
        hwndWinamp:= OpenProcess(PROCESS_VM_READ, False,TempHandle);
        ReadProcessMemory(hwndWinamp, Pointer(MPointer), @dat2,500,temp);
        CloseHandle(hwndWinamp);
        Result:= GetLongFilename(String(AnsiString(dat2)));
    end;
end;

(*
function GetWinampNextTitel: AnsiString;
var hwndWinamp, TempHandle : THandle;
    dat2: array[0..500] of AnsiChar;
    TrackPos,maxpos: Integer;
    temp, MPointer: Cardinal;
begin
    hwndWinamp:= FindWindow('Winamp v1.x',nil);
    if hwndWinamp= 0 then
    begin
        result:=''
    end else
    begin
        // Wenn Shuffle aktiviert ist, kann keine Aussage über den nächsten Titel getroffen werden
        if SendMessage(hwndWinamp,WM_USER,0 , IPC_GET_SHUFFLE)=1 then
            result := AnsiString('N/A [random]')
        else
        begin
            TrackPos := SendMessage(hwndWinamp,WM_USER,0 , IPC_GETLISTPOS);
            maxpos   := SendMessage(hwndWinamp,WM_USER,0 , IPC_GETLISTLENGTH);
            if maxpos-1 > Trackpos then inc(TrackPos) // noch nicht am Ende der Liste
            else begin
                // am Ende der Liste
                if SendMessage(hwndWinamp,WM_USER,0 , IPC_GET_REPEAT)=1
                // ist Repeat auf ON? - Dann liefere den ersten Titel in der Liste
                then TrackPos := 0 else
                begin
                    // andernfalls: Ende der Liste, kein Repeat - kein nächstes Lied
                    result:= AnsiString('N/A [no repeat]');
                    exit;
                end;
            end;
            MPointer:= SendMessage(hwndWinamp,WM_USER,TrackPos , IPC_GETPLAYLISTTITLE);
            GetWindowThreadProcessId(hwndWinamp,TempHandle);
            hwndWinamp:= OpenProcess(PROCESS_VM_READ, False,TempHandle);
            ReadProcessMemory(hwndWinamp, Pointer(MPointer), @dat2,500,temp);
            CloseHandle(hwndWinamp);
            // Überprüfen: Existiert nächstes File überhaupt?
            if fileexists(String(GetWinampFilename(Trackpos))) then
                Result := AnsiString(dat2)
            else
                Result := AnsiString('N/A [File not found]');
                // andere Möglichkeit: Die Liste weiter durchgehen, um den nächsten gültigen Titel zu erhalten.
        end;
    end;
end;

function GetWinampPrevTitel: AnsiString;
var hwndWinamp, TempHandle : THandle;
    dat2: array[0..500] of AnsiChar;
    TrackPos,maxpos: Integer;
    temp, MPointer: Cardinal;
begin
    // Genau wie "Next", nur umgedreht ;-)
    hwndWinamp:= FindWindow('Winamp v1.x',nil);
    if hwndWinamp= 0 then
    begin
        result:=''
    end else
    begin
        if SendMessage(hwndWinamp,WM_USER,0 , IPC_GET_SHUFFLE)=1 then
            result := AnsiString('N/A [random]')
        else
        begin
            TrackPos := SendMessage(hwndWinamp,WM_USER,0 , IPC_GETLISTPOS);
            maxpos   := SendMessage(hwndWinamp,WM_USER,0 , IPC_GETLISTLENGTH);
            if Trackpos > 0 then dec(TrackPos)
            else begin
                if SendMessage(hwndWinamp,WM_USER,0 , IPC_GET_REPEAT)=1
                then TrackPos:=maxpos-1 else
                begin
                    result := AnsiString('N/A [no repeat]');
                    exit;
                end;
            end;
            MPointer:= SendMessage(hwndWinamp,WM_USER,TrackPos , IPC_GETPLAYLISTTITLE);
            GetWindowThreadProcessId(hwndWinamp,TempHandle);
            hwndWinamp:= OpenProcess(PROCESS_VM_READ, False,TempHandle);
            ReadProcessMemory(hwndWinamp, Pointer(MPointer), @dat2, 500,temp);
            CloseHandle(hwndWinamp);
            if fileexists(String(GetWinampFilename(Trackpos))) then
                Result := AnsiString(dat2)
            else
                Result := AnsiString('N/A [File not found]');
        end;
    end;
end;
*)

function GetWinampPlayListLength:integer;
var hwndWinamp:THandle;
begin
    hwndWinamp:= FindWindow('Winamp v1.x',nil);
    if hwndWinamp= 0 then
    begin
        result:=-1
    end else
    begin
        result := SendMessage(hwndWinamp,WM_USER,0 , IPC_GETLISTLENGTH);
    end;
end;

(*
// GetWinampState = 0: Gestoppt.
// GetWinampState = 1: Abspielend.
// GetWinampState = 3: Pause
// GetWinampState = -1: kein Winamp gefunden
function GetWinampState: integer;
var hwndWinamp: THandle;
begin
    hwndWinamp:= FindWindow('Winamp v1.x',nil);
    if hwndWinamp<>0 then
        result := SendMessage(hwndWinamp,WM_USER, 0 , IPC_ISPLAYING)
    else result:=-1
end;

procedure SetWinampVolume(vol:byte);
var hwndWinamp: THandle;
begin
    hwndWinamp:= FindWindow('Winamp v1.x',nil);
    if hwndWinamp<>0 then SendMessage(hwndWinamp,WM_USER, vol , IPC_SETVOLUME)
end;


procedure WinampPlayPrev;
var hwndWinamp: THandle;
begin
    hwndWinamp:= FindWindow('Winamp v1.x',nil);
    if hwndWinamp<>0 then SendMessage(hwndWinamp,WM_COMMAND, WinAmp_Button1, 0);
end;

procedure WinampPlay;
var hwndWinamp: THandle;
begin
    hwndWinamp:= FindWindow('Winamp v1.x',nil);
    if hwndWinamp<>0 then SendMessage(hwndWinamp,WM_COMMAND, WinAmp_Button2, 0);
end;

procedure WinampPause;
var hwndWinamp: THandle;
begin
    hwndWinamp:= FindWindow('Winamp v1.x',nil);
    if hwndWinamp<>0 then SendMessage(hwndWinamp,WM_COMMAND, WinAmp_Button3, 0);
end;

procedure WinampStop;
var hwndWinamp: THandle;
begin
    hwndWinamp:= FindWindow('Winamp v1.x',nil);
    if hwndWinamp<>0 then SendMessage(hwndWinamp,WM_COMMAND, WinAmp_Button4, 0);
end;

procedure WinampPlayNext;
var hwndWinamp: THandle;
begin
    hwndWinamp:= FindWindow('Winamp v1.x',nil);
    if hwndWinamp<>0 then SendMessage(hwndWinamp,WM_COMMAND, WinAmp_Button5, 0);
end;

procedure WinampVolumeUp;
var hwndWinamp: THandle;
begin
    hwndWinamp:= FindWindow('Winamp v1.x',nil);
    if hwndWinamp<>0 then SendMessage(hwndWinamp,WM_COMMAND, WINAMP_VOLUMEUP, 0);
end;

procedure WinampVolumeDown;
var hwndWinamp: THandle;
begin
    hwndWinamp:= FindWindow('Winamp v1.x',nil);
    if hwndWinamp<>0 then SendMessage(hwndWinamp,WM_COMMAND, WINAMP_VOLUMEDOWN, 0);
end;

procedure WinampDeletePlayList;
var hwndWinamp: THandle;
begin
    hwndWinamp:= FindWindow('Winamp v1.x',nil);
    if hwndWinamp<>0 then SendMessage(hwndwinamp,WM_USER,0,IPC_DELETE);

end;
*)

end.
