{

    Unit NempFileUtils

    Defines and implements some general functions for writing
    data to *.gmp and *.npl files

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2005-2019, Daniel Gaussmann
    http://www.gausi.de
    mail@gausi.de
    ---------------------------------------------------------------
    This program is free software; you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by the
    Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful, but
    WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
    for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin St, Fifth Floor, Boston, MA 02110, USA

    See license.txt for more information

    ---------------------------------------------------------------
}

unit NempFileUtils;

interface

uses WinApi.Windows, System.Classes, System.SysUtils,
  System.Generics.Collections, System.Generics.Defaults, Hilfsfunktionen;

    const
        DT_Byte     = 1;
        DT_Word     = 2;
        DT_Integer  = 4;
        DT_String   = 5;
        DT_Boolean  = 6;
        DT_Single   = 7;
        DT_Double   = 8;
        DT_Int64    = 9;
        DT_DWord    = 10;
        DT_Cardinal = 11;
        DT_DateTime = 12;

        // !!! set this always to the last valid datatype
        MAX_SUPPORTED_DATA_ENUM = 12;

        DATA_END_ID = 255;

        MP3DB_PL_Path    = 1;
        MP3DB_PL_DriveID = 2;
        MP3DB_PL_COVERID = 27;

        MP3DB_PL_CATEGORY = 39;

    type
        {
        *--------------------
        * TLibraryPlaylist
        *--------------------
        * a little class for saving/loading the List of Playlists into
        * the Medialibray file (*.gmp).
        }
        TLibraryPlaylist = class
            private
                fPath: String;
                fDriveID: Integer;
                fCategory: Cardinal;
                fName: String;
                fCoverID: String;
                function GetFilename: String;
            public
                property Path: String read fPath write fPath ;
                property Filename: String read GetFilename;
                property DriveID: Integer read fDriveID write fDriveID ;
                property Category: Cardinal read fCategory write fCategory;
                property Name: String read fName write fName;
                property CoverID: String read fCoverID write fCoverID;

                constructor Create(aFilename: String = '');
                procedure LoadFromStream(aStream: TStream);
                function SaveToStream(aStream: TStream): LongInt;
                procedure SetNewDriveChar(aChar: Char);

                function IsCategory(aCatIdx: Byte): Boolean;
                procedure AddToCategory(aCatIdx: Byte);
                procedure RemoveFromCategory(aCatIdx: Byte);
        end;

        TLibraryPlaylistList = class(TObjectList<TLibraryPlaylist>);


    // write little chunks of Data into a Stream
    // common Data format:
    //     1 Byte  ID           used to fill the proper property of the object, like Artist, Path, Title, Year, Genre, ...
    //                          IDs are defined by the class using the methods from this unit
    //     1 Byte  Data type    with that, Nemp can skip unknown IDs by using a generic reading method
    //                          (ReadUnkownDataFromStream)
    //                          Data type constants/IDs are defined here in this unit (see above, DT_***)
    //     X Bytes actual Data  format depends on Data type
    function WriteByteToStream(aStream: TStream; ID: Byte; aData: Byte): LongInt;
    function WriteWordToStream(aStream: TStream; ID: Byte; aData: Word): LongInt;
    function WriteDWordToStream(aStream: TStream; ID: Byte; aData: DWord): LongInt;

    function WriteIntegerToStream(aStream: TStream; ID: Byte; aData: Integer): LongInt;
    function WriteTextToStream(aStream: TStream; ID: Byte; wString: UnicodeString): LongInt;
    function WriteBoolToStream(aStream: TStream; ID: Byte; aData: Boolean): LongInt;

    function WriteSingleToStream(aStream: TStream; ID: Byte; aData: Single): LongInt;
    function WriteDoubleToStream(aStream: TStream; ID: Byte; aData: Double): LongInt;
    function WriteInt64ToStream(aStream: TStream; ID: Byte; aData: Int64): LongInt;
    function WriteCardinalToStream(aStream: TStream; ID: Byte; aData: Cardinal): LongInt;

    function WriteDateTimeToStream(aStream: TStream; ID: Byte; aData: TDateTime): LongInt;

    function WriteDataEnd(aStream: TStream ): LongInt;

    // reading little chunks of Data from a Stream
    // the "ID byte" has already been read here
    // If one of these functions is called, the next Byte to read from the stream is the
    // "Data Type Byte". The function "Read**FromStream" should check whether this Value matches the **
    // if not, a default value is returned.
    // (But this would be a Indicator for an invalid File)

    // read some non matching Data from a Stream, so that reading from the stream can go on
    procedure ReadErroneousData(aStream: TStream; errType: Byte);
    function DataTypeMatchesFunction(aStream: TStream; aType: Byte): Boolean;

    // used, if a DataID is unknown (because it is written by a following version of nemp)
    // !!! The DT_*** constant following the DataID in the stream *MUST* be known
    //     If Nemp uses more different Data types, the file format version *MUST* be changed
    //      currently: (Nemp 4.13) "5.0", see e.g. MP3DB_VERSION
    function ReadUnkownDataFromStream(aStream: TStream): Boolean;

    function ReadByteFromStream(aStream: TStream): Byte;
    function ReadWordFromStream(aStream: TStream): Word;
    function ReadDWordFromStream(aStream: TStream): DWord;

    function ReadIntegerFromStream(aStream: TStream): Integer;
    function ReadTextFromStream(aStream: TStream): String;
    function ReadBoolFromStream(aStream: TStream): Boolean;

    function ReadSingleFromStream(aStream: TStream): Single;
    function ReadDoubleFromStream(aStream: TStream): Double;
    function ReadInt64FromStream(aStream: TStream): Int64;
    function ReadCardinalFromStream(aStream: TStream): Cardinal;
    function ReadDateTimeFromStream(aStream: TStream): TDateTime;

