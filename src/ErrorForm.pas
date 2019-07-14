{

    Unit ErrorForm

    Displays a list of recent error messages

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

unit ErrorForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFError = class(TForm)
    Memo_Error: TMemo;
    BtnClear: TButton;
    BtnOK: TButton;
    procedure BtnOKClick(Sender: TObject);
    procedure BtnClearClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FError: TFError;

implementation

uses NempMainUnit, Nemp_RessourceStrings;

{$R *.dfm}

procedure TFError.BtnClearClick(Sender: TObject);
begin
    ErrorLogCount := 0;
    ErrorLog.Clear;
    Memo_Error.Clear;
    Memo_Error.Lines.Add(ErrorForm_NoMessages);
    Nemp_MainForm.MM_H_ErrorLog.Caption := MainForm_MainMenu_NoMessages;
end;

procedure TFError.BtnOKClick(Sender: TObject);
begin
    if ErrorLogCount = 0 then
        Nemp_MainForm.MM_H_ErrorLog.Visible := False;

    Close;
end;

procedure TFError.FormShow(Sender: TObject);
begin
    if ErrorLogCount = 0 then
        Memo_Error.Text := ErrorForm_NoMessages
    else
        Memo_Error.Lines.Assign(ErrorLog);
end;

end.
