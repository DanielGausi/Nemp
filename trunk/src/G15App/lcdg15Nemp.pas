unit lcdg15Nemp;

interface

uses
    Windows, SysUtils, StrUtils, Classes, Graphics, Controls, ExtCtrls, ShlObj,
    ActiveX, iniFiles, nempApi, lcdg15;


type TNempG15Applet = class(TObject)
    private
        ResetTimer: TTimer;
        CurrentFileName: UnicodeString;
        CurrentTitle: UnicodeString;
        CurrentFileScrolling: Boolean;
        CurrentFileScrollPos: Integer;
        CurrentTrackLength: Integer;
        CurrentTrackLengthString: String;
        CurrentPlayListPos: Integer;
        CurrentPlayListPosMin: Integer;
        CurrentPlayListPosMax: Integer;

        fSavePath: String;

        fStartPriority: Integer;   // Priority of the first SendToDisplay
        fDisplayPriority: Integer; //  Priority of the other SendToDisplay
        fStartWithNemp: Boolean;

        function GetOnConfig: TOnConfigureCB;
        procedure SetOnConfig(value: TOnConfigureCB);

        procedure ResetTimerTimer(Sender: TObject);

        procedure InitSettings;

    public
        MainBitmap: TBitmap;
        SplashImage: TBitmap;
        ControlImage: TImage;

        g15Display: TLcdG15;

        AppState: Integer;

        property OnConfig: TOnConfigureCB Read GetOnConfig write SetOnConfig;
        property StartPriority: Integer read fStartPriority write fStartPriority;
        property DisplayPriority: Integer read fDisplayPriority write fDisplayPriority;
        property StartWithNemp: Boolean read fStartWithNemp write fStartWithNemp;

        constructor Create;
        destructor Destroy; Override;

        procedure PaintIntro;
        procedure PaintCurrentTrackInfo;
        procedure PaintPlaylistPart;


        procedure myCallbackSoftButtons(dwButtons:integer);
        procedure SaveSettings;

end;

TAudioType = (at_Undef, at_File, at_Stream, at_CDDA, at_CUE);



implementation


function GetAudioTypeFromFilename(aFilename: String): TAudioType;
begin
    // determine AudioType
    if (pos('://', aFilename) > 0) then
    begin
        if AnsiStartsText('cda', aFilename)
            or AnsiStartsText('cdda', aFilename)
        then
            result := at_CDDA     // CD-Audio
        else
            result := at_Stream;  // Webradio
    end else
    begin
        if AnsiLowerCase(ExtractFileExt(aFilename)) = '.cda' then
            result := at_CDDA         // CD-Audio (.cda-File)
        else
            result := at_File         // File
    end;
end;

function IsExeInProgramSubDir: Boolean;
var p1: String;
begin
    result := false;
    p1 := IncludeTrailingPathDelimiter(GetEnvironmentVariable('ProgramFiles'));
    if AnsiStartsText(p1, ParamStr(0)) then
        result := true
    else
    begin
        p1 := GetEnvironmentVariable('ProgramW6432');
        if p1 <> '' then
            result := AnsiStartsText(IncludeTrailingPathDelimiter(p1), ParamStr(0));
    end;
end;

function GetShellFolder(CSIDL: integer): string;
var
  pidl              : PItemIdList;
  FolderPath        : string;
  SystemFolder      : Integer;
  Malloc            : IMalloc;
begin
  Malloc := nil;
  FolderPath := '';
  SHGetMalloc(Malloc);
  if Malloc = nil then
  begin
    Result := FolderPath;
    Exit;
  end;
  try
    SystemFolder := CSIDL;
    if SUCCEEDED(SHGetSpecialFolderLocation(0, SystemFolder, pidl)) then
    begin
      SetLength(FolderPath, max_path);
      if SHGetPathFromIDList(pidl, PChar(FolderPath)) then
      begin
        SetLength(FolderPath, length(PChar(FolderPath)));
      end;
    end;
    Result := FolderPath;
  finally
    Malloc.Free(pidl);
  end;
end;



// From: http://www.delphipraxis.net/37489-microsoft-cleartype-ein-aus.html
procedure ChangeCleartype(canvas:Tcanvas;ClearType:boolean);
var
  lf: TLogFont;
  tf: TFont;
