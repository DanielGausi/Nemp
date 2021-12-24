{

    Unit CoverHelper

    Implements some useful functions dealing with covers.
      - Finding a useful cover for an audiofile
        Used by medialibrary, if id3tag contains no cover
        Idea: Search "around the file" for image-files
              Choose one of the found files, that "looks like a front-cover"
              i.e.: the filename contains "front", "_a", or "folder"

      - Methods for showing a cover, e.g. in the Player, VST, WebServer

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
unit CoverHelper;

interface

uses
  Windows, Messages, SysUtils,  Classes, Graphics,
  Dialogs, StrUtils, ContNrs, Jpeg, PNGImage, math,
  NempAudioFiles, Nemp_ConstantsAndTypes,
  cddaUtils, basscd, oneinst, md5, AudioFiles.Base, AudioFiles.Declarations, AudioFiles.Factory,
  Winapi.Wincodec, Winapi.ActiveX, System.Generics.Defaults, System.Generics.Collections,
  LibraryOrganizer.Base, LibraryOrganizer.Files
  ;

const
    // some Flags for initialising CoverArt
    INIT_COVER_DEFAULT       = 0;
    INIT_COVER_FORCE_RESCAN  = 1;
    INIT_COVER_IGNORE_USERID = 2;

type

    CoverScanThreadMode = (tm_VCL, tm_Thread);

    TNempCover = class
    private
        fTranslateArtist: Boolean;
        fTranslateAlbum: Boolean;

        fArtist    : UnicodeString;
        fAlbum     : UnicodeString;
        fYear      : Integer;
        fGenre     : UnicodeString;
        fDirectory : UnicodeString;
        fFileAge   : TDateTime;

        function fGetInfoString: String;
        function fGetArtist: String;
        function fGetAlbum: String;
        function fCheckInvalidData: Boolean;

    public
      ID: String;
      key: String;    // init: a copy of ID, but ID can be changed without resorting

      property InfoString: String read fGetInfoString;
      property InvalidData: Boolean read fCheckInvalidData;

      property Artist     : UnicodeString  read fGetArtist write fArtist    ;
      property Album      : UnicodeString  read fGetAlbum  write fAlbum     ;
      property Year       : Integer        read fYear      write fYear      ;
      property Genre      : UnicodeString  read fGenre     write fGenre     ;
      property Directory  : UnicodeString  read fDirectory write fDirectory ;
      property FileAge    : TDateTime      read fFileAge   write fFileAge   ;

      constructor create(CompleteLibrary: Boolean=False);
      procedure Assign(aCover: TNempCover);

      // Try to get some "Common Strings" from a list of audioFiles with the same coverfile
      procedure GetCoverInfos(AudioFileList: TAudioFileList);
    end;

    //TNempCoverList = class(TObjectList<TNempCover>);
    //TNempCoverCompare = function(a1,a2: TNempCover): Integer;

    TCoverArtSearcher = class
    private
        class var fUseDir         : LongBool      ;
        class var fUseParentDir   : LongBool      ;
        class var fUseSubDir      : LongBool      ;
        class var fUseSisterDir   : LongBool      ;
        class var fSubDirName     : UnicodeString ;
        class var fSisterDirName  : UnicodeString ;
        class var fSavePath       : UnicodeString ;
        class var fBaseSavePath   : UnicodeString ;
        class var fCoverSize      : Integer       ;
        class var fCoverSizeIndex : Integer       ;


        var fCurrentPath,                      // the last Path a CoverList was created for
            fCurrentCoverName,                 // the last Filename for the Coverart used as "FrontCover"
            fCurrentCoverID:  UnicodeString;   // the last calculated CoverID
        var RandomCoverList: TAudioCollectionList;      // Randomly selected cover. Used for customized painting

        class function fGetUseDir       : LongBool      ; static;
        class function fGetUseParentDir : LongBool      ; static;
        class function fGetUseSubDir    : LongBool      ; static;
        class function fGetUseSisterDir : LongBool      ; static;
        class function fGetSubDirName   : UnicodeString ; static;
        class function fGetSisterDirName: UnicodeString ; static;
        class function fGetSavePath     : UnicodeString ; static;
        class function fGetBaseSavePath : UnicodeString ; static;
        class function fGetSize         : Integer       ; static;
        class function fGetSizeIndex    : Integer       ; static;

        class procedure fSetUseDir       (Value :  LongBool      ); static;
        class procedure fSetUseParentDir (Value :  LongBool      ); static;
        class procedure fSetUseSubDir    (Value :  LongBool      ); static;
        class procedure fSetUseSisterDir (Value :  LongBool      ); static;
        class procedure fSetSubDirName   (Value :  UnicodeString ); static;
        class procedure fSetSisterDirName(Value :  UnicodeString ); static;
        class procedure fSetSavepath     (Value :  UnicodeString ); static;
        class procedure fSetBaseSavepath (Value :  UnicodeString ); static;
        class procedure fSetSize         (Value :  Integer       ); static;
        class procedure fSetSizeindex    (Value :  Integer       ); static;


        // Get the front cover from a list of names of found imagefiles
        function GetFrontCoverIndex(CoverList: TStrings): integer;
        // GetCoverFromList calls GetFrontCoverIndex and load it into the Bitmap
        function GetCoverFromList(aList: TStringList; aCoverbmp: TPicture): boolean;

        // Search image files in pfad and add them to CoverList
        procedure SucheCover(Pfad: UnicodeString; CoverList: TStringList);
        // Search additional files "around the audiofile"
        // These functions will call SucheCover with a new Pfad built from Pfad
        // SubStr is a string that must be contained in the name of the sub/sister-directory
        // (which is one setting for the medialibrary, default is "cover")
        procedure SucheCoverInSubDir(Pfad: UnicodeString; CoverList: TStringList; Substr: UnicodeString);
        procedure SucheCoverInSisterDir(Pfad: UnicodeString; CoverList: TStringList; Substr: UnicodeString);
        procedure SucheCoverInParentDir(Pfad: UnicodeString; CoverList:TStringList);

        // imagefiles in other directories are not determined, if there are to much directories
        // Idea: A few dirs may be "CD1, CD2, Cover" or something like that,
        //       but many directories are probably something else and images in these directories
        //       may have nothing to do with our file here.
        function CountSubDirs(Pfad: UnicodeString):integer;
        function CountSisterDirs(Pfad: UnicodeString):integer;
        function CountFilesInParentDir(Pfad: UnicodeString):integer;

        // Determine whether there exists a directory which matches the setting
        function GetValidSubDir(Pfad: UnicodeString; Substr: UnicodeString): UnicodeString;
        function GetValidSisterDir(Pfad: UnicodeString; Substr: UnicodeString): UnicodeString;

        // Paint a custumized cover "Your Library", using Cover in RandomCoverList
        procedure PaintMainCover(aCoverBmp: TPicture);

        /// Threadsafe resizing of coverart:
        ///  Since Nemp 4.12 the Windows Imaging Component WIC is used
        ///  This uses a IWICImagingFactory, and we need one for each thread
        ///  Creating a new IWICImagingFactory everytime a scaling is needed, would be too much overhead
        ///  Therefore:
        ///       WICImagingFactory_VCL is created, when it is needed, and released at the Library-destructor
        ///       WICImagingFactory_ScanThread is created and released in the context of the ScanThread
        function GetProperImagingFactory(ScanMode: CoverScanThreadMode): IWICImagingFactory;

    public
        class property  UseDir       : LongBool       read fGetUseDir        write fSetUseDir        ;
        class property  UseParentDir : LongBool       read fGetUseParentDir  write fSetUseParentDir  ;
        class property  UseSubDir    : LongBool       read fGetUseSubDir     write fSetUseSubDir     ;
        class property  UseSisterDir : LongBool       read fGetUseSisterDir  write fSetUseSisterDir  ;
        class property  SubDirName   : UnicodeString  read fGetSubDirName    write fSetSubDirName    ;
        class property  SisterDirName: UnicodeString  read fGetSisterDirName write fSetSisterDirName ;
        class property  Savepath     : UnicodeString  read fGetSavepath      write fSetSavepath      ;
        class property  BaseSavepath : UnicodeString  read fGetBaseSavepath  write fSetBaseSavepath      ;
        class property  CoverSize    : Integer        read fGetSize          write fSetSize          ;
        class property  CoverSizeIndex : Integer      read fGetSizeIndex     write fSetSizeIndex     ;


        constructor create;
        destructor Destroy; override;
        procedure Clear;

        // InitCoverArtCache
        // Init the settings for Coverart caching
        // - set the maximum size of the cached cover art (240, 500, 750, 1000)
        // - set the cache directory (\Cover\ + <Size>\)
        class procedure InitCoverArtCache(BaseDir: String; Mode: Integer);

        procedure GetCandidateFilelist(aAudioFile: TAudioFile; aCoverListe: TStringList); // "GetCoverListe"

        procedure StartNewSearch;  // "ReInitCoverSearch"

        ///  The InitCover-methods will create a new image file in \Cover\<md5-Hash>.jpg
        ///  This is later used by the Coverlfow and other displays for the cover art
        ///  Return value: the MD5-Hash (i.e. filename of the resized cover)
        function InitCoverFromFilename(aFileName: UnicodeString; ScanMode: CoverScanThreadMode): String;
        function InitCoverFromMetaData(aAudioFile: TAudioFile; ScanMode: CoverScanThreadMode; Flags: Integer): String;
        procedure InitCover(aAudioFile: TAudioFile; ScanMode: CoverScanThreadMode; Flags: Integer);

        class function GetCover_Fast(aAudioFile: TAudioFile; aCoverbmp: TPicture): boolean; overload;
        class function GetCover_Fast(aCoverID: String; aCoverbmp: TPicture): boolean; overload;
        function GetCover_Complete(aAudioFile: TAudioFile; aCoverbmp: TPicture): boolean;

        // Get the Default-Cover
        // i.e. one of the ugly Nemp-Covers like "no cover", "webradio"
        //      OR the customized cover file from the Medialibrary-settings.
        class procedure GetDefaultCover(aType: TEDefaultCoverType; aCoverPic: TPicture; Flags: Integer);

        // GetCoverBitmapFromID:
        // Get the Bitmap for a specified Cover-ID
        function GetCoverBitmapFromID(aCoverID: String; aCoverBmp: TPicture): Boolean;
        function GetCoverBitmapFromCollection(aCollection: TAudioCollection; aCoverBmp: TPicture): Boolean;

        // Randomly select some covers from the list and store it in the RandomCoverList
        procedure PrepareMainCover(aCategory: TLibraryCategory);

        // Paint a customized cover "Your Library", but using only ColorIDs for the picking algorithm
        procedure PaintMainPickCover(aCoverBmp: TBitmap; aRootCollection: TRootCollection);

        // Save a Graphic in a resized file. Used for all the little md5-named jpgs
        // in <NempDir>\Cover
        class function ScalePicStreamToFile_DefaultSize(aStream: TStream; aID: UnicodeString; aWICImagingFactory: IWICImagingFactory; OverWrite: Boolean = False): boolean;
        class function ScalePicStreamToFile_AllSizes(aStream: TStream; aID: UnicodeString; aWICImagingFactory: IWICImagingFactory; OverWrite: Boolean = False): boolean;

        class function ScalePicStreamToFile(aStream: TStream; aID: UnicodeString; destSize: Integer; destDir: String; aWICImagingFactory: IWICImagingFactory; OverWrite: Boolean = False): boolean;

    end;



    var
        WICImagingFactory_VCL: IWICImagingFactory;
        WICImagingFactory_ScanThread: IWICImagingFactory;


  // Converts data from a (id3tag)-picture-stream to a Bitmap.
  function PicStreamToBitmap(aStream: TStream; Mime: AnsiString; aBmp: TBitmap): Boolean;

  // Draw a Picture on a Bitmap
  procedure AssignBitmap(Bitmap: TBitmap; const Picture: TPicture);

  // Draw a Graphic on a bounded Bitmap (stretch, proportional)
  procedure FitBitmapIn(Bounds: TBitmap; Source: TGraphic);
  procedure FitPictureIn(Bounds: TPicture; Source: TGraphic);
  procedure FitWICImageIn(aWICImage: TWICImage; aWidth, aHeight:Integer);

  // returns true, iff a preview-graphic for this ID should be already stored in the Cover-Save-Directory
  function PreviewGraphicShouldExist(aCoverID: String): Boolean;

  // If a preview-graphic could not be found (but should exist), we want to recreate it.
  // This method is quite often called when changing the cover size for the first time
  // Note: So far, this will overwrite a manually set cover for the library :(
  //       Possible fix for that: when creating user-defined cover art: Create thumbnails for all sizes at once
  function RepairCoverFileVCL(oldID: string; aAudioFile: TAudioFile; aPic: TPicture; out newID: String): Boolean;


implementation

uses NempMainUnit, StringHelper, AudioFileHelper, GnuGetText, Nemp_RessourceStrings;
// NempMainUnitm is used, as some settings from the MediaLibrary are used here.

var
    CSAccessRandomCoverlist: RTL_CRITICAL_SECTION;
    CSAccessCoverSearcherProperties: RTL_CRITICAL_SECTION;

// another function used just here.
function IsImageExt(aExt: String): boolean;
begin
    aExt := AnsiLowerCase(aExt);
    result := (aExt = '.jpg')
           OR (aExt = '.jpeg')
           OR (aExt = '.png')
           OR (aExt = '.bmp')
           OR (aExt = '.gif')
           OR (aExt = '.jfif');
end;

{ TNempCover }

procedure TNempCover.Assign(aCover: TNempCover);
begin
    fTranslateArtist := aCover.fTranslateArtist;
    fTranslateAlbum  := aCover.fTranslateAlbum ;

    ID        := aCover.ID         ;
    key       := aCover.key        ;
    fArtist   := aCover.fArtist    ;
    fAlbum    := aCover.fAlbum     ;
    fYear     := aCover.fYear      ;
    fGenre    := aCover.fGenre     ;
    fDirectory:= aCover.fDirectory ;
    fFileAge  := aCover.fFileAge   ;
end;

constructor TNempCover.create(CompleteLibrary: Boolean=False);
begin
    fTranslateArtist := CompleteLibrary;
    fTranslateAlbum  := CompleteLibrary;
end;

function TNempCover.fCheckInvalidData: Boolean;
begin
    result := (fArtist = AUDIOFILE_UNKOWN) and (fAlbum = AUDIOFILE_UNKOWN);
end;

function TNempCover.fGetAlbum: String;
begin
    if fTranslateAlbum then
        result := _(fAlbum)
    else
        result := fAlbum;
end;

function TNempCover.fGetArtist: String;
begin
    if fTranslateArtist then
        result := _(fArtist)
    else
        result := fArtist;
end;


function TNempCover.fGetInfoString: String;
begin
    if self.ID = 'all' then
        result := _(CoverFlowText_VariousArtists) + ' - ' + _(CoverFlowText_WholeLibrary)
    else
    begin
        if (self.Year >= 1000) and (year <= 2500) then
            // note: NOT fArtist and fAlbum!
            result := Artist  + ' - ' + Album + ' (' + IntToStr(fYear) + ')'
        else
            result := Artist  + ' - ' + Album
    end;
end;

procedure TNempCover.GetCoverInfos(AudioFileList: TAudioFileList);
var str1: UnicodeString;
    maxidx, i, fehlstelle: Integer;
    aStringlist: TStringList;
    newestAge, currentAge: TDateTime;
begin

  if ID = '' then
  begin
      fArtist := CoverFlowText_VariousArtists; //'Various artists';
      fAlbum := CoverFlowText_UnkownCompilation; // 'Unknown';
      fYear := 0;
      fGenre := 'Other';
      fDirectory := ' ';
      fFileAge := 0;
      exit;
  end;

  if AudioFileList.Count <= 25 then maxIdx := AudioFileList.Count-1 else maxIdx := 25;

  aStringlist := TStringList.Create;
  for i := 0 to maxIdx do
      if (AudioFileList[i].Artist <> '') then
          aStringlist.Add(AudioFileList[i].Artist);

  fehlstelle := 0;
  str1 := GetCommonString(aStringlist, 0, fehlstelle);  // bei Test auf "String gleich?" keinen Fehler zulassen
  if str1 = '' then
  begin
      fArtist := CoverFlowText_VariousArtists; // 'Various artists';
      fTranslateArtist := True;
  end
  else
  begin
      fArtist := str1; // Fehlstelle ist irrelevant
      fTranslateArtist := False;
  end;


  aStringlist.Clear;
  // Dasselbe jetzt mit Album, aber mit Toleranz 1 bei den Strings
  for i := 0 to maxIdx do
      if (AudioFileList[i].Album <> '') then
          aStringlist.Add(AudioFileList[i].Album);

  fehlstelle := 0;
  str1 := GetCommonString(aStringlist, 1, fehlstelle);  // bei Test auf "String gleich?" einen Fehler zulassen  (cd1/2...)
  if str1 = '' then
  begin
      fAlbum := CoverFlowText_UnkownCompilation; // 'Unknown compilation';
      fTranslateAlbum := True;
  end
  else
  begin
      fTranslateAlbum := False;
      if fehlstelle <= length(str1) Div 2 +1 then
          fAlbum := str1
      else
          fAlbum := copy(str1, 1, fehlstelle-1) + ' ... ';
  end;

  aStringlist.Clear;
  // Dasselbe jetzt mit Genre
  for i := 0 to maxIdx do
      aStringlist.Add(AudioFileList[i].Genre);
  fehlstelle := 0;
  str1 := GetCommonString(aStringlist, 1, fehlstelle);  // bei Test auf "String gleich?" einen Fehler zulassen  (cd1/2...)
  if str1 = '' then
      fGenre := 'Other'
  else
      fGenre := str1;

  if AudioFileList.Count = 0 then
  begin
      fYear := 0;
      fDirectory := ' ';
  end else
  begin
      AudioFileList.Sort(Sort_Jahr_asc);
      fYear := StrToIntDef(AudioFileList[AudioFileList.Count Div 2].Year, 0);
      fDirectory := IncludeTrailingPathDelimiter(AudioFileList[0].Ordner);
  end;

  newestAge := 0;
  for i := 0 to AudioFileList.Count - 1 do
  begin
      currentAge := AudioFileList[i].FileAge;
      if currentAge > newestAge then
          newestAge := currentAge;
  end;
  fFileAge := newestAge;

  aStringlist.Free;
end;



function PicStreamToBitmap(aStream: TStream; Mime: AnsiString; aBmp: TBitmap): Boolean;
var jp: TJPEGImage;
    png: TPNGImage;
begin
    result := True;
    if (mime = 'image/jpeg') or (mime = 'image/jpg') or (AnsiUpperCase(String(Mime)) = 'JPG') then
    try
        aStream.Seek(0, soFromBeginning);
        jp := TJPEGImage.Create;
        try
          try
            jp.LoadFromStream(aStream);
            jp.DIBNeeded;
            aBmp.Assign(jp);
          except
            result := False;
            aBmp.Assign(NIL);
          end;
        finally
          jp.Free;
        end;
    except
        result := False;
        aBmp.Assign(NIL);
    end else
        if (mime = 'image/png') or (Uppercase(String(Mime)) = 'PNG') then
        try
            aStream.Seek(0, soFromBeginning);
            png := TPNGImage.Create;
            try
              try
                png.LoadFromStream(aStream);
                aBmp.Assign(png);
              except
                result := False;
                aBmp.Assign(NIL);
              end;
            finally
              png.Free;
            end;
        except
            result := False;
            aBmp.Assign(NIL);
        end else
        if (mime = 'image/bmp') or (Uppercase(String(Mime)) = 'BMP') then
            try
                aStream.Seek(0, soFromBeginning);
                aBmp.LoadFromStream(aStream);
            except
                result := False;
                aBmp.Assign(Nil);
            end else
                begin
                    aBmp.Assign(NIL);
                end;
end;


procedure AssignBitmap(Bitmap: TBitmap; const Picture: TPicture);
begin
    Bitmap.PixelFormat := pf24bit;
    Bitmap.Height := 0;
    Bitmap.Width := 0;
    Bitmap.Canvas.Brush.Style := bsClear;
    Bitmap.Height := Picture.Height;
    Bitmap.Width := Picture.Width;
    //Bitmap.Canvas.FillRect(Rect(0, 0, Bitmap.Width, Bitmap.Height));
    Bitmap.Canvas.Draw(0, 0, Picture.Graphic);
    Bitmap.PixelFormat := pf24bit;
end;



procedure FitPictureIn(Bounds: TPicture; Source: TGraphic);
var BoundBitmap: TBitmap;
begin
    BoundBitmap := TBitmap.Create;
    try
        BoundBitmap.Width  := Bounds.Width;
        BoundBitmap.Height := Bounds.Height;
        FitBitmapIn(BoundBitmap, Source);
        Bounds.Assign(BoundBitmap);
    finally
        BoundBitmap.Free;
    end;
end;


procedure FitBitmapIn(Bounds: TBitmap; Source: TGraphic);
var xfactor, yfactor:double;
    tmpBmp: TBitmap;
begin
    if Source = NIL then
        exit;
    if (Source.Width = 0) or (Source.Height=0) then
        exit;

    xfactor:= (Bounds.Width) / Source.Width;
    yfactor:= (Bounds.Height) / Source.Height;
    if xfactor > yfactor then
    begin
        Bounds.Width := round(Source.Width*yfactor);
        Bounds.Height := round(Source.Height*yfactor);
    end else
    begin
        Bounds.Width := round(Source.Width*xfactor);
        Bounds.Height := round(Source.Height*xfactor);
    end;

    // fix zero-sized images
    if Bounds.Width = 0 then Bounds.Width := 1;
    if Bounds.Height = 0 then Bounds.Height := 1;

    tmpbmp := tBitmap.Create;
    try
        tmpBmp.Assign(Source);
        SetStretchBltMode(Bounds.Canvas.Handle, HALFTONE);
        StretchBlt(Bounds.Canvas.Handle,
                  0,0, Bounds.Width, Bounds.Height,
                  tmpbmp.Canvas.Handle,
                  0, 0, tmpBmp.Width, tmpBmp.Height, SRCCopy);
    finally
        tmpbmp.Free
    end;
end;


// WIC-principle from https://www.delphipraxis.net/1291613-post31.html
procedure FitWICImageIn(aWICImage: TWICImage; aWidth, aHeight:Integer);
var scale: IWICBitmapScaler;
    wicBitmap: IWICBitmap;
    newHeight, newWidth:Integer;
    xfactor, yfactor:double;
begin
    if not Assigned(aWICImage) then
        exit;

    xfactor:= (aWidth) / aWICImage.Width;
    yfactor:= (aHeight) / aWICImage.Height;
    if xfactor > yfactor then
    begin
        newWidth := round(aWICImage.Width*yfactor);
        newHeight := round(aWICImage.Height*yfactor);
    end else
    begin
        newWidth := round(aWICImage.Width*xfactor);
        newHeight := round(aWICImage.Height*xfactor);
    end;

    // fix zero-sized images
    if newWidth = 0 then newWidth := 1;
    if newHeight = 0 then newHeight := 1;

    aWICImage.ImagingFactory.CreateBitmapScaler(scale);
    scale.Initialize(aWICImage.Handle, NewWidth, NewHeight, WICBitmapInterpolationModeFant);
    aWICImage.ImagingFactory.CreateBitmapFromSourceRect(scale, 0, 0, NewWidth, NewHeight, wicBitmap);
    if Assigned(wicBitmap) then
        aWICImage.Handle := wicBitmap;
end;



function PreviewGraphicShouldExist(aCoverID: String): Boolean;
begin
    // we use a "_" at the beginning of a cover ID to indicate a "missing cover",
    // i.e. no cover art have been found so far
    result := (Length(aCoverID) > 1) and (aCoverID[1] <> '_');
end;

function RepairCoverFileVCL(oldID: string; aAudioFile: TAudioFile; aPic: TPicture; out newID: String): Boolean;
var
  lCoverArtSearcher: TCoverArtSearcher;
begin
  result := false;
  newID := oldID;

  if MedienBib.StatusBibUpdate >= 2 then
    exit;

  if not assigned(aAudioFile) then
    aAudioFile := MedienBib.GetAudioFileWithCoverID(oldID);

  if not assigned(aAudioFile) then
    exit;

  lCoverArtSearcher := TCoverArtSearcher.create;
  try
    lCoverArtSearcher.InitCover(aAudioFile, tm_VCL, INIT_COVER_FORCE_RESCAN);
    if assigned(aPic) then
      result := lCoverArtSearcher.GetCoverBitmapFromID(aAudioFile.CoverID, aPic)
    else
      result := True; // check for success will be done otherwise after this method

     // das true versaut es ggf. zumindest dann, wenn oben newID auf '' gesetzt wurde


    // if we found an image, but the ID has changed: Change it on the other files with that ID as well
    if (aAudioFile.CoverID <> oldID) then
    begin
        if aAudioFile.CoverID = '' then
          aAudioFile.CoverID := 'kaputt repaired';
        MedienBib.ChangeCoverID(oldID, aAudioFile.CoverID);
        if  MedienBib.NewCoverFlow.CurrentCoverID = oldID then
            MedienBib.NewCoverFlow.CurrentCoverID := aAudioFile.CoverID;
        newID := aAudioFile.CoverID;
    end;

  finally
    lCoverArtSearcher.Free;
  end;
end;


{ TCoverArtSearcher }

constructor TCoverArtSearcher.create;
begin
    RandomCoverList := TAudioCollectionList.Create(False);
end;

destructor TCoverArtSearcher.Destroy;
begin
  RandomCoverList.Free;
  inherited;
end;


class function TCoverArtSearcher.fGetSavePath: UnicodeString;
begin
    EnterCriticalSection(CSAccessCoverSearcherProperties);
    result := fSavePath;
    LeaveCriticalSection(CSAccessCoverSearcherProperties);
end;

class function TCoverArtSearcher.fGetBaseSavePath: UnicodeString ;
begin
    EnterCriticalSection(CSAccessCoverSearcherProperties);
    result := fBaseSavePath;
    LeaveCriticalSection(CSAccessCoverSearcherProperties);
end;

class function TCoverArtSearcher.fGetSisterDirName: UnicodeString;
begin
    EnterCriticalSection(CSAccessCoverSearcherProperties);
    result := fSisterDirName;
    LeaveCriticalSection(CSAccessCoverSearcherProperties);
end;

class function TCoverArtSearcher.fGetSize: Integer;
begin
    InterLockedExchange(Result, fCoverSize);
end;

class function TCoverArtSearcher.fGetSizeIndex: Integer;
begin
    InterLockedExchange(Result, fCoverSizeIndex);
end;

class function TCoverArtSearcher.fGetSubDirName: UnicodeString;
begin
    EnterCriticalSection(CSAccessCoverSearcherProperties);
    result := fSubDirName;
    LeaveCriticalSection(CSAccessCoverSearcherProperties);
end;

class function TCoverArtSearcher.fGetUseDir: LongBool;
begin
    InterLockedExchange(Integer(Result), Integer(fUseDir));
end;

class function TCoverArtSearcher.fGetUseParentDir: LongBool;
begin
    InterLockedExchange(Integer(Result), Integer(fUseParentDir));
end;

class function TCoverArtSearcher.fGetUseSisterDir: LongBool;
begin
    InterLockedExchange(Integer(Result), Integer(fUseSisterDir));
end;

class function TCoverArtSearcher.fGetUseSubDir: LongBool;
begin
    InterLockedExchange(Integer(Result), Integer(fUseSubDir));
end;

class procedure TCoverArtSearcher.fSetSavepath(Value: UnicodeString);
begin
    EnterCriticalSection(CSAccessCoverSearcherProperties);
    fSavePath := Value;
    LeaveCriticalSection(CSAccessCoverSearcherProperties);
end;

class procedure TCoverArtSearcher.fSetBaseSavepath(Value: UnicodeString);
begin
    EnterCriticalSection(CSAccessCoverSearcherProperties);
    fBaseSavePath := Value;
    LeaveCriticalSection(CSAccessCoverSearcherProperties);
end;


class procedure TCoverArtSearcher.fSetSisterDirName(Value: UnicodeString);
begin
    EnterCriticalSection(CSAccessCoverSearcherProperties);
    fSisterDirName := Value;
    LeaveCriticalSection(CSAccessCoverSearcherProperties);
end;

class procedure TCoverArtSearcher.fSetSize(Value: Integer);
begin
    InterLockedExchange(fCoverSize, Value);
end;

class procedure TCoverArtSearcher.fSetSizeindex(Value: Integer);
begin
    InterLockedExchange(fCoverSizeIndex, Value);
end;

class procedure TCoverArtSearcher.fSetSubDirName(Value: UnicodeString);
begin
    EnterCriticalSection(CSAccessCoverSearcherProperties);
    fSubDirName := Value;
    LeaveCriticalSection(CSAccessCoverSearcherProperties);
end;

class procedure TCoverArtSearcher.fSetUseDir(Value: LongBool);
begin
    InterLockedExchange(Integer(fUseDir), Integer(Value));
end;

class procedure TCoverArtSearcher.fSetUseParentDir(Value: LongBool);
begin
    InterLockedExchange(Integer(fUseParentDir), Integer(Value));
end;

class procedure TCoverArtSearcher.fSetUseSisterDir(Value: LongBool);
begin
    InterLockedExchange(Integer(fUseSisterDir), Integer(Value));
end;

class procedure TCoverArtSearcher.fSetUseSubDir(Value: LongBool);
begin
    InterLockedExchange(Integer(fUseSubDir), Integer(Value));
end;

procedure TCoverArtSearcher.GetCandidateFilelist(aAudioFile: TAudioFile;
  aCoverListe: TStringList);
begin
    aCoverListe.Clear;
    if DirectoryExists(aAudioFile.Ordner) then
    begin
        if UseDir then
            SucheCover(aAudioFile.Ordner, aCoverListe);

        if (aCoverListe.Count = 0) and UseParentDir and (CountFilesInParentDir(aAudioFile.Ordner) <= 5) then
            SucheCoverInParentDir(aAudioFile.Ordner, aCoverListe);

        if (aCoverListe.Count = 0) and UseSubDir and (CountSubDirs(aAudioFile.Ordner) <= 5) then
            SucheCoverInSubDir(aAudioFile.Ordner, aCoverListe, SubDirName);

        if (aCoverListe.Count = 0) and UseSisterDir and (CountSisterDirs(aAudioFile.Ordner) <= 5) then
            SucheCoverInSisterDir(aAudioFile.Ordner, aCoverListe, SisterDirName);
    end;
end;

procedure TCoverArtSearcher.StartNewSearch;
begin
    fCurrentPath      := '';
    fCurrentCoverName := '';
    fCurrentCoverID   := '';
end;

class procedure TCoverArtSearcher.InitCoverArtCache(BaseDir: String; Mode: Integer);
begin
    EnterCriticalSection(CSAccessCoverSearcherProperties);

    fBaseSavePath := IncludeTrailingPathDelimiter(BaseDir) + 'Cover\';
    // Set the proper SubDirectory for CoverArt
    case Mode of
        0: fSavePath := IncludeTrailingPathDelimiter(BaseDir) + 'Cover\';
        1: fSavePath := IncludeTrailingPathDelimiter(BaseDir) + 'Cover\M\';
        2: fSavePath := IncludeTrailingPathDelimiter(BaseDir) + 'Cover\L\';
        3: fSavePath := IncludeTrailingPathDelimiter(BaseDir) + 'Cover\XL\';
    else
        fSavePath := IncludeTrailingPathDelimiter(BaseDir) + 'Cover\';
    end;

    case Mode of
        0: CoverSize := 240;
        1: CoverSize := 500;
        2: CoverSize := 750;
        3: CoverSize := 1000;
    else
        CoverSize := 500;
    end;

    // Try to create the Directory
    try
        ForceDirectories(fSavePath);
    except
        if not DirectoryExists(fSavePath) then
            fSavePath := IncludeTrailingPathDelimiter(BaseDir);
    end;

    LeaveCriticalSection(CSAccessCoverSearcherProperties);
end;

procedure TCoverArtSearcher.InitCover(aAudioFile: TAudioFile;
  ScanMode: CoverScanThreadMode; Flags: Integer);
var CoverListe: TStringList;
    NewCoverName: String;
    ForceReScan: Boolean;
begin
  try
      ForceReScan       := (Flags and INIT_COVER_FORCE_RESCAN) = INIT_COVER_FORCE_RESCAN   ;
      // IgnoreUserCoverID := (Flags and INIT_COVER_IGNORE_USERID) = INIT_COVER_IGNORE_USERID ;

      aAudioFile.CoverID := ''; // new WIC : RESET the ID
      if InitCoverFromMetaData(aAudioFile, ScanMode, Flags) <> '' then
      begin
          // Cover in Metadata found and successfully saved to <ID>.jpg
          fCurrentCoverID := aAudioFile.CoverID;
          fCurrentPath := '';
          fCurrentCoverName := '';
      end else // AudioFile.GetAudioData hat kein Cover im ID3Tag gefunden. Also: In Dateien drumherum suchen
      begin
            // Wenn Da kein Erfolg: Cover-Datei suchen.
            // Aber nur, wenn man jetzt in einem Anderen Ordner ist.
            // Denn sonst würde die Suche ja dasselbe Ergebnis liefern
            if (fCurrentPath <> aAudioFile.Ordner) or (ForceReScan) then
            begin
                fCurrentPath := aAudioFile.Ordner;

                Coverliste := TStringList.Create;
                GetCandidateFilelist(aAudioFile, coverliste);
                if Coverliste.Count > 0 then
                begin
                    NewCoverName := coverliste[GetFrontCoverIndex(CoverListe)];
                    if  (NewCovername <> fCurrentCoverName) or (ForceReScan) then
                    begin
                        aAudioFile.CoverID := InitCoverFromFilename(NewCovername, ScanMode);
                        if aAudioFile.CoverID = '' then
                        begin
                            // Something was wrong with the Coverfile (see comments in InitCoverFromFilename)
                            // possible solution: Try the next coverfile.
                            // Easier: Just use "Default-Cover" and md5(AudioFile.Ordner) as Cover-ID
                            NewCoverName := '';
                            aAudioFile.CoverID := '__'+ MD5DigestToStr(MD5UnicodeString(aAudioFile.Ordner));
                        end;
                        fCurrentCoverID := aAudioFile.CoverID;
                        fCurrentCoverName := NewCovername;
                    end
                    else
                        aAudioFile.CoverID := fCurrentCoverID;
                end else
                begin
                    // Kein Cover gefunden
                    fCurrentCoverName := '';
                    fCurrentCoverID := '__'+ MD5DigestToStr(MD5UnicodeString(aAudioFile.Ordner));
                    aAudioFile.CoverID := fCurrentCoverID;
                end;
                coverliste.free;
            end else
            begin
                // Datei ist im selben Ordner wie die letzte Datei, also auch dasselbe Cover.
                aAudioFile.CoverID := fCurrentCoverID;
            end;
      end;
  except
    if assigned(aAudioFile) then aAudioFile.CoverID := '';
     fCurrentCoverID := '';
     fCurrentPath := '';
     fCurrentCoverName := '';
  end;
end;


function TCoverArtSearcher.InitCoverFromMetaData(aAudioFile: tAudioFile;
  ScanMode: CoverScanThreadMode; Flags: Integer): String;
var CoverStream: TMemoryStream;
    newID: String;
    MainFile: TBaseAudioFile;

begin
    result := '';
    aAudioFile.CoverID := '';
    CoverStream := TMemoryStream.Create;
    try
        MainFile := AudioFileFactory.CreateAudioFile(aAudioFile.Pfad);
        if assigned(MainFile) then
        begin
            try
                MainFile.ReadFromFile(aAudioFile.Pfad);
                // first: Check for a User-CoverID
                // this can happen, if the user refreshes the medialibrar and has set a specials CoverID through the Detail-Window
                // (possible since Nemp 4.13)
                if ( Flags and INIT_COVER_IGNORE_USERID) = 0 then
                    newID := aAudioFile.GetUserCoverIDFromMetaData(MainFile);

                if  (newID <> '') and FileExists(SavePath + newID + '.jpg') then
                begin
                    aAudioFile.CoverID := newID;
                    result := newID;
                end else
                begin
                    ///  However, if the "UserID.jpg" does not exist (or, more probably, the UserCover is not set),
                    ///  we need to check for regular CoverArt information in the MetaData
                    if aAudioFile.GetCoverStreamFromMetaData(CoverStream, MainFile) then
                    begin
                        // there is a Picture-Tag in the Metadata, and its content is now stored in Coverstream
                        CoverStream.Seek(0, soFromBeginning);
                        // compute a new ID from the stream data
                        newID := MD5DigestToStr(MD5Stream(CoverStream));
                        // try to save a resized JPG from the content of the stream
                        // if this fails, there was something wrong with the image data :(
                        if ScalePicStreamToFile_DefaultSize(CoverStream, newID, GetProperImagingFactory(ScanMode)) then
                        begin
                            aAudioFile.CoverID := newID;
                            result := newID;
                        end;
                    end;
                end;
            finally
                MainFile.Free;
            end;
        end;

    finally
        CoverStream.Free;
    end;
end;

function TCoverArtSearcher.InitCoverFromFilename(aFileName: UnicodeString;
  ScanMode: CoverScanThreadMode): String;
var newID: String;
    fs: TFileStream;
begin
    try
        newID := MD5DigestToStr(MD5File(aFileName));
    except
        newID := ''
    end;

    if newID = '' then
    begin
        // somethin was wrong with opening the file ...
        // I've got sometimes Exceptions "cannot access file..." with fresh downloaded files from LastFM
        // maybe conflicts with an antivirus-scanner??
        // so, try again.
        sleep(100);
        try
            newID := MD5DigestToStr(MD5File(aFileName));
        except
            newID := ''
        end;
    end;

    result := '';
    if newID <> '' then
    begin
        fs := TFileStream.Create(aFileName, fmOpenRead);
        try
            if ScalePicStreamToFile_DefaultSize(fs, newID, GetProperImagingFactory(ScanMode)) then
                result := newID
        finally
            fs.Free;
        end;
    end;
end;

function TCoverArtSearcher.GetFrontCoverIndex(CoverList:TStrings):integer;
var i:integer;
begin
  result := -1;

  for i:=0 to CoverList.Count-1 do
    if AnsiContainsText(CoverList[i],'front') then
    begin
      result := i;
      break;
    end;

  if result = -1 then
    for i:=0 to CoverList.Count-1 do
      if AnsiContainsText(CoverList[i],'_a') then
      begin
        result := i;
        break;
      end;

  if result = -1 then
  begin
    result := 0;
    for i:=0 to CoverList.Count-1 do
      if AnsiContainsText(CoverList[i],'folder') then
      begin
        result := i;
        break;
      end;
  end;
end;

function TCoverArtSearcher.GetCoverFromList(aList: TStringList; aCoverbmp: TPicture): Boolean;
var FrontCover:integer;
    aGraphic: TPicture;
begin
      result := False;
      if aList.Count = 0 then
          Exit;
      FrontCover := GetFrontCoverIndex(aList);
      aGraphic := TPicture.Create;
      try
          aGraphic.LoadFromFile(aList[FrontCover]);
          if (aCoverbmp.Width > 0) and (aCoverBmp.Height > 0) then
              FitPictureIn(aCoverbmp, aGraphic.Graphic)
          else
              //AssignBitmap(aCoverBmp, aGraphic);
              aCoverbmp.Assign(aGraphic);
          result := True;
      finally
          aGraphic.Free;
      end;
end;


Procedure TCoverArtSearcher.SucheCover(pfad: UnicodeString; CoverList:TStringList);
var sr : TSearchrec;
    dateityp:string;
begin
    pfad := IncludeTrailingPathDelimiter(pfad);

    if Findfirst(pfad+'*',FaAnyfile,sr) = 0 then
    repeat
      if (sr.name<>'.') AND (sr.name<>'..') then
      begin
          dateityp := ExtractFileExt(sr.Name);
          if IsImageExt(dateityp) then
              CoverList.Add(pfad + sr.Name);
      end;
    until Findnext(sr)<>0;
    Findclose(sr);
end;

procedure TCoverArtSearcher.SucheCoverInSubDir(Pfad: UnicodeString; CoverList:TStringList; Substr: UnicodeString);
var sdir: UnicodeString;
begin
    sdir := GetValidSubDir(Pfad, Substr);
    if sdir <> Pfad then
      SucheCover(sdir, CoverList);
end;

procedure TCoverArtSearcher.SucheCoverInSisterDir(Pfad: UnicodeString; CoverList: TStringList; Substr: UnicodeString);
var sdir: UnicodeString;
begin
    sdir := GetValidSisterDir(Pfad,Substr);
    if sdir <> Pfad then
      SucheCover(sdir, CoverList);
end;

procedure TCoverArtSearcher.SucheCoverInParentDir(Pfad: UnicodeString; CoverList: TStringList);
begin
  pfad := ExcludeTrailingPathDelimiter(pfad);
  pfad := Copy(pfad,1,LastDelimiter('\',Pfad));
  SucheCover(pfad, CoverList);
end;

function TCoverArtSearcher.CountSubDirs(Pfad: UnicodeString):integer;
var sr: TsearchRec;
begin
  result := 0;
  if AnsiEndsStr('\', pfad) then
      pfad:=Copy(Pfad,1,length(pfad)-1);
  if (findfirst(pfad+'\*',FaDirectory,sr)=0) then
      repeat
        if (sr.name<>'.') AND (sr.name<>'..')
            AND ((sr.Attr AND faDirectory)=faDirectory) then
          result := result + 1;
      until (Findnext(sr)<>0) OR (result > 6) ;
    findclose(sr);
end;


function TCoverArtSearcher.CountSisterDirs(Pfad: UnicodeString):integer;
begin
  pfad := ExcludeTrailingPathDelimiter(pfad);
 // ...und den Parentordner bestimmen
  Pfad := Copy(Pfad,1, LastDelimiter('\',Pfad));
  result := CountSubDirs(Pfad);
end;

function TCoverArtSearcher.CountFilesInParentDir(Pfad: UnicodeString):integer;
var sr: TsearchRec;
begin
  result := 0;
  pfad := ExcludeTrailingPathDelimiter(pfad);
  pfad := Copy(pfad,1, LastDelimiter('\',Pfad));

  if (Findfirst(pfad+'\*',FaAnyfile,sr)=0) then
      repeat
        if (sr.name<>'.') AND (sr.name<>'..')
            And (Not IsImageExt(ExtractFileExt(sr.Name)))
        then
          result := result + 1;
      until (Findnext(sr)<>0) OR (result > 6) ;
    Findclose(sr);
end;

function TCoverArtSearcher.GetValidSubDir(Pfad: UnicodeString; Substr: UnicodeString): UnicodeString;
var sr: TsearchRec;
  abbruch:boolean;
begin
  result := pfad;
  pfad := IncludeTrailingPathDelimiter(pfad);
  abbruch := false;
  if (findfirst(pfad+'*',FaDirectory,sr)=0) then
  repeat
    if (sr.name<>'.') AND (sr.name<>'..')
      AND ((sr.Attr AND faDirectory)=faDirectory)
      AND (AnsiContainsText(sr.name, Substr))
      then
      begin
        result := pfad + sr.Name;
        abbruch := True;
      end;
  until (abbruch) or (Findnext(sr)<>0) ;
  findclose(sr);
end;

function TCoverArtSearcher.GetValidSisterDir(Pfad: UnicodeString; Substr: UnicodeString): UnicodeString;
var sr: TsearchRec;
  abbruch:boolean;
  pfadOrig: UnicodeString;
begin
  pfad := ExcludeTrailingPathDelimiter(pfad);
  pfadOrig := pfad;
  pfad := Copy(pfad,1,LastDelimiter('\',Pfad));
  result := PfadOrig;
  abbruch := false;

  if (Findfirst(pfad+'\*',FaDirectory,sr)=0) then
  repeat
    if (sr.name<>'.') AND (sr.name<>'..')
      AND ((sr.Attr AND faDirectory)=faDirectory)
      AND ((pfad + '\' + sr.Name) <> pfadOrig)
      AND (AnsiContainsText(sr.name, Substr))
      then
      begin
        result := pfad + '\' + sr.Name;
        abbruch := True;
      end;
  until (abbruch) or (Findnext(sr)<>0) ;
  Findclose(sr);
end;

function TCoverArtSearcher.GetCover_Complete(aAudioFile: TAudioFile;
  aCoverbmp: TPicture): boolean;
var coverliste: TStringList;
begin
    if (aAudioFile.AudioType <> at_File)
    OR
       ( (aAudioFile.AudioType <> at_File)
         AND (aAudioFile.CoverID <> '')
         And FileExists(TCoverArtSearcher.Savepath + aAudioFile.CoverID + '.jpg')
        )
    then
        result := GetCover_Fast(aAudioFile, aCoverbmp)
    else
    begin
        if aAudioFile.GetCoverFromMetaData(aCoverbmp.Bitmap, true) then
        begin
            result := True;
        end
        else
        begin
            coverliste := TStringList.Create;
            GetCandidateFilelist(aAudioFile,coverliste);
            try
                if Not GetCoverFromList(CoverListe, aCoverbmp) then
                begin
                    GetDefaultCover(dcFile, aCoverbmp, 0);
                    result := False;
                end else
                    result := True;
            except
                GetDefaultCover(dcFile, aCoverbmp, 0);
                result := false;
            end;
            coverliste.free;
        end;

    end;
end;

class function TCoverArtSearcher.GetCover_Fast(aAudioFile: TAudioFile;
  aCoverbmp: TPicture): boolean;
var aGraphic: TPicture;
    baseName, completeName: String;
begin
  result := false;
  try
      case aAudioFile.AudioType of
          at_Stream: begin
              TCoverArtSearcher.GetDefaultCover(dcWebRadio, aCoverbmp, 0);
              result := True;
          end;
          at_File: begin
              if (aAudioFile.CoverID <> '') And FileExists(TCoverArtSearcher.Savepath + aAudioFile.CoverID + '.jpg') then
              begin
                  aGraphic := TPicture.Create;
                  try
                      aGraphic.LoadFromFile(TCoverArtSearcher.Savepath + aAudioFile.CoverID + '.jpg');

                      if (aCoverbmp.Width > 0) and (aCoverBmp.Height > 0) then
                          FitPictureIn(aCoverbmp, aGraphic.Graphic)
                      else
                          //AssignBitmap(aCoverBmp, aGraphic);
                          aCoverbmp.Assign(aGraphic);
                      result := True;
                  finally
                      aGraphic.Free;
                  end;
              end else
              begin
                  TCoverArtSearcher.GetDefaultCover(dcFile, aCoverbmp, 0);
                  result := False;
              end;
          end;
          at_CDDA: begin
              // get a Covername from cddb-id
              baseName := CoverFilenameFromCDDA(aAudioFile.Pfad);
              completeName := '';
              if FileExists(TCoverArtSearcher.Savepath + baseName + '.jpg') then
                  completeName := TCoverArtSearcher.Savepath + baseName + '.jpg'
              else if FileExists(TCoverArtSearcher.Savepath + baseName + '.png') then
                  completeName := TCoverArtSearcher.Savepath + baseName + '.png';

              if completeName <> '' then
              begin
                  aGraphic := TPicture.Create;
                  try
                      aGraphic.LoadFromFile(completeName);
                      if (aCoverbmp.Width > 0) and (aCoverBmp.Height > 0) then
                          FitPictureIn(aCoverbmp, aGraphic.Graphic)
                      else
                          aCoverBmp.Assign(aGraphic);
                      result := True;
                  finally
                      aGraphic.Free;
                  end;
              end else
              begin
                  TCoverArtSearcher.GetDefaultCover(dcCDDA, aCoverbmp, 0);
                  result := false;
              end;
          end;
      end;
  except
      TCoverArtSearcher.GetDefaultCover(dcFile, aCoverbmp, 0);
      result := false;
  end;
end;

class function TCoverArtSearcher.GetCover_Fast(aCoverID: String; aCoverbmp: TPicture): boolean;
var aGraphic: TPicture;
begin
  try
    if (aCoverID <> '') And FileExists(TCoverArtSearcher.Savepath + aCoverID + '.jpg') then
    begin
        aGraphic := TPicture.Create;
        try
            aGraphic.LoadFromFile(TCoverArtSearcher.Savepath + aCoverID + '.jpg');

            if (aCoverbmp.Width > 0) and (aCoverBmp.Height > 0) then
                FitPictureIn(aCoverbmp, aGraphic.Graphic)
            else
                //AssignBitmap(aCoverBmp, aGraphic);
                aCoverbmp.Assign(aGraphic);
            result := True;
        finally
            aGraphic.Free;
        end;
    end
    else
      result := false;
  except
    result := false;
  end;
end;

function TCoverArtSearcher.GetCoverBitmapFromCollection(aCollection: TAudioCollection; aCoverBmp: TPicture): Boolean;
begin
  if (aCollection is TRootCollection) then begin
    PaintMainCover(aCoverBmp);
    result := True;
  end else
    result := GetCoverBitmapFromID(aCollection.CoverID, aCoverBmp);
end;

function TCoverArtSearcher.GetCoverBitmapFromID(aCoverID: String; aCoverBmp: TPicture): Boolean;
var aJpg: TJpegImage;
begin
    result := true;
    if (aCoverID = 'all') or (aCoverID = 'searchresult') then
    begin
        // PaintPersonalCover
        PaintMainCover(aCoverBmp);
    end else
    begin
        if aCoverID = '' then
        begin
            GetDefaultCover(dcFile, aCoverBmp, cmNoStretch);
            result := False;
        end else
        begin
            if FileExists(SavePath + aCoverID + '.jpg') then
            begin
                aJpg := TJpegImage.Create;
                try
                    try
                        aJpg.LoadFromFile(SavePath  + aCoverID + '.jpg');
                        aCoverBmp.Assign(aJpg);
                    except
                        GetDefaultCover(dcError, aCoverBmp,  cmNoStretch);
                        result := False;
                    end;
                finally
                  aJpg.Free;
                end;
            end else
            begin
                TCoverArtSearcher.GetDefaultCover(dcError, aCoverBmp, cmNoStretch);
                result := False;
            end;
        end;
    end;
end;


class procedure TCoverArtSearcher.GetDefaultCover(aType: TEDefaultCoverType; aCoverPic: TPicture; Flags: Integer);
var filename: UnicodeString;
    WPic: TWICImage;
    Stretch: Boolean;

begin
    // Flags auswerten
    Stretch := (Flags and cmNoStretch) = 0;

    filename := SavePath + '_default_cover.jpg';
    if aType = dcWebRadio  then
    begin
        filename := SavePath + '_default_cover_webradio.jpg';
        if not FileExists(filename) then
            filename := SavePath + '_default_cover_webradio.png';
        if not FileExists(filename) then
            filename := ExtractFilePath(ParamStr(0)) + 'Images\default_cover_webradio.png';
        if not FileExists(filename)  then
            filename := ExtractFilePath(ParamStr(0)) + 'Images\default_cover_webradio.jpg';
    end; //else
    if not FileExists(filename) then
    begin
        filename := SavePath + '_default_cover.jpg';
        if not FileExists(filename) then
            filename := SavePath + '_default_cover.png';
        if not FileExists(filename) then
            filename := ExtractFilePath(ParamStr(0)) + 'Images\default_cover.png';
        if not FileExists(filename)  then
            filename := ExtractFilePath(ParamStr(0)) + 'Images\default_cover.jpg';
    end;

    if FileExists(filename) then
    begin
        WPic := TWICImage.Create;
        try
            WPic.LoadFromFile(filename);
            if Stretch and (aCoverPic.Width > 0) and (aCoverPic.Height > 0) then
            begin
                FitWICImageIn(WPic, aCoverPic.Width, aCoverPic.Height);
                aCoverPic.Bitmap.Assign(WPic);
            end
            else
                aCoverPic.Bitmap.Assign(WPic);
        finally
            WPic.Free
        end;
    end else
    begin
        // otherwise: just a blank image with some text.
        aCoverPic.Bitmap := TBitmap.Create;
        aCoverPic.Bitmap.Height := CoverSize;
        aCoverPic.Bitmap.Width := CoverSize;
        aCoverPic.Bitmap.Canvas.Font.Size := CoverSize Div 20;
        aCoverPic.Bitmap.Canvas.TextOut(CoverSize Div 20, (CoverSize Div 2) - (CoverSize Div 40), 'Cover not available.');
    end;
end;

procedure TCoverArtSearcher.PrepareMainCover(aCategory: TLibraryCategory);
var i: Integer;
    CoverArray: Array of Integer;
    GoodCoverList: TAudioCollectionList;
    RC: TRootCollection;

    procedure ShuffleFisherYates;
    var
        i,j: Integer;
        tmp: Integer;
    begin
      // alle Elemente des Feldes durchlaufen
      for i := Low(CoverArray) to High(CoverArray) do begin
        // neue, zufällig Position bestimmen
        j := i + Random(Length(CoverArray) - i);
        // Element Nr. i mit Nr. j vertauschen (3ecks-Tausch)
        tmp := CoverArray[j];
        CoverArray[j] := CoverArray[i];
        CoverArray[i] := tmp;
      end;
    end;

    function IsFileFlow: Boolean;
    begin
      result := (aCategory.CollectionCount = 1) and (aCategory.Collections[0] is TRootCollection);
    end;

begin
    // Alte Liste löschen
    EnterCriticalSection(CSAccessRandomCoverlist);
    RandomCoverList.Clear;

    if IsFileFlow then begin
          RC := TRootCollection(aCategory.Collections[0]);

          GoodCoverList := TAudioCollectionList.Create(False);
          try
              // fill GoodCoverList with "good covers", i.e. a cover-bitmap exists
              for i := 1 to RC.CollectionCount - 1 do  //SourceCoverList.Count - 1 do
              begin
                  //if (SourceCoverlist[i].ID <> '')
                  //    and(SourceCoverlist[i].ID[1] <> '_')
                  if (RC.SubCollections[i].CoverID <> '')
                    and (RC.SubCollections[i].CoverID[1] <> '_')
                  then
                      GoodCoverList.Add(RC.SubCollections[i]);
              end;

              if GoodCoverList.Count >= 1 then
              begin
                      Setlength(CoverArray, GoodCoverList.Count);
                      for i := 0 to GoodCoverList.Count - 1 do
                          CoverArray[i] := i;
                      ShuffleFisherYates;

                      case Length(CoverArray) of
                          0: ; // empty list
                          1: RandomCoverList.Add(GoodCoverList[CoverArray[0]]); // Ein Cover - das draufmalen
                          2..3: for i := 0 to 1  do
                                    RandomCoverList.Add(GoodCoverList[CoverArray[i]]);
                          4..7: for i := 0 to 3  do
                                    RandomCoverList.Add(GoodCoverList[CoverArray[i]]);
                          8..15: for i := 0 to 7  do
                                    RandomCoverList.Add(GoodCoverList[CoverArray[i]]);
                      else
                          for i := 0 to 15 do
                              RandomCoverList.Add(GoodCoverList[CoverArray[i]]);
                      end;
              end
              else
                  ;// leere Liste, nichts zu tun.
          finally
              GoodCoverList.Free;
          end;
    end;
  LeaveCriticalSection(CSAccessRandomCoverlist);
end;

procedure TCoverArtSearcher.Clear;
begin
    RandomCoverList.Clear;
    fCurrentPath      := '';
    fCurrentCoverName := '';
    fCurrentCoverID   := '';
end;


procedure TCoverArtSearcher.PaintMainPickCover(aCoverBmp: TBitmap; aRootCollection: TRootCollection);
var
  i: Integer;
  TileSize: Integer;
  x1,y1: Integer;
const
  PickCoverSize = 256;

    procedure SetColorByID(aCanvas: TCanvas; aID: Cardinal);
    var
      aColor: TColor;
    begin
      // note: This method only works up to ~4 million covers
      aColor := aID + (1 shl 23);
      aCanvas.Brush.Color := aColor;
      aCanvas.Pen.Color := aColor;
    end;

    function GetCoverIndexByKey(aKey: String): Integer;
    var j: Integer;
    begin
      result := 0;
      for j := 0 to aRootCollection.CollectionCount - 1 do
      begin
        //if TNempCover(MainCoverList[j]).ID = aCoverID then
        if aRootCollection.SubCollections[j].Key = aKey then
        begin
          result := j + 1;
          {
            j + 1 instead of just j, because the Coverflow Contains an additional Cover at the beginning,
            containing the RootCollection itself.
          }
          break;
        end;
      end;
    end;

begin
    EnterCriticalSection(CSAccessRandomCoverlist);
    aCoverBmp.Canvas.Brush.Style := bsSolid;

    if RandomCoverList.Count = 0 then
    begin
        // No Cover in the library. Just paint the "zero" Cover
        aCoverBmp.Width  := PickCoverSize;
        aCoverBmp.Height := PickCoverSize;
        SetColorByID(aCoverBmp.Canvas, 0);
        aCoverBmp.Canvas.Rectangle(0,0, aCoverBmp.Width, aCoverBmp.Height);
    end else
    begin
        //TileSize := PickCoverSize Div 4;
        // At least one cover in the library

            // first: Set size of Target-Bitmap
            // and Tile size
            case RandomCoverList.Count of
                1: begin
                    aCoverBmp.Width  := PickCoverSize;
                    aCoverBmp.Height := PickCoverSize;
                    TileSize := PickCoverSize;
                end;
                2: begin
                    aCoverBmp.Width  := PickCoverSize;
                    aCoverBmp.Height := PickCoverSize Div 2;
                    TileSize := PickCoverSize Div 2;
                end;
                4: begin
                    aCoverBmp.Width  := PickCoverSize;
                    aCoverBmp.Height := PickCoverSize;
                    TileSize := PickCoverSize Div 2;
                end;
                8: begin
                    aCoverBmp.Width  := PickCoverSize;
                    aCoverBmp.Height := PickCoverSize Div 2;
                    TileSize := PickCoverSize Div 4;
                end;
                16: begin
                    aCoverBmp.Width  := PickCoverSize;
                    aCoverBmp.Height := PickCoverSize;
                    TileSize := PickCoverSize Div 4;
                end;
            else
                begin
                    aCoverBmp.Width  := PickCoverSize;
                    aCoverBmp.Height := PickCoverSize;
                    TileSize := PickCoverSize;
                end;
            end;

            for i := 0 to min(15, RandomCoverList.Count - 1) do
            begin
              SetColorByID(aCoverBmp.Canvas, GetCoverIndexByKey(RandomCoverList[i].Key) );
              case RandomCoverList.Count of
                  1: begin
                    x1 := 0;
                    y1 := 0;
                  end;
                  2,4: begin
                    x1 := ((i mod 2) * 2*TileSize);
                    y1 := ((i Div 2) * 2*TileSize);
                  end;
                  8,16: begin
                    x1 := ((i mod 4) * TileSize);
                    y1 := ((i Div 4) * TileSize);
                  end;
              else
                  begin
                    x1 := 0;
                    y1 := 0;
                  end;
              end;
              aCoverBmp.Canvas.Rectangle(x1, y1, x1+TileSize, y1+TileSize);
            end; // for
    end;
    LeaveCriticalSection(CSAccessRandomCoverlist);
end;


procedure TCoverArtSearcher.PaintMainCover(aCoverBmp: TPicture);
var i: Integer;
    smallbmp: TBitmap;
    aGraphic: TPicture;
    success: Boolean;
    newID: String;
    TileSize: Integer;// = 60;
begin
    EnterCriticalSection(CSAccessRandomCoverlist);

    if RandomCoverList.Count = 0 then
    begin
        // No Cover in the library. Just get the Default-Cover
        GetDefaultCover(dcFile, aCoverBmp, cmNoStretch);
    end else
    begin
        TileSize := CoverSize Div 4;

        // At least one cover in the library
        smallbmp := TBitmap.Create;
        try
            // first: Set size of Target-Bitmap
            // and Tile-Bitmap
            case RandomCoverList.Count of
                1: begin
                    aCoverBmp.Bitmap.Width  := 4 * TileSize;
                    aCoverBmp.Bitmap.Height := 4 * TileSize;
                    smallbmp.Width   := 4 * TileSize;
                    smallbmp.Height  := 4 * TileSize;
                end;
                2: begin
                    aCoverBmp.Bitmap.Width  := 4 * TileSize;
                    aCoverBmp.Bitmap.Height := 2 * TileSize;
                    smallbmp.Width   := 2 * TileSize;
                    smallbmp.Height  := 2 * TileSize;
                end;
                4: begin
                    aCoverBmp.Bitmap.Width  := 4 * TileSize;
                    aCoverBmp.Bitmap.Height := 4 * TileSize;
                    smallbmp.Width   := 2 * TileSize;
                    smallbmp.Height  := 2 * TileSize;
                end;
                8: begin
                    aCoverBmp.Bitmap.Width  := 4 * TileSize;
                    aCoverBmp.Bitmap.Height := 2 * TileSize;
                    smallbmp.Width   := 1 * TileSize;
                    smallbmp.Height  := 1 * TileSize;
                end;
                16: begin
                    aCoverBmp.Bitmap.Width  := 4 * TileSize;
                    aCoverBmp.Bitmap.Height := 4 * TileSize;
                    smallbmp.Width   := 1 * TileSize;
                    smallbmp.Height  := 1 * TileSize;
                end;
            end;

            for i := 0 to min(15, RandomCoverList.Count - 1) do
            begin

                aGraphic := TPicture.Create;
                try
                      success := GetCoverBitmapFromID(RandomCoverList[i].CoverID, aGraphic);
                      // if there is no file for this coverID (probably because of some recent change in CoverSize:
                      // try to get it again

                      if (not success) and PreviewGraphicShouldExist(RandomCoverList[i].CoverID) then
                          success := RepairCoverFileVCL(RandomCoverList[i].CoverID, Nil, aGraphic, newID);

                      // if we still get no proper cover art: Get the default one
                      if not success then
                          GetDefaultCover(dcError, aGraphic,  cmNoStretch);
                      // assign the graphic to the little bitmap
                      AssignBitmap(smallbmp, aGraphic);
                finally
                    aGraphic.Free;
                end;

                // smallbmp auf aCoverBmp kopieren.
                SetStretchBltMode(aCoverBmp.Bitmap.Canvas.Handle, HALFTONE);
                case RandomCoverList.Count of
                      1: StretchBlt(aCoverBmp.Bitmap.Canvas.Handle,     // handle to destination device context
                                0, //23 + 40,
                                0, //78 + 0,
                                4 * TileSize, 4 * TileSize,   // width, height of destination rectangle
                                smallbmp.Canvas.Handle,  // handle to source device context
                                0, 0,                   // x/y-coordinate of source rectangle's upper-left corner
                                smallbmp.Width, smallBmp.Height,
                                SRCCopy);
                      2,4: StretchBlt(aCoverBmp.Bitmap.Canvas.Handle,     // handle to destination device context
                                ((i mod 2) * 2*TileSize),
                                ((i Div 2) * 2*TileSize),
                                2*TileSize, 2*TileSize,   // width, height of destination rectangle
                                smallbmp.Canvas.Handle,  // handle to source device context
                                0, 0,                   // x/y-coordinate of source rectangle's upper-left corner
                                smallbmp.Width, smallBmp.Height,
                                SRCCopy);
                      8,16: StretchBlt(aCoverBmp.Bitmap.Canvas.Handle,     // handle to destination device context
                                ((i mod 4) * TileSize),
                                ((i Div 4) * TileSize),
                                TileSize, TileSize,   // width, height of destination rectangle
                                smallbmp.Canvas.Handle,  // handle to source device context
                                0, 0,                   // x/y-coordinate of source rectangle's upper-left corner
                                smallbmp.Width, smallBmp.Height,
                                SRCCopy);
                end; // case
            end; // for
        finally
            smallbmp.Free;
        end;
    end;

    LeaveCriticalSection(CSAccessRandomCoverlist);
end;

function TCoverArtSearcher.GetProperImagingFactory(ScanMode: CoverScanThreadMode): IWICImagingFactory;
begin
    case ScanMode of
        tm_VCL: begin
            if WICImagingFactory_VCL = Nil then
                CoCreateInstance(CLSID_WICImagingFactory, nil, CLSCTX_INPROC_SERVER or
                    CLSCTX_LOCAL_SERVER, IUnknown, WICImagingFactory_VCL);
            result := WICImagingFactory_VCL;
        end;
        tm_Thread: begin
            if WICImagingFactory_ScanThread = Nil then
                CoCreateInstance(CLSID_WICImagingFactory, nil, CLSCTX_INPROC_SERVER or
                    CLSCTX_LOCAL_SERVER, IUnknown, WICImagingFactory_ScanThread);
            result := WICImagingFactory_ScanThread;
        end;
    end;
end;


class function TCoverArtSearcher.ScalePicStreamToFile(aStream: TStream; aID: UnicodeString; destSize: Integer; destDir: String; aWICImagingFactory: IWICImagingFactory; OverWrite: Boolean = False): boolean;
var NewIDFilename: String;
    hr: HRESULT;
    isLocalFactory: Boolean;
    // for proper scaling
    xfactor, yfactor:double;
    origWidth, origHeight: Cardinal;
    newWidth, newHeight: Cardinal;
    // reading the source image
    SourceAdapter: IStream;
    BitmapDecoder: IWICBitmapDecoder;
    DecodeFrame: IWICBitmapFrameDecode;
    SourceBitmap: IWICBitmap;
    SourceScaler: IWICBitmapScaler;
    // writing the resized image
    DestStream: TMemoryStream;
    DestAdapter: IStream;
    DestWICStream: IWICStream;
    BitmapEncoder: IWICBitmapEncoder;
    EncodeFrame: IWICBitmapFrameEncode;
    Props: IPropertyBag2;
begin
    result := False;
    NewIDFilename := destDir + aID + '.jpg';
    if (Not Overwrite) and FileExists(NewIDFilename) then
    begin
        result := True;
        exit;
    end;

    isLocalFactory := (aWICImagingFactory = nil);
    if isLocalFactory then
        CoCreateInstance(CLSID_WICImagingFactory, nil, CLSCTX_INPROC_SERVER or
          CLSCTX_LOCAL_SERVER, IUnknown, aWICImagingFactory);

    // read the image data from stream
    SourceAdapter := TStreamAdapter.Create(aStream);
    hr := aWICImagingFactory.CreateDecoderFromStream(SourceAdapter, guid_null, WICDecodeMetadataCacheOnDemand, BitmapDecoder);
    if Succeeded(hr) then hr := BitmapDecoder.GetFrame(0, DecodeFrame);
    if Succeeded(hr) then hr := aWICImagingFactory.CreateBitmapFromSource(DecodeFrame, WICBitmapCacheOnLoad, SourceBitmap);
    if Succeeded(hr) then hr := SourceBitmap.GetSize(origWidth, origHeight);

    // init with the size of the original file
    newWidth  := origWidth ;
    newHeight := origHeight;
    // calculate proper (down)scaling
    xfactor:= (destSize) / origWidth;
    yfactor:= (destSize) / origHeight;
    if xfactor > yfactor then
    begin
        if yFactor < 1 then
        begin
            newWidth := round(origWidth * yfactor);
            newHeight := round(origHeight * yfactor);
        end;
    end else
    begin
        if xFactor < 1 then
        begin
            newWidth := round(origWidth * xfactor);
            newHeight := round(origHeight * xfactor);
        end;
    end;

    // scale the original image
    if Succeeded(hr) then hr := aWICImagingFactory.CreateBitmapScaler(SourceScaler);
    if Succeeded(hr) then hr := SourceScaler.Initialize(SourceBitmap, NewWidth, NewHeight, WICBitmapInterpolationModeFant);

    if Succeeded(hr) then
    begin
        // Reading and scaling the original image was successful.
        // Now try to save the scaled image
        DestStream := TMemoryStream.create;
        try
            // create new WICStream
            DestAdapter := TStreamAdapter.Create(DestStream);
            if Succeeded(hr) then hr := aWICImagingFactory.CreateStream(DestWICStream);
            if Succeeded(hr) then hr := DestWICStream.InitializeFromIStream(DestAdapter);
            // create and prepare JPEG-Encoder
            if Succeeded(hr) then hr := aWICImagingFactory.CreateEncoder(GUID_ContainerFormatJpeg, guid_null, BitmapEncoder);
            if Succeeded(hr) then hr := BitmapEncoder.Initialize(DestWICStream, WICBitmapEncoderNoCache);
            if Succeeded(hr) then hr := BitmapEncoder.CreateNewFrame(EncodeFrame, Props);
            if Succeeded(hr) then hr := EncodeFrame.Initialize(Props);
            if Succeeded(hr) then hr := EncodeFrame.SetSize(newWidth, newHeight);
            // write image data
            if Succeeded(hr) then hr := EncodeFrame.WriteSource(SourceScaler, nil);
            if Succeeded(hr) then hr := EncodeFrame.Commit;
            if Succeeded(hr) then hr := BitmapEncoder.Commit;
            // finally save the stream to the destination file
            if Succeeded(hr) then
                try
                    DestStream.SaveToFile(NewIDFilename);
                    result := True;
                except
                    // silent exception here, but (try to) delete the destination file, if it exists
                    if FileExists(NewIDFilename) then DeleteFile(NewIDFilename);
                        result := False;
                end;
        finally
            DestStream.Free;
        end;
    end;

    if isLocalFactory then
        aWICImagingFactory._Release;
end;

class function TCoverArtSearcher.ScalePicStreamToFile_AllSizes(aStream: TStream; aID: UnicodeString; aWICImagingFactory: IWICImagingFactory; OverWrite: Boolean = False): boolean;
var aSaveDir: String;
    tmp: Boolean;
begin
    result := False;
    try
        aSaveDir := BaseSavePath;
        ForceDirectories(aSaveDir);
        if DirectoryExists(aSaveDir) then
        begin
            tmp := ScalePicStreamToFile(aStream, aID, 240, aSaveDir, aWICImagingFactory, OverWrite);
            result := result or tmp;
        end;

        aSaveDir := BaseSavePath + 'M\';
        ForceDirectories(aSaveDir);
        aStream.Position := 0;
        if DirectoryExists(aSaveDir) then
        begin
            tmp := ScalePicStreamToFile(aStream, aID, 500, aSaveDir, aWICImagingFactory, OverWrite);
            result := result or tmp;
        end;

        aSaveDir := BaseSavePath + 'L\';
        ForceDirectories(aSaveDir);
        aStream.Position := 0;
        if DirectoryExists(aSaveDir) then
        begin
            tmp := ScalePicStreamToFile(aStream, aID, 750, aSaveDir, aWICImagingFactory, OverWrite);
            result := result or tmp;
        end;

        aSaveDir := BaseSavePath + 'XL\';
        ForceDirectories(aSaveDir);
        aStream.Position := 0;
        if DirectoryExists(aSaveDir) then
        begin
            tmp := ScalePicStreamToFile(aStream, aID, 1000, aSaveDir, aWICImagingFactory, OverWrite);
            result := result or tmp;
        end;

    except
        //
    end;
end;


class function TCoverArtSearcher.ScalePicStreamToFile_DefaultSize(aStream: TStream; aID: UnicodeString; aWICImagingFactory: IWICImagingFactory; OverWrite: Boolean = False): boolean;
begin
    result := ScalePicStreamToFile(aStream, aID, CoverSize, SavePath, aWICImagingFactory, OverWrite);
end;



initialization

  InitializeCriticalSection(CSAccessRandomCoverlist);
  InitializeCriticalSection(CSAccessCoverSearcherProperties);

  Pointer(WICImagingFactory_ScanThread) := Nil;
  Pointer(WICImagingFactory_VCL)        := Nil;

finalization

  DeleteCriticalSection(CSAccessRandomCoverlist);
  DeleteCriticalSection(CSAccessCoverSearcherProperties);

  if WICImagingFactory_VCL <> Nil then
      WICImagingFactory_VCL._Release;

end.
