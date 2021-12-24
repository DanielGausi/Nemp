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
  System.UITypes;

type

  TStationTreeData = record
    fStation: TStation;
  end;
  PStationTreeData = ^TStationTreeData;


  TFormStreamVerwaltung = class(TForm)
    Btn_Ok: TButton;
    Btn_Shoutcast: TButton;
    Btn_Icecast: TButton;
    PC_Streams: TPageControl;
    Tab_Favourites: TTabSheet;
    Tab_Shoutcast: TTabSheet;
    VST_ShoutcastQuery: TVirtualStringTree;
    VST_Favorites: TVirtualStringTree;
    LblConst_Limit: TLabel;
    GrpBox_GeneralSearch: TGroupBox;
    GrpBox_SearchGenre: TGroupBox;
    CB_SearchGenre: TComboBox;
    xxx_ProgressBar1: TProgressBar;
    BtnExport: TButton;
    BtnImport: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialogFavorites: TSaveDialog;
    PM_Shoutcast: TPopupMenu;
    PM_Favorites: TPopupMenu;
    PM_SC_AddToPlaylist: TMenuItem;
    PM_SC_AddToFavorites: TMenuItem;
    PM_Fav_NewStation: TMenuItem;
    PM_Fav_AddToPlaylist: TMenuItem;
    PM_Fav_Edit: TMenuItem;
    PM_Fav_Delete: TMenuItem;
    N2: TMenuItem;
    PM_Fav_Export: TMenuItem;
    PM_Fav_Import: TMenuItem;
    Edt_Search: TEdit;
    Btn_AddSelected: TButton;
    Btn_Search: TButton;
    Btn_SearchGenre: TButton;
    MainMenu_StreamSelection: TMainMenu;
    MM_Favorites: TMenuItem;
    MM_Fav_NewStatio: TMenuItem;
    MM_Fav_AddToPlaylist: TMenuItem;
    MM_Fav_Edit: TMenuItem;
    MM_Fav_Delete: TMenuItem;
    N1: TMenuItem;
    MM_Fav_Export: TMenuItem;
    MM_Fav_Import: TMenuItem;
    MM_Shoutcast: TMenuItem;
    MM_SC_AddToPlaylist: TMenuItem;
    MM_SC_AddToFavorites: TMenuItem;
    XXXX_CB_ParseStreamURL: TCheckBox;
    udSortFavorites: TUpDown;
    Label1: TLabel;
    cbSortMode: TComboBox;
    BtnSetCustomSort: TButton;
    BtnNewStation: TButton;
    lblShoutcastAPIchanged: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Btn_OkClick(Sender: TObject);
    procedure Btn_ShoutcastClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Btn_IcecastClick(Sender: TObject);
    //procedure Btn_SearchClick(Sender: TObject);
    //procedure Edt_SearchKeyPress(Sender: TObject; var Key: Char);
    procedure VST_ShoutcastQueryColumnDblClick(Sender: TBaseVirtualTree;
      Column: TColumnIndex; Shift: TShiftState);
    //procedure VST_ShoutcastQueryHeaderClick(Sender: TVTHeader; Column: TColumnIndex;
    //        Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    //procedure HideTimerTimer(Sender: TObject);
    //procedure Btn_AddSelectedClick(Sender: TObject);
    //procedure Btn_SearchGenreClick(Sender: TObject);
    procedure Btn_NewClick(Sender: TObject);
    procedure Btn_EditClick(Sender: TObject);
    procedure Btn_DeleteSelectedClick(Sender: TObject);
    //procedure VST_ShoutcastQueryKeyDown(Sender: TObject; var Key: Word;
    //  Shift: TShiftState);
    procedure VST_FavoritesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PM_SC_AddToPlaylistClick(Sender: TObject);
    // procedure PM_SC_AddToFavoritesClick(Sender: TObject);
    procedure PM_Fav_NewStationClick(Sender: TObject);
    procedure PM_Fav_EditClick(Sender: TObject);
    procedure PM_Fav_DeleteClick(Sender: TObject);
    procedure PM_Fav_ExportClick(Sender: TObject);
    procedure PM_Fav_ImportClick(Sender: TObject);
    procedure PM_Fav_AddToPlaylistClick(Sender: TObject);
    //procedure VST_ShoutcastQueryGetText(Sender: TBaseVirtualTree;
    //  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
    //  var CellText: string);
    procedure VST_FavoritesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    //procedure __VST_FavoritesHeaderClick(Sender: TVTHeader; Column: TColumnIndex;
    //        Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure udSortFavoritesClick(Sender: TObject; Button: TUDBtnType);
    procedure VST_FavoritesChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure cbSortModeChange(Sender: TObject);
    procedure BtnSetCustomSortClick(Sender: TObject);
    procedure SaveDialogFavoritesTypeChange(Sender: TObject);
    procedure VST_FavoritesHeaderClick(Sender: TVTHeader;
      HitInfo: TVTHeaderHitInfo);
  private
    { Private-Deklarationen }
    StationList: TObjectlist;
    FavoriteList: TObjectlist;

  protected
      Procedure ShoutcastQueryMessage(Var aMsg: TMessage); message WM_Shoutcast;
  public
    { Public-Deklarationen }
    /// ShoutcastQuery: TShoutcastQuery;
  end;

