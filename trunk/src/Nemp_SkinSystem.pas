{

    Unit Nemp_SkinSystem

    The SkinSystem of Nemp
    This unit needs some changes until 4.0
    Some changes are already done, some mor will follow....

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

unit Nemp_SkinSystem;

interface

uses Windows, Graphics, ExtCtrls, Controls, Types, Forms, dialogs, SysUtils, VirtualTrees,  StdCtrls,
iniFiles, jpeg, NempPanel, Classes, oneinst, SkinButtons,

Nemp_ConstantsAndTypes, PartyModeClass;

type
  // Achtung: Reihenfolge hier jetzt so lassen!!

  TControlButtons = (ctrlPlayPauseBtn,
                     ctrlStopBtn,
                     ctrlNextBtn,
                     ctrlPrevBtn,
                     ctrlSlideForwardBtn,
                     ctrlSlidebackwardBtn,
                     ctrlRandomBtn,
                     ctrlRecordBtn,
                     ctrlMinimizeBtn,
                     ctrlCloseBtn,
                     ctrlMenuBtn
                     );
                     // Der Reverse-Button fällt hier raus. Größe und Position sind fest!!

  type

  // Typ Zur Farbverwaltung des Skins
  TNempColorScheme = record
      FormCL: TColor;
      TabTextCL: TColor;
      TabTextBackGroundCL: TColor;
      SpecTitelCL: TColor;
      SpecTimeCL: TColor;
      SpecTitelBackGroundCL: TColor;
      SpecTimeBackGroundCL: TColor;
      SpecPenCL: TColor;
      SpecPen2Cl: TColor;
      SpecPeakCL: TColor;
      PreviewTitleColor: TColor;
      PreviewArtistColor: TColor;
      PreviewTimeColor: TColor;

      LabelCL: TColor;
      LabelBackGroundCL: TColor;
      GroupboxFrameCL: TColor;
      MemoBackGroundCL: TColor;
      MemoTextCL: TColor;
      ShapeBrushCL: TColor;
      ShapePenCL: TColor;
      Splitter1Color: TColor;
      Splitter2Color: TColor;
      Splitter3Color: TColor;
      PlaylistPlayingFileColor: TColor;

      // Farben (und Optionen) für die Bitraten-Darstellung in der Playlist/Medienliste
      MinFontColor: TColor;
      MaxFontColor: TColor;
      MiddleFontColor: TColor;
      MiddleToMinComputing: Byte;
      MiddleToMaxComputing: Byte;

      Tree_Color                         : Array[1..4] of TColor;
      Tree_FontColor                     : Array[1..4] of TColor;
      Tree_FontSelectedColor             : Array[1..4] of TColor;
      Tree_HeaderBackgroundColor         : Array[1..4] of TColor;
      Tree_HeaderFontColor               : Array[1..4] of TColor;
      Tree_BorderColor                   : Array[1..4] of TColor;
      Tree_DisabledColor                 : Array[1..4] of TColor;
      Tree_DropMarkColor                 : Array[1..4] of TColor;
      Tree_DropTargetBorderColor         : Array[1..4] of TColor;
      Tree_DropTargetColor               : Array[1..4] of TColor;
      Tree_FocussedSelectionBorder       : Array[1..4] of TColor;
      Tree_FocussedSelectionColor        : Array[1..4] of TColor;
      Tree_GridLineColor                 : Array[1..4] of TColor;
      Tree_HeaderHotColor                : Array[1..4] of TColor;
      Tree_HotColor                      : Array[1..4] of TColor;
      Tree_SelectionRectangleBlendColor  : Array[1..4] of TColor;
      Tree_SelectionRectangleBorderColor : Array[1..4] of TColor;
      Tree_TreeLineColor                 : Array[1..4] of TColor;
      Tree_UnfocusedSelectionBorderColor : Array[1..4] of TColor;
      Tree_UnfocusedSelectionColor       : Array[1..4] of TColor;
  end;


  const
    DefaultButtonData : Array[TControlButtons] of TNempButtonData =
      ( (Name: 'BtnPlayPause'    ; Visible: True; Left:  61; Top: 82; Width: 24; Height: 24),  // 'PlayBtn',
        (Name: 'BtnStop'         ; Visible: True; Left:  85; Top: 82; Width: 24; Height: 24),  // 'StopBtn',
        (Name: 'BtnNext'         ; Visible: True; Left: 133; Top: 82; Width: 24; Height: 24),  // 'NextBtn',
        (Name: 'BtnPrev'         ; Visible: True; Left:  37; Top: 82; Width: 24; Height: 24),  // 'PrevBtn',
        (Name: 'BtnSlideForward' ; Visible: True; Left: 157; Top: 82; Width: 24; Height: 24),  // 'SlideForwardBtn',
        (Name: 'BtnSlideBackward'; Visible: True; Left:  13; Top: 82; Width: 24; Height: 24),   // 'SlidebackwardBtn'
        (Name: 'BtnRandom'       ; Visible: True; Left: 191; Top: 82; Width: 24; Height: 24),  // 'RandomBtn',
        (Name: 'BtnRecord'       ; Visible: True; Left: 109; Top: 82; Width: 24; Height: 24),  // 'RecordBtn',
        (Name: 'BtnMinimize'     ; Visible: False; Left: 202; Top: 1; Width: 12; Height: 12),  // 'MinimizeBtn',
        (Name: 'BtnClose'        ; Visible: True; Left: 214; Top: 1; Width: 12; Height: 12),  // 'CloseBtn',
        (Name: 'BtnMenu'         ; Visible: False; Left:   8; Top: 52; Width: 12; Height: 12)  // 'MenuBtn',
      ) ;

  type
      SkinButtonRec = record
          Button: TSkinButton;
          GlyphFile: String;
      end;

 type
  // Eigentliche Skinklasse
  TNempSkin = class
      public
        Name: UnicodeString;
        Path: UnicodeString;
        isActive: Boolean;

        // Bild für das Gesamte Ding
        CompleteBitmap: TBitmap;

        // Bild für den Mittelteil (den eigentlichen Player)
        // Kann leer sein - Aber wenn vorhanden, dann ist hier der Offset klar. Nämlich 0/0
        UseSeparatePlayerBitmap: Boolean;
        PlayerBitmap: TBitmap;
        ExtendedPlayerBitmap: TBitmap;

        SetStarBitmap: TBitmap;
        HalfStarBitmap: TBitmap;
        UnSetStarBitmap: TBitmap;

        // Originaler Offset des SKins
        PlayerPageOffsetXOrig: Integer;
        PlayerPageOffsetYOrig: Integer;

        // Aktueller Offset des SKins
        // Dieser kann bei "FixedBackground" dynamisch der Fensterposition angepasst werden
        // "Scheinbare Transparenz", wenn das Bild dem Desktop-Hintergrund entspricht
        PlayerPageOffsetX: Integer;
        PlayerPageOffsetY: Integer;
        //----
        UseBackGroundImageVorauswahl  : boolean;
        UseBackgroundImagePlaylist    : boolean;
        UseBackgroundImageMedienliste : boolean;
        UseBackgroundTagCloud         : boolean;
        UseBackgroundImages: Array[0..3] of boolean;

        TileBackground: Boolean;  // Hintergrund kacheln
        FixedBackGround: Boolean; // Hintergrund fixieren

        boldFont: Boolean;

        DrawGroupboxFrames: Boolean;
        DrawGroupboxFramesMain: Boolean;
        HideTabText: Boolean;
        DrawTransparentTabText: Boolean;
        DrawTransparentLabel  : Boolean;
        DrawTransparentTitel  : Boolean;
        DrawTransparentTime   : Boolean;
        //----
        DisableBitrateColorsPlaylist    : Boolean;
        DisableBitrateColorsMedienliste : Boolean;
        //----
        DisableArtistScrollbar      : Boolean;
        DisableAlbenScrollbar       : Boolean;
        DisablePlaylistScrollbar    : Boolean;
        DisableMedienListeScrollbar : Boolean;
        //----
        UseBlendedSelectionArtists     : Boolean;
        UseBlendedSelectionAlben       : Boolean;
        UseBlendedSelectionPlaylist    : Boolean;
        UseBlendedSelectionMedienliste : Boolean;
        UseBlendedSelectionTagCloud    : Boolean;

        UseBlendedArtists      : Boolean;
        UseBlendedAlben        : Boolean;
        UseBlendedPlaylist     : Boolean;
        UseBlendedMedienliste  : Boolean;
        UseBlendedTagCloud     : Boolean;

        BlendFaktorArtists     : Byte;
        BlendFaktorAlben       : Byte;
        BlendFaktorPlaylist    : Byte;
        BlendFaktorMedienliste : Byte;
        BlendFaktorTagCloud    : Byte;

        BlendFaktorArtists2     : Byte;
        BlendFaktorAlben2       : Byte;
        BlendFaktorPlaylist2    : Byte;
        BlendFaktorMedienliste2 : Byte;
        BlendFaktorTagCloud2    : Byte;

        //----
        HideMainMenu: Boolean;

        //OldUseDefaultButtons: Boolean;
        ButtonMode: Integer;  // 0: Windows, 1: Nemp klassisch, 2: Nemp3.0
        SlideButtonMode: Integer;

        UseDefaultListImages: Boolean;

        UseDefaultStarBitmaps: Boolean;

        //-------------------------------------------------
        SkinColorScheme: TNempColorScheme;
        DialogCustomColors: Array[0..15] of TColor;

        // ControlButtonData: Store the values
        ControlButtonData : Array[TControlButtons] of TNempButtonData;
        // ControlButtons: The Buttons on the MainForm
        ControlButtons : Array[TControlButtons] of TSkinButton;

        TabButtons: Array [0..9] of SkinButtonRec;
        SlideButtons: Array [0..15] of SkinButtonRec;

        NempPartyMode: TNempPartyMode;

        constructor create;
        destructor Destroy;  override;         //Complete:: Für die Optionen-Vorschau. Da z.B. nicht die SkinButtons ändern
        procedure LoadFromDir(DirName: UnicodeString; Complete: Boolean = True);
        procedure SaveToDir(DirName: UnicodeString);
        procedure copyFrom(aSkin: TNempskin);


        Procedure FitSkinToNewWindow;  // Setz den ganzen Skin bei Bedarf um
        Procedure FitPlayerToNewWindow; // Setzt nur den Player-Teil um
        procedure RepairSkinOffset;
        Procedure SetArtistAlbumOffsets;
        procedure SetVSTOffsets;
        Procedure SetPlaylistOffsets;

        procedure DrawPreview(aPanel: TNempPanel);

        procedure DrawAPanel(aPanel: TNempPanel; UseBackground: Boolean = True);
        //procedure DrawGroupboxFrame(aGroupbox: TNempGroupbox);


        Procedure UpdateSpectrumGraphics;
        procedure ActivateSkin;
        procedure DeActivateSkin;

        procedure TileGraphic(const ATile: TBitmap; const ATarget: TCanvas; X, Y: Integer; Stretch: Boolean = False);

        //function CreatePlayerBitmap: boolean;

        /// function SaveButton(aBmp: TBitmap; aFilename: String): boolean;
        //procedure CreateButtonFiles(CutMode: Integer);
        //procedure CorrectButtonFile(Cutmode: Integer; btnidx: Integer; BtnMode: Integer; Row: Integer);

        // LoadGraphicFromBaseName: Load Graphic from a file
        // aFilename<Scale>.<Ext>
        // where <Scale> is a Scalefactor-Suffix (for alternate Graphics in Partymode)
        // and <Ext> is png, bmp or jpg
        function LoadGraphicFromBaseName(aBmp: TBitmap; aFilename: UnicodeString; Scaled: Boolean=False): Boolean;

      private

        // Die alten Grafiken, bzw. die Default-Grafiken in das neue Glyph-Format bringen
        procedure AssignWindowsGlyphs(UseSkinGraphics: Boolean);
        procedure AssignWindowsTabGlyphs(UseSkinGraphics: Boolean);

//        procedure AssignDefaultSystemButtons;

        procedure AssignSkinTabGlyphs;

        procedure SetDefaultButtonSizes;
        // Setzt die Buttongrößen im Hauptfenster und sortiert die TabOrder
        procedure AssignButtonSizes;

        //procedure AssignClassicGlyph(aButton: TSkinButton; aFilename: UnicodeString);
        procedure AssignNemp3Glyph(aButton: TSkinButton; aFilename: UnicodeString; Scaled: Boolean=False);

        procedure AssignStarGraphics;


  end;


const CustomColorNames : Array [0..15] of string = ('ColorA','ColorB','ColorC','ColorD','ColorE','ColorF','ColorG','ColorH','ColorI','ColorJ','ColorK','ColorL','ColorM','ColorN','ColorO','ColorP');

implementation


uses NempMainUnit, OptionsComplete, Hilfsfunktionen, spectrum_vis,
    SplitForm_Hilfsfunktionen, PlaylistUnit, AuswahlUnit, MedienlisteUnit, ExtendedControlsUnit,
    VSTEditControls, MedienBibliothekClass, TagClouds;

constructor TNempSkin.create;
var i: Integer;
begin
  inherited create;
  CompleteBitmap := TBitmap.Create;
  PlayerBitmap := TBitmap.Create;
  ExtendedPlayerBitmap := TBitmap.Create;

  NempPartyMode := TNempPartyMode.Create;
  NempPartymode.BackupOriginalPositions;

  SetStarBitmap := TBitmap.Create;
  HalfStarBitmap:= TBitmap.Create;
  UnSetStarBitmap := TBitmap.Create;

  SetStarBitmap.Transparent := True;
  HalfStarBitmap.Transparent := True;
  UnSetStarBitmap.Transparent := True;
  SetStarBitmap.Width := 14;
  SetStarBitmap.Height := 14;
  SetStarBitmap.Canvas.Rectangle(0,0,14,14);
  UnSetStarBitmap.Width := 14;
  UnSetStarBitmap.Height := 14;
  UnSetStarBitmap.Canvas.Rectangle(0,0,14,14);
  HalfStarBitmap.Width := 14;
  HalfStarBitmap.Height := 14;
  HalfStarBitmap.Canvas.Rectangle(0,0,14,14);

  isActive := False;

  // Set the ControlButtons-Array
  ControlButtons[ctrlPlayPauseBtn    ] :=  Nemp_MainForm.PlayPauseBtn    ;
  ControlButtons[ctrlStopBtn         ] :=  Nemp_MainForm.StopBtn         ;
  ControlButtons[ctrlNextBtn         ] :=  Nemp_MainForm.PlayNextBtn     ;
  ControlButtons[ctrlPrevBtn         ] :=  Nemp_MainForm.PlayPrevBtn     ;
  ControlButtons[ctrlSlideForwardBtn ] :=  Nemp_MainForm.SlideForwardBtn ;
  ControlButtons[ctrlSlidebackwardBtn] :=  Nemp_MainForm.SlidebackBtn    ;
  ControlButtons[ctrlRandomBtn       ] :=  Nemp_MainForm.RandomBtn       ;
  ControlButtons[ctrlRecordBtn       ] :=  Nemp_MainForm.RecordBtn       ;
  ControlButtons[ctrlMinimizeBtn     ] :=  Nemp_MainForm.BtnMinimize     ;
  ControlButtons[ctrlCloseBtn        ] :=  Nemp_MainForm.BtnClose        ;
  ControlButtons[ctrlMenuBtn         ] :=  Nemp_MainForm.BtnMenu         ;

  TabButtons[0].Button    :=  Nemp_MainForm.TabBtn_Cover         ;
  TabButtons[1].Button    :=  Nemp_MainForm.TabBtn_Lyrics        ;
  TabButtons[2].Button    :=  Nemp_MainForm.TabBtn_Equalizer     ;
  TabButtons[3].Button    :=  Nemp_MainForm.TabBtn_Effects       ;
  TabButtons[4].Button    :=  Nemp_MainForm.TabBtn_Playlist      ;
  TabButtons[5].Button    :=  Nemp_MainForm.TabBtn_Browse        ;
  TabButtons[6].Button    :=  Nemp_MainForm.TabBtn_CoverFlow     ;
  TabButtons[7].Button    :=  Nemp_MainForm.TabBtn_TagCloud      ;
  TabButtons[8].Button    :=  Nemp_MainForm.TabBtn_Preselection  ;
  TabButtons[9].Button    :=  Nemp_MainForm.TabBtn_Medialib      ;

  TabButtons[0].GlyphFile := 'TabBtnCover'       ;
  TabButtons[1].GlyphFile := 'TabBtnLyrics'      ;
  TabButtons[2].GlyphFile := 'TabBtnEqualizer'   ;
  TabButtons[3].GlyphFile := 'TabBtnEffects'     ;
  TabButtons[4].GlyphFile := 'TabBtnNemp'        ;
  TabButtons[5].GlyphFile := 'TabBtnBrowse'      ;
  TabButtons[6].GlyphFile := 'TabBtnCoverflow'   ;
  TabButtons[7].GlyphFile := 'TabBtnTagCloud'    ;
  TabButtons[8].GlyphFile := 'TabBtnNemp'        ;
  TabButtons[9].GlyphFile := 'TabBtnNemp'        ;

  SlideButtons[0].Button  := Nemp_MainForm.VolButton           ;
  SlideButtons[1].Button  := Nemp_MainForm.SlideBarButton      ;
  SlideButtons[2].Button  := Nemp_MainForm.HallButton          ;
  SlideButtons[3].Button  := Nemp_MainForm.EchoWetDryMixButton ;
  SlideButtons[4].Button  := Nemp_MainForm.EchoTimeButton      ;
  SlideButtons[5].Button  := Nemp_MainForm.SampleRateButton    ;
  SlideButtons[6].Button  := Nemp_MainForm.EqualizerButton1    ;
  SlideButtons[7].Button  := Nemp_MainForm.EqualizerButton2    ;
  SlideButtons[8].Button  := Nemp_MainForm.EqualizerButton3    ;
  SlideButtons[9].Button  := Nemp_MainForm.EqualizerButton4    ;
  SlideButtons[10].Button := Nemp_MainForm.EqualizerButton5    ;
  SlideButtons[11].Button := Nemp_MainForm.EqualizerButton6    ;
  SlideButtons[12].Button := Nemp_MainForm.EqualizerButton7    ;
  SlideButtons[13].Button := Nemp_MainForm.EqualizerButton8    ;
  SlideButtons[14].Button := Nemp_MainForm.EqualizerButton9    ;
  SlideButtons[15].Button := Nemp_MainForm.EqualizerButton10   ;

  SlideButtons[0].GlyphFile := 'SlideBtnVolume';
  for i := 1 to 5 do SlideButtons[i].GlyphFile := 'SlideBtnLeftRight';
  for i := 6 to 15 do SlideButtons[i].GlyphFile := 'SlideBtnUpDown';


end;

destructor TNempSkin.Destroy;
begin
  CompleteBitmap.Free;
  PlayerBitmap.Free;
  ExtendedPlayerBitmap.Free;

  SetStarBitmap.Free;
  HalfStarBitmap.Free;
  UnSetStarBitmap.Free;

  NempPartyMode.Free;

  inherited destroy;
end;

procedure TNempSkin.LoadFromDir(DirName: UnicodeString; Complete: Boolean = True);
var i,idx: integer;
  ini: TMemIniFile;
  SectionStr, n: String;
   Buttontmp, ListenCompletebmp: TBitmap;
  tmpjpg: TJpegImage;
  aPoint: TPoint;
  j: TControlButtons;
  aStream: TFileStream;
begin
  name := ExtractFileName(DirName);
  path := DirName;

  ini := TMeminiFile.Create(DirName + '\skin.ini', TEncoding.UTF8);
  try
        ini.Encoding := TEncoding.UTF8;
        UseBackGroundImageVorauswahl    := Not Ini.ReadBool('BackGround','HideBackgroundImageArtists'      , False); // Abwärtskompatibilität!
        UseBackGroundImageVorauswahl    := Not Ini.ReadBool('BackGround','HideBackgroundImageVorauswahl'   , False);
        UseBackgroundImagePlaylist      := Not Ini.ReadBool('BackGround','HideBackgroundImagePlaylist'     , False);
        UseBackgroundImageMedienliste   := Not Ini.ReadBool('BackGround','HideBackgroundImageMedienliste'  , False);
        UseBackgroundTagCloud           := Not Ini.ReadBool('BackGround','HideBackgroundTagCloud'          , False);

        UseBackgroundImages[0] := True; // Player immer!
        UseBackgroundImages[1] := UseBackgroundImagePlaylist;
        UseBackgroundImages[2] := UseBackGroundImageVorauswahl;
        UseBackgroundImages[3] := UseBackgroundImageMedienliste;
        TileBackground                   := ini.ReadBool('BackGround','TileBackground'      , True);
        FixedBackGround                  := ini.ReadBool('BackGround','FixedBackGround'     , True);
        PlayerPageOffsetXOrig := Ini.ReadInteger('BackGround','PlayerPageOffsetX', 0);
        PlayerPageOffsetYOrig := Ini.ReadInteger('BackGround','PlayerPageOffsetY', 0);
        if FixedBackGround then
        begin
          PlayerPageOffsetX := PlayerPageOffsetXOrig;
          PlayerPageOffsetY := PlayerPageOffsetYOrig;
        end else
        begin
          aPoint := (Nemp_MainForm.TopMainPanel.ClientToScreen(Point(Nemp_MainForm.PlayerPanel.Left, Nemp_MainForm.PlayerPanel.Top)));

          PlayerPageOffsetX := aPoint.X + PlayerPageOffsetXOrig; //Nemp_MainForm.Left + Nemp_MainForm.PlayerPanel.Left + PlayerPageOffsetXOrig;
          PlayerPageOffsetY := aPoint.Y + PlayerPageOffsetYOrig; //Nemp_MainForm.Top + Nemp_MainForm.PlayerPanel.Top + PlayerPageOffsetYOrig;
        end;
        //
        //--------------------------
        //                                                          
        DrawGroupboxFrames               := Ini.ReadBool('Options','DrawGroupboxFrames'              , True);
        boldFont                         := Ini.ReadBool('Options', 'boldFont'                       , False);
        DrawGroupboxFramesMain           := Ini.ReadBool('Options','DrawGroupboxFramesMain'          , DrawGroupboxFrames);
        HideTabText                      := Ini.ReadBool('Options','HideTabText'                     , False);
        DrawTransparentTabText           := Ini.ReadBool('Options','DrawTransparentTabText'          , True);
        DrawTransparentLabel             := Ini.ReadBool('Options','DrawTransparentLabel'            , True);
        DrawTransparentTitel             := Ini.ReadBool('Options','DrawTransparentTitel'            , True);
        DrawTransparentTime              := Ini.ReadBool('Options','DrawTransparentTime'             , True);
        //----
        DisableBitrateColorsPlaylist     := Ini.ReadBool('Options','DisableBitrateColorsPlaylist'    , True);
        DisableBitrateColorsMedienliste  := Ini.ReadBool('Options','DisableBitrateColorsMedienliste' , True);
        //----
        DisableArtistScrollbar           := Ini.ReadBool('Options','DisableArtistScrollbar'          , False);
        DisableAlbenScrollbar            := Ini.ReadBool('Options','DisableAlbenScrollbar'           , False);
        DisablePlaylistScrollbar         := Ini.ReadBool('Options','DisablePlaylistScrollbar'        , False);
        DisableMedienListeScrollbar      := Ini.ReadBool('Options','DisableMedienListeScrollbar'     , False);
        //----
        UseBlendedSelectionArtists       := Ini.ReadBool('Options','UseBlendedSelectionArtists'      , True);
        UseBlendedSelectionAlben         := Ini.ReadBool('Options','UseBlendedSelectionAlben'        , True);
        UseBlendedSelectionPlaylist      := Ini.ReadBool('Options','UseBlendedSelectionPlaylist'     , True);
        UseBlendedSelectionMedienliste   := Ini.ReadBool('Options','UseBlendedSelectionMedienliste'  , True);
        UseBlendedSelectionTagCloud      := Ini.ReadBool('Options','UseBlendedSelectionTagCloud'     , True);

        UseBlendedArtists        := Ini.ReadBool('Options','UseBlendedArtists'      , False);
        UseBlendedAlben          := Ini.ReadBool('Options','UseBlendedAlben'        , False);
        UseBlendedPlaylist       := Ini.ReadBool('Options','UseBlendedPlaylist'     , False);
        UseBlendedMedienliste    := Ini.ReadBool('Options','UseBlendedMedienliste'  , False);
        UseBlendedTagCloud       := Ini.ReadBool('Options','UseBlendedTagCloud'     , False);

        //----
        HideMainMenu                     := Ini.ReadBool('Options','HideMainMenu'  , False);

        ButtonMode                       := Ini.ReadInteger('Options', 'ButtonMode', 0);
        //if ButtonMode = -1 then
        //begin
        //  OldUseDefaultButtons                := Ini.ReadBool('Options','UseDefaultButtons', False);
        //  if OldUseDefaultButtons then ButtonMode := 0 else ButtonMode := 1;
        //end;
        if (ButtonMode < 0) or (ButtonMode > 2) then ButtonMode := 0;

        SlideButtonMode                  := Ini.ReadInteger('Options', 'SlideButtonMode', 0);
        //if ButtonMode = -1 then
        //begin
        //  OldUseDefaultSlideButtons                := Ini.ReadBool('Options','UseDefaultSlideButtons', False);
        //  if OldUseDefaultSlideButtons then SlideButtonMode := 0 else SlideButtonMode := 1;
        //end;
        if (SlideButtonMode < 0) or (SlideButtonMode > 2) then SlideButtonMode := 0;


        //UseDefaultSlideButtons           := Ini.ReadBool('Options','UseDefaultSlideButtons', False);
        UseDefaultListImages             := Ini.ReadBool('Options','UseDefaultListImages', False);
        UseDefaultStarBitmaps  := Ini.ReadBool('Options','UseDefaultStarBitmaps', True);
        UseSeparatePlayerBitmap          := Ini.ReadBool('Options', 'UseSeparatePlayerBitmap', False);
        //----
        BlendFaktorArtists     := Ini.ReadInteger('Options','BlendFaktorArtists'       , 100);
        BlendFaktorAlben       := Ini.ReadInteger('Options','BlendFaktorAlben'         , 100);
        BlendFaktorPlaylist    := Ini.ReadInteger('Options','BlendFaktorPlaylist'      , 100);
        BlendFaktorMedienliste := Ini.ReadInteger('Options','BlendFaktorMedienliste'   , 100);
        BlendFaktorTagCloud    := Ini.ReadInteger('Options','BlendFaktorTagCloud'      , 100);

        BlendFaktorArtists2     := Ini.ReadInteger('Options','BlendFaktorArtists2'       , 100);
        BlendFaktorAlben2       := Ini.ReadInteger('Options','BlendFaktorAlben2'         , 100);
        BlendFaktorPlaylist2    := Ini.ReadInteger('Options','BlendFaktorPlaylist2'      , 100);
        BlendFaktorMedienliste2 := Ini.ReadInteger('Options','BlendFaktorMedienliste2'   , 100);
        BlendFaktorTagCloud2    := Ini.ReadInteger('Options','BlendFaktorTagCloud2'      , 100);

        SkinColorScheme.FormCL                := StringToColor(Ini.ReadString('Colors','FormCL'               , 'clWindow'   ));
        SkinColorScheme.TabTextCL             := StringToColor(Ini.ReadString('Colors','TabTextCL'            , 'clWindowText'   ));
        SkinColorScheme.TabTextBackGroundCL   := StringToColor(Ini.ReadString('Colors','TabTextBackGroundCL'  , 'clWindow'     ));
        SkinColorScheme.SpecTitelCL           := StringToColor(Ini.ReadString('Colors','SpecTitelCL'          , 'clWindowText'     ));

        SkinColorScheme.SpecTimeCL            := StringToColor(Ini.ReadString('Colors','SpecTimeCL'           , 'clWindowText'  ));
        SkinColorScheme.SpecTitelBackGroundCL := StringToColor(Ini.ReadString('Colors','SpecTitelBackGroundCL', 'clBtnFace'     ));
        SkinColorScheme.SpecTimeBackGroundCL  := StringToColor(Ini.ReadString('Colors','SpecTimeBackGroundCL' , 'clBtnFace'     ));
        SkinColorScheme.SpecPenCL             := StringToColor(Ini.ReadString('Colors','SpecPenCL'            , 'clActiveCaption' ));
        SkinColorScheme.SpecPeakCL            := StringToColor(Ini.ReadString('Colors','SpecPeakCL'           , 'clBackground'     ));
        SkinColorScheme.PreviewTitleColor     := StringToColor(Ini.ReadString('Colors','PreviewTitleColor'    , 'clWindowText'     ));
        SkinColorScheme.PreviewArtistColor    := StringToColor(Ini.ReadString('Colors','PreviewArtistColor'   , 'clGrayText'       ));
        SkinColorScheme.PreviewTimeColor      := StringToColor(Ini.ReadString('Colors','PreviewTimeColor'     , 'clWindowText'     ));


        if ini.ValueExists('Colors','SpecPen2CL') then
            SkinColorScheme.SpecPen2CL             := StringToColor(Ini.ReadString('Colors','SpecPen2CL'            , 'clActiveCaption' ))
        else
            SkinColorScheme.SpecPen2Cl := SkinColorScheme.SpecPeakCL;

        SkinColorScheme.LabelCL               := StringToColor(Ini.ReadString('Colors','LabelCL'              , 'clWindowText'     ));
        SkinColorScheme.LabelBackGroundCL     := StringToColor(Ini.ReadString('Colors','LabelBackGroundCL'    , 'clblack'   ));
        SkinColorScheme.GroupboxFrameCL       := StringToColor(Ini.ReadString('Colors','GroupboxFrameCL'      , 'clblack'   ));
        SkinColorScheme.MemoBackGroundCL      := StringToColor(Ini.ReadString('Colors','MemoBackGroundCL'     , 'clWindow'     ));
        SkinColorScheme.MemoTextCL            := StringToColor(Ini.ReadString('Colors','MemoTextCL'           , 'clWindowText'   ));
        SkinColorScheme.ShapeBrushCL          := StringToColor(Ini.ReadString('Colors','ShapeBrushCL'         , 'clwhite'   ));
        SkinColorScheme.ShapePenCL            := StringToColor(Ini.ReadString('Colors','ShapePenCL'           , 'clGradientActiveCaption'    ));
        SkinColorScheme.Splitter1Color        := StringToColor(Ini.ReadString('Colors','Splitter1'            , 'clWindow'    ));
        SkinColorScheme.Splitter2Color        := StringToColor(Ini.ReadString('Colors','Splitter2'            , 'clWindow'    ));
        SkinColorScheme.Splitter3Color        := StringToColor(Ini.ReadString('Colors','Splitter3'            , 'clWindow'    ));
        SkinColorScheme.PlaylistPlayingFileColor := StringToColor(Ini.ReadString('Colors','PlaylistPlayingFileColor'            , 'clGradientActiveCaption'    ));
        //SkinColorScheme.ControlImagesColor    := StringToColor(Ini.ReadString('Colors','ControlImagesColor'            , ColorToString(SkinColorScheme.GroupboxFrameCL)    ));

        SkinColorScheme.MinFontColor    := StringToColor(Ini.ReadString('Colors','MinFontColor'     , 'clred'         ));
        SkinColorScheme.MiddleFontColor := StringToColor(Ini.ReadString('Colors','MiddleFontColor'  , 'clwindowtext'  ));
        SkinColorScheme.MaxFontColor    := StringToColor(Ini.ReadString('Colors','MaxFontColor'     , 'clgreen'       ));
        SkinColorScheme.MiddleToMinComputing := Ini.ReadInteger('Colors', 'MiddleToMinComputing', 2);
        SkinColorScheme.MiddleToMaxComputing := Ini.ReadInteger('Colors', 'MiddleToMaxComputing', 2);

        for i:= 0 to 15 do
          DialogCustomColors[i] := StringToColor(Ini.ReadString('DialogColors', CustomColorNames[i]         , '$00FFFFFF'    ));

        // Farben für die Trees
        for idx := 1 to 4 do
        begin
            case idx of
                1: SectionStr := 'ArtistColors';
                2: SectionStr := 'AlbenColors';
                3: SectionStr := 'PlaylistColors';
               else SectionStr := 'MedienlisteColors';
            end;
            SkinColorScheme.Tree_Color[idx]                        := StringToColor(Ini.ReadString(SectionStr, 'Tree_Color'                             , 'clWindow' ));
            SkinColorScheme.Tree_FontColor[idx]                    := StringToColor(Ini.ReadString(SectionStr, 'Tree_FontColor'                         , 'clWindowText' ));
            SkinColorScheme.Tree_FontSelectedColor[idx]            := StringToColor(Ini.ReadString(SectionStr, 'Tree_FontColorSelected'                 , 'clWindow' ));
            SkinColorScheme.Tree_HeaderBackgroundColor[idx]        := StringToColor(Ini.ReadString(SectionStr, 'Tree_HeaderBackgroundColor'             , 'clGradientActiveCaption'     ));
            SkinColorScheme.Tree_HeaderFontColor[idx]              := StringToColor(Ini.ReadString(SectionStr, 'Tree_HeaderFontColor'                   , 'clWindowText' ));
            SkinColorScheme.Tree_BorderColor[idx]                  := StringToColor(Ini.ReadString(SectionStr, 'Tree_BorderColor'                       , 'clBtnFace'    ));
            SkinColorScheme.Tree_DisabledColor[idx]                := StringToColor(Ini.ReadString(SectionStr, 'Tree_DisabledColor'                     , 'clBtnShadow'  ));
            SkinColorScheme.Tree_DropMarkColor[idx]                := StringToColor(Ini.ReadString(SectionStr, 'Tree_DropMarkColor'                     , 'clHighlight'  ));
            SkinColorScheme.Tree_DropTargetBorderColor[idx]        := StringToColor(Ini.ReadString(SectionStr, 'Tree_DropTargetBorderColor'             , 'clHighlight'  ));
            SkinColorScheme.Tree_DropTargetColor[idx]              := StringToColor(Ini.ReadString(SectionStr, 'Tree_DropTargetColor'                   , 'clHighlight'  ));
            SkinColorScheme.Tree_FocussedSelectionBorder[idx]      := StringToColor(Ini.ReadString(SectionStr, 'Tree_FocussedSelectionBorder'           , 'clHighlight'  ));
            SkinColorScheme.Tree_FocussedSelectionColor[idx]       := StringToColor(Ini.ReadString(SectionStr, 'Tree_FocussedSelectionColor'            , 'clHighlight'  ));
            SkinColorScheme.Tree_GridLineColor[idx]                := StringToColor(Ini.ReadString(SectionStr, 'Tree_GridLineColor'                     , 'clBtnFace'    ));
            SkinColorScheme.Tree_HeaderHotColor[idx]               := StringToColor(Ini.ReadString(SectionStr, 'Tree_HeaderHotColor'                    , 'clBtnShadow'  ));
            SkinColorScheme.Tree_HotColor[idx]                     := StringToColor(Ini.ReadString(SectionStr, 'Tree_HotColor'                          , 'clWindowText' ));
            SkinColorScheme.Tree_SelectionRectangleBlendColor[idx] := StringToColor(Ini.ReadString(SectionStr, 'Tree_SelectionRectangleBlendColor'      , 'clHighlight'  ));
            SkinColorScheme.Tree_SelectionRectangleBorderColor[idx]:= StringToColor(Ini.ReadString(SectionStr, 'Tree_SelectionRectangleBorderColor'     , 'clHighlight'  ));
            SkinColorScheme.Tree_TreeLineColor[idx]                := StringToColor(Ini.ReadString(SectionStr, 'Tree_TreeLineColor'                     , 'clBtnShadow'  ));
            SkinColorScheme.Tree_UnfocusedSelectionBorderColor[idx]:= StringToColor(Ini.ReadString(SectionStr, 'Tree_UnfocusedSelectionBorderColor'     , 'clBtnFace'    ));
            SkinColorScheme.Tree_UnfocusedSelectionColor[idx]      := StringToColor(Ini.ReadString(SectionStr, 'Tree_UnfocusedSelectionColor'           , 'clBtnFace'    ));
        end;

        // Button-Eigenschaften
        for j := low(TControlbuttons) to High(TControlButtons) do
        begin
          n := DefaultButtonData[j].Name;
          ControlButtonData[j].Name := n;
          ControlButtonData[j].Visible     := Ini.ReadBool   ('Buttons', n + 'Visible'    , DefaultButtonData[j].Visible     );
          ControlButtonData[j].Left        := Ini.ReadInteger('Buttons', n + 'Left'       , DefaultButtonData[j].Left        );
          ControlButtonData[j].Top         := Ini.ReadInteger('Buttons', n + 'Top'        , DefaultButtonData[j].Top         );
          ControlButtonData[j].Width       := Ini.ReadInteger('Buttons', n + 'Width'      , DefaultButtonData[j].Width       );
          ControlButtonData[j].Height      := Ini.ReadInteger('Buttons', n + 'Height'     , DefaultButtonData[j].Height      );
        end;

  finally
        ini.free;
  end;

  if Not LoadGraphicFromBaseName(CompleteBitmap, DirName + '\main', false) then
  begin
      CompleteBitmap.Width := 10;
      CompleteBitmap.Height := 10;
      CompleteBitmap.Canvas.Brush.Color := SkinColorScheme.FormCL;
      CompleteBitmap.Canvas.Pen.Color := SkinColorScheme.LabelCL;
      CompleteBitmap.Canvas.FillRect(CompleteBitmap.Canvas.ClipRect);
  end;


  if UseSeparatePlayerBitmap then
  begin
      if not LoadGraphicFromBaseName(PlayerBitmap, DirName + '\player', False) then
      begin
          PlayerBitmap.Width := 10;
          PlayerBitmap.Height := 10;
          PlayerBitmap.Canvas.Brush.Color := SkinColorScheme.FormCL;
          PlayerBitmap.Canvas.Pen.Color := SkinColorScheme.LabelCL;
          PlayerBitmap.Canvas.FillRect(PlayerBitmap.Canvas.ClipRect);
      end;
      if not LoadGraphicFromBaseName(ExtendedPlayerBitmap, DirName + '\extendedplayer', true) then
      begin
          ExtendedPlayerBitmap.Width := 10;
          ExtendedPlayerBitmap.Height := 10;
          ExtendedPlayerBitmap.Canvas.Brush.Color := SkinColorScheme.FormCL;
          ExtendedPlayerBitmap.Canvas.Pen.Color := SkinColorScheme.LabelCL;
          ExtendedPlayerBitmap.Canvas.FillRect(ExtendedPlayerBitmap.Canvas.ClipRect);
      end;



  end;




  if Not Complete then exit;

  //LoadButtons;
/////  LoadSlideButtons;

  ListenCompletebmp := TBitmap.Create;
  if FileExists(DirName + '\ListenBilder.bmp') then
  begin

      try
        aStream := TFileStream.Create(DirName + '\ListenBilder.bmp', fmOpenRead or fmShareDenyWrite);
        ListenCompletebmp.LoadFromStream(aStream);
        aStream.free;
      except

      end;
  end
  else
    if FileExists(DirName + '\ListenBilder.jpg') then
    begin
      tmpjpg := TJpegImage.Create;
      try
        aStream := TFileStream.Create(DirName + '\ListenBilder.jpg', fmOpenRead or fmShareDenyWrite);
        tmpjpg.LoadFromStream(aStream);
        aStream.free;
        ListenCompletebmp.Assign(tmpjpg);
      except

      end;
      tmpjpg.Free;
    end
    else
    begin
      ListenCompletebmp.Assign(NIl);
      UseDefaultListImages := True;
    end;
  if Not UseDefaultListImages then
  begin
      ButtonTmp := TBitmap.Create;
      Buttontmp.PixelFormat := pf32bit;
      ButtonTmp.Width := 14;
      Buttontmp.Height := 14;
      Nemp_MainForm.PlayListSkinImageList.Clear;
      for i := 0 to 10 do
      begin
        ButtonTmp.Canvas.CopyRect(
            rect(0,0,14,14), ListenCompletebmp.Canvas,
            rect(i*14,0,i*14+14, ButtonTmp.Height));
        Nemp_MainForm.PlayListSkinImageList.AddMasked(ButtonTmp,Buttontmp.Canvas.Pixels[0,0]);
      end;
      ButtonTmp.Free;
      Nemp_MainForm.PlaylistVST.Images := Nemp_MainForm.PlayListSkinImageList;
      Nemp_MainForm.VST.Images := Nemp_MainForm.PlayListSkinImageList;
  end else
  begin
    Nemp_MainForm.PlaylistVST.Images := Nemp_MainForm.PlayListImageList;
    Nemp_MainForm.VST.Images := Nemp_MainForm.PlayListImageList;
  end;
  ListenCompletebmp.Free;


  {if UseSkinGraphics then
            BaseDir := Path + '\'
        else
            BaseDir := ExtractFilePath(ParamStr(0)) + 'Images\';}
  // Change in Nemp 4.0: The Graphics MUST be there. No Fallback to Default-Stars

  //if FileExists(DirName + '\starset.bmp') and FileExists(DirName + '\starunset.bmp') then
  //begin
      //SetStarBitmap.LoadFromFile(DirName + '\starset.bmp');
      //UnSetStarBitmap.LoadFromFile(DirName + '\starunset.bmp');



      {
      LoadGraphicFromBaseName(SetStarBitmap, DirName + '\starset'); // SetStarBitmap.LoadFromFile(DirName + '\starset.bmp');
      LoadGraphicFromBaseName(UnSetStarBitmap, DirName + '\starunset');// UnSetStarBitmap.LoadFromFile(DirName + '\starunset.bmp');
      //if FileExists(DirName + '\starhalfset.bmp') then
      //    HalfStarBitmap.LoadFromFile(DirName + '\starhalfset.bmp')
      LoadGraphicFromBaseName(HalfStarBitmap, DirName + '\starhalfset'); //HalfStarBitmap.LoadFromFile(DirName + '\starhalfset.bmp')
      SetStarBitmap.Transparent := True;
      UnSetStarBitmap.Transparent := True;
      HalfStarBitmap.Transparent := True;
      RatingGraphics.SetStars(SetStarBitmap, HalfStarBitmap, UnSetStarBitmap);


      LoadGraphicFromBaseName(SetStarBitmap, DirName + '\starset', True);
      LoadGraphicFromBaseName(UnSetStarBitmap, DirName + '\starunset', True);
      LoadGraphicFromBaseName(HalfStarBitmap, DirName + '\starhalfset', True);
      SetStarBitmap.Transparent := True;
      UnSetStarBitmap.Transparent := True;
      HalfStarBitmap.Transparent := True;

      PlayerRatingGraphics.SetStars(SetStarBitmap, HalfStarBitmap, UnSetStarBitmap);
      }




      //else
          //HalfStarBitmap.LoadFromFile(DirName + '\starset.bmp');
        //LoadGraphicFromBaseName(HalfStarBitmap, DirName + '\starset'); // HalfStarBitmap.LoadFromFile(DirName + '\starset.bmp')
  {end else
  begin
      SetStarBitmap.Assign(Nil);
      HalfStarBitmap.Assign(Nil);
      UnSetStarBitmap.Assign(Nil);

      SetStarBitmap.Transparent := True;
      UnSetStarBitmap.Transparent := True;
      HalfStarBitmap.Transparent := True;

      Nemp_MainForm.PlayListImageList.GetBitmap(11, SetStarBitmap);
      Nemp_MainForm.PlayListImageList.GetBitmap(12, HalfStarBitmap);
      Nemp_MainForm.PlayListImageList.GetBitmap(13, UnSetStarBitmap);
  end;
  }


end;

procedure TNempSkin.SaveToDir(DirName: UnicodeString);
var idx: integer;
  ini: TMemIniFile;
  SectionStr, n: String;
  j: TControlButtons;
begin
  ini := TMeminiFile.Create(DirName + '\skin.ini', TEncoding.UTF8);
  try
        ini.Encoding := TEncoding.UTF8;
        Ini.WriteBool('BackGround','HideBackgroundImageVorauswahl'   , NOT UseBackGroundImageVorauswahl    );
        Ini.WriteBool('BackGround','HideBackgroundImagePlaylist'     , NOT UseBackgroundImagePlaylist   );
        Ini.WriteBool('BackGround','HideBackgroundImageMedienliste'  , NOT UseBackgroundImageMedienliste);
        Ini.WriteBool('BackGround','HideBackgroundTagCloud'          , Not UseBackgroundTagCloud);
        ini.WriteBool('BackGround','TileBackground'                  , TileBackground);
        ini.WriteBool('BackGround','FixedBackGround'                  , FixedBackGround);

        Ini.WriteInteger('BackGround','PlayerPageOffsetX', PlayerPageOffsetXOrig);
        Ini.WriteInteger('BackGround','PlayerPageOffsetY', PlayerPageOffsetYOrig);
        //
        //--------------------------
        //
        Ini.WriteBool('Options', 'boldFont'                       , boldFont);
        Ini.WriteBool('Options','DrawGroupboxFrames'              , DrawGroupboxFrames      );
        Ini.WriteBool('Options','DrawGroupboxFramesMain'              , DrawGroupboxFramesMain);
        Ini.WriteBool('Options','HideTabText'                     , HideTabText             );
        Ini.WriteBool('Options','DrawTransparentTabText'          , DrawTransparentTabText  );
        Ini.WriteBool('Options','DrawTransparentLabel'            , DrawTransparentLabel    );
        Ini.WriteBool('Options','DrawTransparentTitel'            , DrawTransparentTitel    );
        Ini.WriteBool('Options','DrawTransparentTime'             , DrawTransparentTime     );
        //----
        Ini.WriteBool('Options','DisableBitrateColorsPlaylist'    , DisableBitrateColorsPlaylist    );
        Ini.WriteBool('Options','DisableBitrateColorsMedienliste' , DisableBitrateColorsMedienliste );
        //----
        Ini.WriteBool('Options','DisableArtistScrollbar'          , DisableArtistScrollbar     );
        Ini.WriteBool('Options','DisableAlbenScrollbar'           , DisableAlbenScrollbar      );
        Ini.WriteBool('Options','DisablePlaylistScrollbar'        , DisablePlaylistScrollbar   );
        Ini.WriteBool('Options','DisableMedienListeScrollbar'     , DisableMedienListeScrollbar);
        //----
        Ini.WriteBool('Options','UseBlendedSelectionArtists'      , UseBlendedSelectionArtists     );
        Ini.WriteBool('Options','UseBlendedSelectionAlben'        , UseBlendedSelectionAlben       );
        Ini.WriteBool('Options','UseBlendedSelectionPlaylist'     , UseBlendedSelectionPlaylist    );
        Ini.WriteBool('Options','UseBlendedSelectionMedienliste'  , UseBlendedSelectionMedienliste );
        Ini.WriteBool('Options','UseBlendedSelectionTagCloud'     , UseBlendedSelectionTagCloud    );

        Ini.WriteBool('Options','UseBlendedArtists'      , UseBlendedArtists     );
        Ini.WriteBool('Options','UseBlendedAlben'        , UseBlendedAlben       );
        Ini.WriteBool('Options','UseBlendedPlaylist'     , UseBlendedPlaylist    );
        Ini.WriteBool('Options','UseBlendedMedienliste'  , UseBlendedMedienliste );
        Ini.WriteBool('Options','UseBlendedTagCloud'     , UseBlendedTagCloud    );

        //----
        Ini.WriteBool('Options','HideMainMenu'  , HideMainMenu);
        Ini.WriteInteger('Options', 'ButtonMode', ButtonMode);
        // Ini.WriteBool('Options','UseDefaultButtons', UseDefaultButtons);
        Ini.WriteInteger('Options', 'SlideButtonMode', SlideButtonMode);
        //Ini.WriteBool('Options','UseDefaultSlideButtons', UseDefaultSlideButtons);
        Ini.WriteBool('Options','UseDefaultListImages', UseDefaultListImages);
        Ini.WriteBool('Options','UseDefaultStarBitmaps', UseDefaultStarBitmaps);

        Ini.WriteBool('Options', 'UseSeparatePlayerBitmap', UseSeparatePlayerBitmap);
        //----
        Ini.WriteInteger('Options','BlendFaktorArtists'       , BlendFaktorArtists    );
        Ini.WriteInteger('Options','BlendFaktorAlben'         , BlendFaktorAlben      );
        Ini.WriteInteger('Options','BlendFaktorPlaylist'      , BlendFaktorPlaylist   );
        Ini.WriteInteger('Options','BlendFaktorMedienliste'   , BlendFaktorMedienliste);
        Ini.WriteInteger('Options','BlendFaktorTagCloud'      , BlendFaktorTagCloud);

        Ini.WriteInteger('Options','BlendFaktorArtists2'       , BlendFaktorArtists2    );
        Ini.WriteInteger('Options','BlendFaktorAlben2'         , BlendFaktorAlben2      );
        Ini.WriteInteger('Options','BlendFaktorPlaylist2'      , BlendFaktorPlaylist2   );
        Ini.WriteInteger('Options','BlendFaktorMedienliste2'   , BlendFaktorMedienliste2);
        Ini.WriteInteger('Options','BlendFaktorTagCloud2'      , BlendFaktorTagCloud2   );

        // Farbwert in einen String der Form $XXXXXXXX bringen:      '$'+InttoHex(Integer(  ),8)
        // (damit die Vordefinierten Farben AUCH SO gespeichert werden, und nicht als Farbname wie "clblack")


        Ini.WriteString('Colors','FormCL'               , '$'+InttoHex(Integer( SkinColorScheme.FormCL                ),8)  );
        Ini.WriteString('Colors','TabTextCL'            , '$'+InttoHex(Integer( SkinColorScheme.TabTextCL             ),8)  );
        Ini.WriteString('Colors','TabTextBackGroundCL'  , '$'+InttoHex(Integer( SkinColorScheme.TabTextBackGroundCL   ),8)  );
        Ini.WriteString('Colors','SpecTitelCL'          , '$'+InttoHex(Integer( SkinColorScheme.SpecTitelCL           ),8)  );

        Ini.WriteString('Colors','SpecTimeCL'           , '$'+InttoHex(Integer( SkinColorScheme.SpecTimeCL            ),8)  );
        Ini.WriteString('Colors','SpecTitelBackGroundCL', '$'+InttoHex(Integer( SkinColorScheme.SpecTitelBackGroundCL ),8)  );
        Ini.WriteString('Colors','SpecTimeBackGroundCL' , '$'+InttoHex(Integer( SkinColorScheme.SpecTimeBackGroundCL  ),8)  );
        Ini.WriteString('Colors','SpecPenCL'            , '$'+InttoHex(Integer( SkinColorScheme.SpecPenCL             ),8)  );
        Ini.WriteString('Colors','SpecPen2CL'            , '$'+InttoHex(Integer( SkinColorScheme.SpecPen2CL           ),8)  );
        Ini.WriteString('Colors','SpecPeakCL'           , '$'+InttoHex(Integer( SkinColorScheme.SpecPeakCL            ),8)  );
        Ini.WriteString('Colors','PreviewTitleColor'    ,  '$'+InttoHex(Integer( SkinColorScheme.PreviewTitleColor    ),8)  );
        Ini.WriteString('Colors','PreviewArtistColor'   ,  '$'+InttoHex(Integer( SkinColorScheme.PreviewArtistColor   ),8)  );
        Ini.WriteString('Colors','PreviewTimeColor'     ,  '$'+InttoHex(Integer( SkinColorScheme.PreviewTimeColor     ),8)  );

        Ini.WriteString('Colors','LabelCL'              , '$'+InttoHex(Integer( SkinColorScheme.LabelCL               ),8)  );
        Ini.WriteString('Colors','LabelBackGroundCL'    , '$'+InttoHex(Integer( SkinColorScheme.LabelBackGroundCL     ),8)  );
        Ini.WriteString('Colors','GroupboxFrameCL'      , '$'+InttoHex(Integer( SkinColorScheme.GroupboxFrameCL       ),8)  );
        Ini.WriteString('Colors','MemoBackGroundCL'     , '$'+InttoHex(Integer( SkinColorScheme.MemoBackGroundCL      ),8)  );
        Ini.WriteString('Colors','MemoTextCL'           , '$'+InttoHex(Integer( SkinColorScheme.MemoTextCL            ),8)  );
        Ini.WriteString('Colors','ShapeBrushCL'         , '$'+InttoHex(Integer( SkinColorScheme.ShapeBrushCL          ),8)  );
        Ini.WriteString('Colors','ShapePenCL'           , '$'+InttoHex(Integer( SkinColorScheme.ShapePenCL            ),8)  );
        Ini.WriteString('Colors','Splitter1'            , '$'+InttoHex(Integer( SkinColorScheme.Splitter1Color   ),8)  );
        Ini.WriteString('Colors','Splitter2'            , '$'+InttoHex(Integer( SkinColorScheme.Splitter2Color   ),8)  );
        Ini.WriteString('Colors','Splitter3'            , '$'+InttoHex(Integer( SkinColorScheme.Splitter3Color   ),8)  );
        Ini.WriteString('Colors','PlaylistPlayingFileColor', '$'+InttoHex(Integer( SkinColorScheme.PlaylistPlayingFileColor),8)  );
        //Ini.WriteString('Colors','ControlImagesColor', '$'+InttoHex(Integer( SkinColorScheme.ControlImagesColor),8)  );

        Ini.WriteString('Colors','MinFontColor'   , '$'+InttoHex(Integer( SkinColorScheme.MinFontColor)   ,8)  );
        Ini.WriteString('Colors','MiddleFontColor', '$'+InttoHex(Integer( SkinColorScheme.MiddleFontColor),8)  );
        Ini.WriteString('Colors','MaxFontColor'   , '$'+InttoHex(Integer( SkinColorScheme.MaxFontColor)   ,8)  );
        Ini.WriteInteger('Colors', 'MiddleToMinComputing', SkinColorScheme.MiddleToMinComputing);
        Ini.WriteInteger('Colors', 'MiddleToMaxComputing', SkinColorScheme.MiddleToMaxComputing);

        for idx:= 0 to 15 do
          Ini.WriteString('DialogColors',CustomColorNames[idx]            , '$'+InttoHex(Integer( DialogCustomColors[idx]   ),8)  );


        // Farben für die Trees
        for idx := 1 to 4 do
        begin
            case idx of
                1: SectionStr := 'ArtistColors';
                2: SectionStr := 'AlbenColors';
                3: SectionStr := 'PlaylistColors';
               else SectionStr := 'MedienlisteColors';
            end;
            Ini.WriteString(SectionStr, 'Tree_Color'                        , '$'+InttoHex(Integer( SkinColorScheme.Tree_Color[idx]                         ),8) );
            Ini.WriteString(SectionStr, 'Tree_FontColor'                    , '$'+InttoHex(Integer( SkinColorScheme.Tree_FontColor[idx]                     ),8) );
            Ini.WriteString(SectionStr, 'Tree_FontColorSelected'            , '$'+InttoHex(Integer( SkinColorScheme.Tree_FontSelectedColor[idx]             ),8) );
            Ini.WriteString(SectionStr, 'Tree_HeaderBackgroundColor'        , '$'+InttoHex(Integer( SkinColorScheme.Tree_HeaderBackgroundColor[idx]         ),8) );
            Ini.WriteString(SectionStr, 'Tree_HeaderFontColor'              , '$'+InttoHex(Integer( SkinColorScheme.Tree_HeaderFontColor[idx]               ),8) );
            Ini.WriteString(SectionStr, 'Tree_BorderColor'                  , '$'+InttoHex(Integer( SkinColorScheme.Tree_BorderColor[idx]                   ),8) );
            Ini.WriteString(SectionStr, 'Tree_DisabledColor'                , '$'+InttoHex(Integer( SkinColorScheme.Tree_DisabledColor[idx]                 ),8) );
            Ini.WriteString(SectionStr, 'Tree_DropMarkColor'                , '$'+InttoHex(Integer( SkinColorScheme.Tree_DropMarkColor[idx]                 ),8) );
            Ini.WriteString(SectionStr, 'Tree_DropTargetBorderColor'        , '$'+InttoHex(Integer( SkinColorScheme.Tree_DropTargetBorderColor[idx]         ),8) );
            Ini.WriteString(SectionStr, 'Tree_DropTargetColor'              , '$'+InttoHex(Integer( SkinColorScheme.Tree_DropTargetColor[idx]               ),8) );
            Ini.WriteString(SectionStr, 'Tree_FocussedSelectionBorder'      , '$'+InttoHex(Integer( SkinColorScheme.Tree_FocussedSelectionBorder[idx]       ),8) );
            Ini.WriteString(SectionStr, 'Tree_FocussedSelectionColor'       , '$'+InttoHex(Integer( SkinColorScheme.Tree_FocussedSelectionColor[idx]        ),8) );
            Ini.WriteString(SectionStr, 'Tree_GridLineColor'                , '$'+InttoHex(Integer( SkinColorScheme.Tree_GridLineColor[idx]                 ),8) );
            Ini.WriteString(SectionStr, 'Tree_HeaderHotColor'               , '$'+InttoHex(Integer( SkinColorScheme.Tree_HeaderHotColor[idx]                ),8) );
            Ini.WriteString(SectionStr, 'Tree_HotColor'                     , '$'+InttoHex(Integer( SkinColorScheme.Tree_HotColor[idx]                      ),8) );
            Ini.WriteString(SectionStr, 'Tree_SelectionRectangleBlendColor' , '$'+InttoHex(Integer( SkinColorScheme.Tree_SelectionRectangleBlendColor[idx]  ),8) );
            Ini.WriteString(SectionStr, 'Tree_SelectionRectangleBorderColor', '$'+InttoHex(Integer( SkinColorScheme.Tree_SelectionRectangleBorderColor[idx] ),8) );
            Ini.WriteString(SectionStr, 'Tree_TreeLineColor'                , '$'+InttoHex(Integer( SkinColorScheme.Tree_TreeLineColor[idx]                 ),8) );
            Ini.WriteString(SectionStr, 'Tree_UnfocusedSelectionBorderColor', '$'+InttoHex(Integer( SkinColorScheme.Tree_UnfocusedSelectionBorderColor[idx] ),8) );
            Ini.WriteString(SectionStr, 'Tree_UnfocusedSelectionColor'      , '$'+InttoHex(Integer( SkinColorScheme.Tree_UnfocusedSelectionColor[idx]       ),8) );
        end;

        // Button-Eigenschaften
        for j := low(TControlbuttons) to High(TControlButtons) do
        begin
          n := DefaultButtonData[j].Name;
          Ini.WriteBool   ('Buttons', n + 'Visible'    , ControlButtonData[j].Visible     );
          Ini.WriteInteger('Buttons', n + 'Left'       , ControlButtonData[j].Left        );
          Ini.WriteInteger('Buttons', n + 'Top'        , ControlButtonData[j].Top         );
          Ini.WriteInteger('Buttons', n + 'Width'      , ControlButtonData[j].Width       );
          Ini.WriteInteger('Buttons', n + 'Height'     , ControlButtonData[j].Height      );
        end;
        try
            Ini.UpdateFile;
        except
            // Silent Exception
        end;
  finally
        ini.free;
  end;
end;

procedure TNempSkin.copyFrom(aSkin: TNempskin);
var idx: integer;
  tc: TControlButtons;

begin
  CompleteBitmap.Assign(askin.CompleteBitmap);
  PlayerBitmap.Assign(aSkin.PlayerBitmap);
  ExtendedPlayerBitmap.Assign(aSkin.ExtendedPlayerBitmap);

  for tc := low(TControlbuttons) to High(TControlButtons) do
  begin
    ControlButtonData[tc].Visible     := aSkin.ControlButtonData[tc].Visible     ;
    ControlButtonData[tc].Left        := aSkin.ControlButtonData[tc].Left        ;
    ControlButtonData[tc].Top         := aSkin.ControlButtonData[tc].Top         ;
    ControlButtonData[tc].Width       := aSkin.ControlButtonData[tc].Width       ;
    ControlButtonData[tc].Height      := aSkin.ControlButtonData[tc].Height      ;
  end;

  Name     := aSkin.Name    ;
  isActive := aSkin.isActive;
//
  PlayerPageOffsetXOrig := aSkin.PlayerPageOffsetXOrig;
  PlayerPageOffsetYOrig := aSkin.PlayerPageOffsetYOrig;
  PlayerPageOffsetX     := aSkin.PlayerPageOffsetX;
  PlayerPageOffsetY     := aSkin.PlayerPageOffsetY;

  //----
  UseBackGroundImageVorauswahl  := aSkin.UseBackGroundImageVorauswahl   ;
  UseBackgroundImagePlaylist    := aSkin.UseBackgroundImagePlaylist     ;
  UseBackgroundImageMedienliste := aSkin.UseBackgroundImageMedienliste  ;
  UseBackgroundTagCloud         := aSkin.UseBackgroundTagCloud          ;
  UseBackgroundImages[0] := True; // Player immer!
  UseBackgroundImages[1] := UseBackgroundImagePlaylist;
  UseBackgroundImages[2] := UseBackGroundImageVorauswahl;
  UseBackgroundImages[3] := UseBackgroundImageMedienliste;
  TileBackground         := aSkin.TileBackground;
  FixedBackGround        := aSkin.FixedBackGround;
  //
  //--------------------------
  //
  boldFont                       := aSkin.boldFont;
  DrawGroupboxFrames             := aSkin.DrawGroupboxFrames              ;
  DrawGroupboxFramesMain         := aSkin.DrawGroupboxFramesMain          ;
  HideTabText                    := aSkin.HideTabText                     ;
  DrawTransparentTabText         := aSkin.DrawTransparentTabText          ;
  DrawTransparentLabel           := aSkin.DrawTransparentLabel            ;
  DrawTransparentTitel           := aSkin.DrawTransparentTitel            ;
  DrawTransparentTime            := aSkin.DrawTransparentTime             ;
  //----
  DisableBitrateColorsPlaylist   := aSkin.DisableBitrateColorsPlaylist    ;
  DisableBitrateColorsMedienliste:= aSkin.DisableBitrateColorsMedienliste ;
  //----
  DisableArtistScrollbar         := aSkin.DisableArtistScrollbar          ;
  DisableAlbenScrollbar          := aSkin.DisableAlbenScrollbar           ;
  DisablePlaylistScrollbar       := aSkin.DisablePlaylistScrollbar        ;
  DisableMedienListeScrollbar    := aSkin.DisableMedienListeScrollbar     ;
  //----
  UseBlendedSelectionArtists     := aSkin.UseBlendedSelectionArtists      ;
  UseBlendedSelectionAlben       := aSkin.UseBlendedSelectionAlben        ;
  UseBlendedSelectionPlaylist    := aSkin.UseBlendedSelectionPlaylist     ;
  UseBlendedSelectionMedienliste := aSkin.UseBlendedSelectionMedienliste  ;

  UseBlendedArtists     := aSkin.UseBlendedArtists      ;
  UseBlendedAlben       := aSkin.UseBlendedAlben        ;
  UseBlendedPlaylist    := aSkin.UseBlendedPlaylist     ;
  UseBlendedMedienliste := aSkin.UseBlendedMedienliste  ;

  BlendFaktorArtists     := aSkin.BlendFaktorArtists              ;
  BlendFaktorAlben       := aSkin.BlendFaktorAlben                ;
  BlendFaktorPlaylist    := aSkin.BlendFaktorPlaylist             ;
  BlendFaktorMedienliste := aSkin.BlendFaktorMedienliste          ;

  BlendFaktorArtists2     := aSkin.BlendFaktorArtists2              ;
  BlendFaktorAlben2       := aSkin.BlendFaktorAlben2                ;
  BlendFaktorPlaylist2    := aSkin.BlendFaktorPlaylist2             ;
  BlendFaktorMedienliste2 := aSkin.BlendFaktorMedienliste2          ;

  //---

  HideMainMenu := aSkin.HideMainMenu;
  ButtonMode   := aSkin.ButtonMode;
  SlideButtonMode := aSkin.SlideButtonMode;
  UseDefaultListImages := aSkin.UseDefaultListImages;
  UseSeparatePlayerBitmap := aSkin.UseSeparatePlayerBitmap;
  UseDefaultStarBitmaps  := aSkin.UseDefaultStarBitmaps;

  ////
  with SkinColorScheme do
  begin
      FormCL                := aSkin.SkinColorScheme.FormCL                 ;
      TabTextCL             := aSkin.SkinColorScheme.TabTextCL              ;
      TabTextBackGroundCL   := aSkin.SkinColorScheme.TabTextBackGroundCL    ;
      SpecTitelCL           := aSkin.SkinColorScheme.SpecTitelCL            ;
      SpecTimeCL            := aSkin.SkinColorScheme.SpecTimeCL             ;
      SpecTitelBackGroundCL := aSkin.SkinColorScheme.SpecTitelBackGroundCL  ;
      SpecTimeBackGroundCL  := aSkin.SkinColorScheme.SpecTimeBackGroundCL   ;
      SpecPenCL             := aSkin.SkinColorScheme.SpecPenCL              ;
      SpecPen2CL            := aSkin.SkinColorScheme.SpecPen2CL             ;
      SpecPeakCL            := aSkin.SkinColorScheme.SpecPeakCL             ;
      LabelCL               := aSkin.SkinColorScheme.LabelCL                ;
      LabelBackGroundCL     := aSkin.SkinColorScheme.LabelBackGroundCL      ;
      GroupboxFrameCL       := aSkin.SkinColorScheme.GroupboxFrameCL        ;
      MemoBackGroundCL      := aSkin.SkinColorScheme.MemoBackGroundCL       ;
      MemoTextCL            := aSkin.SkinColorScheme.MemoTextCL             ;
      ShapeBrushCL          := aSkin.SkinColorScheme.ShapeBrushCL           ;
      ShapePenCL            := aSkin.SkinColorScheme.ShapePenCL             ;
      Splitter1Color        := aSkin.SkinColorScheme.Splitter1Color         ;
      Splitter2Color        := aSkin.SkinColorScheme.Splitter2Color         ;
      Splitter3Color        := aSkin.SkinColorScheme.Splitter3Color         ;
      PlaylistPlayingFileColor := aSkin.SkinColorScheme.PlaylistPlayingFileColor;

      MinFontColor    := aSkin.SkinColorScheme.MinFontColor;
      MiddleFontColor := aSkin.SkinColorScheme.MiddleFontColor;
      MaxFontColor    := aSkin.SkinColorScheme.MaxFontColor;
      MiddleToMinComputing := aSkin.SkinColorScheme.MiddleToMinComputing;
      MiddleToMaxComputing := aSkin.SkinColorScheme.MiddleToMaxComputing;

      
      for idx := 1 to 4 do
      begin
          Tree_Color[idx]                         := askin.SkinColorScheme.Tree_Color[idx]                         ;
          Tree_FontColor[idx]                     := askin.SkinColorScheme.Tree_FontColor[idx]                     ;
          Tree_FontSelectedColor[idx]             := askin.SkinColorScheme.Tree_FontSelectedColor[idx]             ;
          Tree_HeaderBackgroundColor[idx]         := askin.SkinColorScheme.Tree_HeaderBackgroundColor[idx]         ;
          Tree_HeaderFontColor[idx]               := askin.SkinColorScheme.Tree_HeaderFontColor[idx]               ;
          Tree_BorderColor[idx]                   := askin.SkinColorScheme.Tree_BorderColor[idx]                   ;
          Tree_DisabledColor[idx]                 := askin.SkinColorScheme.Tree_DisabledColor[idx]                 ;
          Tree_DropMarkColor[idx]                 := askin.SkinColorScheme.Tree_DropMarkColor[idx]                 ;
          Tree_DropTargetBorderColor[idx]         := askin.SkinColorScheme.Tree_DropTargetBorderColor[idx]         ;
          Tree_DropTargetColor[idx]               := askin.SkinColorScheme.Tree_DropTargetColor[idx]               ;
          Tree_FocussedSelectionBorder[idx]       := askin.SkinColorScheme.Tree_FocussedSelectionBorder[idx]       ;
          Tree_FocussedSelectionColor[idx]        := askin.SkinColorScheme.Tree_FocussedSelectionColor[idx]        ;
          Tree_GridLineColor[idx]                 := askin.SkinColorScheme.Tree_GridLineColor[idx]                 ;
          Tree_HeaderHotColor[idx]                := askin.SkinColorScheme.Tree_HeaderHotColor[idx]                ;
          Tree_HotColor[idx]                      := askin.SkinColorScheme.Tree_HotColor[idx]                      ;
          Tree_SelectionRectangleBlendColor[idx]  := askin.SkinColorScheme.Tree_SelectionRectangleBlendColor[idx]  ;
          Tree_SelectionRectangleBorderColor[idx] := askin.SkinColorScheme.Tree_SelectionRectangleBorderColor[idx] ;
          Tree_TreeLineColor[idx]                 := askin.SkinColorScheme.Tree_TreeLineColor[idx]                 ;
          Tree_UnfocusedSelectionBorderColor[idx] := askin.SkinColorScheme.Tree_UnfocusedSelectionBorderColor[idx] ;
          Tree_UnfocusedSelectionColor[idx]       := askin.SkinColorScheme.Tree_UnfocusedSelectionColor[idx]       ;
      end;
  end;
end;


Procedure TNempSkin.FitSkinToNewWindow;
begin
  RepairSkinOffset;
  SetArtistAlbumOffsets;
  SetPlaylistOffsets;
  SetVSTOffsets;
  UpdateSpectrumGraphics;
end;

Procedure TNempSkin.FitPlayerToNewWindow;
begin
  RepairSkinOffset;
  UpdateSpectrumGraphics;
end;


procedure TNempSkin.RepairSkinOffset;
var aPoint: TPoint;
begin
  if NOT FixedBackGround then
  begin
    aPoint := (Nemp_MainForm.TopMainPanel.ClientToScreen(Point(Nemp_MainForm.PlayerPanel.Left,Nemp_MainForm.PlayerPanel.Top)));
    PlayerPageOffsetX := aPoint.X + PlayerPageOffsetXOrig;
    PlayerPageOffsetY := aPoint.Y + PlayerPageOffsetYOrig;
  end else
  begin
    PlayerPageOffsetX := PlayerPageOffsetXOrig;
    PlayerPageOffsetY := PlayerPageOffsetYOrig;
  end;
end;


Procedure TNempSkin.SetArtistAlbumOffsets;
var pnlPoint, OffsetPoint: TPoint;
begin
  OffsetPoint := Nemp_MainForm.PlayerPanel.ClientToScreen(Point(0,0));

  pnlPoint := Nemp_MainForm.ArtistsVST.ClientToScreen(Point(0,0));
  Nemp_MainForm.ArtistsVST.BackgroundOffsetX := PlayerPageOffsetX + (pnlPoint.X - OffsetPoint.X);
  Nemp_MainForm.ArtistsVST.BackgroundOffsetY := PlayerPageOffsetY + (pnlPoint.Y - OffsetPoint.Y);


  pnlPoint := Nemp_MainForm.AlbenVST.ClientToScreen(Point(0,0));
  Nemp_MainForm.AlbenVST.BackgroundOffsetX := PlayerPageOffsetX + (pnlPoint.X - OffsetPoint.X);
  Nemp_MainForm.AlbenVST.BackgroundOffsetY := PlayerPageOffsetY + (pnlPoint.Y - OffsetPoint.Y);


  pnlPoint := Nemp_MainForm.PanelTagCloudBrowse.ClientToScreen(Point(0,0));
  TagCustomizer.OffSetX := PlayerPageOffsetX + (pnlPoint.X - OffsetPoint.X);
  TagCustomizer.OffSetY := PlayerPageOffsetY + (pnlPoint.Y - OffsetPoint.Y);

  Nemp_MainForm.PanelTagCloudBrowse.Repaint;

end;

procedure TNempSkin.SetVSTOffsets;
var pnlPoint, OffsetPoint, ImgPoint: TPoint;
begin
  OffsetPoint := Nemp_MainForm.PlayerPanel.ClientToScreen(Point(0,0));
  pnlPoint := Nemp_MainForm.VST.ClientToScreen(Point(0,0));

  ImgPoint := Nemp_MainForm.ImgBibRating.ClientToScreen(Point(0,0));
  Nemp_MainForm.VST.BackgroundOffsetX := PlayerPageOffsetX + (pnlPoint.X - OffsetPoint.X);
  Nemp_MainForm.VST.BackgroundOffsetY := PlayerPageOffsetY + (pnlPoint.Y - OffsetPoint.Y);

  Nemp_MainForm.BibRatingHelper.BackGroundBitmap.Width := Nemp_MainForm.ImgBibRating.Width;
  Nemp_MainForm.BibRatingHelper.BackGroundBitmap.Height := Nemp_MainForm.ImgBibRating.Height;
  TileGraphic(CompleteBitmap,
        Nemp_MainForm.BibRatingHelper.BackGroundBitmap.Canvas,
        PlayerPageOffsetX + (ImgPoint.X - OffsetPoint.X),
        PlayerPageOffsetY + (ImgPoint.Y - OffsetPoint.Y)
  );

  Nemp_MainForm.BibRatingHelper.ReDrawRatingInStarsOnBitmap(Nemp_MainForm.ImgBibRating.Picture.Bitmap);
end;

Procedure TNempSkin.SetPlaylistOffsets;
var pnlPoint, OffsetPoint: TPoint;
begin
  pnlPoint := Nemp_MainForm.PlayListVST.ClientToScreen(Point(0,0));
  OffsetPoint := Nemp_MainForm.PlayerPanel.ClientToScreen(Point(0,0));
  Nemp_MainForm.PlaylistVST.BackgroundOffsetX := PlayerPageOffsetX + (pnlPoint.X - OffsetPoint.X);
  Nemp_MainForm.PlaylistVST.BackgroundOffsetY := PlayerPageOffsetY + (pnlPoint.Y - OffsetPoint.Y);
end;

procedure TNempSkin.ActivateSkin;
var i, idx: integer;
  DestVST: TVirtualStringTree;
  j: TControlButtons;

begin
  isActive := True;
  //zunächst: Ownerdraw der Boxen/Panels setzen
  for i := 0 to Nemp_MainForm.ComponentCount - 1 do
  begin
    if Nemp_MainForm.Components[i] is TNempPanel then
    begin
      TNempPanel(Nemp_MainForm.Components[i]).OwnerDraw := True;
    end;
    // No Groupboxes any longer
    //if Nemp_MainForm.Components[i] is TNempGroupbox then
    //  TNempGroupbox(Nemp_MainForm.Components[i]).OwnerDraw := True;
  end;
  AuswahlForm.ContainerPanelAuswahlform.OwnerDraw := True;
  MedienListeForm.ContainerPanelMedienBibForm.OwnerDraw := True;
  PlaylistForm.ContainerPanelPlaylistForm.OwnerDraw := True;
  ExtendedControlForm.ContainerPanelExtendedControlsForm.OwnerDraw := True;

  LoadGraphicFromBaseName(NempPlayer.PreviewBackGround, path + '\Win7PreviewBackground', false);
  // Grafiken für die Buttons setzem
  with Nemp_MainForm do
  begin
        if Not UseDefaultListImages then
        begin
            PlaylistVST.Images := PlayListSkinImageList;
            VST.Images := PlayListSkinImageList;
        end else
        begin
            PlaylistVST.Images := PlayListImageList;
            VST.Images := PlayListImageList;
        end;

        case SlideButtonMode of
           0,1: begin
                  for i := 0 to 15 do
                  begin
                      SlideButtons[i].Button.DrawMode := dm_Windows;
                      SlideButtons[i].Button.CustomRegion := False;
                      SlideButtons[i].Button.Glyph.Assign(Nil);
                      SlideButtons[i].Button.Refresh;
                  end;
           end;

           2: begin
                  for i := 0 to 15 do
                  begin
                      SlideButtons[i].Button.DrawMode := dm_Skin;
                      AssignNemp3Glyph(SlideButtons[i].Button,
                            path + '\' + SlideButtons[i].GlyphFile, True);
                      SlideButtons[i].Button.CustomRegion := True;
                      SlideButtons[i].Button.Refresh;
                  end;
           end;
        end;

        // Buttons / Images konfigurieren.
        AssignButtonSizes;

        AssignStarGraphics;

        case ButtonMode of
            0: begin
                AssignWindowsGlyphs(False);
//                AssignDefaultSystemButtons;
                AssignWindowsTabGlyphs(False);
            end;

            1: begin
                AssignWindowsGlyphs(True);
//                AssignDefaultSystemButtons;
                AssignWindowsTabGlyphs(True);
            end;

            2: begin
                for j := low(TControlbuttons) to High(TControlbuttons) do
                begin
                    AssignNemp3Glyph(
                        ControlButtons[j],
                        Path + '\' + ControlButtonData[j].Name,
                        True);
                    ControlButtons[j].GlyphLine := ControlButtons[j].GlyphLine;
                end;

                AssignNemp3Glyph(
                        AuswahlForm.CloseImage,
                        Path + '\' + ControlButtonData[ctrlCloseBtn].Name,
                        True);
                    AuswahlForm.CloseImage.GlyphLine := AuswahlForm.CloseImage.GlyphLine;
                AssignNemp3Glyph(
                        MedienListeForm.CloseImage,
                        Path + '\' + ControlButtonData[ctrlCloseBtn].Name,
                        True);
                    MedienListeForm.CloseImage.GlyphLine := MedienListeForm.CloseImage.GlyphLine;
                AssignNemp3Glyph(
                        PlaylistForm.CloseImage,
                        Path + '\' + ControlButtonData[ctrlCloseBtn].Name,
                        True);
                    PlaylistForm.CloseImage.GlyphLine := PlaylistForm.CloseImage.GlyphLine;

                AssignNemp3Glyph(DirectionPositionBTN,  Path + '\BtnReverse', True);
                DirectionPositionBTN.GlyphLine := DirectionPositionBTN.GlyphLine;

                AssignNemp3Glyph(CB_MedienBibGlobalQuickSearch,  Path + '\BtnQuickSearch', True);
                CB_MedienBibGlobalQuickSearch.GlyphLine := CB_MedienBibGlobalQuickSearch.GlyphLine;

                AssignSkinTabGlyphs;
            end;
        end;
  end;

  // Eigenschaften der Bäume
  with Nemp_MainForm do
  begin
      Nemp_MainForm.BibRatingHelper.UsebackGround := True;

      if (UseBackGroundImageVorauswahl)  then ArtistsVST.Background.Assign(CompleteBitmap)
        else ArtistsVST.Background.Assign(Nil);
      if (UseBackGroundImageVorauswahl) then AlbenVST.Background.Assign(CompleteBitmap)
        else AlbenVST.Background.Assign(Nil);
      if (UseBackgroundImagePlaylist) then PlaylistVST.Background.Assign(CompleteBitmap)
        else PlaylistVST.Background.Assign(Nil);
      if (UseBackgroundImageMedienliste) then VST.Background.Assign(CompleteBitmap)
        else VST.Background.Assign(Nil);

      // Scrollbars
      if DisableArtistScrollbar then ArtistsVST.ScrollBarOptions.ScrollBars := ssNone
        else ArtistsVST.ScrollBarOptions.ScrollBars := ssVertical;
      if DisableAlbenScrollbar then AlbenVST.ScrollBarOptions.ScrollBars := ssNone
        else AlbenVST.ScrollBarOptions.ScrollBars := ssVertical;
      if DisablePlaylistScrollbar then PlaylistVST.ScrollBarOptions.ScrollBars := ssNone
        else PlaylistVST.ScrollBarOptions.ScrollBars := ssVertical;
      if DisableMedienListeScrollbar then VST.ScrollBarOptions.ScrollBars := ssNone
        else VST.ScrollBarOptions.ScrollBars := ssBoth;
      // Alphablending
      if UseBlendedSelectionArtists then
        ArtistsVST.TreeOptions.PaintOptions := ArtistsVST.TreeOptions.PaintOptions + [toUseBlendedSelection]
      else ArtistsVST.TreeOptions.PaintOptions := ArtistsVST.TreeOptions.PaintOptions - [toUseBlendedSelection];
      if UseBlendedSelectionAlben then
        AlbenVST.TreeOptions.PaintOptions := AlbenVST.TreeOptions.PaintOptions + [toUseBlendedSelection]
      else AlbenVST.TreeOptions.PaintOptions := AlbenVST.TreeOptions.PaintOptions - [toUseBlendedSelection];
      if UseBlendedSelectionPlaylist then
        PlaylistVST.TreeOptions.PaintOptions := PlaylistVST.TreeOptions.PaintOptions + [toUseBlendedSelection]
      else PlaylistVST.TreeOptions.PaintOptions := PlaylistVST.TreeOptions.PaintOptions - [toUseBlendedSelection];
      if UseBlendedSelectionMedienliste then
        VST.TreeOptions.PaintOptions := VST.TreeOptions.PaintOptions + [toUseBlendedSelection]
      else VST.TreeOptions.PaintOptions := VST.TreeOptions.PaintOptions - [toUseBlendedSelection];

      ArtistsVST.SelectionBlendFactor  := BlendFaktorArtists     ;
      AlbenVST.SelectionBlendFactor    := BlendFaktorAlben       ;
      PlaylistVST.SelectionBlendFactor := BlendFaktorPlaylist    ;
      VST.SelectionBlendFactor         := BlendFaktorMedienliste ;

      // TagCloud-Settings
      TagCustomizer.UseBackGround    := UseBackgroundTagCloud;
      if UseBackgroundTagCloud then
          TagCustomizer.BackgroundImage := CompleteBitmap
      else
          TagCustomizer.BackgroundImage := Nil;
      TagCustomizer.TileBackGround   := TileBackground;
      TagCustomizer.BackgroundColor  := SkinColorScheme.Tree_Color[1];
      TagCustomizer.FontColor        := SkinColorScheme.Tree_FontColor[1];
      TagCustomizer.FocusFontColor   := SkinColorScheme.Tree_FontSelectedColor[1];
      TagCustomizer.FocusBorderColor := SkinColorScheme.Tree_FocussedSelectionBorder[1];
      TagCustomizer.FocusBackgroundColor := SkinColorScheme.Tree_FocussedSelectionColor[1];
      TagCustomizer.HoverFontColor  := SkinColorScheme.Tree_FontSelectedColor[1];

          TagCustomizer.CloudUseAlphaBlend := UseBlendedTagCloud ;
          TagCustomizer.CloudBlendColor := SkinColorScheme.Tree_Color[1];
          TagCustomizer.CloudBlendIntensity := BlendFaktorTagCloud2;

          TagCustomizer.TagUseAlphaBlend := self.UseBlendedSelectionTagCloud ;
          TagCustomizer.TagBlendColor := SkinColorScheme.Tree_SelectionRectangleBlendColor[1];
          TagCustomizer.TagBlendIntensity := BlendFaktorTagCloud; // as in the Trees (set in the Object-Inspector)


      // Header
      ArtistsVST.Header.Options := ArtistsVST.Header.Options + [hoOwnerDraw];
      AlbenVST.Header.Options := AlbenVST.Header.Options + [hoOwnerDraw];
      PlaylistVST.Header.Options := PlaylistVST.Header.Options + [hoOwnerDraw];
      VST.Header.Options := VST.Header.Options + [hoOwnerDraw];

      // Farben
      for idx := 1 to 4 do
      begin
        case idx of
          1: DestVST := ArtistsVST;
          2: DestVST := AlbenVST;
          3: DestVST := PlaylistVST;
          else DestVST := VST;
        end;
        DestVST.Color                                  := SkinColorScheme.Tree_Color[idx]                        ;
        DestVST.Font.Color                             := SkinColorScheme.Tree_FontColor[idx]                    ;
        DestVST.Header.Background                      := SkinColorScheme.Tree_HeaderBackgroundColor[idx]        ;
        DestVST.Header.Font.Color                      := SkinColorScheme.Tree_HeaderFontColor[idx]              ;
        DestVST.Colors.BorderColor                     := SkinColorScheme.Tree_BorderColor[idx]                  ;
        DestVST.Colors.DisabledColor                   := SkinColorScheme.Tree_DisabledColor[idx]                ;
        DestVST.Colors.DropMarkColor                   := SkinColorScheme.Tree_DropMarkColor[idx]                ;
        DestVST.Colors.DropTargetBorderColor           := SkinColorScheme.Tree_DropTargetBorderColor[idx]        ;
        DestVST.Colors.DropTargetColor                 := SkinColorScheme.Tree_DropTargetColor[idx]              ;
        DestVST.Colors.FocusedSelectionBorderColor     := SkinColorScheme.Tree_FocussedSelectionBorder[idx]      ;
        DestVST.Colors.FocusedSelectionColor           := SkinColorScheme.Tree_FocussedSelectionColor[idx]       ;
        DestVST.Colors.GridLineColor                   := SkinColorScheme.Tree_GridLineColor[idx]                ;
        DestVST.Colors.HeaderHotColor                  := SkinColorScheme.Tree_HeaderHotColor[idx]               ;
        DestVST.Colors.HotColor                        := SkinColorScheme.Tree_HotColor[idx]                     ;
        DestVST.Colors.SelectionRectangleBlendColor    := SkinColorScheme.Tree_SelectionRectangleBlendColor[idx] ;
        DestVST.Colors.SelectionRectangleBorderColor   := SkinColorScheme.Tree_SelectionRectangleBorderColor[idx];
        DestVST.Colors.TreeLineColor                   := SkinColorScheme.Tree_TreeLineColor[idx]                ;
        DestVST.Colors.UnfocusedSelectionBorderColor   := SkinColorScheme.Tree_UnfocusedSelectionBorderColor[idx];
        DestVST.Colors.UnfocusedSelectionColor         := SkinColorScheme.Tree_UnfocusedSelectionColor[idx]      ;
      end;
  end;

  // Eigenschaften der Massenhaft auftretenden Sachen setzen
  // Hier jetzt auch in einer Schleife. Sollte leichter zu lesen sein.
  for i := 0 to Nemp_MainForm.ComponentCount - 1 do
  begin
    if Nemp_MainForm.Components[i] is TLabel then
    begin
      TLabel(Nemp_MainForm.Components[i]).Color := SkinColorScheme.LabelBackGroundCL;
      TLabel(Nemp_MainForm.Components[i]).Font.Color := SkinColorScheme.LabelCL;
      TLabel(Nemp_MainForm.Components[i]).Transparent := DrawTransparentLabel;
    end else
    if Nemp_MainForm.Components[i] is TLabel then
    begin
      TLabel(Nemp_MainForm.Components[i]).Color := SkinColorScheme.LabelBackGroundCL;
      TLabel(Nemp_MainForm.Components[i]).Font.Color := SkinColorScheme.LabelCL;
      TLabel(Nemp_MainForm.Components[i]).Transparent := DrawTransparentLabel;
    end else
    if Nemp_MainForm.Components[i] is TShape then
    begin
      TShape(Nemp_MainForm.Components[i]).Brush.Color := SkinColorScheme.ShapeBrushCL;
      TShape(Nemp_MainForm.Components[i]).Pen.Color := SkinColorScheme.ShapePenCL;
    end
{    else
    if Nemp_MainForm.Components[i] is TLabeledEdit then
    begin
      TLabeledEdit(Nemp_MainForm.Components[i]).EditLabel.Color := SkinColorScheme.LabelBackGroundCL;
      TLabeledEdit(Nemp_MainForm.Components[i]).EditLabel.Font.Color := SkinColorScheme.LabelCL;
      TLabeledEdit(Nemp_MainForm.Components[i]).EditLabel.Transparent := DrawTransparentLabel;
    end}
  end;

  // Weitere Eigenschaften der Form setzen
  with Nemp_MainForm do
  begin
    MedienBib.NewCoverFlow.SetColor(SkinColorScheme.FormCL);

    if boldFont then
    begin
      Spectrum.TextStyle := [fsBold];
      Spectrum.TimeStyle := [fsBold];
    end else
    begin
      Spectrum.TextStyle := [];
      Spectrum.TimeStyle := [];
    end;

    Color := SkinColorScheme.FormCL;
    Splitter1.Color := SkinColorScheme.Splitter1Color;
    Splitter2.Color := SkinColorScheme.Splitter2Color;
    Splitter3.Color := SkinColorScheme.Splitter3Color;
    Splitter4.Color := SkinColorScheme.Splitter1Color;

    //LblPlayerTitle.Font.Color := SkinColorScheme.SpecTitelCL;
    //LblPlayerArtist.Font.Color := SkinColorScheme.SpecTitelCL;
    //LblPlayerAlbum.Font.Color := SkinColorScheme.SpecTitelCL;

    LyricsMemo.Color := SkinColorScheme.MemoBackGroundCL;
    LyricsMemo.Font.Color := SkinColorScheme.MemoTextCL;
    Spectrum.TextColor := SkinColorScheme.SpecTitelCL;

    Spectrum.PreviewArtistColor := SkinColorScheme.PreviewArtistColor ;
    Spectrum.PreviewTitleColor  := SkinColorScheme.PreviewTitleColor  ;
    Spectrum.PreviewTimeColor   := SkinColorScheme.PreviewTimeColor   ;

    Spectrum.TimeColor := SkinColorScheme.SpecTimeCL;
    Spectrum.TitelBackColor := SkinColorScheme.SpecTitelBackGroundCL;
    Spectrum.TimebackColor := SkinColorScheme.SpecTimeBackGroundCL;
    Spectrum.Pen := SkinColorScheme.SpecPenCL;
    Spectrum.Pen2 := SkinColorScheme.SpecPen2CL;
    Spectrum.Peak := SkinColorScheme.SpecPeakCL;
    if DrawTransparentTime then Spectrum.TimeTextBackground := bsclear
      else Spectrum.TimeTextBackground := bssolid;
    if DrawTransparentTitel then Spectrum.TitelTextBackground := bsclear
      else Spectrum.TitelTextBackground := bssolid;

    if (HideMainMenu) or (Nemp_MainForm.AnzeigeMode = 1) then
      Menu := NIL
    else
      Menu := Nemp_MainMenu;
  end;

  // Dann: Hintergrundgrafiken-Offsets für die Trees initialisieren
  SetArtistAlbumOffsets;
  SetVSTOffsets;
  SetPlaylistOffsets;

  // Spectrum-Hintergrund setzen
  UpdateSpectrumGraphics;
  Nemp_MainForm.RepaintVisOnPause;

end;


procedure TNempSkin.DeActivateSkin;
var i, idx: integer;
  DestVST: TVirtualStringTree;

begin
  isActive := False;
  //zunächst: Ownerdraw der Boxen/Panels setzen
  with Nemp_MainForm do
  begin
    for i := 0 to Nemp_MainForm.ComponentCount - 1 do
    begin
      //if Components[i] is TNempGroupbox then
      //  TNempGroupbox(Nemp_MainForm.Components[i]).OwnerDraw := False;
      if Nemp_MainForm.Components[i] is TNempPanel then
        TNempPanel(Nemp_MainForm.Components[i]).OwnerDraw := False;
    end;
  end;
  AuswahlForm.ContainerPanelAuswahlform.OwnerDraw := False;
  MedienListeForm.ContainerPanelMedienBibForm.OwnerDraw := False;
  PlaylistForm.ContainerPanelPlaylistForm.OwnerDraw := False;
  ExtendedControlForm.ContainerPanelExtendedControlsForm.OwnerDraw := False;

  // Grafiken für die Buttons setzen
  with Nemp_MainForm do
  begin
        PlaylistVST.Images := PlayListImageList;
        VST.Images := PlayListImageList;

        SetDefaultButtonSizes;
        AssignButtonSizes;

        AssignWindowsGlyphs(False);
        //System-Grafiken
//        AssignDefaultSystemButtons;
        AssignWindowsTabGlyphs(False);

        AssignStarGraphics;

        for i := 0 to 15 do
        begin
            SlideButtons[i].Button.DrawMode := dm_Windows;
            SlideButtons[i].Button.CustomRegion := False;
            SlideButtons[i].Button.Glyph.Assign(Nil);
            SlideButtons[i].Button.Refresh;
        end;

        // Note to Self: Is this OK? Overwrite Star-Graphics with Windows-Default??
        //SetStarBitmap.Assign(Nil);
        //HalfStarBitmap.Assign(Nil);
        //UnSetStarBitmap.Assign(Nil);
        //PlayListImageList.GetBitmap(11, SetStarBitmap);
        //PlayListImageList.GetBitmap(12, HalfStarBitmap);
        //PlayListImageList.GetBitmap(13, UnSetStarBitmap);
        //RatingGraphics.SetStars(SetStarBitmap, HalfStarBitmap, UnSetStarBitmap);

  end;


  // Eigenschaften der Bäume
  with Nemp_MainForm do
  begin
      ArtistsVST.Background.Assign(Nil);
      AlbenVST.Background.Assign(Nil);
      PlaylistVST.Background.Assign(Nil);
      VST.Background.Assign(Nil);
      BibRatingHelper.UsebackGround := False;

      BibRatingHelper.ReDrawRatingInStarsOnBitmap(ImgBibRating.Picture.Bitmap);

      TagCustomizer.UseBackGround := False;
      TagCustomizer.TileBackGround:= False;
      TagCustomizer.BackgroundImage := Nil;

//      VDTCover.Background.Assign(Nil);
      // AlphaBlending
      ArtistsVST.TreeOptions.PaintOptions := ArtistsVST.TreeOptions.PaintOptions - [toUseBlendedSelection];
      AlbenVST.TreeOptions.PaintOptions := AlbenVST.TreeOptions.PaintOptions - [toUseBlendedSelection];
      PlaylistVST.TreeOptions.PaintOptions := PlaylistVST.TreeOptions.PaintOptions - [toUseBlendedSelection];
      VST.TreeOptions.PaintOptions := VST.TreeOptions.PaintOptions - [toUseBlendedSelection];
//      VDTCover.TreeOptions.PaintOptions := VDTCover.TreeOptions.PaintOptions - [toUseBlendedSelection];
      // Scrollbars
      ArtistsVST.ScrollBarOptions.ScrollBars := ssVertical;
      AlbenVST.ScrollBarOptions.ScrollBars := ssVertical;
      PlaylistVST.ScrollBarOptions.ScrollBars := ssVertical;
      VST.ScrollBarOptions.ScrollBars := ssBoth;
      // Header
      ArtistsVST.Header.Options := ArtistsVST.Header.Options - [hoOwnerDraw];
      AlbenVST.Header.Options := AlbenVST.Header.Options - [hoOwnerDraw];
      PlaylistVST.Header.Options := PlaylistVST.Header.Options - [hoOwnerDraw];
      VST.Header.Options := VST.Header.Options - [hoOwnerDraw];

      TagCustomizer.UseBackGround    := False;
      TagCustomizer.BackgroundColor  := clWindow;
      TagCustomizer.FontColor        := clWindowText;
      TagCustomizer.FocusFontColor   := clWindowText;
      TagCustomizer.FocusBorderColor := clHotlight;
      TagCustomizer.FocusBackgroundColor := clHighlight;
      TagCustomizer.HoverFontColor  := clHighlight;

      TagCustomizer.CloudUseAlphaBlend := False ;
      TagCustomizer.CloudBlendColor := clHighlight;
      TagCustomizer.CloudBlendIntensity := 0;

      TagCustomizer.TagUseAlphaBlend := False ;
      TagCustomizer.TagBlendColor := clHighlight;
      TagCustomizer.TagBlendIntensity := 0;


      // Farben
      for idx := 1 to 5 do
      begin
        case idx of
          1: DestVST := ArtistsVST;
          2: DestVST := AlbenVST;
          3: DestVST := PlaylistVST;
          else DestVST := VST;
        end;
        DestVST.Color                                  := clWindow;
        DestVST.Font.Color                             := clWindowText;
        DestVST.Header.Background                      := clWindow;
        DestVST.Header.Font.Color                      := clWindowText;
        DestVST.Colors.BorderColor                     := clBtnFace;
        DestVST.Colors.DisabledColor                   := clBtnShadow;
        DestVST.Colors.DropMarkColor                   := clHighlight;
        DestVST.Colors.DropTargetBorderColor           := clHighlight;
        DestVST.Colors.DropTargetColor                 := clHighlight;
        DestVST.Colors.FocusedSelectionBorderColor     := clHighlight;
        DestVST.Colors.FocusedSelectionColor           := clHighlight;
        DestVST.Colors.GridLineColor                   := clBtnFace;
        DestVST.Colors.HeaderHotColor                  := clBtnShadow;
        DestVST.Colors.HotColor                        := clWindowText;
        DestVST.Colors.SelectionRectangleBlendColor    := clHighlight;
        DestVST.Colors.SelectionRectangleBorderColor   := clHighlight;
        DestVST.Colors.TreeLineColor                   := clBtnShadow;
        DestVST.Colors.UnfocusedSelectionBorderColor   := clBtnFace;
        DestVST.Colors.UnfocusedSelectionColor         := clBtnFace;
      end;
{      VDTCover.Color                                  := clWindow;
      VDTCover.Font.Color                             := clWindowText;
      VDTCover.Header.Background                      := clWindow;
      VDTCover.Header.Font.Color                      := clWindowText;
      VDTCover.Colors.BorderColor                     := clBtnFace;
      VDTCover.Colors.DisabledColor                   := clBtnShadow;
      VDTCover.Colors.DropMarkColor                   := clHighlight;
      VDTCover.Colors.DropTargetBorderColor           := clHighlight;
      VDTCover.Colors.DropTargetColor                 := clHighlight;
      VDTCover.Colors.FocusedSelectionBorderColor     := clHighlight;
      VDTCover.Colors.FocusedSelectionColor           := clHighlight;
      VDTCover.Colors.GridLineColor                   := clBtnFace;
      VDTCover.Colors.HeaderHotColor                  := clBtnShadow;
      VDTCover.Colors.HotColor                        := clWindowText;
      VDTCover.Colors.SelectionRectangleBlendColor    := clHighlight;
      VDTCover.Colors.SelectionRectangleBorderColor   := clHighlight;
      VDTCover.Colors.TreeLineColor                   := clBtnShadow;
      VDTCover.Colors.UnfocusedSelectionBorderColor   := clBtnFace;
      VDTCover.Colors.UnfocusedSelectionColor         := clBtnFace;
 }
  end;

  // Eigenschaften der Massenhaft auftretenden Sachen setzen
  // Hier jetzt auch in einer Schleife. Sollte leichter zu lesen sein.
  for i := 0 to Nemp_MainForm.ComponentCount - 1 do
  begin
    if Nemp_MainForm.Components[i] is TLabel then
    begin
      TLabel(Nemp_MainForm.Components[i]).Color := clBtnFace;
      TLabel(Nemp_MainForm.Components[i]).Font.Color := clWindowText;
      TLabel(Nemp_MainForm.Components[i]).Transparent := True;
    end else
    if Nemp_MainForm.Components[i] is TLabel then
    begin
      TLabel(Nemp_MainForm.Components[i]).Color := clBtnFace;
      TLabel(Nemp_MainForm.Components[i]).Font.Color := clWindowText;
      TLabel(Nemp_MainForm.Components[i]).Transparent := True;
    end else
    if Nemp_MainForm.Components[i] is TShape then
    begin
      TShape(Nemp_MainForm.Components[i]).Brush.Color := clGradientActiveCaption;
      TShape(Nemp_MainForm.Components[i]).Pen.Color := clBlack;
    end
{    else
    if Nemp_MainForm.Components[i] is TLabeledEdit then
    begin
      TLabeledEdit(Nemp_MainForm.Components[i]).EditLabel.Color := clBtnFace;
      TLabeledEdit(Nemp_MainForm.Components[i]).EditLabel.Font.Color := clWindowText;
      TLabeledEdit(Nemp_MainForm.Components[i]).EditLabel.Transparent := True;
    end
}
  end;

  MedienBib.NewCoverFlow.SetColor(clWhite);
  
  // Weitere Eigenschaften der Form setzen
  with Nemp_MainForm do
  begin
    Color := clBtnFace;
    Splitter1.Color := clBtnFace;
    Splitter2.Color := clBtnFace;
    Splitter3.Color := clBtnFace;
    Splitter4.Color := clBtnFace;
    LyricsMemo.Color := clWindow;
    LyricsMemo.Font.Color := clWindowText;
    Spectrum.TextColor := clWindowText;
    Spectrum.TimeColor := clWindowText;
    Spectrum.TitelBackColor := clBtnFace;
    Spectrum.TimebackColor := clBtnFace;

    Spectrum.PreviewArtistColor := clGrayText;
    Spectrum.PreviewTitleColor  := clWindowText;
    Spectrum.PreviewTimeColor   := clWindowText;

    Spectrum.TextStyle := [];
    Spectrum.TimeStyle := [];
    Spectrum.Pen := clActiveCaption;
    Spectrum.Peak := clBackground;
    Spectrum.UseBackGround := False;
    Spectrum.TitelTextBackground := bsclear;
    Spectrum.TimeTextBackground := bsclear;
    Spectrum.SetGradientBitmap;
    Spectrum.DrawRating(RatingImage.Tag);
    RepaintVisOnPause;

    if Nemp_MainForm.AnzeigeMode = 0 then
      Menu := Nemp_MainMenu;
  end;
end;


procedure TNempskin.TileGraphic(const ATile: TBitmap; const ATarget: TCanvas; X, Y: Integer; Stretch: Boolean = False);
var
  xstart, xloop, yloop: Integer;
  f: Single;
begin
  if ATile.Width * ATile.Height = 0 then exit;

  // Stretch is used only for the player-part, if a seperate bitmap is used there
  if Stretch then
      f := NempPartyMode.ResizeFactor
  else
      f := 1;

  if TileBackground{ AND UseBitmap} then
  begin
      xloop := X Mod aTile.Width;
      if xloop < 0 then xloop := xloop + aTile.Width;

      xloop := -xloop;
      xstart := xloop;

      Yloop := Y Mod aTile.Height;
      if yloop < 0 then yloop := yloop + aTile.Height;

      yloop := - yloop;

      while Yloop < ATarget.ClipRect.Bottom  do
      begin
        Xloop := xstart;
        while Xloop < ATarget.ClipRect.Right do
        begin
            ATarget.StretchDraw(Rect(XLoop, YLoop, XLoop + Round(ATile.Width * f), yLoop + Round(ATile.Height * f) ), ATile);
            Inc(Xloop, Round(ATile.Width * f));
        end;
        Inc(Yloop, Round(ATile.Height * f));
      end;
  end else
  begin
    ATarget.Brush.Color := SkinColorScheme.FormCL;
    ATarget.FillRect(ATarget.ClipRect);
   { if UseBitmap then}
      ATarget.Draw(-x, -y, ATile);
  end;
end;

 (*    // Dont delete yet - i may need some parts for drawing the new Panels!
procedure TNempSkin.DrawGroupboxFrame(aGroupbox: TNempGroupbox);
begin
  aGroupbox.Canvas.Pen.Width := 1;
  aGroupbox.Canvas.Pen.Color := SkinColorScheme.GroupboxFrameCL;
  aGroupbox.Canvas.Brush.style := bsclear;
  aGroupbox.Canvas.Roundrect(1,1, aGroupbox.Width-1, aGroupbox.Height-1,6,6);
end;


procedure TNempSkin.DrawAGroupbox(aGroupbox: TNempGroupbox; UseBackground: Boolean = True);
var grpPoint, OffsetPoint: TPoint;
    sourceBmp: TBitmap;
    localOffsetX, localOffsetY: Integer;
    localdrawFrame: Boolean;
begin
  grpPoint := aGroupbox.ClientToScreen(Point(0,0));
  OffsetPoint := Nemp_MainForm.PlayerPanel.ClientToScreen(Point(0,0));

  if (aGroupbox.Tag = 0) and UseSeparatePlayerBitmap then
  begin
      // Player-Teil gesondert behandelr
      localOffsetX := 0;
      localOffsetY := 0;
      sourceBmp := PlayerBitmap;
  end else
      {  // there are no groupboxes in ExControls
      if (aGroupbox.Tag = 5) and UseSeparateExControlsBitmap then
      begin
          // Player-Teil gesondert behandelr
          localOffsetX := - grpPoint.X + OffsetPoint.X;
          localOffsetY := - grpPoint.Y + OffsetPoint.Y;
          sourceBmp := ExControlsBitmap;
      end
      else  }
      begin
          localOffsetX := PlayerPageOffsetX;
          localOffsetY := PlayerPageOffsetY;
          sourceBmp := CompleteBitmap;
      end;

  if (aGroupbox.Tag = 0) then
    localDrawFrame := DrawGroupboxFramesMain
  else
    localDrawFrame := DrawGroupboxFrames;

  with Nemp_MainForm do
  begin
    if UseBackground then
          TileGraphic(sourceBmp, aGroupbox.Canvas,
                localOffsetX + (grpPoint.X - OffsetPoint.X) ,
                localOffsetY + (grpPoint.Y - OffsetPoint.Y))
    else
    begin
          aGroupbox.Canvas.Brush.Style := bsSolid;
          aGroupbox.Canvas.Brush.Color := SkinColorScheme.FormCL;
          aGroupbox.Canvas.FillRect(aGroupbox.ClientRect);
    end;
    if localDrawFrame then
      DrawGroupboxFrame(aGroupbox);
  end;
end;


procedure TNempSkin.DrawAOptionsGroupbox(aGroupbox: TNempGroupbox; UseBackground: Boolean = True);
var grpPoint, OffsetPoint: TPoint;
    sourceBmp: TBitmap;
    localOffsetX, localOffsetY: Integer;
    localdrawFrame: Boolean;
begin
  grpPoint := aGroupbox.ClientToScreen(Point(0,0));
  OffsetPoint := OptionsCompleteForm.GRPBOXTextAnzeige.ClientToScreen(Point(0,0));

  if UseSeparatePlayerBitmap then
  begin
      // Player-Teil gesondert behandelr
      localOffsetX := 0;
      localOffsetY := 0;
      sourceBmp := PlayerBitmap;
      localDrawFrame := DrawGroupboxFramesMain;
  end else
  begin
      localOffsetX := PlayerPageOffsetX;
      localOffsetY := PlayerPageOffsetY;
      sourceBmp := CompleteBitmap;
      localDrawFrame := DrawGroupboxFrames;
  end;

  with OptionsCompleteForm do
  begin
    if UseBackground then
          TileGraphic(sourceBmp, aGroupbox.Canvas,
                localOffsetX + (grpPoint.X - OffsetPoint.X+8) ,
                localOffsetY + (grpPoint.Y - OffsetPoint.Y+28))
    else
    begin
          aGroupbox.Canvas.Brush.Style := bsSolid;
          aGroupbox.Canvas.Brush.Color := SkinColorScheme.FormCL;
          aGroupbox.Canvas.FillRect(aGroupbox.ClientRect);
    end;
    if localDrawFrame then
      DrawGroupboxFrame(aGroupbox);
  end;
end;   *)

procedure TNempSkin.DrawPreview(aPanel: TNempPanel);
///  todo:
///  Bitmap malen
///  Controls malen
var pnlPoint, OffsetPoint: TPoint;
    tmp: TBitmap;
    sourceBmp: TBitmap;
    localOffsetX, localOffsetY: Integer;
    stretch: Boolean;
begin
    tmp := TBitmap.Create;
    try
        tmp.Width := aPanel.Width;
        tmp.Height := aPanel.Height;
        pnlPoint := Nemp_MainForm.NewPlayerPanel.ClientToScreen(Point(0,0));
        OffsetPoint := Nemp_MainForm.PlayerPanel.ClientToScreen(Point(0,0));
        stretch := False;

        if UseSeparatePlayerBitmap then
        begin
            // LocalOffset: -2:
            // The NewPlayerPanel On OptionsForm is bigger than the NewPlayerPanel on Mainform
            // This ist to include the Top/Left-Values of MainForm.NewPlayerPanel on the
            // MainForm PlayerPanel-Container-Panel
            localOffsetX := -2;
            localOffsetY := -2;
            sourceBmp := PlayerBitmap;
            //localDrawFrame := DrawGroupboxFramesMain;
        end else
        begin
            localOffsetX := PlayerPageOffsetX-2;
            localOffsetY := PlayerPageOffsetY-2;
            sourceBmp := CompleteBitmap;
            //localDrawFrame := DrawGroupboxFrames;
        end;
        TileGraphic(sourceBmp, tmp.Canvas,
              localOffsetX + (pnlPoint.X - OffsetPoint.X) ,
              localOffsetY + (pnlPoint.Y - OffsetPoint.Y),
              Stretch);
        BitBlt(aPanel.Canvas.Handle, 0,   0, tmp.Width, tmp.Height, tmp.Canvas.Handle, 0,  0, srccopy);
    finally
        tmp.Free;
    end;
end;

procedure TNempSkin.DrawAPanel(aPanel: TNempPanel; UseBackground: Boolean = True);
var pnlPoint, OffsetPoint: TPoint;
    tmp: TBitmap;
    sourceBmp: TBitmap;
    localOffsetX, localOffsetY: Integer;
    stretch: Boolean;
begin
  tmp := TBitmap.Create;
  tmp.Width := aPanel.Width;
  tmp.Height := aPanel.Height;

  pnlPoint := aPanel.ClientToScreen(Point(0,0));
  OffsetPoint := Nemp_MainForm.PlayerPanel.ClientToScreen(Point(0,0));

  stretch := False;
  if (aPanel.Tag = 0) and UseSeparatePlayerBitmap then
  begin
      // Player-Teil gesondert behandelr
      localOffsetX := 0;
      localOffsetY := 0;
      sourceBmp := PlayerBitmap;
      stretch := NempPartyMode.Active;
      OffsetPoint := pnlPoint;
  end
  else
      if (aPanel.Tag = 5) and UseSeparatePlayerBitmap then
      begin
          // Player-Teil gesondert behandelr
          localOffsetX := 0;//{-pnlPoint.X + }OffsetPoint.X;
          localOffsetY := 0;//{-pnlPoint.Y +} OffsetPoint.Y;
          pnlPoint := aPanel.ClientToScreen(Point(0,0));
          OffsetPoint := Nemp_MainForm.AudioPanel.ClientToScreen(Point(0,0));
          sourceBmp := ExtendedPlayerBitmap;
          //OffsetPoint.X := OffsetPoint.X - Nemp_MainForm.AudioPanel.Left;  // AudioPanel.Top/Left is 2 on the ContainerPanel
          //OffsetPoint.Y := OffsetPoint.Y - Nemp_MainForm.AudioPanel.Top;
          stretch := NempPartyMode.Active;
      end
      else
      begin
          localOffsetX := PlayerPageOffsetX;
          localOffsetY := PlayerPageOffsetY;
          sourceBmp := CompleteBitmap;
      end;

  with Nemp_MainForm do
  begin
    if UseBackground then
          TileGraphic(sourceBmp, tmp.Canvas,
                localOffsetX + (pnlPoint.X - OffsetPoint.X) ,
                localOffsetY + (pnlPoint.Y - OffsetPoint.Y),
                Stretch)
    else
    begin
          tmp.Canvas.Brush.Style := bsSolid;
          tmp.Canvas.Pen.Color :=  SkinColorScheme.FormCL;
          tmp.Canvas.Brush.Color := SkinColorScheme.FormCL;
          tmp.Canvas.FillRect(tmp.Canvas.ClipRect);
    end;
  end;

  BitBlt(aPanel.Canvas.Handle, 0,   0, tmp.Width, tmp.Height, tmp.Canvas.Handle, 0,  0, srccopy);
  tmp.Free;
end;

Procedure TNempSkin.UpdateSpectrumGraphics;
begin
  with Nemp_MainForm do
  begin
    Spectrum.SetBackGround(True);
    Spectrum.SetTextBackGround(True);
    Spectrum.SetTimeBackGround(True);
    Spectrum.SetStarBackGround(True);
    Spectrum.DrawRating(RatingImage.Tag);
    Spectrum.SetGradientBitmap;
  end;
end;

function TNempSkin.LoadGraphicFromBaseName(aBmp: TBitmap; aFilename: UnicodeString; Scaled: Boolean=False): Boolean;
var NewName, ext: String;
    ScaleCorrectionNeeded: Boolean;
    tmpPic: TPicture;

        function GetExistingExtension: string;
        begin
            result := '';
            if FileExists(NewName + '.png') then
                result := '.png'
            else
            if FileExists(NewName + '.bmp') then
                result := '.bmp'
            else
            if FileExists(NewName + '.jpg') then
                result := '.jpg'
        end;

begin
  // First: Select the correct scaled file
  ScaleCorrectionNeeded := False;
  if Scaled and (NempPartyMode.Active) then
  begin
      // Get scaling-suffix
      case NempPartyMode.FactorToIndex of
          0: NewName := aFilename;       // + '.bmp';
          1: NewName := aFilename + '15';// .bmp';
          2: NewName := aFilename + '20';// .bmp';
          3: NewName := aFilename + '25';// .bmp';
      else
           NewName := aFilename + '15';// .bmp';
      end;

      // Get an existing Filename "NewName.ext"
      ext := GetExistingExtension;
      if ext <> '' then
      begin
          // File exists :D
          NewName := NewName + ext;
          ScaleCorrectionNeeded := False;
      end
      else
      begin
          // No valid file found. Fall back to default graphics
          ScaleCorrectionNeeded := True;
          NewName := aFilename;
          ext := GetExistingExtension;
          if ext <> '' then
              NewName := aFilename + ext
          else
          begin
              NewName := aFilename + '.bmp';  // This file does NOT exist!
              ScaleCorrectionNeeded := False; // so the else-part below will draw an empty bitmap
          end;
      end;
  end
  else
  begin
      // no scaling, Buttons have default sizes
      ScaleCorrectionNeeded := False;
      NewName := aFilename;//  + '.bmp';
      ext := GetExistingExtension;
      if ext <> '' then
          NewName := aFilename + ext  // This file does exist
      else
          NewName := aFilename + '.bmp';  // This file does NOT exist!
  end;


  if ScaleCorrectionNeeded then
  begin
      // We have a scaled button, but not the correctly scaled file for it.
      // Load the default one and stretch it.
      tmpPic := TPicture.Create;
      try
          if FileExists(NewName) then // Note: This should always be true. ;-)
          begin
              result := True;
              try
                  tmpPic.LoadFromFile(NewName);
                  aBmp.Width := Round(NempPartyMode.ResizeFactor * tmpPic.Width);
                  aBmp.Height := Round(NempPartyMode.ResizeFactor * tmpPic.Height);
                  aBmp.Canvas.StretchDraw(Rect(0,0, aBmp.Width, aBmp.Height), tmpPic.Graphic);
              except
                  result := False;
              end;
          end else
              result := False;
      finally
          tmpPic.Free;
      end;

  end else
  begin
      // correct scaled file exists. Just load it.
      if FileExists(NewName) then
      begin
          tmpPic := TPicture.Create;
          try
              result := True;
              try
                  tmpPic.LoadFromFile(NewName);
                  aBmp.Assign(tmpPic.Graphic);
              except
                  result := False;
              end;
          finally
              tmpPic.Free;
          end;
      end else
      begin
          result := False;
          aBmp.Width := 150;
          aBmp.Height := 150;
          aBmp.Canvas.Brush.Style := bsSolid;
          aBmp.Canvas.Brush.Color := clWhite;
          aBmp.Canvas.FillRect(Rect(1,1,149,149));
      end;
  end;
end;
              (*
procedure TNempSkin.AssignDefaultSystemButtons;
begin
    with Nemp_MainForm do
    begin
        Buttons12ImageList.GetBitmap(0,BtnMinimize.NempGlyph);
        Buttons12ImageList.GetBitmap(1,BtnClose.NempGlyph);
        Buttons12ImageList.GetBitmap(2,BtnMenu.NempGlyph);
        BtnMinimize.NumGlyphsX := 1;
        BtnMinimize.NumGlyphs := 1;
        BtnClose.NumGlyphsX := 1;
        BtnClose.NumGlyphs := 1;
        BtnMenu.NumGlyphsX := 1;
        BtnMenu.NumGlyphs := 1;

        // und die anderen Close-Images

            Buttons12ImageList.GetBitmap(1,AuswahlForm.CloseImage.NempGlyph);
            AuswahlForm.CloseImage.NumGlyphsX := 1;
            AuswahlForm.CloseImage.NumGlyphs := 1;

            Buttons12ImageList.GetBitmap(1,MedienlisteForm.CloseImage.NempGlyph);
            MedienlisteForm.CloseImage.NumGlyphsX := 1;
            MedienlisteForm.CloseImage.NumGlyphs := 1;

            Buttons12ImageList.GetBitmap(1,PlaylistForm.CloseImage.NempGlyph);
            PlaylistForm.CloseImage.NumGlyphsX := 1;
            PlaylistForm.CloseImage.NumGlyphs := 1;
    end;
end;
      *)
procedure TNempSkin.AssignButtonSizes;
var BtnArray: Array[0..7] of TSkinButton;
    tmpBtn: TSkinButton;
    i, j: Integer;
    r: TChangeProc;
    b: TControlButtons;
begin
    i := 0;
    NempPartyMode.SetButtonPos(ControlButtonData[ctrlPlayPauseBtn] , i);
    NempPartyMode.SetButtonPos(ControlButtonData[ctrlStopBtn]      , i);
    NempPartyMode.SetButtonPos(ControlButtonData[ctrlNextBtn]      , i);
    NempPartyMode.SetButtonPos(ControlButtonData[ctrlPrevBtn]      , i);
    NempPartyMode.SetButtonPos(ControlButtonData[ctrlSlideForwardBtn]  , i);
    NempPartyMode.SetButtonPos(ControlButtonData[ctrlSlidebackwardBtn] , i);
    NempPartyMode.SetButtonPos(ControlButtonData[ctrlRandomBtn]    , i);
    NempPartyMode.SetButtonPos(ControlButtonData[ctrlRecordBtn]    , i);
    // 3 System-Buttons
    NempPartyMode.SetButtonPos(ControlButtonData[ctrlMinimizeBtn]  , i);
    NempPartyMode.SetButtonPos(ControlButtonData[ctrlCloseBtn]     , i);
    NempPartyMode.SetButtonPos(ControlButtonData[ctrlMenuBtn]      , i);


    r := NempPartyMode.ResizeProc;
    with Nemp_MainForm do
    begin
        for b := Low(TControlButtons) to High(TControlButtons) do
        begin
            ControlButtons[b].Left   := r(ControlButtonData[b].Left)  ;
            ControlButtons[b].Top    := r(ControlButtonData[b].Top) ;
            ControlButtons[b].Width  := r(ControlButtonData[b].Width) ;
            ControlButtons[b].Height := r(ControlButtonData[b].Height);
            if b <= ctrlRecordBtn  then
                ControlButtons[b].Visible:= ControlButtonData[b].Visible or (ButtonMode <> 2)
            else
                ControlButtons[b].Visible:= ControlButtonData[b].Visible;
        end;

        BtnArray[0] := PlayPauseBTN        ;
        BtnArray[1] := SlideBackBTN        ;
        BtnArray[2] := PlayPrevBTN         ;
        BtnArray[3] := StopBTN             ;
        BtnArray[4] := RecordBTN           ;
        BtnArray[5] := PlayNextBTN         ;
        BtnArray[6] := SlideForwardBTN     ;
        BtnArray[7] := RandomBTN           ;

        //Bubblesort für TabOrder
        for i := 0 to 6 do
        begin
            for j := 0 to 6 - i do
            begin
                if (BtnArray[j].Left > BtnArray[j+1].Left) or
                   ((BtnArray[j].Left = BtnArray[j+1].Left) and
                    ((BtnArray[j].Top > BtnArray[j+1].Top))) then
                begin
                    //Swap Buttons
                    tmpBtn := BtnArray[j];
                    BtnArray[j] := BtnArray[j+1];
                    BtnArray[j+1] := tmpBtn;
                end;
            end;
        end;
        // Buttons sortiert -> TabOrder setzen
        SlideBarButton.TabOrder := 0;
        for i := 0 to 7 do
            BtnArray[i].TabOrder := i+1;
    end;
end;

procedure TNempSkin.SetDefaultButtonSizes;
var j: TControlbuttons;
begin
    for j := low(TControlbuttons) to High(TControlButtons) do
    begin
      ControlButtonData[j].Visible     := DefaultButtonData[j].Visible;
      ControlButtonData[j].Left        := DefaultButtonData[j].Left        ;
      ControlButtonData[j].Top         := DefaultButtonData[j].Top         ;
      ControlButtonData[j].Width       := DefaultButtonData[j].Width       ;
      ControlButtonData[j].Height      := DefaultButtonData[j].Height      ;
    end;
end;

procedure TNempSkin.AssignWindowsTabGlyphs(UseSkinGraphics: Boolean);
var BaseDir: String;
    tmpBitmap: tBitmap;
    b: Integer;
begin
    with Nemp_MainForm do
    begin
        if UseSkinGraphics then
            BaseDir := Path + '\'
        else
            BaseDir := ExtractFilePath(ParamStr(0)) + 'Images\';

        tmpBitmap := TBitmap.Create;
        try
            for b := 0 to 9 do
            begin
                TabButtons[b].Button.DrawMode := dm_Windows;
                TabButtons[b].Button.NumGlyphsX := 1;
                TabButtons[b].Button.NumGlyphs  := 1;
                TabButtons[b].Button.Glyph.Assign(Nil);
                LoadGraphicFromBaseName(tmpBitmap, BaseDir + TabButtons[b].GlyphFile, True);
                TabButtons[b].Button.NempGlyph.Assign(tmpBitmap);
                TabButtons[b].Button.CustomRegion := False;
                TabButtons[b].Button.GlyphLine := TabButtons[b].Button.GlyphLine;
            end;
        finally
            tmpBitmap.Free;
        end;
    end;
end;

procedure TNempSkin.AssignSkinTabGlyphs;
var BaseDir: String;
    b: Integer;
begin
    with Nemp_MainForm do
    begin
        BaseDir := path + '\';
        for b := 0 to 9 do
        begin
            TabButtons[b].Button.DrawMode := dm_Skin;
            AssignNemp3Glyph(TabButtons[b].Button, BaseDir + TabButtons[b].GlyphFile, True);
            TabButtons[b].Button.Refresh;
        end;
    end;
end;


procedure TNempSkin.AssignStarGraphics;
var BaseDir: String;
begin
    if isActive and (not UseDefaultStarBitmaps) then
        BaseDir := path + '\'
    else
        BaseDir := ExtractFilePath(ParamStr(0)) + 'Images\';

        // todo: Var UseDefaultStars...

    LoadGraphicFromBaseName(SetStarBitmap, BaseDir + 'starset');
    LoadGraphicFromBaseName(UnSetStarBitmap, BaseDir + 'starunset');
    LoadGraphicFromBaseName(HalfStarBitmap, BaseDir + 'starhalfset');
    SetStarBitmap.Transparent := True;
    UnSetStarBitmap.Transparent := True;
    HalfStarBitmap.Transparent := True;
    RatingGraphics.SetStars(SetStarBitmap, HalfStarBitmap, UnSetStarBitmap);

    Nemp_MainForm.BibRatingHelper.SetStars(SetStarBitmap, HalfStarBitmap, UnSetStarBitmap);
    if Assigned(MedienBib.CurrentAudioFile) then
        Nemp_MainForm.BibRatingHelper.DrawRatingInStarsOnBitmap(MedienBib.CurrentAudioFile.Rating, Nemp_MainForm.ImgBibRating.Picture.Bitmap, Nemp_MainForm.ImgBibRating.Width, Nemp_MainForm.ImgBibRating.Height)
    else
        Nemp_MainForm.BibRatingHelper.DrawRatingInStarsOnBitmap(128, Nemp_MainForm.ImgBibRating.Picture.Bitmap, Nemp_MainForm.ImgBibRating.Width, Nemp_MainForm.ImgBibRating.Height);

    LoadGraphicFromBaseName(SetStarBitmap, BaseDir + 'starset', True);
    LoadGraphicFromBaseName(UnSetStarBitmap, BaseDir + 'starunset', True);
    LoadGraphicFromBaseName(HalfStarBitmap, BaseDir + 'starhalfset', True);
    SetStarBitmap.Transparent := True;
    UnSetStarBitmap.Transparent := True;
    HalfStarBitmap.Transparent := True;

    PlayerRatingGraphics.SetStars(SetStarBitmap, HalfStarBitmap, UnSetStarBitmap);
end;

procedure TNempSkin.AssignWindowsGlyphs(UseSkinGraphics: Boolean);
var BaseDir: String;
    b: TControlButtons;
    tmpBitmap: tBitmap;
begin
    with Nemp_MainForm do
    begin
        if UseSkinGraphics then
            BaseDir := Path + '\'
        else
            BaseDir := ExtractFilePath(ParamStr(0)) + 'Images\';

        tmpBitmap := tBitmap.Create;
        try
            for b := Low(TControlButtons) to High(TControlButtons) do
            begin
                ControlButtons[b].DrawMode := dm_Windows;
                ControlButtons[b].NumGlyphs := 1;
                ControlButtons[b].Glyph.Assign(Nil);
                ControlButtons[b].Refresh;
                LoadGraphicFromBaseName(tmpBitmap, BaseDir + DefaultButtonData[b].Name, True);

                ControlButtons[b].NempGlyph.Assign(tmpBitmap);
                ControlButtons[b].GlyphLine := ControlButtons[b].GlyphLine;
                ControlButtons[b].RePaint;
            end;
            DirectionPositionBTN .drawMode := dm_Windows;
            DirectionPositionBTN .NumGlyphs := 1;
            DirectionPositionBTN.NempGlyph.Assign(Nil);
            LoadGraphicFromBaseName(tmpBitmap, BaseDir + 'BtnReverse', True);
            DirectionPositionBTN.NempGlyph.Assign(tmpBitmap);
            DirectionPositionBTN.GlyphLine := DirectionPositionBTN.GlyphLine;
            DirectionPositionBTN.Refresh;


            CB_MedienBibGlobalQuickSearch .drawMode := dm_Windows;
            CB_MedienBibGlobalQuickSearch.NumGlyphsX := 1;
            CB_MedienBibGlobalQuickSearch .NumGlyphs := 1;
            CB_MedienBibGlobalQuickSearch.NempGlyph.Assign(Nil);
            LoadGraphicFromBaseName(tmpBitmap, BaseDir + 'BtnQuickSearch', True);
            CB_MedienBibGlobalQuickSearch.NempGlyph.Assign(tmpBitmap);
            CB_MedienBibGlobalQuickSearch.GlyphLine := CB_MedienBibGlobalQuickSearch.GlyphLine;
            CB_MedienBibGlobalQuickSearch.Refresh;



            LoadGraphicFromBaseName(tmpBitmap, BaseDir + DefaultButtonData[ctrlCloseBtn].Name, True);
            AuswahlForm.CloseImage.NempGlyph.Assign(tmpBitmap);
            //Buttons12ImageList.GetBitmap(1,AuswahlForm.CloseImage.NempGlyph);
            AuswahlForm.CloseImage.NumGlyphsX := 1;
            AuswahlForm.CloseImage.NumGlyphs := 1;

            //Buttons12ImageList.GetBitmap(1,MedienlisteForm.CloseImage.NempGlyph);
            MedienlisteForm.CloseImage.NempGlyph.Assign(tmpBitmap);
            MedienlisteForm.CloseImage.NumGlyphsX := 1;
            MedienlisteForm.CloseImage.NumGlyphs := 1;

            //Buttons12ImageList.GetBitmap(1,PlaylistForm.CloseImage.NempGlyph);
            PlaylistForm.CloseImage.NempGlyph.Assign(tmpBitmap);
            PlaylistForm.CloseImage.NumGlyphsX := 1;
            PlaylistForm.CloseImage.NumGlyphs := 1;

        finally
            tmpBitmap.Free;
        end;
    end;
end;


procedure TNempSkin.AssignNemp3Glyph(aButton: TSkinButton; aFilename: UnicodeString; Scaled: Boolean=False);
var tmpBitmap: TBitmap;
begin
    aButton.DrawMode := dm_Skin;
    aButton.NumGlyphsX := 5;
    tmpBitmap := TBitmap.Create;
    try
        LoadGraphicFromBaseName(tmpBitmap, aFilename, Scaled);
        aButton.NempGlyph.Assign(tmpBitmap);
        aButton.GlyphLine := aButton.GlyphLine;
    finally
        tmpBitmap.Free;
    end;
end;


end.
