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

unit AudioFileHelper;

interface

uses Windows, Classes, Contnrs, SysUtils, StrUtils, Math, IniFiles, Dialogs,
    Nemp_ConstantsAndTypes, Hilfsfunktionen, NempAudioFiles, DriveRepairTools,
    DateUtils, System.UITypes, System.Generics.Defaults;

const SORT_MAX = 10;

var Sort_Pfad_asc,
    Sort_ArtistTitel_asc,
    Sort_ArtistAlbumTrackTitel_asc,
    Sort_TitelArtist_asc          ,
    Sort_AlbumTrack_asc           ,
    Sort_Jahr_asc                 ,
    Sort_Genre_asc                ,
    Sort_CoverID                  : IComparer<TAudioFile>;

function binaersuche(Liste: TAudioFileList; FilePath, FileName: UnicodeString; l,r:integer):integer;

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


procedure LoadPlaylistFromFile(aFilename: UnicodeString; TargetList: TAudioFileList; AutoScan: Boolean; aDriveManager: TDriveManager);
procedure LoadPlaylistFromFileM3U8(aFilename: UnicodeString; TargetList: TAudioFileList; AutoScan: Boolean);
procedure LoadPlaylistFromFilePLS(aFilename: UnicodeString; TargetList: TAudioFileList; AutoScan: Boolean);
procedure LoadPlaylistFromFileNPL(aFilename: UnicodeString; TargetList: TAudioFileList; AutoScan: Boolean; aDriveManager: TDriveManager);
procedure LoadPlaylistFromFileASX(aFilename: UnicodeString; TargetList: TAudioFileList; AutoScan: Boolean);

procedure SavePlaylistToNPL(aFilename: UnicodeString; SourceList: TAudioFileList; aDriveManager: TDriveManager; Silent: Boolean = True);


function AFCompareArtist(a1,a2: tAudioFile): Integer;
function AFCompareAlbumArtist(a1,a2: tAudioFile): Integer;
function AFCompareComposer(a1,a2: tAudioFile): Integer;
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
function AFCompareAlbumGain(a1,a2: tAudioFile): Integer;
function AFCompareTrackGain(a1,a2: tAudioFile): Integer;
function AFCompareAlbumPeak(a1,a2: tAudioFile): Integer;
function AFCompareTrackPeak(a1,a2: tAudioFile): Integer;
function AFCompareBPM(a1,a2: tAudioFile): Integer;

var MainSort: IComparer<TAudioFile>;


implementation

uses NempMainUnit, CoverHelper, MedienbibliothekClass;
// MainUnit is needed because
//    - some of the binary searches
// need some properties from the MedienBib, from where
// the sort-method is called



function AFCompareArtist(a1,a2: tAudioFile): Integer;
begin
    result := AnsiCompareText_Nemp(a1.Artist, a2.Artist);
end;
function AFCompareAlbumArtist(a1,a2: tAudioFile): Integer;
begin
    result := AnsiCompareText_Nemp(a1.AlbumArtist, a2.AlbumArtist);
end;
function AFCompareComposer(a1,a2: tAudioFile): Integer;
begin
  result := AnsiCompareText_Nemp(a1.Composer, a2.Composer);
end;
function AFCompareTitle(a1,a2: tAudioFile): Integer;
begin
    result := AnsiCompareText_Nemp(a1.Titel, a2.Titel);
end;
function AFCompareAlbum(a1,a2: tAudioFile): Integer;
begin
    result := AnsiCompareText_Nemp(a1.Album, a2.Album);
end;
function AFCompareComment(a1,a2: tAudioFile): Integer;
begin
    result := AnsiCompareText_Nemp(a1.Comment, a2.Comment);
end;
function AFCompareYear(a1,a2: tAudioFile): Integer;
begin
    result := AnsiCompareText_Nemp(a1.Year, a2.Year);
end;
function AFCompareGenre(a1,a2: tAudioFile): Integer;
begin
    result := AnsiCompareText_Nemp(a1.Genre, a2.Genre);
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
  result := AnsiCompareText_Nemp(a1.Ordner, a2.Ordner);
  if result = 0 then
      result := AnsiCompareText_Nemp(a1.Dateiname, a2.Dateiname);
end;
function AFCompareDirectory(a1,a2: tAudioFile): Integer;
begin
    result := AnsiCompareText_Nemp(a1.Ordner, a2.Ordner);
