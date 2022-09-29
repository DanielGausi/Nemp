{

    Unit BibHelper

    Some helpers for Medialibrary


    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2005-2022, Daniel Gaussmann
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
    NempAudioFiles, CoverHelper, NempFileUtils;


Const SO_Pfad = 0;
      SO_ArtistAlbum = 1;
      SO_AlbumArtist = 2;
      SO_Cover = 3;

      MP3DB_PL_Path = 1;

 type

    (*TJustaString = class
    public
      DataString: UnicodeString;
      AnzeigeString: UnicodeString;

      constructor create(aDataString: UnicodeString; aAnzeigeString: UnicodeString = '');
      destructor Destroy; override;
    end;
    *)

    teRandomPlaylistRange = (rprLibrary, rprCategory, rprView);


    TPlaylistFillOptions = record
      // SkipGenreCheck: boolean;
      // Sortierte Version von "Genres" aus mp3fileUtils.
      // Wird von der Checklistbox übernommen
      // GenreStrings: TStrings;
      // GenreChecked: Array of boolean;
      SkipTagCheck: boolean;
      WantedTags: TStringList;
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
      SelectionRange: teRandomPlaylistRange;
      CheckCategory: Boolean;
      CategoryIdx: Byte;
    end;



  function BinaerPlaylistSuche(Liste: TLibraryPlaylistList; filename: UnicodeString; l,r:integer):integer;
  procedure MergePlaylists(MainList, NewList: TLibraryPlaylistList);
  // Procedure AntiMergePlaylists(MainList, DeleteList: TLibraryPlaylistList);


implementation

uses AudioFileHelper, StringHelper, Hilfsfunktionen;


function BinaerPlaylistSuche(Liste: TLibraryPlaylistList; Filename: UnicodeString; l,r: integer):integer;
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
        strm := Liste[m].Path;
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


procedure MergePlaylists(MainList, NewList: TLibraryPlaylistList);
var
  i: Integer;
begin
  // System Change 2021/22: Do not use linear-time merging here
  // We don't have THAT many Playlists, so we just add the new Files, and sort the whole list again
  for i := 0 to NewList.Count - 1 do
    MainList.Add(NewList[i]);

  MainList.Sort(SortPlaylists_Path);
end;


(*Procedure AntiMergePlaylists(MainList, DeleteList: TLibraryPlaylistList);
var
  i: Integer;
begin
  // System Change 2021: Do not use linear-time removing
  // We don't have THAT many Playlists, so we just delete the missing Files
  for i := 0 to DeleteList.count - 1 do begin
    MainList.Remove(DeleteList[i]);
  end;
end;
*)

end.
