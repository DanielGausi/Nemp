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

    Unit MonkeyFiles

    Get audio information from Monkeys Audio Files (*.ape)

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

unit MonkeyFiles;

interface

uses Windows, Messages, SysUtils,  Classes, Apev2Tags, Dialogs;

const
    // Compression level codes
    MONKEY_COMPRESSION_FAST       = 1000;   // Fast (poor)
    MONKEY_COMPRESSION_NORMAL     = 2000;   // Normal (good)
    MONKEY_COMPRESSION_HIGH       = 3000;   // High (very good)
    MONKEY_COMPRESSION_EXTRA_HIGH = 4000;   // Extra high (best)
    MONKEY_COMPRESSION_INSANE     = 5000;   // Insane
    MONKEY_COMPRESSION_BRAINDEAD  = 6000;   // BrainDead

    { Compression level names }
    MONKEY_COMPRESSION: array [0..6] of string =
      ('Unknown', 'Fast', 'Normal', 'High', 'Extra High', 'Insane', 'BrainDead');

    // Format flags, only for Monkey's Audio <= 3.97
    MONKEY_FLAG_8_BIT          = 1;    // Audio 8-bit
    MONKEY_FLAG_CRC            = 2;    // New CRC32 error detection
    MONKEY_FLAG_PEAK_LEVEL     = 4;    // Peak level stored
    MONKEY_FLAG_24_BIT         = 8;    // Audio 24-bit
    MONKEY_FLAG_SEEK_ELEMENTS  = 16;   // Number of seek elements stored
    MONKEY_FLAG_WAV_NOT_STORED = 32;   // WAV header not stored

    // Channel mode names
    MONKEY_MODE: array [0..2] of string =
      ('Unknown', 'Mono', 'Stereo');

type

    TMonkeyFile = class(TBaseApeFile)
        private
            fVersion             : Integer;
            fVersionStr          : String;
            fPeakLevel           : LongWord;
            fPeakLevelRatio      : Double;
            fTotalSamples        : Int64;
            fCompressionMode     : Integer;
            fCompressionModeStr  : String;
            // FormatFlags, only used with Monkey's <= 3.97
            fFormatFlags         : Integer;
            fHasPeakLevel        : Boolean;
            fHasSeekElements     : Boolean;
            fWavNotStored        : Boolean;
            fBits                : integer;

            procedure fResetData;
            function fGetVersionStr: String;

        protected
            function ReadAudioDataFromStream(aStream: TStream): Boolean; override;

        public
            property Version           : Integer  read fVersion;
            property VersionStr        : String   read fGetVersionStr;
            property PeakLevel 	       : LongWord	read fPeakLevel;
            property PeakLevelRatio    : Double 	read fPeakLevelRatio;
            property TotalSamples 	   : Int64	  read fTotalSamples;
            property CompressionMode 	 : Integer	read fCompressionMode;
            property CompressionModeStr: String 	read fCompressionModeStr;
            // FormatFlags, only used with Monkey's <= 3.97
            property FormatFlags 	     : Integer	read fFormatFlags;
            property HasPeakLevel 	   : Boolean	read fHasPeakLevel;
            property HasSeekElements 	 : Boolean	read fHasSeekElements;
            property WavNotStored 	   : Boolean	read fWavNotStored;
            property Bits              : Integer read fBits;
    end;


implementation