end;
function AFCompareFilename(a1,a2: tAudioFile): Integer;
begin
    result := AnsiCompareText_Nemp(a1.Dateiname, a2.Dateiname);
end;
function AFCompareExtension(a1,a2: tAudioFile): Integer;
begin
    result := AnsiCompareText_Nemp(a1.Extension, a2.Extension);
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
    result := CompareValue(a1.ChannelModeIdx, a2.ChannelModeIdx);
end;
function AFCompareSamplerate(a1,a2: tAudioFile): Integer;
begin
    result := CompareValue(a1.SampleRateIdx, a2.SampleRateIdx);
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
    result := AnsiCompareText_Nemp(a1.CD, a2.CD);
end;
function AFCompareFavorite(a1,a2: tAudioFile): Integer;
begin
    result := CompareValue(a1.Favorite, a2.Favorite);
end;

function AFCompareAlbumGain(a1,a2: tAudioFile): Integer;
begin
    if isZero(a1.AlbumGain) and isZero(a2.AlbumGain) then
        result := 0
    else
        if (isZero(a1.AlbumGain)) and (NOT isZero(a2.AlbumGain)) then
            result := 1
        else
            if (NOT isZero(a1.AlbumGain)) and (isZero(a2.AlbumGain)) then
                result := -1
            else

    result := CompareValue(a1.AlbumGain, a2.AlbumGain);
end;
function AFCompareTrackGain(a1,a2: tAudioFile): Integer;
begin
    if isZero(a1.TrackGain) and isZero(a2.TrackGain) then
        result := 0
    else
        if (isZero(a1.TrackGain)) and (NOT isZero(a2.TrackGain)) then
            result := 1
        else
            if (NOT isZero(a1.TrackGain)) and (isZero(a2.TrackGain)) then
                result := -1
            else

    result := CompareValue(a1.TrackGain, a2.TrackGain);
end;

function AFCompareAlbumPeak(a1,a2: tAudioFile): Integer;
begin
    result := CompareValue(a1.AlbumPeak, a2.AlbumPeak);
end;
function AFCompareTrackPeak(a1,a2: tAudioFile): Integer;
begin
    result := CompareValue(a1.TrackPeak, a2.TrackPeak);
end;

function AFCompareBPM(a1,a2: tAudioFile): Integer;
begin
  result := CompareText(a1.bpm, a2.bpm);
end;


function Sortieren_ArtistTitel_asc(item1,item2: TAudioFile):integer;
var tmp:integer;
begin
    tmp:=AnsiCompareText_Nemp(item1.Artist, item2.Artist);
    if tmp=0 then
        result := AnsiCompareText_Nemp(item1.Titel, item2.Titel)
    else result:= tmp;
end;


function binaersuche(Liste: TAudioFileList; FilePath, FileName: UnicodeString; l,r:integer):integer;
var m:integer;
    c:integer;
begin
    if (r < l) or (r = -1) then
    begin
        result:=-1;
    end else
    begin
        m:=(l+r) DIV 2;

        c := AnsiCompareText_Nemp(FilePath, Liste[m].Ordner);
        if c = 0 then
            c := AnsiCompareText_Nemp(FileName, Liste[m].Dateiname);

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
    if MedienBib.StatusBibUpdate <= 1 then
        mbAf := MedienBib.GetAudioFileWithFilename(aNewFile.Pfad)
    else
        mbAf := Nil;

    if assigned(mbAF) then
    begin
        aNewFile.Assign(mbAF);
    end else
    begin
        if WithCover then
        begin
            aNewFile.GetAudioData(aNewFile.Pfad, GAD_Rating or MedienBib.IgnoreLyricsFlag);
            NempPlayer.CoverArtSearcher.InitCover(aNewFile, tm_VCL, INIT_COVER_DEFAULT);
        end else
            aNewFile.GetAudioData(aNewFile.Pfad, GAD_Rating or MedienBib.IgnoreLyricsFlag);
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
        if WithCover then
        begin
            aNewFile.GetAudioData(aNewFile.Pfad, GAD_Rating or MedienBib.IgnoreLyricsFlag);
            NempPlayer.CoverArtSearcher.InitCover(aNewFile, tm_VCL, INIT_COVER_DEFAULT);
        end else
            aNewFile.GetAudioData(aNewFile.Pfad, GAD_Rating or MedienBib.IgnoreLyricsFlag);

        if MedienBib.StatusBibUpdate <= 1 then
        begin
            mbAf := MedienBib.GetAudioFileWithFilename(aNewFile.Pfad);
            if assigned(mbAF) then
                mbAF.Assign(aNewFile);
        end;
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
procedure LoadPlaylistFromFileM3U8(aFilename: UnicodeString; TargetList: TAudioFileList; AutoScan: Boolean);
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
procedure LoadPlaylistFromFilePLS(aFilename: UnicodeString; TargetList: TAudioFileList; AutoScan: Boolean);
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
                aAudioFile.Description :=  NewTitel
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


