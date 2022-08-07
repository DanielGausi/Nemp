{

    Unit StreamVerwaltung
    Form FormStreamVerwaltung

    - Form for managing Webradio
      Managing Favourites
      Searching in the Shoutcast-Directory

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
unit StreamVerwaltung;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, VirtualTrees, StdCtrls, Contnrs,  IniFiles,
  shellApi, Menus,  Hilfsfunktionen, gnuGettext, Nemp_RessourceStrings,
  Nemp_ConstantsAndTypes, TreeHelper, ComCtrls, ShoutcastUtils, ExtCtrls,
  System.UITypes, ActiveX, vcl.themes;

type


  TFormStreamVerwaltung = class(TForm)
    VST_Favorites: TVirtualStringTree;
    OpenDialog1: TOpenDialog;
    SaveDialogFavorites: TSaveDialog;
    PM_Favorites: TPopupMenu;
    PM_Fav_NewStation: TMenuItem;
    PM_Fav_AddToPlaylist: TMenuItem;
    PM_Fav_Edit: TMenuItem;
    PM_Fav_Delete: TMenuItem;
    N2: TMenuItem;
    PM_Fav_Export: TMenuItem;
    PM_Fav_Import: TMenuItem;
    MainMenu_StreamSelection: TMainMenu;
    MM_Favorites: TMenuItem;
    MM_Fav_NewStatio: TMenuItem;
    MM_Fav_AddToPlaylist: TMenuItem;
    MM_Fav_Edit: TMenuItem;
    MM_Fav_Delete: TMenuItem;
    N1: TMenuItem;
    MM_Fav_Export: TMenuItem;
    MM_Fav_Import: TMenuItem;
    Label1: TLabel;
    pnlMain: TPanel;
    pnlButtons: TPanel;
    Btn_Icecast: TButton;
    Btn_Ok: TButton;
    BtnNewStation: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Btn_OkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Btn_IcecastClick(Sender: TObject);

    procedure VST_ShoutcastQueryColumnDblClick(Sender: TBaseVirtualTree;
      Column: TColumnIndex; Shift: TShiftState);
    procedure Btn_NewClick(Sender: TObject);
    procedure Btn_EditClick(Sender: TObject);
    procedure Btn_DeleteSelectedClick(Sender: TObject);
    procedure VST_FavoritesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PM_Fav_NewStationClick(Sender: TObject);
    procedure PM_Fav_EditClick(Sender: TObject);
    procedure PM_Fav_DeleteClick(Sender: TObject);
    procedure PM_Fav_ExportClick(Sender: TObject);
    procedure PM_Fav_ImportClick(Sender: TObject);
    procedure PM_Fav_AddToPlaylistClick(Sender: TObject);
    procedure VST_FavoritesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    // procedure cbSortModeChange(Sender: TObject);
    // procedure BtnSetCustomSortClick(Sender: TObject);
    procedure SaveDialogFavoritesTypeChange(Sender: TObject);
    procedure VST_FavoritesHeaderClick(Sender: TVTHeader;
      HitInfo: TVTHeaderHitInfo);
    procedure VST_FavoritesDragAllowed(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure VST_FavoritesDragOver(Sender: TBaseVirtualTree; Source: TObject;
      Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode;
      var Effect: Integer; var Accept: Boolean);
    procedure VST_FavoritesDragDrop(Sender: TBaseVirtualTree; Source: TObject;
      DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState;
      Pt: TPoint; var Effect: Integer; Mode: TDropMode);
    procedure VST_FavoritesPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
  private
    { Private-Deklarationen }
    // StationList: TObjectlist;
    // FavoriteList: TObjectlist;

    procedure FillRadioStationTree(selIdx: Integer);

  protected
      Procedure ShoutcastQueryMessage(Var aMsg: TMessage); message WM_Shoutcast;
  public
    { Public-Deklarationen }

  end;



var
  FormStreamVerwaltung: TFormStreamVerwaltung;

implementation

uses NempMainUnit, NewStation, LibraryOrganizer.Webradio;

{$R *.dfm}


procedure TFormStreamVerwaltung.FormCreate(Sender: TObject);
begin
  BackupComboboxes(self);
  TranslateComponent (self);
  RestoreComboboxes(self);
  VST_Favorites.NodeDataSize := SizeOf(TStation);
  FillRadioStationTree(0);
end;



Procedure TFormStreamVerwaltung.ShoutcastQueryMessage(Var aMsg: TMessage);
var FS: TFileStream;
    filename, sl: string;
    s: AnsiString;
begin
    Case aMsg.WParam of

        ST_PlaylistDownloadComplete : begin
                                  s := PAnsiChar(aMsg.LParam);
                                  if s <> '' then
                                  begin
                                      filename := GetProperFilenameForPlaylist(s);
                                      try
                                          FS := TFileStream.Create(filename, fmCreate or fmOpenWrite);
                                          try
                                              FS.Write(s[1], length(s));
                                          finally
                                              FS.Free;
                                          end;
                                          NempPlaylist.LoadFromFile(filename);
                                          DeleteFile(PChar(filename));
                                      except
                                          // saving failed. Nothing to do.
                                      end;
                                  end;
                                  //ProgressBar1.Position := Progressbar1.Max;
                                  //StatusBar1.Panels[0].Text := Shoutcast_DownloadComplete;
                                  //HideTimer.Enabled := True;
                               end;
        ST_PlaylistStreamLink: begin
                                  sl := PChar(aMsg.LParam);
                                  NempPlaylist.AddFileToPlaylist(sl);
                               end;
        ST_PlaylistDownloadFailed   : begin
                                  MessageDlg(Shoutcast_Error_DownloadFailed, mtWarning, [mbOK], 0);
                                  //StatusBar1.Panels[0].Text := '';
                                  //ProgressBar1.Visible := False;
                               end;
    end;

end;



procedure TFormStreamVerwaltung.VST_FavoritesDragAllowed(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  var Allowed: Boolean);
begin
  Allowed := True;
end;

procedure TFormStreamVerwaltung.VST_FavoritesDragDrop(Sender: TBaseVirtualTree;
  Source: TObject; DataObject: IDataObject; Formats: TFormatArray;
  Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
var
  aNode, focusNode: PVirtualNode;
  stn: TStation;
begin
  focusNode := VST_Favorites.FocusedNode;
  case Mode of
    dmNowhere: VST_Favorites.MoveTo(focusNode, VST_Favorites.RootNode, amInsertAfter, False);
    dmAbove: VST_Favorites.MoveTo(focusNode, VST_Favorites.DropTargetNode, amInsertBefore, False);
    dmOnNode,
    dmBelow: VST_Favorites.MoveTo(focusNode, VST_Favorites.DropTargetNode, amInsertAfter, False);
  end;
  VST_Favorites.Header.SortColumn := -1;
  VST_Favorites.Invalidate;

  // adjust the actual data list
  Medienbib.RadioStationList.OwnsObjects := False;
  aNode := VST_Favorites.GetFirst;
  while assigned(aNode) do begin
    stn := VST_Favorites.GetNodeData<TStation>(aNode);
    Medienbib.RadioStationList[aNode.Index] := stn;
    aNode := VST_Favorites.GetNextSibling(aNode);
  end;
  Medienbib.RadioStationList.OwnsObjects := True;
  MedienBib.RefreshWebRadioCategory;
  Medienbib.Changed := True;
end;

procedure TFormStreamVerwaltung.VST_FavoritesDragOver(Sender: TBaseVirtualTree;
  Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint;
  Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
begin
  Accept := Source = VST_Favorites;
end;


procedure TFormStreamVerwaltung.FillRadioStationTree(selIdx: Integer);
var
  aNode: pVirtualNode;
  i: Integer;
begin
  // VST_Favorites.BeginUpdate;
  VST_Favorites.Clear;
  for i := 0 to Medienbib.RadioStationList.Count - 1 do
    VST_Favorites.AddChild(Nil, Medienbib.RadioStationList[i]);
  //VST_Favorites.EndUpdate;

  aNode := VST_Favorites.GetFirst;
  for i := 0 to selIdx - 1 do
    aNode := VST_Favorites.GetNext(aNode);

  VST_Favorites.FocusedNode := aNode;
  VST_Favorites.Selected[aNode] := True;
end;

procedure TFormStreamVerwaltung.Btn_OkClick(Sender: TObject);
begin
    Close;
end;

(*procedure TFormStreamVerwaltung.cbSortModeChange(Sender: TObject);
begin
    case cbSortMode.ItemIndex of
      0: Medienbib.RadioStationList.Sort(Sort_Name_Asc);
      1: Medienbib.RadioStationList.Sort(Sort_MediaType_Asc);
      2: Medienbib.RadioStationList.Sort(Sort_Genre_Asc);
      3: Medienbib.RadioStationList.Sort(Sort_URL_Asc);
      4: Medienbib.RadioStationList.Sort(Sort_Custom);
    end;

    FillRadioStationTree(0);
    MedienBib.RefreshWebRadioCategory;
    Medienbib.Changed := True;
    // udSortFavorites.Enabled := cbSortMode.ItemIndex = 5;
end;*)

procedure TFormStreamVerwaltung.Btn_IcecastClick(Sender: TObject);
begin
    ShellExecute(Handle, 'open', 'https://www.icecast.org', nil, nil, SW_SHOW);
end;


procedure TFormStreamVerwaltung.FormShow(Sender: TObject);
begin
  //udSortFavorites.Enabled := cbSortMode.ItemIndex = 5;
end;


procedure TFormStreamVerwaltung.VST_ShoutcastQueryColumnDblClick(
  Sender: TBaseVirtualTree; Column: TColumnIndex; Shift: TShiftState);
var
  Node: PVirtualNode;
begin
  Node := Sender.FocusedNode;
  if not Assigned(Node) then
    Exit;

  Sender.GetNodeData<TStation>(Node).TuneIn(NempPlaylist.BassHandlePlaylist);
end;

procedure TFormStreamVerwaltung.VST_FavoritesHeaderClick(Sender: TVTHeader;
  HitInfo: TVTHeaderHitInfo);
begin
  if HitInfo.Button = mbLeft then
  begin
    // cbSortMode.ItemIndex := HitInfo.Column;
    VST_Favorites.Header.SortColumn := HitInfo.Column;

    if VST_Favorites.Header.SortDirection = sdAscending then begin
      VST_Favorites.Header.SortDirection := sdDescending;
      case HitInfo.Column of
        0: Medienbib.RadioStationList.Sort(Sort_Name_Desc);
        1: Medienbib.RadioStationList.Sort(Sort_MediaType_Desc);
        2: Medienbib.RadioStationList.Sort(Sort_Genre_Desc);
        3: Medienbib.RadioStationList.Sort(Sort_URL_Desc);
      end;
    end else
    begin
      VST_Favorites.Header.SortDirection := sdAscending;
      case HitInfo.Column of
        0: Medienbib.RadioStationList.Sort(Sort_Name_Asc);
        1: Medienbib.RadioStationList.Sort(Sort_MediaType_Asc);
        2: Medienbib.RadioStationList.Sort(Sort_Genre_Asc);
        3: Medienbib.RadioStationList.Sort(Sort_URL_Asc);
      end;
    end;
    FillRadioStationTree(0);
    MedienBib.RefreshWebRadioCategory;
    Medienbib.Changed := True;
  end;
end;


(*procedure TFormStreamVerwaltung.BtnSetCustomSortClick(Sender: TObject);
var i: Integer;
begin
  for i := 0 to Medienbib.RadioStationList.Count - 1 do
    TStation(Medienbib.RadioStationList[i]).SortIndex := i;
  cbSortMode.ItemIndex := 4;
end;*)


procedure TFormStreamVerwaltung.Btn_NewClick(Sender: TObject);
var NewStation: TStation;
    currentmaxIdx: Integer;
begin
    if Not Assigned(NewStationForm) then
        Application.CreateForm(TNewStationForm, NewStationForm);
    NewStationForm.Edt_Name.Text     := '';
    NewStationForm.Edt_URL.Text      := '';
    NewStationForm.CB_Mediatype.Text := 'mp3';
    NewStationForm.CB_Bitrate.Text   := '128';
    NewStationForm.Edt_Genre.Text    := '';
    if NewStationForm.ShowModal = mrOK then
    begin
        NewStation := TStation.Create(Handle);
        NewStation.Name      := NewStationForm.Edt_Name.Text;
        NewStation.URL       := NewStationForm.Edt_URL.Text;
        NewStation.MediaType := NewStationForm.CB_Mediatype.Text;
        NewStation.Bitrate   := StrToIntDef(NewStationForm.CB_Bitrate.Text, 128);
        NewStation.Genre     := NewStationForm.Edt_Genre.Text;

        currentmaxIdx := MedienBib.AddRadioStation(newStation);
        newStation.SortIndex := currentmaxIdx;
        VST_Favorites.AddChild(Nil, NewStation);
        MedienBib.RefreshWebRadioCategory;
        Medienbib.Changed := True;
    end;
end;

procedure TFormStreamVerwaltung.Btn_EditClick(Sender: TObject);
var aNode: PVirtualNode;
    Station: TStation;
begin
    if Not Assigned(NewStationForm) then
        Application.CreateForm(TNewStationForm, NewStationForm);

    aNode := VST_Favorites.FocusedNode;
    if assigned(aNode) then
    begin
        Station := VST_Favorites.GetNodeData<TStation>(aNode);

        NewStationForm.Edt_Name.Text     := Station.Name       ;
        NewStationForm.Edt_URL.Text      := Station.URL        ;
        NewStationForm.CB_Mediatype.Text := Station.MediaType  ;
        NewStationForm.CB_Bitrate.Text   := IntToStr(Station.Bitrate);
        NewStationForm.Edt_Genre.Text    := Station.Genre      ;
        if NewStationForm.ShowModal = mrOK then
        begin
            Station.Name      := NewStationForm.Edt_Name.Text;
            Station.URL       := NewStationForm.Edt_URL.Text;
            Station.MediaType := NewStationForm.CB_Mediatype.Text;
            Station.Bitrate   := StrToIntDef(NewStationForm.CB_Bitrate.Text, 128);
            Station.Genre     := NewStationForm.Edt_Genre.Text;
            MedienBib.RefreshWebRadioCategory;
            MedienBib.Changed := True;
        end;
    end;
end;


procedure TFormStreamVerwaltung.Btn_DeleteSelectedClick(Sender: TObject);
var i:integer;
    SelectedStations: TNodeArray;
    NewSelectNode: PVirtualNode;
begin
    SelectedStations := VST_Favorites.GetSortedSelection(False);
    if length(SelectedStations) = 0 then exit;

    MedienBib.Changed := True;
    VST_Favorites.BeginUpdate;

    NewSelectNode := VST_Favorites.GetNextSibling(SelectedStations[length(SelectedStations)-1]);
    if not Assigned(NewSelectNode) then
      NewSelectNode := VST_Favorites.GetPreviousSibling(SelectedStations[0]);

    for i := length(SelectedStations)-1 downto 0 do begin
      MedienBib.DeleteWebRadioStation(VST_Favorites.GetNodeData<TStation>(SelectedStations[i]));
      VST_Favorites.DeleteNode(SelectedStations[i]);
    end;
    MedienBib.RefreshWebRadioCategory;

    if assigned(NewSelectNode) then begin
      VST_Favorites.Selected[NewSelectNode] := True;
      VST_Favorites.FocusedNode := NewSelectNode;
    end;

    VST_Favorites.EndUpdate;
    VST_Favorites.Invalidate;
end;

procedure TFormStreamVerwaltung.VST_FavoritesGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  Station: TStation;
begin
  Station := Sender.GetNodeData<TStation>(Node);
  Case column of
    0: CellText := Station.Name;
    1: CellText := Station.Format;
    2: CellText := Station.Genre;
    3: CellText := Station.URL;
  end;
end;

procedure TFormStreamVerwaltung.VST_FavoritesKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  aNode: PVirtualNode;
begin
  case Key of
      VK_RETURN: begin
            aNode := VST_Favorites.FocusedNode;
            if not Assigned(aNode) then
              Exit;
            VST_Favorites.GetNodeData<TStation>(aNode).TuneIn(NempPlaylist.BassHandlePlaylist);
      end;
  end;
end;

procedure TFormStreamVerwaltung.VST_FavoritesPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
  TargetCanvas.Font.Color := TStyleManager.ActiveStyle.GetSystemColor(clWindowText)
end;

procedure TFormStreamVerwaltung.PM_Fav_AddToPlaylistClick(Sender: TObject);
var
  aNode: PVirtualNode;
begin
    aNode := VST_Favorites.FocusedNode;
    if not Assigned(aNode) then
      Exit;
    VST_Favorites.GetNodeData<TStation>(aNode).TuneIn(NempPlaylist.BassHandlePlaylist);
end;

procedure TFormStreamVerwaltung.PM_Fav_NewStationClick(Sender: TObject);
begin
    Btn_NewClick(Nil);
end;

procedure TFormStreamVerwaltung.PM_Fav_EditClick(Sender: TObject);
begin
    Btn_EditClick(Nil);
end;

procedure TFormStreamVerwaltung.PM_Fav_DeleteClick(Sender: TObject);
begin
    Btn_DeleteSelectedClick(Nil);
end;


procedure TFormStreamVerwaltung.SaveDialogFavoritesTypeChange(Sender: TObject);
begin
    case SaveDialogFavorites.FilterIndex of
        1: SaveDialogFavorites.DefaultExt := 'pls';
        2: SaveDialogFavorites.DefaultExt := 'nwl';
    end;
end;

procedure TFormStreamVerwaltung.PM_Fav_ExportClick(Sender: TObject);
begin
    If SaveDialogFavorites.Execute then
        MedienBib.ExportFavorites(SaveDialogFavorites.FileName)
end;

procedure TFormStreamVerwaltung.PM_Fav_ImportClick(Sender: TObject);
begin
  if OpenDialog1.Execute then begin
    MedienBib.ImportFavorites(OpenDialog1.FileName);
    FillRadioStationTree(0);
    MedienBib.RefreshWebRadioCategory;
  end;
end;


end.
