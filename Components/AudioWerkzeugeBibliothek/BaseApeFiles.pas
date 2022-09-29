{
    -----------------------------------
    Audio Werkzeuge Bibliothek
    -----------------------------------
    (c) 2012-2020, Daniel Gaussmann
              Website : www.gausi.de
              EMail   : mail@gausi.de
    -----------------------------------

    Unit BaseApeFiles

    (was: Apev2Tags before)

    This is the base class for
        MonkeyFiles
        MusePackFiles
        OptimFrogFiles
        TrueAudioFiles
        WavePackFiles

    Use an instance of these classes to colelct data from the files.

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

unit BaseApeFiles;

interface

uses Windows, SysUtils, Classes,
     AudioFiles.Base, AudioFiles.Declarations,
     Id3Basics, ID3v1Tags, ApeV2Tags, ApeTagItem;

type

    TBaseApeFile = class (TBaseAudioFile)
        private

            fApeTag: TApeTag;
            fID3v1Tag: TID3v1tag;

            fTagsToBeWritten : TMetaTagSet;
            fDefaultTags     : TMetaTagSet;
            fTagsToBeDeleted : TMetaTagSet;

            fID3v2TagSize: Cardinal;

            function fGetID3v1TagSize: Cardinal;
            function fGetApeTagSize: Cardinal;
            function fGetCombinedTagSize: Cardinal;  // The Size of Ape, ID3v and ID3v2 together. Used for Bitrate calculation

      protected
            function fGetFileSize   : Int64;    override;
            function fGetDuration   : Integer;  override;
            function fGetBitrate    : Integer;  override;
            function fGetSamplerate : Integer;  override;
            function fGetChannels   : Integer;  override;
            function fGetValid      : Boolean;  override;

            procedure fSetTitle (aValue: UnicodeString); override;
            procedure fSetArtist(aValue: UnicodeString); override;
            procedure fSetAlbum (aValue: UnicodeString); override;
            procedure fSetYear  (aValue: UnicodeString); override;
            procedure fSetTrack (aValue: UnicodeString); override;
            procedure fSetGenre (aValue: UnicodeString); override;
            procedure fSetAlbumArtist (value: UnicodeString); override;

            function fGetTitle  : UnicodeString; override;
            function fGetArtist : UnicodeString; override;
            function fGetAlbum  : UnicodeString; override;
            function fGetYear   : UnicodeString; override;
            function fGetTrack  : UnicodeString; override;
            function fGetGenre  : UnicodeString; override;
            function fGetAlbumArtist : UnicodeString; override;

            function ReadAudioDataFromStream(aStream: TStream): Boolean; virtual;
            function fGetFileType            : TAudioFileType; override;
            function fGetFileTypeDescription : String;         override;

        public
            property ApeTag: TApeTag read fApeTag;
            property ID3v1Tag: TID3v1tag read fID3v1Tag;

            ///  Set of [mt_Existing, mt_ID3v1, mt_ID3v2, mt_APE]
            ///  Note: In "Ape-Based-Filetypes" ID3v2 is NOT supported
            ///        Setting [mt_ID3v1] will have NO effect in this class
            ///  TagsToBeWritten: Define which Tag(s) should be updated in the file when writing
            ///  DefaultTags: Define which Tag(s) should be written when only [mt_Existing] is selected
            ///               and NO Tag exists at all
            ///  TagsToBeDeleted: define which Tag should be removed by RemoveFromFile
            property TagsToBeWritten : TMetaTagSet read fTagsToBeWritten write fTagsToBeWritten ;
            property DefaultTags     : TMetaTagSet read fDefaultTags     write fDefaultTags     ;
            property TagsToBeDeleted : TMetaTagSet read fTagsToBeDeleted write fTagsToBeDeleted ;

            ///  Size of the Tags in Bytes
            ///  Note: Only the Apev2Tag and ID3v1Tag is really processed here
            ///        The ID3v2Tag is only detected to exclude its size frome the amount of "audiodata"
            ///        However, in most cases it should not be existing
            property Apev2TagSize   : Cardinal read fGetApeTagSize;
            property ID3v1TagSize   : Cardinal read fGetID3v1TagSize;
            property ID3v2TagSize   : Cardinal read fID3v2TagSize;
            property CombinedTagSize: Cardinal read fGetCombinedTagSize;

            constructor Create; override;
            destructor Destroy; override;

            procedure Clear;

            function ReadFromFile(aFilename: UnicodeString): TAudioError;   override;
            function WriteToFile(aFilename: UnicodeString): TAudioError;    override;
            function RemoveFromFile(aFilename: UnicodeString): TAudioError; override;
    end;

implementation

{ TBaseApeFile }

constructor TBaseApeFile.Create;
begin
    fApeTag := TApeTag.Create;
    fID3v1Tag := TID3v1Tag.Create;

    fTagsToBeWritten := [mt_Existing];
    fDefaultTags     := [mt_ID3v1, mt_APE];
    fTagsToBeDeleted := [mt_Existing];
end;

destructor TBaseApeFile.Destroy;
begin
    fApeTag.Free;
    fID3v1Tag.Free;
    inherited;
end;

function TBaseApeFile.fGetFileType: TAudioFileType;
begin
    result := at_AbstractApe;
end;

function TBaseApeFile.fGetFileTypeDescription: String;
begin
    result := TAudioFileNames[at_AbstractApe]
end;

{
    Clear
    Set default values
}
procedure TBaseApeFile.Clear;
begin
    ApeTag.Clear;
    ID3v1Tag.Clear;

    FFileSize := 0;
    fID3v2TagSize := 0;
    fDuration   := 0;
    fBitrate    := 0;
    fSamplerate := 0;
    fChannels   := 0;
    fValid      := False;
end;



function TBaseApeFile.fGetValid: Boolean;
begin
    result := fValid;
end;
function TBaseApeFile.fGetFileSize: Int64;
begin
    result := fFileSize;
end;


// dummy getters
function TBaseApeFile.fGetDuration: Integer;
begin
    result := fDuration;
end;
function TBaseApeFile.fGetChannels: Integer;
begin
    result := fChannels;
end;
function TBaseApeFile.fGetSamplerate: Integer;
begin
    result := fSamplerate;
end;
function TBaseApeFile.fGetBitrate: Integer;
begin
    result := fBitrate;
end;

// Tag Size Getters
function TBaseApeFile.fGetID3v1TagSize: Cardinal;
begin
    Result := ApeTag.ID3v1TagSize;
end;
function TBaseApeFile.fGetApeTagSize: Cardinal;
begin
    Result := ApeTag.Apev2TagSize;
end;
function TBaseApeFile.fGetCombinedTagSize: Cardinal;
begin
    result := ApeTag.Apev2TagSize
            + ApeTag.ID3v1TagSize   // also determined and managed by TApeTag
            + fID3v2TagSize;        // determined from TBaseApeFile.ReadFromFile
end;


// Actual properties
procedure TBaseApeFile.fSetAlbum(aValue: UnicodeString);
begin
    ApeTag.Album := aValue;
    fID3v1Tag.Album := aValue;
end;
procedure TBaseApeFile.fSetAlbumArtist(value: UnicodeString);
begin
  ApeTag.AlbumArtist := Value;
end;

procedure TBaseApeFile.fSetArtist(aValue: UnicodeString);
begin
    ApeTag.Artist := aValue;
    fID3v1Tag.Artist := aValue;
end;
procedure TBaseApeFile.fSetTitle(aValue: UnicodeString);
begin
    ApeTag.Title := aValue;
    fID3v1Tag.Title := aValue;
end;
procedure TBaseApeFile.fSetTrack(aValue: UnicodeString);
begin
    ApeTag.Track := aValue;
    fID3v1Tag.Track := aValue;
end;
procedure TBaseApeFile.fSetYear(aValue: UnicodeString);
begin
    ApeTag.Year := aValue;
    fID3v1Tag.Year := ShortString(aValue);
end;
procedure TBaseApeFile.fSetGenre(aValue: UnicodeString);
begin
    ApeTag.Genre := aValue;
    fID3v1Tag.Genre := aValue;
end;


function TBaseApeFile.fGetAlbum: UnicodeString;
begin
    result := ApeTag.Album;
    if result = '' then
        result := fID3v1Tag.Album;
end;
function TBaseApeFile.fGetAlbumArtist: UnicodeString;
begin
  result := ApeTag.AlbumArtist;
end;
function TBaseApeFile.fGetArtist: UnicodeString;
begin
    result := ApeTag.Artist;
    if result = '' then
        result := fID3v1Tag.Artist;
end;
function TBaseApeFile.fGetGenre: UnicodeString;
begin
    result := ApeTag.Genre;
    if result = '' then
        result := fID3v1Tag.Genre;
end;
function TBaseApeFile.fGetTitle: UnicodeString;
begin
    result := ApeTag.Title;
    if result = '' then
        result := fID3v1Tag.Title;
end;
function TBaseApeFile.fGetTrack: UnicodeString;
begin
    result := ApeTag.Track;
    if result = '' then
        result := fID3v1Tag.Track;
end;
function TBaseApeFile.fGetYear: UnicodeString;
begin
    result := ApeTag.Year;
    if result = '' then
        result := UnicodeString(fID3v1Tag.Year);
end;

{
    ReadAudioDataFromStream
    Read the audio data from a stream
    This should be implemented in derived classes
}
function TBaseApeFile.ReadAudioDataFromStream(aStream: TStream): Boolean;
begin
    fDuration   := 0;
    fBitrate    := 0;
    fSamplerate := 0;
    fChannels   := 0;
    result := True;
end;


function TBaseApeFile.ReadFromFile(aFilename: UnicodeString): TAudioError;
var fs: TAudioFileStream;
begin
    inherited ReadFromFile(aFileName);
    Clear;
    if AudioFileExists(aFilename) then
    begin
        try
            fs := TAudioFileStream.Create(aFilename, fmOpenRead or fmShareDenyWrite);
            try
                fFileSize := fs.Size;

                // Check for an existing ID3v2Tag and get its size
                fID3v2TagSize := GetID3Size(fs);

                // Read the APEv2Tag from the stream
                result := ApeTag.ReadFromStream(fs);

                // no matter what the result is: we may have also already read a raw ID3v1Tag
                if ApeTag.ID3v1Present then
                    fID3v1Tag.CopyFromRawTag(ApeTag.ID3v1TagRaw);

                // Read the Audio Data (duration, bitrate, ) from the file.
                // This should be done in derivate classes
                // TagSizes (all 3) may be needed there
                fs.Seek(fID3v2TagSize, soBeginning);
                ReadAudioDataFromStream(fs);
            finally
                fs.Free;
            end;
        except
            result := FileErr_FileOpenR;
        end;
    end else
        result := FileErr_NoFile;
end;


function TBaseApeFile.WriteToFile(aFilename: UnicodeString): TAudioError;
var TagWritten : Boolean;
    DoWriteV1, DoWriteApe: Boolean;

begin
    inherited WriteToFile(aFilename);
    result := FileErr_None;

    TagWritten := False;
    DoWriteV1  := (mt_ID3v1 in fTagsToBeWritten) or ((mt_Existing in fTagsToBeWritten) and fId3v1Tag.Exists);
    DoWriteApe := (mt_APE in fTagsToBeWritten)   or ((mt_Existing in fTagsToBeWritten) and fApeTag.Exists);

    if DoWriteApe then
    begin
        result := fApeTag.WriteToFile(aFileName);
        TagWritten := True;
    end;
    if DoWriteV1 then
    begin
        result := fId3v1Tag.WriteToFile(aFileName);
        TagWritten := True;
    end;

    if not TagWritten then
    begin
        DoWriteV1  := mt_ID3v1 in fDefaultTags;
        DoWriteApe := mt_APE in fDefaultTags  ;

        if DoWriteApe then
            result := fApeTag.WriteToFile(aFileName);
        if DoWriteV1 then
            result := fId3v1Tag.WriteToFile(aFileName);
    end;
end;

function TBaseApeFile.RemoveFromFile(aFilename: UnicodeString): TAudioError;
begin
    inherited RemoveFromFile(aFilename);

    result := FileErr_None;
    if (mt_Existing in fTagsToBeDeleted) or (mt_ID3v1 in fTagsToBeDeleted) then
      result := fId3v1Tag.RemoveFromFile(aFilename);
    if (mt_Existing in fTagsToBeDeleted) or (mt_APE in fTagsToBeDeleted) then
      result := fApeTag.RemoveFromFile(aFilename);
end;


end.
