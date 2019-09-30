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

    Unit OptimFrogFiles

    Get audio information from OptimFrog Audio Files (*.ofr)

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

unit OptimFrogFiles;

interface

uses Windows, Messages, SysUtils,  Classes, Apev2Tags, Dialogs;

const
    OFR_COMPRESSION: array [0..9] of String = ('fast', 'normal', 'high', 'extra',
        'best', 'ultra', 'insane', 'highnew', 'extranew', 'bestnew');

    OFR_BITS: array [0..10] of ShortInt = (8, 8, 16, 16, 24, 24, 32, 32,
        -32, -32, -32); //negative value corresponds to floating point type.

    OFR_CHANNELMODE: array [0..1] of String = ('Mono', 'Stereo');

type
    TOfrHeader = packed record
        ID: array [1..4] of AnsiChar;    // Always 'OFR '
        Size: Cardinal;
        Length: Cardinal;
        HiLength: Word;
        SampleType, ChannelMode: Byte;
        SampleRate: Integer;
        EncoderID: Word;
        CompressionID: Byte;
    end;


    TOptimFrogFile = class(TBaseApeFile)
        private
            fHeader: TOfrHeader;
            procedure fResetData;
            function fGetSamples: Int64;

            function fGetVersion: string;
            function fGetCompression: string;
            function fGetBits: ShortInt;

        protected
            function ReadAudioDataFromStream(aStream: TStream): Boolean; override;

        public
            property Version    : String read fGetVersion;
            property Compression: String read fGetCompression;
            property Bits       : ShortInt read fGetBits;
    end;

implementation

{ OptimFrogFile }

function TOptimFrogFile.fGetSamples: Int64;
var Res: array [0..1] of Cardinal absolute Result;
begin
    // Get number of samples
    Res[0] := fHeader.Length shr fHeader.ChannelMode;
    Res[1] := fHeader.HiLength shr fHeader.ChannelMode;
end;

function TOptimFrogFile.fGetVersion: string;
begin
    // Get encoder version
    result := Format('%5.3f', [((fHeader.EncoderID shr 4) + 4500) / 1000]);
end;


function TOptimFrogFile.fGetCompression: string;
var c: Byte;
begin
  // Get compression level
  c := fHeader.CompressionID shr 3;
  if c in [0..9] then
      result := OFR_COMPRESSION[c]
  else
      result := 'unknown';
end;

function TOptimFrogFile.FGetBits: ShortInt;
begin
    // Get number of bits per sample
    if FHeader.SampleType in [0..10] then
        result := OFR_BITS[fHeader.SampleType]
    else
        result := 0;
end;


procedure TOptimFrogFile.fResetData;
begin
    // Reset data
    fValid := False;
    fSampleRate := 0;
    fChannels := 0;
    fDuration := 0;
    fBitrate := 0;
end;

function TOptimFrogFile.ReadAudioDataFromStream(aStream: TStream): Boolean;
var SampleCount: Int64;
begin
    fResetData;
    aStream.Read(fHeader, SizeOf(fHeader));

    fValid := (fHeader.ID = 'OFR ')
          and (fHeader.SampleRate > 0)
          and (fHeader.SampleType in [0..10])
          and (fHeader.ChannelMode in [0..1])
          and (fHeader.CompressionID shr 3 in [0..9]);
    result := fValid;

    if fValid then
    begin
        fSampleRate := fHeader.SampleRate;
        fChannels := fHeader.ChannelMode + 1;
        SampleCount := fGetSamples;
        // Get duration
        if fSampleRate > 0 then
            fDuration := Round(SampleCount / fSampleRate)
        else
            fDuration := 0;
        if SampleCount > 0 then
            fBitrate := Round(FileSize * 8.0 * fSampleRate / SampleCount)
        else
            fBitrate := 0;
    end;
end;

end.
