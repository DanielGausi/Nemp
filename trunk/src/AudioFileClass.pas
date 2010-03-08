{

    Unit AudioFileClass

    Defines and implements the class TAudioFile
    One of the Basic-Units

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2009, Daniel Gaussmann
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

    Additional permissions

    If you modify this Program, or any covered work, by linking or combining it
    with
        - the bass.dll and it addons
          (including, but not limited to the bass_fx.dll)
        - MadExcept
        - DGL-OpenGL
        - FSPro Windows 7 Taskbar Components
    or a modified version of these libraries, the licensors of this Program
    grant you additional permission to convey the resulting work.

    ---------------------------------------------------------------
}


unit AudioFileClass;

interface

uses windows, classes, SysUtils, math, Contnrs, ComCtrls, forms, Mp3FileUtils,
  ID3v2Frames, ComObj, graphics, variants, ATL_WMAfile, ATL_FLACfile_ReadOnly,
  strUtils, md5, U_CharCode, Nemp_ConstantsAndTypes, Hilfsfunktionen, Inifiles;

type

    // Class TTag: Used for the TagCloud
    TTag = class
      private
          // The key of the tag, e.g. 'Pop', 'really great song', '80s', ...
          fKey: UTF8String;

          //
          fBreadCrumbIndex: Integer;
          fIsAutoTag: Boolean;

          function GetCount: Integer;
      public
          // Stores all AudioFiles with this Tag.
          AudioFiles: TObjectList;
          // The number of AudioFiles tagged with this Tag.
          property count: Integer read GetCount;
          property Key: UTF8String read fKey;
          property IsAutoTag: Boolean read fIsAutoTag write fIsAutoTag;

          property BreadCrumbIndex: Integer read fBreadCrumbIndex write fBreadCrumbIndex;
          constructor Create(aKey: UTF8String);
          destructor Destroy; override;
    end;



    TAudioFile = class
    private
        // some properties
        // read it from ID3- or other tags
        fTitle: UnicodeString;
        fComment: UnicodeString;
        fLyrics: UTF8String;
        fDescription: UnicodeString;
        fTrack: Byte;
        fRating: Byte;
        fPlayCounter: Cardinal;
        // some more properties
        // read it from the file itself
        fDuration: Integer;
        fChannelModeIDX: Byte;
        fSamplerateIDX: Byte;
        fVBR: Boolean;
        fBitrate: Word;
        fFileSize: Integer;
        // CoverID: a md5-hash-like string
        fCoverID: String;

        // In the playlist, every AudioFile can have a list
        // of TAudiofiles (CueList), if there is a cuefile present
        // These subfiles starts at position Index01
        // (in cuefiles this is named that way)
        FIndex01: Single; // Speichert den Cue-Index

        // fStrings stores Properties like Artist and Album, which
        // are used for preselection ("browselists")
        // As I do not want to 7x7=49 different sort function,
        // I set the array-index, which is used then in the sort-function
        // Note to self: Eventually Obsolete, if I implement the better
        //               Sort-Stuff in the Medialibrary
        //  Should also work with 2 function-pointers
        //  and one Uber-Sort-function, which calls these 2 in the right order.
        FStrings: array [TAudioFileStringIndex] of UnicodeString;

        // key1, key2: Used for the Browse-Lists
        // These values must be set when building the "AllArtist-Lists" and so on
        fKey1: UnicodeString;
        fKey2: UnicodeString;

        // List of all Tags for this Audiofile
        // This List is managed in class TTagCloud
        fTagList: TObjectList;

        function fGetTagList: TObjectList;

        // ChannelMode/Samplerate is used most times for displaying as a String
        function GetChannelMode: String;
        function GetChannelModeShort: String;
        function GetSamplerate: String;
        function GetSamplerateShort: String;

        // Checks whether lyrics exist or not
        function fGetLyricsExisting: Boolean;

        function fGetExtension: String;

        function GetString(Index: TAudioFileStringIndex): UnicodeString;
        procedure SetString(Index: TAudioFileStringIndex; const Value: UnicodeString);

        function GetPath: UnicodeString;
        procedure SetPath(const Value: UnicodeString);

        function fGetPlaylistTitleString: UnicodeString;

        // Read tags from the filetype and convert the data to TAudiofile-Data
        procedure GetMp3Info(filename: UnicodeString; Flags: Integer = 0);
        procedure GetOggInfo(filename: UnicodeString);
        procedure GetWmaInfo(filename: UnicodeString);
        procedure GetWavInfo(WaveFile: UnicodeString);
        procedure GetFlacInfo(Filename: UnicodeString);
        // no tags found - set default values
        procedure SetUnknown;

        procedure QuickUpdateMP3Tag(aFilename: String = '');

        procedure SetMp3Data(filename: UnicodeString; Flags: Integer = 0);

        // Write a string in a stream. In previous versions several encodings were
        // written, now only UTF8 is used
        // the ID defines, whether the string contains the artist, title, album, ...
        procedure WriteTextToStream(aStream: TStream; ID: Byte; wString: UnicodeString);
        function ReadTextFromStream(aStream: TStream): UnicodeString;
    public
        // CueList: AudioFiles in the Playlist can have a Cuesheet.
        // Each entry in this sheet is realized as a TAudiofile, which are
        // stored in this list.
        CueList: TObjectlist;

        // some fields used quite often in several ways.
        FileIsPresent: Boolean;
        FileChecked: Boolean;
        isStream: Boolean;

        // Counter for Random playback
        // If a file was played, it will be "blocked" for some time
        // to avoid repeating a file to often.
        // Yes, this is not "really random",
        // but humans believe this is "more random" ;-)
        LastPlayed: Integer;

        // ViewCounter is used by searching in the library.
        // Everytime some audiofiles are displayed in the main VST,
        // the displayed files get a new ViewCounter-ID to identify them
        // fast at "better Searches". See comments in BibSearcherClass.
        ViewCounter: Integer;

        // WebServerID is used by Nemp WebServer
        // Each file will get ist own ID, which will be used for downloading
        // the file without publishing the filename in the local filesystem.
        WebServerID: Integer;

        // PrebookIndex is used for prebooking some files for the playlist
        // PrebookIndex should be equal to the Index of the file in the
        // Playlist.PrebookList
        PrebookIndex: Integer;

        // RawTags: #13#10-separated Tags
        // Management of these Strings (except loading/saving) is done in Class TTagCloud
        //RawTagAuto: UTF8String;
        RawTagLastFM: UTF8String;
        RawTagUserDefined: UTF8String;
        // Used in TagEditor/CloudTag.RenameTag
        // True indicates that the ID3Tag of the file should be rewritten
        ID3TagNeedsUpdate: Boolean;

        property Titel:  UnicodeString Read fTitle write fTitle;                        // 2
        property Artist: UnicodeString Index siArtist read GetString write SetString;  // 1
        property Album:  UnicodeString Index siAlbum read GetString write SetString;   // 3
        property Ordner: UnicodeString Index siOrdner read GetString;
        property Genre:  UnicodeString Index siGenre read GetString write SetString;
        property Year:   UnicodeString Index siJahr read GetString write SetString;    // 9
        property Comment:UnicodeString read fComment write fComment;
        property Lyrics : UTF8String   read fLyrics write fLyrics;
        property LyricsExisting: Boolean read fGetLyricsExisting;
        property Description: UnicodeString read fDescription write fDescription;
        property Dateiname: UnicodeString Index siDateiname read GetString;
        property Extension: String read fGetExtension;
        property Strings[Index: TAudioFileStringIndex]: UnicodeString read GetString write SetString;
        property Index01: single read FIndex01;

        property CoverID: String read fCoverID write fCoverID;
        property Track: Byte read fTrack write fTrack;
        property Duration: Integer read fDuration write fDuration;
        property Rating: Byte read fRating write fRating;
        property PlayCounter: Cardinal read fPlayCounter write fPlayCounter;
        property ChannelMode: String read GetChannelMode;
        property ChannelModeShort: String read GetChannelModeShort;
        // note: ChannelModeInt and SampleRateInt gives the INDEX in the Array,
        //       not the real values
        property ChannelModeInt: Byte read fChannelModeIDX;
        property SampleRate: String read GetSamplerate;
        property SampleRateShort: String read GetSamplerateShort;
        property SampleRateInt: Byte read fSampleRateIDX;
        property vbr: boolean read fVBR;
        property Bitrate: word read fBitrate write fBitrate;
        property Size: Integer read fFileSize;
        
        property Pfad: UnicodeString read GetPath write SetPath;
        property PlaylistTitle: UnicodeString read fGetPlaylistTitleString;

        property Key1: UnicodeString read fKey1 write fKey1;
        property Key2: UnicodeString read fKey2 write fKey2;

        property Taglist: TObjectList read fgetTagList;

        constructor Create;
        destructor Destroy; override;

        // Copy the data from aAudiofile
        procedure Assign(aAudioFile: TAudioFile);
        // AssignLight: Copy Data, except Lyrics and RawTagsLastFM
        //   used for the webserver-copy of the MedienBib.
        //   Lyrics are not used in webserver but needs much place
        procedure AssignLight(aAudioFile: TAudioFile);

        // Change the Driveletter from a file
        procedure SetNewDriveChar(aChar: WideChar);

        procedure GetAudioData(filename: UnicodeString; Flags: Integer = 0);
        function GetCueList(aCueFilename: UnicodeString =''; aAudioFilename: UnicodeString = ''): boolean; // R�ckgabewert: Liste erstellt/nicht erstellt

        // Write the Meta-Data back to the file
        // This method will call a proper sub-methode like SetMp3Info
        procedure SetAudioData(Flags: Integer = 0);

        // save the data here in a ";"-separated string for csv-export
        function GenerateCSVString: UnicodeString;

        // Load the data from a .gmp-file (medialib-format)
        procedure LoadFromStream(aStream: TStream);
        // load the data from a .npl-file (Nemp-playlist-format)
        // the difference is about URLs as paths and relative filenames in playlists
        procedure LoadFromStreamForPlaylist(aStream: TStream);
        // save the data to the stream. gmp/npl-stuff is done via the second parameter
        procedure SaveToStream(aStream: TStream; aPath: UnicodeString = '');

        // Set the samplerate. Called by the playerclass.
        // Samplerate came from the bass.dll, but not directly compatible to
        // the Index-system here.
        procedure SetSampleRate(aRate: Integer);

        // QuickFileUpdate:
        // Set only the Rating and the Playcounter and write it to the file
        procedure QuickUpdateTag(aFilename: String = '');
    end;

    // Okay. This doesnt make any sense. I wanted to create subclasses of
    // TAudiofile here, as some properties are only used by the playlist.
    // But all i coded was this re-definition...
    TPlaylistFile = TAudioFile;

    // Types used in the VirtualStringTrees
    TTreeData = record
      FAudioFile : TAudioFile;
    end;
    PTreeData = ^TTreeData;

    // Note to self: This is maybe obsolete, when the bottom part of the
    // mainwindow is changed
    PCoverTreeData = ^TCoverTreeData;
    TCoverTreeData = record
        Image: TBitmap;
    end;


    TAudioFileCompare = function(a1,a2: TAudioFile): Integer;
    TSortDirection = (sd_Ascending, sd_Descending);

    TCompareRecord = record
        Comparefunction: TAudioFileCompare;
        Direction: TSortDirection;
        Tag: Integer;
    end;
    

