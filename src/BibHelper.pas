{

    Unit BibHelper

    Some helpers for Medialibrary


    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2005-2010, Daniel Gaussmann
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

unit BibHelper;

interface

uses Windows, Classes, SysUtils, ContNrs, Math, Nemp_ConstantsAndTypes,
    NempAudioFiles;


Const SO_Pfad = 0;
      SO_ArtistAlbum = 1;
      SO_AlbumArtist = 2;
      SO_Cover = 3;

 type
    TJustaString = class
    public
      DataString: UnicodeString;
      AnzeigeString: UnicodeString;

      constructor create(aDataString: UnicodeString; aAnzeigeString: UnicodeString = '');
      destructor Destroy; override;
    end;


    TPlaylistFillOptions = record
      // SkipGenreCheck: boolean;
      // Sortierte Version von "Genres" aus mp3fileUtils.
      // Wird von der Checklistbox übernommen
      // GenreStrings: TStrings;
      // GenreChecked: Array of boolean;
      SkipTagCheck: boolean;
      WantedTags: TObjectList;
      MinTagMatchCount: Integer;   // <= WantedTags.Count
      SkipYearCheck: Boolean;
      MinYear: Word;
      MaxYear: Word;
      RatingMode: Integer;
      Rating: Byte;
      // duration settings
      UseMinLength: Boolean;
      UseMaxLength: Boolean;
      MinLength: Integer;
      MaxLength: Integer;
      // general settings
      MaxCount: Integer;
      WholeBib: Boolean;
    end;

  function CoverSort_Artist(item1,item2:pointer):integer;
  function CoverSort_Album(item1,item2:pointer):integer;
  function CoverSort_Genre(item1,item2:pointer):integer;
  function CoverSort_GenreYear(item1,item2:pointer):integer;
  function CoverSort_Jahr(item1,item2:pointer):integer;
  function CoverSort_FileAgeAlbum(item1,item2:pointer):integer;
  function CoverSort_FileAgeArtist(item1,item2:pointer):integer;
  // Note: These two coversort-Methods are almost the same, as
  //       in one Directory there is (almost everytime) only one
  //       "cover" (except covers are set by the ID3.tag)
  //       Used for the BrowseBy-Menu in MainForm
  function CoverSort_DirectoryArtist(item1,item2:pointer):integer;
  function CoverSort_DirectoryAlbum(item1,item2:pointer):integer;

  // Same as above, but missing cover will be collected at the beginning
  function CoverSort_ArtistMissingFirst(item1,item2:pointer):integer;
  function CoverSort_AlbumMissingFirst(item1,item2:pointer):integer;
  function CoverSort_GenreMissingFirst(item1,item2:pointer):integer;
  function CoverSort_GenreYearMissingFirst(item1,item2:pointer):integer;
  function CoverSort_JahrMissingFirst(item1,item2:pointer):integer;
  function CoverSort_FileAgeAlbumMissingFirst(item1,item2:pointer):integer;
  function CoverSort_FileAgeArtistMissingFirst(item1,item2:pointer):integer;
  function CoverSort_DirectoryArtistMissingFirst(item1,item2:pointer):integer;
  function CoverSort_DirectoryAlbumMissingFirst(item1,item2:pointer):integer;

    // Same as above, but missing cover will be collected at the end
  function CoverSort_ArtistMissingLast(item1,item2:pointer):integer;
  function CoverSort_AlbumMissingLast(item1,item2:pointer):integer;
  function CoverSort_GenreMissingLast(item1,item2:pointer):integer;
  function CoverSort_GenreYearMissingLast(item1,item2:pointer):integer;
  function CoverSort_JahrMissingLast(item1,item2:pointer):integer;
  function CoverSort_FileAgeAlbumMissingLast(item1,item2:pointer):integer;
  function CoverSort_FileAgeArtistMissingLast(item1,item2:pointer):integer;
  function CoverSort_DirectoryArtistMissingLast(item1,item2:pointer):integer;
  function CoverSort_DirectoryAlbumMissingLast(item1,item2:pointer):integer;



  function PlaylistSort_Pfad(item1,item2:pointer):integer;
  function PlaylistSort_Name(item1,item2:pointer):integer;

  function BinaerPlaylistSuche(Liste: TObjectlist; filename: UnicodeString; l,r:integer):integer;


  function AkleinerB(A,B: TAudioFile; SortOrder: Integer; SortArray: TNempSortArray): Boolean;
        //Fügt zwei gleichmäßig sortierte Listen zu einer zusammen
        procedure Merge(SourceA, SourceB, Target: TObjectlist; SortOrder: Integer; SortArray: TNempSortArray);
        // Dasselbe, nur für PlaylistFiles. Sortorder ist da immer "Pfad"
        procedure MergePlaylists(SourceA, SourceB, Target: TObjectlist);

        // Baut eine neue Liste auf, die die Elemente enthält, die NICHT in Deletelist auftreten
        Procedure AntiMerge(Source, DeleteList, Target: TObjectlist);
        Procedure AntiMergePlaylists(Source, DeleteList, Target: TObjectlist);


implementation

uses AudioFileHelper, StringHelper, CoverHelper;


constructor TJustaString.create(aDataString: UnicodeString; aAnzeigeString: UnicodeString ='' );
begin
  DataString := aDataString;
  if aAnzeigestring = '' then
    Anzeigestring := DataString
  else
    AnzeigeString := aAnzeigeString;
end;

destructor TJustaString.Destroy;
begin
    inherited destroy;
end;


function CoverSort_Artist(item1,item2:pointer):integer;
var tmp1:integer;
begin
  if (TNempCover(item1).ID = 'all') and (TNempCover(item2).ID <> 'all') then result := -1 else
  if (TNempCover(item2).ID = 'all') and (TNempCover(item1).ID <> 'all') then result := 1 else
  if (TNempCover(item1).ID = 'searchresult') and (TNempCover(item2).ID <> 'searchresult') then result := -1 else
  if (TNempCover(item2).ID = 'searchresult') and (TNempCover(item1).ID <> 'searchresult') then result := 1 else
  if (TNempCover(item1).ID = '') and (TNempCover(item2).ID <> '') then result := -1 else
  if (TNempCover(item2).ID = '') and (TNempCover(item1).ID <> '') then result := 1 else
  begin
      tmp1:= AnsiCompareText(TNempCover(item1).Artist, TNempCover(item2).Artist);
      if tmp1=0 then
        result := AnsiCompareText(TNempCover(item1).Album, TNempCover(item2).Album)
      else
        result:= tmp1;
  end;
end;

function CoverSort_Album(item1,item2:pointer):integer;
var tmp1:integer;
begin
  if (TNempCover(item1).ID = 'all') and (TNempCover(item2).ID <> 'all') then result := -1 else
  if (TNempCover(item2).ID = 'all') and (TNempCover(item1).ID <> 'all') then result := 1 else
  if (TNempCover(item1).ID = 'searchresult') and (TNempCover(item2).ID <> 'searchresult') then result := -1 else
  if (TNempCover(item2).ID = 'searchresult') and (TNempCover(item1).ID <> 'searchresult') then result := 1 else
  if (TNempCover(item1).ID = '') and (TNempCover(item2).ID <> '') then result := -1 else
  if (TNempCover(item2).ID = '') and (TNempCover(item1).ID <> '') then result := 1 else
  begin
    tmp1:= AnsiCompareText(TNempCover(item1).Album, TNempCover(item2).Album);
    if tmp1=0 then
      result := AnsiCompareText(TNempCover(item1).Artist, TNempCover(item2).Artist)
    else
      result:= tmp1;
    end;
end;

function CoverSort_Genre(item1,item2:pointer):integer;
begin
  if (TNempCover(item1).ID = 'all') and (TNempCover(item2).ID <> 'all') then result := -1 else
  if (TNempCover(item2).ID = 'all') and (TNempCover(item1).ID <> 'all') then result := 1 else
  if (TNempCover(item1).ID = 'searchresult') and (TNempCover(item2).ID <> 'searchresult') then result := -1 else
  if (TNempCover(item2).ID = 'searchresult') and (TNempCover(item1).ID <> 'searchresult') then result := 1 else
  if (TNempCover(item1).ID = '') and (TNempCover(item2).ID <> '') then result := -1 else
  if (TNempCover(item2).ID = '') and (TNempCover(item1).ID <> '') then result := 1 else
  begin
    result := AnsiCompareText(TNempCover(item1).Genre, TNempCover(item2).Genre);
    if result = 0 then
      result := CoverSort_Artist(item1, item2);
  end;
end;
function CoverSort_GenreYear(item1,item2:pointer):integer;
begin
  if (TNempCover(item1).ID = 'all') and (TNempCover(item2).ID <> 'all') then result := -1 else
  if (TNempCover(item2).ID = 'all') and (TNempCover(item1).ID <> 'all') then result := 1 else
  if (TNempCover(item1).ID = 'searchresult') and (TNempCover(item2).ID <> 'searchresult') then result := -1 else
  if (TNempCover(item2).ID = 'searchresult') and (TNempCover(item1).ID <> 'searchresult') then result := 1 else
  if (TNempCover(item1).ID = '') and (TNempCover(item2).ID <> '') then result := -1 else
  if (TNempCover(item2).ID = '') and (TNempCover(item1).ID <> '') then result := 1 else
  begin
    result := AnsiCompareText(TNempCover(item1).Genre, TNempCover(item2).Genre);
    if result = 0 then
      result := CoverSort_Jahr(item1, item2);
  end;
end;
function CoverSort_Jahr(item1,item2:pointer):integer;
begin
  if (TNempCover(item1).ID = 'all') and (TNempCover(item2).ID <> 'all') then result := -1 else
  if (TNempCover(item2).ID = 'all') and (TNempCover(item1).ID <> 'all') then result := 1 else
  if (TNempCover(item1).ID = 'searchresult') and (TNempCover(item2).ID <> 'searchresult') then result := -1 else
  if (TNempCover(item2).ID = 'searchresult') and (TNempCover(item1).ID <> 'searchresult') then result := 1 else
  if (TNempCover(item1).ID = '') and (TNempCover(item2).ID <> '') then result := -1 else
  if (TNempCover(item2).ID = '') and (TNempCover(item1).ID <> '') then result := 1 else
  begin
    result := CompareValue(TNempCover(item2).Year,TNempCover(item1).Year); // umgekehrt sortieren - neuere zuerst
    if result = 0 then
      result := CoverSort_Artist(item1, item2);
  end;
end;
function CoverSort_FileAgeAlbum(item1,item2:pointer):integer;
begin
  if (TNempCover(item1).ID = 'all') and (TNempCover(item2).ID <> 'all') then result := -1 else
  if (TNempCover(item2).ID = 'all') and (TNempCover(item1).ID <> 'all') then result := 1 else
  if (TNempCover(item1).ID = 'searchresult') and (TNempCover(item2).ID <> 'searchresult') then result := -1 else
  if (TNempCover(item2).ID = 'searchresult') and (TNempCover(item1).ID <> 'searchresult') then result := 1 else
  if (TNempCover(item1).ID = '') and (TNempCover(item2).ID <> '') then result := -1 else
  if (TNempCover(item2).ID = '') and (TNempCover(item1).ID <> '') then result := 1 else
  begin
    result := CompareValue(TNempCover(item2).FileAge,TNempCover(item1).FileAge); // umgekehrt sortieren - neuere zuerst
    if result = 0 then
      result := CoverSort_Album(item1, item2);
  end;
end;
function CoverSort_FileAgeArtist(item1,item2:pointer):integer;
begin
  if (TNempCover(item1).ID = 'all') and (TNempCover(item2).ID <> 'all') then result := -1 else
  if (TNempCover(item2).ID = 'all') and (TNempCover(item1).ID <> 'all') then result := 1 else
  if (TNempCover(item1).ID = 'searchresult') and (TNempCover(item2).ID <> 'searchresult') then result := -1 else
  if (TNempCover(item2).ID = 'searchresult') and (TNempCover(item1).ID <> 'searchresult') then result := 1 else
  if (TNempCover(item1).ID = '') and (TNempCover(item2).ID <> '') then result := -1 else
  if (TNempCover(item2).ID = '') and (TNempCover(item1).ID <> '') then result := 1 else
  begin
    result := CompareValue(TNempCover(item2).FileAge,TNempCover(item1).FileAge); // umgekehrt sortieren - neuere zuerst
    if result = 0 then
      result := CoverSort_Artist(item1, item2);
  end;
end;
function CoverSort_DirectoryArtist(item1,item2:pointer):integer;
begin
  if (TNempCover(item1).ID = 'all') and (TNempCover(item2).ID <> 'all') then result := -1 else
  if (TNempCover(item2).ID = 'all') and (TNempCover(item1).ID <> 'all') then result := 1 else
  if (TNempCover(item1).ID = 'searchresult') and (TNempCover(item2).ID <> 'searchresult') then result := -1 else
  if (TNempCover(item2).ID = 'searchresult') and (TNempCover(item1).ID <> 'searchresult') then result := 1 else
  if (TNempCover(item1).ID = '') and (TNempCover(item2).ID <> '') then result := -1 else
  if (TNempCover(item2).ID = '') and (TNempCover(item1).ID <> '') then result := 1 else
  begin
    result := AnsiCompareText(TNempCover(item1).Directory, TNempCover(item2).Directory);
    if result = 0 then
      result := CoverSort_Artist(item1, item2);
  end;
end;
function CoverSort_DirectoryAlbum(item1,item2:pointer):integer;
begin
  if (TNempCover(item1).ID = 'all') and (TNempCover(item2).ID <> 'all') then result := -1 else
  if (TNempCover(item2).ID = 'all') and (TNempCover(item1).ID <> 'all') then result := 1 else
  if (TNempCover(item1).ID = 'searchresult') and (TNempCover(item2).ID <> 'searchresult') then result := -1 else
  if (TNempCover(item2).ID = 'searchresult') and (TNempCover(item1).ID <> 'searchresult') then result := 1 else
  if (TNempCover(item1).ID = '') and (TNempCover(item2).ID <> '') then result := -1 else
  if (TNempCover(item2).ID = '') and (TNempCover(item1).ID <> '') then result := 1 else
  begin
    result := AnsiCompareText(TNempCover(item1).Directory, TNempCover(item2).Directory);
    if result = 0 then
      result := CoverSort_Album(item1, item2);
  end;
end;


function MissingFirstHelper(item1,item2:pointer):integer;
begin
    if (TNempCover(item1).ID = 'all') and (TNempCover(item2).ID <> 'all') then result := -1 else
    if (TNempCover(item2).ID = 'all') and (TNempCover(item1).ID <> 'all') then result := 1 else
    if (TNempCover(item1).ID = 'searchresult') and (TNempCover(item2).ID <> 'searchresult') then result := -1 else
    if (TNempCover(item2).ID = 'searchresult') and (TNempCover(item1).ID <> 'searchresult') then result := 1 else

    if (TNempCover(item1).ID <> '') and (TNempCover(item1).ID[1] = '_') then
    begin
        // item1 is a missing cover
        if (TNempCover(item2).ID <> '') and (TNempCover(item2).ID[1] = '_') then
            // both cover are missing
            result := 0
        else
            result := -1;
    end else
        if (TNempCover(item2).ID <> '') and (TNempCover(item2).ID[1] = '_') then
        begin
            // item2 is missing
            if (TNempCover(item1).ID <> '') and (TNempCover(item1).ID[1] = '_') then
                // both are missing
                result := 0
            else
                result := 1;
        end else
            // none is missing
            result := 0;
end;

function CoverSort_ArtistMissingFirst(item1,item2:pointer):integer;
begin
    result := MissingFirstHelper(item1,item2);
    if result = 0 then
        result := CoverSort_Artist(item1, item2);
end;
function CoverSort_AlbumMissingFirst(item1,item2:pointer):integer;
begin
    result := MissingFirstHelper(item1,item2);
    if result = 0 then
        result := CoverSort_Album(item1, item2);
end;
function CoverSort_GenreMissingFirst(item1,item2:pointer):integer;
begin
    result := MissingFirstHelper(item1,item2);
    if result = 0 then
        result := CoverSort_Genre(item1, item2);
end;
function CoverSort_GenreYearMissingFirst(item1,item2:pointer):integer;
begin
    result := MissingFirstHelper(item1,item2);
    if result = 0 then
        result := CoverSort_GenreYear(item1, item2);
end;
function CoverSort_JahrMissingFirst(item1,item2:pointer):integer;
begin
    result := MissingFirstHelper(item1,item2);
    if result = 0 then
        result := CoverSort_Jahr(item1, item2);
end;
function CoverSort_FileAgeAlbumMissingFirst(item1,item2:pointer):integer;
begin
    result := MissingFirstHelper(item1,item2);
    if result = 0 then
        result := CoverSort_FileAgeAlbum(item1, item2);
end;
function CoverSort_FileAgeArtistMissingFirst(item1,item2:pointer):integer;
begin
    result := MissingFirstHelper(item1,item2);
    if result = 0 then
        result := CoverSort_FileAgeArtist(item1, item2);
end;
function CoverSort_DirectoryArtistMissingFirst(item1,item2:pointer):integer;
begin
    result := MissingFirstHelper(item1,item2);
    if result = 0 then
        result := CoverSort_DirectoryArtist(item1, item2);
end;
function CoverSort_DirectoryAlbumMissingFirst(item1,item2:pointer):integer;
begin
    result := MissingFirstHelper(item1,item2);
    if result = 0 then
        result := CoverSort_DirectoryAlbum(item1, item2);
end;




function MissingLastHelper(item1,item2:pointer):integer;
begin
    if (TNempCover(item1).ID = 'all') and (TNempCover(item2).ID <> 'all') then result := -1 else
    if (TNempCover(item2).ID = 'all') and (TNempCover(item1).ID <> 'all') then result := 1 else
    if (TNempCover(item1).ID = 'searchresult') and (TNempCover(item2).ID <> 'searchresult') then result := -1 else
    if (TNempCover(item2).ID = 'searchresult') and (TNempCover(item1).ID <> 'searchresult') then result := 1 else

    if (TNempCover(item1).ID <> '') and (TNempCover(item1).ID[1] = '_') then
    begin
        // item1 is a missing cover
        if (TNempCover(item2).ID <> '') and (TNempCover(item2).ID[1] = '_') then
            // both cover are missing
            result := 0
        else
            result := 1;
    end else
        if (TNempCover(item2).ID <> '') and (TNempCover(item2).ID[1] = '_') then
        begin
            // item2 is missing
            if (TNempCover(item1).ID <> '') and (TNempCover(item1).ID[1] = '_') then
                // both are missing
                result := 0
            else
                result := -11;
        end else
            // none is missing
            result := 0;
end;

function CoverSort_ArtistMissingLast(item1,item2:pointer):integer;
begin
    result := MissingLastHelper(item1,item2);
    if result = 0 then
        result := CoverSort_Artist(item1, item2);
end;
function CoverSort_AlbumMissingLast(item1,item2:pointer):integer;
begin
    result := MissingLastHelper(item1,item2);
    if result = 0 then
        result := CoverSort_Album(item1, item2);
end;
function CoverSort_GenreMissingLast(item1,item2:pointer):integer;
begin
    result := MissingLastHelper(item1,item2);
    if result = 0 then
        result := CoverSort_Genre(item1, item2);
end;
function CoverSort_GenreYearMissingLast(item1,item2:pointer):integer;
begin
    result := MissingLastHelper(item1,item2);
    if result = 0 then
        result := CoverSort_GenreYear(item1, item2);
end;
function CoverSort_JahrMissingLast(item1,item2:pointer):integer;
begin
    result := MissingLastHelper(item1,item2);
    if result = 0 then
        result := CoverSort_Jahr(item1, item2);
end;
function CoverSort_FileAgeAlbumMissingLast(item1,item2:pointer):integer;
begin
    result := MissingLastHelper(item1,item2);
    if result = 0 then
        result := CoverSort_FileAgeAlbum(item1, item2);
end;
function CoverSort_FileAgeArtistMissingLast(item1,item2:pointer):integer;
begin
    result := MissingLastHelper(item1,item2);
    if result = 0 then
        result := CoverSort_FileAgeArtist(item1, item2);
end;
function CoverSort_DirectoryArtistMissingLast(item1,item2:pointer):integer;
begin
    result := MissingLastHelper(item1,item2);
    if result = 0 then
        result := CoverSort_DirectoryArtist(item1, item2);
end;
function CoverSort_DirectoryAlbumMissingLast(item1,item2:pointer):integer;
begin
    result := MissingLastHelper(item1,item2);
    if result = 0 then
        result := CoverSort_DirectoryAlbum(item1, item2);
end;




function PlaylistSort_Pfad(item1,item2:pointer):integer;
begin
  result := AnsiCompareText(TJustaString(item1).DataString, TJustaString(item2).DataString);
end;
function PlaylistSort_Name(item1,item2:pointer):integer;
begin
  result := AnsiCompareText(TJustaString(item1).AnzeigeString, TJustaString(item2).AnzeigeString);
end;

function BinaerPlaylistSuche(Liste: TObjectlist; Filename: UnicodeString; l,r: integer):integer;
var m: integer;
    strm: UnicodeString;
    c: integer;
begin
    if r < l then
    begin
        result := -1;
    end else
    begin
        m := (l+r) DIV 2;
        strm := (Liste[m] as TJustaString).DataString;
        c := AnsiCompareText(Filename, strm);
        if l = r then
        begin
            if c = 0 then result := l
            else result := -1;
        end else
        begin
            if  c = 0 then
                result := m
            else if c > 0 then
                result := BinaerPlaylistSuche(Liste, Filename, m+1, r)
                else
                    result := BinaerPlaylistSuche(Liste, Filename, l, m-1);
        end;
    end;
end;


function AkleinerB(A,B: TAudioFile; SortOrder: Integer; SortArray: TNempSortArray): Boolean;
var tmp, tmp1, tmp2: Integer;
begin
  case SortOrder of
      SO_Pfad: begin
          tmp := AnsiCompareText(A.Ordner, B.Ordner);
          if tmp = 0 then
            result := AnsiCompareText(A.Dateiname, B.Dateiname) < 0
          else
            result := tmp < 0;
      end;
      SO_ArtistAlbum: begin
          if SortArray[1] = siFileAge then
              tmp1 := AnsiCompareText(A.FileAgeSortString, B.FileAgeSortString)
          else
              tmp1 := AnsiCompareText(A.Strings[SortArray[1]], B.Strings[SortArray[1]]);

          if tmp1=0 then
          begin
              if SortArray[2] = siFileAge then
                  tmp2 := AnsiCompareText(A.FileAgeSortString, B.FileAgeSortString)
              else
                  tmp2 := AnsiCompareText(A.Strings[SortArray[2]], B.Strings[SortArray[2]]);
              if tmp2 = 0 then
                  result := AnsiCompareText(A.Titel, B.Titel) < 0
              else
                  result := tmp2 < 0;
          end
          else result := tmp1 < 0;
      end;
      SO_AlbumArtist: begin
          if SortArray[2] = siFileAge then
              tmp1 := AnsiCompareText(A.FileAgeSortString, B.FileAgeSortString)
          else
              tmp1 := AnsiCompareText(A.Strings[SortArray[2]], B.Strings[SortArray[2]]);
          if tmp1=0 then
          begin
              if SortArray[1] = siFileAge then
                  tmp2 := AnsiCompareText(A.FileAgeSortString, B.FileAgeSortString)
              else
                  tmp2 := AnsiCompareText(A.Strings[SortArray[1]], B.Strings[SortArray[1]]);
              if tmp2 = 0 then
                  result := AnsiCompareText(A.Titel, B.Titel) < 0
              else
                  result := tmp2 < 0;
          end
          else result := tmp1 < 0;
      end;
      SO_Cover: begin
         result := AnsiCompareText(A.CoverID, B.CoverID) <= 0;
      end;
      // Fehler ;-)
      else result := True;
  end;

end;

procedure Merge(SourceA, SourceB, Target: TObjectlist; SortOrder: Integer; SortArray: TNempSortArray);
var idxA, idxB: Integer;
begin
// Mische die beiden Source-Listen zu einer Target-Liste.
  Target.Clear;
  idxA := 0;
  idxB := 0;
  while (idxA < SourceA.Count) OR (idxB < SourceB.Count) do
  begin
        if (idxA < SourceA.Count) AND (idxB < SourceB.Count) then
        begin
            // Noch was in beiden Spource-Listen drin
            if AkleinerB(TAudioFile(SourceA[idxA]), TAudioFile(SourceB[idxB]), SortOrder, SortArray) then
            begin
              Target.Add(SourceA[idxA]);
              inc(idxA);
            end else
            begin
              Target.Add(SourceB[idxB]);
              inc(idxB);
            end;
        end else
        begin
            // Nur noch in einer Liste was drin
            if (idxA < SourceA.Count) then
            begin
              Target.Add(SourceA[idxA]);
              inc(idxA);
            end else
            begin
              Target.Add(SourceB[idxB]);
              inc(idxB);
            end;
        end;
  end; // While
end;

procedure MergePlaylists(SourceA, SourceB, Target: TObjectlist);
var idxA, idxB: Integer;
begin
// Mische die beiden Source-Listen zu einer Target-Liste.
  Target.Clear;
  idxA := 0;
  idxB := 0;
  while (idxA < SourceA.Count) OR (idxB < SourceB.Count) do
  begin
        if (idxA < SourceA.Count) AND (idxB < SourceB.Count) then
        begin
            // Noch was in beiden Source-Listen drin
            if AnsiCompareText(TJustaString(SourceA[idxA]).DataString, TJustaString(SourceB[idxB]).DataString) < 0 then
            begin
              Target.Add(SourceA[idxA]);
              inc(idxA);
            end else
            begin
              Target.Add(SourceB[idxB]);
              inc(idxB);
            end;
        end else
        begin
            // Nur noch in einer Liste was drin
            if (idxA < SourceA.Count) then
            begin
              Target.Add(SourceA[idxA]);
              inc(idxA);
            end else
            begin
              Target.Add(SourceB[idxB]);
              inc(idxB);
            end;
        end;
  end; // While
end;


Procedure AntiMerge(Source, DeleteList, Target: TObjectlist);
var idxS, idxD, i: Integer;
begin
  idxS := 0;
  idxD := 0;
  Target.Clear; // Sollte aber eh so sein ;-)
  while (idxS < Source.Count) AND (idxD < DeleteList.Count) do
  begin
    if TAudioFile(Source[idxS]).Pfad = TAudioFile(DeleteList[idxD]).Pfad then
    begin
      //nicht in die Targetliste einfügen
      inc(idxS);
      inc(idxD);
    end else
    begin
      Target.Add(Source[idxS]);
      inc(idxS);
    end;
  end;
  // Deletelist abgearbeitet. Der Rest kommt in die Target-Liste mit rein
  for i := idxS to Source.Count -1 do
    Target.Add(Source[i]);
end;
Procedure AntiMergePlaylists(Source, DeleteList, Target: TObjectlist);
var idxS, idxD, i: Integer;
begin
  idxS := 0;
  idxD := 0;
  Target.Clear; // Sollte aber eh so sein ;-)
  while (idxS < Source.Count) AND (idxD < DeleteList.Count) do
  begin
    if TJustaString(Source[idxS]).DataString = TJustaString(DeleteList[idxD]).DataString then
    begin
      //nicht in die Targetliste einfügen
      inc(idxS);
      inc(idxD);
    end else
    begin
      Target.Add(Source[idxS]);
      inc(idxS);
    end;
  end;
  // Deletelist abgearbeitet. Der Rest kommt in die Target-Liste mit rein
  for i := idxS to Source.Count -1 do
    Target.Add(Source[i]);
end;





end.
