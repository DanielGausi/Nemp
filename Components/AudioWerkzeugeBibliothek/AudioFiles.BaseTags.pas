{
    -----------------------------------
    Audio Werkzeuge Bibliothek
    -----------------------------------
    (c) 2012-2024, Daniel Gaussmann
              Website : www.gausi.de
              EMail   : mail@gausi.de
    -----------------------------------

    Unit AudioFiles.Basetags

    TTagItem
      Base class for all TagItems like TID3v2Frame, TVorbisComment, ...


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

unit AudioFiles.BaseTags;

interface

{$I config.inc}

uses Classes, SysUtils, AudioFiles.Declarations
  {$IFDEF USE_GENERICS}, System.Generics.Collections {$ELSE}, System.Contnrs {$ENDIF}
  ;

var
  {
    For OggVorbis-Comments and Apev2-Tags, there is no standard key defined for "Lyrics"
    As far as I know , the following keys are commonly used
    - 'UNSYNCEDLYRICS' (e.g. Mp3Tag)
    - 'UNSYNCED LYRICS' (e.g. foobar2000 according to some sources)
    - 'LYRICS' (used on Android according to some sources)

    This Library will check for the Keys defined in "AWB_SupportedLyricsKeys".
    If a file contains no Lyrics yet, setting lyrics will use the key defined in "AWB_DefaultLyricsKey"
  }
  AWB_SupportedLyricsKeys: Array of String = ['UNSYNCEDLYRICS', 'UNSYNCED LYRICS', 'LYRICS'];
  AWB_DefaultLyricsKey: String = 'UNSYNCEDLYRICS';

const
  AWB_MimeJpeg = 'image/jpeg';
  AWB_MimePNG = 'image/png';
  AWB_MimeJpegFaulty = 'image/jpg'; // this one is actually invalid, but sometimes used

type
    {
      teTagType
      Used by TTagItem (see below) to identify the type of a TagItem without using class-information
    }
    teTagType = (ttID3v2, ttVorbis, ttFlacMetaBlock, ttApev2, ttM4AAtom, ttUndef);
    TTagTypes = set of teTagType;
const
    cTagTypes: Array[teTagType] of String = ('ID3v2', 'Vorbis', 'FlacMetaBlock', 'Apev2', 'M4AAtom', 'Undef');

type
    {
      teTagContentType,
      teTextMode
      Many TagItems in Audio-Metadata contain text information. In some cases, there are
      "texts" with additional meta data (e.g. the language of the text).
      Which kind of information is stored within a TagItem is not always simple to decide. In some
      cases it is defined by the documentation of the MetaTag-System, in some cases there are explicit
      flags for text/binary.
      The parameter "TextMode" in TTagItem.GetText and SetText controls how to deal with these cases.
      * tmStrict: return the text only for actual text fields. Empty string otherwise.
      * tmReasonable: return the text information also for text fields with additional metadata.
                      Only the actual text is returned, *not* the metadata like "language".
                      Examples for this are TID3v2tag.Comments, Lyrics or UserText
      * tmForced: always return the items data as "text", even binary data. Non-printable
                  characters will be replaced by ".".
    }
    teTextMode = (tmStrict, tmReasonable, tmForced);

    teTagContentType = (tctInvalid, tctUndef, tctAll, tctText, tctPicture, tctBinary,
      // ID3v2-specific
      tctComment,          // >= tmReasonable (TagItem.GetText will return a value, if TextMode is tmReasonable or tmForced)
      tctLyrics,           // >= tmReasonable
      tctURL,              // >= tmReasonable
      tctUserText,         // >= tmReasonable
      tctUserURL,          // >= tmReasonable
      tctPopularimeter,
      tctPrivate,
      tctUnknown,
      // Apev2-specific
      tctExternal,         // >= tmStrict (this is considered as text by this library)
      tctReserved,
      // m4a specific
      tctTrackOrDiskNumber, // >= tmReasonable
      tctGenre,             // >= tmReasonable
      tctSpecialText,       // >= tmReasonable
      tctSpecial
    );
    TTagContentTypes = set of teTagContentType;

const
    {
      cDefaultTagContentTypes:
      The default set of TagItems that will be returned by AudioFile.GetTagList to get a list of all TagItems
      in the file.
    }
    cDefaultTagContentTypes = [tctText, tctComment, tctLyrics, tctURL, tctUserText, tctUserURL, tctExternal,
        tctTrackOrDiskNumber, tctGenre, tctSpecialText];

type
    {
      TTagItem
      Base class for all TagItems.
      In abstract terms, every TagItem consists of a key-value pair. Sometimes the key speaks
      for itself, sometimes it just a short combination of numbres and letters. In that case,
      the metatag-definition often provides a human readable "description" about the information
      stored in this TagItem.
      To make it easier to use, there are also abstract methods for reading text and image data.
      However, these only make sense if the TagItem also contains corresponding data.
      The concrete implementations in derived classes will check the TagContentType and return
      “False” if the TagItem does not contain any text or image.
    }
    TTagItem = class
      private

      protected
        fTagType: teTagType;

        constructor Create(aTagType: teTagType);

        function GetKey: UnicodeString; virtual; abstract;
        function GetTagContentType: teTagContentType; virtual; abstract;
        function GetDescription: UnicodeString; virtual;
        function GetDataSize: Integer; virtual; abstract;

      public
        property TagType: teTagType read fTagType;  // ID3v2, VorbisComment, ...
        property Key: UnicodeString read GetKey;    // TALB, ARTIST, ...
        property Description: UnicodeString read GetDescription;
        property TagContentType: teTagContentType read GetTagContentType;
        property DataSize: Integer read GetDataSize;

        function MatchContentType(ContentTypes: TTagContentTypes): Boolean; virtual;
        function GetText(TextMode: teTextMode = tmReasonable): UnicodeString; virtual; abstract;
        function SetText(aValue: UnicodeString; TextMode: teTextMode = tmReasonable): Boolean; virtual; abstract;

        function GetPicture(Dest: TStream; out Mime: AnsiString; out PicType: TPictureType; out Description: UnicodeString): Boolean; virtual; abstract;
        function SetPicture(Source: TStream; Mime: AnsiString; PicType: TPictureType; Description: UnicodeString): Boolean; virtual; abstract;
    end;

    {$IFDEF USE_GENERICS}
      TTagItemList = TList<TTagItem>;
    {$ELSE}
      TTagItemList = TList;
    {$ENDIF}

    TTagItemClass = class of TTagItem;

    {
      TTagItemInfo
      Used for possible (but not yet existing) TagItems. Every AudioFile class may return
      an array of TTagItemInfo with a list of possible TTagItems the end user may want to add
      to the audiofile.
      You as a developer are free to present a different list of TTagItems to the end user
      (or, in some cases allow even arbitrary keys). The provided list will return a list of
      TagItems that are "recommended" or "well defined" or whatever by the documentation
      of the specific meta data format or some other reliable sources on "the internet".
    }
    TTagItemInfo = record
      Key: String;
      Description: String;
      TagType: teTagType;
      TagContentType: teTagContentType;  // (?)
    end;

    TTagItemInfoDynArray = Array of TTagItemInfo;

    function ByteArrayToString(const A: array of Byte): string;


implementation

function ByteArrayToString(const A: array of Byte): string;
var
  i: Integer;
begin
  SetLength(Result, Length(A));
  for i := Low(A) to High(A) do begin
    if (A[i] < 32) or ((A[i] >= 127) and (A[i] <= 159)) then
      Result[i + 1] := '.'
    else
      Result[i + 1] := Chr(A[i]);
  end;
end;


{ TTagItem }

constructor TTagItem.Create(aTagType: teTagType);
begin
  inherited create;
  fTagType := aTagType;
end;

function TTagItem.GetDescription: UnicodeString;
begin
  result := Key;
end;


function TTagItem.MatchContentType(ContentTypes: TTagContentTypes): Boolean;
begin
  result := (TagContentType in ContentTypes) or
   ((tctAll in ContentTypes) and not (TagContentType in [tctInvalid, tctUndef]))
end;

end.
