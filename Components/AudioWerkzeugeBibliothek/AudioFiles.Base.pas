{
    -----------------------------------
    Audio Werkzeuge Bibliothek
    -----------------------------------
    (c) 2012-2024, Daniel Gaussmann
              Website : www.gausi.de
              EMail   : mail@gausi.de
    -----------------------------------

    Unit AudioFileBasics

    TBaseAudioFile
      Abstract base class for all other AudioFiles

    TTagItem
      Base class for all TagItems like TID3v2Frame, TVorbisComment, ...


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

unit AudioFiles.Base;

interface

{$I config.inc}

uses Classes, SysUtils, AudioFiles.Declarations, AudioFiles.BaseTags
  {$IFDEF USE_GENERICS}, System.Generics.Collections {$ELSE}, System.Contnrs {$ENDIF}
  ;

type

    TBaseAudioFile = class
        protected
            fFileSize  	: Int64;
            fDuration   : Integer;
            fBitrate    : Integer;
            fSamplerate : Integer;
            fChannels   : Integer;
            fValid      : Boolean;
            fFileName   : UnicodeString;

            function fGetFileSize   : Int64;    virtual;
            function fGetDuration   : Integer;  virtual;
            function fGetBitrate    : Integer;  virtual;
            function fGetSamplerate : Integer;  virtual;
            function fGetChannels   : Integer;  virtual;
            function fGetValid      : Boolean;  virtual;

            // Setter/Getter for basic Metadata
            function fGetTitle     : UnicodeString;  virtual; abstract;
            function fGetArtist    : UnicodeString;  virtual; abstract;
            function fGetAlbumArtist : UnicodeString;  virtual; abstract;
            function fGetAlbum     : UnicodeString;  virtual; abstract;
            function fGetYear      : UnicodeString;  virtual; abstract;
            function fGetTrack     : UnicodeString;  virtual; abstract;
            function fGetGenre     : UnicodeString;  virtual; abstract;
            function fGetLyrics    : UnicodeString;  virtual; abstract;

            procedure fSetTitle    (aValue: UnicodeString);  virtual; abstract;
            procedure fSetArtist   (aValue: UnicodeString);  virtual; abstract;
            procedure fSetAlbumArtist   (aValue: UnicodeString);  virtual; abstract;
            procedure fSetAlbum    (aValue: UnicodeString);  virtual; abstract;
            procedure fSetYear     (aValue: UnicodeString);  virtual; abstract;
            procedure fSetTrack    (aValue: UnicodeString);  virtual; abstract;
            procedure fSetGenre    (aValue: UnicodeString);  virtual; abstract;
            procedure fSetLyrics   (aValue: UnicodeString);  virtual; abstract;

            function fGetFileType            : TAudioFileType; virtual; abstract;
            function fGetFileTypeDescription : String;         virtual; abstract;

        public
            property Valid      : Boolean read fGetValid;
            property FileSize 	: Int64	  read fGetFileSize;
            // Basic Audio data
            property Duration   : Integer read fGetDuration;
            property Bitrate    : Integer read fGetBitrate;
            property Samplerate : Integer read fGetSamplerate;
            property Channels   : Integer read fGetChannels;

            property Filename   : UnicodeString read fFileName;
            property FileType   : TAudioFileType read fGetFileType;
            property FileTypeDescription : String read fGetFileTypeDescription;

            // Basic Meta data from Tags
            property Title   : UnicodeString read fGetTitle  write fSetTitle ;
            property Artist  : UnicodeString read fGetArtist write fSetArtist;
            property AlbumArtist  : UnicodeString read fGetAlbumArtist write fSetAlbumArtist;
            property Album   : UnicodeString read fGetAlbum  write fSetAlbum ;
            property Year    : UnicodeString read fGetYear   write fSetYear  ;
            property Track   : UnicodeString read fGetTrack  write fSetTrack ;
            property Genre   : UnicodeString read fGetGenre  write fSetGenre ;
            property Lyrics  : UnicodeString read fGetLyrics write fSetLyrics;

            constructor Create; virtual; abstract;

            function ReadFromFile(aFilename: UnicodeString): TAudioError;    virtual;
            function WriteToFile(aFilename: UnicodeString): TAudioError;     virtual;
            function RemoveFromFile(aFilename: UnicodeString): TAudioError;  virtual;
            function UpdateFile: TAudioError;

            // - GetTagList will return a list of all contained tag items in the file that
            //   matches the given ContentTypes.
            // - DeleteTagItem will remove a tag item from the file.
            //   Note: It is simple to remove a tag item. *Restoring* it may be more
            //         complicated or even close to impossible in some cases, as the tag item
            //         could use a proprietary binary format which is unknown to you.
            procedure GetTagList(Dest: TTagItemList; ContentTypes: TTagContentTypes = cDefaultTagContentTypes); virtual; abstract;
            procedure DeleteTagItem(aTagItem: TTagItem); virtual; abstract;

            // These methods are designed to add new text tag items easily.
            // - GetUnusedTextTags can be used to create a list of “permitted” standard text tag items that are
            //   not yet existing in the file.
            function GetUnusedTextTags: TTagItemInfoDynArray; virtual; abstract;
            // - AddTextTagItem creates a new text tag item selected from this list.
            // You may use other (tag specific) methods to allow the end user to add more tag items than
            // returned by GetUnusedTextTags
            function AddTextTagItem(aKey, aValue: UnicodeString): TTagItem; virtual; abstract;

            // Abstract methods to get/set picture data from the meta tag of the file.
            // Note that not all parameters are used in all meta tag formats.
            function GetPicture(Dest: TStream; out Mime: AnsiString; out PicType: TPictureType; out Description: UnicodeString): Boolean; virtual;
            function SetPicture(Source: TStream; Mime: AnsiString; PicType: TPictureType; Description: UnicodeString): Boolean; virtual; abstract;
    end;

    TBaseAudioFileClass = class of TBaseAudioFile;


implementation


{ TBaseAudioFile }


function TBaseAudioFile.fGetFileSize: Int64;
begin
  result := fFileSize;
end;

function TBaseAudioFile.fGetDuration: Integer;
begin
  result := fDuration;
end;

function TBaseAudioFile.fGetBitrate: Integer;
begin
  result := fBitrate;
end;

function TBaseAudioFile.fGetSamplerate: Integer;
begin
  result := fSamplerate;
end;

function TBaseAudioFile.fGetChannels: Integer;
begin
  result := fChannels;
end;

function TBaseAudioFile.fGetValid: Boolean;
begin
  result := fValid;
end;

function TBaseAudioFile.ReadFromFile(aFilename: UnicodeString): TAudioError;
begin
    fFileName := aFilename;
    result := FileErr_None;
end;

function TBaseAudioFile.RemoveFromFile(aFilename: UnicodeString): TAudioError;
begin
    fFileName := aFilename;
    result := FileErr_None;
end;

function TBaseAudioFile.WriteToFile(aFilename: UnicodeString): TAudioError;
begin
    fFileName := aFilename;
    result := FileErr_None;
end;

function TBaseAudioFile.UpdateFile: TAudioError;
begin
    result := WriteToFile(fFileName);
end;

function TBaseAudioFile.GetPicture(Dest: TStream; out Mime: AnsiString; out PicType: TPictureType; out Description: UnicodeString): Boolean;
var
  TagItems: TTagItemList;
begin
  TagItems := TTagItemList.Create;
  try
    GetTagList(TagItems, [tctPicture]);
    if TagItems.Count > 0 then begin
      result := TagItems[0].GetPicture(Dest, Mime, PicType, Description);
    end else begin
      result := False;
      Mime := '';
      PicType := ptOther;
      Description := '';
    end;
  finally
    TagItems.Free;
  end;
end;

end.