//  function min(a,b:integer):integer;


var
  FormStreamVerwaltung: TFormStreamVerwaltung;
        {
Const 

      DefaultSender : Array [1..23] of TRadioRecord =
      (
            (Beschreibung: 'Morituri te salutant ~ Das Radio mit der schwarzen Seele'; URL: 'http://p15200355.pureserver.info:9000'; Verbindung: 'Modem (24)'),
            (Beschreibung: 'Morituri te salutant ~ Das Radio mit der schwarzen Seele'; URL: 'http://p15200355.pureserver.info:8000'; Verbindung: 'DSL (128)'),
            (Beschreibung: 'Gaming-FM'; URL: 'http://www.gamingfm.com:7500/'; Verbindung: 'DSL (128)'),
            (Beschreibung: 'ETN.FM Trance Channel'; URL: 'http://world1.etn.fm:80/stream/1027'; Verbindung: 'DSL (192)'),
            (Beschreibung: 'ETN.FM Progressive Channel'; URL: 'http://SFO.ETN.FM:80/stream/1077'; Verbindung: 'DSL (192)'),
            (Beschreibung: 'ETN.FM Progressive Channel'; URL: 'http://toronto.etn.fm:8220/'; Verbindung: 'Modem (32)'),
            (Beschreibung: 'ETN3'; URL: 'http://toronto.etn.fm:8400'; Verbindung: 'DSL (AAC+, 128)'),
            (Beschreibung: 'ETN3'; URL: 'http://toronto.etn.fm:8410'; Verbindung: 'Modem (AAC+, 32)'),
            (Beschreibung: 'Lemon Radio'; URL: 'http://85.12.11.155:8045/'; Verbindung: 'ISDN (AAC+)'),
            (Beschreibung: 'SnakeNet'; URL: 'http://www.snakenetmetalradio.com/Snakenet-96k.asp'; Verbindung: 'DSL (128)'),
            (Beschreibung: 'Digitally Imported - European Trance, Techno, Hi-NRG'; URL: 'http://64.236.34.196:80/stream/1003'; Verbindung: 'DSL (96)'),
            (Beschreibung: 'Digitally Imported - Vocal Trance'; URL: 'http://64.236.34.196:80/stream/1065'; Verbindung: 'DSL (96)'),
            (Beschreibung: 'Digitally Imported - Chillout'; URL: 'http://64.236.34.97:80/stream/1035'; Verbindung: 'DSL (96)'),
            (Beschreibung: 'Digitally Imported - HardDance'; URL: 'http://64.236.34.196:80/stream/1025'; Verbindung: 'DSL (96)'),
            (Beschreibung: 'Digitally Imported - House'; URL: 'http://64.236.34.97:80/stream/1007'; Verbindung: 'DSL (96)'),
            (Beschreibung: 'Digitally Imported - Gabber'; URL: 'http://205.188.215.226:8006'; Verbindung: 'DSL (96)'),
            (Beschreibung: 'SKY.FM - Best of the 80s'; URL: 'http://64.236.34.196:80/stream/1013'; Verbindung: 'DSL (128)'),
            (Beschreibung: 'SKY.FM & SALSASTREAM.com'; URL: 'http://205.188.215.231:8010'; Verbindung: 'DSL (96)'),
            (Beschreibung: 'FM4 (inoffzieller Stream)'; URL: 'http://listen.fm4.amd.co.at:31337/fm4-lq.ogg'; Verbindung: 'Modem (32)'),
            (Beschreibung: 'FM4 (inoffzieller Stream)'; URL: 'http://listen.fm4.amd.co.at:31337/fm4-mq.ogg'; Verbindung: 'ISDN (64)'),
            (Beschreibung: 'FM4 (inoffzieller Stream)'; URL: 'http://listen.fm4.amd.co.at:31337/fm4-hq.ogg'; Verbindung: 'DSL (160)'),
            (Beschreibung: 'Radio R1Live (Darkwave & Gothic)'; URL: 'http://www.r1live.de:8000'; Verbindung: 'DSL (128)'),
            (Beschreibung: 'The Edge Rocks'; URL: 'http://85.17.17.12:8040/'; Verbindung: 'DSL (128)')

      );
              }
