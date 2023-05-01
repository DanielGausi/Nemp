{

    Unit cddaUtils

    - manage meta data for Audio CDs
      Read CD Text
      Use online CDDB
      Cache data from online CDDB in a local file

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2005-2023, Daniel Gaussmann
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

unit cddaUtils;

interface

uses  Windows, Forms, Messages, SysUtils, Variants, ContNrs, Classes, StrUtils,
      bass, basscd, CDSelection, Controls,
      System.Generics.Defaults, System.Generics.Collections;

const
  MAXDRIVES = 10;  // maximum number auf CDDA-Drives

  REGEX_EMAIL =  '^((?>[a-zA-Z\d!#$%&''*+\-/=?^_`{|}~]+\x20*|"((?=[\x01-\x7f])'
           +'[^"\\]|\\[\x01-\x7f])*"\x20*)*(?<angle><))?((?!\.)'
           +'(?>\.?[a-zA-Z\d!#$%&''*+\-/=?^_`{|}~]+)+|"((?=[\x01-\x7f])'
           +'[^"\\]|\\[\x01-\x7f])*")@(((?!-)[a-zA-Z\d\-]+(?<!-)\.)+[a-zA-Z]'
           +'{2,}|\[(((?(?<!\[)\.)(25[0-5]|2[0-4]\d|[01]?\d?\d))'
           +'{4}|[a-zA-Z\d\-]*[a-zA-Z\d]:((?=[\x01-\x7f])[^\\\[\]]|\\'
           +'[\x01-\x7f])+)\])(?(angle)>)$';


type
    TCddaError = (cddaErr_None,
                  cddaErr_invalidPath,
                  cddaErr_invalidDrive,
                  cddaErr_invalidTrackNumber,
                  cddaErr_DriveNotReady,
                  cddaErr_NoAudioTrack,
                  cddaErr_Cancelled,
                  cddaErr_Unknown
                  );

    TCDTrackData = record
      Title    : String;
      Artist   : String;
      Album    : String;
      Duration : Integer;
      Track    : Integer;
      Year     : String;
      Genre    : String;
      CddbID   : UTF8String;
    end;


    TCDDADrive = class
      private
        fCddbID  : UTF8String;
        fIndex         : Integer;
        fIsCompilation : Boolean;
        fDelimter      : Char;
        fCDTextTitles: TStringList;
        fCDDBTitles: TStringList;
        fPreferOnline: Boolean;
        fVendor   : AnsiString;
        fProduct  : AnsiString;
        fRevision : AnsiString;
        fLetter   : Char;
        fOutOfDate: Boolean;

        function GetCDTextInformation: TCddaError;
        function GetCDDBInformation: TCddaError;
        function GetLocalCDDBInformation: Boolean;
        function GetTrackDataCDText(TrackNumber: Integer; var TrackData: TCDTrackData): Boolean;
        function GetTrackDataCDDB(TrackNumber: Integer; var TrackData: TCDTrackData): Boolean;
        procedure CheckForCompilation;
      public
        property Vendor   : AnsiString read fVendor;
        property Product  : AnsiString read fProduct;
        property Revision : AnsiString read fRevision;
        property Letter   : Char read fLetter;
        property OutOfDate: Boolean read fOutOfDate write fOutOfDate;

        constructor Create;
        destructor Destroy; override;
        procedure ClearDiscInformation;
        function GetDiscInformation(CheckOnline, PreferOnline: Boolean): TCddaError;
        class function GetTrackNumber(aPath: String): Integer;
        class function GetDriveNumber(aPath: String): Integer;
        class function GetDriveCDDBID(aPath: String): UTF8String;
        function GetTrackData(TrackNumber: Integer; var TrackData: TCDTrackData): Boolean; overload;
        function GetTrackData(Path: String; var TrackData: TCDTrackData): Boolean; overload;
    end;

    TCDDADriveList = class(TObjectList<TCDDADrive>);
    TCDDBCacheDict = class(TObjectDictionary<string, TStringList>);

    function CDDriveList: TCDDADriveList;
    function LocalCDDBData: TCDDBCacheDict;

    procedure AddLocalCDDBData(cdID: String; cdData: TStringList);
    procedure RemoveLocalCDDBData(aDrive: TCDDADrive);//   (cdID: String);
    procedure ClearAllLocalCDDBData;

    procedure UpdateDriveList;

    function BassErrorToCDError(aError: Integer): TCddaError;
    function SameDrive(A, B: String): Boolean;
    function CoverFilenameFromCDDA(aPath: String): String;
    function CddbIDFromCDDA(aPath: String): String;

    procedure ClearCDDriveData;
    // When adding some file to the Playlist (by Drag&Drop, Copy&Paste), the DiskInformation should be refreshed.
    // But only once per "Action", not per every file. Therefore, the CDDB-Data should be marked as deprecated. If
    // a file on a deprecated CD-Drive is found, it will refresh it's Disk-Information, and remove the mark.
    procedure MarkCDDriveDataAsDeprecated;

    function ValidEMail(aMail: String): Boolean;
    function GenerateCDDBHello(Mail: String): String;
    procedure BASS_ApplyCDDBSettings(Server: String; EMail: String);


implementation

uses
  System.RegularExpressions, Nemp_ConstantsAndTypes;

var
  fCDDriveList: TCDDADriveList;
  fLocalCDDBData: TCDDBCacheDict;

procedure FillDriveList;
var cdi : BASS_CD_INFO ;
    newCDDrive: TCDDADrive;
    idx: Integer;
begin
  idx := 0;
  while (idx < MAXDRIVES) and BASS_CD_GetInfo(idx, cdi) do begin
      newCDDrive := TCDDADrive.Create;
      newCDDrive.fVendor    := cdi.vendor;
      newCDDrive.fProduct   := cdi.product;
      newCDDrive.fRevision  := cdi.rev;
      newCDDrive.fLetter    := Char(cdi.letter + Ord('A'));
      newCDDrive.fIndex    := idx;
      fCDDriveList.Add(newCDDrive);
      inc(idx);
  end;
end;

procedure LoadCachedCDDBData;
var
  allData, cdData: TStringList;
  cdID: String;
  iLine: Integer;
begin
  if FileExists(NempSettingsManager.SavePath + 'CDDBCache.ncd') then begin
    allData := TStringList.Create;
    try
      iLine := 0;
      allData.LoadFromFile(NempSettingsManager.SavePath + 'CDDBCache.ncd', TEnCoding.UTF8);
      while iLine < allData.Count do begin
        if trim(allData[iLine]) = '<CDDBEntry>' then begin
          inc(iLine);
          // the next line contains the ID of this CD entry
          cdID := allData[iLine];
          inc(iLine);
          // the following lines contains the CD Data
          cdData := TStringList.Create;
          while trim(allData[iLine]) <> '</CDDBEntry>' do begin
            cdData.Add(allData[iLine]);
            inc(iLine);
          end;
          fLocalCDDBData.AddOrSetValue(cdID, cdData);
          inc(iLine); // should be the next '<CDDBEntry>'
        end;
      end;
    finally
      allData.Free;
    end;
  end;
end;

procedure SaveCachedCDDBData;
var
  allData: TStringList;
  iCD: String;
begin
  allData := TStringList.Create;
  try
    for iCD in fLocalCDDBData.Keys do begin
      allData.Add('<CDDBEntry>');
      allData.Add(iCD);
      allData.AddStrings(fLocalCDDBData[iCD]);
      allData.Add('</CDDBEntry>');
    end;
    allData.SaveToFile(NempSettingsManager.SavePath + 'CDDBCache.ncd', TEnCoding.UTF8);
  finally
    allData.Free;
  end;
end;

procedure AddLocalCDDBData(cdID: String; cdData: TStringList);
var
  DataCopy: TStringList;
  i: Integer;
begin
  DataCopy := TStringList.Create;
  // remove the comment section from the original data
  for i := 0 to cdData.Count - 1 do
    if (cdData[i] <> '') and (cdData[i][1] <> '#')  then
      DataCopy.Add(cdData[i]);

  LocalCDDBData.AddOrSetValue(cdID, DataCopy);
  SaveCachedCDDBData;
end;

procedure RemoveLocalCDDBData(aDrive: TCDDADrive);
begin
  if LocalCDDBData.ContainsKey(String(aDrive.fCddbID)) then
    LocalCDDBData.Remove(String(aDrive.fCddbID))
end;

procedure ClearAllLocalCDDBData;
begin
  LocalCDDBData.Clear;
  SaveCachedCDDBData;
end;

function CDDriveList: TCDDADriveList;
begin
  if not assigned(fCDDriveList) then begin
    fCDDriveList := TCDDADriveList.Create(True);
    // Get list of available drives
    FillDriveList;
    // Initialize local Cache
    if not assigned(fLocalCDDBData) then begin
      fLocalCDDBData := TCDDBCacheDict.Create([doOwnsValues]);
      LoadCachedCDDBData;
    end;
  end;
  result := fCDDriveList;
end;


function LocalCDDBData: TCDDBCacheDict;
begin
  if not assigned(fLocalCDDBData) then begin
    fLocalCDDBData := TCDDBCacheDict.Create([doOwnsValues]);
    LoadCachedCDDBData;
  end;
  result := fLocalCDDBData;
end;


procedure UpdateDriveList;
begin
  // change 2022: Just start from scratch
  CDDriveList.Clear;
  FillDriveList;
end;

function BassErrorToCDError(aError: Integer): TCddaError;
begin
    case aError of
        BASS_ERROR_DEVICE   : result := cddaErr_InvalidDrive;
        BASS_ERROR_NOCD     : result := cddaErr_DriveNotReady;
        BASS_ERROR_CDTRACK  : result := cddaErr_invalidTrackNumber;
        BASS_ERROR_NOTAUDIO : result := cddaErr_NoAudioTrack;
    else
        result := cddaErr_Unknown;
    end;
end;

function SameDrive(A, B: String): Boolean;
begin
  result := TCDDADrive.GetDriveNumber(A) = TCDDADrive.GetDriveNumber(B);
end;


function CoverFilenameFromCDDA(aPath: String): String;
var
  aDrive: Integer;
begin
  aDrive := TCDDADrive.GetDriveNumber(aPath);
  if aDrive >= 0 then begin
    result := String(CDDriveList[aDrive].fCddbID);
    result := StringReplace(result, ' ', '-', [rfReplaceAll]);
    if Length(result) > 32 then
      SetLength(Result, 32);
  end;
end;

function CddbIDFromCDDA(aPath: String): String;
var
  aDrive: Integer;
begin
  aDrive := TCDDADrive.GetDriveNumber(aPath);
  result := String(BASS_CD_GetID(aDrive,BASS_CDID_CDDB));
end;


procedure ClearCDDriveData;
var
  i: Integer;
begin
  for i := 0 to CDDriveList.Count - 1 do
    CDDriveList[i].ClearDiscInformation;
end;

procedure MarkCDDriveDataAsDeprecated;
var
  i: Integer;
begin
  for i := 0 to CDDriveList.Count - 1 do
    CDDriveList[i].OutOfDate := True;
end;

function ValidEMail(aMail: String): Boolean;
begin
  Result := (trim(aMail) = '') or TRegEx.IsMatch(trim(aMail), REGEX_EMAIL);
end;

function GenerateCDDBHello(Mail: String): String;
var
  at: Integer;
  name, server: String;
begin
  at := Pos('@', Mail);
  name := Copy(Mail, 1, at-1);
  server := Copy(Mail, at+1, length(Mail));
  result := Format('"%s"+"%s"+%s', [name, server, CDDB_APPNAME]);
end;

procedure BASS_ApplyCDDBSettings(Server: String; EMail: String);
begin
  Server := trim(Server);
  EMail := trim(EMail);

  if Server = ''  then
    BASS_SetConfigPtr(BASS_CONFIG_CD_CDDB_SERVER or BASS_UNICODE, pChar(CDDB_DEFAULT_SERVER))
  else
    BASS_SetConfigPtr(BASS_CONFIG_CD_CDDB_SERVER or BASS_UNICODE, pChar(Server));

  if ValidEMail(EMail) and (EMail <> '') then
    BASS_SetConfigPtr(BASS_CONFIG_CD_CDDB_HELLO or BASS_UNICODE, PChar(GenerateCDDBHello(EMail)))
  else
    BASS_SetConfigPtr(BASS_CONFIG_CD_CDDB_HELLO or BASS_UNICODE, PChar(GenerateCDDBHello(CDDB_DEFAULT_EMAIL)))
end;


{ TCDDADrive }

constructor TCDDADrive.Create;
begin
  inherited;
  fCDTextTitles := TStringList.Create;
  fCDDBTitles := TStringList.Create;
  fOutOfDate := True;
end;

destructor TCDDADrive.Destroy;
begin
  fCDTextTitles.Free;
  fCDDBTitles.Free;
  inherited;
end;

procedure TCDDADrive.CheckForCompilation;
var
  i: integer;
  cMinus, cSlash, c: Integer;
begin
  fIsCompilation := False;
  cMinus := 0;
  cSlash := 0;
  c := 0;

  for i := 0 to fCDDBTitles.Count - 1 do
  begin
      if AnsiStartstext('TTITLE', fCDDBTitles[i]) then
      begin
          c := c + 1;
          if pos(' - ', fCDDBTitles[i]) > 0 then
              cMinus := cMinus + 1;
          if pos(' / ', fCDDBTitles[i]) > 0 then
              cSlash := cSlash + 1;
      end;
  end;

  if cSlash >= c-2 then
  begin
      fIsCompilation := True;
      fDelimter := '/';
  end else
  if cMinus >= c-2 then
  begin
      fIsCompilation := True;
      fDelimter := '-';
  end;

end;

function TCDDADrive.GetCDTextInformation: TCddaError;
var
  pData: PAnsiChar;
begin
  result := cddaErr_None;
  pData := BASS_CD_GetID(fIndex, BASS_CDID_TEXT);
  if pData <> Nil then begin
    fCDTextTitles.Clear;
    while (trim(String(pData)) <> '') do begin
      fCDTextTitles.Add(String(pData));
      pData := pData + Length(pData) + 1 ;
    end;
  end else
    result := BassErrorToCDError(BASS_ErrorGetCode)
end;

function TCDDADrive.GetLocalCDDBInformation: Boolean;
begin
  if LocalCDDBData.ContainsKey(String(fCddbID)) then begin
    fCDDBTitles.Clear;
    fCDDBTitles.AddStrings(LocalCDDBData[String(fCddbID)]);
    CheckForCompilation;
    result := True;
  end else
    result := False;
end;

function TCDDADrive.GetCDDBInformation: TCddaError;
var
  queryReply, tmpCddbData: UTF8String;
begin
    result := cddaErr_None;
    // the fCachedCddbID := BASS_CD_GetID(fIndex, BASS_CDID_CDDB); is needed anyway, even if we don't want to query the cddb online
    // This ID should have been calculated before calling this method.
    if fCddbID = '' then
      exit;

    // first: Try to get Data from local Cache
    if not GetLocalCDDBInformation then begin
          // ID is not cached in local data yet. Search it online!
          // 1. Query general Information about the Disc.
          // Return value may be used for the next query BASS_CDID_CDDB_READ
          queryReply := BASS_CD_GetID(fIndex, BASS_CDID_CDDB_QUERY);
                // Example reply:
                //    210 Found exact matches, list follows (until terminating `.')
                //    soundtrack 9a09340d Pink Floyd / 1979 - The Wall (Disc 01)
                //    rock 9a09340d Pink Floyd / THE WALL  (Shine On Box)  - CD 1 (1992)
                //    .
          if queryReply = '' then
            result := BassErrorToCDError(BASS_ErrorGetCode)
          else begin
              if AnsiStartsText('200', String(queryReply)) then begin
                // only one entry for this disc is found in the online database
                tmpCddbData := BASS_CD_GetID(fIndex, BASS_CDID_CDDB_READ + 0);
                if tmpCddbData = '' then
                  result := BassErrorToCDError(BASS_ErrorGetCode)
                else
                  fCDDBTitles.Text := String(tmpCddbData);
              end
              else begin
                if AnsiStartsText('210', String(queryReply))
                    or AnsiStartsText('211', String(queryReply))
                then begin
                    // more than one entry for this disc is found.
                    // User selection needed
                    if not assigned(FormCDDBSelect) then
                      Application.CreateForm(TFormCDDBSelect, FormCDDBSelect);
                    FormCDDBSelect.FillView(queryReply);

                    if (not FormCDDBSelect.Visible) and (FormCDDBSelect.ShowModal = mrOK) then begin
                      tmpCddbData := BASS_CD_GetID(fIndex, BASS_CDID_CDDB_READ + FormCDDBSelect.SelectedEntry);
                      if tmpCddbData = '' then
                        result := BassErrorToCDError(BASS_ErrorGetCode)
                      else
                        fCDDBTitles.Text := String(tmpCddbData);
                    end
                    else begin
                      // canceled by user
                      fCDDBTitles.Clear;
                      result := cddaErr_Cancelled;
                    end;
                end else
                begin
                    // some error occured
                    fCDDBTitles.Clear;
                    result := cddaErr_Unknown;
                end;
              end;
              if result = cddaErr_None then begin
                AddLocalCDDBData(String(fCddbID), fCDDBTitles);
                CheckForCompilation;
              end;
          end;
    end;  // not GetLocalCDDBInformation
end;

procedure TCDDADrive.ClearDiscInformation;
begin
  fCDTextTitles.Clear;
  fCDDBTitles.Clear;
  fCddbID := '';
  fIsCompilation := False;
  fPreferOnline := False;
  fDelimter := #0;
  fOutOfDate := True;
end;

function TCDDADrive.GetDiscInformation(CheckOnline, PreferOnline: Boolean): TCddaError;
var
  tmpResult: TCddaError;
begin
  fOutOfDate := False;
  result := cddaErr_None;

  if UTf8String(BASS_CD_GetID(fIndex, BASS_CDID_CDDB)) = fCddbID then
    exit;   // nothing has changed

  ClearDiscInformation;

  fPreferOnline := PreferOnline;

  fCddbID := BASS_CD_GetID(fIndex, BASS_CDID_CDDB);
  if fCddbID = '' then
    result := BassErrorToCDError(BASS_ErrorGetCode);

  // Get MetaData for the current Disc in the Drive
  tmpResult := GetCDTextInformation;
  if result = cddaErr_None then
    result := tmpResult;

  if PreferOnline or ((fCDTextTitles.Count = 0) and CheckOnline) then begin
    tmpResult := GetCDDBInformation;
    if result = cddaErr_None then
      result := tmpResult;
  end;

  fOutOfDate := False;
end;

class function TCDDADrive.GetDriveNumber(aPath: String): Integer;
var
  i: integer;
begin
  result := -1;
  if length(aPath) = 0 then
    exit;

  for i := 0 to CDDriveList.Count - 1 do begin
    if CDDriveList[i].Letter = aPath[1] then begin
      result := i;
      break;
    end;
  end;
end;

class function TCDDADrive.GetDriveCDDBID(aPath: String): UTF8String;
var
  idx: Integer;
begin
  idx := TCDDADrive.GetDriveNumber(aPath);
  if idx >= 0 then
    result := CDDriveList[idx].fCddbID
  else
    result := '';
end;

class function TCDDADrive.GetTrackNumber(aPath: String): Integer;
var
  i: Integer;
  numberString: String;
  numberFound: Boolean;
begin
  numberString := '';
  numberFound := False;
  for i := 1 to length(aPath) do begin
    if CharInSet(apath[i], ['0','1','2','3','4','5','6','7','8','9']) then begin
      numberFound := True;
      numberString := numberString + aPath[i];
    end else begin
      if numberFound then
          break;
    end;
  end;
  result := StrToIntDef(numberString, -1);
end;

function TCDDADrive.GetTrackDataCDText(TrackNumber: Integer; var TrackData: TCDTrackData): Boolean;
begin
  result := fCDTextTitles.Count > 0;

  if result then begin
    TrackData.Genre := '';
    TrackData.Year  := '';
    TrackData.Album := fCDTextTitles.Values['TITLE0'];
    TrackData.Title := fCDTextTitles.Values['TITLE' + IntToStr(TrackNumber)];
    TrackData.Artist := fCDTextTitles.Values['PERFORMER' + IntToStr(TrackNumber)];
    if TrackData.Artist = '' then
      TrackData.Artist := fCDTextTitles.Values['PERFORMER0'];
    //if AnsiStartsText(fArtist, fAlbum) then
    //    fAlbum := Trim(StringReplace(fAlbum, fArtist, '', [rfReplaceAll]));
  end;
end;

function TCDDADrive.GetTrackDataCDDB(TrackNumber: Integer; var TrackData: TCDTrackData): Boolean;
var
  discTitle, TrackTitle: String;
  idx: Integer;
begin
  result := fCDDBTitles.Count > 0;
  if result then begin
    TrackData.Genre := fCDDBTitles.Values['DGENRE'];
    TrackData.Year  := fCDDBTitles.Values['DYEAR'];

    discTitle := fCDDBTitles.Values['DTITLE'];
    idx := Pos(' / ', discTitle);
    // if idx = 0 then
    //    idx := Pos(' - ', tmp);
    if idx > 0 then begin
      TrackData.Album  := Copy(discTitle, idx + 3, Length(discTitle));
      TrackData.Artist := Copy(discTitle, 1, idx);
    end else
      TrackData.Album := discTitle;

    if fIsCompilation then begin
      // Get Title and Artist, Track numbering starts with 0 here
      TrackTitle := fCDDBTitles.Values['TTITLE' + IntToStr(TrackNumber - 1)];
      idx := Pos(' ' + fDelimter + ' ', TrackTitle);
      TrackData.Title := Copy(TrackTitle, idx + 3, Length(TrackTitle));
      TrackData.Artist := Copy(TrackTitle, 1, idx);
    end else
      TrackData.Title := fCDDBTitles.Values['TTITLE' + IntToStr(TrackNumber - 1)];
  end;
end;

function TCDDADrive.GetTrackData(TrackNumber: Integer; var TrackData: TCDTrackData): Boolean;
var
  ByteLength: DWord;
  success: Boolean;
begin
  // reset TrackData
  TrackData.Title    := 'Track' + IntToStr(TrackNumber);
  TrackData.Artist   := '';
  TrackData.Album    := '';
  TrackData.Duration := 0;
  TrackData.Track    := -1;
  TrackData.Year     := '';
  TrackData.Genre    := '';
  TrackData.CddbID   := fCddbID;

  ByteLength := BASS_CD_GetTrackLength(fIndex, TrackNumber - 1); // This method wants Track=0 for the first track
  if ByteLength = High(DWord) then begin
    result := False;
  end else begin
    result := True;
    TrackData.Duration := ByteLength Div 176400;
    TrackData.Track := TrackNumber;
    TrackData.CddbID := fCddbID;

    if fPreferOnline then begin // fPreferOnline is set during GetDiscInformation()
      success := GetTrackDataCDDB(TrackNumber, TrackData);
      if not success then
        GetTrackDataCDText(TrackNumber, TrackData);
    end else begin
      success := GetTrackDataCDText(TrackNumber, TrackData);
      if not success then
        GetTrackDataCDDB(TrackNumber, TrackData);
    end;
  end;
end;

function TCDDADrive.GetTrackData(Path: String; var TrackData: TCDTrackData): Boolean;
begin
  TrackData.Track := GetTrackNumber(Path);
   if TrackData.Track >= 0 then
     result := GetTrackData(TrackData.Track, TrackData)
   else
    result := False;
end;

initialization

  fCDDriveList := Nil;
  fLocalCDDBData := Nil;

finalization

  if assigned(fCDDriveList) then
    fCDDriveList.Free;

  if assigned(fLocalCDDBData) then
    fLocalCDDBData.Free;

end.
