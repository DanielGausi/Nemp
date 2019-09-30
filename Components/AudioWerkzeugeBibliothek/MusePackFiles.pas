{
    -----------------------------------
    Audio Werkzeuge Bibliothek
    -----------------------------------
    (c) 2012, Daniel Gaussmann
              Website : www.gausi.de
              EMail   : mail@gausi.de
    -----------------------------------
    contains parts of
        Audio Tools Library
        http://mac.sourceforge.net/atl/
        e-mail: macteam@users.sourceforge.net

        Copyright (c) 2000-2002 by Jurgen Faul
        Copyright (c) 2003-2005 by The MAC Team
    -----------------------------------

    Unit MusePack

    Get audio information from MusePack Audio Files (*.mpc)

    ---------------------------------------------------------------------------

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

    ---------------------------------------------------------------------------

    Alternatively, you may use this unit under the terms of the
    MOZILLA PUBLIC LICENSE (MPL):

    The contents of this file are subject to the Mozilla Public License
    Version 1.1 (the "License"); you may not use this file except in
    compliance with the License. You may obtain a copy of the License at
    http://www.mozilla.org/MPL/

    Software distributed under the License is distributed on an "AS IS"
    basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
    License for the specific language governing rights and limitations
    under the License.

    ---------------------------------------------------------------------------
}


unit MusePackFiles;

interface

uses Windows, Messages, SysUtils,  Classes, Apev2Tags, Dialogs;

const

    // Used with ChannelModeID property
    MPP_CM_STEREO = 1;                 // Index for stereo mode
    MPP_CM_JOINT_STEREO = 2;           // Index for joint-stereo mode

    // Channel mode names
    MPP_MODE: array [0..2] of string = ('Unknown', 'Stereo', 'Joint Stereo');

type


    // File header data - for internal use
    HeaderRecord = record
        ByteArray: array [1..32] of Byte;        // Data as byte array
        IntegerArray: array [1..8] of Integer;   // Data as integer array
    end;


    TMusePackFile = class(TBaseApeFile)
        fHeader: HeaderRecord;
        fDataIndex: Integer;

        fValid: Boolean;
        fChannelModeID: Byte;

        fFrameCount: Integer;
        fSampleCount: Int64;
        fStreamVersion: Byte;

        procedure fResetData;
        function fGetChannelMode: string;

        //function fGetBitRate: Word;
        //function fGetDuration: Double;
        function fIsCorrupted: Boolean;
        function fGetRatio: Double;
        function fGetVersionString: String;

        // private methods to get some information from the Header
        function fGetStreamVersion: Byte;
        function fGetChannelModeID: Byte;

        function fGetFrameCount: Integer;  // used up to Version 7
        function fGetSampleCount: Int64; // used in Version 8

    protected

        function fGetChannels: Integer;      override;
        function fGetSamplerate: Integer; override;

        function ReadAudioDataFromStream(aStream: TStream): Boolean; override;

    public
        { Public declarations }

        property ChannelMode: String read fGetChannelMode;
        property ChannelModeID: Byte read fGetChannelModeID;
        property VersionString: String read fGetVersionString;

    end;

implementation

const
    // ID code for stream version 7 and 7.1
    STREAM_VERSION_7_ID = 120279117;        // 120279117 = 'MP+' + #7
    STREAM_VERSION_71_ID = 388714573;       // 388714573 = 'MP+' + #23
    STREAM_VERSION_8_ID = $4B43504D;        // = 'MPCK'

    mpp_samplerates : array[0..3] of integer = ( 44100, 48000, 37800, 32000 );



{ TMusePackFile }

function TMusePackFile.fGetStreamVersion: Byte;
begin
    // Get MPEGplus stream version
    case fHeader.IntegerArray[1] of
        STREAM_VERSION_7_ID : Result := 7;
        STREAM_VERSION_71_ID : Result := 71;
        STREAM_VERSION_8_ID  : Result := 8;
    else
        begin
            case (fHeader.ByteArray[2] mod 32) div 2 of
                3: Result := 4;
                7: Result := 5;
                11: Result := 6
            else
                Result := 0;
            end;
        end;
    end;
end;


function TMusePackFile.fGetFrameCount: Integer;
begin
    // Get frame count
    case fStreamVersion of
        4: Result := fHeader.IntegerArray[2] shr 16;
        5..71: Result := fHeader.IntegerArray[2];
    else
        Result := 0;
    end;
end;