implementation

uses NempMainUnit, NewStation;

{$R *.dfm}


function AddVSTStation(AVST: TCustomVirtualStringTree; aNode: PVirtualNode; aStation: TStation): PVirtualNode;
var Data: PStationTreeData;
begin
  Result:= AVST.AddChild(aNode); // meistens wohl Nil
  AVST.ValidateNode(Result,false);
  Data:=AVST.GetNodeData(Result);
  Data^.fStation := aStation;
end;


procedure TFormStreamVerwaltung.FormCreate(Sender: TObject);
var i: integer;
  newStation: TStation;
begin
  BackupComboboxes(self);
  TranslateComponent (self);
  RestoreComboboxes(self);
  //CB_SearchGenre.ItemIndex := 0;

  StationList := TObjectlist.Create;
  FavoriteList := TObjectlist.Create;

  PC_Streams.ActivePageIndex := 1;
  
  VST_ShoutcastQuery.NodeDataSize := SizeOf(PStationTreeData);
  VST_Favorites.NodeDataSize := SizeOf(PStationTreeData);

  ///ShoutcastQuery := TShoutcastQuery.Create(Handle);
  //Progressbar1.Parent := Statusbar1;
  //Progressbar1.Left := 210;
  //Progressbar1.Top := 2;
  //Progressbar1.Height := 15;

  Tab_Shoutcast.TabVisible := False;
  Tab_Favourites.TabVisible := False;


  for i := 0 to MedienBib.RadioStationList.Count - 1 do
  begin
      newStation := TStation.Create(Handle);
      newStation.Assign( TStation(MedienBib.RadioStationList[i]));
      FavoriteList.Add(newStation);
  end;
  for i := 0 to FavoriteList.Count - 1 do
      AddVSTStation(VST_Favorites, NIL, (FavoriteList[i] as TStation));
end;



Procedure TFormStreamVerwaltung.ShoutcastQueryMessage(Var aMsg: TMessage);
var FS: TFileStream;
    filename, sl: string;
    s: AnsiString;
