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
unit CoverHelper;

interface

uses
  Windows, Messages, SysUtils,  Classes, Graphics,
  Dialogs, StrUtils, ContNrs, Jpeg, PNGImage, GifImg, math,
  MP3FileUtils, ID3v2Frames, AudioFileClass, Nemp_ConstantsAndTypes;


type

    TNempCover = class
    private
        function fGetInfoString: String;
    public
      ID: String;
      key: String;    // init: a copy of ID, but ID can be changed without resorting
      Artist: UnicodeString;
      Album: UnicodeString;
      Year: Integer;
      Genre: UnicodeString;
      Directory: UnicodeString;
      FileAge: TDateTime;

      property InfoString: String read fGetInfoString;
      procedure Assign(aCover: TNempCover);
    end;


  // Get the front cover from a list of names of found imagefiles
  function GetFrontCover(CoverList: TStrings): integer;

  // Search imagefiles in pfad and add them to CoverList
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

  // Save a Graphic in a resized file. Used for all the little md5-named jpgs
  // in <NempDir>\Cover
  function SafeResizedGraphic(aGraphic: TGraphic; dest: UnicodeString; W,h: Integer; OverWrite: Boolean = False): boolean;

  // Converts data from a (id3tag)-picture-stream to a Bitmap.
  function PicStreamToImage(aStream: TStream; Mime: AnsiString; aBmp: TBitmap): Boolean;

  // Draw a Picture on a Bitmap
  procedure AssignBitmap(var Bitmap: TBitmap; const Picture: TPicture);

  // Draw a Graphic on a bounded Bitmap (stretch, proportional)
  procedure FitBitmapIn(Bounds: TBitmap; Source: TGraphic);

  // GetCoverFromList calls GetFrontCover and load it into the Bitmap
  function GetCoverFromList(aList: TStringList; aCoverbmp: tBitmap): boolean;
  // Get the Frontcover from an id3Tag
  function GetCoverFromID3(aAudioFile: TAudioFile; aCoverbmp: tBitmap): boolean;

  // GetCover calls GetCoverFromID3,
  // then MedienBib.GetCoverList and GetCoverFromList if no success
  // finally GetDefaultCover if still no success
  function GetCover(aAudioFile: TAudioFile; aCoverbmp: tBitmap): boolean;

  // GetCoverBitmapFromID:
  // Get the Bitmap for a specified Cover-ID
  function GetCoverBitmapFromID(aCoverID: String; aCoverBmp: tBitmap; aDir: String): Boolean;


  // Get the Default-Cover
  // i.e. one of the ugly Nemp-Covers like "no cover", "webradio"
  //      OR the customized cover file from the Medialibrary-settings.
  procedure GetDefaultCover(aType: TDefaultCoverType; aCoverbmp: tBitmap; Flags: Integer);

  // Try to get some "Common Strings" from a list of audioFiles with the same coverfile
  procedure GetCoverInfos(AudioFileList: TObjectlist; aCover: TNempCover);

  // Select randomly some covers from the list and store it in the
  // global variable RandomCoverList
  procedure GetRandomCover(SourceCoverlist: TObjectlist);
  // Clear random cover
  procedure ClearRandomCover;
  // Paint a custumized cover "Your Library", using Cover in RandomCoverList
  procedure PaintPersonalMainCover(aCoverBmp: TBitmap);


implementation

uses NempMainUnit, StringHelper, AudioFileHelper;
// NempMainUnit is used, as some settings from the MediaLibrary are used here.

var
    CSAccessRandomCoverlist: RTL_CRITICAL_SECTION;
    RandomCoverList: TStringlist;       // Randomly selected cover. Used for customized painting


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
    ID       := aCover.ID        ;
    key      := aCover.key       ;
    Artist   := aCover.Artist    ;
    Album    := aCover.Album     ;
    Year     := aCover.Year      ;
    Genre    := aCover.Genre     ;
    Directory:= aCover.Directory ;
    FileAge  := aCover.FileAge   ;
end;

function TNempCover.fGetInfoString: String;
begin
   if (self.Year >= 1000) and (year <= 2500) then
        result := Artist  + ' - ' + Album + ' (' + IntToStr(year) + ')'
   else
       result := Artist  + ' - ' + Album
   // TODO: Translation of ALL COVER
end;


function GetFrontCover(CoverList:TStrings):integer;
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

