{
    -----------------------------------
    Audio Werkzeuge Bibliothek
    -----------------------------------
    (c) 2012, Daniel Gaussmann
              Website : www.gausi.de
              EMail   : mail@gausi.de
    -----------------------------------
    contains parts of
        Audio Tools Library
        http://mac.sourceforge.net/atl/
        e-mail: macteam@users.sourceforge.net

        Copyright (c) 2000-2002 by Jurgen Faul
        Copyright (c) 2003-2005 by The MAC Team
    -----------------------------------

    Unit WmaFiles

    Get audio information from WMA Files (*.wma)
    (read only)

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

unit WmaFiles;

interface

uses Classes, SysUtils, AudioFileBasics;

const
  // Channel modes
    WMA_CM_UNKNOWN = 0;       // Unknown
    WMA_CM_MONO = 1;          // Mono
    WMA_CM_STEREO = 2;        // Stereo

    // Channel mode names
    WMA_MODE: array [0..2] of String = ('Unknown', 'Mono', 'Stereo');

type

    TWMAfile = class(TBaseAudioFile)
        private
            { Private declarations }
            fChannelModeID: Byte;
            fTitle: UnicodeString;
            fArtist: UnicodeString;
            fAlbum: UnicodeString;
            fTrack: UnicodeString;
            fYear: UnicodeString;
            fGenre: UnicodeString;
            fComment: UnicodeString;
            procedure fResetData;
            function fGetChannelMode: String;
        protected
            function fGetFileSize   : Int64;    override;
            function fGetDuration   : Integer;  override;
            function fGetBitrate    : Integer;  override;
            function fGetSamplerate : Integer;  override;
            function fGetChannels   : Integer;  override;
            function fGetValid      : Boolean;  override;

            procedure fSetTitle           (aValue: UnicodeString); override;
            procedure fSetArtist          (aValue: UnicodeString); override;
            procedure fSetAlbum           (aValue: UnicodeString); override;
            procedure fSetYear            (aValue: UnicodeString); override;
            procedure fSetTrack           (aValue: UnicodeString); override;
            procedure fSetGenre           (aValue: UnicodeString); override;

            function fGetTitle            : UnicodeString; override;
            function fGetArtist           : UnicodeString; override;
            function fGetAlbum            : UnicodeString; override;
            function fGetYear             : UnicodeString; override;
            function fGetTrack            : UnicodeString; override;
            function fGetGenre            : UnicodeString; override;

        public
            { Public declarations }
            constructor Create;                                     { Create object }
            function ReadFromFile(aFilename: UnicodeString): TAudioError;   override;
            function WriteToFile(aFilename: UnicodeString): TAudioError;    override;
            function RemoveFromFile(aFilename: UnicodeString): TAudioError; override;
            property ChannelModeID: Byte read FChannelModeID;   { Channel mode code }
            property ChannelMode: string read FGetChannelMode;  { Channel mode name }
            property Comment: UnicodeString read FComment;               { Comment }
        end;

implementation

const
  { Object IDs }
  WMA_HEADER_ID =
    #48#38#178#117#142#102#207#17#166#217#0#170#0#98#206#108;
    //  16 Bytes
    //  30  26  b2  75                                    CE  6C

  WMA_FILE_PROPERTIES_ID =
    #161#220#171#140#71#169#207#17#142#228#0#192#12#32#83#101;
    // 16 Bytes
    //    A1 DC  AB  8C                                20  53  65

  WMA_STREAM_PROPERTIES_ID =
    #145#7#220#183#183#169#207#17#142#230#0#192#12#32#83#101;
    //   91  7  DC  B7                              0C 20 53  65

  WMA_CONTENT_DESCRIPTION_ID =
    #51#38#178#117#142#102#207#17#166#217#0#170#0#98#206#108;
    //   33  26 B2  75                              0 62   CE 6C

  WMA_EXTENDED_CONTENT_DESCRIPTION_ID =
    #64#164#208#210#7#227#210#17#151#240#0#160#201#94#168#80;
    //  40   A4  D0  D2                            C9  5E  A8  50

  { Max. number of supported comment fields }
  WMA_FIELD_COUNT = 8;

  { Names of supported comment fields }
  WMA_FIELD_NAME: array [1..WMA_FIELD_COUNT] of UnicodeString =
    ('WM/TITLE', 'WM/AUTHOR', 'WM/ALBUMTITLE', 'WM/TRACK', 'WM/YEAR',
     'WM/GENRE', 'WM/DESCRIPTION', 'WM/TRACKNUMBER');

  { Max. number of characters in tag field }
  WMA_MAX_STRING_SIZE = 250;

type                                  
  // Object ID
  ObjectID = array [1..16] of AnsiChar;

  // Tag data
  TagData = array [1..WMA_FIELD_COUNT] of UnicodeString;

  // File data - for internal use
  FileData = record
      MaxBitRate: Integer;              // Max. bit rate (bps)
      Channels: Word;                   // Number of channels
      SampleRate: Integer;              // Sample rate (hz)
      ByteRate: Integer;                // Byte rate
      Tag: TagData;                     // WMA tag information
  end;

{ ********************* Auxiliary functions & procedures ******************** }

function ReadFieldString(const Source: TStream; DataSize: Word): UnicodeString;
var Iterator, StringSize: Integer;
    FieldData: array [1..WMA_MAX_STRING_SIZE * 2] of Byte;
begin
    // Read field data and convert to Unicode string
    Result := '';
    StringSize := DataSize div 2;
    if StringSize > WMA_MAX_STRING_SIZE then StringSize := WMA_MAX_STRING_SIZE;
    Source.ReadBuffer(FieldData, StringSize * 2);
    Source.Seek(DataSize - StringSize * 2, soFromCurrent);
    for Iterator := 1 to StringSize do
        Result := Result +
            WideChar(FieldData[Iterator * 2 - 1] + (FieldData[Iterator * 2] shl 8));
end;

{ --------------------------------------------------------------------------- }

procedure ReadTagStandard(const Source: TStream; var Tag: TagData);
var Iterator: Integer;
    FieldSize: array [1..5] of Word;
    FieldValue: UnicodeString;
begin
    // Read standard tag data
    Source.ReadBuffer(FieldSize, SizeOf(FieldSize));
    for Iterator := 1 to 5 do
        if FieldSize[Iterator] > 0 then
        begin
            // Read field value
            FieldValue := ReadFieldString(Source, FieldSize[Iterator]);
            // Set corresponding tag field if supported
            case Iterator of
                1: Tag[1] := FieldValue;
                2: Tag[2] := FieldValue;
                4: Tag[7] := FieldValue;
            end;
        end;
end;

{ --------------------------------------------------------------------------- }

procedure ReadTagExtended(const Source: TStream; var Tag: TagData);
var Iterator1, Iterator2, FieldCount, DataSize, DataType: Word;
    FieldName, FieldValue: UnicodeString;
    FieldDWord: Cardinal;
begin
    // Read extended tag data
    Source.ReadBuffer(FieldCount, SizeOf(FieldCount));
    for Iterator1 := 1 to FieldCount do
    begin
      // Read field name
      Source.ReadBuffer(DataSize, SizeOf(DataSize));
      FieldName := ReadFieldString(Source, DataSize);
      // Read value data type
      Source.ReadBuffer(DataType, SizeOf(DataType));
      // Read field value only if string

      case DataType of
          0 : begin
                // WideString
                Source.ReadBuffer(DataSize, SizeOf(DataSize));
                FieldValue := ReadFieldString(Source, DataSize);
          end;
          3: begin
              // Dword   (length 4 bytes)
              Source.ReadBuffer(DataSize, SizeOf(DataSize));
              Source.ReadBuffer(FieldDWord, SizeOf(FieldDWord));
              FieldValue := IntToStr(FieldDWord);
          end;
      else
          begin
              Source.ReadBuffer(DataSize, SizeOf(DataSize));
              Source.Seek(DataSize, soFromCurrent);
          end;
      end;
    
      // Set corresponding tag field if supported
      for Iterator2 := 1 to WMA_FIELD_COUNT do
        if UpperCase(Trim(FieldName)) = WMA_FIELD_NAME[Iterator2] then
          Tag[Iterator2] := FieldValue;
    end;
end;

{ --------------------------------------------------------------------------- }

procedure ReadObject(const ID: ObjectID; Source: TStream; var Data: FileData);
begin
    // Read data from header object if supported
    if ID = WMA_FILE_PROPERTIES_ID then
    begin
        // Read file properties
        Source.Seek(80, soFromCurrent);
        Source.ReadBuffer(Data.MaxBitRate, SizeOf(Data.MaxBitRate));
    end;
    if ID = WMA_STREAM_PROPERTIES_ID then
    begin
        // Read stream properties
        Source.Seek(60, soFromCurrent);
        Source.ReadBuffer(Data.Channels, SizeOf(Data.Channels));
        Source.ReadBuffer(Data.SampleRate, SizeOf(Data.SampleRate));
        Source.ReadBuffer(Data.ByteRate, SizeOf(Data.ByteRate));
    end;
    if ID = WMA_CONTENT_DESCRIPTION_ID then
    begin
        // Read standard tag data
        Source.Seek(4, soFromCurrent);
        ReadTagStandard(Source, Data.Tag);
    end;
    if ID = WMA_EXTENDED_CONTENT_DESCRIPTION_ID then
    begin
        // Read extended tag data
        Source.Seek(4, soFromCurrent);
        ReadTagExtended(Source, Data.Tag);
    end;
end;

{ --------------------------------------------------------------------------- }


{ ********************** Private functions & procedures ********************* }

procedure TWMAfile.FResetData;
begin
    // Reset variables
    fValid := false;
    fFileSize := 0;
    fChannelModeID := WMA_CM_UNKNOWN;
    fChannels := 0;
    fSampleRate := 0;
    fDuration := 0;
    fBitRate := 0;
    fTitle := '';
    fArtist := '';
    fAlbum := '';
    fTrack := '0';
    fYear := '';
    fGenre := '';
    fComment := '';
end;

procedure TWMAfile.fSetAlbum(aValue: UnicodeString);
begin
  inherited;
  // nothing. This Unit is read-Only
end;

procedure TWMAfile.fSetArtist(aValue: UnicodeString);
begin
  inherited;
  // nothing. This Unit is read-Only
end;

procedure TWMAfile.fSetGenre(aValue: UnicodeString);
begin
  inherited;
  // nothing. This Unit is read-Only
end;

procedure TWMAfile.fSetTitle(aValue: UnicodeString);
begin
  inherited;
  // nothing. This Unit is read-Only
end;

procedure TWMAfile.fSetTrack(aValue: UnicodeString);
begin
  inherited;
  // nothing. This Unit is read-Only
end;

procedure TWMAfile.fSetYear(aValue: UnicodeString);
begin
  inherited;
  // nothing. This Unit is read-Only
end;

{ --------------------------------------------------------------------------- }

function TWMAfile.fGetAlbum: UnicodeString;
begin
    result := fAlbum;
end;

function TWMAfile.fGetArtist: UnicodeString;
begin
    result := fArtist;
end;

function TWMAfile.fGetBitrate: Integer;
begin
    result := fBitrate;
end;

function TWMAfile.FGetChannelMode: string;
begin
  { Get channel mode name }
  Result := WMA_MODE[FChannelModeID];
end;

function TWMAfile.fGetChannels: Integer;
begin
    result := fChannelModeID;
end;

function TWMAfile.fGetDuration: Integer;
begin
    result := fDuration;
end;

function TWMAfile.fGetFileSize: Int64;
begin
    result := fFileSize
end;

function TWMAfile.fGetGenre: UnicodeString;
begin
    result := fGenre;
end;

function TWMAfile.fGetSamplerate: Integer;
begin
    result := fSamplerate;
end;

function TWMAfile.fGetTitle: UnicodeString;
begin
    result := fTitle;
end;

function TWMAfile.fGetTrack: UnicodeString;
begin
    result := fTrack;
end;

function TWMAfile.fGetValid: Boolean;
begin
    result := fValid;
end;

function TWMAfile.fGetYear: UnicodeString;
begin
    result := fYear;
end;

{ ********************** Public functions & procedures ********************** }

constructor TWMAfile.Create;
begin
  { Create object }
  inherited;
  FResetData;
end;

{ --------------------------------------------------------------------------- }

function TWMAfile.ReadFromFile(aFilename: UnicodeString): TAudioError;
var
  Data: FileData;
  fs: TFileStream;
  ID: ObjectID;
  Iterator, ObjectCount, ObjectSize, Position: Integer;
begin
    // Reset variables and load file data
    fResetData;
    FillChar(Data, SizeOf(Data), 0);
    result := FileErr_None;
    if AudioFileExists(aFilename) then
    begin
        try
            fs := TAudioFileStream.Create(aFilename, fmOpenRead or fmShareDenyWrite);
            try
                fFileSize := fs.Size;

                fs.ReadBuffer(ID, SizeOf(ID));
                if ID = WMA_HEADER_ID then
                begin
                    fs.Seek(8, soFromCurrent);
                    fs.ReadBuffer(ObjectCount, SizeOf(ObjectCount));
                    fs.Seek(2, soFromCurrent);
                    // Read all objects in header and get needed data
                    for Iterator := 1 to ObjectCount do
                    begin
                        Position := fs.Position;
                        fs.ReadBuffer(ID, SizeOf(ID));
                        fs.ReadBuffer(ObjectSize, SizeOf(ObjectSize));
                        ReadObject(ID, fs, Data);
                        fs.Seek(Position + ObjectSize, soFromBeginning);
                    end;
                end;
            finally
                fs.Free;
            end;
        except
            result := FileErr_FileOpenR;
        end;
    end
    else
        result := FileErr_NoFile;


    if result = FileErr_None then
    begin
        // Process data if loaded and valid
        fValid := true;
        // Fill properties with loaded data
        if (Data.Channels = WMA_CM_MONO) or (Data.Channels = WMA_CM_STEREO) then
            fChannelModeID := Data.Channels
        else
            fChannelModeID := WMA_CM_UNKNOWN;

        fSampleRate := Data.SampleRate;
        if Data.MaxBitRate > 0 then
            FDuration := round(fFileSize * 8 / Data.MaxBitRate)
        else
            FDuration := 0;

        fBitRate := Data.ByteRate * 8;
        fTitle   := Trim(Data.Tag[1]);
        fArtist  := Trim(Data.Tag[2]);
        fAlbum   := Trim(Data.Tag[3]);
        fYear    := Trim(Data.Tag[5]);
        fGenre   := Trim(Data.Tag[6]);
        fComment := Trim(Data.Tag[7]);

        fTrack := Trim(Data.Tag[8]);
        if fTrack = '' then
            fTrack := Trim(Data.Tag[4]);
    end;
end;

function TWMAfile.RemoveFromFile(aFilename: UnicodeString): TAudioError;
begin
    result := WmaErr_WritingNotSupported;
end;

function TWMAfile.WriteToFile(aFilename: UnicodeString): TAudioError;
begin
    result := WmaErr_WritingNotSupported;
end;

end.
