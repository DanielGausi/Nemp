{
  BASSCD 2.4 Delphi unit
  Copyright (c) 2003-2019 Un4seen Developments Ltd.

  See the BASSCD.CHM file for more detailed documentation
}

unit BASSCD;

interface

{$IFDEF MSWINDOWS}
uses BASS, Windows;
{$ELSE}
uses BASS;
{$ENDIF}

const
  // additional error codes returned by BASS_ErrorGetCode
  BASS_ERROR_NOCD       = 12; // no CD in drive
  BASS_ERROR_CDTRACK    = 13; // invalid track number
  BASS_ERROR_NOTAUDIO   = 17; // not an audio track

  // additional BASS_SetConfig options
  BASS_CONFIG_CD_FREEOLD        = $10200;
  BASS_CONFIG_CD_RETRY          = $10201;
  BASS_CONFIG_CD_AUTOSPEED      = $10202;
  BASS_CONFIG_CD_SKIPERROR      = $10203;
  BASS_CONFIG_CD_READ           = $10205;
  BASS_CONFIG_CD_TIMEOUT        = $10206;

  // additional BASS_SetConfigPtr options
  BASS_CONFIG_CD_CDDB_SERVER    = $10204;
  BASS_CONFIG_CD_CDDB_HELLO	    = $10207;

  // BASS_CD_SetInterface options
  BASS_CD_IF_AUTO               = 0;
  BASS_CD_IF_SPTI               = 1;
  BASS_CD_IF_ASPI               = 2;
  BASS_CD_IF_WIO                = 3;
  BASS_CD_IF_LINUX              = 4;

  // "rwflag" read capability flags
  BASS_CD_RWFLAG_READCDR        = 1;
  BASS_CD_RWFLAG_READCDRW       = 2;
  BASS_CD_RWFLAG_READCDRW2      = 4;
  BASS_CD_RWFLAG_READDVD        = 8;
  BASS_CD_RWFLAG_READDVDR       = 16;
  BASS_CD_RWFLAG_READDVDRAM     = 32;
  BASS_CD_RWFLAG_READANALOG     = $10000;
  BASS_CD_RWFLAG_READM2F1       = $100000;
  BASS_CD_RWFLAG_READM2F2       = $200000;
  BASS_CD_RWFLAG_READMULTI      = $400000;
  BASS_CD_RWFLAG_READCDDA       = $1000000;
  BASS_CD_RWFLAG_READCDDASIA    = $2000000;
  BASS_CD_RWFLAG_READSUBCHAN    = $4000000;
  BASS_CD_RWFLAG_READSUBCHANDI  = $8000000;
  BASS_CD_RWFLAG_READC2         = $10000000;
  BASS_CD_RWFLAG_READISRC       = $20000000;
  BASS_CD_RWFLAG_READUPC        = $40000000;

  // additional BASS_CD_StreamCreate/File flags
  BASS_CD_SUBCHANNEL            = $200;
  BASS_CD_SUBCHANNEL_NOHW       = $400;
  BASS_CD_C2ERRORS              = $800;

  // additional CD sync type
  BASS_SYNC_CD_ERROR            = 1000;
  BASS_SYNC_CD_SPEED            = 1002;

  // BASS_CD_Door actions
  BASS_CD_DOOR_CLOSE            = 0;
  BASS_CD_DOOR_OPEN             = 1;
  BASS_CD_DOOR_LOCK             = 2;
  BASS_CD_DOOR_UNLOCK           = 3;

  // BASS_CD_GetID flags
  BASS_CDID_UPC                 = 1;
  BASS_CDID_CDDB                = 2;
  BASS_CDID_CDDB2               = 3;
  BASS_CDID_TEXT                = 4;
  BASS_CDID_CDPLAYER            = 5;
  BASS_CDID_MUSICBRAINZ         = 6;
  BASS_CDID_ISRC                = $100; // + track #
  BASS_CDID_CDDB_QUERY          = $200;
  BASS_CDID_CDDB_READ           = $201; // + entry #
  BASS_CDID_CDDB_READ_CACHE     = $2FF;

  // BASS_CD_GetTOC modes
  BASS_CD_TOC_TIME              = $100;
  BASS_CD_TOC_INDEX             = $200; // + track #

  // BASS_CD_TOC_TRACK "adrcon" flags
  BASS_CD_TOC_CON_PRE           = 1;
  BASS_CD_TOC_CON_COPY          = 2;
  BASS_CD_TOC_CON_DATA          = 4;

  // CDDATAPROC "type" values
  BASS_CD_DATA_SUBCHANNEL       = 0;
  BASS_CD_DATA_C2               = 1;

  BASS_CD_TRACK_PREGAP          = $FFFF;

  // BASS_CHANNELINFO type
  BASS_CTYPE_STREAM_CD          = $10200;

  // BASS_ChannelGetLength/GetPosition/SetPosition mode
  BASS_POS_CD_TRACK             = 4; // track number

