{
  BASS_WADSP 2.4.1.0 Delphi API, copyright (c) 2005-2009 radio42, Bernd Niedergesaess.
  Requires BASS - available from www.un4seen.com

  See the BASS_WADSP.txt file for a more complete documentation

  NOTE:
  You should disable floating-point exceptions in your app, since this isn't done by default.
  Simply call before using/loading this library: 
  "Set8087CW($133F);"
  This is because some Winamp DSPs might change the FloatingPointUnit state and raise a stupid exception.
}

Unit BASS_WADSP;

interface

uses windows, bass;

const
  // Winamp SDK message parameter values (for lParam)
  BASS_WADSP_IPC_GETOUTPUTTIME    = 105;
  BASS_WADSP_IPC_ISPLAYING        = 104;
  BASS_WADSP_IPC_GETVERSION       = 0;
  BASS_WADSP_IPC_STARTPLAY        = 102;
  BASS_WADSP_IPC_GETINFO          = 126;
  BASS_WADSP_IPC_GETLISTLENGTH    = 124;
  BASS_WADSP_IPC_GETLISTPOS       = 125;
  BASS_WADSP_IPC_GETPLAYLISTFILE  = 211;
  BASS_WADSP_IPC_GETPLAYLISTTITLE = 212;
  BASS_WADSP_IPC                  = 1024;

type
  HWADSP = DWORD;       // Winamp DSP plugin handle

  WINAMPWINPROC = function(hwnd: HWND; msg: DWORD; wParam: DWORD; lParam: DWORD):DWORD; stdcall;
  {
    User defined Window Message Process Handler
    hwnd   : The Window handle we are dealing with
    msg    : The window message send
    wParam : The wParam message parameter see the Winamp SDK for further details
    lParam : The lParam message parameter see the Winamp SDK for further details
  }

const
  basswadspdll = 'bass_wadsp.dll';

function BASS_WADSP_GetVersion(): Integer; stdcall; external basswadspdll;
function BASS_WADSP_Init(hwndMain: HWND): BOOL; stdcall; external basswadspdll;
function BASS_WADSP_Free: BOOL; stdcall; external basswadspdll;
function BASS_WADSP_FreeDSP(plugin: HWADSP): BOOL; stdcall; external basswadspdll;
function BASS_WADSP_GetFakeWinampWnd(plugin: HWADSP): HWND; stdcall; external basswadspdll;
function BASS_WADSP_SetSongTitle(plugin: HWADSP; thetitle: PAnsiChar): BOOL; stdcall; external basswadspdll;
function BASS_WADSP_SetFileName(plugin: HWADSP; thefile: PAnsiChar): BOOL; stdcall; external basswadspdll;

function BASS_WADSP_Load(dspfile: PChar; x: Integer; y: Integer; width: Integer; height: Integer; proc: WINAMPWINPROC): HWADSP; stdcall; external basswadspdll;
function BASS_WADSP_Config(plugin: HWADSP): BOOL; stdcall; external basswadspdll;
function BASS_WADSP_Start(plugin: HWADSP; module: Integer; hchan: DWORD): BOOL; stdcall; external basswadspdll;
function BASS_WADSP_Stop(plugin: HWADSP): BOOL; stdcall; external basswadspdll;
function BASS_WADSP_SetChannel(plugin: HWADSP; hchan: DWORD): BOOL; stdcall; external basswadspdll;
function BASS_WADSP_GetModule(plugin: HWADSP): Integer; stdcall; external basswadspdll;
function BASS_WADSP_ChannelSetDSP(plugin: HWADSP; hchan: DWORD; priority: Integer): HDSP; stdcall; external basswadspdll;
function BASS_WADSP_ChannelRemoveDSP(plugin: HWADSP): BOOL; stdcall; external basswadspdll;

function BASS_WADSP_ModifySamplesSTREAM(plugin: HWADSP; buffer: Pointer; length: DWORD): DWORD; stdcall; external basswadspdll;
function BASS_WADSP_ModifySamplesDSP(plugin: HWADSP; buffer: Pointer; length: DWORD): DWORD; stdcall; external basswadspdll;

function BASS_WADSP_GetName(plugin: HWADSP): PAnsiChar; stdcall; external basswadspdll;
function BASS_WADSP_GetModuleCount(plugin: HWADSP): Integer; stdcall; external basswadspdll;
function BASS_WADSP_GetModuleName(plugin: HWADSP; module: Integer): PAnsiChar; stdcall; external basswadspdll;

function BASS_WADSP_PluginInfoFree: BOOL; stdcall; external basswadspdll;
function BASS_WADSP_PluginInfoLoad(dspfile: PChar): BOOL; stdcall; external basswadspdll;
function BASS_WADSP_PluginInfoGetName: PAnsiChar; stdcall; external basswadspdll;
function BASS_WADSP_PluginInfoGetModuleCount: Integer; stdcall; external basswadspdll;
function BASS_WADSP_PluginInfoGetModuleName(module: Integer): PAnsiChar; stdcall; external basswadspdll;

implementation

end.