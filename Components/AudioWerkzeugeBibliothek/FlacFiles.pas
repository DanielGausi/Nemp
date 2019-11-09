{
    -----------------------------------
    Audio Werkzeuge Bibliothek
    -----------------------------------
    (c) 2010-2012, Daniel Gaussmann
                   Website : www.gausi.de
                   EMail   : mail@gausi.de
    -----------------------------------

    Unit FlacFiles

    Manipulate *.flac files

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

unit FlacFiles;

{$I config.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, ContNrs, Classes
  {$IFDEF USE_SYSTEM_TYPES}, System.Types{$ENDIF}
  , AudioFileBasics, VorbisComments, Id3Basics , winsock;

const
    FLAC_MARKER = 'fLaC';

    Picture_Types: Array[0..20] of string =
          (	'Other',
            '32x32 pixels file icon (PNG only)',
            'Other file icon',
            'Cover (front)',
            'Cover (back)',
            'Leaflet page',
            'Media (e.g. lable side of CD)',
            'Lead artist/lead performer/soloist',
            'Artist/performer',
            'Conductor',
            'Band/Orchestra',
            'Composer',
            'Lyricist/text writer',
            'Recording Location',
            'During recording',
            'During performance',
            'Movie/video screen capture',
            'A bright coloured fish',
            'Illustration',
            'Band/artist logotype',
            'Publisher/Studio logotype' );


//type

    {TFlacError = (FlacErr_None, FlacErr_NoFile, FlacErr_FileCreate,
          FlacErr_FileOpenR, FlacErr_FileOpenRW,
          FlacErr_InvalidFlacFile,
          FlacErr_MetaDataTooLarge,
          FlacErr_BackupFailed,
          FlacErr_DeleteBackupFailed);  }
  {
const
      FlacErrorErrorString: Array[TFlacError] of String =
  ( 'No Error',
    'File not found',
    'FileCreate failed.',
    'FileOpenRead failed',
    'FileOpenReadWrite failed',
    'Invalid Flac File',
    'Metadata-Block exceeds maximum size',
    'Backup failed',
    'Delete backup failed'
  );       }

type
    TMetaDataBlockHeader = array[1..4] of Byte;
    TMetaDataBlockData = Array of Byte;

    TFlacHeader = packed record
        StreamMarker: array[1..4] of AnsiChar;     //should always be 'fLaC'
        MetaDataBlockHeader: TMetaDataBlockHeader; // the header of the METADATA_BLOCK_STREAMINFO
        Info: array[1..18] of Byte;                // content of the METADATA_BLOCK_STREAMINFO
        MD5Sum: array[1..16] of Byte;              // (---- " ---)
    end;

    // Basic-Class for Metadata-Blocks
    TFlacMetaBlock = class
        private
            fHeader: TMetaDataBlockHeader;           // Store the Header
            fData: TMetaDataBlockData;               // ... the data
            fPositionInStream: Int64;

            function fGetDataSize: Cardinal;          // compute DataSize from the Header
            procedure fSetDataSize(aSize: Cardinal);  // Set the Size in the Header
            function fGetLastBlock: Boolean;         // get/set the Bit indicating, whether
            procedure fSetLastBlock(Value: Boolean); // this is the last MetaBlock or not
            procedure fCopyHeader(aSourceHeader: TMetaDataBlockHeader);
            function fGetBlockType: Byte;
            procedure fSetBlockType(value: Byte);

        public
            property BlockType: Byte read fGetBlockType write fSetBlockType;
            property LastBlockInFile: Boolean read fGetLastBlock write fSetLastBlock;

            // read Data from the Stream. Ancestors should overwrite this method
            // to parse the data properly
            function ReadFromStream(aSourceHeader: TMetaDataBlockHeader; Source: TStream): Boolean; virtual;
            // write it into a Stream
            function WriteToStream(Destination: TStream): Boolean; virtual;
    end;

    TFlacCommentsBlock = class (TFlacMetaBlock)
        private
            Comments: TVorbisComments;
        public
            constructor Create;
            destructor Destroy; override;
            procedure Clear;
            function IsEmpty: Boolean;
            function ReadFromStream(aSourceHeader: TMetaDataBlockHeader; Source: TStream): Boolean; override;
            function WriteToStream(Destination: TStream): Boolean; override;
    end;

    TFlacPictureBlock = class (TFlacMetaBlock)
        private
            fPictureType: Cardinal;
            fMime: AnsiString;
            fDescription: Utf8String;
            fWidth         : Cardinal;
            fHeight        : Cardinal;
            fColorDepth    : Cardinal;
            fNumberOfColors: Cardinal;
            fPicData: TMemoryStream;
            function fGetDescription: UnicodeString;
            procedure fSetDescription(value: UnicodeString);
            function fCalculateBlockSize: Cardinal;
        public
            property PictureType: Cardinal read fPictureType write fPictureType;
            property Mime: AnsiString read fMime write fMime;
            property Description: UnicodeString read fGetDescription write fSetDescription;
            property Width         : Cardinal read fWidth          write fWidth          ;
            property Height        : Cardinal read fHeight         write fHeight         ;
            property ColorDepth    : Cardinal read fColorDepth     write fColorDepth     ;
            property NumberOfColors: Cardinal read fNumberOfColors write fNumberOfColors ;

            constructor Create;
            destructor Destroy; override;
            procedure Clear;
            function IsEmpty: Boolean;

            procedure CopyPicData(Target: TStream);
            function ReadFromStream(aSourceHeader: TMetaDataBlockHeader; Source: TStream): Boolean; override;
            function WriteToStream(Destination: TStream): Boolean; override;
    end;
 
    TFlacFile = class(TBaseAudioFile)
        private

            fHeader: TFlacHeader;

            fBitsPerSample: Byte;
            fSamples      : Int64;

            fUsePadding   : Boolean;
            fAudioOffset  : Integer; // the position in the file where the Audiodata begins
            fFlacOffset   : Integer; // the beginning of the flac file (> 0 if id3tag is present)

            fMetaBlocks: TObjectList;
            fFlacCommentsBlock: TFlacCommentsBlock;

            //function fGetTitle       : UnicodeString;
            function fGetVersion     : UnicodeString;
            //function fGetAlbum       : UnicodeString;
            //function fGetTrackNumber : UnicodeString;
            //function fGetArtist      : UnicodeString;
            function fGetPerformer   : UnicodeString;
            function fGetCopyright   : UnicodeString;
            function fGetLicense     : UnicodeString;
            function fGetOrganization: UnicodeString;
            function fGetDescription : UnicodeString;
            //function fGetGenre       : UnicodeString;
            //function fGetDate        : UnicodeString;
            function fGetLocation    : UnicodeString;
            function fGetContact     : UnicodeString;
            function fGetISRC        : UnicodeString;

            //procedure fSetTitle       (value: UnicodeString);
            procedure fSetVersion     (value: UnicodeString);
            //procedure fSetAlbum       (value: UnicodeString);
            //procedure fSetTrackNumber (value: UnicodeString);
            //procedure fSetArtist      (value: UnicodeString);
            procedure fSetPerformer   (value: UnicodeString);
            procedure fSetCopyright   (value: UnicodeString);
            procedure fSetLicense     (value: UnicodeString);
            procedure fSetOrganization(value: UnicodeString);
            procedure fSetDescription (value: UnicodeString);
            //procedure fSetGenre       (value: UnicodeString);
            //procedure fSetDate        (value: UnicodeString);
            procedure fSetLocation    (value: UnicodeString);
            procedure fSetContact     (value: UnicodeString);
            procedure fSetISRC        (value: UnicodeString);

            procedure ClearData;
            procedure ValidateFlacCommentsBlock;
            function fIsValid: Boolean;

            function fGetArbitraryPictureBlock: TFlacPictureBlock;
            function PrepareDataToWrite(tmpFlacFile: TFlacFile; BufferStream: TStream; aFilename: String): TAudioError;
            function BackupAudioData(source: TStream; BackUpFilename: UnicodeString): TAudioError;
            function AppendBackup(Destination: TStream; BackUpFilename: UnicodeString): TAudioError;

        protected
            //function fGetDuration: Integer; override

            function fGetFileSize   : Int64;    override;
            function fGetDuration   : Integer;  override;
            function fGetBitrate    : Integer;  override;
            function fGetSamplerate : Integer;  override;
            function fGetChannels   : Integer;  override;
            function fGetValid      : Boolean;  override;

            procedure fSetTitle  (Value: UnicodeString); override;
            procedure fSetArtist (Value: UnicodeString); override;
            procedure fSetAlbum  (Value: UnicodeString); override;
            procedure fSetYear   (Value: UnicodeString); override;
            procedure fSetTrack  (Value: UnicodeString); override;
            procedure fSetGenre  (Value: UnicodeString); override;

            function fGetTitle   : UnicodeString; override;
            function fGetArtist  : UnicodeString; override;
            function fGetAlbum   : UnicodeString; override;
            function fGetYear    : UnicodeString; override;
            function fGetTrack   : UnicodeString; override;
            function fGetGenre   : UnicodeString; override;

        public
            property UsePadding: Boolean read fUsePadding write fUsePadding;

            //property Title       : UnicodeString read fGetTitle        write fSetTitle       ;
            property Version     : UnicodeString read fGetVersion      write fSetVersion     ;
            //property Album       : UnicodeString read fGetAlbum        write fSetAlbum       ;
            //property TrackNumber : UnicodeString read fGetTrackNumber  write fSetTrackNumber ;
            //property Artist      : UnicodeString read fGetArtist       write fSetArtist      ;
            property Performer   : UnicodeString read fGetPerformer    write fSetPerformer   ;
            property Copyright   : UnicodeString read fGetCopyright    write fSetCopyright   ;
            property License     : UnicodeString read fGetLicense      write fSetLicense     ;
            property Organization: UnicodeString read fGetOrganization write fSetOrganization;
            property Description : UnicodeString read fGetDescription  write fSetDescription ;
            //property Genre       : UnicodeString read fGetGenre        write fSetGenre       ;
            //property Date        : UnicodeString read fGetDate         write fSetDate        ;
            property Location    : UnicodeString read fGetLocation     write fSetLocation    ;
            property Contact     : UnicodeString read fGetContact      write fSetContact     ;
            property ISRC        : UnicodeString read fGetISRC         write fSetISRC        ;

            constructor Create;
            destructor Destroy; override;

            function ReadFromStream(fs: TStream): TAudioError;
            function ReadFromFile(aFilename: UnicodeString): TAudioError; override;
            function WriteToFile(aFilename: UnicodeString): TAudioError;  override;
            function RemoveFromFile(aFilename: UnicodeString): TAudioError;  override;

            // Get/Set an arbitrary Picture (the one with front-cover will be preferred )
            function GetPictureStream(Destination: TStream;
                                        var aPicType: Cardinal;
                                        var aMime: AnsiString;
                                        var aDescription: UnicodeString): Boolean;
            procedure SetPicture(Source: TStream; aMime: AnsiString;      // set a Picture
                  aDescription: UnicodeString);                           // use Source=NIL, to delete the picture

            // Get all Picture-Blocks from the List of Metablocks and add them into the Targetlist
            procedure GetAllPictureBlocks(aTarget: TObjectList);
            // Add a new Picture
            procedure AddPicture(Source: TStream; aType: Cardinal; aMime: AnsiString;
                  aDescription: UnicodeString);
            // Delete a specified Picture
            procedure DeletePicture(aFlacPictureBlock: TFlacPictureBlock);

            function GetPropertyByFieldname(aField: String): UnicodeString;
            function SetPropertyByFieldname(aField: String; aValue: UnicodeString): Boolean;

            // Get All FieldNames in the CommentVectorList
            procedure GetAllFields(Target: TStrings);
            // Give Access to these Fields (note: Fieldnames dont have to be unique)
            function GetPropertyByIndex(aIndex: Integer): UnicodeString;
            function SetPropertyByIndex(aIndex: Integer; aValue: UnicodeString): Boolean;
    end;


implementation


function IsMetaBlockLastBlock(aHeader: TMetaDataBlockHeader): Boolean;
begin
    result := (aHeader[1] and $80) = $80;
end;

procedure SetMetaBlockLastBlock(aHeader: TMetaDataBlockHeader; LastBlock: Boolean);
begin
    if LastBlock then
        aHeader[1] := aHeader[1] or $80  // set the first Bit
    else
        aHeader[1] := aHeader[1] and $7F // unset the first Bit
end;


function MetaType(aHeader: TMetaDataBlockHeader): Byte;
begin
    result := aHeader[1] and $7F; // the Type is determined by the last 7 bits
end;

// In FlacFiles, all Integers (except in the Comments) are stored BigEndian
// We need to convert them to LittleEndian
function ReadBigEndianCardinal(source: TStream): Cardinal;
begin
    Source.Read(result, SizeOf(result));
    result := ntohl(result);
end;

procedure WriteBigEndianCardinal(Destination: TStream; value: Cardinal);
var x: Cardinal;
begin
    x := htonl(value);
    Destination.Write(x, sizeOf(value));
end;

//--------------------------------------------------------------------
// Get a "reasonable" padding-size (i.e.: fill the last used cluster)
//--------------------------------------------------------------------
function GetPaddingSize(DataSize: Int64; aFilename: UnicodeString; UseClusterSize: Boolean): Cardinal;
var
   Drive: string;
   ClusterSize           : Cardinal;
   SectorPerCluster      : Cardinal;
   BytesPerSector        : Cardinal;
   NumberOfFreeClusters  : Cardinal;
   TotalNumberOfClusters : Cardinal;
begin
  Drive := ExtractFileDrive(aFileName);
  if UseClusterSize and (trim(Drive) <> '')then
  begin
      if Drive[Length(Drive)]<>'\' then Drive := Drive+'\';
      try
          if GetDiskFreeSpace(PChar(Drive),
                              SectorPerCluster,
                              BytesPerSector,
                              NumberOfFreeClusters,
                              TotalNumberOfClusters) then
            ClusterSize := SectorPerCluster * BytesPerSector
          else
            ClusterSize := 2048;
      except
        ClusterSize := 2048;
      end;
  end else
    ClusterSize := 2048;
  Result := (((DataSize DIV ClusterSize) + 1) * Clustersize) - DataSize;
end;


{ TFlacMetaBlock }

function TFlacMetaBlock.fGetBlockType: Byte;
begin
    result := MetaType(fHeader);
end;

function TFlacMetaBlock.fGetDataSize: Cardinal;
begin
    result := fHeader[2] * 65536
            + fHeader[3] * 256
            + fHeader[4];
end;

procedure TFlacMetaBlock.fSetDataSize(aSize: Cardinal);
begin
    fHeader[2] := aSize Div 65536;
    aSize := aSize Mod 65536;
    fHeader[3] := aSize Div 256;
    aSize := aSize Mod 256;
    fHeader[4] := aSize;
end;

function TFlacMetaBlock.fGetLastBlock: Boolean;
begin
    result := IsMetaBlockLastBlock(fHeader);  // = (fHeader[1] and $80) = 1;
end;

procedure TFlacMetaBlock.fSetBlockType(value: Byte);
begin
    if value >= 127 then  // however, only values of 1..6 should be set
        value := 126;

    if self.LastBlockInFile then
        fHeader[1] := 128 + value
    else
        fHeader[1] := value;
end;

procedure TFlacMetaBlock.fSetLastBlock(Value: Boolean);
begin
    if Value then
        fHeader[1] := fHeader[1] or $80  // set the first Bit
    else
        fHeader[1] := fHeader[1] and $7F // unset the first Bit
end;

procedure TFlacMetaBlock.fCopyHeader(aSourceHeader: TMetaDataBlockHeader);
begin
    fHeader[1] := aSourceHeader[1];
    fHeader[2] := aSourceHeader[2];
    fHeader[3] := aSourceHeader[3];
    fHeader[4] := aSourceHeader[4];
end;

function TFlacMetaBlock.ReadFromStream(aSourceHeader: TMetaDataBlockHeader; Source: TStream): Boolean;
var c, d: Integer;
begin
    fPositionInStream := Source.Position - 4;
    // Copy the Header-Information
    fCopyHeader(aSourceHeader);
    // read Data from Stream
    c := fGetDataSize;
    SetLength(fData, c);
    d := Source.Read(fData[0], c);
    result := c=d;
end;

function TFlacMetaBlock.WriteToStream(Destination: TStream): Boolean;
var d: Integer;
begin
    // write Header
    Destination.Write(fHeader[1], 4);
    // write Data
    d := Destination.Write(fData[0], length(fData));
    result := d = length(fData);


end;

{ TFlacCommentsBlock }


constructor TFlacCommentsBlock.Create;
begin
    BlockType := 4;
    Comments := TVorbisComments.Create;
end;

destructor TFlacCommentsBlock.Destroy;
begin
    Comments.Free;
    inherited;
end;


procedure TFlacCommentsBlock.Clear;
begin
    // Delete Comments
    Comments.Clear;
end;

function TFlacCommentsBlock.IsEmpty: Boolean;
var sl: TStrings;
begin
    sl := TStringList.Create;
    try
        Comments.GetAllFields(sl);
        result := sl.Count = 0;
    finally
        sl.free;
    end;
end;

function TFlacCommentsBlock.ReadFromStream(aSourceHeader: TMetaDataBlockHeader;
  Source: TStream): Boolean;
begin
    fPositionInStream := Source.Position - 4;
    // Copy the Header-Information
    fCopyHeader(aSourceHeader);
    result := Comments.ReadFromStream(Source, fGetDataSize, True);
end;

function TFlacCommentsBlock.WriteToStream(Destination: TStream): Boolean;
var currentPos, posAfterHeader, posAfterData: Int64;
begin
    currentPos := Destination.Position;

    // write Header
    Destination.Write(fHeader[1], 4);
    posAfterHeader := Destination.Position;

    // write Data
    result := Comments.WriteToStream(Destination, True);
    posAfterData := Destination.Position;

    // set size of the written data in the Header
    fSetDataSize(posAfterData - posAfterHeader);

    // rewrite Header
    Destination.Position := (currentPos);
    Destination.Write(fHeader[1], 4);

    // seek to the end of the data
    Destination.Position := posAfterData;


end;


{ TFlacPictureBlock }

constructor TFlacPictureBlock.Create;
begin
    fPicData := TMemoryStream.Create;
    BlockType := 6;
    Mime := '';
    Description := '';
    fWidth         := 0;
    fHeight        := 0;
    fColorDepth    := 0;
    fNumberOfColors:= 0;
end;

destructor TFlacPictureBlock.Destroy;
begin
    fPicData.Free;
    inherited;
end;

procedure TFlacPictureBlock.Clear;
begin
    fPicData.Clear;
    Mime := '';
    Description    := '';
    fWidth         := 0;
    fHeight        := 0;
    fColorDepth    := 0;
    fNumberOfColors:= 0;
end;

function TFlacPictureBlock.IsEmpty: Boolean;
begin
    result := fPicData.Size = 0;
end;

function TFlacPictureBlock.fGetDescription: UnicodeString;
begin
    {$IFDEF UNICODE}
        result := UnicodeString(fDescription);
    {$ELSE}
        result := UTF8Decode(fDescription);
    {$ENDIF}
end;

procedure TFlacPictureBlock.fSetDescription(value: UnicodeString);
begin
    {$IFDEF UNICODE}
        fDescription := Utf8String(value);
    {$ELSE}
        fDescription := UTF8Encode(value);
    {$ENDIF}
end;

procedure TFlacPictureBlock.CopyPicData(Target: TStream);
begin
    Target.CopyFrom(fPicData, 0);
end;

function TFlacPictureBlock.ReadFromStream(aSourceHeader: TMetaDataBlockHeader;
  Source: TStream): Boolean;
var mimeLength, descLength, picSize: Cardinal;
begin
    fPositionInStream := Source.Position - 4;
    // Copy the Header-Information
    fCopyHeader(aSourceHeader);
    // read Data from Stream

    // 1. Picture-Type
    fPictureType := ReadBigEndianCardinal(Source);
    // 2. Mime-type
    mimeLength := ReadBigEndianCardinal(Source);
    SetLength(fMime, mimeLength);
    Source.Read(fMime[1], mimeLength);
    // 3. Description
    descLength := ReadBigEndianCardinal(Source);
    SetLength(fDescription, descLength);
    Source.Read(fDescription[1], descLength);
    // 4. Some data about the Picture
    fWidth          := ReadBigEndianCardinal(Source);
    fHeight         := ReadBigEndianCardinal(Source);
    fColorDepth     := ReadBigEndianCardinal(Source);
    fNumberOfColors := ReadBigEndianCardinal(Source);
    // 5. Picture Data
    picSize := ReadBigEndianCardinal(Source);
    fPicData.Clear;
    fPicData.CopyFrom(Source, PicSize);
    result := True;
end;

function TFlacPictureBlock.WriteToStream(Destination: TStream): Boolean;
begin
    // correct the Header (should not be necessary, as we do this in TFlacFile.SetPicture)
    fSetDataSize(fCalculateBlockSize);

    // write Header
    Destination.Write(fHeader[1], 4);

    // 1. Picture-Type
    WriteBigEndianCardinal(Destination, fPictureType);
    // 2. Mime-type
    WriteBigEndianCardinal(Destination, length(fMime));
    Destination.Write(fMime[1], length(fMime));
    // 3. Description
    WriteBigEndianCardinal(Destination, length(fDescription));
    Destination.Write(fDescription[1], length(fDescription));
    // 4. Some data about the Picture
    WriteBigEndianCardinal(Destination, fWidth         );
    WriteBigEndianCardinal(Destination, fHeight        );
    WriteBigEndianCardinal(Destination, fColorDepth    );
    WriteBigEndianCardinal(Destination, fNumberOfColors);
    // 5. Picture Data
    WriteBigEndianCardinal(Destination, fPicData.Size);
    Destination.CopyFrom(fPicData, 0);
    result := True;


end;




{ TFlacFile }

constructor TFlacFile.Create;
begin
    fMetaBlocks := TObjectList.Create;
    fUsePadding := True;
    ClearData;
end;

destructor TFlacFile.Destroy;
begin
    fMetaBlocks.Free;
    inherited;
end;

function TFlacFile.fGetAlbum: UnicodeString;
begin
    ValidateFlacCommentsBlock;
    result := fFlacCommentsBlock.Comments.Album;
end;
function TFlacFile.fGetArtist: UnicodeString;
begin
    ValidateFlacCommentsBlock;
    result := fFlacCommentsBlock.Comments.Artist;
end;
function TFlacFile.fGetContact: UnicodeString;
begin
    ValidateFlacCommentsBlock;
    result := fFlacCommentsBlock.Comments.Contact;
end;
function TFlacFile.fGetCopyright: UnicodeString;
begin
    ValidateFlacCommentsBlock;
    result := fFlacCommentsBlock.Comments.Copyright;
end;
function TFlacFile.fGetYear: UnicodeString;
begin
    ValidateFlacCommentsBlock;
    result := fFlacCommentsBlock.Comments.Date;
end;
function TFlacFile.fGetDescription: UnicodeString;
begin
    result := fFlacCommentsBlock.Comments.Description;
end;
function TFlacFile.fGetGenre: UnicodeString;
begin
    ValidateFlacCommentsBlock;
    result := fFlacCommentsBlock.Comments.Genre;
end;
function TFlacFile.fGetISRC: UnicodeString;
begin
    ValidateFlacCommentsBlock;
    result := fFlacCommentsBlock.Comments.ISRC;
end;
function TFlacFile.fGetLicense: UnicodeString;
begin
    ValidateFlacCommentsBlock;
    result := fFlacCommentsBlock.Comments.License;
end;
function TFlacFile.fGetLocation: UnicodeString;
begin
    ValidateFlacCommentsBlock;
    result := fFlacCommentsBlock.Comments.Location;
end;
function TFlacFile.fGetOrganization: UnicodeString;
begin
    ValidateFlacCommentsBlock;
    result := fFlacCommentsBlock.Comments.Organization;
end;
function TFlacFile.fGetPerformer: UnicodeString;
begin
    ValidateFlacCommentsBlock;
    result := fFlacCommentsBlock.Comments.Performer;
end;
function TFlacFile.fGetTitle: UnicodeString;
begin
    ValidateFlacCommentsBlock;
    result := fFlacCommentsBlock.Comments.Title;
end;
function TFlacFile.fGetTrack: UnicodeString;
begin
    ValidateFlacCommentsBlock;
    result := fFlacCommentsBlock.Comments.TrackNumber;
end;
function TFlacFile.fGetVersion: UnicodeString;
begin
    ValidateFlacCommentsBlock;
    result := fFlacCommentsBlock.Comments.Version;
end;


procedure TFlacFile.fSetAlbum(value: UnicodeString);
begin
    ValidateFlacCommentsBlock;
    fFlacCommentsBlock.Comments.Album := value;
end;
procedure TFlacFile.fSetArtist(value: UnicodeString);
begin
    ValidateFlacCommentsBlock;
    fFlacCommentsBlock.Comments.Artist := value;
end;
procedure TFlacFile.fSetContact(value: UnicodeString);
begin
    ValidateFlacCommentsBlock;
    fFlacCommentsBlock.Comments.Contact := value;
end;
procedure TFlacFile.fSetCopyright(value: UnicodeString);
begin
    ValidateFlacCommentsBlock;
    fFlacCommentsBlock.Comments.Copyright := value;
end;
procedure TFlacFile.fSetYear(value: UnicodeString);
begin
    ValidateFlacCommentsBlock;
    fFlacCommentsBlock.Comments.Date := value;
end;
procedure TFlacFile.fSetDescription(value: UnicodeString);
begin
    ValidateFlacCommentsBlock;
    fFlacCommentsBlock.Comments.Description := value;
end;
procedure TFlacFile.fSetGenre(value: UnicodeString);
begin
    ValidateFlacCommentsBlock;
    fFlacCommentsBlock.Comments.Genre := value;
end;
procedure TFlacFile.fSetISRC(value: UnicodeString);
begin
    ValidateFlacCommentsBlock;
    fFlacCommentsBlock.Comments.ISRC := value;
end;
procedure TFlacFile.fSetLicense(value: UnicodeString);
begin
    ValidateFlacCommentsBlock;
    fFlacCommentsBlock.Comments.License := value;
end;
procedure TFlacFile.fSetLocation(value: UnicodeString);
begin
    ValidateFlacCommentsBlock;
    fFlacCommentsBlock.Comments.Location := value;
end;
procedure TFlacFile.fSetOrganization(value: UnicodeString);
begin
    ValidateFlacCommentsBlock;
    fFlacCommentsBlock.Comments.Organization := value;
end;
procedure TFlacFile.fSetPerformer(value: UnicodeString);
begin
    ValidateFlacCommentsBlock;
    fFlacCommentsBlock.Comments.Performer := value;
end;
procedure TFlacFile.fSetTitle(value: UnicodeString);
begin
    ValidateFlacCommentsBlock;
    fFlacCommentsBlock.Comments.Title := value;
end;
procedure TFlacFile.fSetTrack(value: UnicodeString);
begin
    ValidateFlacCommentsBlock;
    fFlacCommentsBlock.Comments.TrackNumber := value;
end;
procedure TFlacFile.fSetVersion(value: UnicodeString);
begin
    ValidateFlacCommentsBlock;
    fFlacCommentsBlock.Comments.Version := value;
end;
procedure TFlacFile.GetAllFields(Target: TStrings);
begin
    ValidateFlacCommentsBlock;
    fFlacCommentsBlock.Comments.GetAllFields(Target);
end;

function TFlacFile.fGetArbitraryPictureBlock: TFlacPictureBlock;
var i: Integer;
    tmpPicBlock: TFlacPictureBlock;
    arbitraryPicFound: Boolean;
begin
    result := Nil;
    arbitraryPicFound := False;
    for i := 0 to self.fMetaBlocks.Count - 1 do
    begin
        if TFlacMetaBlock(fMetaBlocks[i]).BlockType = 6 then
        begin
            if not arbitraryPicFound then
                result := TFlacPictureBlock(fMetaBlocks[i])
            else
            begin
                tmpPicBlock := TFlacPictureBlock(fMetaBlocks[i]);
                if (result.PictureType <> 3) and (tmpPicBlock.PictureType = 3) then
                begin
                    result := tmpPicBlock;
                end;
            end;
            arbitraryPicFound := True;
        end;
    end;

end;

function TFlacFile.GetPictureStream(Destination: TStream;
                                        var aPicType: Cardinal;
                                        var aMime: AnsiString;
                                        var aDescription: UnicodeString): Boolean;
var picBlock: TFlacPictureBlock;
begin
    picBlock := fGetArbitraryPictureBlock;

    if assigned(picBlock) then
    begin
        Destination.CopyFrom(picBlock.fPicData, 0);
        aPicType := picBlock.PictureType;
        aMime := picBlock.Mime;
        aDescription := picBlock.Description;
        result := True;
    end
    else
    begin
        aPicType := 0;
        aMime := '';
        aDescription := '';
        result := False;
    end;
end;

procedure TFlacFile.GetAllPictureBlocks(aTarget: TObjectList);
var i: Integer;
begin
    aTarget.Clear;
    for i := 0 to self.fMetaBlocks.Count - 1 do
    begin
        if TFlacMetaBlock(fMetaBlocks[i]).BlockType = 6 then
            aTarget.Add(fMetaBlocks[i]);
    end;
end;

procedure TFlacFile.DeletePicture(aFlacPictureBlock: TFlacPictureBlock);
begin
    fMetaBlocks.Remove(aFlacPictureBlock);
end;

procedure TFlacFile.AddPicture(Source: TStream; aType: Cardinal; aMime: AnsiString;
                  aDescription: UnicodeString);
var picBlock: TFlacPictureBlock;
begin
    if (8*4 + length(aMime)
        + length(aDescription)
        + Source.Size) <=  256*256*256
    then
    begin
        if assigned(Source) and (Source.Size > 0) then
        begin
            picBlock := TFlacPictureBlock.Create;
            fMetaBlocks.Add(picBlock);

            if aType > 20 then
                aType := 0; // "Other"

            picBlock.fPictureType := aType;

            picBlock.Mime        := aMime;
            picBlock.Description := aDescription;
            picBlock.fWidth         := 0;
            picBlock.fHeight        := 0;
            picBlock.fColorDepth    := 0;
            picBlock.fNumberOfColors:= 0;

            picBlock.fPicData.Clear;
            picBlock.fPicData.CopyFrom(Source, 0);

            // Set size-Info in the Header
            picBlock.fSetDataSize(picBlock.fCalculateBlockSize);
        end; // else: nothing to do
    end
    else
    begin
        raise Exception.Create('Maximum picture size exceeded: Datasize > 16MiB.');
    end;
end;

function TFlacPictureBlock.fCalculateBlockSize: Cardinal;
begin
    result := 8*4 // the Integers/lengths stored in the block
        + length(fMime)
        + length(fDescription)
        + fPicData.Size;
end;

procedure TFlacFile.SetPicture(Source: TStream; aMime: AnsiString; aDescription: UnicodeString);
var picBlock: TFlacPictureBlock;
begin
    if (8*4 + length(aMime)
        + length(aDescription)
        + Source.Size) <=  256*256*256
    then
    begin
        picBlock := fGetArbitraryPictureBlock;
        if assigned(Source) and (Source.Size > 0) then
        begin
            if not assigned(picBlock) then
            begin
                picBlock := TFlacPictureBlock.Create;
                picBlock.fPictureType := 3; // front-cover
                fMetaBlocks.Add(picBlock);
            end;

            picBlock.Mime        := aMime;
            picBlock.Description := aDescription;
            picBlock.fWidth         := 0;
            picBlock.fHeight        := 0;
            picBlock.fColorDepth    := 0;
            picBlock.fNumberOfColors:= 0;

            picBlock.fPicData.Clear;
            picBlock.fPicData.CopyFrom(Source, 0);

            // Set size-Info in the Header
            picBlock.fSetDataSize(picBlock.fCalculateBlockSize);
        end else
        begin
            // Delete the Block from the file
            if assigned(picBlock) then
            begin
                fMetaBlocks.Extract(picBlock);
                FreeAndNil(picBlock);
            end;
        end;
    end
    else
    begin
        raise Exception.Create('Maximum picture size exceeded: Datasize > 16MiB.');
    end;
end;

function TFlacFile.GetPropertyByFieldname(aField: String): UnicodeString;
begin
    ValidateFlacCommentsBlock;
    result := fFlacCommentsBlock.Comments.GetPropertyByFieldname(aField);
end;

function TFlacFile.GetPropertyByIndex(aIndex: Integer): UnicodeString;
begin
    ValidateFlacCommentsBlock;
    result := fFlacCommentsBlock.Comments.GetPropertyByIndex(aIndex);
end;

function TFlacFile.SetPropertyByFieldname(aField: String;
  aValue: UnicodeString): Boolean;
begin
    ValidateFlacCommentsBlock;
    result := fFlacCommentsBlock.Comments.SetPropertyByFieldname(aField, aValue);
end;

function TFlacFile.SetPropertyByIndex(aIndex: Integer;
  aValue: UnicodeString): Boolean;
begin
    ValidateFlacCommentsBlock;
    result := fFlacCommentsBlock.Comments.SetPropertyByIndex(aIndex, aValue);
end;


procedure TFlacFile.ClearData;
begin
    fChannels      := 0;
    fSampleRate    := 0;
    fBitsPerSample := 0;
    fSamples       := 0;
    fBitrate       := 0;
    fAudioOffset   := 0;
    fFlacCommentsBlock := Nil;
    fMetaBlocks.Clear;
end;

procedure TFlacFile.ValidateFlacCommentsBlock;
begin
    if not assigned(fFlacCommentsBlock) then
    begin
        // Create new empty MetaBlock now
        //NewFlacMetaBlock := TFlacCommentsBlock.Create;
        //fFlacCommentsBlock := TFlacCommentsBlock(NewFlacMetaBlock);
        fFlacCommentsBlock := TFlacCommentsBlock.Create;
        fMetaBlocks.Add(fFlacCommentsBlock);
    end;
end;

function TFlacFile.fIsValid: Boolean;
begin
    result := (fHeader.StreamMarker = FLAC_MARKER)
            and (fChannels > 0)
            and (fSampleRate > 0)
            and (fBitsPerSample > 0)
            and (fSamples > 0);
end;

function TFlacFile.fGetFileSize   : Int64;
begin
    result := fFileSize;
end;
function TFlacFile.fGetDuration: Integer;
begin
    if (fIsValid) and (fSampleRate > 0) then
        result := Round(fSamples / fSampleRate)
    else
       result := 0;
end;
function TFlacFile.fGetBitrate    : Integer;
begin
    result := fBitrate;
end;
function TFlacFile.fGetSamplerate : Integer;
begin
    result := fSampleRate;
end;
function TFlacFile.fGetChannels   : Integer;
begin
    result := fChannels;
end;
function TFlacFile.fGetValid      : Boolean;
begin
    result := fIsValid;
end;


function TFlacFile.ReadFromStream(fs: TStream): TAudioError;
var NewMetaHeader: TMetaDataBlockHeader;
    NewFlacMetaBlock: TFlacMetaBlock;
begin
    // Set Size
    fFileSize := fs.Size;

    // check for ID3v2-Tag
    fFlacOffset := GetID3Size(fs);
    fs.Seek(fFlacOffset, soFromBeginning);

    // read the Flac-Header
    fs.Read(fHeader, SizeOf(fHeader));
    // Check for 'fLaC'
    if fHeader.StreamMarker <> FLAC_MARKER then
        result := FlacErr_InvalidFlacFile
    else
        result := FileErr_None;

    if result = FileErr_None then   // File seems to be valid so far
    begin
        // Get some informaation - copied from the AudioToolsLibrary (ATL)
        fChannels      := fHeader.Info[13] shr 1 and $7 + 1;
        fSampleRate    := fHeader.Info[11] shl 12 or fHeader.Info[12] shl 4 or fHeader.Info[13] shr 4;
        fBitsPerSample := fHeader.Info[13] and 1 shl 4 or fHeader.Info[14] shr 4 + 1;
        fSamples       := fHeader.Info[15] shl 24 or fHeader.Info[16] shl 16 or fHeader.Info[17] shl 8 or fHeader.Info[18];

        if Not IsMetaBlockLastBlock(fheader.MetaDataBlockHeader) then
        begin
            // read further MetaDataBlocks
            repeat
                fs.Read(NewMetaHeader, SizeOf(NewMetaHeader));
                case MetaType(NewMetaHeader) of
                    0, 127: begin
                        // the METADATA_BLOCK_STREAMINFO has been read before
                        // 127 is also invalid
                        result := FlacErr_InvalidFlacFile;
                        break;
                    end;
                    1: begin // padding
                        NewFlacMetaBlock := TFlacMetaBlock.Create;
                        fMetaBlocks.Add(NewFlacMetaBlock);
                        NewFlacMetaBlock.ReadFromStream(NewMetaHeader, fs);
                    end;
                    4: begin // Comments
                        NewFlacMetaBlock := TFlacCommentsBlock.Create;
                        fFlacCommentsBlock := TFlacCommentsBlock(NewFlacMetaBlock);   // this is the Comments-Block!
                        fMetaBlocks.Add(NewFlacMetaBlock);
                        NewFlacMetaBlock.ReadFromStream(NewMetaHeader, fs);
                    end;
                    6: begin // Picture
                        NewFlacMetaBlock := TFlacPictureBlock.Create;
                        fMetaBlocks.Add(NewFlacMetaBlock);
                        NewFlacMetaBlock.ReadFromStream(NewMetaHeader, fs);
                    end;
                else
                    begin
                        {
                          2 : APPLICATION
                          3 : SEEKTABLE
                          5 : CUESHEET
                          7-126 : reserved
                        }
                        NewFlacMetaBlock := TFlacMetaBlock.Create;
                        fMetaBlocks.Add(NewFlacMetaBlock);
                        NewFlacMetaBlock.ReadFromStream(NewMetaHeader, fs);
                    end;
                end;
            until TFlacMetaBlock(fMetaBlocks[fMetaBlocks.Count - 1]).LastBlockInFile;

            ValidateFlacCommentsBlock;
        end;
    end;
    fAudioOffset := fs.Position;
end;

function TFlacFile.ReadFromFile(aFilename: UnicodeString): TAudioError;
var fs: TAudioFileStream;
begin
    // Clear Data, Metablocks, ...
    ClearData;
    if AudioFileExists(aFilename) then
    begin
        try
            fs := TAudioFileStream.Create(aFilename, fmOpenRead or fmShareDenyWrite);
            try
                result := ReadFromStream(fs);
            finally
                if fIsValid then
                begin
                    fBitrate := Round((( fFileSize - fAudioOffset )) * 8 / fGetDuration);
                end
                else
                    result := FlacErr_InvalidFlacFile;

                fs.Free;
            end;
        except
            result := FileErr_FileOpenR;
        end;
    end else
        result := FileErr_NoFile;
end;

function TFlacFile.PrepareDataToWrite(tmpFlacFile: TFlacFile; BufferStream: TStream; aFilename: String): TAudioError;
var i, pad: Integer;
    MetaDataPresent: Boolean;
    AvailableSpaceForData: Integer;
    PadBlock: TFlacMetaBlock;
    MetaBlocksToWrite: TObjectList;
    oldpos, newpos: int64;
begin
    result := FileErr_None;

    for i := tmpFlacFile.fMetaBlocks.Count - 1 downto 0 do
    begin
        // delete all Comments, pictures and padding from the tmpFlacFile
        // (we want to replace this by "self")
        if TFlacMetaBlock(tmpFlacFile.fMetaBlocks[i]).BlockType in [1,4,6] then // padding, comments, picture
            tmpFlacFile.fMetaBlocks.Delete(i);
    end;
    tmpFlacFile.fFlacCommentsBlock := Nil;  // delete the reference

    // check and cleanup "self"-Blocks
    for i := Self.fMetaBlocks.Count - 1 downto 0 do
    begin
        case TFlacMetaBlock(Self.fMetaBlocks[i]).BlockType of
            1: begin
                // delete the padding block - we will write one new big padding block at the end.
                Self.fMetaBlocks.Delete(i);
            end;
            4: begin
                if TFlacCommentsBlock(Self.fMetaBlocks[i]).IsEmpty then
                begin
                    // dont write empty Comments
                    Self.fMetaBlocks.Delete(i);
                    fFlacCommentsBlock := Nil;
                end;
            end;
            6: begin
                if TFlacPictureBlock(Self.fMetaBlocks[i]).IsEmpty then
                    // dont write empty Pictures
                    Self.fMetaBlocks.Delete(i);
            end;
        end;
    end;

    // collect Self-Metablocks we should write
    MetaBlocksToWrite := TObjectList.Create(False);
    try
        for i := 0 to Self.fMetaBlocks.Count - 1 do
        begin
            if TFlacMetaBlock(Self.fMetaBlocks[i]).BlockType in [4,6] then // comments, picture
                MetaBlocksToWrite.Add(Self.fMetaBlocks[i])
        end;

        // Is there any Metadata to write?
        MetaDataPresent := MetaBlocksToWrite.Count + tmpFlacFile.fMetaBlocks.Count > 0;
        // how much space do we have?
        AvailableSpaceForData := tmpFlacFile.fAudioOffset - tmpFlacFile.fFlacOffset;


        if not MetaDataPresent then
        begin
            // we have only the METADATA_BLOCK_STREAMINFO
            // so this would be the last block, iff we dont use padding
            SetMetaBlockLastBlock(tmpFlacFile.fHeader.MetaDataBlockHeader, Not UsePadding);
        end else
        begin
            // we have more than the METADATA_BLOCK_STREAMINFO
            // so this is NOT the last block
            SetMetaBlockLastBlock(tmpFlacFile.fHeader.MetaDataBlockHeader, False);
            // Set the bit in the other blocks to "False"
            for i := 0 to tmpFlacFile.fMetaBlocks.Count - 1 do
                TFlacMetaBlock(tmpFlacFile.fMetaBlocks[i]).fSetLastBlock(False);
            for i := 0 to Self.fMetaBlocks.Count - 1 do
                TFlacMetaBlock(Self.fMetaBlocks[i]).fSetLastBlock(False);  // this includes all MetaBlocksToWrite

            if Not Usepadding then
            begin
                // Set the bit on the last block to "True"
                // IMPORTANT: WE MUST WRITE THE "LAST" BLOCK DEFINED HERE AT LAST !
                // We will write 1. "self blocks" with new data, 3.other blocks from "tmpFlacFile", so:
                if tmpFlacFile.fMetaBlocks.Count > 0 then
                    // we have some "other" blocks
                    TFlacMetaBlock(tmpFlacFile.fMetaBlocks[tmpFlacFile.fMetaBlocks.Count-1]).fSetLastBlock(True)
                else
                    // we have no "other blocks", but as MetaDataPresent=True, we have one block here
                    TFlacMetaBlock(MetaBlocksToWrite[MetaBlocksToWrite.Count-1]).fSetLastBlock(True);
            end;
        end;

        // start writing
        BufferStream.Write(tmpFlacFile.fHeader, SizeOf(tmpFlacFile.fHeader)); // "flac" and the METADATA_BLOCK_STREAMINFO

        // write "self blocks", i.e. "new data"
        for i := 0 to MetaBlocksToWrite.Count - 1 do
        begin
            oldPos := BufferStream.Position;
            TFlacMetaBlock(MetaBlocksToWrite[i]).WriteToStream(BufferStream);
            newPos := BufferStream.Position;
            if newPos - oldPos > 256*256*256 + 4 then
                result := FlacErr_MetaDataTooLarge;
        end;

        // write other blocks from the file again, i.e. "old data"
        for i := 0 to tmpFlacFile.fMetaBlocks.Count - 1 do
        begin
            oldPos := BufferStream.Position;
            TFlacMetaBlock(tmpFlacFile.fMetaBlocks[i]).WriteToStream(BufferStream);
            newPos := BufferStream.Position;
            if newPos - oldPos > 256*256*256 + 4 then
                result := FlacErr_MetaDataTooLarge;
        end;
    finally
        MetaBlocksToWrite.Free;
    end;

    // add padding
    if Usepadding then
    begin
        // try to adjust paddingsize to available space
        if AvailableSpaceForData >= BufferStream.Position + 5 then // 4 Bytes for Header + at least 1 Byte padding
            // we can build a Metadatablock that just fits the availablespace
            pad := AvailableSpaceForData - BufferStream.Position - 4
        else
            pad := GetPaddingSize(
                tmpFlacFile.fFileSize - AvailableSpaceForData + BufferStream.Position + 4,
                aFilename,
                True );

        // correct padding size - do not allow to much padding
        pad := pad mod 4096;

        PadBlock := TFlacMetaBlock.Create;
        try
            PadBlock.BlockType := 1;
            PadBlock.fSetDataSize(pad);
            PadBlock.fSetLastBlock(True);

            Setlength(PadBlock.fData, pad);
            FillChar(PadBlock.fData[0], pad, 0);

            PadBlock.WriteToStream(BufferStream);
        finally
            PadBlock.Free;
        end;
    end;

end;

function TFlacFile.BackupAudioData(source: TStream; BackUpFilename: UnicodeString): TAudioError;
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
function TFlacFile.AppendBackup(Destination: TStream; BackUpFilename: UnicodeString): TAudioError;
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

function TFlacFile.WriteToFile(aFilename: UnicodeString): TAudioError;
var fs: TAudioFileStream;
    bs: TMemoryStream;
    tmpFlacFile: TFlacFile;
    AvailableSize: Integer;
begin
    if AudioFileExists(aFilename) then
    begin
        try
            fs := TAudioFileStream.Create(aFilename, fmOpenReadWrite or fmShareDenyWrite);
            try
                tmpFlacFile := tFlacFile.Create;
                try
                    // read Existing stuff in the File
                    result := tmpFlacFile.ReadFromStream(fs);
                    if result = FileErr_None then
                    begin
                        // file is ok, write the new data from "self"
                        bs := TMemoryStream.Create;
                        try
                            // cache the new Metadata into the bufferstream
                            result := PrepareDataToWrite(tmpFlacFile, bs, aFilename);

                            if result = FileErr_None then
                            begin
                                AvailableSize := tmpFlacFile.fAudioOffset - tmpFlacFile.fFlacOffset;
                                if AvailableSize = bs.Size then
                                begin
                                    // just copy the new Metadata into the file
                                    fs.Seek(tmpFlacFile.fFlacOffset, soFromBeginning);
                                    // just copy the complete BufferStream into the Filestream
                                    fs.CopyFrom(bs, 0);
                                end else
                                begin
                                    // rewrite (almost) the whole file
                                    fs.Seek(tmpFlacFile.fAudioOffset, soFromBeginning);
                                    result := BackupAudioData(fs, aFilename+'~');
                                    if result = FileErr_None then
                                    begin
                                        fs.Seek(tmpFlacFile.fFlacOffset, soFromBeginning);
                                        // copy the complete BufferStream into the Filestream
                                        fs.CopyFrom(bs, 0);
                                        // write AudioData back to the File
                                        result := self.AppendBackup(fs, aFilename+'~');
                                        // cleanup
                                        if result = FileErr_None then
                                        begin
                                            // Set End of File here (in case noPdding and new Comments are smaller)
                                            SetEndOfFile((fs as THandleStream).Handle);
                                            //delete backupfile
                                            if not DeleteFile(aFilename + '~') then
                                                result := FlacErr_DeleteBackupFailed;
                                        end;
                                    end;
                                end;
                            end;
                        finally
                            bs.Free;
                        end;

                    end;
                finally
                    tmpFlacFile.Free;
                end;
            finally
                fs.Free;
            end;
        except
            result := FileErr_FileOpenRW;
        end;
    end
    else
        result := FileErr_NoFile;
end;

function TFlacFile.RemoveFromFile(aFilename: UnicodeString): TAudioError;
begin
    result := FlacErr_RemovingNotSupported;
end;



end.
