{

    Unit BibSearch
    Form TFormBibSearch

    Inputform for the extended search in the medialibrary

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
unit BibSearch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, CheckLst, ExtCtrls, ComCtrls,
  MedienBibliothekClass, Nemp_ConstantsAndTypes, Nemp_RessourceStrings,
  ID3GenreList, BibSearchClass, gnugettext, NempHelp;

type
  TFormBibSearch = class(TForm)
    Btn_ExtendedSearch: TButton;
    BtnCancel: TButton;
    Panel1: TPanel;
    GRPErweiterteSucheEdit: TGroupBox;
    LblConst_SearchArtist: TLabel;
    LblConst_SearchTitle: TLabel;
    LblConst_SearchAlbum: TLabel;
    LblConst_SearchComment: TLabel;
    LblConst_SearchPath: TLabel;
    LblConst_GeneralSearchHint: TLabel;
    LblConst_LyricSearchHint: TLabel;
    ArtistEDIT: TEdit;
    TitelEDIT: TEdit;
    AlbumEDIT: TEdit;
    KommentarEDIT: TEdit;
    PathEDIT: TEdit;
    GeneralEdit: TEdit;
    LyricEdit: TMemo;
    CBFehlerToleranz: TCheckBox;
    BtnClear: TButton;
    Panel2: TPanel;
    GrpBox_ExtendedSearchGenres: TGroupBox;
    cbGenres: TCheckListBox;
    cbIgnoreGenres: TCheckBox;
    cbIncludeUnkownGenres: TCheckBox;
    GrpBox_ExtendedSearchDate: TGroupBox;
    LblConst_SearchExtendedYear: TLabel;
    LblConst_SearchExtendedPeriod: TLabel;
    seJahr: TSpinEdit;
    cbIgnoreYear: TCheckBox;
    cbIncludeNA: TCheckBox;
    cbInclude0: TCheckBox;
    cb_ExtendedSearchPeriod: TComboBox;
    Panel3: TPanel;
    CB_SearchHistory: TComboBox;
    LblConst_SearchGenre: TLabel;
    GenreEdit: TEdit;
    procedure Btn_ExtendedSearchClick(Sender: TObject);
    procedure cbIgnoreGenresClick(Sender: TObject);
    procedure cbIgnoreYearClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CB_SearchHistoryChange(Sender: TObject);
    procedure BtnClearClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure FillSuchComboBox;
  public
    { Public-Deklarationen }
    procedure EnableControls(AllowSearch: Boolean);
  end;

var
  FormBibSearch: TFormBibSearch;

procedure StringAdd(var OldString: String; AddString: String);

implementation

{$R *.dfm}

uses NempMainUnit, Hilfsfunktionen;


// Helper for building the Strings in the history-ComboBox
procedure StringAdd(var OldString: String; AddString: String);
begin
    if (OldString <> '') AND (Addstring <> '') then
        OldString := OldString + ', ' + Addstring;
    if (OldString = '') AND (AddString <> '') then
        OldString := Addstring;
    if (OldString <> '') AND (AddString = '') then
        OldString := OldString;
    if (OldString = '') AND (AddString = '') then
        OldString := '';
end;


procedure TFormBibSearch.FormCreate(Sender: TObject);
begin
    BackUpComboBoxes(self);
    TranslateComponent (self);
    RestoreComboboxes(self);
    HelpContext := HELP_SearchMediaLibrary;

    cbGenres.Items.Clear;
    // Genres: StringList defined in MP3FileUtils
    cbGenres.Items := ID3Genres;
end;

procedure TFormBibSearch.FormShow(Sender: TObject);
begin
  FillSuchComboBox;
  BtnClear.Click;
end;

procedure TFormBibSearch.EnableControls(AllowSearch: Boolean);
begin
    cbIgnoreGenres.Enabled := AllowSearch;
    cbGenres.Enabled              := AllowSearch and (NOT cbIgnoreGenres.Checked);
    cbIncludeUnkownGenres.Enabled := AllowSearch and (NOT cbIgnoreGenres.Checked);

    cbIgnoreYear.Enabled := AllowSearch;
    seJahr.Enabled                  := AllowSearch and (NOT cbIgnoreYear.Checked);
    cbIncludeNA.Enabled             := AllowSearch and (NOT cbIncludeNA.Enabled );
    cbInclude0.Enabled              := AllowSearch and (NOT cbInclude0.Enabled  );
    cb_ExtendedSearchPeriod.Enabled := AllowSearch and (NOT cbIgnoreYear.Checked);
    LblConst_SearchExtendedYear.Enabled   := AllowSearch and (NOT cbIgnoreYear.Checked);
    LblConst_SearchExtendedPeriod.Enabled := AllowSearch and (NOT cbIgnoreYear.Checked);

    CB_SearchHistory           .Enabled := AllowSearch;
    LblConst_SearchArtist      .Enabled := AllowSearch;
    LblConst_SearchTitle       .Enabled := AllowSearch;
    LblConst_SearchAlbum       .Enabled := AllowSearch;
    LblConst_SearchComment     .Enabled := AllowSearch;
    LblConst_SearchPath        .Enabled := AllowSearch;
    LblConst_GeneralSearchHint .Enabled := AllowSearch;
    LblConst_LyricSearchHint   .Enabled := AllowSearch;
    ArtistEDIT                 .Enabled := AllowSearch;
    TitelEDIT                  .Enabled := AllowSearch;
    AlbumEDIT                  .Enabled := AllowSearch;
    KommentarEDIT              .Enabled := AllowSearch;
    GenreEdit                  .Enabled := AllowSearch;
    PathEDIT                   .Enabled := AllowSearch;
    GeneralEdit                .Enabled := AllowSearch;
    LyricEdit                  .Enabled := AllowSearch;
    CBFehlerToleranz           .Enabled := AllowSearch;
    BtnClear                   .Enabled := AllowSearch;

    Btn_ExtendedSearch         .Enabled := AllowSearch;
end;

procedure TFormBibSearch.cbIgnoreGenresClick(Sender: TObject);
begin
    cbGenres.Enabled := NOT cbIgnoreGenres.Checked;
    cbIncludeUnkownGenres.Enabled := NOT cbIgnoreGenres.Checked;
end;

procedure TFormBibSearch.cbIgnoreYearClick(Sender: TObject);
begin
    cb_ExtendedSearchPeriod.Enabled := NOT cbIgnoreYear.Checked;
    LblConst_SearchExtendedPeriod.Enabled := NOT cbIgnoreYear.Checked;
    LblConst_SearchExtendedYear.Enabled := NOT cbIgnoreYear.Checked;

    seJahr.Enabled := NOT cbIgnoreYear.Checked;
    cbIncludeNA.Enabled := NOT cbIgnoreYear.Checked; //NOT cbIncludeNA.Enabled;
    cbInclude0.Enabled := NOT cbIgnoreYear.Checked;  //NOT cbInclude0.Enabled;
end;

procedure TFormBibSearch.CB_SearchHistoryChange(Sender: TObject);
begin
      MedienBib.BibSearcher.ShowSearchResults(CB_SearchHistory.ItemIndex+1)
end;

procedure TFormBibSearch.FillSuchComboBox;
var i: integer;
begin
  CB_SearchHistory.Items.Clear;
  for i := 1 to 10 do
  begin
    if MedienBib.BibSearcher.SearchKeyWords[i].ComboBoxString <> '' then
      CB_SearchHistory.Items.Add(MedienBib.BibSearcher.SearchKeyWords[i].ComboBoxString);
  end;
  if CB_SearchHistory.Items.Count = 0 then
    CB_SearchHistory.Items.Add((MainForm_NoSearchHistory));

  CB_SearchHistory.ItemIndex := 0;
end;


procedure TFormBibSearch.BtnCancelClick(Sender: TObject);
begin
    Close;
end;

procedure TFormBibSearch.BtnClearClick(Sender: TObject);
begin
    GeneralEdit.Text    := '';
    ArtistEDIT.Text     := '';
    AlbumEDIT.Text      := '';
    TitelEDIT.Text      := '';
    PathEDIT.Text       := '';
    KommentarEDIT.Text  := '';
    GenreEdit.Text      := '';
    LyricEdit.Text      := '';
end;

procedure TFormBibSearch.Btn_ExtendedSearchClick(Sender: TObject);

    function EinItemGecheckt(CBox: TChecklistbox):boolean;
    var i:integer;
    begin
      result:=False;
      for i:=0 to CBox.Items.Count-1 do
        if CBox.Checked[i] then
        begin
          result:=True;
          break;
        end;
    end;

var i:integer;
    KeyWords: TSearchKeyWords;
    newComboBoxString: String;
begin
    if Medienbib.StatusBibUpdate >= 2 then exit;

    // Medienbib.BibSearcher.SearchOptions.SearchParam := (Sender as TButton).Tag;
    Medienbib.BibSearcher.SearchOptions.AllowErrors := CBFehlerToleranz.Checked;

    KeyWords.General   := Trim(GeneralEdit.Text);
    KeyWords.Artist    := Trim(ArtistEDIT.Text);
    KeyWords.Album     := Trim(AlbumEDIT.Text);
    KeyWords.Titel     := Trim(TitelEDIT.Text);
    KeyWords.Pfad      := Trim(PathEDIT.Text);
    KeyWords.Kommentar := Trim(KommentarEDIT.Text);
    KeyWords.Genre     := Trim(GenreEDIT.Text);
    KeyWords.Lyric     := Trim(LyricEdit.Text);

    newComboBoxString := '';
    StringAdd(newComboBoxString, KeyWords.General  );
    StringAdd(newComboBoxString, KeyWords.Artist   );
    StringAdd(newComboBoxString, KeyWords.Album    );
    StringAdd(newComboBoxString, KeyWords.Titel    );
    StringAdd(newComboBoxString, KeyWords.Pfad     );
    StringAdd(newComboBoxString, KeyWords.Kommentar);
    StringAdd(newComboBoxString, KeyWords.Genre    );
    StringAdd(newComboBoxString, KeyWords.Lyric    );

    ///case Medienbib.BibSearcher.SearchOptions.SearchParam of
    ///    0: ; // nothing. NewSearch
    ///    1: newComboBoxString := newComboBoxString + SearchForm_CBAddRefineSearch;  // Refined search
    ///    2: newComboBoxString := newComboBoxString + SearchForm_CBAddExtendSearch;  // Extended search
    ///end;

    if newComboBoxString = '' then
        newComboBoxString := (MainForm_NoSearchKeywords);
    KeyWords.ComboBoxString := newComboBoxString;

    Medienbib.BibSearcher.InitNewSearch(KeyWords);

    FillSuchComboBox;

    Medienbib.BibSearcher.SearchOptions.SkipGenreCheck  := cbIgnoreGenres.Checked
                                      OR (NOT EinItemGecheckt(cbGenres));
    Medienbib.BibSearcher.SearchOptions.IncludeNAGenres := cbIncludeUnkownGenres.Checked;
    Medienbib.BibSearcher.SearchOptions.GenreStrings := cbGenres.Items;
    Setlength(Medienbib.BibSearcher.SearchOptions.GenreChecked,
              Medienbib.BibSearcher.SearchOptions.GenreStrings.Count);
    for i := 0 to cbGenres.Items.Count - 1 do
        Medienbib.BibSearcher.SearchOptions.GenreChecked[i] := cbGenres.Checked[i];
    Medienbib.BibSearcher.SearchOptions.SkipYearCheck  := cbIgnoreYear.Checked;
    Medienbib.BibSearcher.SearchOptions.WhichYearCheck := cb_ExtendedSearchPeriod.ItemIndex;
    Medienbib.BibSearcher.SearchOptions.MinMaxYear     := seJahr.Value;
    Medienbib.BibSearcher.SearchOptions.IncludeNAYear  := cbIncludeNA.Checked;
    Medienbib.BibSearcher.SearchOptions.Include0Year   := cbInclude0.Checked;

    MedienBib.CompleteSearch(Keywords);
end;

end.