procedure LoadPlaylistFromFileNPL(aFilename: UnicodeString; TargetList: TAudioFileList; AutoScan: Boolean; aDriveManager: TDriveManager);
var aStream: TFileStream;
    NPLHeader: AnsiString;
    FileCount, i: Integer;
    NewAudioFile: TAudioFile;
    NPLVersion: AnsiString;
    FileIsCurrentVersion, SupportedFormat: Boolean;

    SavedDriveList: TDriveList;
    currentDriveID: Integer;
    CurrentDriveChar: Char;

const
  Check1: AnsiString = 'NempPlaylist';
  Deprecatd_Version    : AnsiString = '3.1';
  Current_Version      : AnsiString = '5.0';  // like in the GMP, new in Nemp 4.13
  Current_Version_Ext  : AnsiString = '5.1';  // additional Drive-Information stored at the beginning of the File

begin
      try
          aStream := TFileStream.Create(aFileName, fmOpenRead or fmShareDenyWrite);
          try
              setlength(NPLHeader, length(Check1));
              setlength(NPLVersion, length(Current_Version));
              aStream.Read(NPLHeader[1], length(NPLHeader));
              aStream.Read(NPLVersion[1], length(NPLVersion));

              FileIsCurrentVersion := True;
              if (NPLVersion = Deprecatd_Version) then
                  FileIsCurrentVersion := False;

              if (NPLVersion = Current_Version) then
                  FileIsCurrentVersion := True;

              SupportedFormat := (NPLVersion = Deprecatd_Version)
                              or (NPLVersion = Current_Version)
                              or (NPLVersion = Current_Version_Ext);

              if (NPLHeader = Check1) AND SupportedFormat then // file starts with "NempPlaylist"
              begin
                  SavedDriveList := TDriveList.Create(True);
                  try
                      // new in Nemp 4.14: NPL-Files also contain Drive-Information about the used TDrives
                      //                   These are used to fix Drive Letters just as the MediaLibrary does it for a long time now...
                      if NPLVersion = Current_Version_Ext then
                      begin
                          aDriveManager.LoadDrivesFromStream(aStream, SavedDriveList);
                          aDriveManager.SynchronizeDrives(SavedDriveList);
                      end;

                      // initialise variables for fixing Drive Letters
                      CurrentDriveChar := ' ';
                      currentDriveID := -2;

                      // Read the AudioFiles from the Stream
                      aStream.Read(FileCount, SizeOf(Integer));
                      for i := 1 to FileCount do
                      begin
                          NewAudioFile := TAudioFile.Create;
                          if FileIsCurrentVersion then
                              NewAudioFile.LoadDataFromStream(aStream, True, False)
                          else
                              NewAudioFile.LoadFromStreamForPlaylist_DEPRECATED(aStream);

                          if NewAudioFile.isCDDA then
                              SetCDDADefaultInformation(NewAudioFile);

                          // Nemp Version 4.14 or later:
                          // NPL-Files contain TDrives-Information to fix Drive Letters
                          if NPLVersion = Current_Version_Ext then
                          begin
                              if (not NewAudioFile.isStream) and TDriveManager.EnableUSBMode and (newAudioFile.DriveID <> -5) then
                              begin
                                    if currentDriveID <> newAudioFile.DriveID then
                                    begin
                                        // currentDriveChar does not match, we need to find the correct one
                                        if newAudioFile.DriveID <= -1 then
                                            CurrentDriveChar := '\'
                                        else
                                        begin
                                            if newAudioFile.DriveID < SavedDriveList.Count then
                                                CurrentDriveChar := SavedDriveList[newAudioFile.DriveID].Drive[1]
                                            else // something is wrong with the file here
                                            begin
                                                MessageDlg('Invalid playlist: Invalid AudioData: DriveID not found.', mtError, [mbOK], 0);
                                                break;
                                            end;
                                        end;
                                        // anyway, we've got a new ID here, and we can set the next drive with this ID faster
                                        currentDriveID := newAudioFile.DriveID;
                                    end;
                                    // now *actually* assign the proper drive letter ;-)
                                    newAudioFile.SetNewDriveChar(CurrentDriveChar);
                              end;
                          end;

                          // after that: scan the file (if wanted)
                          if AutoScan then
                              NewAudioFile.ReCheckExistence
                          else
                              NewAudioFile.FileIsPresent := True;

                          TargetList.Add(NewAudioFile);
                      end;

                  finally
                      SavedDriveList.Free;
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

