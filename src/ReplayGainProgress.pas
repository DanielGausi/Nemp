{

    Unit ReplayGainProgress

    - Show Progress of the ReplayGain calculation

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2005-2022, Daniel Gaussmann
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
    AutoClose: Boolean;
    procedure InitiateReplayGainCalculation(aFileList: TAudioFileList; aCalculationMode: TRGCalculationMode; CreateCopies: Boolean);

  end;

  function ReplayGainToAudioError(aErrorCode: Integer): TNempAudioError;

var
  ReplayGainProgressForm: TReplayGainProgressForm;

  NempReplayGainCalculator: TNempReplayGainCalculator;


implementation

uses NempMainUnit, MainFormHelper, ReplayGain, gnugettext, Nemp_RessourceStrings, Nemp_ConstantsAndTypes;

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
    NempOptions.AutoCloseProgressWindow := cbAutoClose.Checked;
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
    TranslateComponent (self);

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
    self.cbAutoClose.Checked := NempOptions.AutoCloseProgressWindow or AutoClose;
    cbAutoClose.OnClick := cbAutoCloseClick;

    LblMain.Caption := Progressform_ReplayGain;
end;

procedure TReplayGainProgressForm.InitiateReplayGainCalculation(
  aFileList: TAudioFileList; aCalculationMode: TRGCalculationMode; CreateCopies: Boolean);
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
              NempReplayGainCalculator.AddAudioFile(aFileList[i]);

          NempReplayGainCalculator.Start;
    end;
end;

Procedure TReplayGainProgressForm.OnMainProgress (RGThread: TNempReplayGainCalculator; AlbumName: String; FileCount: Integer; Progress: TRGStatus);
var displayAlbum: String;
begin

    case Progress of
      RGStatus_StartCalculationSingleTracks: begin
          LogMemo.Lines.Add(Format(ReplayGain_CalculateSingleTracks, [FileCount]));
      end;

      RGStatus_StartCalculationSingleAlbum: begin
          LogMemo.Lines.Add(Format(ReplayGain_CalculateSingleAlbum, [FileCount]));
      end;

      RGStatus_StartCalculationMultiAlbum: begin
          if AlbumName = '' then
              displayAlbum := ReplayGain_UnknownAlbum
          else
              displayAlbum := AlbumName;

          LogMemo.Lines.Add(Format(ReplayGain_CalculateMultipleAlbums, [displayAlbum, FileCount]));
      end;

      RGStatus_StartSync: begin
          LblStatus.Caption := Format(ReplayGain_StartSynchronizing, [FileCount]);
      end;

      RGStatus_StartDeleteValues: begin
          LogMemo.Lines.Add(Format(ReplayGain_RemoveFromFiles, [FileCount]));
          LblStatus.Caption := Format(ReplayGain_RemoveFromFiles, [FileCount]);
      end;


      RGStatus_Finished: begin
              ///  FileCount gives the completed files from this album
              ///  => increase "Offset" by FileCount
              fFileCountOffset := fFileCountOffset + FileCount;

              // not necessarily *completely* finished, but at least one album is finished
              LblStatus.Caption := ReplayGain_Complete;
      end;
    end;
end;

procedure TReplayGainProgressForm.OnStreamInit(aReplayGainCalculator: TNempReplayGainCalculator;
  ErrorCode: Integer);
begin
    case ErrorCode of
        RG_ERR_None: begin
            LblStatus.Caption := Format (ReplayGain_ScanningFile ,
                [  ExtractFilename(aReplayGainCalculator.CurrentFilename) ]);
        end;
    else
        LogMemo.Lines.Add(Format(ReplayGain_UnexpectedError, [ErrorCode]));
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
        RG_ERR_TooManyChannels: LogMemo.Lines.Add(Format(ReplayGain_ErrorTooManyChannels, [aReplayGainCalculator.CurrentFilename]));
        RG_ERR_AlbumGainFreqChanged: LogMemo.Lines.Add(Format(ReplayGain_ErrorAlbumGainFreqChanged, [aReplayGainCalculator.CurrentFilename]));
        RG_ERR_InitGainAnalysisError: LogMemo.Lines.Add(Format(ReplayGain_ErrorInitGainAnalysisError, [aReplayGainCalculator.CurrentFilename]));

        BASS_ERROR_ENDED: ; // can happen sometimes, but it's not actually an error ...
    end;
end;


procedure TReplayGainProgressForm.OnTrackProgress(Sender: TNempReplayGainCalculator;
  aProgress: Single);
begin
    pbTrack.Position := trunc(100* aProgress);
end;


procedure TReplayGainProgressForm.OnTrackComplete(aReplayGainCalculator: TNempReplayGainCalculator; aIndex: Integer; aGain: Double; aPeak: Double);
begin
    LogMemo.Lines.Add(Format(ReplayGain_TrackSummary,
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
    LogMemo.Lines.Add(Format(ReplayGain_AlbumSummary, [aGain, aPeak]));

    LblStatus.Caption := ReplayGain_AlbumComplete;
    pbTrack.Position := 100;
end;

procedure TReplayGainProgressForm.OnWriteMetaDataProgress(Sender: TNempReplayGainCalculator; aProgress: Single);
begin
    pbTrack.Position := Trunc(100 * aProgress);
end;

procedure TReplayGainProgressForm.OnAudioFileSynch(aFile: TAudioFile; aTrackGain,
  aAlbumGain, aTrackPeak, aAlbumPeak: Double);
var ListOfFiles : TAudioFileList;
    i: Integer;
    listFile: TAudioFile;
begin
    aFile.TrackGain := aTrackGain;
    aFile.AlbumGain := aAlbumGain;
    aFile.TrackPeak := aTrackPeak;
    aFile.AlbumPeak := aAlbumPeak;
    MedienBib.Changed := True;

    ListOfFiles := TAudioFileList.Create(False);
    try
        // get List of this AudioFile
        GetListOfAudioFileCopies(aFile, ListOfFiles);
        // edit all these files
        for i := 0 to ListOfFiles.Count - 1 do
        begin
            listFile := ListOfFiles[i];
            listFile.TrackGain := aTrackGain;
            listFile.AlbumGain := aAlbumGain;
            listFile.TrackPeak := aTrackPeak;
            listFile.AlbumPeak := aAlbumPeak;
        end;
    finally
        ListOfFiles.Free;
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
        LogMemo.Lines.Add(ReplayGain_Abort)
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