begin
    Case aMsg.WParam of
        SCQ_BeginDownload    : begin
                                  //ProgressBar1.Max := aMsg.lParam;
                                  //Btn_Search.Caption := Shoutcast_Cancel;
                                  //Btn_SearchGenre.Caption := Shoutcast_Cancel;
                               end;
        SCQ_ProgressDownload : begin
                                  //StatusBar1.Panels[0].Text := Shoutcast_Downloading;
                                  //ProgressBar1.Position := aMsg.lParam;
                               end;
        SCQ_FinishedDownload : begin
                                  //StatusBar1.Panels[0].Text := Shoutcast_ParsingXMLData;
                               end;
        SCQ_AbortedDownload   : begin
                                  //ProgressBar1.Visible := False;
                                  //StatusBar1.Panels[0].Text := '';
                                  //Btn_Search.Caption := Shoutcast_OK;
                                  //Btn_SearchGenre.Caption := Shoutcast_OK;
                               end;
        SCQ_ConnectionFailed  : begin
                                  MessageDlg(Shoutcast_Error_ConnectionFailed, mtWarning, [mbOK], 0);
                                  //ProgressBar1.Visible := False;
                                  //StatusBar1.Panels[0].Text := '';
                                  ////Lbl_Status.Visible := False;
                                  //Btn_Search.Caption := Shoutcast_OK;
                                  //Btn_SearchGenre.Caption := Shoutcast_OK;
                               end;
        SCQ_ParsedList         : begin
                                  //StationList.Clear;
                                  //aList := TObjectList(aMsg.LParam);
                                  //for i := 0 to aList.Count - 1 do
                                  //    StationList.Add(aList.Items[i]);

                                  //VST_ShoutcastQuery.Clear;
                                  //for i := 0 to StationList.Count - 1 do
                                  //    AddVSTStation(VST_ShoutcastQuery, NIL, (StationList[i] as TStation));

                                  //ProgressBar1.Visible := False;
                                  //Lbl_Status.Visible := False;
                                  //StatusBar1.Panels[0].Text := '';
                                  //Btn_Search.Caption := Shoutcast_OK;
                                  //Btn_SearchGenre.Caption := Shoutcast_OK;
                               end;

        ST_PlaylistDownloadConnecting: begin
                                  ////Lbl_Status.Visible := True;
                                  //ProgressBar1.Visible := True;
                                  //ProgressBar1.Position := 0;
                                  //StatusBar1.Panels[0].Text := Shoutcast_Connecting;
                               end;
        //ST_PlaylistDownloadBegins: begin
                                  ////Lbl_Status.Visible := True;
                                  //ProgressBar1.Visible := True;
                                  //ProgressBar1.Position := Progressbar1.Max Div 2;
                                  //StatusBar1.Panels[0].Text := Shoutcast_DownloadingPlaylist;
        //                       end;
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



procedure TFormStreamVerwaltung.VST_FavoritesChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
    if VST_Favorites.Selected[Node] then
    begin
        udSortFavorites.Min := 0;
        udSortFavorites.Max := 2* FavoriteList.Count;
        udSortFavorites.Position := FavoriteList.Count;
    end;
end;


procedure TFormStreamVerwaltung.udSortFavoritesClick(Sender: TObject;
  Button: TUDBtnType);
var currentIDX: Integer;
    aNode: PVirtualNode;
    i: Integer;
begin
    if assigned(VST_Favorites.FocusedNode) then
    begin
        currentIDX :=  VST_Favorites.FocusedNode.Index;
        case Button of
            btNext: begin
                if currentIdx > 0 then
                begin
                    FavoriteList.Exchange(currentIdx, currentIdx-1);
                    Medienbib.RadioStationList.Exchange(currentIdx, currentIdx-1);
                    dec(currentIdx);
                end;
            end;

            btPrev: begin
                if currentIdx < FavoriteList.Count - 1 then
                begin
                    FavoriteList.Exchange(currentIdx, currentIdx+1);
                    Medienbib.RadioStationList.Exchange(currentIdx, currentIdx+1);
                    inc(currentIdx);
                end;
            end;
        end;

        VST_Favorites.OnChange := Nil;
        VST_Favorites.Clear;
        for i := 0 to FavoriteList.Count - 1 do
            AddVSTStation(VST_Favorites, NIL, (FavoriteList[i] as TStation));
        aNode := VST_Favorites.GetFirst;
        for i := 0 to currentIdx - 1 do
            aNode := VST_Favorites.GetNext(aNode);
        VST_Favorites.FocusedNode := aNode;
        VST_Favorites.Selected[aNode] := True;
        VST_Favorites.OnChange := VST_FavoritesChange;


        Medienbib.Changed := True;
        //if MedienBib.CurrentArtist = BROWSE_RADIOSTATIONS then
        begin
            // Anzeige im Tree der MainForm neu füllen
            // Medienbib.GetAlbenList(MedienBib.CurrentArtist);
            // FillStringTree(Medienbib.Alben, Nemp_MainForm.AlbenVST);
        end;
    end;
end;

{
procedure TFormStreamVerwaltung.HideTimerTimer(Sender: TObject);
begin
    //Lbl_Status.Visible := False;
    //StatusBar1.Panels[0].Text := '';
    //ProgressBar1 .Visible := False;
    //HideTimer.Enabled := False;
end;
}

