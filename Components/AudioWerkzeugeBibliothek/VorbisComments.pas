{
    -----------------------------------
    Audio Werkzeuge Bibliothek
    -----------------------------------
    (c) 2012, Daniel Gaussmann
              Website : www.gausi.de
              EMail   : mail@gausi.de
    -----------------------------------

    Unit VorbisComments

    Helper class for Ogg-Vorbis-Comments (as used in *.ogg, *.opus and *.flac)

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
  Windows, Messages, SysUtils, Variants, ContNrs, Classes, System.NetEncoding,
  AudioFiles.Declarations, AudioFiles.BaseTags
  {$IFDEF USE_SYSTEM_TYPES}, System.Types{$ENDIF} ;

const

    VORBIS_ID = 'vorbis';
    Opus_ID = 'OpusTags';

    VORBIS_ALBUM        = 'ALBUM'        ;
    VORBIS_ARTIST       = 'ARTIST'       ;
    VORBIS_CONTACT      = 'CONTACT'      ;
    VORBIS_COPYRIGHT    = 'COPYRIGHT'    ;
    VORBIS_DATE         = 'DATE'         ;
    VORBIS_YEAR         = 'YEAR'         ;
    VORBIS_DESCRIPTION  = 'DESCRIPTION'  ;
    VORBIS_GENRE        = 'GENRE'        ;
    VORBIS_ISRC         = 'ISRC'         ;
    VORBIS_LICENSE      = 'LICENSE'      ;
    VORBIS_LOCATION     = 'LOCATION'     ;
    VORBIS_ORGANIZATION = 'ORGANIZATION' ;
    VORBIS_PERFORMER    = 'PERFORMER'    ;
    VORBIS_TITLE        = 'TITLE'        ;
    VORBIS_TRACKNUMBER  = 'TRACKNUMBER'  ;
    VORBIS_VERSION      = 'VERSION'      ;
    VORBIS_ALBUMARTIST  = 'ALBUMARTIST'  ;
    METADATA_BLOCK_PICTURE = 'METADATA_BLOCK_PICTURE';
    COVERART = 'COVERART'; // deprecated, not directly supported by this Library

    // keys from https://age.hobba.nl/audio/mirroredpages/ogg-tagging.html
    VORBIS_PUBLISHER = 'PUBLISHER';
    VORBIS_DISCNUMBER = 'DISCNUMBER';
    VORBIS_EANUPN = 'EAN/UPN';
    VORBIS_LABEL = 'LABEL';
    VORBIS_LABELNO = 'LABELNO';
    VORBIS_OPUS = 'OPUS';
    VORBIS_SOURCEMEDIA = 'SOURCEMEDIA';
    VORBIS_ENCODEDBY = 'ENCODED-BY';
    VORBIS_COMPOSER = 'COMPOSER'; //
    VORBIS_ARRANGER = 'ARRANGER';
    VORBIS_LYRICIST = 'LYRICIST';
    VORBIS_AUTHOR = 'AUTHOR';
    VORBIS_CONDUCTOR = 'CONDUCTOR';
    VORBIS_ENSEMBLE = 'ENSEMBLE';
    VORBIS_PART = 'PART';
    VORBIS_PARTNUMBER = 'PARTNUMBER';
    VORBIS_COMMENT = 'COMMENT';

    // additional keys that I use in my Player Nemp, that seems to be used by other players as well
    VORBIS_HARMONIC_KEY = 'INITIALKEY';
    VORBIS_BPM = 'BPM';

    cTextVorbisKeys: Array[0..35] of String = (
        VORBIS_ALBUM, VORBIS_ALBUMARTIST, VORBIS_ARRANGER, VORBIS_ARTIST, VORBIS_AUTHOR, VORBIS_BPM,
        VORBIS_COMMENT, VORBIS_COMPOSER, VORBIS_CONDUCTOR, VORBIS_CONTACT, VORBIS_COPYRIGHT,
        VORBIS_DATE, VORBIS_DESCRIPTION, VORBIS_DISCNUMBER, VORBIS_EANUPN, VORBIS_ENCODEDBY,
        VORBIS_ENSEMBLE, VORBIS_GENRE, VORBIS_HARMONIC_KEY, VORBIS_ISRC, VORBIS_LABEL, VORBIS_LABELNO,
        VORBIS_LICENSE, VORBIS_LOCATION, VORBIS_LYRICIST, VORBIS_OPUS, VORBIS_ORGANIZATION, VORBIS_PART,
        VORBIS_PARTNUMBER, VORBIS_PERFORMER, VORBIS_PUBLISHER, VORBIS_SOURCEMEDIA, VORBIS_TITLE,
        VORBIS_TRACKNUMBER, VORBIS_VERSION, VORBIS_YEAR);

type

    {$IFNDEF UNICODE}
        UnicodeString = WideString;
    {$ENDIF}

    teOggContainerType = (octInvalid, octOgg, octFlac, octOpus);


    TVorbisHeader = packed record
        PacketType: Byte;                       // 1, 3, 5 for the first 3 Vorbis-Header in an Ogg-Stream (we need only the first and second)
        ID: array [1..6] of AnsiChar;           // always "vorbis"
    end;

    TOpusHeader = packed record
        ID: array [1..8] of AnsiChar;           // always "OpusTags"
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

    TCommentVector = class(TTagItem)
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

            function PicDataToBase64(Source: TStream; aMime: AnsiString;
                      aPicType: TPictureType; aDescription: UnicodeString): UTF8String;

        protected
          function GetKey: UnicodeString; override;
          function GetTagContentType: teTagContentType; override;
          function GetDataSize: Integer; override;

        public
            property FieldName: String read fGetFieldName write fSetFieldName;  // = TTagItem.Key
            property Value: UnicodeString read fGetValue write fSetValue;       // = TTagItem.Get/SetText(tmForced)

            constructor Create;
            function ReadFromStream(Source: TStream): Boolean;
            function WriteToStream(Destination: TStream): Boolean;

            function GetText(TextMode: teTextMode = tmReasonable): UnicodeString; override;
            function SetText(aValue: UnicodeString; TextMode: teTextMode = tmReasonable): Boolean; override;

            function GetPicture(Dest: TStream; out Mime: AnsiString; out PicType: TPictureType; out Description: UnicodeString): Boolean; override;
            function SetPicture(Source: TStream; Mime: AnsiString; PicType: TPictureType; Description: UnicodeString): Boolean; override;


    end;

    {
      TMetaDataBlockPicture is a structure from the FLAC documentation.
      However, it is recommended to uses this structure in VorbisComments as well
      for storing CoverArt (Encoded as Base64 in that case).
      Therefore we need it here already, not in unit FlacFiles.pas
    }
    TMetaDataBlockPicture = class
      private
        fPictureType: TPictureType;
        fMime: AnsiString;
        fDescription: Utf8String;
        fWidth         : Cardinal;
        fHeight        : Cardinal;
        fColorDepth    : Cardinal;
        fNumberOfColors: Cardinal;
        fPicData: TMemoryStream;
        function GetDescription: UnicodeString;
        procedure SetDescription(value: UnicodeString);
        function CalculateBlockSize: Cardinal;

        function GetAsBase64: UTF8String;
        procedure SetAsBase64(Value: UTF8String);

    public
        property PicData: TMemoryStream read fPicData;
        property PictureType: TPictureType read fPictureType write fPictureType;
        property Mime: AnsiString read fMime write fMime;
        property Description: UnicodeString read GetDescription write SetDescription;
        property Width         : Cardinal read fWidth          write fWidth          ;
        property Height        : Cardinal read fHeight         write fHeight         ;
        property ColorDepth    : Cardinal read fColorDepth     write fColorDepth     ;
        property NumberOfColors: Cardinal read fNumberOfColors write fNumberOfColors ;
        property Size: Cardinal read CalculateBlockSize;
        property AsBase64: UTF8String read GetAsBase64 write SetAsBase64;

        constructor Create;
        destructor Destroy; override;
        procedure Clear;
        function IsEmpty: Boolean;

        procedure CopyPicData(Target: TStream);
        function ReadFromStream(Source: TStream): Boolean;
        function WriteToStream(Destination: TStream): Boolean;

    end;

    {
    TVorbisComments:
        class for VorbisComments
    }
    TVorbisComments = class
        private
            fContainerType: teOggContainerType;
            fVorbisHeader: TVorbisHeader;
            fOpusHeader: TOpusHeader;

            fVendorString: UTF8String;
            fCommentVectorList: TObjectList;
            fValidComment: Boolean;

            function GetCount: Integer;
            function fGetCommentVectorByFieldname(aField: String): TCommentVector;
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
            function fGetAlbumArtist : UnicodeString;
            function fGetLyrics      : UnicodeString;

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
            procedure fSetAlbumArtist (value: UnicodeString);
            procedure fSetLyrics      (value: UnicodeString);

        public
            property Count: Integer read GetCount;
            property ContainerType: teOggContainerType read fContainerType write fContainerType;
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
            property AlbumArtist : UnicodeString read fGetAlbumArtist  write fSetAlbumArtist ;
            property Lyrics      : UnicodeString read fGetLyrics       write fSetLyrics      ;

            //property CommentVectorList: TObjectList read fCommentVectorList;

            constructor Create;
            destructor Destroy; override;
            procedure Clear;
            function ReadFromStream(Source: TStream; Size: Integer): Boolean;
            function WriteToStream(Destination: TStream): Boolean;
            // The SizeInStream is just the size of the Comments.
            // It does NOT include optional padding!
            // function GetSizeInStream: Integer;   // not needed any more

            // public versions of the private Methods
            function GetPropertyByFieldname(aField: String): UnicodeString;
            // the Set-method also implements some Validations
            function SetPropertyByFieldname(aField: String; aValue: UnicodeString): Boolean;

            procedure GetTagList(Dest: TTagItemList; ContentTypes: TTagContentTypes = cDefaultTagContentTypes);
            procedure DeleteTagItem(aTagItem: TTagItem);

            function GetUnusedTextTags: TTagItemInfoDynArray;
            function AddTextTagItem(aKey, aValue: UnicodeString): TTagItem;

            function GetPicture(Destination: TStream;
                                        var aMime: AnsiString;
                                        var aPicType: TPictureType;
                                        var aDescription: UnicodeString): Boolean; overload;

            function SetPicture(Source: TStream; aMime: AnsiString;
                        aPicType: TPictureType; aDescription: UnicodeString): Boolean;  // use Source=NIL, to delete the picture
            // Add a new Picture
            procedure AddPicture(Source: TStream; aMime: AnsiString; aPicType: TPictureType;
                  aDescription: UnicodeString);
    end;


implementation

uses
  WinApi.WinSock;


// In FlacFiles, all Integers (except in the Comments) are stored BigEndian
// We need to convert them to LittleEndian
function ReadBigEndianCardinal(source: TStream): Cardinal;
begin
    Source.Read(result, SizeOf(result));
    result := ntohl(result);
end;

procedure WriteBigEndianCardinal(Destination: TStream; value: Cardinal);
var x: Cardinal;
begin
    x := htonl(value);
    Destination.Write(x, sizeOf(value));
end;


{ TCommentVector }

constructor TCommentVector.Create;
begin
  inherited create(ttVorbis);
end;

function TCommentVector.fGetFieldName: String;
begin
    result := String(fFieldName);
end;

procedure TCommentVector.fSetFieldname(aName: String);
begin
  // A case-insensitive field name that may consist of ASCII 0x20 through 0x7D, 0x3D ('=') excluded.
  // ASCII 0x41 through 0x5A inclusive (A-Z) is to be considered equivalent to ASCII 0x61 through 0x7A inclusive (a-z).
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

function TCommentVector.GetKey: UnicodeString;
begin
  result := UnicodeString(FieldName);
end;

function TCommentVector.GetTagContentType: teTagContentType;
begin
  // note: by design, *ALL* CommentVectors contain text data.
  // However, there are workarounds for coverart, using Base64 encoding
  // for binary data.
  // There may be other fieldnames containing Base64 encoded binary data.
  // It is up to the developer (= YOU ;-) ) to decide how to deal with it
  // in the application.
  if SameText(Key, METADATA_BLOCK_PICTURE)  then
    result := tctPicture
  else if SameText(Key, COVERART) then
    result := tctBinary
  else
    result := tctText;
end;

function TCommentVector.GetText(TextMode: teTextMode = tmReasonable): UnicodeString;
begin
  if TagContentType = tctText then
    result := Value
  else begin
    if TextMode = tmForced then
      result := Value
    else
      result := '';
  end;
end;

function TCommentVector.SetText(aValue: UnicodeString; TextMode: teTextMode = tmReasonable): Boolean;
begin
  if TagContentType = tctText then begin
    Value := aValue;
    result := True;
  end
  else begin
    if TextMode = tmForced then begin
      Value := aValue;
      result := True;
    end
    else
      result := False;
  end;
end;

function TCommentVector.PicDataToBase64(Source: TStream; aMime: AnsiString;
                      aPicType: TPictureType; aDescription: UnicodeString): UTF8String;
var
  PicBlock: TMetaDataBlockPicture;
begin
  // returns the data as a base64 encoded TMetaDataBlockPicture structure
  PicBlock := TMetaDataBlockPicture.Create;
  try
    picBlock.PictureType := aPicType;
    picBlock.Mime := aMime;
    picBlock.Description := aDescription;
    picBlock.PicData.Clear;
    picBlock.PicData.CopyFrom(Source, 0);
    result := PicBlock.AsBase64;
  finally
    PicBlock.Free;
  end;
end;

function TCommentVector.GetPicture(Dest: TStream; out Mime: AnsiString;
  out PicType: TPictureType; out Description: UnicodeString): Boolean;
var
  PicBlock: TMetaDataBlockPicture;
begin
  result := (TagContentType = tctPicture) and (fValue <> '');
  Mime := '';
  PicType := ptOther;
  Description := '';

  if result then begin
    PicBlock := TMetaDataBlockPicture.Create;
    try
      PicBlock.AsBase64 := UTF8String(fValue);
      result := PicBlock.Size > 0;
      if result then begin
        Dest.CopyFrom(picBlock.PicData, 0);
        Mime := picBlock.Mime;
        PicType := picBlock.PictureType;
        Description := picBlock.Description;
      end;
    finally
      PicBlock.Free;
    end;
  end;
end;

function TCommentVector.SetPicture(Source: TStream; Mime: AnsiString;
  PicType: TPictureType; Description: UnicodeString): Boolean;
begin
  result := TagContentType = tctPicture;
  if result then
    Value := UnicodeString(PicDataToBase64(Source, Mime, PicType, Description));
end;

function TCommentVector.GetDataSize: Integer;
begin
  result := Length(Value);
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
    fVorbisHeader.PacketType := 0;
    fVorbisHeader.ID := '123456'; // invalid
    fOpusHeader.ID := '12345678'; // invalid
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

function TVorbisComments.GetCount: Integer;
begin
  result := fCommentVectorList.Count;
end;

function TVorbisComments.fGetCommentVectorByFieldname(aField: String): TCommentVector;
var
  i: Integer;
begin
    result := Nil;
    for i := 0 to fCommentVectorList.Count - 1 do
    begin
        if SameText(aField, TCommentVector(fCommentVectorList[i]).FieldName) then
        begin
            result := TCommentVector(fCommentVectorList[i]);
            break;
        end;
    end;
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
    result := fGetPropertyByFieldname(VORBIS_ALBUM);
end;

function TVorbisComments.fGetAlbumArtist: UnicodeString;
begin
  result := fGetPropertyByFieldName(VORBIS_ALBUMARTIST);
end;

function TVorbisComments.fGetArtist: UnicodeString;
begin
    result := fGetPropertyByFieldname(VORBIS_ARTIST);
end;

function TVorbisComments.fGetContact: UnicodeString;
begin
    result := fGetPropertyByFieldname(VORBIS_CONTACT);
end;

function TVorbisComments.fGetCopyright: UnicodeString;
begin
    result := fGetPropertyByFieldname(VORBIS_COPYRIGHT);
end;

function TVorbisComments.fGetDate: UnicodeString;
begin
    result := fGetPropertyByFieldname(VORBIS_DATE);
    if result = '' then
        result := fGetPropertyByFieldname(VORBIS_YEAR);
end;

function TVorbisComments.fGetDescription: UnicodeString;
begin
    result := fGetPropertyByFieldname(VORBIS_DESCRIPTION);
end;

function TVorbisComments.fGetGenre: UnicodeString;
begin
    result := fGetPropertyByFieldname(VORBIS_GENRE);
end;

function TVorbisComments.fGetISRC: UnicodeString;
begin
    result := fGetPropertyByFieldname(VORBIS_ISRC);
end;

function TVorbisComments.fGetLicense: UnicodeString;
begin
    result := fGetPropertyByFieldname(VORBIS_LICENSE);
end;

function TVorbisComments.fGetLocation: UnicodeString;
begin
    result := fGetPropertyByFieldname(VORBIS_LOCATION);
end;

function TVorbisComments.fGetOrganization: UnicodeString;
begin
    result := fGetPropertyByFieldname(VORBIS_ORGANIZATION);
end;

function TVorbisComments.fGetPerformer: UnicodeString;
begin
    result := fGetPropertyByFieldname(VORBIS_PERFORMER);
end;

function TVorbisComments.fGetTitle: UnicodeString;
begin
    result := fGetPropertyByFieldname(VORBIS_TITLE);
end;

function TVorbisComments.fGetTrackNumber: UnicodeString;
begin
    result := fGetPropertyByFieldname(VORBIS_TRACKNUMBER);
end;

function TVorbisComments.fGetVersion: UnicodeString;
begin
    result := fGetPropertyByFieldname(VORBIS_VERSION);
end;

function TVorbisComments.fGetLyrics: UnicodeString;
var
  i: Integer;
begin
  result := '';
  i := 0;
  while (result = '') and (i <= High(AWB_SupportedLyricsKeys)) do begin
    result := fGetPropertyByFieldname(AWB_SupportedLyricsKeys[i]);
    inc(i);
  end;
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
            matchingVector.FieldName := AnsiUppercase(aField);
            fCommentVectorList.Add(matchingVector);
        end;

        // set the new Value
        matchingVector.Value := aValue;
    end;
end;

procedure TVorbisComments.fSetAlbum(value: UnicodeString);
begin
    fSetPropertyByFieldname(VORBIS_ALBUM, Value);
end;

procedure TVorbisComments.fSetAlbumArtist(value: UnicodeString);
begin
  fSetPropertyByFieldName(VORBIS_ALBUMARTIST, value);
end;

procedure TVorbisComments.fSetArtist(value: UnicodeString);
begin
    fSetPropertyByFieldname(VORBIS_ARTIST, Value);
end;

procedure TVorbisComments.fSetContact(value: UnicodeString);
begin
    fSetPropertyByFieldname(VORBIS_CONTACT, Value);
end;

procedure TVorbisComments.fSetCopyright(value: UnicodeString);
begin
    fSetPropertyByFieldname(VORBIS_COPYRIGHT, Value);
end;

procedure TVorbisComments.fSetDate(value: UnicodeString);
begin
    fSetPropertyByFieldname(VORBIS_DATE, Value);
end;

procedure TVorbisComments.fSetDescription(value: UnicodeString);
begin
    fSetPropertyByFieldname(VORBIS_DESCRIPTION, Value);
end;

procedure TVorbisComments.fSetGenre(value: UnicodeString);
begin
    fSetPropertyByFieldname(VORBIS_GENRE, Value);
end;

procedure TVorbisComments.fSetISRC(value: UnicodeString);
begin
    fSetPropertyByFieldname(VORBIS_ISRC, Value);
end;

procedure TVorbisComments.fSetLicense(value: UnicodeString);
begin
    fSetPropertyByFieldname(VORBIS_LICENSE, Value);
end;

procedure TVorbisComments.fSetLocation(value: UnicodeString);
begin
    fSetPropertyByFieldname(VORBIS_LOCATION, Value);
end;

procedure TVorbisComments.fSetOrganization(value: UnicodeString);
begin
    fSetPropertyByFieldname(VORBIS_ORGANIZATION, Value);
end;

procedure TVorbisComments.fSetPerformer(value: UnicodeString);
begin
    fSetPropertyByFieldname(VORBIS_PERFORMER, Value);
end;

procedure TVorbisComments.fSetTitle(value: UnicodeString);
begin
    fSetPropertyByFieldname(VORBIS_TITLE, Value);
end;

procedure TVorbisComments.fSetTrackNumber(value: UnicodeString);
begin
    fSetPropertyByFieldname(VORBIS_TRACKNUMBER, Value);
end;

procedure TVorbisComments.fSetVersion(value: UnicodeString);
begin
    fSetPropertyByFieldname(VORBIS_VERSION, Value);
end;

procedure TVorbisComments.fSetLyrics(value: UnicodeString);
var
  i: Integer;
  lyricVector: TCommentVector;
begin
  lyricVector := Nil;
  i := 0;
  while (lyricVector = Nil) and (i <= High(AWB_SupportedLyricsKeys)) do begin
    lyricVector := fGetCommentVectorByFieldname(AWB_SupportedLyricsKeys[i]);
    inc(i);
  end;

  if trim(Value) = '' then begin
    if assigned(lyricVector) then begin
      fCommentVectorList.Extract(lyricVector);
      FreeAndNil(lyricVector);
    end;
  end else
  begin
    // if no lyric Vector was found: Create a new one and add it to the VectorList
    if not assigned(lyricVector) then begin
      lyricVector := TCommentVector.Create;
      lyricVector.FieldName := AnsiUppercase(AWB_DefaultLyricsKey);
      fCommentVectorList.Add(lyricVector);
    end;
    lyricVector.Value := Value;
  end;
end;


function TVorbisComments.ReadFromStream(Source: TStream; Size: Integer): Boolean;
var vendorLength: Integer;
    i, CommentCount: Integer;
    newCommentVector: TCommentVector;
    framingBit: Byte;
    currentPos: Int64;
    ValidHeader: Boolean;
begin
    // store currentPos in the Stream
    currentPos := Source.Position;
    Clear;

    ValidHeader := True;
    case fContainerType of
      octOgg: begin
        source.Read(fVorbisHeader, sizeOf(fVorbisHeader));
        ValidHeader := (fVorbisHeader.PacketType = 3) and (fVorbisHeader.ID = VORBIS_ID);
      end;
      octFlac: ValidHeader := True; // nothing else to to
      octOpus: begin
        source.Read(fOpusHeader, sizeOf(fOpusHeader));
        ValidHeader := fOpusHeader.ID = Opus_ID
      end;
    end;

    if not ValidHeader then begin
      fValidComment := False;
      result := False;
      Source.Seek(currentPos + Size, soBeginning);
      exit;
    end;

    // first: VendorString
    // should be something like "Xiph.Org libVorbis I 20020717"
    source.Read(vendorLength, sizeOf(vendorlength));
    if vendorLength > 0 then begin
      setlength(fVendorString, vendorLength);
      source.Read(fVendorString[1], length(fVendorString));
    end;

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

    case fContainerType of
      octOgg: begin
        source.Read(framingBit, sizeOf(framingBit));
        // this should be 1, otherwise the Header is invalid
        fValidComment := framingBit = 1;
      end;
      octFlac: fValidComment := True;
      octOpus: fValidComment := True;
    end;
    result := ValidComment;

    // Seek in the Stream after the Comment-Packet (which could include some padding
    // after the framing bit)
    if Size >= 0 then
        Source.Seek(currentPos + Size, soBeginning);
end;


function TVorbisComments.WriteToStream(Destination: TStream): Boolean;
var l,c,i: integer;
    framingBit: Byte;
begin
    result := True;
    try
        case fContainerType of
          octOgg: Destination.Write(fVorbisHeader, SizeOf(fVorbisHeader)); // #3 + vorbis
          octFlac: ;
          octOpus: Destination.Write(fOpusHeader, SizeOf(fOpusHeader)); // "OpusTags"
        end;

        // write vendorstring
        l := length(fVendorString);
        Destination.Write(l, sizeOf(l));
        if l > 0 then
          Destination.Write(fVendorString[1], l);
        // write number of comments
        c := fCommentVectorList.Count;
        Destination.Write(c, sizeOf(c));
        // write comments
        for i := 0 to c-1 do
            if not TCommentVector(fCommentVectorList[i]).WriteToStream(Destination) then
                result := False;

        case fContainerType of
          octOgg: begin
            framingBit := 1;
            Destination.Write(framingBit, sizeOf(framingBit));
          end;
          octFlac: ;
          octOpus: ;
        end;

    except
        result := False;
    end;
end;

function TVorbisComments.GetPicture(Destination: TStream;
  var aMime: AnsiString; var aPicType: TPictureType;
  var aDescription: UnicodeString): Boolean;
var
  picTags: TTagItemList;
begin
  result := False;
  picTags := TTagItemList.Create;
  try
    GetTagList(picTags, [tctPicture]);
    if picTags.Count > 0 then begin
      result := picTags[0].GetPicture(Destination, aMime, aPicType, aDescription);
    end;
  finally
     picTags.Free;
  end;
end;

function TVorbisComments.SetPicture(Source: TStream; aMime: AnsiString; aPicType: TPictureType; aDescription: UnicodeString): Boolean;
var
  picTags: TTagItemList;
begin
  picTags := TTagItemList.Create;
  try
    GetTagList(picTags, [tctPicture]);

    result := picTags.Count > 0;
    // currently no pic in the file, and stream contains a pic: Add a pic.
    if (picTags.Count = 0) and assigned(Source) then begin
      AddPicture(Source, aMime, aPicType, aDescription);
      result := True;
    end;
    // otherwise: replace a current pic (or delete it)
    if picTags.Count > 0 then begin
      if assigned(Source) then
        result := picTags[0].SetPicture(Source, aMime, aPicType, aDescription)
      else begin
        fCommentVectorList.Extract(picTags[0]);
        FreeAndNil(picTags[0]);
      end;
    end;
  finally
    picTags.Free;
  end;
end;

procedure TVorbisComments.AddPicture(Source: TStream; aMime: AnsiString; aPicType: TPictureType;
      aDescription: UnicodeString);
var
  newCommentVector: TCommentVector;
begin
  if assigned(Source) and (Source.Size > 0) then begin
    newCommentVector := TCommentVector.Create;
    newCommentVector.FieldName := AnsiUppercase(METADATA_BLOCK_PICTURE);
    newCommentVector.SetPicture(Source, aMime, aPicType, aDescription);
    fCommentVectorList.Add(newCommentVector);
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

procedure TVorbisComments.GetTagList(Dest: TTagItemList; ContentTypes: TTagContentTypes = cDefaultTagContentTypes);
var
  i: Integer;
begin
  for i := 0 to fCommentVectorList.Count - 1 do
    if TCommentVector(fCommentVectorList[i]).MatchContentType(ContentTypes) then
      Dest.Add(TCommentVector(fCommentVectorList[i]));
end;

procedure TVorbisComments.DeleteTagItem(aTagItem: TTagItem);
begin
  fCommentVectorList.Remove(aTagItem);
end;

function TVorbisComments.GetUnusedTextTags: TTagItemInfoDynArray;
var
  iKey, iRes: Integer;
  resultArray: TTagItemInfoDynArray;
begin
  SetLength(resultArray, Length(cTextVorbisKeys));  // max. possible length
  iRes := 0;

  for iKey := Low(cTextVorbisKeys) to High(cTextVorbisKeys) do begin
    if not assigned(fGetCommentVectorByFieldname(cTextVorbisKeys[iKey])) then begin
      resultArray[iRes].Key := cTextVorbisKeys[iKey];
      resultArray[iRes].Description := '';
      resultArray[iRes].TagType := ttVorbis;
      resultArray[iRes].TagContentType := tctText;
      inc(iRes);
    end;
  end;

  SetLength(resultArray, iRes); // correct length
  result := resultArray;
end;

function TVorbisComments.AddTextTagItem(aKey, aValue: UnicodeString): TTagItem;
begin
  if SetPropertyByFieldname(aKey, aValue) then
    result := fGetCommentVectorByFieldname(aKey)
  else
    result := Nil;
end;


(*function TVorbisComments.GetSizeInStream: Integer;
var ms: TMemoryStream;
begin
    ms := TMemoryStream.Create;
    try
        WriteToStream(ms);
        result := ms.Size;
    finally
        ms.Free;
    end;
end;*)

{ TMetaDataBlockPicture }

constructor TMetaDataBlockPicture.Create;
begin
  fPicData := TMemoryStream.Create;
end;

destructor TMetaDataBlockPicture.Destroy;
begin
  fPicData.Free;
  inherited;
end;

procedure TMetaDataBlockPicture.Clear;
begin
  fPicData.Clear;
  Mime := '';
  Description := '';
  fWidth := 0;
  fHeight := 0;
  fColorDepth := 0;
  fNumberOfColors:= 0;
end;

function TMetaDataBlockPicture.CalculateBlockSize: Cardinal;
begin
  result := 8*4 // the Integers/lengths stored in the block
        + length(fMime)
        + length(fDescription)
        + fPicData.Size;
end;

procedure TMetaDataBlockPicture.CopyPicData(Target: TStream);
begin
  Target.CopyFrom(fPicData, 0);
end;


function TMetaDataBlockPicture.IsEmpty: Boolean;
begin
  result := fPicData.Size = 0;
end;

function TMetaDataBlockPicture.GetDescription: UnicodeString;
begin
  {$IFDEF UNICODE}
  result := UnicodeString(fDescription);
  {$ELSE}
  result := UTF8Decode(fDescription);
  {$ENDIF}
end;

procedure TMetaDataBlockPicture.SetAsBase64(Value: UTF8String);
var
  InputStream, OutputStream: TMemoryStream;
begin
  InputStream := TMemoryStream.Create;
  OutputStream := TMemoryStream.Create;
  try
    InputStream.Write(Value[1], Length(Value));
    InputStream.Position := 0;
    TNetEncoding.Base64.Decode(InputStream, OutPutStream);
    OutPutStream.Position := 0;
    ReadFromStream(OutputStream);
  finally
    InputStream.Free;
    OutputStream.Free;
  end;
end;

function TMetaDataBlockPicture.GetAsBase64: UTF8String;
var
  Base64: TBase64Encoding;
  InputStream, OutputStream: TMemoryStream;
begin
  Base64 := TBase64Encoding.Create(0); // no LineBreaks!!
  try
    InputStream := TMemoryStream.Create;
    OutputStream := TMemoryStream.Create;
    try
      WriteToStream(InputStream);
      InputStream.Position := 0;
      Base64.Encode(InputStream, OutputStream);
      OutputStream.Position := 0;
      SetLength(result, OutputStream.Size);
      OutputStream.Read(result[1], length(result));
    finally
      OutputStream.Free;
      InputStream.Free;
    end;
  finally
    Base64.Free;
  end;
end;


procedure TMetaDataBlockPicture.SetDescription(value: UnicodeString);
begin
  {$IFDEF UNICODE}
  fDescription := Utf8String(value);
  {$ELSE}
  fDescription := UTF8Encode(value);
  {$ENDIF}
end;

function TMetaDataBlockPicture.ReadFromStream(Source: TStream): Boolean;
var
  mimeLength, descLength, picSize: Cardinal;
begin
  // 1. Picture-Type
  fPictureType := TPictureType(ReadBigEndianCardinal(Source));
  // 2. Mime-type
  mimeLength := ReadBigEndianCardinal(Source);
  SetLength(fMime, mimeLength);
  Source.Read(fMime[1], mimeLength);
  // 3. Description
  descLength := ReadBigEndianCardinal(Source);
  SetLength(fDescription, descLength);
  Source.Read(fDescription[1], descLength);
  // 4. Some data about the Picture
  fWidth          := ReadBigEndianCardinal(Source);
  fHeight         := ReadBigEndianCardinal(Source);
  fColorDepth     := ReadBigEndianCardinal(Source);
  fNumberOfColors := ReadBigEndianCardinal(Source);
  // 5. Picture Data
  picSize := ReadBigEndianCardinal(Source);
  fPicData.Clear;
  fPicData.CopyFrom(Source, PicSize);
  result := True;
end;

function TMetaDataBlockPicture.WriteToStream(Destination: TStream): Boolean;
begin

    // 1. Picture-Type
    WriteBigEndianCardinal(Destination, Cardinal(fPictureType));
    // 2. Mime-type
    WriteBigEndianCardinal(Destination, length(fMime));
    Destination.Write(fMime[1], length(fMime));
    // 3. Description
    WriteBigEndianCardinal(Destination, length(fDescription));
    Destination.Write(fDescription[1], length(fDescription));
    // 4. Some data about the Picture
    WriteBigEndianCardinal(Destination, fWidth         );
    WriteBigEndianCardinal(Destination, fHeight        );
    WriteBigEndianCardinal(Destination, fColorDepth    );
    WriteBigEndianCardinal(Destination, fNumberOfColors);
    // 5. Picture Data
    WriteBigEndianCardinal(Destination, fPicData.Size);
    Destination.CopyFrom(fPicData, 0);
    result := True;
end;

end.