begin
  tf := Tfont.create;
  try
    tf.Assign(canvas.font);
    GetObject(tf.Handle, sizeof(lf), @lf);
    if ClearType then
      lf.lfQuality := DEFAULT_QUALITY
    else
      lf.lfQuality := NONANTIALIASED_QUALITY;
    tf.Handle := CreateFontIndirect(lf);
    canvas.font.assign(tf);
  finally
    tf.Free;
  end;
end;

function SekIntToMinStr(sek: integer): string;
begin
    result := inttostr(sek DIV 60);
    sek := sek Mod 60;
    if sek < 10 then
        result := result + ':0' + inttostr(sek)
    else
        result:=result + ':' + inttostr(sek);
end;



{ TNempG15Applet }


// callback for Config: Should be done in MainForm, so use a property here
constructor TNempG15Applet.Create;
begin

    InitSettings;

    MainBitmap := TBitmap.Create;
    SplashImage:= TBitmap.Create;
    MainBitmap.Height := LGLCD_BMP_HEIGHT;
    MainBitmap.Width := LGLCD_BMP_WIDTH;

    MainBitmap.Canvas.Font.Color := clblack;
    MainBitmap.Canvas.Font.Name := 'Tahoma';
    MainBitmap.Canvas.Font.Size := 10;

    CurrentFileName := '';
    CurrentFileScrolling := False;
    CurrentFileScrollPos := 0;
    CurrentTrackLengthString := '0:00';
    CurrentTrackLength := 0;

    AppState := 0;
    CurrentPlayListPos := 0;

    ResetTimer := TTimer.Create(Nil);
    ResetTimer.Enabled := False;
    ResetTimer.Interval := 10000;
    ResetTimer.OnTimer := ResetTimerTimer;

    try
        g15Display := TLcdG15.Create('Nemp: G15-Addon', false, true, true);
        if Not g15Display.CreateComplete then
        begin
            FreeAndNil(g15Display);
        end;

        g15Display.OnSoftButtons := myCallbackSoftButtons;

        g15Display.LcdCanvas := MainBitmap.Canvas;
        g15Display.SendToDisplay(fStartPriority);
    except
        g15Display := Nil;
    end;
end;

destructor TNempG15Applet.Destroy;
begin
    g15Display.Free;
    ResetTimer.Free;
    MainBitmap.Free;
    SplashImage.Free;
    inherited;
end;

procedure TNempG15Applet.InitSettings;
var ini: TMemIniFile;
    tmp: String;
    useapp: Boolean;
begin
    // Get Savepath for settings
    if IsExeInProgramSubDir then
    begin
        // Nemp liegt im System-Programmverzeichnis
        fSavePath := GetShellFolder(CSIDL_APPDATA) + '\Gausi\Nemp\';
        try
            ForceDirectories(fSavePath);
        except
            fSavePath := ExtractFilePath(ParamStr(0)) + 'Data\';
        end;
    end else
    begin
        // Nemp liegt woanders
        fSavePath := ExtractFilePath(ParamStr(0)) + 'Data\';
    end;


    ini := TMeminiFile.Create(fSavePath + 'g15.ini', TEncoding.Utf8);
    try
        fStartPriority   := ini.ReadInteger('NempG15', 'StartPriority'    , 255 );
        fDisplayPriority := ini.ReadInteger('NempG15', 'fDisplayPriority' , 1   );
    finally
        ini.Free;
    end;

    ini := TMeminiFile.Create(fSavePath + 'Nemp.ini', TEncoding.Utf8);
    try
        ini.Encoding := TEncoding.UTF8;
        tmp := Ini.ReadString('Allgemein', 'DisplayApp', '');
        useapp := Ini.ReadBool('Allgemein', 'UseDisplayApp', tmp <> '');

        fStartWithNemp := useapp and (tmp = ExtractFilename(ParamStr(0)));
    finally
        ini.Free;
    end;

end;

