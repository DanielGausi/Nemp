unit cddaUtils;

interface

uses  Windows, Messages, SysUtils, Variants, ContNrs, Classes, StrUtils,
      bass, basscd;

const MAXDRIVES = 10;  // maximum number auf CDDA-Drives

type
    TCddaError = (cddaErr_None,
                  cddaErr_invalidPath,
                  cddaErr_invalidDrive,
                  cddaErr_invalidTrackNumber,
                  cddaErr_DriveNotReady,
                  cddaErr_NoAudioTrack

                  );

    TCDDADrive = class
        public
            Vendor   : AnsiString;
            Product  : AnsiString;
            Revision : AnsiString;
            Letter   : Char;
    end;

    TCDDAFile = class
        private
            fTitle    : String;
            fArtist   : String;
            fAlbum    : String;
            fDuration : Integer;
            fTrack    : Integer;

            fDriveLetter : Char;
            fDriveNumber : Integer;

            function fGetDriveChar(aPath: String): Char;
            function fGetDriveNumber(aDriveChar: Char): Integer;

            function fGetTrackNumber(aPath: String): Integer;

            function fGetDataFromCDText(aDrive, aTrack: Integer): Boolean;


        public
            property Title    : String  read fTitle     ;
            property Artist   : String  read fArtist    ;
            property Album    : String  read fAlbum     ;
            property Duration : Integer read fDuration  ;
            property Track    : Integer read fTrack     ;

            constructor Create;

            function GetData(aPath: String; UseCDDB: Boolean): TCddaError;

    end;

    procedure EnsureDriveListIsFilled;
    function BassErrorToCDError(aError: Integer): TCddaError;

    function SameDrive(A, B: String): Boolean;
    function AudioDriveNumber(aPath: String): Integer;



var
    CDDriveList: TObjectList;



implementation

procedure EnsureDriveListIsFilled;
var cdi : BASS_CD_INFO ;
    newCDDrive: TCDDADrive;
    idx: Integer;
begin
    if not assigned(CDDriveList) then
    begin
        CDDriveList := TObjectList.Create(True);

        // Get list of available drives
        idx := 0;
        while (idx < MAXDRIVES) and BASS_CD_GetInfo(idx, cdi) do
        begin
            newCDDrive := TCDDADrive.Create;
            newCDDrive.Vendor    := cdi.vendor;
            newCDDrive.Product   := cdi.product;
            newCDDrive.Revision  := cdi.rev;
            newCDDrive.Letter    := Char(cdi.letter + Ord('A'));

            CDDriveList.Add(newCDDrive);
            inc(idx);
        end;
    end;
end;

function BassErrorToCDError(aError: Integer): TCddaError;
begin
    case aError of
        BASS_ERROR_DEVICE   : result := cddaErr_InvalidDrive;
        BASS_ERROR_NOCD     : result := cddaErr_DriveNotReady;
        BASS_ERROR_CDTRACK  : result := cddaErr_invalidTrackNumber;
        BASS_ERROR_NOTAUDIO : result := cddaErr_NoAudioTrack;
    end;
end;

function SameDrive(A, B: String): Boolean;
var cd: TCDDAFile;
    DriveA: Char;
begin
    cd := TCDDAFile.Create;
    try
        DriveA := cd.fGetDriveChar(A);
        result := DriveA = cd.fGetDriveChar(B);
    finally
        cd.Free;
    end;
end;

function AudioDriveNumber(aPath: String): Integer;
var cd: TCDDAFile;
    DriveA: Char;
begin
    cd := TCDDAFile.Create;
    try
        if cd.fGetDriveChar(aPath) <> #0 then
            // Get DriveNumber from DriveLetter
            result := cd.fGetDriveNumber(cd.fDriveLetter)
        else
            result := -1;
    finally
        cd.Free;
    end;
end;




{ TCDDAFile }


{
    --------------------------------------------------------
    fGetDriveChar
    Get the driveChar X from a Path.
    Possible formats:  "X:\TrackYY.cda" or "cd(d)a://X,Y"
    --------------------------------------------------------
}
function TCDDAFile.fGetDriveChar(aPath: String): Char;
var idx: Integer;
begin
    idx := pos('://', aPath);

    if (idx > 0) then
    begin
        if length(aPath) >= idx + 3 then
            fDriveLetter := aPath[idx+3]
        else
            fDriveLetter := #0;  // invalid Path
    end else
    begin
        if length(aPath) > 0 then
            fDriveLetter := aPath[1]
        else
            fDriveLetter := #0; // invalid Path
    end;

    result := fDriveLetter;
