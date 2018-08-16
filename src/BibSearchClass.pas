{

    Unit BibSearchClass

    Implements searching in the medialibrary

    The TMedienBibliothek-Class has a property TBibSearcher.
    TBibSearcher knows the Files from the library through the variable
    "MainList", which is the same list as TMedienBibliothek.Mp3ListePfadSort

    Almost everything here runs in VCL Mainthread.
    Except: Building the "tmpTotalStrings", which will run in context of the
    update-thread.

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


unit BibSearchClass;

interface

uses Windows, Contnrs, Sysutils,  Classes, dialogs, Messages, IniFiles,
     NempAudioFiles,
     Hilfsfunktionen, StringSearchHelper, StrUtils, Nemp_ConstantsAndTypes,
     Nemp_RessourceStrings;

const smQuick=0;
      smQuickLyric=1;
      smSlow=2;


type
    // Some helpers for searching
    // Unicode-Keywords are used for exact matching
    TSearchKeyWords = record
        General: UnicodeString;
        Artist: UnicodeString;
        Album: UnicodeString;
        Titel: UnicodeString;
        Pfad: UnicodeString;
        Kommentar: UnicodeString;
        Lyric: UnicodeString;
        Mode: Integer;
        ComboBoxString: UnicodeString;
    end;
    // UTF8-Keywords are used for Quicksearch
    // and approximate matching
    TUTF8SearchKeywords = record
        General: UTF8String;
        Artist: UTF8String;
        Album: UTF8String;
        Titel: UTF8String;
        Pfad: UTF8String;
        Kommentar: UTF8String;
        Lyric: UTF8String;
    end;

    TQuickSearchOptions = record
        WhileYouType: Boolean;
        AllowErrorsOnType: Boolean;
        AllowErrorsOnEnter: Boolean;
        ChangeCoverFlow: Boolean;
    end;


    TSearchOptions = record
        // SearchParam: Word; // NewSearch, extend search, refine search
                              // Nem p 4.7.3: Always "New search"
        AllowErrors: Boolean;
        SkipGenreCheck: boolean;
        IncludeNAGenres: boolean;

        // Genrestrings: sorted list of genres as defined in mp3FileUtils.pas
        // Note: in mp3fileutils genres are not sorted, the order there is
        // defined by id3.org and winamp
        GenreStrings: TStrings;
        GenreChecked: Array of boolean;

        SkipYearCheck: Boolean;
        WhichYearCheck: Word;
        MinMaxYear: Word;
        IncludeNAYear: boolean;
        Include0Year: boolean;
    end;

    // approximate quicksearch needs a list of UTF8 encoded Strings
    // Delphi2009-Stringlist are UTF16-encoded (TEncoding is only used for saving)
    // so, here is a highly complex TUTF8StringList. ;-)
    TUTF8StringList = Array of UTF8String;


    TBibSearcher = class
      private
        // Destination Handle for the Windows-Messages
        MainWindowHandle: DWord;

        // Current list. This is a pointer to another list (one of the SearchResults[1..10])
        // Used for "Better search"
        CurrentList: TObjectList;

        // Dummy-Audiofiles
        fDummyAudioFile: TAudioFile;

        fIPCSearchIsRunning: Boolean;

        // Some Flags for the search
        // are used in VCL and secondary thread
        // IMPORTANT: Do not use these private variables directly!
        //            Use the properties instead (which will call threadsafe setters/getters)
        fAccelerateSearch: LongBool;
        fAccelerateLyricSearch: LongBool;
        fAccelerateSearchIncludePath: LongBool;
        fAccelerateSearchIncludeComment: LongBool;

        fTotalStringLengthSetting   : Integer;  // The length of the total string, according to the curent settings
        fTotalStringLengthMinimized : Integer;  //  The length of the total string, without filenames and without comments
        fLyricStringLength          : Integer;  // The Length of the Lyric string

        // Variables for quicker search.
        // The TotalStrings contain all String-Information of all the
        // Audiofiles in one big string. This cann be searched much
        // faster than accessing every single Audiofile-Object
        TotalString: UTF8String;
        // If a search keyword matches the TotalString at position x,
        // The indizes-array can be used to get the index of the
        // matching audiofile within the Objectlist
        TotalStringIndizes: TIntArray;

        // Same for Lyrics
        // Separated Strings as in Quicksearch one might not want to
        // search within in the lyrics
        TotalLyricString: UTF8String;
        TotalLyricStringIndizes: TIntArray;

        // the tmp-versions of these vars are used during the update-process
        // of the library. At the end of this process the vars will swapped
        // within the vcl mainthread.
        //TmpTotalString: UTF8String;
        //TmpTotalStringIndizes: TIntArray;
        //TmpTotalLyricString: UTF8String;
        //TmpTotalLyricStringIndizes: TIntArray;

        // Getter and Setter for threadsafe properties
        function GetAccelerateSearch: LongBool;
        procedure SetAccelerateSearch(Value: LongBool);
        procedure SetAccelerateSearchIncludePath(Value: LongBool);
        function GetAccelerateSearchIncludePath: LongBool;
        procedure SetAccelerateSearchIncludeComment(Value: LongBool);
        function GetAccelerateSearchIncludeComment: LongBool;
        function GetAccelerateLyricSearch: LongBool;
        procedure SetAccelerateLyricSearch(Value: LongBool);

        procedure CalculateTotalStringLengths(FileList: TObjectList);
        procedure CalculateLyricStringLengths(FileList: TObjectList);

         //Some sub-methods for searching
        //procedure DeleteNotMatchingFiles(KeyWords: TSearchKeyWords; UTF8SearchKeyWords: TUTF8SearchKeyWords);
        procedure SearchFuzzy(Searchmode: Integer; UTF8LongestKeyword: UTF8String; KeyWords: TSearchKeyWords; UTF8SearchKeyWords: TUTF8SearchKeyWords);
        procedure SearchExact(Searchmode: Integer; UTF8LongestKeyword: UTF8String; KeyWords: TSearchKeyWords; UTF8SearchKeyWords: TUTF8SearchKeyWords);
        function IsOK(substr:UnicodeString; str: UnicodeString):boolean;
        function IsOKNoSubStrings(substr:UnicodeString; str: UnicodeString):boolean;
        function IsOKApprox(substr: UTF8String; str: UnicodeString):boolean;
        function CheckGenre(Genre: UnicodeString):boolean;
        function CheckYear(Year: UnicodeString):boolean;

        function AudioFileMatchesCompleteKeywords(aAudioFile: TAudioFile; Keywords: TSearchKeywords): Boolean;
        function AudioFileMatchesCompleteKeywordsApprox(aAudioFile: TAudioFile; Keywords: TUTF8SearchKeywords): Boolean;

        function AudioFileMatchesCompleteKeywordsNoSubStrings(aAudioFile: TAudioFile; Keywords: TSearchKeywords): Boolean;

        function GenerateKeywordList(aKeyword: UnicodeString): TStringList;


      public
        // Main list. This is just a pointer to TMedienBibliothek.Mp3ListePfadSort
        MainList: TObjectList;

        // Contains the results of a quicksearch
        QuickSearchResults: TObjectList;
        //QuickSearchAdditionalResults: TObjectList;

        // The IPC-Search results for the Deskband. VCL only!!
        IPCSearchResults: TObjectList;

        QuickSearchOptions: TQuickSearchOptions;
        SearchOptions: TSearchOptions;

        // SearchResultLists contain the last 10 Searchresults,
        // SearchKeyWords the corresponding keywords ans
        SearchResultLists: Array[1..10] of TObjectlist;
        SearchKeyWords: Array[1..10] of TSearchKeyWords;

        // some thread-safe properties
        property AccelerateSearch: LongBool read GetAccelerateSearch write SetAccelerateSearch;
        property AccelerateSearchIncludePath: LongBool read GetAccelerateSearchIncludePath write SetAccelerateSearchIncludePath;
        property AccelerateSearchIncludeComment: LongBool read GetAccelerateSearchIncludeComment write SetAccelerateSearchIncludeComment;
        property AccelerateLyricSearch: LongBool read GetAccelerateLyricSearch write SetAccelerateLyricSearch;

        property DummyAudioFile: TAudioFile read fDummyAudioFile;

        property IPCSearchIsRunning: Boolean read fIPCSearchIsRunning;

        constructor Create(aWnd: DWord);
        destructor Destroy; override;

        procedure Clear;
        // Deletes an AudioFile from the ObjectLists
        procedure RemoveAudioFileFromLists(aAudioFile: TAudioFile);
        // Deletes Files contained in aList from the SearchLists
        procedure RemoveAudioFilesFromLists(aList: TObjectList);

        // Read/write some settings from IniFile
        procedure LoadFromIni(Ini: TMemIniFile);
        procedure SaveToIni(Ini: TMemIniFile);

        // Displays a Searchresult-List
        procedure ShowSearchResults(aIndex: Integer);

        // generate the tmpTotal-Strings
        // Note: These run in a secondary thread, not the VCL-mainthread
        // Parameter is the temporary Mp3ListePfadSort from the library
        //procedure BuildTMPTotalString(tmpFileList: TObjectList);
        //procedure BuildTMPTotalLyricString(tmpFileList: TObjectList);

        // generate the TotalStrings directly
        // Note: These run in the VCL-mainthread
        procedure BuildTotalString(FileList: TObjectList);
        procedure BuildTotalLyricString(FileList: TObjectList);
        procedure ClearTotalLyricString;

        // Swap the TmpTotalString-Stuff (created in secondary thread)
        // to the TotalString-Stuff (runs in secondary thread)
        procedure SwapTotalStrings(FileList: TObjectList);

        procedure InitNewSearch(Keywords: TSearchKeyWords);
        /// procedure InitBetterSearch(Keywords: TSearchKeyWords);

        procedure GlobalQuickSearch(Keyword: UnicodeString; AllowErr: Boolean);
        procedure GlobalQuickTagSearch(KeyTag: UnicodeString);

        procedure CompleteSearch(Keywords: TSearchKeyWords);
        procedure CompleteSearchNoSubStrings(Keywords: TSearchKeyWords);
        // Search for IPC (as used in the Deskband)
        procedure IPCQuickSearch(Keyword: UnicodeString);

        procedure EmptySearch(Mode: Integer);
        procedure SearchMarker(aIndex: Byte);

    end;

// Helpers for Quicksearch.
// Not methods, as these are called also from Nemp Webserver, which uses a
// simple copy (=just a ObjectList) of the Medialib.
// (A copy is used there because I do not want to code everything threadsafe ;-))
function AudioFileMatchesKeywords(aAudioFile: TAudioFile; Keywords: TStringList): Boolean;
function AudioFileMatchesKeywordsApprox(aAudioFile: TAudioFile; Keywords: TUTF8StringList): Boolean;


function AudioFileMatchesKeywordsPlaylist(aAudioFile: TAudioFile; Keywords: TStringList): Boolean;

implementation


function AudioFileMatchesKeywordsPlaylist(aAudioFile: TAudioFile; Keywords: TStringList): Boolean;
var i: Integer;
begin
 result := true;
 for i := 0 to Keywords.Count - 1 do
 begin
     if   (AnsiContainsText(aAudioFile.Artist    , Keywords[i]))
       or (AnsiContainsText(aAudioFile.Titel     , Keywords[i]))
       or (AnsiContainsText(aAudioFile.Album     , Keywords[i]))
       or (AnsiContainsText(aAudioFile.Pfad      , Keywords[i]))
     then  // nothing. Audiofile is valid (til here)
     else
     begin
        // If a Keyword was not found:
        // Audiofile doesn't match - break.
        result := False;
        break;
     end;
 end;
end;


// Helpers for Quicksearch.
// (keywords here means just some words, which match any field of the audiofile)
function AudioFileMatchesKeywords(aAudioFile: TAudioFile; Keywords: TStringList): Boolean;
var i: Integer;
begin
 result := true;
 for i := 0 to Keywords.Count - 1 do
 begin
     if        (AnsiContainsText(aAudioFile.Pfad      , Keywords[i]))
            or (AnsiContainsText(aAudioFile.Artist    , Keywords[i]))
            or (AnsiContainsText(aAudioFile.Album     , Keywords[i]))
            or (AnsiContainsText(aAudioFile.Titel     , Keywords[i]))
            or (AnsiContainsText(aAudioFile.Comment   , Keywords[i]))
     then  // nothing. Audiofile is valid (til here)
     else
     begin
        // If a Keyword was not found:
        // Audiofile doesn't match - break.
        result := False;
        break;
     end;
 end;
end;

function AudioFileMatchesKeywordsApprox(aAudioFile: TAudioFile; Keywords: TUTF8StringList): Boolean;
var i: Integer;
begin
  result := True;
  for i := 0 to length(Keywords)-1 do
  begin
      if  (SearchDP(UTF8Encode(AnsiLowerCase(aAudioFile.Pfad)),      Keywords[i],  length(Keywords[i]) Div 4) > 0)
          or (SearchDP(UTF8Encode(AnsiLowerCase(aAudioFile.Artist)), Keywords[i],  length(Keywords[i]) Div 4) > 0)
          or (SearchDP(UTF8Encode(AnsiLowerCase(aAudioFile.Titel)),  Keywords[i],  length(Keywords[i]) Div 4) > 0)
          or (SearchDP(UTF8Encode(AnsiLowerCase(aAudioFile.Album)),  Keywords[i],  length(Keywords[i]) Div 4) > 0)
          or (SearchDP(UTF8Encode(AnsiLowerCase(aAudioFile.Comment)),Keywords[i],  length(Keywords[i]) Div 4) > 0)
      then // nothing. Audiofile is valid (til here)
      else
      begin
          // Audiofile doesn't match - break.
          result := False;
          break;
      end;
  end;
end;


{
    --------------------------------------------------------
    Basic Class-Stuff.
    Create, Destroy, Clear, Remove some objects
    --------------------------------------------------------
}
constructor TBibSearcher.Create(aWnd: DWord);
var i: Integer;
begin
    inherited Create;
    MainWindowHandle := aWnd;
    QuickSearchResults := TObjectList.Create(False);
    IPCSearchResults := TObjectList.Create(False);
    for i := 1 to 10 do
        SearchResultLists[i] := TObjectlist.Create(False);

    fDummyAudioFile := TAudioFile.Create;
end;

destructor TBibSearcher.Destroy;
var i: Integer;
begin
    IPCSearchResults.Free;
    QuickSearchResults.Free;
    fDummyAudioFile.Free;
    for i := 1 to 10 do
        SearchResultLists[i].Free;
    inherited destroy;
end;

procedure TBibSearcher.Clear;
var i: Integer;
begin
    QuickSearchResults.Clear;
    for i := 1 to 10 do
        SearchResultLists[i].Clear;
    TotalString := '';
    //TmpTotalString := '';
    SetLength(TotalStringIndizes, 0);
    //SetLength(TmpTotalStringIndizes, 0);
    TotalLyricString := '';
    //TmpTotalLyricString := '';
    SetLength(TotalLyricStringIndizes, 0);
    //SetLength(TmpTotalLyricStringIndizes, 0);
end;

procedure TBibSearcher.RemoveAudioFileFromLists(aAudioFile: TAudioFile);
var i: Integer;
begin
    QuickSearchResults.Extract(aAudioFile);
    for i := 1 to 10 do
        SearchResultLists[i].Extract(aAudioFile);
end;

procedure TBibSearcher.RemoveAudioFilesFromLists(aList: TObjectList);
var i: Integer;
begin
    for i := 0 to aList.Count - 1 do
        RemoveAudioFileFromLists(TAudioFile(aList[i]));
end;

{
    --------------------------------------------------------
    LoadFromIni
    SaveToIni
    Load/Save some settings
    called via MedienBib.LoadFrom/SaveToIni
    --------------------------------------------------------
}
procedure TBibSearcher.LoadFromIni(Ini: TMemIniFile);
begin
    AccelerateSearch               := Ini.ReadBool('MedienBib', 'AccelerateSearch', True);
    AccelerateSearchIncludePath    := Ini.ReadBool('MedienBib', 'AccelerateSearchIncludePath', True);
    AccelerateSearchIncludeComment := Ini.ReadBool('MedienBib', 'AccelerateSearchIncludeComment', False);
    AccelerateLyricSearch          := Ini.ReadBool('MedienBib', 'AccelerateLyricSearch', False);

    QuickSearchOptions.WhileYouType       := Ini.ReadBool('MedienBib', 'QSWhileYouType', True);
    QuickSearchOptions.AllowErrorsOnEnter := Ini.ReadBool('MedienBib', 'QSAllowErrorsOnEnter', True);
    QuickSearchOptions.AllowErrorsOnType  := Ini.ReadBool('MedienBib', 'QSAllowErrorsOnType', False);
    QuickSearchOptions.ChangeCoverFlow    := Ini.ReadBool('MedienBib', 'QSChangeCoverFlow', False);
end;
procedure TBibSearcher.SaveToIni(Ini: TMemIniFile);
begin
    Ini.WriteBool('MedienBib', 'AccelerateSearch', AccelerateSearch);
    Ini.WriteBool('MedienBib', 'AccelerateSearchIncludePath', AccelerateSearchIncludePath);
    Ini.WriteBool('MedienBib', 'AccelerateSearchIncludeComment', AccelerateSearchIncludeComment);
    Ini.WriteBool('MedienBib', 'AccelerateLyricSearch', AccelerateLyricSearch);

    Ini.WriteBool('MedienBib', 'QSWhileYouType', QuickSearchOptions.WhileYouType);
    Ini.WriteBool('MedienBib', 'QSAllowErrorsOnEnter', QuickSearchOptions.AllowErrorsOnEnter);
    Ini.WriteBool('MedienBib', 'QSAllowErrorsOnType', QuickSearchOptions.AllowErrorsOnType);
    Ini.WriteBool('MedienBib', 'QSChangeCoverFlow', QuickSearchOptions.ChangeCoverFlow);
end;

{
    --------------------------------------------------------
    Setter/Getter for properties
    InterlockedExchange necessary as these properties are used
    in BuildTmpTotalString, which runs in a secondary thread
    --------------------------------------------------------
}
function TBibSearcher.GetAccelerateSearch: LongBool;
begin
  InterLockedExchange(Integer(Result), Integer(fAccelerateSearch));
end;
procedure TBibSearcher.SetAccelerateSearch(Value: LongBool);
begin
  InterLockedExchange(Integer(fAccelerateSearch), Integer(Value));
end;
procedure TBibSearcher.SetAccelerateSearchIncludePath(Value: LongBool);
begin
  InterLockedExchange(Integer(fAccelerateSearchIncludePath), Integer(Value));
end;
function TBibSearcher.GetAccelerateSearchIncludePath: LongBool;
begin
  InterLockedExchange(Integer(Result), Integer(fAccelerateSearchIncludePath));
end;
procedure TBibSearcher.SetAccelerateSearchIncludeComment(Value: LongBool);
begin
  InterLockedExchange(Integer(fAccelerateSearchIncludeComment), Integer(Value));
end;
function TBibSearcher.GetAccelerateSearchIncludeComment: LongBool;
begin
  InterLockedExchange(Integer(Result), Integer(fAccelerateSearchIncludeComment));
end;
function TBibSearcher.GetAccelerateLyricSearch: LongBool;
begin
  InterLockedExchange(Integer(Result), Integer(fAccelerateLyricSearch));
end;
procedure TBibSearcher.SetAccelerateLyricSearch(Value: LongBool);
begin
  InterLockedExchange(Integer(fAccelerateLyricSearch), Integer(Value));
end;

(*
{
    --------------------------------------------------------
    BuildTMPTotalString
    BuildTMPTotalLyricString
    Generate the temporary versions of the totalstrings.
    Note: run in secondary thread!
    --------------------------------------------------------
}
procedure TBibSearcher.BuildTMPTotalString(tmpFileList: TObjectList);
var aAudioFile: TAudioFile;
    i: Integer;
begin
    if AccelerateSearch then
    begin
        // Create TotalString and Indizes
        // Looks complicated, but check quicksearch
        // with/without acceleration on large libraries (~50.000 files)
        TmpTotalString := '';
        Setlength(TmpTotalStringIndizes, tmpFileList.Count);
        for i := 0 to tmpFileList.Count-1 do
        begin
            TmpTotalStringIndizes[i] := Length(TmpTotalString);
            aAudioFile := TAudioFile(tmpFileList[i]);
            TmpTotalString := TmpTotalString
                           + Utf8Encode(AnsiLowerCase(aAudioFile.Artist)) + #1
                           + Utf8Encode(AnsiLowerCase(aAudioFile.Titel)) + #1
                           + Utf8Encode(AnsiLowerCase(aAudioFile.Album));
            if AccelerateSearchIncludePath then
                  TmpTotalString := TmpTotalString + #1
                              + Utf8Encode(AnsiLowerCase(aAudioFile.Pfad));
            if AccelerateSearchIncludeComment then
                  TmpTotalString := TmpTotalString + #1
                              + Utf8Encode(AnsiLowerCase(aAudioFile.Comment));
            TmpTotalString := TmpTotalString + #13#10;
        end;
    end else
    begin
        TmpTotalString := '';
        Setlength(TmpTotalStringIndizes, 0);
    end;
end;
procedure TBibSearcher.BuildTMPTotalLyricString(tmpFileList: TObjectList);
var aAudioFile: TAudioFile;
    i: Integer;
begin
    if AccelerateLyricSearch then
    begin
        TmpTotalLyricString := '';
        Setlength(TmpTotalLyricStringIndizes, tmpFileList.Count);
        for i := 0 to tmpFileList.Count-1 do
        begin
            TmpTotalLyricStringIndizes[i] := Length(TmpTotalLyricString);
            aAudioFile := TAudioFile(tmpFileList[i]);
            TmpTotalLyricString := TmpTotalLyricString
                           + Utf8Encode(AnsiLowerCase(UTF8ToString(aAudioFile.Lyrics))) + #13#10;
        end;
    end else
    begin
        TmpTotalLyricString := '';
        Setlength(TmpTotalLyricStringIndizes, 0);
    end;
end;
*)

{
    --------------------------------------------------------
    BuildTotalString
    BuildTotalLyricString
    Generate the  totalstrings.
    Note: run in VCL-Mainthread
    just the same method as the tmp-versions.
    Note to self: This could be done more elegant...
    --------------------------------------------------------
}

procedure TBibSearcher.CalculateTotalStringLengths(FileList: TObjectList);
var aAudioFile: TAudioFile;
    aLengthAdditional, aLengthMinimal: Integer;
    i: Integer;
begin
    fTotalStringLengthSetting   := 0;
    fTotalStringLengthMinimized := 0;

    if AccelerateSearch then
    begin
        for i := 0 to Filelist.Count - 1 do
        begin
            aAudioFile := TAudioFile(FileList[i]);
            aLengthMinimal := 4 + Length(Utf8Encode(AnsiLowerCase(aAudioFile.Artist)) {+ #1}
                                     + Utf8Encode(AnsiLowerCase(aAudioFile.Titel)) {+ #1}
                                     + Utf8Encode(AnsiLowerCase(aAudioFile.Album)) {+ #13#10});

            aLengthAdditional := 0;
            if AccelerateSearchIncludePath then
                aLengthAdditional := 1 + aLengthAdditional
                                       + length({#1 + }Utf8Encode(AnsiLowerCase(aAudioFile.Pfad)));
            if AccelerateSearchIncludeComment then
                aLengthAdditional := 1 + aLengthAdditional
                                       + length({#1 + }Utf8Encode(AnsiLowerCase(aAudioFile.Comment)));

            fTotalStringLengthSetting   := fTotalStringLengthSetting + aLengthMinimal + aLengthAdditional;
            fTotalStringLengthMinimized := fTotalStringLengthMinimized + aLengthMinimal;
        end;
    end;
end;

procedure TBibSearcher.CalculateLyricStringLengths(FileList: TObjectList);
var aAudioFile: TAudioFile;
    i: Integer;
begin
    fLyricStringLength := 0;
    if AccelerateLyricSearch then
    begin
        for i := 0 to Filelist.Count - 1 do
        begin
            aAudioFile := TAudioFile(FileList[i]);
            fLyricStringLength := fLyricStringLength
                         + 2 + Length( Utf8Encode(AnsiLowerCase(UTF8ToString(aAudioFile.Lyrics)))) {+ #13#10};
        end;
    end;
end;

procedure TBibSearcher.BuildTotalString(FileList: TObjectList);
var aAudioFile: TAudioFile;
    i, currentPos, maxLength: Integer;
    currentAudioString: UTF8String;
    BuildSettings, BuildAtAll: Boolean;
begin
    if AccelerateSearch then
    begin
        // first: calculate the necessary length, two possible variations:
        // fTotalStringLengthSetting
        // fTotalStringLengthMinimized
        // SendMessage(MainWindowHandle, WM_MedienBib, MB_OutOfMemory, LParam(PWideChar('Calculating ... ')));

        CalculateTotalStringLengths(FileList);
        // clear current string
        TotalString := '';

        //SendMessage(MainWindowHandle, WM_MedienBib, MB_OutOfMemory, LParam(PWideChar(' ... ' + IntToStr(fTotalStringLengthSetting))));

        BuildSettings := True;
        BuildAtAll := True;
        try
            SetLength(TotalString, fTotalStringLengthSetting + 1);
        except
            on EOutOfMemory do
            begin
                BuildSettings := False;
                SendMessage(MainWindowHandle, WM_MedienBib, MB_OutOfMemory, LParam(OutOfMemory_DataReduced));
            end;
        end;

        if NOT BuildSettings then
        // try again
        try
            SetLength(TotalString, fTotalStringLengthMinimized + 1);
        except
            on EOutOfMemory do
            begin
                TotalString := '';
                BuildAtAll := False;
                SendMessage(MainWindowHandle, WM_MedienBib, MB_OutOfMemory, LParam(OutOfMemory_DataDisabled));
            end;
        end;

        //SendMessage(MainWindowHandle, WM_MedienBib, MB_OutOfMemory, LParam(PWideChar('Length ' + IntToStr(Length(TotalString)))));

        if BuildAtall then
        begin
            Setlength(TotalStringIndizes, FileList.Count);
            maxLength := Length(TotalString);
            currentPos := 1;
            for i := 0 to FileList.Count-1 do
            begin
                TotalStringIndizes[i] := currentPos - 1; //before: Length(TotalString);

                aAudioFile := TAudioFile(FileList[i]);
                currentAudioString :=
                               Utf8Encode(AnsiLowerCase(aAudioFile.Artist)) + #1
                             + Utf8Encode(AnsiLowerCase(aAudioFile.Titel)) + #1
                             + Utf8Encode(AnsiLowerCase(aAudioFile.Album));
                if AccelerateSearchIncludePath and BuildSettings then
                    currentAudioString := currentAudioString + #1
                                + Utf8Encode(AnsiLowerCase(aAudioFile.Pfad));
                if AccelerateSearchIncludeComment and BuildSettings then
                    currentAudioString := currentAudioString + #1
                                + Utf8Encode(AnsiLowerCase(aAudioFile.Comment));
                currentAudioString := currentAudioString + #13#10;

                if currentPos + length(currentAudioString) <= maxLength then
                begin
                    move(currentAudioString[1], TotalString[currentPos], length(currentAudioString) );
                    inc(currentPos, length(currentAudioString));
                end else
                    // This Should NEVER happen!!
                    SendMessage(MainWindowHandle, WM_MedienBib, MB_OutOfMemory,
                        LParam(OutOfMemory_ErrorBuildingDataString));
            end;

            //SendMessage(MainWindowHandle, WM_MedienBib, MB_MessageForDialog, LParam(PWideChar('Length (fertig) ' + ':' + IntToStr(Length(TotalString)))));
        end else
        begin
            TotalString := '';
            Setlength(TotalStringIndizes, 0);
        end;
    end else
    begin
        TotalString := '';
        Setlength(TotalStringIndizes, 0);
    end;


end;
procedure TBibSearcher.BuildTotalLyricString(FileList: TObjectList);
var aAudioFile: TAudioFile;
    i, currentPos, maxLength: Integer;
    currentAudioString: UTF8String;
    BuildAtAll: Boolean;
begin
    if AccelerateLyricSearch then
    begin
        CalculateLyricStringLengths(FileList);
        TotalLyricString := '';
        BuildAtAll := True;

        try
            SetLength(TotalLyricString, fLyricStringLength + 1);
        except
            on EOutOfMemory do
            begin
                TotalLyricString := '';
                BuildAtAll := False;
                SendMessage(MainWindowHandle, WM_MedienBib, MB_OutOfMemory, LParam(OutOfMemory_LyricsDisabled));
            end;
        end;

        if BuildAtAll then
        begin
            Setlength(TotalLyricStringIndizes, FileList.Count);
            maxLength := Length(TotalLyricString);
            currentPos := 1;

            for i := 0 to FileList.Count-1 do
            begin
                TotalLyricStringIndizes[i] := currentPos - 1;
                aAudioFile := TAudioFile(FileList[i]);
                currentAudioString := Utf8Encode(AnsiLowerCase(UTF8ToString(aAudioFile.Lyrics))) + #13#10;

                if currentPos + length(currentAudioString) <= maxLength then
                begin
                    move(currentAudioString[1], TotalLyricString[currentPos], length(currentAudioString) );
                    inc(currentPos, length(currentAudioString));
                end else
                    // This Should NEVER happen!!
                    SendMessage(MainWindowHandle, WM_MedienBib, MB_OutOfMemory,
                        LParam(OutOfMemory_ErrorBuildingLyricString));
            end;
        end else
        begin
            TotalLyricString := '';
            Setlength(TotalLyricStringIndizes, 0);
        end;
    end else
    begin
        TotalLyricString := '';
        Setlength(TotalLyricStringIndizes, 0);
    end;
end;

procedure TBibSearcher.ClearTotalLyricString;
begin
    AccelerateLyricSearch := False;
    TotalLyricString := '';
    Setlength(TotalLyricStringIndizes, 0);
end;

{
    --------------------------------------------------------
    SwapTotalStrings
    Swap the total strings
    Executed in the final part of an update-process
    runs in VCL-Mainthread
    --------------------------------------------------------
}
procedure TBibSearcher.SwapTotalStrings(FileList: TObjectList);
begin

    BuildTotalString(FileList);
    BuildTotalLyricString(FileList);

    {
    exit;

  if AccelerateSearch then
  begin
      // copy the indizes
      setlength(TotalStringIndizes, length(TmpTotalStringIndizes));
      for i := 0 to Length(TotalStringIndizes) - 1 do
          TotalStringIndizes[i] := TmpTotalStringIndizes[i];
      setlength(TmpTotalStringIndizes, 0);
      // swapString. Old TotalString should be cleared automatically
      // by compiler-magic and stuff
      TotalString := TmpTotalString;
  end else
  begin
      setlength(TotalStringIndizes, 0);
      setlength(TmpTotalStringIndizes, 0);
      TotalString := '';
      TmpTotalString := '';
  end;
  // the same for the lyrics
  if AccelerateLyricSearch then
  begin
      setlength(TotalLyricStringIndizes, length(TmpTotalLyricStringIndizes));
      for i := 0 to Length(TotalLyricStringIndizes) - 1 do
        TotalLyricStringIndizes[i] := TmpTotalLyricStringIndizes[i];
      setlength(TmpTotalLyricStringIndizes, 0);
      TotalLyricString := TmpTotalLyricString;
  end else
  begin
      setlength(TotalLyricStringIndizes, 0);
      setlength(TmpTotalLyricStringIndizes, 0);
      TotalLyricString := '';
      TmpTotalLyricString := '';
  end;
  }

end;


{
    --------------------------------------------------------
    IsOK
    IsOKApprox
    AnsiContainsText returns False on an empty substring
    We need True here
    --------------------------------------------------------
}
function TBibSearcher.IsOK(substr: UnicodeString; str: UnicodeString):boolean;
begin
    result := (substr = '') or (AnsiContainsText(str, substr))
end;
function TBibSearcher.IsOKNoSubStrings(substr:UnicodeString; str: UnicodeString):boolean;
begin
    // Exact matching, used for doubleClick on Labels
    result := (substr = '') or AnsiSameText(substr, str)
end;

function TBibSearcher.IsOKApprox(substr:UTF8String; str: UnicodeString):boolean;
begin
    result := (substr = '') or (SearchDP(UTF8Encode(AnsiLowerCase(str)), substr, Length(substr) Div 4) > 0)
end;

{
    --------------------------------------------------------
    CheckGenre
    CheckYear
    Check whether a Genrestring/Year matches the settings
    of the search
    --------------------------------------------------------
}

function TBibSearcher.CheckGenre(Genre: UnicodeString):boolean;
var GenreIDX: Integer;
begin
  if SearchOptions.SkipGenreCheck then
      result := true
  else
  begin
      GenreIDX := SearchOptions.GenreStrings.IndexOf(Genre);
      if GenreIDX > -1 then
          result := SearchOptions.GenreChecked[GenreIDX]
      else
          result := SearchOptions.IncludeNAGenres;
  end;
end;
function TBibSearcher.CheckYear(Year: UnicodeString):boolean;
var intYear:integer;
begin
  if SearchOptions.SkipYearCheck then
      result := True
  else
  try
      intYear := strtointdef(Year,-1);
      {before - after - exact}
      case SearchOptions.WhichYearCheck of
        0: result := intYear <= SearchOptions.MinMaxYear;
        1: result := intYear >= SearchOptions.MinMaxYear;
      else
        result := intYear = SearchOptions.MinMaxYear;
      end;
      if (SearchOptions.Include0Year) AND (intYear=0) then
        result := True;
    except
      result := SearchOptions.IncludeNAYear;
    end;
end;

{
    --------------------------------------------------------
    AudioFileMatchesCompleteKeywords
    AudioFileMatchesCompleteKeywordsApprox
    Check whether the audiofile matches the keywords
    (keywords here means separated by fields)
    AudioFileMatchesCompleteKeywordsNoSubStrings: Exact matching, used for doubleClick on Labels
    --------------------------------------------------------
}
function TBibSearcher.AudioFileMatchesCompleteKeywords(aAudioFile: TAudioFile; Keywords: TSearchKeywords): Boolean;
begin
  result := IsOk(Keywords.Artist, aAudioFile.Artist)
          AND IsOk(Keywords.Titel, aAudioFile.Titel)
          AND IsOk(Keywords.Album, aAudioFile.Album)
          AND IsOk(Keywords.Pfad, aAudioFile.Pfad)
          AND IsOk(Keywords.Kommentar, aAudioFile.Comment)
          AND CheckGenre(aAudioFile.Genre)
          AND CheckYear(aAudioFile.Year)
          AND (
               (trim(Keywords.Lyric) = '')
            or (AnsiContainsText(UTF8ToString(aAudioFile.Lyrics), Keywords.Lyric)))
          AND (
               (trim(Keywords.General) = '')
            or (AnsiContainsText(aAudioFile.Pfad      , Keywords.General))
            or (AnsiContainsText(aAudioFile.Artist    , Keywords.General))
            or (AnsiContainsText(aAudioFile.Album     , Keywords.General))
            or (AnsiContainsText(aAudioFile.Titel     , Keywords.General))
            or (AnsiContainsText(aAudioFile.Comment   , Keywords.General))
            or (AnsiContainsText(UTF8ToString(aAudioFile.Lyrics), Keywords.General))
          );
end;

function TBibSearcher.AudioFileMatchesCompleteKeywordsNoSubStrings(aAudioFile: TAudioFile; Keywords: TSearchKeywords): Boolean;
begin
    result := IsOKNoSubStrings(Keywords.Artist, aAudioFile.Artist)
          AND IsOKNoSubStrings(Keywords.Titel, aAudioFile.Titel)
          AND IsOKNoSubStrings(Keywords.Album, aAudioFile.Album)
          AND IsOKNoSubStrings(Keywords.Pfad, aAudioFile.Pfad)
          AND IsOKNoSubStrings(Keywords.Kommentar, aAudioFile.Comment)
          AND CheckGenre(aAudioFile.Genre)
          AND CheckYear(aAudioFile.Year);
end;


function TBibSearcher.AudioFileMatchesCompleteKeywordsApprox(aAudioFile: TAudioFile; Keywords: TUTF8SearchKeywords): Boolean;
begin
    result := IsOKApprox(Keywords.Artist, aAudioFile.Artist)
          AND IsOKApprox(Keywords.Titel,  aAudioFile.Titel )
          AND IsOKApprox(Keywords.Album,  aAudioFile.Album )
          AND IsOKApprox(Keywords.Kommentar, aAudioFile.Comment)
          And ((Keywords.Pfad = '') or (SearchDP(UTF8Encode(AnsiLowerCase(aAudioFile.Pfad)), Keywords.Pfad, Length(Keywords.Pfad) Div 4) > 0))
          AND CheckGenre(aAudioFile.Genre)
          AND CheckYear(aAudioFile.Year)
          AND (
               (trim(String(Keywords.Lyric)) = '')
            or (SearchDP(UTF8Encode(AnsiLowerCase(UTF8ToString(aAudioFile.Lyrics))),
            Keywords.Lyric,  length(Keywords.Lyric) Div 4) > 0)
          )
          AND (
               (trim(String(Keywords.General)) = '')
            or (SearchDP(UTF8Encode(AnsiLowerCase(aAudioFile.Pfad)),   Keywords.General,  length(Keywords.General) Div 4) > 0)
            or (SearchDP(UTF8Encode(AnsiLowerCase(aAudioFile.Artist)), Keywords.General,  length(Keywords.General) Div 4) > 0)
            or (SearchDP(UTF8Encode(AnsiLowerCase(aAudioFile.Titel)),  Keywords.General,  length(Keywords.General) Div 4) > 0)
            or (SearchDP(UTF8Encode(AnsiLowerCase(aAudioFile.Album)),  Keywords.General,  length(Keywords.General) Div 4) > 0)
            or (SearchDP(UTF8Encode(AnsiLowerCase(aAudioFile.Comment)),Keywords.General,  length(Keywords.General) Div 4) > 0)
            or (SearchDP(UTF8Encode(AnsiLowerCase(UTF8ToString(aAudioFile.Lyrics))),
                Keywords.General,  length(Keywords.General) Div 4) > 0)
          );
end;


{
    --------------------------------------------------------
    ShowSearchResults
    Shows the aIndex-th Searchresult in VST
    called from OnChange-Event of History-Combobox
    also set this List as the quicksearchlist
    --------------------------------------------------------
}
procedure TBibSearcher.ShowSearchResults(aIndex: Integer);
begin
    fDummyAudioFile.Titel := MainForm_NoSearchresults;
    if (aIndex >=1) and (aIndex <= 10) then
    begin
        CurrentList := SearchResultLists[aIndex];
        SendMessage(MainWindowHandle, WM_MedienBib, MB_ShowSearchResults, lParam(SearchResultLists[aIndex]));
    end
    else
    begin
        CurrentList := SearchResultLists[1];
        SendMessage(MainWindowHandle, WM_MedienBib, MB_ShowSearchResults, lParam(SearchResultLists[1]));
    end;

end;

{
    --------------------------------------------------------
    GenerateKeywordList
    Cut a Edit.Text into several words
    Used only by QuickSearch atm
    --------------------------------------------------------
}
function TBibSearcher.GenerateKeywordList(aKeyword: UnicodeString): TStringList;
begin
  result := ExplodeWithQuoteMarks(' ', aKeyword);
end;

{
    --------------------------------------------------------
    InitNewSearch
    InitBetterSearch
    initialize a search:
      - shifts the previous searchresults/Keywords
      - Set the new Searchkeywords
      - Set CurrentList (which will be used for new searchresults)
    --------------------------------------------------------
}
procedure TBibSearcher.InitNewSearch(Keywords: TSearchKeyWords);
var i,l:integer;
begin
    for i:=9 downto 1 do
    begin
        SearchResultLists[i+1].Clear;
        for l:=0 to SearchResultLists[i].Count-1 do
            SearchResultLists[i+1].Add(SearchResultLists[i][l]);
        SearchKeyWords[i+1].General:= SearchKeyWords[i].General;
        SearchKeyWords[i+1].Artist   := SearchKeyWords[i].Artist;
        SearchKeyWords[i+1].Titel    := SearchKeyWords[i].Titel;
        SearchKeyWords[i+1].Album    := SearchKeyWords[i].Album;
        SearchKeyWords[i+1].Kommentar:= SearchKeyWords[i].Kommentar;
        SearchKeyWords[i+1].Mode     := SearchKeyWords[i].Mode;
        SearchKeyWords[i+1].Lyric    := SearchKeyWords[i].Lyric;
        SearchKeyWords[i+1].ComboBoxString := SearchKeyWords[i].ComboBoxString;
    end;
    SearchResultLists[1].Clear;
    SearchKeyWords[1].General        := Keywords.General       ;
    SearchKeyWords[1].Titel          := Keywords.Titel         ;
    SearchKeyWords[1].Artist         := Keywords.Artist        ;
    SearchKeyWords[1].Kommentar      := Keywords.Kommentar     ;
    SearchKeyWords[1].Album          := Keywords.Album         ;
    SearchKeyWords[1].Lyric          := Keywords.Lyric         ;
    SearchKeyWords[1].ComboBoxString := Keywords.ComboBoxString;

    CurrentList := SearchResultLists[1];
    // Show empty CurrentList in MainForm
    fDummyAudioFile.Titel := MainForm_NoSearchresults; // ???
    SendMessage(MainWindowHandle, WM_MedienBib, MB_ShowSearchResults, lParam(CurrentList));
end;


{
    --------------------------------------------------------
    GlobalQuickSearch
    performs a quick search on the library
    the searchstring is splitted into several words
    (so a search for a mix from artists and titles is possible)
    Algorithm:
      * exact search
        - search longest word via Boyer-Moore-Horspool on TotalString
        - verify match
      * apprixmate search
        - search longest word via dynamic programming (levenshtein-distance) on TotalString
        - verify match
      * no acceleration available
        - test every audiofile
    --------------------------------------------------------
}
procedure TBibSearcher.GlobalQuickSearch(Keyword: UnicodeString; AllowErr: Boolean);
var i, lmax: integer;
    Keywords: TStringList;
    KeywordsUTF8: TUTF8StringList;
    UTF8Keyword: UTF8String;
    OnlyOneWord: Boolean;
    // for Horspool/dynamic programming
    k: Integer;
    BC, A: TBC_IntArray;
    // search borders for binary search
    // note: Not really used here. It could increase the searchspeed
    //       as the search-interval could theoretically be reduced piece by piece,
    //       but this here ist fast enough already :D
    searchL, searchR: Integer;
    // Index of the next audiofile for detailed testing
    NewIdx: Integer;
    // tmpList stores the Not exact matching files, for a sorted result
    // (exact matchings first)
    tmpList //// , tmpList2
    : TObjectlist;
begin

  Keywords := GenerateKeywordList(keyword);
  OnlyOneWord := Keywords.Count = 1;
  searchL := 0;
  searchR := length(TotalStringIndizes) - 1;

  SetLength(KeywordsUTF8, Keywords.Count);
  for i := 0 to Keywords.Count - 1 do
      KeywordsUTF8[i] := UTF8Encode(AnsiLowerCase(Keywords[i]));

  // Get the longest keyword
  // Note: Boyer-Moore-Horspool is (much) faster on (much) longer search-patterns.
  //       Dynamic-programming is slower on longer searchpatterns, but shorter
  //       ones will cause many false positives
  UTF8Keyword := GetLongestUTF8String(Keywords);
  lmax := length(UTF8Keyword);

  QuickSearchResults.Clear;

  if lmax > 0 then
  begin
      if AllowErr then
      begin
            tmpList  := TObjectlist.Create(False);
            if AccelerateSearch then
            begin
                k := 0;
                // Preprocessing for dynamic programming
                A := PreProcess_FilterCount(UTF8Keyword);

                while k + lmax < Length(TotalString) do
                begin
                    k := SearchFilterCountDP(TotalString, UTF8Keyword, (lmax Div 4), k, A);
                    if k = 0 then break;

                    NewIdx := BinIntSearch(TotalStringIndizes, k, searchL, searchR);
                    // Probably binary search will NOT find k in the indizes-array
                    // it will return randomly the next smaller or bigger index.
                    // we need always the smaller one.
                    if TotalStringIndizes[NewIdx] > k then
                        if NewIdx > 0 then dec(NewIdx);

                    // Check whether audiofile really matches the keywords
                    if AudioFileMatchesKeywords(TAudioFile(MainList[NewIdx]), Keywords) then
                        QuickSearchResults.Add(TAudioFile(MainList[NewIdx]))
                    else
                        if AudioFileMatchesKeywordsApprox(TAudioFile(MainList[NewIdx]), KeywordsUTF8) then
                            tmpList.Add(TAudioFile(MainList[NewIdx]));

                    // continue with next audiofile
                    if NewIdx < length(TotalStringIndizes) - 1 then
                        k := TotalStringIndizes[NewIdx + 1]
                    else
                        k := length(TotalString) + 1;
                end;
            end else
            begin
                // No acceleration. :(
                // Check every single object
                for i := 0 to MainList.Count - 1 do
                begin
                    // Add File to first List
                    if AudioFileMatchesKeywords(TAudioFile(MainList[i]), Keywords) then
                        QuickSearchResults.Add(TAudioFile(MainList[i]))
                    else
                        if AudioFileMatchesKeywordsApprox(TAudioFile(MainList[i]), KeywordsUTF8) then
                            tmpList.Add(TAudioFile(MainList[i]));
                end;
            end;
            // Exact matchings first, matchings with errors afterwards.
            for i := 0 to tmpList.Count - 1 do
                QuickSearchResults.Add(tmpList[i]);

            tmpList.Free;
      end else
      begin
            // no errors allowed, exact matching
            if AccelerateSearch then
            begin
                k := 0;
                // preprocessing for Boyer-Moore-Horspool
                BC := PreProcess_BMH_BC(UTF8Keyword);

                while k + lmax < Length(TotalString) do
                begin
                    k := BoyerMooreHorspoolEx(TotalString, UTF8Keyword, k, BC);
                    if k = 0 then break;
                    // ... just the same idea as in the first part
                    NewIdx := BinIntSearch(TotalStringIndizes, k, searchL, searchR);
                    if TotalStringIndizes[NewIdx] > k then
                        if NewIdx > 0 then dec(NewIdx);

                    if OnlyOneWord or (AudioFileMatchesKeywords(TAudioFile(MainList[NewIdx]), Keywords)) then
                        QuickSearchResults.Add(TAudioFile(MainList[NewIdx]));

                    if NewIdx < length(TotalStringIndizes) - 1 then
                        k := TotalStringIndizes[NewIdx + 1]
                    else
                        k := length(TotalString) + 1;
                end;
            end else
            begin
                for i := 0 to MainList.Count - 1 do
                    if (AudioFileMatchesKeywords(TAudioFile(MainList[i]), Keywords)) then
                        QuickSearchResults.Add(TAudioFile(MainList[i]));
            end;
      end;
  end;
  fDummyAudioFile.Titel := MainForm_NoSearchresults;
  SendMessage(MainWindowHandle, WM_MedienBib, MB_ShowQuickSearchResults, lParam(QuickSearchResults));
  Keywords.Free;
end;

procedure TBibSearcher.GlobalQuickTagSearch(KeyTag: UnicodeString);
var i: Integer;
    aAudioFile: TAudioFile;
    tmpTagList: TStringList;
begin
    // we need only one list here
    QuickSearchResults.Clear;

    tmpTagList := TStringList.Create;
    try
        for i := 0 to MainList.Count - 1 do
        begin
            aAudioFile := TAudioFile(MainList[i]);
            if AnsiContainsText(aAudioFile.RawTagLastFM      , KeyTag) then
            begin
                // audiofile is possibly tagged with the KeyTag
                tmpTagList.Text := String(aAudioFile.RawTagLastFM);
                if tmpTagList.IndexOf(KeyTag) > -1 then
                    QuickSearchResults.Add(aAudioFile);
            end;
        end;
    finally
        tmpTagList.Free;
    end;

    // show search results
    fDummyAudioFile.Titel := MainForm_NoSearchresults;
    SendMessage(MainWindowHandle, WM_MedienBib, MB_ShowSearchResults, lParam(QuickSearchResults));
end;



{
    --------------------------------------------------------
    IPCQuickSearch
    performs a quick search on the library
    similar to GlobalQuickSearch, but less options
    * always errors allowed
    * no "current view"
    --------------------------------------------------------
}
procedure TBibSearcher.IPCQuickSearch(Keyword: UnicodeString);
var i, lmax: integer;
    Keywords: TStringList;
    KeywordsUTF8: TUTF8StringList;
    UTF8Keyword: UTF8String;
    //OnlyOneWord: Boolean;
    // for Horspool/dynamic programming
    k: Integer;
    A: TBC_IntArray;
    // search borders for binary search
    // note: Not really used here. It could increase the searchspeed
    //       as the search-interval could theoretically be reduced piece by piece,
    //       but this here ist fast enough already :D
    searchL, searchR: Integer;
    // Index of the next audiofile for detailed testing
    NewIdx: Integer;
    // tmpList stores the Not exact matching files, for a sorted result
    // (exact matchings first)
    tmpList: TObjectlist;
begin
  fIPCSearchIsRunning := True;

  Keywords := GenerateKeywordList(keyword);
  //OnlyOneWord := Keywords.Count = 1;
  searchL := 0;
  searchR := length(TotalStringIndizes) - 1;

  SetLength(KeywordsUTF8, Keywords.Count);
  for i := 0 to Keywords.Count - 1 do
      KeywordsUTF8[i] := UTF8Encode(AnsiLowerCase(Keywords[i]));

  // Get the longest keyword
  // Note: Boyer-Moore-Horspool is (much) faster on (much) longer search-patterns.
  //       Dynamic-programming is slower on longer searchpatterns, but shorter
  //       ones will cause many false positives
  UTF8Keyword := GetLongestUTF8String(Keywords);
  lmax := length(UTF8Keyword);

  IPCSearchResults.clear;

  if lmax > 0 then
  begin
            tmpList  := TObjectlist.Create(False);
            if AccelerateSearch then
            begin
                k := 0;
                // Preprocessing for dynamic programming
                A := PreProcess_FilterCount(UTF8Keyword);

                while k + lmax < Length(TotalString) do
                begin
                    k := SearchFilterCountDP(TotalString, UTF8Keyword, (lmax Div 4), k, A);
                    if k = 0 then break;

                    NewIdx := BinIntSearch(TotalStringIndizes, k, searchL, searchR);
                    // Probably binary search will NOT find k in the indizes-array
                    // it will return randomly the next smaller or bigger index.
                    // we need always the smaller one.
                    if TotalStringIndizes[NewIdx] > k then
                        if NewIdx > 0 then dec(NewIdx);

                    // Check whether audiofile really matches the keywords
                    if AudioFileMatchesKeywords(TAudioFile(MainList[NewIdx]), Keywords) then
                        IPCSearchResults.Add(TAudioFile(MainList[NewIdx]))
                    else
                        if AudioFileMatchesKeywordsApprox(TAudioFile(MainList[NewIdx]), KeywordsUTF8) then
                            tmpList.Add(TAudioFile(MainList[NewIdx]));

                    // continue with next audiofile
                    if NewIdx < length(TotalStringIndizes) - 1 then
                        k := TotalStringIndizes[NewIdx + 1]
                    else
                        k := length(TotalString) + 1;
                end;
            end else
            begin
                // No acceleration. :(
                // Check every single object
                for i := 0 to MainList.Count - 1 do
                begin
                    if AudioFileMatchesKeywords(TAudioFile(MainList[i]), Keywords) then
                        IPCSearchResults.Add(TAudioFile(MainList[i]))
                    else
                        if AudioFileMatchesKeywordsApprox(TAudioFile(MainList[i]), KeywordsUTF8) then
                            tmpList.Add(TAudioFile(MainList[i]));
                end;
            end;
            // Exact matchings first, matchings with errors afterwards.
            for i := 0 to tmpList.Count - 1 do
                IPCSearchResults.Add(tmpList[i]);

            tmpList.Free;
  end;

  // Copy SearchResults to VCL-Lists
  //SendMessage(MainWindowHandle, WM_MedienBib, MB_GetQuickSearchResults, lParam(QuickSearchResults));
  //SendMessage(MainWindowHandle, WM_MedienBib, MB_GetAdditionalQuickSearchResults, lParam(QuickSearchAdditionalResults));
  // Show search results.
  //SendMessage(MainWindowHandle, WM_MedienBib, MB_ShowQuickSearchResults, lParam(fDummyAudioFile));

  Keywords.Free;
  fIPCSearchIsRunning := False;
end;


{
    --------------------------------------------------------
    SearchFuzzy
    Search the library with allowing errors
    Further comments: See QuickSearch-method
    --------------------------------------------------------
}
procedure TBibSearcher.SearchFuzzy(Searchmode: Integer; UTF8LongestKeyword: UTF8String; KeyWords: TSearchKeyWords; UTF8SearchKeyWords: TUTF8SearchKeyWords);
var
    // "local" TotalString - TotalString or TotalLyricString
    LocalTotalString: UTF8String;
    LocalStringIndizes: TIntArray;
    k, i, lmax: Integer;
    NewIdx, searchL, searchR: Integer;
    A: TBC_IntArray;
    tmpList: TObjectlist;
begin
    lMax := length(UTF8LongestKeyword);

    if SearchMode = smQuick then
    begin
        LocalTotalString := TotalString;
        LocalStringIndizes := TotalStringIndizes;
    end else
    begin
        LocalTotalString := TotalLyricString;
        LocalStringIndizes := TotalLyricStringIndizes;
    end;

    searchL := 0;
    searchR := length(LocalStringIndizes) - 1;

    tmpList := TObjectlist.Create(False);
    try
        if SearchMode = smSlow then
        begin
            // No quicker search available
            // Check every single Audiofile
            for i := 0 to MainList.Count - 1 do
                begin
                    if AudioFileMatchesCompleteKeywords(TAudioFile(MainList[i]), Keywords) then
                        CurrentList.Add(TAudioFile(MainList[i]))
                    else
                        if AudioFileMatchesCompleteKeywordsApprox(TAudioFile(MainList[i]), UTF8SearchKeywords) then
                            tmpList.Add(TAudioFile(MainList[i]));
                end;
        end else
        begin
            k := 0;
            A := PreProcess_FilterCount(UTF8LongestKeyword);
            while k + lmax < Length(LocalTotalString) do
            begin
                k := SearchFilterCountDP(LocalTotalString, UTF8LongestKeyword, (lmax Div 4), k, A);

                if k = 0 then break;
                NewIdx := BinIntSearch(LocalStringIndizes, k, searchL, searchR);

                if LocalStringIndizes[NewIdx] > k then
                    if NewIdx > 0 then dec(NewIdx);

                if AudioFileMatchesCompleteKeywords(TAudioFile(MainList[NewIdx]), Keywords) then
                    CurrentList.Add(TAudioFile(MainList[NewIdx]))
                else
                    if AudioFileMatchesCompleteKeywordsApprox(TAudioFile(MainList[NewIdx]), UTF8SearchKeywords) then
                        tmpList.Add(TAudioFile(MainList[NewIdx]));

                if NewIdx < length(LocalStringIndizes) - 1 then
                    k := LocalStringIndizes[NewIdx + 1]
                else
                    k := length(LocalTotalString) + 1;
            end;
        end;
        for i := 0 to tmpList.Count - 1 do
            CurrentList.Add(tmpList[i]);
    finally
        tmpList.Free;
    end;
end;

{
    --------------------------------------------------------
    SearchExact
    Search the library without allowing errors
    Further comments: See QuickSearch-method
    --------------------------------------------------------
}
procedure TBibSearcher.SearchExact(Searchmode: Integer; UTF8LongestKeyword: UTF8String; KeyWords: TSearchKeyWords; UTF8SearchKeyWords: TUTF8SearchKeyWords);
var
    LocalTotalString: UTF8String;
    LocalStringIndizes: TIntArray;
    k, i, lmax: Integer;
    searchL, searchR, NewIdx: Integer;
    BC: TBC_IntArray;
begin
    lMax := length(UTF8LongestKeyword);


    if SearchMode = smQuick then
    begin
        LocalTotalString := TotalString;
        LocalStringIndizes := TotalStringIndizes;
    end else
    begin
        LocalTotalString := TotalLyricString;
        LocalStringIndizes := TotalLyricStringIndizes;
    end;

    searchL := 0;
    searchR := length(LocalStringIndizes) - 1;

    if SearchMode = smSlow then
    begin
        for i := 0 to MainList.Count - 1 do
        begin
            if AudioFileMatchesCompleteKeywords(TAudioFile(MainList[i]), Keywords) then
                CurrentList.Add(TAudioFile(MainList[i]));
        end;
    end else
    begin
        k := 0;
        BC := PreProcess_BMH_BC(UTF8LongestKeyword);
        while k + lmax < Length(LocalTotalString) do
        begin
            k := BoyerMooreHorspoolEx(LocalTotalString, UTF8LongestKeyword, k, BC);

            if k = 0 then break;
            NewIdx := BinIntSearch(LocalStringIndizes, k, searchL, searchR);
            if LocalStringIndizes[NewIdx] > k then
                if NewIdx > 0 then dec(NewIdx);

            if AudioFileMatchesCompleteKeywords(TAudioFile(MainList[NewIdx]), Keywords) then
                CurrentList.Add(TAudioFile(MainList[NewIdx]));

            if NewIdx < length(LocalStringIndizes) - 1 then
                k := LocalStringIndizes[NewIdx + 1]
            else
                k := length(LocalTotalString) + 1;
        end;
    end;
end;


{
    --------------------------------------------------------
    CompleteSearch
    Do the searching!
    SearchMode: Depending on the keywords and acceleration-settings
                use a quicker search using one of the TotalStrings
    --------------------------------------------------------
}
procedure TBibSearcher.CompleteSearch(Keywords: TSearchKeyWords);
var
    UTF8SearchKeywords: TUTF8SearchKeywords;
    UTF8LongestKeyword: UTF8String;
    // Searchmode (smQuick, smQuickLyric or smSlow)
    SearchMode: Integer;
begin
    UTF8SearchKeywords.General  := Utf8Encode(AnsiLowerCase(Keywords.General  ));
    UTF8SearchKeywords.Artist   := Utf8Encode(AnsiLowerCase(Keywords.Artist   ));
    UTF8SearchKeywords.Titel    := Utf8Encode(AnsiLowerCase(Keywords.Titel    ));
    UTF8SearchKeywords.Album    := Utf8Encode(AnsiLowerCase(Keywords.Album    ));
    UTF8SearchKeywords.Pfad     := Utf8Encode(AnsiLowerCase(Keywords.Pfad     ));
    UTF8SearchKeywords.Kommentar:= Utf8Encode(AnsiLowerCase(Keywords.Kommentar));
    UTF8SearchKeywords.Lyric    := Utf8Encode(AnsiLowerCase(Keywords.Lyric  ));

    Searchmode := smSlow;
    UTF8LongestKeyword := '';
    if AccelerateSearch then
    begin
        UTF8LongestKeyword := UTF8SearchKeywords.Artist;
        if Length(UTF8SearchKeywords.Titel) > length(UTF8LongestKeyword) then
            UTF8LongestKeyword := UTF8SearchKeywords.Titel;
        if Length(UTF8SearchKeywords.Album) > length(UTF8LongestKeyword) then
            UTF8LongestKeyword := UTF8SearchKeywords.Album;

        if AccelerateSearchIncludePath
           AND (Length(UTF8SearchKeywords.Pfad) > length(UTF8LongestKeyword)) then
            UTF8LongestKeyword := UTF8SearchKeywords.Pfad;
        if AccelerateSearchIncludeComment
           AND (Length(UTF8SearchKeywords.Kommentar) > length(UTF8LongestKeyword)) then
            UTF8LongestKeyword := UTF8SearchKeywords.Kommentar;
        if length(UTF8LongestKeyword) > 1 then
        begin
            SearchMode := smQuick;
        end;
    end;

    if AccelerateLyricSearch then
    begin
        if Length(UTF8SearchKeywords.Lyric) > length(UTF8LongestKeyword) then
        begin
            UTF8LongestKeyword := UTF8SearchKeywords.Lyric;
            if length(UTF8LongestKeyword) > 1 then
            begin
                SearchMode := smQuickLyric;
            end;
        end;
    end;

    // passende AudioFiles suchen
    if SearchOptions.AllowErrors then
        // approximate search
        SearchFuzzy(SearchMode, UTF8LongestKeyword, KeyWords, UTF8SearchKeywords)
    else
        // exact search
        SearchExact(SearchMode, UTF8LongestKeyword, KeyWords, UTF8SearchKeywords);

    // show search results
    fDummyAudioFile.Titel := MainForm_NoSearchresults;
    SendMessage(MainWindowHandle, WM_MedienBib, MB_ShowSearchResults, lParam(CurrentList));
end;

// Exact matching, used for doubleClick on Labels
procedure TBibSearcher.CompleteSearchNoSubStrings(Keywords: TSearchKeyWords);
var i: Integer;
begin
    // we need only one list here
    QuickSearchResults.Clear;

    for i := 0 to MainList.Count - 1 do
        if AudioFileMatchesCompleteKeywordsNOSubStrings(TAudioFile(MainList[i]), Keywords) then
            QuickSearchResults.Add(TAudioFile(MainList[i]));

    // show search results
    fDummyAudioFile.Titel := MainForm_NoSearchresults;
    SendMessage(MainWindowHandle, WM_MedienBib, MB_ShowSearchResults, lParam(QuickSearchResults));
end;

{
    --------------------------------------------------------
    EmptySearch
    Search only for emtpy strings
    --------------------------------------------------------
}
procedure TBibSearcher.EmptySearch(Mode: Integer);
var tmpList: TObjectList;
    i: Integer;
begin
    tmpList := TObjectList.Create(False);
    try
        case Mode of
            1: begin // Title
                for i := 0 to MainList.Count - 1 do
                begin
                    if TAudioFile(MainList[i]).Titel = '' then
                        tmpList.Add(MainList[i]);
                end;
            end;
            2: begin // Artist
                for i := 0 to MainList.Count - 1 do
                begin
                    if TAudioFile(MainList[i]).Artist = '' then
                        tmpList.Add(MainList[i]);
                end;
            end;
            3: begin // Album
                for i := 0 to MainList.Count - 1 do
                begin
                    if TAudioFile(MainList[i]).Album = '' then
                        tmpList.Add(MainList[i]);
                end;
            end;
            42: begin
                for i := 0 to MainList.Count - 1 do
                begin
                    if (TAudioFile(MainList[i]).Album = '')
                      or (TAudioFile(MainList[i]).Artist = '')
                      or (TAudioFile(MainList[i]).Titel = '')
                    then
                        tmpList.Add(MainList[i]);
                end;
            end;
        end;

        fDummyAudioFile.Titel := MainForm_NoSearchresults;
        SendMessage(MainWindowHandle, WM_MedienBib, MB_ShowSearchResults, lParam(tmpList));
    finally
        tmpList.Free;
    end;
end;

procedure TBibSearcher.SearchMarker(aIndex: Byte);
var tmpList: TObjectList;
    i: Integer;
begin
    tmpList := TObjectList.Create(False);
    try
        if aIndex = 4 then
        begin
            // list all marked files
            for i := 0 to MainList.Count - 1 do
            begin
                if TAudioFile(MainList[i]).Favorite <> 0 then
                    tmpList.Add(MainList[i]);
            end;

        end else
        begin
            for i := 0 to MainList.Count - 1 do
            begin
                if TAudioFile(MainList[i]).Favorite = aIndex then
                    tmpList.Add(MainList[i]);
            end;
        end;

        fDummyAudioFile.Titel := MainForm_NoFavorites;
        SendMessage(MainWindowHandle, WM_MedienBib, MB_ShowFavorites, lParam(tmpList));
    finally
        tmpList.Free;
    end;
end;

end.
