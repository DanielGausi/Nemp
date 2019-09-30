{
    -----------------------------------
    Audio Werkzeuge Bibliothek
    -----------------------------------
    (c) 2012, Daniel Gaussmann
              Website : www.gausi.de
              EMail   : mail@gausi.de
    -----------------------------------

    Unit AudioFiles

    "Super class" for all types of Audiofiles

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

unit AudioFiles;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, ContNrs,
  AudioFileBasics, Apev2Tags, ApeTagItem, ID3v2Frames,
  Mp3Files, FlacFiles, OggVorbisFiles, M4AFiles,
  MonkeyFiles, WavPackFiles, MusePackFiles, OptimFrogFiles, TrueAudioFiles,
  WmaFiles, WavFiles;


type
    TAudioFileType = (at_Invalid,
                      at_Mp3,
                      at_Ogg,
                      at_Flac,
                      at_M4A,
                      at_Monkey,
                      at_WavPack,
                      at_MusePack,
                      at_OptimFrog,
                      at_TrueAudio,
                      at_Wma,
                      at_Wav);

const    TAudioFileNames: Array[TAudioFileType] of String =
          ( 'Invalid Audiofile',
            'MPEG Audio',
            'Ogg/Vorbis',
            'Free Lossless Audio Codec',
            'MPEG-4',
            'Monkey''s Audio',
            'WavPack',
            'Musepack',
            'OptimFROG',
            'The True Audio',
            'Windows Media Audio',
            'RIFF WAVE'  );

type
    TGeneralAudioFile = class
        private
            fBaseAudioFile: TBaseAudioFile;
            fFileType: TAudioFileType;
            fFilename: UnicodeString;

            //fFileSize  	: Int64;
            //fDuration   : Integer;
            //fBitrate    : Integer;
            //fSamplerate : Integer;
            //fChannels   : Integer;
            //fValid      : Boolean;

            fLastError  : TAudioError;

            function fGetFileTypeName: String;

            function fGetFileSize   : Int64;
            function fGetDuration   : Integer;
            function fGetBitrate    : Integer;
            function fGetSamplerate : Integer;
            function fGetChannels   : Integer;
            function fGetValid      : Boolean;

            // Setter/Getter for basic Metadata
            function fGetTitle     : UnicodeString;
            function fGetArtist    : UnicodeString;
            function fGetAlbum     : UnicodeString;
            function fGetYear      : UnicodeString;
            function fGetTrack     : UnicodeString;
            function fGetGenre     : UnicodeString;
            procedure fSetTitle    (aValue: UnicodeString);
            procedure fSetArtist   (aValue: UnicodeString);
            procedure fSetAlbum    (aValue: UnicodeString);
            procedure fSetYear     (aValue: UnicodeString);
            procedure fSetTrack    (aValue: UnicodeString);
            procedure fSetGenre    (aValue: UnicodeString);

            function fGetMP3File       : TMp3File       ;
            function fGetOggFile       : TOggVorbisFile ;
            function fGetFlacFile      : TFlacFile      ;
            function fGetM4AFile       : TM4AFile       ;
            function fGetBaseApeFile   : TBaseApeFile   ;
            function fGetMonkeyFile    : TMonkeyFile    ;
            function fGetWavPackFile   : TWavPackFile   ;
            function fMusePackGetFile  : TMusePackFile  ;
            function fGetOptimFrogFile : TOptimFrogFile ;
            function fGetTrueAudioFile : TTrueAudioFile ;
            function fGetWmaFile       : TWmaFile       ;
            function fGetWavFile       : TWavFile       ;


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


            property MP3File       : TMp3File       read fGetMP3File      ;
            property OggFile       : TOggVorbisFile read fGetOggFile      ;
            property FlacFile      : TFlacFile      read fGetFlacFile     ;
            property M4aFile       : TM4AFile       read fGetM4AFile      ;

            property BaseApeFile   : TBaseApeFile   read fGetBaseApeFile  ;
            property MonkeyFile    : TMonkeyFile    read fGetMonkeyFile   ;
            property WavPackFile   : TWavPackFile   read fGetWavPackFile  ;
            property MusePackFile  : TMusePackFile  read fMusePackGetFile ;
            property OptimFrogFile : TOptimFrogFile read fGetOptimFrogFile;
            property TrueAudioFile : TTrueAudioFile read fGetTrueAudioFile;
            property WmaFile       : TWMAFile       read fGetWmaFile      ;
            property WavFile       : TWavFile       read fGetWavFile      ;

            property FileType: TAudioFileType read fFileType;
            property Filename: UnicodeString read fFilename;
            property FileTypeName: String read fGetFileTypeName;

            property LastError : TAudioError read fLastError;

            constructor Create(aFilename: UnicodeString);
            destructor Destroy; override;

            //function ReadFromFile(aFilename: UnicodeString): TAudioError;
            function UpdateFile: TAudioError;
            function RemoveFromFile: TAudioError;
    end;

implementation

{ TAudioFile }

constructor TGeneralAudioFile.Create(aFilename: UnicodeString);
var ext: UnicodeString;
begin
    ext := AnsiLowercase(ExtractFileExt(aFileName));
    fFilename := aFilename;
    if (ext = '.mp3')
        or (ext = '.mp2')
        or (ext = '.mp1')
    then
    begin
        fBaseAudioFile := TMP3File.Create;
        fFileType := at_Mp3;
    end
    else
    if (ext = '.ogg')
        or (ext = '.oga')
    then
    begin
        fBaseAudioFile := TOggVorbisFile.Create;
        fFileType := at_Ogg;
    end
    else
    if (ext = '.flac')
        or (ext = '.fla')
    then
    begin
        fBaseAudioFile := TFlacFile.Create;
        fFileType := at_Flac;
    end
    else
    if (ext = '.m4a')
        or (ext = '.mp4')
    then
    begin
        fBaseAudioFile := TM4AFile.Create;
        fFileType := at_M4A;
    end
    else
    if (ext = '.ape')
        or (ext = '.mac')
    then
    begin
        fBaseAudioFile := TMonkeyFile.Create;
        fFileType := at_Monkey;
    end
    else
    if (ext = '.wv')
    then
    begin
        fBaseAudioFile := TWavPackFile.Create;
        fFileType := at_WavPack;
    end
    else
    if (ext = '.mpc')
        or (ext = '.mp+')
        or (ext = '.mpp')
    then
    begin
        fBaseAudioFile := TMusePackFile.Create;
        fFileType := at_MusePack;
    end
    else
    if (ext = '.ofr')
        or (ext = '.ofs')
    then
    begin
        fBaseAudioFile := TOptimFrogFile.Create;
        fFileType := at_OptimFrog;
    end
    else
    if (ext = '.tta')
    then
    begin
        fBaseAudioFile := TTrueAudioFile.Create;
        fFileType := at_TrueAudio;
    end
    else
    if (ext = '.wma')
    then
    begin
        fBaseAudioFile := TWmaFile.Create;
        fFileType := at_Wma;
    end
    else
    if (ext = '.wav')
    then
    begin
        fBaseAudioFile := TWavFile.Create;
        fFileType := at_Wav;
    end
    else
    begin
        fBaseAudioFile := Nil;
        fFileType := at_Invalid;
    end;

    if assigned(fBaseAudioFile) then
        fLastError := fBaseAudioFile.ReadFromFile(aFilename)
    else
        fLastError := FileErr_NotSupportedFileType;
end;

destructor TGeneralAudioFile.Destroy;
begin
    if Assigned(fBaseAudioFile) then
        fBaseAudioFile.Free;
    inherited;
end;

function TGeneralAudioFile.fGetFileTypeName: String;
begin
    result := TAudioFileNames[fFileType];
end;

{
    fGet<*>File
    Get a specialised AudioFile for deeper manipulation
}
function TGeneralAudioFile.fGetFlacFile: TFlacFile;
begin
    if fFileType = at_Flac then
        result := TFlacFile(fBaseAudioFile)
    else
        result := Nil
end;

function TGeneralAudioFile.fGetM4AFile: TM4AFile;
begin
    if fFileType = at_M4A then
        result := TM4AFile(fbaseAudioFile)
    else
        result := Nil;
end;

function TGeneralAudioFile.fGetBaseApeFile: TBaseApeFile;
begin
    if fFileType in [at_Monkey, at_WavPack, at_MusePack, at_OptimFrog, at_TrueAudio] then
        result := TBaseApeFile(fBaseAudioFile)
    else
        result := Nil
end;
function TGeneralAudioFile.fGetMonkeyFile: TMonkeyFile;
begin
    if fFileType = at_Monkey then
        result := TMonkeyFile(fBaseAudioFile)
    else
        result := Nil
end;
function TGeneralAudioFile.fGetMP3File: TMp3File;
begin
    if fFileType = at_Mp3 then
        result := TMp3File(fBaseAudioFile)
    else
        result := Nil
end;
function TGeneralAudioFile.fMusePackGetFile: TMusePackFile;
begin
    if fFileType = at_MusePack then
        result := TMusePackFile(fBaseAudioFile)
    else
        result := Nil
end;
function TGeneralAudioFile.fGetOggFile: TOggVorbisFile;
begin
    if fFileType = at_Ogg then
        result := TOggVorbisFile(fBaseAudioFile)
    else
        result := Nil
end;
function TGeneralAudioFile.fGetOptimFrogFile: TOptimFrogFile;
begin
    if fFileType = at_OptimFrog then
        result := TOptimFrogFile(fBaseAudioFile)
    else
        result := Nil
end;
function TGeneralAudioFile.fGetTrueAudioFile: TTrueAudioFile;
begin
    if fFileType = at_TrueAudio then
        result := TTrueAudioFile(fBaseAudioFile)
    else
        result := Nil
end;
function TGeneralAudioFile.fGetWavPackFile: TWavPackFile;
begin
    if fFileType = at_Wavpack then
        result := TWavPackFile(fBaseAudioFile)
    else
        result := Nil
end;
function TGeneralAudioFile.fGetWmaFile: TWmaFile;
begin
    if fFileType = at_Wma then
        result := TWmaFile(fBaseAudioFile)
    else
        result := Nil
end;
function TGeneralAudioFile.fGetWavFile: TWavFile;
begin
    if fFileType = at_Wav then
        result := TWavFile(fBaseAudioFile)
    else
        result := Nil
end;

{
    fGet<*>
    Getter for
      - Basic MetaTag Properties
      - Basic Audio Properties
}
function TGeneralAudioFile.fGetAlbum: UnicodeString;
begin
    if assigned(fBaseAudioFile) then
        result := fBaseAudioFile.Album
    else
        result := ''
end;
function TGeneralAudioFile.fGetArtist: UnicodeString;
begin
    if assigned(fBaseAudioFile) then
        result := fBaseAudioFile.Artist
    else
        result := ''
end;
function TGeneralAudioFile.fGetBitrate: Integer;
begin
    if assigned(fBaseAudioFile) then
        result := fBaseAudioFile.Bitrate
    else
        result := 0
end;
function TGeneralAudioFile.fGetChannels: Integer;
begin
        if assigned(fBaseAudioFile) then
        result := fBaseAudioFile.Channels
    else
        result := 0
end;
function TGeneralAudioFile.fGetDuration: Integer;
begin
    if assigned(fBaseAudioFile) then
        result := fBaseAudioFile.Duration
    else
        result := 0
end;
function TGeneralAudioFile.fGetFileSize: Int64;
begin
    if assigned(fBaseAudioFile) then
        result := fBaseAudioFile.FileSize
    else
        result := 0
end;
function TGeneralAudioFile.fGetGenre: UnicodeString;
begin
    if assigned(fBaseAudioFile) then
        result := fBaseAudioFile.Genre
    else
        result := ''
end;
function TGeneralAudioFile.fGetSamplerate: Integer;
begin
    if assigned(fBaseAudioFile) then
        result := fBaseAudioFile.Samplerate
    else
        result := 0
end;
function TGeneralAudioFile.fGetTitle: UnicodeString;
begin
    if assigned(fBaseAudioFile) then
        result := fBaseAudioFile.Title
    else
        result := ''
end;
function TGeneralAudioFile.fGetTrack: UnicodeString;
begin
    if assigned(fBaseAudioFile) then
        result := fBaseAudioFile.Track
    else
        result := ''
end;
function TGeneralAudioFile.fGetValid: Boolean;
begin
    if assigned(fBaseAudioFile) then
        result := fBaseAudioFile.Valid
    else
        result := False
end;
function TGeneralAudioFile.fGetYear: UnicodeString;
begin
    if assigned(fBaseAudioFile) then
        result := fBaseAudioFile.Year
    else
        result := ''
end;

{
    fSet<*>
    Setter for Basic MetaTag Properties
}
procedure TGeneralAudioFile.fSetAlbum(aValue: UnicodeString);
begin
    if assigned(fBaseAudioFile) then
        fBaseAudioFile.Album := aValue;
end;
procedure TGeneralAudioFile.fSetArtist(aValue: UnicodeString);
begin
    if assigned(fBaseAudioFile) then
        fBaseAudioFile.Artist := aValue;
end;
procedure TGeneralAudioFile.fSetGenre(aValue: UnicodeString);
begin
    if assigned(fBaseAudioFile) then
        fBaseAudioFile.Genre := aValue;
end;
procedure TGeneralAudioFile.fSetTitle(aValue: UnicodeString);
begin
    if assigned(fBaseAudioFile) then
        fBaseAudioFile.Title := aValue;
end;
procedure TGeneralAudioFile.fSetTrack(aValue: UnicodeString);
begin
    if assigned(fBaseAudioFile) then
        fBaseAudioFile.Track := aValue;
end;
procedure TGeneralAudioFile.fSetYear(aValue: UnicodeString);
begin
    if assigned(fBaseAudioFile) then
        fBaseAudioFile.Year := aValue;
end;

function TGeneralAudioFile.RemoveFromFile: TAudioError;
begin
    if assigned(fBaseAudioFile) then
        result := fBaseAudioFile.RemoveFromFile(fFilename)
    else
        result := FileErr_NotSupportedFileType
end;

function TGeneralAudioFile.UpdateFile: TAudioError;
begin
    if assigned(fBaseAudioFile) then
        result := fBaseAudioFile.WriteToFile(fFilename)
    else
        result := FileErr_NotSupportedFileType
end;

end.
