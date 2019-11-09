{
    -----------------------------------
    Audio Werkzeuge Bibliothek
    -----------------------------------
    (c) 2012, Daniel Gaussmann
              Website : www.gausi.de
              EMail   : mail@gausi.de
    -----------------------------------

    Unit VorbisComments

    Helper class for Ogg-Vorbis-Comments (as used in *.ogg and *.flac)

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

unit VorbisComments;

{$I config.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, ContNrs, Classes
  {$IFDEF USE_SYSTEM_TYPES}, System.Types{$ENDIF} ;

const
    VORBIS_ID = 'vorbis';

type

    {$IFNDEF UNICODE}
        UnicodeString = WideString;
    {$ENDIF}


    TVorbisHeader = packed record
        PacketType: Byte;                       // 1, 3, 5 for the first 3 Vorbis-Header in an Ogg-Stream (we need only the first and second)
        ID: array [1..6] of AnsiChar;           // always "vorbis"
    end;

    TVorbisIdentification = packed record
        PacketType: Byte;                       // always 1 here
        ID: array [1..6] of AnsiChar;           // always "vorbis"
        BitstreamVersion: Cardinal;             // Bitstream version number
        ChannelMode: Byte;                      // Number of channels
        SampleRate: Integer;                    // Sample rate (hz)
        BitRateMaximal: Integer;                // Bit rate upper limit
        BitRateNominal: Integer;                // Nominal bit rate
        BitRateMinimal: Integer;                // Bit rate lower limit
        BlockSize: Byte;                        // Coded size for small and long blocks
        StopFlag: Byte;                         // always 1
    end;

    TCommentVector = class
        private
            // FieldName is AnsiString
            // Value is UTf8String
            // To handle Delphi Version before/after D2009
            // we have getter/setter for these values
            // "Value" is UnicodeString, as data can contain unicode-data
            // "FieldName" is String (AnsiString would be ok either)
            fFieldName: AnsiString;
            fValue: UnicodeString;
            function fGetFieldName: String;
            procedure fSetFieldname(aName: String);
            function fGetValue: UnicodeString;
            procedure fSetValue(aValue: UnicodeString);
        public
            property FieldName: String read fGetFieldName write fSetFieldName;
            property Value: UnicodeString read fGetValue write fSetValue;
            function ReadFromStream(Source: TStream): Boolean;
            function WriteToStream(Destination: TStream): Boolean;
    end;

    {
    TVorbisComments:
        class for VorbisComments
    }
    TVorbisComments = class
        private
            fHeader: TVorbisHeader;
            fVendorString: UTF8String;
            fCommentVectorList: TObjectList;
            fValidComment: Boolean;

            function fGetPropertyByFieldname(aField: String): UnicodeString;
            // The following fields are listed in the official Ogg-Vorbis-Documentation
            function fGetTitle       : UnicodeString;
            function fGetVersion     : UnicodeString;
            function fGetAlbum       : UnicodeString;
            function fGetTrackNumber : UnicodeString;
            function fGetArtist      : UnicodeString;
            function fGetPerformer   : UnicodeString;
            function fGetCopyright   : UnicodeString;
            function fGetLicense     : UnicodeString;
            function fGetOrganization: UnicodeString;
            function fGetDescription : UnicodeString;
            function fGetGenre       : UnicodeString;
            function fGetDate        : UnicodeString;
            function fGetLocation    : UnicodeString;
            function fGetContact     : UnicodeString;
            function fGetISRC        : UnicodeString;

            procedure fSetPropertyByFieldname(aField: String; aValue: UnicodeString);
            procedure fSetTitle       (value: UnicodeString);
            procedure fSetVersion     (value: UnicodeString);
            procedure fSetAlbum       (value: UnicodeString);
            procedure fSetTrackNumber (value: UnicodeString);
            procedure fSetArtist      (value: UnicodeString);
            procedure fSetPerformer   (value: UnicodeString);
            procedure fSetCopyright   (value: UnicodeString);
            procedure fSetLicense     (value: UnicodeString);
            procedure fSetOrganization(value: UnicodeString);
            procedure fSetDescription (value: UnicodeString);
            procedure fSetGenre       (value: UnicodeString);
            procedure fSetDate        (value: UnicodeString);
            procedure fSetLocation    (value: UnicodeString);
            procedure fSetContact     (value: UnicodeString);
            procedure fSetISRC        (value: UnicodeString);


        public
            property ValidComment: Boolean read fValidComment;
            property VendorString: UTF8String read fVendorString    ;
            property Title       : UnicodeString read fGetTitle        write fSetTitle       ;
            property Version     : UnicodeString read fGetVersion      write fSetVersion     ;
            property Album       : UnicodeString read fGetAlbum        write fSetAlbum       ;
            property TrackNumber : UnicodeString read fGetTrackNumber  write fSetTrackNumber ;
            property Artist      : UnicodeString read fGetArtist       write fSetArtist      ;
            property Performer   : UnicodeString read fGetPerformer    write fSetPerformer   ;
            property Copyright   : UnicodeString read fGetCopyright    write fSetCopyright   ;
            property License     : UnicodeString read fGetLicense      write fSetLicense     ;
            property Organization: UnicodeString read fGetOrganization write fSetOrganization;
            property Description : UnicodeString read fGetDescription  write fSetDescription ;
            property Genre       : UnicodeString read fGetGenre        write fSetGenre       ;
            property Date        : UnicodeString read fGetDate         write fSetDate        ;
            property Location    : UnicodeString read fGetLocation     write fSetLocation    ;
            property Contact     : UnicodeString read fGetContact      write fSetContact     ;
            property ISRC        : UnicodeString read fGetISRC         write fSetISRC        ;

            //property CommentVectorList: TObjectList read fCommentVectorList;

            constructor Create;
            destructor Destroy; override;
            procedure Clear;
            function ReadFromStream(Source: TStream; Size: Integer; SkipHeader: Boolean=False): Boolean;
            function WriteToStream(Destination: TStream; SkipHeader: Boolean=False): Boolean;
            // The SizeInStream is just the size of the Comments.
            // It does NOT include optional padding!
            function GetSizeInStream: Integer;

            // public versions of the private Methods
            function GetPropertyByFieldname(aField: String): UnicodeString;
            // the Set-method also implements some Validations
            function SetPropertyByFieldname(aField: String; aValue: UnicodeString): Boolean;

            // Get All FieldNames in the CommentVectorList
            procedure GetAllFields(Target: TStrings);
            // Give Access to these Fields (note: Fieldnames dont have to be unique)
            function GetPropertyByIndex(aIndex: Integer): UnicodeString;
            function SetPropertyByIndex(aIndex: Integer; aValue: UnicodeString): Boolean;
    end;


implementation

{ TCommentVector }

function TCommentVector.fGetFieldName: String;
begin
    result := String(fFieldName);
end;

procedure TCommentVector.fSetFieldname(aName: String);
begin
    fFieldname := AnsiString(aName);
end;

function TCommentVector.fGetValue: UnicodeString;
begin
    result := fValue;
end;

procedure TCommentVector.fSetValue(aValue: UnicodeString);
begin
    fValue := aValue;
end;

function TCommentVector.ReadFromStream(Source: TStream): Boolean;
var c, e: integer;
    rawString: Utf8String;
    rawStringUnicode: String;
begin
    Source.Read(c, SizeOf(c));
    setlength(rawString, c);
    Source.Read(rawString[1], length(rawString));

    rawStringUnicode := String(rawString);
    e := pos('=', rawStringUnicode);
    result := e > 0;

    FieldName := Copy(rawStringUnicode, 1, e-1);

    {$IFDEF UNICODE}
        fValue := Copy(rawStringUnicode, e+1, length(rawStringUnicode) - e );
    {$ELSE}
        fValue := Copy(rawStringUnicode, e+1, length(rawStringUnicode) - e );
    {$ENDIF}
end;

function TCommentVector.WriteToStream(Destination: TStream): Boolean;
var rawString: Utf8String;
    l: Integer;
begin
    {$IFDEF UNICODE}
        rawString := Utf8String(Fieldname + '=' + Value);
    {$ELSE}
        rawString := Utf8Encode(Fieldname + '=' + Value);
    {$ENDIF}

    l := length(rawString);
    try
        Destination.Write(l, sizeOf(l));
        Destination.Write(rawString[1], l);
        result := True;
    except
        result := False;
    end;
end;

{ TVorbisComments }

procedure TVorbisComments.Clear;
begin
    fheader.PacketType := 0;
    fHeader.ID := '123456';
    fVendorString := '';
    fCommentVectorList.Clear;
    fValidComment := False;
end;

constructor TVorbisComments.Create;
begin
    fCommentVectorList := TObjectList.Create;
end;

destructor TVorbisComments.Destroy;
begin
    fCommentVectorList.Free;
    inherited;
end;


function TVorbisComments.fGetPropertyByFieldname(aField: String): UnicodeString;
var i: integer;
begin
    result := '';
    for i := 0 to fCommentVectorList.Count - 1 do
    begin
        if SameText(aField, TCommentVector(fCommentVectorList[i]).FieldName) then
        begin
            result := TCommentVector(fCommentVectorList[i]).Value;
            break;
        end;
    end;
end;


function TVorbisComments.fGetAlbum: UnicodeString;
begin
    result := fGetPropertyByFieldname('album');
end;

function TVorbisComments.fGetArtist: UnicodeString;
begin
    result := fGetPropertyByFieldname('artist');
end;

function TVorbisComments.fGetContact: UnicodeString;
begin
    result := fGetPropertyByFieldname('contact');
end;

function TVorbisComments.fGetCopyright: UnicodeString;
begin
    result := fGetPropertyByFieldname('copyright');
end;

function TVorbisComments.fGetDate: UnicodeString;
begin
    result := fGetPropertyByFieldname('date');
    if result = '' then
        result := fGetPropertyByFieldname('year');
end;

function TVorbisComments.fGetDescription: UnicodeString;
begin
    result := fGetPropertyByFieldname('description');
end;

function TVorbisComments.fGetGenre: UnicodeString;
begin
    result := fGetPropertyByFieldname('genre');
end;

function TVorbisComments.fGetISRC: UnicodeString;
begin
    result := fGetPropertyByFieldname('isrc');
end;

function TVorbisComments.fGetLicense: UnicodeString;
begin
    result := fGetPropertyByFieldname('license');
end;

function TVorbisComments.fGetLocation: UnicodeString;
begin
    result := fGetPropertyByFieldname('location');
end;

function TVorbisComments.fGetOrganization: UnicodeString;
begin
    result := fGetPropertyByFieldname('organization');
end;

function TVorbisComments.fGetPerformer: UnicodeString;
begin
    result := fGetPropertyByFieldname('performer');
end;

function TVorbisComments.fGetTitle: UnicodeString;
begin
    result := fGetPropertyByFieldname('title');
end;

function TVorbisComments.fGetTrackNumber: UnicodeString;
begin
    result := fGetPropertyByFieldname('tracknumber');
end;

function TVorbisComments.fGetVersion: UnicodeString;
begin
    result := fGetPropertyByFieldname('version');
end;


procedure TVorbisComments.fSetPropertyByFieldname(aField: String; aValue: UnicodeString);
var i: integer;
    matchingVector: TCommentVector;
begin
    matchingVector := Nil;
    // search the comment with "AField"
    for i := 0 to fCommentVectorList.Count - 1 do
    begin
        if SameText(aField, TCommentVector(fCommentVectorList[i]).FieldName) then
        begin
            matchingVector := TCommentVector(fCommentVectorList[i]);
            break;
        end;
    end;

    if trim(aValue) = '' then
    begin
        if assigned(matchingVector) then
        begin
            fCommentVectorList.Extract(matchingVector);
            FreeAndNil(matchingVector);
        end; // else: nothing to do
    end else
    begin
        // if no matching comment was found: Create a new one and add it to the
        // VectorList
        if not assigned(matchingVector)  then
        begin
            matchingVector := TCommentVector.Create;
            matchingVector.FieldName := aField;
            fCommentVectorList.Add(matchingVector);
        end;

        // set the new Value
        matchingVector.Value := aValue;
    end;
end;

procedure TVorbisComments.fSetAlbum(value: UnicodeString);
begin
    fSetPropertyByFieldname('album', Value);
end;

procedure TVorbisComments.fSetArtist(value: UnicodeString);
begin
    fSetPropertyByFieldname('artist', Value);
end;

procedure TVorbisComments.fSetContact(value: UnicodeString);
begin
    fSetPropertyByFieldname('contact', Value);
end;

procedure TVorbisComments.fSetCopyright(value: UnicodeString);
begin
    fSetPropertyByFieldname('copyright', Value);
end;

procedure TVorbisComments.fSetDate(value: UnicodeString);
begin
    fSetPropertyByFieldname('date', Value);
end;

procedure TVorbisComments.fSetDescription(value: UnicodeString);
begin
    fSetPropertyByFieldname('description', Value);
end;

procedure TVorbisComments.fSetGenre(value: UnicodeString);
begin
    fSetPropertyByFieldname('genre', Value);
end;

procedure TVorbisComments.fSetISRC(value: UnicodeString);
begin
    fSetPropertyByFieldname('isrc', Value);
end;

procedure TVorbisComments.fSetLicense(value: UnicodeString);
begin
    fSetPropertyByFieldname('license', Value);
end;

procedure TVorbisComments.fSetLocation(value: UnicodeString);
begin
    fSetPropertyByFieldname('location', Value);
end;

procedure TVorbisComments.fSetOrganization(value: UnicodeString);
begin
    fSetPropertyByFieldname('organization', Value);
end;

procedure TVorbisComments.fSetPerformer(value: UnicodeString);
begin
    fSetPropertyByFieldname('performer', Value);
end;

procedure TVorbisComments.fSetTitle(value: UnicodeString);
begin
    fSetPropertyByFieldname('title', Value);
end;

procedure TVorbisComments.fSetTrackNumber(value: UnicodeString);
begin
    fSetPropertyByFieldname('tracknumber', Value);
end;

procedure TVorbisComments.fSetVersion(value: UnicodeString);
begin
    fSetPropertyByFieldname('version', Value);
end;


function TVorbisComments.ReadFromStream(Source: TStream; Size: Integer; SkipHeader: Boolean=False): Boolean;
var vendorLength: Integer;
    i, CommentCount: Integer;
    newCommentVector: TCommentVector;
    framingBit: Byte;

    currentPos: Int64;
begin
    // store currentPos in the Stream
    currentPos := Source.Position;
    Clear;
    if Not SkipHeader then
    begin
        // read Header
        source.Read(fHeader, sizeOf(fHeader));
        if not ((fHeader.PacketType = 3) and (fHeader.ID = VORBIS_ID)) then
        begin
            fValidComment := False;
            result := False;
            Source.Seek(currentPos + Size, soBeginning);
            exit;
        end;
        // ok, valid Vorbis-Header found. Proceed with comments.
    end;

    // first: VendorString
    // should be something like "Xiph.Org libVorbis I 20020717"
    source.Read(vendorLength, sizeOf(vendorlength));
    setlength(fVendorString, vendorLength);
    source.Read(fVendorString[1], length(fVendorString));

    // read Number of Comments ...
    source.Read(CommentCount, sizeOf(CommentCount));
    fCommentVectorList.Clear;
    // ... read Comment Vectors
    for i := 1 to CommentCount do
    begin
        newCommentVector := TCommentVector.Create;
        newCommentVector.ReadFromStream(source);
        fCommentVectorList.Add(newCommentVector);
    end;

    // read closing framing bit
    if Not SkipHeader then
    begin
        source.Read(framingBit, sizeOf(framingBit));
        // this should be 1, otherwise the Header is invalid
        fValidComment := framingBit = 1;
    end else
        fValidComment := True;

    result := ValidComment;

    // Seek in the Stream after the Comment-Packet (which could include some padding
    // after the framing bit)
    if Size >= 0 then
        Source.Seek(currentPos + Size, soBeginning);
end;



function TVorbisComments.WriteToStream(Destination: TStream; SkipHeader: Boolean=False): Boolean;
var l,c,i: integer;
    framingBit: Byte;
begin
    result := True;
    try
        if not SkipHeader then
            // write header
            Destination.Write(fHeader, SizeOf(fHeader)); // #3 + vorbis

        // write vendorstring
        l := length(fVendorString);
        Destination.Write(l, sizeOf(l));
        Destination.Write(fVendorString[1], l);
        // write number of comments
        c := fCommentVectorList.Count;
        Destination.Write(c, sizeOf(c));
        // write comments
        for i := 0 to c-1 do
            if not TCommentVector(fCommentVectorList[i]).WriteToStream(Destination) then
                result := False;

        if Not SkipHeader then
        begin
            framingBit := 1;
            Destination.Write(framingBit, sizeOf(framingBit));
        end;
    except
        result := False;
    end;
end;

function TVorbisComments.GetPropertyByFieldname(aField: String): UnicodeString;
begin
    result := fGetPropertyByFieldname(aField);
end;

function TVorbisComments.SetPropertyByFieldname(aField: String;
  aValue: UnicodeString): Boolean;
var i: integer;
begin
    result := True;
    if trim(aField) <> '' then
    begin
        for i := 1 to length(aField) do
        begin
            if (aField[i]= '=')
                or (Ord(aField[i]) < $20)
                or (Ord(aField[i]) > $7D)
            then
                // invalid Fieldname - abort
                result := False;
        end;
    end else
        result := False;

    // Set it !
    if result then
        fSetPropertyByFieldname(aField, aValue);
end;


procedure TVorbisComments.GetAllFields(Target: TStrings);
var i: Integer;
begin
    Target.Clear;
    for i := 0 to fCommentVectorList.Count - 1 do
        Target.Add(String(TCommentVector(fCommentVectorList[i]).fFieldName));
end;

function TVorbisComments.GetPropertyByIndex(aIndex: Integer): UnicodeString;
begin
    if (aIndex >= 0) and (aIndex <= fCommentVectorList.Count - 1) then
        result := TCommentVector(fCommentVectorList[aIndex]).Value
    else
        result := '';
end;

function TVorbisComments.SetPropertyByIndex(aIndex: Integer;
  aValue: UnicodeString): Boolean;
begin
    if (aIndex >= 0) and (aIndex <= fCommentVectorList.Count - 1) then
    begin
        if trim(aValue) = '' then
            fCommentVectorList.Delete(aIndex)
        else
            TCommentVector(fCommentVectorList[aIndex]).Value := aValue;
        result := True;
    end else
        result := False;
end;

function TVorbisComments.GetSizeInStream: Integer;
var ms: TMemoryStream;
begin
    ms := TMemoryStream.Create;
    try
        WriteToStream(ms);
        result := ms.Size;
    finally
        ms.Free;
    end;
end;

end.
