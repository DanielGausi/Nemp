unit NewFavoritePlaylist;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TNewFavoritePlaylistForm = class(TForm)
    edit_PlaylistName: TLabeledEdit;
    edit_PlaylistFilename: TLabeledEdit;
    cb_AutoCreateFilename: TCheckBox;
    BtnOK: TButton;
    BtnCancel: TButton;
    procedure FormShow(Sender: TObject);
    procedure edit_PlaylistNameChange(Sender: TObject);
    procedure edit_PlaylistFilenameChange(Sender: TObject);
    procedure cb_AutoCreateFilenameClick(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  NewFavoritePlaylistForm: TNewFavoritePlaylistForm;

implementation

uses NempMainUnit, StringHelper, PlaylistClass, PlaylistManagement;

{$R *.dfm}

procedure TNewFavoritePlaylistForm.FormShow(Sender: TObject);
begin
    edit_PlaylistFilename.Enabled := Not cb_AutoCreateFilename.Checked;
    edit_PlaylistName.Text := NempPlayList.PlaylistManager.GetUnusedPlaylistFile;
end;


procedure TNewFavoritePlaylistForm.cb_AutoCreateFilenameClick(Sender: TObject);
begin
    edit_PlaylistFilename.Enabled := Not cb_AutoCreateFilename.Checked;
end;

procedure TNewFavoritePlaylistForm.edit_PlaylistFilenameChange(Sender: TObject);
begin
    BtnOK.Enabled := IsValidFilename(edit_PlaylistFilename.Text);
end;

procedure TNewFavoritePlaylistForm.edit_PlaylistNameChange(Sender: TObject);
var s: String;
    i: Integer;
begin
    if cb_AutoCreateFilename.Checked then
    begin
        s := edit_PlaylistName.Text;
        for i := 1 to Length(s) do
        begin
            if s[i] = ':' then s[i] := '-';
            if s[i] = '/' then s[i] := '-';
            if s[i] = '\' then s[i] := '-';
            if s[i] = '*' then s[i] := '-';
            if s[i] = '?' then s[i] := '-';
            if s[i] = '"' then s[i] := '_';
            if s[i] = '<' then s[i] := '-';
            if s[i] = '>' then s[i] := '-';
            if s[i] = '|' then s[i] := '_';
        end;

        edit_PlaylistFilename.OnChange := Nil;
        edit_PlaylistFilename.Text := s + '.npl';
        edit_PlaylistFilename.OnChange := edit_PlaylistFilenameChange;
    end;
end;



end.
