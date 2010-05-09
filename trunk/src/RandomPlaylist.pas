{

    Unit RandomPlaylist
    Form RandomPlaylistForm

    Settings for Random-Playlist.

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2005-2010, Daniel Gaussmann
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
unit RandomPlaylist;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, CheckLst,  iniFiles, ContNrs,
  Menus,   Hilfsfunktionen, AudioFileClass,
  MP3FileUtils, Nemp_ConstantsAndTypes,
  gnuGettext, Nemp_RessourceStrings, ExtCtrls, ImgList, RatingCtrls;

type
  TTagSetting = class
    private
        function fGetCount: Integer;
    public
        MatchType: Integer;
        CheckList: TStringList;
        property Count: Integer read fGetCount;
        constructor Create;
        destructor Destroy; override;
        procedure Add(aString: String);
  end;

  TRandomPlaylistForm = class(TForm)
    GrpBox_Date: TGroupBox;
    LblConst_PeriodTo: TLabel;
    LblConst_PeriodFrom: TLabel;
    SE_PeriodTo: TSpinEdit;
    cbIgnoreYear: TCheckBox;
    GrpBox_Tags: TGroupBox;
    cbIgnoreGenres: TCheckBox;
    cbGenres: TCheckListBox;
    SE_PeriodFrom: TSpinEdit;
    GrpBox_General: TGroupBox;
    seMaxCount: TSpinEdit;
    LblConst_MaxCount: TLabel;
    LblConst_TitlesFrom: TLabel;
    Btn_Ok: TButton;
    Btn_Cancel: TButton;
    Lbl_Preselection: TLabel;
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
    cbTagCountSelection: TComboBox;
    LblTagViewCount: TLabel;
    cbTagMatchType: TComboBox;
    LblTagMatchType: TLabel;
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
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure cbTagCountSelectionChange(Sender: TObject);
  private
    { Private-Deklarationen }
    //GenreSettings: Array [0..9] of TGenreSetting;
    TagSettings: Array [0..9] of TTagSetting;
    LastSelection: Integer;
    LastCheckedTags: TStringList;

    ActualRating: Integer;
    RandomRatingHelper : TRatingHelper;

    LocalTopTags: TObjectList;

    procedure SetLastCheckedTags;
    procedure RecheckLastCheckedTags;

    procedure FillTagList;
    procedure RefillTagList;



  public
    { Public-Deklarationen }
    procedure BackupComboboxes;
    procedure RestoreComboboxes;
    //procedure ShowRating(Value: Integer);
  end;



var
  RandomPlaylistForm: TRandomPlaylistForm;
  DefaultGenreSettings: Array[0..9] of tStringlist;

{const DefaultGenreNames: Array[0..9] of String =
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
               );   }

implementation

{$R *.dfm}

Uses NempMainUnit, TagClouds;


Constructor TTagSetting.Create;
var i: Integer;
begin
    inherited create;
    CheckList := TStringList.Create;
    MatchType := 2;
end;

Destructor TTagSetting.Destroy;
begin
    CheckList.Free;
    inherited destroy;
end;

function TTagSetting.fGetCount: Integer;
begin
    result := CheckList.Count;
end;

procedure TTagSetting.Add(aString: String);
begin
    CheckList.Add(aString);
end;


procedure TRandomPlaylistForm.FormCreate(Sender: TObject);
var ini: TMemIniFile;
    genresCount, i, j, idx, rat: Integer;
    BaseDir, aTag: String;
    s,h,u: TBitmap;
    ltmp, c: Integer;
