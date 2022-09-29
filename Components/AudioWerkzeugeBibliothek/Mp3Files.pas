{
    -----------------------------------
    Audio Werkzeuge Bibliothek
    -----------------------------------
    (c) 2012-2020, Daniel Gaussmann
              Website : www.gausi.de
              EMail   : mail@gausi.de
    -----------------------------------

    Unit MP3Files

    Manipulate mp3-Files
    * Read MPEG information (bitrate, samplerate, ...)
    * Read/Write ID3v1-Tags
    * Read/Write ID3v2-Tags

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

unit Mp3Files;

interface

uses Windows, Messages, SysUtils, StrUtils, Variants, ContNrs, Classes,
     AudioFiles.Base, AudioFiles.Declarations,
     ID3v1Tags, ID3v2Tags, MpegFrames, ID3v2Frames, Apev2Tags;

type

    ///  TTagScanMode
    ///  Purpose is to speed up reading file information while building up a media library (or something like that)
    ///  Often the ID3v1Tag is not needed, as everything is already covered by the ID3v2Tag.
    ///  I assume that file access is the bottleneck, so NOT searching for some more data at the very end of the file
    ///  may increase the overall speed.
    ///  * id3_read_complete : Always check for both versions
    ///  * id3_read_smart    : Check for ID3v2Tag first. If some "relevant data" is missing, try ID3v1tag as well
    ///  * id3_read_v2_only  : read only v2
    ///    (note: only v1 doesn't make much sense for faster reading)
    TTagScanMode = (id3_read_complete, id3_read_smart, id3_read_v2_only );

    ///  Notes:
    ///  - Defining what "relevant data" for "id3_read_smart" means
    ///    All possible fields in the ID3v1-Tag are rather useful and could add something
    ///    useful. However, "Comment" is rarely used. If this is not contained in the v2Tag,
    ///    we should not look for it on v1.
    ///    * use property "SmartRead_IgnoreComment" (default: True)
    ///  - Avoiding inconsistent data
    ///    When reading only one Tag from the file, the internal Tag-Objects for the others
    ///    remains empty. But when we want to change the meta data in the file, it should be
    ///    ensured that these data remains consistently.
    ///    * use private field "v1Processed" , whether we've looked for that Tag in the file.
    ///      The Setter-Methods should check for that, and look after the v1Tag in the file
    ///      by re-reading it
    ///    * To deactivate this feature, use property "SmartRead_AvoidInconsistentData" (default: True)

    TMP3File = class (TBaseAudioFile)
        private
            fID3v1Tag: TID3v1Tag;
            fID3v2Tag: TID3v2Tag;
            fApeTag  : TApeTag;
            fMpegInfo: TMpegInfo;

            fTagScanMode   : TTagScanMode;

            fTagsToBeWritten : TMetaTagSet;
            fDefaultTags     : TMetaTagSet;
            fTagsToBeDeleted : TMetaTagSet;

            fSmartRead_IgnoreComment         : Boolean;
            fSmartRead_AvoidInconsistentData : Boolean;
            fSecondaryTagsProcessed                 : Boolean;

            // a private field for performing a complete analysis in ReadFromFile,
            // including storing all the MPEG-Frames in the fMpegInfo
            ReadWithCompleteAnalysis: Boolean;

            function fGetID3v1Size: Integer;
            function fGetID3v2Size: Integer;
            function fGetApeSize: Integer;

            procedure EnforceSecondaryTagsAreProcessed;
            function SecondaryTagsAreNeeded: Boolean;

            function GetMpegScanMode: TMpegScanMode;
            procedure SetMpegScanMode(const Value: TMpegScanMode);

        protected

            function fGetFileSize   : Int64;    override;
            function fGetDuration   : Integer;  override;
            function fGetBitrate    : Integer;  override;
            function fGetSamplerate : Integer;  override;
            function fGetChannels   : Integer;  override;
            function fGetValid      : Boolean;  override;

            procedure fSetTitle           (aValue: UnicodeString); override;
            procedure fSetArtist          (aValue: UnicodeString); override;
            procedure fSetAlbumArtist     (aValue: UnicodeString); override;
            procedure fSetAlbum           (aValue: UnicodeString); override;
            procedure fSetYear            (aValue: UnicodeString); override;
            procedure fSetTrack           (aValue: UnicodeString); override;
            procedure fSetGenre           (aValue: UnicodeString); override;
            procedure fSetComment         (aValue: UnicodeString);

            function fGetTitle            : UnicodeString; override;
            function fGetArtist           : UnicodeString; override;
            function fGetAlbumArtist      : UnicodeString; override;
            function fGetAlbum            : UnicodeString; override;
            function fGetYear             : UnicodeString; override;
            function fGetTrack            : UnicodeString; override;
            function fGetGenre            : UnicodeString; override;
            function fGetComment          : UnicodeString;

            function fGetFileType            : TAudioFileType; override;
            function fGetFileTypeDescription : String;         override;

        public

            property ID3v1Tag: TID3v1Tag read fID3v1Tag;
            property ID3v2Tag: TID3v2Tag read fID3v2Tag;
            property ApeTag  : TApeTag   read fApeTag  ;
            property MpegInfo: TMpegInfo read fMpegInfo;

            property ID3v1TagSize: Integer read fGetID3v1Size;
            property ID3v2TagSize: Integer read fGetID3v2Size;
            property ApeTagSize  : Integer read fGetApeSize  ;

            // Properties for "smart reading"
            property TagScanMode   : TTagScanMode read fTagScanMode write fTagScanMode;
            property SmartRead_IgnoreComment         : Boolean read fSmartRead_IgnoreComment          write fSmartRead_IgnoreComment;
            property SmartRead_AvoidInconsistentData : Boolean read fSmartRead_AvoidInconsistentData  write fSmartRead_AvoidInconsistentData;
            property SecondaryTagsProcessed          : Boolean read fSecondaryTagsProcessed;

            ///  MpegScanMode: "Fast", "Complete" or "Smart" scan of the file to get Bitrate and Duration
            ///  * MPEG_SCAN_Fast: Scan the first two MPEG-Frames of a file.
            ///        For VBR: Trust in the existence of a valid XING-Header.
            ///  * MPEG_SCAN_Complete: Process to whole file Frame by Frame
            ///  * MPEG_SCAN_Smart: Try a fast scan first. If the result for Bitrate is unusual low
            ///        (i.e. 32 kbit/s or even lower), a complete scan is performed
            property MpegScanMode: TMpegScanMode read GetMpegScanMode write SetMpegScanMode;

            ///  Set of [mt_Existing, mt_ID3v1, mt_ID3v2, mt_APE]
            ///  TagsToBeWritten: Define which Tag(s) should be updated in the file when writing
            ///  DefaultTags: Define which Tag(s) should be written when only [mt_Existing] is selected
            ///               and NO Tag exists at all
            ///  TagsToBeDeleted: define which Tag should be removed by RemoveFromFile
            property TagsToBeWritten : TMetaTagSet read fTagsToBeWritten write fTagsToBeWritten ;
            property DefaultTags     : TMetaTagSet read fDefaultTags     write fDefaultTags     ;
            property TagsToBeDeleted : TMetaTagSet read fTagsToBeDeleted write fTagsToBeDeleted ;

            property Comment: UnicodeString read fGetComment write fSetComment;

            constructor Create; override;
            destructor Destroy; override;

            procedure Clear;
            function ReadFromFile(aFilename: UnicodeString): TAudioError;    override;
            function WriteToFile(aFilename: UnicodeString): TAudioError;     override;
            function RemoveFromFile(aFilename: UnicodeString): TAudioError;  override;

            ///  AnalyseFile: This is only for a low level analysis of the file
            ///               It is mainly used by myself to have a closer look on "odd" mp3 files
            ///               which some properties leading to wrong results in bitrate, duration and stuff.
            function AnalyseFile(aFilename: UnicodeString): TAudioError;

    end;


implementation

{ TMP3File }

procedure TMP3File.Clear;
begin
    fID3v2Tag.Clear;
    fID3v1Tag.Clear;
    ApeTag.Clear;

    FFileSize := 0;

    fDuration   := 0;
    fBitrate    := 0;
    fSamplerate := 0;
    fChannels   := 0;
    fValid      := False;
    fSecondaryTagsProcessed := False;
end;

constructor TMP3File.Create;
begin
    fID3v1Tag := TID3v1Tag.Create;
    fID3v2Tag := TID3v2Tag.Create;
    fMpegInfo := TMpegInfo.create;
    fApeTag   := TApeTag.Create;

    fTagsToBeWritten := [mt_Existing];
    fDefaultTags     := [mt_ID3v1, mt_ID3v2];
    fTagsToBeDeleted := [mt_Existing];

    fTagScanMode :=    id3_read_complete; //id3_read_smart
    fSecondaryTagsProcessed          := False;
    fSmartRead_IgnoreComment         := True;
    fSmartRead_AvoidInconsistentData := True;
    ReadWithCompleteAnalysis         := False;
end;

destructor TMP3File.Destroy;
begin
    fID3v1Tag.Free;
    fID3v2Tag.Free;
    fMpegInfo.Free;
    fApeTag.Free;

    inherited;
end;

procedure TMP3File.EnforceSecondaryTagsAreProcessed;
var fs: TAudioFileStream;
    tmp1: TAudioError;
begin
  if SmartRead_AvoidInconsistentData and (not fSecondaryTagsProcessed) then
  begin
    // try to read the v1Tag from the file
    if AudioFileExists(self.Filename) then
    begin
      try
        fs := TAudioFileStream.Create(self.Filename, fmOpenRead or fmShareDenyWrite);
        try
          tmp1 := ApeTag.ReadFromStream(fs);
          if ApeTag.ID3v1Present then
              fID3v1Tag.CopyFromRawTag(ApeTag.ID3v1TagRaw);
          // if nothing wrong happens there, we will consider the ID3v1Tag "processed"
          fSecondaryTagsProcessed := (tmp1 = FileErr_None);


        finally
          fs.Free;
        end;
      except
        ; //nothing to do. Reading failed (again)
      end;
    end
  end;
end;

function TMP3File.SecondaryTagsAreNeeded: Boolean;
var BasePropertyMissing, CommentMissing: Boolean;
begin
    case fTagScanMode of

        id3_read_complete: result := True;

        id3_read_v2_only: result := False;

        id3_read_smart: begin
            if not ID3v2tag.Exists then
                result := True
            else
            begin
                BasePropertyMissing := (ID3v2tag.Artist = '')
                                OR (ID3v2tag.Title = '')
                                OR (ID3v2tag.Album = '')
                                OR (ID3v2tag.Track = '')
                                OR (ID3v2tag.Year = '')
                                OR (ID3v2tag.Genre = '');
                CommentMissing := (ID3v2tag.Comment = '');

                if fSmartRead_IgnoreComment then
                    result :=  BasePropertyMissing
                else
                  result := BasePropertyMissing or CommentMissing;
            end;
        end;
    else
        result := False;
    end;
end;

function TMP3File.GetMpegScanMode: TMpegScanMode;
begin
    result := fMpegInfo.MpegScanMode;
end;

procedure TMP3File.SetMpegScanMode(const Value: TMpegScanMode);
begin
    fMpegInfo.MpegScanMode := Value;
end;

function TMP3File.fGetFileType: TAudioFileType;
begin
    result := at_Mp3;
end;

function TMP3File.fGetFileTypeDescription: String;
begin
    result := TAudioFileNames[at_Mp3];
end;

function TMP3File.fGetFileSize: Int64;
begin
    result := fFileSize;
end;

function TMP3File.fGetBitrate: Integer;
begin
    result := fBitrate;
end;
function TMP3File.fGetDuration: Integer;
begin
    result := fDuration;
end;
function TMP3File.fGetSamplerate: Integer;
begin
    result := fSamplerate;
end;
function TMP3File.fGetChannels: Integer;
begin
    result := fChannels;
end;

function TMP3File.fGetComment: UnicodeString;
begin
    result := fID3v2tag.Comment;
    if result = '' then
        result := fID3v1Tag.Comment;
    if result = '' then
        result := fApeTag.Comment;
end;

function TMP3File.fGetAlbum: UnicodeString;
begin
    result := fID3v2Tag.Album;
    if result = '' then
        result := fID3v1Tag.Album;
    if result = '' then
        result := fApeTag.Album;
end;
function TMP3File.fGetAlbumArtist: UnicodeString;
begin
  result := fID3v2Tag.AlbumArtist;
  if result = '' then
    result := fApeTag.AlbumArtist;
end;

function TMP3File.fGetArtist: UnicodeString;
begin
    result := fID3v2Tag.Artist;
    if result = '' then
        result := fID3v1Tag.Artist;
    if result = '' then
        result := fApeTag.Artist;
end;
function TMP3File.fGetGenre: UnicodeString;
begin
    result := fID3v2Tag.Genre;
    if result = '' then
        result := fID3v1Tag.Genre;
    if result = '' then
        result := fApeTag.Genre;
end;
function TMP3File.fGetTitle: UnicodeString;
begin
    result := fID3v2Tag.Title;
    if result = '' then
        result := fID3v1Tag.Title;
    if result = '' then
        result := fApeTag.Title;
end;
function TMP3File.fGetTrack: UnicodeString;
begin
    result := fID3v2Tag.Track;
    if result = '' then
        result := fID3v1Tag.Track;
    if result = '' then
        result := fApeTag.Track;
end;
function TMP3File.fGetYear: UnicodeString;
begin
    result := fID3v2Tag.Year;
    if result = '' then
        result := UnicodeString(fID3v1Tag.Year);
    if result = '' then
        result := fApeTag.Year;
end;


procedure TMP3File.fSetAlbum(aValue: UnicodeString);
begin
  inherited;
  EnforceSecondaryTagsAreProcessed;
  fID3v1Tag.Album := aValue;
  fID3v2Tag.Album := aValue;
  fApeTag.Album := aValue;
end;

procedure TMP3File.fSetAlbumArtist(aValue: UnicodeString);
begin
  inherited;
  EnforceSecondaryTagsAreProcessed;
  fID3v2Tag.AlbumArtist := aValue;
  fApeTag.AlbumArtist := aValue;
end;

procedure TMP3File.fSetArtist(aValue: UnicodeString);
begin
  inherited;
  EnforceSecondaryTagsAreProcessed;
  fID3v1Tag.Artist := aValue;
  fID3v2Tag.Artist := aValue;
  fApeTag.Artist := aValue;
end;

procedure TMP3File.fSetComment(aValue: UnicodeString);
begin
  EnforceSecondaryTagsAreProcessed;
  fID3v1Tag.Comment := aValue;
  fID3v2Tag.Comment := aValue;
  fApeTag.Comment := aValue;
end;

procedure TMP3File.fSetGenre(aValue: UnicodeString);
begin
  inherited;
  EnforceSecondaryTagsAreProcessed;
  fID3v1Tag.Genre := aValue;
  fID3v2Tag.Genre := aValue;
  fApeTag.Genre := aValue;
end;

procedure TMP3File.fSetTitle(aValue: UnicodeString);
begin
  inherited;
  EnforceSecondaryTagsAreProcessed;
  fID3v1Tag.Title := aValue;
  fID3v2Tag.Title := aValue;
  fApeTag.Title := aValue;
end;

procedure TMP3File.fSetTrack(aValue: UnicodeString);
begin
  inherited;
  EnforceSecondaryTagsAreProcessed;
  fID3v1Tag.Track := aValue;
  fID3v2Tag.Track := aValue;
  fApeTag.Track := aValue;
end;

procedure TMP3File.fSetYear(aValue: UnicodeString);
begin
  inherited;
  EnforceSecondaryTagsAreProcessed;
  fID3v1Tag.Year := ShortString(aValue);
  fID3v2Tag.Year := aValue;
  fApeTag.Year := aValue;
end;

function TMP3File.fGetID3v1Size: Integer;
begin
    if fId3v1Tag.Exists then
        result := 128
    else
        result := 0;
end;
function TMP3File.fGetID3v2Size: Integer;
begin
    if fID3v2Tag.Exists then
        result := fId3v2Tag.Size
    else
        result := 0;
end;
function TMP3File.fGetApeSize: Integer;
begin
    if fApeTag.Exists then
        result := fApeTag.Apev2TagSize
    else
        result := 0;
end;


function TMP3File.fGetValid: Boolean;
begin
    result := fValid;
end;


function TMP3File.ReadFromFile(aFilename: UnicodeString): TAudioError;
var fs: TAudioFileStream;
    tmp1, tmp2, tmpMpeg: TAudioError;
begin
    inherited ReadFromFile(aFilename);

    Clear;
    if AudioFileExists(aFilename) then
    begin
        try
            fs := TAudioFileStream.Create(aFilename, fmOpenRead or fmShareDenyWrite);
            try
                fFileSize := fs.Size;

                // Read ID3v2-Tag
                tmp2 := id3v2tag.ReadFromStream(fs);
                if fID3v2Tag.exists then
                    fs.Seek(id3v2tag.size, soBeginning)
                else
                    fs.Seek(0, sobeginning);

                // Read MPEG-Information
                if ReadWithCompleteAnalysis then
                    tmpMpeg := fMpegInfo.StoreFrames(fs)
                else
                    tmpMpeg := fMpegInfo.LoadFromStream(fs);

                // Read ID3v1-Tag and APE
                if SecondaryTagsAreNeeded or ReadWithCompleteAnalysis then
                begin
                    tmp1 := ApeTag.ReadFromStream(fs);
                    if ApeTag.ID3v1Present then
                        fID3v1Tag.CopyFromRawTag(ApeTag.ID3v1TagRaw);
                    fSecondaryTagsProcessed := True;
                end
                else
                    tmp1 := FileErr_None;

                // summarize
                result := tmpMpeg;
                if result = FileErr_None then
                    result := tmp2;
                if result = FileErr_None then
                    result := tmp1;

                fValid := tmpMpeg = FileErr_None;
                if fValid then
                begin
                    fDuration    := fMpegInfo.Duration;
                    fBitrate     := fMpegInfo.Bitrate * 1000;
                    fSamplerate  := fMpegInfo.Samplerate;
                    case fMpegInfo.Channelmode of
                        0: fChannels := 2;
                        1: fChannels := 2;
                        2: fChannels := 2;
                        3: fChannels := 1;
                    else
                         fChannels := 0;
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
end;


function TMP3File.AnalyseFile(aFilename: UnicodeString): TAudioError;
begin
    ReadWithCompleteAnalysis := True;
    result := ReadFromFile(aFileName);
    ReadWithCompleteAnalysis := False;
end;


function TMP3File.RemoveFromFile(aFilename: UnicodeString): TAudioError;
begin
    inherited RemoveFromFile(aFilename);
    result := FileErr_None;

    if (mt_Existing in fTagsToBeDeleted) or (mt_ID3v1 in fTagsToBeDeleted) then
      result := fId3v1Tag.RemoveFromFile(aFilename);
    if (mt_Existing in fTagsToBeDeleted) or (mt_APE in fTagsToBeDeleted) then
      result := fApeTag.RemoveFromFile(aFilename);
    if (mt_Existing in fTagsToBeDeleted) or (mt_ID3v2 in fTagsToBeDeleted) then
      result := fId3v2Tag.RemoveFromFile(aFilename);
end;

function TMP3File.WriteToFile(aFilename: UnicodeString): TAudioError;
var TagWritten: Boolean;
  DoWriteV1, DoWriteV2, DoWriteApe: Boolean;
begin
    inherited WriteToFile(aFilename);
    result := FileErr_None;

    TagWritten := False;
    DoWriteV1  := (mt_ID3v1 in fTagsToBeWritten) or ((mt_Existing in fTagsToBeWritten) and fId3v1Tag.Exists);
    DoWriteV2  := (mt_ID3v2 in fTagsToBeWritten) or ((mt_Existing in fTagsToBeWritten) and fId3v2Tag.Exists);
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
    if DoWriteV2 then
    begin
        result := fId3v2Tag.WriteToFile(aFileName);
        TagWritten := True;
    end;

    if not TagWritten then
    begin
        DoWriteV1  := mt_ID3v1 in fDefaultTags;
        DoWriteV2  := mt_ID3v2 in fDefaultTags;
        DoWriteApe := mt_APE in fDefaultTags  ;

        if DoWriteApe then
            result := fApeTag.WriteToFile(aFileName);
        if DoWriteV1 then
            result := fId3v1Tag.WriteToFile(aFileName);
        if DoWriteV2 then
            result := fId3v2Tag.WriteToFile(aFileName);
    end;
end;


end.