var
  SortPlaylists_Path,
  SortPlaylists_Name : IComparer<TLibraryPlaylist>;


implementation

// private function, same for all writing functions
function WriteDataHeader(aStream: TStream; ID: Byte; DataType: Byte): LongInt;
begin
    // write the Data-ID (Path, Artist, Genre, ...)
    result := aStream.Write(ID, SizeOf(ID));
    // write the DataType-Indicator.
    result := result + aStream.Write(DataType, SizeOf(DataType));
    // after that: write the actual data (different in the other functions)
end;

function WriteByteToStream(aStream: TStream; ID: Byte; aData: Byte): LongInt;
begin
    result := WriteDataHeader(aStream, ID, DT_Byte);
    // write the actual data.
    // here: just one little byte
    result := result + aStream.Write(aData, SizeOf(aData));
end;

function WriteWordToStream(aStream: TStream; ID: Byte; aData: Word): LongInt;
begin
    result := WriteDataHeader(aStream, ID, DT_Word);
    // write the actual data.
    // here: just a Word variable
    result := result + aStream.Write(aData, SizeOf(aData));
end;

function WriteDWordToStream(aStream: TStream; ID: Byte; aData: DWord): LongInt;
begin
    result := WriteDataHeader(aStream, ID, DT_DWord);
    // write the actual data.
    // here: just a Word variable
    result := result + aStream.Write(aData, SizeOf(aData));
end;

function WriteIntegerToStream(aStream: TStream; ID: Byte; aData: Integer): LongInt;
begin
    result := WriteDataHeader(aStream, ID, DT_Integer);
    // write the actual data.
    // here: just an Integer variable
    result := result + aStream.Write(aData, SizeOf(aData));
end;

function WriteTextToStream(aStream: TStream; ID: Byte; wString: UnicodeString): LongInt;
var len: integer;
    tmpStr: UTF8String;
begin
    result := WriteDataHeader(aStream, ID, DT_String);
    // write the actual data.
    // here: "Length + String". Text Endoding is always UTF-8
    //
    // temporary create UTF8String from data
    tmpstr := UTF8Encode(wString);
    len := length(tmpstr);
    // Write Length ant UTF8-Endoded String
    result := result + aStream.Write(len, SizeOf(len));
    result := result + aStream.Write(PAnsiChar(tmpstr)^, len);
end;

function WriteBoolToStream(aStream: TStream; ID: Byte; aData: Boolean): LongInt;
begin
    result := WriteDataHeader(aStream, ID, DT_Boolean);
    // write the actual data.
    result := result + aStream.Write(aData, SizeOf(aData));
end;

function WriteSingleToStream(aStream: TStream; ID: Byte; aData: Single): LongInt;
begin
    result := WriteDataHeader(aStream, ID, DT_Single);
    // write the actual data.
    result := result + aStream.Write(aData, SizeOf(aData));
end;

function WriteDoubleToStream(aStream: TStream; ID: Byte; aData: Double): LongInt;
begin
    result := WriteDataHeader(aStream, ID, DT_Double);
    // write the actual data.
    result := result + aStream.Write(aData, SizeOf(aData));
end;

function WriteInt64ToStream(aStream: TStream; ID: Byte; aData: Int64): LongInt;
begin
    result := WriteDataHeader(aStream, ID, DT_Int64);
    // write the actual data.
    result := result + aStream.Write(aData, SizeOf(aData));