begin
  
  BackupComboboxes;
  TranslateComponent (self);
  RestoreComboboxes;
  cbGenres.Items.Clear;
  // cbGenres.Items := Genres;

  RandomRatingHelper := TRatingHelper.Create;
  LocalTopTags := TObjectList.Create(False);
  LastCheckedTags := TStringList.Create;

  s := TBitmap.Create;
  h := TBitmap.Create;
  u := TBitmap.Create;
  BaseDir := ExtractFilePath(ParamStr(0)) + 'Images\';
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

    // LastChecked Tags
    LastCheckedTags.Clear;
    c := Ini.ReadInteger('LastCheckedTags', 'Count', -1);
    for i := 0 to c - 1 do
    begin
        aTag := Ini.ReadString('LastCheckedTags', 'Check' + IntToStr(i), '' );
        if trim(aTag) <> '' then
            LastCheckedTags.Add(aTag);
    end;
    LastSelection := Ini.ReadInteger('LastCheckedTags', 'PreselectionIndex', 0);

    ltmp := Ini.ReadInteger('LastCheckedTags', 'ShownTags', 5);
    if (ltmp >= 0) and (ltmp < cbTagCountSelection.Items.Count) then
        cbTagCountSelection.ItemIndex := ltmp
    else
        cbTagCountSelection.ItemIndex := 5;

    ltmp := Ini.ReadInteger('LastCheckedTags', 'TagMatchType', 4);
    if (ltmp >= 0) and (ltmp < cbTagMatchType.Items.Count) then
        cbTagMatchType.ItemIndex := ltmp
    else
        cbTagMatchType.ItemIndex := 4;

    // Genre-Settings
    for i := 0 to 9 do
    begin
        if ini.SectionExists('GenreSetting' + IntToStr(i)) then
        begin
            // Daten aus der Sektion lesen
            TagSettings[i] := TTagSetting.Create;

            // first entry is the name of the setting
            TagSettings[i].Add( Ini.ReadString('GenreSetting' + IntToStr(i), 'Name', 'Setting' + IntToStr(i)) );

            genresCount := Ini.ReadInteger('GenreSetting' + IntToStr(i), 'Count', 0);

            ltmp := Ini.ReadInteger('GenreSetting' + IntToStr(i), 'TagMatchType', 4);
            if (ltmp >= 0) and (ltmp < cbTagMatchType.Items.Count) then
                TagSettings[i].MatchType := ltmp
            else
                TagSettings[i].MatchType := 4;

            for j := 0 to genresCount-1 do
            begin
                aTag := Ini.ReadString('GenreSetting' + IntToStr(i), 'Check' + IntToStr(j), '');
                if aTag <> '' then
                    TagSettings[i].Add(aTag);
            end;
        end else
        begin
            // Standardwerte nehmen
            TagSettings[i] := TTagSetting.Create;
            for j := 0 to DefaultGenreSettings[i].Count - 1 do
                TagSettings[i].Add(DefaultGenreSettings[i][j]);
        end;
        if TagSettings[i].Count > 0 then
            cb_Preselection.Items.Add(TagSettings[i].CheckList[0])
        else
            cb_Preselection.Items.Add('-?-')
    end;
    // Damit wird die LastSelection aktiviert.
    ///// cb_Preselection.ItemIndex := LastSelection;

    cb_Preselection.OnChange := Nil;
    cb_Preselection.ItemIndex := LastSelection;
    cb_Preselection.OnChange := cb_PreselectionChange;
    //RecheckLastCheckedTags; // No. Do this not until OnShow

  finally
    ini.Free;
  end;
end;

procedure TRandomPlaylistForm.FormDestroy(Sender: TObject);
var i: Integer;
begin
  //for i := 0 to length(GenreSettings)-1 do
  //  GenreSettings[i].Free;
  for i := 0 to length(TagSettings) - 1 do
      TagSettings[i].Free;

  RandomRatingHelper.Free;
  LocalTopTags.Free;
  LastCheckedTags.Free;
end;

procedure TRandomPlaylistForm.FormResize(Sender: TObject);
begin
    cbGenres.Columns := Width Div 150;
end;

procedure TRandomPlaylistForm.SetLastCheckedTags;
var i: integer;
begin
    LastCheckedTags.Clear;
    for i := 0 to cbGenres.Count - 1 do
        if cbGenres.Checked[i] then
            LastCheckedTags.Add(TTag(cbGenres.Items.Objects[i]).Key);
end;

