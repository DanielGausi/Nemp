{
    -----------------------------------
    Audio Werkzeuge Bibliothek
    -----------------------------------
    (c) 2012, Daniel Gaussmann
              Website : www.gausi.de
              EMail   : mail@gausi.de
    -----------------------------------

    Unit M4AFiles

    Manipulate m4a-Files (as used by iTunes)

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

unit M4aFiles;

interface

uses Windows, Messages, SysUtils, StrUtils, Variants, ContNrs, Classes,
 AudioFileBasics, M4aAtoms;


const DEFAULT_MEAN: AnsiString = 'com.apple.iTunes';

type


    TM4AFile = class (TBaseAudioFile)

        private
            fBytesBeforeMDTA: DWord;
            fTmpStcoOffset: DWord;

            function fPrepareSaving(ExistingTag: TM4AFile; dest: TStream): TAudioError;
            procedure fFixAudioOffsets(st: TStream; diff: Integer);

            function BackupAudioData(source: TStream; BackUpFilename: UnicodeString): TAudioError;
            function AppendBackup(Destination: TStream; BackUpFilename: UnicodeString): TAudioError;
            

        protected

            function fGetFileSize   : Int64;    override;
            function fGetDuration   : Integer;  override;
            function fGetBitrate    : Integer;  override;
            function fGetSamplerate : Integer;  override;
            function fGetChannels   : Integer;  override;
            function fGetValid      : Boolean;  override;

            // standard properties
            // Setter
            procedure fSetTitle      (aValue: UnicodeString); override;
            procedure fSetArtist     (aValue: UnicodeString); override;
            procedure fSetAlbum      (aValue: UnicodeString); override;
            procedure fSetYear       (aValue: UnicodeString); override;
            procedure fSetTrack      (aValue: UnicodeString); override;
            procedure fSetGenre      (aValue: UnicodeString); override;
            procedure fSetComment    (aValue: UnicodeString);
            // Getter
            function fGetTitle       : UnicodeString; override;
            function fGetArtist      : UnicodeString; override;
            function fGetAlbum       : UnicodeString; override;
            function fGetYear        : UnicodeString; override;
            function fGetTrack       : UnicodeString; override;
            function fGetGenre       : UnicodeString; override;
            function fGetComment     : UnicodeString;

            procedure fSetDisc      (aValue: UnicodeString);
            function fGetDisc       : UnicodeString;


            procedure __fSetAlbumArtist       (aValue: UnicodeString);
            procedure __fSetGrouping          (aValue: UnicodeString);
            procedure __fSetComposer          (aValue: UnicodeString);
            procedure __fSetDescription       (aValue: UnicodeString);
            procedure __fSetLongDescription   (aValue: UnicodeString);
            procedure __fSetLyrics            (aValue: UnicodeString);
            procedure __fSetCopyright         (aValue: UnicodeString);
            procedure __fSetEncodingTool      (aValue: UnicodeString);
            procedure __fSetEncodedBy         (aValue: UnicodeString);
            procedure __fSetKeywords          (aValue: UnicodeString);

            function __fGetAlbumArtist        : UnicodeString;
            function __fGetGrouping           : UnicodeString;
            function __fGetComposer           : UnicodeString;
            function __fGetDescription        : UnicodeString;
            function __fGetLongDescription    : UnicodeString;
            function __fGetLyrics             : UnicodeString;
            function __fGetCopyright          : UnicodeString;
            function __fGetEncodingTool       : UnicodeString;
            function __fGetEncodedBy          : UnicodeString;
            function __fGetKeywords           : UnicodeString;


        public
            FTYP: TBaseAtom;
            MOOV: TMoovAtom;
            PADDING: TBaseAtom;

            UsePadding: Boolean; // Set UsePadding to False before WriteToFile to delete Free-Atoms
                                 // Note: If it is True, all Free-Atoms will be merged to one large
                                 //       Free-Atom to fill the unused space before the actual audio-data


            property Comment : UnicodeString read fGetComment write fSetComment;
            property Disc    : UnicodeString read fGetDisc   write  fSetDisc   ;


            property AlbumArtist        : UnicodeString read __fGetAlbumArtist      write  __fSetAlbumArtist    ;
            property Grouping           : UnicodeString read __fGetGrouping         write  __fSetGrouping       ;
            property Composer           : UnicodeString read __fGetComposer         write  __fSetComposer       ;
            property Description        : UnicodeString read __fGetDescription      write  __fSetDescription    ;
            property LongDescription    : UnicodeString read __fGetLongDescription  write  __fSetLongDescription;
            property Lyrics             : UnicodeString read __fGetLyrics           write  __fSetLyrics         ;
            property Copyright          : UnicodeString read __fGetCopyright        write  __fSetCopyright      ;
            property EncodingTool       : UnicodeString read __fGetEncodingTool     write  __fSetEncodingTool   ;
            property EncodedBy          : UnicodeString read __fGetEncodedBy        write  __fSetEncodedBy      ;
            property Keywords           : UnicodeString read __fGetKeywords         write  __fSetKeywords       ;

            constructor Create;
            destructor Destroy; override;
            procedure Clear;
            function ReadFromFile(aFilename: UnicodeString): TAudioError;    override;
            function WriteToFile(aFilename: UnicodeString): TAudioError;     override;
            function RemoveFromFile(aFilename: UnicodeString): TAudioError;  override;

            function GetPictureStream(Dest: TStream; var typ: TM4APicTypes): Boolean;
            procedure SetPicture(Source: TStream; typ: TM4APicTypes);      // set a Picture
                                                                          // use Source=NIL, to delete the picture

            function GetTextDataByDescription(aDescription: UnicodeString): UnicodeString;
            function GetSpecialData(mean, name: AnsiString): UnicodeString;
            procedure SetSpecialData(mean, name: AnsiString; aValue: UnicodeString);

            procedure GetAllTextAtomDescriptions(dest: TStrings);
            procedure GetAllTextAtoms(dest: TObjectList);

            procedure GetAllAtoms(dest: TObjectList);
            procedure RemoveMetaAtom(aAtom: TMetaAtom);


    end;

implementation

{ TM4AFile }


constructor TM4AFile.Create;
begin
    MOOV := TMoovAtom.Create('moov');
    FTYP := TBaseAtom.Create('ftyp');
    PADDING := TBaseAtom.Create('free');
    fValid      := False;
    UsePadding  := True;
end;

destructor TM4AFile.Destroy;
begin
    FTYP.Free;
    MOOV.Free;
    PADDING.Free;
    inherited;
end;

procedure TM4AFile.Clear;
begin
    FTYP.Clear;
    MOOV.Clear;
    PADDING.Clear;
    fValid      := False;
end;


function TM4AFile.fGetValid: Boolean;
begin
    result := fValid;
end;


function TM4AFile.fGetFileSize: Int64;
begin
    result := fFileSize;
end;

function TM4AFile.fGetSamplerate: Integer;
begin
    result := MOOV.Samplerate
end;


function TM4AFile.fGetDuration: Integer;
begin
    result := MOOV.Duration
end;

function TM4AFile.fGetChannels: Integer;
begin
    result := MOOV.Channels
end;

function TM4AFile.fGetBitrate: Integer;
begin
    if moov.Duration > 0 then
        result := round(8 * (fFilesize - moov.AudioDataOffset) / (moov.Duration))
    else
        result := 0;
end;

function TM4AFile.fGetArtist: UnicodeString;
begin
    result := MOOV.UdtaAtom.GetTextData('©ART');
end;

function TM4AFile.fGetTitle: UnicodeString;
begin
    result := MOOV.UdtaAtom.GetTextData('©nam');
end;

function TM4AFile.fGetAlbum: UnicodeString;
begin
    result := MOOV.UdtaAtom.GetTextData('©alb');
end;

function TM4AFile.fGetComment: UnicodeString;
begin
    result := MOOV.UdtaAtom.GetTextData('©cmt');
end;

function TM4AFile.fGetYear: UnicodeString;
begin
    result := MOOV.UdtaAtom.GetTextData('©day');
end;

function TM4AFile.fGetTrack: UnicodeString;
begin
    result := MOOV.UdtaAtom.GetTrackNumber
end;

function TM4AFile.fGetGenre: UnicodeString;
begin
    result := MOOV.UdtaAtom.GetGenre;
end;


procedure TM4AFile.fSetArtist(aValue: UnicodeString);
begin
    MOOV.UdtaAtom.SetTextData('©ART', aValue);
end;

procedure TM4AFile.fSetTitle(aValue: UnicodeString);
begin
    MOOV.UdtaAtom.SetTextData('©nam', aValue);
end;

procedure TM4AFile.fSetAlbum(aValue: UnicodeString);
begin
    MOOV.UdtaAtom.SetTextData('©alb', aValue);
end;

procedure TM4AFile.fSetComment(aValue: UnicodeString);
begin
    MOOV.UdtaAtom.SetTextData('©cmt', aValue);
end;

procedure TM4AFile.fSetYear(aValue: UnicodeString);
begin
    MOOV.UdtaAtom.SetTextData('©day', aValue);
end;

procedure TM4AFile.fSetGenre(aValue: UnicodeString);
begin
    MOOV.UdtaAtom.SetGenre(aValue);
end;

procedure TM4AFile.fSetTrack(aValue: UnicodeString);
begin
    MOOV.UdtaAtom.SetTrackNumber(aValue);
end;

function TM4AFile.fGetDisc: UnicodeString;
begin
    result := MOOV.UdtaAtom.GetDiscNumber;
end;
procedure TM4AFile.fSetDisc(aValue: UnicodeString);
begin
    MOOV.UdtaAtom.SetDiscNumber(aValue);
end;


function TM4AFile.GetPictureStream(Dest: TStream; var typ: TM4APicTypes): Boolean;
begin
    result := MOOV.UdtaAtom.GetPictureStream(Dest, typ);
end;

procedure TM4AFile.SetPicture(Source: TStream; typ: TM4APicTypes);
begin
    MOOV.UdtaAtom.SetPicture(Source, typ);
end;


function TM4AFile.GetTextDataByDescription(aDescription: UnicodeString): UnicodeString;
var idx, i: Integer;
    aMean, aName: AnsiString;
    aAtomName: TAtomName;
begin

    idx := pos('::', aDescription);
    if idx > 0 then
    begin
        aName := AnsiString(copy(aDescription, 1, idx-1));
        aMean := AnsiString(copy(aDescription, idx+2, length(aDescription) - idx + 1));
        result := MOOV.UdtaAtom.GetSpecialData(aMean, aName);
    end else
    begin
        if AnsiStartsText('Unknown Atom (', aDescription) then
        begin
            aName := AnsiString(copy(aDescription, 15, 4));
            move(aName[1], aAtomName[1], 4);
            result := MOOV.UdtaAtom.GetTextData(aAtomName);
        end else
        begin
            for i := 0 to length(KnownMetaAtoms) - 1 do
                if KnownMetaAtoms[i].Description = aDescription then
                begin
                    result := MOOV.UdtaAtom.GetTextData(KnownMetaAtoms[i].AtomName);
                    break;
                end;
        end;
    end;
end;

function TM4AFile.GetSpecialData(mean, name: AnsiString): UnicodeString;
begin
    result := MOOV.UdtaAtom.GetSpecialData(mean, name);
end;

procedure TM4AFile.SetSpecialData(mean, name: AnsiString;
  aValue: UnicodeString);
begin
    MOOV.UdtaAtom.SetSpecialData(mean, name, aValue);
end;

procedure TM4AFile.GetAllTextAtomDescriptions(dest: TStrings);
begin
    MOOV.UdtaAtom.GetAllTextAtomDescriptions(dest);
end;

procedure TM4AFile.GetAllTextAtoms(dest: TObjectList);
begin
    MOOV.UdtaAtom.GetAllTextAtoms(dest);
end;

procedure TM4AFile.GetAllAtoms(dest: TObjectList);
begin
    MOOV.UdtaAtom.GetAllAtoms(dest);
end;

procedure TM4AFile.RemoveMetaAtom(aAtom: TMetaAtom);
begin
    MOOV.UdtaAtom.RemoveAtom(aAtom);
end;

function TM4AFile.ReadFromFile(aFilename: UnicodeString): TAudioError;
var fs: TAudioFileStream;
    AtomSize: DWord;
    AtomName: TAtomName;
begin
    Clear;
    // result := FileErr_None;

    if AudioFileExists(aFilename) then
    begin
        try
            fs := TAudioFileStream.Create(aFilename, fmOpenRead or fmShareDenyWrite);
            try
                fFileSize := fs.Size;

                // Read FTYP-Atom
                // result <> FileErr_none <=> we have a 64Bit-Atom (not supported)
                result := GetNextAtomInfo(fs, AtomName, AtomSize);

                if result = FileErr_None then
                begin
                    if (AtomName = 'ftyp') then
                    begin
                        FTYP.ReadFromStream(fs, AtomSize);
                    end else
                        result := M4aErr_Invalid_TopLevelAtom;
                end;

                // Read MOOV-Atom
                if result = FileErr_None then
                begin
                    result := GetNextAtomInfo(fs, AtomName, AtomSize);
                    if result = FileErr_None then
                    begin
                        if AtomName = 'moov' then
                        begin
                            MOOV.ReadFromStream(fs, AtomSize);
                            result := MOOV.ParseData;
                        end else
                            result := M4aErr_Invalid_TopLevelAtom;
                    end;
                end;

                if result = FileErr_None then
                begin
                    // Check for FREE-Atom
                    result := GetNextAtomInfo(fs, AtomName, AtomSize);
                    if result = FileErr_None then
                    begin
                        if AtomName = 'free' then
                        begin
                            PADDING.ReadFromStream(fs, AtomSize);
                            // Next Atom must be MDAT
                            GetNextAtomInfo(fs, AtomName, AtomSize);
                            // (mdat can be larger)
                            if AtomName = 'mdat' then
                                fBytesBeforeMDTA := fs.Position - 8
                            else
                                result := M4aErr_Invalid_TopLevelAtom;

                        end else
                        begin
                            // No FREE-Atom, next MUST be MDAT (?)
                            if AtomName = 'mdat' then
                                fBytesBeforeMDTA := fs.Position - 8
                            else
                                result := M4aErr_Invalid_TopLevelAtom;
                        end;
                    end;
                end;
            finally
                fs.Free;
            end;
        except
            result := FileErr_FileOpenR;
        end;
    end else
        result := FileErr_NoFile;

    fValid := result = FileErr_None;
end;

function TM4AFile.RemoveFromFile(aFilename: UnicodeString): TAudioError;
begin
    result := M4aErr_RemovingNotSupported;
end;


function TM4AFile.fPrepareSaving(ExistingTag: TM4AFile;
  dest: TStream): TAudioError;
var MoovOffset: DWord;
begin
    MOOV.UdtaAtom.PrepareDataForSaving;

    // write FTYP into the new Stream
    ExistingTag.FTYP.SaveToStream(dest);

    // write MOOV into the new Stream
    MoovOffset := dest.Size;
    result := ExistingTag.MOOV.WriteToStreamWithNewUDTA(dest, MOOV.UdtaAtom);

    fTmpStcoOffset := MoovOffset + ExistingTag.MOOV.StcoOffset;
end;

procedure TM4AFile.fFixAudioOffsets(st: TStream; diff: Integer);
var i: Integer;
    c, v: Dword;
begin
    st.Seek( fTmpStcoOffset + 12, soBeginning);
    st.Read(c, 4);
    c := ChangeEndian32(c);
    for i := 1 to c do
    begin
        st.Read(v, 4);
        v := ChangeEndian32(v);
        st.Seek(-4, soCurrent);

        inc(v, diff);

        v := ChangeEndian32(v);
        st.Write(v, 4);
    end;      
end;

function TM4AFile.BackupAudioData(source: TStream; BackUpFilename: UnicodeString): TAudioError;
var fs: TAudioFileStream;
begin
    try
        fs := TAudioFileStream.Create(BackupFilename, fmCreate);
        try
            fs.CopyFrom(source, source.Size - source.Position);
            result := FileErr_None;
        finally
            fs.Free;
        end;
    except
        result := FileErr_FileCreate
    end;
end;

function TM4AFile.AppendBackup(Destination: TStream; BackUpFilename: UnicodeString): TAudioError;
var fs: TAudioFileStream;
begin
    try
        fs := TAudioFileStream.Create(BackupFilename, fmOpenread);
        try
            Destination.CopyFrom(fs, 0);
            result := FileErr_None;
        finally
            fs.Free;
        end;
    except
        result := FlacErr_BackupFailed;
    end;
end;

function TM4AFile.WriteToFile(aFilename: UnicodeString): TAudioError;
var ExistingTag: TM4AFile;
    tmpMetaStream: TMemoryStream;
    FreeAtom: TFreeAtom;
    fs: TAudioFileStream;

          function WriteData: TAudioError;
          begin
              result := FileErr_None;
              if AudioFileExists(aFilename) then
              begin
                  try
                      fs := TAudioFileStream.Create(aFilename, fmOpenReadWrite or fmShareDenyWrite);
                      try
                          fs.Seek(0, soBeginning);
                          // copy the new tmpMetaStream into the file
                          fs.CopyFrom(tmpMetaStream, 0);
                      finally
                          fs.Free;
                      end;
                  except
                      result := FileErr_FileOpenRW;
                  end;
              end else
                  result := FileErr_NoFile;
          end;

begin
    // result := FileErr_None;

    ExistingTag := TM4AFile.Create;
    try
        result := ExistingTag.ReadFromFile(aFilename);

        if result = FileErr_None then
        begin
            tmpMetaStream := TMemoryStream.Create;
            try
                // copy first Atoms of ExistingTag, but replace moov.udta with self.moov.udta
                {result := }fPrepareSaving(ExistingTag, tmpMetaStream);

                if (tmpMetaStream.Size = ExistingTag.fBytesBeforeMDTA) and UsePadding then
                    // nothing special todo
                    result := WriteData
                else

                begin
                    // we need a FREE-Atom (which has a minimum size of 8 bytes)
                    if (tmpMetaStream.Size + 8 < ExistingTag.fBytesBeforeMDTA) and UsePadding then
                    begin
                        FreeAtom := TFreeAtom.CreateFree('free', ExistingTag.fBytesBeforeMDTA - tmpMetaStream.Size);
                        try
                            FreeAtom.SaveToStream(tmpMetaStream);
                            // (and we are done)
                            result := WriteData;
                        finally
                            FreeAtom.Free;
                        end


                    end else
                    begin
                        // we do not have enough space for writing our data,
                        // OR we dont want to have padding
                        // rewrite complete file, but add som extra free-space
                        if UsePadding then
                        begin
                            FreeAtom := TFreeAtom.CreateFree('free', 2048);
                            try
                                FreeAtom.SaveToStream(tmpMetaStream);
                            finally
                                FreeAtom.Free;
                            end;

                        end;

                        fFixAudioOffsets(tmpMetaStream, tmpMetaStream.Size - ExistingTag.fBytesBeforeMDTA);
                        try
                            fs := TAudioFileStream.Create(aFilename, fmOpenReadWrite or fmShareDenyWrite);
                            try
                                fs.Seek(ExistingTag.fBytesBeforeMDTA, soBeginning);
                                result := BackupAudioData(fs, aFilename+'~');
                                if result = FileErr_None then
                                begin
                                    fs.Seek(0, soBeginning);
                                    // copy the new tmpMetaStream into the file
                                    fs.CopyFrom(tmpMetaStream, 0);
                                    // write AudioData back to the File
                                    result := self.AppendBackup(fs, aFilename+'~');
                                    // cleanup
                                    if result = FileErr_None then
                                    begin
                                        // Set End of File here (in case new Metadata is smaller)
                                        SetEndOfFile((fs as THandleStream).Handle);
                                        //delete backupfile
                                        if not DeleteFile(aFilename + '~') then
                                            result := FlacErr_DeleteBackupFailed;
                                    end;
                                end;
                            finally
                                fs.Free;
                            end;
                        except
                            result := FileErr_FileOpenRW;
                        end;
                    end;
                end;
            finally
                tmpMetaStream.Free;
            end;
        end;
    finally
        Existingtag.Free;
    end;
end;

function TM4AFile.__fGetAlbumArtist: UnicodeString;
begin
    result := MOOV.UdtaAtom.GetTextData('aART');
end;

function TM4AFile.__fGetComposer: UnicodeString;
begin
    result := MOOV.UdtaAtom.GetTextData('©wrt');
end;

function TM4AFile.__fGetCopyright: UnicodeString;
begin
    result := MOOV.UdtaAtom.GetTextData('cprt');
end;

function TM4AFile.__fGetDescription: UnicodeString;
begin
    result := MOOV.UdtaAtom.GetTextData('desc');
end;

function TM4AFile.__fGetEncodedBy: UnicodeString;
begin
    result := MOOV.UdtaAtom.GetTextData('©enc');
end;

function TM4AFile.__fGetEncodingTool: UnicodeString;
begin
    result := MOOV.UdtaAtom.GetTextData('©too');
end;

function TM4AFile.__fGetGrouping: UnicodeString;
begin
    result := MOOV.UdtaAtom.GetTextData('©grp');
end;

function TM4AFile.__fGetLongDescription: UnicodeString;
begin
    result := MOOV.UdtaAtom.GetTextData('ldes');
end;

function TM4AFile.__fGetLyrics: UnicodeString;
begin
    result := MOOV.UdtaAtom.GetTextData('©lyr');
end;

function TM4AFile.__fGetKeywords: UnicodeString;
begin
    result := MOOV.UdtaAtom.GetTextData('keyw');
end;

procedure TM4AFile.__fSetAlbumArtist(aValue: UnicodeString);
begin
    MOOV.UdtaAtom.SetTextData('aART', aValue);
end;

procedure TM4AFile.__fSetComposer(aValue: UnicodeString);
begin
    MOOV.UdtaAtom.SetTextData('©wrt', aValue);
end;

procedure TM4AFile.__fSetCopyright(aValue: UnicodeString);
begin
    MOOV.UdtaAtom.SetTextData('cprt', aValue);
end;

procedure TM4AFile.__fSetDescription(aValue: UnicodeString);
begin
    MOOV.UdtaAtom.SetTextData('desc', aValue);
end;

procedure TM4AFile.__fSetEncodedBy(aValue: UnicodeString);
begin
    MOOV.UdtaAtom.SetTextData('©enc', aValue);
end;

procedure TM4AFile.__fSetEncodingTool(aValue: UnicodeString);
begin
    MOOV.UdtaAtom.SetTextData('©too', aValue);
end;

procedure TM4AFile.__fSetGrouping(aValue: UnicodeString);
begin
    MOOV.UdtaAtom.SetTextData('©grp', aValue);
end;

procedure TM4AFile.__fSetLongDescription(aValue: UnicodeString);
begin
    MOOV.UdtaAtom.SetTextData('ldes', aValue);
end;

procedure TM4AFile.__fSetLyrics(aValue: UnicodeString);
begin
    MOOV.UdtaAtom.SetTextData('©lyr', aValue);
end;

procedure TM4AFile.__fSetKeywords(aValue: UnicodeString);
begin
    MOOV.UdtaAtom.SetTextData('keyw', aValue);
end;

end.
