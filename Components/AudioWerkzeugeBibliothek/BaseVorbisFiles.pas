{
    -----------------------------------
    Audio Werkzeuge Bibliothek
    -----------------------------------
    (c) 2012-2024, Daniel Gaussmann
              Website : www.gausi.de
              EMail   : mail@gausi.de
    -----------------------------------

    Unit BaseVorbisFiles

    This is the new base class for
        OggVorbisFiles
        FlacFiles
        OpusFiles

    Use an instance of these classes to collect data from the files.

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

unit BaseVorbisFiles;

interface

uses Windows, SysUtils, Classes, System.ContNrs,
     AudioFiles.Base, AudioFiles.BaseTags, AudioFiles.Declarations,
     VorbisComments, OggContainer;

type

    TBaseVorbisFile = class (TBaseAudioFile)
      private

      protected
        function GetVorbisComments: TVorbisComments; virtual; abstract;
        procedure fSetTitle (aValue: UnicodeString); override;
        procedure fSetArtist(aValue: UnicodeString); override;
        procedure fSetAlbum (aValue: UnicodeString); override;
        procedure fSetYear  (aValue: UnicodeString); override;
        procedure fSetTrack (aValue: UnicodeString); override;
        procedure fSetGenre (aValue: UnicodeString); override;
        procedure fSetAlbumArtist (value: UnicodeString); override;
        procedure fSetLyrics (value: UnicodeString); override;
        procedure fSetVersion     (value: UnicodeString);
        procedure fSetPerformer   (value: UnicodeString);
        procedure fSetCopyright   (value: UnicodeString);
        procedure fSetLicense     (value: UnicodeString);
        procedure fSetOrganization(value: UnicodeString);
        procedure fSetDescription (value: UnicodeString);
        procedure fSetLocation    (value: UnicodeString);
        procedure fSetContact     (value: UnicodeString);
        procedure fSetISRC        (value: UnicodeString);

        function fGetTitle  : UnicodeString; override;
        function fGetArtist : UnicodeString; override;
        function fGetAlbum  : UnicodeString; override;
        function fGetYear   : UnicodeString; override;
        function fGetTrack  : UnicodeString; override;
        function fGetGenre  : UnicodeString; override;
        function fGetAlbumArtist : UnicodeString; override;
        function fGetLyrics      : UnicodeString; override;
        function fGetVersion     : UnicodeString;
        function fGetPerformer   : UnicodeString;
        function fGetCopyright   : UnicodeString;
        function fGetLicense     : UnicodeString;
        function fGetOrganization: UnicodeString;
        function fGetDescription : UnicodeString;
        function fGetLocation    : UnicodeString;
        function fGetContact     : UnicodeString;
        function fGetISRC        : UnicodeString;

        function fGetFileType            : TAudioFileType; override;
        function fGetFileTypeDescription : String;         override;
        function GetMaxSample(aStream: TStream): Integer; virtual;

      public
        constructor Create; override;
        destructor Destroy; override;

        property Version     : UnicodeString read fGetVersion      write fSetVersion     ;
        property Performer   : UnicodeString read fGetPerformer    write fSetPerformer   ;
        property Copyright   : UnicodeString read fGetCopyright    write fSetCopyright   ;
        property License     : UnicodeString read fGetLicense      write fSetLicense     ;
        property Organization: UnicodeString read fGetOrganization write fSetOrganization;
        property Description : UnicodeString read fGetDescription  write fSetDescription ;
        property Location    : UnicodeString read fGetLocation     write fSetLocation    ;
        property Contact     : UnicodeString read fGetContact      write fSetContact     ;
        property ISRC        : UnicodeString read fGetISRC         write fSetISRC        ;

        // Direct Access to the Comments.
        property VorbisComments: TVorbisComments read GetVorbisComments;

        // Access to these Fields by Name or Index (note: Fieldnames dont have to be unique)
        function GetPropertyByFieldname(aField: String): UnicodeString; virtual;
        function SetPropertyByFieldname(aField: String; aValue: UnicodeString): Boolean; virtual;

        // Methods for handling CoverArt
        // **Note that Flac should NOT use VorbisComments for that**
        // Get/Set "the" METADATA_BLOCK_PICTURE from the Comments.
        // If there are more than one METADATA_BLOCK_PICTURE-Comment, the first one in the list is used.
        function SetPicture(Source: TStream; aMime: AnsiString;
              aPicType: TPictureType; aDescription: UnicodeString): Boolean; override;

        // Add a new METADATA_BLOCK_PICTURE
        procedure AddPicture(Source: TStream; aMime: AnsiString; aPicType: TPictureType; aDescription: UnicodeString); virtual;

        procedure GetTagList(Dest: TTagItemList; ContentTypes: TTagContentTypes = cDefaultTagContentTypes); override;
        procedure DeleteTagItem(aTagItem: TTagItem); override;

        function GetUnusedTextTags: TTagItemInfoDynArray; override;
        function AddTextTagItem(aKey, aValue: UnicodeString): TTagItem; override;
    end;

implementation

{ TBaseVorbisFile }

constructor TBaseVorbisFile.Create;
begin
  inherited;
end;

destructor TBaseVorbisFile.Destroy;
begin
  inherited;
end;

function TBaseVorbisFile.fGetFileType: TAudioFileType;
begin
  result := at_AbstractVorbis;
end;

function TBaseVorbisFile.fGetFileTypeDescription: String;
begin
  result := cAudioFileType[at_AbstractApe]
end;

// This function is copied from the "AudioToolsLibrary"
function TBaseVorbisFile.GetMaxSample(aStream: TStream): Integer;
var
  Index, DataIndex, Iterator: Integer;
  Data: array [0..250] of AnsiChar;
  Header: TOggHeader;
begin
    // Get total number of samples }
    Result := 0;
    for Index := 1 to 50 do
    begin
      DataIndex := aStream.Size - (SizeOf(Data) - 16) * Index - 16;
      aStream.Seek(DataIndex, soBeginning);
      aStream.Read(Data, SizeOf(Data));
      // Get number of PCM samples from last Ogg packet header
      // Search for an OggPage-ID from the end of the File
      for Iterator := SizeOf(Data) - 16 downto 0 do
          if Data[Iterator] +
             Data[Iterator + 1] +
             Data[Iterator + 2] +
             Data[Iterator + 3] = OGG_PAGE_ID then
          begin
              // found it! Read header and return the AbsolutePosition (=MaxSample in OggVorbis)
              aStream.Seek(DataIndex + Iterator, soBeginning);
              aStream.Read(Header, SizeOf(Header));
              Result := Header.AbsolutePosition;
              exit;
          end;
    end;
end;


procedure TBaseVorbisFile.fSetAlbum(aValue: UnicodeString);
begin
  VorbisComments.Album := aValue;
end;
procedure TBaseVorbisFile.fSetAlbumArtist(value: UnicodeString);
begin
  VorbisComments.AlbumArtist := Value;
end;
procedure TBaseVorbisFile.fSetArtist(aValue: UnicodeString);
begin
  VorbisComments.Artist := aValue;
end;
procedure TBaseVorbisFile.fSetTitle(aValue: UnicodeString);
begin
  VorbisComments.Title := aValue;
end;
procedure TBaseVorbisFile.fSetTrack(aValue: UnicodeString);
begin
  VorbisComments.TrackNumber := aValue;
end;
procedure TBaseVorbisFile.fSetYear(aValue: UnicodeString);
begin
  VorbisComments.Date := aValue;
end;
procedure TBaseVorbisFile.fSetGenre(aValue: UnicodeString);
begin
  VorbisComments.Genre := aValue;
end;

procedure TBaseVorbisFile.fSetContact(value: UnicodeString);
begin
  VorbisComments.Contact := value;
end;
procedure TBaseVorbisFile.fSetCopyright(value: UnicodeString);
begin
  VorbisComments.Copyright := value;
end;
procedure TBaseVorbisFile.fSetDescription(value: UnicodeString);
begin
  VorbisComments.Description := value;
end;
procedure TBaseVorbisFile.fSetISRC(value: UnicodeString);
begin
  VorbisComments.ISRC := value;
end;
procedure TBaseVorbisFile.fSetLicense(value: UnicodeString);
begin
  VorbisComments.License := value;
end;
procedure TBaseVorbisFile.fSetLocation(value: UnicodeString);
begin
  VorbisComments.Location := value;
end;
procedure TBaseVorbisFile.fSetOrganization(value: UnicodeString);
begin
  VorbisComments.Organization := value;
end;
procedure TBaseVorbisFile.fSetPerformer(value: UnicodeString);
begin
  VorbisComments.Performer := value;
end;
procedure TBaseVorbisFile.fSetVersion(value: UnicodeString);
begin
  VorbisComments.Version := value;
end;
procedure TBaseVorbisFile.fSetLyrics (value: UnicodeString);
begin
  VorbisComments.Lyrics := value;
end;


function TBaseVorbisFile.fGetAlbum: UnicodeString;
begin
  result := VorbisComments.Album;
end;
function TBaseVorbisFile.fGetAlbumArtist: UnicodeString;
begin
  result := VorbisComments.AlbumArtist;
end;
function TBaseVorbisFile.fGetArtist: UnicodeString;
begin
  result := VorbisComments.Artist;
end;
function TBaseVorbisFile.fGetGenre: UnicodeString;
begin
  result := VorbisComments.Genre;
end;
function TBaseVorbisFile.fGetTitle: UnicodeString;
begin
  result := VorbisComments.Title;
end;
function TBaseVorbisFile.fGetTrack: UnicodeString;
begin
  result := VorbisComments.TrackNumber;
end;
function TBaseVorbisFile.fGetYear: UnicodeString;
begin
  result := VorbisComments.Date;
end;

function TBaseVorbisFile.fGetContact: UnicodeString;
begin
  result := VorbisComments.Contact;
end;
function TBaseVorbisFile.fGetCopyright: UnicodeString;
begin
  result := VorbisComments.Copyright;
end;
function TBaseVorbisFile.fGetDescription: UnicodeString;
begin
  result := VorbisComments.Description;
end;
function TBaseVorbisFile.fGetISRC: UnicodeString;
begin
  result := VorbisComments.ISRC;
end;
function TBaseVorbisFile.fGetLicense: UnicodeString;
begin
  result := VorbisComments.License;
end;
function TBaseVorbisFile.fGetLocation: UnicodeString;
begin
  result := VorbisComments.Location;
end;
function TBaseVorbisFile.fGetOrganization: UnicodeString;
begin
  result := VorbisComments.Organization;
end;
function TBaseVorbisFile.fGetPerformer: UnicodeString;
begin
  result := VorbisComments.Performer;
end;
function TBaseVorbisFile.fGetVersion: UnicodeString;
begin
  result := VorbisComments.Version;
end;
function TBaseVorbisFile.fGetLyrics: UnicodeString;
begin
  result := VorbisComments.Lyrics;
end;

procedure TBaseVorbisFile.GetTagList(Dest: TTagItemList; ContentTypes: TTagContentTypes = cDefaultTagContentTypes);
begin
  VorbisComments.GetTagList(Dest, ContentTypes);
end;

procedure TBaseVorbisFile.DeleteTagItem(aTagItem: TTagItem);
begin
  VorbisComments.DeleteTagItem(aTagItem);
end;

function TBaseVorbisFile.GetUnusedTextTags: TTagItemInfoDynArray;
begin
  result := VorbisComments.GetUnusedTextTags;
end;

function TBaseVorbisFile.AddTextTagItem(aKey, aValue: UnicodeString): TTagItem;
begin
  result := VorbisComments.AddTextTagItem(aKey, aValue);
end;

function TBaseVorbisFile.GetPropertyByFieldname(aField: String): UnicodeString;
begin
  result := VorbisComments.GetPropertyByFieldname(aField);
end;

function TBaseVorbisFile.SetPropertyByFieldname(aField: String; aValue: UnicodeString): Boolean;
begin
  result := VorbisComments.SetPropertyByFieldname(aField, aValue);
end;

function TBaseVorbisFile.SetPicture(Source: TStream; aMime: AnsiString; aPicType: TPictureType;
  aDescription: UnicodeString): Boolean;
begin
  result := VorbisComments.SetPicture(Source, aMime, aPicType, aDescription);
end;

// Add a new Picture
procedure TBaseVorbisFile.AddPicture(Source: TStream; aMime: AnsiString; aPicType: TPictureType;
      aDescription: UnicodeString);
begin
  VorbisComments.AddPicture(Source, aMime, aPicType, aDescription);
end;

end.