const
      // GAD_xxx: Flags for GetAudioData-Methods
      GAD_Cover = 1;
      GAD_Rating = 2;
      // note for future extensions:
      // this is planned as bitmasks, so use 4,8,16,32,.. for additional flags

      // SAD_xxx Flags for SetAudioData-Methods
      SAD_None     = 0;   // Do not Update Informatin in the file
      SAD_Existing = 1;  // Update only existing Tag (note: v2 Tag has to be created!)
      SAD_Both     = 2;  // Update both (v1 an v2)-Tags

      // property-IDs for saving/loading
      // general format in the gmp/npl-files
      // 1Byte ID
      // Data according to ID. Byte, Integer, String, ..
      MP3DB_PFAD        = 0;
      MP3DB_ARTIST      = 1;
      MP3DB_TITEL       = 2;
      MP3DB_ALBUM       = 3;
      MP3DB_DAUER       = 4;
      MP3DB_BITRATE     = 5;
      MP3DB_VBR         = 6;
      MP3DB_CHANNELMODE = 7;
      MP3DB_SAMPLERATE  = 8;
      MP3DB_FILESIZE    = 10;
      MP3DB_DATUM       = 11;
      MP3DB_TRACK       = 12;
      //---
      MP3DB_KATEGORIE   = 20;  // this was used in "Gausis mp3 Verwaltung"
                               // (something like Nemp 0.1)
      MP3DB_KOMMENTAR   = 21;
      MP3DB_YEAR        = 22;
      MP3DB_GENRE       = 23;
        MP3DB_GENRE_STR   = 26;  //$1A
      MP3DB_LYRICS      = 24;
      MP3DB_ID3KOMMENTAR = 25;
      MP3DB_COVERID = 27;

      //MP3DB_DUMMY_Byte1  = 28;
      MP3DB_RATING = 28;

      MP3DB_CUEPRESENT   = 30;

      // some dummy IDs for future use.
      // Ints are Integer, Bytes are Bytes, Texts are strings
      // note: some of them are already in use
      MP3DB_DUMMY_Byte2  = 29;
      //MP3DB_DUMMY_Int1   = 30;
      // MP3DB_DUMMY_Int2   = 31;
      MP3DB_PLAYCOUNTER  = 31;
      MP3DB_DUMMY_Int3   = 32;
      //MP3DB_DUMMY_Text1  = 33;
      MP3DB_LASTFM_TAGS  = 33;
      MP3DB_DUMMY_Text2  = 34;
      MP3DB_DUMMY_Text3  = 35;
      // 42 marks the end of an AudioFile
      MP3DB_ENDOFINFO = 42;

      // Some Constant-Arrays
      // Probably there exists better ways of doing the stuff, where this is used
      // - but these lines are one of the first lines ever written for this program ;)
      Mp3db_Samplerates: Array[0..9] of String
            = (' 8.0','11.0','12.0','16.0','22.0','24.0','32.0','44.1','48.0','N/A ');
      Nemp_Samplerates_Int: Array[0..9] of Integer
            = ( 8000, 11025, 12000, 16000, 22050, 24000, 32000, 44100, 48000, -1);
      Mp3db_Modes:  Array[0..4] of String
            = ('S ','JS','DC','M ','--');
      Nemp_Modes_Int: Array[0..4] of Integer
            = (2,2,2,1,-1);
      Mp3DB_ExtendedModes : Array[0..4] of String =('Stereo', 'Joint-Stereo', 'Dual-Channel', 'Mono', '');

      AUDIOFILE_UNKOWN = '<N/A>';

      // Used for parsing cue-sheets
      CUE_ID_FILE      = 0;
      CUE_ID_PERFORMER = 1;
      CUE_ID_TITLE     = 2;
      CUE_ID_TRACK     = 3;
      CUE_ID_INDEX     = 4;
      CUE_ID_UNKNOWN   = 5;

      // some helpers for cue-sheets
      function GetCueID(aString: String): Byte;
      function GetFileNameFromCueString(aString: String):String;



procedure GetMp3Details(filename:UnicodeString;
      var mpeginfo:Tmpeginfo;
      var ID3v2Tag: TID3v2Tag;
      var id3v1tag:Tid3v1tag);


implementation

uses NempMainUnit, Dialogs, CoverHelper;

 {$I-}


 { TTag }

constructor TTag.Create(aKey: UTF8String);
begin
    inherited create;
    AudioFiles := TObjectList.Create(False);
    fKey := AnsiLowercase(aKey);
    fIsAutoTag := False;
    BreadCrumbIndex := High(Integer);
end;

destructor TTag.Destroy;
begin
    AudioFiles.Free;
    inherited;
end;

function TTag.GetCount: Integer;
begin
    result := AudioFiles.Count;
end;



{
    --------------------------------------------------------
    GetMp3Details
      Read ID3v1Tag,
      Read ID3v2Tag,
      Read Mpeg-Info from file
    --------------------------------------------------------
}
procedure GetMp3Details(filename: UnicodeString;
    var mpeginfo:Tmpeginfo;
    var ID3v2Tag: TID3v2Tag;
    var id3v1tag:Tid3v1tag);
var
    Stream: TFileStream;
begin
    try
        Stream := TFileStream.Create(filename, fmOpenRead or fmShareDenyWrite);
        try
            id3v1tag.ReadFromStream(Stream);
            Stream.Seek(0, sobeginning);
            id3v2tag.ReadFromStream(Stream);
            if id3v2Tag.exists then
                Stream.Seek(id3v2tag.size, soFromBeginning)
            else
                Stream.Seek(0, sobeginning);
            mpeginfo.LoadFromStream(Stream);
        finally
            Stream.free;
        end;
    except
        // nothing here
        // if FileStream.Create throws an Exception just do nothing
        // this method is called too often. ;-)
    end;
end;


{
    --------------------------------------------------------
    Basic Class-Stuff.
    Create, Destroy, Assign
    --------------------------------------------------------
}
constructor TAudioFile.create;
begin
    inherited create;
    Duration := 0;
    fBitrate := 160;
    fChannelmodeIDX := 1; // JS;
    fSamplerateIDX := 7 ; // = 44.1Hz
    FileIsPresent := True;
    Genre := 'Other';
    Year := '';
    FileChecked := False;
    isStream := False;
    LastPlayed := 0;
    Track := 0;
    coverID := '';
    fRating := 0;
    ID3TagNeedsUpdate := False;
end;
destructor TAudioFile.Destroy;
begin
  if assigned(CueList) then
  begin
      // clear and free cuelist if present
      CueList.Clear;
      CueList.Free;
  end;
  if assigned(fTagList) then
      fTagList.Free;

  inherited destroy;
end;
procedure TAudioFile.Assign(aAudioFile: TAudioFile);
begin
    Description        := aAudioFile.Description         ;
    fFileSize          := aAudioFile.fFileSize           ;
    Duration           := aAudioFile.Duration            ;
    fBitrate           := aAudioFile.fBitrate            ;
    fvbr               := aAudioFile.fvbr                ;
    fChannelModeIDX    := aAudioFile.fChannelModeIDX     ;
    fSamplerateIDX     := aAudioFile.fSamplerateIDX      ;
    FileIsPresent      := aAudioFile.FileIsPresent       ;
    isStream           := aAudioFile.isStream            ;
    FileChecked        := aAudioFile.FileChecked         ;
    Titel              := aAudioFile.Titel               ;
    Artist             := aAudioFile.Artist              ;
    Album              := aAudioFile.Album               ;
    Genre              := aAudioFile.Genre               ;
    Year               := aAudioFile.Year                ;
    Track              := aAudioFile.Track               ;
    Comment            := aAudioFile.Comment             ;
    Lyrics             := aAudioFile.Lyrics              ;
    CoverID            := aAudioFile.CoverID             ;
    Rating             := aAudioFile.Rating              ;
    PlayCounter        := aAudioFile.PlayCounter         ;
    Pfad               := aAudioFile.Pfad                ;
    RawTagLastFM       := aAudioFile.RawTagLastFM        ;