procedure TNempG15Applet.SaveSettings;
var ini: TMemIniFile;
begin
    ini := TMeminiFile.Create(fSavePath + 'g15.ini', TEncoding.Utf8);
    try
        ini.WriteInteger('NempG15', 'StartPriority'   , fStartPriority   );
        ini.WriteInteger('NempG15', 'fDisplayPriority', fDisplayPriority );
    finally
        ini.Free;
    end;

    ini := TMeminiFile.Create(fSavePath + 'Nemp.ini', TEncoding.Utf8);
    try
        ini.Encoding := TEncoding.UTF8;

        Ini.WriteString('Allgemein', 'DisplayApp', ExtractFilename(ParamStr(0)));
        Ini.WriteBool('Allgemein', 'UseDisplayApp', fStartWithNemp);

        Nemp_SetDisplayApp(fStartWithNemp);

        //if fStartWithNemp then
        //begin
        //    Ini.WriteString('Allgemein', 'DisplayApp', ExtractFilename(ParamStr(0)));
        //    Ini.WriteBool('Allgemein', 'UseDisplayApp', True);
        //end
        //else
        //begin
        //    Ini.WriteString('Allgemein', 'DisplayApp', ExtractFilename(ParamStr(0)));
        //    Ini.WriteBool('Allgemein', 'UseDisplayApp', False);
        //end;

    finally
        ini.UpdateFile;
        ini.Free;
    end;


end;



function TNempG15Applet.GetOnConfig: TOnConfigureCB;
begin
    if assigned(g15Display) then
        result := g15Display.OnConfigure
    else
        result := Nil;
end;




procedure TNempG15Applet.SetOnConfig(value: TOnConfigureCB);
begin
    if assigned(g15Display) then
        g15Display.OnConfigure := value;
end;


// Callback for Buttons
procedure TNempG15Applet.myCallbackSoftButtons(dwButtons: integer);
var State: Integer;
    maxIdx: Integer;
begin
    // Button pressed
    if AppState = 0 then
    begin
        // AppState 0: Control the player
        case dwButtons of
            1: begin
                CurrentFileScrollPos := 0;
                NempPlayPrev;
            end;
            2: begin
                State := GetNempState;
                if State = 1 then
                    NempPause
                else
                    NempPlay;
            end;
            4: NempPlayNext;
            8: begin
                  AppState := 1;
                  ResetTimer.Enabled := True;
                  CurrentPlayListPos := GetNempPlayListPos;
                  if CurrentPlayListPos > 0 then
                      CurrentPlayListPosMin := CurrentPlayListPos - 1
                  else
                      CurrentPlayListPosMin := CurrentPlayListPos;

                  CurrentPlayListPosMax := CurrentPlayListPosMin + 2;
            end;
        end;
    end else
    begin
        // Appstart = 1: Select File in Playlist
        // restart Timer
        ResetTimer.Enabled := False;
        ResetTimer.Enabled := True;
        case dwButtons of
            1: begin
                if CurrentPlayListPos > 0 then
                    CurrentPlayListPos := CurrentPlayListPos - 1;
            end;
            2: begin
                maxIdx := GetNempPlayListLength;
                if CurrentPlayListPos < maxIdx-1 then
                    CurrentPlayListPos := CurrentPlayListPos + 1;
            end;
            4: begin
                SetNempPlayListPos(CurrentPlayListPos);
                AppState := 0;
            end;
            8: begin
                  ResetTimer.Enabled := False;
                  AppState := 0;
            end;
        end;
    end;
end;

procedure TNempG15Applet.PaintIntro;
begin
    MainBitmap.Canvas.Brush.Color := clWhite;
    MainBitmap.Canvas.FillRect(Rect(0, 0, LGLCD_BMP_WIDTH, LGLCD_BMP_HEIGHT));

    MainBitmap.Canvas.Draw(0,0, SplashImage);

    MainBitmap.Canvas.Font.Size := 7;
    ChangeCleartype(MainBitmap.Canvas, False);

    MainBitmap.Canvas.Font.Color := clWhite;
    MainBitmap.Canvas.Brush.Color := clBlack;


    MainBitmap.Canvas.TextOut(96, 5, 'Noch ein');
    MainBitmap.Canvas.TextOut(91, 16, 'mp3-Player');
    MainBitmap.Canvas.TextOut(86, 27, 'www.gausi.de');


    if Assigned(g15Display) then
        g15Display.SendToDisplay(fDisplayPriority);

    ControlImage.Picture.Assign(MainBitmap);
end;


procedure TNempG15Applet.PaintCurrentTrackInfo;
var NeuerFilename: UnicodeString;
    NeuerTitel: UnicodeString;
    neuerstatus:integer;
    //NeuerRandomMode: integer;
    CurrentPos : Integer;