procedure TRandomPlaylistForm.RecheckLastCheckedTags;
var i: Integer;
begin
    for i := 0 to cbGenres.Count - 1 do
    begin
        cbGenres.Checked[i] := LastCheckedTags.IndexOf( TTag(cbGenres.Items.Objects[i]).Key ) >= 0;
    end;
end;

procedure TRandomPlaylistForm.FillTagList;
var i: Integer;
    aTag: TTag;
begin
      // clear ChecklistBox
    cbGenres.Clear;
    LocalTopTags.Clear;
    // Get new tags
    MedienBib.GetTopTags(StrToIntDef(cbTagCountSelection.Text, 150), 10, LocalTopTags);
    // Show Tags
    for i := 0 to LocalTopTags.Count - 1 do
    begin
        aTag := TTag(LocalTopTags[i]);
        cbGenres.AddItem( aTag.key + ' (' + IntToStr(aTag.TotalCount)+')', aTag);
    end;
end;

procedure TRandomPlaylistForm.RefillTagList;
begin
    SetLastCheckedTags;
    // Fill List
    FillTagList;
    // Restore checked items
    RecheckLastCheckedTags;
end;

procedure TRandomPlaylistForm.FormShow(Sender: TObject);
begin
    if MedienBib.BrowseMode <> 2 then
        MedienBib.ReBuildTagCloud;

    FillTagList;
    RecheckLastCheckedTags;
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
  cbGenres.Enabled := Not cbIgnoreGenres.Checked;
  Btn_Save.Enabled := Not cbIgnoreGenres.Checked;

  LblTagViewCount    .Enabled := Not cbIgnoreGenres.Checked;
  cbTagCountSelection.Enabled := Not cbIgnoreGenres.Checked;
  LblTagMatchType    .Enabled := Not cbIgnoreGenres.Checked;
  cbTagMatchType     .Enabled := Not cbIgnoreGenres.Checked;
  Lbl_Preselection   .Enabled := Not cbIgnoreGenres.Checked;
  cb_Preselection    .Enabled := Not cbIgnoreGenres.Checked;
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
      if TagSettings[idx].Count > 0 then
          NewName := TagSettings[idx].CheckList[0]
      else
          NewName := '-?-';
      // Namen eingeben lassen
      repeat
          ok := InputQuery('Genre-Auswahl speichern',
                     'Geben Sie eine (neue) Bezeichnung für die Auswahl an',
                      NewName);
          if not CheckNewName(NewName, idx) then
            MessageDLG('Diese Bezeichnung existiert bereits oder ist ungültig. Bitte geben Sie eine andere ein.', mtError, [mbOk], 0);
       until (NOT ok) or (CheckNewName(NewName, idx));

      if not ok then exit;

      if TagSettings[idx].Count = 0 then
          TagSettings[idx].Add(NewName)
      else
          TagSettings[idx].CheckList[0] := Newname;

      TagSettings[idx].MatchType := cbTagMatchType.ItemIndex;
      //GenreSettings[idx].Name := NewName;
      cb_Preselection.Items[idx] := NewName;
      cb_Preselection.ItemIndex := idx;
  end;


  ini := TMeminiFile.Create(SavePath + 'RandomPlaylist.ini', TEncoding.UTF8);
  try
    ini.Encoding := TEncoding.UTF8;
    if ini.SectionExists('GenreSetting' + IntToStr(idx)) then
      ini.EraseSection('GenreSetting' + IntToStr(idx));

    if TagSettings[idx].Count > 0 then
        Ini.WriteString('GenreSetting' + IntToStr(idx), 'Name', TagSettings[idx].CheckList[0])
    else
        Ini.WriteString('GenreSetting' + IntToStr(idx), 'Name', '-?-');

    genresCount := 0;
    for i := 0 to cBGenres.Count - 1 do
    begin
        if cBGenres.Checked[i] then
        begin
            Ini.WriteString('GenreSetting' + IntToStr(idx),
                            'Check' + IntToStr(GenresCount),
                            TTag(cbGenres.Items.Objects[i]).Key );
            inc(GenresCount);
        end;
    end;
    Ini.WriteInteger('GenreSetting' + IntToStr(idx), 'Count', GenresCount);
    Ini.WriteInteger('GenreSetting' + IntToStr(idx), 'TagMatchType', TagSettings[idx].MatchType);
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
      for i := 0 to length(TagSettings) - 1 do
          //if AnsiSameText(aName, GenreSettings[i].Name) and (i <> OwnIndex)then
          if (TagSettings[i].Count > 0) and (AnsiSameText(TagSettings[i].CheckList[0], aName)) and (i <> OwnIndex) then
          begin
              result :=False;
              break;
          end;