end;
procedure TAudioFile.AssignLight(aAudioFile: TAudioFile);
begin
    Description        := aAudioFile.Description         ;
    fFileSize          := aAudioFile.fFileSize           ;
    Duration           := aAudioFile.Duration            ;
    fBitrate           := aAudioFile.fBitrate            ;
    fvbr               := aAudioFile.fvbr                ;
    fChannelModeIDX    := aAudioFile.fChannelModeIDX     ;
    fSamplerateIDX     := aAudioFile.fSamplerateIDX      ;
    FileIsPresent      := aAudioFile.FileIsPresent       ;
    isStream           := aAudioFile.isStream            ;
    FileChecked        := aAudioFile.FileChecked         ;
    Titel              := aAudioFile.Titel               ;
    Artist             := aAudioFile.Artist              ;
    Album              := aAudioFile.Album               ;
    Genre              := aAudioFile.Genre               ;
    Year               := aAudioFile.Year                ;
    Track              := aAudioFile.Track               ;
    Comment            := aAudioFile.Comment             ;
    // No Lyrics here!
    CoverID            := aAudioFile.CoverID             ;
    Rating             := aAudioFile.Rating              ;
    PlayCounter        := aAudioFile.PlayCounter         ;
    Pfad               := aAudioFile.Pfad                ;
end;

{
    --------------------------------------------------------
    SetNewDriveChar
    Change x:\[...]\mySong.mp3 to y:\[...]\mySong.mp3.
    If the Path starts with "\" (i.e. "\\"), nothing is done
    --------------------------------------------------------
}
procedure TAudioFile.SetNewDriveChar(aChar: WideChar);
begin
  if length(FStrings[siOrdner]) > 1 then
  begin
    if FStrings[siOrdner][1] <> '\' then
        FStrings[siOrdner][1] := aChar;
  end;
end;

{
    --------------------------------------------------------
    Setter and Getter for Path
    --------------------------------------------------------
}
function TAudioFile.GetPath: UnicodeString;
begin
  if IsStream then
      result := fStrings[siOrdner]
  else
  begin
    //if (length(FStrings[siOrdner]) > 0) and (FStrings[siOrdner][length(FStrings[siOrdner])] = '\') then
        result := FStrings[siOrdner] + Dateiname
    //else
    //    result := FStrings[siOrdner] + '\' + Dateiname;
  end;
end;
procedure TAudioFile.SetPath(const Value: UnicodeString);
begin
  if IsStream then
  begin
      FStrings[siOrdner] := Value;
      FStrings[siDateiname] := '';
  end
  else
  begin
      FStrings[siOrdner] := ExtractFilePath(Value);//ExtractFileDir(Value);
      FStrings[siDateiname] := ExtractFileName(Value);
  end;
end;

{
    --------------------------------------------------------
    Setter and Getter for String Values
    Note to self: Eventually obsolete soon
    --------------------------------------------------------
}
function TAudioFile.GetString(Index: TAudioFileStringIndex): UnicodeString;
begin
    result := FStrings[Index];
end;
procedure TAudioFile.SetString(Index: TAudioFileStringIndex; const Value: UnicodeString);
begin
    FStrings[Index] := Value;
end;

function TAudioFile.fGetPlaylistTitleString: UnicodeString;
begin
  if isStream then
    result := Description
  else
  begin
    if Artist = AUDIOFILE_UNKOWN then
      result := Titel
    else
      result := Artist + ' - ' + Titel;
  end;

  if result = '' then
    result := Pfad;
end;

function TAudioFile.fGetTagList: TObjectList;
begin
    if not Assigned(fTagList) then
        fTagList := TObjectList.Create(False);
    result := fTagList;
end;

{
    --------------------------------------------------------
    Getter for ChannelMode
    --------------------------------------------------------
}
function TAudioFile.GetChannelMode: String;
begin
    result := Mp3DB_ExtendedModes[fChannelModeIDX];
end;
function TAudioFile.GetChannelModeShort: String;
begin
    result := Mp3db_Modes[fChannelModeIDX];
end;

{
    --------------------------------------------------------
    Getter for Samplerate
    First version is used in Detail-window
    Second is used in main VST
    --------------------------------------------------------
}
function TAudioFile.GetSamplerate: String;
begin
    result := Mp3db_Samplerates[fSamplerateIDX] + ' kHz';
end;
function TAudioFile.GetSamplerateShort: String;
begin
    result := Mp3db_Samplerates[fSamplerateIDX];
end;
{
    --------------------------------------------------------
    "Setter" for Samplerate.
    Used by the bass.dll to correct the value
    (e.g. on files with unknown tag-structure)
    --------------------------------------------------------
}
procedure TAudioFile.SetSampleRate(aRate: Integer);
begin
    case aRate of
        8000 : fSamplerateIDX := 0;
        11025: fSamplerateIDX := 1;
        12000: fSamplerateIDX := 2;
        16000: fSamplerateIDX := 3;
        22050: fSamplerateIDX := 4;
        24000: fSamplerateIDX := 5;
        32000: fSamplerateIDX := 6;
        44100: fSamplerateIDX := 7;
        48000: fSamplerateIDX := 8;
    else
        fSamplerateIDX := 9;
    end;
end;
{
    --------------------------------------------------------
    Getter for Extension
    (modified version of SysUtils.ExtractFileExt - we dont need the "." here)
    --------------------------------------------------------
}
function TAudioFile.fGetExtension: String;
var I: Integer;
begin
    I := LastDelimiter('.' + PathDelim + DriveDelim, Dateiname) + 1;
    if (I > 1) and (Dateiname[I-1] = '.') then
        Result := Copy(Dateiname, I, MaxInt)
    else
        Result := '';
end;
{
    --------------------------------------------------------
    Getter for LyricsExisting
    --------------------------------------------------------
}
function TAudioFile.fGetLyricsExisting: Boolean;
begin
  result := flyrics <> '';
end;

{
    --------------------------------------------------------
    GetAudioData, main method of this class
    Flags are only used in mp3-files.
    Notes:
      * Covers contained in mp3-Files are recognized
        If no Cover in the id3tag was found, the MedieLibrary
        will call another "GetCover"-method. This is done not in this
        class, as the filesearching will give the same result on every
        file in the same directory. Doing this outside this class
        would be much faster.
        However, sometimes it is not wanted to read the cover from the
        file. In this case you should NOT add the Flag GAD_Cover, otherwise
        this flag should be used.
      * The Medialibrary can manage ratings without saving it to the files.
        When the user presses "F5" to refresh some files, with a unsaved
        Library-rating, these ratings will be lost. So ratings are only read,
        if flag GAD_Rating is set AND the current rating is equal to 0
        (i.e. undefined).
        If the user wants to reset the ratings: Use "reset ratings".
    --------------------------------------------------------
}
procedure TAudioFile.GetAudioData(filename: UnicodeString; Flags: Integer = 0);
var F: File;
begin
  // Set Filechecked to false.
  FileChecked := False;

  if PathSeemsToBeURL(filename) then
  begin
      IsStream := True;
      Pfad := filename;
      fFileSize := 0;
  end
  else
  begin
      try
        IsStream := False;
        // Get the extension and call the proper private method.
        if (AnsiLowerCase(ExtractFileExt(filename)) = '.mp3')
          or (AnsiLowerCase(ExtractFileExt(filename)) = '.mp2')
          or (AnsiLowerCase(ExtractFileExt(filename)) = '.mp1')
        then
          GetMp3Info(Filename, Flags)
        else
          if AnsiLowerCase(ExtractFileExt(filename)) = '.wma' then
            GetWMAInfo(Filename)
          else
            if AnsiLowerCase(ExtractFileExt(filename)) = '.ogg' then
              GetOggInfo(Filename)
            else
              if AnsiLowerCase(ExtractFileExt(filename)) = '.wav' then
                GetWavInfo(Filename)
              else
                if AnsiLowerCase(ExtractFileExt(filename)) = '.flac' then
                  GetFlacInfo(filename)
                else
                begin
                    Pfad:=filename;
                    FileIsPresent := FileExists(filename);
                    FileChecked := FileIsPresent;
                    if FileIsPresent then
                    begin
                      AssignFile(F, filename);
                      FileMode := 0;
                      Reset(F,1);
                      fFileSize := filesize(f);
                      CloseFile(F);
                    end else
                      fFileSize := 0;
                    SetUnknown;
                end;
      except
        Pfad:=filename;
        FileIsPresent := FileExists(filename);
        FileChecked := FileIsPresent;
        fFileSize := 0;
        SetUnknown;
      end;
  end;
end;

{
    --------------------------------------------------------
    GetMp3Info
    Uses MP3FileUtils
    --------------------------------------------------------
}
procedure TAudioFile.GetMp3Info(filename: UnicodeString; Flags: Integer = 0);
var mpegInfo:TMpegInfo;
    ID3v2Tag:TID3V2Tag;
    ID3v1tag:TID3v1Tag;
    CoverStream, TagStream: TMemoryStream;
    PicList: TObjectlist;
    PicType: Byte;
    PicDesc: UnicodeString;
    PicMime: AnsiString;
    i: Integer;
    aBMP: TBitmap;
    newID: String;
