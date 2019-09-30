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

    Unit TrueAudioFiles

    Get audio information from TrueAudio Files (*.tta)

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

unit TrueAudioFiles;

interface

uses Windows, Messages, SysUtils,  Classes, Apev2Tags, Dialogs;

type

    tta_header = packed record
        ID: array[0..3] of AnsiChar;
        AudioFormat: Word;
        NumChannels: Word;
        BitsPerSample: Word;
        SampleRate: Longword;
        DataLength: Longword;
        CRC32: Longword;
    end;

    TTrueAudioFile = class(TBaseApeFile)
        private
            fHeader: tta_header;
            fAudioFormat: Cardinal;
            fBits: Cardinal;
            fSamples: Cardinal;
            fCRC32: Cardinal;
            procedure fResetData;
        protected
            function ReadAudioDataFromStream(aStream: TStream): Boolean; override;
        public
            property Bits       : Cardinal read fBits;
            property AudioFormat: Cardinal read fAudioFormat;
    end;

implementation

{ TTrueAudioFile }

procedure TTrueAudioFile.fResetData;
begin
    fAudioFormat := 0;
    fBits        := 0;
    fSamples     := 0;
    fCRC32       := 0;

    fSampleRate := 0;
    fChannels   := 0;
    fBitrate    := 0;
    fDuration   := 0;
end;

function TTrueAudioFile.ReadAudioDataFromStream(aStream: TStream): Boolean;
begin
    fResetData;
    Result := False;
    // start looking for chunks
    FillChar(fHeader, SizeOf(fHeader),0);
    aStream.Read(fHeader, SizeOf(fHeader));

    if fHeader.ID = 'TTA1' then
    begin
        fValid := True;
        fAudioFormat := fHeader.AudioFormat;
        fChannels    := fHeader.NumChannels;
        fBits        := fHeader.BitsPerSample;
        fSampleRate  := fHeader.SampleRate;
        fSamples     := fHeader.DataLength;
        FCRC32       := fHeader.CRC32;

        if fSamples > 0 then
            fBitrate := Round(FileSize * 8 * fSampleRate / fSamples)
        else
            fBitrate := 0;

        if fSampleRate > 0 then
            fDuration := Round(fSamples / fSampleRate)
        else
            fDuration := 0;

        Result := True;
    end;
end;

end.
