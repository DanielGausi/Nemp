{
    -----------------------------------
    Audio Werkzeuge Bibliothek
    -----------------------------------
    (c) 2012, Daniel Gaussmann
              Website : www.gausi.de
              EMail   : mail@gausi.de
    -----------------------------------

    Unit M4AAtoms

    Manipulate m4a-Files (as used by iTunes)
    - Parse Atoms of the file

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
unit M4aAtoms;

{$I config.inc}

interface

uses Windows, Messages, SysUtils, StrUtils, Variants, ContNrs, Classes,
     AudioFileBasics {$IFDEF USE_SYSTEM_TYPES}, System.Types{$ENDIF};


type
    TBuffer = Array of byte;
    TAtomName = Array[1..4] of AnsiChar;
    TM4APicTypes = (M4A_JPG=13, M4A_PNG, M4A_Invalid);

    TMetaAtomDescription = record
        AtomName: TAtomName;
        Description: String;
    end;

const
    // Known Atoms with text-data
    KnownMetaAtoms : Array[0..26] of TMetaAtomDescription =
      ((AtomName: '©nam'; Description: 'Name'),
       (AtomName: '©ART'; Description: 'Artist'),
       (AtomName: 'aART'; Description: 'Album Artist'),
       (AtomName: '©alb'; Description: 'Album'),
       (AtomName: '©grp'; Description: 'Grouping'),
       (AtomName: '©wrt'; Description: 'Composer'),
       (AtomName: '©cmt'; Description: 'Comment'),
       (AtomName: '©gen'; Description: 'Genre (User defined)'),
       (AtomName: '©day'; Description: 'Release Date'),
       (AtomName: 'tvsh'; Description: 'TV Show Name'),
       (AtomName: 'tven'; Description: 'TV Episode ID'),
       (AtomName: 'tvnn'; Description: 'TV Network'),
       (AtomName: 'desc'; Description: 'Description'),
       (AtomName: 'ldes'; Description: 'Long Description'),
       (AtomName: '©lyr'; Description: 'Lyrics'),
       (AtomName: 'sonm'; Description: 'Sort Name'),
       (AtomName: 'soar'; Description: 'Sort Artist'),
       (AtomName: 'soal'; Description: 'Sort Album'),
       (AtomName: 'soco'; Description: 'Sort Composer'),
       (AtomName: 'sosn'; Description: 'Sort Show'),
       (AtomName: 'cprt'; Description: 'Copyright'),
       (AtomName: '©too'; Description: 'Encoding Tool'),
       (AtomName: '©enc'; Description: 'Encoded by'),
       (AtomName: 'purd'; Description: 'Purchase Date'),
       (AtomName: 'keyw'; Description: 'Keywords'),
       (AtomName: 'catg'; Description: 'Category'),
       (AtomName: 'apID'; Description: 'Purchase Account') );

type

    TBaseAtom = class
        private
            fName: TAtomName;
            fData: TMemoryStream;

            function fGetSize: DWord;
        public
            property Name: TAtomName read fName;
            property Size: DWord read fGetSize;

            constructor Create(aName: TAtomName); virtual;
            destructor Destroy; override;

            procedure Clear; virtual;

            function ReadFromStream(aStream: TStream; aSize: DWord): Integer;
            function SaveToStream(aStream: TStream): Int64;
    end;

    TFreeAtom = class(TBaseAtom)
        constructor CreateFree(aName: TAtomName; aSize: DWord);

    end;


    // TRAK contains Information about the Track, as Duration, Bitrate, ...
    // Also contains (as a subsubsub...-Atom the STCO-Atom, which MUST be modified, if
    // the length of metadata changed (offsets)
    TTrakAtom = class(TBaseAtom)
        private
            fBitrate    : Integer;
            fSamplerate : Integer;
            fChannels   : Integer;
            fDuration   : Integer;
            fValid      : Boolean;

            // Position of the stco-Atom within the fData-Stream
            fOffsetPosition: DWord;
            // Number of Offsets (all of them may have to change after writing metadata)
            fOffsetCount: DWord;
            // Position where AudioData begins
            fAudioOffset: DWord;

            // interesting sub(sub...)atoms of the trak-Atom which needs deeper looks
            function Parse1_MDIA(aSize: DWord): TAudioError;
            function Parse2_MDHD(aSize: DWord): TAudioError; // SubAtom of MDIA (contains duration (?))
            function Parse3_MINF(aSize: DWord): TAudioError; // SubAtom of MDIA (contains subatoms)
            function Parse4_STBL(aSize: DWord): TAudioError; // Subatom of MINF (contains subatoms)
            function Parse5_STSD(aSize: DWord): TAudioError; // Subatom of STBL (contains channels, samplerate)
            function Parse6_STCO(aSize: DWord): TAudioError; // Subatom of STBL (contains Offsets, need to be changed eventually)

        public
            procedure Clear; override;
            function ParseData: TAudioError;
    end;

    TTrackDisc = (meta_Track, meta_Disc);

    // TMetaATOM is one of the meta-atoms in udta.meta.ilst
    // (something like the "Frames" within the ID3v2-Tag)
    TMetaAtom = class(TBaseAtom)
        private
            procedure prepareDiskTrackAtom(l: TTrackDisc; aValue: UnicodeString);
            procedure WriteHeader(aSize: DWord);
        public
            function GetTextData: UnicodeString;
            function GetTrackNumber: UnicodeString;
            function GetGenre: UnicodeString;
            function GetDiscNumber: UnicodeString;

            procedure SetTextData(aValue: UnicodeString);
            procedure SetTrackNumber(aValue: UnicodeString);
            procedure SetStandardGenre(idx: Integer);
            procedure SetDiscNumber(aValue: UnicodeString);

            // Cover art
            function GetPictureStream(Dest: TStream; var typ: TM4APicTypes): Boolean;
            procedure SetPicture(Source: TStream; typ: TM4APicTypes);

            // parse "----" atoms
            function GetSpecialData(out aMean, aName: AnsiString): UnicodeString;
            procedure SetSpecialData(aMean, aName: AnsiString; aValue: UnicodeString);

            // for displaying all Text-Atoms
            function ContainsTextData: Boolean;
            function GetListDescription: UnicodeString;
    end;

    // UDTA contains the Metadata (artist, title, album, ...)
    TUdtaAtom = class(TBaseAtom)
        private
            fMetaAtoms: TObjectList;

            function fSearchAtom(aName: TAtomName): TMetaAtom;
            function fSearchSpecialAtom(mean, name: AnsiString; out Value: UnicodeString): TMetaAtom;


            procedure fAddDefaultMetaData; // fill fData with default data, in case there ist no udta in the file

        public

            constructor Create(aName: TAtomName); override;
            destructor Destroy; override;

            function ParseData: TAudioError;

            function GetTextData(aName: TAtomName): UnicodeString;
            function GetTrackNumber: UnicodeString;
            function GetGenre: UnicodeString;
            function GetDiscNumber: UnicodeString;

            procedure SetTextData(aName: TAtomName; aValue: UnicodeString);
            procedure SetTrackNumber(aValue: UnicodeString);
            procedure SetGenre(aValue: UnicodeString);
            procedure SetDiscNumber(aValue: UnicodeString);

            function GetPictureStream(Dest: TStream; var typ: TM4APicTypes): Boolean;
            procedure SetPicture(Source: TStream; typ: TM4APicTypes);

            // Spaecial data:
            // Atom with the following structure
            // ----  (atom)
            //    mean  (subatom)
            //    name  (subatom)
            //    data  (subatom)
            // used by iTunes for some data, and can be used e.g. for ratings (as "mp3tag" does it)
            function GetSpecialData(aMean, aName: AnsiString): UnicodeString;
            procedure SetSpecialData(aMean, aName: AnsiString; aValue: UnicodeString);

            procedure GetAllTextAtomDescriptions(dest: TStrings);
            procedure GetAllTextAtoms(dest: TObjectList);

            procedure GetAllAtoms(dest: TObjectList);
            procedure RemoveAtom(aAtom: TMetaAtom);

            function PrepareDataForSaving: TAudioError;
    end;


    // Contains some sub-Atoms, which will be parsed seperately
    //   - The TRAK, with duration, samplerate
    //   - The UDTA.META, witrh the actual metadata like title, artist, ...
    TMoovAtom = class(TBaseAtom)
        private
            fDuration   : Integer;
            fSamplerate : Integer;
            fChannels   : Integer;
            fAudioDataOffset : DWord;  // From the trak.mdia.minf.stbl.stco-Atom, relative to the beginning of the file)

            fStcoOffset: DWord; // Position of the stco-Atom
                                // relative to the beginning of the MOOV-Tag (i.e. 8 bytes before fData starts in the file)

        public
            AtomList: TObjectList;
            TrakAtom: TTrakAtom;
            UdtaAtom: TUdtaAtom;

            property Duration   : Integer read fDuration  ;
            property Samplerate : Integer read fSamplerate;
            property Channels   : Integer read fChannels  ;
            property AudioDataOffset: DWord read fAudioDataOffset;
            property StcoOffset: Dword read fStcoOffset;

            constructor Create(aName: TAtomName); override;
            destructor Destroy; override;

            procedure Clear; Override;
            function ParseData: TAudioError;
            function WriteToStreamWithNewUDTA(dest: TStream; newUDTA: TUdtaAtom): TAudioError;

    end;


    function ChangeEndian32(X: DWORD): DWORD; register;
    function ChangeEndian16(X: WORD): WORD;
    function GetNextAtomInfo(aStream: TStream; out Name: TAtomName; out Size: DWord): TAudioError;


implementation


uses ID3GenreList;


function GetNextAtomInfo(aStream: TStream; out Name: TAtomName; out Size: DWord): TAudioError;
begin
    aStream.Read(Size, 4);
    Size := ChangeEndian32(Size);
    aStream.Read(Name[1], 4);

    if Size < 8 then
        result := M4AErr_64BitNotSupported
    else
        result := FileErr_None;
end;


function ChangeEndian32(X: DWORD): DWORD; register;
asm
  bswap EAX //convert Endian
end;

function ChangeEndian16(X: WORD): WORD;
begin
  result := swap(X); //convert Endian
end;

{ TBaseAtom }
constructor TBaseAtom.Create(aName: TAtomName);
begin
    fName := aName;
    fData := TMemoryStream.Create;
end;

destructor TBaseAtom.Destroy;
begin
    fData.Free;
    inherited;
end;

procedure TBaseAtom.Clear;
begin
    fData.Clear;
end;


function TBaseAtom.fGetSize: DWord;
begin
    result := fData.Size + 8;
end;

// Copy the data from the File into the local fData-Stream
function TBaseAtom.ReadFromStream(aStream: TStream; aSize: DWord): Integer;
begin
    Clear;
    result := fData.CopyFrom(aStream, aSize-8)
end;

// Save the Atom into another Stream
function TBaseAtom.SaveToStream(aStream: TStream): Int64;
var c: DWord;
begin
    c := ChangeEndian32(DWord(fData.Size) + 8);
    result := aStream.Write(c, 4);
    result := result + aStream.Write(Name[1], 4);
    result := result + aStream.CopyFrom(fData, 0);
end;


{ TFreeAtom }

constructor TFreeAtom.CreateFree(aName: TAtomName; aSize: DWord);
var buf: TBuffer;
begin
    inherited create(aName);
    fData.SetSize(aSize - 8);

    setlength(buf, aSize - 8);
    FillChar(buf[0], aSize - 8, 0);
    fData.Write(buf[0], aSize - 8);
end;



{ TTrakAtom }

procedure TTrakAtom.Clear;
begin
    inherited clear;
    fDuration   := 0;
    fBitrate    := 0;
    fSamplerate := 0;
    fChannels   := 0;
    fValid      := False;

    fOffsetPosition := 0;
    fOffsetCount := 0;
end;


// Parse TRAK
// Interesting atoms:
//    - trak.mdia.mdhd            Duration,             read only
//    - trak.mdia.minf.stbl.stsd  Channels, Samplerate, read only
//    - trak.mdia.minf.stbl.stco  AudioOffsets          read /write
function TTrakAtom.ParseData: TAudioError;
var bytesProcessed: DWord;
    newName: TAtomName;
    newSize: DWord;
begin
    result := FileErr_None;

    bytesProcessed := 0;
    fData.Position := 0;
    while (bytesProcessed < fData.Size) and (result = FileErr_None) do
    begin
        GetNextAtomInfo(fData, newName, newSize);
        if newName = 'mdia' then
            result := Parse1_MDIA(newSize)
        else
            fData.Seek(newSize-8, soCurrent);

        // inc(bytesProcessed, newSize);
        if newSize > 0 then
            inc(bytesProcessed, newSize)
        else
        begin
            bytesProcessed := fData.Size;
            result := M4aErr_Invalid_TRAK;
        end;
    end;
end;

// Parse MDIA
function TTrakAtom.Parse1_MDIA(aSize: DWord): TAudioError;
var bytesProcessed: DWord;
    newName: TAtomName;
    newSize: DWord;
    tmp: TAudioError;
begin
    result := FileErr_None;

    bytesProcessed := 8;
    while (bytesProcessed < aSize) do
    begin
        tmp := FileErr_None;
        GetNextAtomInfo(fData, newName, newSize);

        if newName = 'mdhd' then
            tmp := Parse2_MDHD(newSize)
        else
            if newName = 'minf' then
                tmp := Parse3_MINF(newSize)
            else
                fData.Seek(newSize-8, soCurrent);

        if tmp <> FileErr_None then
            result := tmp;

        // inc(bytesProcessed, newSize);
        if newSize > 0 then
            inc(bytesProcessed, newSize)
        else
        begin
            bytesProcessed := fData.Size;
            result := M4aErr_Invalid_MDIA;
        end;
    end;
end;

// Parse MDHD, Get Duration
function TTrakAtom.Parse2_MDHD(aSize: DWord): TAudioError;
var Version: Byte;
    TrackLength, TimeScale: DWord;
begin
    result := FileErr_None;

    fData.Read(Version, 1);
    if Version > 1 then    // 0: 32bit fields, 1: 64bit
    begin
        result := M4aErr_Invalid_MDHD;
        fData.Seek(aSize-9, soCurrent); // skip rest of the MDHD-Atom
    end else
    begin
        fData.Seek(3, soCurrent); // 3 Byte Flags, ignore
        fData.Seek(2* (Version + 1) * 4, soCurrent); // 2x Timestamps, each 32 Bit at Version 0, 64Bit at Version 1

        fData.Read(TimeScale, 4);
        TimeScale := ChangeEndian32(TimeScale);
        
        if Version = 0 then
        begin
            fData.Read(TrackLength, 4);
            TrackLength := ChangeEndian32(TrackLength);
            fDuration := trunc(TrackLength / TimeScale);
        end else
        begin
            fData.Seek(8, soCurrent);
            // Point of Failure: Incorrect Duration, but that should never happen...
            fDuration := High(Integer);
        end;
        fData.Seek(4, soCurrent); // skip rest of the MDHD-Atom
    end;
end;

// Parse MINF
function TTrakAtom.Parse3_MINF(aSize: DWord): TAudioError;
var bytesProcessed: DWord;
    newName: TAtomName;
    newSize: DWord;
begin
    result := FileErr_None;

    bytesProcessed := 8;
    while bytesProcessed < aSize do
    begin
        GetNextAtomInfo(fData, newName, newSize);
        if newName = 'stbl' then
            result := Parse4_STBL(newSize)
        else
            fData.Seek(newSize-8, soCurrent);

        //inc(bytesProcessed, newSize);
        if newSize > 0 then
            inc(bytesProcessed, newSize)
        else
        begin
            bytesProcessed := fData.Size;
            result := M4aErr_Invalid_MINF;
        end;
    end;
end;

// Parse STBL
function TTrakAtom.Parse4_STBL(aSize: DWord): TAudioError;
var bytesProcessed: DWord;
    newName: TAtomName;
    newSize: DWord;
    tmp: TAudioError;
begin
    result := FileErr_None;

    bytesProcessed := 8;
    while bytesProcessed < aSize do
    begin
        tmp := FileErr_None;
        GetNextAtomInfo(fData, newName, newSize);
        if newName = 'stsd' then
            tmp := Parse5_STSD(newsize)
        else
            if newName = 'stco' then
                tmp := Parse6_STCO(newSize)
            else
                fData.Seek(newSize-8, soCurrent);

        if tmp <> FileErr_None then
            result := tmp;

        if newSize > 0 then
            inc(bytesProcessed, newSize)
        else
        begin
            bytesProcessed := aSize;
            result := M4aErr_Invalid_STBL;
        end;

    end;
end;

// ParseSTSD , get Channels, Samplerate
function TTrakAtom.Parse5_STSD(aSize: DWord): TAudioError;
var Version: Byte;
    Channels, Bits: Word;
    AudioSamplerate: Word; // ?? Some sources say 16, others 32 Bit
begin
    result := FileErr_None;

    //fData.Seek(aSize-8, soFromCurrent);                                            // processed Bytes so far
                                                                                     // 8
    fData.Read(Version, 1);                                                          // 9
    if Version <> 0 then    // 0: 32bit fields, 1: 64bit
    begin
        result := M4aErr_Invalid_STSD;
        fData.Seek(aSize-9, soCurrent); // skip rest of the MDHD-Atom           // (complete)
    end else
    begin
        fData.Seek(   3  // {Version,} Flags
                    + 4  // Number of Descriptions
                    + 8 // Header af mp4a-Atom
                    + 16 // some stuff I dont need here                             // 40
            , soCurrent);
        fData.Read(Channels, 2);                                                    // 42
        Channels := ChangeEndian16(Channels);
        fChannels := Channels;

        fData.Read(Bits, 2);                                                        // 44
        Bits := ChangeEndian16(Bits);
        fData.Seek(4, soCurrent);                                               // 48
        fData.Read(AudioSamplerate, 2);
        fData.Seek(2, soCurrent); // seek another 2 bytes                       // 52
        AudioSamplerate := ChangeEndian16(AudioSamplerate);
        fSamplerate := AudioSamplerate;

        fData.Seek(aSize - 52, soCurrent);
    end;
end;

// Parse STCO, Get AudioOffsets
function TTrakAtom.Parse6_STCO(aSize: DWord): TAudioError;
var Version: Byte;
begin
    result := FileErr_None;

    fData.Read(Version, 1);
    if Version <> 0 then    // 0: 32bit fields, 1: 64bit
    begin
        result := M4aErr_Invalid_STCO;
        fData.Seek(aSize-9, soCurrent); // skip rest of the MDHD-Atom
    end else
    begin
        fOffsetPosition := fData.Position - 1 ;
        /// NOTE: At this position:
        ///  4 Bytes Version/Flags
        ///  4 Bytes Offset Count : X
        ///  X times 4 Bytes Offset Values

        fData.Seek(3, soCurrent); // skip Flags
        fData.Read(fOffsetCount, 4);
        fOffsetCount := ChangeEndian32(fOffsetCount);

        if fOffsetCount > 0 then
        begin
            fData.Read(fAudioOffset, 4);
            fAudioOffset := ChangeEndian32(fAudioOffset);

            fData.Seek(aSize-20, soCurrent);
        end else
            fData.Seek(aSize-16, soCurrent);
    end;
end;


{ TMoovAtom }

constructor TMoovAtom.Create(aName: TAtomName);
begin
    inherited;
    UdtaAtom := TUdtaAtom.Create('udta');
    TrakAtom := TTrakAtom.Create('trak');
    AtomList := TObjectList.Create(True);
    // Do not add them to the Atomlist here!
    // AtomList.Add(TrakAtom);
    // AtomList.Add(UdtaAtom);
end;


destructor TMoovAtom.Destroy;
begin
    AtomList.Extract(UdtaAtom);
    AtomList.Extract(TrakAtom);
    UdtaAtom.Free;
    TrakAtom.Free;

    AtomList.Clear;
    AtomList.Free;
    inherited;
end;


procedure TMoovAtom.Clear;
begin
    AtomList.Extract(UdtaAtom);
    AtomList.Extract(TrakAtom);
    UdtaAtom.Free;
    TrakAtom.Free;
    AtomList.Clear;

    fDuration   := 0;
    fSamplerate := 0;
    fChannels   := 0;

    UdtaAtom := TUdtaAtom.Create('udta');
    TrakAtom := TTrakAtom.Create('trak');

    inherited Clear;
end;


// Parse the moov-Atom
// Expected subatoms are
// - mvhd (a few bytes, no interesting data)
// - trak (many sub-atoms on several level, contains duration, samplerate, ...)
// - udta (contains a meta-atom, which contains sub-atoms with meta-data like artist, title, ...)
function TMoovAtom.ParseData: TAudioError;
var bytesProcessed: DWord;
    newName: TAtomName;
    newSize: DWord;
    TrakOffset: Dword;
    newAtom: TBaseAtom;
    tmp: TAudioError;
    trakFound, udtaFound: Boolean;
begin
    result := FileErr_None;

    bytesProcessed := 0;
    fData.Position := 0;

    trakFound := False;
    udtaFound := False;

    while bytesProcessed < fData.Size do
    begin
        GetNextAtomInfo(fData, newName, newSize);
        if newName = 'trak' then
        begin
            if trakFound then
            begin
                result := M4aErr_Invalid_DuplicateTRAK;
                newAtom := TBaseAtom.Create(newName);
                newAtom.ReadFromStream(fData, newSize);
                AtomList.Add(newAtom);
            end
            else
            begin
                trakFound := True;
                TrakOffset := fData.Position - 8;
                TrakAtom.ReadFromStream(fData, newSize);
                AtomList.Add(TrakAtom);

                // The Trak-Atom needs to be parsed
                // most of the data here is readonly, but not all (offsets in the stco-Atom)
                tmp := TrakAtom.ParseData;
                if tmp = FileErr_None then
                begin
                    // fill private fields with data from TRAK
                    fDuration   := TrakAtom.fDuration;
                    fSamplerate := TrakAtom.fSamplerate;
                    fChannels   := TrakAtom.fChannels;
                    fAudioDataOffset := TrakAtom.fAudioOffset;

                    fStcoOffset := TrakAtom.fOffsetPosition + TrakOffset;
                end else
                    // some error occured
                    result := tmp;
            end;
        end else
            if newName = 'udta' then
            begin
                if udtaFound then
                begin
                    result := M4aErr_Invalid_DuplicateUDTA;
                    newAtom := TBaseAtom.Create(newName);
                    newAtom.ReadFromStream(fData, newSize);
                    AtomList.Add(newAtom);
                end
                else
                begin
                    udtaFound := True;
                    UdtaAtom.ReadFromStream(fData, newSize);
                    AtomList.Add(UdtaAtom);
                    tmp := UdtaAtom.ParseData;
                    if tmp <> FileErr_None then
                        result := tmp;
                end;
            end else
            begin
                // other atom, probably mvhd
               newAtom := TBaseAtom.Create(newName);
               newAtom.ReadFromStream(fData, newSize);
               AtomList.Add(newAtom);
            end;

        //inc(bytesProcessed, newSize);
        if newSize > 0 then
            inc(bytesProcessed, newSize)
        else
        begin
            bytesProcessed := fData.Size;
            result := M4aErr_Invalid_MOOV;
        end;


    end;

    if not assigned(UdtaAtom) then
    begin
        UdtaAtom := TUdtaAtom.Create('udta');
        UdtaAtom.fAddDefaultMetaData;
        AtomList.Add(UdtaAtom);
    end;
end;


function TMoovAtom.WriteToStreamWithNewUDTA(dest: TStream;
  newUDTA: TUdtaAtom): TAudioError;
var c: DWord;
    SizeOffset: Int64;
    i: Integer;
    bytesWritten: Int64;
begin
    result := FileErr_None;
    SizeOffset := dest.Size; // we need to change the size later

    c := ChangeEndian32(DWord(fData.Size) + 8);
    dest.Write(c, 4);
    dest.Write(Name[1], 4);

    bytesWritten := 8;

    for i := 0 to AtomList.Count - 1 do
    begin
        if TBaseAtom(AtomList[i]).Name = 'udta' then
            bytesWritten := bytesWritten + newUDTA.SaveToStream(dest)
        else
        begin
            if TBaseAtom(AtomList[i]).Name = 'trak' then
            begin
                // this ist, what where we need to change data later
                fStcoOffset := TTrakAtom(AtomList[i]).fOffsetPosition + bytesWritten;
                bytesWritten := bytesWritten + TTrakAtom(AtomList[i]).SaveToStream(dest);
            end else
                bytesWritten := bytesWritten + TBaseAtom(AtomList[i]).SaveToStream(dest)
        end;
    end;

    // write correct size into the Stream
    dest.Position := SizeOffset;
    c := DWord(bytesWritten);
    c := ChangeEndian32(c);
    dest.Write(c, 4);

    dest.Seek(0, soEnd);
end;

{ TUdtaAtom }

constructor TUdtaAtom.Create(aName: TAtomName);
begin
    inherited Create(aName);
    fMetaAtoms := TObjectList.Create(True);
end;

destructor TUdtaAtom.Destroy;
begin
    fMetaAtoms.Free;
    inherited;
end;

function TUdtaAtom.fSearchAtom(aName: TAtomName): TMetaAtom;
var i: Integer;
begin
    result := Nil;
    for i := 0 to fMetaAtoms.Count -1 do
        if AnsiLowercase(UnicodeString(TMetaAtom(fMetaAtoms[i]).Name)) = AnsiLowercase(UnicodeString(aName)) then
        begin
            result := TMetaAtom(fMetaAtoms[i]);
            break;
        end;
end;

function TUdtaAtom.fSearchSpecialAtom(mean, name: AnsiString; out Value: UnicodeString): TMetaAtom;
var i: Integer;
    FoundMean, FoundName: AnsiString;
begin
    result := Nil;
    Value := '';
    for i := 0 to fMetaAtoms.Count - 1 do
    begin
        if TMetaAtom(fMetaAtoms[i]).Name = '----' then
        begin
            Value := TMetaAtom(fMetaAtoms[i]).GetSpecialData(FoundMean, FoundName);
            if (FoundMean = mean) and (FoundName = name) then
            begin
                result := TMetaAtom(fMetaAtoms[i]);
                break;
            end;
        end;
    end;
end;

procedure TUdtaAtom.fAddDefaultMetaData;
var c: Dword;
    a: AnsiString;
    b: Byte;
begin
    c := ChangeEndian32(53);
    fData.Write(c, 4);     // size of META
    a := 'meta';
    fData.Write(a[1], 4);  // name of META
    c := 0;
    fData.Write(c, 4); // flags/version of META

    // default hdlr-subatom   (I dont know what this is, but it seems to be in every meta-tag)
    c := ChangeEndian32(33);
    fData.Write(c, 4);     // size of HDLR
    a := 'hdlr';
    fData.Write(a[1], 4);  // name of HDLR
    c := 0;
    fData.Write(c, 4); // ???
    fData.Write(c, 4); // ???
    a := 'mdirappl';
    fData.Write(a[1], 8); // ???
    fData.Write(c, 4); // ???
    fData.Write(c, 4); // ???
    b := 0;
    fData.Write(b, 1); // ???

    // ILST
    c := ChangeEndian32(8);
    fData.Write(c, 4);    // size of ILST
    a := 'ilst';
    fData.Write(a[1], 4);  // name of ILST
end;


function TUdtaAtom.GetGenre: UnicodeString;
var aAtom: TMetaAtom;
begin
    result := GetTextData('©gen'); // user defined Genres
    if result = '' then
    begin
        aAtom := fSearchAtom('gnre');   // standardized Genres as in ID3
        if assigned(aAtom) then
            result := aAtom.GetGenre
    end;
end;


function TUdtaAtom.GetTextData(aName: TAtomName): UnicodeString;
var aAtom: TMetaAtom;
begin
    aAtom := fSearchAtom(aName);
    if assigned(aAtom) then
        result := aAtom.GetTextData
    else
        result := '';
end;

function TUdtaAtom.GetTrackNumber: UnicodeString;
var aAtom: TMetaAtom;
begin
    aAtom := fSearchAtom('trkn');
    if assigned(aAtom) then
        result := aAtom.GetTrackNumber
    else
        result := '';
end;

function TUdtaAtom.GetDiscNumber: UnicodeString;
var aAtom: TMetaAtom;
begin
    aAtom := fSearchAtom('disk');
    if assigned(aAtom) then
        result := aAtom.GetDiscNumber
    else
        result := '';
end;

function TUdtaAtom.GetPictureStream(Dest: TStream; var typ: TM4APicTypes): Boolean;
var aAtom: TMetaAtom;
begin
    aAtom := fSearchAtom('covr');
    if assigned(aAtom) then
        result := aAtom.GetPictureStream(Dest, typ)
    else
        result := False;
end;

function TUdtaAtom.GetSpecialData(aMean, aName: AnsiString): UnicodeString;
var aAtom: TMetaAtom;
    FoundValue: UnicodeString;
begin
    result := '';
    aAtom := fSearchSpecialAtom(aMean, aName, FoundValue);
    if assigned(aAtom) then
        result := FoundValue
    else
        result := '';
end;

procedure TUdtaAtom.SetTextData(aName: TAtomName; aValue: UnicodeString);
var aAtom: TMetaAtom;
begin
    aAtom := fSearchAtom(aName);
    if assigned(aAtom) then
    begin
        if aValue = '' then
            self.fMetaAtoms.Remove(aAtom)
        else
            aAtom.SetTextData(aValue);
    end
    else
    begin
        if aValue <> '' then
        begin
            aAtom := TMetaAtom.Create(aName);
            fMetaAtoms.Add(aAtom);
            aAtom.SetTextData(aValue);
        end;
    end;
end;

procedure TUdtaAtom.SetTrackNumber(aValue: UnicodeString);
var aAtom: TMetaAtom;
begin
    aAtom := fSearchAtom('trkn');
    if assigned(aAtom) then
    begin
        if aValue = '' then
            fMetaAtoms.Remove(aAtom)
        else
            aAtom.SetTrackNumber(aValue)
    end
    else
    begin
        if aValue <> '' then
        begin
            aAtom := TMetaAtom.Create('trkn');
            fMetaAtoms.Add(aAtom);
            aAtom.SetTrackNumber(aValue);
        end;
    end;
end;

procedure TUdtaAtom.SetDiscNumber(aValue: UnicodeString);
var aAtom: TMetaAtom;
begin
    aAtom := fSearchAtom('disk');
    if assigned(aAtom) then
    begin
        if aValue = '' then
            fMetaAtoms.Remove(aAtom)
        else
            aAtom.SetDiscNumber(aValue)
    end
    else
    begin
        if aValue <> '' then
        begin
            aAtom := TMetaAtom.Create('disk');
            fMetaAtoms.Add(aAtom);
            aAtom.SetDiscNumber(aValue);
        end;
    end;
end;

procedure TUdtaAtom.SetGenre(aValue: UnicodeString);
var aAtom: TMetaAtom;
    IsStandard: Boolean;
    idx: Integer;
begin
    idx := ID3Genres.IndexOf(aValue);
    IsStandard := idx >= 0;

    if IsStandard then
    begin
        // Standard Genre
        // update gnre and ©gen
        SetTextData('©gen', aValue); // userdefined

        aAtom := fSearchAtom('gnre');
        if assigned(aAtom) then
        begin
            if aValue = '' then
                fmetaAtoms.Remove(aAtom)
            else
                aAtom.SetStandardGenre(idx);
        end
        else
        begin
            if aValue <> '' then
            begin
                aAtom := TMetaAtom.Create('gnre');
                fMetaAtoms.Add(aAtom);
                aAtom.SetStandardGenre(idx);
            end;
        end;
    end else
    begin
        // Not a Standard Genre
        // update ©gen, delete gnre
        SetTextData('©gen', aValue); // userdefined
        // delete gnre (consistent data)
        aAtom := fSearchAtom('gnre');
        if assigned(aAtom) then
            fMetaAtoms.Remove(aAtom);
    end;
end;


procedure TUdtaAtom.SetPicture(Source: TStream; typ: TM4APicTypes);
var aAtom: TMetaAtom;
begin
    aAtom := fSearchAtom('covr');
    if assigned(aAtom) then
    begin
        if assigned(Source) and (typ <> M4A_Invalid) then
            aAtom.SetPicture(Source, typ)
        else
            fMetaAtoms.Remove(aAtom)
    end else
    begin
        if assigned(Source) and (typ <> M4A_Invalid) then
        begin
            aAtom := TMetaAtom.Create('covr');
            fMetaAtoms.Add(aAtom);
            aAtom.SetPicture(Source, typ);
        end;
    end;
end;

procedure TUdtaAtom.SetSpecialData(aMean, aName: AnsiString; aValue: UnicodeString);
var aAtom: TMetaAtom;
    FoundValue: UnicodeString;
begin
    aAtom := fSearchSpecialAtom(aMean, aName, FoundValue);
    if assigned(aAtom) then
    begin
          if aValue <> '' then
              aAtom.SetSpecialData(aMean, aName, aValue)
          else
              fMetaAtoms.Remove(aAtom)
    end else
    begin
        if aValue <> '' then
        begin
            aAtom := TMetaAtom.Create('----');
            fMetaAtoms.Add(aAtom);
            aAtom.SetSpecialData(aMean, aName, aValue)
        end;
    end;
end;


procedure TUdtaAtom.GetAllTextAtomDescriptions(dest: TStrings);
var i: Integer;
begin
    dest.Clear;
    for i := 0 to self.fMetaAtoms.Count - 1 do
        if TMetaAtom(fMetaAtoms[i]).ContainsTextData then
            dest.Add(TMetaAtom(fMetaAtoms[i]).GetListDescription);
end;

procedure TUdtaAtom.GetAllTextAtoms(dest: TObjectList);
var i: Integer;
begin
    dest.Clear;
    for i := 0 to self.fMetaAtoms.Count - 1 do
        if TMetaAtom(fMetaAtoms[i]).ContainsTextData then
            dest.Add(TMetaAtom(fMetaAtoms[i]));
end;

procedure TUdtaAtom.GetAllAtoms(dest: TObjectList);
var i: Integer;
begin
    dest.Clear;
    for i := 0 to self.fMetaAtoms.Count - 1 do
        dest.Add(TMetaAtom(fMetaAtoms[i]));
end;

procedure TUdtaAtom.RemoveAtom(aAtom: TMetaAtom);
begin
    fMetaAtoms.Remove(aAtom);
end;



function TUdtaAtom.ParseData: TAudioError;
var bytesProcessed, IlstProcessed, MetaProcessed: DWord;
    newName: TAtomName;
    newSize, MetaSize, IlstSize: DWord;
    newAtom: TMetaAtom;
    Version: Byte;
    metaFound: Boolean;
begin
    bytesProcessed := 0;
    fData.Position := 0;

    result := FileErr_None;

    metaFound := False;
    while bytesProcessed < fData.Size do
    begin
        GetNextAtomInfo(fData, newName, newSize);
        inc(bytesProcessed, 8);
        if newName = 'meta' then
        begin
            metaFound := True;
            fData.Read(Version, 1);
            if Version <> 0 then
            begin
                result := M4aErr_Invalid_METAVersion;
                exit;
            end;
            fData.Seek(3, soCurrent); // skip Flags
            inc(bytesProcessed, 4);

            // meta ok, parse it
            MetaProcessed := 12;
            MetaSize := newSize;
            while MetaProcessed < MetaSize do
            begin
                GetNextAtomInfo(fData, newName, newSize);
                inc(bytesProcessed, 8);
                inc(MetaProcessed, 8);

                if newName = 'ilst' then
                begin
                    // Get all MetaAtoms from the ilst-Atom
                    IlstSize := newSize;
                    IlstProcessed := 8;
                    while IlstProcessed < IlstSize do
                    begin
                        GetNextAtomInfo(fData, newName, newSize);
                        newAtom := TMetaAtom.Create(newName);
                        newAtom.ReadFromStream(fData, newSize);
                        fMetaAtoms.Add(newAtom);

                        if newSize > 0 then
                            inc(IlstProcessed, newSize)
                        else
                        begin
                            IlstProcessed := IlstSize;
                            result := M4aErr_Invalid_UDTA;
                        end;
                    end;
                    if IlstProcessed > 0 then
                    begin
                        inc(bytesProcessed, IlstProcessed);
                        inc(MetaProcessed, IlstProcessed);
                    end else
                    begin
                        bytesProcessed := fData.Size;
                        MetaProcessed := MetaSize;
                        result := M4aErr_Invalid_UDTA;
                    end;
                end else
                begin
                    // some other atom, skip it
                    // probably "hdlr" or "free"
                    if newSize > 8 then
                    begin
                        fData.Seek(newSize-8, soCurrent);  // skip this atom
                        inc(bytesProcessed, newSize-8);
                        inc(MetaProcessed, newSize-8);
                    end else
                    begin
                        bytesProcessed := fData.Size;
                        MetaProcessed := MetaSize;
                        result := M4aErr_Invalid_UDTA;
                    end;
                end;
            end; // parsing ILST
        end // parse META
        else
        begin
            // other udta.[..]-atom
            // probably FREE-Atom
            if newSize > 8 then
            begin
                fData.Seek(newSize-8, soCurrent);
                inc(bytesProcessed, newSize-8);
            end else
            begin
                bytesProcessed := fData.Size;
                result := M4aErr_Invalid_UDTA;
            end;
        end;
    end;

    if not metaFound then
        // there was no META-Tag: create one
        // (we NEED an meta-aom within the data-stream)
        fAddDefaultMetaData;
end;

function TUdtaAtom.PrepareDataForSaving: TAudioError;
var newStream: TMemoryStream;
    bytesProcessed, MetaProcessed: DWord;

    newName: TAtomName;
    newSize, MetaSize, c, newIlstSize, newMetaSize: DWord;
    newAtom: TMetaAtom;
    VersionFlags: DWord;
    MetaSizeOffset, IlstSizeOffset: Int64;
    ILSTwritten: Boolean;

          procedure WriteILST;
          var i: Integer;
          begin
              IlstSizeOffset := newStream.Size;
              // write size and name of ILST
              c := ChangeEndian32(newSize);
              newStream.Write(c, 4);
              newStream.Write(newName[1], 4);
              // Write all the little Atoms containing new Meta-data
              for i := 0 to fMetaAtoms.Count - 1 do
                  TMetaAtom(fMetaAtoms[i]).SaveToStream(newStream);
              // Compute correct Size of ILST
              newIlstSize := newStream.Size - IlstSizeOffset;
              newIlstSize := ChangeEndian32(newIlstSize);
          end;

begin
    ILSTwritten := False;
    MetaSizeOffset := 0;

    newStream := TMemoryStream.Create;
    try
        bytesProcessed := 0;
        fData.Position := 0;
        result := FileErr_None;

        while bytesProcessed < fData.Size do
        begin
            GetNextAtomInfo(fData, newName, newSize);
            inc(bytesProcessed, 8);
            if newName = 'free' then
            begin
                // just skip, we write only ONE free-Atom into the file
                // (on Top Level)
                fData.Seek(newSize-8, soCurrent);
                inc(bytesProcessed, newSize-8);
            end else
                if newName = 'meta' then
                begin
                    // Note: We ALWAYS have meta in the stream!
                    // Next thing to write is the META-Size.
                    // but this has to be changed later, so: store the current position
                    MetaSizeOffset := newStream.Size;

                    // write size and name of META
                        c := ChangeEndian32(newSize);
                        newStream.Write(c, 4);
                        newStream.Write(newName[1], 4);

                    // copy Flags and version to newStream
                        fData.Read(VersionFlags, 4);
                        inc(bytesProcessed, 4);
                        // first Byte of this must be 0, as Delphi reads LittleEndian, we have
                        if (VersionFlags Mod 256) <> 0 then
                        begin
                            result := M4aErr_Invalid_METAVersion;
                            exit;
                        end else
                            newStream.Write(VersionFlags, 4); // write Version and Flags

                    // parse META-subatoms
                        MetaProcessed := 12;
                        MetaSize := newSize;
                        while MetaProcessed < MetaSize do
                        begin
                            GetNextAtomInfo(fData, newName, newSize);
                            inc(bytesProcessed, 8);
                            inc(MetaProcessed, 8);

                            if newName = 'ilst' then
                            begin
                                WriteILST;
                                ILSTwritten := True;

                                // skip the old ILST in fData
                                fData.Seek(newSize-8, soCurrent);
                                inc(bytesProcessed, newSize-8);
                                inc(MetaProcessed, newSize-8);
                            end else
                            begin
                                if newname = 'free' then
                                    // do not write old FREE-atoms into the newStream
                                    fData.Seek(newSize-8, soCurrent)
                                else
                                begin
                                    // copy the old atom int the newStream
                                    newAtom := TMetaAtom.Create(newName);
                                    try
                                        newAtom.ReadFromStream(fData, newSize);
                                        newAtom.SaveToStream(newStream);
                                    finally
                                        newAtom.Free;
                                    end;
                                end;
                                inc(bytesProcessed, newSize-8);
                                inc(MetaProcessed, newSize-8);
                            end;
                        end;
                        // if not ILST written, then we have to do it here
                        // can be the case, if an udta-atom was present in the file, but without an udta.meta.ilst-atom
                        if not ILSTwritten then
                            WriteILST;

                    // Compute correct Size of META
                        newMetaSize := newStream.Size - MetaSizeOffset;
                        newMetaSize := ChangeEndian32(newMetaSize);

                end // newname = 'META'
                else
                begin
                    // other atoms (Not META, Not FREE): just copy them into newStream
                    newAtom := TMetaAtom.Create(newName);
                    try
                        newAtom.ReadFromStream(fData, newSize);
                        newAtom.SaveToStream(newStream);
                    finally
                        newAtom.Free;
                    end;
                end;
        end; // All DATA processed


        // Correct Sizes in Stream
        newStream.Seek(IlstSizeOffset, soBeginning);
        newStream.Write(newIlstSize, 4);

        newStream.Seek(MetaSizeOffset, soBeginning);
        newStream.Write(newMetaSize, 4);

        // Delete Old Data
        fData.Clear;
        // copy new data
        fData.CopyFrom(newStream, 0);

    finally
        newStream.Free;
    end;
end;

{ TMetaAtom }

function TMetaAtom.GetTextData: UnicodeString;
var newName: TAtomName;
    newSize, MetaType: DWord;
    dataString: UTF8String;
begin
    fData.Position := 0;

    GetNextAtomInfo(fData, newName, newSize);
    if newName = 'data' then
    begin
        fData.Read(MetaType, 4);
        MetaType := ChangeEndian32(MetaType);

        if MetaType = 1 then
        begin
            fData.Seek(4, soCurrent);  // reserved Bytes
            SetLength(dataString, fData.Size - fData.Position);
            fData.Read(dataString[1], length(dataString));
            result := ConvertUTF8ToString(dataString);
        end else
            result := '';
    end else
        result := '';
end;


procedure TMetaAtom.WriteHeader(aSize: DWord);
var name: TAtomName;
begin
    fData.Position := 0;
    aSize := ChangeEndian32(aSize);
    fData.Write(aSize, 4);
    name := 'data';
    fData.Write(name[1], 4);
end;

procedure TMetaAtom.SetTextData(aValue: UnicodeString);
var dataString: UTF8String;
    newSize, MetaType, reserved: DWord;
begin
    dataString := ConvertStringToUTF8(aValue);
    newSize := 16 + length(dataString);

    fData.Clear;
    WriteHeader(newSize);

    MetaType := ChangeEndian32(1);
    reserved := 0;
    fData.Write(MetaType, 4);
    fData.Write(reserved, 4);
    fData.Write(dataString[1], length(dataString));
end;

function TMetaAtom.GetGenre: UnicodeString;
var newName: TAtomName;
    newSize, MetaType: DWord;
    gnre: Word;
begin
    fData.Position := 0;

    GetNextAtomInfo(fData, newName, newSize);
    if newName = 'data' then
    begin
        fData.Read(MetaType, 4);
        MetaType := ChangeEndian32(MetaType);

        if MetaType = 0 then  // binary data here
        begin
            fData.Seek(4, soCurrent);  // reserved Bytes
            fData.Read(gnre, 2);
            gnre := ChangeEndian16(gnre) - 1; // this number will be  the same as in ID3-Tags

            if (gnre > 0) and (gnre < ID3Genres.Count) then
                result := ID3Genres[gnre]
            else
                result := '';
        end
        else
            result := ''; // unexpected gnre-format
    end
    else
        result := '';
end;


procedure TMetaAtom.SetStandardGenre(idx: Integer);
var buf: TBuffer;
    v: Word;
begin
    fData.Clear;

    setlength(buf, 18);
    FillChar(buf[0], 18, 0);
    fData.Write(buf[0], 18);

    WriteHeader(18);
    v := ChangeEndian16(Word(idx + 1));
    fData.Seek(16, soBeginning);
    fData.Write(v, 2);
end;

procedure TMetaAtom.prepareDiskTrackAtom(l: TTrackDisc; aValue: UnicodeString);
var s: DWord;
    buf: TBuffer;
    posSlash: Integer;
    trk, total: DWord;
begin
    case l of
      meta_Track:  s := 24;
      meta_Disc:   s := 22;
    else
      s := 22;
    end;

    if fData.Size = 0 then
    begin
        // new Atom, init
        // 8 Bytes Flags, 2 Bytes 0, 2 Bytes TrackNumber, 2 Bytes TotalTracks, 2 Bytes 0
        setlength(buf, s);
        FillChar(buf[0], s, 0);
        fData.Write(buf[0], s);
    end;
    WriteHeader(s);

    posSlash := pos('/', aValue);
    if posSlash > 0 then
    begin
        trk := StrToIntDef(Copy(aValue, 1, posSlash-1), 0);
        total := StrToIntDef(Copy(aValue, posSlash+1, length(aValue) - posSlash), 0);
    end else
    begin
          trk := StrToIntDef(aValue, 0);
          total := 0;
    end;

    trk := ChangeEndian16(trk);
    total := ChangeEndian16(total);
    fData.Seek(18, soBeginning);
    fData.Write(trk, 2);
    fData.Write(total, 2);
end;

function TMetaAtom.GetTrackNumber: UnicodeString;
var newName: TAtomName;
    newSize: DWord;
    trk, total: Word;
begin
    fData.Position := 0;

    GetNextAtomInfo(fData, newName, newSize);
    if newName = 'data' then
    begin
        fData.Seek(10, soCurrent);
        fData.Read(trk, 2);
        trk := ChangeEndian16(trk);
        fData.Read(total, 2);
        total := ChangeEndian16(total);

        if total > 0 then
            result := IntToStr(trk) + '/' + IntToStr(total)
        else
            result := IntToStr(trk);
    end
    else
        result := ''; // unexpected trkn-format
end;

procedure TMetaAtom.SetTrackNumber(aValue: UnicodeString);
begin
    prepareDiskTrackAtom(meta_Track, aValue);
end;

function TMetaAtom.GetDiscNumber: UnicodeString;
begin
    result := GetTrackNumber;
end;

procedure TMetaAtom.SetDiscNumber(aValue: UnicodeString);
begin
    prepareDiskTrackAtom(meta_Disc, aValue);
end;

function TMetaAtom.GetPictureStream(Dest: TStream; var typ: TM4APicTypes): Boolean;
var newName: TAtomName;
    newSize, t: DWord;
begin
    fData.Position := 0;

    GetNextAtomInfo(fData, newName, newSize);
    if newName = 'data' then
    begin
        fData.Read(t, 4);
        t := ChangeEndian32(t);
        if t in [13,14] then
        begin
            case t of
                13: typ := M4A_JPG;
                14: typ := M4A_PNG
            else
                typ := M4A_Invalid;
            end;
            fData.Seek(4, soCurrent);
            Dest.CopyFrom(fData, fData.Size - 16);
            result := True;
        end else
            result := False;
    end else
        result := False;
end;

procedure TMetaAtom.SetPicture(Source: TStream; typ: TM4APicTypes);
var t: DWord;
begin
    fData.Clear;
    WriteHeader(16 + Source.Size);

    case typ of
        M4A_JPG: t := ChangeEndian32(13) ;
        M4A_PNG: t := ChangeEndian32(13)
    else
        t := 0;
    end;

    fData.Write(t, 4);
    t := 0;
    fData.Write(t, 4);
    fData.CopyFrom(Source, 0);
end;

function TMetaAtom.GetSpecialData(out aMean, aName: AnsiString): UnicodeString;
var newName: TAtomName;
    newSize, MetaType: DWord;
    dataString: UTF8String;
begin
    fData.Position := 0;
    result := '';
    GetNextAtomInfo(fData, newName, newSize);
    if newName = 'mean' then
    begin
        fData.Seek(4, soCurrent);
        Setlength(aMean, newSize - 12);
        fData.Read(aMean[1], newSize - 12);
    end else
    begin
        result := '';
        exit;
    end;

    GetNextAtomInfo(fData, newName, newSize);
    if newName = 'name' then
    begin
        fData.Seek(4, soCurrent);
        Setlength(aName, newSize - 12);
        fData.Read(aName[1], newSize - 12);
    end else
    begin
        result := '';
        exit;
    end;

    GetNextAtomInfo(fData, newName, newSize);
    if newName = 'data' then
    begin
        fData.Read(MetaType, 4);
        MetaType := ChangeEndian32(MetaType);
        if MetaType = 1 then
        begin
            fData.Seek(4, soCurrent);
            setlength(dataString, newSize-16);
            fData.Read(dataString[1], newSize - 8);
            result := ConvertUTF8ToString(dataString);
        end else
            result := '';
    end else
    begin
        result := '';
        exit;
    end;
end;


procedure TMetaAtom.SetSpecialData(aMean, aName: AnsiString; aValue: UnicodeString);
var s, n, o: DWord;
    dataString: UTF8String;
    tmp: TAtomName;
begin
    fData.Clear;
    dataString := ConvertStringToUTF8(aValue);
    n := 0;
    s := ChangeEndian32(length(aMean) + 12);
    fData.Write(s, 4);
    tmp := 'mean';
    fData.Write(tmp[1], 4);
    fData.Write(n, 4);
    fData.Write(aMean[1], length(aMean));

    s := ChangeEndian32(length(aName) + 12);
    fData.Write(s, 4);
    tmp := 'name';
    fData.Write(tmp[1], 4);
    fData.Write(n, 4);
    fData.Write(aName[1], length(aName));

    s := ChangeEndian32(length(dataString) + 16);
    fData.Write(s, 4);
    tmp := 'data';
    fData.Write(tmp[1], 4);
    o := ChangeEndian32(1);
    fData.Write(o, 4);
    fData.Write(n, 4);
    fData.Write(dataString[1], length(dataString));
end;

function TMetaAtom.ContainsTextData: Boolean;
var dummy1, dummy2: AnsiString;
begin
    result := (GetTextData <> '')
           or (GetSpecialData(dummy1, dummy2) <> '');
end;

function TMetaAtom.GetListDescription: UnicodeString;
var i: Integer;
    aMean, aName: AnsiString;
begin
    result := 'Unknown Atom ('+ self.Name+ ')'; // Dont change this!! (Used in TM4AFile.GetTextDataByDescription)
    if self.Name = '----' then
    begin
        GetSpecialData(aMean, aName);
        result := UnicodeString(aName + '::' + aMean);  // Dont change this!! (Used in TM4AFile.GetTextDataByDescription)
    end else
        if self.Name = 'trkn' then
            result := 'Track number'
        else
            if self.Name = 'disk' then
                result := 'Disk number'
            else
                if self.Name = 'gnre' then
                    result := 'Genre (index)'
                else
                    if self.Name = 'covr' then
                        result := 'Cover art'
                    else
                    begin
                        for i := 0 to length(KnownMetaAtoms) - 1 do
                            if KnownMetaAtoms[i].AtomName = self.Name then
                            begin
                                result := KnownMetaAtoms[i].Description;
                                break;
                            end;
                    end;
end;


end.
