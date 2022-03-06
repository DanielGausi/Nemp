{
    -----------------------------------
    Audio Werkzeuge Bibliothek
    -----------------------------------
    (c) 2012-2020, Daniel Gaussmann
              Website : www.gausi.de
              EMail   : mail@gausi.de
    -----------------------------------

    Unit ID3v2Tags

    Read/Write ID3v2Tags
    (This was part of the Unit MP3FileUtils before)

  -------------------------------------------------------

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

  -------------------------------------------------------
}

unit ID3v2Tags;

{$I config.inc}

interface

uses
  SysUtils, Classes, Windows, Contnrs, U_CharCode
  {$IFDEF USE_SYSTEM_TYPES}, System.Types{$ENDIF}
  , AudioFiles.Declarations, ID3v2Frames;

type


//--------------------------------------------------------------------
// Teil 1: Some small helpers
//--------------------------------------------------------------------

  TID3Version = record
    Major: Byte;
    Minor: Byte;
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

    function ReadFrames(From: LongInt; Stream: TStream): TAudioError;
    function ReadHeader(Stream: TStream): TAudioError;
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
    function GetBPM: UnicodeString;

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
    procedure SetBPM(Value: UnicodeString);

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

    // get the size of another ID3v2Tag in the Stream. used for removing/writing
    function GetExistingTagSize(aStream: TStream): Cardinal;

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
    property BPM: UnicodeString read GetBPM write SetBPM;


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

    function ReadFromStream(Stream: TStream): TAudioError;
    function WriteToStream(Stream: TStream): TAudioError;
    function RemoveFromStream(Stream: TStream): TAudioError;
    function ReadFromFile(Filename: UnicodeString): TAudioError;
    function WriteToFile(Filename: UnicodeString): TAudioError;
    function RemoveFromFile(Filename: UnicodeString): TAudioError;
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
    function GetAllFrames              : TObjectlist; overload; deprecated;
    function GetAllTextFrames          : TObjectlist; overload; deprecated;
    function GetAllUserTextFrames      : TObjectlist; overload; deprecated;
    function GetAllCommentFrames       : TObjectlist; overload; deprecated;
    function GetAllLyricFrames         : TObjectlist; overload; deprecated;
    function GetAllUserDefinedURLFrames: TObjectlist; overload; deprecated;
    function GetAllPictureFrames       : TObjectlist; overload; deprecated;
    function GetAllPopularimeterFrames : TObjectlist; overload; deprecated;
    function GetAllURLFrames           : TObjectlist; overload; deprecated;
    function GetAllPrivateFrames       : TObjectList; overload; deprecated;

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
    function GetAllowedTextFrames: TList; overload; deprecated;
    function GetAllowedURLFrames: TList;  overload; deprecated;  // WOAR, ... Not the user definied WXXX-Frame
    procedure GetAllowedTextFrames(aList: TList); overload;
    procedure GetAllowedURLFrames(aList: TList);  overload;


    function AddFrame(aID: TFrameIDs): TID3v2Frame;
    procedure DeleteFrame(aFrame: TID3v2Frame);
  end;
//--------------------------------------------------------------------


{.$Message Hint 'You should change the default rating description for your projects'}
var
  DefaultRatingDescription: AnsiString = 'Mp3ileUtils, www.gausi.de';
  // Changig this should be done e.g. in MainFormCreate or in the initialization-part
  // It should be like "<Name of the program>, <URL to your webpage>"


// Some useful functions.
// Use them e.g. in OnChange of a TEdit
function IsValidV2TrackString(value:string):boolean;

// Get a TrackNr. from a ID3v2-Tag-trackstring
  // e.g.: 3/15 => 3
function GetTrackFromV2TrackString(value: string): Integer;



implementation

uses ID3GenreList;


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
  Drive := AudioExtractFileDrive(aFileName);
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
function TID3v2Tag.ReadHeader(Stream: TStream): TAudioError;
var
  RawHeader: TID3v2Header;
  ExtendedHeader: Array[0..3] of byte;
  ExtendedHeaderSize: Integer;
begin
  result := FileErr_None;
  try
    Stream.Seek(0, soBeginning);
    Stream.ReadBuffer(RawHeader, 10);
    if RawHeader.ID = 'ID3' then
    begin
      if RawHeader.Version in [2,3,4] then
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
                  result := Mp3ERR_Compression;
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
          result := MP3ERR_Invalid_Header;
    end;
  except
    on EReadError do result := MP3ERR_StreamRead;
    on E: Exception do
    begin
      result := Mp3ERR_Unclassified;
      MessageBox(0, PChar(E.Message), PChar('Error'), MB_OK or MB_ICONERROR or MB_TASKMODAL or MB_SETFOREGROUND);
    end;
  end;
end;

//--------------------------------------------------------------------
// Read the frames of the ID3v2 Tags
//--------------------------------------------------------------------
function TID3v2Tag.ReadFrames(From: LongInt; Stream: TStream): TAudioError;
var FrameIDstr: AnsiString;
    newFrame: TID3v2Frame;
