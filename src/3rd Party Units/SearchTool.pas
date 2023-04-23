unit SearchTool;

/////////////////////////////////////////////////////////////////////
//                                                                 //
//                           SearchTool                            //
//                          Version: 3.0                           //
//                                                                 //
//       Ich bedanke mich bei allen, die bei der Entwicklung       //
//   dieser Unit geholfen haben (durch Problemlösungsideen etc.)   //
//                                                                 //
//                                                                 //
//                                                                 //
//                                                                 //
//                Copyright © 2005-2006 Heiko Thiel                //
//                                                                 //
/////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////
//                                                                 //
// Lizenz                                                          //
//                                                                 //
// Sie dürfen diese Unit nach belieben modifizieren und benutzten, //
// unter der Bedienung, dass  eine Erwähnung der Unit inkl. Autor  //
// innerhalb des Programms erfolgt, wenn die Unit in irgendeiner   //
// Art und Weise benutzt wird     .                                //
//                                                                 //
/////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////
//                                                                 //
// Chronik                                                         //
//                                                                 //
// Version 1.0 (24.09.05):                                         //
//     - Erstes Release                                            //
//                                                                 //
// Version 2.0 (22.10.05):                                         //
//     - Arbeitsplatz-Bezeichnung aus dem System  auslesen         //
//     - Filter erlaubt Platzhalter (*)                            //
//                                                                 //
// Version 3.0  Alpha (28.05.06):                                  //
//     - UniCode-Unterstützung (Filter erst einmal wieder nur für  //
//                              Dateiendungen)                     //
//                                                                 //
// Version 3.0  Alpha2 (28.05.06):                                 //
//     - Filtereinstellungen verbessert (Filter werden nicht mehr  //
//       als Array übergeben, sondern als String (durch ; getrennt)//
//     - SearchTool in einen Thread ausgelagert (aber auschaltbar) //
//     - Win95, 98 und ME- Kompatibilität wieder hergestellt       //
//                                                                 //
// Version 3.0 (17.02.07)                                          //
//     - Filter erlaubt nun wieder Platzhalter (*)                 //
//     - FIX: Abbrechen verursachte Deadlock                       //
//     - CHANGE: SearchFiles wartet bei einem extra Therad nicht   //
//               mehr auf das Ende des Threads                     //
//                                                                 //
/////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////
//                                                                 //
// Modified by Daniel Gausi Gaußmann for NEMP                      //
// Juni 2007                                                       //
//                                                                 //
// - Property "ID" hinzugefügt, um mehrere Instanzen gleichzeitig  //
//   laufen lassen zu können                                       //
// - wParam der Nachrichten beinhaltet die ID, nicht mehr die      //
//   Anzahl der Dateien/Ordner                                     //
//   Der Hauptthread kann dadurch das neue File in die PLaylist    //
//   oder die Medienbib einsortieren                               //
//                                                                 //
// April 2009                                                      //
// - etwas AnsiString/String-Zeug                                  //
//   d.h. explizite Konvertierungen wegen der D2009-Warnungen      //
// - WideString = UnicodeString                                    //
//                                                                 //
/////////////////////////////////////////////////////////////////////



interface

uses  Windows, Forms, Messages, ShlObj, SysUtils, ActiveX;

const
  ST_Start      = WM_User + 1500; //wParam: ID; lParam = nicht benutzt
  ST_CurrentDir = WM_User + 1501; //wParam = nicht benutzt; lParam=aktueller Ordner
  ST_NewFile    = WM_User + 1502; //wParam = ID; lParam=gefundene Datei
  ST_NewDir     = WM_User + 1503; //wParam = ID; lParam=gefundene Ordner
  ST_Finish     = WM_User + 1504; //wParam: ID; lParam = nicht benutzt


  ST_ID_Playlist = 4;
  ST_ID_Medialist = 8;

