{
    -----------------------------------
    Audio Werkzeuge Bibliothek
    -----------------------------------
    (c) 2012, Daniel Gaussmann
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

uses Windows, Messages, SysUtils, Variants, ContNrs, Classes, AudioFileBasics;

type
    TApePictureTypes = (
      apt_Arbitrary,
      apt_Other, apt_Icon, apt_OtherIcon, apt_Front, apt_Back, apt_Leaflet,
      apt_Media, apt_Lead, apt_Artist, apt_Conductor, apt_Band, apt_Composer,
      apt_Lyricist, apt_Studio, apt_Recording, apt_Performance, apt_MovieScene,
      apt_ColoredFish, apt_Illustration, apt_BandLogo, apt_PublisherLogo );

const
    TPictureTypeStrings: Array[TApePictureTypes] of AnsiString = (
      '',
      'Cover Art (other)', 'Cover Art (icon)', 'Cover Art (other icon)',
      'Cover Art (front)', 'Cover Art (back)', 'Cover Art (leaflet)',
      'Cover Art (media)', 'Cover Art (lead)', 'Cover Art (artist)',
      'Cover Art (conductor)', 'Cover Art (band)', 'Cover Art (composer)',
      'Cover Art (lyricist)', 'Cover Art (studio)', 'Cover Art (recording)',
      'Cover Art (performance)', 'Cover Art (movie scene)',
      'Cover Art (colored fish)', 'Cover Art (illustration)',
      'Cover Art (band logo)', 'Cover Art (publisher logo)' );


type
    TBuffer = Array of Byte;

    TApeTagItemContentType = (ctText, ctBinary, ctExternal, ctreserved);

    TApeTagItem = class
        private
            fValueSize: Integer;
            fFlags: DWord;
            fKey: AnsiString;
            fValue: UTF8String;    // for normal String Data
            fData: TBuffer;        // for Binary Data

            function fCheckKey(aKey: AnsiString): Boolean;

            function fGetCompleteSize: Integer;

            procedure fSetValue(aValue: UnicodeString);
            function fGetValue: UnicodeString;

            procedure fSetContentType(aValue: TApeTagItemContentType);
            function fGetContentType: TApeTagItemContentType;

            procedure fSetReadOnly(aValue: Boolean);
            function fGetReadOnly: Boolean;
        public
            property ValueSize: Integer read fValueSize;
            property CompleteSize: Integer read fGetCompleteSize;
            property Flags: DWord read fFlags;
            property Key: AnsiString read fKey;
            property Value: UnicodeString read fGetValue write fSetValue;

            property ContentType: TApeTagItemContentType read fGetContentType write fSetContentType;
            property ReadOnlyFlag: Boolean read fGetReadOnly write fSetReadOnly;
            constructor Create(aKey: AnsiString);

            function GetBinaryData(dest: TStream): boolean;
            procedure SetBinaryData(source: TStream);

            function GetPicture(dest: TStream; var description: UnicodeString): boolean;
            procedure SetPicture(source: TStream; description: UnicodeString);

            function ReadFromStream(aStream: TStream): Boolean;
            function WriteToStream(aStream: TStream): Boolean;
    end;

implementation

{ TApeTagItem }

constructor TApeTagItem.Create(aKey: AnsiString);
begin
    if fCheckKey(aKey) then
        fKey := aKey;
end;

function TApeTagItem.fCheckKey(aKey: AnsiString): Boolean;
var i: Integer;
begin
    result := True;
    for i := 1 to length(aKey) do
        if Not (aKey[i] in [' '..'~'] ) then
            result := false;
end;

function TApeTagItem.fGetCompleteSize: Integer;
begin
    result := 8 + length(fKey) + 1 + fValueSize;
end;

function TApeTagItem.fGetContentType: TApeTagItemContentType;
begin
    result := TApeTagItemContentType((Flags shr 1) AND 3);
end;

procedure TApeTagItem.fSetContentType(aValue: TApeTagItemContentType);
begin
    fFlags :=
    (((not 0)     // all Bits 1
    - (3 shl 1))  // all Bits 1 except bit 1,2
    and fFlags)   // Flag-Bits Niled
    or
    (DWord(aValue) shl 1);  // Set new Flag
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

function TApeTagItem.fGetValue: UnicodeString;
begin
    if ContentType in [ctText, ctExternal] then
        result := ConvertUTF8ToString(fValue)
    else
        result := '<Binary Data>';
end;

procedure TApeTagItem.fSetValue(aValue: UnicodeString);
begin
    fValue := ConvertStringToUTF8(aValue);

    fValueSize := length(fValue);
    ContentType := ctText;
    ReadOnlyFlag := False;
end;


function TApeTagItem.GetBinaryData(dest: TStream): boolean;
begin
    if ContentType <> ctBinary then
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
    ContentType := ctBinary;
    ReadOnlyFlag := False;
end;

function TApeTagItem.GetPicture(dest: TStream;
  var description: UnicodeString): boolean;
var i, c: Integer;
    tmp: Utf8String;
begin
    if ContentType <> ctBinary then
        result := False
    else
    begin
        // expected data format:
        // <description> (UTF8 encoded)
        // $00           (delimter)
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
            // invalid data format
            result := False;
    end;
end;

procedure TApeTagItem.SetPicture(source: TStream;
  description: UnicodeString);
var descUTF8: UTF8String;
begin
    if description = '' then
        description := 'cover art';
    descUTF8 := ConvertStringToUTF8(description);
    Setlength(fData, length(descUTF8) + 1 + source.Size);
    Move(descUTF8[1], fData[0], length(descUTF8));
    fData[length(descUTF8)] := 0;
    source.Position := 0;
    source.Read(fData[length(descUTF8)+1], source.Size);

    fValueSize := length(fData);
    ContentType := ctBinary;
    ReadOnlyFlag := False;
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
    if Not fCheckKey(tmpKey) then
    begin
        result := False;
        Exit;
    end;
    // key is valid
    fKey := tmpKey;

    aStream.Position := cPos + keyLength;

    if ContentType = ctBinary then
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

    if ContentType = ctBinary then
        aStream.Write(fData[0], fValueSize)
    else
        aStream.Write(fValue[1], fValueSize);

    result := True;
end;

end.