begin
  result := FileErr_None;
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
    on EReadError do result := MP3ERR_StreamRead;
    on E: Exception do
    begin
      result := Mp3ERR_Unclassified;
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
function TID3v2Tag.ReadFromStream(Stream: TStream): TAudioError;
var SyncedStream: TMemoryStream;
begin
  // Clear self
  clear;

  result := ReadHeader(Stream);
  if (FExists) and (result = FileErr_None) then
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

function TID3v2Tag.GetExistingTagSize(aStream: TStream): Cardinal;
var ExistingID3Tag: TID3v2Tag;
begin
    ExistingID3Tag := TID3v2Tag.Create;
    try
      ExistingID3Tag.ReadHeader(aStream);
      if ExistingID3Tag.FExists then
         result := ExistingID3Tag.FTagSize
      else
        result := 0;
    finally
       ExistingID3Tag.Free;
    end;
end;


function TID3v2Tag.WriteToStream(Stream: TStream): TAudioError;
var
  aHeader: TID3v2Header;
  TmpStream, ID3v2Stream: TAudioFileStream;
  TmpName, FrameName: String;  // temporary filenames. Delphi-Default-Strings
  v1Tag: String[3];
  v1AdditionalPadding: Cardinal;
  Buffer: TBuffer;
  CacheAudio: Boolean;
  i: Integer;
  AudioDataSize: int64;
  tmpFrameStream: TMemoryStream;
  ExistingTagSize: Cardinal;

begin
  result := FileErr_None;
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
    ID3v2Stream := TAudioFileStream.Create(FrameName, fmCreate or fmShareDenyWrite);
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
                  try
                      for i := 0 to Frames.Count - 1 do
                          (Frames[i] as TID3v2Frame).WriteToStream(tmpFrameStream);
                      tmpFrameStream.Position := 0;
                      UnSyncStream(tmpFrameStream, ID3v2Stream);
                  finally
                      tmpFrameStream.Free;
                  end;
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
          ExistingTagSize := GetExistingTagSize(Stream);
          // jump to the end of this tag
          Stream.Seek(ExistingTagSize, soBeginning);

          // 2019: new decision for CacheAudio:
          // Rewrite the File also when the old existing Tag is WAY BIGGER than the new one
          // - for example after removing a huge CoverArt from the Tag
          CacheAudio :=
              // user wants no padding
              (not FUsePadding) OR
              // ExistingTag too small
              ((ID3v2Stream.Size + 30) >= ExistingTagSize) OR
              // ExistingTag is way too large (max. padding Size: 500k)
              (ExistingTagSize > ID3v2Stream.Size + 512000);

          if CacheAudio then
          begin
              // Existing ID3v2Tag is too small (or too big in case of no padding) for the new one
              // Write Audiodata to temporary file
              TmpName := GetTempFile;
              try
                  TmpStream := TAudioFileStream.Create(TmpName, fmCreate or fmShareDenyWrite);
                  try
                      TmpStream.Seek(0, soBeginning);

                      AudioDataSize := Stream.Size - Stream.Position;
                      if TmpStream.CopyFrom(Stream, Stream.Size - Stream.Position) <> AudioDataSize then
                      begin
                          TmpStream.Free;
                          result := Mp3ERR_Cache;
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
                  finally
                      TmpStream.Free;
                  end;
              except
                  result := Mp3ERR_Cache;
                  // Failure -> Exit, to not damage the file
                  Exit;
              end;
          end;

          // situation here:
          // Old Audiodata is stored in a temporary file "TmpName" (if caching is neccessary)
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
                  fPaddingSize := ExistingTagSize - FDataSize;
                  FTagSize := ExistingTagSize;
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
              TmpStream := TAudioFileStream.Create(TmpName, fmOpenRead);
              try
                TmpStream.Seek(0, soBeginning);
                Stream.CopyFrom(TmpStream, TmpStream.Size);
                SetStreamEnd(Stream);
              finally
                TmpStream.Free;
              end;
            except
              result := FileErr_FileOpenR;
              Exit;
            end;
          end;
          // delete cache
          DeleteFile(PChar(TmpName));
      end;  // if ID3v2Stream.Size > 0;

    finally
      ID3v2Stream.Free;
      // delete cache
      DeleteFile(PChar(FrameName));
    end;
  except
    on EFCreateError do result := FileErr_FileCreate;
    on EWriteError do result := MP3ERR_StreamWrite;
    on E: Exception do
    begin
      result := Mp3ERR_Unclassified;
      MessageBox(0, PChar(E.Message), PChar('Error Error'), MB_OK or MB_ICONERROR or MB_TASKMODAL or MB_SETFOREGROUND);
    end;
  end;
end;

//--------------------------------------------------------------------
// delete tag
//--------------------------------------------------------------------
function TID3v2Tag.RemoveFromStream(Stream: TStream): TAudioError;
var
  TmpStream: TAudioFileStream;
  TmpName: String;
  tmpsize: int64;
  ExistingTagSize: Cardinal;
