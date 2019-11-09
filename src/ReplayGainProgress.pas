unit ReplayGainProgress;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  System.Contnrs, myDialogs,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, NempReplayGainCalculation,
  Vcl.ComCtrls, VirtualTrees, bass, nempAudiofiles, Vcl.ExtCtrls;

type
  TReplayGainProgressForm = class(TForm)
    pbTrack: TProgressBar;
    BtnCancel: TButton;
    pbComplete: TProgressBar;
    MainImage: TImage;
    LblMain: TLabel;
    LblStatus: TLabel;
    LogMemo: TMemo;
    cbAutoClose: TCheckBox;
    CloseTimer: TTimer;
    procedure BtnAlbumRGClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);

    procedure OnThreadTerminate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure cbAutoCloseClick(Sender: TObject);
    procedure CloseTimerTimer(Sender: TObject);
  private
    { Private declarations }

    fTotalFileCount: Integer;
    fFileCountOffset: Integer;

    fOperationCancelled: Boolean;

    Procedure OnStreamInit(aReplayGainCalculator: TNempReplayGainCalculator; ErrorCode: Integer);
    procedure OnTrackProgress(Sender: TNempReplayGainCalculator; aProgress: Single);
    procedure OnTrackComplete(aReplayGainCalculator: TNempReplayGainCalculator; aIndex: Integer; aGain: Double; aPeak: Double);
    procedure OnAlbumComplete(aReplayGainCalculator: TNempReplayGainCalculator; aIndex: Integer; aGain: Double; aPeak: Double);

    procedure OnWriteMetaDataProgress(Sender: TNempReplayGainCalculator; aProgress: Single);
    procedure OnCalculationError(aReplayGainCalculator: TNempReplayGainCalculator; ErrorCode: Integer);
    procedure OnAudioFileSynch(aFile: TAudioFile; aTrackGain, aAlbumGain, aTrackPeak, aAlbumPeak: Double);
    Procedure OnMainProgress (RGThread: TNempReplayGainCalculator; AlbumName: String; FileCount: Integer; Progress: TRGStatus);

  public
    { Public declarations }
    // ReplayGainCalculator: TReplayGainCalculator;
    AutoClose: Boolean;

    procedure InitiateReplayGainCalculation(aFileList: TObjectList; aCalculationMode: TRGCalculationMode; CreateCopies: Boolean);


  end;

  function ReplayGainToAudioError(aErrorCode: Integer): TNempAudioError;

var
  ReplayGainProgressForm: TReplayGainProgressForm;

  NempReplayGainCalculator: TNempReplayGainCalculator;


implementation

uses NempMainUnit, MainFormHelper, AudioFiles, ReplayGain, Nemp_RessourceStrings;

{$R *.dfm}

function ReplayGainToAudioError(aErrorCode: Integer): TNempAudioError;
begin
    case aErrorCode of
        RG_ERR_None                 : result := AUDIOERR_None;
        RG_ERR_TooManyChannels      : result := AUDIOERR_ReplayGain_TooManyChannels       ;
        RG_ERR_AlbumGainFreqChanged : result := AUDIOERR_ReplayGain_AlbumGainFreqChanged  ;
        RG_ERR_InitGainAnalysisError: result := AUDIOERR_ReplayGain_InitGainAnalysisError ;

        // can happen sometimes, but it's not actually an error ...
        BASS_ERROR_ENDED            : result := AUDIOERR_None;
    else
        result := AUDIOERR_Unkown;
    end;
end;



procedure TReplayGainProgressForm.BtnCancelClick(Sender: TObject);
begin
    if assigned(NempReplayGainCalculator) then
    begin
        fOperationCancelled := True;
        NempReplayGainCalculator.Terminate;
    end
    else
        close;
end;

