unit DeleteHelper;

interface

uses windows, classes, SysUtils, Contnrs, strUtils,
    Nemp_ConstantsAndTypes, Hilfsfunktionen;

type

    // Network-Code from http://www.delphi-forum.de/viewtopic.php?t=1907
    PNetResourceArray = ^TNetResourceArray;
    TNetResourceArray = array[0..100] of TNetResourceA;


    TDeleteRecommendation = (dr_Keep, dr_Delete);
    TDeleteHint = (dh_DivePresent, dh_DriveMissing, dh_NetworkPresent, dh_NetworkMissing);

    TDeleteData = class
        public
            DriveString : String;    // i.e. "c:\" or "\\MyOtherPC\"
            DoDelete    : Boolean;   // User-Input
            Recommendation : TDeleteRecommendation; // What should be done?
            Hint: TDeleteHint;                      // ... and why?
            Files: TObjectList;

            constructor Create;
            destructor Destroy; override;

    end;

    procedure ScanNetworkResources(ResourceType, DisplayType: DWord; List: TStrings);
    function RechnerInWG(hwnd: HWND; hdc: HDC ; lpnr: PNetResource; Clients: TStrings ): Boolean;

implementation


function RechnerInWG(hwnd: HWND; hdc: HDC ; lpnr: PNetResource; Clients: TStrings ): Boolean;
var
    cbBuffer: DWORD; // = 16384;
var
    hEnum, dwResult, dwResultEnum : DWORD;
    lpnrLocal : array [0..16384 div SizeOf(TNetResource)] of TNetResource;
    i : integer;
    cEntries : Longint;
begin
    centries := -1;
    cbBuffer := 16384;
    dwResult := WNetOpenEnum( RESOURCE_CONTEXT, RESOURCETYPE_DISK, 0, lpnr, hEnum);
    if (dwResult <> NO_ERROR) then
    begin
        Result := False;
        Exit;
    end;
    FillChar( lpnrLocal, cbBuffer, 0 );
    dwResultEnum := WNetEnumResource(hEnum, DWORD(cEntries), @lpnrLocal, cbBuffer);
    Clients.Clear;
    for i := 0 to cEntries - 1 do
    begin
        Clients.Add(lpnrLocal[i].lpRemoteName);
    end;
    dwResult := WNetCloseEnum(hEnum);

    if(dwResult <> NO_ERROR) then
    begin
        Result := False;
    end
    else
    begin
        Result := True;
    end;
end;


Function CreateNetResourceList(ResourceType: DWord;
                               NetResource: PNetResourceA;
                               out Entries: DWord;
                               out List: PNetResourceArray): Boolean;
var EnumHandle: THandle;
    BufSize: DWord;
    Res: DWord;
begin
    Result := False;
    List := Nil;
    Entries := 0;
    if WNetOpenEnumA(RESOURCE_CONTEXT, ResourceType,0,NetResource, EnumHandle) = NO_ERROR then
    begin
        try
            BufSize := $4000;   // 16 kByte
            GetMem(List, BufSize);
            try
                repeat
                    Entries := DWord(-1);
                    FillChar(List^, BufSize, 0);
                    Res := WNetEnumResourceA(EnumHandle, Entries, List, BufSize);
                    if Res = ERROR_MORE_DATA
                    then begin
                          //BufSize := BufSize*2;
                         ReAllocMem(List, BufSize);
                         end;
                until Res <> ERROR_MORE_DATA;
                Result := Res = NO_ERROR;
                if not Result then
                begin
                    FreeMem(List);
                    List := Nil;
                    Entries := 0;
                end;
            except
                FreeMem(List);
                raise;
            end;
        finally
            WNetCloseEnum(EnumHandle);
        end;
    end;
end;
                      aasa

procedure ScanNetworkResources(ResourceType, DisplayType: DWord; List: TStrings);

    procedure ScanLevel(NetResource: PNetResourceA);
    var
      Entries: DWord;
      NetResourceList: PNetResourceArray;
      i: Integer;
    begin
        if CreateNetResourceList(ResourceType, NetResource, Entries, NetResourceList) then
        try
            for i := 0 to Integer(Entries) - 1 do
            begin
                if (DisplayType = RESOURCEDISPLAYTYPE_GENERIC)
                  or (NetResourceList[i].dwDisplayType = DisplayType)
                then
                begin
                    List.AddObject(NetResourceList[i].lpRemoteName + '\',
                               Pointer(NetResourceList[i].dwDisplayType));
                end;
                //if (NetResourceList[i].dwUsage and RESOURCEUSAGE_CONTAINER) <> 0 then
                //    ScanLevel(@NetResourceList[i]);
            end;
        finally
            FreeMem(NetResourceList);
        end;
    end;

begin
    ScanLevel(Nil);
end;

{ TDeleteData }

constructor TDeleteData.Create;
begin
    Files := TObjectList.Create(False);
end;

destructor TDeleteData.Destroy;
begin
    Files.Free;
    inherited;
end;

end.