function TMusePackFile.fGetSampleCount: Int64;
var i: Integer;
begin
    // 13:  4 Bytes MPCK
    //     +2 Bytes SH
    //     +1 Byte Size of this packet (assumed, that this is always the case)
    //     +4 Bytes CRC
    //     +1 Byte Version (= 8)
    //--------------------------
    //    12 Bytes before the SampleCount
    i := 13;
    result := fHeader.ByteArray[i] mod 128;
    while (i < 32) and (fHeader.ByteArray[i] >= 128) do
    begin
        inc(i);
        result := result * 128 + (fHeader.ByteArray[i] mod 128);
    end;

    // the i-th byte is the last one for SampleCount
    inc(i); // now the first one of "Beginning Silence"
    while (i < 32) and (fHeader.ByteArray[i] >= 128) do
        inc(i);
    // the next one is the first Byte with "additional useful data"
    if i < 31 then
        fDataIndex := i + 1
    else
        fDataIndex := 1;  // invalid Header
end;

function TMusePackFile.fGetSampleRate: Integer;
var sr: Integer;
begin
   if fStreamVersion = 8 then
        sr := fHeader.ByteArray[fDataIndex] shr 5
   else
        sr := fHeader.ByteArray[11] and 3;

   if sr <= 3 then
      result := mpp_samplerates[sr]
   else
      result := 0; // invalid// unknown
end;

function TMusePackFile.fGetChannelModeID: Byte;
begin
    case fStreamVersion of
        7, 71: begin
            if (fHeader.ByteArray[12] mod 128) < 64 then
                Result := MPP_CM_STEREO
            else
                Result := MPP_CM_JOINT_STEREO
        end;
        8: begin
            if ((fHeader.ByteArray[fDataIndex + 1] shr 3) AND 1) = 1 then
                Result := MPP_CM_JOINT_STEREO
            else
                Result := MPP_CM_STEREO;
        end;
    else
        begin
            // Get channel mode for stream version 4-6
            if (fHeader.ByteArray[3] mod 128) = 0 then
                Result := MPP_CM_STEREO
            else
                Result := MPP_CM_JOINT_STEREO;
        end;
    end;
end;

function TMusePackFile.fGetChannels: Integer;
begin
    if fStreamVersion = 8 then
        result := (fHeader.ByteArray[fDataIndex+1] shr 4) + 1
    else
        result := 2;
end;

function TMusePackFile.fGetChannelMode: string;
begin
    result := MPP_MODE[FChannelModeID];
end;

function TMusePackFile.FGetRatio: Double;
begin
    // Get compression ratio
    if (fValid) and ((fChannelModeID = MPP_CM_STEREO) or (fChannelModeID = MPP_CM_JOINT_STEREO)) then
        Result := FileSize / ((fFrameCount * 1152) * (2 * 16 / 8) + 44) * 100
    else
        Result := 0;
end;

function TMusePackFile.FGetVersionString: String;
begin
    case fStreamVersion of
	      4: Result := '4.0';
        5: Result := '5.0';
	      6: Result := '6.0';
        7: Result := '7.0';
        8: Result := '8.0';
       71: Result := '7.1';
    else
        Result := IntToStr(fStreamVersion);
	  end;
end;

function TMusePackFile.FIsCorrupted: Boolean;
begin
    // Check for file corruption
    Result := (fValid) and ((fBitRate < 3) or (fBitRate > 480));
end;

procedure TMusePackFile.FResetData;
begin
    fValid := false;
    fChannelModeID := 0;
    fFrameCount := 0;
    fStreamVersion := 0;
end;

function TMusePackFile.ReadAudioDataFromStream(aStream: TStream): Boolean;
var
    Transferred: Integer;
    CompressedSize: Int64;
begin
    fResetData;
    Result := True;

    FillChar(fHeader, SizeOf(fHeader), 0);

    // Read header and get file size
    Transferred := aStream.Read(fHeader, 32);

    if Transferred < 32 then
        Result := false
    else
        Move(fHeader.ByteArray, fHeader.IntegerArray, SizeOf(fHeader.ByteArray));

    // Process data if loaded and file valid
    fStreamVersion := fGetStreamVersion;
    if (Result) and (FileSize > 0) and (fStreamVersion > 0) then
    begin
        fValid := true;

        // Fill properties with header data
        // Get SampleCount first!
        // in Version 8 the size of the SampleCount-field has NOT a fixed size
        // in fGetSampleCount this size is determined, which the other methods are using
        if fStreamVersion = 8 then
            fSampleCount   := fGetSampleCount
        else
            fFrameCount    := fGetFrameCount;

        fChannels := fGetChannels;

        fSampleRate    := fGetSampleRate;
        fChannelModeID := fGetChannelModeID;

        // Compute Duration
        if fSampleRate > 0 then
        begin
            if fStreamVersion = 8 then
                fDuration := Round(fSampleCount / fSampleRate)
            else
                fDuration := Round(fFRameCount * 1152 / fSampleRate)
        end
        else
            fDuration := 0;

        // Compute Bitrate
        CompressedSize := FileSize - CombinedTagSize;
        if fDuration > 0 then
            fBitrate := Round(CompressedSize * 8 / fDuration)
        else
            fBitrate := 0;
    end;

end;

end.
