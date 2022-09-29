{
    -----------------------------------
    Audio Werkzeuge Bibliothek
    -----------------------------------
    (c) 2012-2020, Daniel Gaussmann
              Website : www.gausi.de
              EMail   : mail@gausi.de
    -----------------------------------

    Unit ID3v1Tags

    Read/Write ID3v1Tags
    (This was part of the Unit MP3FileUtils before)

  -------------------------------------------------------

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

  -------------------------------------------------------
}

unit ID3v1Tags;

{$I config.inc}

interface

uses
  SysUtils, Classes, Windows, Contnrs, U_CharCode, System.WideStrUtils
  {$IFDEF USE_SYSTEM_TYPES}, System.Types{$ENDIF}
  , AudioFiles.Declarations;

type

//--------------------------------------------------------------------
// Teil 2: Types for ID3v1-tag
//--------------------------------------------------------------------


  TID3v1Tag = class(TObject)
  private
    FTitle: String30;
    FArtist: String30;
    FAlbum: String30;
    FComment: String30;
    FTrack: Byte;
    FYear: String4;
    FGenre: Byte;
    FExists: Boolean;
    FVersion: Byte;

    // convert the ansi-data to UnicodeString using a codepage
    // * use GetCodepage(Filename) to get the probably used codepage
    // * fAutoCorrectCodepage = False: Use the System-Codepage
    fAutoCorrectCodepage: Boolean;
    FCharCode: TCodePage;
    function GetConvertedUnicodeText(Value: String30): UnicodeString;

    function GetTitle: UnicodeString;
    function GetArtist: UnicodeString;
    function GetAlbum: UnicodeString;
    function GetComment: UnicodeString;

    function GetGenre: String;  // Delphi-Default-String. Just for display, as Genre is stored as one byte
    function GetTrack: String;  // Delphi-Default-String. Just for display, as Track is stored as one byte
    function GetYear: String4;

    function SetString30(value: UnicodeString): String30;
    procedure SetTitle(Value: UnicodeString);
    procedure SetArtist(Value: UnicodeString);
    procedure SetAlbum(Value: UnicodeString);
    procedure SetGenre(Value: String);         // Delphi-Default-String.
    procedure SetYear(Value: String4);
    procedure SetComment(Value: UnicodeString);
    procedure SetTrack(Value: String);        // Delphi-Default-String.
  public
    constructor Create;
    destructor Destroy; override;
    property TagExists: Boolean read FExists;
    property Exists:    Boolean read FExists;

    property Version: Byte read FVersion;
    property Title: UnicodeString read GetTitle write SetTitle;
    property Artist: UnicodeString read GetArtist write SetArtist;
    property Album: UnicodeString read GetAlbum write SetAlbum;
    property Genre: String read GetGenre write SetGenre;     // Delphi-Default-String.
    property Track: String read GetTrack write SetTrack;     // Delphi-Default-String.
    property Year: String4 read GetYear write SetYear;
    property Comment: UnicodeString read GetComment write SetComment;

    property CharCode: TCodePage read FCharCode write FCharCode;
    property AutoCorrectCodepage: Boolean read FAutoCorrectCodepage write FAutoCorrectCodepage;

    procedure Clear;
    procedure CopyFromRawTag(Rawtag: TID3v1Structure);
    function ReadFromStream(Stream: TStream): TAudioError;
    function WriteToStream(Stream: TStream): TAudioError;
    function RemoveFromStream(Stream: TStream): TAudioError;
    function ReadFromFile(Filename: UnicodeString): TAudioError;        // UnicodeString
    function WriteToFile(Filename: UnicodeString): TAudioError;
    function RemoveFromFile(Filename: UnicodeString): TAudioError;
  end;
//--------------------------------------------------------------------


  // Some useful functions.
  // Use them e.g. in OnChange of a TEdit

  function IsValidV1TrackString(value:string):boolean;
  function IsValidYearString(value:string):boolean;


implementation

uses ID3GenreList;

