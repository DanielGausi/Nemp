unit _TestUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  System.Contnrs,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ReplayGainAnalysis, NempReplayGainCalculation,
  Vcl.ComCtrls, VirtualTrees, bass, nempAudiofiles;

type
  TTestForm = class(TForm)
    Memo1: TMemo;
    BtnGetreplayGainData: TButton;
    LblStatus: TLabel;
    pbTrack: TProgressBar;
    BtnAlbumRG: TButton;
    Button1: TButton;
    pbComplete: TProgressBar;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure BtnGetreplayGainDataClick(Sender: TObject);
    procedure BtnAlbumRGClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }

    fTotalFileCount: Integer;
    fFileCountOffset: Integer;
  public
    { Public declarations }
    ReplayGainCalculator: TReplayGainCalculator;

    Procedure OnStreamInit(aReplayGainCalculator: TReplayGainCalculator; ErrorCode: Integer);
    procedure OnTrackProgress(Sender: TReplayGainCalculator; aProgress: Single);
    procedure OnSingleTrackComplete(aReplayGainCalculator: TReplayGainCalculator; aIndex: Integer; aGain: Double; aPeak: SmallInt);

    procedure OnTrackComplete(aReplayGainCalculator: TReplayGainCalculator; aIndex: Integer; aGain: Double; aPeak: SmallInt);
    procedure OnAlbumComplete(aReplayGainCalculator: TReplayGainCalculator; aIndex: Integer; aGain: Double; aPeak: SmallInt);

    procedure OnWriteMetaDataProgress(Sender: TReplayGainCalculator; aProgress: Single);

    procedure OnCalculationError(aReplayGainCalculator: TReplayGainCalculator; ErrorCode: Integer);

    procedure OnAudioFileSynch(aFile: TAudioFile; aTrackGain, aAlbumGain: Double);

    Procedure OnMainProgress (RGThread: TNempReplayGainCalculator; AlbumName: String; FileCount: Integer; Progress: TRGStatus);

  end;

var
  TestForm: TTestForm;

  NempReplayGainCalculator: TNempReplayGainCalculator;


implementation

uses NempMainUnit, MainFormHelper, AudioFiles, ReplayGain;

{$R *.dfm}


procedure TTestForm.Button1Click(Sender: TObject);
var i:integer;
    Data: PTreeData;
    SelectedMp3s: TNodeArray;

    sl: TStringList;

begin

    SelectedMP3s := Nemp_MainForm.VST.GetSortedSelection(False);
    if length(SelectedMP3s) = 0 then exit;

    sl := TStringList.Create;
    try
          for i := 0 to length(SelectedMP3s)-1 do
          begin
              Data := Nemp_MainForm.VST.GetNodeData(SelectedMP3s[i]);
              sl.Add( Data^.FAudioFile.Pfad);
          end;

          ReplayGainCalculator.CalculateAlbumGain(sl);
    finally
        sl.Free
    end;

end;

procedure TTestForm.FormCreate(Sender: TObject);
begin
    ReplayGainCalculator := TReplayGainCalculator.create;
    ReplayGainCalculator.OnStreamInit          := OnStreamInit;
    ReplayGainCalculator.OnError               := OnCalculationError;
    ReplayGainCalculator.OnStreamProgress      := OnTrackProgress;
    ReplayGainCalculator.OnSingleTrackComplete := OnSingleTrackComplete;
    ReplayGainCalculator.OnTrackComplete       := OnTrackComplete;
    ReplayGainCalculator.OnAlbumComplete       := OnAlbumComplete;

end;

procedure TTestForm.FormDestroy(Sender: TObject);
begin
    ReplayGainCalculator.Free;
end;