procedure TReplayGainProgressForm.cbAutoCloseClick(Sender: TObject);
begin
    // if actual User-Input: Overwrite autoclose
    Nemp_MainForm.NempOptions.AutoCloseProgressWindow := cbAutoClose.Checked;
    self.AutoClose := cbAutoClose.Checked;
    // deactivate Timer
    CloseTimer.Enabled := False;
    cbAutoClose.Caption := MediaLibrary_OperationComplete_CBClose_NoTimer;
end;


procedure TReplayGainProgressForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
    CanClose := not assigned(NempReplayGainCalculator);
end;

procedure TReplayGainProgressForm.FormCreate(Sender: TObject);
var aPath: String;
begin
    aPath := ExtractFilePath(ParamStr(0)) + 'Images\ReplayGain.png';
    if FileExists(aPath) then
        MainImage.Picture.LoadFromFile(aPath)
    else
        MainImage.Picture.Assign(Nil);
end;


procedure TReplayGainProgressForm.FormShow(Sender: TObject);
var MainMonitor: TMonitor;
begin
    CloseTimer.Enabled := False;

    MainMonitor := Screen.MonitorFromWindow(Nemp_MainForm.handle);
    Top := MainMonitor.WorkareaRect.Height - height;
    Left := MainMonitor.WorkareaRect.Right - width;

    cbAutoClose.OnClick := Nil;
    self.cbAutoClose.Checked := Nemp_MainForm.NempOptions.AutoCloseProgressWindow or AutoClose;
    cbAutoClose.OnClick := cbAutoCloseClick;

    LblMain.Caption := Progressform_ReplayGain;
end;

procedure TReplayGainProgressForm.InitiateReplayGainCalculation(
  aFileList: TObjectList; aCalculationMode: TRGCalculationMode; CreateCopies: Boolean);
var i: Integer;
begin
    if assigned(NempReplayGainCalculator) then
        TranslateMessageDLG((Progressform_ReplayGain_AlreadyRunning), mtInformation, [MBOK], 0)
    else
    begin
          // block some Library actions and part of the GUI
          MedienBib.StatusBibUpdate := 1;
          BlockGUI(1);

          // initiate Progress GUI
          LblMain.Caption     := Progressform_ReplayGain;
          BtnCancel.Caption   := XcmbCancel;
          fOperationCancelled := False;
          pbTrack.Position    := 0;
          pbComplete.Position := 0;
          LogMemo.Lines.Clear;


          fTotalFileCount  := aFileList.Count;
          fFileCountOffset := 0;

          // create Calculation thread
          NempReplayGainCalculator := TNempReplayGainCalculator.Create;
          NempReplayGainCalculator.MainWindowHandle := FOwnMessageHandler;

          NempReplayGainCalculator.CalculationMode := aCalculationMode;

          NempReplayGainCalculator.OnStreamInit           := OnStreamInit;
          NempReplayGainCalculator.OnError                := OnCalculationError;
          NempReplayGainCalculator.OnTrackProgress        := OnTrackProgress;
          NempReplayGainCalculator.OnTrackComplete        := OnTrackComplete;
          NempReplayGainCalculator.OnAlbumComplete        := OnAlbumComplete;
          NempReplayGainCalculator.OnWriteMetaDataProgress := OnWriteMetaDataProgress;
          NempReplayGainCalculator.OnSynchAudioFile := OnAudioFileSynch;
          NempReplayGainCalculator.OnMainProgress   := OnMainProgress ;
          NempReplayGainCalculator.OnTerminate      := OnThreadTerminate;

          NempReplayGainCalculator.UseAudioFileCopies := CreateCopies;
          for i := 0 to aFileList.Count - 1 do
              NempReplayGainCalculator.AddAudioFile(TAudioFile(aFileList[i]));

          NempReplayGainCalculator.Start;
    end;
end;