procedure TFormStreamVerwaltung.FormDestroy(Sender: TObject);
begin
    StationList.Free;
    FavoriteList.Free;
    ///ShoutcastQuery.Free;
end;

procedure TFormStreamVerwaltung.Btn_OkClick(Sender: TObject);
begin
    Close;
end;

procedure TFormStreamVerwaltung.Btn_ShoutcastClick(Sender: TObject);
begin
    ShellExecute(Handle, 'open', 'http://www.shoutcast.com', nil, nil, SW_SHOW);
end;

procedure TFormStreamVerwaltung.cbSortModeChange(Sender: TObject);
var i: Integer;
begin
    case cbSortMode.ItemIndex of
        0: begin
          FavoriteList.Sort(Sort_Name_Asc);
          Medienbib.RadioStationList.Sort(Sort_Name_Asc);
        end;
        1: begin
          FavoriteList.Sort(Sort_MediaType_Asc);
          Medienbib.RadioStationList.Sort(Sort_MediaType_Asc);
        end;
        2: begin
          FavoriteList.Sort(Sort_Genre_Asc);
          Medienbib.RadioStationList.Sort(Sort_Genre_Asc);
        end;
        3: begin
          FavoriteList.Sort(Sort_URL_Asc);
          Medienbib.RadioStationList.Sort(Sort_URL_Asc);
        end;
        4: begin
          FavoriteList.Sort(Sort_Custom);
          Medienbib.RadioStationList.Sort(Sort_Custom);
        end;
    end;

    VST_Favorites.Clear;
    for i := 0 to FavoriteList.Count - 1 do
        AddVSTStation(VST_Favorites, NIL, (FavoriteList[i] as TStation));

    Medienbib.Changed := True;
    //if MedienBib.CurrentArtist = BROWSE_RADIOSTATIONS then
    begin
        // Anzeige im Tree der MainForm neu füllen
        //Medienbib.GetAlbenList(MedienBib.CurrentArtist);
        //FillStringTree(Medienbib.Alben, Nemp_MainForm.AlbenVST);
    end;

    udSortFavorites.Enabled := cbSortMode.ItemIndex = 4;
end;

procedure TFormStreamVerwaltung.Btn_IcecastClick(Sender: TObject);
begin
    ShellExecute(Handle, 'open', 'http://www.icecast.org', nil, nil, SW_SHOW);
end;


procedure TFormStreamVerwaltung.FormShow(Sender: TObject);
begin
    PC_Streams.ActivePageIndex := 0;
    udSortFavorites.Enabled := cbSortMode.ItemIndex = 5;
end;

(*procedure TFormStreamVerwaltung.Btn_SearchClick(Sender: TObject);
begin
  if ShoutcastQuery.Status = 0 then
  begin
      Btn_Search.Caption := Shoutcast_Cancel;
      Btn_SearchGenre.Caption := Shoutcast_Cancel;

      //Lbl_Status.Visible := True;
      ProgressBar1.Position := 0;
      ProgressBar1.Visible := True;
      StatusBar1.Panels[0].Text := Shoutcast_Connecting;

      ShoutcastQuery.DownloadStationList(Edt_Search.Text, QM_Search);
  end else
      ShoutcastQuery.CancelDownload := True;
end;


procedure TFormStreamVerwaltung.Btn_SearchGenreClick(Sender: TObject);
var s: String;
begin
  if ShoutcastQuery.Status = 0 then
  begin
      Btn_Search.Caption := Shoutcast_Cancel;
      Btn_SearchGenre.Caption := Shoutcast_Cancel;

      //Lbl_Status.Visible := True;
      ProgressBar1.Position := 0;
      ProgressBar1.Visible := True;
      StatusBar1.Panels[0].Text := Shoutcast_Connecting;

      s := CB_SearchGenre.Text;

      if s = 'R&B' then s := 'R%26B';
      if s = 'Hip-Hop' then s := 'Hip%20Hop';

      ShoutcastQuery.DownloadStationList(s, QM_Genre);
  end else
  begin
      ShoutcastQuery.CancelDownload := True;
  end;
end;

procedure TFormStreamVerwaltung.Edt_SearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if ord(key) = VK_RETURN then
  begin
    key := #0;
    Btn_SearchClick(Nil);
  end;
end;       *)