type

  // {$IFNDEF UNICODE}
  // UnicodeString = WideString;
  // {$ENDIF}


  MessageKind = (mkNoneMessage=$10000001, mkPostMessage, mkSendMessage);

  TWStrArr = array of UnicodeString;

  TSearchTool = class
    private
      FFiles            : TWStrArr;
      FFilesCount       : Integer;
      FSaveFilesMemSize : Integer;

      FDirs             : TWStrArr;
      FDirsCount        : Integer;
      FSaveDirsMemSize  : Integer;

      FCurrentDir       : UnicodeString;

      FMask             : UnicodeString;
      FMaskA            : AnsiString; //Ansi-Variante von FFileMask, damit Delphi nicht ständig konvertieren muss

      FStartTime        : Cardinal;
      FSearchDuration   : Cardinal;
      FIsSearching      : Boolean ;

      FBreak            : LongBool;
      FThread           : Integer ;

      FListFiles  : LongBool   ;
      FListDirs   : LongBool   ;
      FRecurse    : LongBool   ;
      FMHandle    : THandle    ;
      FMSystem    : MessageKind;
      FMCurrentDir: MessageKind;
      FMFound     : MessageKind;

      FExtraThread: Boolean;

      FID: Integer;

      procedure CreateSystemMessage (const Msg: Cardinal; const wParam, lParam: Integer);
      procedure CreateCurrentDirMessage(const wParam, lParam: Integer);
      procedure CreateFoundMessage  (const Msg: Cardinal; const wParam, lParam: Integer);

      procedure NewFile(lPm: Integer);
      procedure NewDir(lPm: Integer);
      procedure ChangeDir(NewDir: UnicodeString);

      //function Filter(const Name: WideString): Boolean;

      procedure AddDir(const Dir: UnicodeString);
      procedure AddFile(const FileName: UnicodeString);

      procedure GetFilesA(Root: AnsiString);
      procedure GetFilesW(Root: UnicodeString);

      procedure SearchFilesA(const Root: AnsiString);
      procedure SearchFilesW(const Root: UnicodeString);

      procedure StartSearch;

      function NameOfMyComputer: UnicodeString;
      function GetDuration: Cardinal;
      function GetCurrentDir: UnicodeString;

      function GetFilesCount : Integer;
      function GetDirsCount : Integer;

      function GetListFiles  : LongBool;
      function GetListDirs   : LongBool;
      function GetRecurse    : LongBool;
      function GetMHandle    : THandle ;
      function GetMSystem    : MessageKind;
      function GetMCurrentDir: MessageKind;
      function GetMFound     : MessageKind;

      procedure SetMask       (Value: UnicodeString);
      procedure SetListFiles  (Value: LongBool);
      procedure SetListDirs   (Value: LongBool);
      procedure SetRecurse    (Value: LongBool);
      procedure SetMHandle    (Value: THandle);
      procedure SetMSystem    (Value: MessageKind);
      procedure SetMCurrentDir(Value: MessageKind);
      procedure SetMFound     (Value: MessageKind);

    public
      constructor Create ;
      destructor  Destroy; override;

      function ResetData: Boolean;
      procedure SearchFiles(const RootFolder: UnicodeString; const ExtraThread: Boolean = true); overload;
      procedure SearchFiles(const RootFolder: UnicodeString; const Mask: UnicodeString;
                            const Recurse: Boolean = false; const ExtraThread: Boolean = true); overload;
      procedure Break;

      property Mask          : UnicodeString  read FMask write SetMask;

      property Files         : TWStrArr    read FFiles       ;
      property FilesCount    : Integer     read GetFilesCount;

      property Dirs          : TWStrArr    read FDirs        ;
      property DirsCount     : Integer     read GetDirsCount ;

      property CurrentDir    : UnicodeString  read GetCurrentDir;
      property SearchDuration: Cardinal    read GetDuration ;
      property IsSearching   : Boolean     read FIsSearching;

      property ListFiles     : LongBool    read GetListFiles   write SetListFiles  ;
      property ListDirs      : LongBool    read GetListDirs    write SetListDirs   ;
      property Recurse       : LongBool    read GetRecurse     write SetRecurse    ;
      property MHandle       : THandle     read GetMHandle     write SetMHandle    ;
      property MSystem       : MessageKind read GetMSystem     write SetMSystem    ;
      property MCurrentDir   : MessageKind read GetMCurrentDir write SetMCurrentDir;
      property MFound        : MessageKind read GetMFound      write SetMFound     ;

      property ID : Integer read FID write FID;
  end;