begin
    FileIsPresent:=False;
    Pfad:=filename;
    if NOT FileExists(filename) then
    begin
      SetUnknown;
      exit;
    end;
    FileIsPresent:=True;
    FileChecked := True;
    mpeginfo:=TMpegInfo.Create;
    ID3v2Tag:=TID3V2Tag.Create;
    ID3v1tag:=TID3v1Tag.Create;

    if MedienBib.NempCharCodeOptions.AutoDetectCodePage then
    begin
      ID3v1Tag.CharCode := GetCodePage(filename, MedienBib.NempCharCodeOptions);
      ID3v2Tag.CharCode := ID3v1Tag.CharCode;
    end;

    ID3v1Tag.AutoCorrectCodepage := MedienBib.NempCharCodeOptions.AutoDetectCodePage;
    ID3v2Tag.AutoCorrectCodepage := MedienBib.NempCharCodeOptions.AutoDetectCodePage;
    ID3v2Tag.AlwaysWriteUnicode := MedienBib.NempCharCodeOptions.AlwaysWriteUnicode;

    // read Tags from File
    GetMp3Details(filename,mpegInfo,ID3v2Tag,ID3v1tag);

    // If file was valid mp3-file:
    // Put the tag-info into the audiofile-structure.
    // Id3v2-tags have priority
    if mpeginfo.FirstHeaderPosition>-1 then
    begin
        // aus dem ID3 Tag
        if id3v2tag.artist<>'' then Artist:=(id3v2tag.artist)
            else if id3v1tag.artist<>'' then Artist:=(id3v1tag.artist)
                else Artist:=AUDIOFILE_UNKOWN;
        if id3v2tag.title<>'' then Titel:=(id3v2tag.title)
            else if id3v1tag.title<>'' then Titel:=(id3v1tag.title)
                else Titel:=Dateiname;
        if id3v2tag.album<>'' then Album:=(id3v2tag.album)
            else if id3v1tag.album<>'' then Album:=(id3v1tag.album)
                else album:=AUDIOFILE_UNKOWN;
        if id3v2tag.Year<>'' then Year:=(id3v2tag.Year)
            else if id3v1tag.Year<>'' then Year := Trim(UnicodeString(id3v1tag.Year))
                else Year:='';
        if id3v2tag.genre<>'' then
          genre := id3v2tag.genre
        else
          if id3v1tag.exists then
            genre := id3v1tag.genre
          else
            genre := '';
        Track := GetTrackFromV2TrackString(Id3v2tag.Track);
        if Track = 0 then
            Track := StrToIntDef(Id3v1tag.Track, 0);
        Lyrics := UTF8Encode(id3v2tag.Lyrics);

        if id3v2tag.Comment<>'' then Comment := id3v2tag.Comment
          else if id3v1tag.Comment<>'' then Comment := id3v1tag.Comment
            else Comment := '';

        PlayCounter := Id3v2tag.PlayCounter;

        //  MPEG-Infos
        Duration:= mpeginfo.dauer;
        fBitrate:=mpeginfo.bitrate;
        fvbr := mpeginfo.vbr;
        fFileSize := mpeginfo.FileSize;
        SetSampleRate(mpeginfo.samplerate);
        case mpeginfo.channelmode of
            // ('S ','JS','DC','M ','--');
            0: fChannelmodeIDX := 0; //Stereo
            1: fChannelmodeIDX := 1; //'Joint stereo',
            2: fChannelmodeIDX := 2; //'Dual channel (Stereo)',
            3: fChannelmodeIDX := 3; //'Single channel (Mono)');
            else fChannelmodeIDX := 4;
        end;

        // get Nemp/Tags
        TagStream := TMemoryStream.Create;
        try
            if id3v2tag.GetPrivateFrame('NEMP/Tags', TagStream) and (TagStream.Size > 0) then
            begin
                // We found a Tag-Frame with Information in the ID3Tag
                TagStream.Position := 0;
                SetLength(RawTagLastFM, TagStream.Size);
                TagStream.Read(RawTagLastFM[1], TagStream.Size);
            end;
        finally
            TagStream.Free;
        end;

        // Determine rating if wanted.
        // Note: only if no rating is set!
        // Change January 2010: Set Rating if Flag is set OR (not AND as before) the current rating is zero
        // No: Read it always from ID3Tag, as ratings are always written into the tag on mp3-Files!
        // if ((Flags and GAD_Rating) = GAD_Rating) OR (fRating = 0) then
        fRating := id3v2tag.Rating;

        // Determine cover if wanted
        if (Flags and GAD_Cover) = GAD_Cover then
        begin
            // clear ID, so MediaLibrary.GetCover can do its job if no cover
            // in the tag is found.
            CoverID := '';
            CoverStream := TMemoryStream.Create;
            PicList := id3v2Tag.GetAllPictureFrames;
            try
                if PicList.Count >0 then
                begin
                    // Check Pic-Liste.
                    // Take the cover flagged as "frontcover" or the first one
                    // in the list.
                    for i := PicList.Count - 1 downto 0 do
                    begin
                        CoverStream.Clear;
                        TID3v2Frame(PicList[i]).GetPicture(PicMime, PicType, PicDesc, CoverStream);
                        if PicType = 3 then //Front-Cover
                            break;
                    end;
                    aBMP := TBitmap.Create;
                    try
                        PicStreamToImage(CoverStream, PicMime, aBMP);
                        if not aBMP.Empty then
                        begin
                            CoverStream.Seek(0, soFromBeginning);
                            newID := MD5DigestToStr(MD5Stream(CoverStream));
                            if SafeResizedGraphic(aBMP, MedienBib.CoverSavePath + newID + '.jpg', 240, 240) then
                                CoverID := newID;
                        end;
                    finally
                        aBMP.Free;
                    end;
                end;
            finally
                PicList.Free;
                CoverStream.Free;
            end;
        end // if Flags = GAD_Cover
    end else
    begin
        // if you're here:
        // the mp3-file is not valid. Use default-values.
        fFileSize := mpeginfo.FileSize;
        SetUnknown;
    end;
    MpegInfo.Free;
    Id3v2Tag.Free;
    Id3v1Tag.Free;
end;

{
    --------------------------------------------------------
    GetFlacInfo
    Uses ATL
    --------------------------------------------------------
}
procedure TAudioFile.GetFlacInfo(Filename: UnicodeString);
var FLACfile: TFLACfile;
begin
    FileIsPresent := False;
    Pfad := Filename;
    if NOT FileExists(Filename) then
    begin
      SetUnknown;
      exit;
    end;
    FileIsPresent := True;
    FileChecked := True;
    isStream := False;


    FLACfile := TFLACfile.Create;

    if FileExists(FileName) then
    { Load FLAC data }
    if FLACfile.ReadFromFile(FileName) then
      if FLACfile.Valid then
      begin
          fFileSize := FLACfile.FileLength;

          if FLACfile.artist <> '' then
              Artist := FLACfile.artist
          else Artist := AUDIOFILE_UNKOWN;

          if FLACfile.title <> '' then
              Titel := FLACfile.title
          else Titel := Dateiname;

          if FLACfile.album <> '' then
              Album := FLACfile.album
          else Album := AUDIOFILE_UNKOWN;

          // Jahr
          if FLACfile.Year <> '' then
              Year := FLACfile.Year
          else Year := '';

          if FLACfile.genre <> '' then
              genre := FLACfile.genre
          else
              genre := '';

          Track := StrToIntDef(FLACfile.TrackString, 0);

          // ? FLACfile.xRating
          //fRating := 0;

          Lyrics := UTF8Encode(FLACfile.Lyrics);

          Comment := FLACfile.Comment;

          Duration := Round(FlacFile.Duration);
          fBitrate := FlacFile.Bitrate;
          fvbr := False;

          case FlacFile.Channels of
              1: fChannelModeIDX := 3; // Mono
              2: fChannelModeIDX := 0; // Stereo
          else
              fChannelModeIdx := 4; // Unknown
          end;
          SetSampleRate(FlacFile.samplerate);
      end
      else
        { Header not found }
        SetUnknown
    else
      { Read error }
      SetUnknown
  else
    { File does not exist }
    SetUnknown;
  FlacFile.Free;
end;

{
    --------------------------------------------------------
    GetOggInfo
    Uses some weird code - I should replace this by the ATL soon
    --------------------------------------------------------
}
procedure TAudioFile.GetOggInfo(filename: UnicodeString);
var  F: File;
    fsize:integer;
    position,i,c, Idx:integer;
    buffer: TBuffer;
    valid:boolean;
    sr,vendor_length,comment_list_length, comment_length: ^cardinal;
    min_bitrate,nominal_bitrate,max_bitrate:^integer;

    vendorstr,tmpstr, param:string;
    value: UTF8String;
    chmode:byte;
