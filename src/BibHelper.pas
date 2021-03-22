{

    Unit BibHelper

    Some helpers for Medialibrary


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

unit BibHelper;

interface

uses Windows, Classes, SysUtils, ContNrs, Math, Nemp_ConstantsAndTypes,
    NempAudioFiles, CoverHelper;


Const SO_Pfad = 0;
      SO_ArtistAlbum = 1;
      SO_AlbumArtist = 2;
      SO_Cover = 3;

      MP3DB_PL_Path = 1;

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

  function CoverSearch_ID(Liste: TNempCoverList; aID: String; l, r: Integer): Integer;
  // presort-functions
  function CoverSort_ID(const item1, item2: TNempCover): Integer;
  function PreCoverSort_Default(item1, item2: TNempCover): Integer;
  function PreCoverSort_MissingFirst(item1, item2: TNempCover): Integer;
  function PreCoverSort_MissingLast(item1, item2: TNempCover): Integer;

  function ActualCoverSort_Artist(item1, item2: TNempCover): Integer;
  function ActualCoverSort_Album(item1, item2: TNempCover): Integer;
  function ActualCoverSort_Genre(item1, item2: TNempCover): Integer;
  function ActualCoverSort_GenreYear(item1, item2: TNempCover): Integer;
  function ActualCoverSort_Jahr(item1, item2: TNempCover): Integer;
  function ActualCoverSort_FileAgeAlbum(item1, item2: TNempCover): Integer;
  function ActualCoverSort_FileAgeArtist(item1, item2: TNempCover): Integer;
  // Note: These two coversort-Methods are almost the same, as
  //       in one Directory there is (almost everytime) only one
  //       "cover" (except covers are set by the ID3.tag)
  //       Used for the BrowseBy-Menu in MainForm
  function ActualCoverSort_DirectoryArtist(item1, item2: TNempCover): Integer;
  function ActualCoverSort_DirectoryAlbum(item1, item2: TNempCover): Integer;


  function PlaylistSort_Pfad(item1,item2:pointer):integer;
  function PlaylistSort_Name(item1,item2:pointer):integer;

  function BinaerPlaylistSuche(Liste: TObjectlist; filename: UnicodeString; l,r:integer):integer;


  function AkleinerB(A,B: TAudioFile; SortOrder: Integer; SortArray: TNempSortArray): Boolean;
        //Fügt zwei gleichmäßig sortierte Listen zu einer zusammen
        procedure Merge(SourceA, SourceB, Target: TAudioFileList; SortOrder: Integer; SortArray: TNempSortArray);
        // Dasselbe, nur für PlaylistFiles. Sortorder ist da immer "Pfad"
        procedure MergePlaylists(SourceA, SourceB, Target: TObjectList);

        // Baut eine neue Liste auf, die die Elemente enthält, die NICHT in Deletelist auftreten
        Procedure AntiMerge(Source, DeleteList, Target: TAudioFileList);
        Procedure AntiMergePlaylists(Source, DeleteList, Target: TObjectList);


implementation

uses AudioFileHelper, StringHelper;


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


function CoverSearch_ID(Liste: TNempCoverList; aID: String; l, r: Integer): Integer;
var
  c, m: integer;
begin
  if (r < l) or (r = -1) then
    result := -1
  else
  begin
    m := (l+r) DIV 2;
    c := AnsiCompareStr(aID, Liste[m].ID);

    if l = r then
    begin
      if c = 0 then
        result := l
      else
        result := -1;
    end else
    begin
      if c = 0 then
        result := m
      else
        if c > 0 then
          result := CoverSearch_ID(Liste, aID, m+1, r)
        else
          result := CoverSearch_ID(Liste, aID, l, m-1);
    end;
  end;
end;


function CoverSort_ID(const item1, item2: TNempCover): Integer;
begin
  result := PreCoverSort_Default(item1, item2);
  if result = 0 then
    result := AnsiCompareStr(item1.ID, item2.ID);
end;

function PreCoverSort_Default(item1, item2: TNempCover): Integer;
begin
  result := 0;
  if (item1.ID = 'all') and (item2.ID <> 'all') then result := -1 else
  if (item2.ID = 'all') and (item1.ID <> 'all') then result := 1 else
  if (item1.ID = 'searchresult') and (item2.ID <> 'searchresult') then result := -1 else
  if (item2.ID = 'searchresult') and (item1.ID <> 'searchresult') then result := 1 else
  if (item1.ID = '') and (item2.ID <> '') then result := -1 else
  if (item2.ID = '') and (item1.ID <> '') then result := 1;
end;

function PreCoverSort_MissingFirst(item1, item2: TNempCover): Integer;
begin
  if (item1.ID = 'all') and (item2.ID <> 'all') then result := -1 else
  if (item2.ID = 'all') and (item1.ID <> 'all') then result := 1 else
  if (item1.ID = 'searchresult') and (item2.ID <> 'searchresult') then result := -1 else
  if (item2.ID = 'searchresult') and (item1.ID <> 'searchresult') then result := 1 else

  if (item1.ID <> '') and (item1.ID[1] = '_') then
  begin
      // item1 is a missing cover
      if (item2.ID <> '') and (item2.ID[1] = '_') then
          // both cover are missing
          result := 0
      else
          result := -1;
  end else
      if (item2.ID <> '') and (item2.ID[1] = '_') then
      begin
          // item2 is missing
          if (item1.ID <> '') and (item1.ID[1] = '_') then
              // both are missing
              result := 0
          else
              result := 1;
      end else
          // none is missing
          result := 0;
end;

function PreCoverSort_MissingLast(item1, item2: TNempCover): Integer;
begin
  if (item1.ID = 'all') and (item2.ID <> 'all') then result := -1 else
  if (item2.ID = 'all') and (item1.ID <> 'all') then result := 1 else
  if (item1.ID = 'searchresult') and (item2.ID <> 'searchresult') then result := -1 else
  if (item2.ID = 'searchresult') and (item1.ID <> 'searchresult') then result := 1 else

  if (item1.ID <> '') and (item1.ID[1] = '_') then
  begin
      // item1 is a missing cover
      if (item2.ID <> '') and (item2.ID[1] = '_') then
          // both cover are missing
          result := 0
      else
          result := 1;
  end else
      if (item2.ID <> '') and (item2.ID[1] = '_') then
      begin
          // item2 is missing
          if (item1.ID <> '') and (item1.ID[1] = '_') then
              // both are missing
              result := 0
          else
              result := -11;
      end else
          // none is missing
          result := 0;
end;

function ActualCoverSort_Artist(item1, item2: TNempCover): Integer;
begin
  result := AnsiCompareText_Nemp(item1.Artist, item2.Artist);
  if result = 0 then
    result := AnsiCompareText_Nemp(item1.Album, item2.Album)
end;

function ActualCoverSort_Album(item1, item2: TNempCover): Integer;
begin
  result := AnsiCompareText_Nemp(item1.Album, item2.Album);
  if result = 0 then
    result := AnsiCompareText_Nemp(item1.Artist, item2.Artist)
end;

function ActualCoverSort_Genre(item1, item2: TNempCover): Integer;
begin
  result := AnsiCompareText_Nemp(item1.Genre, item2.Genre);
  if result = 0 then
    result := ActualCoverSort_Artist(item1, item2);
end;

function ActualCoverSort_GenreYear(item1, item2: TNempCover): Integer;
begin
  result := AnsiCompareText_Nemp(item1.Genre, item2.Genre);
  if result = 0 then
    result := ActualCoverSort_Jahr(item1, item2);
end;

function ActualCoverSort_Jahr(item1, item2: TNempCover): Integer;
begin
  result := CompareValue(item2.Year, item1.Year); // umgekehrt sortieren - neuere zuerst
  if result = 0 then
    result := ActualCoverSort_Artist(item1, item2);
end;

function ActualCoverSort_FileAgeAlbum(item1, item2: TNempCover): Integer;
begin
  result := CompareValue(item2.FileAge, item1.FileAge); // umgekehrt sortieren - neuere zuerst
  if result = 0 then
    result := ActualCoverSort_Album(item1, item2);
end;

function ActualCoverSort_FileAgeArtist(item1, item2: TNempCover): Integer;
begin
  result := CompareValue(item2.FileAge, item1.FileAge); // umgekehrt sortieren - neuere zuerst
  if result = 0 then
    result := ActualCoverSort_Artist(item1, item2);
end;

function ActualCoverSort_DirectoryArtist(item1, item2: TNempCover): Integer;
begin
  result := AnsiCompareText_Nemp(item1.Directory, item2.Directory);
  if result = 0 then
    result := ActualCoverSort_Artist(item1, item2);
end;

function ActualCoverSort_DirectoryAlbum(item1, item2: TNempCover): Integer;
begin
  result := AnsiCompareText_Nemp(item1.Directory, item2.Directory);
  if result = 0 then
    result := ActualCoverSort_Album(item1, item2);
end;


function PlaylistSort_Pfad(item1,item2:pointer):integer;
begin
  result := AnsiCompareText_Nemp(TJustaString(item1).DataString, TJustaString(item2).DataString);
end;
function PlaylistSort_Name(item1,item2:pointer):integer;
begin
  result := AnsiCompareText_Nemp(TJustaString(item1).AnzeigeString, TJustaString(item2).AnzeigeString);
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
        c := AnsiCompareText_Nemp(Filename, strm);
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
          tmp := AnsiCompareText_Nemp(A.Ordner, B.Ordner);
          if tmp = 0 then
            result := AnsiCompareText_Nemp(A.Dateiname, B.Dateiname) < 0
          else
            result := tmp < 0;
      end;
      SO_ArtistAlbum: begin
          if SortArray[1] = siFileAge then
              tmp1 := AnsiCompareText_Nemp(A.FileAgeSortString, B.FileAgeSortString)
          else
              tmp1 := AnsiCompareText_Nemp(A.Strings[SortArray[1]], B.Strings[SortArray[1]]);

          if tmp1=0 then
          begin
              if SortArray[2] = siFileAge then
                  tmp2 := AnsiCompareText_Nemp(A.FileAgeSortString, B.FileAgeSortString)
              else
                  tmp2 := AnsiCompareText_Nemp(A.Strings[SortArray[2]], B.Strings[SortArray[2]]);
              if tmp2 = 0 then
                  result := AnsiCompareText_Nemp(A.Titel, B.Titel) < 0
              else
                  result := tmp2 < 0;
          end
          else result := tmp1 < 0;
      end;
      SO_AlbumArtist: begin
          if SortArray[2] = siFileAge then
              tmp1 := AnsiCompareText_Nemp(A.FileAgeSortString, B.FileAgeSortString)
          else
              tmp1 := AnsiCompareText_Nemp(A.Strings[SortArray[2]], B.Strings[SortArray[2]]);
          if tmp1=0 then
          begin
              if SortArray[1] = siFileAge then
                  tmp2 := AnsiCompareText_Nemp(A.FileAgeSortString, B.FileAgeSortString)
              else
                  tmp2 := AnsiCompareText_Nemp(A.Strings[SortArray[1]], B.Strings[SortArray[1]]);
              if tmp2 = 0 then
                  result := AnsiCompareText_Nemp(A.Titel, B.Titel) < 0
              else
                  result := tmp2 < 0;
          end
          else result := tmp1 < 0;
      end;
      SO_Cover: begin
         result := AnsiCompareText_Nemp(A.CoverID, B.CoverID) <= 0;
      end;
      // Fehler ;-)
      else result := True;
  end;

end;

procedure Merge(SourceA, SourceB, Target: TAudioFileList; SortOrder: Integer; SortArray: TNempSortArray);
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
            if AkleinerB(SourceA[idxA], SourceB[idxB], SortOrder, SortArray) then
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

procedure MergePlaylists(SourceA, SourceB, Target: TObjectList);
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
            if AnsiCompareText_Nemp(TJustaString(SourceA[idxA]).DataString, TJustaString(SourceB[idxB]).DataString) < 0 then
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


Procedure AntiMerge(Source, DeleteList, Target: TAudioFileList);
var idxS, idxD, i: Integer;
begin
  idxS := 0;
  idxD := 0;
  Target.Clear; // Sollte aber eh so sein ;-)
  while (idxS < Source.Count) AND (idxD < DeleteList.Count) do
  begin
    if Source[idxS].Pfad = DeleteList[idxD].Pfad then
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
