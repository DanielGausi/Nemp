{ *************************************************************************** }
{                                                                             }
{ Audio Tools Library                                                         }
{ Class TWMAfile - for extracting information from WMA file header            }
{                                                                             }
{ http://mac.sourceforge.net/atl/                                             }
{ e-mail: macteam@users.sourceforge.net                                       }
{                                                                             }
{ Copyright (c) 2000-2002 by Jurgen Faul                                      }
{ Copyright (c) 2003-2005 by The MAC Team                                     }
{                                                                             }
{ Version 1.0 (29 April 2002)                                                 }
{   - Support for Windows Media Audio (versions 7, 8)                         }
{   - File info: file size, channel mode, sample rate, duration, bit rate     }
{   - WMA tag info: title, artist, album, track, year, genre, comment         }
{                                                                             }
{ This library is free software; you can redistribute it and/or               }
{ modify it under the terms of the GNU Lesser General Public                  }
{ License as published by the Free Software Foundation; either                }
{ version 2.1 of the License, or (at your option) any later version.          }
{                                                                             }
{ This library is distributed in the hope that it will be useful,             }
{ but WITHOUT ANY WARRANTY; without even the implied warranty of              }
{ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU           }
{ Lesser General Public License for more details.                             }
{                                                                             }
{ You should have received a copy of the GNU Lesser General Public            }
{ License along with this library; if not, write to the Free Software         }
{ Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA   }
{                                                                             }
{ *************************************************************************** }

{
    Modified by Daniel 'Gausi' Gaussman
    - procedure ReadTagExtended extended
    - fixed some issue with WM/TRACKNUMBER and WM/TRACK
    - replaced "Widestring" by "UnicodeString" for Delphi 2009

}

unit ATL_WMAfile;

interface

uses
  Classes, SysUtils, dialogs;

const
  { Channel modes }
  WMA_CM_UNKNOWN = 0;                                               { Unknown }
  WMA_CM_MONO = 1;                                                     { Mono }
  WMA_CM_STEREO = 2;                                                 { Stereo }

  { Channel mode names }
  WMA_MODE: array [0..2] of String = ('Unknown', 'Mono', 'Stereo');


type

{$IFNDEF UNICODE}
  UnicodeString = WideString;
{$ENDIF}

  { Class TWMAfile }
  TWMAfile = class(TObject)
    private
      { Private declarations }
      FValid: Boolean;
      FFileSize: Integer;
      FChannelModeID: Byte;
      FSampleRate: Integer;
      FDuration: Double;
      FBitRate: Integer;
      FTitle: UnicodeString;
      FArtist: UnicodeString;
      FAlbum: UnicodeString;
      FTrack: Integer;
      FYear: UnicodeString;
      FGenre: UnicodeString;
      FComment: UnicodeString;
      procedure FResetData;
      function FGetChannelMode: String;
    public
      { Public declarations }
      constructor Create;                                     { Create object }
      function ReadFromFile(const FileName: UnicodeString): Boolean;     { Load data }
      property Valid: Boolean read FValid;               { True if valid data }
      property FileSize: Integer read FFileSize;          { File size (bytes) }
      property ChannelModeID: Byte read FChannelModeID;   { Channel mode code }
      property ChannelMode: string read FGetChannelMode;  { Channel mode name }
      property SampleRate: Integer read FSampleRate;       { Sample rate (hz) }
      property Duration: Double read FDuration;          { Duration (seconds) }
      property BitRate: Integer read FBitRate;              { Bit rate (kbit) }
      property Title: UnicodeString read FTitle;                    { Song title }
      property Artist: UnicodeString read FArtist;                 { Artist name }
      property Album: UnicodeString read FAlbum;                    { Album name }
      property Track: Integer read FTrack;                     { Track number }
      property Year: UnicodeString read FYear;                            { Year }
      property Genre: UnicodeString read FGenre;                    { Genre name }
      property Comment: UnicodeString read FComment;                   { Comment }
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
    {'WM/TRACKNUMBER' added on 19.Okt 2008 by Daniel 'Gausi' Gaussmann}

  { Max. number of characters in tag field }
  WMA_MAX_STRING_SIZE = 250;

type                                  
  { Object ID }
  ObjectID = array [1..16] of AnsiChar;

  { Tag data }
  TagData = array [1..WMA_FIELD_COUNT] of UnicodeString;

  { File data - for internal use }
  FileData = record
    FileSize: Integer;                                    { File size (bytes) }
    MaxBitRate: Integer;                                { Max. bit rate (bps) }
    Channels: Word;                                      { Number of channels }
    SampleRate: Integer;                                   { Sample rate (hz) }
    ByteRate: Integer;                                            { Byte rate }
    Tag: TagData;                                       { WMA tag information }
  end;

{ ********************* Auxiliary functions & procedures ******************** }

function ReadFieldString(const Source: TStream; DataSize: Word): UnicodeString;
var
  Iterator, StringSize: Integer;
  FieldData: array [1..WMA_MAX_STRING_SIZE * 2] of Byte;
begin
  { Read field data and convert to Unicode string }
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
var
  Iterator: Integer;
  FieldSize: array [1..5] of Word;
  FieldValue: UnicodeString;
begin
  { Read standard tag data }
  Source.ReadBuffer(FieldSize, SizeOf(FieldSize));
  for Iterator := 1 to 5 do
    if FieldSize[Iterator] > 0 then
    begin
      { Read field value }
      FieldValue := ReadFieldString(Source, FieldSize[Iterator]);
      { Set corresponding tag field if supported }
      case Iterator of
        1: Tag[1] := FieldValue;
        2: Tag[2] := FieldValue;
        4: Tag[7] := FieldValue;
      end;
    end;
end;

{ --------------------------------------------------------------------------- }

procedure ReadTagExtended(const Source: TStream; var Tag: TagData);
var
  Iterator1, Iterator2, FieldCount, DataSize, DataType: Word;
  FieldName, FieldValue: UnicodeString;
  FieldDWord: Cardinal;
begin
  { Read extended tag data }
  Source.ReadBuffer(FieldCount, SizeOf(FieldCount));
  for Iterator1 := 1 to FieldCount do
  begin
    { Read field name }
    Source.ReadBuffer(DataSize, SizeOf(DataSize));
    FieldName := ReadFieldString(Source, DataSize);
    { Read value data type }
    Source.ReadBuffer(DataType, SizeOf(DataType));
    { Read field value only if string }


    // modified by Daniel 'Gausi' Gaussmann
    // 19.Okt.2008
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
            Source.ReadBuffer(DataSize, SizeOf(DataSize)); // Added By Daniel Gausi Gaussmann, 16.3.2006
            Source.Seek(DataSize, soFromCurrent);
        end;
    end;
    
    { Set corresponding tag field if supported }
    for Iterator2 := 1 to WMA_FIELD_COUNT do
      if UpperCase(Trim(FieldName)) = WMA_FIELD_NAME[Iterator2] then
        Tag[Iterator2] := FieldValue;
  end;
end;

{ --------------------------------------------------------------------------- }

procedure ReadObject(const ID: ObjectID; Source: TStream; var Data: FileData);
begin
  { Read data from header object if supported }
  if ID = WMA_FILE_PROPERTIES_ID then
  begin
    { Read file properties }
    Source.Seek(80, soFromCurrent);
    Source.ReadBuffer(Data.MaxBitRate, SizeOf(Data.MaxBitRate));
  end;
  if ID = WMA_STREAM_PROPERTIES_ID then
  begin
    { Read stream properties }
    Source.Seek(60, soFromCurrent);
    Source.ReadBuffer(Data.Channels, SizeOf(Data.Channels));
    Source.ReadBuffer(Data.SampleRate, SizeOf(Data.SampleRate));
    Source.ReadBuffer(Data.ByteRate, SizeOf(Data.ByteRate));
  end;
  if ID = WMA_CONTENT_DESCRIPTION_ID then
  begin
    { Read standard tag data }
    Source.Seek(4, soFromCurrent);
    ReadTagStandard(Source, Data.Tag);
  end;
  if ID = WMA_EXTENDED_CONTENT_DESCRIPTION_ID then
  begin
    { Read extended tag data }
    Source.Seek(4, soFromCurrent);
    ReadTagExtended(Source, Data.Tag);
  end;
end;

{ --------------------------------------------------------------------------- }

function ReadData(const FileName: UnicodeString; var Data: FileData): Boolean;
var
  Source: TFileStream;
  ID: ObjectID;
  Iterator, ObjectCount, ObjectSize, Position: Integer;
begin
  { Read file data }
  try
    Source := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
    Data.FileSize := Source.Size;
    { Check for existing header }
    Source.ReadBuffer(ID, SizeOf(ID));
    if ID = WMA_HEADER_ID then
    begin
      Source.Seek(8, soFromCurrent);
      Source.ReadBuffer(ObjectCount, SizeOf(ObjectCount));
      Source.Seek(2, soFromCurrent);
      { Read all objects in header and get needed data }
      for Iterator := 1 to ObjectCount do
      begin
        Position := Source.Position;
        Source.ReadBuffer(ID, SizeOf(ID));
        Source.ReadBuffer(ObjectSize, SizeOf(ObjectSize));
        ReadObject(ID, Source, Data);
        Source.Seek(Position + ObjectSize, soFromBeginning);
      end;
    end;
    Source.Free;
    Result := true;
  except
    Result := false;
  end;
end;

{ --------------------------------------------------------------------------- }

function IsValid(const Data: FileData): Boolean;
begin
  { Check for data validity }
  Result :=
    (Data.MaxBitRate > 0) and (Data.MaxBitRate < 320000) and
    ((Data.Channels = WMA_CM_MONO) or (Data.Channels = WMA_CM_STEREO)) and
    (Data.SampleRate >= 8000) and (Data.SampleRate <= 96000) and
    (Data.ByteRate > 0) and (Data.ByteRate < 40000);

{  Showmessage(Inttostr(Data.MaxBitRate)
  + #13#10 + Inttostr(Data.Channels)
  + #13#10 + Inttostr(Data.SampleRate)
  + #13#10 + Inttostr(Data.ByteRate)
  );}
end;

{ --------------------------------------------------------------------------- }

function ExtractTrack(const TrackString: UnicodeString): Integer;
var
  Value, Code: Integer;
begin
  { Extract track from string }
  Result := 0;
  Val(TrackString, Value, Code);
  if Code = 0 then Result := Value;
end;

{ ********************** Private functions & procedures ********************* }

procedure TWMAfile.FResetData;
begin
  { Reset variables }
  FValid := false;
  FFileSize := 0;
  FChannelModeID := WMA_CM_UNKNOWN;
  FSampleRate := 0;
  FDuration := 0;
  FBitRate := 0;
  FTitle := '';
  FArtist := '';
  FAlbum := '';
  FTrack := 0;
  FYear := '';
  FGenre := '';
  FComment := '';
end;

{ --------------------------------------------------------------------------- }

function TWMAfile.FGetChannelMode: string;
begin
  { Get channel mode name }
  Result := WMA_MODE[FChannelModeID];
end;

{ ********************** Public functions & procedures ********************** }

constructor TWMAfile.Create;
begin
  { Create object }
  inherited;
  FResetData;
end;

{ --------------------------------------------------------------------------- }

function TWMAfile.ReadFromFile(const FileName: UnicodeString): Boolean;
var
  Data: FileData;
begin
  { Reset variables and load file data }
  FResetData;
  FillChar(Data, SizeOf(Data), 0);
  Result := ReadData(FileName, Data);

  { Process data if loaded and valid }
  if Result then // and IsValid(Data) then                                      // Edited by Gausi
  // Note: There are some WMA-Files with higher Bitrates than the ones allowed in "IsValid"
  begin
    FValid := true;
    { Fill properties with loaded data }
    FFileSize := Data.FileSize;

    if (Data.Channels = WMA_CM_MONO) or (Data.Channels = WMA_CM_STEREO) then    // Edited by Gausi
        FChannelModeID := Data.Channels
    else                                                                        // Edited by Gausi
        FChannelModeID := WMA_CM_UNKNOWN;                                       // Edited by Gausi

    FSampleRate := Data.SampleRate;
    if Data.MaxBitRate > 0 then                                                 // Edited by Gausi
        FDuration := Data.FileSize * 8 / Data.MaxBitRate
    else                                                                        // Edited by Gausi
        FDuration := 0;                                                         // Edited by Gausi

    FBitRate := Data.ByteRate * 8 div 1000;
    FTitle := Trim(Data.Tag[1]);
    FArtist := Trim(Data.Tag[2]);
    FAlbum := Trim(Data.Tag[3]);


    FTrack := ExtractTrack(Trim(Data.Tag[8]));
    if FTrack = 0 then
        FTrack := ExtractTrack(Trim(Data.Tag[4]));

    FYear := Trim(Data.Tag[5]);
    FGenre := Trim(Data.Tag[6]);
    FComment := Trim(Data.Tag[7]);
  end;
end;

end.
