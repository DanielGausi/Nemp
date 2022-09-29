{

    Unit DuplicateFilesDialog

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
unit DuplicateFilesDialogs;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TECopyAction = (caSkip, caRename, caOverwrite, caCancel);

  TDuplicateFilesDialog = class(TForm)
    lblDuplicateFile: TLabel;
    rgQuery: TRadioGroup;
    cbForAll: TCheckBox;
    BtnCancel: TButton;
    BtnOk: TButton;
    lblFilename: TLabel;
    Panel1: TPanel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    fFilename: String;
    procedure fSetFilename(aFilename: String);
    function GetApplyForAll: Boolean;
    procedure SetApplyForAll(aValue: Boolean);

    function GetCopyAction: TECopyAction;
    procedure SetCopyAction(aValue: TECopyAction);

  public
    { Public declarations }

    property Filename: string read fFilename write fSetFilename;

    property ApplyForAll: Boolean read GetApplyForAll write SetApplyForAll;
    property CopyAction: TECopyAction read GetCopyAction write SetCopyAction;

  end;

//Resourcestring
//  rs_DuplicateFilesDialogLabel = 'The file "%s" already exists in the destination directory.';

var
  DuplicateFilesDialog: TDuplicateFilesDialog;

implementation

uses GnuGetText;

{$R *.dfm}


procedure TDuplicateFilesDialog.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
end;

procedure TDuplicateFilesDialog.fSetFilename(aFilename: String);
begin
  fFilename := ExtractFilename(aFilename);
  lblFilename.Caption := fFilename;
end;

function TDuplicateFilesDialog.GetApplyForAll: Boolean;
begin
  result := cbForAll.Checked;
end;
procedure TDuplicateFilesDialog.SetApplyForAll(aValue: Boolean);
begin
  cbForAll.Checked := aValue;
end;

function TDuplicateFilesDialog.GetCopyAction: TECopyAction;
begin
  result := TECopyAction(rgQuery.ItemIndex);
end;
procedure TDuplicateFilesDialog.SetCopyAction(aValue: TECopyAction);
begin
  rgQuery.ItemIndex := Integer(aValue);
end;



end.
