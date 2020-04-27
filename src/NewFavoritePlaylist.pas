unit NewFavoritePlaylist;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, StrUtils;

type
  TNewFavoritePlaylistForm = class(TForm)
    edit_PlaylistDescription: TLabeledEdit;
    edit_PlaylistFilename: TLabeledEdit;
    cb_AutoCreateFilename: TCheckBox;
    BtnOK: TButton;
    BtnCancel: TButton;
    lbl_Hint: TLabel;
    procedure FormShow(Sender: TObject);
    procedure edit_PlaylistDescriptionChange(Sender: TObject);
    procedure edit_PlaylistFilenameChange(Sender: TObject);
    procedure cb_AutoCreateFilenameClick(Sender: TObject);
  private
    { Private declarations }
    procedure CheckInput(aDescription, aFilename: String);
  public
    { Public declarations }
  end;

var
  NewFavoritePlaylistForm: TNewFavoritePlaylistForm;

implementation

uses NempMainUnit, StringHelper, PlaylistClass, PlaylistManagement, Nemp_RessourceStrings;

{$R *.dfm}

procedure TNewFavoritePlaylistForm.CheckInput(aDescription, aFilename: String);
var FileOK, IsValid, IsEmpty: Boolean;
    PlaylistInfoOK: Integer;
begin
    if not AnsiEndsText('.npl', aFilename) then
        aFilename := aFilename + '.npl';

    IsEmpty := AnsiSameText(trim(aFilename), '.npl');
    IsValid := IsValidFilename(aFilename);
    FileOK := IsValid and (not IsEmpty)
            and (not FileExists(NempPlayList.PlaylistManager.UserSavePath + aFilename));

    PlaylistInfoOK := NempPlaylist.PlaylistManager.PlaylistExist(
        edit_PlaylistDescription.Text,
        edit_PlaylistFilename.Text);

    if (PlaylistInfoOK = PLAYLIST_MANAGER_OK) and FileOK then
    begin
        lbl_Hint.Caption := PlaylistManager_CheckOK;
        BtnOk.Enabled := True;
    end else
    begin
        begin
            BtnOk.Enabled := False;
            case PlaylistInfoOK of
                PLAYLIST_MANAGER_OK : begin
                                          if IsEmpty then
                                              lbl_Hint.Caption := PlaylistManager_EmptyFilename
                                          else
                                          if not IsValid then
                                              lbl_Hint.Caption := PlaylistManager_EmptyFilename
                                          else
                                          if not FileOK then
                                              lbl_Hint.Caption := PlaylistManager_FileExists;
                                      end;
                PLAYLIST_MANAGER_FILE_EXISTS        : lbl_Hint.Caption := PlaylistManager_FileExists ;
                PLAYLIST_MANAGER_DESCRIPTION_EXISTS : lbl_Hint.Caption := PlaylistManager_NameExists ;
            else
                lbl_Hint.Caption := PlaylistManager_Duplicate;
            end;
        end;
    end;
end;

procedure TNewFavoritePlaylistForm.FormShow(Sender: TObject);
begin
    edit_PlaylistFilename.Enabled := Not cb_AutoCreateFilename.Checked;
    edit_PlaylistDescription.Text := NempPlayList.PlaylistManager.GetUnusedPlaylistFile;

    CheckInput(edit_PlaylistDescription.Text, edit_PlaylistFilename.Text);
end;

procedure TNewFavoritePlaylistForm.cb_AutoCreateFilenameClick(Sender: TObject);
begin
    edit_PlaylistFilename.Enabled := Not cb_AutoCreateFilename.Checked;
end;

procedure TNewFavoritePlaylistForm.edit_PlaylistFilenameChange(Sender: TObject);
begin
    CheckInput(edit_PlaylistDescription.Text, edit_PlaylistFilename.Text);
end;

procedure TNewFavoritePlaylistForm.edit_PlaylistDescriptionChange(Sender: TObject);
var s: String;
begin
    if cb_AutoCreateFilename.Checked then
    begin
        s := ConvertToFileName(edit_PlaylistDescription.Text);

        edit_PlaylistFilename.OnChange := Nil;
        edit_PlaylistFilename.Text := s + '.npl';
        edit_PlaylistFilename.OnChange := edit_PlaylistFilenameChange;
    end;

    CheckInput(edit_PlaylistDescription.Text, edit_PlaylistFilename.Text);
end;



end.
