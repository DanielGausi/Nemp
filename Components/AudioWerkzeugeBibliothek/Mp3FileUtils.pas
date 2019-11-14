{
  -------------------------------------------------------

  The contents of this file are subject to the Mozilla Public License
  Version 1.1 (the "License"); you may not use this file except in
  compliance with the License. You may obtain a copy of the License at
  http://www.mozilla.org/MPL/

  Software distributed under the License is distributed on an "AS IS"
  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
  License for the specific language governing rights and limitations
  under the License.

  The Original Code is MP3FileUtils.

  The Initial Developer of the Original Code is Daniel Gaussmann,
  mail@gausi.de. Portions created by the Initial Developer are
  Copyright (C) 2005-2011 the Initial Developer. All Rights Reserved.

  Contributor(s): (none yet)

  Alternatively, the contents of this file may be used under the terms
  of the GNU Lesser General Public License Version 2.1 or later
  (the  "LGPL"), in which case the provisions of LGPL are applicable
  instead of those above. If you wish to allow use of your version of
  this file only under the terms of the LGPL and not to allow others to use
  your version of this file under the MPL, indicate your decision by
  deleting the provisions above and replace them with the notice and
  other provisions required by the LGPL. If you do not delete
  the provisions above, a recipient may use your version of this file
  under either the MPL or the LGPL License.

  -------------------------------------------------------
}

{
 Extract and set several information in mp3-Files.

      - TID3v1Tag:
        Read and write ID3v1-Tags
        All information are supported
        Version 1.1 is supported

      - TMpegInfo
        Read MPEG-information (bitrate, duration, ...)

      - TID3v2Tag:
        Read and write ID3v2-Tags.
        Support for all sub-versions (2.2, 2.3, 2.4)

      - TID3v2Frame:
        Edit ID3v2-Tag on Frame-level (experienced users only)


  Supported Third-Party-Tools
  ========================================================================================================
    - TntWare Delphi Unicode Controls
      Download: http://www.tntware.com/delphicontrols/unicode/
      Note: Tnt is only used for File-Access.
            If you just need Ansi-Filenames, you will NOT need TNTs
            Delphi 2009 do not need the TNTs.


  Version-History
  ========================================================================================================

  March 2016: v0.6c -> v0.6d
  ==========================
    - added support for the "Info"-variant of the XING-Header in some CBR-files

  June 2012: v0.6b -> v0.6c
  ==========================
  Bugfix
    - getConvertedUnicodeText corrected for TE_UTF16, but actuallay no BOM is present

  June 2012: v0.6a -> v0.6b
  ==========================
  Bugfix
    - correct computation of bitrate and duration in MPEG 2 Layer 3 files
      with varible bitrate (Xing-Header)
    - Renamed "genres" to "ID3Genres" and outsourced it into ID3GenreList.pas

  December 2011: v0.6 -> v0.6a
  ============================
  Bugfix
    - method SetRatingAndCounter didn't work properly, when no POPM-Frame
      was in the file: Instead of writing the Rating and Playcounter into the Tag,
      the Value for "Playcounter" was written as "Rating".


  June 2011: v0.5b -> v0.6
  ========================
  New features
    - Private Frames
    - VBRI-Header-Detection
    - added some more genres to the Genres-List
    - added methods GetUserText, SetUserText, GetAllUserTextFrames,
      deleted TXXX-Frames from GetAllTextFrames
      (see TXXX-Bugfix below)

  Changes
    - ID3v2Tag.ReadFromStream: Copy all frames into a memorystream before reading
    - deleted methods SetRating and SetPersonalPlayCounter
      use SetRatingAndCounter instead to set both values at once
      (both values are stored in the same frame)

  Bugfixes
    - correct reading of UTF8-encoded Textframes with Delphi2009
    - ExtendedHeader-Size has been misinterpreted
    - User defined Textframes (TXXX) have NOT the same structure as other Textframes
    - result of TMpegInfo.GetframeLength is integer (negative value is used as error indication),
      but TMpegHeader.Framelentgh is Word. The direct assignment provided some errors whith
      range checking enabled


  August 2009: v0.5a -> 0.5b
  ========================
    - Fatal Bug fixed: ID3-v1-Tag could not be deleted in Delphi 2009, and every
      write-access (WriteToFile/-Stream) to ID3v1-Tags created a new one at the
      end of the file. (This was the case only in Delphi 2009, it was a
      Char-AnsiChar-thingy.)
    - DefaultRatingDescription is a var now.
    - Added frame-support for PlayCounter. Not the PCNT-Frame, but the
      counter included within Rating-Frames.
      (Use with care, this is not tested very well. This should have come along
      with some more new features (private-frames), but someone showed me
      this ID3v1-bug, which really must be fixed.)

  April 2009: v0.5 -> 0.5a (not published)
  ========================
    - fixed a possible memory-leak in TID3v2Tag.RemoveFromStream

  April 2009: v0.4a -> 0.5
  ========================
    - update to Delphi 2009
    - kicked out DIConverters.
      Conversion will now use the MultiByteToWideChar-Function from the Windows-API
      (-) some codepages are not supported any longer
      (+) easier to use, no third-party-stuff required
      (+) smaller binary
    - kicked out some methods, which were declared "deprecated" in v0.4
    - AcceptAllEncodings replaced by AutoCorrectCodepage
    - CharCode replaced by CodePage
    - GetCharcode replaced by GetCodePage
    - added TMpegInfo.Duration (same as .Dauer, just for the english users ;-) )
    - fixed a bug which possibly caused invalid encoded URLs on "Unicode-filenames"
    - fixed a problem with activated range-checking and PaddingSize of zero
    - translated (most) comments to english

  Dezember 2008: v0.4 -> 0.4a (sorry, from here on only german ;-))
  ===========================
    - Fehler behoben, der bei Tags mit einer bestimmten Text-Kodierung das letzte
      Zeichen der Textfelder abschnitt

  Juni 2008: v0.3b -> 0.4
  =======================
    - Code anders strukturiert - einiges in die Klasse TID3v2Frame ausgelagert
    - Unterstützung von Unsynchronisation
    - Unterstützung von GroupID und DataLength-Flags in Frame-Headern
    - Bei Compression und/oder Encryption wird das Auslesen abgebrochen
    - Unterstützung von URLs
    - Unterstützung von Bewertungen
    - Fehler in der Behandlung bei "Beschreibungen" mit Unicode - das führte u.a. dazu,
      dass viele Cover in Dateien von jamendo.com nicht angezeigt wurden.

  Februar 2008: v0.3a -> 0.3b
  ==========================
    - Funktion GetTrackFromV2TrackString hinzugefügt
    - Bug in der Funktion GetPaddingSize behoben

  Juni 2007: v0.3 -> 0.3a
  ==========================
    - Bei den Gettern des ID3v1-Tags wurden häufig Leerstellen und/oder Nullbytes mit übergeben, was ein Trim() außerhalb
      der Klasse nötig machte. Das wurde korrigiert - das trim() wird jetzt hier intern gemacht.
    - Schönheitsfehler bei der Benennung beseitigt: TPictureFrameDes()ription heißt jetzt TPictureFrameDes(c)ription


  Februar 2007: v0.2a -> 0.3
  ==========================
    - INT/WE- Versionen über Compiler-Schalter vereint.
      Siehe dazu das Ende dieses einleitenden Kommentars
    - Fehler entfernt, die bei einer Verkleinerung des ID3v2-Tags unter gewissen Umständen zu unschönen
      Effekten bei den getaggten mp3s führte - die letzten Frames/Sekunden des Liedes wurden dann doppelt
      abgespielt.
    - intelligenteres Padding-System (abhängig von der Clustergröße)
      für den ID3v1Tag werden 128 Byte im Cluster freigehalten (falls er nicht existiert), so
      dass ein nachträgliches Einfügen keinen Zusatzplatz benötigt.


  ========================================================================================================
  September 2006: v0.2 -> 0.2a (beide Versionen)
  ==============================================
    - katastrophalen Bug behoben, der ungültige ID3v2-TextFrames erzeugt.


  August 2006:  v0.1 -> v0.2(International)
  =========================================

    Kleinere Bugs:
    ==============
    - Der ID3v1-Tag wurde vor dem Lesen nicht gelöscht, so dass u.U noch alte Informationen übrigblieben
    - Unter gewissen Umständen wurden Lyrics und Comments bei ID3v2 nicht richtig ausgelesen.
      Das lag aber an fehlerhaften Language-Informationen, die jetzt ausgebügelt werden.
    - Fehler beim Lesen einer Variante von Unicode behoben (Stichwort: Byte-Order)
    - Finalize-Abschnitt (wieder) hinzugefügt. Der ist zwischendurch mal irgendwo verlorengegangen.

    Updates/Änderungen:
    ===================
       Klasse TID3v1Tag:
       -----------------
       - in der 'International'-Version werden alle Textinformationen als WideString zurückgeliefert
       - beim Lesen findet ggf. eine Konvertierung statt, die vom CharCode abhängt.
         Mit Hilfe der Funktion GetCharCode aus der Unit U_CharCode (mitgeliefert) kann
         der beim Taggen verwendete Zeichensatz anhand des Dateinamens bestimmt werden.
         Das funktioniert natürlich nur mit einer gewissen Fehlerquote. Mehr dazu in der Datei 'Unicode.txt'.
       - beim Schreiben wird ebenfalls dieser Zeichensatz verwendet und der WideString entsprechend konvertiert
       - Flag 'AcceptAllEncodings' hinzugefügt. Ist dieser 'False', findet keine Konvertierung statt
         (weder beim schreiben, noch beim lesen).
         Was das für einen Effekt auf Systemen außerhalb Westeuropas hat, kann ich nicht genau sagen.

       Klasse TID3v2Tag:
       -----------------
       - Sämtliche TextInformationen werden jetzt als WideString geliefert.
       - Textinformationen werden automatisch im Unicode-Format gespeichert, falls dies nötig ist.
       - Flag 'AlwaysWriteUnicode' hinzugefügt. Ist dies gesetzt, wird immer im Unicode-Format gespeichert,
         auch wenn das nicht nötig ist (d.h. wenn nur "Standard"-Buchstaben verwendet werden)
       - beim Lesen findet ggf. eine Konvertierung statt, die vom CharCode abhängt.
         Mit Hilfe der Funktion GetCharCode aus der Unit U_CharCode (mitgeliefert) kann
         der beim Taggen verwendete Zeichensatz anhand des Dateinamens bestimmt werden.
         Im Gegensatz zur Klasse ID3v1Tag tritt dies nur dann auf, wenn beim Taggen auf Unicode verzichtet
         wurde. D.h. auch wenn das Flag 'AcceptAllEncodings' nicht gesetzt ist, kann man kyrillische oder asiatische (oder...)
         Zeichen erhalten. Dies sollte eigentlich sogar die Regel sein - ist es aber nicht, weswegen ich den ganzen
         Kram mit der Konvertierung überhaupt implementieren musste.
         Das funktioniert natürlich nur mit einer gewissen Fehlerquote. Mehr dazu in der Datei 'Unicode.txt'.
       - Flag 'AcceptAllEncodings' hinzugefügt. Ist dieser 'False', findet keine Konvertierung statt

}

unit Mp3FileUtils;

{$I config.inc}

interface

uses
  SysUtils, Classes, Windows, Contnrs, dialogs, U_CharCode
  {$IFDEF USE_SYSTEM_TYPES}, System.Types{$ENDIF}
  {$IFDEF USE_TNT_COMPOS}, TntSysUtils, TntClasses{$ENDIF}, Id3v2Frames;

type

  {$IFDEF USE_TNT_COMPOS}
      TMPFUFileStream = TTNTFileStream;
  {$ELSE}
      TMPFUFileStream = TFileStream;
  {$ENDIF}



//--------------------------------------------------------------------
// Teil 1: Some small helpers
//--------------------------------------------------------------------
  TBuffer = Array of byte;
  TMP3Error = (MP3ERR_None, MP3ERR_NoFile, MP3ERR_FOpenCrt, MP3ERR_FOpenR,
               MP3ERR_FOpenRW, MP3ERR_FOpenW, MP3ERR_SRead, MP3ERR_SWrite,
               ID3ERR_Cache, ID3ERR_NoTag, ID3ERR_Invalid_Header, ID3ERR_Compression,
               ID3ERR_Unclassified,
               MPEGERR_NoFrame );
  TID3Version = record
    Major: Byte;
    Minor: Byte;
  end;
//--------------------------------------------------------------------


//--------------------------------------------------------------------
// Teil 2: Types for ID3v1-tag
//--------------------------------------------------------------------
  String4  = String[4];          // OK. ShortStrings are short AnsiStrings in Delphi2009
  String30 =  String[30];

  // Structure of ID3v1Tags in the file
  TID3v1Structure = record
    ID: array[1..3] of AnsiChar;               // all together 128 Bytes
    Title: Array [1..30] of AnsiChar;          // Use AnsiChars
    Artist: Array [1..30] of AnsiChar;
    Album: Array [1..30] of AnsiChar;
    Year: array [1..4] of AnsiChar;
    Comment: Array [1..30] of AnsiChar;
    Genre: Byte;
  end;

  TID3v1Tag = class(TObject)
  private
    FTitle: String30;
    FArtist: String30;
    FAlbum: String30;
    FComment: String30;
    FTrack: Byte;
    FYear: String4;
    FGenre: Byte;
    FExists: Boolean;
    FVersion: Byte;

    // convert the ansi-data to UnicodeString using a codepage
    // * use GetCodepage(Filename) to get the probably used codepage
    // * fAutoCorrectCodepage = False: Use the System-Codepage
    fAutoCorrectCodepage: Boolean;
    FCharCode: TCodePage;
    function GetConvertedUnicodeText(Value: String30): UnicodeString;

    function GetTitle: UnicodeString;
    function GetArtist: UnicodeString;
    function GetAlbum: UnicodeString;
    function GetComment: UnicodeString;

    function GetGenre: String;  // Delphi-Default-String. Just for display, as Genre is stored as one byte
    function GetTrack: String;  // Delphi-Default-String. Just for display, as Track is stored as one byte
    function GetYear: String4;

    function SetString30(value: UnicodeString): String30;
    procedure SetTitle(Value: UnicodeString);
    procedure SetArtist(Value: UnicodeString);
    procedure SetAlbum(Value: UnicodeString);
    procedure SetGenre(Value: String);         // Delphi-Default-String.
    procedure SetYear(Value: String4);
    procedure SetComment(Value: UnicodeString);
    procedure SetTrack(Value: String);        // Delphi-Default-String.
  public
    constructor Create;
    destructor Destroy; override;
    property TagExists: Boolean read FExists;
    property Exists:    Boolean read FExists;

    property Version: Byte read FVersion;
    property Title: UnicodeString read GetTitle write SetTitle;
    property Artist: UnicodeString read GetArtist write SetArtist;
    property Album: UnicodeString read GetAlbum write SetAlbum;
    property Genre: String read GetGenre write SetGenre;     // Delphi-Default-String.
    property Track: String read GetTrack write SetTrack;     // Delphi-Default-String.
    property Year: String4 read GetYear write SetYear;
    property Comment: UnicodeString read GetComment write SetComment;

    property CharCode: TCodePage read FCharCode write FCharCode;
    property AutoCorrectCodepage: Boolean read FAutoCorrectCodepage write FAutoCorrectCodepage;

    procedure Clear;
    function ReadFromStream(Stream: TStream): TMP3Error;
    function WriteToStream(Stream: TStream): TMP3Error;
    function RemoveFromStream(Stream: TStream): TMP3Error;
    function ReadFromFile(Filename: UnicodeString): TMP3Error;        // UnicodeString
    function WriteToFile(Filename: UnicodeString): TMP3Error;
    function RemoveFromFile(Filename: UnicodeString): TMP3Error;
  end;
//--------------------------------------------------------------------