begin
    Neuerstatus     := GetNempState;  // 1: Playing, 3: Paused, 0: Not Playing
    neuerFilename   := GetNempCurrentTitleW(IPC_CF_FILENAME);
    //GetNempPlaylistFileNameW(-1);
    //NeuerRandomMode := GetNempRandomMode;

    if CurrentFileName <> neuerFilename then
    begin
        // Get information about the new track
        CurrentFileName := neuerFilename;
        CurrentTitle := GetNempCurrentTitleW(IPC_CF_TITLE); //GetNempPlaylistTitelW(-1);

        CurrentTrackLength := GetNemp_TrackLength;
        CurrentTrackLengthString := SekIntToMinStr(CurrentTrackLength);

        CurrentFileScrollPos := 0;
        MainBitmap.Canvas.Font.Size := 10;
        ChangeCleartype(MainBitmap.Canvas, False);
        CurrentFileScrolling := MainBitmap.Canvas.TextWidth(CurrentTitle) > LGLCD_BMP_WIDTH;
    end;


    // Position im Track bestimmen und anzeigen
    if GetAudioTypeFromFilename(neuerFilename) = at_Stream then
    begin
        // check for a new title (if new Meta data has arrived in the meantime)
        NeuerTitel := GetNempCurrentTitleW(IPC_CF_TITLE);
        currentPos := 0;
        if NeuerTitel <> CurrentTitle then
        begin
            CurrentTitle := NeuerTitel;

            CurrentFileScrollPos := 0;
            MainBitmap.Canvas.Font.Size := 10;
            ChangeCleartype(MainBitmap.Canvas, False);
            CurrentFileScrolling := MainBitmap.Canvas.TextWidth(CurrentTitle) > LGLCD_BMP_WIDTH;
        end;
    end else
    begin
        // just get the new position in the file
        CurrentPos := GetNemp_TrackPosition;
    end;


    // Clear Display
    MainBitmap.Canvas.Brush.Color := clWhite;
    MainBitmap.Canvas.FillRect(Rect(0, 0, LGLCD_BMP_WIDTH, LGLCD_BMP_HEIGHT));


    MainBitmap.Canvas.Font.Color := clBlack;

    // Paint CurrentTitle
    MainBitmap.Canvas.Font.Size := 10;
    ChangeCleartype(MainBitmap.Canvas, False);

    if CurrentFileScrolling then
    begin
        MainBitmap.Canvas.TextOut(CurrentFileScrollPos, 0, CurrentTitle + ' ... ' + CurrentTitle);
        dec(CurrentFileScrollPos,1);
        if CurrentFileScrollPos < - MainBitmap.Canvas.TextWidth(CurrentTitle + ' ... ') then
            CurrentFileScrollPos := 0;
    end
    else
        MainBitmap.Canvas.TextOut(0, 0, CurrentTitle);

    // Paint Time
    MainBitmap.Canvas.Font.Size := 8;
    ChangeCleartype(MainBitmap.Canvas, False);

    MainBitmap.Canvas.TextOut(0, 16, SekIntToMinStr(CurrentPos DIV 1000));
    MainBitmap.Canvas.TextOut(LGLCD_BMP_WIDTH - MainBitmap.Canvas.TextWidth(CurrentTrackLengthString), 16 , CurrentTrackLengthString);


    case NeuerStatus of
        0: MainBitmap.Canvas.TextOut(50, 16, '(stopped)');// Not Playing
        1: begin
            // Paint Scrollbar
            MainBitmap.Canvas.Rectangle(30, 21, 130, 25);
            MainBitmap.Canvas.Brush.Color := clBlack;
            if CurrentTrackLength <> 0 then
                MainBitmap.Canvas.Fillrect(Rect(30, 21, 30 + (CurrentPos Div (CurrentTrackLength * 10)) , 25));
        end;
        3: MainBitmap.Canvas.TextOut(50, 16, '(paused)'); // paused
    end;

    // Paint Buttons
    MainBitmap.Canvas.Brush.Color := clBlack;
    if Neuerstatus = 1 then
    begin
        // Pause-Symbol
        MainBitmap.Canvas.Fillrect(Rect(53, 31, 56, 42));
        MainBitmap.Canvas.Fillrect(Rect(59, 31, 62, 42));
    end
    else
        // "Play"-Symbol
        MainBitmap.Canvas.Polygon([
            Point(55,31),
            Point(55,41),
            Point(60,36) ]);

    // Previous
    MainBitmap.Canvas.Fillrect(Rect(10, 31, 13, 42));
    MainBitmap.Canvas.Polygon([
        Point(20,31),
        Point(20,41),
        Point(15,36) ]);

    // Next
    MainBitmap.Canvas.Fillrect(Rect(105, 31, 108, 42));
    MainBitmap.Canvas.Polygon([
        Point(97,31),
        Point(97,41),
        Point(102,36) ]);

    // Menu
    MainBitmap.Canvas.Brush.Color := clWhite;
    MainBitmap.Canvas.Rectangle(140,31, 155, 42);

    MainBitmap.Canvas.MoveTo(142, 33);
    MainBitmap.Canvas.LineTo(151, 33);

    MainBitmap.Canvas.MoveTo(142, 35);
    MainBitmap.Canvas.LineTo(148, 35);

    MainBitmap.Canvas.MoveTo(142, 37);
    MainBitmap.Canvas.LineTo(150, 37);

    MainBitmap.Canvas.MoveTo(142, 39);
    MainBitmap.Canvas.LineTo(150, 39);

    MainBitmap.Canvas.Pixels[152,33] := clBlack;
    MainBitmap.Canvas.Pixels[152,35] := clBlack;
    MainBitmap.Canvas.Pixels[152,37] := clBlack;
    MainBitmap.Canvas.Pixels[152,39] := clBlack;

    if Assigned(g15Display) then
        g15Display.SendToDisplay(fDisplayPriority);

    ControlImage.Picture.Assign(MainBitmap);