Procedure TReplayGainProgressForm.OnMainProgress (RGThread: TNempReplayGainCalculator; AlbumName: String; FileCount: Integer; Progress: TRGStatus);
var displayAlbum: String;
begin
    // pbComplete.Position := Trunc(100 * OverallProgress);

    case Progress of
      RGStatus_StartCalculationSingleTracks: begin
          LogMemo.Lines.Add(Format('Calculating ReplayGain (TrackGain only) values for %d files ...', [FileCount]));
      end;

      RGStatus_StartCalculationSingleAlbum: begin
          LogMemo.Lines.Add(Format('Calculating ReplayGain (with AlbumGain) values for %d files ...', [FileCount]));
      end;

      RGStatus_StartCalculationMultiAlbum: begin
          if AlbumName = '' then
              displayAlbum := '<Unknown Album>'
          else
              displayAlbum := AlbumName;

          LogMemo.Lines.Add(Format('Calculating ReplayGain values for album "%s" with %d files ...', [displayAlbum, FileCount]));
      end;

      RGStatus_StartSync: begin
          LblStatus.Caption := Format('Calculating complete, synchronizing %d files ...', [FileCount]);
      end;

      RGStatus_StartDeleteValues: begin
          LogMemo.Lines.Add(Format('Removing ReplayGain values from %d files ...', [FileCount]));
          LblStatus.Caption := Format('Removing ReplayGain values from %d files ...', [FileCount]);
      end;


      RGStatus_Finished: begin

              ///  FileCount gives the completed files from this album
              ///  => increase "Offset" by FileCount
              fFileCountOffset := fFileCountOffset + FileCount;

              // not necessarily *completely* finished, but at least one album is finished
              // pbAlbum.Position := 100;
              ///// Memo1.Lines.Add('... done');
              // Memo1.Lines.Add('ReplayGain Album completed..');
              // LogMemo.Lines.Add('');

              LblStatus.Caption := 'Done.';
      end;
    end;
end;

procedure TReplayGainProgressForm.OnStreamInit(aReplayGainCalculator: TNempReplayGainCalculator;
  ErrorCode: Integer);
begin
    case ErrorCode of
        RG_ERR_None: begin
            LblStatus.Caption := Format ( 'Scanning file %s',
                [  ExtractFilename(aReplayGainCalculator.CurrentFilename) ]);

             {
            Format ( 'Scanning %s (%d kB, %d channel(s), %d Hz)',
                [  ExtractFilename(aReplayGainCalculator.CurrentFilename),
                   aReplayGainCalculator.ChannelLength Div 1024,
                   aReplayGainCalculator.ChannelCount,
                   aReplayGainCalculator.ChannelFreq    ]);
              }
            // Application.ProcessMessages;
        end;
    else
        LogMemo.Lines.Add(Format('Some unexpected Error occured (Errorcode: %d)', [ErrorCode]));
        //RG_ERR_TooManyChannels  : LblStatus.Caption := 'Too many Channels. Only mono and stereo are supported.';
        //RG_ERR_No16Bit          : LblStatus.Caption := 'Channel is not a 16Bit channel. ReplayGain calculation is not supported.' ;
        //RG_ERR_FreqNotSupported : LblStatus.Caption := 'Channel frequency is not supported';
    end;
end;

procedure TReplayGainProgressForm.OnCalculationError(aReplayGainCalculator: TNempReplayGainCalculator; ErrorCode: Integer);
var AudioErr: TNempAudioError;
begin

    AudioErr := ReplayGainToAudioError(ErrorCode);
    if AudioErr <> AUDIOERR_None then
    begin
        HandleError(afa_ReplayGain,
            aReplayGainCalculator.CurrentFilename,
            AudioErr);
    end;


    case ErrorCode of
        RG_ERR_None: ;
        RG_ERR_TooManyChannels: LogMemo.Lines.Add(Format('Error: Too many channels (%s)', [aReplayGainCalculator.CurrentFilename]));
        RG_ERR_AlbumGainFreqChanged: LogMemo.Lines.Add(Format('Warning: AlbumGain calculation cancelled (%s)', [aReplayGainCalculator.CurrentFilename]));
        RG_ERR_InitGainAnalysisError: LogMemo.Lines.Add(Format('Error: Failed initialisiing replay gain calculation (%s)', [aReplayGainCalculator.CurrentFilename]));

        BASS_ERROR_ENDED: ; // can happen sometimes, but it's not actually an error ...
        {
        if aErr <> AUDIOERR_None then
            begin
                ErrorLog := TErrorLog.create(afa_ReplayGain, localAudioFile, aErr, false);
                try
                    SendMessage(MainWindowHandle, WM_MedienBib, MB_ErrorLog, LParam(ErrorLog));
                finally
                    ErrorLog.Free;
                end;
            end;
        }
    end;
