{

    Unit MultimediaKeys
    Form FormMediaKeyInit

    - This Unit presents a Window to configure MultiMediaKeys

    It is decided here whether the ShellHook for WM_APPCOMMAND is installed
    or not.
    On some systems it is needed, on others not. Idea for the test:
    - Focus a Window that do not Accept WM_APPCOMMAND-Messages (like this form)
    - Install the hook, which directs the Messages to MainWindow
    - Let the user press "Play/Pause" once
    - Count the number of AppCommands after this.
    - If it is = 1, the the hook can be installed
      if it is >1, the hook MUST NOT be installed, otherwise really strange
      things will happen. ;-)

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
unit MultimediaKeys;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, jpeg, gnuGettext,
  Nemp_RessourceStrings;

type
  TFormMediaKeyInit = class(TForm)
    BtnEsc: TButton;
    BtnOk: TButton;
    MMKEYHinweisLbl: TLabel;
    Image1: TImage;
    procedure FormShow(Sender: TObject);
    procedure ReactOnMMKey;
    procedure BtnEscClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FormMediaKeyInit: TFormMediaKeyInit;

implementation

{$R *.dfm}
uses NempMainUnit, OptionsComplete;

procedure TFormMediaKeyInit.FormShow(Sender: TObject);
begin
  Image1.Visible := True;
  BtnEsc.Visible := True;
  Height := 268;
  BtnOK.Enabled := False;
  BtnOK.Visible := False;
  MMKEYHinweisLbl.Caption := _('To configure the mediakeys, press the play/pause key. It is important, that you press it only once!');

  SetWindowPos(Handle,HWND_TOPMOST,0,0,0,0,SWP_NOSIZE+SWP_NOMOVE);
end;

procedure TFormMediaKeyInit.ReactOnMMKey;
begin
  Image1.Visible := False;
  BtnEsc.Visible := False;
  Height := 134;
  BtnOK.Enabled := True;
  BtnOK.Visible := True;
  MMKEYHinweisLbl.Caption := _('Thank you. Please click the Ok-Button now.');
exit
end;

procedure TFormMediaKeyInit.BtnEscClick(Sender: TObject);
begin
  if assigned(OptionsCompleteForm) then
          OptionsCompleteForm.Lbl_MultimediaKeys_Status.Caption := (MediaKeys_Status_Standard);
end;

procedure TFormMediaKeyInit.FormCreate(Sender: TObject);
begin
  TranslateComponent (self);
end;

end.