end;

procedure TRandomPlaylistForm.SaveSettings;
var ini: TMemIniFile;
    i: Integer;
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

    // save current Tag-settings
    if ini.SectionExists('LastCheckedTags') then
        ini.EraseSection('LastCheckedTags');
    Ini.WriteInteger('LastCheckedTags', 'Count', LastCheckedTags.Count);
    for i := 0 to LastCheckedTags.Count - 1 do
        Ini.WriteString('LastCheckedTags', 'Check' + IntToStr(i), LastCheckedTags[i] );
    Ini.WriteInteger('LastCheckedTags', 'PreselectionIndex', LastSelection);

    Ini.WriteInteger('LastCheckedTags', 'ShownTags', cbTagCountSelection.ItemIndex);
    Ini.WriteInteger('LastCheckedTags', 'TagMatchType', cbTagMatchType.ItemIndex);

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
    tmpTagList: TObjectList;

begin
  if MedienBib.StatusBibUpdate <> 0 then
  begin
    MessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
    exit;
  end;

  SetLastCheckedTags;
  SaveSettings;

  tmpTagList := TObjectList.Create(False);
  try
      //Medienbib.PlaylistFillOptions.GenreStrings    := cbGenres.Items;
      // Setlength(Medienbib.PlaylistFillOptions.GenreChecked, Medienbib.PlaylistFillOptions.GenreStrings.Count);
      // for i := 0 to cbGenres.Items.Count - 1 do
      //    Medienbib.PlaylistFillOptions.GenreChecked[i] := cbGenres.Checked[i];

      Medienbib.PlaylistFillOptions.SkipTagCheck  := (cbIgnoreGenres.Checked);

      if not Medienbib.PlaylistFillOptions.SkipTagCheck then
      begin
          for i := 0 to cbGenres.Count - 1 do
              if cbGenres.Checked[i] then
                  tmpTagList.Add(cbGenres.Items.Objects[i]);
          if tmpTagList.Count > 0 then
              Medienbib.PlaylistFillOptions.WantedTags := tmpTagList
          else
              Medienbib.PlaylistFillOptions.Wantedtags := Nil;

          case cbTagMatchType.ItemIndex of
              0: Medienbib.PlaylistFillOptions.MinTagMatchCount := tmpTagList.Count;
              1: Medienbib.PlaylistFillOptions.MinTagMatchCount := Round(tmpTagList.Count * 0.8);
              2: Medienbib.PlaylistFillOptions.MinTagMatchCount := Round(tmpTagList.Count * 0.5);
              3: Medienbib.PlaylistFillOptions.MinTagMatchCount := Round(tmpTagList.Count * 0.2);
              4: Medienbib.PlaylistFillOptions.MinTagMatchCount := 1;
          else
              Medienbib.PlaylistFillOptions.MinTagMatchCount := 1;
          end;
          if Medienbib.PlaylistFillOptions.MinTagMatchCount < 1 then
              Medienbib.PlaylistFillOptions.MinTagMatchCount := 1;
      end else
          Medienbib.PlaylistFillOptions.Wantedtags := Nil;

      Medienbib.PlaylistFillOptions.SkipYearCheck := cbIgnoreYear.Checked;
      Medienbib.PlaylistFillOptions.MinYear       := SE_PeriodFrom.Value;
      Medienbib.PlaylistFillOptions.MaxYear       := SE_PeriodTo.Value;
      Medienbib.PlaylistFillOptions.MaxCount      := seMaxCount.Value;
      Medienbib.PlaylistFillOptions.WholeBib      := CBWholeBib.ItemIndex = 0;
      Medienbib.PlaylistFillOptions.RatingMode    := CBRating.ItemIndex;
      Medienbib.PlaylistFillOptions.Rating        := ActualRating;

      Medienbib.PlaylistFillOptions.UseMinLength  := CBMinLength.Checked;
      Medienbib.PlaylistFillOptions.UseMaxLength  := CBMaxLength.Checked;
      Medienbib.PlaylistFillOptions.MinLength     := SE_MinLength.Value;
      Medienbib.PlaylistFillOptions.MaxLength     := SE_MaxLength.Value;

      DateiListe := TObjectList.Create(False);
      MedienBib.FillRandomList(DateiListe);
  finally
      tmpTagList.Free;
      Medienbib.PlaylistFillOptions.Wantedtags := Nil;
  end;

  if assigned(DateiListe) and (Dateiliste.Count <= 10) then
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

