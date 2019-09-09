{

    Unit ShutDownEdit
    Form ShutDownEditForm

    - Small Form for setting a customized countdown-length

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2005-2019, Daniel Gaussmann
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
unit ShutDownEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, gnuGettext, System.DateUtils, Vcl.ExtCtrls;

type
  TShutDownEditForm = class(TForm)
    BtnOk: TButton;
    BtnCancel: TButton;
    grpBoxSettings: TGroupBox;
    cbIntendedAction: TComboBox;
    lblIntendedAction: TLabel;
    lblCountDownLength: TLabel;
    cbCountdownLength: TComboBox;
    SE_Hours: TSpinEdit;
    SE_Minutes: TSpinEdit;
    LblConst_Minute: TLabel;
    LblConst_Hour: TLabel;
    ImgShutDown: TImage;
    lblShutDownMode: TLabel;
    lblCurrentStatus: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure cbCountdownLengthChange(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbIntendedActionChange(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure ShowProperImage(aMode: Integer);
  public
    { Public-Deklarationen }
  end;

var
  ShutDownEditForm: TShutDownEditForm;

implementation

uses Hilfsfunktionen, NempMainUnit, Nemp_RessourceStrings, Nemp_ConstantsAndTypes,
    NempApi, MyDialogs;

{$R *.dfm}

procedure TShutDownEditForm.BtnOkClick(Sender: TObject);
begin

    if (cbCountdownLength.ItemIndex = 8) AND (NempPlaylist.WiedergabeMode <> NEMP_API_NOREPEAT) then
    begin
        if TranslateMessageDLG(NempShutDown_AtEndOfPlaylist_Dlg, mtWarning, [MBOk, MBAbort], 0) = MrOk then
            ModalResult := mrOK
        else
            ModalResult := mrNone
    end else
        ModalResult := mrOK;


    // set current settings as the new settings for NempOptions // IniFile
    Nemp_MainForm.NempOptions.ShutDownModeIniIdx     := cbIntendedAction  .ItemIndex  ;
    Nemp_MainForm.NempOptions.ShutDownTimeIniIdx     := cbCountdownLength .ItemIndex  ;
    Nemp_MainForm.NempOptions.ShutDownTimeIniHours   := SE_Hours.Value  ;
    Nemp_MainForm.NempOptions.ShutDownTimeIniMinutes := SE_Minutes.Value;

    // Start the actual Countdown timer

    // SHUTDOWNMODE_StopNemp, SHUTDOWNMODE_ExitNemp, SHUTDOWNMODE_Suspend, SHUTDOWNMODE_Hibernat, SHUTDOWNMODE_Shutdown
    Nemp_MainForm.NempOptions.ShutDownMode := cbIntendedAction.ItemIndex;

    case cbCountdownLength.ItemIndex of
        0: Nemp_MainForm.NempOptions.ShutDownTime := IncMinute(Now, 5);
        1: Nemp_MainForm.NempOptions.ShutDownTime := IncMinute(Now, 15);
        2: Nemp_MainForm.NempOptions.ShutDownTime := IncMinute(Now, 30);
        3: Nemp_MainForm.NempOptions.ShutDownTime := IncMinute(Now, 45);
        4: Nemp_MainForm.NempOptions.ShutDownTime := IncMinute(Now, 60);
        5: Nemp_MainForm.NempOptions.ShutDownTime := IncMinute(Now, 90);
        6: Nemp_MainForm.NempOptions.ShutDownTime := IncMinute(Now, 120);
        7: Nemp_MainForm.NempOptions.ShutDownTime := IncMinute(Now, 60 * SE_Hours.Value + SE_Minutes.Value);
        8: ; // special case, shut down after end of playlist
    end;

    Nemp_MainForm.NempOptions.ShutDownAtEndOfPlaylist := (cbCountdownLength.ItemIndex = 8);

end;

procedure TShutDownEditForm.cbCountdownLengthChange(Sender: TObject);
begin
    LblConst_Hour           .Enabled := cbCountdownLength.ItemIndex = 7;
    LblConst_Minute         .Enabled := cbCountdownLength.ItemIndex = 7;
    SE_Hours                .Enabled := cbCountdownLength.ItemIndex = 7;
    SE_Minutes              .Enabled := cbCountdownLength.ItemIndex = 7;
end;

procedure TShutDownEditForm.cbIntendedActionChange(Sender: TObject);
begin
    ShowProperImage(cbIntendedAction.ItemIndex);
end;

procedure TShutDownEditForm.FormCreate(Sender: TObject);
begin
    cbIntendedAction.OnChange := Nil;
    cbCountdownLength.OnChange:= Nil;
    BackUpComboBoxes(self);
    TranslateComponent (self);
    RestoreComboboxes(self);
    cbIntendedAction.OnChange := cbIntendedActionChange;
    cbCountdownLength.OnChange := cbCountdownLengthChange;

    // set settings from the NempOptions // IniFile
    cbIntendedAction  .ItemIndex := Nemp_MainForm.NempOptions.ShutDownModeIniIdx ;
    cbCountdownLength .ItemIndex := Nemp_MainForm.NempOptions.ShutDownTimeIniIdx ;

    SE_Hours.Value   := Nemp_MainForm.NempOptions.ShutDownTimeIniHours   ;
    SE_Minutes.Value := Nemp_MainForm.NempOptions.ShutDownTimeIniMinutes ;

    ShowProperImage(Nemp_MainForm.NempOptions.ShutDownModeIniIdx) ;
end;

procedure TShutDownEditForm.FormShow(Sender: TObject);
begin
    cbCountdownLengthChange(Nil);
    lblCurrentStatus.Caption := Nemp_MainForm.GetShutDownInfoCaption;
end;

procedure TShutDownEditForm.ShowProperImage(aMode: Integer);
var filename: String;
begin
    case aMode of
        SHUTDOWNMODE_StopNemp  : Filename := ExtractFilePath(ParamStr(0)) + 'Images\SleepStopNemp.png';
        SHUTDOWNMODE_ExitNemp  : Filename := ExtractFilePath(ParamStr(0)) + 'Images\SleepCloseNemp.png';
        SHUTDOWNMODE_Suspend   : Filename := ExtractFilePath(ParamStr(0)) + 'Images\SleepSuspend.png';
        SHUTDOWNMODE_Hibernate : Filename := ExtractFilePath(ParamStr(0)) + 'Images\SleepHibernate.png';
        SHUTDOWNMODE_Shutdown  : Filename := ExtractFilePath(ParamStr(0)) + 'Images\SleepShutdown.png';
    end;
    if FileExists(filename) then
        ImgShutDown.Picture.LoadFromFile(filename);

    case aMode of
        SHUTDOWNMODE_StopNemp  : lblShutDownMode.Caption := NempShutDown_StopPopupBlank      ;
        SHUTDOWNMODE_ExitNemp  : lblShutDownMode.Caption := NempShutDown_ClosePopupBlank     ;
        SHUTDOWNMODE_Suspend   : lblShutDownMode.Caption := NempShutDown_SuspendPopupBlank   ;
        SHUTDOWNMODE_Hibernate : lblShutDownMode.Caption := NempShutDown_HibernatePopupBlank ;
        SHUTDOWNMODE_Shutdown  : lblShutDownMode.Caption := NempShutDown_ShutDownPopupBlank  ;
    end;

end;

end.




