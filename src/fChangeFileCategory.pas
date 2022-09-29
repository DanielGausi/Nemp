{

    Unit fChangeFileCategory

    - Form Dialog for moving/copying files into other categories

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
unit fChangeFileCategory;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Winapi.ActiveX,
  Nemp_RessourceStrings, gnugetText, math, NempHelp,
  NempAudioFiles, LibraryOrganizer.Base, LibraryOrganizer.Files,
  AudioDisplayUtils, Vcl.Imaging.pngimage;

type
  TFormChangeCategory = class(TForm)
    pnlButtons: TPanel;
    BtnCancel: TButton;
    BtnOK: TButton;
    pnlNewCategory: TPanel;
    lblNewCategory: TLabel;
    cbCategorySelection: TComboBox;
    rbMoveFiles: TRadioButton;
    rbCopyFiles: TRadioButton;
    pnlFiles: TPanel;
    memoFiles: TMemo;
    lblFiles: TLabel;
    pnlCurrent: TPanel;
    lblCurrentCategory: TLabel;
    lblHeadline: TLabel;
    ImgHelp: TImage;
    procedure FormCreate(Sender: TObject);
    procedure ImgHelpClick(Sender: TObject);
  private
    { Private declarations }

    procedure SetCurrentCategory(Value: TLibraryFileCategory);
    function GetNewCategory: TLibraryFileCategory;
    function GetEffect: teCategoryAction;


  public
    { Public declarations }
    property NewCategory: TLibraryFileCategory read GetNewCategory;
    property Effect: teCategoryAction read GetEffect;

    procedure SetCategories(Source: TLibraryCategoryList; Current: TLibraryFileCategory);
    procedure SetFiles(Source: TAudioFileList);

  end;

var
  FormChangeCategory: TFormChangeCategory;

implementation

uses Hilfsfunktionen;

{$R *.dfm}


{ TFormChangeCategory }

procedure TFormChangeCategory.FormCreate(Sender: TObject);
begin
  BackupComboboxes(self);
  TranslateComponent(self);
  RestoreComboboxes(self);
  HelpContext := HELP_ChangeCategories;
end;

function TFormChangeCategory.GetEffect: teCategoryAction;
begin
  if rbCopyFiles.Checked then
    result := caCategoryCopy
  else
    result := caCategoryMove;
end;

function TFormChangeCategory.GetNewCategory: TLibraryFileCategory;
begin
  result := TLibraryFileCategory(cbCategorySelection.Items.Objects[cbCategorySelection.ItemIndex]);
end;

procedure TFormChangeCategory.ImgHelpClick(Sender: TObject);
begin
  Application.HelpContext(HELP_ChangeCategories);
end;

procedure TFormChangeCategory.SetCategories(Source: TLibraryCategoryList;
  Current: TLibraryFileCategory);
var
  i: Integer;
begin
  SetCurrentCategory(Current);

  cbCategorySelection.Clear;
  for i := 0 to Source.Count - 1 do begin
    if Source[i] <> Current then
      cbCategorySelection.Items.AddObject(TLibraryFileCategory(Source[i]).Caption, Source[i]);
  end;

  // select the first entry
  if cbCategorySelection.Items.Count > 0 then
    cbCategorySelection.ItemIndex := 0;
end;

procedure TFormChangeCategory.SetCurrentCategory(
  Value: TLibraryFileCategory);
begin
  if assigned(Value) then
    lblCurrentCategory.Caption := Format(ChangeCategoryForm_CurrentCategory, [Value.Caption])
  else
    lblCurrentCategory.Caption := ''; // Format(ChangeCategoryForm_CurrentCategory, [Value.Caption])
end;

procedure TFormChangeCategory.SetFiles(Source: TAudioFileList);
var
  i, maxC: Integer;
begin
  memoFiles.Clear;

  lblFiles.Caption := Format(ChangeCategoryForm_AffectedFiles, [Source.Count]);
  maxC := min(Source.Count, 500);

  for i := 0 to maxC-1 do
    memoFiles.Lines.Add(NempDisplay.PlaylistTitle(Source[i]));

  if maxC < Source.Count then
    memoFiles.Lines.Add(Format(ChangeCategoryForm_MoreFiles, [Source.Count - maxC]));
end;


end.