var
  UniCodeSupport: Boolean;

  function PathMatchSpecA(pszFile, pszSpec: PAnsiChar): Boolean; stdcall;
  function PathMatchSpecW(pszFile, pszSpec: PWideChar): Boolean; stdcall;

implementation

  function PathMatchSpecA(pszFile, pszSpec: PAnsiChar): Boolean; external 'shlwapi.dll';
  function PathMatchSpecW(pszFile, pszSpec: PWideChar): Boolean; external 'shlwapi.dll';

{******************************************************************************}
{* Private methods                                                            *}
{******************************************************************************}

procedure TSearchTool.CreateFoundMessage(const Msg: Cardinal; const wParam, lParam: Integer);
begin
  if FMHandle = 0 then exit;  
  case FMFound of
    mkPostMessage: PostMessage(FMHandle, Msg, wParam, lParam);
    mkSendMessage: SendMessage(FMHandle, Msg, wParam, lParam);
  end
end;

{*----------------------------------------------------------------------------*}

procedure TSearchTool.CreateCurrentDirMessage(const wParam, lParam: Integer);
begin
  if FMHandle = 0 then exit;
  case FMCurrentDir of
    mkPostMessage: PostMessage(FMHandle, ST_CurrentDir, wParam, lParam);
    mkSendMessage: SendMessage(FMHandle, ST_CurrentDir, wParam, lParam);
  end
end;

{*----------------------------------------------------------------------------*}

procedure TSearchTool.CreateSystemMessage(const Msg: Cardinal; const wParam, lParam: Integer);
begin
  if FMHandle = 0 then exit;
  case FMSystem of
    mkPostMessage: PostMessage(FMHandle, Msg, wParam, lParam);
    mkSendMessage: SendMessage(FMHandle, Msg, wParam, lParam);
  end
end;

{*----------------------------------------------------------------------------*}

procedure TSearchTool.NewFile(lPm: Integer);
begin
  if FMHandle = 0 then exit;
  if (FMFound = mkPostMessage) and (not FListFiles) then lPm:=0;
  CreateFoundMessage(ST_NewFile, wParam(FID), lPm)
end;

{*----------------------------------------------------------------------------*}

procedure TSearchTool.NewDir(lPm: Integer);
begin
  if FMHandle = 0 then exit;
  if (FMFound = mkPostMessage) and (not FListDirs) then lPm:=0;
  CreateFoundMessage(ST_NewDir, wParam(FID), lPm)
end;

{*----------------------------------------------------------------------------*}

procedure TSearchTool.ChangeDir(NewDir: UnicodeString);
begin
  FCurrentDir:=NewDir;
  CreateCurrentDirMessage(0, lParam(PWideChar(FCurrentDir)));
end;

{*----------------------------------------------------------------------------*}

procedure TSearchTool.AddDir(const Dir: UnicodeString);
begin
  if FListDirs then
  begin
    if FDirsCount = FSaveDirsMemSize then
    begin
      FSaveDirsMemSize:=FSaveDirsMemSize shl 1;
      SetLength(FDirs, FSaveDirsMemSize);
    end;
    FDirs[FDirsCount]:=Dir;
    NewDir(lParam(PWideChar(FDirs[FDirsCount])));
    inc(FDirsCount);
  end
  else NewDir(lParam(PWideChar(Dir)));
end;

{*----------------------------------------------------------------------------*}

procedure TSearchTool.AddFile(const FileName: UnicodeString);
begin
  if FListFiles then
  begin
    if FFilesCount = FSaveFilesMemSize then
    begin
      FSaveFilesMemSize:=FSaveFilesMemSize shl 1;
      SetLength(FFiles, FSaveFilesMemSize);
    end;
    FFiles[FFilesCount]:=FileName;
    NewFile(lParam(PWideChar(FFiles[FFilesCount])));
    inc(FFilesCount);
  end
  else NewFile(lParam(FileName));
end;

{*----------------------------------------------------------------------------*}

procedure TSearchTool.GetFilesA(Root: AnsiString);
var
  wfd      : TWin32FindDataA;
  HFindFile: THandle        ;
  FileName : AnsiString     ;
  NextDir  : AnsiString     ;