end;


procedure TReplayGainProgressForm.OnTrackProgress(Sender: TNempReplayGainCalculator;
  aProgress: Single);
begin
    pbTrack.Position := trunc(100* aProgress);
end;


procedure TReplayGainProgressForm.OnTrackComplete(aReplayGainCalculator: TNempReplayGainCalculator; aIndex: Integer; aGain: Double; aPeak: Double);
begin
    LogMemo.Lines.Add(Format('Track %d: %6.2f dB, Peak %6.6f (%s)',
                                [aIndex + 1, aGain, aPeak,  ExtractFilename(aReplayGainCalculator.CurrentFilename)]));
    pbTrack.Position := 100;

    ///  Total-File-Index = Offset + aIndex
    ///  fTotalFileCount: "was dem Thread übergeben wurde"

    if (fTotalFileCount > 0) then
        pbComplete.Position := Trunc( 100 * (fFileCountOffset + aIndex + 1) / fTotalFileCount)
    else
        pbComplete.Position := 0;
end;


procedure TReplayGainProgressForm.OnAlbumComplete(aReplayGainCalculator: TNempReplayGainCalculator; aIndex: Integer; aGain: Double; aPeak: Double);
begin
    LogMemo.Lines.Add(Format('AlbumGain: %6.2f dB, Peak %6.6f', [aGain, aPeak]));

    LblStatus.Caption := 'Calculation AlbumGain complete.';
    pbTrack.Position := 100;
end;

procedure TReplayGainProgressForm.OnWriteMetaDataProgress(Sender: TNempReplayGainCalculator; aProgress: Single);
begin
    pbTrack.Position := Trunc(100 * aProgress);
end;

procedure TReplayGainProgressForm.OnAudioFileSynch(aFile: TAudioFile; aTrackGain,
  aAlbumGain, aTrackPeak, aAlbumPeak: Double);
var ListOfFiles : TObjectList;
    i: Integer;
    listFile: TAudioFile;
begin
    aFile.TrackGain := aTrackGain;
    aFile.AlbumGain := aAlbumGain;
    aFile.TrackPeak := aTrackPeak;
    aFile.AlbumPeak := aAlbumPeak;
    MedienBib.Changed := True;

    ListOfFiles := TObjectList.Create(False);
    try
        // get List of this AudioFile
        GetListOfAudioFileCopies(aFile, ListOfFiles);
        // edit all these files
        for i := 0 to ListOfFiles.Count - 1 do
        begin
            listFile := TAudioFile(ListOfFiles[i]);
            listFile.TrackGain := aTrackGain;
            listFile.AlbumGain := aAlbumGain;
            listFile.TrackPeak := aTrackPeak;
            listFile.AlbumPeak := aAlbumPeak;
        end;
    finally
        ListOfFiles.Free;
    end;
end;





procedure TReplayGainProgressForm.BtnAlbumRGClick(Sender: TObject);
var i:integer;
    Data: PTreeData;
    SelectedMp3s: TNodeArray;

