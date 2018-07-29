{

    Unit AudioFileHelper

    Some little helpers for audiofiles and lists with audiofiles
    - sort functions used by ObjectList.Sort
    - binary search functions on lists of audiofiles
    - loading such lists from a playlist-format
      note: This is not done in PlaylistClass, as the
             Medialibrary uses this as well.

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

unit AudioFileHelper;

interface

uses Windows, Classes, Contnrs, SysUtils, StrUtils, Math, IniFiles, Dialogs,
    Nemp_ConstantsAndTypes, Hilfsfunktionen, NempAudioFiles, DateUtils;

const SORT_MAX = 10;

function Sortieren_ArtistTitel_asc(item1,item2:pointer):integer;
function Sortieren_ArtistAlbumTrackTitel_asc(item1,item2:pointer):integer;
function Sortieren_TitelArtist_asc(item1,item2:pointer):integer;
function Sortieren_Pfad_asc(item1,item2:pointer):integer;
function Sortieren_AlbumTrack_asc(item1,item2:pointer):integer;
function Sortieren_Jahr_asc(item1,item2:pointer):integer;
function Sortieren_Genre_asc(item1,item2:pointer):integer;

function Sortieren_String1String2Titel_asc(item1,item2:pointer):integer;
function Sortieren_String2String1Titel_asc(item1,item2:pointer):integer;
function Sortieren_CoverID(item1,item2:pointer):integer;


// Note: The following CompareFunctions are not needed any longer
//       due to the new Sort-System in Nemp 4.0
//function Sortieren_ArtistAlbumTitel_asc(item1,item2:pointer):integer;

//function Sortieren_AlbumArtistTitel_asc(item1,item2:pointer):integer;
//function Sortieren_AlbumTitelArtist_asc(item1,item2:pointer):integer;

//function Sortieren_Dateiname_asc(item1,item2:pointer):integer;

//function Sortieren_Dauer_asc(item1,item2:pointer):integer;
//function Sortieren_DateiGroesse_asc(item1,item2:pointer):integer;
//function Sortieren_Bitrate_asc(item1,item2:pointer):integer;

//function Sortieren_CBR_asc(item1,item2:pointer):integer;
//function Sortieren_Mode_asc(item1,item2:pointer):integer;
//function Sortieren_Samplerate_asc(item1,item2:pointer):integer;
//function Sortieren_Comment_asc(item1,item2:pointer):integer;

//function Sortieren_Lyrics_asc(item1,item2:pointer):integer;
//function Sortieren_Track_asc(item1,item2:pointer):integer;
//function Sortieren_Genre_asc(item1,item2:pointer):integer;

//function Sortieren_Rating_asc(item1,item2:pointer):integer;

//function Sortieren_ArtistTitel_desc(item1,item2:pointer):integer;
//function Sortieren_ArtistAlbumTitel_desc(item1,item2:pointer):integer;
//function Sortieren_TitelArtist_desc(item1,item2:pointer):integer;
//function Sortieren_AlbumArtistTitel_desc(item1,item2:pointer):integer;
//function Sortieren_AlbumTitelArtist_desc(item1,item2:pointer):integer;
//function Sortieren_Pfad_desc(item1,item2:pointer):integer;
//function Sortieren_Dateiname_desc(item1,item2:pointer):integer;
//function Sortieren_Dauer_desc(item1,item2:pointer):integer;
//function Sortieren_DateiGroesse_desc(item1,item2:pointer):integer;
//function Sortieren_Bitrate_desc(item1,item2:pointer):integer;

//function Sortieren_CBR_desc(item1,item2:pointer):integer;
//function Sortieren_Mode_desc(item1,item2:pointer):integer;
//function Sortieren_Samplerate_desc(item1,item2:pointer):integer;
//function Sortieren_Comment_desc(item1,item2:pointer):integer;
//function Sortieren_Track_desc(item1,item2:pointer):integer;
//function Sortieren_Jahr_desc(item1,item2:pointer):integer;
//function Sortieren_Lyrics_desc(item1,item2:pointer):integer;

//function Sortieren_Genre_desc(item1,item2:pointer):integer;
//function Sortieren_AlbumTrack_desc(item1,item2:pointer):integer;
//function Sortieren_Rating_Desc(item1,item2:pointer):integer;

function binaersuche(Liste: TObjectlist; FilePath, FileName: UnicodeString; l,r:integer):integer;
function BinaerAlbumSuche(Liste: TObjectlist; album: UnicodeString; l,r:integer):integer;
function BinaerArtistSuche(Liste: TObjectlist; artist: UnicodeString; l,r:integer):integer;
function BinaerCoverIDSuche(Liste: TObjectlist; CoverID: String; l,r: Integer): Integer;

{Note: Parameter SortArray: TNempSortArray not needed any longer, as search is done by Key1/Key2}
function BinaerArtistSuche_JustContains(Liste: TObjectlist; artist: UnicodeString; l,r:integer):integer;
function BinaerAlbumSuche_JustContains(Liste: TObjectlist; album: UnicodeString; l,r:integer):integer;

// Gets the Data for a new created AudioFile
// First: GetAudiodata.
// Second: Get Rating from the library (important for non-mp3-files)
//procedure SynchronizeAudioFile(aNewFile: TAudioFile; aFileName: UnicodeString; WithCover: Boolean = True);
// SynchronizeAudioFile XXXXx
// replace with 2 new functions
/// 1. SynchNewFileWithBib
///    - search a file in the library
///    - if found: Use the library data for the new File
///    - if not: Get data from file
procedure SynchNewFileWithBib(aNewFile: TAudioFile; WithCover: Boolean = True);
/// 2. SynchAFileWithDisc
///    - Get data from the file
///    - update library data (if file is in the library)
procedure SynchAFileWithDisc(aNewFile: TAudioFile; WithCover: Boolean = True);




procedure LoadPlaylistFromFile(aFilename: UnicodeString; TargetList: TObjectList; AutoScan: Boolean);
procedure LoadPlaylistFromFileM3U8(aFilename: UnicodeString; TargetList: TObjectList; AutoScan: Boolean);
procedure LoadPlaylistFromFilePLS(aFilename: UnicodeString; TargetList: TObjectList; AutoScan: Boolean);
procedure LoadPlaylistFromFileNPL(aFilename: UnicodeString; TargetList: TObjectList; AutoScan: Boolean);
procedure LoadPlaylistFromFileASX(aFilename: UnicodeString; TargetList: TObjectList; AutoScan: Boolean);



function AFCompareArtist(a1,a2: tAudioFile): Integer;
function AFCompareTitle(a1,a2: tAudioFile): Integer;
function AFCompareAlbum(a1,a2: tAudioFile): Integer;
function AFCompareComment(a1,a2: tAudioFile): Integer;
function AFCompareYear(a1,a2: tAudioFile): Integer;
function AFCompareGenre(a1,a2: tAudioFile): Integer;
function AFCompareRating(a1,a2: tAudioFile): Integer;
function AFComparePlayCounter(a1,a2: tAudioFile): Integer;
function AFCompareTrackNr(a1,a2: tAudioFile): Integer;
function AFComparePath(a1,a2: tAudioFile): Integer;
function AFCompareDirectory(a1,a2: tAudioFile): Integer;
function AFCompareFilename(a1,a2: tAudioFile): Integer;
function AFCompareExtension(a1,a2: tAudioFile): Integer;
function AFCompareDuration(a1,a2: tAudioFile): Integer;
function AFCompareBitrate(a1,a2: tAudioFile): Integer;
function AFCompareCBR(a1,a2: tAudioFile): Integer;
function AFCompareChannelMode(a1,a2: tAudioFile): Integer;
function AFCompareSamplerate(a1,a2: tAudioFile): Integer;
function AFCompareFilesize(a1,a2: tAudioFile): Integer;
function AFCompareFileAge(a1,a2: tAudioFile): Integer;
function AFCompareLyricsExists(a1,a2: tAudioFile): Integer;
function AFCompareLastFMTagsExists(a1,a2: tAudioFile): Integer;
function AFCompareCD(a1,a2: tAudioFile): Integer;
function AFCompareFavorite(a1,a2: tAudioFile): Integer;

function MainSort(item1, item2: Pointer): Integer;


implementation

uses NempMainUnit;
// MainUnit is needed because
//    - Sortieren_String1String2Titel_asc and
//    - Sortieren_String1String2Titel_desc
//    - some of the binary searches
// need some properties from the MedienBib, from where
// the sort-method is called


// New Mainsort-Method
// used to sort the displayed audiofiles
function MainSort(item1, item2: Pointer): Integer;
var a1,a2: TAudioFile;
    c: Integer;
begin
    a1 := TAudioFile(item1);
    a2 := TAudioFile(item2);
    result := 0;
    c := 0;
    while  (result = 0) and (c <= SORT_MAX) do
    begin
        case MedienBib.SortParams[c].Direction  of
            sd_Ascending: result := MedienBib.SortParams[c].Comparefunction(a1,a2);
            sd_Descending: result := MedienBib.SortParams[c].Comparefunction(a2,a1);
        end;
        inc(c);
    end;
end;


function AFCompareArtist(a1,a2: tAudioFile): Integer;
begin
    result := AnsiCompareText(a1.Artist, a2.Artist);
end;

function AFCompareTitle(a1,a2: tAudioFile): Integer;
begin
    result := AnsiCompareText(a1.Titel, a2.Titel);
end;
function AFCompareAlbum(a1,a2: tAudioFile): Integer;
begin
    result := AnsiCompareText(a1.Album, a2.Album);
end;
function AFCompareComment(a1,a2: tAudioFile): Integer;
begin
    result := AnsiCompareText(a1.Comment, a2.Comment);
end;
function AFCompareYear(a1,a2: tAudioFile): Integer;
begin
    result := AnsiCompareText(a1.Year, a2.Year);
end;
function AFCompareGenre(a1,a2: tAudioFile): Integer;
begin
    result := AnsiCompareText(a1.Genre, a2.Genre);
end;
function AFCompareRating(a1,a2: tAudioFile): Integer;
begin
    result := CompareValue(a1.Rating, a2.Rating);
end;
function AFComparePlayCounter(a1,a2: tAudioFile): Integer;
begin
    result := CompareValue(a1.PlayCounter, a2.PlayCounter);
end;
function AFCompareTrackNr(a1,a2: tAudioFile): Integer;
begin
    result := CompareValue(a1.Track, a2.Track);
end;
function AFComparePath(a1,a2: tAudioFile): Integer;
begin
//    result := AnsiCompareText(a1.Pfad, a2.Pfad);
  result := AnsiCompareText(a1.Ordner, a2.Ordner);
  if result = 0 then
      result := AnsiCompareText(a1.Dateiname, a2.Dateiname);
end;
function AFCompareDirectory(a1,a2: tAudioFile): Integer;
begin
    result := AnsiCompareText(a1.Ordner, a2.Ordner);
end;
function AFCompareFilename(a1,a2: tAudioFile): Integer;
begin
    result := AnsiCompareText(a1.Dateiname, a2.Dateiname);
end;
function AFCompareExtension(a1,a2: tAudioFile): Integer;
begin
    result := AnsiCompareText(a1.Extension, a2.Extension);
end;
function AFCompareDuration(a1,a2: tAudioFile): Integer;
begin
    result := CompareValue(a1.Duration, a2.Duration);
end;
function AFCompareBitrate(a1,a2: tAudioFile): Integer;
begin
    result := CompareValue(a1.Bitrate, a2.Bitrate);
end;
function AFCompareCBR(a1,a2: tAudioFile): Integer;
begin
    if (a1.vbr) = (a2.vbr) then
        result := 0
    else
      if (a1.vbr) then
          result := -1
      else
          result := 1;
end;
function AFCompareChannelMode(a1,a2: tAudioFile): Integer;
begin
    result := CompareValue(a1.ChannelModeInt, a2.ChannelModeInt);
end;
function AFCompareSamplerate(a1,a2: tAudioFile): Integer;
begin
    result := CompareValue(a1.SampleRateInt, a2.SampleRateInt);
end;
function AFCompareFilesize(a1,a2: tAudioFile): Integer;
begin
    result := CompareValue(a1.Size, a2.Size);
end;
function AFCompareFileAge(a1,a2: tAudioFile): Integer;
begin
    result := CompareValue(DateOf(a1.FileAge), DateOf(a2.Fileage));
end;
function AFCompareLyricsExists(a1,a2: tAudioFile): Integer;
begin
    if a1.LyricsExisting = a2.LyricsExisting then
        result := 0
    else
      if a1.LyricsExisting then
        result := 1
      else
        result := -1;
end;
function AFCompareLastFMTagsExists(a1,a2: tAudioFile): Integer;
begin
    if ((length(a1.RawTagLastFM) = 0) and (length(a2.RawTagLastFM) = 0))
    OR ((length(a1.RawTagLastFM) > 0) and (length(a2.RawTagLastFM) > 0))
    then
        result := 0
    else
        if length(a1.RawTagLastFM) > 0 then
            result := 1
        else
            result := -1;
end;
function AFCompareCD(a1,a2: tAudioFile): Integer;
begin
    result := AnsiCompareText(a1.CD, a2.CD);
end;
function AFCompareFavorite(a1,a2: tAudioFile): Integer;
begin
    result := CompareValue(a1.Favorite, a2.Favorite);
end;


function Sortieren_ArtistTitel_asc(item1,item2:pointer):integer;
var tmp:integer;
begin
    tmp:=AnsiCompareText(TAudioFile(item1).Artist, TAudioFile(item2).Artist);
    if tmp=0 then
        result := AnsiCompareText(TAudioFile(item1).Titel, TAudioFile(item2).Titel)
    else result:= tmp;
end;

function Sortieren_ArtistAlbumTrackTitel_asc(item1,item2:pointer):integer;
begin
    result := AnsiCompareText(TAudioFile(item1).Artist, TAudioFile(item2).Artist);
    if result=0 then
        result := AnsiCompareText(TAudioFile(item1).Album, TAudioFile(item2).Album);
    if result = 0 then
        result := AnsiCompareText(TAudioFile(item1).CD, TAudioFile(item2).CD);
    if result=0 then
        result := CompareValue(TAudioFile(item1).Track,TAudioFile(item2).Track);
    if result=0 then
        result := AnsiCompareText(TAudioFile(item1).Dateiname, TAudioFile(item2).Dateiname);
    if result=0 then
        result := AnsiCompareText(TAudioFile(item1).Titel, TAudioFile(item2).Titel);
end;

function Sortieren_TitelArtist_asc(item1,item2:pointer):integer;
var tmp:integer;
begin
    tmp := AnsiCompareText(TAudioFile(item1).Titel, TAudioFile(item2).Titel);
    if tmp = 0 then
        result := AnsiCompareText(TAudioFile(item1).Artist, TAudioFile(item2).Artist)
    else result:=tmp;
end;

function Sortieren_Pfad_asc(item1,item2:pointer):integer;
begin
  result := AnsiCompareText(TAudioFile(item1).Ordner, TAudioFile(item2).Ordner);
  if result = 0 then
      result := AnsiCompareText(TAudioFile(item1).Dateiname, TAudioFile(item2).Dateiname);
end;

function Sortieren_AlbumTrack_asc(item1,item2:pointer):integer;
begin
  result := AnsiCompareText(TAudioFile(item1).Album,TAudioFile(item2).Album);
  if result = 0 then
      result := AnsiCompareText(TAudioFile(item1).CD, TAudioFile(item2).CD);
  if result = 0 then
      result := AnsiCompareText(TAudioFile(item1).Ordner, TAudioFile(item2).Ordner);
  if result = 0 then
      result := CompareValue(TAudioFile(item1).Track,TAudioFile(item2).Track);
  if result = 0 then
      result := AnsiCompareText(TAudioFile(item1).Dateiname, TAudioFile(item2).Dateiname);
end;
function Sortieren_Jahr_asc(item1,item2:pointer):integer;
begin
    result := AnsiCompareText(TAudioFile(item1).Year,TAudioFile(item2).Year);
    if result = 0 then
      result := Sortieren_ArtistTitel_asc(item1,item2); //Sortieren_ArtistAlbumTitel_asc
end;
function Sortieren_Genre_asc(item1,item2:pointer):integer;
begin
    result := AnsiCompareText(TAudioFile(item1).Genre, TAudioFile(item2).Genre)
end;

(*
function Sortieren_ArtistAlbumTitel_asc(item1,item2:pointer):integer;
var tmp1,tmp2:integer;
begin
    tmp1:=AnsiCompareText(TAudioFile(item1).Artist, TAudioFile(item2).Artist);
    if tmp1=0 then
    begin
        tmp2 := AnsiCompareText(TAudioFile(item1).Album, TAudioFile(item2).Album);
        if tmp2 = 0 then
        begin
            result:= AnsiCompareText(TAudioFile(item1).Titel, TAudioFile(item2).Titel)
        end else result:=tmp2;
    end
    else result:= tmp1;
end;

function Sortieren_AlbumArtistTitel_asc(item1,item2:pointer):integer;
var tmp1,tmp2:integer;
begin
    tmp1:= AnsiCompareText(TAudioFile(item1).Album, TAudioFile(item2).Album);
    if tmp1=0 then
    begin
        tmp2 := AnsiCompareText(TAudioFile(item1).Artist, TAudioFile(item2).Artist);
        if tmp2 = 0 then
        begin
            result:= AnsiCompareText(TAudioFile(item1).Titel, TAudioFile(item2).Titel)
        end else result:=tmp2;
    end
    else result:= tmp1;
end;

function Sortieren_AlbumTitelArtist_asc(item1,item2:pointer):integer;
var tmp1,tmp2:integer;
begin
    tmp1:= AnsiCompareText(TAudioFile(item1).Album, TAudioFile(item2).Album);
    if tmp1=0 then
    begin
        tmp2 := AnsiCompareText(TAudioFile(item1).Titel, TAudioFile(item2).Titel);
        if tmp2 = 0 then
        begin
            result:= AnsiCompareText(TAudioFile(item1).Artist, TAudioFile(item2).Artist);
        end else result:=tmp2;
    end
    else result:= tmp1;
end;

function Sortieren_Dateiname_asc(item1,item2:pointer):integer;
begin
    result := AnsiCompareText(TAudioFile(item1).Dateiname, TAudioFile(item2).Dateiname)
end;
function Sortieren_Dauer_asc(item1,item2:pointer):integer;
begin
    result := compareValue(TAudioFile(item1).Duration,TAudioFile(item2).Duration);
    if result = 0 then
      result := Sortieren_ArtistAlbumTitel_asc(item1,item2);
end;
function Sortieren_DateiGroesse_asc(item1,item2:pointer):integer;
begin
    result := compareValue(TAudioFile(item1).Size,TAudioFile(item2).Size);
    if result = 0 then
      result := Sortieren_ArtistAlbumTitel_asc(item1,item2);
end;
function Sortieren_Bitrate_asc(item1,item2:pointer):integer;
begin
    result := compareValue(TAudioFile(item1).Bitrate,TAudioFile(item2).Bitrate);;
    if result = 0 then
      result := Sortieren_ArtistAlbumTitel_asc(item1,item2);
end;


function Sortieren_CBR_asc(item1,item2:pointer):integer;
begin
    if (TAudioFile(item1).vbr) = (TAudioFile(item2).vbr)
    then
      result := Sortieren_ArtistAlbumTitel_asc(item1,item2)
    else
      if (TAudioFile(item1).vbr) then
        result := -1
      else
        result := 1;
end;
function Sortieren_Mode_asc(item1,item2:pointer):integer;
begin
    result := compareValue(TAudioFile(item1).ChannelModeInt, TAudioFile(item2).ChannelModeInt);;
    if result = 0 then
      result := Sortieren_ArtistAlbumTitel_asc(item1,item2);
end;
function Sortieren_Samplerate_asc(item1,item2:pointer):integer;
begin
    result := compareValue(TAudioFile(item1).SamplerateInt, TAudioFile(item2).SamplerateInt);
    if result = 0 then
      result := Sortieren_ArtistAlbumTitel_asc(item1,item2);
end;
function Sortieren_Comment_asc(item1,item2:pointer):integer;
begin
    result := AnsiCompareText(TAudioFile(item1).Comment, TAudioFile(item2).Comment);
    if result = 0 then
      result := Sortieren_ArtistAlbumTitel_asc(item1,item2);
end;


function Sortieren_Lyrics_asc(item1,item2:pointer):integer;
begin
    if (TAudioFile(item1).LyricsExisting) = (TAudioFile(item2).LyricsExisting)
    then
      result := Sortieren_ArtistAlbumTitel_asc(item1,item2)
    else
      if (TAudioFile(item1).LyricsExisting) then
        result := -1
      else
        result := 1;
end;

function Sortieren_Track_asc(item1,item2:pointer):integer;
begin
    result := compareValue(TAudioFile(item1).Track, TAudioFile(item2).Track);;
    if result = 0 then
      result := Sortieren_ArtistAlbumTitel_asc(item1,item2);
end;

function Sortieren_Genre_asc(item1,item2:pointer):integer;
begin
  result := AnsiCompareText(TAudioFile(item1).Genre,TAudioFile(item2).Genre);
  if result = 0 then
    result := Sortieren_ArtistAlbumTitel_asc(item1,item2);
end;

function Sortieren_Rating_asc(item1,item2:pointer):integer;
begin
    result := compareValue(TAudioFile(item1).Rating, TAudioFile(item2).Rating);
    if result = 0 then
      result := Sortieren_ArtistAlbumTitel_asc(item1,item2);
end;

//----------------
// Descending sort
function Sortieren_ArtistTitel_desc(item1,item2:pointer):integer;
begin
    result := AnsiCompareText(TAudioFile(item2).Artist, TAudioFile(item1).Artist);
    if result=0 then
        result := AnsiCompareText(TAudioFile(item2).Titel, TAudioFile(item1).Titel);
end;

function Sortieren_ArtistAlbumTitel_desc(item1,item2:pointer):integer;
var tmp1,tmp2:integer;
begin
    tmp1:=AnsiCompareText(TAudioFile(item2).Artist, TAudioFile(item1).Artist);
    if tmp1=0 then
    begin
        tmp2 := AnsiCompareText(TAudioFile(item2).Album, TAudioFile(item1).Album);
        if tmp2 = 0 then
        begin
            result:= AnsiCompareText(TAudioFile(item2).Titel, TAudioFile(item1).Titel)
        end else result:=tmp2;
    end
    else result:= tmp1;
end;

function Sortieren_TitelArtist_desc(item1,item2:pointer):integer;
begin
    result := AnsiCompareText(TAudioFile(item2).Titel, TAudioFile(item1).Titel);
    if result = 0 then
        result := AnsiCompareText(TAudioFile(item2).Artist, TAudioFile(item1).Artist);
end;

function Sortieren_AlbumArtistTitel_desc(item1,item2:pointer):integer;
var tmp1,tmp2:integer;
begin
    tmp1:= AnsiCompareText(TAudioFile(item2).Album, TAudioFile(item1).Album);
    if tmp1=0 then
    begin
        tmp2 := AnsiCompareText(TAudioFile(item2).Artist, TAudioFile(item1).Artist);
        if tmp2 = 0 then
        begin
            result:= AnsiCompareText(TAudioFile(item2).Titel, TAudioFile(item1).Titel)
        end else result:=tmp2;
    end
    else result:= tmp1;
end;

function Sortieren_AlbumTitelArtist_desc(item1,item2:pointer):integer;
var tmp1,tmp2:integer;
begin
    tmp1:= AnsiCompareText(TAudioFile(item2).Album, TAudioFile(item1).Album);
    if tmp1=0 then
    begin
        tmp2 := AnsiCompareText(TAudioFile(item2).Titel, TAudioFile(item1).Titel);
        if tmp2 = 0 then
        begin
            result:= AnsiCompareText(TAudioFile(item2).Artist, TAudioFile(item1).Artist);
        end else result:=tmp2;
    end
    else result:= tmp1;
end;

function Sortieren_Pfad_desc(item1,item2:pointer):integer;
begin
  result := AnsiCompareText(TAudioFile(item2).Pfad, TAudioFile(item1).Pfad);
end;

function Sortieren_Dateiname_desc(item1,item2:pointer):integer;
begin
    result:=AnsiCompareText(TAudioFile(item2).Dateiname, TAudioFile(item1).Dateiname)
end;
function Sortieren_Dauer_desc(item1,item2:pointer):integer;
begin
    result := compareValue(TAudioFile(item2).Duration,TAudioFile(item1).Duration);
    if result = 0 then
      result := Sortieren_ArtistAlbumTitel_asc(item1,item2);
end;
function Sortieren_DateiGroesse_desc(item1,item2:pointer):integer;
begin
    result:=compareValue(TAudioFile(item2).Size,TAudioFile(item1).Size);
    if result = 0 then
      result := Sortieren_ArtistAlbumTitel_asc(item1,item2);
end;
function Sortieren_Bitrate_desc(item1,item2:pointer):integer;
begin
    result:=compareValue(TAudioFile(item2).Bitrate,TAudioFile(item1).Bitrate);
    if result = 0 then
      result := Sortieren_ArtistAlbumTitel_asc(item1,item2);
end;

function Sortieren_CBR_desc(item1,item2:pointer):integer;
begin
    if (TAudioFile(item1).vbr) = (TAudioFile(item2).vbr)
    then
      result := Sortieren_ArtistAlbumTitel_asc(item1,item2)
    else
      if (TAudioFile(item1).vbr) then
        result := 1
      else
        result := -1;
end;
function Sortieren_Mode_desc(item1,item2:pointer):integer;
begin
    result := compareValue(TAudioFile(item2).ChannelModeInt, TAudioFile(item1).ChannelModeInt);;
    if result = 0 then
      result := Sortieren_ArtistAlbumTitel_asc(item1,item2);
end;
function Sortieren_Samplerate_desc(item1,item2:pointer):integer;
begin
    result := compareValue(TAudioFile(item2).SamplerateInt, TAudioFile(item1).SamplerateInt);
    if result = 0 then
      result := Sortieren_ArtistAlbumTitel_asc(item1,item2);
end;
function Sortieren_Comment_desc(item1,item2:pointer):integer;
begin
    result := AnsiCompareText(TAudioFile(item2).Comment, TAudioFile(item1).Comment);;
    if result = 0 then
      result := Sortieren_ArtistAlbumTitel_asc(item1,item2);
end;

function Sortieren_Jahr_desc(item1,item2:pointer):integer;
begin
    result:=AnsiCompareText(TAudioFile(item2).Year,TAudioFile(item1).Year);
    if result = 0 then
      result := Sortieren_ArtistAlbumTitel_asc(item1,item2);
end;
function Sortieren_Lyrics_desc(item1,item2:pointer):integer;
begin
    if (TAudioFile(item1).LyricsExisting) = (TAudioFile(item2).LyricsExisting)
    then
      result := Sortieren_ArtistAlbumTitel_asc(item1,item2)
    else
      if (TAudioFile(item1).LyricsExisting) then
        result := 1
      else
        result := -1;
end;
function Sortieren_Track_desc(item1,item2:pointer):integer;
begin
  result := compareValue(TAudioFile(item2).Track, TAudioFile(item1).Track);;
    if result = 0 then
      result := Sortieren_ArtistAlbumTitel_desc(item1,item2);
end;
function Sortieren_Genre_desc(item1,item2:pointer):integer;
begin
  result := AnsiCompareText(TAudioFile(item2).Genre,TAudioFile(item1).Genre);
  if result = 0 then
    result := Sortieren_ArtistAlbumTitel_desc(item1,item2);
end;

function Sortieren_AlbumTrack_desc(item1,item2:pointer):integer;
begin
  result := AnsiCompareText(TAudioFile(item2).Album,TAudioFile(item1).Album);
  if result = 0 then
      result := AnsiCompareText(TAudioFile(item2).Ordner,TAudioFile(item1).Ordner);
  if result = 0 then
      result := CompareValue(TAudioFile(item2).Track,TAudioFile(item1).Track);
  if result = 0 then
      result := AnsiCompareText(TAudioFile(item2).Dateiname,TAudioFile(item1).Dateiname);
end;

function Sortieren_Rating_Desc(item1,item2:pointer):integer;
begin
  result := compareValue(TAudioFile(item2).Rating, TAudioFile(item1).Rating);
    if result = 0 then
      result := Sortieren_ArtistAlbumTitel_desc(item1,item2);
end;
*)

function Sortieren_String1String2Titel_asc(item1,item2:pointer):integer;
var tmp1,tmp2: Integer;
begin
    if MedienBib.NempSortArray[1] = siFileAge then
        tmp1 := AnsiCompareText(TAudioFile(item1).FileAgeSortString, TAudioFile(item2).FileAgeSortString)
    else
        tmp1 := AnsiCompareText(TAudioFile(item1).Strings[MedienBib.NempSortArray[1]], TAudioFile(item2).Strings[MedienBib.NempSortArray[1]]);
    if tmp1=0 then
    begin
        if MedienBib.NempSortArray[2] = siFileAge then
            tmp2 := AnsiCompareText(TAudioFile(item1).FileAgeSortString, TAudioFile(item2).FileAgeSortString)
        else
            tmp2 := AnsiCompareText(TAudioFile(item1).Strings[MedienBib.NempSortArray[2]], TAudioFile(item2).Strings[MedienBib.NempSortArray[2]]);
        if tmp2 = 0 then
        begin
            result:= AnsiCompareText(TAudioFile(item1).Titel, TAudioFile(item2).Titel)
        end else result:=tmp2;
    end
    else result:= tmp1;
end;
function Sortieren_String2String1Titel_asc(item1,item2:pointer):integer;
var tmp1,tmp2:integer;
begin
    if MedienBib.NempSortArray[2] = siFileAge then
        tmp1 := AnsiCompareText(TAudioFile(item1).FileAgeSortString, TAudioFile(item2).FileAgeSortString)
    else
        tmp1:= AnsiCompareText(TAudioFile(item1).Strings[MedienBib.NempSortArray[2]], TAudioFile(item2).Strings[MedienBib.NempSortArray[2]]);
    if tmp1=0 then
    begin
        if MedienBib.NempSortArray[1] = siFileAge then
            tmp2 := AnsiCompareText(TAudioFile(item1).FileAgeSortString, TAudioFile(item2).FileAgeSortString)
        else
            tmp2 := AnsiCompareText(TAudioFile(item1).Strings[MedienBib.NempSortArray[1]], TAudioFile(item2).Strings[MedienBib.NempSortArray[1]]);
        if tmp2 = 0 then
        begin
            result:= AnsiCompareText(TAudioFile(item1).Titel, TAudioFile(item2).Titel)
        end else result:=tmp2;
    end
    else result:= tmp1;
end;

function Sortieren_CoverID(item1,item2:pointer):integer;
begin
  result := AnsiCompareText(TAudioFile(item1).CoverID,TAudioFile(item2).CoverID);
end;



function binaersuche(Liste: TObjectlist; FilePath, FileName: UnicodeString; l,r:integer):integer;
var m:integer;
    //strm: UnicodeString;
    c:integer;
begin
    if (r < l) or (r = -1) then
    begin
        result:=-1;
    end else
    begin
        m:=(l+r) DIV 2;

          // strm := (Liste[m] as TAudioFile).Pfad;
          c := AnsiCompareText(FilePath, TAudioFile(Liste[m]).Ordner);
          if c = 0 then
              c := AnsiCompareText(FileName, TAudioFile(Liste[m]).Dateiname);

          //        strm:=(Liste[m] as TAudioFile).Pfad;
          //c := AnsiCompareText(filename,strm);


        if l=r then
        begin
            if c=0 then result:=l
            else result:=-1;
        end else
        begin
            if  c=0 then
                result:=m
            else if c > 0 then
                result := binaersuche(Liste, FilePath, FileName, m+1, r)
                else
                    result := binaersuche(Liste, FilePath, FileName, l, m-1);
        end;
    end;
end;


function BinaerAlbumSuche(Liste: TObjectlist; album: UnicodeString; l,r:integer):integer;
var m:integer;
    strm: UnicodeString;
    c:integer;
begin
    if (r < l) or (r = -1) then
    begin
        result:=-1;
    end else
    begin
        m:=(l+r) DIV 2;
        // strm:=(Liste[m] as TAudioFile).Strings[SortArray[2]]; //Album;

        strm:=(Liste[m] as TAudioFile).Key2;
        c := AnsiCompareText(album,strm);
        if l=r then
        begin
            if c=0 then result:=l
            else result:=-1;
        end else
        begin
            if  c=0 then
                result:=m
            else if c > 0 then
                result := BinaerAlbumSuche(Liste,album,m+1,r)
                else
                    result := BinaerAlbumSuche(Liste,album,l,m-1);
        end;
    end;
end;

function BinaerArtistSuche(Liste: TObjectlist; artist: UnicodeString; l,r:integer):integer;
var m:integer;
    strm: UnicodeString;
    c:integer;
begin
    if (r < l) or (r = -1) then
    begin
        result:=-1;
    end else
    begin
        m:=(l+r) DIV 2;
        //strm:=(Liste[m] as TAudioFile).Strings[SortArray[1]]; //artist;
        strm:=(Liste[m] as TAudioFile).Key1;
        c := AnsiCompareText(artist,strm);
        if l=r then
        begin
            if c=0 then result:=l
            else result:=-1;
        end else
        begin
            if  c=0 then
                result:=m
            else if c > 0 then
                result := BinaerArtistSuche(Liste,artist,m+1,r)
                else
                    result := BinaerArtistSuche(Liste,artist,l,m-1);
        end;
    end;
end;

function BinaerCoverIDSuche(Liste: TObjectlist; CoverID: String; l,r: Integer): Integer;
var m:integer;
    strm:String;
    c:integer;
begin
    if (r < l) or (r = -1) then
    begin
        result := -1;
    end else
    begin
        m := (l+r) DIV 2;
        strm := (Liste[m] as TAudioFile).Key1;
        c := AnsiCompareText(CoverID, strm);
        if l = r then
        begin
            if c = 0 then result := l
            else result := -1;
        end else
        begin
            if c = 0 then
                result := m
            else if c > 0 then
                result := BinaerCoverIDSuche(Liste, CoverID, m+1, r)
                else
                    result := BinaerCoverIDSuche(Liste, CoverID, l, m-1);
        end;
    end;
end;

function BinaerArtistSuche_JustContains(Liste: TObjectlist; artist: UnicodeString; l,r:integer):integer;
var m:integer;
    strm: UnicodeString;
    c:integer;
begin
    if (r < l) or (r = -1) then
    begin
        result:=-1;
    end else
    begin
        m:=(l+r) DIV 2;
        //strm:=(Liste[m] as TAudioFile).Strings[SortArray[1]]; //artist;
        strm:=(Liste[m] as TAudioFile).Key1;
        c := AnsiCompareText(artist,strm);
        if l=r then
        begin
            if (c=0) OR (AnsiStartsText(artist + '\' ,strm)) then result:=l
            else result:=-1;
        end else
        begin
            if  (c=0) OR (AnsiStartsText(artist + '\', strm)) then
                result:=m
            else if c > 0 then
                result := BinaerArtistSuche_JustContains(Liste,artist,m+1,r)
                else
                    result := BinaerArtistSuche_JustContains(Liste,artist,l,m-1);
        end;
    end;
end;
function BinaerAlbumSuche_JustContains(Liste: TObjectlist; album: UnicodeString; l,r:integer):integer;
var m:integer;
    strm: UnicodeString;
    c:integer;
begin
    if (r < l) or (r = -1) then
    begin
        result:=-1;
    end else
    begin
        m:=(l+r) DIV 2;
        //strm:=(Liste[m] as TAudioFile).Strings[SortArray[2]]; //Album;
        strm:=(Liste[m] as TAudioFile).Key2;
        c := AnsiCompareText(album,strm);
        if l=r then
        begin
            if (c=0) OR (AnsiStartsText(album + '\',strm)) then result:=l
            else result:=-1;
        end else
        begin
            if  (c=0)  OR (AnsiStartsText(album + '\',strm)) then
                result:=m
            else if c > 0 then
                result := BinaerAlbumSuche_JustContains(Liste,album,m+1,r)
                else
                    result := BinaerAlbumSuche_JustContains(Liste,album,l,m-1);
        end;
    end;
end;

{
    --------------------------------------------------------
    Getting the Data for a new created AudioFile
    --------------------------------------------------------
}
(*procedure SynchronizeAudioFile(aNewFile: TAudioFile;
  aFileName: UnicodeString; WithCover: Boolean = True);
var mbAf: TAudioFile;
begin
    aNewFile.GetAudioData(aFileName, GAD_Cover OR GAD_Rating);
    if WithCover then
        Medienbib.InitCover(aNewFile);
    mbAf := MedienBib.GetAudioFileWithFilename(aFileName);
    if assigned(mbAF) then
    begin
        aNewFile.Assign(mbAF);
    end;
        // aNewFile.Rating := mbAf.Rating;
end;
*)


{
    --------------------------------------------------------
    SynchNewFileWithBib
      - search a file in the library
      - if found: Use the library data for the new File
      - if not: Get data from file
    --------------------------------------------------------
}
procedure SynchNewFileWithBib(aNewFile: TAudioFile; WithCover: Boolean = True);
var mbAf: TAudioFile;
begin
    mbAf := MedienBib.GetAudioFileWithFilename(aNewFile.Pfad);
    if assigned(mbAF) then
    begin
        aNewFile.Assign(mbAF);
    end else
    begin
        aNewFile.GetAudioData(aNewFile.Pfad, GAD_Cover OR GAD_Rating or MedienBib.IgnoreLyricsFlag);
        if WithCover then
            Medienbib.InitCover(aNewFile);
    end;
end;

{
    --------------------------------------------------------
    SynchAFileWithDisc
      - Get data from the file
      - update library data (if file is in the library)
    --------------------------------------------------------
}
procedure SynchAFileWithDisc(aNewFile: TAudioFile; WithCover: Boolean = True);
var mbAf: TAudioFile;
begin
    if FileExists(aNewFile.Pfad) then
    begin
        aNewFile.GetAudioData(aNewFile.Pfad, GAD_Cover OR GAD_Rating or MedienBib.IgnoreLyricsFlag);
        if WithCover then
            Medienbib.InitCover(aNewFile);
        mbAf := MedienBib.GetAudioFileWithFilename(aNewFile.Pfad);
        if assigned(mbAF) then
            mbAF.Assign(aNewFile);
    end;
end;

{
    --------------------------------------------------------
    LoadPlaylistFromFileM3U8
    Load a playlist from an m3u8-playlist as used in Winamp
    Note: With Delphi 2009 you can load m3u and m3u8-lists
          by the same procedure, as the only difference is the
          encoding, marked by a BOM at the beginning of the file.
          This is recognized by the StringList.LoadfromFile-method.
    --------------------------------------------------------
}
procedure LoadPlaylistFromFileM3U8(aFilename: UnicodeString; TargetList: TObjectList; AutoScan: Boolean);
var mylist: tStringlist;
    i:integer;
    aAudiofile: TPlaylistfile;
    s: UnicodeString;
    dauer:integer;
begin
    mylist := TStringlist.Create;
    try

        myList.LoadFromFile(aFilename);

        if (myList.Count > 0) then
        try
            if (myList[0] = '#EXTM3U') then
            begin
                i := 1;
                while (i < myList.Count) do
                begin


                  // ExtInf-Data first
                  s := myList[i];
                  if trim(s) = '' then begin
                      inc(i);
                      //continue;
                  end else
                  begin

                    aAudioFile := TPlaylistfile.create;
                    if (copy(s,0,7) = '#EXTINF') then // ExtInf-line found
                    begin
                          dauer := StrToIntDef((copy(s,pos(':',s)+1,pos(',',s)-9)),0);
                          aAudioFile.Duration  := dauer;
                          if pos(' - ',s) > 0 then
                          begin
                              aAudioFile.Artist := copy(s,pos(',',s)+1,pos(' - ',s)-pos(',',s)-1);
                              aAudiofile.Titel  := copy(s,pos(' - ',s)+3,length(s));
                          end else
                          begin   // it seems, that ther is no "real" extinf, just the filename
                              aAudioFile.Artist := '';
                              aAudiofile.Titel  := copy(s,pos(',',s)+1, length(s));
                          end;
                          // bei URLs soll die Exinf-Zeile ins Description feld
                          // bei Dateien wäre das unnötig. lass ich jetzt aber erstmal so.
                          aAudioFile.Description := copy(s,pos(',',s)+1, length(s));
                          inc(i);
                    end;  // else showmessage(copy(s,0,7));
                    // Hinweis: Wenn der Zugriff auf mylist[i] hier schiefgeht, dann
                    //          gibts ne ExtInf-Zeile ohne zugehörigen Dateinamen
                    //       => m3U-Liste ist ungültig!

                    begin
                          s := myList[i];
                          case GetAudioTypeFromFilename(s) of
                              at_File: begin
                                  aAudioFile.AudioType := at_File;
                                  aAudioFile.Pfad := ExpandFilename(s);
                                  aAudioFile.FileIsPresent := True;
                                  if AutoScan then
                                  begin
                                      //SynchronizeAudioFile(aAudioFile, aAudioFile.Pfad, False);
                                      SynchNewFileWithBib(aAudioFile, False);
                                      aAudiofile.GetCueList;
                                  end else
                                  begin
                                      aAudioFile.Titel := ExtractFileName(ExpandFilename(s));
                                      aAudioFile.Artist := '';
                                  end;
                              end;

                              at_Stream: begin
                                  aAudioFile.AudioType := at_Stream;
                                  aAudioFile.FileIsPresent := True;
                                  aAudioFile.Pfad := s;
                                  aAudioFile.Artist := ''; // Titel und Artist stehen im Tag des Streams,
                                  aAudiofile.Titel  := ''; // der noch gar nicht da ist
                                  aAudioFile.Titel := aAudioFile.Pfad
                              end;

                              at_CDDA: begin
                                  SetCDDADefaultInformation(aAudioFile);
                                  aAudioFile.AudioType := at_CDDA;
                                  aAudioFile.Pfad := s;
                                  if AutoScan and
                                      (aAudioFile.Artist = '') // dont scan again, if ExtInf-Data was found
                                                               // we do not want cddb-queries here, only CD-Text
                                  then
                                      aAudioFile.GetAudioData(s, 0);
                              end;
                          end;
                    end;
                    TargetList.Add(aAudiofile);
                    inc(i);
                  end;
                end;
            end
            else
            begin
                // Liste ist nicht im EXT-Format - einfach nur Dateinamen
                // Das sollte bei m3u8 aber eigentlich nicht vorkommen - ich lass es hier aber mal drin....
                for i := 0 to myList.Count - 1 do
                begin
                    s := mylist[i];
                    if trim(s)='' then continue;
                    aAudioFile := TPlaylistfile.create;

                    case GetAudioTypeFromFilename(s) of
                        at_File: begin
                            aAudioFile.AudioType := at_File;
                            aAudioFile.Pfad := ExpandFilename(s);
                            aAudioFile.FileIsPresent := True;
                            if AutoScan then
                            begin
                                //SynchronizeAudioFile(aAudioFile, aAudioFile.Pfad, False);
                                SynchNewFileWithBib(aAudioFile, False);
                                aAudiofile.GetCueList;
                            end else
                            begin
                                aAudioFile.Titel := ExtractFileName(ExpandFilename(s));
                                aAudioFile.Artist := '';
                            end;
                        end;

                        at_Stream: begin
                            aAudioFile.AudioType := at_Stream;
                            aAudioFile.FileIsPresent := True;
                            aAudioFile.Pfad := s;
                            aAudioFile.Titel := aAudioFile.Pfad
                        end;

                        at_CDDA: begin
                            aAudioFile.AudioType := at_CDDA;
                            SetCDDADefaultInformation(aAudioFile);
                            aAudioFile.Pfad := s;
                            if AutoScan then
                                aAudioFile.GetAudioData(s, 0)
                            else
                            begin
                                aAudioFile.Titel := s;
                                aAudioFile.Artist := '';
                            end;
                        end;
                    end;
                    TargetList.Add(aAudiofile);
                end;
            end;
        except
          //MessageDLG('Fehler beim Laden der Playlist.', mtError, [MBOK], 0);
        end else // MyList.count=0
          ;//MessageDLG('Fehler beim Laden der Playlist.', mtError, [MBOK], 0);
    finally
        FreeAndNil(myList);
    end;
end;
procedure LoadPlaylistFromFilePLS(aFilename: UnicodeString; TargetList: TObjectList; AutoScan: Boolean);
var i:integer;
    aAudiofile: TPlaylistfile;
    ini: TMemIniFile;
    NumberOfEntries: Integer;
    newFilename: String;
    newTitel: String;
begin
    ini := TMeminiFile.Create(aFilename, TEncoding.Default);
    try
      NumberOfEntries := ini.ReadInteger('playlist','NumberOfEntries',-1);
      for i := 1 to NumberOfEntries do
      begin
        newFilename := ini.ReadString('playlist','File'+ IntToStr(i),'');
        if newFilename = '' then continue;

        aAudioFile := TPlaylistfile.create;

        case GetAudioTypeFromFilename(newFilename) of
            at_File: begin
                newFilename := ExpandFilename(newFilename);
                aAudioFile.AudioType := at_File;
                aAudioFile.Pfad := newFilename;
                aAudioFile.Duration := Ini.ReadInteger('playlist','Length'+IntToStr(i),0);
                newTitel := ini.ReadString('playlist','Title'+ IntToStr(i),'');
                aAudioFile.Artist := copy(newTitel,1, pos(' - ',newTitel));
                aAudiofile.Titel  := copy(newTitel,pos(' - ',newTitel)+3,length(newTitel));
                if AutoScan then
                begin
                    // SynchronizeAudioFile(aAudioFile, newFilename, False);
                    SynchNewFileWithBib(aAudioFile, False);
                    aAudiofile.GetCueList;
                end;
            end;

            at_Stream: begin
                aAudioFile.AudioType := at_Stream;
                aAudioFile.FileIsPresent := True;
                aAudioFile.Pfad := newFilename;
                newTitel := ini.ReadString('playlist','Title'+ IntToStr(i),'');
                //if newTitel <> '' then
                    aAudioFile.Description :=  NewTitel
                //else
                //    aAudioFile.Description := aAudioFile.Pfad;
                // aAudioFile.Titel := aAudioFile.Description;
            end;

            at_CDDA: begin
                SetCDDADefaultInformation(aAudioFile);
                aAudioFile.AudioType := at_CDDA;
                aAudioFile.Pfad := newFilename;
                aAudioFile.Duration := Ini.ReadInteger('playlist','Length'+IntToStr(i),0);
                newTitel := ini.ReadString('playlist','Title'+ IntToStr(i),'');
                aAudioFile.Artist := copy(newTitel,1, pos(' - ',newTitel));
                aAudiofile.Titel  := copy(newTitel,pos(' - ',newTitel)+3,length(newTitel));
                if AutoScan and (aAudioFile.Artist = '') then
                    aAudioFile.GetAudioData(newFilename, 0)
            end;
        end;
        TargetList.Add(aAudiofile);
      end;
    finally
      ini.Free;
    end;
end;


procedure LoadPlaylistFromFileNPL(aFilename: UnicodeString; TargetList: TObjectList; AutoScan: Boolean);
var aStream: TFileStream;
    v1, v2: AnsiString;
    c, i: Integer;
    NewAudioFile: TAudioFile;
const
  Check1: AnsiString = 'NempPlaylist';
  Check2: AnsiString = '3.1';
begin
      try
          aStream := TFileStream.Create(aFileName, fmOpenRead or fmShareDenyWrite);
          try
              setlength(v1, length(Check1));
              setlength(v2, length(Check2));
              aStream.Read(v1[1], length(v1));
              aStream.Read(v2[1], length(v2));
              if (v1 = Check1) and (v2 = Check2) then
              begin
                  aStream.Read(c, SizeOf(Integer));
                  for i := 1 to c do
                  begin
                      NewAudioFile := TAudioFile.Create;
                      NewAudioFile.LoadFromStreamForPlaylist(aStream);

                      if NewAudioFile.isCDDA then
                          SetCDDADefaultInformation(NewAudioFile);

                      //if NewAudioFile.isStream then
                      //  NewAudioFile.Description := NewAudioFile.Titel;

                      if AutoScan then
                          NewAudioFile.ReCheckExistence
                      else
                          NewAudioFile.FileIsPresent := True;

                      TargetList.Add(NewAudioFile);
                  end;
              end else
                MessageDlg('Invalid playlist', mtError, [mbOK], 0);
          finally
              if Assigned(aStream) then
                aStream.Free;
          end;
      except
          // Reading failed
      end;
end;

procedure LoadPlaylistFromFileASX(aFilename: UnicodeString; TargetList: TObjectList; AutoScan: Boolean);
var mylist: tStringlist;
    i:integer;
    aAudiofile: TPlaylistfile;
    s: UnicodeString;
    tmp: String;
    quote1, quote2: Integer;
begin
      mylist := TStringlist.Create;
      try
          myList.LoadFromFile(aFileName);
          if (mylist.Count > 0) and AnsiStartsText('<asx', Trim(mylist[0])) then
          begin
              for i := 1 to myList.Count - 1 do
              begin
                if AnsiStartsText('<ref href', Trim(mylist[i])) then
                begin
                    quote1 := Pos('"', mylist[i]);
                    quote2 := PosEx('"', myList[i], quote1+1);
                    if quote1 < quote2 then
                    begin
                        tmp := copy(myList[i], quote1+1, quote2-quote1-1);
                        //Showmessage(tmp);
                        s := (tmp);

                        aAudiofile := TPlaylistfile.Create;

                        case GetAudioTypeFromFilename(s) of
                            at_File: begin
                                aAudioFile.AudioType := at_File;
                                aAudioFile.Pfad := ExpandFilename(s);
                                aAudioFile.FileIsPresent := True;
                                if AutoScan then
                                begin
                                    //SynchronizeAudioFile(aAudioFile, aAudioFile.Pfad, False);
                                    SynchNewFileWithBib(aAudioFile, False);
                                    aAudiofile.GetCueList;
                                end else
                                begin
                                    aAudioFile.Titel := ExtractFileName(ExpandFilename(s));
                                    aAudioFile.Artist := '';
                                end;
                            end;

                            at_Stream: begin
                                aAudioFile.AudioType := at_Stream;
                                aAudioFile.FileIsPresent := True;
                                aAudioFile.Pfad := s;
                                aAudioFile.Titel := aAudioFile.Pfad
                            end;

                            at_CDDA: begin
                                SetCDDADefaultInformation(aAudioFile);
                                aAudioFile.AudioType := at_CDDA;
                                aAudioFile.Pfad := s;
                            end;
                        end;

                        TargetList.Add(aAudiofile);
                    end;
                end;
              end;
          end;
      finally
          mylist.Free
      end;
end;



procedure LoadPlaylistFromFile(aFilename: UnicodeString; TargetList: TObjectList; AutoScan: Boolean);
var ext: UnicodeString;
begin
  // Evtl. Todo in Zukunft:
  // Test, ob Datei vorhanden ist, oder ob sie auf einem anderen Laufwerk liegt
  // Und dann die Dateinamen anpassen.

  if Not FileExists(aFilename) then
      exit;

  SetCurrentDir(ExtractFilePath(aFileName));

  ext := LowerCase(ExtractFileExt(aFilename));

  if ext = '.m3u' then
    LoadPlaylistFromFileM3U8(aFilename, TargetList, AutoScan)
  else
    if ext = '.m3u8' then
      LoadPlaylistFromFileM3U8(aFilename, TargetList, AutoScan)
    else
      if ext = '.pls' then
        LoadPlaylistFromFilePLS(aFilename, TargetList, AutoScan)
      else
        if ext = '.npl' then
          LoadPlaylistFromFileNPL(aFilename, TargetList, AutoScan)
        else
          if (ext = '.asx') or (ext = '.wax') then
            LoadPlaylistFromFileASX(aFilename, TargetList, AutoScan);

end;


end.