type
  BASS_CD_INFO = record
    vendor: PAnsiChar;  // manufacturer
    product: PAnsiChar; // model
    rev: PAnsiChar;     // revision
    letter: Integer;    // drive letter
    rwflags: DWORD;     // read/write capability flags
    canopen: BOOL;      // BASS_CD_DOOR_OPEN/CLOSE is supported?
    canlock: BOOL;      // BASS_CD_DOOR_LOCK/UNLOCK is supported?
    maxspeed: DWORD;    // max read speed (KB/s)
    cache: DWORD;       // cache size (KB)
    cdtext: BOOL;       // can read CD-TEXT
  end;

  // TOC structures
  BASS_CD_TOC_TRACK = record
    res1: Byte;
    adrcon: Byte;       // ADR + control
    track: Byte;        // track number
    res2: Byte;
    case Integer of
      0: (lba: DWORD);   // start address (logical block address)
      1: (hmsf: Array[0..3] of BYTE); // start address (hours/minutes/seconds/frames)
  end;

  BASS_CD_TOC = record
    size: Word;         // size of TOC
    first: Byte;        // first track
    last: Byte;         // last track
    tracks: Array[0..99] of BASS_CD_TOC_TRACK; // up to 100 tracks
  end;

  CDDATAPROC = procedure(handle: HSTREAM; pos: Integer; type_: DWORD; buffer: Pointer; length: DWORD; user: Pointer); {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};
  {
    Sub-channel/C2 reading callback function.
    handle : The CD stream handle
    pos    : The position of the data
    type   : The type of data (BASS_CD_DATA_xxx)
    buffer : Buffer containing the data.
    length : Number of bytes in the buffer
    user   : The 'user' parameter value given when calling BASS_CD_StreamCreate/FileEx
  }


const
{$IFDEF MSWINDOWS}
  basscddll = 'bass\basscd.dll';
{$ENDIF}
{$IFDEF LINUX}
  basscddll = 'libbasscd.so';
{$ENDIF}

function BASS_CD_SetInterface(iface:DWORD): DWORD; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF}; external basscddll;

function BASS_CD_GetInfo(drive:DWORD; var info:BASS_CD_INFO): BOOL; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF}; external basscddll;
function BASS_CD_Door(drive,action:DWORD): BOOL; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF}; external basscddll;
function BASS_CD_DoorIsOpen(drive:DWORD): BOOL; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF}; external basscddll;
function BASS_CD_DoorIsLocked(drive:DWORD): BOOL; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF}; external basscddll;
function BASS_CD_IsReady(drive:DWORD): BOOL; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF}; external basscddll;
function BASS_CD_GetTracks(drive:DWORD): DWORD; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF}; external basscddll;
function BASS_CD_GetTrackLength(drive,track:DWORD): DWORD; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF}; external basscddll;
function BASS_CD_GetTrackPregap(drive,track:DWORD): DWORD; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF}; external basscddll;
function BASS_CD_GetTOC(drive,mode:DWORD; var toc:BASS_CD_TOC): BOOL; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF}; external basscddll;
function BASS_CD_GetID(drive,id:DWORD): PAnsiChar; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF}; external basscddll;
function BASS_CD_GetSpeed(drive:DWORD): DWORD; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF}; external basscddll;
function BASS_CD_SetSpeed(drive,speed:DWORD): BOOL; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF}; external basscddll;
function BASS_CD_SetOffset(drive:DWORD; offset:Integer): BOOL; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF}; external basscddll;
function BASS_CD_Release(drive:DWORD): BOOL; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF}; external basscddll;

function BASS_CD_StreamCreate(drive,track,flags:DWORD): HSTREAM; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF}; external basscddll;
function BASS_CD_StreamCreateFile(f:PChar; flags:DWORD): HSTREAM; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF}; external basscddll;
function BASS_CD_StreamCreateEx(drive,track,flags:DWORD; proc:CDDATAPROC; user:Pointer): HSTREAM; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF}; external basscddll;
function BASS_CD_StreamCreateFileEx(f:PChar; flags:DWORD; proc:CDDATAPROC; user:Pointer): HSTREAM; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF}; external basscddll;
function BASS_CD_StreamGetTrack(handle:HSTREAM): DWORD; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF}; external basscddll;
function BASS_CD_StreamSetTrack(handle:HSTREAM; track:DWORD): BOOL; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF}; external basscddll;

function BASS_CD_Analog_Play(drive,track,pos:DWORD): BOOL; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF}; external basscddll;
function BASS_CD_Analog_PlayFile(f:PAnsiChar; pos:DWORD): DWORD; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF}; external basscddll;
function BASS_CD_Analog_Stop(drive:DWORD): BOOL; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF}; external basscddll;
function BASS_CD_Analog_IsActive(drive:DWORD): DWORD; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF}; external basscddll;
function BASS_CD_Analog_GetPosition(drive:DWORD): DWORD; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF}; external basscddll;

implementation

end.
