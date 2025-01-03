{
    -----------------------------------
    Audio Werkzeuge Bibliothek
    -----------------------------------
    (c) 2012-2024, Daniel Gaussmann
              Website : www.gausi.de
              EMail   : mail@gausi.de
    -----------------------------------

    Unit Apev2Tags

    Manipulate Apev2Tags

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

{
  General remarks:

  APE-V2-Tags are usually stored at the end of the file.
  However, at the *very end* of the file, there could be also an ID3v1-Tag, and this is quite common, as it seems.

  Detection of APE/ID3 is very similar, and it can't be seperated that easily. For example, the "TAG" identifier
  of the ID3v1Tag could be (but it's not very likely) part of the "APETAGEX" identifier of the Apev2Tag-Header.

  Therefore, checking for APE-Tags requires also checking for ID3v1-Tags.

  For file types within this library, that supports APE and ID3v1, it is recommended to check for the APE-Tag first.
  The TApeTag class defined here has properties, so that the calling TXXXFile class has access to the existing
  ID3v1Tag-structure as well, so it can be copied directly into a proper ID3v1Tag-Object for further processing.

  But this class here doesn't provide any methods to write a modified ID3v1Tag into the file. Writing an APE-Tag
  with the methods defined here will write ONLY the APE-Tag, and will leave the rest of the file untouched -
  including a possible existing ID3v1-Tag. If the ID3Tag should be altered as well, you have to use ID3v1Tag.WriteToFile()
  as well. (This behaviour of TBaseApeFile is consistent with the one in TMp3File.)

}

unit Apev2Tags;

interface

uses Windows, Messages, SysUtils, StrUtils, Variants, ContNrs, Classes, Types,
     AudioFiles.Base, AudioFiles.BaseTags, AudioFiles.Declarations,
     Id3Basics, ApeTagItem;

type

    TApeTag = class
        private
            fApev2TagFooter: TApeHeader;
            fApev2TagHeader: TApeHeader;
            fID3v1tag: TID3v1Structure;

            fExists: Boolean;

            fID3v1Present: Boolean;
            fID3v1TagSize: Cardinal;

            fOffset: DWord;   // Position (from End of File) where the Apev2Tag begins
            fItemList: TObjectList;

            function fIsValidHeader(aApeHeader: TApeHeader): Boolean;
            function fTagContainsHeader: Boolean;

            function fGetTagItemByKey(aKey: String): TApeTagItem;

            function fGetComment          : UnicodeString;
            function fGetSubTitle         : UnicodeString;
            function fGetDebutAlbum       : UnicodeString;
            function fGetPublisher        : UnicodeString;
            function fGetConductor        : UnicodeString;
            function fGetComposer         : UnicodeString;
            function fGetCopyright        : UnicodeString;
            function fGetPublicationright : UnicodeString;
            function fGetFile             : UnicodeString;
            function fGetEAN              : UnicodeString;
            function fGetISBN             : UnicodeString;
            function fGetCatalog          : UnicodeString;
            function fGetLC               : UnicodeString;
            function fGetRecordDate       : UnicodeString;
            function fGetRecordLocation   : UnicodeString;
            function fGetMedia            : UnicodeString;
            function fGetIndex            : UnicodeString;
            function fGetRelated          : UnicodeString;
            function fGetISRC             : UnicodeString;
            function fGetAbstract         : UnicodeString;
            function fGetLanguage         : UnicodeString;
            function fGetBibliography     : UnicodeString;
            function fGetIntroplay        : UnicodeString;
            function fGetAlbumArtist      : UnicodeString;
            function fGetLyrics           : UnicodeString;

            procedure fSetComment         (aValue: UnicodeString);
            procedure fSetSubTitle        (aValue: UnicodeString);
            procedure fSetDebutAlbum      (aValue: UnicodeString);
            procedure fSetPublisher       (aValue: UnicodeString);
            procedure fSetConductor       (aValue: UnicodeString);
            procedure fSetComposer        (aValue: UnicodeString);
            procedure fSetCopyright       (aValue: UnicodeString);
            procedure fSetPublicationright(aValue: UnicodeString);
            procedure fSetFile            (aValue: UnicodeString);
            procedure fSetEAN             (aValue: UnicodeString);
            procedure fSetISBN            (aValue: UnicodeString);
            procedure fSetCatalog         (aValue: UnicodeString);
            procedure fSetLC              (aValue: UnicodeString);
            procedure fSetRecordDate      (aValue: UnicodeString);
            procedure fSetRecordLocation  (aValue: UnicodeString);
            procedure fSetMedia           (aValue: UnicodeString);
            procedure fSetIndex           (aValue: UnicodeString);
            procedure fSetRelated         (aValue: UnicodeString);
            procedure fSetISRC            (aValue: UnicodeString);
            procedure fSetAbstract        (aValue: UnicodeString);
            procedure fSetLanguage        (aValue: UnicodeString);
            procedure fSetBibliography    (aValue: UnicodeString);
            procedure fSetIntroplay       (aValue: UnicodeString);
            procedure fSetAlbumArtist     (aValue: UnicodeString);
            procedure fSetLyrics          (aValue: UnicodeString);

            function fComputeNewTagSize: Integer;  // Used to get the new ApeTag size before writing (EXcluding the Header)
            function fGetTagSize: Cardinal;        // The Size of the ApeTag in the File. Including Header AND Footer.
            function fGetVersion: Cardinal;
            function fContainsData: Boolean;

            procedure fPrepareFooterAndHeader;

      protected

            procedure fSetTitle  (aValue: UnicodeString);
            procedure fSetArtist (aValue: UnicodeString);
            procedure fSetAlbum  (aValue: UnicodeString);
            procedure fSetYear   (aValue: UnicodeString);
            procedure fSetTrack  (aValue: UnicodeString);
            procedure fSetGenre  (aValue: UnicodeString);

            function fGetTitle   : UnicodeString;
            function fGetArtist  : UnicodeString;
            function fGetAlbum   : UnicodeString;
            function fGetYear    : UnicodeString;
            function fGetTrack   : UnicodeString;
            function fGetGenre   : UnicodeString;

            function ReadTagFromStream(aStream: TStream; ReadItems: Boolean): TAudioError;

        public
            property ContainsHeader: Boolean read fTagContainsHeader;
            property ID3v1Present: Boolean read fID3v1Present;
            property ID3v1TagRaw: TID3v1Structure read fID3v1tag;

            property Exists: Boolean read fExists;
            property Version: Cardinal read fGetVersion;
            property ContainsData: Boolean read fContainsData;

            // Size of the Tag in Bytes
            property Apev2TagSize   : Cardinal read fGetTagSize;
            property ID3v1TagSize   : Cardinal read fID3v1TagSize;

            // These properties are defined in the Apev2Tag-Standard
            property Title            : UnicodeString read fGetTitle             write fSetTitle            ;
            property Artist           : UnicodeString read fGetArtist            write fSetArtist           ;
            property Album            : UnicodeString read fGetAlbum             write fSetAlbum            ;
            property Year             : UnicodeString read fGetYear              write fSetYear             ;
            property Track            : UnicodeString read fGetTrack             write fSetTrack            ;
            property Genre            : UnicodeString read fGetGenre             write fSetGenre            ;
            property Comment          : UnicodeString read fGetComment           write fSetComment          ;
            property SubTitle         : UnicodeString read fGetSubTitle          write fSetSubTitle         ;
            property DebutAlbum       : UnicodeString read fGetDebutAlbum        write fSetDebutAlbum       ;
            property Publisher        : UnicodeString read fGetPublisher         write fSetPublisher        ;
            property Conductor        : UnicodeString read fGetConductor         write fSetConductor        ;
            property Composer         : UnicodeString read fGetComposer          write fSetComposer         ;
            property Copyright        : UnicodeString read fGetCopyright         write fSetCopyright        ;
            property PublicationRight : UnicodeString read fGetPublicationright  write fSetPublicationright ;
            property FileLocation     : UnicodeString read fGetFile              write fSetFile             ;
            property EAN              : UnicodeString read fGetEAN               write fSetEAN              ;
            property ISBN             : UnicodeString read fGetISBN              write fSetISBN             ;
            property Catalog          : UnicodeString read fGetCatalog           write fSetCatalog          ;
            property LabelCode        : UnicodeString read fGetLC                write fSetLC               ;
            property RecordDate       : UnicodeString read fGetRecordDate        write fSetRecordDate       ;
            property RecordLocation   : UnicodeString read fGetRecordLocation    write fSetRecordLocation   ;
            property Media            : UnicodeString read fGetMedia             write fSetMedia            ;
            property Indexes          : UnicodeString read fGetIndex             write fSetIndex            ;
            property Related          : UnicodeString read fGetRelated           write fSetRelated          ;
            property ISRC             : UnicodeString read fGetISRC              write fSetISRC             ;
            property AbstractOfContent: UnicodeString read fGetAbstract          write fSetAbstract         ;
            property Language         : UnicodeString read fGetLanguage          write fSetLanguage         ;
            property Bibliography     : UnicodeString read fGetBibliography      write fSetBibliography     ;
            property Introplay        : UnicodeString read fGetIntroplay         write fSetIntroplay        ;
            // Additional properties
            property AlbumArtist      : UnicodeString read fGetAlbumArtist       write fSetAlbumArtist      ;
            property Lyrics           : UnicodeString read fGetLyrics            write fSetLyrics           ;

            constructor Create;
            destructor Destroy; override;

            // Clear all Items and set Footer/Header to default values
            procedure Clear;
            procedure ClearOnlyApe;

            // Get/Set arbitrary Keys
            // Use this with caution - you probably don't need this
            function GetValueByKey(aKey: AnsiString): UnicodeString;
            function SetValueByKey(aKey: AnsiString; aValue: UnicodeString): Boolean;

            // Set/Get Binary Data
            // You REALLY SHOULD NOT use this. ;-)
            function GetBinaryDataByKey(aKey: AnsiString; dest: TStream): Boolean;
            procedure SetBinaryByKey(aKey: AnsiString; source: TStream);

            procedure GetTagList(Dest: TTagItemList; ContentTypes: TTagContentTypes = cDefaultTagContentTypes);
            procedure DeleteTagItem(aTagItem: TTagItem);
            function GetUnusedTextTags: TTagItemInfoDynArray;
            function AddTextTagItem(aKey, aValue: UnicodeString): TTagItem;

            // Get/Set Cover Art
            // return value of the getter:
            //     The cover art in Apev2tag is NOT standardized
            //     Here a special format is expected, which seems to be used by other taggers:
            //     <Key> $00 <UTF8-Encoded description> $00 <actual picture data>
            //     The getter will return TRUE if a matching TagItem in this Format was found, FALSE otherwise
            function GetPicture(aType: TPictureType; dest: TStream; var description: UnicodeString): boolean; overload;
            function GetPicture(aKey: AnsiString; dest: TStream; var description: UnicodeString): boolean; overload;
            function SetPicture(aType: TPictureType;description: String; source: TStream): boolean; overload;
            function SetPicture(aKey: AnsiString; description: UnicodeString; source: TStream): boolean; overload;

            function ReadFromStream(aStream: TStream): TAudioError;

            function ReadFromFile(aFilename: UnicodeString): TAudioError;
            function WriteToFile(aFilename: UnicodeString): TAudioError;
            function RemoveFromFile(aFilename: UnicodeString): TAudioError;
    end;

implementation

{ TApeFile }

constructor TApeTag.Create;
begin
    fItemList := TObjectList.Create;
end;

destructor TApeTag.Destroy;
begin
    fItemList.Free;
    inherited;
end;


{
    Clear
    Set default values
}
procedure TApeTag.Clear;
begin
    fItemList.Clear;
    fOffset := 0;
    fPrepareFooterAndHeader;
    fID3v1Present := False;
    fID3v1TagSize := 0;
    FillChar(fID3v1Tag, 128, 0);
    fExists := False;
end;

procedure TApeTag.ClearOnlyApe;
begin
    fItemList.Clear;
    fOffset := 0;
    fPrepareFooterAndHeader;
    fExists := False;
end;


function TApeTag.fIsValidHeader(aApeHeader: TApeHeader): Boolean;
begin
    result := aApeHeader.Preamble = APE_PREAMBLE; //AnsiString('APETAGEX');
end;


function TApeTag.fTagContainsHeader: Boolean;
begin
    result := ((fApev2TagFooter.Flags shr 31) and 1) = 1;
end;

function TApeTag.fComputeNewTagSize: Integer;
var s, i: Integer;
begin
    s := 0;
    for i := 0 to fItemList.Count - 1 do
        s := s + TApeTagItem(fItemList[i]).CompleteSize;

    result := s + 32;
end;

function TApeTag.fGetTagSize: Cardinal;
begin
    if fIsValidHeader(fApev2TagFooter) then
    begin
        result := fApev2TagFooter.Size;
        if ContainsHeader then
            result := result + 32
    end
    else
        result := 0;
end;

function TApeTag.fGetVersion: Cardinal;
begin
    if fIsValidHeader(fApev2TagFooter) then
      result := fApev2TagFooter.Version Div 1000
    else
      result := 0;
end;

function TApeTag.fContainsData: Boolean;
begin
    result := fItemList.Count > 0;
end;

{
    fSetValueByKey
    Set the matching TagItem in the List to the given Value
      - If aValue = '', the Item will be deleted.
      - If no matching Item can be found, a new one is created
    Used for property setters for Artist, Album, etc.
}
function TApeTag.SetValueByKey(aKey: AnsiString; aValue: UnicodeString): Boolean;
var i: Integer;
    aTagItem: TApeTagItem;
    success: Boolean;
begin
    success := False;
    result := False;
    if not ValidApeKey(aKey) then
      exit;

    for i := 0 to fItemList.Count - 1 do
    begin
        aTagItem := TApeTagItem(fItemList[i]);
        if AnsiSameText(String(aKey), String(aTagItem.Key)) then
        begin
            if aValue = '' then
                fItemList.Delete(i)
            else
                //aTagItem.Value := aValue;
                result := aTagItem.SetText(aValue);
            success := True;
            break;
        end;
    end;

    if (not success) and (aValue <> '')  then
    begin
        // create a new item
        aTagItem := TApeTagItem.Create(aKey);
        result := aTagItem.SetText(aValue);
        //aTagItem.Value := aValue;
        fItemList.Add(aTagItem);
    end;
end;

procedure TApeTag.fSetAbstract(aValue: UnicodeString);
begin
    SetValueByKey(APE_Abstract, aValue);
end;
procedure TApeTag.fSetAlbum(aValue: UnicodeString);
begin
    SetValueByKey(APE_Album, aValue);
end;
procedure TApeTag.fSetAlbumArtist(aValue: UnicodeString);
begin
  SetValueByKey(APE_albumartist, aValue);
end;

procedure TApeTag.fSetArtist(aValue: UnicodeString);
begin
    SetValueByKey(APE_Artist, aValue);
end;
procedure TApeTag.fSetBibliography(aValue: UnicodeString);
begin
    SetValueByKey(APE_Bibliography, aValue);
end;
procedure TApeTag.fSetCatalog(aValue: UnicodeString);
begin
    SetValueByKey(APE_Catalog, aValue);
end;
procedure TApeTag.fSetComment(aValue: UnicodeString);
begin
    SetValueByKey(APE_Comment, aValue);
end;
procedure TApeTag.fSetComposer(aValue: UnicodeString);
begin
    SetValueByKey(APE_Composer, aValue);
end;
procedure TApeTag.fSetConductor(aValue: UnicodeString);
begin
    SetValueByKey(APE_Conductor, aValue);
end;
procedure TApeTag.fSetCopyright(aValue: UnicodeString);
begin
    SetValueByKey(APE_Copyright, aValue);
end;
procedure TApeTag.fSetDebutAlbum(aValue: UnicodeString);
begin
    SetValueByKey(APE_DebutAlbum, aValue);
end;
procedure TApeTag.fSetEAN(aValue: UnicodeString);
begin
    SetValueByKey(APE_EANUBC, aValue);
end;
procedure TApeTag.fSetFile(aValue: UnicodeString);
begin
    SetValueByKey(APE_File, aValue);
end;
procedure TApeTag.fSetGenre(aValue: UnicodeString);
begin
    SetValueByKey(APE_Genre, aValue);
end;
procedure TApeTag.fSetIndex(aValue: UnicodeString);
begin
    SetValueByKey(APE_Index, aValue);
end;
procedure TApeTag.fSetIntroplay(aValue: UnicodeString);
begin
    SetValueByKey(APE_Introplay, aValue);
end;
procedure TApeTag.fSetISBN(aValue: UnicodeString);
begin
   SetValueByKey(APE_ISBN, aValue);
end;
procedure TApeTag.fSetISRC(aValue: UnicodeString);
begin
    SetValueByKey(APE_ISRC, aValue);
end;
procedure TApeTag.fSetLanguage(aValue: UnicodeString);
begin
    SetValueByKey(APE_Language, aValue);
end;
procedure TApeTag.fSetLC(aValue: UnicodeString);
begin
    SetValueByKey(APE_LC, aValue);
end;
procedure TApeTag.fSetMedia(aValue: UnicodeString);
begin
    SetValueByKey(APE_Media, aValue);
end;
procedure TApeTag.fSetPublicationright(aValue: UnicodeString);
begin
    SetValueByKey(APE_PublicationRight, aValue);
end;
procedure TApeTag.fSetPublisher(aValue: UnicodeString);
begin
    SetValueByKey(APE_Publisher, aValue);
end;
procedure TApeTag.fSetRecordDate(aValue: UnicodeString);
begin
    SetValueByKey(APE_RecordDate, aValue);
end;
procedure TApeTag.fSetRecordLocation(aValue: UnicodeString);
begin
    SetValueByKey(APE_RecordLocation, aValue);
end;
procedure TApeTag.fSetRelated(aValue: UnicodeString);
begin
    SetValueByKey(APE_Related, aValue);
end;
procedure TApeTag.fSetSubTitle(aValue: UnicodeString);
begin
    SetValueByKey(APE_Subtitle, aValue);
end;
procedure TApeTag.fSetTitle(aValue: UnicodeString);
begin
    SetValueByKey(APE_Title, aValue);
end;
procedure TApeTag.fSetTrack(aValue: UnicodeString);
begin
    SetValueByKey(APE_Track, aValue);
end;
procedure TApeTag.fSetYear(aValue: UnicodeString);
begin
    SetValueByKey(APE_Year, aValue);
end;

procedure TApeTag.fSetLyrics(aValue: UnicodeString);
var
  i: Integer;
  LyricItem: TApeTagItem;
begin
  LyricItem := Nil;
  i := 0;
  while (LyricItem = Nil) and (i <= High(AWB_SupportedLyricsKeys)) do begin
    LyricItem := fGetTagItemByKey(AWB_SupportedLyricsKeys[i]);
    inc(i);
  end;

  if trim(aValue) = '' then begin
    if assigned(LyricItem) then
      DeleteTagItem(LyricItem);
  end else
  begin
    // if no lyric Vector was found: Create a new one and add it to the VectorList
    if not assigned(LyricItem) then begin
      LyricItem := TApeTagItem.Create(AnsiString(AWB_DefaultLyricsKey));
      fItemList.Add(LyricItem);
    end;
    LyricItem.SetText(aValue);
  end;
end;

{
    fGetValueByKey
    Get the matching TagItem in the List and returns its value
    Used for property getters for Artist, Album, etc.
}
function TApeTag.GetValueByKey(aKey: AnsiString): UnicodeString;
var i: Integer;
    aTagItem: TApeTagItem;
begin
    result := '';
    for i := 0 to fItemList.Count - 1 do
    begin
        aTagItem := TApeTagItem(fItemList[i]);
        if AnsiSameText(String(aKey), String(aTagItem.Key)) then begin
            result := aTagItem.GetText;
            break;
        end;
    end;
end;

function TApeTag.fGetTagItemByKey(aKey: String): TApeTagItem;
var
  i: Integer;
begin
  result := Nil;
  for i := 0 to fItemList.Count - 1 do begin
    if AnsiSameText(String(aKey), String(TApeTagItem(fItemList[i]).Key)) then begin
      result := TApeTagItem(fItemList[i]);
      break;
    end;
  end;
end;

function TApeTag.fGetAbstract: UnicodeString;
begin
    result := GetValueByKey(APE_Abstract);
end;
function TApeTag.fGetAlbum: UnicodeString;
begin
    result := GetValueByKey(APE_Album);
end;
function TApeTag.fGetAlbumArtist: UnicodeString;
begin
  result := GetValueByKey(APE_AlbumArtist);
end;
function TApeTag.fGetArtist: UnicodeString;
begin
    result := GetValueByKey(APE_Artist);
end;
function TApeTag.fGetBibliography: UnicodeString;
begin
    result := GetValueByKey(APE_Bibliography);
end;
function TApeTag.fGetCatalog: UnicodeString;
begin
    result := GetValueByKey(APE_Catalog);
end;
function TApeTag.fGetComment: UnicodeString;
begin
    result := GetValueByKey(APE_Comment);
end;
function TApeTag.fGetComposer: UnicodeString;
begin
    result := GetValueByKey(APE_Composer);
end;
function TApeTag.fGetConductor: UnicodeString;
begin
    result := GetValueByKey(APE_Conductor);
end;
function TApeTag.fGetCopyright: UnicodeString;
begin
    result := GetValueByKey(APE_Copyright);
end;
function TApeTag.fGetDebutAlbum: UnicodeString;
begin
    result := GetValueByKey(APE_DebutAlbum);
end;
function TApeTag.fGetEAN: UnicodeString;
begin
    result := GetValueByKey(APE_EANUBC);
end;
function TApeTag.fGetFile: UnicodeString;
begin
    result := GetValueByKey(APE_File);
end;
function TApeTag.fGetGenre: UnicodeString;
begin
    result := GetValueByKey(APE_Genre);
end;
function TApeTag.fGetIndex: UnicodeString;
begin
    result := GetValueByKey(APE_Index);
end;
function TApeTag.fGetIntroplay: UnicodeString;
begin
    result := GetValueByKey(APE_Introplay);
end;
function TApeTag.fGetISBN: UnicodeString;
begin
    result := GetValueByKey(APE_ISBN);
end;
function TApeTag.fGetISRC: UnicodeString;
begin
    result := GetValueByKey(APE_ISRC);
end;
function TApeTag.fGetLanguage: UnicodeString;
begin
    result := GetValueByKey(APE_Language);
end;
function TApeTag.fGetLC: UnicodeString;
begin
    result := GetValueByKey(APE_LC);
end;
function TApeTag.fGetMedia: UnicodeString;
begin
    result := GetValueByKey(APE_Media);
end;
function TApeTag.fGetPublicationright: UnicodeString;
begin
    result := GetValueByKey(APE_Publicationright);
end;
function TApeTag.fGetPublisher: UnicodeString;
begin
    result := GetValueByKey(APE_Publisher);
end;
function TApeTag.fGetRecordDate: UnicodeString;
begin
    result := GetValueByKey(APE_RecordDate);
end;
function TApeTag.fGetRecordLocation: UnicodeString;
begin
    result := GetValueByKey(APE_RecordLocation);
end;
function TApeTag.fGetRelated: UnicodeString;
begin
    result := GetValueByKey(APE_Related);
end;
function TApeTag.fGetSubTitle: UnicodeString;
begin
    result := GetValueByKey(APE_Subtitle);
end;
function TApeTag.fGetTitle: UnicodeString;
begin
    result := GetValueByKey(APE_Title);
end;
function TApeTag.fGetTrack: UnicodeString;
begin
    result := GetValueByKey(APE_Track);
end;
function TApeTag.fGetYear: UnicodeString;
begin
    result := GetValueByKey(APE_Year);
end;

function TApeTag.fGetLyrics: UnicodeString;
var
  i: Integer;
begin
  result := '';
  i := 0;
  while (result = '') and (i <= High(AWB_SupportedLyricsKeys)) do begin
    result := GetValueByKey(AnsiString(AWB_SupportedLyricsKeys[i]));
    inc(i);
  end;
end;


function TApeTag.GetBinaryDataByKey(aKey: AnsiString; dest: TStream): Boolean;
var i: Integer;
    aTagItem: TApeTagItem;
begin
    result := False;
    for i := 0 to fItemList.Count - 1 do
    begin
        aTagItem := TApeTagItem(fItemList[i]);
        if AnsiSameText(String(aKey), String(aTagItem.Key)) then
            result := aTagItem.GetBinaryData(dest);
    end;
end;
procedure TApeTag.SetBinaryByKey(aKey: AnsiString; source: TStream);
var i: Integer;
    aTagItem: TApeTagItem;
    success: Boolean;
begin
    success := False;
    if not ValidApeKey(aKey) then
      exit;

    for i := 0 to fItemList.Count - 1 do
    begin
        aTagItem := TApeTagItem(fItemList[i]);
        if AnsiSameText(String(aKey), String(aTagItem.Key)) then
        begin
            if assigned(source) and (source.Size > 0) then
                aTagItem.SetBinaryData(source)
            else
                fItemList.Delete(i);
            success := True;
            break;
        end;
    end;
    if not success then
    begin
        if assigned(source) and (Source.Size > 0) then
        begin
            aTagItem := TApeTagItem.Create(aKey, ctApeBinary);
            aTagItem.SetBinaryData(source);
            fItemList.Add(aTagItem);
        end;
    end;
end;

procedure TApeTag.GetTagList(Dest: TTagItemList; ContentTypes: TTagContentTypes = cDefaultTagContentTypes);
var
  i: Integer;
begin
  for i := 0 to fItemList.Count - 1 do
    if TApeTagItem(fItemList[i]).MatchContentType(ContentTypes) then
      Dest.Add(TApeTagItem(fItemList[i]));
end;

procedure TApeTag.DeleteTagItem(aTagItem: TTagItem);
begin
  fItemList.Extract(aTagItem);
  FreeAndNil(aTagItem);
end;

function TApeTag.GetUnusedTextTags: TTagItemInfoDynArray;
var
  iKey, iRes: Integer;
  resultArray: TTagItemInfoDynArray;
begin
  SetLength(resultArray, Length(cTextApeKeys));  // max. possible length
  iRes := 0;

  for iKey := Low(cTextApeKeys) to High(cTextApeKeys) do begin
    if not assigned(fGetTagItemByKey(cTextApeKeys[iKey])) then begin
      resultArray[iRes].Key := cTextApeKeys[iKey];
      resultArray[iRes].Description := '';
      resultArray[iRes].TagType := ttApev2;
      resultArray[iRes].TagContentType := tctText;
      inc(iRes);
    end;
  end;

  SetLength(resultArray, iRes); // correct length
  result := resultArray;
end;

function TApeTag.AddTextTagItem(aKey, aValue: UnicodeString): TTagItem;
begin
  if SetValueByKey(AnsiString(aKey), aValue) then
    result := fGetTagItemByKey(aKey)
  else
    result := Nil;
end;

function TApeTag.GetPicture(aKey: AnsiString; dest: TStream; var description: UnicodeString): boolean;
var i: Integer;
    aTagItem: TApeTagItem;
    dummyMime: AnsiString;
    dummyType: TPictureType;

begin
    result := False;
    for i := 0 to fItemList.Count - 1 do
    begin
        aTagItem := TApeTagItem(fItemList[i]);
        if AnsiSameText(String(aKey), String(aTagItem.Key))
           or ((aKey = '') and AnsiStartsText('Cover Art', String(aTagItem.Key))) then
        begin
            result := aTagItem.GetPicture(dest, dummyMime, dummyType, description);
        end;
    end;
end;

function TApeTag.GetPicture(aType: TPictureType; dest: TStream;
  var description: UnicodeString): boolean;
begin
    result := GetPicture(cApePictureKeys[aType], dest, description);
end;

function TApeTag.SetPicture(aKey: AnsiString; description: UnicodeString; source: TStream): Boolean;
var i: Integer;
    aTagItem: TApeTagItem;
begin
    result := False;
    if not ValidApeKey(aKey) then
      exit;

    for i := 0 to fItemList.Count - 1 do
    begin
        aTagItem := TApeTagItem(fItemList[i]);
        if AnsiSameText(String(aKey), String(aTagItem.Key)) then
        begin
            if assigned(source) and (source.Size > 0) then
                result := aTagItem.SetPicture(source, '', ptOther, description) // Mime and PicType will be ignored
            else begin
                fItemList.Delete(i);
                result := True;
            end;
            break;
        end;
    end;
    if not result then
    begin
        if assigned(source) and (Source.Size > 0) then
        begin
            aTagItem := TApeTagItem.Create(aKey, ctApeBinary);
            result := aTagItem.SetPicture(source, '', ptOther, description); // Mime and PicType will be ignored
            fItemList.Add(aTagItem);
        end;
    end;
end;

function TApeTag.SetPicture(aType: TPictureType;description: String; source: TStream): Boolean;
begin
    result := SetPicture(cApePictureKeys[aType], description, source);
end;


{
    ReadTagFromStream
    Read the tag from a stream
    The parameter ReadItems is used for reading basic data (Footer, Header)
    just before writing the new Tag into the File
}
function TApeTag.ReadTagFromStream(aStream: TStream; ReadItems: Boolean): TAudioError;
var i: Integer;
    newItem: TApeTagItem;
    p: Pointer;
    hiddenApeHeader: TApeHeader;
    CombinedTagStructure: TCombinedFooterTag;
    MemStream: TMemoryStream;
    tmpValidApeFooter: Boolean;

begin
    result := FileErr_None;
    clear;
    tmpValidApeFooter := False;

    // Check for ID3/APE-Markers at the end of the file
    aStream.Seek(-160, soFromEnd);
    if (aStream.Read(CombinedTagStructure, 160) <> 160) then
        result := FileErr_StreamRead
    else
    begin
        if IsValidID3Tag(CombinedTagStructure.ID3Tag) then
        begin
            // we DO have a valid ID3v1Tag in the file
            fID3v1TagSize := 128;
            fID3v1Present := True;
            fOffset := 128;
            fID3v1tag := CombinedTagStructure.ID3Tag;

            tmpValidApeFooter := fIsValidHeader(CombinedTagStructure.ApeFooter);
            if tmpValidApeFooter then
                fApev2TagFooter := CombinedTagStructure.ApeFooter;  // we DO have a valid ApeFooter in the file
        end else
        begin
            // we DO NOT have a valid ID3v1Tag in the file, but
            // we may have a APE-Footer at the end of the file instead of the ID3v1Tag
            p := @CombinedTagStructure.ID3Tag.Year[4];
            hiddenApeHeader := PApeHeader(p)^ ;

            tmpValidApeFooter := fIsValidHeader(hiddenApeHeader);
            if tmpValidApeFooter then
                fApev2TagFooter := hiddenApeHeader;  // we DO have a valid ApeFooter at the very end of the file
        end;
    end;

    if not tmpValidApeFooter then
        exit;

    // Apev2tag is present, it's Footer is stored in fApev2TagFooter
    // (we have to set fOffset accordingly now)
    fExists := True;
    if ContainsHeader then  // i.e. the flag in the footer is set
    begin
        fOffset := fApev2TagFooter.Size + 32 + fID3v1TagSize;
        aStream.Seek(- fOffset, soEnd);
        aStream.Read(fApev2TagHeader, 32);
        if Not fIsValidHeader(fApev2TagHeader) then
        begin
            // The header is invalid, probably the flag in the footer is wrong
            // set last Header Bit in the Footer to 0
            fApev2TagFooter.Flags := fApev2TagFooter.Flags AND ((not 0) shr 1);
            fOffset := fApev2TagFooter.Size + fID3v1TagSize;
        end;
    end
    else
    begin
        fOffset := fApev2TagFooter.Size + fID3v1TagSize;
        aStream.Seek(-fOffset, soEnd);
    end;

    // ReadItems
    if ReadItems then
    begin
        MemStream := TMemoryStream.Create;
        try
            MemStream.CopyFrom(aStream, fApev2TagFooter.Size );
            MemStream.Position := 0;

            for i := 1 to fApev2TagFooter.ItemCount do
            begin
                newItem := TApeTagItem.Create('');
                if newItem.ReadFromStream(MemStream) then
                    fItemList.Add(newItem)
                else
                begin
                    // something was wrong with the TagItem (e.g. invalid key)
                    result := ApeErr_InvalidTag;
                    // discard all Data, but preserve possible ID3v1-Data
                    ClearOnlyApe;
                    break;
                end;
            end;
        finally
            MemStream.Free;
        end;
    end;
end;

function TApeTag.ReadFromStream(aStream: TStream): TAudioError;
begin
    result := ReadTagFromStream(aStream, True);
end;


function TApeTag.ReadFromFile(aFilename: UnicodeString): TAudioError;
var fs: TAudioFileStream;
begin
    Clear;
    if AudioFileExists(aFilename) then
    begin
        try
            fs := TAudioFileStream.Create(aFilename, fmOpenRead or fmShareDenyWrite);
            try
                result := ReadTagFromStream(fs, True);
            finally
                fs.Free;
            end;
        except
            result := FileErr_FileOpenR;
        end;
    end else
        result := FileErr_NoFile;
end;

procedure TApeTag.fPrepareFooterAndHeader;
var b: DWord;
begin
    b := 1;
    fApev2TagFooter.Preamble  := APE_PREAMBLE;
    fApev2TagFooter.Version   := 2000;
    fApev2TagFooter.Size      := fComputeNewTagSize;
    fApev2TagFooter.ItemCount := fItemList.Count;
    fApev2TagFooter.Flags     := b shl 31;  // Header is present
                                            // (we will write a header by default)
    fApev2TagHeader.Preamble  := APE_PREAMBLE;
    fApev2TagHeader.Version   := 2000;
    fApev2TagHeader.Size      := fApev2TagFooter.Size;
    fApev2TagHeader.ItemCount := fItemList.Count;
    fApev2TagHeader.Flags     := (b shl 31) or (b shl 29);
end;

function TApeTag.WriteToFile(aFilename: UnicodeString): TAudioError;
var fs: TAudioFileStream;
    oldTag: TApeTag;
    i: Integer;
begin
    result := FileErr_None;

    fPrepareFooterAndHeader;

    if fItemList.Count = 0 then
        RemoveFromFile(aFilename)
    else
    begin
        if AudioFileExists(aFilename) then
        begin
            try
                fs := TAudioFileStream.Create(aFilename, fmOpenReadWrite or fmShareDenyWrite);
                try
                    /// Check the file for an existing tag
                    oldTag := TApeTag.Create;
                    try
                        oldTag.ReadTagFromStream(fs, False); // items there are not needed
                        fs.Seek(- oldTag.fOffset, soEnd);
                        // Write new Data into the Stream
                        if ContainsHeader then
                            fs.Write(fApev2TagHeader, 32);
                        for i := 0 to fItemList.Count - 1 do
                            TApeTagItem(fItemList[i]).WriteToStream(fs);
                        fs.Write(fApev2TagFooter, 32);

                        // copy old ID3Tag back to the file
                        if oldTag.fID3v1Present then
                            fs.Write(oldTag.fID3v1tag, 128);

                        SetEndOfFile(fs.Handle);
                    finally
                        oldTag.Free;
                    end;
                finally
                    fs.Free;
                end;
            except
                result := FileErr_FileOpenRW;
            end;
        end else
            result := FileErr_NoFile;
    end;
end;

function TApeTag.RemoveFromFile(aFilename: UnicodeString): TAudioError;
var fs: TAudioFileStream;
    oldTag: TApeTag;
begin
    result := FileErr_None;

    if AudioFileExists(aFilename) then
    begin
        try
            fs := TAudioFileStream.Create(aFilename, fmOpenReadWrite or fmShareDenyWrite);
            try
                /// Check the file for an existing tag
                oldTag := TApeTag.Create;
                try
                    oldTag.ReadTagFromStream(fs, False); // items there are not needed
                    if oldTag.fOffset > 0 then
                    begin
                        fs.Seek(- oldTag.fOffset, soEnd);

                        // copy old ID3Tag back to the file
                        if oldTag.fID3v1Present then
                            fs.Write(oldTag.fID3v1tag, 128);

                        SetEndOfFile(fs.Handle);
                    end;
                finally
                    oldTag.Free;
                end;
            finally
                fs.Free;
            end;
        except
            result := FileErr_FileOpenRW;
        end;
    end else
        result := FileErr_NoFile;
end;

end.