//--------------------------------------------------------------------
// Teil 3: Types for ID3v2-tags
//--------------------------------------------------------------------
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

  TID3v2Tag = class(TObject)
  private
    Frames: TObjectList;
    fExists: Boolean;
    fVersion: TID3Version;
    fFlgUnsynch: Boolean;
    fFlgCompression: Boolean;
    fFlgExtended: Boolean;
    fFlgExperimental: Boolean;
    fFlgFooterPresent: Boolean;
    fFlgUnknown: Boolean;
    fPaddingSize: LongWord;
    fTagSize: LongWord;
    fDataSize: LongWord;
    fUsePadding: Boolean;
    fUseClusteredPadding: Boolean;
    fFilename: UnicodeString;

    // Always write Unicode?
    // True: frames will be written as utf-16 always
    // False: ..only if needed, Ansi otherwise (recommended for compatibilty to other taggers ;-))
    fAlwaysWriteUnicode: Boolean;
    fAutoCorrectCodepage: Boolean;
    fCharCode: TCodePage;

    function GetFrameIDString(ID:TFrameIDs):AnsiString;

    function GetFrameIndex(ID:TFrameIDs):integer;
    function GetUserTextFrameIndex(aDescription: UnicodeString): integer;
    function GetDescribedTextFrameIndex(ID:TFrameIDs; Language:AnsiString; Description:UnicodeString): Integer;
    function GetPictureFrameIndex(aDescription: UnicodeString): Integer;
    function GetUserDefinedURLFrameIndex(Description: UnicodeString): Integer;
    function GetPopularimaterFrameIndex(aEMail: AnsiString):integer;
    function GetPrivateFrameIndex(aOwnerID: AnsiString): Integer;

    function GetDescribedTextFrame(ID:TFrameIDs; Language:AnsiString; Description: UnicodeString): UnicodeString;
    procedure SetDescribedTextFrame(ID:TFrameIDs; Language:AnsiString; Description: UnicodeString; Value: UnicodeString);

    function ReadFrames(From: LongInt; Stream: TStream): TMP3Error;
    function ReadHeader(Stream: TStream): TMP3Error;
    procedure SyncStream(Source, Target: TStream);

    // property read functions
    function GetTitle: UnicodeString;
    function GetArtist: UnicodeString;
    function GetAlbum: UnicodeString;
    function ParseID3v2Genre(value: UnicodeString): UnicodeString;
    function GetGenre: UnicodeString;
    function GetTrack: UnicodeString;
    function GetYear: UnicodeString;
    function GetStandardComment: UnicodeString;
    function GetStandardLyrics: UnicodeString;
    function GetComposer: UnicodeString;
    function GetOriginalArtist: UnicodeString;
    function GetCopyright: UnicodeString;
    function GetEncodedBy: UnicodeString;
    function GetLanguages: UnicodeString;
    function GetSoftwareSettings: UnicodeString;
    function GetMediatype: UnicodeString;
    function Getid3Length: UnicodeString;
    function GetPublisher: UnicodeString;
    function GetOriginalFilename: UnicodeString;
    function GetOriginalLyricist: UnicodeString;
    function GetOriginalReleaseYear: UnicodeString;
    function GetOriginalAlbumTitel: UnicodeString;

    //property set functions
    procedure SetTitle(Value: UnicodeString);
    procedure SetArtist(Value: UnicodeString);
    procedure SetAlbum(Value: UnicodeString);
    function BuildID3v2Genre(value: UnicodeString): UnicodeString;
    procedure SetGenre(Value: UnicodeString);
    procedure SetTrack(Value: UnicodeString);
    procedure SetYear(Value: UnicodeString);
    procedure SetStandardComment(Value: UnicodeString);
    procedure SetStandardLyrics(Value: UnicodeString);
    procedure SetComposer(Value: UnicodeString);
    procedure SetOriginalArtist(Value: UnicodeString);
    procedure SetCopyright(Value: UnicodeString);
    procedure SetEncodedBy(Value: UnicodeString);
    procedure SetLanguages(Value: UnicodeString);
    procedure SetSoftwareSettings(Value: UnicodeString);
    procedure SetMediatype(Value: UnicodeString);
    procedure Setid3Length(Value: UnicodeString);
    procedure SetPublisher(Value: UnicodeString);
    procedure SetOriginalFilename(Value: UnicodeString);
    procedure SetOriginalLyricist(Value: UnicodeString);
    procedure SetOriginalReleaseYear(Value: UnicodeString);
    procedure SetOriginalAlbumTitel(Value: UnicodeString);

    function GetStandardUserDefinedURL: AnsiString;
    procedure SetStandardUserDefinedURL(Value: AnsiString);

    // SetRatingAndCounter: use aRating = -1 or aCounter = -1 to let this value untouched
    //                      use aRating = 0 AND aCounter = 0 to delete the frame
    //procedure SetRatingAndCounter(aEMail: AnsiString; aRating: Integer {Byte}; aCounter: Integer{Cardinal});
    function GetArbitraryRating: Byte;
    procedure SetArbitraryRating(Value: Byte);
    function GetArbitraryPersonalPlayCounter: Cardinal;
    procedure SetArbitraryPersonalPlayCounter(Value: Cardinal);

    procedure SetCharCode(Value: TCodePage);
    procedure SetAutoCorrectCodepage(Value: Boolean);


  public


    constructor Create;
    destructor Destroy; override;

    // "Level 1": Easy access through properties.
    //            The setter and getter will do all the complicated stuff for you
    property Title:   UnicodeString read GetTitle  write SetTitle;
    property Artist:  UnicodeString read GetArtist write SetArtist;
    property Album:   UnicodeString read GetAlbum  write SetAlbum;
    property Genre:   UnicodeString read GetGenre  write SetGenre;
    property Track:   UnicodeString read GetTrack  write SetTrack;
    property Year:    UnicodeString read GetYear   write SetYear;

    property Comment: UnicodeString read GetStandardComment write SetStandardComment;
    property Lyrics : UnicodeString read GetStandardLyrics write SetStandardLyrics;
    property URL: AnsiString read GetStandardUserDefinedURL write SetStandardUserDefinedURL;
    property Rating: Byte read GetArbitraryRating write SetArbitraryRating;
    property PlayCounter: Cardinal read GetArbitraryPersonalPlayCounter write SetArbitraryPersonalPlayCounter;

    property Composer:         UnicodeString read  GetComposer           write  SetComposer        ;
    property OriginalArtist:   UnicodeString read  GetOriginalArtist     write  SetOriginalArtist  ;
    property Copyright:        UnicodeString read  GetCopyright          write  SetCopyright       ;
    property EncodedBy:        UnicodeString read  GetEncodedBy          write  SetEncodedBy       ;
    property Languages:        UnicodeString read  GetLanguages          write  SetLanguages       ;
    property SoftwareSettings: UnicodeString read  GetSoftwareSettings   write  SetSoftwareSettings;
    property Mediatype:        UnicodeString read  GetMediatype          write  SetMediatype       ;
    property id3Length:           UnicodeString read  Getid3Length           write Setid3Length          ;
    property Publisher:           UnicodeString read  GetPublisher           write SetPublisher          ;
    property OriginalFilename:    UnicodeString read  GetOriginalFilename    write SetOriginalFilename   ;
    property OriginalLyricist:    UnicodeString read  GetOriginalLyricist    write SetOriginalLyricist   ;
    property OriginalReleaseYear: UnicodeString read  GetOriginalReleaseYear write SetOriginalReleaseYear;
    property OriginalAlbumTitel:  UnicodeString read  GetOriginalAlbumTitel  write SetOriginalAlbumTitel ;


    property FlgUnsynch       : Boolean read fFlgUnsynch write fFlgUnsynch;
    property FlgCompression   : Boolean read fFlgCompression;
    property FlgExtended      : Boolean read fFlgExtended;
    property FlgExperimental  : Boolean read fFlgExperimental;
    property FlgFooterPresent : Boolean read fFlgFooterPresent;
    property FlgUnknown       : Boolean read fFlgUnknown;

    property Size:       LongWord    read fTagSize;
    property Exists:     Boolean     read fExists;      //  two properties twice
    property TagExists:  Boolean     read fExists;      //  due to backward compatibility
    property Padding:    Longword    read fPaddingSize; //
    property PaddingSize:Longword    read fPaddingSize; //

    property Version:    TID3Version read fVersion;
    property UsePadding: Boolean     read fUsePadding write fUsePadding;
    property UseClusteredPadding: Boolean read fUseClusteredPadding write fUseClusteredPadding;

    property  AlwaysWriteUnicode: Boolean read fAlwaysWriteUnicode write fAlwaysWriteUnicode;

    property CharCode: TCodePage read fCharCode write SetCharCode;
    property  AutoCorrectCodepage: Boolean read fAutoCorrectCodepage write SetAutoCorrectCodepage;

    function ReadFromStream(Stream: TStream): TMP3Error;
    function WriteToStream(Stream: TStream): TMP3Error;
    function RemoveFromStream(Stream: TStream): TMP3Error;
    function ReadFromFile(Filename: UnicodeString): TMP3Error;
    function WriteToFile(Filename: UnicodeString): TMP3Error;
    function RemoveFromFile(Filename: UnicodeString): TMP3Error;
    procedure Clear;


    // "Level 2": Some advanced Frames. Get/edit them on Tag-Level
    //           Setting a value to '' will delete the frame
    function GetText(FrameID: TFrameIDs): UnicodeString;
    procedure SetText(FrameID:TFrameIDs; Value: UnicodeString);

    // User defined TextFrames (TXXX)
    function GetUserText(Description: UnicodeString): UnicodeString;
    procedure SetUserText(Description, Value: UnicodeString);

    function GetURL(FrameID: TFrameIDs): AnsiString;
    procedure SetURL(FrameID:TFrameIDs; Value: AnsiString);

    // Comments  (COMM)
    // Note: Delete by Set(..., '');
    procedure SetExtendedComment(Language: AnsiString; Description: UnicodeString; value: UnicodeString);
    function GetExtendedComment(Language: AnsiString; Description: UnicodeString): UnicodeString;

    // Lyrics
    // Note: Delete by Set(..., '');
    procedure SetLyrics(Language: AnsiString; Description: UnicodeString; value: UnicodeString);
    function GetLyrics(Language: AnsiString; Description: UnicodeString): UnicodeString;

    // Pictures (APIC)
    // Note: Delete by setting Stream = Nil
    function GetPicture(stream: TStream; Description: UnicodeString): AnsiString; // Rückgabe: Mime-Type
    procedure SetPicture(MimeTyp: AnsiString; PicType: Byte; Description: UnicodeString; stream: TStream);

    // User-defined URL (WXXX)
    // Note: Delete by Set(..., '');
    function GetUserDefinedURL(Description: UnicodeString): AnsiString;
    procedure SetUserDefinedURL(Description: UnicodeString; Value: AnsiString);

    // Ratings (POPM)

    // Note: GetRating('*') gets an arbitrary rating (in case more than one exist in the tag)
    function GetRating(aEMail: AnsiString): Byte;
    //procedure SetRating(aEMail: AnsiString; Value: Byte); (method from version 0.5)
    function GetPersonalPlayCounter(aEMail: AnsiString): Cardinal;
    // procedure SetPersonalPlayCounter(aEMail: AnsiString; Value: Cardinal); (method from version 0.5)

    // SetRatingAndCounter('*', .., ..) overwrites an arbitrary rating/counter
    // SetRatingAndCounter(.., -1, ..) lets the rating untouched
    // SetRatingAndCounter(.., .., -1) lets the counter untouched
    // SetRatingAndCounter(.., 0, 0)  deletes the rating/counter-frame
    procedure SetRatingAndCounter(aEMail: AnsiString; aRating: Integer {Byte}; aCounter: Integer{Cardinal});

    // Private Frames
    function GetPrivateFrame(aOwnerID: AnsiString; Content: TStream): Boolean;
    procedure SetPrivateFrame(aOwnerID: AnsiString; Content: TStream);



    // "Level 3": Manipulation on Frame-Level
    //            Be careful with writing on this level
    //            These Methods gives you some lists with different types of frames
    //            See ID3v2Frames.pas how to edit these Frames
    function GetAllFrames              : TObjectlist; overload;
    function GetAllTextFrames          : TObjectlist; overload;
    function GetAllUserTextFrames      : TObjectlist; overload;
    function GetAllCommentFrames       : TObjectlist; overload;
    function GetAllLyricFrames         : TObjectlist; overload;
    function GetAllUserDefinedURLFrames: TObjectlist; overload;
    function GetAllPictureFrames       : TObjectlist; overload;
    function GetAllPopularimeterFrames : TObjectlist; overload;
    function GetAllURLFrames           : TObjectlist; overload;
    function GetAllPrivateFrames       : TObjectList; overload;

    procedure GetAllFrames(aList: TObjectlist); overload;
    procedure GetAllTextFrames          (aList: TObjectlist); overload;
    procedure GetAllUserTextFrames      (aList: TObjectlist); overload;
    procedure GetAllCommentFrames       (aList: TObjectlist); overload;
    procedure GetAllLyricFrames         (aList: TObjectlist); overload;
    procedure GetAllUserDefinedURLFrames(aList: TObjectlist); overload;
    procedure GetAllPictureFrames       (aList: TObjectlist); overload;
    procedure GetAllPopularimeterFrames (aList: TObjectlist); overload;
    procedure GetAllURLFrames           (aList: TObjectlist); overload;
    procedure GetAllPrivateFrames       (aList: TObjectlist); overload;


    // Check, wether a new frame is valid, i.e. unique
    function ValidNewCommentFrame(Language: AnsiString; Description: UnicodeString): Boolean;
    function ValidNewLyricFrame(Language: AnsiString; Description: UnicodeString): Boolean;
    function ValidNewPictureFrame(Description: UnicodeString): Boolean;
    function ValidNewUserDefUrlFrame(Description: UnicodeString): Boolean;
    function ValidNewPopularimeterFrame(EMail: AnsiString): Boolean;

    // Get allowed Frame-IDs (not every frame is allowed in every subversion)
    function GetAllowedTextFrames: TList;
    function GetAllowedURLFrames: TList; // WOAR, ... Not the user definied WXXX-Frame

    function AddFrame(aID: TFrameIDs): TID3v2Frame;
    procedure DeleteFrame(aFrame: TID3v2Frame);
  end;
//--------------------------------------------------------------------


//--------------------------------------------------------------------
// Teil 4. Types for MPEG
//--------------------------------------------------------------------

  TMpegHeader = record
    version: byte;
    layer: byte;
    protection: boolean;
    bitrate: LongInt;
    samplerate: LongInt;
    channelmode: byte;
    extension: byte;
    copyright: boolean;
    original: boolean;
    emphasis: byte;
    padding: boolean;
    framelength: word;
    valid: boolean;
  end;

  TXingHeader = record
    Frames: integer;
    Size: integer;
    vbr: boolean;
    valid: boolean;
    corrupted: boolean;
  end;
  TVBRIHeader = TXingHeader;

  TMpegInfo = class(TObject)
  Private
    FFilesize: int64;
    Fversion:integer;
    Flayer:integer;
    Fprotection:boolean;
    Fbitrate:word;
    Fsamplerate:integer;
    Fchannelmode:byte;
    Fextension:byte;
    Fcopyright:boolean;
    Foriginal:boolean;
    Femphasis:byte;
    Fframes:Integer;
    Fdauer:Longint;
    Fvbr:boolean;
    Fvalid: boolean;
    FfirstHeaderPosition: int64;

    // Check, wether there is in aBuffer on position a valid MPEG-header
    function GetValidatedHeader(aBuffer: TBuffer; position: integer): TMpegHeader;
    // Check, wether the MPEG-header is followed by a Xing-Frame
    function GetXingHeader(aMpegheader: TMpegHeader; aBuffer: TBuffer; position: integer ): TXingHeader;
    function GetVBRIHeader(aMpegheader: TMpegHeader; aBuffer: TBuffer; position: integer ): TVBRIHeader;

    function GetFramelength(version:byte;layer:byte;bitrate:integer;Samplerate:integer;padding:boolean):integer;

  public
    constructor create;
    function LoadFromStream(stream: tStream): TMP3Error;
    function LoadFromFile(FileName: UnicodeString): TMP3Error;
    property Filesize: int64          read   FFilesize;
    property Version: integer         read   Fversion;
    property Layer: integer           read   Flayer;
    property Protection: boolean      read   Fprotection;
    property Bitrate: word            read   Fbitrate;
    property Samplerate: integer      read   Fsamplerate;
    property Channelmode: byte        read   Fchannelmode;
    property Extension: byte          read   Fextension;
    property Copyright: boolean       read   Fcopyright;
    property Original: boolean        read   Foriginal;
    property Emphasis: byte           read   Femphasis;
    property Frames: Integer          read   Fframes;
    property Dauer: Longint           read   Fdauer;
    property Duration: Longint        read   Fdauer; // Same as "Dauer" - for the english user ;-)
    property Vbr: boolean             read   Fvbr;
    property Valid: boolean           read   Fvalid;
    property FirstHeaderPosition: int64 read   FfirstHeaderPosition;
  end;



  // Some useful functions.
  // Use them e.g. in OnChange of a TEdit
  function IsValidV2TrackString(value:string):boolean;
  function IsValidV1TrackString(value:string):boolean;
  function IsValidYearString(value:string):boolean;

  // Get a TrackNr. from a ID3v2-Tag-trackstring
  // e.g.: 3/15 => 3
  function GetTrackFromV2TrackString(value: string): Integer;

const

 MPEG_BIT_RATES : array[1..3] of array[1..3] of array[0..15] of word =
  { Version 1, Layer I }
    (((0,32,64,96,128,160,192,224,256,288,320,352,384,416,448,0),
  { Version 1, Layer II }
    (0,32,48,56, 64, 80, 96,112,128,160,192,224,256,320,384,0),
  { Version 1, Layer III }
    (0,32,40,48, 56, 64, 80, 96,112,128,160,192,224,256,320,0)),
  { Version 2, Layer I }
    ((0,32,48, 56, 64, 80, 96,112,128,144,160,176,192,224,256,0),
  { Version 2, Layer II }
    (0, 8,16,24, 32, 40, 48, 56, 64, 80, 96, 112,128,144,160,0),
  { Version 2, Layer III }
    (0, 8,16,24, 32, 40, 48, 56, 64, 80, 96, 112,128,144,160,0)),
  { Version 2.5, Layer I }
    ((0,32,48, 56, 64, 80, 96,112,128,144,160,176,192,224,256,0),
  { Version 2.5, Layer II }
    (0, 8,16,24, 32, 40, 48, 56, 64, 80, 96, 112,128,144,160,0),
  { Version 2.5, Layer III }
    (0, 8,16,24, 32, 40, 48, 56, 64, 80, 96, 112,128,144,160,0)));

  sample_rates: array[1..3] of array [0..3] of word=
    ((44100,48000,32000,0),
    (22050,24000,16000,0),
    (11025,12000,8000,0));
  channel_modes:array[0..3] of string=('Stereo','Joint stereo','Dual channel (Stereo)','Single channel (Mono)');
  extensions:array[1..3] of array [0..3] of string=
    (('bands 4 to 31','bands 8 to 32','bands 12 to 31','bands 16 to 31'),
     ('bands 4 to 31','bands 8 to 32','bands 12 to 31','bands 16 to 31'),
     ('IS:off, MS:off','IS:on, MS:off','IS:off, MS:on','IS:on, MS:on'));
  emphasis_values: array[0..3] of string = ('None', '50/15ms','reserved','CCIT J.17');

  {.$Message Hint 'You should change the default rating description for your projects'}
var
  DefaultRatingDescription: AnsiString = 'Mp3ileUtils, www.gausi.de';
  // Changig this should be done e.g. in MainFormCreate or in the initialization-part
  // It should be like "<Name of the program>, <URL to your webpage>"


var
  LanguageCodes: TStringlist;
  LanguageNames: TStringlist;


implementation

uses ID3GenreList;



//--------------------------------------------------------------------
// Some useful functions outside the classes
//--------------------------------------------------------------------

//--------------------------------------------------------------------
//  before Delphi 2009:
//    * String is AnsiString
//    * If no TNTs are used, Delphi cannot handle Unicode-Filenames
//    * If TNTs are used, the following two methods will not be compiled
//      and WideFileExists/-ExtractFileDrive will be the TNT-function with WideString-Parameter
//  Delphi 2009:
//    * TNTs are not used (as Delphi itself can handle Unicode)
//    * String is UnicodeString
//--------------------------------------------------------------------
{$IFNDEF USE_TNT_COMPOS}
function  WideFileExists(aString: string):boolean;
begin
  result := FileExists(aString);
end;

function WideExtractFileDrive(aString: String): string;
begin
  result := ExtractFileDrive(aString);
end;
{$ENDIF}


//--------------------------------------------------------------------
// Check, wether Frame-ID is valid
//--------------------------------------------------------------------
function ValidFrame(ID: AnsiString): Boolean;
var
  i: Cardinal;
begin
  result := true;
  for i := 1 to length(ID) do
    if not (ID[i] in ['0'..'9', 'A'..'Z']) then
    begin
      result := false;
      Break;
    end;
end;

function ValidTextFrame(ID: AnsiString): Boolean;
begin
  result := (length(ID) >= 3) and (ID[1] = 'T');
end;

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

//--------------------------------------------------------------------
// Convert a 32bit-integer to a 28bit-integer
//--------------------------------------------------------------------
function Int32ToInt28(Value: LongWord): TInt28;
begin
  // move every byte in Value to the right, take the 7 LSBs
  // and assign them to the result
  Result[3] := (Value shr  0) and $7F;
  Result[2] := (Value shr  7) and $7F;
  Result[1] := (Value shr 14) and $7F;
  Result[0] := (Value shr 21) and $7F;
end;

//--------------------------------------------------------------------
// Get a temporary filename
//--------------------------------------------------------------------
function GetTempFile: String;
var
  Path: String;
  i: Integer;
begin
  SetLength(Path, 256);
  FillChar(PChar(Path)^, 256 * sizeOf(Char), 0);
  GetTempPath(256, PChar(Path));
  Path := Trim(Path);
  if Path[Length(Path)] <> '\' then
    Path := Path + '\';
  i := 0;
  repeat
    result := Path + 'TagTemp.t' + IntToHex(i, 2);
    inc(i);
  until not FileExists(result);
end;


