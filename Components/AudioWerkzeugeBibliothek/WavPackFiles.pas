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

    Unit WavPackFiles

    Get audio information from WavPack Audio Files (*.ape)

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

unit WavPackFiles;

interface

uses Windows, Messages, SysUtils,  Classes, Apev2Tags, Dialogs;

type
    TWavPackFile = class(TBaseApeFile)
        private
            fFormatTag : integer;
            fVersion   : integer;
            fEncoder   : string;
            fSamples   : Int64;
            fBSamples  : Int64;
            fBits      : integer;

            procedure fResetData;
            function fGetRatio: Double;
            function fGetChannelMode: string;

            function _ReadV3( f: TStream ): boolean;
            function _ReadV4( f: TStream ): boolean;

        protected
            function ReadAudioDataFromStream(aStream: TStream): Boolean; override;

        public
            property FormatTag: integer	read FFormatTag;
            property Version: integer read FVersion;
            property ChannelMode: string read FGetChannelMode;
            property Samples: Int64 read FSamples;
            property BSamples: Int64 read FBSamples;
            property Ratio: Double read FGetRatio;
            property Encoder: string read FEncoder;
            property Bits   : Integer read fBits;
    end;

	  wavpack_header3 = record
        ckID: array[0..3] of AnsiChar;
        ckSize: longword;
        version: word;
        bits: word  ;
        flags: word;
        shift: word;
        total_samples: longword;
        crc: longword;
        crc2: longword;
        extension: array[0..3] of AnsiChar;
        extra_bc: byte;
        extras: array[0..2] of AnsiChar;
    end;

    wavpack_header4 = record
        ckID: array[0..3] of AnsiChar;
        ckSize: longword;
        version: word;
        track_no: byte;
        index_no: byte;
        total_samples: longword;
        block_index: longword;
        block_samples: longword;
        flags: longword;
        crc: longword;
    end;

  	fmt_chunk = record
        wformattag: word;
        wchannels: word;
        dwsamplespersec: longword;
        dwavgbytespersec: longword;
        wblockalign: word;
        wbitspersample: word;
	  end;

  	riff_chunk = record
	    	id: array[0..3] of AnsiChar;
	  	  size: longword;
  	end;

const

    //version 3 flags
    MONO_FLAG_v3	     = 1;	    // not stereo
    FAST_FLAG_v3	     = 2;	    // non-adaptive predictor and stereo mode
    //  RAW_FLAG_v3	       = 4;	    // raw mode (no .wav header)
    //  CALC_NOISE_v3	     = 8;	    // calc noise in lossy mode (no longer stored)
    HIGH_FLAG_v3	     = $10;	  // high quality mode (all modes)
    //  BYTES_3_v3		     = $20;	  // files have 3-byte samples
    //  OVER_20_v3		     = $40;	  // samples are over 20 bits
    WVC_FLAG_v3	       = $80;	  // create/use .wvc (no longer stored)
    //  LOSSY_SHAPE_v3     = $100;  // noise shape (lossy mode only)
    //  VERY_FAST_FLAG_v3	 = $200;  // double fast (no longer stored)
    NEW_HIGH_FLAG_v3	 = $400;  // new high quality mode (lossless only)
    //  CANCEL_EXTREME_v3	 = $800;  // cancel EXTREME_DECORR
    //  CROSS_DECORR_v3	   = $1000; // decorrelate chans (with EXTREME_DECORR flag)
    //  NEW_DECORR_FLAG_v3 = $2000; // new high-mode decorrelator
    //  JOINT_STEREO_v3	   = $4000; // joint stereo (lossy and high lossless)
    EXTREME_DECORR_v3	 = $8000; // extra decorrelation (+ enables other flags)


    sample_rates: array[0..14] of integer = ( 6000, 8000, 9600, 11025, 12000, 16000, 22050,
                                              24000, 32000, 44100, 48000, 64000, 88200, 96000, 192000 );


implementation


procedure TWavPackFile.fResetData;
begin
  	fValid := false;
	  fFormatTag := 0;
  	fBits := 0;
    fVersion := 0;
    fEncoder := '';
    fSamples := 0;
    fBSamples := 0;
end;

function TWavPackFile.ReadAudioDataFromStream(aStream: TStream): Boolean;
var marker: array[0..3] of AnsiChar;
begin
    fResetData;
    //read first bytes
    FillChar(marker, SizeOf(marker), 0);
    aStream.Read(marker, SizeOf(marker));
    aStream.Seek(0, soBeginning);

    if marker = 'RIFF' then
       result := _ReadV3(aStream)
    else
        if marker = 'wvpk' then
            result := _ReadV4(aStream)
        else
            result := False;
end;

function TWavPackFile._ReadV3(f: TStream): boolean;
var chunk: riff_chunk;
    wavchunk: array[0..3] of AnsiChar;
    fmt: fmt_chunk;
    hasfmt: boolean;
    fpos: int64;
    wvh3: wavpack_header3;