begin
  if not FBreak then
  begin
    ZeroMemory(@wfd, SizeOf(wfd));
    HFindFile:=FindFirstFileA(PAnsiChar(Root+'*'), wfd);
    if not ((HFindFile=0) or (HFindFile = INVALID_HANDLE_VALUE)) then
    begin
      try
        repeat
          if (wfd.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = FILE_ATTRIBUTE_DIRECTORY then
          begin
            if not ((AnsiString(wfd.cFileName) = '.') or (AnsiString(wfd.cFileName) = '..')) then
            begin
              FileName := Root+wfd.cFileName;
              if PathMatchSpecA(PAnsiChar(FileName), PAnsiChar(FMaskA)) then AddDir(UnicodeString(FileName));
              if FRecurse then
              begin
                NextDir:=Root+wfd.cFileName+AnsiChar('\');
                ChangeDir(UnicodeString(NextDir));
                GetFilesA(NextDir);
                ChangeDir(UnicodeString(Root));
              end
            end
          end
          else
          begin
            FileName:=Root+wfd.cFileName;
            if PathMatchSpecA(PAnsiChar(FileName), PAnsiChar(FMaskA)) then AddFile(UnicodeString(Root+wfd.cFileName))
          end;
        until (not FindNextFileA(HFindFile, wfd)) or FBreak
      finally
        Windows.FindClose(HFindFile)
      end
    end
  end
end;

{*----------------------------------------------------------------------------*}

procedure TSearchTool.GetFilesW(Root: UnicodeString);
var
  wfd      : TWin32FindDataW;
  HFindFile: THandle        ;
  FileName : UnicodeString  ;
  NextDir  : UnicodeString  ;
begin
  ChangeDir(Root);
  if not FBreak then
  begin
    ZeroMemory(@wfd, SizeOf(wfd));
    HFindFile:=FindFirstFileW(PWideChar(Root+'*'), wfd);
    if not ((HFindFile=0) or (HFindFile = INVALID_HANDLE_VALUE)) then
    begin
      try
        repeat
          if (wfd.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = FILE_ATTRIBUTE_DIRECTORY then
          begin
            if not ((UnicodeString(wfd.cFileName)='.') or (UnicodeString(wfd.cFileName)='..')) then
            begin
              FileName:=Root+wfd.cFileName;
              if PathMatchSpecW(PWideChar(FileName), PWideChar(FMask)) then AddDir(FileName);
              if FRecurse then        
              begin
                NextDir:=Root+wfd.cFileName+WideChar('\');
                ChangeDir(NextDir);
                GetFilesW(NextDir);
                ChangeDir(Root);
              end;
            end;
          end
          else
          begin
            FileName:=Root+wfd.cFileName;
            if PathMatchSpecW(PWideChar(FileName), PWideChar(FMask)) then AddFile(Root+wfd.cFileName)
          end;
        until (not FindNextFileW(HFindFile, wfd)) or FBreak
      finally
        Windows.FindClose(HFindFile)
      end
    end
  end
end;

{*----------------------------------------------------------------------------*}

procedure TSearchTool.SearchFilesA(const Root: AnsiString);
var
  DrStrLen: Cardinal;
  DrStr   : AnsiString;
  CrDrStr : PAnsiChar;
  CrDrLen : Integer;

  DirEx   : Cardinal;
  Dw1, Dw2: Cardinal;
begin
  if Root = AnsiString(NameOfMyComputer) + '\' then
  begin
    DrStrLen := GetLogicalDriveStringsA(0, nil);
    SetLength(DrStr, DrStrLen);
    if GetLogicalDriveStringsA(DrStrLen, @DrStr[1])=DrStrLen-1 then
    begin
      CrDrStr:=PAnsiChar(DrStr);
      while (not FBreak) and (CrDrStr[0] <> #0) do
      begin
        ChangeDir(UnicodeString(AnsiString(CrDrStr)));
        if PathMatchSpecA(CrDrStr, PAnsiChar(FMaskA)) then AddDir(UnicodeString(AnsiString(CrDrStr)));
        CrDrLen:=lstrlenA(CrDrStr);
        if FRecurse and GetVolumeInformationA(CrDrStr, nil, 0, nil, DW1, DW2, nil, 0) then GetFilesA(CrDrStr);
        inc(CrDrStr, CrDrLen+1)
      end
    end
  end
  else
  begin
    DirEx:=GetFileAttributesA(PAnsiChar(Root)); //DirectoryExists
    if (DirEx<>DWord(-1)) and (FILE_ATTRIBUTE_DIRECTORY and DirEx=FILE_ATTRIBUTE_DIRECTORY) then
    begin
      GetFilesA(Root);
    end
  end
end;

{*----------------------------------------------------------------------------*}

procedure TSearchTool.SearchFilesW(const Root: UnicodeString);
var
  DrStrLen: Cardinal;
  DrStr   : UnicodeString;
  CrDrStr : PWideChar;
  CrDrLen : Integer;

  DirEx   : Cardinal;
  Dw1, Dw2: Cardinal;
begin
  if Root = NameOfMyComputer + '\' then
  begin
    DrStrLen := GetLogicalDriveStringsW(0, nil);
    SetLength(DrStr, DrStrLen);
    if GetLogicalDriveStringsW(DrStrLen, @DrStr[1])=DrStrLen-1 then
    begin
      CrDrStr:=PWideChar(DrStr);
      while (not FBreak) and (CrDrStr[0] <> #0) do
      begin
        ChangeDir(CrDrStr);
        if PathMatchSpecW(CrDrStr, PWideChar(FMask)) then AddDir(CrDrStr);
        CrDrLen:=lstrlenW(CrDrStr);
        if FRecurse and GetVolumeInformationW(CrDrStr, nil, 0, nil, DW1, DW2, nil, 0) then GetFilesW(CrDrStr);
        inc(CrDrStr, CrDrLen+1)
      end
    end
  end
  else
  begin
    DirEx:=GetFileAttributesW(PWideChar(Root)); //DirectoryExists
    if (DirEx<>DWord(-1)) and (FILE_ATTRIBUTE_DIRECTORY and DirEx=FILE_ATTRIBUTE_DIRECTORY) then
    begin
      GetFilesW(Root);
    end
  end
end;

{*----------------------------------------------------------------------------*}

procedure TSearchTool.StartSearch;
var
  lenFStr: Integer;
  Lock   : RTL_CRITICAL_SECTION;
  CurDirA: AnsiSTring;
begin
  FStartTime:=GetTickCount;
  FBreak      :=false;
  CreateSystemMessage(ST_Start, FID, 0);

  //Start-Reservation
  if FListFiles then
  begin
    FSaveFilesMemSize:=100 ;
    SetLength(FFiles, 100);
  end
  else
  begin
    FSaveFilesMemSize:=0 ;
    FFiles:=nil;
  end;
  FFilesCount := 0  ;
  if FListDirs then
  begin
    FSaveDirsMemSize:=100 ;
    SetLength(FDirs, 100);
  end
  else
  begin
    FSaveDirsMemSize:=0;
    FDirs:= nil;
  end;
  FDirsCount := 0  ;

  if UniCodeSupport then
  begin
    lenFStr := lstrlenW(PWideChar(FCurrentDir));
    if lenFStr > 0 then
    begin
      if FCurrentDir[lenFStr] <> '\' then
      begin
        if FCurrentDir[lenFStr] = '/' then FCurrentDir[lenFStr] := '\'
                                      else FCurrentDir := FCurrentDir+'\'
      end;
      SearchFilesW(FCurrentDir)
    end;
  end
  else
  begin
    CurDirA := AnsiString(FCurrentDir);
    lenFStr := lstrlenA(PAnsiChar(CurDirA));
    if lenFStr > 0 then
    begin
      if CurDirA[lenFStr] <> '\' then
      begin
        if CurDirA[lenFStr] = '/' then CurDirA[lenFStr] := '\'
                                  else CurDirA := CurDirA+'\'
      end;
      FCurrentDir:=UnicodeString(CurDirA);
      SearchFilesA(CurDirA)
    end;
  end;

  FCurrentDir:='';
  if FListFiles then SetLength(FFiles, FFilesCount);
  if FListDirs  then SetLength(FDirs , FDirsCount );
  FSearchDuration:=GetTickCount-FStartTime;
  CreateSystemMessage(ST_Finish, FID, 0);
  FBreak      :=false;
  InitializeCriticalSection(Lock);
  EnterCriticalSection(Lock);
    FIsSearching:=false;
    if FExtraThread then CloseHandle(FThread);
  LeaveCriticalSection(Lock);
  DeleteCriticalSection(Lock);  
end;

{*----------------------------------------------------------------------------*}

function TSearchTool.NameOfMyComputer: UnicodeString; //Bezeichnung des Arbeitsplatzes
var
  pMal: IMalloc    ;
  pidl: PItemIdList;
  isf: IShellFolder;
  StrRet: TStrRet  ;
  p: PChar;
begin
  Result:='';
  if (SHGetMalloc(pMal) = NoError) and
     (SHGetDesktopFolder(isf) = NoError) then
  begin
    try
      SHGetSpecialFolderLocation(0, CSIDL_Drives, pidl);
      if pidl <> nil then
      begin
        if isf.GetDisplayNameOf(pidl, SHGDN_NORMAL, StrRet) = S_OK then
        begin
          case StrRet.uType of
            //STRRET_CSTR  : SetString(Result, StrRet.cStr, lstrlen(StrRet.cStr));
            STRRET_CSTR  : SetString(Result, StrRet.cStr, lstrlenA(StrRet.pStr));
            STRRET_OFFSET: begin
                             p:=PChar(@pidl.mkid.abID[StrRet.uOffset-SizeOf(pidl.mkid.cb)]);
                             SetString(Result, p, lstrlen(p))
                           end;
            STRRET_WSTR  : Result:=StrRet.pOleStr;
          end
        end
      end;
    finally
      if pidl<> nil then pMal.Free(pidl);
      isf:=nil;
      pMal:=nil
    end
  end
end;

{*----------------------------------------------------------------------------*}

function TSearchTool.GetDuration: Cardinal;
begin
  if FIsSearching then Result:=GetTickCount-FStartTime
                  else Result:=FSearchDuration;
end;

{*----------------------------------------------------------------------------*}

function TSearchTool.GetCurrentDir: UnicodeString;
begin
  Result:=FCurrentDir; //wird von der TRL synchronisiert
end;

{*----------------------------------------------------------------------------*}

function TSearchTool.GetFilesCount : Integer;
begin
  InterlockedExchange(Integer(Result), Integer(FFilesCount));
end;

function TSearchTool.GetDirsCount : Integer;
begin
  InterlockedExchange(Integer(Result), Integer(FDirsCount));
end;

{*----------------------------------------------------------------------------*}

function TSearchTool.GetListFiles: LongBool;
begin
  InterlockedExchange(Integer(Result), Integer(FListFiles));
end;

{*----------------------------------------------------------------------------*}

function TSearchTool.GetListDirs: LongBool;
begin
  InterlockedExchange(Integer(Result), Integer(FListDirs));
end;

{*----------------------------------------------------------------------------*}

function TSearchTool.GetRecurse: LongBool;
begin
  InterlockedExchange(Integer(Result), Integer(FRecurse));
end;

{*----------------------------------------------------------------------------*}

function TSearchTool.GetMHandle: THandle;
begin
  InterlockedExchange(Integer(Result), Integer(FMHandle))
end;

{*----------------------------------------------------------------------------*}

function TSearchTool.GetMSystem: MessageKind;
begin
  InterlockedExchange(Integer(Result), Integer(FMSystem));
end;

{*----------------------------------------------------------------------------*}

function TSearchTool.GetMCurrentDir: MessageKind;
begin
  InterlockedExchange(Integer(Result), Integer(FMCurrentDir));
end;

{*----------------------------------------------------------------------------*}

function TSearchTool.GetMFound: MessageKind;
begin
  InterlockedExchange(Integer(Result), Integer(FMFound));
end;

{*----------------------------------------------------------------------------*}

procedure TSearchTool.SetMask(Value: UnicodeString);
begin
  FMask  := Value;
  FMaskA := AnsiString(Value);
end;

{*----------------------------------------------------------------------------*}

procedure TSearchTool.SetListFiles(Value: LongBool);
begin
  InterlockedExchange(Integer(FListFiles), Integer(Value));
end;

{*----------------------------------------------------------------------------*}

procedure TSearchTool.SetListDirs(Value: LongBool);
begin
  InterlockedExchange(Integer(FListDirs), Integer(Value));
end;

{*----------------------------------------------------------------------------*}

procedure TSearchTool.SetRecurse(Value: LongBool);
begin
  InterlockedExchange(Integer(FRecurse), Integer(Value));
end;

{*----------------------------------------------------------------------------*}

procedure TSearchTool.SetMHandle(Value: THandle);
begin
  InterlockedExchange(Integer(FMHandle), Value)
end;

{*----------------------------------------------------------------------------*}

procedure TSearchTool.SetMSystem(Value: MessageKind);
begin
  InterlockedExchange(Integer(FMSystem), Integer(Value));
end;

{*----------------------------------------------------------------------------*}

procedure TSearchTool.SetMCurrentDir(Value: MessageKind);
begin
  InterlockedExchange(Integer(FMCurrentDir), Integer(Value));
end;

{*----------------------------------------------------------------------------*}

procedure TSearchTool.SetMFound     (Value: MessageKind);
begin
  InterlockedExchange(Integer(FMFound), Integer(Value));
end;

{*----------------------------------------------------------------------------*}

procedure StartThread(ST: TSearchTool);
begin
  ST.StartSearch;
end;

{******************************************************************************}
{* Public methods                                                             *}
{******************************************************************************}

constructor TSearchTool.Create;
begin
  ResetData;
  FThread         := 0;
  FExtraThread    := false;
  FSearchDuration := 0;
  FRecurse        := false;

  FMHandle        := 0    ;
  FMSystem        := mkPostMessage;
  FMCurrentDir    := mkPostMessage;
  FMFound         := mkPostMessage;

  FIsSearching    := false;
  FBreak          := false;
  FListDirs       := true ;
  FListFiles      := true ;
end;

{*----------------------------------------------------------------------------*}

destructor TSearchTool.Destroy;
begin
  Self.Break;
end;

{*----------------------------------------------------------------------------*}

function TSearchTool.ResetData: Boolean;
begin
  if not FIsSearching then
  begin
    FFiles            := nil;
    FFilesCount       :=   0;
    FSaveFilesMemSize :=   0;

    FDirs             := nil;
    FDirsCount        := 0  ;
    FSaveDirsMemSize  := 0  ;
    Result            :=true;
  end
  else Result:=false
end;

{*----------------------------------------------------------------------------*}

procedure TSearchTool.SearchFiles(const RootFolder: UnicodeString; const ExtraThread: Boolean = true);
var
  Dummy   : Cardinal;
begin
  Self.Break;

  FIsSearching:=true;
  FCurrentDir:=RootFolder;
  FSearchDuration:=0;
  if ExtraThread then
  begin
    FExtraThread:=true;
    FThread:=BeginThread(nil, 0, @StartThread, Self, 0, Dummy);
  end
  else
  begin
    FExtraThread:=false;
    StartSearch;
  end;
end;

{*----------------------------------------------------------------------------*}

procedure TSearchTool.SearchFiles(const RootFolder: UnicodeString; const Mask: UnicodeString;
                                  const Recurse: Boolean = false; const ExtraThread: Boolean = true);
var
  Dummy   : Cardinal;
begin
  Self.Break;
  FRecurse := Recurse;
  FMask    := Mask;
  FMaskA   := AnsiString(Mask);

  FIsSearching:=true;
  FCurrentDir:=RootFolder;
  FSearchDuration:=0;
  if ExtraThread then
  begin
    FExtraThread:=true;
    FThread:=BeginThread(nil, 0, @StartThread, Self, 0, Dummy);
  end
  else
  begin
    FExtraThread:=false;
    StartSearch;
  end;
end;

{*----------------------------------------------------------------------------*}

procedure TSearchTool.Break;
var
  waitRes: Cardinal;
begin
  InterlockedExchange(Integer(FBreak), Integer(true)); //1=true
  if FIsSearching then
  begin
    if FExtraThread then
    begin
      waitRes:=WAIT_TIMEOUT;
      while (waitRes = WAIT_TIMEOUT) and FIsSearching do
      begin
        Application.ProcessMessages;
        waitRes:=WaitForSingleObject(FThread, 100);
      end;
    end
    else
    begin
      while FIsSearching do
      begin
        Application.ProcessMessages;
      end;
    end;
  end;
end;

{*----------------------------------------------------------------------------*}

initialization
  UniCodeSupport:=Win32Platform = VER_PLATFORM_WIN32_NT;
  
end.