//--------------------------------------------------------------------
// ID3v1 or ID3v1.1 ?
//--------------------------------------------------------------------
function GetID3v1Version(Tag: TID3v1Structure): Byte;
begin
  // If the 29th byte of the comment is =0 an
  // 30th <> 0, then this is the Track-nr.
  if (Tag.Comment[29] = #00) and (Tag.Comment[30] <> #00) then
    result := 1
  else
    result := 0;
end;

//--------------------------------------------------------------------
// ... and for v1
//--------------------------------------------------------------------
function IsValidV1TrackString(value:string):boolean;
begin
  result := (StrToIntDef(Value, -1) > -1);
end;

//--------------------------------------------------------------------
// Check for valid year
//--------------------------------------------------------------------
function IsValidYearString(value:string):boolean;
var tmp:integer;
begin
  tmp := StrToIntDef(Value, -1);
  result := (tmp > -1) AND (tmp < 10000);
end;


//--------------------------------------------------------------------
//--------------------------------------------------------------------
//        *** TID3v1Tag ***
//--------------------------------------------------------------------
//--------------------------------------------------------------------


constructor TID3v1Tag.Create;
begin
  inherited Create;
  // Set default-values
  Clear;
  FCharCode := DefaultCharCode;
  AutoCorrectCodepage := False;
end;

destructor TID3v1Tag.destroy;
begin
  inherited destroy;
end;

procedure TID3v1Tag.CopyFromRawTag(Rawtag: TID3v1Structure);
begin
    FExists := True;
    FVersion := GetID3v1Version(RawTag);
    FTitle := RawTag.Title;
    FArtist := RawTag.Artist;
    FAlbum := RawTag.Album;
    FYear := RawTag.Year;

    if FVersion = 0 then
    begin
      FComment := (RawTag.Comment);
      FTrack := 0;
    end
    else
    begin
      Move(RawTag.Comment[1], FComment[1], 28);
      FComment[29] := #0;
      FComment[30] := #0;
      FTrack := Ord(RawTag.Comment[30]);
    end;
    FGenre := RawTag.Genre;
end;

// Read the Tag from a stream
function TID3v1Tag.ReadFromStream(Stream: TStream): TAudioError;
var
  RawTag: TID3v1Structure;
begin
  clear;
  result := FileErr_None;
  FExists := False;
  try
    Stream.Seek(-128, soEnd);
    if (Stream.Read(RawTag, 128) = 128) then
    begin
      if IsValidID3Tag(RawTag) then
        CopyFromRawTag(RawTag);
    end
    else
      result := MP3ERR_StreamRead;
  except
    on E: Exception do
    begin
      result := Mp3ERR_Unclassified;
      MessageBox(0, PChar(E.Message), PChar('Error'), MB_OK or MB_ICONERROR or MB_TASKMODAL or MB_SETFOREGROUND);
    end;
  end;
end;

// Write Tag to a stream
function TID3v1Tag.WriteToStream(Stream: TStream): TAudioError;
var
  NewRawTag: TID3v1Structure;
  ExistingTag: TID3v1Structure;
begin
  result := FileErr_None;
  try
    FillChar(NewRawTag, 128, 0);
    NewRawTag.ID := ID3V1_PREAMBLE; // 'TAG';
    Move(FTitle[1], NewRawTag.Title, Length(FTitle));
    Move(FArtist[1], NewRawTag.Artist, Length(FArtist));
    Move(FAlbum[1], NewRawTag.Album, Length(FAlbum));
    Move(FYear[1], NewRawTag.Year, Length(FYear));
    Move(FComment[1], NewRawTag.Comment, Length(FComment));
    if FTrack > 0 then
    begin
      NewRawTag.Comment[29] := #0;
      NewRawTag.Comment[30] := AnsiChar(Chr(FTrack));
    end;
    NewRawTag.Genre := FGenre;

    // Search for an existing tag and set position to write the new one
    Stream.Seek(-128, soEnd);
    if (Stream.Read(ExistingTag, 128) = 128) then
    begin
      if IsValidID3Tag(ExistingTag) then
        Stream.Seek(-128, soEnd)
      else
        Stream.Seek(0, soEnd);

      if Stream.Write(NewRawTag, 128) <> 128 then
        result := MP3ERR_StreamWrite;
    end else
      result := MP3ERR_StreamRead;
  except
    on E: Exception do
    begin
      result := Mp3ERR_Unclassified;
      MessageBox(0, PChar(E.Message), PChar('Error'), MB_OK or MB_ICONERROR or MB_TASKMODAL or MB_SETFOREGROUND);
    end;
  end;
end;

// Delete Tag, if existing
function TID3v1Tag.RemoveFromStream(Stream: TStream): TAudioError;
var ExistingTag: TID3v1Structure;
begin
  result := FileErr_None;
  try
    Stream.Seek(-128, soEnd);
    if (Stream.Read(ExistingTag, 128) = 128) then
    begin
      if IsValidID3Tag(ExistingTag) then
      begin
        Stream.Seek(-128, soEnd);
        SetStreamEnd(Stream);
      end;
      // else: nothing to do, there was no ID3v1Tag
    end else
      result := MP3ERR_StreamRead;
  except
    on E: Exception do
    begin
      result := Mp3ERR_Unclassified;
      MessageBox(0, PChar(E.Message), PChar('Error'), MB_OK or MB_ICONERROR or MB_TASKMODAL or MB_SETFOREGROUND);
    end;
  end;
end;

// Set default-values
procedure TID3v1Tag.Clear;
begin
  FTitle   := String30(StringOfChar(#0, 30));
  FArtist  := String30(StringOfChar(#0, 30));
  FAlbum   := String30(StringOfChar(#0, 30));
  FYear    := String4(StringOfChar(#0, 4));
  FComment := String30(StringOfChar(#0, 30));

  FTrack   := 0;
  FGenre   := 0;
  FVersion := 0;
  FExists  := False;
end;

// read tag from a file
// -> use stream-function
function TID3v1Tag.ReadFromFile(Filename: UnicodeString): TAudioError;
var
  Stream: TAudioFileStream;
begin
  if AudioFileExists(Filename) then
    try
      Stream := TAudioFileStream.Create(Filename, fmOpenRead or fmShareDenyWrite);
      try
        result := ReadFromStream(Stream);
      finally
        Stream.Free;
      end;
    except
      result := FileErr_FileOpenR;
    end
  else
    result := FileErr_NoFile;
end;

// Write a tag to a file
// -> use stream-function
function TID3v1Tag.WriteToFile(Filename: UnicodeString): TAudioError;
var
  Stream: TAudioFileStream;
begin
  if AudioFileExists(Filename) then
    try
      Stream := TAudioFileStream.Create(Filename, fmOpenReadWrite or fmShareDenyWrite);
      try
        result := WriteToStream(Stream);
      finally
        Stream.Free;
      end;
    except
      result := FileErr_FileOpenRW;
    end
  else
    result := FileErr_NoFile;
end;

// Delete Tag from a file
// -> use stream-function
function TID3v1Tag.RemoveFromFile(Filename: UnicodeString): TAudioError;
var
  Stream: TAudioFileStream;
begin
  if AudioFileExists(Filename) then
    try
      Stream := TAudioFileStream.Create(Filename, fmOpenReadWrite or fmShareDenyWrite);
      try
        result := RemoveFromStream(Stream);
      finally
        Stream.Free;
      end;
    except
      result := FileErr_FileOpenRW;
    end
  else
    result := FileErr_NoFile;
end;


// Converts a String[30] to UnicodeString
//   * if AutoCorrectCodepage=True then the conversion is done by the
//     given CodePage
//   * otherwise it will be done by delphi, i.e. the system-codepage
function TID3v1Tag.GetConvertedUnicodeText(Value: String30): UnicodeString;
var
  tmp: AnsiString;
  L: Integer;
begin
    if AutoCorrectCodepage then
    begin
      if IsUTf8String(Value) then
        result := UTF8ToString(Value)
      else
      begin

                L := MultiByteToWideChar(FCharCode.CodePage,
                          MB_PRECOMPOSED,  // Flags
                          @Value[1],       // data to convert
                          Length(Value),   // Size in bytes
                          nil,             // output - not used here
                          0);              // 0=> Get required BufferSize

                if L = 0 then
                begin
                    // Something's wrong => Fall back to ANSI
                    setlength(tmp, 30);
                    move(Value[1], tmp[1], 30);
                    {$IFDEF UNICODE}
                        // use explicit typecast
                        result := trim(String(tmp));
                    {$ELSE}
                        result := trim(tmp);
                    {$ENDIF}
                end else
                begin
                    // SetBuffer, Size in WChars, not Bytes.
                    SetLength(Result, L);
                    // Convert
                    MultiByteToWideChar(FCharCode.CodePage,
                              MB_PRECOMPOSED,
                              @Value[1],
                              length(Value),
                              @Result[1],
                              L);
                    // trim string
                    result := Trim(Result);
                end;
      end;
    end

    else
    begin
      // copy to AnsiString and typecast
      setlength(tmp,30);
      move(Value[1], tmp[1], 30);
      {$IFDEF UNICODE}
          // use explicit typecast
          result := trim(String(tmp));
      {$ELSE}
          result := trim(tmp);
      {$ENDIF}
    end;
end;

function TID3v1Tag.GetTitle: UnicodeString;
begin
  result := GetConvertedUnicodeText(FTitle);
end;
function TID3v1Tag.GetArtist: UnicodeString;
begin
  result := GetConvertedUnicodeText(FArtist);
end;
function TID3v1Tag.GetAlbum: UnicodeString;
begin
  result := GetConvertedUnicodeText(FAlbum);
end;
function TID3v1Tag.GetComment: UnicodeString;
begin
  result := GetConvertedUnicodeText(FComment);
end;
function TID3v1Tag.GetGenre: String;
begin
  if FGenre <= 125 then
    result := ID3Genres[FGenre]
  else
    result := '';
end;
function TID3v1Tag.GetTrack: String;
begin
  result := IntToStr(FTrack);
end;

function TID3v1Tag.GetYear: String4;
begin
  result := FYear;
end;


// Converts a UnicodeString to String[30]
//   * if AutoCorrectCodepage=True then the conversion is done by the
//     given CodePage
//   * otherwise it will be done by delphi, i.e. the system-codepage
function TID3v1Tag.SetString30(value: UnicodeString): String30;
var i, max, L: integer;
    tmpstr: AnsiString;
begin
    result := String30(StringOfChar(#0, 30));
    if fAutoCorrectCodepage then
    begin

        if length(value) > 0 then
        begin

            L := WideCharToMultiByte(FCharCode.CodePage, // CodePage
                  0, // Flags
                  @Value[1],      // String to Convert
                  -1,//length(Value),  // ... and its length
                  Nil,     // output, not needed here
                  0,       // and its length, 0 to get required length
                  Nil,  // DefaultChar, Nil=SystemDefault
                  Nil);  // DefaultChar needed

            if L = 0 then
            begin
                // Failure, Fall back to Ansi
                tmpstr := AnsiString(value);
                max := length(tmpstr);
                if max > 30 then max := 30;
                for i := 1 to max do
                    result[i] := tmpstr[i];
            end
            else
            begin
                // use a tmp-AnsiString, as the UnicodeString may be longer
                SetLength(tmpstr, L);
                //tmpstr := (StringOfChar(#0, L));
                WideCharToMultiByte(FCharCode.CodePage, // CodePage
                      0, // Flags
                      @Value[1],      // String to Convert
                      -1, //length(Value),  // ... and its length
                      @tmpstr[1],     // output
                      L,             // and its length
                      Nil,  // DefaultChar, Nil=SystemDefault
                      Nil);  // DefaultChar needed


                result := String30(tmpstr);
            end;
        end;
    end else
    begin
        // Write as Ansi
        tmpstr := AnsiString(value);
        max := length(tmpstr);
        if max > 30 then max := 30;
        for i := 1 to max do
            result[i] := tmpstr[i];
    end;
end;


procedure TID3v1Tag.SetTitle(Value: UnicodeString);
begin
  FTitle := SetString30(Value);
end;
procedure TID3v1Tag.SetArtist(Value: UnicodeString);
begin
  FArtist := SetString30(Value);
end;
procedure TID3v1Tag.SetAlbum(Value: UnicodeString);
begin
  FAlbum := SetString30(Value);
end;
procedure TID3v1Tag.SetGenre(Value: String);
var
  i: integer;
begin
  i := ID3Genres.IndexOf(Value);
  if i >= 0 then
    FGenre := i
  else
    FGenre := 255; // undefined
end;

procedure TID3v1Tag.SetYear(Value: String4);
begin
  FYear := Value;
end;

procedure TID3v1Tag.SetComment(Value: UnicodeString);
begin
  FComment := SetString30(Value);
end;
procedure TID3v1Tag.SetTrack(Value : String);
begin
  FTrack := StrToIntDef(Value, 0);
end;



end.
