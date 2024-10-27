{
    -----------------------------------
    Audio Werkzeuge Bibliothek
    -----------------------------------
    (c) 2010-2024, Daniel Gaussmann
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
  {$IFDEF USE_SYSTEM_TYPES}, System.Types{$ENDIF},
  AudioFiles.Base, AudioFiles.BaseTags, AudioFiles.Declarations, BaseVorbisFiles,
  VorbisComments, Id3Basics , winsock;

const
    FLAC_MARKER = 'fLaC';

    cFlacMetaDataBlockTypes: array[0..6] of String = ('STREAMINFO', 'PADDING', 'APPLICATION', 'SEEKTABLE', 'VORBIS_COMMENT', 'CUESHEET', 'PICTURE' );
    cUnkownFlacMetaDataBlockType = 'FLACMETADATABLOCK';
    cMaxBlockSize = 16777216; // = 256*256*256

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
    TFlacMetaBlock = class(TTagItem)
        private
            fHeader: TMetaDataBlockHeader;           // Store the Header
            fData: TMetaDataBlockData;               // ... the data (not always used in derived classes)
            fPositionInStream: Int64;

            function fGetDataSize: Cardinal;          // compute DataSize from the Header
            procedure fSetDataSize(aSize: Cardinal);  // Set the Size in the Header
            function fGetLastBlock: Boolean;         // get/set the Bit indicating, whether
            procedure fSetLastBlock(Value: Boolean); // this is the last MetaBlock or not
            procedure fCopyHeader(aSourceHeader: TMetaDataBlockHeader);
            function fGetBlockType: Byte;
            procedure fSetBlockType(value: Byte);
        protected
            function GetKey: UnicodeString; override;
            function GetTagContentType: teTagContentType; override;
            function GetDataSize: Integer; override;

        public
            property BlockType: Byte read fGetBlockType write fSetBlockType;
            property LastBlockInFile: Boolean read fGetLastBlock write fSetLastBlock;

            constructor create;
            // read Data from the Stream. Ancestors should overwrite this method
            // to parse the data properly
            function ReadFromStream(aSourceHeader: TMetaDataBlockHeader; Source: TStream): Boolean; virtual;
            // write it into a Stream
            function WriteToStream(Destination: TStream): Boolean; virtual;

            // TTagItem methods
            function GetText(TextMode: teTextMode = tmReasonable): UnicodeString; override;
            function SetText(aValue: UnicodeString; TextMode: teTextMode = tmReasonable): Boolean; override;

            function GetPicture(Dest: TStream; out Mime: AnsiString; out PicType: TPictureType; out Description: UnicodeString): Boolean; override;
            function SetPicture(Source: TStream; Mime: AnsiString; PicType: TPictureType; Description: UnicodeString): Boolean; override;
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
            fMetaDataBlockPicture: TMetaDataBlockPicture;


            procedure SetPicDescription(value: UnicodeString);
            function GetPicDescription: UnicodeString;
            function GetMime: AnsiString;
            procedure SetMime(value: AnsiString);

            function GetWidth          : Cardinal;
            function GetHeight         : Cardinal;
            function GetColorDepth     : Cardinal;
            function GetNumberOfColors : Cardinal;
            function GetPictureType    : TPictureType;

            procedure SetWidth         (Value: Cardinal);
            procedure SetHeight        (Value: Cardinal);
            procedure SetColorDepth    (Value: Cardinal);
            procedure SetNumberOfColors(Value: Cardinal);
            procedure SetPictureType   (Value: TPictureType);
        protected

        public
            property PictureType: TPictureType read GetPictureType write SetPictureType;
            property Mime: AnsiString read GetMime write SetMime;
            property PicDescription: UnicodeString read GetPicDescription write SetPicDescription;

            property Width         : Cardinal read GetWidth          write SetWidth          ;
            property Height        : Cardinal read GetHeight         write SetHeight         ;
            property ColorDepth    : Cardinal read GetColorDepth     write SetColorDepth     ;
            property NumberOfColors: Cardinal read GetNumberOfColors write SetNumberOfColors ;

            constructor Create;
            destructor Destroy; override;
            procedure Clear;
            function IsEmpty: Boolean;

            procedure CopyPicData(Target: TStream);
            function ReadFromStream(aSourceHeader: TMetaDataBlockHeader; Source: TStream): Boolean; override;
            function WriteToStream(Destination: TStream): Boolean; override;

            function GetPicture(Dest: TStream; out Mime: AnsiString; out PicType: TPictureType; out Description: UnicodeString): Boolean; override;
            function SetPicture(Source: TStream; Mime: AnsiString; PicType: TPictureType; Description: UnicodeString): Boolean; override;
    end;
 
    TFlacFile = class(TBaseVorbisFile)
        private
            fHeader: TFlacHeader;
            fBitsPerSample: Byte;
            fSamples      : Int64;
            fUsePadding   : Boolean;
            fAudioOffset  : Integer; // the position in the file where the Audiodata begins
            fFlacOffset   : Integer; // the beginning of the flac file (> 0 if id3tag is present)
            fMetaBlocks: TObjectList;
            fFlacCommentsBlock: TFlacCommentsBlock;

            procedure ClearData;
            function fGetArbitraryPictureBlock: TFlacPictureBlock;
            function PrepareDataToWrite(tmpFlacFile: TFlacFile; BufferStream: TStream; aFilename: String): TAudioError;
            function BackupAudioData(source: TStream; BackUpFilename: UnicodeString): TAudioError;
            function AppendBackup(Destination: TStream; BackUpFilename: UnicodeString): TAudioError;

        protected

            function GetVorbisComments: TVorbisComments; override;
            function fGetFileType: TAudioFileType; override;
            function fGetFileTypeDescription : String; override;
            function fGetDuration: Integer; override;
            function fGetValid: Boolean; override;

        public
            property UsePadding: Boolean read fUsePadding write fUsePadding;

            constructor Create; override;
            destructor Destroy; override;

            function ReadFromStream(fs: TStream): TAudioError;
            function ReadFromFile(aFilename: UnicodeString): TAudioError; override;
            function WriteToFile(aFilename: UnicodeString): TAudioError;  override;
            function RemoveFromFile(aFilename: UnicodeString): TAudioError;  override;

            function SetPicture(Source: TStream;
                                    aMime: AnsiString;
                                    aPicType: TPictureType;
                                    aDescription: UnicodeString): Boolean;  override;
            procedure AddPicture(Source: TStream; aMime: AnsiString; aType: TPictureType;  aDescription: UnicodeString); override;

            procedure GetTagList(Dest: TTagItemList; ContentTypes: TTagContentTypes = cDefaultTagContentTypes); override;
            procedure DeleteTagItem(aTagItem: TTagItem); override;
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

function PicBlockSize(aStream: TStream; aMime: AnsiString; aDescription: UnicodeString): Integer;
begin
  result := 8*4
      + length(aMime)
      + (length(aDescription) * SizeOf(WideChar))
      + aStream.Size
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

constructor TFlacMetaBlock.create;
begin
  inherited create(ttFlacMetaBlock);
end;

function TFlacMetaBlock.GetKey: UnicodeString;
begin
  if BlockType in [0..6] then
    result := cFlacMetaDataBlockTypes[BlockType]
  else
    result := cUnkownFlacMetaDataBlockType;
end;

function TFlacMetaBlock.GetTagContentType: teTagContentType;
begin
  // in general FlacMetaBlocks do not directly contain data we are interested in
  result := tctUndef;
end;

procedure TFlacMetaBlock.fCopyHeader(aSourceHeader: TMetaDataBlockHeader);
begin
    fHeader[1] := aSourceHeader[1];
    fHeader[2] := aSourceHeader[2];
    fHeader[3] := aSourceHeader[3];
    fHeader[4] := aSourceHeader[4];
end;

function TFlacMetaBlock.GetDataSize: Integer;
begin
  result := Length(fData);
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

function TFlacMetaBlock.GetText(TextMode: teTextMode = tmReasonable): UnicodeString;
begin
  // usually, this one doesn't make any sense. We have a base FlacMetaBlock here, which contains no data we can make use of.
  if TextMode = tmForced then
    result := ByteArrayToString(fData)
  else
    result := '';
end;

function TFlacMetaBlock.SetText(aValue: UnicodeString; TextMode: teTextMode = tmReasonable): Boolean;
begin
  raise Exception.Create('TFlacMetaBlock.SetText: Invalid method call');
end;

function TFlacMetaBlock.GetPicture(Dest: TStream; out Mime: AnsiString; out PicType: TPictureType; out Description: UnicodeString): Boolean;
begin
  raise Exception.Create('TFlacMetaBlock.GetPicture: Invalid method call');
end;

function TFlacMetaBlock.SetPicture(Source: TStream; Mime: AnsiString; PicType: TPictureType; Description: UnicodeString): Boolean;
begin
  raise Exception.Create('TFlacMetaBlock.SetPicture: Invalid method call');
end;

{ TFlacCommentsBlock }


constructor TFlacCommentsBlock.Create;
begin
    inherited create;
    BlockType := 4;
    Comments := TVorbisComments.Create;
    Comments.ContainerType := octFlac;
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
begin
  result := Comments.Count = 0;
end;

function TFlacCommentsBlock.ReadFromStream(aSourceHeader: TMetaDataBlockHeader;
  Source: TStream): Boolean;
begin
    fPositionInStream := Source.Position - 4;
    // Copy the Header-Information
    fCopyHeader(aSourceHeader);
    result := Comments.ReadFromStream(Source, fGetDataSize);
end;

function TFlacCommentsBlock.WriteToStream(Destination: TStream): Boolean;
var currentPos, posAfterHeader, posAfterData: Int64;
begin
    currentPos := Destination.Position;

    // write Header
    Destination.Write(fHeader[1], 4);
    posAfterHeader := Destination.Position;

    // write Data
    result := Comments.WriteToStream(Destination);
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
  inherited create;
  fMetaDataBlockPicture := TMetaDataBlockPicture.Create;
  BlockType := 6;
end;

destructor TFlacPictureBlock.Destroy;
begin
  fMetaDataBlockPicture.Free;
  inherited;
end;

procedure TFlacPictureBlock.Clear;
begin
  fMetaDataBlockPicture.Clear;
end;

function TFlacPictureBlock.IsEmpty: Boolean;
begin
    result := fMetaDataBlockPicture.IsEmpty;
end;

function TFlacPictureBlock.GetColorDepth: Cardinal;
begin
  result := fMetaDataBlockPicture.ColorDepth;
end;

function TFlacPictureBlock.GetPicDescription: UnicodeString;
begin
  result := fMetaDataBlockPicture.Description;
end;

function TFlacPictureBlock.GetHeight: Cardinal;
begin
  result := fMetaDataBlockPicture.Height;
end;

function TFlacPictureBlock.GetMime: AnsiString;
begin
  result := fMetaDataBlockPicture.Mime;
end;

function TFlacPictureBlock.GetNumberOfColors: Cardinal;
begin
  result := fMetaDataBlockPicture.NumberOfColors;
end;

function TFlacPictureBlock.GetPictureType: TPictureType;
begin
  result := fMetaDataBlockPicture.PictureType;
end;

function TFlacPictureBlock.GetWidth: Cardinal;
begin
  result := fMetaDataBlockPicture.Width;
end;

procedure TFlacPictureBlock.SetColorDepth(Value: Cardinal);
begin
  fMetaDataBlockPicture.ColorDepth := Value;
end;

procedure TFlacPictureBlock.SetPicDescription(value: UnicodeString);
begin
  fMetaDataBlockPicture.Description := Value;
end;

procedure TFlacPictureBlock.SetHeight(Value: Cardinal);
begin
  fMetaDataBlockPicture.Height := Value;
end;

procedure TFlacPictureBlock.SetMime(value: AnsiString);
begin
  fMetaDataBlockPicture.Mime := value;
end;

procedure TFlacPictureBlock.SetNumberOfColors(Value: Cardinal);
begin
  fMetaDataBlockPicture.NumberOfColors := Value;
end;

procedure TFlacPictureBlock.SetPictureType(Value: TPictureType);
begin
  fMetaDataBlockPicture.PictureType := Value;
end;

procedure TFlacPictureBlock.SetWidth(Value: Cardinal);
begin
  fMetaDataBlockPicture.Width := Value;
end;

procedure TFlacPictureBlock.CopyPicData(Target: TStream);
begin
  fMetaDataBlockPicture.CopyPicData(Target);
end;

function TFlacPictureBlock.ReadFromStream(aSourceHeader: TMetaDataBlockHeader;
  Source: TStream): Boolean;
begin
    fPositionInStream := Source.Position - 4;
    // Copy the Header-Information
    fCopyHeader(aSourceHeader);
    // read Data from Stream
    result := fMetaDataBlockPicture.ReadFromStream(Source);
end;

function TFlacPictureBlock.WriteToStream(Destination: TStream): Boolean;
begin
    // correct the Header (should not be necessary, as we do this in TFlacFile.SetPicture)
    // fSetDataSize(fCalculateBlockSize);
    fSetDataSize(fMetaDataBlockPicture.Size);

    // write Header
    Destination.Write(fHeader[1], 4);
    // Write Data
    result := fMetaDataBlockPicture.WriteToStream(Destination);
end;

function TFlacPictureBlock.GetPicture(Dest: TStream; out Mime: AnsiString; out PicType: TPictureType; out Description: UnicodeString): Boolean;
begin
  Dest.CopyFrom(fMetaDataBlockPicture.PicData, 0);
  Mime := Mime;
  PicType := PictureType;
  Description := Description;
  result := True;
end;

function TFlacPictureBlock.SetPicture(Source: TStream; Mime: AnsiString; PicType: TPictureType; Description: UnicodeString): Boolean;
begin
  result := PicBlockSize(Source, Mime, Description) < cMaxBlockSize;

  if result then begin
    Mime        := Mime;
    Description := Description;
    Width         := 0;
    Height        := 0;
    ColorDepth    := 0;
    NumberOfColors:= 0;

    fMetaDataBlockPicture.PicData.Clear;
    fMetaDataBlockPicture.PicData.CopyFrom(Source, 0);
    // Set size-Info in the Header
    fSetDataSize(fMetaDataBlockPicture.Size);
  end;
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

function TFlacFile.fGetFileType: TAudioFileType;
begin
    result := at_Flac;
end;

function TFlacFile.fGetFileTypeDescription: String;
begin
    result := cAudioFileType[at_Flac];
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
                if (result.PictureType <> ptFrontCover) and (tmpPicBlock.PictureType = ptFrontCover) then
                begin
                    result := tmpPicBlock;
                end;
            end;
            arbitraryPicFound := True;
        end;
    end;
end;

procedure TFlacFile.GetTagList(Dest: TTagItemList; ContentTypes: TTagContentTypes = cDefaultTagContentTypes);
var
  i: Integer;
begin
  VorbisComments.GetTagList(Dest, ContentTypes);

  // Note: We will NOT add the other TFlacMetaBlocks here, just PICTURE Blocks, if wanted
  if ([tctAll, tctPicture] * ContentTypes <> [])  then begin // *: Intersection
    for i := 0 to self.fMetaBlocks.Count - 1 do begin
      if TFlacMetaBlock(fMetaBlocks[i]).BlockType = 6 then
        Dest.Add(TFlacMetaBlock(fMetaBlocks[i]));
    end;
  end;
end;

procedure TFlacFile.DeleteTagItem(aTagItem: TTagItem);
begin
  case aTagItem.TagType of
    ttVorbis: VorbisComments.DeleteTagItem(aTagItem);
    ttFlacMetaBlock: begin
      if TFlacMetaBlock(aTagItem).BlockType = 6 then
        fMetaBlocks.Remove(aTagItem);
    end;
  end;
end;

procedure TFlacFile.AddPicture(Source: TStream; aMime: AnsiString; aType: TPictureType;
                  aDescription: UnicodeString);
var
  picBlock: TFlacPictureBlock;
begin
  if PicBlockSize(Source, aMime, aDescription) < cMaxBlockSize then begin
    if assigned(Source) and (Source.Size > 0) then begin
      picBlock := TFlacPictureBlock.Create;
      fMetaBlocks.Add(picBlock);
      picBlock.SetPicture(Source, aMime, aType, aDescription);
    end; // else: nothing to do
  end
  else begin
    raise Exception.Create('Maximum picture size exceeded: Datasize > 16MiB.');
  end;
end;

function TFlacFile.SetPicture(Source: TStream; aMime: AnsiString; aPicType: TPictureType;
     aDescription: UnicodeString): Boolean;
var
  picBlock: TFlacPictureBlock;
begin
  result := PicBlockSize(Source, aMime, aDescription) < cMaxBlockSize;
  if result then begin
    picBlock := fGetArbitraryPictureBlock;
    if assigned(Source) and (Source.Size > 0) then
    begin
      if not assigned(picBlock) then begin
        picBlock := TFlacPictureBlock.Create;
        picBlock.PictureType := aPicType;
        fMetaBlocks.Add(picBlock);
      end;
      result := picBlock.SetPicture(Source, aMime, aPicType, aDescription);
    end else
    begin
      // Delete the Block from the file
      if assigned(picBlock) then begin
        result := True;
        fMetaBlocks.Extract(picBlock);
        FreeAndNil(picBlock);
      end;
    end;
  end
  else begin
    raise Exception.Create('Maximum picture size exceeded: Datasize > 16MiB.');
  end;
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

function TFlacFile.GetVorbisComments: TVorbisComments;
begin
  if not assigned(fFlacCommentsBlock) then begin
    // Create new empty MetaBlock now
    fFlacCommentsBlock := TFlacCommentsBlock.Create;
    fMetaBlocks.Add(fFlacCommentsBlock);
  end;
  result := fFlacCommentsBlock.Comments;
end;

function TFlacFile.fGetValid: Boolean;
begin
    result := (fHeader.StreamMarker = FLAC_MARKER)
            and (fChannels > 0)
            and (fSampleRate > 0)
            and (fBitsPerSample > 0)
            and (fSamples > 0);
end;

function TFlacFile.fGetDuration: Integer;
begin
    if (Valid) and (fSampleRate > 0) then
        result := Round(fSamples / fSampleRate)
    else
       result := 0;
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

            if not assigned(fFlacCommentsBlock) then begin
              fFlacCommentsBlock := TFlacCommentsBlock.Create;
              fMetaBlocks.Add(fFlacCommentsBlock);
            end;
        end;
    end;
    fAudioOffset := fs.Position;
end;

function TFlacFile.ReadFromFile(aFilename: UnicodeString): TAudioError;
var fs: TAudioFileStream;
begin
    inherited ReadFromFile(aFilename);
    // Clear Data, Metablocks, ...
    ClearData;
    if AudioFileExists(aFilename) then
    begin
        try
            fs := TAudioFileStream.Create(aFilename, fmOpenRead or fmShareDenyWrite);
            try
                result := ReadFromStream(fs);
            finally
                if Valid then
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
        result := FileErr_BackupFailed;
    end;
end;

function TFlacFile.WriteToFile(aFilename: UnicodeString): TAudioError;
var fs: TAudioFileStream;
    bs: TMemoryStream;
    tmpFlacFile: TFlacFile;
    AvailableSize: Integer;
    backupFilename: String;
begin
    inherited WriteToFile(aFilename);
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
                                    backupFilename := GetBackupFilename(aFilename);
                                    result := BackupAudioData(fs, backupFilename); // BackupAudioData(fs, aFilename+'~');
                                    if result = FileErr_None then
                                    begin
                                        fs.Seek(tmpFlacFile.fFlacOffset, soFromBeginning);
                                        // copy the complete BufferStream into the Filestream
                                        fs.CopyFrom(bs, 0);
                                        // write AudioData back to the File
                                        result := self.AppendBackup(fs, backupFilename);
                                        // cleanup
                                        if result = FileErr_None then
                                        begin
                                            // Set End of File here (in case noPdding and new Comments are smaller)
                                            SetEndOfFile((fs as THandleStream).Handle);
                                            //delete backupfile
                                            if not DeleteFile(backupFilename) then
                                                result := FileErr_DeleteBackupFailed;
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
    inherited RemoveFromFile(aFilename);
    result := TagErr_RemovingNotSupported;
end;


end.
