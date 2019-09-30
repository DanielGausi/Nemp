{
    -----------------------------------
    Audio Werkzeuge Bibliothek
    -----------------------------------
    (c) 2010-2012, Daniel Gaussmann
                   Website : www.gausi.de
                   EMail   : mail@gausi.de
    -----------------------------------

    Unit ID3Basics

    Helper methods to detect ID3v2-Tag (but nothing else)

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

unit Id3Basics;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes;

type

  TInt28 = array[0..3] of Byte;   // Sync-Safe Integer

  // Header-Structure of ID3v2-Tags
  // same on all subversions
  TID3v2Header = record
    ID: array[1..3] of AnsiChar;
    Version: Byte;
    Revision: Byte;
    Flags: Byte;
    TagSize: TInt28;
  end;

  function GetID3Size(Source: TStream): Integer;

implementation

//--------------------------------------------------------------------
// Convert a 28bit-integer to a 32bit-integer
//--------------------------------------------------------------------
function Int28ToInt32(Value: TInt28): LongWord;
begin
  // Take the rightmost byte and let it there,
  // take the second rightmost byte and move it 7bit to left
  //                                    (in an 32bit-variable)
  // a.s.o.
  result := (Value[3]) shl  0 or
            (Value[2]) shl  7 or
            (Value[1]) shl 14 or
            (Value[0]) shl 21;
end;


function GetID3Size(Source: TStream): Integer;
var rawHeader: TID3v2Header;
    FFlgFooterPresent: Boolean;
begin
    result := 0;
    Source.Seek(0, soFromBeginning);
    Source.ReadBuffer(RawHeader, 10);
    if RawHeader.ID = 'ID3' then
    begin
        if RawHeader.Version in [2,3,4] then
        begin
            result := Int28ToInt32(RawHeader.TagSize) + 10;
            if RawHeader.Version = 4 then
            begin
                FFlgFooterPresent := (RawHeader.Flags and 16) = 16;
                if FFlgFooterPresent then
                    result := result + 10;
            end;
        end;
    end;
end;

end.