begin
    if assigned(NempReplayGainCalculator) then
        ShowMessage('Sorry, already running')
    else
    begin
          LblMain.Caption := Progressform_ReplayGain;

          BtnCancel.Caption := XcmbCancel;
          fOperationCancelled := False;

          LogMemo.Lines.Clear;


          SelectedMP3s := Nemp_MainForm.PlaylistVST.GetSortedSelection(False);
          if length(SelectedMP3s) = 0 then exit;

          pbComplete.Position := 0;

          fTotalFileCount  := length(SelectedMP3s);
          fFileCountOffset := 0;

          // create Calculation thread
          NempReplayGainCalculator := TNempReplayGainCalculator.Create;
          NempReplayGainCalculator.MainWindowHandle := FOwnMessageHandler;

          case (Sender as TButton).Tag of
              0: NempReplayGainCalculator.CalculationMode := RG_Calculate_SingleTracks;
              1: NempReplayGainCalculator.CalculationMode := RG_Calculate_SingleAlbum ;
              2: NempReplayGainCalculator.CalculationMode := RG_Calculate_MultiAlbums ;
              3: NempReplayGainCalculator.CalculationMode := RG_Delete_ReplayGainValues ;
          end;

          NempReplayGainCalculator.OnStreamInit           := OnStreamInit;
          NempReplayGainCalculator.OnError                := OnCalculationError;
          NempReplayGainCalculator.OnTrackProgress        := OnTrackProgress;
          NempReplayGainCalculator.OnTrackComplete        := OnTrackComplete;
          NempReplayGainCalculator.OnAlbumComplete        := OnAlbumComplete;
          NempReplayGainCalculator.OnWriteMetaDataProgress := OnWriteMetaDataProgress;
          NempReplayGainCalculator.OnSynchAudioFile := OnAudioFileSynch;
          NempReplayGainCalculator.OnMainProgress   := OnMainProgress ;

          NempReplayGainCalculator.OnTerminate := OnThreadTerminate;

          for i:=0 to length(SelectedMP3s)-1 do
          begin
              Data := Nemp_MainForm.VST.GetNodeData(SelectedMP3s[i]);
              NempReplayGainCalculator.AddAudioFile(Data^.FAudioFile);
          end;

          NempReplayGainCalculator.Start;

    end;
end;

procedure TReplayGainProgressForm.OnThreadTerminate(Sender: TObject);
begin
    NempReplayGainCalculator := Nil;

    lblStatus.Caption := MediaLibrary_OperationComplete_CloseWindowNow ;
    BtnCancel.Caption := XcmbOK;
    pbTrack   .Position := 100;
    pbComplete.Position := 100;

    if fOperationCancelled then
    begin
        LblMain.Caption := Progressform_ReplayGain_Cancelled;
        LogMemo.Lines.Add('Aborted')
    end else
    begin
        LblMain.Caption := Progressform_ReplayGain_Complete;
    end;

    if cbAutoClose.Checked or AutoClose then
    begin
        // set AutoClose to False again
        AutoClose := False;
        // start the closeTimer
        CloseTimer.Tag := 5;
        cbAutoClose.Caption := Format(MediaLibrary_OperationComplete_CBClose_TimerActive, [CloseTimer.Tag]);
        CloseTimer.Enabled := True;
    end;

    // set Library Status and GUI to "free" again
    UnBlockGUI;
    MedienBib.StatusBibUpdate := 0;

    // Display values in Library-VST (and Icon in Playlist-VST)
    Nemp_Mainform.VST.Invalidate;
    Nemp_Mainform.PlaylistVST.Invalidate;
end;

procedure TReplayGainProgressForm.CloseTimerTimer(Sender: TObject);
begin
    CloseTimer.Tag := CloseTimer.Tag - 1;
    cbAutoClose.Caption := Format(MediaLibrary_OperationComplete_CBClose_TimerActive, [CloseTimer.Tag]);
    if CloseTimer.Tag <= 0 then
    begin
        CloseTimer.Enabled := False;
        close;
    end;
end;



end.