procedure LoadPlaylistFromFileASX(aFilename: UnicodeString; TargetList: TAudioFileList; AutoScan: Boolean);
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
                        s := (tmp);

                        aAudiofile := TPlaylistfile.Create;

                        case GetAudioTypeFromFilename(s) of
                            at_File: begin
                                aAudioFile.AudioType := at_File;
                                aAudioFile.Pfad := ExpandFilename(s);
                                aAudioFile.FileIsPresent := True;
                                if AutoScan then
                                begin
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


procedure LoadPlaylistFromFile(aFilename: UnicodeString; TargetList: TAudioFileList; AutoScan: Boolean; aDriveManager: TDriveManager);
var ext: UnicodeString;
begin
  // Evtl. Todo in Zukunft:
  // Test, ob Datei vorhanden ist, oder ob sie auf einem anderen Laufwerk liegt
  // Und dann die Dateinamen anpassen.

  if Not FileExists(aFilename) then
      exit;

  // !!! LoadPlaylistFromFile is called with aDriveManager=NIL from downloaded Shoutcast-Playlists
  //     => Never use the DriveManager in files coming frome there (i.e. only for our own *.npl-files)

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
          LoadPlaylistFromFileNPL(aFilename, TargetList, AutoScan, aDriveManager)
        else
          if (ext = '.asx') or (ext = '.wax') then
            LoadPlaylistFromFileASX(aFilename, TargetList, AutoScan);

end;


procedure SavePlaylistToNPL(aFilename: UnicodeString; SourceList: TAudioFileList; aDriveManager: TDriveManager; Silent: Boolean = True);
var i, c: integer;
    aAudiofile: TPlaylistfile;
    tmpStream: TMemoryStream;
    tmp: AnsiString;
    PlaylistSaveDriveChar: Char;
    AudioFileSavePath: String;
    aDrive: TDrive;
begin
    tmpStream := TMemoryStream.Create;
    try
        // VersionsInfo schreiben
        tmp := 'NempPlaylist';
        tmpStream.Write(tmp[1], length(tmp));
        tmp := '5.1';
        tmpStream.Write(tmp[1], length(tmp));

        ///  Since Nemp 4.14: Add List of ManagedDrives into the PlaylistFile
        ///  But we have (so far) no proper DriveManagement in the TNempPlaylist-Class during runtime
        ///  Therefore: Add ManagedDrives just here
        aDrivemanager.AddDrivesFromAudioFiles(SourceList);
        aDriveManager.SaveDrivesToStream(tmpStream);

        PlaylistSaveDriveChar := aFilename[1];
        if PlaylistSaveDriveChar = '\' then
            PlaylistSaveDriveChar := '-';

        // FileCount
        c := SourceList.Count;
        tmpStream.Write(c, SizeOf(Integer));
        // actual Files
        for i := 0 to SourceList.Count - 1 do
        begin
            aAudioFile := SourceList[i];
            case aAudioFile.AudioType of
                at_File: begin

                      // if the AudioFile is located on the same Drive as the Playlist: Save relative Path
                      if (aAudioFile.Ordner[1] = PlaylistSaveDriveChar) and TDrivemanager.EnableCloudMode then
                      begin
                          aAudioFile.DriveID := -5;
                          AudioFileSavePath := ExtractRelativePath(aFilename, aAudioFile.Pfad );
                      end else
                      // otherwise save also a proper DriveID
                      begin
                              if aAudioFile.Ordner[1] <> '\' then
                              begin
                                  aDrive := aDriveManager.GetManagedDriveByChar(aAudioFile.Ordner[1]);
                                  if assigned(aDrive) then
                                  begin
                                      aAudioFile.DriveID := aDrive.ID;
                                      AudioFileSavePath := aAudioFile.Pfad;
                                  end else
                                  begin
                                       // for now: No exception here, just don't use "letter fix"
                                       aAudioFile.DriveID := -5;
                                       AudioFileSavePath := aAudioFile.Pfad;
                                  end;
                              end else
                              begin
                                  aAudioFile.DriveID := -1;
                                  AudioFileSavePath := aAudioFile.Pfad;
                              end;
                      end;

                      aAudioFile.SaveToStream(tmpStream, AudioFileSavePath);
                end;
                at_Stream: begin
                    aAudioFile.SaveToStream(tmpStream, aAudioFile.Pfad)
                end;
                at_CDDA: begin
                    aAudioFile.SaveToStream(tmpStream, aAudioFile.Pfad)
                end;
            end;
        end;
        try
            tmpStream.SaveToFile(aFilename);
        except
            on E: Exception do
                if not Silent then
                    MessageDLG(E.Message, mtError, [mbOK], 0);
        end;
    finally
        tmpStream.Free;
    end;