type
    // Real structure of Monkey's Audio header
    // common header for all versions
    APE_HEADER = packed record
        cID: array[1..4] of AnsiChar;    // should equal 'MAC '
        nVersion : WORD;                 // version number * 1000 (3.81 = 3810)
    end;
    // old header for <= 3.97
    APE_HEADER_OLD = packed record
        nCompressionLevel,               // the compression level
        nFormatFlags,                    // any format flags (for future use)
        nChannels: word;                 // the number of channels (1 or 2)
        nSampleRate,                     // the sample rate (typically 44100)
        nHeaderBytes,                    // the bytes after the MAC header that compose the WAV header
        nTerminatingBytes,               // the bytes after that raw data (for extended info)
        nTotalFrames,                    // the number of frames in the file
        nFinalFrameBlocks: longword;     // the number of samples in the final frame
        nInt : integer;
    end;
    // new header for >= 3.98
    APE_HEADER_NEW = packed record
        nCompressionLevel : word;		    // the compression level (see defines I.E. COMPRESSION_LEVEL_FAST)
        nFormatFlags      : word;		    // any format flags (for future use) Note: NOT the same flags as the old header!
        nBlocksPerFrame   : longword;		// the number of audio blocks in one frame
        nFinalFrameBlocks : longword;		// the number of audio blocks in the final frame
        nTotalFrames      : longword;		// the total number of frames
        nBitsPerSample    : word;		    // the bits per sample (typically 16)
        nChannels         : word;		    // the number of channels (1 or 2)
        nSampleRate       : longword;   // the sample rate (typically 44100)
    end;
    // data descriptor for >= 3.98
    APE_DESCRIPTOR = packed record
        padded : Word;                    // padding/reserved (always empty)
        nDescriptorBytes,		              // the number of descriptor bytes (allows later expansion of this header)
        nHeaderBytes,			                // the number of header APE_HEADER bytes
        nSeekTableBytes,		              // the number of bytes of the seek table
        nHeaderDataBytes,		              // the number of header data bytes (from original file)
        nAPEFrameDataBytes,		            // the number of bytes of APE frame data
        nAPEFrameDataBytesHigh,	          // the high order number of APE frame data bytes
        nTerminatingDataBytes : longword; // the terminating data of the file (not including tag data)
        cFileMD5 : array[0..15] of Byte;  // the MD5 hash of the file (see notes for usage... it's a littly tricky)
    end;

{ TMonkeyFile }



procedure TMonkeyFile.fResetData;
begin
  { Reset data }
	fValid     		      := False;
  fVersion            := 0;
  fVersionStr         := '';
	fBits      		      := 0;
  fPeakLevel          := 0;
  fPeakLevelRatio     := 0.0;
  fTotalSamples       := 0;
	fBitrate  		      := 0;
	fCompressionMode    := 0;
  fCompressionModeStr := '';
  fFormatFlags        := 0;
  fHasPeakLevel       := False;
  fHasSeekElements    := False;
  fWavNotStored       := False;
end;

function TMonkeyFile.fGetVersionStr: String;
var fsub: Integer;
begin
    fSub := fVersion Mod 1000;
    if (fSub mod 10) = 0 then
        fSub := fSub Div 10;
    result := Format('%d.%d', [fVersion Div 1000, fSub]);
end;

function TMonkeyFile.ReadAudioDataFromStream(aStream: TStream): Boolean;
var
   APE            : APE_HEADER;     // common header
   APE_OLD        : APE_HEADER_OLD; // old header   <= 3.97
   APE_NEW        : APE_HEADER_NEW; // new header   >= 3.98
   APE_DESC       : APE_DESCRIPTOR; // extra header >= 3.98
   BlocksPerFrame : integer;
   LoadSuccess    : boolean;
