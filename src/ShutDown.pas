{

    Unit ShutDown
    Form ShutDownForm

    Form showing after countdown for shutdown elapsed.
    A last 30-Seconds-Countdown starts to warn the user and give
    him a chance to cancel shutdown.

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2009, Daniel Gaussmann
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

    Additional permissions

    If you modify this Program, or any covered work, by linking or combining it
    with
        - the bass.dll and it addons
          (including, but not limited to the bass_fx.dll)
        - MadExcept
        - DGL-OpenGL
        - FSPro Windows 7 Taskbar Components
    or a modified version of these libraries, the licensors of this Program
    grant you additional permission to convey the resulting work.

    ---------------------------------------------------------------
}
unit ShutDown;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, AudioFileClass, StrUtils, 

  Nemp_ConstantsAndTypes, gnuGettext, Nemp_RessourceStrings;

type
  TShutDownForm = class(TForm)
    Btn_Cancel: TButton;
    Btn_ShutDownNow: TButton;
    ShutDownLBL: TLabel;
    Timer1: TTimer;
    LblHinweis: TLabel;
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Btn_ShutDownNowClick(Sender: TObject);
    procedure Btn_CancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  ShutDownForm: TShutDownForm;

implementation

uses Systemhelper, NempMainUnit;

{$R *.dfm}

procedure TShutDownForm.FormShow(Sender: TObject);
begin
  ShutDownLBL.Caption := Format((NempShutDown_CountDownLbl),  [30] );
  Timer1.Tag := 30;
  Timer1.Enabled := True;


  // Idee: Langes FadeOut. Vorher: Player-Flag setzen, damit KEIN TITELWECHSEL mehr durchgef�hrt wird.

  NempPlayer.FadeOut(30);
  // Bei Abbruch: Wieder Fade-In und Syncs wieder setzen

  case Nemp_MainForm.NempOptions.ShutDownMode of
        SHUTDOWNMODE_StopNemp  : LblHinweis.Caption := (NempShutDown_StopNemp  );
        SHUTDOWNMODE_ExitNemp  : LblHinweis.Caption := (NempShutDown_CloseNemp );
        SHUTDOWNMODE_Suspend   : LblHinweis.Caption := (NempShutdown_Suspend);
        SHUTDOWNMODE_Hibernate : LblHinweis.Caption := (NempShutDown_Hibernate);
        SHUTDOWNMODE_Shutdown  : LblHinweis.Caption := (NempShutDown_ShutDown);
    end;

  SetWindowPos(ShutDownForm.Handle,HWND_TOPMOST,0,0,0,0,SWP_NOSIZE+SWP_NOMOVE);
end;

procedure TShutDownForm.Timer1Timer(Sender: TObject);
begin
  Timer1.Tag := Timer1.Tag - 1;
  ShutDownLBL.Caption := Format((NempShutDown_CountDownLbl),  [Timer1.Tag] );

  if (Timer1.Tag <= (NempPlayer.FadingInterval DIV 1000)) or (Timer1.Tag <= 1) then
        if NempPlayer.PauseOnSuspend then
                                    NempPlayer.pause;

  if Timer1.Tag <= 0 then
  begin
    Timer1.Enabled := False;
    case Nemp_MainForm.NempOptions.ShutDownMode of
        SHUTDOWNMODE_StopNemp : NempPlayer.stop;
        SHUTDOWNMODE_ExitNemp : Nemp_MainForm.Close;
        SHUTDOWNMODE_Suspend   : SetSuspendState(False);
        SHUTDOWNMODE_Hibernate : SetSuspendState(True);
        SHUTDOWNMODE_Shutdown  : ExWindows(EWX_Shutdown OR EWX_Poweroff);
    end;
    close;
  end;
end;


procedure TShutDownForm.Btn_ShutDownNowClick(Sender: TObject);
begin
  Timer1.Tag := 2;
  exit;
end;

procedure TShutDownForm.Btn_CancelClick(Sender: TObject);
begin
  NempPlayer.CancelFadeOut;
  Timer1.Enabled := False;
  close;
end;

procedure TShutDownForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Timer1.Enabled := False;
end;

procedure TShutDownForm.FormCreate(Sender: TObject);
begin
  TranslateComponent (self);
end;

end.
