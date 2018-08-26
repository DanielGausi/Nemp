unit lcdg15;

{

Copyright (C) 2006 smurfynet at users.sourceforge.net
This is free software distributed under the terms of the
GNU Public License.  See the file COPYING for details.
$Id: lcdg15.pas,v 0.3 2007/05/01 smurfy.de $

Changes:

v0.5: Changed pixels[] to scanline in SendToDisplay
      => much better performance

v0.42:
  Update for Delphi 2009 - Daniel Gaussmann

v0.4.1:
 hook and events for volume wheel
v0.4.0:
 modifications for SetAsLCDForegroundApp and
 UpdateImage with different priorities - Uwe Mannl
v0.3:
 modifications for new Wrapper-DLL - Olaf Stieleke
v0.2:
 added support for configure and softbuttonscallback
v0.1:
 initial release support main functions

}



interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Dialogs, StdCtrls, ExtCtrls;

{///************************************************************************ }
{/// lgLcdDeviceDesc }
{///************************************************************************ }


type
  lgLcdDeviceDesc = record
    Width: LongInt;
    Height: LongInt;
    Bpp: LongInt;
    NumSoftButtons: LongInt;
  end {lgLcdDeviceDesc};

type
  PKBDLLHOOKSTRUCT = ^KBDLLHOOKSTRUCT;

  KBDLLHOOKSTRUCT = packed record
    vkCode      : DWORD;
    scanCode    : DWORD;
    flags       : DWORD;
    time        : DWORD;
    dwExtraInfo : DWORD;
  end;

{///************************************************************************ }
{/// lgLcdBitmap }
{///************************************************************************ }

const
  LGLCD_BMP_FORMAT_160x43x1 = $00000001;
  LGLCD_BMP_WIDTH = (160);
  LGLCD_BMP_HEIGHT = (43);
  LLKHF_EXTENDED = $00000001;
  LLKHF_INJECTED = $00000010;
  LLKHF_ALTDOWN  = $00000020;
  LLKHF_UP       = $00000080;
  LLMHF_INJECTED = $00000001;
  WH_Keyboard_LL = 13;

type
  PlgLcdBitmapHeader = ^lgLcdBitmapHeader;
  lgLcdBitmapHeader = record
    Format: LongInt;
  end {lgLcdBitmapHeader};

type
  lgLcdBitmap160x43x1 = record
    hdr: LGLCDBITMAPHEADER;
    pixels : array[0..6879] of byte; { LGLCD_BMP_WIDTH * LGLCD_BMP_HEIGHT}
  end {lgLcdBitmap160x43x1};

{/// Priorities }
const
  LGLCD_PRIORITY_IDLE_NO_SHOW = (0);
  LGLCD_PRIORITY_BACKGROUND = (64);
  LGLCD_PRIORITY_NORMAL = (128);
  LGLCD_PRIORITY_ALERT = (255);
  LGLCD_SYNC_UPDATE = $80000000;

{///************************************************************************ }
{/// Callbacks }
{///************************************************************************ }

// currently not in use  

type lgLcdOnConfigureCB = function (connection:integer;const pContext:Pointer):dword;stdcall;
type lgLcdOnSoftButtonsCB = function(device:integer;dwButtons:dword;pContext:pointer):dword;stdcall;


{///************************************************************************ }
{/// lgLcdConnectContext }
{///************************************************************************ }


type
  lgLcdConfigureContext = record
{/// Set to NULL if not configurable }
    configCallback: LGLCDONCONFIGURECB;
    configContext: pointer;
  end {lgLcdConfigureContext};

type
  lgLcdConnectContextA = record
{/// "Friendly name" display in the listing }
    appFriendlyName: pAnsiChar;
{/// isPersistent determines whether this connection persists in the list }
    isPersistent: Bool;
{/// isAutostartable determines whether the client can be started by }
{/// LCDMon }
    isAutostartable: Bool;
    onConfigure: lgLcdConfigureContext;
{/// --> Connection handle }
    connection: Integer;
  end {lgLcdConnectContextA};


{///************************************************************************ }
{/// lgLcdOpenContext }
{///************************************************************************ }

type
  lgLcdSoftbuttonsChangedContext = record
{/// Set to NULL if no softbutton notifications are needed }
    softbuttonsChangedCallback: LGLCDONSOFTBUTTONSCB;
    softbuttonsChangedContext: Pointer;
  end {lgLcdSoftbuttonsChangedContext};

type
  lgLcdOpenContext = record
    connection: Integer;
{/// Device index to open }
    index: Integer;
    onSoftbuttonsChanged: LGLCDSOFTBUTTONSCHANGEDCONTEXT;
{/// --> Device handle }
    device: Integer;
  end {lgLcdOpenContext};


{///************************************************************************ }
{/// Exported functions }
{///************************************************************************ }

//Calling convention now cdecl, not stdcall anymore - OST, 01.05.2007
function lgLcdInit:dword; cdecl;
procedure lgLcdDeInit;cdecl;
function lgLcdEnumerate(connection,index:integer; var lgLcdDeviceDesc:lgLcdDeviceDesc): word; cdecl;
function lgLcdClose(device:integer):dword;cdecl;
function lgLcdConnectA(var lgLcdConnectContextA: lgLcdConnectContextA):dword;cdecl;
function lgLcdDisconnect(connection:integer):dword;cdecl;
function lgLcdOpen(var lgLcdOpenContext:lgLcdOpenContext):dword;cdecl;
function lgLcdUpdateBitmap(device:integer; lgLcdBitmapHeader:PlgLcdBitmapHeader;priority:dword):dword;cdecl;
function lgLcdReadSoftButtons(device:integer; var button:dword):dword;cdecl;
function lgLcdSetAsLCDForegroundApp(device:integer; foregroundYesNoFlag:integer):dword;cdecl;

procedure HOOK_VOLWHEEL( power : Boolean ); cdecl;
//procedure HOOK_ALPHA( power : Boolean ); cdecl;

procedure StartHook; cdecl;
procedure StopHook; cdecl;

{///************************************************************************ }
{/// Delphi Helper Class  }
{///************************************************************************ }

function TLcdG15LcdOnSoftButtonsCB(device:integer;dwButtons:dword;pContext:pointer):dword; stdcall;
function TLcdG15LcdOnConfigureCB(connection:integer;const pContext:Pointer):dword;stdcall;

type TOnSoftButtonsCB = procedure(dwButtons:integer) of Object;
type TOnConfigureCB = procedure() of Object;

type TLcdG15 = class(TComponent)
  private
   LCanvas : TCanvas;
   fSourceBitmap: TBitmap;
   LOpenContext : lgLcdOpenContext;
   LOnSoftButtonsCB : TOnSoftButtonsCB;
   LOnConfigureCB : TOnConfigureCB;
  public
    CreateComplete: Boolean;
   property OnSoftButtons : TOnSoftButtonsCB read LOnSoftButtonsCB write LOnSoftButtonsCB;
   property OnConfigure : TOnConfigureCB read LOnConfigureCB write LOnConfigureCB;
   property LcdCanvas : TCanvas read LCanvas write LCanvas;
   // note: SourceBitmap MUST have PixelFormat pf8bit !!!!
   property SourceBitmap: TBitmap read fSourceBitmap write fSourceBitmap;
   constructor Create(ApplicationName:AnsiString;isPersistent:Bool;isAutostartable:Bool;SupportConfigure:boolean = false); reintroduce;
   destructor Destroy(); override;
   procedure SendToDisplay(priority:integer);
   procedure ClearDisplay();
   function GetButtonsPress():integer;
   function SetAsLCDForegroundApp(foregroundYesNoFlag: integer):integer;
end;

implementation

var
  OldHook: HHook;
  //KeyHookMessage: Cardinal;
  TrappingVolumeWheel,
  TrappingAlpha : Boolean;

{///************************************************************************ }
{/// Load Exported functions }
{///************************************************************************ }

//Changed calling convention and renaming of the imported DLL-Functions
//OST, 01.05.2007
function lgLcdEnumerate(connection,index:integer; var lgLcdDeviceDesc:lgLcdDeviceDesc): word; cdecl;
external 'lgLcdWrapper.dll' name 'lgLcdEnumerateWrap';

function lgLcdInit:dword; cdecl;
external 'lgLcdWrapper.dll' name 'lgLcdInitWrap';

procedure lgLcdDeInit;cdecl;
external 'lgLcdWrapper.dll' name 'lgLcdDeInitWrap';

function lgLcdClose(device:integer):dword;cdecl;
external 'lgLcdWrapper.dll' name 'lgLcdCloseWrap';

function lgLcdConnectA(var lgLcdConnectContextA : lgLcdConnectContextA):dword;cdecl;
external 'lgLcdWrapper.dll' name 'lgLcdConnectAWrap';

function lgLcdDisconnect(connection:integer):dword;cdecl;
external 'lgLcdWrapper.dll' name 'lgLcdDisconnectWrap';

function lgLcdOpen(var lgLcdOpenContext:lgLcdOpenContext):dword;cdecl;
external 'lgLcdWrapper.dll' name 'lgLcdOpenWrap';

function lgLcdUpdateBitmap(device:integer; lgLcdBitmapHeader:PlgLcdBitmapHeader;priority:dword):dword;cdecl;
external 'lgLcdWrapper.dll' name 'lgLcdUpdateBitmapWrap';

function lgLcdReadSoftButtons(device:integer; var button:dword):dword;cdecl;
external 'lgLcdWrapper.dll' name 'lgLcdReadSoftButtonsWrap';

function lgLcdSetAsLCDForegroundApp(device:integer; foregroundYesNoFlag:integer):dword;cdecl;
external 'lgLcdWrapper.dll' name 'lgLcdSetAsLCDForegroundAppWrap';

{///************************************************************************ }
{/// Delphi Helper Class  implementation}
{///************************************************************************ }

constructor TLcdG15.Create(ApplicationName:AnsiString;isPersistent:Bool;isAutostartable:Bool;SupportConfigure:boolean = false);
var ConnectContext : lgLcdConnectContextA;
    DeviceDescription : lgLcdDeviceDesc;
    Status : integer;
begin
  CreateComplete := False;
  LCanvas := Nil;


  //init display
  Status := lgLcdInit();

  if Status <> 0 then
      exit;


  //init connect to display
  ConnectContext.appFriendlyName := pAnsiChar(ApplicationName);
  ConnectContext.isPersistent := isPersistent;
  ConnectContext.isAutostartable := isAutostartable;

  if (SupportConfigure) then
  begin
   ConnectContext.onConfigure.configCallback := TLcdG15LcdOnConfigureCB;
   ConnectContext.onConfigure.configContext := self;
  end
  else
  begin
   ConnectContext.onConfigure.configCallback := nil;
   ConnectContext.onConfigure.configContext := nil;
  end;
  
  ConnectContext.connection := -1;

  //connect
  Status := lgLcdConnectA(ConnectContext);
  // assert(status = 0);
  if (Status <> 0) or (ConnectContext.connection = -1) then
      exit;
  //assert(ConnectContext.connection <> -1);

  //enum display. connect to display 0 !
  Status :=lgLcdEnumerate(ConnectContext.connection,0,DeviceDescription);
  if Status <> 0 then
      exit;
  //assert(status = 0);

  LOpenContext.connection := ConnectContext.connection;
  LOpenContext.index := 0;
  LOpenContext.onSoftbuttonsChanged.softbuttonsChangedCallback := TLcdG15LcdOnSoftButtonsCB;
  LOpenContext.onSoftbuttonsChanged.softbuttonsChangedContext := self;
  LOpenContext.device := -1;
  Status := lgLcdOpen(LOpenContext);
  if (Status <> 0) or (LOpenContext.device = -1) then
      exit;
  //assert(status = 0);
  //assert(LOpenContext.device <> -1);

  CreateComplete := True;


end;

destructor TLcdG15.Destroy();
begin
  lgLcdClose(LOpenContext.device);
  lgLcdDeInit;
end;

procedure TLcdG15.SendToDisplay(priority:integer);
var i,it,x2:integer;
    bmp : lgLcdBitmap160x43x1;
    P: PByteArray;
begin
  if (LOpenContext.device = -1) then exit;

  x2 := 0;
  for it := 0 to 43 -1 do
  begin
      P := SourceBitmap.ScanLine[it];
      for i := 0 to 160 -1 do
      begin
          if P[i] <> $ff then
              bmp.pixels[x2] := 128
          else
              bmp.pixels[x2] := 0;
          inc(x2);
      end;
  end;
    {
  x2:=0;
  for it:= 0 to 43 -1 do
  begin
    for i:= 0 to 160 -1 do
    begin
      tmp :=  SourceBitmap.Canvas.Pixels[i,it];
      if tmp <> $ffffff then
        bmp.pixels[x2] := 128
      else
        bmp.pixels[x2] := 0;
      inc(x2);
    end;
  end;
  }
 bmp.hdr.Format := LGLCD_BMP_FORMAT_160x43x1;
 lgLcdUpdateBitmap(LOpenContext.device,@bmp.hdr,LGLCD_SYNC_UPDATE or priority);
end;

procedure TLcdG15.ClearDisplay();
var
  bmp : lgLcdBitmap160x43x1;
  i : integer;
begin
 if (LOpenContext.device = -1) then exit;
 for i:= 0 to 160*43 -1 do
     bmp.pixels[i] := 0;

 bmp.hdr.Format := LGLCD_BMP_FORMAT_160x43x1;
 lgLcdUpdateBitmap(LOpenContext.device,@bmp.hdr,LGLCD_SYNC_UPDATE or 128);
end;

function TLcdG15.GetButtonsPress():integer;
var button : dword;
begin
 Result:=0;
 if (LOpenContext.device = -1) then exit;
 
 lgLcdReadSoftButtons(LOpenContext.device,button);
 result :=  button;
end;

function TLcdG15.SetAsLCDForegroundApp(foregroundYesNoFlag: integer):integer;
begin
  Result := 0;
  if (LOpenContext.device = -1) then exit;
  result := lgLcdSetAsLCDForegroundApp(LOpenContext.device, foregroundYesNoFlag);
end;

{///************************************************************************ }
{/// Delphi Callback helper  implementation}
{///************************************************************************ }

function TLcdG15LcdOnSoftButtonsCB(device:integer;dwButtons:dword;pContext:pointer):dword;stdcall;
begin
 Result:=0;
 if (pContext <> nil) then
 begin
  if (assigned(TLcdG15(pContext).LOnSoftButtonsCB)) then
  begin
          TLcdG15(pContext).LOnSoftButtonsCB( dwButtons);
  end;
 end;
end;

function TLcdG15LcdOnConfigureCB(connection:integer;const pContext:Pointer):dword;stdcall;
begin
 Result:=0;
 if (pContext <> nil) then
 begin
  if (assigned(TLcdG15(pContext).LOnConfigureCB)) then
  begin
          TLcdG15(pContext).LOnConfigureCB();
  end;
 end;
end;

function LowLevelHookProc( nCode:Integer; awParam: WPARAM; alParam:LPARAM): LRESULT; stdcall;
var
  pkbhs: PKBDLLHOOKSTRUCT;
  FilterThis: boolean;

begin
  // Don't hook this key by default
  FilterThis := false;

  // if the key action was key down, then
  if awParam = WM_KEYDOWN then
  begin

    if (nCode=HC_ACTION) and ((( alParam shr 16) and KF_UP) = 0) then
      pkbhs := PKBDLLHOOKSTRUCT(alParam);

    if TrappingVolumeWheel = true then
      if ( ( pkbhs^.vkCode = 174 ) OR ( pkbhs^.vkCode = 175 ) ) then
        FilterThis := true;

    if TrappingAlpha then
      case pkbhs^.vkCode of
        8 :      FilterThis := true; 		// Backspace
        13 :     FilterThis := true; 		// Enter
        27 :     FilterThis := true; 		// Escape
        32 :     FilterThis := true; 		// Space
        48..57 : FilterThis := true;  		// 0-9
        65..90 : FilterThis := true; 		// a-z
        189 :    FilterThis := true; 		// '-' key (hiphen)
      end;
      
  end;

  if ( ( awParam = WM_KEYDOWN ) AND ( FilterThis = true ) ) then
  begin
    {
     The key pressed is one that we want to hook, so send this to our application...
    }
    PostMessage(  FindWindow( 'TFormMain','FormMain'),  WM_APP+666,  13,  pkbhs^.vkCode   );
    Result := 1;

  end else
  begin
    // We do not want to hook the key pressed, so let it pass through to the active window...
    Result:= CallNextHookEx (OldHook, nCode, awParam, alParam)
  end;
end;

procedure StartHook; cdecl;
begin
  OldHook := SetWindowsHookEx(WH_Keyboard_LL, LowLevelHookProc, HInstance, 0);
end;

procedure StopHook; cdecl;
begin
  UnHookWindowsHookEx(OldHook);
end;

procedure HOOK_VOLWHEEL( power : Boolean ); cdecl;
begin
  if power <> TrappingVolumeWheel then
  begin
    TrappingVolumeWheel := power;
    if TrappingVolumeWheel OR TrappingAlpha then
      StartHook
    else
      StopHook;
  end;
end;

procedure HOOK_ALPHA( power : Boolean ); cdecl;
begin
  if power <> TrappingAlpha then
  begin
    TrappingAlpha := power;
    if TrappingVolumeWheel OR TrappingAlpha then
      StartHook
    else
      StopHook;
  end;
end;

end.
