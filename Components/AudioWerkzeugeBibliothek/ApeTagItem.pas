{
    -----------------------------------
    Audio Werkzeuge Bibliothek
    -----------------------------------
    (c) 2012-2024, Daniel Gaussmann
              Website : www.gausi.de
              EMail   : mail@gausi.de
    -----------------------------------

    Unit ApeTagItem

    Helper class for ApeV2Tags

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

unit ApeTagItem;

interface

uses Windows, Messages, SysUtils, Variants, ContNrs, Classes, StrUtils,
  AudioFiles.Declarations, AudioFiles.BaseTags;

const

    cApePictureKeys: Array[TPictureType] of AnsiString = (
      'Cover Art (other)', 'Cover Art (icon)', 'Cover Art (other icon)',
      'Cover Art (front)', 'Cover Art (back)', 'Cover Art (leaflet)',
      'Cover Art (media)', 'Cover Art (lead)', 'Cover Art (artist)',
      'Cover Art (conductor)', 'Cover Art (band)', 'Cover Art (composer)',
      'Cover Art (lyricist)', 'Cover Art (studio)', 'Cover Art (recording)',
      'Cover Art (performance)', 'Cover Art (movie scene)',
      'Cover Art (colored fish)', 'Cover Art (illustration)',
      'Cover Art (band logo)', 'Cover Art (publisher logo)' );

      APE_AlbumArtist     = 'Albumartist';
      APE_Artist          = 'Artist';
      APE_Title           = 'Title';
      APE_Album           = 'Album';
      APE_Genre           = 'Genre';
      APE_Track           = 'Track';
      APE_Year            = 'Year';
      APE_Abstract        = 'Abstract';
      APE_Bibliography    = 'Bibliography';
      APE_Catalog         = 'Catalog';
      APE_Comment         = 'Comment';
      APE_Composer        = 'Composer';
      APE_Conductor       = 'Conductor';
      APE_Copyright       = 'Copyright';
      APE_DebutAlbum      = 'Debut album';
      APE_EANUBC          = 'EAN/UBC';
      APE_File            = 'File';
      APE_Index           = 'Index';
      APE_Introplay       = 'Introplay';
      APE_ISBN            = 'ISBN';
      APE_ISRC            = 'ISRC';
      APE_Language        = 'Language';
      APE_LC              = 'LC';
      APE_Media           = 'Media';
      APE_PublicationRight = 'Publicationright';
      APE_Publisher       = 'Publisher';
      APE_RecordDate      = 'Record Date';
      APE_RecordLocation  = 'Record Location';
      APE_Related         = 'Related';
      APE_Subtitle        = 'Subtitle';
      APE_BPM             = 'BPM';
      // additional keys that I use in my Player Nemp, that seems to be used by other players as well
      APE_HARMONIC_KEY    = 'InitialKey';
      APE_Discnumber      = 'DISCNUMBER';

    cTextApeKeys: Array[0..32] of string = (
      APE_Abstract, APE_Album, APE_AlbumArtist, APE_Artist, APE_Bibliography,
      APE_BPM, APE_Catalog, APE_Comment, APE_Composer, APE_Conductor, APE_Copyright,
      APE_DebutAlbum, APE_Discnumber, APE_EANUBC, APE_File, APE_Genre, APE_Index,
      APE_HARMONIC_KEY, APE_Introplay, APE_ISBN, APE_ISRC, APE_Language, APE_LC,
      APE_Media, APE_PublicationRight, APE_Publisher, APE_RecordDate,
      APE_RecordLocation, APE_Related, APE_Subtitle, APE_Title, APE_Track,
      APE_Year);

type
    TBuffer = Array of Byte;

    // TApeTagItemContentType is just used in the Constructor of an ApetagItem
    // Otherwise, the more general teTagContentType is used
    TApeTagItemContentType = (ctApeText, ctApeBinary, ctApeExternal); // ctApeReserved not supported

    TApeTagItem = class(TTagItem)
        private
            fValueSize: Integer;
            fFlags: DWord;
            fKey: AnsiString;
            fValue: UTF8String;    // for normal String Data
            fData: TBuffer;        // for Binary Data

            function fGetCompleteSize: Integer;
            procedure SetTagContentType(aValue: teTagContentType);
            procedure fSetReadOnly(aValue: Boolean);
            function fGetReadOnly: Boolean;
            function GetPicType: TPictureType;

        protected
            function GetKey: UnicodeString; override;
            function GetTagContentType: teTagContentType; override;
            function GetDataSize: Integer; override;
        public
            property ValueSize: Integer read fValueSize;
            property CompleteSize: Integer read fGetCompleteSize;
            property Flags: DWord read fFlags;
            property ReadOnlyFlag: Boolean read fGetReadOnly write fSetReadOnly;

            // Create a ApeTagItem
            // If you want to add a new TagItem to an existing ApeTag-Structure by yourself, you MUST set Key and TagType
            // While reading TagItems from an existing ApeTag, these values will be overwritten be ReadFromStream
            constructor Create(aKey: AnsiString; aType: TApeTagItemContentType = ctApeText);

            function GetText(TextMode: teTextMode = tmReasonable): UnicodeString; override;
            function SetText(aValue: UnicodeString; TextMode: teTextMode = tmReasonable): Boolean; override;

            function GetPicture(Dest: TStream; out Mime: AnsiString; out PicType: TPictureType; out Description: UnicodeString): Boolean; override;
            function SetPicture(Source: TStream; Mime: AnsiString; PicType: TPictureType; Description: UnicodeString): Boolean; override;

            function GetBinaryData(dest: TStream): boolean;
            procedure SetBinaryData(source: TStream);

            function ReadFromStream(aStream: TStream): Boolean;
            function WriteToStream(aStream: TStream): Boolean;
    end;

    function ValidApeKey(aKey: AnsiString): Boolean;

implementation

function ValidApeKey(aKey: AnsiString): Boolean;
var
  i: Integer;
begin
  result := True;
  for i := 1 to length(aKey) do
    if not (aKey[i] in [' '..'~'] ) then begin
      result := false;
      break;
    end;
end;

{ TApeTagItem }

constructor TApeTagItem.Create(aKey: AnsiString; aType: TApeTagItemContentType = ctApeText);
begin
  fTagType := ttApev2;
  fKey := aKey;
  case aType  of
    ctApeText: SetTagContentType(tctText);
    ctApeBinary: SetTagContentType(tctBinary);
    ctApeExternal: SetTagContentType(tctExternal);
  end;
end;

function TApeTagItem.fGetCompleteSize: Integer;
begin
  result := 8 + length(fKey) + 1 + fValueSize;
end;

function TApeTagItem.GetKey: UnicodeString;
begin
  result := UnicodeString(fKey);
end;

function TApeTagItem.GetTagContentType: teTagContentType;
var
  b: Cardinal;
begin
    // result := TApeTagItemContentType((Flags shr 1) AND 3);
    // former TApeTagItemContentType = (ctText, ctBinary, ctExternal, ctreserved);
    b := (Flags shr 1) AND 3;
    case b of
      0: result := tctText;
      1: begin
        result := tctBinary;
        if AnsiStartsText('Cover Art', String(fKey)) then
          result := tctPicture;
      end;
      2: result := tctExternal;
    else
      result := tctReserved; // kinda invalid.
    end;
end;

procedure TApeTagItem.SetTagContentType(aValue: teTagContentType);
var
  b: Cardinal;
begin
    case aValue of
      tctText: b := 0;
      tctBinary: b := 1;
      tctExternal: b := 2;
      tctReserved: b := 3;
    else
      b := 1;
    end;

    fFlags :=
    (((not 0)     // all Bits 1
    - (3 shl 1))  // all Bits 1 except bit 1,2
    and fFlags)   // Flag-Bits Niled
    or
    (b shl 1);  // Set new Flag
end;

procedure TApeTagItem.fSetReadOnly(aValue: Boolean);
begin
    if aValue then
        fFlags := fFlags or 1
    else
        fFlags := ((not 0) shl 1) // last bit is 0, others 1
                  and fFlags;
end;
function TApeTagItem.fGetReadOnly: Boolean;
begin
    result := (fFlags And 1) = 1;
end;

function TApeTagItem.GetText(TextMode: teTextMode = tmReasonable): UnicodeString;
begin
    result := '';
    if TagContentType in [tctText, tctExternal] then
        result := ConvertUTF8ToString(fValue)
    else begin
      if TextMode = tmForced then
        result := ByteArrayToString(fData)
    end;
end;

function TApeTagItem.SetText(aValue: UnicodeString; TextMode: teTextMode = tmReasonable): Boolean;
begin
    result := TagContentType in [tctText, tctExternal];

    if result then begin
      fValue := ConvertStringToUTF8(aValue);
      fValueSize := length(fValue);
      ReadOnlyFlag := False;
    end;
end;

function TApeTagItem.GetBinaryData(dest: TStream): boolean;
begin
    if TagContentType <> tctBinary then
        result := False
    else
    begin
        dest.Write(fData[0], length(fData));
        result := True;
    end;
end;

procedure TApeTagItem.SetBinaryData(source: TStream);
begin
    Setlength(fData, source.Size);
    source.Position := 0;
    source.Read(fData[0], source.Size);
    fValueSize := length(fData);
    SetTagContentType(tctBinary);
    ReadOnlyFlag := False;
end;

function TApeTagItem.GetPicType: TPictureType;
var
  i: TPictureType;
begin
  result := ptOther;
  for i := Low(TPictureType) to High(TPictureType) do begin
    if fKey = cApePictureKeys[i] then begin
      result := i;
      break;
    end;
  end;
end;

function TApeTagItem.GetPicture(Dest: TStream; out Mime: AnsiString; out PicType: TPictureType; out Description: UnicodeString): Boolean;
var i, c: Integer;
    tmp: Utf8String;
begin
    Mime := '';
    Description := '';
    PicType := GetPicType;
    result := TagContentType in [tctBinary, tctPicture];
    if not result then
        exit;

    // expected data format:
    // <description> (UTF8 encoded)
    // $00           (delimiter)
    // data          (actual picture data)
    c := High(Integer);
    for i := 0 to length(fData) - 1 do
        // get position of $00 Delimiter
        if fData[i] = 0 then
        begin
            c := i;
            break;
        end;
    if c < length(fData)-1 then
    begin
        Setlength(tmp, c);
        Move(fData[0], tmp[1], c);
        description := ConvertUTF8ToString(tmp);

        dest.Write(fData[c+1], length(fData)-(c+1));
        result := True;
    end else
        // unexpected data format
        result := False;
end;


function TApeTagItem.SetPicture(Source: TStream; Mime: AnsiString; PicType: TPictureType; Description: UnicodeString): Boolean;
var descUTF8: UTF8String;
begin
    // parameters PicType and Mime are ignored
    // * a TagItem cannot change it's key (because it must be unique in the Tag)
    // * There is no Mimetype information provided in this format
    result := TagContentType in [tctBinary, tctPicture];
    if not result then
      exit;

    if (description = '') then
        description := 'Cover Art';

    descUTF8 := ConvertStringToUTF8(description);
    Setlength(fData, length(descUTF8) + 1 + source.Size);
    Move(descUTF8[1], fData[0], length(descUTF8));
    fData[length(descUTF8)] := 0;
    source.Position := 0;
    source.Read(fData[length(descUTF8)+1], source.Size);

    fValueSize := length(fData);
    SetTagContentType(tctBinary);
    ReadOnlyFlag := False;
end;

function TApeTagItem.GetDataSize: Integer;
begin
  if TagContentType in [tctBinary, tctPicture] then
    result := Length(fData)
  else
    result := Length(fValue);
end;

function TApeTagItem.ReadFromStream(aStream: TStream): Boolean;
var c, i, keyLength: Integer;
    KeyBuf: Array [1..256] of AnsiChar;
    tmpKey: AnsiString;
    cPos: Integer;
begin
    result := True;

    aStream.Read(fValueSize, 4);
    aStream.Read(fFlags, 4);

    // Itemkey: AnsiString terminated with $00
    cPos := aStream.Position;
    c := aStream.Read(KeyBuf[1], 256);  // 255 is maximum length for the key, 256 must be 0 then
    keyLength := -1;
    for i := 1 to c do
        if ord(KeyBuf[i]) = 0 then
        begin
            keyLength := i;
            break;
        end;

    // Check for valid key length
    if keyLength < 0 then
    begin
        result := False;
        Exit;
    end;

    tmpKey := Copy(KeyBuf, 1, keyLength - 1);
    // Check for valid key
    if Not ValidApeKey(tmpKey) then
    begin
        result := False;
        Exit;
    end;
    // key is valid
    fKey := tmpKey;

    aStream.Position := cPos + keyLength;

    if TagContentType in [tctBinary, tctPicture] then
    begin
        // fill fDATA with the binary data for further parsing
        SetLength(fData, fValueSize);
        aStream.Read(fData[0], fValueSize);
    end else
    begin
        // Content is UTF8 encoded text
        SetLength(fValue, fValueSize);
        aStream.Read(fValue[1], fValueSize);
    end;
end;

function TApeTagItem.WriteToStream(aStream: TStream): Boolean;
var b: Byte;
begin
    // first: Length of Value
    aStream.Write(fValueSize, 4);
    // Flags
    aStream.Write(fFlags, 4);
    // key
    aStream.Write(fKey[1], length(fKey));
    b := 0;
    aStream.Write(b, 1);

    if TagContentType = tctBinary then
        aStream.Write(fData[0], fValueSize)
    else
        aStream.Write(fValue[1], fValueSize);

    result := True;
end;

end.
