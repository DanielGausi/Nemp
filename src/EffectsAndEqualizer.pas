unit EffectsAndEqualizer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  NempPanel, SkinButtons, MyDialogs, System.IniFiles,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,

  Nemp_RessourceStrings, Vcl.Menus, Vcl.ComCtrls;

type
  TFormEffectsAndEqualizer = class(TForm)
    GRPBOXEffekte: TGroupBox;
    HallShape: TShape;
    HallLBL: TLabel;
    EchoWetDryMixShape: TShape;
    EchoTimeShape: TShape;
    EchoTimeLBL: TLabel;
    EchoMixLBL: TLabel;
    EffekteLBL2: TLabel;
    EffekteLBL1: TLabel;
    SampleRateShape: TShape;
    SampleRateLBL: TLabel;
    EffekteLBL3: TLabel;
    DirectionPositionBTN: TSkinButton;
    Btn_EffectsOff: TBitBtn;
    EchoWetDryMixButton: TSkinButton;
    HallButton: TSkinButton;
    EchoTimeButton: TSkinButton;
    SampleRateButton: TSkinButton;
    BtnABRepeatSetA: TSkinButton;
    BtnABRepeatSetB: TSkinButton;
    BtnABRepeatUnset: TSkinButton;
    GRPBOXEqualizer: TGroupBox;
    EqualizerShape5: TShape;
    EqualizerShape2: TShape;
    EqualizerShape3: TShape;
    EqualizerShape4: TShape;
    EqualizerShape6: TShape;
    EqualizerShape7: TShape;
    EqualizerShape8: TShape;
    EqualizerShape9: TShape;
    EqualizerShape10: TShape;
    EQLBL1: TLabel;
    EQLBL2: TLabel;
    EQLBL3: TLabel;
    EQLBL4: TLabel;
    EQLBL5: TLabel;
    EQLBL6: TLabel;
    EQLBL7: TLabel;
    EQLBL8: TLabel;
    EQLBL9: TLabel;
    EQLBL10: TLabel;
    EqualizerShape1: TShape;
    EqualizerDefaultShape: TShape;
    EqualizerButton1: TSkinButton;
    EqualizerButton2: TSkinButton;
    EqualizerButton3: TSkinButton;
    EqualizerButton5: TSkinButton;
    EqualizerButton4: TSkinButton;
    EqualizerButton6: TSkinButton;
    EqualizerButton7: TSkinButton;
    EqualizerButton8: TSkinButton;
    EqualizerButton9: TSkinButton;
    EqualizerButton10: TSkinButton;
    Btn_EqualizerPresets: TSkinButton;
    ButtonNextEQ: TButton;
    ButtonPrevEQ: TButton;
    Button1: TButton;
    Equalizer_PopupMenu: TPopupMenu;
    PM_EQ_Disabled: TMenuItem;
    N27: TMenuItem;
    PM_EQ_Load: TMenuItem;
    PM_EQ_Save: TMenuItem;
    PM_EQ_Delete: TMenuItem;
    N45: TMenuItem;
    PM_EQ_RestoreStandard: TMenuItem;
    TrackBar1: TTrackBar;
    ProgressBar1: TProgressBar;
    procedure GRPBOXEffekteDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure GRPBOXEqualizerDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure NempPanelPaint(Sender: TObject);
    procedure HallShapeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure EffectsButtonEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure HallButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure HallButtonMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure HallButtonStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure FormCreate(Sender: TObject);
    procedure EchoWetDryMixShapeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure EchoTimeShapeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure EchoWetDryMixButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EchoWetDryMixButtonMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure EchoWetDryMixButtonStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure EchoTimeButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EchoTimeButtonMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SampleRateButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SampleRateButtonMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SampleRateButtonStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure SampleRateShapeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure SyncEffectValuesToVCL;
    procedure EqualizerButton1StartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure EqualizerButton1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure EqualizerButton1EndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure EqualizerButton1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EqualizerButton1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Btn_EqualizerPresetsClick(Sender: TObject);
    procedure PM_EQ_DisabledClick(Sender: TObject);
    procedure PM_EQ_RestoreStandardClick(Sender: TObject);
    procedure ButtonPrevEQClick(Sender: TObject);
    procedure DirectionPositionBTNClick(Sender: TObject);
    procedure BtnABRepeatSetAClick(Sender: TObject);
    procedure BtnABRepeatSetBClick(Sender: TObject);
    procedure BtnABRepeatUnsetClick(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure Btn_EffectsOffClick(Sender: TObject);
  private
    { Private declarations }

    // Speichert den Slidebutton, der gerade gedraggt wird
    DraggingSlideButton: TSkinButton;

    procedure SetGroupboxEffectsDragover;
  public
    { Public declarations }

    EqualizerButtons: Array[0..9] of TSkinButton;

    procedure SetGroupboxEQualizerDragover;
    procedure CorrectEQButton(band: Integer; ResetCaption: Boolean = True);
    function VCLEQToPlayer(idx: Integer): Single;
    function APIEQToPlayer(Value: Integer): Single;
    procedure CorrectHallButton;
    function VCLHallToPlayer: Single;
    procedure CorrectEchoButtons;
    function VCLEchoMixToPlayer: Single;
    function VCLEchoTimeToPlayer: Single;
    procedure CorrectSpeedButton;
    function VCLSpeedToPlayer: Single;
    procedure CorrectVCLForABRepeat;

    procedure ResetEffectButtons;

    procedure DeleteEQSettingsClick(Sender: TObject);
    procedure SaveEQSettingsClick(Sender: TObject);
    procedure SetEqualizerByName(aSetting: UnicodeString);
    function GetDefaultEQName(aIdx: Integer): String;
    procedure InitEqualizerMenuFormIni(aIni: TMemIniFile);
    procedure SetEqualizerFromPresetClick(Sender: TObject);
  end;

var
  FormEffectsAndEqualizer: TFormEffectsAndEqualizer;

implementation

{$R *.dfm}

uses NempMainUnit, Nemp_ConstantsAndTypes, gnugettext;


procedure TFormEffectsAndEqualizer.FormCreate(Sender: TObject);
var ini: TMemIniFile;
begin

    TranslateComponent (self);

    EqualizerButtons[0] := EqualizerButton1;
    EqualizerButtons[1] := EqualizerButton2;
    EqualizerButtons[2] := EqualizerButton3;
    EqualizerButtons[3] := EqualizerButton4;
    EqualizerButtons[4] := EqualizerButton5;
    EqualizerButtons[5] := EqualizerButton6;
    EqualizerButtons[6] := EqualizerButton7;
    EqualizerButtons[7] := EqualizerButton8;
    EqualizerButtons[8] := EqualizerButton9;
    EqualizerButtons[9] := EqualizerButton10;

    ini := TMeminiFile.Create(SavePath + 'Nemp_EQ.ini');
    try
        InitEqualizerMenuFormIni(ini);
        Btn_EqualizerPresets.Caption := NempPlayer.EQSettingName;
    finally
        ini.Free
    end;
end;

procedure TFormEffectsAndEqualizer.FormShow(Sender: TObject);
begin
    SyncEffectValuesToVCL
end;


procedure TFormEffectsAndEqualizer.SyncEffectValuesToVCL;
var i: Integer;
begin
    CorrectHallButton;
    CorrectEchoButtons;
    CorrectSpeedButton;
    for i := 0 to 9 do CorrectEQButton(i);
end;


procedure TFormEffectsAndEqualizer.CorrectEQButton(band: Integer; ResetCaption: Boolean = True);
begin

        // Valid values:  EQ_NEW_MAX ... - EQ_NEW_MAX (i.e. 10 ... - 10)
        // Bass allows values in 15 .. -15, but this sounds often bad.
        // So we have to map EQ_NEW_MAX ... - EQ_NEW_MAX into
        //               Shape.Top ...  Shape.Top + Shape.Height - Button.Height
        EqualizerButtons[band].Top := EqualizerShape1.Top  +
            Round((EQ_NEW_MAX - NempPlayer.fxgain[band])
                  * (EqualizerShape1.Height - EqualizerButtons[band].Height)
                  / (2*EQ_NEW_MAX));
        if ResetCaption then
            Btn_EqualizerPresets.Caption := NempPlayer.EQSettingName;

end;
function TFormEffectsAndEqualizer.VCLEQToPlayer(idx: Integer): Single;
begin
    // We have to map Shape.Top ...  Shape.Top + Shape.Height - Button.Height
    //           into EQ_NEW_MAX ... -EQ_NEW_MAX

        result := EQ_NEW_MAX -
          ((EqualizerButtons[idx].Top - EqualizerShape1.Top)
          * (2*EQ_NEW_MAX)
          / ((EqualizerShape1.Height - EqualizerButtons[idx].Height)));
end;
function TFormEffectsAndEqualizer.APIEQToPlayer(Value: Integer): Single;
begin
    result := EQ_NEW_MAX - ( Value / EQ_NEW_FACTOR );
end;


procedure TFormEffectsAndEqualizer.CorrectHallButton;
begin
        HallButton.Left := HallShape.Left +
            Round(sqr((NempPlayer.ReverbMix + 96)
              * sqrt(HallShape.Width - HallButton.Width)
              / 96));
        HallLBL.Caption := Inttostr(Round(NempPlayer.ReverbMix)) + 'dB';
end;
function TFormEffectsAndEqualizer.VCLHallToPlayer: Single;
begin
      result := 96/sqrt(HallShape.Width - HallButton.Width) * sqrt(HallButton.Left - HallShape.Left) - 96;
end;




procedure TFormEffectsAndEqualizer.CorrectEchoButtons;
begin
        EchoWetDryMixButton.Left := EchoWetDryMixShape.Left +
            Round(NempPlayer.EchoWetDryMix
              * (EchoWetDryMixShape.Width - EchoWetDryMixButton.Width)
              / 50);
        EchoTimeButton.Left := EchoWetDryMixShape.Left
            + Round((NempPlayer.EchoTime - 100)
              * (EchoTimeShape.Width - EchoTimeButton.Width)
              / 1900);
        EchoMixLBL.Caption := Inttostr(Round(NempPlayer.EchoWetDryMix)) + '%';
        EchoTimeLBL.Caption := Inttostr(Round(NempPlayer.EchoTime)) + 'ms';

end;
function TFormEffectsAndEqualizer.VCLEchoMixToPlayer: Single;
begin
        result := (EchoWetDryMixButton.Left - EchoWetDryMixShape.Left)
          * 50
          / (EchoWetDryMixShape.Width - EchoWetDryMixButton.Width);
end;
function TFormEffectsAndEqualizer.VCLEchoTimeToPlayer: Single;
begin
      result := (EchoTimeButton.Left - EchoWetDryMixShape.Left)
          * 1900
          / (EchoTimeShape.Width - EchoTimeButton.Width)
      + 100;
end;



procedure TFormEffectsAndEqualizer.CorrectSpeedButton;
var middle, whole: Integer;
begin
    begin
        middle := (SampleRateShape.Width DIV 2) - (SampleRateButton.Width Div 2) + SampleRateShape.Left;
        whole := sqr(middle - SampleRateShape.Left);

        if NempPlayer.Speed > 1 then
          SampleRateButton.Left := middle + Round(sqrt((NempPlayer.Speed - 1) / 2 * whole))
        else
          SampleRateButton.Left := middle - Round(sqrt((1 - NempPlayer.Speed) * 3/2 * whole));
        SampleRateLBL.Caption := inttostr(Round(NempPlayer.Speed * 100)) + '%';
end;
end;
function TFormEffectsAndEqualizer.VCLSpeedToPlayer: Single;
var middle, whole: Integer;
begin
      middle := (SampleRateShape.Width DIV 2) - (SampleRateButton.Width Div 2) + SampleRateShape.Left;
      whole := sqr(middle - SampleRateShape.Left);

      if SampleRateButton.Left < middle then
        result := sqr(SampleRateButton.Left - middle) * 0.66 / (-whole) + 1
      else
        result := sqr(SampleRateButton.Left - middle) * 2 / whole + 1;
end;


procedure TFormEffectsAndEqualizer.CorrectVCLForABRepeat;
var EnableControls: Boolean;
begin
    with Nemp_MainForm do
    begin
        //ab1.Left := Round(NempPlayer.ABRepeatA * (SlideBarShape.Width-SlideBarButton.Width)) - (ab1.Width Div 2) + SlideBarShape.Left + (SlideBarButton.Width Div 2);
        //ab2.Left := Round(NempPlayer.ABRepeatB * (SlideBarShape.Width-SlideBarButton.Width)) - (ab2.Width Div 2) + SlideBarShape.Left + (SlideBarButton.Width Div 2);

        ab1.Left := Round(NempPlayer.ABRepeatA * (SlideBarShape.Width)) + SlideBarShape.Left;
        ab2.Left := Round(NempPlayer.ABRepeatB * (SlideBarShape.Width)) + SlideBarShape.Left - ab2.Width;


        ab1.Visible := NempPlayer.ABRepeatActive;
        ab2.Visible := NempPlayer.ABRepeatActive;
        PM_ABRepeat.Checked := NempPlayer.ABRepeatActive;

        EnableControls   := Assigned(NempPlayer.MainAudioFile) and (not NempPlayer.MainAudioFile.isStream);

        PM_ABRepeat      .Enabled := EnableControls;
        PM_ABRepeatSetA  .Enabled := EnableControls;
        PM_ABRepeatSetB  .Enabled := EnableControls;
    end;

    BtnABRepeatSetA  .Enabled := EnableControls;
    BtnABRepeatSetB  .Enabled := EnableControls;
    BtnABRepeatUnSet .Enabled := NempPlayer.ABRepeatActive and EnableControls;
end;


procedure TFormEffectsAndEqualizer.GRPBOXEqualizerDragOver(Sender,
  Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var NewPos, BtnHeight: Integer;
begin
    BtnHeight := DraggingSlideButton.Height;
    if (Sender is TGroupBox) then
        NewPos := y - (BtnHeight Div 2)
    else
        NewPos := (Sender as TControl).Top + y - (BtnHeight Div 2);

  //if NewPos >= AudioPanel.Height - GRPBOXEqualizer.Top - BtnHeight{53} then
  //  NewPos := AudioPanel.Height - GRPBOXEqualizer.Top - BtnHeight{53};

  if NewPos <= EqualizerShape1.Top then
      NewPos := EqualizerShape1.Top
    else
      if NewPos >= EqualizerShape1.Top + EqualizerShape1.Height - BtnHeight then
        NewPos := EqualizerShape1.Top + EqualizerShape1.Height - BtnHeight
      //else
      //  if // Button zuweit unten, dass ein weiteres draggen die TopMAinPanel-Grenzen verlässt
      //    NewPos >= AudioPanel.Height - GRPBOXEqualizer.Top - BtnHeight{53} then
      //      NewPos := AudioPanel.Height - GRPBOXEqualizer.Top - BtnHeight{53}
       // else
          ; //NewPos := NewPos;

  DraggingSlideButton.Top := NewPos;

  NempPlayer.SetEqualizer(DraggingSlideButton.Tag, VCLEQToPlayer(DraggingSlideButton.Tag));

  NempPlayer.EQSettingName := (MainForm_BtnEqualizerPresetsCustom);
  Btn_EqualizerPresets.Caption := (MainForm_BtnEqualizerPresetsCustom);
end;





procedure TFormEffectsAndEqualizer.SetGroupboxEffectsDragover;
begin
     Btn_EffectsOff        .OnDragOver := GRPBOXEffekteDragOver;
     DirectionPositionBTN  .OnDragOver := GRPBOXEffekteDragOver;
     EchoMixLBL            .OnDragOver := GRPBOXEffekteDragOver;
     EchoTimeButton        .OnDragOver := GRPBOXEffekteDragOver;
     EchoTimeLBL           .OnDragOver := GRPBOXEffekteDragOver;
     EchoTimeShape         .OnDragOver := GRPBOXEffekteDragOver;
     EchoWetDryMixButton   .OnDragOver := GRPBOXEffekteDragOver;
     EchoWetDryMixShape    .OnDragOver := GRPBOXEffekteDragOver;
     EffekteLBL1           .OnDragOver := GRPBOXEffekteDragOver;
     EffekteLBL2           .OnDragOver := GRPBOXEffekteDragOver;
     EffekteLBL3           .OnDragOver := GRPBOXEffekteDragOver;
     //EffekteLBL4           .OnDragOver := GRPBOXEffekteDragOver;
     HallButton            .OnDragOver := GRPBOXEffekteDragOver;
     HallLBL               .OnDragOver := GRPBOXEffekteDragOver;
     HallShape             .OnDragOver := GRPBOXEffekteDragOver;
     //PosRewindCB           .OnDragOver := GRPBOXEffekteDragOver;
     SampleRateButton      .OnDragOver := GRPBOXEffekteDragOver;
     SampleRateLBL         .OnDragOver := GRPBOXEffekteDragOver;
     SampleRateShape       .OnDragOver := GRPBOXEffekteDragOver;

     HallShape             .OnDragOver := GRPBOXEffekteDragOver;
     EchoWetDryMixShape    .OnDragOver := GRPBOXEffekteDragOver;
     EchoTimeShape         .OnDragOver := GRPBOXEffekteDragOver;
     SampleRateShape       .OnDragOver := GRPBOXEffekteDragOver;
end;



procedure TFormEffectsAndEqualizer.BtnABRepeatSetAClick(Sender: TObject);
begin
    NempPlayer.SetASync(NempPlayer.Progress);
    CorrectVCLForABRepeat;
end;

procedure TFormEffectsAndEqualizer.BtnABRepeatSetBClick(Sender: TObject);
begin
    NempPlayer.SetBSync(NempPlayer.Progress);
    CorrectVCLForABRepeat;
end;

procedure TFormEffectsAndEqualizer.BtnABRepeatUnsetClick(Sender: TObject);
begin
    if NempPlayer.ABRepeatActive then
        NempPlayer.RemoveABSyncs
    else
        NempPlayer.SetABSyncs(NempPlayer.Progress, -1);
    CorrectVCLForABRepeat;
end;

procedure TFormEffectsAndEqualizer.Btn_EffectsOffClick(Sender: TObject);
begin
  HallButtonMouseDown(HallButton, mbright, [], 0,0);
  EchoWetDryMixButtonMouseDown(EchoWetDryMixButton, mbright, [], 0,0);
  EchoTimeButtonMouseDown(EchoTimeButton, mbright, [], 0,0);
  SampleRateButtonMouseDown(SampleRateButton, mbright, [], 0,0);
end;

procedure TFormEffectsAndEqualizer.Btn_EqualizerPresetsClick(Sender: TObject);
var point: TPoint;
begin
  GetCursorPos(Point);
  Equalizer_PopupMenu.Popup(Point.X, Point.Y);
end;

procedure TFormEffectsAndEqualizer.ButtonPrevEQClick(Sender: TObject);
var //currentSetting: String;
    currentIdx, maxIdx, nextIdx: Integer;
    newSetting: String;
    Ini: TMeminiFile;
begin
    // Get the Index of the Current setting
    currentIdx := GetDefaultEqualizerIndex(NempPlayer.EQSettingName);

    // Get next Element
    Ini := TMeminiFile.Create(SavePath + 'Nemp_EQ.ini');
    try
        maxIdx := Ini.ReadInteger('Summary', 'Max', 17);

        if (Sender as TButton).Tag = 0 then
        begin
            if currentIdx <= 0 then
                nextIdx := maxIdx
            else
                nextIdx := currentIdx - 1;
        end else
        begin
            if currentIdx >= maxIdx then
                nextIdx := 0
            else
                nextIdx := currentIdx + 1;
        end;

        newSetting := Ini.ReadString('Summary', 'Name'+IntToStr(nextIdx), GetDefaultEQName(nextIdx));
        SetEqualizerByName(newSetting);

    finally
        Ini.Free;
    end;

end;

procedure TFormEffectsAndEqualizer.GRPBOXEffekteDragOver(Sender,
  Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var NewPos: Integer;
begin
    if (Sender is TGroupBox) then
        NewPos := x - (DraggingSlideButton.Width Div 2)
    else
        NewPos := (Sender as TControl).Left + x - (DraggingSlideButton.Width Div 2);
    // Die Shapes sind hier alle gleich - also z.B. das HallShape nehmen
    if NewPos <= HallShape.Left then
        NewPos := HallShape.Left
    else
        if NewPos >= HallShape.Left + HallShape.Width - DraggingSlideButton.Width then
            NewPos := HallShape.Left + HallShape.Width - DraggingSlideButton.Width;

    DraggingSlideButton.Left := NewPos;

    if DraggingSlideButton = Hallbutton then
    begin
      NempPlayer.ReverbMix := VCLHallToPlayer;
      CorrectHallButton;
    end else
      if DraggingSlideButton = EchoWetDryMixButton then
      begin
        NempPlayer.EchoWetDryMix := VCLEchoMixToPlayer;
        CorrectEchoButtons;
      end else
        if DraggingSlideButton = EchoTimeButton then
        begin
          NempPlayer.EchoTime := VCLEchoTimeToPlayer;
          CorrectEchoButtons;
        end else
          if DraggingSlideButton = SampleRateButton then
          begin
            NempPlayer.Speed := VCLSpeedToPlayer;
            CorrectSpeedButton;
          end;
end;

procedure TFormEffectsAndEqualizer.EffectsButtonEndDrag(Sender, Target: TObject; X,
  Y: Integer);
begin
    ClipCursor(nil);

    HallShape.Repaint;
    EchoWetDryMixShape.Repaint;
    EchoTimeShape.Repaint;
    SamplerateShape.Repaint;

    GRPBoxEffekte.Repaint;
end;


{
========================================
Event-Handler for Echo
========================================
}

procedure TFormEffectsAndEqualizer.EchoWetDryMixShapeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var NewPos: Integer;
begin
  if Button = mbRight then
    NewPos := EchoWetDryMixShape.Left
  else
    NewPos := EchoWetDryMixShape.Left + x - (EchoWetDryMixButton.Width Div 2);
  if NewPos <= EchoWetDryMixShape.Left then
      EchoWetDryMixButton.Left := EchoWetDryMixShape.Left
    else
      if NewPos >= EchoWetDryMixShape.Left + EchoWetDryMixShape.Width - EchoWetDryMixButton.Width then
        EchoWetDryMixButton.Left := EchoWetDryMixShape.Left + EchoWetDryMixShape.Width - EchoWetDryMixButton.Width
      else
        EchoWetDryMixButton.Left := NewPos;

  NempPlayer.EchoWetDryMix := VCLEchoMixToPlayer;//  (EchoWetDryMixButton.Left, -1, SETFX_MODE_VCL);
  CorrectEchoButtons;
end;
procedure TFormEffectsAndEqualizer.EchoWetDryMixButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var newpos: integer;
begin
  case key of
    vk_Left: NewPos := (Sender as TControl).Left - 1;
    vk_Right: NewPos := (Sender as TControl).Left + 1;
    vk_Up: begin
                HallButton.SetFocus;
                exit;
           end;
    vk_Down: begin
                EchoTimeButton.SetFocus;
                exit;
             end;
    vk_Space: NewPos := EchoWetDryMixShape.Left; // Default-Stellung
    else NewPos := (Sender as TControl).Left;
  end;
  if NewPos <= EchoWetDryMixShape.Left then
      NewPos := EchoWetDryMixShape.Left
    else
      if NewPos >= EchoWetDryMixShape.Left + EchoWetDryMixShape.Width - EchoWetDryMixButton.Width then
        NewPos := EchoWetDryMixShape.Left + EchoWetDryMixShape.Width - EchoWetDryMixButton.Width;
  EchoWetDryMixButton.Left := NewPos;
  NempPlayer.EchoWetDryMix := VCLEchoMixToPlayer;
  CorrectEchoButtons;
end;
procedure TFormEffectsAndEqualizer.EchoWetDryMixButtonMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if Button = mbRight then
  begin
    NempPlayer.EchoWetDryMix := 0;
    CorrectEchoButtons;
  end;
end;
procedure TFormEffectsAndEqualizer.EchoWetDryMixButtonStartDrag(Sender: TObject;
  var DragObject: TDragObject);
var Arect: TRect;
// Für beide Echo Buttons
begin
  SetGroupboxEffectsDragover;
  DraggingSlideButton := (Sender as TSkinButton);

  with (Sender as TControl) do
  begin
    Begindrag(false);
    ARect.TopLeft := GRPBOXEffekte.ClientToScreen(Point(0,0));
    ARect.BottomRight := (GRPBOXEffekte.ClientToScreen(Point(GRPBOXEffekte.Width, GRPBOXEffekte.Height)));
    ClipCursor(@Arect);
  end;
end;

// ==============================================

procedure TFormEffectsAndEqualizer.EchoTimeShapeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var NewPos: Integer;
begin
  if Button = mbRight then
    NewPos := EchoWetDryMixShape.Left
  else
    NewPos := EchoTimeShape.Left + x - (EchoTimeButton.Width Div 2);
  if NewPos <= EchoTimeShape.Left then
      EchoTimeButton.Left := EchoTimeShape.Left
    else
      if NewPos >= EchoTimeShape.Left + EchoTimeShape.Width - EchoTimeButton.Width then
        EchoTimeButton.Left := EchoTimeShape.Left + EchoTimeShape.Width - EchoTimeButton.Width
      else
        EchoTimeButton.Left := NewPos;

  NempPlayer.EchoTime := VCLEchoTimeToPlayer;
  CorrectEchoButtons;
end;
procedure TFormEffectsAndEqualizer.EchoTimeButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var newpos: integer;
begin
  case key of
    vk_Left: NewPos := (Sender as TControl).Left - 1;
    vk_Right: NewPos := (Sender as TControl).Left + 1;
    vk_Down: begin
                SampleRateButton.SetFocus;
                exit;
             end;
    vk_Up: begin
                EchoWetDryMixButton.SetFocus;
                exit;
           end;
    vk_Space: NewPos := EchoTimeShape.Left;  // Default-Stellung
    else NewPos := (Sender as TControl).Left;
  end;
  if NewPos <= EchoTimeShape.Left then
      NewPos := EchoTimeShape.Left
    else
      if NewPos >= EchoTimeShape.Left + EchoTimeShape.Width - EchoTimeButton.Width then
        NewPos := EchoTimeShape.Left + EchoTimeShape.Width - EchoTimeButton.Width;

  EchoTimeButton.Left := NewPos;
  NempPlayer.EchoTime := VCLEchoTimeToPlayer;
  CorrectEchoButtons;
end;
procedure TFormEffectsAndEqualizer.EchoTimeButtonMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
  begin
    NempPlayer.EchoTime := 100;
    CorrectEchoButtons;
  end;
end;


{
========================================
Event-Handler for Speed
========================================
}
procedure TFormEffectsAndEqualizer.SampleRateShapeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var NewPos: Integer;
begin
  if Button = mbRight then
    Newpos := (SampleRateShape.Width DIV 2) - (SampleRateButton.Width Div 2) + SampleRateShape.Left
  else
    NewPos := SampleRateShape.Left + x - (SampleRateButton.Width Div 2);
  if NewPos <= SampleRateShape.Left then
      SampleRateButton.Left := SampleRateShape.Left
    else
      if NewPos >= SampleRateShape.Left + SampleRateShape.Width - SampleRateButton.Width then
        SampleRateButton.Left := SampleRateShape.Left + SampleRateShape.Width - SampleRateButton.Width
      else
        SampleRateButton.Left := NewPos;
  NempPlayer.Speed := VCLSpeedToPlayer; // (SampleRateButton.Left, SETFX_MODE_VCL);
  CorrectSpeedButton;
end;
procedure TFormEffectsAndEqualizer.SampleRateButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var newpos: integer;
begin
  case key of
    vk_Left: NewPos := (Sender as TControl).Left - 1;
    vk_Right: NewPos := (Sender as TControl).Left + 1;
    vk_Up: begin
              EchoTimeButton.SetFocus;
              exit;
            end;
    vk_Down: begin
              DirectionPositionBTN.SetFocus;
              exit;
            end;
    vk_Space: NewPos := (SampleRateShape.Width DIV 2) - (SampleRateButton.Width Div 2) + SampleRateShape.Left; // Default-Stellung
    else NewPos := (Sender as TControl).Left;
  end;
  if NewPos <= SampleRateShape.Left then
      NewPos := SampleRateShape.Left
    else
      if NewPos >= SampleRateShape.Left + SampleRateShape.Width - SampleRateButton.Width then
        NewPos := SampleRateShape.Left + SampleRateShape.Width - SampleRateButton.Width;
  SampleRateButton.Left := NewPos;
  NempPlayer.Speed := VCLSpeedToPlayer ; //(Sender as TButton).Left, SETFX_MODE_VCL);
  CorrectSpeedButton;
end;

procedure TFormEffectsAndEqualizer.SampleRateButtonMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var newpos: integer;
begin
  if Button = mbRight then
  begin
    NewPos := (SampleRateShape.Width DIV 2) - (SampleRateButton.Width Div 2) + SampleRateShape.Left;
    SampleRateButton.Left := NewPos;
    NempPlayer.Speed := 1;
    CorrectSpeedButton;
  end;
end;

procedure TFormEffectsAndEqualizer.SampleRateButtonStartDrag(Sender: TObject;
  var DragObject: TDragObject);
var Arect: TRect;
begin
  SetGroupboxEffectsDragover;
  DraggingSlideButton := (Sender as TSkinButton);
  with (Sender as TControl) do
  begin
    Begindrag(false);
    ARect.TopLeft     := GRPBOXEffekte.ClientToScreen(Point(0,0));
    ARect.BottomRight := GRPBOXEffekte.ClientToScreen(Point(GRPBOXEffekte.Width, GRPBOXEffekte.Height));
    ClipCursor(@Arect);
  end;

end;



{
========================================
Event-Handler for Hall
========================================
}
procedure TFormEffectsAndEqualizer.HallShapeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var NewPos: Integer;
begin
  if Button = mbRight then
    NewPos := HallShape.Left
  else
    NewPos := HallShape.Left + x - (HallButton.Width Div 2);
  if NewPos <= HallShape.Left then
      NewPos := HallShape.Left
    else
      if NewPos >= HallShape.Left + HallShape.Width - HallButton.Width then
        NewPos := HallShape.Left + HallShape.Width - HallButton.Width
      else
        NewPos := NewPos;
  HallButton.Left := NewPos;

  NempPlayer.ReverbMix := VCLHallToPlayer;
  CorrectHallButton;
end;
// ===============================
procedure TFormEffectsAndEqualizer.HallButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var Newpos: Integer;
begin
  case key of
    vk_Left: NewPos := (Sender as TControl).Left - 1;
    vk_Right: NewPos := (Sender as TControl).Left + 1;
    vk_Down: begin
                EchoWetDryMixButton.SetFocus;
                exit;
             end;
    vk_Up: begin
                Btn_EffectsOff.SetFocus;
                exit;
            end;
    vk_Space: NewPos := HallShape.Left; // Default-Stellung
    else NewPos := (Sender as TControl).Left;
  end;
  if NewPos <= HallShape.Left then
      NewPos := HallShape.Left
    else
      if NewPos >= HallShape.Left + HallShape.Width - HallButton.Width then
        NewPos := HallShape.Left + HallShape.Width - HallButton.Width;

  HallButton.Left := NewPos;
  NempPlayer.ReverbMix := VCLHallToPlayer;
  CorrectHallButton;
end;
procedure TFormEffectsAndEqualizer.HallButtonMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
  begin
    NempPlayer.ReverbMix := -96;
    CorrectHallButton;
  end;
end;
procedure TFormEffectsAndEqualizer.HallButtonStartDrag(Sender: TObject;
  var DragObject: TDragObject);
var Arect: TRect;
begin
  SetGroupboxEffectsDragover;
  DraggingSlideButton := (Sender as TSkinButton);
  with (Sender as TControl) do
  begin
    Begindrag(false);
    ARect.TopLeft :=  GRPBOXEffekte.ClientToScreen(Point(0,0));
    ARect.BottomRight :=  GRPBOXEffekte.ClientToScreen(Point(GRPBOXEffekte.Width, GRPBOXEffekte.Height));
    ClipCursor(@Arect);
  end;
end;


procedure TFormEffectsAndEqualizer.SetGroupboxEQualizerDragover;
begin
    Btn_EqualizerPresets  .OnDragOver := GRPBOXEqualizerDragOver;
    EQLBL1                .OnDragOver := GRPBOXEqualizerDragOver;
    EQLBL2                .OnDragOver := GRPBOXEqualizerDragOver;
    EQLBL3                .OnDragOver := GRPBOXEqualizerDragOver;
    EQLBL4                .OnDragOver := GRPBOXEqualizerDragOver;
    EQLBL5                .OnDragOver := GRPBOXEqualizerDragOver;
    EQLBL6                .OnDragOver := GRPBOXEqualizerDragOver;
    EQLBL7                .OnDragOver := GRPBOXEqualizerDragOver;
    EQLBL8                .OnDragOver := GRPBOXEqualizerDragOver;
    EQLBL9                .OnDragOver := GRPBOXEqualizerDragOver;
    EQLBL10               .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerButton1      .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerButton2      .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerButton3      .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerButton4      .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerButton5      .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerButton6      .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerButton7      .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerButton8      .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerButton9      .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerButton10     .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerDefaultShape .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerShape1       .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerShape2       .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerShape3       .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerShape4       .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerShape5       .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerShape6       .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerShape7       .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerShape8       .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerShape9       .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerShape10      .OnDragOver := GRPBOXEqualizerDragOver;
end;

procedure TFormEffectsAndEqualizer.TrackBar1Change(Sender: TObject);
begin

end;

{
========================================
Event-Handler for Equalizer
========================================
}
procedure TFormEffectsAndEqualizer.EqualizerButton1DragOver(Sender,
  Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
Var newpos: integer;
  localTag: Integer;
  BtnHeight: Integer;
begin
  localtag := (Sender as TControl).Tag;
  BtnHeight := EqualizerButtons[localTag].Height;
  NewPos := (Sender as TControl).Top + y - (BtnHeight Div 2);


  //if NewPos >= AudioPanel.Height - GRPBOXEqualizer.Top - BtnHeight{53} then
  //  NewPos := AudioPanel.Height - GRPBOXEqualizer.Top - BtnHeight{53};

  if NewPos <= EqualizerShape1.Top then
      NewPos := EqualizerShape1.Top
    else
      if NewPos >= EqualizerShape1.Top + EqualizerShape1.Height - BtnHeight then
        NewPos := EqualizerShape1.Top + EqualizerShape1.Height - BtnHeight
     // else
     //   if // Button zuweit unten, dass ein weiteres draggen die TopMAinPanel-Grenzen verlässt
     //     NewPos >= AudioPanel.Height - GRPBOXEqualizer.Top - BtnHeight{53} then
     //       NewPos := AudioPanel.Height - GRPBOXEqualizer.Top - BtnHeight{53}
     //   else
          ; //NewPos := NewPos;

  EqualizerButtons[localTag].Top := NewPos;
  NempPlayer.SetEqualizer(localTag, VCLEQToPlayer(localTag));

  NempPlayer.EQSettingName := (MainForm_BtnEqualizerPresetsCustom);
  Btn_EqualizerPresets.Caption := (MainForm_BtnEqualizerPresetsCustom);
end;
procedure TFormEffectsAndEqualizer.EqualizerButton1EndDrag(Sender,
  Target: TObject; X, Y: Integer);
begin
  ClipCursor(Nil);
end;

procedure TFormEffectsAndEqualizer.EqualizerButton1KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var Newpos: Integer;
    localTag, BtnHeight: Integer;
begin
  localtag := (Sender as TControl).Tag;
  BtnHeight := EqualizerButtons[localTag].Height;

  case key of
    vk_up: NewPos := (Sender as TControl).Top - 1;
    vk_Down: NewPos := (Sender as TControl).Top + 1;
    vk_Space: NewPos := (EqualizerShape1.Top + ((EqualizerShape1.Height - BtnHeight) Div 2) )   ;//62; // Default-Stellung

    vk_Right : begin
                  (EqualizerButtons[(localTag + 1) mod 10]).SetFocus;
                  exit;
               end;
    vk_Left : begin
                  (EqualizerButtons[(localTag + 9 ) mod 10]).SetFocus;
                  exit;
               end;

    else NewPos := EqualizerButtons[localTag].Top;
  end;

  if NewPos <= EqualizerShape1.Top then
      NewPos := EqualizerShape1.Top
  else
      if NewPos >= EqualizerShape1.Top + EqualizerShape1.Height - BtnHeight then
          NewPos := EqualizerShape1.Top + EqualizerShape1.Height - BtnHeight;

  EqualizerButtons[localTag].Top := NewPos;
  NempPlayer.SetEqualizer(localTag, VCLEQToPlayer(localTag));
  NempPlayer.EQSettingName := (MainForm_BtnEqualizerPresetsCustom);
  Btn_EqualizerPresets.Caption := (MainForm_BtnEqualizerPresetsCustom);
end;

procedure TFormEffectsAndEqualizer.EqualizerButton1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var LocalTag: integer;
begin
  if Button = mbRight then
  begin
      LocalTag := (Sender as TControl).Tag;
      NempPlayer.SetEqualizer((Sender as TControl).Tag, 0);
      CorrectEQButton(LocalTag);

      NempPlayer.EQSettingName := (MainForm_BtnEqualizerPresetsCustom);
      Btn_EqualizerPresets.Caption := (MainForm_BtnEqualizerPresetsCustom);
  end;
end;

procedure TFormEffectsAndEqualizer.EqualizerButton1StartDrag(Sender: TObject;
  var DragObject: TDragObject);
var Arect: TRect;
begin
  SetGroupboxEQualizerDragover;
  (Sender as TSkinButton).OnDragOver := EqualizerButton1DragOver;
  DraggingSlideButton := (Sender as TSkinButton);

  with (Sender as TControl) do
  begin
    Begindrag(false);
    ARect.TopLeft := GRPBOXEqualizer.ClientToScreen(Point(0,0));
    ARect.BottomRight := GRPBOXEqualizer.ClientToScreen(Point(GRPBOXEqualizer.Width, GRPBOXEqualizer.Height));
    ClipCursor(@Arect);
  end;
end;




{
Panel-Paint (will be removed, probably)
}
procedure TFormEffectsAndEqualizer.NempPanelPaint(Sender: TObject);
begin
   { if (Sender as TNempPanel).Tag <= 3 then
        Nemp_MainForm.NempSkin.DrawAPanel((Sender as TNempPanel), Nemp_MainForm.NempSkin.UseBackgroundImages[(Sender as TNempPanel).Tag])
    else
        Nemp_MainForm.NempSkin.DrawAPanel((Sender as TNempPanel), True);
        }
end;


function TFormEffectsAndEqualizer.GetDefaultEQName(aIdx: Integer): String;
begin
  if (aIdx >= 0) and (aIdx <= 17) then
      result := EQ_NAMES[aIdx]
  else
      result := 'Unknown equalizer setting (' + IntToStr(aIdx) + ')';
end;

procedure TFormEffectsAndEqualizer.SetEqualizerByName(aSetting: UnicodeString);
var i, DefIndex: integer;
  preset: single;
  ini: TMeminiFile;
begin
    // DefaultIndex ermitteln (für die voreingestellten Settings, falls die Ini leer ist)
    DefIndex := GetDefaultEqualizerIndex(aSetting);

    // Daten aus Ini laden
    ini := TMeminiFile.Create(SavePath + 'Nemp_EQ.ini');
    try
        for i := 0 to 9 do
        begin
            preset := Ini.ReadInteger(aSetting, 'EQ'+inttostr(i+1), Round(EQ_DEFAULTPRESETS[DefIndex][i])) / EQ_NEW_FACTOR ;
            NempPlayer.SetEqualizer(i, preset);
            CorrectEQButton(i, False);
        end;
    finally
        ini.Free
    end;

    if SameText(aSetting,EQ_NAMES[0]) then
        NempPlayer.EQSettingName := (MainForm_BtnEqualizerPresetsSelect)
    else
        NempPlayer.EQSettingName := aSetting;
    Btn_EqualizerPresets.Caption := NempPlayer.EQSettingName;

end;

procedure TFormEffectsAndEqualizer.SetEqualizerFromPresetClick(Sender: TObject);
var PresetName: String;
begin
  // Gewählte Einstellung erkennen
  PresetName := (Sender as TMenuItem).Caption;

  SetEqualizerByName(PresetName);
end;

procedure TFormEffectsAndEqualizer.SaveEQSettingsClick(Sender: TObject);
var i, c: integer;
    preset: Integer;
    ini: TMemIniFile;
    PresetName, existingName: String;
    NewName: String;
    Ok, Check, Cancel, NewNameExists, GoOn: Boolean;
begin
  case (Sender as TMenuItem).Tag of
      0: begin
            // Gewählte Einstellung erkennen
            PresetName := (Sender as TMenuItem).Caption;
            if TranslateMessageDLG(Format(MainForm_BtnEqualizerOverwriteQuery, [PresetName]), mtInformation, [mbYes, mbNo], 0) = mrYes then
            begin
                // Daten aus Ini laden
                ini := TMeminiFile.Create(SavePath + 'Nemp_EQ.ini');
                try
                    for i := 0 to 9 do
                    begin
                        preset := Round(NempPlayer.fxGain[i] * EQ_NEW_FACTOR);
                        ini.WriteInteger(PresetName, 'EQ'+inttostr(i+1), preset);
                    end;
                    try
                        Ini.UpdateFile;
                    except
                        // Silent Exception
                    end;
                finally
                    ini.Free
                end;
                NempPlayer.EQSettingName := (Sender as TMenuItem).Caption;
                Btn_EqualizerPresets.Caption := (Sender as TMenuItem).Caption;
            end;
      end
  else
      begin
          // Save unter neuem Namen
          NewName := 'New preset';
          // Eingabe - solange wiederholen, bis Abbruch oder Eingabe gültig
          repeat
              Cancel := False;
              Check := False;
              Ok := InputQuery(MainForm_BtnEqualizerSaveNewCaption, MainForm_BtnEqualizerSaveNewPrompt, NewName);
              if OK then
              begin
                  NewName := trim(NewName);
                  Check := length(NewName) >= 1;
                  for i := 1 to length(NewName) do
                  begin
                      if not CharInSet(NewName[i], ['a'..'z', ' ', 'A'..'Z', '0'..'9']) then //(NewName[i] in ['a'..'z', ' ', 'A'..'Z', '0'..'9']) then
                      begin
                          Check := False;
                          break;
                      end;
                  end;
                  if Not Check then
                      Cancel := TranslateMessageDLG(MainForm_EqualizerInvalidInput, mtWarning, [mbOk, mbCancel], 0) = mrCancel
                  else
                  begin
                      // OK und Check ok => speichern!
                      Ini := TMeminiFile.Create(SavePath + 'Nemp_EQ.ini');
                      try
                          // zuerst NewName suchen - evtl. gibts die Section schon in der Auflistung!
                          NewNameExists := False;
                          c := Ini.ReadInteger('Summary', 'Max', 17);
                          for i := 0 to c do
                          begin
                              existingName := Ini.ReadString('Summary', 'Name'+IntToStr(i), GetDefaultEQName(i));
                              if existingName = NewName then
                              begin
                                  NewNameExists := True;
                                  break;
                              end;
                          end;

                          // Abfrage, ob überschrieben werden soll
                          if NewNameExists then
                          begin
                              GoOn := TranslateMessageDLG(Format(MainForm_BtnEqualizerOverwriteQuery, [NewName]), mtInformation, [mbOk, mbCancel], 0) = mrOK
                          end else
                              GoOn := True;

                          if GoOn then
                          begin
                              // Falls neuer Name: max-Wert um eins erhöhen und reinschreiben
                              if not NewNameExists then
                              begin
                                  Ini.WriteInteger('Summary', 'Max', c+1);
                                  Ini.WriteString('Summary', 'Name'+IntToStr(c+1), NewName);
                              end;
                              // Werte in die (neue) Section schreiben
                              for i := 0 to 9 do
                              begin
                                  preset := Round(NempPlayer.fxGain[i] * EQ_NEW_FACTOR);
                                  ini.WriteInteger(NewName, 'EQ'+inttostr(i+1), preset);
                              end;

                              try
                                  // Ini speichern
                                  Ini.UpdateFile;
                              except
                                  // Silent Exception
                              end;
                              // Menüs neu initialisieren
                              InitEqualizerMenuFormIni(Ini);

                              NempPlayer.EQSettingName := NewName;
                              Btn_EqualizerPresets.Caption := NewName;
                          end;
                      finally
                          ini.Free
                      end;
                  end;
              end else
                  Cancel := True;
          until (OK and Check) or Cancel;
      end
  end;
end;


procedure TFormEffectsAndEqualizer.DeleteEQSettingsClick(Sender: TObject);
var i, c, idx: integer;
    Ini: TMemIniFile;
    PresetName, EQName: String;
begin
    PresetName := (Sender as TMenuItem).Caption;
    if TranslateMessageDLG(Format(MainForm_BtnEqualizerDeleteQuery, [PresetName]), mtInformation, [mbYes, mbNo], 0) = mrYes then
    begin
          Ini := TMemIniFile.Create(SavePath + 'Nemp_EQ.ini');
          try
              c := Ini.ReadInteger('Summary', 'Max', 17);
              idx := c+1;
              for i := 0 to c do
              begin
                  EQName := Ini.ReadString('Summary', 'Name'+IntToStr(i), GetDefaultEQName(i));
                  if SameText(EQName, PresetName) then
                  begin
                    idx := i;
                    break;
                  end;
              end;
              // Idx markiert das Setting, das gelöscht werden soll
              // folgende Settings rücken eins auf
              for i := idx to c-1 do
              begin
                  EQName := Ini.ReadString('Summary', 'Name'+IntToStr(i+1), GetDefaultEQName(i));
                  Ini.WriteString('Summary', 'Name'+IntToStr(i), EQName);
              end;
              // letzten, jetzt überflüssigen Key löschen
              Ini.DeleteKey('Summary', 'Name'+IntToStr(c));
              // max-Wert verkleinern
              Ini.WriteInteger('Summary', 'Max', c-1);
              // ungültige Section löschen
              Ini.EraseSection(PresetName);
              try
                  // Ini speichern
                  Ini.UpdateFile;
              except
                  // Silent Exception
              end;
              // Menüs neu initialisieren
              InitEqualizerMenuFormIni(Ini);

              if SameText(NempPlayer.EQSettingName, PresetName) then
              begin
                  NempPlayer.EQSettingName := MainForm_BtnEqualizerPresetsCustom;
                  Btn_EqualizerPresets.Caption := NempPlayer.EQSettingName;
              end;
          finally
              Ini.Free;
          end;
    end;
end;


procedure TFormEffectsAndEqualizer.DirectionPositionBTNClick(Sender: TObject);
begin
    Nempplayer.ReversePlayback(False{PosRewindCB.Checked});
end;

procedure TFormEffectsAndEqualizer.InitEqualizerMenuFormIni(aIni: TMemIniFile);
var c, i: Integer;
    EQName: String;
    aMenuItem: TMenuItem;
    RewriteIni: Boolean;
begin
    RewriteIni := False;

    c := aIni.ReadInteger('Summary', 'Max', 17);
    if not aIni.ValueExists('Summary', 'Max') then
    begin
        aIni.WriteInteger('Summary', 'Max', c);
        RewriteIni := True;
    end;

    PM_EQ_Load.Clear;
    PM_EQ_Save.Clear;
    PM_EQ_Delete.Clear;

    for i := 0 to c do
    begin
        EQName := aIni.ReadString('Summary', 'Name'+IntToStr(i), GetDefaultEQName(i));
        if not (aIni.ValueExists('Summary', 'Name'+IntToStr(i)))then
        begin
            aIni.WriteString('Summary', 'Name'+IntToStr(i), EQName);
            RewriteIni := True;
        end;

        aMenuItem := TMenuItem.Create(Nemp_MainForm);
        aMenuItem.AutoHotkeys := maManual;
        aMenuItem.AutoCheck := False;
        aMenuItem.Tag := 0;
        aMenuItem.OnClick := SetEqualizerFromPresetClick;
        aMenuItem.Caption := EQName;
        PM_EQ_Load.Add(aMenuItem);

        aMenuItem := TMenuItem.Create(Nemp_MainForm);
        aMenuItem.AutoHotkeys := maManual;
        aMenuItem.AutoCheck := False;
        aMenuItem.Tag := 0;
        aMenuItem.OnClick := SaveEQSettingsClick;
        aMenuItem.Caption := EQName;
        PM_EQ_Save.Add(aMenuItem);

        aMenuItem := TMenuItem.Create(Nemp_MainForm);
        aMenuItem.AutoHotkeys := maManual;
        aMenuItem.AutoCheck := False;
        aMenuItem.Tag := 0;
        aMenuItem.OnClick := DeleteEQSettingsClick;
        aMenuItem.Caption := EQName;
        PM_EQ_Delete.Add(aMenuItem);
    end;

    aMenuItem := TMenuItem.Create(Nemp_MainForm);
    aMenuItem.AutoHotkeys := maManual;
    aMenuItem.AutoCheck := False;
    aMenuItem.Tag := 0;
    aMenuItem.Caption := '-';
    PM_EQ_Save.Add(aMenuItem);

    aMenuItem := TMenuItem.Create(Nemp_MainForm);
    aMenuItem.AutoHotkeys := maManual;
    aMenuItem.AutoCheck := False;
    aMenuItem.Tag := 1;
    aMenuItem.OnClick := SaveEQSettingsClick;
    aMenuItem.Caption := MainForm_BtnEqualizerSaveNewButton;
    PM_EQ_Save.Add(aMenuItem);

    if RewriteIni then
        try
            aIni.UpdateFile;
        except
            // Silent Exception
        end;
end;

procedure TFormEffectsAndEqualizer.PM_EQ_DisabledClick(Sender: TObject);
var i: Integer;
begin
    for i := 0 to 9 do
    begin
        NempPlayer.SetEqualizer(i, 0);
        CorrectEQButton(i);
    end;
    NempPlayer.EQSettingName := (MainForm_BtnEqualizerPresetsSelect);
    Btn_EqualizerPresets.Caption := NempPlayer.EQSettingName;end;

procedure TFormEffectsAndEqualizer.PM_EQ_RestoreStandardClick(Sender: TObject);
var i, OldMax, iSearch, g, preset: integer;
    Ini: TMemIniFile;
    ValueFound: Boolean;
begin
  if TranslateMessageDLG((Player_RestoreDefaultEqualizer), mtInformation, [mbOK, mbABORT], 0) = mrAbort then
      exit;

  Ini := TMemIniFile.Create(SavePath + 'Nemp_EQ.ini');
  try
      OldMax := Ini.ReadInteger('Summary', 'Max', 17);

      for i := 0 to 17 do
      begin
          ValueFound := False;
          for iSearch := 0 to OldMax do
          begin
              if SameText( Ini.ReadString('Summary', 'Name'+IntToStr(iSearch), EQ_NAMES[i]), EQ_NAMES[i]) then
              begin
                  ValueFound := True;
                  break;
              end;
          end;

          // ggf. Max erhöhen und Namen in Ini schreiben
          if not ValueFound then
          begin
              inc(OldMax);
              Ini.WriteInteger('Summary', 'Max', OldMax);
              Ini.WriteString('Summary', 'Name'+IntToStr(OldMax), EQ_NAMES[i]);
          end;

          // Werte in der Section neu schreiben
          for g := 0 to 9 do
          begin
              preset := Round(EQ_DEFAULTPRESETS[i][g]);
              Ini.WriteInteger(EQ_NAMES[i], 'EQ'+inttostr(g+1), preset);
          end;
      end;
      try
          Ini.UpdateFile;
      except
          // Silent Exception
      end;
      InitEqualizerMenuFormIni(Ini);
  finally
      Ini.Free;
  end;
end;

procedure TFormEffectsAndEqualizer.ResetEffectButtons;
var SpeedEffectsAllowed: Boolean;
begin
    if NempPlayer.MainStreamIsReverseStream then
    begin
      DirectionPositionBTN.GlyphLine := 1;
      DirectionPositionBTN.Tag := 1;
      DirectionPositionBTN.Hint := (MainForm_ReverseBtnHint_PlayNormal);
    end else
    begin
      DirectionPositionBTN.GlyphLine := 0;
      DirectionPositionBTN.Tag := 0;
      DirectionPositionBTN.Hint := (MainForm_ReverseBtnHint_PlayReverse);
    end;


    SpeedEffectsAllowed := (not NempPlayer.URLStream) and (not NempPlayer.PrescanInProgress);

    // Changing speed doesn't make sense with Streams, and also not during the Prescan process
    EffekteLBL3      .Enabled := SpeedEffectsAllowed;
    SampleRateLBL    .Enabled := SpeedEffectsAllowed;
    SamplerateShape  .Enabled := SpeedEffectsAllowed;
    SampleRateButton .Enabled := SpeedEffectsAllowed;
    // the same for Reverse playback
    DirectionPositionBTN.Enabled := SpeedEffectsAllowed;
end;

end.
