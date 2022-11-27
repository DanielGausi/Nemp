{

    Unit fExport

    - Export a List of AudioFiles based on a Template file

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

unit fExport;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.IOUtils, ShellApi,
  AudioExportUtils, AudioDisplayUtils, Vcl.ExtCtrls, Vcl.Mask, System.Actions,
  Vcl.ActnList, Vcl.Menus, Vcl.Imaging.pngimage;

type
  TFormExport = class(TForm)
    lbTemplates: TListBox;
    btnSelectExportFilename: TButton;
    saveDlgExport: TSaveDialog;
    rgExportSelection: TRadioGroup;
    btnOK: TButton;
    btnCancel: TButton;
    edtExportFileName: TLabeledEdit;
    pnlButtons: TPanel;
    ActionListExport: TActionList;
    ActionEditTemplate: TAction;
    ActionNewTemplate: TAction;
    ActionDuplicateTemplate: TAction;
    MainMenuExport: TMainMenu;
    mmItemFile: TMenuItem;
    mmItemEditTemplate: TMenuItem;
    ActionDeleteTemplate: TAction;
    mmItemDuplicateTemplate: TMenuItem;
    mmItemNewTemplate: TMenuItem;
    mmItemDeleteTemplate: TMenuItem;
    ActionOpenDirectory: TAction;
    mmItemOpenTemplateDirectory: TMenuItem;
    N1: TMenuItem;
    ActionCreateDefaultTemplates: TAction;
    mmItemCreateDefaultTemplates: TMenuItem;
    grpBoxTemplateSelection: TGroupBox;
    PopupMenuTemplates: TPopupMenu;
    pmItemNewTemplate: TMenuItem;
    pmItemEditTemplate: TMenuItem;
    pmItemDuplicateTemplate: TMenuItem;
    pmItemDeleteTemplate: TMenuItem;
    N2: TMenuItem;
    pmItemOpenTemplateDirectory: TMenuItem;
    pmItemCreateDefaultTemplates: TMenuItem;
    ImgHelp: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSelectExportFilenameClick(Sender: TObject);
    procedure lbTemplatesClick(Sender: TObject);
    procedure edtExportFileNameChange(Sender: TObject);
    procedure ActionEditTemplateExecute(Sender: TObject);
    procedure mmItemFileClick(Sender: TObject);
    procedure ActionNewTemplateExecute(Sender: TObject);
    procedure ActionDuplicateTemplateExecute(Sender: TObject);
    procedure ActionOpenDirectoryExecute(Sender: TObject);
    procedure ActionDeleteTemplateExecute(Sender: TObject);
    procedure ActionCreateDefaultTemplatesExecute(Sender: TObject);
    procedure ImgHelpClick(Sender: TObject);
  private
    { Private-Deklarationen }
    fAudioExport: TAudioExport;
    function AbsoluteFilename(listIdx: Integer): String;

    procedure SetExportDirectory(Value: String);
    function GetExportDirectory: String;
    function GetExportMode: Integer;
    procedure SetExportMode(Value: Integer);
    function GetDefaultTemplate: String;
    procedure SetDefaultTemplate(Value: String);
    procedure DoTemplateChange(Value: String);

    procedure SetExportFilename(Value: String);
    function GetExportFilename: String;

    procedure DoSearchAndFill;
    procedure AddAndSelectNewTemplate(aName: String);
    procedure CheckSettings;
    procedure CheckActions;
  public
    { Public-Deklarationen }
    property AudioExport: TAudioExport read fAudioExport write fAudioExport;
    property ExportFilename: String read GetExportFilename write SetExportFilename;

    property ExportMode: Integer read GetExportMode write SetExportMode;
    property DefaultTemplate: String read GetDefaultTemplate write SetDefaultTemplate;
    property ExportDirectory: String read GetExportDirectory write SetExportDirectory;

    procedure SearchTemplates;
  end;

var
  FormExport: TFormExport;

implementation

{$R *.dfm}

uses
  MyDialogs, GnuGettext, Nemp_RessourceStrings, Hilfsfunktionen, StringHelper, NempHelp;


function IsValidFilename(const FileName: string): boolean;
begin
  result := DirectoryExists(ExtractFilePath(FileName)) and TPath.HasValidFileNameChars(ExtractFileName(FileName), false);
end;


procedure TFormExport.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
  HelpContext := HELP_CSVExport;
end;

procedure TFormExport.FormDestroy(Sender: TObject);
begin
//
end;

procedure TFormExport.FormShow(Sender: TObject);
begin
  CheckSettings;
  CheckActions;
  DoTemplateChange(AbsoluteFilename(lbTemplates.ItemIndex));
end;

{
  Getter/Setter methods
}
function TFormExport.GetExportMode: Integer;
begin
  result := rgExportSelection.ItemIndex;
end;

procedure TFormExport.ImgHelpClick(Sender: TObject);
begin
  Application.HelpContext(HELP_CSVExport);
end;

procedure TFormExport.SetExportMode(Value: Integer);
begin
  if (Value >= 0) and (Value < rgExportSelection.Items.Count) then
    rgExportSelection.ItemIndex := Value;
end;

procedure TFormExport.SetExportDirectory(Value: String);
begin
  saveDlgExport.InitialDir := Value;
end;

function TFormExport.GetExportDirectory: String;
begin
  result := ExtractFilePath(saveDlgExport.FileName);
end;

procedure TFormExport.SetDefaultTemplate(Value: String);
begin
  Value := ChangeFileExt(ExtractFilename(Value), '');
  var idx: Integer := lbTemplates.Items.IndexOf(Value);
  if idx >= 0 then begin
    lbTemplates.ItemIndex := idx;
    DoTemplateChange(AbsoluteFilename(lbTemplates.ItemIndex));
  end;
end;

function TFormExport.GetDefaultTemplate: String;
begin
  result := lbTemplates.Items[lbTemplates.ItemIndex];
end;

procedure TFormExport.SetExportFilename(Value: String);
begin
  edtExportFileName.Text := Value;
end;

function TFormExport.GetExportFilename: String;
begin
  result := edtExportFileName.Text;
end;

{
  SearchTemplates
  - Search templates in Template-Directory.
  - If no Templates can be found: Create the default ones.
}
procedure TFormExport.DoSearchAndFill;
var
  sr: TSearchrec;
begin
  lbTemplates.Clear;
  if Findfirst(fAudioExport.TemplateDirectory + '*.nxp', FaAnyfile, sr) = 0 then
  repeat
    if (sr.name<>'.') AND (sr.name<>'..') then
      lbTemplates.Items.Add(ChangeFileExt(sr.Name, ''));
  until (Findnext(sr) <> 0);
  Findclose(sr);
end;

procedure TFormExport.SearchTemplates;
begin
  DoSearchAndFill;
  if lbTemplates.Count > 0 then begin
    lbTemplates.ItemIndex := 0;
    DoTemplateChange(AbsoluteFilename(lbTemplates.ItemIndex));
  end else begin
    fAudioExport.CreateDefaultExportTemplates;
    DoSearchAndFill;
    if lbTemplates.Count > 0 then begin
      lbTemplates.ItemIndex := 0;
      DoTemplateChange(AbsoluteFilename(lbTemplates.ItemIndex));
    end
  end;
end;

{
  CheckActions
  - Enable/Disable the allowed/useful Actions
}
procedure TFormExport.CheckActions;
var
  sel: Boolean;
begin
  sel :=  (lbTemplates.Count > 0) and (lbTemplates.ItemIndex >= 0);
  ActionEditTemplate.Enabled := sel;
  ActionNewTemplate.Enabled := True;
  ActionDuplicateTemplate.Enabled := sel;
  ActionDeleteTemplate.Enabled := (lbTemplates.Count > 1) and (lbTemplates.ItemIndex >= 0);
end;

procedure TFormExport.mmItemFileClick(Sender: TObject);
begin
  CheckActions;
end;

procedure TFormExport.DoTemplateChange(Value: String);
var
  tmp: string;
begin
  fAudioExport.TemplateFilename := Value;
  if IsValidFilename(ExportFilename) then
    ExportFilename := ChangeFileExt(ExportFilename, fAudioExport.Extension);

  tmp := fAudioExport.Extension;
  Delete(tmp, 1, 1);
  SaveDlgExport.DefaultExt := tmp;

  if SameText(tmp,'csv') then
    SaveDlgExport.Filter := (MediaLibrary_CSVFilter) + ' (*.csv)|*.csv'
  else
    if SameText(tmp,'html') then
      SaveDlgExport.Filter := (MediaLibrary_HTMLFilter) + ' (*.html)|*.html'
    else
      SaveDlgExport.Filter := tmp + ' ' + (MediaLibrary_AnyFileFilter) + '(*.' + tmp +  ')|*.' + tmp;
end;

function TFormExport.AbsoluteFilename(listIdx: Integer): String;
begin
  result := fAudioExport.TemplateDirectory + lbTemplates.Items[lbTemplates.ItemIndex] + '.nxp';
end;

procedure TFormExport.lbTemplatesClick(Sender: TObject);
begin
  DoTemplateChange(AbsoluteFilename(lbTemplates.ItemIndex));
end;

procedure TFormExport.AddAndSelectNewTemplate(aName: String);
begin
  lbTemplates.Items.Add(ChangeFileExt(ExtractFilename(aName), ''));
  lbTemplates.ItemIndex := lbTemplates.Items.Count - 1;
  DoTemplateChange(AbsoluteFilename(lbTemplates.ItemIndex));
end;

procedure TFormExport.ActionNewTemplateExecute(Sender: TObject);
var
  newName: String;
begin
  if InputQuery(ExportNewTemplateCaption, ExportNewTemplatePrompt, newName) then begin
    newName := fAudioExport.CreateEmptyTemplate(newName);
    AddAndSelectNewTemplate(newName);
    CheckActions;
    ShellExecute(Handle, 'open', 'notepad.exe', PChar(newName), Nil, SW_ShowNormal);
  end;
end;

procedure TFormExport.ActionDuplicateTemplateExecute(Sender: TObject);
var
  newName: String;
begin
  if InputQuery(ExportNewTemplateCaption, ExportNewTemplatePrompt, newName) then begin
    newName := fAudioExport.DuplicateTemplate(AbsoluteFilename(lbTemplates.ItemIndex), newName);
    AddAndSelectNewTemplate(newName);
    CheckActions;
    ShellExecute(Handle, 'open', 'notepad.exe', PChar(newName), Nil, SW_ShowNormal);
  end;
end;

procedure TFormExport.ActionDeleteTemplateExecute(Sender: TObject);
begin
  if TranslateMessageDLG(
          Format((ExportDeleteTemplateConfirmation), [lbTemplates.Items[lbTemplates.ItemIndex]]),
          mtConfirmation, [mbYes,MBNo, mbCancel], 0) = mrYes
  then begin
    if DeleteFile(AbsoluteFilename(lbTemplates.ItemIndex)) then begin
      lbTemplates.Items.Delete(lbTemplates.ItemIndex);
      lbTemplates.ItemIndex := 0;
      DoTemplateChange(AbsoluteFilename(lbTemplates.ItemIndex));
    end
    else
      TranslateMessageDLG(ExportDeleteTemplateConfirmation, mtWarning, [mbOK], 0);
  end;
  CheckActions;
end;

procedure TFormExport.ActionEditTemplateExecute(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'notepad.exe', PChar(AbsoluteFilename(lbTemplates.ItemIndex)), Nil, SW_ShowNormal);
end;

procedure TFormExport.ActionOpenDirectoryExecute(Sender: TObject);
begin
  ShellExecute(Handle, 'open' ,'explorer.exe', PChar('"'+ fAudioExport.TemplateDirectory +'"'), '', sw_ShowNormal)
end;

procedure TFormExport.ActionCreateDefaultTemplatesExecute(Sender: TObject);
begin
  fAudioExport.CreateDefaultExportTemplates;
  DoSearchAndFill;
  if lbTemplates.Count > 0 then begin
    lbTemplates.ItemIndex := 0;
    DoTemplateChange(AbsoluteFilename(lbTemplates.ItemIndex));
  end
end;

procedure TFormExport.btnSelectExportFilenameClick(Sender: TObject);
begin
  if SaveDlgExport.Execute then begin
    ExportFilename := saveDlgExport.FileName;
    CheckSettings;
  end;
end;

procedure TFormExport.CheckSettings;
begin
  BtnOk.Enabled := IsValidFilename(edtExportFileName.Text) and FileExists(fAudioExport.TemplateFilename);
end;

procedure TFormExport.edtExportFileNameChange(Sender: TObject);
begin
  CheckSettings;
end;

end.