begin
    result := false;
    hasfmt := false;

    // read and evaluate header
    FillChar( chunk, sizeof(chunk), 0 );
    if (f.Read(chunk, sizeof(chunk)) <> SizeOf( chunk )) or
       (f.Read(wavchunk, sizeof(wavchunk)) <> SizeOf(wavchunk)) or (wavchunk <> 'WAVE')
    then
        exit;

    // start looking for chunks
    FillChar( chunk, SizeOf(chunk), 0 );
    while (f.Position < f.Size) do
    begin
         if (f.read(chunk, sizeof(chunk)) < sizeof(chunk)) or (chunk.size <= 0) then
            break;

         fpos := f.Position;
         if chunk.id = 'fmt ' then // Format chunk found read it
         begin
            if (chunk.size >= sizeof(fmt)) and (f.Read(fmt, sizeof(fmt)) = sizeof(fmt)) then
            begin
                  hasfmt := true;
                  result := True;
                  fValid := true;
                  fFormatTag := fmt.wformattag;
                  fChannels := fmt.wchannels;
                  fSampleRate := fmt.dwsamplespersec;
                  fBits := fmt.wbitspersample;
                  fBitrate := Round(fmt.dwavgbytespersec / 125.0); // 125 = 1/8*1000
            end
            else
                break;
         end else
            if (chunk.id = 'data') and hasfmt then
            begin
                FillChar( wvh3, SizeOf(wvh3) ,0);
                f.Read( wvh3, SizeOf(wvh3) );
                if wvh3.ckID = 'wvpk' then  // wavpack header found
                begin
                    result := true;
                    fValid := true;
                    fVersion := wvh3.version;
                    fChannels := 2 - (wvh3.flags and 1);  // mono flag
                    fSamples := wvh3.total_samples;

                    // Encoder guess
                    if wvh3.bits > 0 then
                    begin
                        if (wvh3.flags and NEW_HIGH_FLAG_v3) > 0 then
                        begin
                            fEncoder := 'hybrid';
                            if (wvh3.flags and WVC_FLAG_v3) > 0 then
                                fEncoder := fEncoder + ' lossless'
                            else
                                fEncoder := fEncoder + ' lossy';

                            if (wvh3.flags and EXTREME_DECORR_v3) > 0 then
                                fEncoder := fEncoder + ' (high)';
                        end
                        else
                            if (wvh3.flags and (HIGH_FLAG_v3 or FAST_FLAG_v3)) = 0 then
                                fEncoder := IntToStr( wvh3.bits + 3 ) + '-bit lossy'
                            else
                            begin
                                fEncoder := IntToStr( wvh3.bits + 3 ) + '-bit lossy';
                                if (wvh3.flags and HIGH_FLAG_v3) > 0 then
                                    fEncoder := fEncoder + ' high'
                                else
                                    fEncoder := fEncoder + ' fast';
                            end;
                    end else
                    begin
                        if (wvh3.flags and HIGH_FLAG_v3) = 0 then
                            fEncoder := 'lossless (fast mode)'
                        else
                            if (wvh3.flags and EXTREME_DECORR_v3) > 0 then
                                fEncoder := 'lossless (high mode)'
                            else
                                fEncoder := 'lossless';
                    end;

                    if fSampleRate <= 0 then
                        fSampleRate := 44100;

                    fDuration := Round(wvh3.total_samples / fSampleRate);
                    if fDuration > 0 then
                        fBitrate := Round(8.0*(FileSize  - int64(CombinedTagSize)  - int64(wvh3.ckSize)) / fDuration);
                end;
                break;
            end
            else  // not a wv file
                break;

         f.seek( fpos + chunk.size, soBeginning );
    end; // while
end;

function TWavPackFile._ReadV4(f: TStream): boolean;
var wvh4: wavpack_header4;
    EncBuf : array[1..4096] of Byte;
    tempo : Integer;
    encoderbyte: Byte;
begin
    result := false;
    FillChar( wvh4, SizeOf(wvh4) ,0);
    f.Read( wvh4, SizeOf(wvh4) );
    if wvh4.ckID = 'wvpk' then // wavpack header found
    begin
        Result := true;
        fValid := true;
        fVersion := wvh4.version shr 8;
        fChannels := 2 - (wvh4.flags and 4);  // mono flag

        fBits := ((wvh4.flags and 3) * 16);   // bytes stored flag
        fSamples := wvh4.total_samples;
        fBSamples := wvh4.block_samples;
        fSampleRate := (wvh4.flags and ($1F shl 23)) shr 23;
        if (fSampleRate > 14) or (fSampleRate < 0) then
            fSampleRate := 44100
        else
            fSampleRate := sample_rates[fSampleRate];

        if ((wvh4.flags and 8) = 8) then // hybrid flag
            fEncoder := 'hybrid lossy'
        else
            fEncoder := 'lossless';

        FDuration := Round(wvh4.total_samples / fSampleRate);
        if fSamples > 0 then
            FBitrate := Round((FileSize - int64(CombinedTagSize) ) * 8 * fSampleRate / fSamples) ;

        FillChar(EncBuf, SizeOf(EncBuf), 0);
        f.Read(EncBuf, SizeOf(EncBuf));
        for tempo := 1 to 4094 do
        begin
            if (EncBuf[tempo] = $65) and
               (EncBuf[tempo + 1] = $02) then
            begin
                encoderbyte := EncBuf[tempo + 2];
                if encoderbyte = 8 then
                    fEncoder := fEncoder + ' (high)'
                else
                    if encoderbyte = 0 then
                        fEncoder := fEncoder + ' (normal)'
                    else
                        if encoderbyte = 2 then
                            fEncoder := fEncoder + ' (fast)'
                        else
                            if encoderbyte = 6 then
                                fEncoder := fEncoder + ' (very fast)';
                Break;
            end;
        end;
    end;
end;

function TWavPackFile.fGetChannelMode: string;
begin
    case fChannels of
         1: result := 'Mono';
         2: result := 'Stereo';
    else
        result := 'Surround';
    end;
end;

function TWavPackFile.fGetRatio: Double;
begin
    // Get compression ratio
    if fValid then
        Result := FileSize / (fSamples * (fChannels * fBits / 8) + 44) * 100
    else
        Result := 0;
end;

end.