procedure TRandomPlaylistForm.cbTagCountSelectionChange(Sender: TObject);
begin
    RefillTagList;
end;

procedure TRandomPlaylistForm.cb_PreselectionChange(Sender: TObject);
var i, idx: Integer;
begin
    idx := cb_Preselection.ItemIndex;
    if (idx > length(TagSettings)-1) or (idx < 0) then exit;

    LastCheckedTags.Clear;
    for i := 1 to TagSettings[idx].Count - 1 do
        LastCheckedTags.Add(TagSettings[idx].CheckList[i]);

    cbTagMatchType.ItemIndex := TagSettings[idx].MatchType;
    RecheckLastCheckedTags;
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










DefaultGenreSettings[0].Add('Rock, Pop, ...');
DefaultGenreSettings[0].Add('Rock');
DefaultGenreSettings[0].Add('Rock & Roll');
DefaultGenreSettings[0].Add('Pop');
DefaultGenreSettings[0].Add('Other');
DefaultGenreSettings[0].Add('Instrumental Rock');
DefaultGenreSettings[0].Add('Instrumental Pop');
DefaultGenreSettings[0].Add('Pop/Funk');
DefaultGenreSettings[0].Add('Top 40');

// Hard Rock, Metal, etc
DefaultGenreSettings[1].Add('Hard Rock, Metal, ...');
DefaultGenreSettings[1].Add('Hard Rock');
DefaultGenreSettings[1].Add('Death Metal');
DefaultGenreSettings[1].Add('Gothic');
DefaultGenreSettings[1].Add('Gothic Rock');
DefaultGenreSettings[1].Add('Metal');

// Techno, House, etc.
DefaultGenreSettings[2].Add('Techno, House, ...');
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
DefaultGenreSettings[3].Add('RnB, Hip Hop, ...');
DefaultGenreSettings[3].Add('Freestyle');
DefaultGenreSettings[3].Add('Gangsta');
DefaultGenreSettings[3].Add('Hip-Hop');
DefaultGenreSettings[3].Add('R&B');
DefaultGenreSettings[3].Add('Rap');

// Klassisch
DefaultGenreSettings[4].Add('Classic');
DefaultGenreSettings[4].Add('Classical');
DefaultGenreSettings[4].Add('Sonata');
DefaultGenreSettings[4].Add('Symphony');
DefaultGenreSettings[4].Add('Chamber Music');

// Meditation
DefaultGenreSettings[5].Add('Meditation');
DefaultGenreSettings[5].Add('Easy Listening');
DefaultGenreSettings[5].Add('Meditative');
DefaultGenreSettings[5].Add('New Age');

DefaultGenreSettings[6].Add('<Custom 1>');
DefaultGenreSettings[6].Add('Other');
DefaultGenreSettings[7].Add('<Custom 2>');
DefaultGenreSettings[7].Add('Other');
DefaultGenreSettings[8].Add('<Custom 3>');
DefaultGenreSettings[8].Add('Other');
DefaultGenreSettings[9].Add('<Custom 4>');
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
