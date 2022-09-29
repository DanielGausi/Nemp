{

    Unit EffectsAndEqualizer

    - Form for Effects and Equalizer settings

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
unit EffectsAndEqualizer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  NempPanel, SkinButtons, MyDialogs, System.IniFiles, math,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,

  Nemp_RessourceStrings, Vcl.Menus, Vcl.ComCtrls, CommCtrl,
  NempTrackbar, NempHelp;

type

  TFormEffectsAndEqualizer = class(TForm)
    Equalizer_PopupMenu: TPopupMenu;
    PM_EQ_Load: TMenuItem;
    PM_EQ_Save: TMenuItem;
    PM_EQ_Delete: TMenuItem;
    N45: TMenuItem;
    PM_EQ_RestoreStandard: TMenuItem;
    GRPBOXEqualizer: TGroupBox;
    tbEQ0: TNempTrackBar;
    tbEQ1: TNempTrackBar;
    tbEQ2: TNempTrackBar;
    tbEQ3: TNempTrackBar;
    tbEQ4: TNempTrackBar;
    tbEQ5: TNempTrackBar;
    tbEQ6: TNempTrackBar;
    tbEQ7: TNempTrackBar;
    tbEQ8: TNempTrackBar;
    tbEQ9: TNempTrackBar;
    EQLBL1: TLabel;
    EQLBL10: TLabel;
    EQLBL2: TLabel;
    EQLBL3: TLabel;
    EQLBL4: TLabel;
    EQLBL5: TLabel;
    EQLBL6: TLabel;
    EQLBL7: TLabel;
    EQLBL8: TLabel;
    EQLBL9: TLabel;
    Btn_EqualizerPresets: TButton;
    ButtonPrevEQ: TButton;
    ButtonNextEQ: TButton;
    GrpBoxEffects: TGroupBox;
    tbReverb: TNempTrackBar;
    HallLBL: TLabel;
    grpBoxABRepeat: TGroupBox;
    BtnABRepeatSetA: TButton;
    BtnABRepeatSetB: TButton;
    BtnABRepeatUnset: TButton;
    BtnClose: TButton;
    BtnDisableEqualizer: TButton;
    tbEchoTime: TNempTrackBar;
    EchoTimeLBL: TLabel;
    EchoMixLBL: TLabel;
    tbWetDryMix: TNempTrackBar;
    Btn_EffectsOff: TBitBtn;
    WobbleTimer: TTimer;
    tbWobble: TNempTrackBar;
    tbSpeed: TNempTrackBar;
    SampleRateLBL: TLabel;
    lblWobble: TLabel;
    lblSpeed: TLabel;
    cbMickyMouseEffect: TCheckBox;
    lblReverb: TLabel;
    lblEcho: TLabel;
    grpBoxDirection: TGroupBox;
    DirectionPositionBTN: TButton;

    procedure FormCreate(Sender: TObject);

    procedure FormShow(Sender: TObject);
    procedure SyncEffectValuesToVCL;
    procedure Btn_EqualizerPresetsClick(Sender: TObject);
    procedure PM_EQ_DisabledClick(Sender: TObject);
    procedure PM_EQ_RestoreStandardClick(Sender: TObject);
    procedure ButtonPrevEQClick(Sender: TObject);
    procedure __DirectionPositionBTNClick(Sender: TObject);
    procedure BtnABRepeatSetAClick(Sender: TObject);
    procedure BtnABRepeatSetBClick(Sender: TObject);
    procedure BtnABRepeatUnsetClick(Sender: TObject);
    procedure Btn_EffectsOffClick(Sender: TObject);
    procedure TrackBarMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tbEQ0Change(Sender: TObject);
    procedure tbReverbChange(Sender: TObject);
    procedure tbReverbMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tbWetDryMixChange(Sender: TObject);
    procedure tbEchoTimeChange(Sender: TObject);
    procedure tbEchoTimeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tbWetDryMixMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tbSpeedChange(Sender: TObject);
    procedure tbSpeedMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BtnCloseClick(Sender: TObject);
    procedure cbMickyMouseEffectClick(Sender: TObject);
    procedure tbWobbleMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tbWobbleChange(Sender: TObject);
    procedure WobbleTimerTimer(Sender: TObject);
   
  private
    { Private declarations }
    fChangingEqualizerPreset: Boolean;

  public
    { Public declarations }
    EqualizerTrackBars: Array[0..9] of TNempTrackBar;

    procedure CorrectEQButton(band: Integer; ResetCaption: Boolean = True);
    function APIEQToPlayer(Value: Integer): Single;
    procedure CorrectHallButton;
    procedure CorrectEchoButtons;
    procedure CorrectSpeedButton;
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

uses NempMainUnit, Nemp_ConstantsAndTypes, gnugettext, MainFormHelper;




procedure TFormEffectsAndEqualizer.FormCreate(Sender: TObject);
var ini: TMemIniFile;

begin
    TranslateComponent (self);
    HelpContext := HELP_EqualizerAndEffects;

    fChangingEqualizerPreset := False;

    EqualizerTrackBars[0] := tbEQ0;
    EqualizerTrackBars[1] := tbEQ1;
    EqualizerTrackBars[2] := tbEQ2;
    EqualizerTrackBars[3] := tbEQ3;
    EqualizerTrackBars[4] := tbEQ4;
    EqualizerTrackBars[5] := tbEQ5;
    EqualizerTrackBars[6] := tbEQ6;
    EqualizerTrackBars[7] := tbEQ7;
    EqualizerTrackBars[8] := tbEQ8;
    EqualizerTrackBars[9] := tbEQ9;

    ini := TMeminiFile.Create(SavePath + 'Nemp_EQ.ini');
    try
        InitEqualizerMenuFormIni(ini);
        Btn_EqualizerPresets.Caption := NempPlayer.EQSettingName;
    finally
        ini.Free
    end;

end;

procedure TFormEffectsAndEqualizer.TrackBarMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if Button = mbRight then
        (Sender as TTrackbar).Position := 0;
end;

procedure TFormEffectsAndEqualizer.FormShow(Sender: TObject);
var i: Integer;
begin
    SyncEffectValuesToVCL    ;

    for i := 0 to 9 do
    begin
        EqualizerTrackBars[i].HandleNeeded;
        SendMessage(EqualizerTrackBars[i].Handle, TBM_CLEARTICS, 0, 0);
        EqualizerTrackBars[i].SetTick(0);
    end;


    SendMessage(tbSpeed.Handle, TBM_CLEARTICS, 0, 0);
    tbSpeed.SetTick(0);

end;


procedure TFormEffectsAndEqualizer.SyncEffectValuesToVCL;
var i: Integer;
begin
    CorrectHallButton;
    CorrectEchoButtons;
    CorrectSpeedButton;
    for i := 0 to 9 do CorrectEQButton(i);
    cbMickyMouseEffect.Checked := NOT NempPlayer.AvoidMickyMausEffect;
end;



procedure TFormEffectsAndEqualizer.tbEQ0Change(Sender: TObject);
var tb: TTrackbar;
begin
    tb := Sender as TTrackbar;

    NempPlayer.SetEqualizer(tb.Tag, - tb.Position / 10);

    if not fChangingEqualizerPreset then
    begin
        NempPlayer.EQSettingName := (MainForm_BtnEqualizerPresetsCustom);
        Btn_EqualizerPresets.Caption := (MainForm_BtnEqualizerPresetsCustom);
    end;
end;

procedure TFormEffectsAndEqualizer.CorrectEQButton(band: Integer; ResetCaption: Boolean = True);
begin

        // Valid values:  EQ_NEW_MAX ... - EQ_NEW_MAX (i.e. 10 ... - 10)
        // Bass allows values in 15 .. -15, but this sounds often bad.
        // So we have to map EQ_NEW_MAX ... - EQ_NEW_MAX into
        //               Shape.Top ...  Shape.Top + Shape.Height - Button.Height
        //EqualizerButtons[band].Top := EqualizerShape1.Top  +
        //    Round((EQ_NEW_MAX - NempPlayer.fxgain[band])
        //          * (EqualizerShape1.Height - EqualizerButtons[band].Height)
        //          / (2*EQ_NEW_MAX));

        EqualizerTrackBars[band].Position := - round (10 * NempPlayer.fxgain[band]);
        if ResetCaption then
            Btn_EqualizerPresets.Caption := NempPlayer.EQSettingName;
end;

function TFormEffectsAndEqualizer.APIEQToPlayer(Value: Integer): Single;
begin
    result := EQ_NEW_MAX - ( Value / EQ_NEW_FACTOR );
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

procedure TFormEffectsAndEqualizer.BtnCloseClick(Sender: TObject);
begin
    Close;
end;

procedure TFormEffectsAndEqualizer.Btn_EffectsOffClick(Sender: TObject);
begin
    tbReverb.Position := -96;
    tbEchoTime.Position := 100;
    tbWetDryMix.Position := 0;

    tbSpeed.Position := 0;
    tbWobble.Position := 0;
    NempPlayer.ForceForwardPlayback;
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


procedure TFormEffectsAndEqualizer.cbMickyMouseEffectClick(Sender: TObject);
begin
    NempPlayer.ChangeMickyMouseEffect(NOT cbMickyMouseEffect.Checked);
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
    fChangingEqualizerPreset := True;
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

    fChangingEqualizerPreset := False;
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


procedure TFormEffectsAndEqualizer.__DirectionPositionBTNClick(Sender: TObject);
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

procedure TFormEffectsAndEqualizer.tbReverbChange(Sender: TObject);
var tPos: Integer;
begin
    tPos := 96 + tbReverb.Position ;
    // ganz links: -96    tpos = 0        => reverb soll -96 sein
    // ganz rechts 0      tpos = 96         => reverb soll 0 sein
    NempPlayer.ReverbMix :=  96 / sqrt(96) * sqrt(tPos) - 96;
    HallLBL.Caption := Inttostr(Round(NempPlayer.ReverbMix)) + 'dB';
end;
procedure TFormEffectsAndEqualizer.tbReverbMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if Button = mbRight then
        tbReverb.Position := -96;
end;


procedure TFormEffectsAndEqualizer.CorrectHallButton;
begin
    tbReverb.Position := Round(sqr((NempPlayer.ReverbMix + 96) * sqrt(96) / 96)) - 96;
    HallLBL.Caption := Inttostr(Round(NempPlayer.ReverbMix)) + 'dB';
end;



procedure TFormEffectsAndEqualizer.tbWetDryMixChange(Sender: TObject);
begin
    NempPlayer.EchoWetDryMix := tbWetDryMix.Position;
    EchoMixLBL.Caption := Inttostr(Round(NempPlayer.EchoWetDryMix)) + '%';
end;


procedure TFormEffectsAndEqualizer.tbEchoTimeChange(Sender: TObject);
begin
    NempPlayer.EchoTime :=  tbEchoTime.Position;
    EchoTimeLBL.Caption := Inttostr(Round(NempPlayer.EchoTime)) + 'ms';
end;

procedure TFormEffectsAndEqualizer.tbEchoTimeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if Button = mbRight then
        tbEchoTime.Position := 100;
end;
procedure TFormEffectsAndEqualizer.tbWetDryMixMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if Button = mbRight then
        tbWetDryMix.Position := 0;
end;



procedure TFormEffectsAndEqualizer.CorrectEchoButtons;
begin
    tbWetDryMix.Position := Round(NempPlayer.EchoWetDryMix);
    tbEchoTime.Position  := Round(NempPlayer.EchoTime);
    EchoMixLBL.Caption  := Inttostr(Round(NempPlayer.EchoWetDryMix)) + '%';
    EchoTimeLBL.Caption := Inttostr(Round(NempPlayer.EchoTime)) + 'ms';
end;


procedure TFormEffectsAndEqualizer.tbSpeedChange(Sender: TObject);
begin
    // position < 0  =>  play Slower ( -33 % ... 0%)
    // position > 0  =>  play faster (0% .. 300%)

    if tbSpeed.Position = 0 then
        NempPlayer.Speed := 1
    else
    if tbSpeed.Position < 0 then // slower
        NempPlayer.Speed := 1 - ((sqr(tbSpeed.Position) * 2/3) / 10000)
    else  // faster
        NempPlayer.Speed := 1 + ((sqr(tbSpeed.Position) * 2) / 10000);

    SampleRateLBL.Caption := inttostr(Round(NempPlayer.Speed * 100)) + '%';
end;


procedure TFormEffectsAndEqualizer.tbSpeedMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if Button = mbRight then
        tbSpeed.Position := 0;
end;

procedure TFormEffectsAndEqualizer.CorrectSpeedButton;
begin
    if SameValue(NempPlayer.Speed, 1) then
        tbSpeed.Position := 0
    else if NempPlayer.Speed < 1 then
        tbSpeed.Position := - Round( sqrt( (1 - NempPlayer.Speed) * 10000 * 3/2)  )
    else
        tbSpeed.Position := Round( sqrt( (NempPlayer.Speed  -1) * 10000 / 2)  );

    SampleRateLBL.Caption := inttostr(Round(NempPlayer.Speed * 100)) + '%';
end;

procedure TFormEffectsAndEqualizer.tbWobbleChange(Sender: TObject);
begin
    if tbWobble.Position = 0 then
    begin
        WobbleTimer.enabled := False;
        NempPlayer.Flutter(1, 1000);
        NempPlayer.Speed := 1;
    end else
    begin
        WobbleTimer.Enabled := True;
    end;
end;

procedure TFormEffectsAndEqualizer.tbWobbleMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if Button = mbRight then
        tbWobble.Position := 0;
end;

procedure TFormEffectsAndEqualizer.WobbleTimerTimer(Sender: TObject);
var factor: Integer;
begin
    factor := tbWobble.Position;  //currently:  1 ... 40

    // start fluttering
    if Random >= 0.6 then
        NempPlayer.Flutter(Random(factor) / 100 + 1, 1000)  // faster
    else
        NempPlayer.Flutter(  1/( (Random(factor) / 100)+1)   , 1000); // slower
end;


procedure TFormEffectsAndEqualizer.PM_EQ_DisabledClick(Sender: TObject);
var i: Integer;
begin
    for i := 0 to 9 do
        EqualizerTrackBars[i].Position := 0;
    NempPlayer.EQSettingName := (MainForm_BtnEqualizerPresetsSelect);
    Btn_EqualizerPresets.Caption := NempPlayer.EQSettingName;
end;

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
      //DirectionPositionBTN.GlyphLine := 1;
      DirectionPositionBTN.Tag := 1;
      DirectionPositionBTN.Caption := (MainForm_ReverseBtnHint_PlayNormal);
      DirectionPositionBTN.Hint := (MainForm_ReverseBtnHint_PlayNormal);
    end else
    begin
      //DirectionPositionBTN.GlyphLine := 0;
      DirectionPositionBTN.Tag := 0;
      DirectionPositionBTN.Caption := (MainForm_ReverseBtnHint_PlayReverse);
      DirectionPositionBTN.Hint := (MainForm_ReverseBtnHint_PlayReverse);
    end;


    // Changing speed doesn't make sense with Streams, and also not during the Prescan process
    SpeedEffectsAllowed := (not NempPlayer.URLStream) and (not NempPlayer.PrescanInProgress);

    lblSpeed           .Enabled := SpeedEffectsAllowed;
    tbSpeed            .Enabled := SpeedEffectsAllowed;
    SampleRateLBL      .Enabled := SpeedEffectsAllowed;
    lblWobble          .Enabled := SpeedEffectsAllowed;
    tbWobble           .Enabled := SpeedEffectsAllowed;
    cbMickyMouseEffect .Enabled := SpeedEffectsAllowed;
    grpBoxDirection    .Enabled := SpeedEffectsAllowed;
    grpBoxABRepeat     .Enabled := SpeedEffectsAllowed;

    DirectionPositionBTN.Enabled := SpeedEffectsAllowed;

end;

end.