begin
    FileIsPresent:=False;
    Pfad:=(filename);

    // Zur�cksetzen, damit die Funktion MedienBib.InitCover sp�ter anschlagen kann!
    CoverID := '';

    if NOT FileExists(filename) then
    begin
      SetUnknown;
      exit;
    end;
    FileIsPresent:=True;
    FileChecked := True;

    AssignFile(F, filename);
    FileMode := 0;
    Reset(F,1);
    fsize:=filesize(f);

    nominal_bitrate := Nil;
    chmode := 0;

    fFileSize := fsize;
    year := '';
    if fsize=0 then
    begin
        CloseFile(F);
        exit;
    end;
    if fsize>=5000 then setlength(buffer,5000) else
        setlength(buffer,fsize);
    blockread(f,buffer[0],length(buffer));
    CloseFile(F);

    position:=-1;
    valid:=false;

    while NOT ((valid) or (position>length(buffer)+1000)) do  // +1000 ma�los �bertrieben, aber egal
    begin
        try
            inc(position);
            if       (ord(buffer[position])  = 01)  // 01: Audio-Infos
                AND (buffer[position+1]  = $76)
                AND (buffer[position+2]= $6F)
                AND (buffer[position+3]= $72)
                AND (buffer[position+4]= $62)
                AND (buffer[position+5]= $69)
                AND (buffer[position+6]= $73)    {'vorbis'}
            then begin
                // +7+8+9+10: sollten 0 sein, �berpr�fe ich erstmal nicht
                // 11 : Audio-Channels
                chmode := buffer[position+11];
                case buffer[position+11] of
                    //('S ','JS','DC','M ','--');
                    1: fChannelmodeIDX := 3;
                    2: fChannelmodeIDX := 0;
                    else fChannelmodeIDX := 4;
                end;
                sr:=@(buffer[position+12]);
                SetSampleRate(sr^);
                min_bitrate := @(buffer[position+16]);
                nominal_bitrate := @(buffer[position+20]);
                max_bitrate := @(buffer[position+24]);
                if (min_bitrate^=nominal_bitrate^)
                    AND (nominal_bitrate^=max_bitrate^)
                    AND (max_bitrate^<>0)
                    then bitrate:=nominal_bitrate^ DIV 1000
                    else if ((min_bitrate^=0) OR (min_bitrate^=-1)) // -1 = $FF FF FF
                        AND (nominal_bitrate^<>0)
                        AND ((max_bitrate^=0) OR (max_bitrate^=-1))
                        then fbitrate:=nominal_bitrate^ DIV 1000
                        else fbitrate := (max_bitrate^ + min_bitrate^) DIV 2000;
            end;
            if       (ord(buffer[position])  = 03)  //03: Titel-Infos
                AND (buffer[position+1]  = $76)
                AND (buffer[position+2] = $6F)
                AND (buffer[position+3] = $72)
                AND (buffer[position+4] = $62)
                AND (buffer[position+5] = $69)
                AND (buffer[position+6] = $73)
            then begin
                vendor_length := @(buffer[position+7]);
                setlength(vendorstr,vendor_length^);
                for i:=0 to vendor_length^-1 do
                    vendorstr[i+1] := chr(buffer[position+11+i]);
                // Anzahl der Kommentarfelder
                comment_list_length := @(buffer[position+11 + Integer(vendor_length^)]);
                position:=position+15+ Integer(vendor_length^); // Position: l�nge des folgenden Kommentares
                for c:=1 to comment_list_length^ do
                begin
                    comment_length := @(buffer[position]);
                    setlength(tmpstr,comment_length^);

                    // das solte doch mit move oder so besser gehen, oder???
                    for i:=0 to comment_length^-1 do
                        tmpstr[i+1] := chr(buffer[position+4+i]);

                    {.$Message Hint 'Code testen, anders machen! Nix mit TmpStringlist, das geht ohne Explode'}

                    Idx := Pos('=', tmpstr);
                    if Idx > 1 then
                    begin
                        param := AnsiLowerCase(Copy(tmpstr, 1, Idx-1));
                        value := UTF8String(Copy(tmpstr, Idx+1, length(tmpstr)));

                        if param = 'artist' then
                          Artist := Utf8ToString(value)
                        else
                          if param = 'album' then
                            Album := Utf8ToString(value)
                          else
                            if param = 'title' then
                              Titel := Utf8ToString(value)
                            else
                              if param='tracknumber' then
                                  Track := StrToIntDef(UTF8ToAnsi(value), 0);

                                  (*
                                  tmpstrlist := explode('=',tmpstr);
                                  if tmpstrlist.Count > 1 then
                                  begin
                                      if Ansilowercase(tmpstrlist[0])='artist'
                                          then artist := UTF8ToString(tmpstrlist[1]);
                                      if Ansilowercase(tmpstrlist[0])='album'
                                          then album:=UTF8ToAnsi(tmpstrlist[1]);
                                      if Ansilowercase(tmpstrlist[0])='title'
                                          then titel:=UTF8ToAnsi(tmpstrlist[1]);
                                      if AnsiLowerCase(tmpstrlist[0])='tracknumber'
                                          then Track := StrToIntDef(UTF8ToAnsi(tmpstrlist[1]),0);
                                  end;
                                  inc(position,comment_length^+4);
                                  tmpstrlist.free;
                                  *)
                    end;



                end;

                if (nominal_bitrate^ * chmode) <> 0 then
                  Duration := round(fFileSize / bitrate / chmode /125*2)
                else
                  Duration := 0;
                valid:=true;
            end;
        except
        end;
    end;
    if titel='' then titel:=Dateiname;
    if artist='' then artist := AUDIOFILE_UNKOWN;
    if album='' then album := AUDIOFILE_UNKOWN;
    fRating := 0; // Rating is not supported in Ogg-Files
end;

{
    --------------------------------------------------------
    GetWmaInfo
    Uses ATL
    --------------------------------------------------------
}
procedure TAudioFile.GetWmaInfo(filename: UnicodeString);
var
  Stream: TFileStream;
  wmaFile: TWMAfile;
begin
  FileIsPresent:=False;
  Pfad:=filename;

  // Zur�cksetzen, damit die Funktion MedienBib.InitCover sp�ter anschlagen kann!
    CoverID := '';

  if NOT FileExists(filename) then
  begin
      SetUnknown;
      exit;
    end;

  FileIsPresent:=True;
  FileChecked := True;
  {$Message Hint 'WMAFILE �berpr�fen (done?)'}
  wmaFile := TWMAFile.create;
  if wmaFile.ReadFromFile(filename) then
  begin
    if wmaFile.Title <> '' then
        Titel := wmaFile.Title
    else Titel := Dateiname;
    if wmaFile.Artist <> '' then
        Artist := wmaFile.Artist
    else Artist := AUDIOFILE_UNKOWN;
    if wmaFile.Album <> '' then
        Album := wmaFile.Album
    else ALbum := AUDIOFILE_UNKOWN;

    fRating := 0;  // Rating in WMA-Files is not supported
    Year := wmaFile.Year;
    Genre := wmaFile.Genre;
    Duration := Round(wmaFile.Duration);
    fBitrate := wmaFile.BitRate;
    fFileSize := wmaFile.FileSize;
    Track := wmaFile.Track;
    SetSampleRate(wmaFile.SampleRate);
    case wmaFile.ChannelModeID of
      WMA_CM_UNKNOWN:  fChannelModeIDX := 4;         { Unknown }
      WMA_CM_MONO:  fChannelModeIDX := 3;          { Mono }
      WMA_CM_STEREO:  fChannelModeIDX := 0;        { Stereo }
    end;
  end
  else
  begin
      SetUnknown;
      try
          Stream := TFileStream.Create(filename, fmOpenRead or fmShareDenyNone);
          try
              fFileSize := Stream.Size;
          finally
              stream.Free;
          end;
      except
          fFileSize := 0;
      end;

  end;

  wmaFile.Free;
end;

{
    --------------------------------------------------------
    GetWavInfo
    Uses modified version of
    http://www.dsdt.info/tipps/?id=354&details=1
    --------------------------------------------------------
}
procedure TAudioFile.GetWavInfo(WaveFile: UnicodeString);
var
  groupID: array[0..3] of AnsiChar;
  riffType: array[0..3] of AnsiChar;
  BytesPerSec: Integer;
  Stream: TFileStream;
  dataSize: Integer;
  wChannels: WORD;
  dwSamplesPerSec: LongInt;
  BytesPerSample:Word;
  BitsPerSample: Word;

  // chunk seeking function,
  // -1 means: chunk not found

 {$Message Hint 'WAV-File: Ok (?)'}
  function GotoChunk(ID: AnsiString): Integer;
  var
    chunkID: array[0..3] of AnsiChar;
    chunkSize: Integer;
  begin
    Result := -1;
    with Stream do begin
      // index of first chunk
      Position := 12;
      repeat
        // read next chunk
        Read(chunkID, 4);
        Read(chunkSize, 4);
        if chunkID <> ID then
          // skip chunk
          Position := Position + chunkSize;
      until (chunkID = ID) or (Position >= Size);

      if chunkID = ID then
        // chunk found,
        // return chunk size
        Result := chunkSize
    end
  end;

begin
  FileIsPresent:=False;
  Pfad:=WaveFile;
  // Zur�cksetzen, damit die Funktion MedienBib.InitCover sp�ter anschlagen kann!
    CoverID := '';

  if NOT FileExists(WaveFile) then
  begin
      SetUnknown;
      exit;
  end;
  FileIsPresent:=True;
  FileChecked := True;
  Titel := Dateiname;
  Artist := AUDIOFILE_UNKOWN;
  Album := AUDIOFILE_UNKOWN;
  Track := 0;
  Year := '';
  Genre := '';
  Comment := '';
  Lyrics := '';
  //LyricsExisting := False;
  fBitrate := 0;
  fvbr := False;
  fRating := 0;   // rating is not supported in WAV-Files