Procedure SucheCover(pfad: UnicodeString; CoverList:TStringList);
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

procedure SucheCoverInSubDir(Pfad: UnicodeString; CoverList:TStringList; Substr: UnicodeString);
var sdir: UnicodeString;
begin
    sdir := GetValidSubDir(Pfad, Substr);
    if sdir <> Pfad then
      SucheCover(sdir, CoverList);
end;

procedure SucheCoverInSisterDir(Pfad: UnicodeString; CoverList: TStringList; Substr: UnicodeString);
var sdir: UnicodeString;
begin
    sdir := GetValidSisterDir(Pfad,Substr);
    if sdir <> Pfad then
      SucheCover(sdir, CoverList);
end;

procedure SucheCoverInParentDir(Pfad: UnicodeString; CoverList: TStringList);
begin
  pfad := ExcludeTrailingPathDelimiter(pfad);
  pfad := Copy(pfad,1,LastDelimiter('\',Pfad));
  SucheCover(pfad, CoverList);
end;

function CountSubDirs(Pfad: UnicodeString):integer;
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

function CountSisterDirs(Pfad: UnicodeString):integer;
begin
  pfad := ExcludeTrailingPathDelimiter(pfad);
 // ...und den Parentordner bestimmen
  Pfad := Copy(Pfad,1, LastDelimiter('\',Pfad));
  result := CountSubDirs(Pfad);
end;

function CountFilesInParentDir(Pfad: UnicodeString):integer;
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

function GetValidSubDir(Pfad: UnicodeString; Substr: UnicodeString): UnicodeString;
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

function GetValidSisterDir(Pfad: UnicodeString; Substr: UnicodeString): UnicodeString;
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

function SafeResizedGraphic(aGraphic: TGraphic; dest: UnicodeString; W,h: Integer; OverWrite: Boolean = False): boolean;
var BigBmp, SmallBmp: TBitmap;
    xfactor, yfactor:double;
    aJpg: tJpegImage;
    aStream: TFileStream;
begin

  result := True;

  if Not Overwrite and FileExists(dest) then exit;

  BigBmp := TBitmap.Create;
  SmallBmp := TBitmap.Create;
  try
      try
          SmallBmp.Width := W;
          SmallBmp.Height := H;

          if (aGraphic <> NIL) And ((aGraphic.Width > 0) And (aGraphic.Height > 0)) then
          begin

              BigBmp.Assign(aGraphic);


              xfactor:= (W) / aGraphic.Width;
              yfactor:= (H) / aGraphic.Height;
              if xfactor > yfactor then
                begin
                  SmallBmp.Width := round(aGraphic.Width * yfactor);
                  SmallBmp.Height := round(aGraphic.Height * yfactor);
                end else
                begin
                  SmallBmp.Width := round(aGraphic.Width * xfactor);
                  SmallBmp.Height := round(aGraphic.Height * xfactor);
                end;

              SetStretchBltMode(SmallBmp.Canvas.Handle, HALFTONE);
              StretchBlt(SmallBmp.Canvas.Handle, 0 ,0, SmallBmp.Width, SmallBmp.Height, BigBmp.Canvas.Handle, 0, 0, BigBmp.Width, BigBmp.Height, SRCCopy);
              aJpg := TJpegImage.Create;
              try
                  aJpg.CompressionQuality := 90;
                  aJpg.Assign(Smallbmp);
                  try
                      aStream := TFileStream.Create(dest, fmCreate or fmOpenWrite);
                      try
                        aJpg.SaveToStream(aStream);
                      finally
                        aStream.free;
                      end;
                  except
                      // silent Exception. Cover-Saving failed.
                      if FileExists(dest) then DeleteFile(dest);
                          result := False;
                  end;
              finally
                  aJpg.Free;
              end;
          end;
      except
        if FileExists(dest) then DeleteFile(dest);
            result := False;
      end;
  finally
      SmallBmp.Free;
      BigBmp.Free;
  end;
end;

function PicStreamToImage(aStream: TStream; Mime: AnsiString; aBmp: TBitmap): Boolean;
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

procedure AssignBitmap(var Bitmap: TBitmap; const Picture: TPicture);
begin
    Bitmap.PixelFormat := pf24bit;
    Bitmap.Height := Picture.Height;
    Bitmap.Width := Picture.Width;
    //Bitmap.Canvas.FillRect(Rect(0, 0, Bitmap.Width, Bitmap.Height));
    Bitmap.Canvas.Draw(0, 0, Picture.Graphic);
    Bitmap.PixelFormat := pf24bit;
end;



procedure FitBitmapIn(Bounds: TBitmap; Source: TGraphic);
var xfactor, yfactor:double;
begin
  if Source = NIL then exit;
  if (Source.Width = 0) or (Source.Height=0) then exit;
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
end;


function GetCoverFromList(aList: TStringList; aCoverbmp: tBitmap): Boolean;
var FrontCover:integer;
    aGraphic: TPicture;
begin
      result := False;
      if aList.Count = 0 then
          Exit;
      FrontCover := GetFrontCover(aList);
      aGraphic := TPicture.Create;
      try
          aGraphic.LoadFromFile(aList[FrontCover]);
          if (aCoverbmp.Width > 0) and (aCoverBmp.Height > 0) then
          begin
              FitBitmapIn(aCoverbmp, aGraphic.Graphic);
              aCoverbmp.Canvas.StretchDraw(aCoverbmp.Canvas.ClipRect, aGraphic.Graphic);
          end else
              AssignBitmap(aCoverBmp, aGraphic);
          result := True;
      finally
          aGraphic.Free;
      end;
end;

function GetCoverFromID3(aAudioFile: TAudioFile; aCoverbmp: tBitmap): boolean;
var MpegInfo: TMpegInfo;
  Id3v1Tag: TID3v1Tag;
  Id3v2Tag: TID3v2Tag;
  PictureFrames: TObjectList;
  Mime: AnsiString;
  PicType: Byte;
  Description: UnicodeString;
  PicData: TMemoryStream;
  ok: Boolean;
  i: integer;
  tmpbmp: TBitmap;
begin
  result := False;

  if (AnsiLowerCase(ExtractFileExt(aAudioFile.Pfad))='.mp3')
    AND FileExists(aAudioFile.Pfad) then
  begin
    mpeginfo := TMpegInfo.Create;
    Id3v1Tag := TId3v1Tag.Create;
    Id3v2Tag := TId3v2Tag.Create;

    try
      GetMp3Details(aAudioFile.Pfad,mpegInfo,ID3v2Tag,ID3v1tag);
    except
    end;

    if ID3v2Tag.exists then
    begin
        PictureFrames := ID3v2Tag.GetAllPictureFrames;
        PicData := TMemoryStream.Create;
        try
            for i := PictureFrames.Count - 1 downto 0 do
            begin
                // hinten anfangen, Front-Cover suchen.
                // gibt es kein Front-Cover: Das erste nehmen
                PicData.Clear;
                (PictureFrames[i] as TID3v2Frame).GetPicture(Mime, PicType, Description, PicData);

                if ((PicType = 3) or (i = 0)) and (PicData.Size > 50) then
                begin
                    tmpbmp := TBitmap.Create;
                    try
                        ok := PicStreamToImage(PicData, Mime, tmpbmp);

                        if ok then
                        begin
                            if (aCoverbmp.Width > 0) and (aCoverBmp.Height > 0) then
                            begin
                                FitBitmapIn(aCoverbmp, tmpbmp);
                                aCoverbmp.Canvas.StretchDraw(aCoverbmp.Canvas.ClipRect, tmpbmp);
                            end else
                                aCoverBmp.Assign(tmpbmp);
                        end;
                    finally
                        tmpbmp.Free;
                    end;
                    if ok then
                    begin
                        result := True;
                        break;
                    end;
                end;
            end;
        finally
            PictureFrames.Free;
            PicData.Free;
        end;

    end;
    mpeginfo.Free;
    Id3v1Tag.Free;
    Id3v2Tag.Free;
  end;
end;

function GetCover(aAudioFile: TAudioFile; aCoverbmp: tBitmap): boolean;
var coverliste: TStringList;
    aGraphic: TPicture;
begin
  try
      if aAudioFile.isStream then
      begin
          GetDefaultCover(dcWebRadio, aCoverbmp, cmUseBibDefaults);
          result := True;
      end else
      begin
            if (aAudioFile.CoverID <> '') And FileExists(Medienbib.CoverSavePath + aAudioFile.CoverID + '.jpg') then
            begin
                aGraphic := TPicture.Create;
                try
                    aGraphic.LoadFromFile(Medienbib.CoverSavePath + aAudioFile.CoverID + '.jpg');
                    if (aCoverbmp.Width > 0) and (aCoverBmp.Height > 0) then
                    begin
                        FitBitmapIn(aCoverbmp, aGraphic.Graphic);
                        aCoverbmp.Canvas.StretchDraw(aCoverbmp.Canvas.ClipRect, aGraphic.Graphic);
                    end else
                        AssignBitmap(aCoverBmp, aGraphic);
                    result := True;
                finally
                    aGraphic.Free;
                end;
            end else
            begin
                // erstmal im ID3-Tag nach nem Bild suchen
                if GetCoverFromID3(aAudioFile, aCoverbmp) then
                    result := True
                else
                begin // in Dateien rund um das Audiofile nach nem Bild suchen
                    coverliste := TStringList.Create;
                    Medienbib.GetCoverListe(aAudioFile,coverliste);
                    try
                        if Not GetCoverFromList(CoverListe, aCoverbmp) then
                        begin
                            GetDefaultCover(dcNoCover, aCoverbmp, cmUseBibDefaults);
                            result := False;
                        end else
                            result := True;
                    except
                        GetDefaultCover(dcNoCover, aCoverbmp, cmUseBibDefaults);
                        result := false;
                    end;
                    coverliste.free;
                end;
            end;
      end;
  except
      GetDefaultCover(dcNoCover, aCoverbmp, cmUseBibDefaults);
      result := false;
  end;
end;

function GetCoverBitmapFromID(aCoverID: String; aCoverBmp: tBitmap; aDir: String): Boolean;
var aJpg: TJpegImage;
begin
    result := true;
    if (aCoverID = 'all') or (aCoverID = 'searchresult') then
    begin
        // PaintPersonalCover
        PaintPersonalMainCover(aCoverBmp);
    end else
    begin
        if aCoverID = '' then
        begin
            GetDefaultCover(dcNoCover, aCoverBmp, cmUseBibDefaults or cmNoStretch);
            result := False;
        end else
        begin
            if FileExists(aDir + aCoverID + '.jpg') then
            begin
                aJpg := TJpegImage.Create;
                try
                    try
                        aJpg.LoadFromFile(aDir  + aCoverID + '.jpg');
                        aCoverBmp.Assign(aJpg);
                    except
                        GetDefaultCover(dcError, aCoverBmp, cmUseBibDefaults or cmNoStretch);
                        result := False;
                    end;
                finally
                  aJpg.Free;
                end;
            end else
            begin
                GetDefaultCover(dcError, aCoverBmp, cmUseBibDefaults or cmNoStretch);
                result := False;
            end;
        end;
    end;
end;

procedure GetDefaultCover(aType: TDefaultCoverType; aCoverbmp: tBitmap; Flags: Integer);
var filename: UnicodeString;
    aGraphic: TPicture;
    Stretch: Boolean;
begin
    // Flags auswerten
    Stretch := (Flags and cmNoStretch) = 0;

    filename := ExtractFilePath(ParamStr(0)) + 'Images\default_cover.png';
    if FileExists(filename) then
    begin
        aGraphic := TPicture.Create;
        try
            aGraphic.LoadFromFile(filename);
            if Stretch and (aCoverbmp.Width > 0) and (aCoverBmp.Height > 0) then
            begin
                FitBitmapIn(aCoverbmp, aGraphic.Graphic);
                aCoverbmp.Canvas.StretchDraw(aCoverbmp.Canvas.ClipRect, aGraphic.Graphic);
            end else
                AssignBitmap(aCoverBmp, aGraphic);
        finally
            aGraphic.Free;
        end;
    end;
end;

procedure GetCoverInfos(AudioFileList: TObjectlist; aCover: TNempCover);
var str1: UnicodeString;
    maxidx, i, fehlstelle: Integer;
    aStringlist: TStringList;
    newestAge, currentAge: TDateTime;
begin

  if aCover.ID = '' then
  begin
      aCover.Artist := 'Various artists';
      aCover.Album := 'Unknown';
      aCover.Year := 0;
      aCover.Genre := 'Other';
      aCover.Directory := ' ';
      aCover.FileAge := 0;
      exit;
  end;

  if AudioFileList.Count <= 25 then maxIdx := AudioFileList.Count-1 else maxIdx := 25;

  aStringlist := TStringList.Create;
  for i := 0 to maxIdx do
      if (TAudioFile(AudioFileList[i]).Artist <> '') then
          aStringlist.Add(TAudioFile(AudioFileList[i]).Artist);

  fehlstelle := 0;
  str1 := GetCommonString(aStringlist, 0, fehlstelle);  // bei Test auf "String gleich?" keinen Fehler zulassen
  if str1 = '' then
    aCover.Artist := 'Various artists'
  else
    aCover.Artist := str1; // Fehlstelle ist irrelevant


  aStringlist.Clear;
  // Dasselbe jetzt mit Album, aber mit Toleranz 1 bei den Strings
  for i := 0 to maxIdx do
      if (TAudioFile(AudioFileList[i]).Album <> '') then
          aStringlist.Add(TAudioFile(AudioFileList[i]).Album);

  fehlstelle := 0;
  str1 := GetCommonString(aStringlist, 1, fehlstelle);  // bei Test auf "String gleich?" einen Fehler zulassen  (cd1/2...)
  if str1 = '' then
    aCover.Album := 'Unknown compilation'
  else
  begin
    if fehlstelle <= length(str1) Div 2 +1 then
      aCover.Album := str1
    else
      aCover.Album := copy(str1, 1, fehlstelle-1) + ' ... ';
  end;

  aStringlist.Clear;
  // Dasselbe jetzt mit Genre
  for i := 0 to maxIdx do
      aStringlist.Add(TAudioFile(AudioFileList[i]).Genre);
  fehlstelle := 0;
  str1 := GetCommonString(aStringlist, 1, fehlstelle);  // bei Test auf "String gleich?" einen Fehler zulassen  (cd1/2...)
  if str1 = '' then
    aCover.Genre := 'Other'
  else
    aCover.Genre := str1;

  if AudioFileList.Count = 0 then
  begin
    aCover.Year := 0;
    aCover.Directory := ' ';
  end
  else
  begin
    AudioFileList.Sort(Sortieren_Jahr_asc);
    aCover.Year := StrToIntDef(TAudioFile(AudioFileList[AudioFileList.Count Div 2]).Year, 0);
    aCover.Directory := TAudioFile(AudioFileList[0]).Ordner;
  end;

  newestAge := 0;
  for i := 0 to AudioFileList.Count - 1 do
  begin
      currentAge := TAudioFile(AudioFileList[i]).FileAge;
      if currentAge > newestAge then
          newestAge := currentAge;
  end;
  aCover.FileAge := newestAge;

  aStringlist.Free;
end;

procedure GetRandomCover(SourceCoverlist: TObjectlist);
var i: Integer;
    CoverArray: Array of Integer;
    GoodCoverList: TObjectList;

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

begin
    // Alte Liste löschen
    EnterCriticalSection(CSAccessRandomCoverlist);
    RandomCoverList.Clear;

    GoodCoverList := TObjectList.Create(False);
    try
        // fill GoodCoverList with "good covers", i.e. a cover-bitmap exists
        for i := 1 to SourceCoverList.Count - 1 do
        begin
            if (TNempCover(SourceCoverlist[i]).ID <> '')
                and(TNempCover(SourceCoverlist[i]).ID[1] <> '_')
            then
                GoodCoverList.Add(SourceCoverlist[i]);
        end;

        if GoodCoverList.Count >= 1 then
        begin
                Setlength(CoverArray, GoodCoverList.Count);
                for i := 0 to GoodCoverList.Count - 1 do
                    CoverArray[i] := i;
                ShuffleFisherYates;

                case Length(CoverArray) of
                    0: ; // empty list
                    1: RandomCoverList.Add(TNempCover(GoodCoverList[CoverArray[0]]).ID); // Ein Cover - das draufmalen
                    2..3: for i := 0 to 1  do
                              RandomCoverList.Add(TNempCover(GoodCoverList[CoverArray[i]]).ID);
                    4..7: for i := 0 to 3  do
                              RandomCoverList.Add(TNempCover(GoodCoverList[CoverArray[i]]).ID);
                    8..15: for i := 0 to 7  do
                              RandomCoverList.Add(TNempCover(GoodCoverList[CoverArray[i]]).ID);
                else
                    for i := 0 to 15 do
                        RandomCoverList.Add(TNempCover(GoodCoverList[CoverArray[i]]).ID);
                end;
        end
        else
            ;// leere Liste, nichts zu tun.
    finally
        GoodCoverList.Free;
    end;


  LeaveCriticalSection(CSAccessRandomCoverlist);
end;

procedure ClearRandomCover;
begin
    RandomCoverList.Clear;
end;

procedure PaintPersonalMainCover(aCoverBmp: TBitmap);
var i: Integer;
    smallbmp: TBitmap;
    aGraphic: TPicture;
Const TileSize = 60;
begin
    EnterCriticalSection(CSAccessRandomCoverlist);

    if RandomCoverList.Count = 0 then
    begin
        // No Cover in the library. Just get the Default-Cover
        GetDefaultCover(dcNoCover, aCoverBmp, cmUseBibDefaults or cmNoStretch);
    end else
    begin
        // At least one cover in the library
        smallbmp := TBitmap.Create;
        try
            // first: Set size of Target-Bitmap
            // and Tile-Bitmap
            case RandomCoverList.Count of
                1: begin
                    aCoverBmp.Width  := 4 * TileSize;
                    aCoverBmp.Height := 4 * TileSize;
                    smallbmp.Width   := 4 * TileSize;
                    smallbmp.Height  := 4 * TileSize;
                end;
                2: begin
                    aCoverBmp.Width  := 4 * TileSize;
                    aCoverBmp.Height := 2 * TileSize;
                    smallbmp.Width   := 2 * TileSize;
                    smallbmp.Height  := 2 * TileSize;
                end;
                4: begin
                    aCoverBmp.Width  := 4 * TileSize;
                    aCoverBmp.Height := 4 * TileSize;
                    smallbmp.Width   := 2 * TileSize;
                    smallbmp.Height  := 2 * TileSize;
                end;
                8: begin
                    aCoverBmp.Width  := 4 * TileSize;
                    aCoverBmp.Height := 2 * TileSize;
                    smallbmp.Width   := 1 * TileSize;
                    smallbmp.Height  := 1 * TileSize;
                end;
                16: begin
                    aCoverBmp.Width  := 4 * TileSize;
                    aCoverBmp.Height := 4 * TileSize;
                    smallbmp.Width   := 1 * TileSize;
                    smallbmp.Height  := 1 * TileSize;
                end;
            end;

            for i := 0 to min(15, RandomCoverList.Count - 1) do
            begin
                if (FileExists(Medienbib.CoverSavePath + RandomCoverList[i] + '.jpg')) then
                begin
                    aGraphic := TPicture.Create;
                    try
                        aGraphic.LoadFromFile(Medienbib.CoverSavePath + RandomCoverList[i] + '.jpg');
                        AssignBitmap(smallbmp, aGraphic);
                        //smallbmp.Assign(aGraphic.Bitmap);
                    finally
                        aGraphic.Free;
                    end;
                end else
                    GetDefaultCover(dcError, smallbmp, cmUseDefaultCover or cmNoStretch);

                // smallbmp auf aCoverBmp kopieren.
                SetStretchBltMode(aCoverBmp.Canvas.Handle, HALFTONE);
                case RandomCoverList.Count of
                      1: StretchBlt(aCoverBmp.Canvas.Handle,     // handle to destination device context
                                0, //23 + 40,
                                0, //78 + 0,
                                4 * TileSize, 4 * TileSize,   // width, height of destination rectangle
                                smallbmp.Canvas.Handle,  // handle to source device context
                                0, 0,                   // x/y-coordinate of source rectangle's upper-left corner
                                smallbmp.Width, smallBmp.Height,
                                SRCCopy);
                      2,4: StretchBlt(aCoverBmp.Canvas.Handle,     // handle to destination device context
                                ((i mod 2) * 2*TileSize),
                                ((i Div 2) * 2*TileSize),
                                2*TileSize, 2*TileSize,   // width, height of destination rectangle
                                smallbmp.Canvas.Handle,  // handle to source device context
                                0, 0,                   // x/y-coordinate of source rectangle's upper-left corner
                                smallbmp.Width, smallBmp.Height,
                                SRCCopy);
                      8,16: StretchBlt(aCoverBmp.Canvas.Handle,     // handle to destination device context
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

initialization

  InitializeCriticalSection(CSAccessRandomCoverlist);
  RandomCoverList := TStringlist.Create;

finalization

  DeleteCriticalSection(CSAccessRandomCoverlist);
  RandomCoverList.Free;

end.