//--------------------------------------------------------------------
// ID3v1 or ID3v1.1 ?
//--------------------------------------------------------------------
function GetID3v1Version(Tag: TID3v1Structure): Byte;
begin
  // If the 29th byte of the comment is =0 an
  // 30th <> 0, then this is the Track-nr.
  if (Tag.Comment[29] = #00) and (Tag.Comment[30] <> #00) then
    result := 1
  else
    result := 0;
end;

//---------------------------------------------------
// check, wether value is a valid track-string for id3v2 ...
//---------------------------------------------------
function IsValidV2TrackString(value:string):boolean;
var
  del: Integer;
  Track, Overall: String;
begin
  del := Pos('/', Value);       // getting the position of the delimiter
  if del = 0 then
    // If there is none, then the whole string is the TrackNumber
    result := (StrToIntDef(Value, -1) > -1)
  else begin
    Overall := Trim(Copy(Value, del + 1, Length(Value) - (del)));
    Track := Trim(Copy(Value, 1, del - 1));
    result := ((StrToIntDef(Track, -1) > -1) AND (StrToIntDef(Overall, -1) > -1))
  end;
end;

//--------------------------------------------------------------------
// ... and for v1
//--------------------------------------------------------------------
function IsValidV1TrackString(value:string):boolean;
begin
  result := (StrToIntDef(Value, -1) > -1);
end;

//--------------------------------------------------------------------
// Check for valid year
//--------------------------------------------------------------------
function IsValidYearString(value:string):boolean;
var tmp:integer;
begin
  tmp := StrToIntDef(Value, -1);
  result := (tmp > -1) AND (tmp < 10000);
end;

//--------------------------------------------------------------------
// Get Track-Nr. from track-string
//--------------------------------------------------------------------
function GetTrackFromV2TrackString(value: string): Integer;
var
  del: Integer;
  Track: String;
begin
  del := Pos('/', Value);       // getting the position of the delimiter
  if del = 0 then
    // If there is none, then the whole string is the TrackNumber
    result := StrToIntDef(Value, 0)
  else begin
    //Overall := Trim(Copy(Value, del + 1, Length(Value) - (del)));
    Track := Trim(Copy(Value, 1, del - 1));
    result := StrToIntDef(Track, 0);
  end;
end;

//--------------------------------------------------------------------
// Get a "reasonable" padding-size (i.e.: fill the last used cluster)
//--------------------------------------------------------------------
function GetPaddingSize(DataSize: Int64; aFilename: UnicodeString; UseClusterSize: Boolean): Cardinal;
var
   Drive: string;
   ClusterSize           : Cardinal;
   SectorPerCluster      : Cardinal;
   BytesPerSector        : Cardinal;
   NumberOfFreeClusters  : Cardinal;
   TotalNumberOfClusters : Cardinal;
begin
  Drive := WideExtractFileDrive(aFileName);
  if UseClusterSize and (trim(Drive) <> '')then
  begin
      if Drive[Length(Drive)]<>'\' then Drive := Drive+'\';
      try
          if GetDiskFreeSpace(PChar(Drive),
                              SectorPerCluster,
                              BytesPerSector,
                              NumberOfFreeClusters,
                              TotalNumberOfClusters) then
            ClusterSize := SectorPerCluster * BytesPerSector
          else
            ClusterSize := 2048;
      except
        ClusterSize := 2048;
      end;
  end else
    ClusterSize := 2048;
  Result := (((DataSize DIV ClusterSize) + 1) * Clustersize) - DataSize;
end;


//--------------------------------------------------------------------
//--------------------------------------------------------------------
//        *** TID3v1Tag ***
//--------------------------------------------------------------------
//--------------------------------------------------------------------


constructor TID3v1Tag.Create;
begin
  inherited Create;
  // Set default-values
  Clear;
  FCharCode := DefaultCharCode;
  AutoCorrectCodepage := False;
end;

destructor TID3v1Tag.destroy;
begin
  inherited destroy;
end;

// Read the Tag from a stream
function TID3v1Tag.ReadFromStream(Stream: TStream): TMP3Error;
var
  RawTag: TID3v1Structure;
begin
  clear;
  result := MP3ERR_None;
  FExists := False;
  try
    Stream.Seek(-128, soEnd);
    if (Stream.Read(RawTag, 128) = 128) then
      if (RawTag.ID = 'TAG') then
      begin
        FExists := True;
        FVersion := GetID3v1Version(RawTag);
        FTitle := (RawTag.Title);
        FArtist := (RawTag.Artist);
        FAlbum := (RawTag.Album);
        FYear := (RawTag.Year);
            //String4(Trim(String(FYear)));
        if FVersion = 0 then
        begin
          FComment := (RawTag.Comment);
          FTrack := 0;
        end
        else
        begin
          Move(RawTag.Comment[1], FComment[1], 28);
          FComment[29] := #0;
          FComment[30] := #0;
          FTrack := Ord(RawTag.Comment[30]);
        end;
        FGenre := RawTag.Genre;
      end
      else
        result := ID3ERR_NoTag
    else
      result := MP3ERR_SRead;
  except
    on E: Exception do
    begin
      result := ID3ERR_Unclassified;
      MessageBox(0, PChar(E.Message), PChar('Error'), MB_OK or MB_ICONERROR or MB_TASKMODAL or MB_SETFOREGROUND);
    end;
  end;
end;

// Write Tag to a stream
function TID3v1Tag.WriteToStream(Stream: TStream): TMP3Error;
var
  RawTag: TID3v1Structure;
  Buffer: Array [1..3] of AnsiChar;
begin
  result := MP3ERR_NONE;
  try
    FillChar(RawTag, 128, 0);
    RawTag.ID := 'TAG';
    Move(FTitle[1], RawTag.Title, Length(FTitle));
    Move(FArtist[1], RawTag.Artist, Length(FArtist));
    Move(FAlbum[1], RawTag.Album, Length(FAlbum));
    Move(FYear[1], RawTag.Year, Length(FYear));
    Move(FComment[1], RawTag.Comment, Length(FComment));
    if FTrack > 0 then
    begin
      RawTag.Comment[29] := #0;
      RawTag.Comment[30] := AnsiChar(Chr(FTrack));
    end;
    RawTag.Genre := FGenre;

    // Search for an existing tag and set position to write the new one
    Stream.Seek(-128, soEnd);
    Stream.Read(Buffer[1], 3);
    if (Buffer[1]='T') AND (Buffer[2]='A') AND (Buffer[3]='G') then
      Stream.Seek(-128, soEnd)
    else
      Stream.Seek(0, soEnd);

    if Stream.Write(RawTag, 128) <> 128 then
      result := MP3ERR_SWrite;
  except
    on E: Exception do
    begin
      result := ID3ERR_Unclassified;
      MessageBox(0, PChar(E.Message), PChar('Error'), MB_OK or MB_ICONERROR or MB_TASKMODAL or MB_SETFOREGROUND);
    end;
  end;
end;

// Delete Tag, if existing
function TID3v1Tag.RemoveFromStream(Stream: TStream): TMP3Error;
var
  Buffer: Array [1..3] of AnsiChar;
begin
  result := MP3ERR_NONE;
  try
    Stream.Seek(-128, soEnd);
    Stream.Read(Buffer[1], 3);
    if (Buffer[1]='T') AND (Buffer[2]='A') AND (Buffer[3]='G') then
    begin
      Stream.Seek(-128, soEnd);
      SetStreamEnd(Stream);
    end
    else
      result := ID3ERR_NoTag;
  except
    on E: Exception do
    begin
      result := ID3ERR_Unclassified;
      MessageBox(0, PChar(E.Message), PChar('Error'), MB_OK or MB_ICONERROR or MB_TASKMODAL or MB_SETFOREGROUND);
    end;
  end;
end;

// Set default-values
procedure TID3v1Tag.Clear;
begin
  FTitle   := String30(StringOfChar(#0, 30));
  FArtist  := String30(StringOfChar(#0, 30));
  FAlbum   := String30(StringOfChar(#0, 30));
  FYear    := String4(StringOfChar(#0, 4));
  FComment := String30(StringOfChar(#0, 30));

  FTrack   := 0;
  FGenre   := 0;
  FVersion := 0;
  FExists  := False;
end;

// read tag from a file
// -> use stream-function
function TID3v1Tag.ReadFromFile(Filename: UnicodeString): TMP3Error;
var
  Stream: TMPFUFileStream;
begin
  if WideFileExists(Filename) then
    try
      Stream := TMPFUFileStream.Create(Filename, fmOpenRead or fmShareDenyWrite);
      try
        result := ReadFromStream(Stream);
      finally
        Stream.Free;
      end;
    except
      result := MP3ERR_FOpenR;
    end
  else
    result := MP3ERR_NoFile;
end;

// Write a tag to a file
// -> use stream-function
function TID3v1Tag.WriteToFile(Filename: UnicodeString): TMP3Error;
var
  Stream: TMPFUFileStream;
begin
  if WideFileExists(Filename) then
    try
      Stream := TMPFUFileStream.Create(Filename, fmOpenReadWrite or fmShareDenyWrite);
      try
        result := WriteToStream(Stream);
      finally
        Stream.Free;
      end;
    except
      result := MP3ERR_FOpenRW;
    end
  else
    result := MP3ERR_NoFile;
end;

// Delete Tag from a file
// -> use stream-function
function TID3v1Tag.RemoveFromFile(Filename: UnicodeString): TMP3Error;
var
  Stream: TMPFUFileStream;
begin
  if WideFileExists(Filename) then
    try
      Stream := TMPFUFileStream.Create(Filename, fmOpenReadWrite or fmShareDenyWrite);
      try
        result := RemoveFromStream(Stream);
      finally
        Stream.Free;
      end;
    except
      result := MP3ERR_FOpenRW;
    end
  else
    result := MP3ERR_NoFile;
end;


// Converts a String[30] to UnicodeString
//   * if AutoCorrectCodepage=True then the conversion is done by the
//     given CodePage
//   * otherwise it will be done by delphi, i.e. the system-codepage
function TID3v1Tag.GetConvertedUnicodeText(Value: String30): UnicodeString;
var
  tmp: AnsiString;
  L: Integer;
begin
    if AutoCorrectCodepage then
    begin
        L := MultiByteToWideChar(FCharCode.CodePage,
                  MB_PRECOMPOSED,  // Flags
                  @Value[1],       // data to convert
                  Length(Value),   // Size in bytes
                  nil,             // output - not used here
                  0);              // 0=> Get required BufferSize

        if L = 0 then
        begin
            // Something's wrong => Fall back to ANSI
            setlength(tmp, 30);
            move(Value[1], tmp[1], 30);
            {$IFDEF UNICODE}
                // use explicit typecast
                result := trim(String(tmp));
            {$ELSE}
                result := trim(tmp);
            {$ENDIF}
        end else
        begin
            // SetBuffer, Size in WChars, not Bytes.
            SetLength(Result, L);
            // Convert
            MultiByteToWideChar(FCharCode.CodePage,
                      MB_PRECOMPOSED,
                      @Value[1],
                      length(Value),
                      @Result[1],
                      L);
            // trim string
            result := Trim(Result);
        end;
    end

    else
    begin
      // copy to AnsiString and typecast
      setlength(tmp,30);
      move(Value[1], tmp[1], 30);
      {$IFDEF UNICODE}
          // use explicit typecast
          result := trim(String(tmp));
      {$ELSE}
          result := trim(tmp);
      {$ENDIF}
    end;
end;

function TID3v1Tag.GetTitle: UnicodeString;
begin
  result := GetConvertedUnicodeText(FTitle);
end;
function TID3v1Tag.GetArtist: UnicodeString;
begin
  result := GetConvertedUnicodeText(FArtist);
end;
function TID3v1Tag.GetAlbum: UnicodeString;
begin
  result := GetConvertedUnicodeText(FAlbum);
end;
function TID3v1Tag.GetComment: UnicodeString;
begin
  result := GetConvertedUnicodeText(FComment);
end;
function TID3v1Tag.GetGenre: String;
begin
  if FGenre <= 125 then
    result := ID3Genres[FGenre]
  else
    result := '';
end;
function TID3v1Tag.GetTrack: String;
begin
  result := IntToStr(FTrack);
end;

function TID3v1Tag.GetYear: String4;
begin
  result := FYear;
end;


// Converts a UnicodeString to String[30]
//   * if AutoCorrectCodepage=True then the conversion is done by the
//     given CodePage
//   * otherwise it will be done by delphi, i.e. the system-codepage
function TID3v1Tag.SetString30(value: UnicodeString): String30;
var i, max, L: integer;
    tmpstr: AnsiString;
begin
    result := String30(StringOfChar(#0, 30));
    if fAutoCorrectCodepage then
    begin

        if length(value) > 0 then
        begin

            L := WideCharToMultiByte(FCharCode.CodePage, // CodePage
                  0, // Flags
                  @Value[1],      // String to Convert
                  -1,//length(Value),  // ... and its length
                  Nil,     // output, not needed here
                  0,       // and its length, 0 to get required length
                  Nil,  // DefaultChar, Nil=SystemDefault
                  Nil);  // DefaultChar needed

            if L = 0 then
            begin
                // Failure, Fall back to Ansi
                tmpstr := AnsiString(value);
                max := length(tmpstr);
                if max > 30 then max := 30;
                for i := 1 to max do
                    result[i] := tmpstr[i];
            end
            else
            begin
                // use a tmp-AnsiString, as the UnicodeString may be longer
                SetLength(tmpstr, L);
                //tmpstr := (StringOfChar(#0, L));
                WideCharToMultiByte(FCharCode.CodePage, // CodePage
                      0, // Flags
                      @Value[1],      // String to Convert
                      -1, //length(Value),  // ... and its length
                      @tmpstr[1],     // output
                      L,             // and its length
                      Nil,  // DefaultChar, Nil=SystemDefault
                      Nil);  // DefaultChar needed


                result := String30(tmpstr);
            end;
        end;
    end else
    begin
        // Write as Ansi

        tmpstr := AnsiString(value);
        max := length(tmpstr);
        if max > 30 then max := 30;
        for i := 1 to max do
            result[i] := tmpstr[i];
    end;
end;


procedure TID3v1Tag.SetTitle(Value: UnicodeString);
begin
  FTitle := SetString30(Value);
end;
procedure TID3v1Tag.SetArtist(Value: UnicodeString);
begin
  FArtist := SetString30(Value);
end;
procedure TID3v1Tag.SetAlbum(Value: UnicodeString);
begin
  FAlbum := SetString30(Value);
end;
procedure TID3v1Tag.SetGenre(Value: String);
var
  i: integer;
begin
  i := ID3Genres.IndexOf(Value);
  if i in [0..125] then
    FGenre := i
  else
    FGenre := 255; // undefined
end;

procedure TID3v1Tag.SetYear(Value: String4);
begin
  FYear := Value;
end;

procedure TID3v1Tag.SetComment(Value: UnicodeString);
begin
  FComment := SetString30(Value);
end;
procedure TID3v1Tag.SetTrack(Value : String);
begin
  FTrack := StrToIntDef(Value, 0);
end;






//--------------------------------------------------------------------
//--------------------------------------------------------------------
//        *** TID3v2Tag ***
//--------------------------------------------------------------------
//--------------------------------------------------------------------

constructor TID3v2Tag.Create;
begin
  inherited Create;
  Frames := TObjectList.Create(True);

  FUseClusteredPadding := True;
  AlwaysWriteUnicode := False;
  FCharCode := DefaultCharCode;
  AutoCorrectCodepage := False;
  FVersion.Major := 3;
  FVersion.Minor := 0;
  FExists := False;
  FTagSize := 0;
  fPaddingSize := 0;
  fFlgUnsynch       := False;
  fFlgCompression   := False;
  fFlgExtended      := False;
  fFlgExperimental  := False;
  fFlgFooterPresent := False;
  fFlgUnknown       := False;
end;

Destructor TID3v2tag.Destroy;
begin
  Frames.Free;
  inherited destroy;
end;

function TID3v2Tag.GetFrameIDString(ID:TFrameIDs):AnsiString;
begin
  case fVersion.Major of
    2: result := ID3v2KnownFrames[ID].IDs[FV_2];
    3: result := ID3v2KnownFrames[ID].IDs[FV_3];
    4: result := ID3v2KnownFrames[ID].IDs[FV_4];
    else result := '';
  end;
end;

// Get the Index of a Frame (given by its ID) in the Frame-Array
// Note: Use this only for unique frames.
//       DO NOT use it for frames like Comments, Picture, Lyrics
function TID3v2Tag.GetFrameIndex(ID:TFrameIDs):integer;
var i:integer;
    IDstr: AnsiString; // FrameIDs are ANSIStrings
begin
  result := -1;
  idstr := GetFrameIDString(ID);
  for i := 0 to Frames.Count - 1 do
  begin
      if (Frames[i] as TID3v2Frame).FrameIDString = IDstr then
      begin
          result := i;
          break;
      end;
  end;
end;

function TID3v2Tag.GetUserTextFrameIndex(aDescription: UnicodeString): integer;
var i: Integer;
    iDescription: UnicodeString;
begin
    result := -1;
    for i := 0 to Frames.Count - 1 do
    begin
        if (TID3v2Frame(Frames[i]).FrameType = FT_UserTextFrame) then
        begin
            TID3v2Frame(Frames[i]).GetUserText(iDescription);
            If AnsiSameText(aDescription, iDescription) then
            begin
                result := i;
                break;
            end;
        end;
    end;
end;

// Get the index of a Frame, given by its ID and a "language-description"-Combination
// as used in Lyrics or Comments
function TID3v2Tag.GetDescribedTextFrameIndex(ID:TFrameIDs; Language:AnsiString; Description: UnicodeString): Integer;
var i:integer;
  IDstr: AnsiString;
  iLanguage: AnsiString;
  iDescription: UnicodeString;
  check: Boolean;
begin
  result := -1;
  idstr := GetFrameIDString(ID);
  for i := 0 to Frames.Count - 1 do
  begin
      if (Frames[i] as TID3v2Frame).FrameIDString = IDstr then
      begin
          (Frames[i] as TID3v2Frame).GetCommentsLyrics(iLanguage, iDescription);
          check := False;
          if ((Language = '*') OR (Language = '')) or (Language = iLanguage) then
              Check := True;
          If Check and ((Description = '*') or (Description = iDescription)) then
          begin
              result := i;
              break;
          end;
      end;
  end;
end;
// Get the index of a Picture-Frame, given by its description
function TID3v2Tag.GetPictureFrameIndex(aDescription: UnicodeString): Integer;
var mime, idstr: AnsiString;
  i: integer;
  PictureData : TMemoryStream;
  desc: UnicodeString;
  picTyp: Byte;
begin
  result := -1;
  idstr := GetFrameIDString(IDv2_PICTURE);
  for i := 0 to Frames.Count - 1 do
    if (Frames[i] as TID3v2Frame).FrameIDString = IDstr then
    begin
        // matching IDstring found
        PictureData := TMemoryStream.Create;
        (Frames[i] as TID3v2Frame).GetPicture(Mime, PicTyp, Desc, PictureData);
        PictureData.Free;

        if (aDescription = Desc) or (aDescription = '*') then
        begin
            // matching description found
            result := i;
            break;
        end;
    end;
end;
// Get the index of a URL-Frame, given by its description
function TID3v2Tag.GetUserDefinedURLFrameIndex(Description: UnicodeString): Integer;
var i: Integer;
  IDstr: AnsiString;
  iDescription: UnicodeString;
begin
  result := -1;
  idstr := GetFrameIDString(IDv2_USERDEFINEDURL);
  for i := 0 to Frames.Count - 1 do
  begin
      if (Frames[i] as TID3v2Frame).FrameIDString = IDstr then
      begin
          (Frames[i] as TID3v2Frame).GetUserdefinedURL(iDescription);
          If Description = iDescription then
          begin
              result := i;
              break;
          end;
      end;
  end;
end;
// Get the index of a Rating-Frame, given by its user-email
function TID3v2Tag.GetPopularimaterFrameIndex(aEMail: AnsiString):integer;
var idstr, iEMail: AnsiString;
    i: Integer;
begin
    result := -1;
    idstr := GetFrameIDString(IDv2_RATING);
    for i := 0 to Frames.Count - 1 do
        if (Frames[i] as TID3v2Frame).FrameIDString = IDstr then
        begin
            (Frames[i] as TID3v2Frame).GetRating(iEMail);
            if (aEMail = iEMail) or (aEMail = '*') then
            begin
                result := i;
                break;
            end;
        end;
end;


function TID3v2Tag.GetPrivateFrameIndex(aOwnerID: AnsiString): Integer;
var i: Integer;
    idStr, iOwner: AnsiString;
    dummyStream: TStream;
begin
    result := -1;
    idstr := GetFrameIDString(IDv2_Private);
    for i := 0 to Frames.Count - 1 do
        if (Frames[i] as TID3v2Frame).FrameIDString = IDstr then
        begin
            dummyStream := TMemoryStream.Create;
            try
                (Frames[i] as TID3v2Frame).GetPrivateFrame(iOwner, dummyStream);
            finally
                dummyStream.Free;
            end;
            if (aOwnerID = iOwner) then
            begin
                result := i;
                break;
            end;
        end;
end;


//--------------------------------------------------------------------
// Read the ID3v2Header
//--------------------------------------------------------------------
function TID3v2Tag.ReadHeader(Stream: TStream): TMP3Error;
var
  RawHeader: TID3v2Header;
  ExtendedHeader: Array[0..3] of byte;
  ExtendedHeaderSize: Integer;
begin
  result := MP3ERR_None;
  try
    Stream.Seek(0, soBeginning);
    Stream.ReadBuffer(RawHeader, 10);
    if RawHeader.ID = 'ID3' then
      if RawHeader.Version in  [2,3,4] then
      begin
        FTagSize := Int28ToInt32(RawHeader.TagSize) + 10;
        FExists := True;
        case RawHeader.Version of
            2: begin
                FFlgUnsynch := (RawHeader.Flags and 128) = 128;
                fFlgCompression := (RawHeader.Flags and 64) = 64;
                fFlgUnknown := (RawHeader.Flags and 63) <> 0;
                FFlgExtended := False;
                FFlgExperimental := False;
                if fFlgCompression then
                  result := ID3ERR_Compression;
                FFlgFooterPresent := False;
            end;
            3: begin
                FFlgUnsynch := (RawHeader.Flags and 128) = 128;
                FFlgExtended := (RawHeader.Flags and 64) = 64;
                FFlgExperimental := (RawHeader.Flags and 32) = 32;
                fFlgUnknown := (RawHeader.Flags and 31) <> 0;
                fFlgCompression := False;
                FFlgFooterPresent := False;
            end;
            4: begin
                FFlgUnsynch := (RawHeader.Flags and 128) = 128;
                FFlgExtended := (RawHeader.Flags and 64) = 64;
                FFlgExperimental := (RawHeader.Flags and 32) = 32;
                fFlgCompression := False;
                FFlgFooterPresent := (RawHeader.Flags and 16) = 16;
                fFlgUnknown := (RawHeader.Flags and 15) <> 0;                
                if FFlgFooterPresent then
                  FTagSize := FTagSize + 10;
            end;
        end;

        // Version
        FVersion.Major := RawHeader.Version;
        FVersion.Minor := RawHeader.Revision;

        // extendedHeader: Just read its size and ignore the rest
        if FFlgExtended then
        begin
            // Size is SyncSafe in subversion 2.4
            Stream.ReadBuffer(ExtendedHeader[0], 4); // Minimum-size is 6bytes
            if fversion.Major =4 then
              ExtendedHeaderSize := 2097152 * ExtendedHeader[0]
                + 16384 * ExtendedHeader[1]
                + 128 * ExtendedHeader[2]
                + ExtendedHeader[3]
            else
              ExtendedHeaderSize := 16777216 * ExtendedHeader[0]
                + 65536 * ExtendedHeader[1]
                + 256 * ExtendedHeader[2]
                + ExtendedHeader[3];

            Stream.Seek(ExtendedHeaderSize, soCurrent);
            // ExtendedHeaderSize is the size _Excluding_ the 4 Size-Bytes
            // thanks to Jürgen vom Projekt inEx information explorer
        end;
      end
      else
          // subversion <> 2,3 or 4: invalid Header, invalid Tag
          result := ID3ERR_Invalid_Header
    else
        result := ID3ERR_NoTag;
  except
    on EReadError do result := MP3ERR_SRead;
    on E: Exception do
    begin
      result := ID3ERR_Unclassified;
      MessageBox(0, PChar(E.Message), PChar('Error'), MB_OK or MB_ICONERROR or MB_TASKMODAL or MB_SETFOREGROUND);
    end;
  end;
end;

//--------------------------------------------------------------------
// Read the frames of the ID3v2 Tags
//--------------------------------------------------------------------
function TID3v2Tag.ReadFrames(From: LongInt; Stream: TStream): TMP3Error;
var FrameIDstr: AnsiString;
    newFrame: TID3v2Frame;
begin
  result := MP3ERR_None;
  FUsePadding := False;
  try
    case fVersion.Major of
      // Version 2-Header has a size  of 6 bytes (3 Byte ID, 3 Byte size)
      2 : Setlength(FrameIDstr,3)
      else Setlength(FrameIDstr,4);
    end;

    if Stream.Position <> From then
      Stream.Position := From;

    // delete old frames (from "self", not from the file ;-))
    Frames.Clear;

    while (Stream.Position < (FTagSize - fPaddingSize))
                                       and (Stream.Position < Stream.Size) do
    begin
      // read FrameID
      Stream.Read(FrameIDStr[1], length(FrameIDStr));

      if ValidFrame(FrameIDstr) then
      begin
        newFrame := TID3v2Frame.Create(FrameIDstr, TID3v2FrameVersions(FVersion.Major));
        newFrame.ReadFromStream(Stream);
        NewFrame.AlwaysWriteUnicode := fAlwaysWriteUnicode;

        newFrame.CharCode := fCharCode;
        NewFrame.AutoCorrectCodepage := fAutoCorrectCodepage;

        Frames.Add(newFrame);
      end else
      // No valid Frame found. Rest of the Tag is padding
      // (I ignore the ID3v2-footer)
      begin
        fPaddingSize := FTagSize - (Stream.Position - length(FrameIDStr));
        FUsePadding := True;
        Break;
      end;
    end;

  except
    on EReadError do result := MP3ERR_SRead;
    on E: Exception do
    begin
      result := ID3ERR_Unclassified;
      MessageBox(0, PChar(E.Message), PChar('Error'), MB_OK or MB_ICONERROR or MB_TASKMODAL or MB_SETFOREGROUND);
    end;
  end;
end;

// SyncStream:
// Replace all $FF 00 by $FF
// See Unsynchronisation-Scheme on id3.org for details.
procedure TID3v2Tag.SyncStream(Source, Target: TStream);
var buf: TBuffer;
    i, last: Int64;
begin
    if FTagSize = 0 then exit; // this should never occur
    setlength(buf, FTagSize);
    Source.Read(buf[0], FTagSize);
    Target.Size := FTagSize;
    i := 0;
    last := 0;
    while i <= length(buf)-1 do
    begin
        While (i < length(buf)-2) and ((buf[i] <> $FF) or (buf[i+1] <> $00)) do
            inc(i);
        // i is now at most length(buf)-2
        // or buf[i] = 255 and buf[i+1] = 0
        // => copy from last position to i into the new stream and skip buf[i+1]
        Target.Write(buf[last], i - last + 1);
        last := i + 2;
        inc(i, 2);   // d.h. last = i
    end;
    // write the rest
    if last <= length(buf)-1 then
        Target.Write(buf[last], length(buf) - last);

    SetStreamEnd(Target);
end;

//--------------------------------------------------------------------
// read the tag. Header first, Frames afterwards
//--------------------------------------------------------------------
function TID3v2Tag.ReadFromStream(Stream: TStream): TMP3Error;
var SyncedStream: TMemoryStream;
begin
  // Clear self
  clear;

  result := ReadHeader(Stream);
  if (FExists) and (result = MP3ERR_None) then
  begin
      // if unsync and subversion 2.2 or 2.3 then:
      // ReadfromStream - Synch to new stream - Readframes from new stream
      if (Version.Major <> 4) and (FFlgUnsynch) then
      begin
          SyncedStream := TMemoryStream.Create;
          try
              SyncStream(Stream, SyncedStream);
              SyncedStream.Position := 0;
              result := ReadFrames(SyncedStream.Position, SyncedStream);
          finally
              SyncedStream.Free;
          end;
      end else
      begin
          // otheriwse: read frames from original stream
          // but: copy the whole thing first - should be faster on slow devices
          // Note: Synch on subversion 2.4 is done on frame-level
          SyncedStream := TMemoryStream.Create;
          try
              SyncedStream.CopyFrom(Stream, fTagSize - Stream.Position);
              SyncedStream.Position := 0;
              result := ReadFrames(SyncedStream.Position, SyncedStream)
          finally
              SyncedStream.Free;
          end;
      end;
  end;
end;


//--------------------------------------------------------------------
// write tag
//--------------------------------------------------------------------
function TID3v2Tag.WriteToStream(Stream: TStream): TMP3Error;
var
  aHeader: TID3v2Header;
  TmpStream, ID3v2Stream: TMPFUFileStream;
  TmpName, FrameName: String;  // temporary filenames. Delphi-Default-Strings
  v1Tag: String[3];
  v1AdditionalPadding: Cardinal;
  Buffer: TBuffer;
  CacheAudio: Boolean;
  i: Integer;
  AudioDataSize: int64;
  tmpFrameStream: TMemoryStream;
  ExistingID3Tag: TID3v2Tag;
begin
  result := MP3ERR_None;
  AudioDataSize := 0;
  v1AdditionalPadding := 0;

  // A ID3v2Tag must contain at least one frame, and this must be at least one byte long
  // If all Frames are deleted, one frame must be restored - I choose
  // "Title" and set it to ' ' (one space)
  //
  // Note: Other frames are not empty - they will care for it by themself. ;-)
  if Frames.Count = 0 then
    Title := ' ';


  // write frames to temporary file
  FrameName := GetTempFile;
  try
    ID3v2Stream := TMPFUFileStream.Create(FrameName, fmCreate or fmShareDenyWrite);

    try
      // build a new header
      // size is unkown yet - must be set later in this method
      aHeader.ID := 'ID3';
      aHeader.Version := fVersion.Major;
      aHeader.Revision := fVersion.Minor;
      for i:=0 to 3 do
          aHeader.TagSize[i] := 0;

      if fFlgUnsynch then
      begin
          // set unsnych-flag in header
          aHeader.Flags := $80;
          // write header. Size will be corrected later in this method
          ID3v2Stream.WriteBuffer(aHeader,10);
          case fversion.Major of
              2,3: begin
                  // write frames, unsynch here
                  tmpFrameStream := TMemoryStream.Create;
                  for i := 0 to Frames.Count - 1 do
                      (Frames[i] as TID3v2Frame).WriteToStream(tmpFrameStream);
                  tmpFrameStream.Position := 0;
                  UnSyncStream(tmpFrameStream, ID3v2Stream);
                  tmpFrameStream.Free;
              end ;
              4: begin
                  // write frames, unsynch in frames
                  for i := 0 to Frames.Count - 1 do
                      (Frames[i] as TID3v2Frame).WriteUnsyncedToStream(ID3v2Stream);
              end;
           end;
      end else
      begin
          // write frames, no unsynch
          aHeader.Flags := $00;
          ID3v2Stream.WriteBuffer(aHeader,10);
          for i := 0 to Frames.Count - 1 do
              (Frames[i] as TID3v2Frame).WriteToStream(ID3v2Stream);
      end;

      // proceed with writing the mp3-file
      if ID3v2Stream.Size > 0 then
      begin
          // Check stream for existing tag
          ExistingID3Tag := TID3v2Tag.Create;
          ExistingID3Tag.ReadHeader(Stream);

          // jump to the end of this tag
          Stream.Seek(ExistingID3Tag.FTagSize, soBeginning);

          // 2019: new decision for CacheAudio:
          // Rewrite the File also when the old existing Tag is WAY BIGGER than the new one
          // - for example after removing a huge CoverArt from the Tag
          CacheAudio :=
              // user wants no padding
              (not FUsePadding) OR
              // ExistingTag too small
              ((ID3v2Stream.Size + 30) >= ExistingID3Tag.FTagSize) OR
              // ExistingTag is way too large (max. padding Size: 500k)
              (ExistingID3Tag.FTagSize > ID3v2Stream.Size + 512000);

          if CacheAudio then
          begin
            // Existing ID3v2Tag is too small (or too big in case of no padding) for the new one
            // Write Audiodata to temporary file
            TmpName := GetTempFile;
            try
                TmpStream := TMPFUFileStream.Create(TmpName, fmCreate or fmShareDenyWrite);
                TmpStream.Seek(0, soBeginning);

                AudioDataSize := Stream.Size - Stream.Position;
                if TmpStream.CopyFrom(Stream, Stream.Size - Stream.Position) <> AudioDataSize then
                begin
                    TmpStream.Free;
                    result := ID3ERR_Cache;
                    Exit;
                end;

                // Check for ID3v1Tag
                // adjust paddingsize, so that an id3v1Tag will not need another cluster on disk
                Stream.Seek(-128, soEnd);
                v1Tag := '   ';
                if (Stream.Read(v1Tag[1], 3) = 3) then
                begin
                  if (v1Tag = 'TAG') then
                    v1AdditionalPadding := 0
                  else
                    v1AdditionalPadding := 128;
                end;
                TmpStream.Free;
              except
                result := ID3ERR_Cache;
                // Failure -> Exit, to not damage the file
                Exit;
              end;
          end;

          // situation here:
          // Old Audiodata is in "tmpstream" (if neccessary)
          // New ID3Tag is in "ID3v2Stream"
          // But: Header is invalid, as the tags size was unknown before
          FDataSize := ID3v2Stream.Size;
          if FUsePadding then
          begin
              // Get paddingsize
              if CacheAudio then
              begin
                  fPaddingSize := GetPaddingSize(AudioDataSize + FDataSize + v1AdditionalPadding, FFilename, FUseClusteredPadding);
                  FTagSize := FDataSize + fPaddingSize;
              end
              else begin
                  fPaddingSize := ExistingID3Tag.FTagSize - FDataSize;
                  FTagSize := ExistingID3Tag.FTagSize;
              end;
          end else
          begin
              // Padding-size is 0
              fPaddingSize := 0;
              FTagSize := FDataSize;
          end;

          // Correct the Headersize
          aHeader.TagSize := Int32ToInt28(FTagSize - 10);
          ID3v2Stream.Seek(0, soBeginning);
          ID3v2Stream.WriteBuffer(aHeader,10);

          // Finally, write all the new stuff into the stream
          Stream.Seek(0, soBeginning);
          ID3v2Stream.Seek(0, soBeginning);

          // write new tag
          Stream.CopyFrom(ID3v2Stream, ID3v2Stream.Size);
          // write padding
          if fPaddingSize > 0 then
          begin
              setlength(Buffer, fPaddingSize);
              FillChar(Buffer[0], fPaddingSize, 0);
              Stream.Write(Buffer[0], fPaddingSize);
          end;
          // write audiodata
          if CacheAudio then
          begin
            try
              TmpStream := TMPFUFileStream.Create(TmpName, fmOpenRead);
              try
                TmpStream.Seek(0, soBeginning);
                Stream.CopyFrom(TmpStream, TmpStream.Size);
                SetStreamEnd(Stream);
              finally
                TmpStream.Free;
              end;
            except
              result := MP3ERR_FOpenR;
              Exit;
            end;
          end;
          // delete cache
          DeleteFile(PChar(TmpName));

          // delete existing-tag-object
          ExistingID3Tag.Free;

      end;  // if ID3v2Stream.Size > 0;

    finally
      ID3v2Stream.Free;
      // delete cache
      DeleteFile(PChar(FrameName));
    end;
  except
    on EFCreateError do result := MP3ERR_FopenCRT;
    on EWriteError do result := MP3ERR_SWrite;
    on E: Exception do
    begin
      result := ID3ERR_Unclassified;
      MessageBox(0, PChar(E.Message), PChar('Error Error'), MB_OK or MB_ICONERROR or MB_TASKMODAL or MB_SETFOREGROUND);
    end;
  end;
end;

//--------------------------------------------------------------------
// delete tag
//--------------------------------------------------------------------
function TID3v2Tag.RemoveFromStream(Stream: TStream): TMP3Error;
var
  TmpStream: TMPFUFileStream;
  TmpName: String;     // temporary filename. Delphi-Default-String
  tmpsize: int64;
  ExistingID3Tag: TID3v2Tag;
begin
  result := MP3ERR_None;
  try
      ExistingID3Tag := TID3v2Tag.Create;
      ExistingID3Tag.ReadHeader(Stream);

      // if a Tag existiert...
      if ExistingID3Tag.FExists then
      begin
          // ...jump to its end...
          Stream.Seek(ExistingID3Tag.FTagSize, soBeginning);

          // ...cache Audiodat to temporary file...
          TmpName := GetTempFile;
          try
              TmpStream := TMPFUFileStream.Create(TmpName, fmCreate);
              try
                  TmpStream.Seek(0, soBeginning);
                  tmpsize := Stream.Size - Stream.Position;
                  if TmpStream.CopyFrom(Stream, Stream.Size - Stream.Position) <> tmpsize then
                  begin
                      TmpStream.Free;
                      ExistingID3Tag.Free;
                      result := ID3ERR_Cache;
                      Exit;
                  end;
                  // ...cut the stream...
                  Stream.Seek(-ExistingID3Tag.FTagSize, soEnd);
                  SetStreamEnd(Stream);
                  ExistingID3Tag.Free;
                  // ...and write the audiodata back.
                  Stream.Seek(0, soBeginning);
                  TmpStream.Seek(0, soBeginning);
                  if Stream.CopyFrom(TmpStream, TmpStream.Size) <> TmpStream.Size then
                  begin
                      TmpStream.Free;
                      ExistingID3Tag.Free;
                      result := ID3ERR_Cache;
                      Exit;
                  end;
              except
                  on EWriteError do result := MP3ERR_SWrite;
                  on E: Exception do
                  begin
                      result := ID3ERR_Unclassified;
                      MessageBox(0, PChar(E.Message), PChar('Error'), MB_OK or MB_ICONERROR or MB_TASKMODAL or MB_SETFOREGROUND);
                  end;
              end;
              // delete tmp-file
              TmpStream.Free;
              DeleteFile(PChar(TmpName));
          except
              on EFOpenError do result := MP3ERR_FOpenCRT;
              on E: Exception do
              begin
                  result := ID3ERR_Unclassified;
                  MessageBox(0, PChar(E.Message), PChar('Error'), MB_OK or MB_ICONERROR or MB_TASKMODAL or MB_SETFOREGROUND);
              end;
          end;
      end
      else
      begin
          ExistingID3Tag.Free;
          result := ID3ERR_NoTag;
      end;
  except
      on E: Exception do
      begin
          result := ID3ERR_Unclassified;
          MessageBox(0, PChar(E.Message), PChar('Error'), MB_OK or MB_ICONERROR or MB_TASKMODAL or MB_SETFOREGROUND);
      end;
  end;
end;


//--------------------------------------------------------------------
// read tag from file
//--------------------------------------------------------------------
function TID3v2Tag.ReadFromFile(Filename: UnicodeString): TMP3Error;
var Stream: TMPFUFileStream;
begin
  if WideFileExists(Filename) then
    try
      FFilename := Filename;
      Stream := TMPFUFileStream.Create(Filename, fmOpenRead or fmShareDenyWrite);
      try
        result := ReadFromStream(Stream);
      finally
        Stream.Free;
      end;
    except
      result := MP3ERR_FOpenR;
    end
  else
    result := MP3ERR_NoFile;
end;

//--------------------------------------------------------------------
// write tag to file
//--------------------------------------------------------------------
function TID3v2Tag.WriteToFile(Filename: UnicodeString): TMP3Error;
var Stream: TMPFUFileStream;
begin
  if WideFileExists(Filename) then
    try
      FFilename := Filename;
      Stream := TMPFUFileStream.Create(Filename, fmOpenReadWrite or fmShareDenyWrite);
      try
        result := WriteToStream(Stream);
      finally
        Stream.Free;
      end;
    except
      result := MP3ERR_FOpenRW;
    end
  else
    result := MP3ERR_NoFile;
end;

//--------------------------------------------------------------------
// delete tag from file
//--------------------------------------------------------------------
function TID3v2Tag.RemoveFromFile(Filename: UnicodeString): TMP3Error;
var Stream: TMPFUFileStream;
begin
  if WideFileExists(Filename) then
    try
      FFilename := Filename;
      Stream := TMPFUFileStream.Create(Filename, fmOpenReadWrite or fmShareDenyWrite);
      try
        result := RemoveFromStream(Stream);
      finally
        Stream.Free;
      end;
    except
      result := MP3ERR_FOpenRW;
    end
  else
    result := MP3ERR_NoFile;
end;


procedure TID3v2Tag.Clear;
begin
  // default-subversion is 3. I think this is common to most other taggers
  FVersion.Major := 3;
  FVersion.Minor := 0;
  FTagSize := 0;
  FDataSize :=0;
  fPaddingSize := 0;
  FExists := False;
  FUsePadding := True;
  fFlgUnsynch       := False;
  fFlgCompression   := False;
  fFlgExtended      := False;
  fFlgExperimental  := False;
  fFlgFooterPresent := False;
  fFlgUnknown       := False;
  FUseClusteredPadding := True;

  Frames.Clear;
end;


//--------------------------------------------------------------------
// Get the text from a text-frame
//--------------------------------------------------------------------
function TID3v2Tag.GetText(FrameID: TFrameIDs): UnicodeString;
var i:integer;
begin
  i := GetFrameIndex(FrameID);
  if i > -1 then
    result := (Frames[i] as TID3v2Frame).GetText
  else
    result := '';
end;

//--------------------------------------------------------------------
// Write a String in a text-frame
// if value = '', the frame will be deleted
//--------------------------------------------------------------------
procedure TID3v2Tag.SetText(FrameID:TFrameIDs; Value: UnicodeString);
var i:integer;
  idStr: AnsiString;
  NewFrame: TID3v2Frame;
begin
  // Check for valid frame-id
  idStr := GetFrameIDString(FrameID);
  if not ValidTextFrame(iDStr) then exit;

  i := GetFrameIndex(FrameID);
  if i > -1 then
  begin
      // Frame already exists
      if value = '' then
          Frames.Delete(i)
      else
          (Frames[i] as TID3v2Frame).SetText(Value);
  end
  else
      if value <> '' then
      begin
          // create new frame
          NewFrame := TID3v2Frame.Create(idStr, TID3v2FrameVersions(FVersion.Major));
          NewFrame.AlwaysWriteUnicode := fAlwaysWriteUnicode;

          newFrame.CharCode := fCharCode;
          NewFrame.AutoCorrectCodepage := fAutoCorrectCodepage;
          Frames.Add(newFrame);
          newFrame.SetText(Value);
      end;
end;

function TID3v2Tag.GetURL(FrameID: TFrameIDs): AnsiString;
var i:integer;
begin
  i := GetFrameIndex(FrameID);
  if i > -1 then
    result := (Frames[i] as TID3v2Frame).GetURL
  else
    result := '';
end;
procedure TID3v2Tag.SetURL(FrameID:TFrameIDs; Value: AnsiString);
var i:integer;
  idStr: AnsiString;
  NewFrame: TID3v2Frame;
begin
  idStr := GetFrameIDString(FrameID);
  if not ValidFrame(iDStr) then exit;

  i := GetFrameIndex(FrameID);
  if i > -1 then
  begin
      // Frame already exists
      if value = '' then
          Frames.Delete(i)
      else
          (Frames[i] as TID3v2Frame).SetURL(Value);
  end
  else
      if value <> '' then
      begin
          // create new frame
          NewFrame := TID3v2Frame.Create(idStr, TID3v2FrameVersions(FVersion.Major));
          NewFrame.AlwaysWriteUnicode := fAlwaysWriteUnicode;
          newFrame.CharCode := fCharCode;
          NewFrame.AutoCorrectCodepage := fAutoCorrectCodepage;
          Frames.Add(newFrame);
          newFrame.SetURL(Value);
      end;
end;

//--------------------------------------------------------------------
// Get the text from an "user defined textframe" (TXXX)
//--------------------------------------------------------------------
function TID3v2Tag.GetUserText(Description: UnicodeString): UnicodeString;
var i: integer;
    DummyDescription: UnicodeString;
begin
    i := GetUserTextFrameIndex(Description);
    if i > -1 then
        result := TID3v2Frame(Frames[i]).GetUserText(DummyDescription)
    else
        result := '';
end;
procedure TID3v2Tag.SetUserText(Description, Value: UnicodeString);
var i: Integer;
    NewFrame: TID3v2Frame;
    idStr: AnsiString;
begin
    // search Frame
    i := GetUserTextFrameIndex(Description);

    if i > -1 then
    begin
        // Frame already exists
        if value = '' then
            Frames.Delete(i)
        else
            (Frames[i] as TID3v2Frame).SetUserText(Description, value);
    end
    else
    begin
        if value <> '' then
        begin
            // create new frame
            idStr := GetFrameIDString(IDv2_USERDEFINEDTEXT); // TXX or TXXX
            NewFrame := TID3v2Frame.Create(idStr, TID3v2FrameVersions(FVersion.Major));
            NewFrame.AlwaysWriteUnicode := fAlwaysWriteUnicode;
            NewFrame.CharCode := fCharCode;
            NewFrame.AutoCorrectCodepage := fAutoCorrectCodepage;
            Frames.Add(NewFrame);
            NewFrame.SetUserText(Description, value);
        end;
    end;
end;


//--------------------------------------------------------------------
// Get the text from an "described textframe", like lyrics and comments
//--------------------------------------------------------------------
function TID3v2Tag.GetDescribedTextFrame(ID: TFrameIDs; Language: AnsiString; Description: UnicodeString): UnicodeString;
var i: integer;
    DummyLanguage: AnsiString;
    DummyDescription: UnicodeString;
begin
  i := GetDescribedTextFrameIndex(ID,Language,Description);
  if i > -1 then
      result := (Frames[i] as TID3v2Frame).GetCommentsLyrics(DummyLanguage,DummyDescription)
  else
      result:='';
end;

procedure TID3v2Tag.SetDescribedTextFrame(ID:TFrameIDs; Language: AnsiString; Description: UnicodeString; Value: UnicodeString);
var i:integer;
    idstr: AnsiString;
    NewFrame: TID3v2Frame;
begin
  // Note: There can be multiple frames with such IDs in a tag. They can be identified by id + language + description
  // Many programs show a "comment" or "lyric" without further information.
  // in this case, the description is often '' (empty string), language may differ
  // To get this "pseudo-default-comment/lyric" and overwrite it:
  // Use '*' as language to get the first frame mathcing the id and description
  // if no matching frame can be found, the language will be changed to 'eng'

  idStr := GetFrameIDString(ID);
  if not ValidFrame(iDStr) then exit;

  if (language <>'*') AND (length(language)<>3)
    then language := 'eng';

  // search Frame
  i := GetDescribedTextFrameIndex(ID, Language, Description);

  if i > -1 then
  begin
      // Frame already exists
      if value= '' then
          Frames.Delete(i)
      else
        (Frames[i] as TID3v2Frame).SetCommentsLyrics(Language, Description, Value);
  end
  else
      if value <> '' then
      begin
          // create new frame
          NewFrame := TID3v2Frame.Create(idStr, TID3v2FrameVersions(FVersion.Major));
          NewFrame.AlwaysWriteUnicode := fAlwaysWriteUnicode;
          newFrame.CharCode := fCharCode;
          NewFrame.AutoCorrectCodepage := fAutoCorrectCodepage;
          Frames.Add(newFrame);
          newFrame.SetCommentsLyrics(Language, Description, Value);
      end;
end;

// ------------------------------------------
// comments / lyrics
// ------------------------------------------
procedure TID3v2Tag.SetExtendedComment(Language:AnsiString; Description: UnicodeString; value:UnicodeString);
begin
  SetDescribedTextFrame(IDv2_COMMENT,Language,Description,value);
end;
function TID3v2Tag.GetExtendedComment(Language: AnsiString; Description: UnicodeString): UnicodeString;
begin
  result := GetDescribedTextFrame(IDv2_COMMENT,Language,Description);
end;

// ------------------------------------------
// lyrics
// ------------------------------------------
procedure TID3v2Tag.SetLyrics(Language:AnsiString; Description: UnicodeString; value: UnicodeString);
begin
  SetDescribedTextFrame(IDv2_LYRICS,Language,Description,value);
end;
function TID3v2Tag.GetLyrics(Language:AnsiString; Description: UnicodeString): UnicodeString;
begin
  result := GetDescribedTextFrame(IDv2_LYRICS,Language,Description);
end;

// ------------------------------------------
// read pictures
// ------------------------------------------
function TID3v2Tag.GetPicture(stream: TStream; Description: UnicodeString): AnsiString;
var idx: Integer;
    mime: AnsiString;
    DummyPicTyp: Byte;
    DummyDesc: UnicodeString;
begin
    IDX := GetPictureFrameIndex( Description);
    if IDX <> -1 then
    begin
      (Frames[IDX] as TID3v2Frame).GetPicture(Mime, DummyPicTyp, DummyDesc, stream);
      result := mime;
    end else
      result := '';
end;
// ------------------------------------------
// set pictures
// ------------------------------------------
procedure TID3v2Tag.SetPicture(MimeTyp: AnsiString; PicType: Byte; Description: UnicodeString; stream: TStream);
var IDX: Integer;
    NewFrame: TID3v2Frame;
    idStr: AnsiString;
    oldMime: AnsiString;
    oldDescription: UnicodeString;
    oldType: Byte;
    oldStream: TMemoryStream;
begin
    idStr := GetFrameIDString(IDv2_PICTURE);
    IDX := GetPictureFrameIndex({PicType,} Description);
    if IDX <> -1 then
    begin
        if Stream = NIL then
          Frames.Delete(IDX)
        else
        begin
            if (Description = '*') or (MimeTyp = '*') or (Stream.size = 0) then
            begin
                oldStream := TMemoryStream.Create;
                (Frames[IDX] as TID3v2Frame).GetPicture(oldMime, oldType, oldDescription, oldStream);
                if (Description = '*') then
                  Description := oldDescription;
                if (MimeTyp = '*') then
                  MimeTyp := oldMime;
                if Stream.Size = 0 then
                  oldStream.SaveToStream(Stream);
                oldStream.Free;
            end;
            (Frames[IDX] as TID3v2Frame).SetPicture(MimeTyp, PicType, Description, Stream)
        end;

    end else
    begin
        if (Stream <> NIL) and (Stream.Size > 0)then
        begin
            NewFrame := TID3v2Frame.Create(idStr, TID3v2FrameVersions(FVersion.Major));
            NewFrame.AlwaysWriteUnicode := fAlwaysWriteUnicode;
            newFrame.CharCode := fCharCode;
            NewFrame.AutoCorrectCodepage := fAutoCorrectCodepage;
            Frames.Add(newFrame);
            if (Description = '*') then
                Description := '';
            if (MimeTyp = '*') then
                  MimeTyp := 'image/jpeg';
            newFrame.SetPicture(MimeTyp, PicType, Description, stream)
        end;
    end;
end;


// ------------------------------------------
// URLs
// ------------------------------------------
function TID3v2Tag.GetUserDefinedURL(Description: UnicodeString): AnsiString;
var IDX: Integer;
    DummyDesc: UnicodeString;
begin
    IDX := GetUserDefinedURLFrameIndex(Description);
    if IDX <> -1 then
        result := (Frames[IDX] as TID3v2Frame).GetUserdefinedURL(DummyDesc);
end;
procedure TID3v2Tag.SetUserDefinedURL(Description: UnicodeString; Value: AnsiString);
var IDX: Integer;
    NewFrame: TID3v2Frame;
    idStr: AnsiString;
begin
    idStr := GetFrameIDString(IDv2_USERDEFINEDURL);
    IDX := GetUserDefinedURLFrameIndex(Description);
    if IDX <> -1 then
    begin
        if Value <> '' then
            (Frames[IDX] as TID3v2Frame).SetUserdefinedURL(Description, Value)
        else
            Frames.Delete(IDX);
    end else
    begin
        if Value <> '' then
        begin
            NewFrame := TID3v2Frame.Create(idStr, TID3v2FrameVersions(FVersion.Major));
            NewFrame.AlwaysWriteUnicode := fAlwaysWriteUnicode;
            newFrame.CharCode := fCharCode;
            NewFrame.AutoCorrectCodepage := fAutoCorrectCodepage;
            Frames.Add(newFrame);
            newFrame.SetUserdefinedURL(Description, Value)
        end;
    end;
end;


function TID3v2Tag.GetStandardUserDefinedURL: AnsiString;
begin
    result := GetUserDefinedURL('');
end;
procedure TID3v2Tag.SetStandardUserDefinedURL(Value: AnsiString);
begin
    SetUserDefinedURL('', Value);
end;

// ------------------------------------------
// Ratings
// ------------------------------------------
procedure TID3v2Tag.SetRatingAndCounter(aEMail: AnsiString; aRating: Integer {Byte}; aCounter: Integer{Cardinal});
var IDX: Integer;
    NewFrame: TID3v2Frame;
    idStr: AnsiString;
    currentRating: Byte;
    currentCounter: Cardinal;
    currentMail: AnsiString;
    newRating: Byte;
    newCounter: Cardinal;
begin
    if aRating >= 0 then
        newRating := aRating Mod 256
    else
        newRating := 0;

    if aCounter >= 0 then
        newCounter := aCounter
    else
        newCounter := 0;

    idStr := GetFrameIDString(IDv2_RATING);
    IDX := GetPopularimaterFrameIndex(aEMail);
    if IDX <> -1 then
    begin
        // there is a Rating/Counter-Frame in the tag
        // 1.) Get the currentRating, - Counter and eMail (Out-Paramater)
        currentRating  := (Frames[IDX] as TID3v2Frame).GetRating(currentMail);
        currentCounter := (Frames[IDX] as TID3v2Frame).GetPersonalPlayCounter(currentMail);
        // 2. Check if the frame should be deleted
        if ((aRating = 0) and (aCounter = 0))            // set both to 0
             or ((aRating = 0) and ((aCounter = -1) and (currentCounter = 0))) // set one to 0 and the
             or ((aRating = -1) and (currentRating = 0) and (aCounter = 0))    // other (which is 0 atm) untouched
        then
            // the frame will contain no information after this, so it can be deleted
            Frames.Delete(IDX)
        else
        begin
            // Set new information, the frame should NOT be deleted
            if aEMail = '*' then
                aEMail := currentMail;

            if aRating <> -1 then
                (Frames[IDX] as TID3v2Frame).SetRating(aEMail, newRating);
            if aCounter <> -1 then
                (Frames[IDX] as TID3v2Frame).SetPersonalPlayCounter(aEMail, newCounter);
        end;
    end else
    begin
        // create a new frame
        NewFrame := TID3v2Frame.Create(idStr, TID3v2FrameVersions(FVersion.Major));
        NewFrame.AlwaysWriteUnicode := fAlwaysWriteUnicode;
        newFrame.CharCode := fCharCode;
        NewFrame.AutoCorrectCodepage := fAutoCorrectCodepage;
        Frames.Add(newFrame);

        if aEMail = '*' then
            aEMail := DefaultRatingDescription;

        if aRating <> -1 then
            newFrame.SetRating(aEMail, newRating);
        if aCounter <> -1 then
            newFrame.SetPersonalPlayCounter(aEMail, newCounter);
    end;
end;


function TID3v2Tag.GetArbitraryRating: Byte;
begin
    result := GetRating('*');
end;
procedure TID3v2Tag.SetArbitraryRating(Value: Byte);
begin
    // SetRating('*', Value);
    SetRatingAndCounter('*', Value, -1);
end;
function TID3v2Tag.GetArbitraryPersonalPlayCounter: Cardinal;
begin
    result := GetPersonalPlayCounter('*');
end;
procedure TID3v2Tag.SetArbitraryPersonalPlayCounter(Value: Cardinal);
begin
    //SetPersonalPlayCounter('*', Value);
    SetRatingAndCounter('*', -1, Value);
end;

function TID3v2Tag.GetRating(aEMail: AnsiString): Byte;
var IDX: Integer;
begin
    IDX := GetPopularimaterFrameIndex(aEMail);
    if IDX <> -1 then
        result := (Frames[IDX] as TID3v2Frame).GetRating(aEMail)
    else
        result := 0;
end;

(*procedure TID3v2Tag.SetRating(aEMail: AnsiString; Value: Byte);
var IDX: Integer;
    NewFrame: TID3v2Frame;
    idStr: AnsiString;
begin
    idStr := GetFrameIDString(IDv2_RATING);
    IDX := GetPopularimaterFrameIndex(aEMail);
    if IDX <> -1 then
    begin
        if Value <> 0 then
        begin
            if aEMail = '*' then // alte Adresse weiterbenutzen
                (Frames[IDX] as TID3v2Frame).GetRating(aEMail);
            (Frames[IDX] as TID3v2Frame).SetRating(aEMail, Value);
        end
        else
            Frames.Delete(IDX);
    end else
    begin
        if Value <> 0 then
        begin
            NewFrame := TID3v2Frame.Create(idStr, TID3v2FrameVersions(FVersion.Major));
            NewFrame.AlwaysWriteUnicode := fAlwaysWriteUnicode;
            newFrame.CharCode := fCharCode;
            NewFrame.AutoCorrectCodepage := fAutoCorrectCodepage;
            Frames.Add(newFrame);
            if aEMail = '*' then
                aEMail := DefaultRatingDescription;
            newFrame.SetRating(aEMail, Value);
        end;
    end;
end;
*)

function TID3v2Tag.GetPersonalPlayCounter(aEMail: AnsiString): Cardinal;
var IDX: Integer;
begin
    IDX := GetPopularimaterFrameIndex(aEMail);
    if IDX <> -1 then
        result := (Frames[IDX] as TID3v2Frame).GetPersonalPlayCounter(aEMail)
    else
        result := 0;
end;
(*
procedure TID3v2Tag.SetPersonalPlayCounter(aEMail: AnsiString; Value: Cardinal);
var IDX: Integer;
    NewFrame: TID3v2Frame;
    idStr: AnsiString;
begin
    idStr := GetFrameIDString(IDv2_RATING);
    IDX := GetPopularimaterFrameIndex(aEMail);
    if IDX <> -1 then
    begin
        if Value <> 0 then
        begin
            if aEMail = '*' then // alte Adresse weiterbenutzen
                (Frames[IDX] as TID3v2Frame).GetRating(aEMail);
            (Frames[IDX] as TID3v2Frame).SetPersonalPlayCounter(aEMail, Value);
        end
        else
            Frames.Delete(IDX);
    end else
    begin
        if Value <> 0 then
        begin
            NewFrame := TID3v2Frame.Create(idStr, TID3v2FrameVersions(FVersion.Major));
            NewFrame.AlwaysWriteUnicode := fAlwaysWriteUnicode;
            newFrame.CharCode := fCharCode;
            NewFrame.AutoCorrectCodepage := fAutoCorrectCodepage;
            Frames.Add(newFrame);
            if aEMail = '*' then
                aEMail := DefaultRatingDescription;
            // There is no rating in th frame, set it to 0
            newFrame.SetRating(aEMail, 0);
            newFrame.SetPersonalPlayCounter(aEMail, value);
        end;
    end;

end;
*)


// ------------------------------------------
// Private Frames
// ------------------------------------------
function TID3v2Tag.GetPrivateFrame(aOwnerID: AnsiString;
  Content: TStream): Boolean;
var IDX: Integer;
begin
    IDX := GetPrivateFrameIndex(aOwnerID);
    if IDX <> -1 then
        result := (Frames[IDX] as TID3v2Frame).GetPrivateFrame(aOwnerID, Content)
    else
        result := False;
end;

procedure TID3v2Tag.SetPrivateFrame(aOwnerID: AnsiString; Content: TStream);
var IDX: Integer;
    NewFrame: TID3v2Frame;
    idStr: AnsiString;
begin
    idStr := GetFrameIDString(IDv2_PRIVATE);
    IDX := GetPrivateFrameIndex(aOwnerID);
    if IDX <> -1 then
    begin
        if assigned(Content) and (Content.Size > 0) then
            (Frames[IDX] as TID3v2Frame).SetPrivateFrame(aOwnerID, Content)
        else
            Frames.Delete(IDX);
    end else
    begin
        if assigned(Content) and (Content.Size > 0) then
        begin
            NewFrame := TID3v2Frame.Create(idStr, TID3v2FrameVersions(FVersion.Major));
            NewFrame.AlwaysWriteUnicode := fAlwaysWriteUnicode;
            newFrame.CharCode := fCharCode;
            NewFrame.AutoCorrectCodepage := fAutoCorrectCodepage;
            Frames.Add(newFrame);
            newFrame.SetPrivateFrame(aOwnerID, Content);
        end;
    end;

end;


// ------------------------------------------
// Setter for properties
// ------------------------------------------
procedure TID3v2Tag.SetTitle(Value: UnicodeString);
begin
  SetText(IDv2_TITEL, Value);
end;
procedure TID3v2Tag.SetArtist(Value: UnicodeString);
begin
  SetText(IDv2_ARTIST, Value);
end;
procedure TID3v2Tag.SetAlbum(Value: UnicodeString);
begin
  SetText(IDv2_ALBUM, Value);
end;
function TID3v2Tag.BuildID3v2Genre(value: UnicodeString): UnicodeString;
begin
  // (<Index>)<Name>
  if ID3Genres.IndexOf(value) > -1 then
    result := '(' + inttostr(ID3Genres.IndexOf(value)) + ')' + value
  else
    result := value;
end;
procedure TID3v2Tag.SetGenre(Value: UnicodeString);
begin
  SetText(IDv2_GENRE, BuildID3v2Genre(Value));
end;
procedure TID3v2Tag.SetYear(Value: UnicodeString);
var temp:integer;
begin
  temp := StrToIntDef(Trim(Value), 0);
  if  (temp > 0) and (temp < 10000) then
  begin
    Value := Trim(Value);
    Insert(StringOfChar('0', 4 - Length(Value)), Value, 1);
  end
  else
    Value := '';
  SetText(IDv2_YEAR, Value);
end;
procedure TID3v2Tag.SetTrack(Value: UnicodeString);
begin
  SetText(IDv2_TRACK, Value);
end;
procedure TID3v2Tag.SetStandardComment(Value: UnicodeString);
begin
  SetDescribedTextFrame(IDv2_COMMENT,'*','',value);
end;
procedure TID3v2Tag.SetStandardLyrics(Value: UnicodeString);
begin
  SetDescribedTextFrame(IDv2_Lyrics,'*','',value);
end;

procedure TID3v2Tag.SetComposer(Value: UnicodeString);
begin
  SetText(IDv2_COMPOSER, value);
end;
procedure TID3v2Tag.SetOriginalArtist(Value: UnicodeString);
begin
  SetText(IDv2_ORIGINALARTIST, value);
end;
procedure TID3v2Tag.SetCopyright(Value: UnicodeString);
begin
  SetText(IDv2_COPYRIGHT, value);
end;
procedure TID3v2Tag.SetEncodedBy(Value: UnicodeString);
begin
  SetText(IDv2_ENCODEDBY, value);
end;
procedure TID3v2Tag.SetLanguages(Value: UnicodeString);
begin
  SetText(IDv2_LANGUAGES, value);
end;
procedure TID3v2Tag.SetSoftwareSettings(Value: UnicodeString);
begin
  SetText(IDv2_SOFTWARESETTINGS, value);
end;
procedure TID3v2Tag.SetMediatype(Value: UnicodeString);
begin
  SetText(IDv2_MEDIATYPE, value);
end;

procedure TID3v2Tag.Setid3Length(Value: UnicodeString);
begin
  SetText(Idv2_LENGTH, value);
end;
procedure TID3v2Tag.SetPublisher(Value: UnicodeString);
begin
  SetText(Idv2_PUBLISHER, value);
end;
procedure TID3v2Tag.SetOriginalFilename(Value: UnicodeString);
begin
  SetText(Idv2_ORIGINALFILENAME, value);
end;
procedure TID3v2Tag.SetOriginalLyricist(Value: UnicodeString);
begin
  SetText(Idv2_ORIGINALLYRICIST, value);
end;
procedure TID3v2Tag.SetOriginalReleaseYear(Value: UnicodeString);
begin
  SetText(Idv2_ORIGINALRELEASEYEAR, value);
end;
procedure TID3v2Tag.SetOriginalAlbumTitel(Value: UnicodeString);
begin
  SetText(Idv2_ORIGINALALBUMTITEL, value);
end;


// ------------------------------------------
// Getter for properties
// ------------------------------------------
function TID3v2Tag.GetTitle: UnicodeString;
begin
  result := GetText(IDv2_TITEL);
end;
function TID3v2Tag.GetArtist: UnicodeString;
begin
  result := GetText(IDv2_ARTIST);
end;
function TID3v2Tag.GetAlbum: UnicodeString;
begin
  result := GetText(IDv2_ALBUM);
end;
function TID3v2Tag.ParseID3v2Genre(value: UnicodeString): UnicodeString;
var posauf, poszu: integer;
  GenreID:Byte;
begin
  // Expected format of genre-strings:
  //    * (nr), with nr = Integer as defined for id3v1-tag
  //    * (nr)Description, with nr as above, description the matching description as in id3v1
  //    * Description, which should be searched in the genres[]-array
  // Default
  result := value;
  // parenthesis exists
  posauf := pos('(',value);
  poszu := pos(')',value);
  if posauf<poszu then
  begin
    GenreID := StrTointDef(copy(value,posauf+1, poszu-posauf-1),255);
    if GenreID < ID3Genres.Count then
      result := ID3Genres[GenreID];
  end;
end;
function TID3v2Tag.GetGenre: UnicodeString;
begin
  result := ParseID3v2Genre(GetText(IDv2_GENRE));
end;
function TID3v2Tag.GetYear: UnicodeString;
begin
  result := GetText(IDv2_YEAR);
end;
function TID3v2Tag.GetTrack: UnicodeString;
begin
  result := GetText(IDv2_TRACK);
end;
function TID3v2Tag.GetStandardComment: UnicodeString;
begin
  result := GetDescribedTextFrame(IDv2_COMMENT,'*','');
end;
function TID3v2Tag.GetStandardLyrics: UnicodeString;
begin
  result := GetDescribedTextFrame(IDv2_Lyrics,'*','');
end;

function TID3v2Tag.GetComposer: UnicodeString;
begin
  result := GetText(IDv2_COMPOSER);
end;
function TID3v2Tag.GetOriginalArtist: UnicodeString;
begin
  result := GetText(IDv2_ORIGINALARTIST);
end;
function TID3v2Tag.GetCopyright: UnicodeString;
begin
  result := GetText(IDv2_COPYRIGHT);
end;
function TID3v2Tag.GetEncodedBy: UnicodeString;
begin
  result := GetText(IDv2_ENCODEDBY);
end;
function TID3v2Tag.GetLanguages: UnicodeString;
begin
  result := GetText(IDv2_LANGUAGES);
end;
function TID3v2Tag.GetSoftwareSettings: UnicodeString;
begin
  result := GetText(IDv2_SOFTWARESETTINGS);
end;
function TID3v2Tag.GetMediatype: UnicodeString;
begin
  result := GetText(IDv2_MEDIATYPE);
end;

function TID3v2Tag.Getid3Length: UnicodeString;
begin
  result := GetText(IDv2_LENGTH);
end;
function TID3v2Tag.GetPublisher: UnicodeString;
begin
  result := GetText(IDv2_PUBLISHER);
end;
function TID3v2Tag.GetOriginalFilename: UnicodeString;
begin
  result := GetText(IDv2_ORIGINALFILENAME);
end;
function TID3v2Tag.GetOriginalLyricist: UnicodeString;
begin
  result := GetText(IDv2_ORIGINALLYRICIST);
end;
function TID3v2Tag.GetOriginalReleaseYear: UnicodeString;
begin
  result := GetText(IDv2_ORIGINALRELEASEYEAR);
end;
function TID3v2Tag.GetOriginalAlbumTitel: UnicodeString;
begin
  result := GetText(IDv2_ORIGINALALBUMTITEL);
end;


// ------------------------------------------
// some methods for "level 3"
// for experienced users only
// ------------------------------------------
function TID3v2Tag.GetAllFrames: TObjectlist;
begin
    result := TObjectList.Create(False);
    GetAllFrames(result);
end;
function TID3v2Tag.GetAllTextFrames: TObjectlist;
begin
    result := TObjectList.Create(False);
    GetAllTextFrames(result);
end;
function TID3v2Tag.GetAllUserTextFrames: TObjectlist;
begin
    result := TObjectList.Create(False);
    GetAllUserTextFrames(result);
end;
function TID3v2Tag.GetAllCommentFrames: TObjectlist;
begin
    result := TObjectList.Create(False);
    GetAllCommentFrames(result);
end;
function TID3v2Tag.GetAllLyricFrames: TObjectlist;
begin
    result := TObjectList.Create(False);
    GetAllLyricFrames(result);
end;
function TID3v2Tag.GetAllUserDefinedURLFrames: TObjectlist;
begin
    result := TObjectList.Create(False);
    GetAllUserDefinedURLFrames(result);
end;
function TID3v2Tag.GetAllPictureFrames: TObjectlist;
begin
    result := TObjectList.Create(False);
    GetAllPictureFrames(result);
end;
function TID3v2Tag.GetAllPopularimeterFrames: TObjectlist;
begin
    result := TObjectList.Create(False);
    GetAllPopularimeterFrames(result);
end;
function TID3v2Tag.GetAllURLFrames: TObjectlist;
begin
    result := TObjectList.Create(False);
    GetAllURLFrames(result);
end;

function TID3v2Tag.GetAllPrivateFrames: TObjectList;
begin
    result := TObjectList.Create(False);
    GetAllPrivateFrames(result);
end;

// New versions of the GetAll* functions:
// Target list as a Parameter
procedure TID3v2Tag.GetAllFrames(aList: TObjectlist);
var i: Integer;
begin
    aList.Clear;
    for i := 0 to Frames.Count-1 do
        aList.Add(Frames[i]);
end;
procedure TID3v2Tag.GetAllTextFrames(aList: TObjectlist);
var i: Integer;
begin
    aList.Clear;
    for i := 0 to Frames.Count-1 do
        if TID3v2Frame(Frames[i]).FrameType = FT_TextFrame then
            aList.Add(Frames[i]);
end;
procedure TID3v2Tag.GetAllUserTextFrames(aList: TObjectlist);
var i: Integer;
begin
    aList.Clear;
    for i := 0 to Frames.Count - 1 do
        if TID3v2Frame(Frames[i]).FrameType = FT_UserTextFrame then
            aList.Add(Frames[i]);
end;
procedure TID3v2Tag.GetAllCommentFrames(aList: TObjectlist);
var i: Integer;
    idStr: AnsiString;
begin
    aList.Clear;
    idStr := GetFrameIDString(IDv2_Comment);
    for i := 0 to Frames.Count-1 do
        if (Frames[i] as TID3v2Frame).FrameIDString = idStr then
            aList.Add(Frames[i]);
end;
procedure TID3v2Tag.GetAllLyricFrames(aList: TObjectlist);
var i: Integer;
    idStr: AnsiString;
begin
    aList.Clear;
    idStr := GetFrameIDString(IDv2_Lyrics);
    for i := 0 to Frames.Count-1 do
        if (Frames[i] as TID3v2Frame).FrameIDString = idStr then
            aList.Add(Frames[i]);
end;
procedure TID3v2Tag.GetAllUserDefinedURLFrames(aList: TObjectlist);
var i: Integer;
    idStr: AnsiString;
begin
    aList.Clear;
    idStr := GetFrameIDString(IDv2_USERDEFINEDURL);
    for i := 0 to Frames.Count-1 do
        if (Frames[i] as TID3v2Frame).FrameIDString = idStr then
            aList.Add(Frames[i]);
end;
procedure TID3v2Tag.GetAllPictureFrames(aList: TObjectlist);
var i: Integer;
    idStr: AnsiString;
begin
    aList.Clear;
    idStr := GetFrameIDString(IDv2_Picture);
    for i := 0 to Frames.Count-1 do
        if (Frames[i] as TID3v2Frame).FrameIDString = idStr then
            aList.Add(Frames[i]);
end;
procedure TID3v2Tag.GetAllPopularimeterFrames(aList: TObjectlist);
var i: Integer;
    idStr: AnsiString;
begin
    aList.Clear;
    idStr := GetFrameIDString(IDv2_Rating);
    for i := 0 to Frames.Count-1 do
        if (Frames[i] as TID3v2Frame).FrameIDString = idStr then
            aList.Add(Frames[i]);
end;
procedure TID3v2Tag.GetAllURLFrames(aList: TObjectlist);
var i: Integer;
begin
    aList.Clear;
    for i := 0 to Frames.Count-1 do
        if (Frames[i] as TID3v2Frame).FrameType = FT_URLFrame then
            aList.Add(Frames[i]);
end;
procedure TID3v2Tag.GetAllPrivateFrames(aList: TObjectlist);
var i: Integer;
    idStr: AnsiString;
begin
    aList.Clear;
    idStr := GetFrameIDString(IDv2_PRIVATE);
    for i := 0 to Frames.Count-1 do
        if (Frames[i] as TID3v2Frame).FrameIDString = idStr then
            aList.Add(Frames[i]);
end;




function TID3v2Tag.ValidNewCommentFrame(Language: AnsiString; Description: UnicodeString): Boolean;
begin
    result := GetDescribedTextFrameIndex(IDv2_Comment, Language, Description) = -1;
end;
function TID3v2Tag.ValidNewLyricFrame(Language: AnsiString; Description: UnicodeString): Boolean;
begin
    result := GetDescribedTextFrameIndex(IDv2_Lyrics, Language, Description) = -1;
end;
function TID3v2Tag.ValidNewPictureFrame(Description: UnicodeString): Boolean;
begin
    result := GetPictureFrameIndex(Description) = -1;
end;
function TID3v2Tag.ValidNewUserDefUrlFrame(Description: UnicodeString): Boolean;
begin
    result := GetUserDefinedURLFrameIndex(Description) = -1;
end;
function TID3v2Tag.ValidNewPopularimeterFrame(EMail: AnsiString): Boolean;
begin
    result := GetPopularimaterFrameIndex(EMail) = -1;
end;


function TID3v2Tag.GetAllowedTextFrames: TList;
var i: TFrameIDs;
begin
    result := TList.Create;
    for i := IDv2_ARTIST to IDv2_SETSUBTITLE do
      if (GetFrameIDString(i)[1] <> '-') AND (GetFrameIndex(i) = -1)
      then
        result.Add(Pointer(i));
end;

function TID3v2Tag.GetAllowedURLFrames: TList;
var i: TFrameIDs;
begin
    result := TList.Create;
    for i := IDv2_AUDIOFILEURL to IDv2_PAYMENTURL do
      if (GetFrameIDString(i)[1] <> '-') AND (GetFrameIndex(i) = -1)
      then
        result.Add(Pointer(i));
end;

function TID3v2Tag.AddFrame(aID: TFrameIDs): TID3v2Frame;
begin
    result := TID3v2Frame.Create( GetFrameIDString(aID), TID3v2FrameVersions(Version.Major));
    Frames.Add(result);
end;

procedure TID3v2Tag.DeleteFrame(aFrame: TID3v2Frame);
begin
    Frames.Remove(aFrame);
end;

procedure TID3v2Tag.SetCharCode(Value: TCodePage);
var i: Integer;
begin
    fCharCode := Value;
    for i := 0 to Frames.Count - 1 do
        (Frames[i] as TID3v2Frame).CharCode := Value;
end;

procedure TID3v2Tag.SetAutoCorrectCodepage(Value: Boolean);
var i: Integer;
begin
    fAutoCorrectCodepage := Value;
    for i := 0 to Frames.Count - 1 do
        (Frames[i] as TID3v2Frame).AutoCorrectCodepage := Value;
end;


//------------------------------------------------------
//------------------------------------------------------
//          *** mpeg ***
//------------------------------------------------------
//------------------------------------------------------


constructor TMpegInfo.create;
begin
  inherited create;
end;

//------------------------------------------------------
// Get the MPEG-Information from a stream
//------------------------------------------------------
function TMpegInfo.LoadFromStream(stream: tStream): TMP3Error;
var buffer: TBuffer;
  erfolg, Skip3rdTest: boolean;
  positionInStream: int64;  // position in the file/stream
  max: int64;
  c,bufferpos: integer;
  tmpMpegHeader, tmp2MpegHeader: TMpegHeader;
  tmpXingHeader: tXingHeader;

  smallBuffer1, smallBuffer2: TBuffer;
  blocksize: integer;
begin
  // be pessimistic first. No mpeg-frame-header found.
  result := MPEGERR_NoFrame;

  Fvalid := False;
  FfirstHeaderPosition := -1;
  blocksize := 512;
  // position in the stream - will be the position of the first mpeg-header at the end of this method
  positionInStream := Stream.Position-1 ;
  // position in the buffer-array
  bufferpos := -1 ;

  setlength(buffer, blocksize);
  c := Stream.Read(buffer[0], length(buffer));
  if c<blocksize then Setlength(Buffer, c);
  max := Stream.Size;
  erfolg :=False;

  FFilesize := max;

  while ( (NOT erfolg) AND (positionInStream + 3 < max ) )
  do begin
    inc(bufferpos);
    inc(positionInStream);
    // so we are at position 0 at first run

    // on the next cycle we have eventually to read some more data
    // to fill the buffer again
    if (bufferpos+3) = (length(buffer)-1) then
    begin
      Stream.Position := PositionInStream;
      c := Stream.Read(buffer[0], length(buffer));
      if c<blocksize then
        Setlength(Buffer, c);
      bufferpos := 0;
    end;

    tmpXingHeader.valid := False;

    // Step 1: Check, wether mpeg-header is on current position
    // ---------------------------------------------------------------------------
    tmpMpegHeader := GetValidatedHeader(Buffer, bufferpos);
    if not tmpMpegHeader.valid then continue;

    Skip3rdTest := False;
    // Step 2: Check, wether frame is a XING-Header
    // ---------------------------------------------------------------------------
    // therefor: eventually read more data into the buffer
    if (bufferpos + tmpMpegHeader.framelength + 3 > length(buffer)-1)  // next header not in buffer
       AND
       (positionInStream + tmpMpegHeader.framelength + 3 < max) // but in stream
       then
    begin
        // set streamposition to the beginning of the current header
        Stream.Position := PositionInStream;
        setlength(smallBuffer1,tmpMpegHeader.framelength + 4);
        // read data
        Stream.Read(smallBuffer1[0],length(smallBuffer1));
        // check Xing-header and next MPEG-header
        try
          tmpXingHeader := GetXingHeader(tmpMpegheader, smallbuffer1, 0);
          if (not tmpXingheader.valid) and (not tmpXingheader.corrupted) then
          begin
              // try VBRI
              tmpXingHeader := GetVBRIHeader(tmpMpegheader, smallBuffer1, 0);
              // Note: Some files with VBRI-Header seem to be invalid
              //       i.e. after the MPEG-Frame containing the VBRI-Header
              //       does not follow directly another MPEG-Frame.
              //       So I skip this test here.
              Skip3rdTest := tmpXingHeader.valid;
              if tmpXingHeader.valid then
                  tmp2MpegHeader.Valid := True
              else
                  // no Xing, no VBRI, probably "normal" MPEG-Frame
                  tmp2MpegHeader := GetValidatedHeader(smallBuffer1, tmpMpegHeader.framelength );
          end else
          begin
              if tmpXingHeader.corrupted then
                  // valid, but corrupted Xing-Frame. Calculate stuff by the NEXT MPEG-Frame, therefore: continue
                  tmp2MpegHeader.valid := False
              else
                  // no valid and intact Xing, no VBRI
                  tmp2MpegHeader := GetValidatedHeader(smallBuffer1, tmpMpegHeader.framelength );
          end;
        except
            tmp2MpegHeader.valid := false;
        end;
        Stream.Position := PositionInStream;
    end else
    begin
        if (positionInStream + tmpMpegHeader.framelength + 3 > max) then
        begin
            continue;
        end;
        // read XingHeader and next Mpeg-header from buffer
        tmpXingHeader := GetXingHeader(tmpMpegheader, buffer, bufferpos );
        if (not tmpXingheader.valid) and (not tmpXingheader.corrupted) then
        begin
            // try VBRI
            tmpXingHeader := GetVBRIHeader(tmpMpegheader, buffer, bufferpos );
            Skip3rdTest := tmpXingHeader.valid;     // see Note above
            if tmpXingHeader.valid then
                tmp2MpegHeader.Valid := True
            else
                // no Xing, no VBRI, probably "normal" MPEG-Frame
                tmp2MpegHeader := GetValidatedHeader(buffer, bufferpos + tmpMpegHeader.framelength);
        end else
        begin
            if tmpXingHeader.corrupted then
                // valid, but corrupted Xing-Frame. Calculate stuff by the NEXT MPEG-Frame, therefore: continue
                tmp2MpegHeader.valid := False
            else
                tmp2MpegHeader := GetValidatedHeader(buffer, bufferpos + tmpMpegHeader.framelength);
        end;
    end;

    // if next header is invalid something is wrong - search further. :(
    if not tmp2MpegHeader.valid then begin
        continue;
    end;

    // Step 3. Search a third Mpeg-Header
    // ---------------------------------------------------------------------------
    if Not Skip3rdTest then
    begin
        // eventually: load more data
        if (bufferpos + tmpMpegHeader.framelength + tmp2MpegHeader.framelength + 3 > length(buffer)-1)
           AND
           (positionInStream + tmpMpegHeader.framelength + tmp2MpegHeader.framelength + 3 < max)
        then
        begin
            Stream.Position := PositionInStream + tmpMpegHeader.framelength + tmp2MpegHeader.framelength;
            setlength(smallBuffer2,4);
            Stream.Read(smallBuffer2[0],length(smallBuffer2));
            Stream.Position := PositionInStream;
            if (smallbuffer2[0]<>$FF) OR (smallbuffer2[1]<$E0) then continue;
        end
        else
        begin
            if (positionInStream + tmpMpegHeader.framelength + tmp2MpegHeader.framelength + 3 > max)
            then continue;

            if (buffer[bufferpos + tmpMpegHeader.framelength + tmp2MpegHeader.framelength] <> $FF)
            OR (buffer[bufferpos + tmpMpegHeader.framelength + tmp2MpegHeader.framelength+1] < $E0)
            then continue;
        end;
    end;


    // Step 4. Success! - Set data!
    // ---------------------------------------------------------------------------
    Fversion := tmpMpegHeader.version;
    Flayer := tmpMpegHeader.layer;
    Fprotection := tmpMpegHeader.protection;
    Fsamplerate := tmpMpegHeader.samplerate;
    Fchannelmode := tmpMpegHeader.channelmode;
    Fextension := tmpMpegHeader.extension;
    Fcopyright := tmpMpegHeader.copyright;
    Foriginal := tmpMpegHeader.original;
    Femphasis := tmpMpegHeader.emphasis;

    if tmpXingHeader.valid then
      try
        // change 13.03.2016: round instead of trunc
        if Version = 1 then
            Fbitrate := round((tmpMpegheader.samplerate/1000 *
              (max - PositionInStream - tmpXingHeader.Size))  / (tmpXingHeader.frames*144))
        else
            Fbitrate := round((tmpMpegheader.samplerate/1000 *
              (max - PositionInStream - tmpXingHeader.Size))  / (tmpXingHeader.frames*72));

        Fvbr := tmpXingHeader.vbr;
        // note: Data at the beginning of the file are not audiodata (e.g. ID3v2Tag).
        // these bytes must be subducted from the filesize
        // it would be better, to subduct also the length of id3v1tag,
        // and other tags at the end of the file.
        // But I think, that this would be overkill, and would make only  +/-1 frames in most cases
        // change 13.03.2016: "round /" instead of DIV
        Fdauer := round( ((max-PositionInStream-tmpXingHeader.Size)*8) / ((Fbitrate)*1000));

        FFrames := tmpXingHeader.Frames;
      except
        continue;
      end
    else
      try
        Fframes := trunc((max - PositionInStream)/tmpMpegheader.framelength);
        FBitrate := tmpMpegHeader.bitrate;
        Fvbr := False;
        Fdauer := ((max - PositionInStream)*8) div ((Fbitrate)*1000);
      except
        continue;
      end;

    Fvalid := True;
    FfirstHeaderPosition := PositionInStream;
    result := MP3ERR_None;
    erfolg := True;
  end;
end;

function TMpegInfo.LoadFromFile(FileName: UnicodeString): TMP3Error;
var Stream: TMPFUFileStream;
begin
  if WideFileExists(Filename) then
    try
      stream := TMPFUFileStream.Create(filename, fmOpenRead or fmShareDenyWrite);
      try
        result := LoadFromStream(Stream);
      finally
        Stream.Free;
      end;
    except
      result := MP3ERR_FOpenR;
    end
  else
    result := MP3ERR_NoFile;
end;

//------------------------------------------------------
// Check, wether buffer contains a valid MPEG-Header
// and returns ist.
// Check property .valid to decide success/no success
//------------------------------------------------------
function TMpegInfo.GetValidatedHeader(aBuffer: TBuffer; position: integer): TMpegheader;
var bitrateindex, versionindex: byte;
    samplerateindex:byte;
    tmpLength: Integer;
begin
  // a mpeg-header starts with 11 (eleven) bits
  if (abuffer[position]<>$FF) OR (abuffer[position+1]<$E0)
  then
  begin
    result.valid := False;
    exit;
  end;

  //Byte 1 and 2: AAAAAAAA AAABBCCD
  //A=1 (11 Sync bytes) at the beginning
  //B: version, normally BB=11 (=MPEG1, Layer3), but some others are allowed
  //C: Layer, for layer III is CC=01
  //D: Protection BIT. If set, the header is followed by a 16bit CRC
  Versionindex := (abuffer[position+1] shr 3) and 3;
  case versionindex of
      0: result.version := 3; //version 2.5 actually - but I need an array-index. ;-)
      1: result.version := 0; //Reserved
      2: result.version := 2;
      3: result.version := 1;
  end;
  result.Layer := 4-((abuffer[position+1] shr 1) and 3);
  result.protection := (abuffer[position+1] AND 1)=0;

  // --->
  // bugfix by terryk from delphi-forum.de
  if (Result.version = 0) or (Result.Layer = 4) then
  begin
    Result.valid := False;
    Exit;
  end;
  // <---

  // Byte 3: EEEEFFGH
  // E: Bitrate-index
  // F: Samplerate-index
  // G: Padding bit
  // H: Private bit
  bitrateindex := (abuffer[position+2] shr 4) AND $F;
  result.bitrate := MPEG_BIT_RATES[result.version][result.layer][bitrateindex];
  if bitrateindex=$F then
  begin
    result.valid := false; // Bad Value !
    exit;
  end;
  samplerateindex := (abuffer[position+2] shr 2) AND $3;
  result.samplerate := sample_rates[result.version][samplerateindex];
  result.padding := ((abuffer[position+2] shr 1) AND $1) = 1;

  // Byte 4: IIJJKLMM
  // I: Channel mode
  // J: Mode extension (for Joint Stereo)
  // K: copyright
  // L: original
  // M: Emphasis   =0 in most cases
  result.channelmode := ((abuffer[position+3] shr 6) AND 3);
  result.extension := ((abuffer[position+3] shr 4) AND 3);
  result.copyright := ((abuffer[position+3] shr 3) AND 1)=1;
  result.original := ((abuffer[position+3] shr 2) AND 1)=1;
  result.emphasis := (abuffer[position+3] AND 3);

  // "For Layer II there are some combinations of bitrate and mode which are not allowed."
  if result.layer=2 then
      if ((result.bitrate=32) AND (result.channelmode<>3))
          OR ((result.bitrate=48) AND (result.channelmode<>3))
          OR ((result.bitrate=56) AND (result.channelmode<>3))
          OR ((result.bitrate=80) AND (result.channelmode<>3))
          OR ((result.bitrate=224) AND (result.channelmode=3))
          OR ((result.bitrate=256) AND (result.channelmode=3))
          OR ((result.bitrate=320) AND (result.channelmode=3))
          OR ((result.bitrate=384) AND (result.channelmode=3))
      then begin
        result.valid := false;
        exit;
      end;

  // calculate framelength
  tmpLength := GetFramelength(result.version, result.layer,
                              result.bitrate,
                              result.Samplerate,
                              result.padding);

  if tmpLength > 0 then
  begin
      result.valid := True;
      result.framelength := Word(tmpLength);
  end else
  begin
      result.valid := false;
      result.framelength := high(word);
  end;

end;

//------------------------------------------------------
// Check for a valid XING-header
// and returns ist.
// Check property .valid to decide success/no success
//------------------------------------------------------
function TMpegInfo.GetXingHeader(aMpegheader: TMpegHeader; aBuffer: TBuffer; position: integer ): TXingHeader;
var Xing_offset: integer;
  Xing_Flags: byte;
begin
  if aMpegheader.version=1 then
    if aMpegheader.channelmode<>3 then
      xing_offset := 32+4
    else
      xing_offset := 17+4
  else
    if aMpegheader.channelmode<>3 then
      xing_offset := 17+4
    else
      xing_offset := 9+4;

  Result.corrupted := False; // think positive!
  // --->
  // bugfix by terryk from delphi-forum.de
  if Length(abuffer) <= (position + xing_offset + 11) then
  begin
    Result.valid := False;
    Exit;
  end;
  // <---

  if ((abuffer[position+xing_offset]=$58)        {'Xing', vbr}
     AND (abuffer[position+xing_offset+1]=$69)
     AND (abuffer[position+xing_offset+2]=$6E)
     AND (abuffer[position+xing_offset+3]=$67))
     OR
     ((abuffer[position+xing_offset]=$49)        {'Info', cbr}
     AND (abuffer[position+xing_offset+1]=$6E)
     AND (abuffer[position+xing_offset+2]=$66)
     AND (abuffer[position+xing_offset+3]=$6F))

     then // Xing Tag found
  begin
          // the next 4 bytes are flags, the 4th (= pos+7) is interesting here
          Xing_flags := abuffer[position+xing_offset+7];
          if (Xing_flags AND 1)=1 then
          begin //number of frames in the next 4 bytes
              result.frames := 16777216 * abuffer[position+xing_offset+8]
                  + 65536 * abuffer[position+xing_offset+9]
                  + 256 * abuffer[position+xing_offset+10]
                  + abuffer[position+xing_offset+11];
          end
          else
              result.frames := 0;
          // Note 1: possible cause vor failures:
          //      In case the Xing-Header is corrupted here,
          //      the following calculations will base upon the first real mpegframe
          //      which very often has a much lower bitrate on vbr-files
          // Note 2: I never found a mp3file with such a corrupted xing-header.
          //      So this should be no problem. ;-)
          result.Size := aMpegHeader.framelength;
          result.vbr := (abuffer[position+xing_offset]=$58); //'X'
          // change 20.03.2016: Valid only if frames > 0.
          //                    There actually ARE files with a cleared INFO-Frame (nothing left but "Info")
          result.valid := result.frames > 0;
          result.corrupted := result.frames = 0;
  end else
    result.valid := False;
end;

function TMpegInfo.GetVBRIHeader(aMpegheader: TMpegHeader; aBuffer: TBuffer; position: integer): TVBRIHeader;
var vbriOffset: Integer;
begin
    // Set the new variables for the Xing/Info-Frame to the default values here
    result.corrupted := False;
    result.vbr := True;

    vbriOffset := 4 + 32; // constant offset
    if Length(abuffer) <= (position + vbriOffset + 16) then
    begin
        // buffer too short for valid VBRI-Header
        Result.valid := False;
        Exit;
    end;

    if (abuffer[position+vbriOffset]=$56)       // V
      AND (abuffer[position+vbriOffset+1]=$42)  // B
      AND (abuffer[position+vbriOffset+2]=$52)  // R
      AND (abuffer[position+vbriOffset+3]=$49)  // I
    then // VBRI found
    begin
        result.frames := 16777216 * abuffer[position+vbriOffset+14]
                  + 65536 * abuffer[position+vbriOffset+15]
                  + 256 * abuffer[position+vbriOffset+16]
                  + abuffer[position+vbriOffset+17];
        result.valid := True;
        result.Size := aMpegHeader.framelength;
    end else
        result.valid := False;
end;


function TMpegInfo.GetFramelength(version:byte;layer:byte;bitrate:longint;Samplerate:longint;padding:boolean):integer;
begin
  if samplerate=0 then result := -2
  else
    if Layer=1 then
      result := trunc(12*bitrate*1000 / samplerate+Integer(padding)*4)
    else
      if Version = 1 then
        result :=  144 * bitrate * 1000 DIV samplerate + integer(padding)
      else
        result := 72 * bitrate * 1000 DIV samplerate + integer(padding)

end;


initialization

  // source:
  // http://www.id3.org/iso639-2.html
  LanguageCodes := TStringList.Create;
  LanguageNames := TStringList.Create;
  LanguageCodes.CaseSensitive := False;
  LanguageNames.CaseSensitive := False;
  LanguageCodes.Add('aar');  LanguageNames.Add('Afar');
  LanguageCodes.Add('abk');  LanguageNames.Add('Abkhazian');
  LanguageCodes.Add('ace');  LanguageNames.Add('Achinese');
  LanguageCodes.Add('ach');  LanguageNames.Add('Acoli');
  LanguageCodes.Add('ada');  LanguageNames.Add('Adangme');
  LanguageCodes.Add('afa');  LanguageNames.Add('Afro-Asiatic (Other)');
  LanguageCodes.Add('afh');  LanguageNames.Add('Afrihili');
  LanguageCodes.Add('afr');  LanguageNames.Add('Afrikaans');
  LanguageCodes.Add('aka');  LanguageNames.Add('Akan');
  LanguageCodes.Add('akk');  LanguageNames.Add('Akkadian');
  LanguageCodes.Add('alb');  LanguageNames.Add('Albanian');
  LanguageCodes.Add('ale');  LanguageNames.Add('Aleut');
  LanguageCodes.Add('alg');  LanguageNames.Add('Algonquian Languages');
  LanguageCodes.Add('amh');  LanguageNames.Add('Amharic');
  LanguageCodes.Add('ang');  LanguageNames.Add('English, Old (ca. 450-1100)');
  LanguageCodes.Add('apa');  LanguageNames.Add('Apache Languages');
  LanguageCodes.Add('ara');  LanguageNames.Add('Arabic');
  LanguageCodes.Add('arc');  LanguageNames.Add('Aramaic');
  LanguageCodes.Add('arm');  LanguageNames.Add('Armenian');
  LanguageCodes.Add('arn');  LanguageNames.Add('Araucanian');
  LanguageCodes.Add('arp');  LanguageNames.Add('Arapaho');
  LanguageCodes.Add('art');  LanguageNames.Add('Artificial (Other)');
  LanguageCodes.Add('arw');  LanguageNames.Add('Arawak');
  LanguageCodes.Add('asm');  LanguageNames.Add('Assamese');
  LanguageCodes.Add('ath');  LanguageNames.Add('Athapascan Languages');
  LanguageCodes.Add('ava');  LanguageNames.Add('Avaric');
  LanguageCodes.Add('ave');  LanguageNames.Add('Avestan');
  LanguageCodes.Add('awa');  LanguageNames.Add('Awadhi');
  LanguageCodes.Add('aym');  LanguageNames.Add('Aymara');
  LanguageCodes.Add('aze');  LanguageNames.Add('Azerbaijani');
  LanguageCodes.Add('bad');  LanguageNames.Add('Banda');
  LanguageCodes.Add('bai');  LanguageNames.Add('Bamileke Languages');
  LanguageCodes.Add('bak');  LanguageNames.Add('Bashkir');
  LanguageCodes.Add('bal');  LanguageNames.Add('Baluchi');
  LanguageCodes.Add('bam');  LanguageNames.Add('Bambara');
  LanguageCodes.Add('ban');  LanguageNames.Add('Balinese');
  LanguageCodes.Add('baq');  LanguageNames.Add('Basque');
  LanguageCodes.Add('bas');  LanguageNames.Add('Basa');
  LanguageCodes.Add('bat');  LanguageNames.Add('Baltic (Other)');
  LanguageCodes.Add('bej');  LanguageNames.Add('Beja');
  LanguageCodes.Add('bel');  LanguageNames.Add('Byelorussian');
  LanguageCodes.Add('bem');  LanguageNames.Add('Bemba');
  LanguageCodes.Add('ben');  LanguageNames.Add('Bengali');
  LanguageCodes.Add('ber');  LanguageNames.Add('Berber (Other)');
  LanguageCodes.Add('bho');  LanguageNames.Add('Bhojpuri');
  LanguageCodes.Add('bih');  LanguageNames.Add('Bihari');
  LanguageCodes.Add('bik');  LanguageNames.Add('Bikol');
  LanguageCodes.Add('bin');  LanguageNames.Add('Bini');
  LanguageCodes.Add('bis');  LanguageNames.Add('Bislama');
  LanguageCodes.Add('bla');  LanguageNames.Add('Siksika');
  LanguageCodes.Add('bnt');  LanguageNames.Add('Bantu (Other)');
  LanguageCodes.Add('bod');  LanguageNames.Add('Tibetan');
  LanguageCodes.Add('bra');  LanguageNames.Add('Braj');
  LanguageCodes.Add('bre');  LanguageNames.Add('Breton');
  LanguageCodes.Add('bua');  LanguageNames.Add('Buriat');
  LanguageCodes.Add('bug');  LanguageNames.Add('Buginese');
  LanguageCodes.Add('bul');  LanguageNames.Add('Bulgarian	');
  LanguageCodes.Add('bur');  LanguageNames.Add('Burmese	');
  LanguageCodes.Add('cad');  LanguageNames.Add('Caddo');
  LanguageCodes.Add('cai');  LanguageNames.Add('Central American Indian (Other)');
  LanguageCodes.Add('car');  LanguageNames.Add('Carib');
  LanguageCodes.Add('cat');  LanguageNames.Add('Catalan	');
  LanguageCodes.Add('cau');  LanguageNames.Add('Caucasian (Other)');
  LanguageCodes.Add('ceb');  LanguageNames.Add('Cebuano');
  LanguageCodes.Add('cel');  LanguageNames.Add('Celtic (Other)');
  LanguageCodes.Add('ces');  LanguageNames.Add('Czech');
  LanguageCodes.Add('cha');  LanguageNames.Add('Chamorro');
  LanguageCodes.Add('chb');  LanguageNames.Add('Chibcha	');
  LanguageCodes.Add('che');  LanguageNames.Add('Chechen');
  LanguageCodes.Add('chg');  LanguageNames.Add('Chagatai');
  LanguageCodes.Add('chi');  LanguageNames.Add('Chinese');
  LanguageCodes.Add('chm');  LanguageNames.Add('Mari');
  LanguageCodes.Add('chn');  LanguageNames.Add('Chinook jargon');
  LanguageCodes.Add('cho');  LanguageNames.Add('Choctaw');
  LanguageCodes.Add('chr');  LanguageNames.Add('Cherokee');
  LanguageCodes.Add('chu');  LanguageNames.Add('Church Slavic');
  LanguageCodes.Add('chv');  LanguageNames.Add('Chuvash');
  LanguageCodes.Add('chy');  LanguageNames.Add('Cheyenne');
  LanguageCodes.Add('cop');  LanguageNames.Add('Coptic');
  LanguageCodes.Add('cor');  LanguageNames.Add('Cornish');
  LanguageCodes.Add('cos');  LanguageNames.Add('Corsican');
  LanguageCodes.Add('cpe');  LanguageNames.Add('Creoles and Pidgins, English-based (Other)');
  LanguageCodes.Add('cpf');  LanguageNames.Add('Creoles and Pidgins, French-based (Other)');
  LanguageCodes.Add('cpp');  LanguageNames.Add('Creoles and Pidgins, Portuguese-based (Other)');
  LanguageCodes.Add('cre');  LanguageNames.Add('Cree');
  LanguageCodes.Add('crp');  LanguageNames.Add('Creoles and Pidgins (Other)	');
  LanguageCodes.Add('cus');  LanguageNames.Add('Cushitic (Other)');
  LanguageCodes.Add('cym');  LanguageNames.Add('Welsh	');
  LanguageCodes.Add('cze');  LanguageNames.Add('Czech');
  LanguageCodes.Add('dak');  LanguageNames.Add('Dakota');
  LanguageCodes.Add('dan');  LanguageNames.Add('Danish');
  LanguageCodes.Add('del');  LanguageNames.Add('Delaware');
  LanguageCodes.Add('deu');  LanguageNames.Add('German');
  LanguageCodes.Add('din');  LanguageNames.Add('Dinka	');
  LanguageCodes.Add('div');  LanguageNames.Add('Divehi');
  LanguageCodes.Add('doi');  LanguageNames.Add('Dogri	');
  LanguageCodes.Add('dra');  LanguageNames.Add('Dravidian (Other)');
  LanguageCodes.Add('dua');  LanguageNames.Add('Duala');
  LanguageCodes.Add('dum');  LanguageNames.Add('Dutch, Middle (ca. 1050-1350)');
  LanguageCodes.Add('dut');  LanguageNames.Add('Dutch	');
  LanguageCodes.Add('dyu');  LanguageNames.Add('Dyula');
  LanguageCodes.Add('dzo');  LanguageNames.Add('Dzongkha');
  LanguageCodes.Add('efi');  LanguageNames.Add('Efik');
  LanguageCodes.Add('egy');  LanguageNames.Add('Egyptian (Ancient)');
  LanguageCodes.Add('eka');  LanguageNames.Add('Ekajuk');
  LanguageCodes.Add('ell');  LanguageNames.Add('Greek, Modern (1453-)');
  LanguageCodes.Add('elx');  LanguageNames.Add('Elamite');
  LanguageCodes.Add('eng');  LanguageNames.Add('English');
  LanguageCodes.Add('enm');  LanguageNames.Add('English, Middle (ca. 1100-1500)');
  LanguageCodes.Add('epo');  LanguageNames.Add('Esperanto	');
  LanguageCodes.Add('esk');  LanguageNames.Add('Eskimo (Other)');
  LanguageCodes.Add('esl');  LanguageNames.Add('Spanish');
  LanguageCodes.Add('est');  LanguageNames.Add('Estonian');
  LanguageCodes.Add('eus');  LanguageNames.Add('Basque');
  LanguageCodes.Add('ewe');  LanguageNames.Add('Ewe');
  LanguageCodes.Add('ewo');  LanguageNames.Add('Ewondo');
  LanguageCodes.Add('fan');  LanguageNames.Add('Fang');
  LanguageCodes.Add('fao');  LanguageNames.Add('Faroese');
  LanguageCodes.Add('fas');  LanguageNames.Add('Persian');
  LanguageCodes.Add('fat');  LanguageNames.Add('Fanti');
  LanguageCodes.Add('fij');  LanguageNames.Add('Fijian');
  LanguageCodes.Add('fin');  LanguageNames.Add('Finnish');
  LanguageCodes.Add('fiu');  LanguageNames.Add('Finno-Ugrian (Other)');
  LanguageCodes.Add('fon');  LanguageNames.Add('Fon');
  LanguageCodes.Add('fra');  LanguageNames.Add('French');
  LanguageCodes.Add('fre');  LanguageNames.Add('French');
  LanguageCodes.Add('frm');  LanguageNames.Add('French, Middle (ca. 1400-1600)');
  LanguageCodes.Add('fro');  LanguageNames.Add('French, Old (842- ca. 1400)');
  LanguageCodes.Add('fry');  LanguageNames.Add('Frisian');
  LanguageCodes.Add('ful');  LanguageNames.Add('Fulah');
  LanguageCodes.Add('gaa');  LanguageNames.Add('Ga');
  LanguageCodes.Add('gae');  LanguageNames.Add('Gaelic (Scots)');
  LanguageCodes.Add('gai');  LanguageNames.Add('Irish');
  LanguageCodes.Add('gay');  LanguageNames.Add('Gayo');
  LanguageCodes.Add('gdh');  LanguageNames.Add('Gaelic (Scots)');
  LanguageCodes.Add('gem');  LanguageNames.Add('Germanic (Other)');
  LanguageCodes.Add('geo');  LanguageNames.Add('Georgian');
  LanguageCodes.Add('ger');  LanguageNames.Add('German');
  LanguageCodes.Add('gez');  LanguageNames.Add('Geez');
  LanguageCodes.Add('gil');  LanguageNames.Add('Gilbertese');
  LanguageCodes.Add('glg');  LanguageNames.Add('Gallegan');
  LanguageCodes.Add('gmh');  LanguageNames.Add('German, Middle High (ca. 1050-1500)');
  LanguageCodes.Add('goh');  LanguageNames.Add('German, Old High (ca. 750-1050)');
  LanguageCodes.Add('gon');  LanguageNames.Add('Gondi');
  LanguageCodes.Add('got');  LanguageNames.Add('Gothic');
  LanguageCodes.Add('grb');  LanguageNames.Add('Grebo');
  LanguageCodes.Add('grc');  LanguageNames.Add('Greek, Ancient (to 1453)');
  LanguageCodes.Add('gre');  LanguageNames.Add('Greek, Modern (1453-)');
  LanguageCodes.Add('grn');  LanguageNames.Add('Guarani');
  LanguageCodes.Add('guj');  LanguageNames.Add('Gujarati');
  LanguageCodes.Add('hai');  LanguageNames.Add('Haida');
  LanguageCodes.Add('hau');  LanguageNames.Add('Hausa');
  LanguageCodes.Add('haw');  LanguageNames.Add('Hawaiian');
  LanguageCodes.Add('heb');  LanguageNames.Add('Hebrew');
  LanguageCodes.Add('her');  LanguageNames.Add('Herero');
  LanguageCodes.Add('hil');  LanguageNames.Add('Hiligaynon');
  LanguageCodes.Add('him');  LanguageNames.Add('Himachali');
  LanguageCodes.Add('hin');  LanguageNames.Add('Hindi');
  LanguageCodes.Add('hmo');  LanguageNames.Add('Hiri Motu');
  LanguageCodes.Add('hun');  LanguageNames.Add('Hungarian');
  LanguageCodes.Add('hup');  LanguageNames.Add('Hupa');
  LanguageCodes.Add('hye');  LanguageNames.Add('Armenian');
  LanguageCodes.Add('iba');  LanguageNames.Add('Iban');
  LanguageCodes.Add('ibo');  LanguageNames.Add('Igbo');
  LanguageCodes.Add('ice');  LanguageNames.Add('Icelandic');
  LanguageCodes.Add('ijo');  LanguageNames.Add('Ijo');
  LanguageCodes.Add('iku');  LanguageNames.Add('Inuktitut');
  LanguageCodes.Add('ilo');  LanguageNames.Add('Iloko');
  LanguageCodes.Add('ina');  LanguageNames.Add('Interlingua (International Auxiliary language Association)');
  LanguageCodes.Add('inc');  LanguageNames.Add('Indic (Other)');
  LanguageCodes.Add('ind');  LanguageNames.Add('Indonesian');
  LanguageCodes.Add('ine');  LanguageNames.Add('Indo-European (Other)');
  LanguageCodes.Add('ine');  LanguageNames.Add('Interlingue');
  LanguageCodes.Add('ipk');  LanguageNames.Add('Inupiak');
  LanguageCodes.Add('ira');  LanguageNames.Add('Iranian (Other)');
  LanguageCodes.Add('iri');  LanguageNames.Add('Irish');
  LanguageCodes.Add('iro');  LanguageNames.Add('Iroquoian uages');
  LanguageCodes.Add('isl');  LanguageNames.Add('Icelandic');
  LanguageCodes.Add('ita');  LanguageNames.Add('Italian');
  LanguageCodes.Add('jav');  LanguageNames.Add('Javanese');
  LanguageCodes.Add('jaw');  LanguageNames.Add('Javanese');
  LanguageCodes.Add('jpn');  LanguageNames.Add('Japanese');
  LanguageCodes.Add('jpr');  LanguageNames.Add('Judeo-Persian');
  LanguageCodes.Add('jrb');  LanguageNames.Add('Judeo-Arabic');
  LanguageCodes.Add('kaa');  LanguageNames.Add('Kara-Kalpak');
  LanguageCodes.Add('kab');  LanguageNames.Add('Kabyle');
  LanguageCodes.Add('kac');  LanguageNames.Add('Kachin');
  LanguageCodes.Add('kal');  LanguageNames.Add('Greenlandic');
  LanguageCodes.Add('kam');  LanguageNames.Add('Kamba');
  LanguageCodes.Add('kan');  LanguageNames.Add('Kannada');
  LanguageCodes.Add('kar');  LanguageNames.Add('Karen');
  LanguageCodes.Add('kas');  LanguageNames.Add('Kashmiri	');
  LanguageCodes.Add('kat');  LanguageNames.Add('Georgian');
  LanguageCodes.Add('kau');  LanguageNames.Add('Kanuri');
  LanguageCodes.Add('kaw');  LanguageNames.Add('Kawi');
  LanguageCodes.Add('kaz');  LanguageNames.Add('Kazakh');
  LanguageCodes.Add('kha');  LanguageNames.Add('Khasi');
  LanguageCodes.Add('khi');  LanguageNames.Add('Khoisan (Other)');
  LanguageCodes.Add('khm');  LanguageNames.Add('Khmer');
  LanguageCodes.Add('kho');  LanguageNames.Add('Khotanese');
  LanguageCodes.Add('kik');  LanguageNames.Add('Kikuyu');
  LanguageCodes.Add('kin');  LanguageNames.Add('Kinyarwanda');
  LanguageCodes.Add('kir');  LanguageNames.Add('Kirghiz');
  LanguageCodes.Add('kok');  LanguageNames.Add('Konkani');
  LanguageCodes.Add('kom');  LanguageNames.Add('Komi');
  LanguageCodes.Add('kon');  LanguageNames.Add('Kongo');
  LanguageCodes.Add('kor');  LanguageNames.Add('Korean');
  LanguageCodes.Add('kpe');  LanguageNames.Add('Kpelle');
  LanguageCodes.Add('kro');  LanguageNames.Add('Kru');
  LanguageCodes.Add('kru');  LanguageNames.Add('Kurukh');
  LanguageCodes.Add('kua');  LanguageNames.Add('Kuanyama');
  LanguageCodes.Add('kum');  LanguageNames.Add('Kumyk');
  LanguageCodes.Add('kur');  LanguageNames.Add('Kurdish');
  LanguageCodes.Add('kus');  LanguageNames.Add('Kusaie');
  LanguageCodes.Add('kut');  LanguageNames.Add('Kutenai');
  LanguageCodes.Add('lad');  LanguageNames.Add('Ladino');
  LanguageCodes.Add('lah');  LanguageNames.Add('Lahnda');
  LanguageCodes.Add('lam');  LanguageNames.Add('Lamba');
  LanguageCodes.Add('lao');  LanguageNames.Add('Lao');
  LanguageCodes.Add('lat');  LanguageNames.Add('Latin');
  LanguageCodes.Add('lav');  LanguageNames.Add('Latvian');
  LanguageCodes.Add('lez');  LanguageNames.Add('Lezghian');
  LanguageCodes.Add('lin');  LanguageNames.Add('Lingala');
  LanguageCodes.Add('lit');  LanguageNames.Add('Lithuanian');
  LanguageCodes.Add('lol');  LanguageNames.Add('Mongo');
  LanguageCodes.Add('loz');  LanguageNames.Add('Lozi');
  LanguageCodes.Add('ltz');  LanguageNames.Add('Letzeburgesch');
  LanguageCodes.Add('lub');  LanguageNames.Add('Luba-Katanga');
  LanguageCodes.Add('lug');  LanguageNames.Add('Ganda');
  LanguageCodes.Add('lui');  LanguageNames.Add('Luiseno');
  LanguageCodes.Add('lun');  LanguageNames.Add('Lunda');
  LanguageCodes.Add('luo');  LanguageNames.Add('Luo (Kenya and Tanzania)');
  LanguageCodes.Add('mac');  LanguageNames.Add('Macedonian');
  LanguageCodes.Add('mad');  LanguageNames.Add('Madurese');
  LanguageCodes.Add('mag');  LanguageNames.Add('Magahi');
  LanguageCodes.Add('mah');  LanguageNames.Add('Marshall');
  LanguageCodes.Add('mai');  LanguageNames.Add('Maithili');
  LanguageCodes.Add('mak');  LanguageNames.Add('Macedonian');
  LanguageCodes.Add('mak');  LanguageNames.Add('Makasar');
  LanguageCodes.Add('mal');  LanguageNames.Add('Malayalam	');
  LanguageCodes.Add('man');  LanguageNames.Add('Mandingo');
  LanguageCodes.Add('mao');  LanguageNames.Add('Maori');
  LanguageCodes.Add('map');  LanguageNames.Add('Austronesian (Other)');
  LanguageCodes.Add('mar');  LanguageNames.Add('Marathi');
  LanguageCodes.Add('mas');  LanguageNames.Add('Masai');
  LanguageCodes.Add('max');  LanguageNames.Add('Manx');
  LanguageCodes.Add('may');  LanguageNames.Add('Malay');
  LanguageCodes.Add('men');  LanguageNames.Add('Mende');
  LanguageCodes.Add('mga');  LanguageNames.Add('Irish, Middle (900 - 1200)');
  LanguageCodes.Add('mic');  LanguageNames.Add('Micmac');
  LanguageCodes.Add('min');  LanguageNames.Add('Minangkabau');
  LanguageCodes.Add('mis');  LanguageNames.Add('Miscellaneous (Other)');
  LanguageCodes.Add('mkh');  LanguageNames.Add('Mon-Kmer (Other)');
  LanguageCodes.Add('mlg');  LanguageNames.Add('Malagasy');
  LanguageCodes.Add('mlt');  LanguageNames.Add('Maltese');
  LanguageCodes.Add('mni');  LanguageNames.Add('Manipuri');
  LanguageCodes.Add('mno');  LanguageNames.Add('Manobo Languages');
  LanguageCodes.Add('moh');  LanguageNames.Add('Mohawk');
  LanguageCodes.Add('mol');  LanguageNames.Add('Moldavian');
  LanguageCodes.Add('mon');  LanguageNames.Add('Mongolian');
  LanguageCodes.Add('mos');  LanguageNames.Add('Mossi');
  LanguageCodes.Add('mri');  LanguageNames.Add('Maori');
  LanguageCodes.Add('msa');  LanguageNames.Add('Malay');
  LanguageCodes.Add('mul');  LanguageNames.Add('Multiple Languages');
  LanguageCodes.Add('mun');  LanguageNames.Add('Munda Languages');
  LanguageCodes.Add('mus');  LanguageNames.Add('Creek');
  LanguageCodes.Add('mwr');  LanguageNames.Add('Marwari');
  LanguageCodes.Add('mya');  LanguageNames.Add('Burmese');
  LanguageCodes.Add('myn');  LanguageNames.Add('Mayan Languages');
  LanguageCodes.Add('nah');  LanguageNames.Add('Aztec');
  LanguageCodes.Add('nai');  LanguageNames.Add('North American Indian (Other)');
  LanguageCodes.Add('nau');  LanguageNames.Add('Nauru');
  LanguageCodes.Add('nav');  LanguageNames.Add('Navajo');
  LanguageCodes.Add('nbl');  LanguageNames.Add('Ndebele, South');
  LanguageCodes.Add('nde');  LanguageNames.Add('Ndebele, North');
  LanguageCodes.Add('ndo');  LanguageNames.Add('Ndongo');
  LanguageCodes.Add('nep');  LanguageNames.Add('Nepali');
  LanguageCodes.Add('new');  LanguageNames.Add('Newari');
  LanguageCodes.Add('nic');  LanguageNames.Add('Niger-Kordofanian (Other)');
  LanguageCodes.Add('niu');  LanguageNames.Add('Niuean');
  LanguageCodes.Add('nla');  LanguageNames.Add('Dutch');
  LanguageCodes.Add('nno');  LanguageNames.Add('Norwegian (Nynorsk)');
  LanguageCodes.Add('non');  LanguageNames.Add('Norse, Old');
  LanguageCodes.Add('nor');  LanguageNames.Add('Norwegian');
  LanguageCodes.Add('nso');  LanguageNames.Add('Sotho, Northern');
  LanguageCodes.Add('nub');  LanguageNames.Add('Nubian Languages');
  LanguageCodes.Add('nya');  LanguageNames.Add('Nyanja');
  LanguageCodes.Add('nym');  LanguageNames.Add('Nyamwezi');
  LanguageCodes.Add('nyn');  LanguageNames.Add('Nyankole');
  LanguageCodes.Add('nyo');  LanguageNames.Add('Nyoro	');
  LanguageCodes.Add('nzi');  LanguageNames.Add('Nzima');
  LanguageCodes.Add('oci');  LanguageNames.Add('Langue d''Oc (post 1500)');
  LanguageCodes.Add('oji');  LanguageNames.Add('Ojibwa');
  LanguageCodes.Add('ori');  LanguageNames.Add('Oriya');
  LanguageCodes.Add('orm');  LanguageNames.Add('Oromo');
  LanguageCodes.Add('osa');  LanguageNames.Add('Osage');
  LanguageCodes.Add('oss');  LanguageNames.Add('Ossetic');
  LanguageCodes.Add('ota');  LanguageNames.Add('Turkish, Ottoman (1500 - 1928)');
  LanguageCodes.Add('oto');  LanguageNames.Add('Otomian Languages');
  LanguageCodes.Add('paa');  LanguageNames.Add('Papuan-Australian (Other)');
  LanguageCodes.Add('pag');  LanguageNames.Add('Pangasinan');
  LanguageCodes.Add('pal');  LanguageNames.Add('Pahlavi');
  LanguageCodes.Add('pam');  LanguageNames.Add('Pampanga');
  LanguageCodes.Add('pan');  LanguageNames.Add('Panjabi');
  LanguageCodes.Add('pap');  LanguageNames.Add('Papiamento');
  LanguageCodes.Add('pau');  LanguageNames.Add('Palauan');
  LanguageCodes.Add('peo');  LanguageNames.Add('Persian, Old (ca 600 - 400 B.C.)');
  LanguageCodes.Add('per');  LanguageNames.Add('Persian');
  LanguageCodes.Add('phn');  LanguageNames.Add('Phoenician');
  LanguageCodes.Add('pli');  LanguageNames.Add('Pali');
  LanguageCodes.Add('pol');  LanguageNames.Add('Polish');
  LanguageCodes.Add('pon');  LanguageNames.Add('Ponape');
  LanguageCodes.Add('por');  LanguageNames.Add('Portuguese');
  LanguageCodes.Add('pra');  LanguageNames.Add('Prakrit uages');
  LanguageCodes.Add('pro');  LanguageNames.Add('Provencal, Old (to 1500)');
  LanguageCodes.Add('pus');  LanguageNames.Add('Pushto');
  LanguageCodes.Add('que');  LanguageNames.Add('Quechua');
  LanguageCodes.Add('raj');  LanguageNames.Add('Rajasthani');
  LanguageCodes.Add('rar');  LanguageNames.Add('Rarotongan');
  LanguageCodes.Add('roa');  LanguageNames.Add('Romance (Other)');
  LanguageCodes.Add('roh');  LanguageNames.Add('Rhaeto-Romance');
  LanguageCodes.Add('rom');  LanguageNames.Add('Romany');
  LanguageCodes.Add('ron');  LanguageNames.Add('Romanian');
  LanguageCodes.Add('rum');  LanguageNames.Add('Romanian');
  LanguageCodes.Add('run');  LanguageNames.Add('Rundi');
  LanguageCodes.Add('rus');  LanguageNames.Add('Russian');
  LanguageCodes.Add('sad');  LanguageNames.Add('Sandawe');
  LanguageCodes.Add('sag');  LanguageNames.Add('Sango');
  LanguageCodes.Add('sah');  LanguageNames.Add('Yakut');
  LanguageCodes.Add('sai');  LanguageNames.Add('South American Indian (Other)');
  LanguageCodes.Add('sal');  LanguageNames.Add('Salishan Languages');
  LanguageCodes.Add('sam');  LanguageNames.Add('Samaritan Aramaic');
  LanguageCodes.Add('san');  LanguageNames.Add('Sanskrit');
  LanguageCodes.Add('sco');  LanguageNames.Add('Scots');
  LanguageCodes.Add('scr');  LanguageNames.Add('Serbo-Croatian');
  LanguageCodes.Add('sel');  LanguageNames.Add('Selkup');
  LanguageCodes.Add('sem');  LanguageNames.Add('Semitic (Other)');
  LanguageCodes.Add('sga');  LanguageNames.Add('Irish, Old (to 900)');
  LanguageCodes.Add('shn');  LanguageNames.Add('Shan');
  LanguageCodes.Add('sid');  LanguageNames.Add('Sidamo');
  LanguageCodes.Add('sin');  LanguageNames.Add('Singhalese');
  LanguageCodes.Add('sio');  LanguageNames.Add('Siouan Languages');
  LanguageCodes.Add('sit');  LanguageNames.Add('Sino-Tibetan (Other)');
  LanguageCodes.Add('sla');  LanguageNames.Add('Slavic (Other)');
  LanguageCodes.Add('slk');  LanguageNames.Add('Slovak');
  LanguageCodes.Add('slo');  LanguageNames.Add('Slovak');
  LanguageCodes.Add('slv');  LanguageNames.Add('Slovenian');
  LanguageCodes.Add('smi');  LanguageNames.Add('Sami Languages');
  LanguageCodes.Add('smo');  LanguageNames.Add('Samoan');
  LanguageCodes.Add('sna');  LanguageNames.Add('Shona');
  LanguageCodes.Add('snd');  LanguageNames.Add('Sindhi');
  LanguageCodes.Add('sog');  LanguageNames.Add('Sogdian');
  LanguageCodes.Add('som');  LanguageNames.Add('Somali');
  LanguageCodes.Add('son');  LanguageNames.Add('Songhai');
  LanguageCodes.Add('sot');  LanguageNames.Add('Sotho, Southern');
  LanguageCodes.Add('spa');  LanguageNames.Add('Spanish');
  LanguageCodes.Add('sqi');  LanguageNames.Add('Albanian');
  LanguageCodes.Add('srd');  LanguageNames.Add('Sardinian	');
  LanguageCodes.Add('srr');  LanguageNames.Add('Serer');
  LanguageCodes.Add('ssa');  LanguageNames.Add('Nilo-Saharan (Other)');
  LanguageCodes.Add('ssw');  LanguageNames.Add('Siswant');
  LanguageCodes.Add('ssw');  LanguageNames.Add('Swazi');
  LanguageCodes.Add('suk');  LanguageNames.Add('Sukuma');
  LanguageCodes.Add('sun');  LanguageNames.Add('Sudanese');
  LanguageCodes.Add('sus');  LanguageNames.Add('Susu');
  LanguageCodes.Add('sux');  LanguageNames.Add('Sumerian');
  LanguageCodes.Add('sve');  LanguageNames.Add('Swedish');
  LanguageCodes.Add('swa');  LanguageNames.Add('Swahili');
  LanguageCodes.Add('swe');  LanguageNames.Add('Swedish');
  LanguageCodes.Add('syr');  LanguageNames.Add('Syriac');
  LanguageCodes.Add('tah');  LanguageNames.Add('Tahitian');
  LanguageCodes.Add('tam');  LanguageNames.Add('Tamil');
  LanguageCodes.Add('tat');  LanguageNames.Add('Tatar');
  LanguageCodes.Add('tel');  LanguageNames.Add('Telugu');
  LanguageCodes.Add('tem');  LanguageNames.Add('Timne');
  LanguageCodes.Add('ter');  LanguageNames.Add('Tereno');
  LanguageCodes.Add('tgk');  LanguageNames.Add('Tajik');
  LanguageCodes.Add('tgl');  LanguageNames.Add('Tagalog');
  LanguageCodes.Add('tha');  LanguageNames.Add('Thai');
  LanguageCodes.Add('tib');  LanguageNames.Add('Tibetan');
  LanguageCodes.Add('tig');  LanguageNames.Add('Tigre');
  LanguageCodes.Add('tir');  LanguageNames.Add('Tigrinya');
  LanguageCodes.Add('tiv');  LanguageNames.Add('Tivi');
  LanguageCodes.Add('tli');  LanguageNames.Add('Tlingit	');
  LanguageCodes.Add('tmh');  LanguageNames.Add('Tamashek');
  LanguageCodes.Add('tog');  LanguageNames.Add('Tonga (Nyasa)	');
  LanguageCodes.Add('ton');  LanguageNames.Add('Tonga (Tonga Islands)');
  LanguageCodes.Add('tru');  LanguageNames.Add('Truk');
  LanguageCodes.Add('tsi');  LanguageNames.Add('Tsimshian');
  LanguageCodes.Add('tsn');  LanguageNames.Add('Tswana');
  LanguageCodes.Add('tso');  LanguageNames.Add('Tsonga');
  LanguageCodes.Add('tuk');  LanguageNames.Add('Turkmen');
  LanguageCodes.Add('tum');  LanguageNames.Add('Tumbuka');
  LanguageCodes.Add('tur');  LanguageNames.Add('Turkish');
  LanguageCodes.Add('tut');  LanguageNames.Add('Altaic (Other)');
  LanguageCodes.Add('twi');  LanguageNames.Add('Twi');
  LanguageCodes.Add('tyv');  LanguageNames.Add('Tuvinian');
  LanguageCodes.Add('uga');  LanguageNames.Add('Ugaritic');
  LanguageCodes.Add('uig');  LanguageNames.Add('Uighur');
  LanguageCodes.Add('ukr');  LanguageNames.Add('Ukrainian');
  LanguageCodes.Add('umb');  LanguageNames.Add('Umbundu');
  LanguageCodes.Add('und');  LanguageNames.Add('Undetermined');
  LanguageCodes.Add('urd');  LanguageNames.Add('Urdu');
  LanguageCodes.Add('uzb');  LanguageNames.Add('Uzbek');
  LanguageCodes.Add('vai');  LanguageNames.Add('Vai');
  LanguageCodes.Add('ven');  LanguageNames.Add('Venda');
  LanguageCodes.Add('vie');  LanguageNames.Add('Vietnamese');
  LanguageCodes.Add('vol');  LanguageNames.Add('Volapük');
  LanguageCodes.Add('vot');  LanguageNames.Add('Votic');
  LanguageCodes.Add('wak');  LanguageNames.Add('Wakashan Languages');
  LanguageCodes.Add('wal');  LanguageNames.Add('Walamo');
  LanguageCodes.Add('war');  LanguageNames.Add('Waray');
  LanguageCodes.Add('was');  LanguageNames.Add('Washo');
  LanguageCodes.Add('wel');  LanguageNames.Add('Welsh');
  LanguageCodes.Add('wen');  LanguageNames.Add('Sorbian Languages');
  LanguageCodes.Add('wol');  LanguageNames.Add('Wolof');
  LanguageCodes.Add('xho');  LanguageNames.Add('Xhosa');
  LanguageCodes.Add('yao');  LanguageNames.Add('Yao');
  LanguageCodes.Add('yap');  LanguageNames.Add('Yap');
  LanguageCodes.Add('yid');  LanguageNames.Add('Yiddish');
  LanguageCodes.Add('yor');  LanguageNames.Add('Yoruba');
  LanguageCodes.Add('zap');  LanguageNames.Add('Zapotec');
  LanguageCodes.Add('zen');  LanguageNames.Add('Zenaga');
  LanguageCodes.Add('zha');  LanguageNames.Add('Zhuang');
  LanguageCodes.Add('zho');  LanguageNames.Add('Chinese');
  LanguageCodes.Add('zul');  LanguageNames.Add('Zulu');
  LanguageCodes.Add('zun');  LanguageNames.Add('Zuni');

finalization

 LanguageCodes.Free;
 LanguageNames.Free;

end.