//  Result := -1;
  try
      Stream := TFileStream.Create(WaveFile, fmOpenRead or fmShareDenyNone);
      with Stream do
      try
          Read(groupID, 4);
          Position := Position + 4; // skip four bytes (file size)
          Read(riffType, 4);
          if (groupID = 'RIFF') and (riffType = 'WAVE') then
          begin
            // search for format chunk
            if GotoChunk('fmt ') <> -1 then
            begin
              // found it
              Position := Position + 2;
              Read(wChannels,2);
              case wChannels of
                1: fChannelModeIDX := 3;
                2: fChannelModeIDX := 0;
                else fChannelModeIDX := 4;
              end;
              {('S ','JS','DC','M ','--');}

              Read(dwSamplesPerSec,4);
              SetSampleRate(dwSamplesPerSec);
              Read(BytesPerSec,4);
              Read(BytesPerSample,2);
              Read(BitsPerSample,2);
              fBitrate := Round(wChannels * BitsPerSample * dwSamplesPerSec / 1000);
              // search for data chunk
              dataSize := GotoChunk('data');

              if dataSize <> -1 then
                // found it
                Duration := dataSize DIV BytesPerSec;
              fFileSize := size;
            end
          end
      finally
          Free
      end
  except
      // nothing to do here
  end;
end;

{
    --------------------------------------------------------
    SetUnknown
    Default values, if no further information can be determined from the file
    --------------------------------------------------------
}
procedure TAudioFile.SetUnknown;
begin
  Titel:=Dateiname;
  Artist := AUDIOFILE_UNKOWN;
  Album := AUDIOFILE_UNKOWN;
  Year := '';
  Genre := '';
  Duration := 0;
  fBitrate := 0;
  fvbr := False;
  fChannelmodeIDX := 4;
  fSamplerateIDX := 9;
  Track := 0;
  fRating := 0;
  // Zur�cksetzen, damit die Funktion MedienBib.InitCover sp�ter anschlagen kann!
  CoverID := '';
end;


{
    --------------------------------------------------------
    QuickFileUpdate
    Write Rating and PlayCounter to the file
    Used by the Player-Postprocessor
    --------------------------------------------------------
}
procedure TAudioFile.QuickUpdateTag(aFilename: String = '');
var localName: String;
begin
    if aFileName = '' then
        localName := self.Pfad
    else
        localName := aFileName;

    if PathSeemsToBeURL(localName) then
        // Nothing to do.
    else
    begin
        try
            // Get the extension and call the proper private method.
            if (AnsiLowerCase(ExtractFileExt(localName)) = '.mp3')
              or (AnsiLowerCase(ExtractFileExt(localName)) = '.mp2')
              or (AnsiLowerCase(ExtractFileExt(localName)) = '.mp1')
            then
                QuickUpdateMP3Tag(localName)
            //else
            //    if AnsiLowerCase(ExtractFileExt(filename)) = '.ogg' then
            //        QuickSetOggInfo(Filename)
        except

        end;
    end;
end;


procedure TAudioFile.QuickUpdateMP3Tag(aFilename: String);
var ID3v2Tag:TID3V2Tag;
begin
    // Rating and PlayCounter can only be stored in the ID3v2-Tag
    if FileExists(aFileName) then
    begin
        ID3v2Tag := TID3V2Tag.Create;
        try
            ID3v2Tag.ReadFromFile(aFilename);
            if Not Id3v2Tag.Exists then
            begin
                // No ID3v2Tag exists in the file.
                // Set basic Information
                Id3v2Tag.Artist := Artist;
                ID3v2Tag.Title := Titel;
                ID3v2Tag.Album := Album;
                ID3v2Tag.Genre := Genre;
                ID3v2Tag.Year := Year;
                ID3v2Tag.Track := IntToStr(Track);
            end;

            // Set New Information
            ID3v2Tag.Rating := Rating;
            ID3v2Tag.PlayCounter := PlayCounter;

            // Update File
            ID3v2Tag.WriteToFile(aFilename);
        finally
            ID3v2Tag.Free;
        end;
    end;
end;

{
    --------------------------------------------------------
    SetAudioData
    Write all Data to the Tag of an AudioFile
    Used, in MainVST.
    --------------------------------------------------------
}
procedure TAudioFile.SetAudioData(Flags: Integer);
begin
    if IsStream then
    // we cannot write tags into a webstream
        exit;

    if (AnsiLowerCase(ExtractFileExt(pfad)) = '.mp3')
          or (AnsiLowerCase(ExtractFileExt(pfad)) = '.mp2')
          or (AnsiLowerCase(ExtractFileExt(pfad)) = '.mp1')
    then
    begin
        SetMp3Data(pfad, flags);
    end;
end;

{
    --------------------------------------------------------
    SetMp3Data
    Write all Data to the ID3Tag of an AudioFile
    Determine which Tag should be set
        SAD_None     // Do not write at all
        SAD_Existing // write existing (i.e. write v1 if it exists; v2 has to be created)
        SAD_Both     // write both Tags (i.e. create v1 if it does not exist)
    --------------------------------------------------------
}
procedure TAudioFile.SetMp3Data(filename: UnicodeString; Flags: Integer);
var
    ID3v2Tag:TID3V2Tag;
    ID3v1Tag:TID3v1Tag;
    ms: TMemoryStream;
begin
    if Flags = SAD_None then
        // Do not update the file
        exit;

    ID3v1Tag := TID3v1Tag.Create;
    ID3v2Tag := TID3V2Tag.Create;
    try
        ID3v1Tag.ReadFromFile(filename);
        if ID3v1Tag.Exists or ((Flags AND SAD_Both) = SAD_Both) then
        begin
            // Update ID3v1-Tag
            ID3v1Tag.Artist := Artist;
            ID3v1Tag.Title := Titel;
            ID3v1Tag.Album := Album;
            ID3v1Tag.Comment := Comment;
            ID3v1Tag.Year := ShortString(Year);
            ID3v1Tag.Track := IntToStr(Track);
            ID3v1Tag.Genre := Genre;
            ID3v1Tag.WriteToFile(filename);
        end;

        ID3v2Tag.ReadFromFile(filename);

        if Titel <> AUDIOFILE_UNKOWN then
            ID3v2tag.Title  := Titel;
        if Artist <> AUDIOFILE_UNKOWN then
            ID3v2tag.Artist := Artist;
        if Album <> AUDIOFILE_UNKOWN then
            ID3v2tag.album  := Album;
        if Comment <> AUDIOFILE_UNKOWN then
            ID3v2tag.Comment:= Comment;
        if Lyrics <> '' then
            Id3v2Tag.Lyrics := Lyrics;

        ID3v2Tag.Year := Year;
        ID3v2Tag.Track := IntToStr(Track);
        ID3v2Tag.Genre := Genre;
        ID3v2Tag.Rating := Rating;
        ID3v2Tag.PlayCounter := PlayCounter;

        if length(RawTagLastFM) > 0 then
        begin
            ms := TMemoryStream.Create;
            try
                ms.Write(RawTagLastFM[1], length(RawTagLastFM));
                ID3v2Tag.SetPrivateFrame('NEMP/Tags', ms);
            finally
                ms.Free;
            end;
        end else
            // delete Tags-Frame
            ID3v2Tag.SetPrivateFrame('NEMP/Tags', NIL);


        ID3v2Tag.WriteToFile(filename);

    finally
        ID3v1Tag.Free;
        ID3v2Tag.Free;
    end;

    
end;

{
    --------------------------------------------------------
    2 Helpers for CueSheets
    --------------------------------------------------------
}
function GetCueID(aString: String): Byte;
begin
  aString := trim(aString);
  if AnsiStartsText('PERFORMER', aString) then
    result := CUE_ID_PERFORMER
  else
    if AnsiStartsText('TITLE', aString) then
      result := CUE_ID_TITLE
    else
      if AnsiStartsText('FILE', aString) then
        result := CUE_ID_FILE
      else
        if AnsiStartsText('TRACK', aString) then
          result := CUE_ID_TRACK
        else
          if AnsiStartsText('INDEX', aString) then
            result := CUE_ID_INDEX
          else
            result := CUE_ID_UNKNOWN;
end;
function GetFileNameFromCueString(aString: String):String;
var i, LastSpacePos: Integer;
begin
  aString := trim(aString);
  LastSpacePos := 1;

  for i := length(aString) downto 1 do
    if aString[i] = ' ' then
    begin
      LastSpacePos := i;
      break;
    end;
  result := copy(aString, 6, LastSpacePos - 6);

  result := Stringreplace(result, '"', '', [rfReplaceAll]);
end;

{
    --------------------------------------------------------
    GetCueList
    Parse a CueSheet and add the found Cues to the Cuelist
    of the AudioFile
    --------------------------------------------------------
}
function TAudioFile.GetCueList(aCueFilename: UnicodeString =''; aAudioFilename: UnicodeString = ''): boolean;
var tmplist, CueTimelist, CueParselist: TStringList;
    i: Integer;
    FileFound: boolean;
    aCue: TAudioFile;