end;

function WriteCardinalToStream(aStream: TStream; ID: Byte; aData: Cardinal): LongInt;
begin
    result := WriteDataHeader(aStream, ID, DT_Cardinal);
    // write the actual data.
    result := result + aStream.Write(aData, SizeOf(aData));
end;

function WriteDateTimeToStream(aStream: TStream; ID: Byte; aData: TDateTime): LongInt;
begin
    result := WriteDataHeader(aStream, ID, DT_DateTime);
    // write the actual data.
    result := result + aStream.Write(aData, SizeOf(aData));
end;

function WriteDataEnd(aStream: TStream): LongInt;
var aID: Byte;
begin
    aID := DATA_END_ID;
    result := aStream.Write(aID, SizeOf(aID));
end;


// if this method is called, something is wrong with the data
// it is used, so tht only the specific data chunk can be skipped, instead of wasting the whole file
procedure ReadErroneousData(aStream: TStream; errType: Byte);
var dummyByte: Byte;
    dummyWord: Word;
    dummyDWord: DWord;
    dummyInteger: Integer;
    dummyString: UTF8String;
    dummyBool: Boolean;
    dummySingle: Single;
    dummyDouble: Double;
    dummyInt64: Int64;
    dummyCardinal: Cardinal;
    dummyDateTime: TDateTime;
    StrLen: Integer;
begin
    case errType of
        DT_Byte    : aStream.Read(dummyByte, SizeOf(dummyByte));
        DT_Word    : aStream.Read(dummyWord, SizeOf(dummyWord));
        DT_Integer : aStream.Read(dummyInteger, SizeOf(dummyInteger));
        DT_String  : begin
              aStream.Read(StrLen, SizeOf(StrLen));
              setLength(dummyString, StrLen);
              aStream.Read(PAnsiChar(dummyString)^, StrLen);
        end;
        DT_Boolean : aStream.Read(dummyBool, SizeOf(dummyBool));
        DT_Single  : aStream.Read(dummySingle, SizeOf(dummySingle));
        DT_Double  : aStream.Read(dummyDouble, SizeOf(dummyDouble));
        DT_Int64   : aStream.Read(dummyInt64, SizeOf(dummyInt64));
        DT_DWord   : aStream.Read(dummyDWord, SizeOf(dummyDWord));
        DT_Cardinal: aStream.Read(dummyCardinal, SizeOf(dummyCardinal));
        DT_DateTime: aStream.Read(dummyDateTime, SizeOf(dummyDateTime));
    end;
end;

function DataTypeMatchesFunction(aStream: TStream; aType: Byte): Boolean;
var DataTypeFromStream: Byte;
begin
    aStream.Read(DataTypeFromStream, SizeOf(DataTypeFromStream));
    // if the expected Data Type does not match the Type written in the stream:
    // read the data (and skip it)
    if DataTypeFromStream <> aType then
        ReadErroneousData(aStream, DataTypeFromStream);

    result := DataTypeFromStream = aType;
end;

function ReadUnkownDataFromStream(aStream: TStream): Boolean;
var DataType: Byte;
begin
    aStream.Read(DataType, SizeOf(DataType));

    if DataType <= MAX_SUPPORTED_DATA_ENUM then
        // just skip the data, otherwise we can't read the file
        ReadErroneousData(aStream, DataType);

    result := DataType <= MAX_SUPPORTED_DATA_ENUM
end;


function ReadByteFromStream(aStream: TStream): Byte;
begin
    if DataTypeMatchesFunction(aStream, DT_Byte) then
        aStream.Read(result, SizeOf(result))
    else
        result := 0;
end;

function ReadWordFromStream(aStream: TStream): Word;
begin
    if DataTypeMatchesFunction(aStream, DT_Word) then
        aStream.Read(result, SizeOf(result))
    else
        result := 0;
end;

function ReadDWordFromStream(aStream: TStream): DWord;
begin
    if DataTypeMatchesFunction(aStream, DT_DWORD) then
        aStream.Read(result, SizeOf(result))
    else
        result := 0;
end;

function ReadIntegerFromStream(aStream: TStream): Integer;
begin
    if DataTypeMatchesFunction(aStream, DT_Integer) then
        aStream.Read(result, SizeOf(result))
    else
        result := 0;
end;

function ReadTextFromStream(aStream: TStream): String;
var StrLen: Integer;
    tmpUTF8: UTF8String;
begin
    if DataTypeMatchesFunction(aStream, DT_String) then
    begin
        aStream.Read(StrLen, SizeOf(StrLen));
        setLength(tmpUTF8, StrLen);
        aStream.Read(PAnsiChar(tmpUTF8)^, StrLen);
        result := UTF8ToString(tmpUTF8);
    end
    else
        result := '';
