{
    -----------------------------------
    Audio Werkzeuge Bibliothek
    -----------------------------------
    (c) 2010-2024, Daniel Gaussmann
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

    Unit OpusFiles

    Manipulate *.opus files

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

unit OpusFiles;

interface

uses
  Windows, Messages, SysUtils, Variants, ContNrs, Classes,  Dialogs,
  VorbisComments, ID3Basics, OggContainer,
  AudioFiles.Base, AudioFiles.Declarations, BaseVorbisFiles;

type

    TOpusIdentification = packed record
        ID: array [1..8] of AnsiChar; // always "OpusHead"
        Version: Byte;                // Version, always 1
        ChannelCount: Byte;           // Number of Output Channels
        PreSkip: Word;
        InputSampleRate: Cardinal;    // Original Samplerate
        OutputGain: SmallInt;
        MappingFamily: Byte;
    end;

    TOpusIdentificationPacket = class(TOggPacket)
      private
        fOpusIdentification: TOpusIdentification;
        procedure StreamDataToRecord;
      public
    end;

    TOpusAudioPacket = class(TOggPacket)
      private
        fConfiguration: Byte;
        function GetBitrateX3: Integer;
        procedure ParseConfiguration;
      public

    end;

    TOpusCommentPacket = class(TOggPacket)
      private
        fComments: TVorbisComments;
        procedure StreamDataToRecord;

      public
        constructor Create;
        destructor Destroy; override;
        procedure Clear; override;
    end;

    {
    MainClass for tagging .opus-Files
    }
    TOpusFile = class(TBaseVorbisFile)
        private
            fMaxSamples: Integer;
            fVBR: Boolean;

            fUsePadding: Boolean;
            fDefaultPadding: Integer;
            fMaxPadding: Integer;

            fIdentificationHeader: TOpusIdentificationPacket;
            fCommentHeader: TOpusCommentPacket;

            procedure SetMaxPadding(Value: Integer);
            procedure SetDefaultPadding(Value: Integer);

            function ReadIdentificationHeader(aContainer: TOggContainer; Target: TOpusIdentificationPacket): TAudioError;
            function ReadCommentHeader(aContainer: TOggContainer; Target: TOpusCommentPacket): TAudioError;

            // DetectVBR: Read a few AudioPackets to decide CBR/VBR
            function DetectVBR(aContainer: TOggContainer): Boolean;

        protected
            function GetVorbisComments: TVorbisComments; override;
            function fGetDuration   : Integer;  override;
            function fGetBitrate    : Integer;  override;
            function fGetFileType            : TAudioFileType; override;
            function fGetFileTypeDescription : String;         override;

        public
            property Samples: Integer read fMaxSamples;
            property VBR: Boolean read fVBR;
            property UsePadding: Boolean read fUsePadding write fUsePadding;
            property DefaultPadding: Integer read fDefaultPadding write SetDefaultPadding;
            property MaxPadding: Integer read fMaxPadding write SetMaxPadding;

            constructor Create; override;
            destructor Destroy; override;

            procedure ClearData;
            function ReadFromFile(aFilename: UnicodeString): TAudioError; override;
            function WriteToFile(aFilename: UnicodeString): TAudioError; override;
            function RemoveFromFile(aFilename: UnicodeString): TAudioError; override;
    end;


implementation


{ TOggVorbisFile }

constructor TOpusFile.Create;
begin
    fIdentificationHeader := TOpusIdentificationPacket.Create;
    fCommentHeader := TOpusCommentPacket.Create;
    fMaxPadding := 25500;
    fDefaultPadding := 2550;
    fUsePadding := True;
    ClearData;
end;

destructor TOpusFile.Destroy;
begin
    fIdentificationHeader.Free;
    fCommentHeader.Free;
    inherited;
end;

function TOpusFile.fGetFileType: TAudioFileType;
begin
    result := at_Opus;
end;

function TOpusFile.fGetFileTypeDescription: String;
begin
    result := cAudioFileType[at_Opus];
end;

procedure TOpusFile.ClearData;
begin
    fFileSize       := 0;
    fMaxSamples     := 0;
    fSampleRate     := 0;
    fValid          := False;
    fChannels       := 0;
    fVBR := True;
    fIdentificationHeader.Clear;
    fCommentHeader.Clear;
end;

function TOpusFile.GetVorbisComments: TVorbisComments;
begin
  result := fCommentHeader.fComments;
end;

procedure TOpusFile.SetMaxPadding(Value: Integer);
begin
  if Value >= 0 then
    fMaxPadding := Value;
  if fMaxPadding > 250*255 then
    fMaxPadding := 250*255;
end;

procedure TOpusFile.SetDefaultPadding(Value: Integer);
begin
  if Value >= 0 then
    fDefaultPadding := Value;
  if fDefaultPadding > 250*255 then
    fDefaultPadding := 250*255;
end;

function TOpusFile.fGetDuration: Integer;
begin
  // Calculate duration time
  // for Opus: Use always 48000 as SampleRate here
  if fMaxSamples > 0 then
    Result := Round(fMaxSamples / 48000)
  else
    Result := 0;
end;

function TOpusFile.fGetBitrate: Integer;
begin
  // Calculate average bit rate
  if Duration > 0 then
    result := Round((fFileSize - fCommentHeader.Data.Size) * 8  / Duration)
  else
    result := 0;
end;

function TOpusFile.ReadIdentificationHeader(aContainer: TOggContainer; Target: TOpusIdentificationPacket): TAudioError;
begin
  result := aContainer.ReadPacket(Target);

  if result = FileErr_None then begin
    if not Target.FinishesPage then
      result := OVErr_InvalidHeader;
  end;

  if result = FileErr_None then begin
    Target.StreamDataToRecord;

    if not ( (Target.fOpusIdentification.ID = 'OpusHead')
         and (Target.fOpusIdentification.Version = 1)
         and (Target.fOpusIdentification.ChannelCount <> 0))
    then
      result := OVErr_InvalidHeader;
  end;
end;

function TOpusFile.ReadCommentHeader(aContainer: TOggContainer; Target: TOpusCommentPacket): TAudioError;
begin
  result := aContainer.ReadPacket(Target);

  if result = FileErr_None then begin
    if not Target.FinishesPage then
      result := OVErr_InvalidHeader;
  end;

  if result = FileErr_None then begin
    Target.StreamDataToRecord;
    if not Target.fComments.ValidComment then
      result := OVErr_InvalidComment;
  end;
end;

function TOpusFile.DetectVBR(aContainer: TOggContainer): Boolean;
var
  FirstAudioPacket, OtherAudioPacket: TOpusAudioPacket;
  err: TAudioError;

  function SameBitrate(first, other: TOpusAudioPacket): Boolean;
  begin
    if (first.fConfiguration = other.fConfiguration) then begin
      result := first.Data.Size = other.Data.size;
    end else begin
      result := (first.GetBitrateX3 = other.GetBitrateX3) and (other.GetBitrateX3 <> High(Integer));
    end;
  end;

begin
  FirstAudioPacket := TOpusAudioPacket.Create;
  OtherAudioPacket := TOpusAudioPacket.Create;
  try
    result := False; // well, probably not. Opus is designed to use VBR. ;-)

    err := aContainer.ReadPacket(FirstAudioPacket);
    if err = FileErr_None then
      FirstAudioPacket.ParseConfiguration;

    while (err = FileErr_None) do begin
      OtherAudioPacket.Clear;
      err := aContainer.ReadPacket(OtherAudioPacket);
      if err = FileErr_None then begin
        OtherAudioPacket.ParseConfiguration;
        if not SameBitrate(FirstAudioPacket, OtherAudioPacket) then begin
          result := True;
          break;
        end;
      end;
    end;

  finally
    OtherAudioPacket.Free;
    FirstAudioPacket.Free;
  end;
end;

function TOpusFile.ReadFromFile(aFilename: UnicodeString): TAudioError;
var fs: TAudioFileStream;
    OggContainer: TOggContainer;
begin
    inherited ReadFromFile(aFilename);
    ClearData;
    if AudioFileExists(aFilename) then
    begin
        try
            fs := TAudioFileStream.Create(aFileName, fmOpenRead or fmShareDenyWrite);
            try
                OggContainer := TOggContainer.Create(fs);
                try
                    fFileSize := fs.Size;

                    result := ReadIdentificationHeader(OggContainer, fIdentificationHeader);
                    if result = FileErr_None then
                      result := ReadCommentHeader(OggContainer, fCommentHeader);

                    // set some private variables from these headers
                    if result = FileErr_None then
                    begin
                        fVBR := DetectVBR(OggContainer); // analyse stream for cbr/vbr
                        fSampleRate := fIdentificationHeader.fOpusIdentification.InputSamplerate;
                        fChannels   := fIdentificationHeader.fOpusIdentification.ChannelCount;

                        // get number of samples in the File
                        // "GetMaxSample" searches from the end of the file and is usually faster.
                        // However, parsing the complete OggContainer may be safer.
                        fMaxSamples := GetMaxSample(fs) - fIdentificationHeader.fOpusIdentification.Preskip;
                        if fMaxSamples <= 0 then
                          fMaxSamples := OggContainer.GetMaxGranulePosition(0) - fIdentificationHeader.fOpusIdentification.Preskip;
                        if fMaxSamples < 0 then
                          fMaxSamples := 0;
                        fValid := True;
                    end else
                        fValid := False;
                finally
                    OggContainer.Free;
                end;
            finally
                fs.Free;
            end;
        except
            result := FileErr_FileOpenR;
        end;
    end else
        result := FileErr_NoFile;
end;

function TOpusFile.WriteToFile(aFilename: UnicodeString): TAudioError;
var fs: TAudioFileStream;
    existingContainer: TOggContainer;
    existingIDHdr: TOpusIdentificationPacket;
    existingCommentHdr: TOpusCommentPacket;
    backupFilename: String;

    function CacheAudioData: TAudioError;
    var
      CacheStream: TAudioFileStream;
    begin
      result := FileErr_None;
      CacheStream := TAudioFileStream.Create(backupFilename, fmCreate);
      try
        try
          existingContainer.CopyRemainsTo(CacheStream)
        finally
          CacheStream.Free;
        end;
      except
        result := FileErr_BackupFailed;
      end;
    end;

    function RestoreCacheAudioData: TAudioError;
    var
      CacheStream: TAudioFileStream;
    begin
      result := FileErr_None;
      CacheStream := TAudioFileStream.Create(backupFilename, fmOpenRead);
      try
        try
          existingContainer.CopyRemainsFrom(CacheStream, True);
        finally
          CacheStream.Free;
        end;
      except
        result := FileErr_BackupFailed;
      end;
    end;

begin
  inherited WriteToFile(aFilename);

  result := FileErr_NoFile;
  if AudioFileExists(aFilename) then begin
    try
      fs := TAudioFileStream.Create(aFilename, fmOpenReadWrite or fmShareDenyWrite);
      try
        existingContainer := TOggContainer.Create(fs);
        existingIDHdr := TOpusIdentificationPacket.Create;
        existingCommentHdr := TOpusCommentPacket.Create;
        try
            fCommentHeader.Data.Clear;
            fCommentHeader.fComments.WriteToStream(fCommentHeader.Data);

            result := ReadIdentificationHeader(existingContainer, existingIDHdr);
            if result = FileErr_None then begin
              // Store the SerialNumber of the first Page, it may be needed later
              existingContainer.KeepSerial;
              // try to replace the CommentHeader
              // allow max. "100 LacingValues" (~ a half OggPage)
              if not existingContainer.ReplacePacket(fCommentHeader, MaxPadding) then
              begin
                // if a quick replacement of the Comment Header fails, we have to rewrite the whole file
                if fUsePadding then
                  AddZeroPadding(fCommentHeader.Data, DefaultPadding); // add "10 LacingValue", 2550 Bytes of padding
                if result = FileErr_None then
                  result := ReadCommentHeader(existingContainer, existingCommentHdr);
                if result = FileErr_None then begin
                  backupFilename := GetBackupFilename(aFilename);
                  result := CacheAudioData;
                end;

                // now we can rewrite the file
                if result = FileErr_None then begin
                  existingContainer.Reset; // The serial number will stay the same!
                  // Write the 3 Header Packets
                  existingContainer.WritePacket(existingIDHdr, True);
                  existingContainer.WritePacket(fCommentHeader, True);
                  // Write the Audio Data
                  RestoreCacheAudioData;  // this will also renumber the pages, if necessary
                  existingContainer.SetEndOfStream;
                  //delete backupfile
                  if not DeleteFile(backupFilename) then
                    result := FileErr_DeleteBackupFailed;
                end;
              end;
            end;

        finally
          existingContainer.Free;
          existingIDHdr.Free;
          existingCommentHdr.Free;
        end;

      finally
        fs.Free;
      end;
    except
      result := FileErr_FileOpenRW;
    end;
  end;
end;

function TOpusFile.RemoveFromFile(aFilename: UnicodeString): TAudioError;
begin
    inherited RemoveFromFile(aFilename);
    result := TagErr_RemovingNotSupported;
end;


{ TOggIdentificationPacket }

procedure TOpusIdentificationPacket.StreamDataToRecord;
begin
  Data.Position := 0;
  Data.Read(fOpusIdentification, SizeOf(fOpusIdentification));
end;

{ TOpusAudioPacket }

function TOpusAudioPacket.GetBitrateX3: Integer;
var
  f: Integer;
  fFrameCount: Byte;
begin
  {
    From the OPUS Documentation,
    https://datatracker.ietf.org/doc/html/rfc6716#section-3.1

     0 1 2 3 4 5 6 7
    +-+-+-+-+-+-+-+-+
    | config  |s| c |
    +-+-+-+-+-+-+-+-+

    +----------------+-------------------+
    | Configuration  | Frame Sizes       |  Factor to get to 3sec
    | Number(s)      |                   |
    +----------------+-------------------+
    | 0...3          | 10, 20, 40, 60 ms |   300, 150, 75, 50
    | 4...7          | 10, 20, 40, 60 ms |   300, 150, 75, 50
    | 8...11         | 10, 20, 40, 60 ms |   300, 150, 75, 50
    | 12...13        | 10, 20 ms         |   300, 150
    | 14...15        | 10, 20 ms         |   300, 150,
    | 16...19        | 2.5, 5, 10, 20 ms |  1200, 600, 300, 150
    | 20...23        | 2.5, 5, 10, 20 ms |  1200, 600, 300, 150
    | 24...27        | 2.5, 5, 10, 20 ms |  1200, 600, 300, 150
    | 28...31        | 2.5, 5, 10, 20 ms |  1200, 600, 300, 150
    +----------------+-------------------+

    Value of s (doesn't matter here)
      0: mono
      1: sterao

    Value of c
      0: 1 frame in the packet
      1: 2 frames in the packet, each with equal compressed size
      2: 2 frames in the packet, with different compressed sizes
      3: an arbitrary number of frames in the packet
  }
  case (fConfiguration shr 3) of
    // 2.5ms
    16,20,24,28: f := 1200;
    // 5ms
    17,21,25,29: f := 600;
    // 10ms
    0,4,8,
    12,14,
    18,22,26,30: f := 300; // 10ms * 300 = 3000
    // 20ms
    1,5,9,
    13,15,
    19,23,27,31: f := 150;
    // 40ms
    2,6,10: f := 75;
    // 60ms
    3,7,11: f := 50
  else
    f := 0; // invalid
  end;

  // Note: we are not actually calculating the Bitrate in every case.
  // If the result from here is "High(Integer)", we consider the file as "VBR"

  case (fConfiguration and 3) of // last 2 bits
    0: result := Data.Size * 8 * f; // 1 Frame in the Packet
    1: result := Data.Size * 4 * f; // 2 Frames in the Packet, same Compressed Sizes
    2: result := High(Integer);     // 2 Frames, different Compresse Sizes (we assume, that they're really different)
    3: begin
        // multiple Frames
        // | config  |s|1|1|v|p|     M     |  Padding length (Optional)
        Data.Position := 1;
        Data.Read(fFrameCount, SizeOf(fFrameCount));
        if ((fFrameCount shr 7) and 1) = 1 then // the first bit indicates VBR
          result := High(Integer)
        else begin
          fFrameCount := fFrameCount and $3F; // actual FrameCount in the last 6 Bits
          if fFrameCount <> 0 then
            result := (Data.Size * 8 * f) Div fFrameCount
          else
            result := High(Integer);
        end;
    end;
  else
    result := High(Integer);
  end;
end;

procedure TOpusAudioPacket.ParseConfiguration;
begin
  Data.Position := 0;
  Data.Read(fConfiguration, SizeOf(fConfiguration));
end;

{ TVorbisCommentPacket }

procedure TOpusCommentPacket.Clear;
begin
  inherited;
  fComments.Clear;
end;

constructor TOpusCommentPacket.Create;
begin
  inherited Create;
  fComments := TVorbisComments.Create;
  fComments.ContainerType := octOpus;
end;

destructor TOpusCommentPacket.Destroy;
begin
  fComments.Free;
  inherited;
end;

procedure TOpusCommentPacket.StreamDataToRecord;
begin
  Data.Position := 0;
  fComments.ReadFromStream(Data, Data.Size);
end;


end.