end;

procedure TNempG15Applet.PaintPlaylistPart;
var i: Integer;
    y: Integer;
begin
    // Clear Display
    MainBitmap.Canvas.Brush.Color := clWhite;
    MainBitmap.Canvas.FillRect(Rect(0, 0, LGLCD_BMP_WIDTH, LGLCD_BMP_HEIGHT));


    MainBitmap.Canvas.Font.Size := 8;
    ChangeCleartype(MainBitmap.Canvas, False);

    // correct/min/Max
    if CurrentPlayListPos < CurrentPlayListPosMin then
    begin
        CurrentPlayListPosMin := CurrentPlayListPos;
        CurrentPlayListPosMax := CurrentPlayListPosMin + 2;
    end;

    if CurrentPlayListPos > CurrentPlayListPosMax then
    begin
        CurrentPlayListPosMax := CurrentPlayListPos;
        CurrentPlayListPosMin := CurrentPlayListPosMax - 2;
        if CurrentPlayListPosMin < 0 then
            CurrentPlayListPos := 0;
    end;

    // paint Playlist-Entries
    y := -2;
    for i := CurrentPlayListPosMin to CurrentPlayListPosMax do
    begin
        if i = CurrentPlayListPos then
        begin
              MainBitmap.Canvas.Font.Color := clWhite;
              MainBitmap.Canvas.Brush.Color := clBlack;
              MainBitmap.Canvas.Brush.Style := bsSolid;
              MainBitmap.Canvas.FillRect(Rect(0,y+2, LGLCD_BMP_WIDTH, y+12));
              MainBitmap.Canvas.Brush.Style := bsClear;
        end else
        begin
              MainBitmap.Canvas.Font.Color := clBlack;
              MainBitmap.Canvas.Brush.Color := clWhite;
              MainBitmap.Canvas.Brush.Style := bsClear;
        end;
        MainBitmap.Canvas.TextOut(0, y, GetNempPlaylistTitelW(i));
        inc(y,10);
    end;

    // Paint Controls
    MainBitmap.Canvas.Font.Color := clBlack;
    MainBitmap.Canvas.Brush.Color := clWhite;
    MainBitmap.Canvas.Brush.Style := bsClear;
    MainBitmap.Canvas.TextOut(95, 32, 'OK');
    MainBitmap.Canvas.TextOut(125, 32, 'Cancel');
    // up
    MainBitmap.Canvas.Polygon([
            Point(15,40),
            Point(25,40),
            Point(20,35) ]);
    // down
    MainBitmap.Canvas.Polygon([
            Point(55,35),
            Point(65,35),
            Point(60,40) ]);

    if Assigned(g15Display) then
        g15Display.SendToDisplay(fDisplayPriority);

    ControlImage.Picture.Assign(MainBitmap);
end;



procedure TNempG15Applet.ResetTimerTimer(Sender: TObject);
begin
    ResetTimer.Enabled := False;
    AppState := 0;
end;

end.