begin
  // Defaultvalue for aAudioFilename: Filename of "self"
  if (aAudioFilename = '') then aAudioFilename := Dateiname else
    aAudioFileName := ExtractFileName(aAudioFilename);

  // Defaultvalue for aAudioFilename: Filename of "self" with extension .cue
  if (aCueFilename = '') then aCueFilename := ChangeFileExt(Self.Pfad, '.cue');

  if not FileExists(aCueFilename) then
  begin
    result := False;
    exit;
    // no cuesheet found
  end;

  tmplist := TStringList.Create;
  tmplist.LoadFromFile(aCueFilename);

  // FileFound:
  // Search for a FILE - entry with matching filename in the cuesheet-file
  // below this line in the sheet the "interesting data" will be found
  FileFound := False;

  // Create CueList or Clear existing
  if not assigned(Cuelist) then
    CueList := TObjectlist.Create(True)
  else
    CueList.Clear;

  aCue := Nil;
  for i:=0 to tmplist.Count - 1 do
  begin
    if Not FileFound then
    begin
          // search for FILE
          if (GetCueID(tmplist[i]) = CUE_ID_FILE) then
          begin
            // FILE found - Check filename
            if AnsiSameText (GetFileNameFromCueString(tmplist[i]) , aAudioFilename) then
               FileFound := True;
          end;
    end else
    begin
      // A FILE was found. Determine cue-information
      case GetCueID(tmplist[i]) of
        CUE_ID_TRACK: begin
                        aCue := TAudioFile.Create;
                        CueList.Add(aCue);
                      end;
        CUE_ID_TITLE: begin
                        if assigned(aCue) then
                          aCue.Titel := copy(trim(tmplist[i]), 7, length(tmplist[i]));
                      end;
        CUE_ID_PERFORMER: begin
                        if assigned(aCue) then
                          aCue.Artist := copy(trim(tmplist[i]), 11, length(tmplist[i]));
                      end;
        CUE_ID_INDEX: begin
                        if assigned(aCue) then
                        begin
                            CueParselist := Explode(' ', trim(tmplist[i]));
                            if CueParselist.Count > 0 then
                            begin
                                CueTimelist := explode(':', CueParselist[CueParselist.Count - 1]);
                                try
                                    if CueTimeList.Count > 0 then
                                      aCue.FIndex01 := 60 * StrToInt(CueTimelist[0]);
                                    if CueTimeList.Count > 1 then
                                      aCue.FIndex01 := aCue.FIndex01 + StrToInt(CueTimelist[1]);
                                    if CueTimeList.Count > 2 then
                                      aCue.FIndex01 := aCue.FIndex01 + (StrToInt(CueTimelist[2]) / 75);
                                except
                                    CueList.Extract(aCue);
                                    FreeAndNil(aCue);
                                end;
                                CueTimelist.free;
                            end;
                            CueParselist.Free;
                        end;
                      end;
        CUE_ID_FILE: break;
                     // Next FILE found. Break.
      end;
    end;
  end;
  tmplist.Free;
  result := True;
end;

{
    --------------------------------------------------------
    GenerateCSVString
    --------------------------------------------------------
}
function TAudioFile.GenerateCSVString: UnicodeString;
var vbrstr, Lyricsstr : UnicodeString;
begin
  if fvbr then
    vbrstr := 'vbr'
  else
    vbrstr := 'cbr';

  if LyricsExisting then
    Lyricsstr := 'ok'
  else
    Lyricsstr := 'N/A';

  result :=
    StringReplace(Artist, ';', ',', [rfReplaceAll]) + ';' +
    StringReplace(Titel, ';', ',', [rfReplaceAll]) + ';' +
    StringReplace(Album, ';', ',', [rfReplaceAll]) + ';' +
    StringReplace(Genre, ';', ',', [rfReplaceAll]) + ';' +
    StringReplace(Year, ';', ',', [rfReplaceAll]) + ';' +
    IntToStr(Track) + ';' +
    StringReplace(Dateiname, ';', ',', [rfReplaceAll]) + ';' +
    StringReplace(Ordner, ';', ',', [rfReplaceAll]) + ';' +
    IntToStr(fFileSize) + ';' +
    IntToStr(Duration) + ';' +
    IntToStr(fBitrate) + ';' +
    ChannelMode + ';' +
    SamplerateShort + ';' +
    IntToStr(Rating) + ';' +
    IntToStr(PlayCounter) + ';' +
    vbrstr + ';' +
    Lyricsstr  ;
end;

{
    --------------------------------------------------------
    ReadTextFromStream
    Note: Probably only the case-2-code is used, as I use
          only utf-8-encoding for saving Audiofiles since
          Nemp Version-I-Dont-Know
    --------------------------------------------------------
}
function TAudioFile.ReadTextFromStream(aStream: TStream): UnicodeString;
var tmpStr: String;
    TextEncoding: Byte;
    len: integer;
    tmputf8: UTF8String;
begin
  aStream.Read(TextEncoding, SizeOf(TextEncoding));
  case TextEncoding of
      0:  begin
            // Ansi
            aStream.Read(len,sizeof(len));
            setlength(tmpStr, len);
            aStream.Read(Pchar(tmpStr)^,len);
            result := tmpstr;
          end;
      1: begin
            // Unicode
            aStream.Read(len,sizeof(len));
            Setlength(result, len Div 2);
            aStream.Read(PWidechar(result)^,len);
          end
      else begin // UTF8
            aStream.Read(len,sizeof(len));
            setlength(tmputf8, len);
            aStream.Read(PAnsiChar(tmputf8)^, len);
            result := UTF8ToString(tmputf8);
         end;
  end;
end;

{
    --------------------------------------------------------
    LoadFromStream
    Load AudioFile-structure from stream
    --------------------------------------------------------
}
procedure TAudioFile.LoadFromStream(aStream: Tstream);
var GenreIDX:byte;
    c: Integer;
    katold:byte;
    tmp: UnicodeString;
    Id: Byte;
    dummy: Integer;
    Wyear: word;
    DummyByte: Byte;
    DummyInt: Integer;
    Dummystr: UnicodeString;
begin
    // Note: First Dummy was used for the size of the Audiofile data
    // not used anymore.
    aStream.Read(dummy, SizeOf(dummy));
    c := 0;
    repeat
        aStream.Read(id, sizeof(ID));
        inc(c);
        case ID of
            MP3DB_PFAD: begin
                tmp := ReadTextFromStream(aStream);
                pfad := tmp;
            end;
            MP3DB_ARTIST: Artist := ReadTextFromStream(aStream);
            MP3DB_TITEL: Titel := ReadTextFromStream(aStream);
            MP3DB_ALBUM: Album := ReadTextFromStream(aStream);
            MP3DB_DAUER: aStream.Read(fDuration,SizeOf(fDuration));
            MP3DB_BITRATE: aStream.Read(fBitrate,SizeOf(fBitrate));
            MP3DB_VBR: aStream.Read(fvbr,SizeOf(fvbr));
            MP3DB_CHANNELMODE: begin
                            aStream.Read(fChannelmodeIDX, SizeOf(fChannelModeIDX));
                            if fChannelmodeIDX > 4 then
                                fChannelmodeIDX := 1;
            end;
            MP3DB_SAMPLERATE: begin
                            aStream.Read(fSamplerateIDX,SizeOf(fSamplerateIDX));
                            if fSamplerateIDX > 9 then
                                fSamplerateIDX := 7;
            end;
            MP3DB_FILESIZE: aStream.Read(fFileSize,SizeOf(fFileSize));
            MP3DB_TRACK: aStream.Read(fTrack, SizeOf(fTrack));
            MP3DB_KATEGORIE: aStream.Read(katold,SizeOf(katold));
            MP3DB_YEAR: begin
                aStream.Read(WYear, SizeOf(WYear));
                Year := IntToStr(WYear);
            end;
            MP3DB_GENRE: begin
                aStream.Read(GenreIDX,SizeOf(GenreIDX));
                if GenreIDX <= 125 then
                  genre := Genres[GenreIDX]
                else
                  genre := '';
            end;
            MP3DB_GENRE_STR: genre := ReadTextFromStream(aStream);
            MP3DB_LYRICS: Lyrics := UTF8String(Trim(ReadTextFromStream(aStream)));
            MP3DB_ID3KOMMENTAR: Comment := ReadTextFromStream(aStream);
            MP3DB_COVERID: CoverID := ReadTextFromStream(aStream);

            MP3DB_RATING : aStream.Read(fRating, sizeOf(fRating));
            MP3DB_CUEPRESENT  : aStream.Read(DummyInt, sizeOf(DummyInt));

            MP3DB_DUMMY_Byte2 : aStream.Read(DummyByte, sizeOf(DummyByte));
            MP3DB_PLAYCOUNTER  : aStream.Read(fPlayCounter, sizeOf(fPlayCounter));
            MP3DB_DUMMY_Int3  : aStream.Read(DummyInt, sizeOf(DummyInt));
            MP3DB_LASTFM_TAGS : RawTagLastFM := ReadTextFromStream(aStream);
            //MP3DB_DUMMY_Text1 : DummyStr := ReadTextFromStream(aStream);
            MP3DB_DUMMY_Text2 : DummyStr := ReadTextFromStream(aStream);
            MP3DB_DUMMY_Text3 : DummyStr := ReadTextFromStream(aStream);

            else begin
              // Something is wrong. Stop reading.
               c := MP3DB_ENDOFINFO;
            end;
        end;
    until (ID = MP3DB_ENDOFINFO) OR (c >= MP3DB_ENDOFINFO);
end;