begin
    fResetData;
    LoadSuccess := False;
    result := False;
    // Read APE Format Header
    if (aStream.Read(APE, sizeof(APE)) = sizeof(APE)) and ( APE.cID = 'MAC ') then
    begin
        fVersion := APE.nVersion;
        // Load New Monkey's Audio Header for version >= 3.98
        if APE.nVersion >= 3980 then
        begin
           fillchar(APE_DESC, sizeof(APE_DESC), 0);
           if (aStream.Read(APE_DESC, sizeof(APE_DESC)) = sizeof(APE_DESC)) then
           begin
              // seek past description header
              if APE_DESC.nDescriptorBytes <> 52 then
                  aStream.Seek(APE_DESC.nDescriptorBytes - 52, soCurrent);
              // load new ape_header
              if APE_DESC.nHeaderBytes > sizeof(APE_NEW) then
                  APE_DESC.nHeaderBytes := sizeof(APE_NEW);
              fillchar(APE_NEW, sizeof(APE_NEW), 0);
              if (longword(aStream.Read(APE_NEW, APE_DESC.nHeaderBytes)) = APE_DESC.nHeaderBytes ) then
              begin
                   // based on MAC SDK 3.98a1 (APEinfo.h)
                   fSampleRate       := APE_NEW.nSampleRate;
                   fChannels         := APE_NEW.nChannels;
                   fFormatFlags      := APE_NEW.nFormatFlags;
                   fBits             := APE_NEW.nBitsPerSample;
                   fCompressionMode  := APE_NEW.nCompressionLevel;
                   // calculate total uncompressed samples
                   if APE_NEW.nTotalFrames > 0 then
                      fTotalSamples     := Int64(APE_NEW.nBlocksPerFrame) *
                                           Int64(APE_NEW.nTotalFrames-1) +
                                           Int64(APE_NEW.nFinalFrameBlocks);
                   LoadSuccess := TRUE;
              end;
           end;
        end else
        begin
            // Old Monkey <= 3.97
            fillchar(APE_OLD, sizeof(APE_OLD), 0);
            if (aStream.Read(APE_OLD, sizeof(APE_OLD)) = sizeof(APE_OLD) ) then
            begin
                fCompressionMode  := APE_OLD.nCompressionLevel;
                fSampleRate       := APE_OLD.nSampleRate;
                fChannels         := APE_OLD.nChannels;
                fFormatFlags      := APE_OLD.nFormatFlags;
                fBits := 16;
                if APE_OLD.nFormatFlags and MONKEY_FLAG_8_BIT  <> 0 then
                    fBits :=  8;
                if APE_OLD.nFormatFlags and MONKEY_FLAG_24_BIT <> 0 then
                    fBits := 24;
                fHasSeekElements  := APE_OLD.nFormatFlags and MONKEY_FLAG_PEAK_LEVEL    <>0;
                fWavNotStored     := APE_OLD.nFormatFlags and MONKEY_FLAG_SEEK_ELEMENTS <>0;
                fHasPeakLevel     := APE_OLD.nFormatFlags and MONKEY_FLAG_WAV_NOT_STORED<>0;
                if fHasPeakLevel then
                begin
                     fPeakLevel        := APE_OLD.nInt;
                     fPeakLevelRatio   := (FPeakLevel / (1 shl FBits) / 2.0) * 100.0;
                end;
                // based on MAC_SDK_397 (APEinfo.cpp)
                if (fVersion >= 3950) then
                    BlocksPerFrame := 73728 * 4
                else
                    if (fVersion >= 3900) or ((fVersion >= 3800) and (APE_OLD.nCompressionLevel = MONKEY_COMPRESSION_EXTRA_HIGH)) then
                        BlocksPerFrame := 73728
                    else
                        BlocksPerFrame := 9216;
                // calculate total uncompressed samples
                if APE_OLD.nTotalFrames > 0 then
                    fTotalSamples :=  Int64(APE_OLD.nTotalFrames-1) *
                                      Int64(BlocksPerFrame) +
                                      Int64(APE_OLD.nFinalFrameBlocks);
                LoadSuccess := TRUE;
            end;
        end;
        if LoadSuccess then
        begin
             // compression profile name
             if ((fCompressionMode mod 1000) = 0) and (fCompressionMode<=6000) then
                 fCompressionModeStr := MONKEY_COMPRESSION[fCompressionMode div 1000]
             else
                fCompressionModeStr := IntToStr(fCompressionMode);
             // length
             if fSampleRate > 0 then
                fDuration := Round(fTotalSamples / fSampleRate);
             // average bitrate
             if fTotalSamples > 0 then
                fBitrate := Round((FileSize - Int64(CombinedTagSize)) * 8.0 * fSampleRate / fTotalSamples);
             // some extra sanity checks
             fValid   := (fBits > 0) and (fSampleRate > 0) and (fTotalSamples > 0) and (fChannels > 0);
             Result   := fValid;
        end
    end;
end;


end.