Procedure TTestForm.OnMainProgress (RGThread: TNempReplayGainCalculator; AlbumName: String; FileCount: Integer; Progress: TRGStatus);
var displayAlbum: String;
begin
    // pbComplete.Position := Trunc(100 * OverallProgress);

    case Progress of
      RGStatus_StartCalculationSingleTracks: begin
          Memo1.Lines.Add(Format('Calculating ReplayGain (TrackGain only) values for %d files ...', [FileCount]));
      end;

      RGStatus_StartCalculationSingleAlbum: begin
          Memo1.Lines.Add(Format('Calculating ReplayGain (with AlbumGain) values for %d files ...', [FileCount]));
      end;

      RGStatus_StartCalculationMultiAlbum: begin

          if AlbumName = '' then
              displayAlbum := '<Unkown Album>'
          else
              displayAlbum := AlbumName;

          Memo1.Lines.Add(Format('Calculating ReplayGain values for album "%s" with %d files ...', [displayAlbum, FileCount]));
      end;
      RGStatus_StartSync: begin
          LblStatus.Caption := Format('Calculating complete, synchronizing %d files ...', [FileCount]);
      end;

      RGStatus_StartDeleteValues: begin
          Memo1.Lines.Add(Format('Removing ReplayGain values from %d files ...', [FileCount]));
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
              Memo1.Lines.Add('');
              Memo1.Lines.Add('');
              LblStatus.Caption := 'Done.';
      end;
    end;
end;

procedure TTestForm.OnStreamInit(aReplayGainCalculator: TReplayGainCalculator;
  ErrorCode: Integer);
begin
    case ErrorCode of
        RG_ERR_None: begin
            LblStatus.Caption :=  Format ( 'Calculating ReplayGain for %s ... %d Bytes, %d channel(s), %d Hz',
                [  ExtractFilename(aReplayGainCalculator.CurrentFilename),
                   aReplayGainCalculator.ChannelLength,
                   aReplayGainCalculator.ChannelCount,
                   aReplayGainCalculator.ChannelFreq    ]);

            // Application.ProcessMessages;
        end;
    else
        Memo1.Lines.Add(Format('Some unexpected Error occured (Errorcode: %d)', [ErrorCode]));
        //RG_ERR_TooManyChannels  : LblStatus.Caption := 'Too many Channels. Only mono and stereo are supported.';
        //RG_ERR_No16Bit          : LblStatus.Caption := 'Channel is not a 16Bit channel. ReplayGain calculation is not supported.' ;
        //RG_ERR_FreqNotSupported : LblStatus.Caption := 'Channel frequency is not supported';
    end;
end;

procedure TTestForm.OnTrackProgress(Sender: TReplayGainCalculator;
  aProgress: Single);
begin
    pbTrack.Position := trunc(100* aProgress);
end;

procedure TTestForm.OnSingleTrackComplete(
  aReplayGainCalculator: TReplayGainCalculator; aIndex: Integer; aGain: Double; aPeak: SmallInt);
begin
    Memo1.Lines.Add(Format('TrackGain: %6.2f dB, Peak: %d,  (%s)',
                                [aGain, aPeak, ExtractFilename(aReplayGainCalculator.CurrentFilename)]));
    Memo1.Lines.Add('');
    LblStatus.Caption := Format ( 'Calculation ReplayGain for %s complete.', [aReplayGainCalculator.CurrentFilename]);
    pbTrack.Position := 100;
    // Application.ProcessMessages;
end;

procedure TTestForm.OnTrackComplete(aReplayGainCalculator: TReplayGainCalculator; aIndex: Integer; aGain: Double; aPeak: SmallInt);
begin
    Memo1.Lines.Add(Format('Track %d: %6.2f dB, Peak: %d,  (%s)',
                                [aIndex, aGain, aPeak, ExtractFilename(aReplayGainCalculator.CurrentFilename)]));
    pbTrack.Position := 100;

    ///  Total-File-Index = Offset + aIndex
    ///  fTotalFileCount: "was dem Thread übergeben wurde"

    if (fTotalFileCount > 0) then
        pbComplete.Position := Trunc( 100 * (fFileCountOffset + aIndex + 1) / fTotalFileCount)
    else
        pbComplete.Position := 0;
