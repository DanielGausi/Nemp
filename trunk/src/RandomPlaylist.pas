{

    Unit RandomPlaylist
    Form RandomPlaylistForm

    Settings for Random-Playlist.

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
unit RandomPlaylist;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, CheckLst,  iniFiles, ContNrs,
  Menus,   Hilfsfunktionen,
  MP3FileUtils, Nemp_ConstantsAndTypes,
  gnuGettext, Nemp_RessourceStrings, ExtCtrls, ImgList, RatingCtrls;

type
  TGenreSetting = class
    public
      Name: String;
      Checked: Array of Boolean;
      constructor Create;
      destructor Destroy; override;
  end;

  TRandomPlaylistForm = class(TForm)
    GrpBox_Date: TGroupBox;
    LblConst_PeriodTo: TLabel;
    LblConst_PeriodFrom: TLabel;
    SE_PeriodTo: TSpinEdit;
    cbIgnoreYear: TCheckBox;
    GrpBox_Genre: TGroupBox;
    cbIgnoreGenres: TCheckBox;
    cbGenres: TCheckListBox;
    SE_PeriodFrom: TSpinEdit;
    GrpBox_General: TGroupBox;
    seMaxCount: TSpinEdit;
    LblConst_MaxCount: TLabel;
    LblConst_TitlesFrom: TLabel;
    Btn_Ok: TButton;
    Btn_Cancel: TButton;
    LblConst_Preselection: TLabel;
    Btn_Save: TButton;
    cb_Preselection: TComboBox;
    CBWholeBib: TComboBox;
    CBInsertMode: TComboBox;
    GrpBox_Rating: TGroupBox;
    CBRating: TComboBox;
    RatingImage: TImage;
    GrpBox_Duration: TGroupBox;
    CBMinLength: TCheckBox;
    CBMaxLength: TCheckBox;
    SE_MinLength: TSpinEdit;
    SE_MaxLength: TSpinEdit;
    LblMinLength: TLabel;
    LblMaxLength: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure cbIgnoreYearClick(Sender: TObject);
    procedure cbIgnoreGenresClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    function CheckNewName(aName: String; OwnIndex: Integer): Boolean;
    procedure Btn_OkClick(Sender: TObject);
    Procedure SaveSettings;
    procedure cb_PreselectionChange(Sender: TObject);
    procedure Btn_SaveClick(Sender: TObject);
    procedure RatingImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure RatingImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RatingImageMouseLeave(Sender: TObject);
    procedure CBMinLengthClick(Sender: TObject);
    procedure CBMaxLengthClick(Sender: TObject);
    procedure SE_MinLengthChange(Sender: TObject);
    procedure SE_MaxLengthChange(Sender: TObject);
  private
    { Private-Deklarationen }
    GenreSettings: Array [0..9] of TGenreSetting;
    LastSelection: Integer;

    ActualRating: Integer;
    RandomRatingHelper : TRatingHelper;

  public
    { Public-Deklarationen }
    procedure BackupComboboxes;
    procedure RestoreComboboxes;
    //procedure ShowRating(Value: Integer);
  end;



var
  RandomPlaylistForm: TRandomPlaylistForm;
  DefaultGenreSettings: Array[0..9] of tStringlist;

const DefaultGenreNames: Array[0..9] of String =
              ('Rock, Pop, ...',
               'Hard Rock, Metal, ...',
               'Techno, House, ...',
               'RnB, Hip Hop, ...',
               'Classic',
               'Meditation',
               '<Custom 1>',
               '<Custom 2>',
               '<Custom 3>',
               '<Custom 4>'
               );

implementation

{$R *.dfm}

Uses NempMainUnit;

Constructor TGenreSetting.Create;
var i: Integer;
begin
  inherited create;
  Name := '';
  Setlength(Checked, Genres.Count);
  for i := 0 to length(Checked) - 1 do
    Checked[i] := False;
end;

Destructor TGenreSetting.Destroy;
begin
  inherited destroy;
end;


procedure TRandomPlaylistForm.FormCreate(Sender: TObject);
var ini: TMemIniFile;
    genresCount, i, j, idx, rat: Integer;
    aGenre, BaseDir: String;
    s,h,u: TBitmap;
    ltmp: Integer;
begin
  
  BackupComboboxes;
  TranslateComponent (self);
  RestoreComboboxes;
  cbGenres.Items.Clear;
  cbGenres.Items := Genres;

  RandomRatingHelper := TRatingHelper.Create;
  s := TBitmap.Create;
  h := TBitmap.Create;
  u := TBitmap.Create;
  BaseDir := ExtractFilePath(ParamStr(0)) + 'Data\img\';
  try
      Nemp_MainForm.NempSkin.LoadGraphicFromBaseName(s, BaseDir + 'starset')    ;
      Nemp_MainForm.NempSkin.LoadGraphicFromBaseName(h, BaseDir + 'starhalfset');
      Nemp_MainForm.NempSkin.LoadGraphicFromBaseName(u, BaseDir + 'starunset')  ;
      RandomRatingHelper.SetStars(s,h,u);
  finally
      s.Free;
      h.Free;
      u.Free;
  end;

  ini := TMeminiFile.Create(SavePath + 'RandomPlaylist.ini', TEncoding.UTF8);
  try
    ini.Encoding := TEncoding.UTF8;
    LastSelection := Ini.ReadInteger('Allgemein', 'LastSelection', 0);
    seMaxCount.Value := Ini.ReadInteger('Allgemein', 'MaxAnzahl', 100);
    if Ini.ReadBool('Allgemein', 'GanzeBib', True) then
      CBWholeBib.ItemIndex := 0
    else
      CBWholeBib.ItemIndex := 1;

    cbIgnoreYear.Checked := Ini.ReadBool('Allgemein', 'IgnoreYear', True);
    cbIgnoreYearClick(Nil);
    SE_PeriodFrom.Value := Ini.ReadInteger('Allgemein', 'MinYear', 2000);
    SE_PeriodTo.Value := Ini.ReadInteger('Allgemein', 'MaxYear', 2007);

    cbIgnoreGenres.Checked := Ini.ReadBool('Allgemein', 'IgnoreGenre', True);
    cbIgnoreGenresClick(Nil);

    // Rating gedöns auslesen
    idx := Ini.ReadInteger('Allgemein', 'Rating', 0);
    if (idx >= 0) and (idx <= 3) then
        CBRating.ItemIndex := idx
    else
        CBRating.ItemIndex := 0;

    rat := ini.ReadInteger('Allgemein', 'RatingValue', 128);
    if (rat >= 0) and (rat <= 255) then
        ActualRating := Rat
    else
        ActualRating := 128;

    RandomRatingHelper.DrawRatingInStarsOnBitmap(ActualRating, RatingImage.Picture.Bitmap, RatingImage.Width, RatingImage.Height);

    //ShowRating(ActualRating);
    //--

    // Duration-settings
    CBMinLength.Checked := Ini.ReadBool('Duration', 'UseMinLength', True);
    CBMaxLength.Checked := Ini.ReadBool('Duration', 'UseMaxLength', True);
    ltmp := Ini.ReadInteger('Duration', 'MinLength', 60);
    if ltmp < 0 then ltmp := 0;
    if ltmp > 7200 then ltmp := 7200;
    SE_MinLength.Value := ltmp;
    LblMinLength.Caption := SekToZeitString(ltmp);
    SE_MinLength.Enabled := CBMinLength.Checked;
    LblMinLength.Enabled := CBMinLength.Checked;

    ltmp := Ini.ReadInteger('Duration', 'MaxLength', 600);
    if ltmp < 0 then ltmp := 0;
    if ltmp > 7200 then ltmp := 7200;
    SE_MaxLength.Value := ltmp;
    LblMaxLength.Caption := SekToZeitString(ltmp);
    SE_MaxLength.Enabled := CBMaxLength.Checked;
    LblMaxLength.Enabled := CBMaxLength.Checked;


    // Genre-Settings
    for i := 0 to 9 do
    begin
      if ini.SectionExists('GenreSetting' + IntToStr(i)) then
      begin
        // Daten aus der Sektion lesen
        GenreSettings[i] := TGenreSetting.Create;
        genresCount := Ini.ReadInteger('GenreSetting' + IntToStr(i), 'Count', 0);
        GenreSettings[i].Name := Ini.ReadString('GenreSetting' + IntToStr(i), 'Name', 'Setting' + IntToStr(i));
        for j := 0 to genresCount-1 do
        begin
          aGenre := Ini.ReadString('GenreSetting' + IntToStr(i),
                                   'Check' + IntToStr(j),
                                   'NotAValidGenre');
          idx := CBGenres.Items.IndexOf(aGenre);
          if (idx >= 0) AND (idx <= length(GenreSettings[i].Checked)-1) then
            GenreSettings[i].Checked[idx] := True;
        end;
      end else
      begin
        // Standardwerte nehmen
        GenreSettings[i] := TGenreSetting.Create;
        GenreSettings[i].Name := DefaultGenreNames[i];
        for j := 0 to DefaultGenreSettings[i].Count - 1 do
        begin
          idx := CBGenres.Items.IndexOf(DefaultGenreSettings[i][j]);
          if (idx >= 0) AND (idx <= length(GenreSettings[i].Checked)-1) then
            GenreSettings[i].Checked[idx] := True;
        end;
      end;
      cb_Preselection.Items.Add(GenreSettings[i].Name);
    end;
    // Damit wird die LastSelection aktiviert.
    cb_Preselection.ItemIndex := LastSelection;

  finally
    ini.Free;
  end;
end;

procedure TRandomPlaylistForm.FormDestroy(Sender: TObject);
var i: Integer;
begin
  for i := 0 to length(GenreSettings)-1 do
    GenreSettings[i].Free;

  RandomRatingHelper.Free;
end;

procedure TRandomPlaylistForm.cbIgnoreYearClick(Sender: TObject);
begin
  LblConst_PeriodFrom.Enabled := NOT cbIgnoreYear.Checked;
  LblConst_PeriodTo  .Enabled := NOT cbIgnoreYear.Checked;
  SE_PeriodFrom.Enabled := NOT cbIgnoreYear.Checked;
  SE_PeriodTo  .Enabled := NOT cbIgnoreYear.Checked;
end;

procedure TRandomPlaylistForm.CBMaxLengthClick(Sender: TObject);
begin
    SE_MaxLength.Enabled := CBMaxLength.Checked;
    LblMaxLength.Enabled := CBMaxLength.Checked;
end;

procedure TRandomPlaylistForm.CBMinLengthClick(Sender: TObject);
begin
    SE_MinLength.Enabled := CBMinLength.Checked;
    LblMinLength.Enabled := CBMinLength.Checked;
end;

procedure TRandomPlaylistForm.SE_MaxLengthChange(Sender: TObject);
begin
    LblMaxLength.Caption := SekToZeitString(SE_MaxLength.Value);
end;

procedure TRandomPlaylistForm.SE_MinLengthChange(Sender: TObject);
begin
    LblMinLength.Caption := SekToZeitString(SE_MinLength.Value);
end;


procedure TRandomPlaylistForm.cbIgnoreGenresClick(Sender: TObject);
begin
  cbGenres.Enabled := NOT cbIgnoreGenres.Checked;
  Btn_Save.Enabled := Not cbIgnoreGenres.Checked;
end;

procedure TRandomPlaylistForm.Btn_SaveClick(Sender: TObject);
var ini: TMemIniFile;
    genresCount, i, idx: Integer;
    NewName: String;
    ok: boolean;
begin
  idx := cb_Preselection.ItemIndex;

  //if idx > 5 then
  begin
      NewName := GenreSettings[idx].Name;
      // Namen eingeben lassen
      repeat
          ok := InputQuery('Genre-Auswahl speichern',
                     'Geben Sie eine (neue) Bezeichnung für die Auswahl an',
                      NewName);
          if not CheckNewName(NewName, idx) then
            MessageDLG('Diese Bezeichnung existiert bereits oder ist ungültig. Bitte geben Sie eine andere ein.', mtError, [mbOk], 0);
       until (NOT ok) or (CheckNewName(NewName, idx));

      if not ok then exit;

      GenreSettings[idx].Name := NewName;
      cb_Preselection.Items[idx] := NewName;
      cb_Preselection.ItemIndex := idx;
  end;


  ini := TMeminiFile.Create(SavePath + 'RandomPlaylist.ini', TEncoding.UTF8);
  try
    ini.Encoding := TEncoding.UTF8;
    if ini.SectionExists('GenreSetting' + IntToStr(idx)) then
      ini.EraseSection('GenreSetting' + IntToStr(idx));

    Ini.WriteString('GenreSetting' + IntToStr(idx), 'Name', GenreSettings[idx].Name);
    genresCount := 0;
    for i := 0 to cBGenres.Count - 1 do
    begin
      if cBGenres.Checked[i] then
      begin
        Ini.WriteString('GenreSetting' + IntToStr(idx), 'Check' + IntToStr(GenresCount), cBGenres.Items[i] );
        inc(GenresCount);
      end;
    end;
    Ini.WriteInteger('GenreSetting' + IntToStr(idx), 'Count', GenresCount);
    try
        Ini.UpdateFile;
    except
        // Silent Exception
    end;
  finally
    ini.Free;
  end;

end;

function TRandomPlaylistForm.CheckNewName(aName: String; OwnIndex: Integer):Boolean;
var i: Integer;
begin
  result := True;
  aName := Trim(aName);
  if aName = '' then
    result := False
  else
    for i := 0 to length(GenreSettings) - 1 do
      if AnsiSameText(aName, GenreSettings[i].Name) and (i <> OwnIndex)then
      begin
        result :=False;
        break;
      end;
end;

procedure TRandomPlaylistForm.SaveSettings;
var ini: TMemIniFile;

begin
  ini := TMeminiFile.Create(SavePath + 'RandomPlaylist.ini', TEncoding.UTF8);
  try
    ini.Encoding := TEncoding.UTF8;
    Ini.WriteInteger('Allgemein', 'LastSelection', LastSelection);
    Ini.WriteInteger('Allgemein', 'MaxAnzahl', seMaxCount.Value);
    Ini.WriteBool('Allgemein', 'GanzeBib', CBWholeBib.ItemIndex = 0);
    Ini.WriteBool('Allgemein', 'IgnoreYear', cbIgnoreYear.Checked);

    Ini.WriteInteger('Allgemein', 'MinYear', SE_PeriodFrom.Value);
    Ini.WriteInteger('Allgemein', 'MaxYear', SE_PeriodTo.Value);

    Ini.WriteBool('Allgemein', 'IgnoreGenre', cbIgnoreGenres.Checked);


     // Rating gedöns speichern
    Ini.WriteInteger('Allgemein', 'Rating', CBRating.ItemIndex);
    ini.WriteInteger('Allgemein', 'RatingValue', ActualRating);

    // Duration-settings
    Ini.WriteBool('Duration', 'UseMinLength', CBMinLength.Checked);
    Ini.WriteBool('Duration', 'UseMaxLength', CBMaxLength.Checked);
    Ini.WriteInteger('Duration', 'MinLength', SE_MinLength.Value);
    Ini.WriteInteger('Duration', 'MaxLength', SE_MaxLength.Value);

    try
        Ini.UpdateFile;
    except
        // Silent Exception
    end;
  finally
    ini.Free;
  end;
end;




procedure TRandomPlaylistForm.Btn_OkClick(Sender: TObject);
var i: Integer;
    DateiListe: TObjectList;
begin
  if MedienBib.StatusBibUpdate <> 0 then
  begin
    MessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
    exit;
  end;

  SaveSettings;
  with Medienbib.PlaylistFillOptions do
  begin
      SkipGenreCheck  := (cbIgnoreGenres.Checked);
      GenreStrings    := cbGenres.Items;
      Setlength(GenreChecked, GenreStrings.Count);
      for i := 0 to cbGenres.Items.Count - 1 do
          GenreChecked[i] := cbGenres.Checked[i];
      SkipYearCheck := cbIgnoreYear.Checked;
      MinYear       := SE_PeriodFrom.Value;
      MaxYear       := SE_PeriodTo.Value;
      MaxCount      := seMaxCount.Value;
      WholeBib      := CBWholeBib.ItemIndex = 0;
      RatingMode    := CBRating.ItemIndex;
      Rating        := ActualRating;

      UseMinLength := CBMinLength.Checked;
      UseMaxLength := CBMaxLength.Checked;
      MinLength := SE_MinLength.Value;
      MaxLength := SE_MaxLength.Value;
  end;

  DateiListe := TObjectList.Create(False);
  MedienBib.FillRandomList(DateiListe);
  if Dateiliste.Count <= 10 then
  begin
      if MessageDlg(
          Format((Hint_RandomPlaylist_NotEnoughTitlesFound), [Dateiliste.Count]),
          mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
          // Nemp_MainForm.HandleFiles(Dateiliste, PLAYER_PLAY_FILES);
          Nemp_MainForm.HandleFiles(Dateiliste, CBInsertMode.ItemIndex);
          FreeAndNil(Dateiliste);
          close;
      end else
          FreeAndNil(Dateiliste);
  end else
  begin
      Nemp_MainForm.HandleFiles(Dateiliste, CBInsertMode.ItemIndex);
      FreeAndNil(Dateiliste);
      close;
  end;
end;

procedure TRandomPlaylistForm.cb_PreselectionChange(Sender: TObject);
var i, idx: Integer;
begin
  idx := cb_Preselection.ItemIndex;
  if (idx > length(GenreSettings)-1) or (idx < 0) then exit;
  for i := 0 to cbGenres.Items.Count - 1 do
    cbGenres.Checked[i] := GenreSettings[idx].Checked[i];
end;

procedure TRandomPlaylistForm.BackupComboboxes;
var i: Integer;
begin
    for i := 0 to self.ComponentCount - 1 do
      if (Components[i] is TComboBox) then
        Components[i].Tag := (Components[i] as TComboBox).ItemIndex;
end;

procedure TRandomPlaylistForm.RestoreComboboxes;
var i: Integer;
begin
  for i := 0 to self.ComponentCount - 1 do
      if (Components[i] is TComboBox) then
        (Components[i] as TComboBox).ItemIndex := Components[i].Tag;
end;

(*
procedure TRandomPlaylistForm.ShowRating(Value: Integer);
var aBmp: TBitmap;
begin
    if Value = 0 then
        Value := 128;
    aBmp := TBitmap.Create;
    try
        aBmp.Width := RatingImage.Width;
        aBmp.Height := RatingImage.Height;
        RandomRatingHelper.DrawRatingInStars(value, aBmp.canvas, RatingImage.Height);
         aBmp.Transparent := True;
        RatingImage.Picture.Bitmap.Assign(aBmp);
    finally
        aBmp.Free;
    end;
end;*)


procedure TRandomPlaylistForm.RatingImageMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var rat: Integer;
begin
    rat := RandomRatingHelper.MousePosToRating(x, 70);//((x div 8)) * 8;
    RandomRatingHelper.DrawRatingInStarsOnBitmap(rat, RatingImage.Picture.Bitmap, RatingImage.Width, RatingImage.Height);
    //ShowRating(rat);
end;

procedure TRandomPlaylistForm.RatingImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    ActualRating := RandomRatingHelper.MousePosToRating(x, 70);
end;

procedure TRandomPlaylistForm.RatingImageMouseLeave(Sender: TObject);
begin
//  ShowRating(ActualRating);
    RandomRatingHelper.DrawRatingInStarsOnBitmap(ActualRating, RatingImage.Picture.Bitmap, RatingImage.Width, RatingImage.Height);
end;

initialization

DefaultGenreSettings[0] := tStringlist.Create;
DefaultGenreSettings[1] := tStringlist.Create;
DefaultGenreSettings[2] := tStringlist.Create;
DefaultGenreSettings[3] := tStringlist.Create;
DefaultGenreSettings[4] := tStringlist.Create;
DefaultGenreSettings[5] := tStringlist.Create;
DefaultGenreSettings[6] := tStringlist.Create;
DefaultGenreSettings[7] := tStringlist.Create;
DefaultGenreSettings[8] := tStringlist.Create;
DefaultGenreSettings[9] := tStringlist.Create;

// Rock & Pop
DefaultGenreSettings[0].Add('Rock');
DefaultGenreSettings[0].Add('Rock & Roll');
DefaultGenreSettings[0].Add('Pop');
DefaultGenreSettings[0].Add('Other');
DefaultGenreSettings[0].Add('Instrumental Rock');
DefaultGenreSettings[0].Add('Instrumental Pop');
DefaultGenreSettings[0].Add('Pop/Funk');
DefaultGenreSettings[0].Add('Top 40');

// Hard Rock, Metal, etc
DefaultGenreSettings[1].Add('Hard Rock');
DefaultGenreSettings[1].Add('Death Metal');
DefaultGenreSettings[1].Add('Gothic');
DefaultGenreSettings[1].Add('Gothic Rock');
DefaultGenreSettings[1].Add('Metal');

// Techno, House, etc.
DefaultGenreSettings[2].Add('Club');
DefaultGenreSettings[2].Add('Dance');
DefaultGenreSettings[2].Add('Eurodance');
DefaultGenreSettings[2].Add('Euro-House');
DefaultGenreSettings[2].Add('Euro-Techno');
DefaultGenreSettings[2].Add('House');
DefaultGenreSettings[2].Add('Techno');
DefaultGenreSettings[2].Add('Techno-Industrial');
DefaultGenreSettings[2].Add('Trance');
DefaultGenreSettings[2].Add('Rave');

// RnB, Hip Hop, etc.
DefaultGenreSettings[3].Add('Freestyle');
DefaultGenreSettings[3].Add('Gangsta');
DefaultGenreSettings[3].Add('Hip-Hop');
DefaultGenreSettings[3].Add('R&B');
DefaultGenreSettings[3].Add('Rap');

// Klassisch
DefaultGenreSettings[4].Add('Classical');
DefaultGenreSettings[4].Add('Sonata');
DefaultGenreSettings[4].Add('Symphony');
DefaultGenreSettings[4].Add('Chamber Music');

// Meditation
DefaultGenreSettings[5].Add('Easy Listening');
DefaultGenreSettings[5].Add('Meditative');
DefaultGenreSettings[5].Add('New Age');

DefaultGenreSettings[6].Add('Other');
DefaultGenreSettings[7].Add('Other');
DefaultGenreSettings[8].Add('Other');
DefaultGenreSettings[9].Add('Other');



finalization

DefaultGenreSettings[0].Free;
DefaultGenreSettings[1].Free;
DefaultGenreSettings[2].Free;
DefaultGenreSettings[3].Free;
DefaultGenreSettings[4].Free;
DefaultGenreSettings[5].Free;
DefaultGenreSettings[6].Free;
DefaultGenreSettings[7].Free;
DefaultGenreSettings[8].Free;
DefaultGenreSettings[9].Free;


end.