procedure TFormStreamVerwaltung.VST_ShoutcastQueryColumnDblClick(
  Sender: TBaseVirtualTree; Column: TColumnIndex; Shift: TShiftState);
var Node: PVirtualNode;
    Data: PStationTreeData;
begin
  Node := Sender.FocusedNode;
  if not Assigned(Node) then
    Exit;

  Data := Sender.GetNodeData(Node);
  //Data^.fStation.TuneIn(Not CB_ParseStreamURL.Checked);
  Data^.fStation.TuneIn(NempPlaylist.BassHandlePlaylist);
end;

(*
procedure TFormStreamVerwaltung.VST_ShoutcastQueryGetText(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType; var CellText: string);
var Data: PStationTreeData;
begin
  Data := Sender.GetNodeData(Node);
  Case column of
    0: CellText := Data^.fStation.Name;
    1: CellText := Data^.fStation.CurrentTitle;
    2: CellText := Data^.fStation.Format;
    3: CellText := Data^.fStation.Genre;
    4: CellText := IntToStr(Data^.fStation.Count);
  end;
end;


procedure TFormStreamVerwaltung.VST_ShoutcastQueryHeaderClick(Sender: TVTHeader; Column: TColumnIndex;
            Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var i: Integer;
begin
    if Button = mbLeft then
    begin
        if VST_ShoutcastQuery.Header.SortDirection = sdAscending then
        begin
            VST_ShoutcastQuery.Header.SortDirection := sdDescending;
            case Column of
               0: StationList.Sort(Sort_Name_Desc);
               1: StationList.Sort(Sort_CurrentTitle_Desc);
               2: StationList.Sort(Sort_MediaType_Desc);
               3: StationList.Sort(Sort_Genre_Desc);
               4: StationList.Sort(Sort_Count_Desc);
            end;
        end else
        begin
            VST_ShoutcastQuery.Header.SortDirection := sdAscending;
            case Column of
               0: StationList.Sort(Sort_Name_Asc);
               1: StationList.Sort(Sort_CurrentTitle_Asc);
               2: StationList.Sort(Sort_MediaType_Asc);
               3: StationList.Sort(Sort_Genre_Asc);
               4: StationList.Sort(Sort_Count_Asc);
            end;
        end;
        VST_ShoutcastQuery.Clear;
        for i := 0 to StationList.Count - 1 do
            AddVSTStation(VST_ShoutcastQuery, NIL, (StationList[i] as TStation));
  end;
end;
*)


procedure TFormStreamVerwaltung.VST_FavoritesHeaderClick(Sender: TVTHeader;
  HitInfo: TVTHeaderHitInfo);
var i: Integer;
begin
    if HitInfo.Button = mbLeft then
    begin
        cbSortMode.ItemIndex := HitInfo.Column;

        if VST_Favorites.Header.SortDirection = sdAscending then
        begin
            VST_Favorites.Header.SortDirection := sdDescending;
            case HitInfo.Column of
                0: begin
                  FavoriteList.Sort(Sort_Name_Desc);
                  Medienbib.RadioStationList.Sort(Sort_Name_Desc);
                end;
                1: begin
                  FavoriteList.Sort(Sort_MediaType_Desc);
                  Medienbib.RadioStationList.Sort(Sort_MediaType_Desc);
                end;
                2: begin
                  FavoriteList.Sort(Sort_Genre_Desc);
                  Medienbib.RadioStationList.Sort(Sort_Genre_Desc);
                end;
                3: begin
                  FavoriteList.Sort(Sort_URL_Desc);
                  Medienbib.RadioStationList.Sort(Sort_URL_Desc);
                end;
            end;
        end else
        begin
            VST_Favorites.Header.SortDirection := sdAscending;
            case HitInfo.Column of
                0: begin
                  FavoriteList.Sort(Sort_Name_Asc);
                  Medienbib.RadioStationList.Sort(Sort_Name_Asc);
                end;
                1: begin
                  FavoriteList.Sort(Sort_MediaType_Asc);
                  Medienbib.RadioStationList.Sort(Sort_MediaType_Asc);
                end;
                2: begin
                  FavoriteList.Sort(Sort_Genre_Asc);
                  Medienbib.RadioStationList.Sort(Sort_Genre_Asc);
                end;
                3: begin
                  FavoriteList.Sort(Sort_URL_Asc);
                  Medienbib.RadioStationList.Sort(Sort_URL_Asc);
                end;
            end;
        end;
        VST_Favorites.Clear;
        for i := 0 to FavoriteList.Count - 1 do
            AddVSTStation(VST_Favorites, NIL, (FavoriteList[i] as TStation));
  end;

  Medienbib.Changed := True;
  //if MedienBib.CurrentArtist = BROWSE_RADIOSTATIONS then
  begin
        // Anzeige im Tree der MainForm neu füllen
        //Medienbib.GetAlbenList(MedienBib.CurrentArtist);
        //FillStringTree(Medienbib.Alben, Nemp_MainForm.AlbenVST);
  end;
end;


procedure TFormStreamVerwaltung.BtnSetCustomSortClick(Sender: TObject);
var i: Integer;
begin
    for i := 0 to FavoriteList.Count - 1 do
    begin
        TStation(FavoriteList[i]).SortIndex := i;
        TStation(Medienbib.RadioStationList[i]).SortIndex := i;
    end;

    cbSortMode.ItemIndex := 4;
end;

(*procedure TFormStreamVerwaltung.Btn_AddSelectedClick(Sender: TObject);
var SelectedStations: TNodeArray;
    aNode: PVirtualNode;
    Data: PStationTreeData;
    Station, NewStation: TStation;
    i: Integer;
    currentmaxIdx: Integer;
begin

    SelectedStations := VST_ShoutcastQuery.GetSortedSelection(False);
    for i := 0 to length(SelectedStations) - 1 do
    begin
        aNode := SelectedStations[i];
        Data := VST_ShoutcastQuery.GetNodeData(aNode);
        Station := Data^.fStation;

        currentmaxIdx := MedienBib.AddRadioStation(Station);

        NewStation := TStation.Create(Handle);
        NewStation.Assign(Station);
        NewStation.SortIndex := currentmaxIdx;
        FavoriteList.Add(newStation);
        AddVSTStation(VST_Favorites, NIL, NewStation);
    end;

    if MedienBib.CurrentArtist = BROWSE_RADIOSTATIONS then
    begin
        // Anzeige im Tree der MainForm neu füllen
        Medienbib.GetAlbenList(MedienBib.CurrentArtist);
        FillStringTree(Medienbib.Alben, Nemp_MainForm.AlbenVST);
    end;
end;
*)

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

        FavoriteList.Add(newStation);
        currentmaxIdx := MedienBib.AddRadioStation(newStation);
        newStation.SortIndex := currentmaxIdx;
        AddVSTStation(VST_Favorites, NIL, NewStation);

        Medienbib.Changed := True;
        //if MedienBib.CurrentArtist = BROWSE_RADIOSTATIONS then
        begin
            // Anzeige im Tree der MainForm neu füllen
            //Medienbib.GetAlbenList(MedienBib.CurrentArtist);
            //FillStringTree(Medienbib.Alben, Nemp_MainForm.AlbenVST);
        end;

    end;
end;

procedure TFormStreamVerwaltung.Btn_EditClick(Sender: TObject);
var aNode: PVirtualNode;
    Data: PStationTreeData;
    Station, bibStation: TStation;
    idx: Integer;
begin
    if Not Assigned(NewStationForm) then
        Application.CreateForm(TNewStationForm, NewStationForm);

    aNode := VST_Favorites.FocusedNode;
    if assigned(aNode) then
    begin
        Data := VST_Favorites.GetNodeData(aNode);
        Station := Data^.fStation;
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

            idx := Integer(aNode.Index);
            if idx < MedienBib.RadioStationList.Count then
            begin
                bibStation := TStation(MedienBib.RadioStationList[idx]);
                bibStation.Assign(Station);
                //if MedienBib.CurrentArtist = BROWSE_RADIOSTATIONS then
                    Nemp_MainForm.AlbenVST.Invalidate;
            end;
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

    for i := length(SelectedStations)-1 downto 0 do
    begin
          MedienBib.RadioStationList.Delete(SelectedStations[i].Index);
          FavoriteList.Delete(SelectedStations[i].Index);
          VST_Favorites.DeleteNode(SelectedStations[i]);
    end;

    //if MedienBib.CurrentArtist = BROWSE_RADIOSTATIONS then
    begin
        // Anzeige im Tree der MainForm neu füllen
        //Medienbib.GetAlbenList(MedienBib.CurrentArtist);
        //FillStringTree(Medienbib.Alben, Nemp_MainForm.AlbenVST);
    end;

    if assigned(NewSelectNode) then
    begin
        VST_Favorites.Selected[NewSelectNode] := True;
        VST_Favorites.FocusedNode := NewSelectNode;
    end;

    VST_Favorites.EndUpdate;
    VST_Favorites.Invalidate;
end;

(*procedure TFormStreamVerwaltung.VST_ShoutcastQueryKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var aNode: PVirtualNode;
    Data: PStationTreeData;
begin
  case Key of
      VK_RETURN: begin
          aNode := VST_Favorites.FocusedNode;
          if not Assigned(aNode) then
            Exit;
          Data := VST_Favorites.GetNodeData(aNode);
          Data^.fStation.TuneIn(not CB_ParseStreamURL.Checked);
      end;
  end;
end;
*)

procedure TFormStreamVerwaltung.VST_FavoritesGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var Data: PStationTreeData;
begin
  Data := Sender.GetNodeData(Node);
  Case column of
    0: CellText := Data^.fStation.Name;
    1: CellText := Data^.fStation.Format;
    2: CellText := Data^.fStation.Genre;
    3: CellText := Data^.fStation.URL;
  end;
end;




procedure TFormStreamVerwaltung.VST_FavoritesKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var aNode: PVirtualNode;
    Data: PStationTreeData;
begin
  case Key of
      VK_RETURN: begin
            aNode := VST_Favorites.FocusedNode;
            if not Assigned(aNode) then
              Exit;
            Data := VST_Favorites.GetNodeData(aNode);
            Data^.fStation.TuneIn(NempPlaylist.BassHandlePlaylist);
      end;
  end;
end;

procedure TFormStreamVerwaltung.PM_SC_AddToPlaylistClick(Sender: TObject);
var aNode: PVirtualNode;
    Data: PStationTreeData;
begin
    aNode := VST_ShoutcastQuery.FocusedNode;
    if not Assigned(aNode) then
      Exit;
    Data := VST_ShoutcastQuery.GetNodeData(aNode);
    Data^.fStation.TuneIn(NempPlaylist.BassHandlePlaylist);
end;

procedure TFormStreamVerwaltung.PM_Fav_AddToPlaylistClick(Sender: TObject);
var aNode: PVirtualNode;
    Data: PStationTreeData;
begin
    aNode := VST_Favorites.FocusedNode;
    if not Assigned(aNode) then
      Exit;
    Data := VST_Favorites.GetNodeData(aNode);
    Data^.fStation.TuneIn(NempPlaylist.BassHandlePlaylist);
end;

(*
procedure TFormStreamVerwaltung.PM_SC_AddToFavoritesClick(Sender: TObject);
begin
    Btn_AddSelectedClick(Nil);
end;
*)

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
var i: Integer;
    newStation: TStation;
begin
    if OpenDialog1.Execute then
    begin
        MedienBib.ImportFavorites(OpenDialog1.FileName);
        VST_Favorites.Clear;
        FavoriteList.Clear;
        for i := 0 to MedienBib.RadioStationList.Count - 1 do
        begin
            newStation := TStation.Create(Handle);
            newStation.Assign( TStation(MedienBib.RadioStationList[i]));
            FavoriteList.Add(newStation);
        end;

        for i := 0 to FavoriteList.Count - 1 do
            AddVSTStation(VST_Favorites, NIL, (FavoriteList[i] as TStation));


        //if MedienBib.CurrentArtist = BROWSE_RADIOSTATIONS then
        begin
            // Anzeige im Tree der MainForm neu füllen
            //Medienbib.GetAlbenList(MedienBib.CurrentArtist);
            //FillStringTree(Medienbib.Alben, Nemp_MainForm.AlbenVST);
        end;
    end;
end;



end.