{
    --------------------------------------------------------
    LoadFromStreamForPlaylist
    Load AudioFile-structure from stream
    Difference to previous method: Filenames are realtive ones.
    Note: Make sure that SetCurrentDir is called before this method!
    --------------------------------------------------------
}
procedure TAudioFile.LoadFromStreamForPlaylist(aStream: TStream);
var GenreIDX:byte;
    c, cuePresent: Integer;
    katold:byte;
    tmp: UnicodeString;
    Id: Byte;
    dummy: Integer;
    Wyear: word;
    DummyByte: Byte;
    DummyInt: Integer;
    Dummystr: UnicodeString;

begin
    aStream.Read(dummy, SizeOf(dummy));
    c := 0;
    repeat
        aStream.Read(id, sizeof(ID));
        inc(c);
        case ID of
            MP3DB_PFAD: begin
                tmp := ReadTextFromStream(aStream);
                if PathSeemsToBeURL(tmp) then
                begin
                    isStream := True;
                    FileIsPresent := True;
                    Pfad := tmp;
                end else
                begin
                    isStream := False;
                    pfad := ExpandFilename(tmp);
                end;

            end;
            MP3DB_ARTIST: Artist := ReadTextFromStream(aStream);
            MP3DB_TITEL: Titel := ReadTextFromStream(aStream);
            MP3DB_ALBUM: Album := ReadTextFromStream(aStream);
            MP3DB_DAUER: aStream.Read(fDuration,SizeOf(fDuration));
            MP3DB_BITRATE: aStream.Read(fBitrate,SizeOf(fBitrate));
            MP3DB_VBR: aStream.Read(fvbr,SizeOf(fvbr));
            MP3DB_CHANNELMODE: aStream.Read(fChannelmodeIDX, SizeOf(fChannelModeIDX));
            MP3DB_SAMPLERATE: aStream.Read(fSamplerateIDX,SizeOf(fSamplerateIDX));
            MP3DB_FILESIZE: aStream.Read(fFileSize,SizeOf(fFileSize));
            MP3DB_TRACK: aStream.Read(fTrack, SizeOf(fTrack));
            MP3DB_KATEGORIE: aStream.Read(katold,SizeOf(katold));
            MP3DB_YEAR: begin
                aStream.Read(WYear, SizeOf(WYear));
                Year := inttostr(WYear);
            end;
            MP3DB_GENRE: begin
                aStream.Read(GenreIDX,SizeOf(GenreIDX));
                if GenreIDX <= 125 then
                  genre := Genres[GenreIDX]
                else
                  genre := '';
            end;
            MP3DB_GENRE_STR: genre := ReadTextFromStream(aStream);
            MP3DB_LYRICS: Lyrics := Utf8String(Trim(ReadTextFromStream(aStream)));
            MP3DB_ID3KOMMENTAR: Comment := ReadTextFromStream(aStream);
            MP3DB_COVERID: CoverID := ReadTextFromStream(aStream);

            MP3DB_RATING : aStream.Read(fRating, sizeOf(fRating));
            MP3DB_CUEPRESENT  : begin
                                    aStream.Read(cuePresent, sizeOf(cuePresent));
                                    GetCueList;
                                end;
            MP3DB_DUMMY_Byte2 : aStream.Read(DummyByte, sizeOf(DummyByte));
            //MP3DB_DUMMY_Int1  : aStream.Read(DummyInt, sizeOf(DummyInt));
            MP3DB_PLAYCOUNTER  : aStream.Read(fPlayCounter, sizeOf(fPlayCounter));
            MP3DB_DUMMY_Int3  : aStream.Read(DummyInt, sizeOf(DummyInt));
            //MP3DB_DUMMY_Text1 : DummyStr := ReadTextFromStream(aStream);
            MP3DB_LASTFM_TAGS : RawTagLastFM := ReadTextFromStream(aStream);
            MP3DB_DUMMY_Text2 : DummyStr := ReadTextFromStream(aStream);
            MP3DB_DUMMY_Text3 : DummyStr := ReadTextFromStream(aStream);

            else begin
              c := MP3DB_ENDOFINFO;
            end;
        end;
    until (ID = MP3DB_ENDOFINFO) OR (c >= MP3DB_ENDOFINFO); 
end;


{
    --------------------------------------------------------
    Methods for writing the stuff ...
    --------------------------------------------------------
}
procedure TAudioFile.WriteTextToStream(aStream: TStream; ID: Byte; wString: UnicodeString);
var TextEncoding: Byte;
    len: integer;
    tmpStr: UTF8String;
begin
  TextEncoding := 2; // UTF-8

  aStream.Write(ID,sizeof(ID));
  aStream.Write(TextEncoding,sizeof(TExtEncoding));

  tmpstr := UTF8Encode(wString);
  len := length(tmpstr);
  aStream.Write(len,SizeOf(len));
  aStream.Write(PAnsiChar(tmpstr)^,len);

end;

procedure TAudioFile.SaveToStream(aStream: Tstream; aPath: UnicodeString = '');
var
    GenreIDXint:integer;
    GenreIDX: byte;
    Id: Byte;
    CuePresent: Integer;
    dummy: Integer;
    Wyear: word; 
begin
    dummy := 0;
    aStream.Write(dummy,SizeOf(dummy));
    if aPath = '' then
        // write filename incl. path
        WriteTextToStream(aStream, MP3DB_PFAD, Pfad)
    else
    begin
        // write only the name in the parameter
        // used by npl-playlist for relative filenames
        WriteTextToStream(aStream, MP3DB_PFAD, aPath);
        // On Playlistfiles: write whether cuesheet is present or not
        if Assigned(CueList) and (CueList.Count > 0) then
        begin
            ID := MP3DB_CUEPRESENT;
            CuePresent := 1;
            aStream.Write(ID,sizeof(ID));
            aStream.Write(CuePresent, sizeOf(CuePresent));
        end;
    end;

    if length(Artist)>0 then
      WriteTextToStream(aStream, MP3DB_ARTIST, Artist);

    if length(titel)>0 then
      WriteTextToStream(aStream, MP3DB_TITEL, Titel);

    if length(Album)>0 then
      WriteTextToStream(aStream, MP3DB_ALBUM, Album);

    if RawTagLastFM <> '' then
        WriteTextToStream(aStream, MP3DB_LASTFM_TAGS, RawTagLastFM);

    if Duration <> 0 then
    begin
      ID:=MP3DB_DAUER;
      aStream.Write(ID,sizeof(ID));
      aStream.Write(fDuration,sizeOf(fDuration));
    end;

    if bitrate <> 192 then
    begin
      ID:=MP3DB_BITRATE;
      aStream.Write(ID,sizeof(ID));
      aStream.Write(fBitrate,sizeOf(fBitrate));
    end;

    ID:=MP3DB_VBR;
    aStream.Write(ID,sizeof(ID));
    aStream.Write(fvbr,sizeOf(fvbr));

    if fChannelModeIDX <> 1 then
    begin
      ID:=MP3DB_CHANNELMODE;
      aStream.Write(ID,sizeof(ID));
      aStream.Write(fChannelmodeIDX,SizeOf(fChannelmodeIDX));
    end;

    if fSamplerateIDX <> 7 then
    begin
      ID:=MP3DB_SAMPLERATE;
      aStream.Write(ID,sizeof(ID));
      aStream.Write(fSamplerateIDX,SizeOf(fSamplerateIDX));
    end;

    ID:=MP3DB_FILESIZE;
    aStream.Write(ID,sizeof(ID));
    aStream.Write(fFileSize,sizeOf(fFileSize));

    if Track <> 0 then
    begin
      ID := MP3DB_TRACK;
      aStream.Write(ID, SizeOf(Id));
      aStream.Write(Track, SizeOf(Track));
    end;

    if fRating <> 0 then
    begin
      ID := MP3DB_RATING;
      aStream.Write(ID, SizeOf(Id));
      aStream.Write(fRating, SizeOf(fRating));
    end;

    if fPlayCounter <> 0 then
    begin
      ID := MP3DB_PLAYCOUNTER;
      aStream.Write(ID, SizeOf(Id));
      aStream.Write(fPlayCounter, SizeOf(fPlayCounter));
    end;

    if Year<>'' then
    begin
      ID := MP3DB_YEAR;
      WYear := StrToIntDef(Year, 0);
      aStream.Write(ID,sizeof(ID));
      aStream.Write(WYear,SizeOf(WYear));
    end;


    GenreIDXint := Genres.IndexOf(genre);
    if GenreIDXint = -1 then
    begin
          // No Standard-Genre - write String
          WriteTextToStream(aStream, MP3DB_GENRE_STR, Genre);
    end else
    begin
          // Standard-Genre: just write the corresponding byte
          ID := MP3DB_GENRE;
          aStream.Write(ID,sizeof(ID));
          GenreIDX := Byte(GenreIDXint);
          aStream.Write(GenreIDX,sizeof(GenreIDX));
    end;

    if length(lyrics) > 0 then
      WriteTextToStream(aStream, MP3DB_LYRICS, String(lyrics));


    if length(Comment) > 0 then
      WriteTextToStream(aStream, MP3DB_ID3KOMMENTAR, Comment);

    if CoverID <> '' then
      WriteTextToStream(aStream, MP3DB_COVERID, CoverID);
                             
    // End of AudioFile
    ID := MP3DB_ENDOFINFO;
    aStream.Write(ID,sizeof(ID));
end;



initialization

// Set the DefaultRatingDescription for MP3FileUtils
DefaultRatingDescription := 'Nemp - Noch ein MP3-Player, www.gausi.de';



end.
