{

    Unit fConfigErrorDlg
    Form ConfigErrorDlg

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

unit fConfigErrorDlg;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, NempHelp,
  System.ImageList, Vcl.ImgList, ShellApi, MyDialogs, gnugettext;

type
  TConfigErrorDlg = class(TForm)
    pnlButtons: TPanel;
    btnOK: TButton;
    imgAlert: TImage;
    lblCaption: TLabel;
    lblMessage: TLabel;
    BtnProgramDir: TButton;
    ImageList1: TImageList;
    btnHelp: TButton;
    btnOpenDataDir: TButton;
    Bevel1: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure btnOpenDataDirClick(Sender: TObject);
    procedure BtnProgramDirClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  ConfigErrorDlg: TConfigErrorDlg;

implementation

uses
  Nemp_ConstantsAndTypes, Nemp_RessourceStrings;

{$R *.dfm}

procedure TConfigErrorDlg.FormCreate(Sender: TObject);
var
  filename: String;
begin
  TranslateComponent(self);

  HelpContext := HELP_Install;
  BtnHelp.HelpContext := HELP_Install;

  filename := ExtractFilePath(ParamStr(0)) + 'Images\alert.png';
  if FileExists(filename) then
      imgAlert.Picture.LoadFromFile(filename);
end;

procedure TConfigErrorDlg.btnOKClick(Sender: TObject);
begin
  Close;
end;

procedure TConfigErrorDlg.btnHelpClick(Sender: TObject);
begin
  Application.HelpContext(HELP_Install);
end;

procedure TConfigErrorDlg.btnOpenDataDirClick(Sender: TObject);
begin
  if DirectoryExists(ExtractFilePath(NempSettingsManager.SavePath)) then
      ShellExecute(Handle, 'open' ,'explorer.exe', PChar('"'+NempSettingsManager.SavePath+'"'), '', sw_ShowNormal)
  else
      TranslateMessageDLG((Warning_DataDirNotFound), mtWarning, [mbOk], 0);
end;

procedure TConfigErrorDlg.BtnProgramDirClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open' ,'explorer.exe', PChar('"'+ExtractFilePath(ParamStr(0))+'"'), '', sw_ShowNormal)
end;


end.