end;


initialization

Sort_Pfad_asc := TComparer<TAudioFile>.Construct( function (const item1,item2: TAudioFile): Integer
begin
    result := AnsiCompareText_Nemp(item1.Ordner, item2.Ordner);
    if result = 0 then
        result := AnsiCompareText_Nemp(item1.Dateiname, item2.Dateiname);
end);


Sort_ArtistTitel_asc := TComparer<TAudioFile>.Construct( function (const item1,item2: TAudioFile): Integer
var tmp:integer;
begin
    tmp:=AnsiCompareText_Nemp(item1.Artist, item2.Artist);
    if tmp=0 then
        result := AnsiCompareText_Nemp(item1.Titel, item2.Titel)
    else result:= tmp;
end);

Sort_ArtistAlbumTrackTitel_asc := TComparer<TAudioFile>.Construct(function (const item1,item2: TAudioFile): Integer
begin
    result := AnsiCompareText_Nemp(item1.Artist, item2.Artist);
    if result=0 then
        result := AnsiCompareText_Nemp(item1.Album, item2.Album);
    if result = 0 then
        result := AnsiCompareText_Nemp(item1.CD, item2.CD);
    if result=0 then
        result := CompareValue(item1.Track,item2.Track);
    if result=0 then
        result := AnsiCompareText_Nemp(item1.Dateiname, item2.Dateiname);
    if result=0 then
        result := AnsiCompareText_Nemp(item1.Titel, item2.Titel);
end);

Sort_TitelArtist_asc := TComparer<TAudioFile>.Construct(function (const item1,item2: TAudioFile): Integer
var tmp:integer;
begin
    tmp := AnsiCompareText_Nemp((item1).Titel, (item2).Titel);
    if tmp = 0 then
        result := AnsiCompareText_Nemp(item1.Artist, item2.Artist)
    else result:=tmp;
end);

Sort_AlbumTrack_asc := TComparer<TAudioFile>.Construct( function (const item1,item2: TAudioFile): Integer
begin
  result := AnsiCompareText_Nemp(item1.Album,item2.Album);
  if result = 0 then
      result := AnsiCompareText_Nemp(item1.CD, item2.CD);
  if result = 0 then
      result := AnsiCompareText_Nemp(item1.Ordner, item2.Ordner);
  if result = 0 then
      result := CompareValue(item1.Track, item2.Track);
  if result = 0 then
      result := AnsiCompareText_Nemp(item1.Dateiname, item2.Dateiname);
end);

Sort_Jahr_asc := TComparer<TAudioFile>.Construct( function (const item1,item2: TAudioFile): Integer
begin
    result := AnsiCompareText_Nemp(item1.Year,item2.Year);
    if result = 0 then
      result := Sortieren_ArtistTitel_asc(item1,item2);
end);

Sort_Genre_asc := TComparer<TAudioFile>.Construct( function(const item1,item2: TAudioFile): Integer
begin
    result := AnsiCompareText_Nemp(item1.Genre, item2.Genre)
end);

Sort_CoverID := TComparer<TAudioFile>.Construct( function (const item1,item2: TAudioFile): Integer
begin
  result := AnsiCompareText_Nemp(item1.CoverID,item2.CoverID);
end
);


MainSort := TComparer<TAudioFile>.Construct( function (const item1, item2: TAudioFile): Integer
var c: Integer;
begin
    result := 0;
    c := 0;
    while  (result = 0) and (c <= SORT_MAX) do
    begin
        case MedienBib.SortParams[c].Direction  of
            sd_Ascending: result := MedienBib.SortParams[c].Comparefunction(item1, item2);
            sd_Descending: result := MedienBib.SortParams[c].Comparefunction(item2, item1);
        end;
        inc(c);
    end;
end) ;




end.