end;


procedure TTestForm.OnAlbumComplete(aReplayGainCalculator: TReplayGainCalculator; aIndex: Integer; aGain: Double; aPeak: SmallInt);
begin
    Memo1.Lines.Add(Format('AlbumGain: %6.2f dB, Peak: %d', [aGain, aPeak]));

    LblStatus.Caption := 'Calculation AlbumGain complete.';
    pbTrack.Position := 100;
    // Application.ProcessMessages;
end;

procedure TTestForm.OnWriteMetaDataProgress(Sender: TReplayGainCalculator; aProgress: Single);
begin
    pbTrack.Position := Trunc(100 * aProgress);
end;

procedure TTestForm.OnAudioFileSynch(aFile: TAudioFile; aTrackGain,
  aAlbumGain: Double);
var ListOfFiles : TObjectList;
    i: Integer;
    listFile: TAudioFile;
begin
    aFile.TrackGain := aTrackGain;
    aFile.AlbumGain := aAlbumGain;

    LblStatus.Caption := ('Writing Metadata to file ...'  + ExtractFilename(aFile.Pfad) );

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
                  end;

                  // MedienBib.Changed := True;

              finally
                  ListOfFiles.Free;
              end;
end;

procedure TTestForm.OnCalculationError(aReplayGainCalculator: TReplayGainCalculator; ErrorCode: Integer);
begin
    case ErrorCode of
        RG_ERR_None: ;
        RG_ERR_TooManyChannels: Memo1.Lines.Add(Format('Error: Too many channels (%s)', [aReplayGainCalculator.CurrentFilename]));
        RG_ERR_No16Bit: Memo1.Lines.Add(Format('Error: Not a 16Bit channel (%s)', [aReplayGainCalculator.CurrentFilename]));
        RG_ERR_AlbumGainFreqChanged: Memo1.Lines.Add(Format('Warning: AlbumGain calculation cancelled (%s)', [aReplayGainCalculator.CurrentFilename]));
        RG_ERR_InitGainAnalysisError: Memo1.Lines.Add(Format('Error: Failed initialisiing replay gain calculation (%s)', [aReplayGainCalculator.CurrentFilename]));

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



procedure TTestForm.BtnGetreplayGainDataClick(Sender: TObject);
begin
    //if InitGainAnalysis(44100) <> INIT_GAIN_ANALYSIS_OK then
    //    Exit;

    pbTrack.Position := 0;

    if assigned(MedienBib.CurrentAudioFile) then
        ReplayGainCalculator.CalculateTrackGain(MedienBib.CurrentAudioFile.Pfad);

end;

procedure TTestForm.BtnAlbumRGClick(Sender: TObject);
var i:integer;
    Data: PTreeData;
    SelectedMp3s: TNodeArray;

begin
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

    NempReplayGainCalculator.OnSynchStreamInit           := OnStreamInit;
    NempReplayGainCalculator.OnSynchError                := OnCalculationError;
    NempReplayGainCalculator.OnSynchStreamProgress       := OnTrackProgress;
    NempReplayGainCalculator.OnSynchSingleTrackComplete  := OnSingleTrackComplete;
    NempReplayGainCalculator.OnSynchTrackComplete        := OnTrackComplete;
    NempReplayGainCalculator.OnSynchAlbumComplete        := OnAlbumComplete;

    NempReplayGainCalculator.OnSynchWriteMetaDataProgress := OnWriteMetaDataProgress;

    NempReplayGainCalculator.OnSynchAudioFile := OnAudioFileSynch;

    NempReplayGainCalculator.OnSynchMainProgress := OnMainProgress ;

    for i:=0 to length(SelectedMP3s)-1 do
    begin
        Data := Nemp_MainForm.VST.GetNodeData(SelectedMP3s[i]);
        NempReplayGainCalculator.AddAudioFile(Data^.FAudioFile);
    end;

    NempReplayGainCalculator.Start;

//
end;



end.
