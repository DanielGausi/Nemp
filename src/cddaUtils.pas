unit cddaUtils;

interface

uses  Windows, Forms, Messages, SysUtils, Variants, ContNrs, Classes, StrUtils,
      bass, basscd, CDSelection, Controls,
      System.Generics.Defaults, System.Generics.Collections;

const
  MAXDRIVES = 10;  // maximum number auf CDDA-Drives

  CDDB_DEFAULT_SERVER = 'gnudb.gnudb.org';
  CDDB_DEFAULT_EMAIL = 'nemp@gausi.de';
  CDDB_APPNAME = 'nemp+5.0';

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
      CddbID   : String;
    end;


    TCDDADrive = class
      private
        fCachedCDTextData: AnsiString;
        fCachedCddbData: UTF8String;
        fCachedCddbID  : UTF8String;
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
        function GetCDDBInformation: TCddaError; //AnsiString;
        procedure ConvertCDTextData(Data: PAnsiChar);
        procedure ConvertCDDBData;
        function GetTrackDataCDText(TrackNumber: Integer; var TrackData: TCDTrackData): Boolean;
        function GetTrackDataCDDB(TrackNumber: Integer; var TrackData: TCDTrackData): Boolean;
      public
        property Vendor   : AnsiString read fVendor;
        property Product  : AnsiString read fProduct;
        property Revision : AnsiString read fRevision;
        property Letter   : Char read fLetter;
        property OutOfDate: Boolean read fOutOfDate write fOutOfDate;

        constructor Create;
        destructor Destroy; override;

        procedure Assign(aDrive: TCDDADrive);
        procedure ClearDiscInformation;
        function GetDiscInformation(CheckOnline, PreferOnline: Boolean): TCddaError;
        procedure CheckForCompilation(aData: UTF8String);
        class function GetTrackNumber(aPath: String): Integer;
        class function GetDriveNumber(aPath: String): Integer;
        class function GetDriveCDDBID(aPath: String): UTF8String;
        function GetTrackData(TrackNumber: Integer; var TrackData: TCDTrackData): Boolean; overload;
        function GetTrackData(Path: String; var TrackData: TCDTrackData): Boolean; overload;
    end;

    TCDDADriveList = class (TObjectList<TCDDADrive>);

    function CDDriveList: TCDDADriveList;
    procedure UpdateDriveList;

    function BassErrorToCDError(aError: Integer): TCddaError;
    function SameDrive(A, B: String): Boolean;
    function CoverFilenameFromCDDA(aPath: String): String;
    function CddbIDFromCDDA(aPath: String): String;

    procedure ClearCDDBCache;
    // When adding some file to the Playlist (by Drag&Drop, Copy&Paste), the DiskInformation should be refreshed.
    // But only once per "Action", not per every file. Therefore, the CDDB-Cache should be marked as Deprecated. If
    // a file on a deprecated CD-Drive is found, it will refresh it's Disk-Information, and remove the mark.
    procedure MarkCDDBCacheAsDeprecated;

    function ValidEMail(aMail: String): Boolean;
    function GenerateCDDBHello(Mail: String): String;
    procedure BASS_ApplyCDDBSettings(Server: String; EMail: String);


implementation

uses
  System.RegularExpressions;

var
  fCDDriveList: TCDDADriveList;

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

function CDDriveList: TCDDADriveList;
begin
  if not assigned(fCDDriveList) then begin
    fCDDriveList := TCDDADriveList.Create(True);
    // Get list of available drives
    FillDriveList;
  end;
  result := fCDDriveList;
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
    result := CDDriveList[aDrive].fCachedCddbID;
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


procedure ClearCDDBCache;
var
  i: Integer;
begin
  for i := 0 to CDDriveList.Count - 1 do
    CDDriveList[i].ClearDiscInformation;
end;

procedure MarkCDDBCacheAsDeprecated;
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

procedure TCDDADrive.Assign(aDrive: TCDDADrive);
begin
    fCachedCDTextData := aDrive.fCachedCDTextData;
    fCachedCddbData := aDrive.fCachedCddbData;
    fCachedCddbID   := aDrive.fCachedCddbID  ;
    fIndex          := aDrive.fIndex         ;
    fIsCompilation  := aDrive.fIsCompilation ;
    fDelimter       := aDrive.fDelimter      ;
    fVendor          := aDrive.Vendor        ;
    fProduct         := aDrive.Product       ;
    fRevision        := aDrive.Revision      ;
    fLetter          := aDrive.Letter        ;
end;

procedure TCDDADrive.CheckForCompilation(aData: UTF8String);
var sl: TStringList;
    i: integer;
    cMinus, cSlash, c: Integer;