begin
  result := FileErr_None;
  try
      ExistingTagSize := GetExistingTagSize(Stream);
      if ExistingTagSize = 0 then
        exit; // nothing to do here

      // ...jump to its end...
      Stream.Seek(ExistingTagSize, soBeginning);
      // ...cache Audiodata to temporary file...
      TmpName := GetTempFile;

      TmpStream := TAudioFileStream.Create(TmpName, fmCreate);
      try
          try
              TmpStream.Seek(0, soBeginning);
              tmpsize := Stream.Size - Stream.Position;
              if TmpStream.CopyFrom(Stream, Stream.Size - Stream.Position) <> tmpsize then
              begin
                  result := Mp3ERR_Cache;
                  Exit;
              end;
              // ...cut the stream...
              Stream.Seek(-ExistingTagSize, soEnd);
              SetStreamEnd(Stream);
              // ...and write the audiodata back.
              Stream.Seek(0, soBeginning);
              TmpStream.Seek(0, soBeginning);
              if Stream.CopyFrom(TmpStream, TmpStream.Size) <> TmpStream.Size then
              begin
                  result := Mp3ERR_Cache;
                  Exit;
              end;
          except
              on EWriteError do result := MP3ERR_StreamWrite;
              on E: Exception do
              begin
                  result := Mp3ERR_Unclassified;
                  MessageBox(0, PChar(E.Message), PChar('Error'), MB_OK or MB_ICONERROR or MB_TASKMODAL or MB_SETFOREGROUND);
              end;
          end;
      finally
          // delete tmp-file
          TmpStream.Free;
          DeleteFile(PChar(TmpName));
      end;

  except
      on EFOpenError do result := FileErr_FileCreate;
      on E: Exception do
      begin
          result := Mp3ERR_Unclassified;
          MessageBox(0, PChar(E.Message), PChar('Error'), MB_OK or MB_ICONERROR or MB_TASKMODAL or MB_SETFOREGROUND);
      end;
  end;
end;


//--------------------------------------------------------------------
// read tag from file
//--------------------------------------------------------------------
function TID3v2Tag.ReadFromFile(Filename: UnicodeString): TAudioError;
var Stream: TAudioFileStream;
begin
  if AudioFileExists(Filename) then
    try
      FFilename := Filename;
      Stream := TAudioFileStream.Create(Filename, fmOpenRead or fmShareDenyWrite);
      try
        result := ReadFromStream(Stream);
      finally
        Stream.Free;
      end;
    except
      result := FileErr_FileOpenR;
    end
  else
    result := FileErr_NoFile;
end;

//--------------------------------------------------------------------
// write tag to file
//--------------------------------------------------------------------
function TID3v2Tag.WriteToFile(Filename: UnicodeString): TAudioError;
var Stream: TAudioFileStream;
begin
  if AudioFileExists(Filename) then
    try
      FFilename := Filename;
      if Frames.Count = 0 then
        result := RemoveFromFile(Filename)
      else
      begin
        Stream := TAudioFileStream.Create(Filename, fmOpenReadWrite or fmShareDenyWrite);
        try
          result := WriteToStream(Stream);
        finally
          Stream.Free;
        end;
      end;
    except
      result := FileErr_FileOpenRW;
    end
  else
    result := FileErr_NoFile;
end;

//--------------------------------------------------------------------
// delete tag from file
//--------------------------------------------------------------------
function TID3v2Tag.RemoveFromFile(Filename: UnicodeString): TAudioError;
var Stream: TAudioFileStream;
begin
  if AudioFileExists(Filename) then
    try
      FFilename := Filename;
      Stream := TAudioFileStream.Create(Filename, fmOpenReadWrite or fmShareDenyWrite);
      try
        result := RemoveFromStream(Stream);
      finally
        Stream.Free;
      end;
    except
      result := FileErr_FileOpenRW;
    end
  else
    result := FileErr_NoFile;
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

procedure TID3v2Tag.SetBPM(Value: UnicodeString);
begin
  SetText(IDv2_BPM, Value);
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
function TID3v2Tag.GetBPM: UnicodeString;
begin
  result := GetText(IDv2_BPM);
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
begin
    result := TList.Create;
    GetAllowedTextFrames(result);
end;

function TID3v2Tag.GetAllowedURLFrames: TList;
begin
    result := TList.Create;
    GetAllowedURLFrames(result);
end;

procedure TID3v2Tag.GetAllowedTextFrames(aList: TList);
var i: TFrameIDs;
begin
    for i := IDv2_ARTIST to IDv2_SETSUBTITLE do
      if (GetFrameIDString(i)[1] <> '-') AND (GetFrameIndex(i) = -1) then
        aList.Add(Pointer(i));
end;

procedure TID3v2Tag.GetAllowedURLFrames(aList: TList);
var i: TFrameIDs;
begin
    for i := IDv2_AUDIOFILEURL to IDv2_PAYMENTURL do
      if (GetFrameIDString(i)[1] <> '-') AND (GetFrameIndex(i) = -1) then
        aList.Add(Pointer(i));
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


end.