end;

function ReadBoolFromStream(aStream: TStream): Boolean;
begin
    if DataTypeMatchesFunction(aStream, DT_Boolean) then
        aStream.Read(result, SizeOf(result))
    else
        result := False;
end;

function ReadSingleFromStream(aStream: TStream): Single;
begin
    if DataTypeMatchesFunction(aStream, DT_Single) then
        aStream.Read(result, SizeOf(result))
    else
        result := 0;
end;

function ReadDoubleFromStream(aStream: TStream): Double;
begin
    if DataTypeMatchesFunction(aStream, DT_Double) then
        aStream.Read(result, SizeOf(result))
    else
        result := 0;
end;

function ReadInt64FromStream(aStream: TStream): Int64;
begin
    if DataTypeMatchesFunction(aStream, DT_Int64) then
        aStream.Read(result, SizeOf(result))
    else
        result := 0;
end;
function ReadCardinalFromStream(aStream: TStream): Cardinal;
begin
    if DataTypeMatchesFunction(aStream, DT_Cardinal) then
        aStream.Read(result, SizeOf(result))
    else
        result := 0;
end;

function ReadDateTimeFromStream(aStream: TStream): TDateTime;
begin
    if DataTypeMatchesFunction(aStream, DT_DateTime) then
        aStream.Read(result, SizeOf(result))
    else
        result := 0;
end;


{ TLibraryPlaylist }

constructor TLibraryPlaylist.Create(aFilename: String);
begin
  inherited create;
  fPath := aFilename;
end;

function TLibraryPlaylist.GetFilename: String;
begin
  result := ExtractFilename(fPath);
end;

procedure TLibraryPlaylist.LoadFromStream(aStream: TStream);
var c: Integer;
    dataID: Byte;
begin
    c := 0;
    repeat
        aStream.Read(dataID, sizeof(dataID));
        inc(c);
        case dataID of
              MP3DB_PL_Path    : fPath    := ReadTextFromStream(aStream);
              MP3DB_PL_DriveID : fDriveID := ReadIntegerFromStream(aStream);
              MP3DB_PL_CATEGORY: fCategory:= ReadCardinalFromStream(aStream);
              MP3DB_PL_COVERID : fCoverID := ReadTextFromStream(aStream);
              DATA_END_ID      : ; // Explicitly do Nothing -  because of the ELSE path ;-)
        else
            begin
                if not ReadUnkownDataFromStream(aStream) then
                    c := DATA_END_ID;
            end;
        end;
    until (dataID = DATA_END_ID) OR (c >= DATA_END_ID);
end;


function TLibraryPlaylist.SaveToStream(aStream: TStream): LongInt;
begin
    result :=          WriteIntegerToStream(aStream, MP3DB_PL_DriveID, fDriveID);
    result := result + WriteTextToStream(aStream, MP3DB_PL_Path, fPath);
    result := result + WriteCardinalToStream(aStream, MP3DB_PL_CATEGORY, fCategory);
    if CoverID <> '' then
      result := result + WriteTextToStream(aStream, MP3DB_PL_COVERID, CoverID);
    result := result + WriteDataEnd(aStream);
end;

procedure TLibraryPlaylist.SetNewDriveChar(aChar: Char);
begin
    if (length(fPath) > 1) and (fPath[1] <> '\') then
        fPath[1] := aChar;
end;

function TLibraryPlaylist.IsCategory(aCatIdx: Byte): Boolean;
begin
  result := (fCategory shr aCatIdx) AND 1 = 1;
end;

procedure TLibraryPlaylist.AddToCategory(aCatIdx: Byte);
begin
  fCategory := fCategory or (1 shl aCatIdx);
end;

procedure TLibraryPlaylist.RemoveFromCategory(aCatIdx: Byte);
begin
  fCategory := fCategory and (not (1 shl aCatIdx));
end;

initialization


{
  SortPlaylists_Path,
  SortPlaylists_Name : IComparer<TLibraryPlaylist>;

}

SortPlaylists_Path := TComparer<TLibraryPlaylist>.Construct( function (const item1,item2: TLibraryPlaylist): Integer
begin
  result := AnsiCompareText_Nemp(Item1.fPath, Item2.fPath);
end);

SortPlaylists_Name := TComparer<TLibraryPlaylist>.Construct( function (const item1,item2: TLibraryPlaylist): Integer
begin
  result := AnsiCompareText_Nemp(Item1.fPath, Item2.fPath);
end);

end.