begin
    fIsCompilation := False;
    cMinus := 0;
    cSlash := 0;
    c := 0;

    sl := TStringList.Create;
    try
        sl.Text := String(aData);
        for i := 0 to sl.Count - 1 do
        begin
            if AnsiStartstext('TTITLE', sl[i]) then
            begin
                c := c + 1;
                if pos(' - ', sl[i]) > 0 then
                    cMinus := cMinus + 1;
                if pos(' / ', sl[i]) > 0 then
                    cSlash := cSlash + 1;
            end;
        end;

        if cSlash >= c-2 then
        begin
            fIsCompilation := True;
            self.fDelimter := '/';
        end else
        if cMinus >= c-2 then
        begin
            fIsCompilation := True;
            self.fDelimter := '-';
        end;
    finally
        sl.Free;
    end;

end;

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

procedure TCDDADrive.ConvertCDTextData(Data: PAnsiChar);
begin
  { quote from the BASS_CD Help file:
    When requesting CD-TEXT, a series of null-terminated strings is returned (the final string ending in a double null),
    in the form of "tag=text". The following is a list of all the possible tags. Where <t> is shown, that represents the
    track number, with "0" being the whole disc/album. For example, "TITLE0" is the album title, while "TITLE1" is the
    title of the first track.
  }
  fCDTextTitles.Clear;
  while (trim(String(Data)) <> '') do begin
    fCDTextTitles.Add(String(Data));
    Data := Data + Length(Data) + 1 ;
  end;
end;

procedure TCDDADrive.ConvertCDDBData;
begin
  fCDDBTitles.Text := String(fCachedCddbData);
end;

function TCDDADrive.GetCDTextInformation: TCddaError;
var
  pData: PAnsiChar;
begin
  result := cddaErr_None;
  pData := BASS_CD_GetID(fIndex, BASS_CDID_TEXT);
  if pData <> Nil then begin
    ConvertCDTextData(pData);
    fCachedCDTextData := self.fCDTextTitles.Text;
  end else
    result := BassErrorToCDError(BASS_ErrorGetCode)
end;

function TCDDADrive.GetCDDBInformation: TCddaError;
var queryReply: UTF8String;

begin
    result := cddaErr_None;
    // the fCachedCddbID := BASS_CD_GetID(fIndex, BASS_CDID_CDDB); is needed anyway, even if we don't want to query the cddb online
    // This ID should have been calculated before calling this method.
    if fCachedCddbID = '' then
      exit;

    // get new DATA
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
          fCachedCddbData := BASS_CD_GetID(fIndex, BASS_CDID_CDDB_READ + 0);
          if fCachedCddbData = '' then
            result := BassErrorToCDError(BASS_ErrorGetCode)
          else
            ConvertCDDBData;
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

              if FormCDDBSelect.ShowModal = mrOK then begin
                fCachedCddbData := BASS_CD_GetID(fIndex, BASS_CDID_CDDB_READ + FormCDDBSelect.SelectedEntry);
                if fCachedCddbData = '' then
                  result := BassErrorToCDError(BASS_ErrorGetCode)
                else
                  ConvertCDDBData;
              end
              else begin
                // canceled by user
                fCachedCddbData := '';
                result := cddaErr_Cancelled;
              end;
          end else
          begin
              // some error occured
              fCachedCddbData := '';
              result := cddaErr_Unknown;
          end;
        end;
        if result = cddaErr_None then
          CheckForCompilation(fCachedCddbData);
    end;
end;

procedure TCDDADrive.ClearDiscInformation;
begin
  fCDTextTitles.Clear;
  fCDDBTitles.Clear;
  fCachedCDTextData := '';
  fCachedCddbData := '';
  fCachedCddbID := '';
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

  if BASS_CD_GetID(fIndex, BASS_CDID_CDDB) = fCachedCddbID then
    exit;   // nothing has changed

  ClearDiscInformation;

  fPreferOnline := PreferOnline;

  fCachedCddbID := BASS_CD_GetID(fIndex, BASS_CDID_CDDB);
  if fCachedCddbID = '' then
    result := BassErrorToCDError(BASS_ErrorGetCode);

  // Get MetaData for the current Disc in the Drive
  tmpResult := GetCDTextInformation;
  if result = cddaErr_None then
    result := tmpResult;

  if PreferOnline or ((fCachedCDTextData = '') and CheckOnline) then begin
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
    result := CDDriveList[idx].fCachedCddbID
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
  TrackData.CddbID   := fCachedCddbID;

  ByteLength := BASS_CD_GetTrackLength(fIndex, TrackNumber - 1); // This method wants Track=0 for the first track
  if ByteLength = High(DWord) then begin
    result := False;
  end else begin
    result := True;
    TrackData.Duration := ByteLength Div 176400;
    TrackData.Track := TrackNumber;
    TrackData.CddbID := fCachedCddbID;

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

finalization

  if assigned(fCDDriveList) then
    fCDDriveList.Free;

end.
