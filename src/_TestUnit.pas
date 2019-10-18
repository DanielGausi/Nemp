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
    ProgressBar1: TProgressBar;
    BtnAlbumRG: TButton;
    Button1: TButton;
    procedure BtnGetreplayGainDataClick(Sender: TObject);
    procedure BtnAlbumRGClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ReplayGainCalculator: TReplayGainCalculator;

    Procedure OnStreamInit(aReplayGainCalculator: TReplayGainCalculator; ErrorCode: Integer);
    procedure OnTrackProgress(Sender: TReplayGainCalculator; aProgress: Single);
    procedure OnSingleTrackComplete(aReplayGainCalculator: TReplayGainCalculator; aIndex: Integer; aGain: Double; aPeak: SmallInt);

    procedure OnTrackComplete(aReplayGainCalculator: TReplayGainCalculator; aIndex: Integer; aGain: Double; aPeak: SmallInt);
    procedure OnAlbumComplete(aReplayGainCalculator: TReplayGainCalculator; aIndex: Integer; aGain: Double; aPeak: SmallInt);

    procedure OnCalculationError(aReplayGainCalculator: TReplayGainCalculator; ErrorCode: Integer);

    procedure OnAudioFileSynch(aFile: TAudioFile; aTrackGain, aAlbumGain: Double);
  end;

var
  TestForm: TTestForm;

  NempReplayGainCalculator: TNempReplayGainCalculator;


implementation

uses NempMainUnit, MainFormHelper, AudioFiles, ReplayGain;

{$R *.dfm}

procedure TTestForm.BtnAlbumRGClick(Sender: TObject);
var i:integer;
    Data: PTreeData;
    SelectedMp3s: TNodeArray;

    sl: TStringList;

begin

    SelectedMP3s := Nemp_MainForm.PlaylistVST.GetSortedSelection(False);
    if length(SelectedMP3s) = 0 then exit;


    // create Calculation thread
    NempReplayGainCalculator := TNempReplayGainCalculator.Create;
    NempReplayGainCalculator.MainWindowHandle := FOwnMessageHandler;

    NempReplayGainCalculator.OnSynchStreamInit           := OnStreamInit;
    NempReplayGainCalculator.OnSynchError                := OnCalculationError;
    NempReplayGainCalculator.OnSynchStreamProgress       := OnTrackProgress;
    NempReplayGainCalculator.OnSynchSingleTrackComplete  := OnSingleTrackComplete;
    NempReplayGainCalculator.OnSynchTrackComplete        := OnTrackComplete;
    NempReplayGainCalculator.OnSynchAlbumComplete        := OnAlbumComplete;

    NempReplayGainCalculator.OnSynchAudioFile := OnAudioFileSynch;

    for i:=0 to length(SelectedMP3s)-1 do
    begin
        Data := Nemp_MainForm.VST.GetNodeData(SelectedMP3s[i]);
        NempReplayGainCalculator.AddAudioFile(Data^.FAudioFile);
    end;

    NempReplayGainCalculator.Start;


    {
    sl := TStringList.Create;
    try
          for i:=0 to length(SelectedMP3s)-1 do
          begin
              Data := Nemp_MainForm.VST.GetNodeData(SelectedMP3s[i]);
              sl.Add( Data^.FAudioFile.Pfad);
          end;

          ReplayGainCalculator.CalculateAlbumGain(sl);
    finally
        sl.Free
    end;  }


//
end;

procedure TTestForm.BtnGetreplayGainDataClick(Sender: TObject);
begin
    //if InitGainAnalysis(44100) <> INIT_GAIN_ANALYSIS_OK then
    //    Exit;

    Progressbar1.Position := 0;

    if assigned(MedienBib.CurrentAudioFile) then
        ReplayGainCalculator.CalculateTrackGain(MedienBib.CurrentAudioFile.Pfad);

end;

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
    Progressbar1.Position := trunc(100* aProgress);
end;

procedure TTestForm.OnSingleTrackComplete(
  aReplayGainCalculator: TReplayGainCalculator; aIndex: Integer; aGain: Double; aPeak: SmallInt);
begin
    Memo1.Lines.Add(Format('TrackGain: %6.2f dB, Peak: %d,  (%s)',
                                [aGain, aPeak, ExtractFilename(aReplayGainCalculator.CurrentFilename)]));
    Memo1.Lines.Add('');
    Memo1.Lines.Add('');
    LblStatus.Caption := Format ( 'Calculation ReplayGain for %s complete.', [aReplayGainCalculator.CurrentFilename]);
    Progressbar1.Position := 0;
    // Application.ProcessMessages;
end;

procedure TTestForm.OnTrackComplete(aReplayGainCalculator: TReplayGainCalculator; aIndex: Integer; aGain: Double; aPeak: SmallInt);
begin
    Memo1.Lines.Add(Format('Track %d: %6.2f dB, Peak: %d,  (%s)',
                                [aIndex, aGain, aPeak, ExtractFilename(aReplayGainCalculator.CurrentFilename)]));
    Progressbar1.Position := 0;
    // Application.ProcessMessages;
end;


procedure TTestForm.OnAlbumComplete(aReplayGainCalculator: TReplayGainCalculator; aIndex: Integer; aGain: Double; aPeak: SmallInt);
begin
    Memo1.Lines.Add('---------------------');
    Memo1.Lines.Add(Format('AlbumGain: %6.2f dB, Peak: %d', [aGain, aPeak]));
    Memo1.Lines.Add('');
    Memo1.Lines.Add('');

    LblStatus.Caption := 'Calculation AlbumGain complete.';
    Progressbar1.Position := 0;
    // Application.ProcessMessages;
end;

procedure TTestForm.OnAudioFileSynch(aFile: TAudioFile; aTrackGain,
  aAlbumGain: Double);
var ListOfFiles : TObjectList;
    i: Integer;
    listFile: TAudioFile;
begin
    aFile.TrackGain := aTrackGain;
    aFile.AlbumGain := aAlbumGain;

    Memo1.Lines.Add('Synching ... ' + ExtractFilename(aFile.Pfad));

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
        RG_ERR_FreqNotSupported: Memo1.Lines.Add(Format('Error: Samplerate not supported (%s)', [aReplayGainCalculator.CurrentFilename]));
        RG_ERR_AlbumGainFreqChanged: Memo1.Lines.Add(Format('Warning: AlbumGain calculation cancelled (%s)', [aReplayGainCalculator.CurrentFilename]));

        BASS_ERROR_ENDED: ; // can happen sometimes ...

    end;
end;



end.
