{
    -----------------------------------
    Audio Werkzeuge Bibliothek
    -----------------------------------
    (c) 2012, Daniel Gaussmann
              Website : www.gausi.de
              EMail   : mail@gausi.de
    -----------------------------------

    Unit AudioFileBasics

    Abstract base class for all other AudioFiles

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

unit AudioFileBasics;

interface

{$I config.inc}

uses Classes, SysUtils
    {$IFDEF USE_TNT_COMPOS}, TntSysUtils, TntClasses{$ENDIF};

type

    {$IFNDEF UNICODE}
        UnicodeString = WideString;
    {$ENDIF}

    {$IFDEF USE_TNT_COMPOS}
      TAudioFileStream = TTNTFileStream;
    {$ELSE}
      TAudioFileStream = TFileStream;
    {$ENDIF}

    TAudioError = (
          FileErr_None,
          FileErr_NoFile,
          FileErr_FileCreate,
          FileErr_FileOpenR,
          FileErr_FileOpenRW,
          FileErr_ReadOnly,

          MP3ERR_StreamRead,
          MP3ERR_StreamWrite,
          Mp3ERR_Cache,
          Mp3ERR_NoTag,
          MP3ERR_Invalid_Header,
          Mp3ERR_Compression,
          Mp3ERR_Unclassified,
          MP3ERR_NoMpegFrame,

          // OggFiles
          OVErr_InvalidFirstPageHeader,
          OVErr_InvalidFirstPage,
          OVErr_InvalidSecondPageHeader,
          OVErr_InvalidSecondPage,
          OVErr_CommentTooLarge,
          OVErr_BackupFailed,
          OVErr_DeleteBackupFailed,
          OVErr_RemovingNotSupported,

          // FlacFiles
          FlacErr_InvalidFlacFile,
          FlacErr_MetaDataTooLarge,
          FlacErr_BackupFailed,
          FlacErr_DeleteBackupFailed,
          FlacErr_RemovingNotSupported,

          // ApeFiles
          ApeErr_InvalidApeFile,
          ApeErr_InvalidTag,
          ApeErr_NoTag,

          // WMA Files
          WmaErr_WritingNotSupported,

          // Wav Files
          WavErr_WritingNotSupported,

          // M4a Files
          M4AErr_64BitNotSupported,
          M4aErr_Invalid_TopLevelAtom,
          M4aErr_Invalid_UDTA,
          // M4aErr_Invalid_META,
          M4aErr_Invalid_METAVersion,
          M4aErr_Invalid_MDHD,
          M4aErr_Invalid_STSD,
          M4aErr_Invalid_STCO,
          M4aErr_Invalid_STBL,
          M4aErr_Invalid_TRAK,
          M4aErr_Invalid_MDIA,
          M4aErr_Invalid_MINF,
          M4aErr_Invalid_MOOV,
          M4aErr_Invalid_DuplicateUDTA,
          M4aErr_Invalid_DuplicateTRAK,

          M4aErr_RemovingNotSupported,

          //
          FileErr_NotSupportedFileType
          );

{    const
      AudioErrorString: Array[TAudioError] of String = (
              'No Error',
              'File not found',
              'FileCreate failed.',
              'Could not read from file',
              'Could not write into file',
              'File is read-only',
              'Reading from stream failed',
              'Writing to stream failed',
              // Id3
              'Caching audiodata failed',
              'No ID3-Tag found',
              'Invalid header for ID3v2-Tag',
              'Compressed ID3-Tag found',
              'Unknown ID3-Error',
              // mpeg
              'Invalid MP3-File: No audioframe found',
              // Ogg
              'Invalid Ogg-Vorbis-File: First Vorbis-Header corrupt',
              'Invalid Ogg-Vorbis-File: First Ogg-Page corrupt',
              'Invalid Ogg-Vorbis-File: Second Vorbis-Header corrupt',
              'Invalid Ogg-Vorbis-File: Second Ogg-Page corrupt',
              'Comment too large (sorry, Flogger limitation)',
              'Backup failed',
              'Delete backup failed',
              'Removing Tag not supported.',
              // Flac
              'Invalid Flac-File',
              'Metadata-Block exceeds maximum size',
              'Type of Metadata is not supported - use mp3, ogg or flac',
              'Quick access to metadata denied',
              'Removing Tag not supported.',

               'Invalid Apev2 file',
               'Invalid Apev2Tag',
               'No Apev2tag found' );
       }
type

    TBaseAudioFile = class
        protected
            fFileSize  	: Int64;
            fDuration   : Integer;
            fBitrate    : Integer;
            fSamplerate : Integer;
            fChannels   : Integer;
            fValid      : Boolean;

            function fGetFileSize   : Int64;    virtual; abstract;
            function fGetDuration   : Integer;  virtual; abstract;
            function fGetBitrate    : Integer;  virtual; abstract;
            function fGetSamplerate : Integer;  virtual; abstract;
            function fGetChannels   : Integer;  virtual; abstract;
            function fGetValid      : Boolean;  virtual; abstract;

            // Setter/Getter for basic Metadata
            function fGetTitle     : UnicodeString;  virtual; abstract;
            function fGetArtist    : UnicodeString;  virtual; abstract;
            function fGetAlbum     : UnicodeString;  virtual; abstract;
            function fGetYear      : UnicodeString;  virtual; abstract;
            function fGetTrack     : UnicodeString;  virtual; abstract;
            function fGetGenre     : UnicodeString;  virtual; abstract;
            procedure fSetTitle    (aValue: UnicodeString);  virtual; abstract;
            procedure fSetArtist   (aValue: UnicodeString);  virtual; abstract;
            procedure fSetAlbum    (aValue: UnicodeString);  virtual; abstract;
            procedure fSetYear     (aValue: UnicodeString);  virtual; abstract;
            procedure fSetTrack    (aValue: UnicodeString);  virtual; abstract;
            procedure fSetGenre    (aValue: UnicodeString);  virtual; abstract;

        public
            property Valid      : Boolean read fGetValid;
            property FileSize 	: Int64	  read fGetFileSize;
            // Basic Audio data
            property Duration   : Integer read fGetDuration;
            property Bitrate    : Integer read fGetBitrate;
            property Samplerate : Integer read fGetSamplerate;
            property Channels   : Integer read fGetChannels;

            // Basic Meta data from Tags
            property Title   : UnicodeString read fGetTitle  write fSetTitle ;
            property Artist  : UnicodeString read fGetArtist write fSetArtist;
            property Album   : UnicodeString read fGetAlbum  write fSetAlbum ;
            property Year    : UnicodeString read fGetYear   write fSetYear  ;
            property Track   : UnicodeString read fGetTrack  write fSetTrack ;
            property Genre   : UnicodeString read fGetGenre  write fSetGenre ;

            function ReadFromFile(aFilename: UnicodeString): TAudioError;    virtual; abstract;
            function WriteToFile(aFilename: UnicodeString): TAudioError;     virtual; abstract;
            function RemoveFromFile(aFilename: UnicodeString): TAudioError;  virtual; abstract;

    end;


    function  AudioFileExists(aString: UnicodeString):boolean;
    function ConvertUTF8ToString(aUTF8String: UTF8String): UnicodeString;
    function ConvertStringToUTF8(aString: UnicodeString): UTF8String;


implementation

function ConvertUTF8ToString(aUTF8String: UTF8String): UnicodeString;
begin
    {$IFDEF UNICODE}
        result := UnicodeString(aUTF8String);
    {$ELSE}
        result := Utf8Decode(aUTF8String);
    {$ENDIF}
end;

function ConvertStringToUTF8(aString: UnicodeString): UTF8String;
begin
    {$IFDEF UNICODE}
        result := UTF8String(aString);
    {$ELSE}
        result := Utf8Encode(aString);
    {$ENDIF}
end;

function AudioFileExists(aString: UnicodeString):boolean;
begin
    {$IFDEF USE_TNT_COMPOS}
        result := WideFileExists(aString);
    {$ELSE}
        result := FileExists(aString);
    {$ENDIF}
end;

end.