end;

{
    --------------------------------------------------------
    fGetTrackNumber
    Get the TrackNumber Y from a Path
    Possible formats: "X:\TrackYY.cda" or "cd(d)a://X,Y"
    --------------------------------------------------------
}
function TCDDAFile.fGetTrackNumber(aPath: String): Integer;
var i: Integer;
    numberString: String;
    numberFound: Boolean;
begin
    numberString := '';
    numberFound := False;
    for i := 1 to length(aPath) do
    begin
        if aPath[i] in ['0','1','2','3','4','5','6','7','8','9'] then
        begin
            numberFound := True;
            numberString := numberString + aPath[i];
        end else
        begin
            if numberFound then
                break;
        end;
    end;

    fTrack := StrToIntDef(numberString, -1);
    result := fTrack;
end;

{
    --------------------------------------------------------
    fGetDriveNumber
    Get the driveNumber for a fiven DriveLetter
    --------------------------------------------------------
}
function TCDDAFile.fGetDriveNumber(aDriveChar: Char): Integer;
var i: integer;
begin
    fDriveNumber := -1;
    for i := 0 to CDDriveList.Count - 1 do
    begin
        if TCDDADrive(CDDriveList[i]).Letter = aDriveChar then
        begin
            fDriveNumber := i;
            break;
        end;
    end;
    result := fDriveNumber;
end;

{
    --------------------------------------------------------
    fGetDataFromCDText
    Get Artist/Titel/Album from CD-Text
    --------------------------------------------------------
}
constructor TCDDAFile.Create;
begin
    // Get List of all Drives, if not already done
    EnsureDriveListIsFilled;
end;

function TCDDAFile.fGetDataFromCDText(aDrive, aTrack: Integer): Boolean;
var CompleteText: PAnsiChar;
    OneEntry: PAnsiChar;

      function GetValue(aKey: AnsiString; aText: PAnsiChar): AnsiString;
      var tmp: PAnsiChar;
      begin
          result := '';
          tmp := aText;
          while (trim(tmp) <> '') do
          begin
              if AnsiStartsText(aKey, tmp) then
              begin
                  // we found the entry
                  result := Copy(tmp, Length(aKey)+2, Length(tmp) - Length(aKey));
                  break;
              end;
              tmp := tmp + Length(tmp) +1 ;
          end;
      end;

begin
    CompleteText := BASS_CD_GetID(aDrive, BASS_CDID_TEXT);
    if CompleteText <> NIL then
    begin
        result := True;
        fAlbum := GetValue('TITLE0', CompleteText);
        fTitle := GetValue('TITLE'+IntToStr(aTrack), CompleteText);
        fArtist:= GetValue('PERFORMER'+IntToStr(aTrack), CompleteText);
        if fArtist = '' then
            fArtist:= GetValue('PERFORMER0', CompleteText); // Album-Artist
    end else
        result := False;
end;


function TCDDAFile.GetData(aPath: String; UseCDDB: Boolean): TCddaError;
var ByteLength: DWord;
begin

    // Get DriveLetter from Path
    if fGetDriveChar(aPath) <> #0 then
    begin
        // Get DriveNumber from DriveLetter
        if fGetDriveNumber(fDriveLetter) > -1 then
        begin
            if fGetTrackNumber(aPath) > -1 then
            begin
                // we found the DriveNr and TrackNr for this file, which is needed for the bass-cd-methods
                if BASS_CD_IsReady(fDriveNumber) then
                begin
                    // Get Duration
                    ByteLength := BASS_CD_GetTrackLength(fDriveNumber, fTrack-1); // This method wants Track=0 for the first track ;-)
                    if ByteLength = High(DWord) then
                        result := BassErrorToCDError(BASS_ErrorGetCode)
                    else
                    begin
                        // There is a CD, the track is valid. So: we can finally begin to check for
                        // some more information
                        result := cddaErr_None;
                        // CD audio is always 44100hz stereo 16-bit. That is 176400 bytes per second.
                        fDuration := ByteLength Div 176400;

                        fGetDataFromCDText(fDriveNumber, fTrack);

                    end;
                end else
                    result := cddaErr_DriveNotReady;
            end else
                result := cddaErr_invalidTrackNumber;
        end else
            result := cddaErr_invalidDrive;
    end else
        result := cddaErr_invalidPath;
end;

initialization

    CDDriveList := Nil;

finalization

    if assigned(CDDriveList) then
        CDDriveList.Free;

end.
