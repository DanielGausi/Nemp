{

    Unit Nemp_SkinSystem

    The SkinSystem of Nemp
    This unit needs some changes until 4.0
    Some changes are already done, some mor will follow....

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

unit Nemp_SkinSystem;

{$I xe.inc}

interface

uses Windows, Graphics, ExtCtrls, Controls, Types, Forms, dialogs, SysUtils, VirtualTrees,  StdCtrls,
iniFiles, jpeg, NempPanel, Classes, oneinst, SkinButtons, PNGImage, ProgressShape,

Nemp_ConstantsAndTypes, PartyModeClass{$IFDEF USESTYLES}, vcl.themes, vcl.styles, Vcl.CheckLst {$ENDIF};

const MAX_MENUIMAGE_INDEX = 43;
      MAX_PLAYLIST_IMAGE_INDEX = 23;

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
                     ctrlHeadsetPlayBtn,
                     ctrlHeadsetStopBtn,
                     ctrlHeadsetPlayNowBtn,
                     ctrlHeadsetInsertToPlaylistBtn,
                     ctrlMinimizeBtn,
                     ctrlCloseBtn
                     //ctrlMenuBtn
                     );
                     // Der Reverse-Button fällt hier raus. Größe und Position sind fest!!

  type

  // Typ Zur Farbverwaltung des Skins
  TNempColorScheme = record
      FormCL: TColor;
      //TabTextCL: TColor;
      //TabTextBackGroundCL: TColor;
      SpecTitelCL: TColor;
      SpecTimeCL: TColor;
      SpecArtistCL: TColor;
      // SpecTitelBackGroundCL: TColor;
      // SpecTimeBackGroundCL: TColor;
      SpecPenCL: TColor;
      SpecPen2Cl: TColor;
      SpecPeakCL: TColor;
      PreviewTitleColor: TColor;
      PreviewArtistColor: TColor;
      PreviewTimeColor: TColor;

      //FontColorControlQuality: TColor;

      PreviewShapePenColor           : TColor;
      PreviewShapeBrushColor         : TColor;
      PreviewShapeProgressPenColor   : TColor;
      PreviewShapeProgressBrushColor : TColor;

      LabelCL: TColor;
      LabelBackGroundCL: TColor;
      GroupboxFrameCL: TColor;
      MemoBackGroundCL: TColor;
      MemoTextCL: TColor;
      ShapeBrushCL: TColor;
      ShapePenCL: TColor;
      ShapePenProgressCL: TColor;
      ShapeBrushProgressCL: TColor;
      SplitterColor: TColor;
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
      Tree_UnfocusedColor                : Array[1..4] of TColor;
  end;


  const
    DefaultButtonData : Array[TControlButtons] of TNempButtonData =
      (
        (Name: 'BtnPlayPause'    ; Visible: True; Left:   8; Top: 30; Width: 24; Height: 24),  // 'PlayBtn',
        (Name: 'BtnStop'         ; Visible: True; Left:  32; Top: 30; Width: 24; Height: 24),  // 'StopBtn',
    		(Name: 'BtnNext'         ; Visible: True; Left:  96; Top: 30; Width: 24; Height: 24),  // 'NextBtn',
        (Name: 'BtnPrev'         ; Visible: True; Left:  72; Top: 30; Width: 24; Height: 24),  // 'PrevBtn',
		    (Name: 'BtnSlideForward' ; Visible: True; Left:  56; Top: 68; Width: 24; Height: 24),  // 'SlideForwardBtn',
        (Name: 'BtnSlideBackward'; Visible: True; Left:  32; Top: 68; Width: 24; Height: 24),   // 'SlidebackwardBtn'
        (Name: 'BtnRandom'       ; Visible: True; Left: 126; Top: 30; Width: 24; Height: 24),  // 'RandomBtn',
    		(Name: 'BtnRecord'       ; Visible: True; Left: 8; Top: 68; Width: 24; Height: 24),  // 'RecordBtn',

        (Name: 'BtnPlayPauseHeadset'   ; Visible: True; Left: 8; Top: 30; Width: 24; Height: 24),  // '',
        (Name: 'BtnStopHeadSet'        ; Visible: True; Left: 32; Top: 30; Width: 24; Height: 24),  // '',
        (Name: 'BtnHeadsetPlaynow'     ; Visible: True; Left: 100; Top: 30; Width: 24; Height: 24),  // '',
        (Name: 'BtnHeadsetToPlaylist'  ; Visible: True; Left: 124; Top: 30; Width: 24; Height: 24),  // '',

        (Name: 'BtnMinimize'     ; Visible: False; Left: 196; Top: 1; Width: 12; Height: 12),  // 'MinimizeBtn',
        (Name: 'BtnClose'        ; Visible: False; Left: 214; Top: 1; Width: 12; Height: 12)  // 'CloseBtn',

      ) ;

  type
      SkinButtonRec = record
          Button: TSkinButton;
          GlyphFile: String;
      end;

 type
  // Eigentliche Skinklasse
  TNempSkin = class
      private
        fControlSelectionLoaded,
        fControCoverLoaded,
        fControlPlayerLoaded,
        fControlProgressLoaded : Boolean;
        //fControlVisLoaded

        fBrowseBitmapLoaded,
        fMedialistBitmapLoaded,
        fPlaylistBitmapLoaded   : Boolean;

        function LoadListGraphic(aTargetBmp: TBitmap; aBaseFilename: UnicodeString): Boolean;

        // Die alten Grafiken, bzw. die Default-Grafiken in das neue Glyph-Format bringen
        procedure AssignWindowsGlyphs(UseSkinGraphics: Boolean);
        procedure AssignWindowsTabGlyphs(UseSkinGraphics: Boolean);

        // bitmap offsets of the trees (global, align with CompleteBitmap)
        procedure fSetATreeOffset(aVST: TVirtualStringTree);
        // bitmap offsets of the trees (align to local Tree-Bitmap)
        procedure fSetTreeLocalOffsetPoint(aTree: TVirtualStringTree; aAlignment: Integer; DoTile: Boolean; aBitmap: TBitmap; aParent: TWinControl = Nil);

        function fGetControlLocalOffsetPoint(aControl: TWinControl; aBitmap: TBitmap; aAlignment: Integer): TPoint;

//        procedure AssignDefaultSystemButtons;

        procedure AssignSkinTabGlyphs;

        procedure SetDefaultButtonSizes;
        // Setzt die Buttongrößen im Hauptfenster und sortiert die TabOrder
        procedure AssignButtonSizes;

        //procedure AssignClassicGlyph(aButton: TSkinButton; aFilename: UnicodeString);
        function AssignNemp3Glyph(aButton: TSkinButton; aFilename: UnicodeString; Scaled: Boolean=False): Boolean;
        function AssignWindowsTabGlyph(aButton: TSkinButton; aFilename: UnicodeString; Scaled: Boolean=False): Boolean;

        procedure AssignStarGraphics;
        procedure AssignABGraphics;

      public
        Name: UnicodeString;
        Path: UnicodeString;
        isActive: Boolean;

        // Bild für das Gesamte Ding
        CompleteBitmap: TBitmap;
        BrowseBitmap,
        MedialistBitmap,
        Playlistbitmap: TBitmap;

        // Bild für den Mittelteil (den eigentlichen Player)
        // Kann leer sein - Aber wenn vorhanden, dann ist hier der Offset klar. Nämlich 0/0
        UseSeparatePlayerBitmap: Boolean;

        {
            align-values for Control-Panels (fixed Height)
                0: left
                1: right
                2: align to MainControls
            align-values for Complete (variable Height)
                0: left-center
                1: right-center
                2: align to MainControls (use PlayerPageOffset<X/Y>Orig in that case)
                3: left-top
                4: right-top
                5: left-bottom
                6: right-bottom
        }

        AlignControlProgressDisplay,
        AlignControlGenericBackground,
        AlignCompleteBackground       : Integer;

        AlignControlGenericOffset  : Integer;

        AlignBackgroundBrowse,
        AlignBackgroundMedialist,
        AlignBackgroundPlaylist : Integer;

        PlayerBitmap: TBitmap;
        ControlSelectionBmp,
        ControlCoverBmp,
        ControlProgressBmp,
        // ControlVisBmp,
        ControlGenericBmp: TBitmap;

        // a copy of the Bitmap painted on the Progress-Panel
        // used for painting the backgrounds of Rating-Stars and Visualisation later
        PaintedProgressBitmap: TBitmap;

        //ExtendedPlayerBitmap: TBitmap;
        SetStarBitmap: TBitmap;
        HalfStarBitmap: TBitmap;
        UnSetStarBitmap: TBitmap;
        ABrepeatBitmapA: TBitmap;
        ABrepeatBitmapB: TBitmap;

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

        TileControlBackground: Boolean;
        TileBackground: Boolean;  // Hintergrund kacheln
        FixedBackGround: Boolean; // Hintergrund fixieren
        // FixedBackGround = 1 (True) means, that the background image is aligned to the NempForm
        // FixedBackGround = 0 (False) means, that the background image is aligned to the DESKTOP

        //Tile yes/no if a special background-image for these part is Loaded
        TileBackgroundBrowse,
        TileBackgroundMedialist,
        TileBackgroundPlaylist: Boolean;

        //DrawGroupboxFrames: Boolean;
        //DrawGroupboxFramesMain: Boolean;
        //HideTabText: Boolean;
        //DrawTransparentTabText: Boolean;
        DrawTransparentLabel  : Boolean;
        // DrawTransparentTitel  : Boolean;
        // DrawTransparentTime   : Boolean;
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

        // XE2:
        UseAdvancedSkin: Boolean;
        TreeClientPaintedBySkin: Boolean;
        AdvancedStyleFilename: String;
        AdvancedStyleName: String;
        RegisteredStyles: TStringList;

        //OldUseDefaultButtons: Boolean;
        ButtonMode: Integer;  // 0: Windows, 1: Nemp klassisch, 2: Nemp3.0
        SlideButtonMode: Integer;

        UseDefaultListImages: Boolean;
        //UseDefaultTreeImages: Boolean;
        UseDefaultMenuImages: Boolean;

        UseDefaultStarBitmaps: Boolean;

        //-------------------------------------------------
        SkinColorScheme: TNempColorScheme;
        DialogCustomColors: Array[0..15] of TColor;

        // ControlButtonData: Store the values
        ControlButtonData : Array[TControlButtons] of TNempButtonData;
        // ControlButtons: The Buttons on the MainForm
        ControlButtons : Array[TControlButtons] of TSkinButton;

        TabButtons: Array [0..12] of SkinButtonRec;
        SlideButtons: Array [0..2] of SkinButtonRec;

        NempPartyMode: TNempPartyMode;

        FormBuilder: TNempFormBuildOptions;

        property ControlProgressLoaded: Boolean read fControlProgressLoaded;

        constructor create;
        destructor Destroy;  override;         //Complete:: Für die Optionen-Vorschau. Da z.B. nicht die SkinButtons ändern
        procedure LoadFromDir(DirName: UnicodeString; Complete: Boolean = True);
        procedure Reload;
        //procedure SaveToDir(DirName: UnicodeString);
        //procedure copyFrom(aSkin: TNempskin);


        Procedure FitSkinToNewWindow;  // Setz den ganzen Skin bei Bedarf um
        Procedure FitPlayerToNewWindow; // Setzt nur den Player-Teil um
        procedure RepairSkinOffset;
        Procedure SetArtistAlbumOffsets;
        procedure SetVSTOffsets;
        Procedure SetPlaylistOffsets;

        procedure SetDefaultMenuImages;

        procedure SetVSTHeaderSettings;

        //procedure DrawPreview(aPanel: TNempPanel);

        //procedure DrawAPanel(aPanel: TNempPanel; UseBackground: Boolean = True);

        procedure DrawARegularPanel(aPanel: TNempPanel; UseBackground: Boolean = True);
        procedure DrawAControlPanel(aPanel: TNempPanel; UseBackground: Boolean; JustInternal: Boolean);
        procedure DrawArtistAlbumPanel(aPanel: TNempPanel; aBibCount: Integer; UseBackground: Boolean = True);

        //procedure DrawGroupboxFrame(aGroupbox: TNempGroupbox);


        Procedure UpdateSpectrumGraphics;
        procedure ActivateSkin(NotTheFirstActivation: Boolean = True);
        procedure DeActivateSkin(NotTheFirstActivation: Boolean = True);
        procedure SetRegionsAgain;

        procedure TileGraphic(const ATile: TBitmap; aDoTile: Boolean; const ATarget: TCanvas; X, Y: Integer; Stretch: Boolean = False);

        //function CreatePlayerBitmap: boolean;

        /// function SaveButton(aBmp: TBitmap; aFilename: String): boolean;
        //procedure CreateButtonFiles(CutMode: Integer);
        //procedure CorrectButtonFile(Cutmode: Integer; btnidx: Integer; BtnMode: Integer; Row: Integer);

        // LoadGraphicFromBaseName: Load Graphic from a file
        // aFilename<Scale>.<Ext>
        // where <Scale> is a Scalefactor-Suffix (for alternate Graphics in Partymode)
        // and <Ext> is png, bmp or jpg
        function LoadGraphicFromBaseName(aBmp: TBitmap; aFilename: UnicodeString; Scaled: Boolean=False): Boolean;

        procedure PaintFallbackImage(var aBitmap: TBitmap);

        procedure AssignOtherGraphics; // Volume etc.



  end;

  function GetSkinDirFromSkinName(aName: String): String;

  {$IFDEF USESTYLES}
  // not used atm
  //procedure UnSkinForm(aForm: TForm);
  {$ENDIF}


const CustomColorNames : Array [0..15] of string = ('ColorA','ColorB','ColorC','ColorD','ColorE','ColorF','ColorG','ColorH','ColorI','ColorJ','ColorK','ColorL','ColorM','ColorN','ColorO','ColorP');

implementation


uses NempMainUnit, Details, OptionsComplete, Hilfsfunktionen, spectrum_vis,
    SplitForm_Hilfsfunktionen, PlaylistUnit, AuswahlUnit, MedienlisteUnit, ExtendedControlsUnit,
    VSTEditControls, MedienBibliothekClass, TagClouds, Systemhelper, DeleteSelect;

function GetSkinDirFromSkinName(aName: String): String;
begin
    result := StringReplace(aName,
              '<public> ', ExtractFilePath(ParamStr(0)) + 'Skins\', []);

    result := StringReplace(result,
              '<private> ', GetShellFolder(CSIDL_APPDATA) + '\Gausi\Nemp\Skins\',[]);

end;

constructor TNempSkin.create;
begin
  inherited create;
  CompleteBitmap := TBitmap.Create;
  PlayerBitmap := TBitmap.Create;

  MedialistBitmap := TBitmap.Create;
  BrowseBitmap := TBitmap.Create;
  Playlistbitmap := TBitmap.Create;


  ControlSelectionBmp := TBitmap.Create;
  ControlCoverBmp     := TBitmap.Create;
  ControlProgressBmp  := TBitmap.Create;
  // ControlVisBmp       := TBitmap.Create;
  ControlGenericBmp   := TBitmap.Create;
  PaintedProgressBitmap := TBitmap.Create;

  NempPartyMode := TNempPartyMode.Create;
  NempPartymode.BackupOriginalPositions;

  SetStarBitmap := TBitmap.Create;
  HalfStarBitmap:= TBitmap.Create;
  UnSetStarBitmap := TBitmap.Create;
  ABrepeatBitmapA := TBitmap.Create;
  ABrepeatBitmapB := TBitmap.Create;


  SetStarBitmap.Transparent := True;
  HalfStarBitmap.Transparent := True;
  UnSetStarBitmap.Transparent := True;
  ABrepeatBitmapA.Transparent := True;
  ABrepeatBitmapB.Transparent := True;
  SetStarBitmap.Width := 14;
  SetStarBitmap.Height := 14;
  SetStarBitmap.Canvas.Rectangle(0,0,14,14);
  UnSetStarBitmap.Width := 14;
  UnSetStarBitmap.Height := 14;
  UnSetStarBitmap.Canvas.Rectangle(0,0,14,14);
  HalfStarBitmap.Width := 14;
  HalfStarBitmap.Height := 14;
  HalfStarBitmap.Canvas.Rectangle(0,0,14,14);
  ABrepeatBitmapA.Width := 13;
  ABrepeatBitmapA.Height := 14;
  ABrepeatBitmapA.Canvas.Rectangle(0,0,14,14);

  ABrepeatBitmapB.Width := 13;
  ABrepeatBitmapB.Height := 14;
  ABrepeatBitmapB.Canvas.Rectangle(0,0,14,14);

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

  ControlButtons[ctrlHeadsetPlayBtn            ] := Nemp_MainForm.PlayPauseHeadSetBtn  ;
  ControlButtons[ctrlHeadsetStopBtn            ] := Nemp_MainForm.StopHeadSetBtn       ;
  ControlButtons[ctrlHeadsetPlayNowBtn         ] := Nemp_MainForm.BtnHeadsetPlaynow    ;
  ControlButtons[ctrlHeadsetInsertToPlaylistBtn] := Nemp_MainForm.BtnHeadsetToPlaylist ;

  ControlButtons[ctrlMinimizeBtn     ] :=  Nemp_MainForm.BtnMinimize     ;
  ControlButtons[ctrlCloseBtn        ] :=  Nemp_MainForm.BtnClose        ;
  //ControlButtons[ctrlMenuBtn         ] :=  Nemp_MainForm.BtnMenu         ;

  TabButtons[0].Button    :=  Nemp_MainForm.TabBtn_Cover         ;
  TabButtons[1].Button    :=  Nemp_MainForm.TabBtn_SummaryLock   ;
  TabButtons[2].Button    :=  Nemp_MainForm.TabBtn_Equalizer     ;
  TabButtons[3].Button    :=  Nemp_MainForm.TabBtn_MainPlayerControl    ; // main playback // Headset playback
  TabButtons[4].Button    :=  Nemp_MainForm.TabBtn_Playlist      ;
  TabButtons[5].Button    :=  Nemp_MainForm.TabBtn_Browse        ;
  TabButtons[6].Button    :=  Nemp_MainForm.TabBtn_CoverFlow     ;
  TabButtons[7].Button    :=  Nemp_MainForm.TabBtn_TagCloud      ;
  TabButtons[8].Button    :=  Nemp_MainForm.TabBtn_Preselection  ;
  TabButtons[9].Button    :=  Nemp_MainForm.TabBtn_Medialib      ;
  TabButtons[10].Button   :=  Nemp_MainForm.TabBtn_Headset       ; // headset playback
  TabButtons[11].Button   :=  Nemp_mainForm.TabBtn_Marker        ;
  TabButtons[12].Button   :=  Nemp_mainForm.TabBtn_Favorites     ;

  TabButtons[0].GlyphFile := 'TabBtnCover'       ;
  TabButtons[1].GlyphFile := 'TabBtnSummaryLock' ;
  TabButtons[2].GlyphFile := 'TabBtnEqualizer'   ; // ...
  TabButtons[3].GlyphFile := 'TabBtnMainPlayerControl'     ;//'TabBtnEffects'     ;
  TabButtons[4].GlyphFile := 'TabBtnNemp'        ;
  TabButtons[5].GlyphFile := 'TabBtnBrowse'      ;
  TabButtons[6].GlyphFile := 'TabBtnCoverflow'   ;
  TabButtons[7].GlyphFile := 'TabBtnTagCloud'    ;
  TabButtons[8].GlyphFile := 'TabBtnNemp'        ;
  TabButtons[9].GlyphFile := 'TabBtnNemp'        ;
  TabButtons[10].GlyphFile := 'TabBtnHeadset';//'TabBtnHeadset'    ;
  TabButtons[11].GlyphFile := 'TabBtnMarker'     ;
  TabButtons[12].GlyphFile := 'TabBtnFavorites'  ;

  SlideButtons[0].Button  := Nemp_MainForm.VolButton           ;
  SlideButtons[1].Button  := Nemp_MainForm.SlideBarButton      ;
  SlideButtons[2].Button := Nemp_MainForm.VolButtonHeadset    ;

  SlideButtons[0].GlyphFile := 'SlideBtnLeftRight'; //'SlideBtnVolume';
  SlideButtons[1].GlyphFile := 'SlideBtnLeftRight';
  SlideButtons[2].GlyphFile := 'SlideBtnLeftRight';//'SlideBtnVolume';


  RegisteredStyles := TStringList.Create;
end;

destructor TNempSkin.Destroy;
begin
  RegisteredStyles.Free;

  CompleteBitmap.Free;
  MedialistBitmap.Free;
  Playlistbitmap.Free;
  BrowseBitmap.Free;


  PlayerBitmap.Free;
  ControlSelectionBmp  .Free;
  ControlCoverBmp      .Free;
  ControlProgressBmp   .Free;
  ControlGenericBmp    .Free;
  PaintedProgressBitmap.Free;

  SetStarBitmap.Free;
  HalfStarBitmap.Free;
  UnSetStarBitmap.Free;
  ABRepeatBitmapA.Free;
  ABRepeatBitmapB.Free;

  NempPartyMode.Free;

  inherited destroy;
end;

procedure TNempSkin.Reload;
begin
    LoadFromDir(path);
end;

procedure TNempSkin.LoadFromDir(DirName: UnicodeString; Complete: Boolean = True);
var i,idx: integer;
  ini: TMemIniFile;
  SectionStr, n {$IFDEF USESTYLES}, StyleFilename{$ENDIF}: String;
  Buttontmp, ListenCompletebmp: TBitmap;
  aPoint: TPoint;
  j: TControlButtons;
  SkinVersion: Integer;

  {$IFDEF USESTYLES}StyleInfo: TStyleInfo;{$ENDIF}

begin
  name := ExtractFileName(DirName);
  path := DirName;

  ini := TMeminiFile.Create(DirName + '\skin.ini', TEncoding.UTF8);
  try
        ini.Encoding := TEncoding.UTF8;

        SkinVersion := Ini.ReadInteger('Skin', 'Version', 1);

        UseBackGroundImageVorauswahl    := Not Ini.ReadBool('BackGround','HideBackgroundImageArtists'      , False); // Abwärtskompatibilität!
        UseBackGroundImageVorauswahl    := Not Ini.ReadBool('BackGround','HideBackgroundImageVorauswahl'   , False);
        UseBackgroundImagePlaylist      := Not Ini.ReadBool('BackGround','HideBackgroundImagePlaylist'     , False);
        UseBackgroundImageMedienliste   := Not Ini.ReadBool('BackGround','HideBackgroundImageMedienliste'  , False);
        UseBackgroundTagCloud           := Not Ini.ReadBool('BackGround','HideBackgroundTagCloud'          , False);

        UseBackgroundImages[0] := True; // Player immer!
        UseBackgroundImages[1] := UseBackgroundImagePlaylist;
        UseBackgroundImages[2] := UseBackGroundImageVorauswahl;
        UseBackgroundImages[3] := UseBackgroundImageMedienliste;
        TileBackground                   := ini.ReadBool('BackGround','TileBackground'       , True);
        TileControlBackground            := ini.ReadBool('BackGround','TileControlBackground', True);
        FixedBackGround                  := ini.ReadBool('BackGround','FixedBackGround'      , True);
        PlayerPageOffsetXOrig := Ini.ReadInteger('BackGround','PlayerPageOffsetX', 0);
        PlayerPageOffsetYOrig := Ini.ReadInteger('BackGround','PlayerPageOffsetY', 0);
        if FixedBackGround then
        begin
            PlayerPageOffsetX := PlayerPageOffsetXOrig;
            PlayerPageOffsetY := PlayerPageOffsetYOrig;
        end else
        begin
            aPoint := Nemp_MainForm.PlayerControlPanel.ClientToScreen(Point(0,0));
            PlayerPageOffsetX := aPoint.X + PlayerPageOffsetXOrig; //Nemp_MainForm.Left + Nemp_MainForm.PlayerPanel.Left + PlayerPageOffsetXOrig;
            PlayerPageOffsetY := aPoint.Y + PlayerPageOffsetYOrig; //Nemp_MainForm.Top + Nemp_MainForm.PlayerPanel.Top + PlayerPageOffsetYOrig;
        end;
        //
        //--------------------------
        //                                                          
        // boldFont                         := Ini.ReadBool('Options', 'boldFont'                       , False);
        DrawTransparentLabel             := Ini.ReadBool('Options','DrawTransparentLabel'            , True);
        // DrawTransparentTitel             := Ini.ReadBool('Options','DrawTransparentTitel'            , True);
        // DrawTransparentTime              := Ini.ReadBool('Options','DrawTransparentTime'             , True);
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
        HideMainMenu     := Ini.ReadBool('Options','HideMainMenu'  , False);

        {$IFDEF USESTYLES}
            UseAdvancedSkin  := Ini.ReadBool('Options','UseAdvancedSkin'  , False);
            AdvancedStyleFilename := Ini.ReadString('Options','AdvancedStyleFilename'  , name);
            TreeClientPaintedBySkin := Ini.ReadBool('Options','TreeClientPaintedBySkin', False);
            StyleFilename := path + '\' + AdvancedStyleFilename + '.vsf';
            if UseAdvancedSkin and NempOptions.GlobalUseAdvancedSkin and FileExists(StyleFilename) then
            begin
                if TStyleManager.IsValidStyle(StyleFilename, StyleInfo) then
                begin
                    AdvancedStyleName := StyleInfo.Name;
                    if RegisteredStyles.IndexOf(StyleInfo.Name) = -1 then
                    begin
                        try
                            TStyleManager.LoadFromFile(StyleFilename); //beware in this line you are only loading and registering a VCL Style and not setting as the current style.
                            RegisteredStyles.Add(StyleInfo.Name)
                        except
                            // possible exception: Style already loaded
                            on E: Exception do Showmessage(E.Message);
                        end;
                    end;
                end
                else
                    UseAdvancedSkin := False;
            end;
        {$ELSE}
            UseAdvancedSkin := False;
            TreeClientPaintedBySkin := True;
            AdvancedStyleFilename := '';
            AdvancedStyleName := '';
        {$ENDIF}


        AlignControlProgressDisplay   := Ini.ReadInteger('BackGround','AlignControlProgressDisplay'         , 1);
        AlignControlGenericBackground := Ini.ReadInteger('BackGround','AlignControlGenericBackground'       , 2);
        AlignCompleteBackground       := Ini.ReadInteger('BackGround','AlignCompleteBackground'             , 2);
        AlignControlGenericOffset     := Ini.ReadInteger('BackGround','AlignControlGenericOffset'           , 0);

        AlignBackgroundBrowse         := Ini.ReadInteger('BackGround','AlignBackgroundBrowse'      , 5);
        AlignBackgroundMedialist      := Ini.ReadInteger('BackGround','AlignBackgroundMedialist'   , 5);
        AlignBackgroundPlaylist       := Ini.ReadInteger('BackGround','AlignBackgroundPlaylist'    , 5);

        TileBackgroundBrowse      := Ini.ReadBool('BackGround','TileBackgroundBrowse'      , False);
        TileBackgroundMedialist   := Ini.ReadBool('BackGround','TileBackgroundMedialist'   , False);
        TileBackgroundPlaylist    := Ini.ReadBool('BackGround','TileBackgroundPlaylist'    , False);


        ButtonMode                       := Ini.ReadInteger('Options', 'ButtonMode', 0);
        if (ButtonMode < 0) or (ButtonMode > 2) then ButtonMode := 0;

        SlideButtonMode                  := Ini.ReadInteger('Options', 'SlideButtonMode', 0);
        if (SlideButtonMode < 0) or (SlideButtonMode > 2) then SlideButtonMode := 0;

        UseDefaultListImages             := Ini.ReadBool('Options','UseDefaultListImages', False);
        //UseDefaultTreeImages             := Ini.ReadBool('Options','UseDefaultTreeImages', False);
        UseDefaultMenuImages             := Ini.ReadBool('Options','UseDefaultMenuImages', False);
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
        SkinColorScheme.SpecTitelCL           := StringToColor(Ini.ReadString('Colors','SpecTitelCL'          , 'clWindowText'     ));
        SkinColorScheme.SpecTimeCL            := StringToColor(Ini.ReadString('Colors','SpecTimeCL'           , 'clWindowText'  ));
        if ini.ValueExists('Colors','SpecArtistCL') then
            SkinColorScheme.SpecArtistCL          := StringToColor(Ini.ReadString('Colors','SpecArtistCL'         , 'clWindowText'  ))
        else
            SkinColorScheme.SpecArtistCL := SkinColorScheme.SpecTitelCL;

        // SkinColorScheme.SpecTitelBackGroundCL := StringToColor(Ini.ReadString('Colors','SpecTitelBackGroundCL', 'clBtnFace'     ));
        // SkinColorScheme.SpecTimeBackGroundCL  := StringToColor(Ini.ReadString('Colors','SpecTimeBackGroundCL' , 'clBtnFace'     ));
        SkinColorScheme.SpecPenCL             := StringToColor(Ini.ReadString('Colors','SpecPenCL'            , 'clActiveCaption' ));
        SkinColorScheme.SpecPeakCL            := StringToColor(Ini.ReadString('Colors','SpecPeakCL'           , 'clBackground'     ));
        SkinColorScheme.PreviewTitleColor     := StringToColor(Ini.ReadString('Colors','PreviewTitleColor'    , 'clWindowText'     ));
        SkinColorScheme.PreviewArtistColor    := StringToColor(Ini.ReadString('Colors','PreviewArtistColor'   , 'clGrayText'       ));
        SkinColorScheme.PreviewTimeColor      := StringToColor(Ini.ReadString('Colors','PreviewTimeColor'     , 'clWindowText'     ));

        //SkinColorScheme.FontColorControlQuality := StringToColor(Ini.ReadString('Colors','FontColorControlQuality'     , 'clWindowText'     ));

        SkinColorScheme.PreviewShapePenColor            := StringToColor(Ini.ReadString('Colors','PreviewShapePenColor'               , 'cl3DDkShadow'     ));
        SkinColorScheme.PreviewShapeBrushColor          := StringToColor(Ini.ReadString('Colors','PreviewShapeBrushColor'             , 'clBtnFace'     ));
        SkinColorScheme.PreviewShapeProgressPenColor    := StringToColor(Ini.ReadString('Colors','PreviewShapeProgressPenColor'       , 'clHighLight'     ));
        SkinColorScheme.PreviewShapeProgressBrushColor  := StringToColor(Ini.ReadString('Colors','PreviewShapeProgressBrushColor'     , 'clHotLight'     ));


        if ini.ValueExists('Colors','SpecPen2CL') then
            SkinColorScheme.SpecPen2CL             := StringToColor(Ini.ReadString('Colors','SpecPen2CL'            , 'clBlack'))//'clActiveCaption' ))
        else
            SkinColorScheme.SpecPen2Cl := SkinColorScheme.SpecPeakCL;

        SkinColorScheme.LabelCL               := StringToColor(Ini.ReadString('Colors','LabelCL'              , 'clWindowText'     ));
        SkinColorScheme.LabelBackGroundCL     := StringToColor(Ini.ReadString('Colors','LabelBackGroundCL'    , 'clblack'   ));
        SkinColorScheme.GroupboxFrameCL       := StringToColor(Ini.ReadString('Colors','GroupboxFrameCL'      , 'clblack'   ));
        SkinColorScheme.MemoBackGroundCL      := StringToColor(Ini.ReadString('Colors','MemoBackGroundCL'     , 'clWindow'     ));
        SkinColorScheme.MemoTextCL            := StringToColor(Ini.ReadString('Colors','MemoTextCL'           , 'clWindowText'   ));
        SkinColorScheme.ShapeBrushCL          := StringToColor(Ini.ReadString('Colors','ShapeBrushCL'         , 'clwhite'   ));
        SkinColorScheme.ShapePenCL            := StringToColor(Ini.ReadString('Colors','ShapePenCL'           , 'clGradientActiveCaption'    ));

        SkinColorScheme.ShapePenProgressCL    := StringToColor(Ini.ReadString('Colors','ShapePenProgressCL'   , 'clHighLight'    ));
        SkinColorScheme.ShapeBrushProgressCL   := StringToColor(Ini.ReadString('Colors','ShapeBrushProgressCL'  , 'clHotLight'    ));

        SkinColorScheme.SplitterColor        := StringToColor(Ini.ReadString('Colors','Splitter1'            , 'clWindow'    ));
        //SkinColorScheme.Splitter2Color        := StringToColor(Ini.ReadString('Colors','Splitter2'            , 'clWindow'    ));
        //SkinColorScheme.Splitter3Color        := StringToColor(Ini.ReadString('Colors','Splitter3'            , 'clWindow'    ));
        SkinColorScheme.PlaylistPlayingFileColor := StringToColor(Ini.ReadString('Colors','PlaylistPlayingFileColor'            , 'clGradientActiveCaption'    ));

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
            SkinColorScheme.Tree_UnfocusedColor[idx]               := StringToColor(Ini.ReadString(SectionStr, 'Tree_UnfocusedColor'                    , 'clBtnFace'    ));
        end;

        // Button-Eigenschaften
        for j := low(TControlbuttons) to High(TControlButtons)  do
        begin
            // "High - 1": do not reposition the CloseBtn
            n := DefaultButtonData[j].Name;
            ControlButtonData[j].Name := n;
            ControlButtonData[j].Visible     := Ini.ReadBool   ('Buttons', n + 'Visible'    , DefaultButtonData[j].Visible     );
            ControlButtonData[j].Left        := Ini.ReadInteger('Buttons', n + 'Left'       , DefaultButtonData[j].Left        );
            ControlButtonData[j].Top         := Ini.ReadInteger('Buttons', n + 'Top'        , DefaultButtonData[j].Top         );
            ControlButtonData[j].Width       := Ini.ReadInteger('Buttons', n + 'Width'      , DefaultButtonData[j].Width       );
            ControlButtonData[j].Height      := Ini.ReadInteger('Buttons', n + 'Height'     , DefaultButtonData[j].Height      );
        end;

        // correct the positions for "old skins" (< 4.11), as butto positions wouldn't probaly make much sense now
        if SkinVersion < 4 then
        begin
            for j := low(TControlbuttons) to ctrlHeadsetInsertToPlaylistBtn do //High(TControlButtons) - 1 do
            begin
              ControlButtonData[j].Left        := DefaultButtonData[j].Left   ;
              ControlButtonData[j].Top         := DefaultButtonData[j].Top    ;
              // Width/Height are ok
            end;
        end;

  finally
        ini.free;
  end;

  if Not LoadGraphicFromBaseName(CompleteBitmap, DirName + '\main', false) then
      PaintFallbackImage(CompleteBitmap);

  fBrowseBitmapLoaded     := LoadGraphicFromBaseName(BrowseBitmap    , DirName + '\BackgroundBrowse'   , False);
  fMedialistBitmapLoaded  := LoadGraphicFromBaseName(MedialistBitmap , DirName + '\BackgroundMedialist', False);
  fPlaylistBitmapLoaded   := LoadGraphicFromBaseName(Playlistbitmap  , DirName + '\BackgroundPlaylist' , False);

  if UseSeparatePlayerBitmap then
  begin
      fControlPlayerLoaded     := LoadGraphicFromBaseName(PlayerBitmap        , DirName + '\player'          , True);
      fControlSelectionLoaded  := LoadGraphicFromBaseName(ControlSelectionBmp , DirName + '\ControlSelection', True);
      fControCoverLoaded       := LoadGraphicFromBaseName(ControlCoverBmp     , DirName + '\ControlCover'    , True);
      fControlProgressLoaded   := LoadGraphicFromBaseName(ControlProgressBmp  , DirName + '\ControlProgress' , True);
      // fControlVisLoaded        := LoadGraphicFromBaseName(ControlVisBmp       , DirName + '\ControlVis'      , True);

      if not fControlPlayerLoaded    then PaintFallbackImage(PlayerBitmap);
      if not fControlSelectionLoaded then PaintFallbackImage(ControlSelectionBmp);
      if not fControCoverLoaded      then PaintFallbackImage(ControlCoverBmp);
      if not fControlProgressLoaded  then PaintFallbackImage(ControlProgressBmp);
      // if not fControlVisLoaded       then PaintFallbackImage(ControlVisBmp);

      // this one will be always used in some way
      if not LoadGraphicFromBaseName(ControlGenericBmp, DirName + '\ControlGeneric', True) then
          PaintFallbackImage(ControlGenericBmp);

  end;

  if Not Complete then exit;

  if UseDefaultListImages then
  begin
      Nemp_MainForm.PlaylistVST.Images := Nemp_MainForm.PlayListImageList;
      Nemp_MainForm.VST.Images         := Nemp_MainForm.PlayListImageList;
  end else
  begin
      ListenCompletebmp := TBitmap.Create;
      try
          if not LoadListGraphic(ListenCompletebmp, DirName + '\ListenBilder') then
          begin
              UseDefaultListImages := True;
              Nemp_MainForm.PlaylistVST.Images := Nemp_MainForm.PlayListImageList;
              Nemp_MainForm.VST.Images         := Nemp_MainForm.PlayListImageList;
          end else
          begin
              UseDefaultListImages := False;
              ButtonTmp := TBitmap.Create;
              try
                  Buttontmp.PixelFormat := pf32bit;
                  ButtonTmp.Width := 14;
                  Buttontmp.Height := 14;
                  Nemp_MainForm.PlayListSkinImageList.Clear;
                  for i := 0 to MAX_PLAYLIST_IMAGE_INDEX do
                  begin
                      ButtonTmp.Canvas.CopyRect(
                            rect(0,0,14,14), ListenCompletebmp.Canvas,
                            rect(i*14,0,i*14+14, ButtonTmp.Height));
                      Nemp_MainForm.PlayListSkinImageList.AddMasked(ButtonTmp,Buttontmp.Canvas.Pixels[0,0]);
                  end;
                  Nemp_MainForm.PlaylistVST.Images := Nemp_MainForm.PlayListSkinImageList;
                  Nemp_MainForm.VST.Images         := Nemp_MainForm.PlayListSkinImageList;
              finally
                  ButtonTmp.Free;
              end;
          end;
      finally
          ListenCompletebmp.Free;
      end;
  end;

  if UseDefaultMenuImages or (Not NempOptions.GlobalUseAdvancedSkin) then
  begin
      SetDefaultMenuImages;
  end else
  begin
      ListenCompletebmp := TBitmap.Create;
      try
          if not LoadListGraphic(ListenCompletebmp, DirName + '\MenuImages') then
          begin
              UseDefaultMenuImages := True;
              SetDefaultMenuImages;
          end else
          begin
              UseDefaultMenuImages := False;
              ButtonTmp := TBitmap.Create;
              try
                  Buttontmp.PixelFormat := pf32bit;
                  ButtonTmp.Width := 16;
                  Buttontmp.Height := 16;
                  Nemp_MainForm.MenuSkinImageList.Clear;
                  for i := 0 to MAX_MENUIMAGE_INDEX do
                  begin
                      ButtonTmp.Canvas.CopyRect(
                            rect(0,0,16,16), ListenCompletebmp.Canvas,
                            rect(i*16,0,i*16+16, ButtonTmp.Height));
                      Nemp_MainForm.MenuSkinImageList.AddMasked(ButtonTmp,Buttontmp.Canvas.Pixels[0,0]);
                  end;
                  Nemp_MainForm.Nemp_MainMenu             .Images := Nemp_MainForm.MenuSkinImageList;
                  Nemp_MainForm.Medialist_Browse_PopupMenu.Images := Nemp_MainForm.MenuSkinImageList;
                  Nemp_MainForm.Medialist_View_PopupMenu  .Images := Nemp_MainForm.MenuSkinImageList;
                  Nemp_MainForm.PlayListPOPUP             .Images := Nemp_MainForm.MenuSkinImageList;
                  Nemp_MainForm.Player_PopupMenu          .Images := Nemp_MainForm.MenuSkinImageList;
                  Nemp_MainForm.PopupTools                .Images := Nemp_MainForm.MenuSkinImageList;
              finally
                  ButtonTmp.Free;
              end;

          end;
      finally
          ListenCompletebmp.Free;
      end;
  end;

end;

procedure TNempSkin.SetDefaultMenuImages;
begin
    Nemp_MainForm.Nemp_MainMenu             .Images := Nemp_MainForm.MenuImages;
    Nemp_MainForm.Medialist_Browse_PopupMenu.Images := Nemp_MainForm.MenuImages;
    Nemp_MainForm.Medialist_View_PopupMenu  .Images := Nemp_MainForm.MenuImages;
    Nemp_MainForm.PlayListPOPUP             .Images := Nemp_MainForm.MenuImages;
    Nemp_MainForm.Player_PopupMenu          .Images := Nemp_MainForm.MenuImages;
    Nemp_MainForm.PopupTools                .Images := Nemp_MainForm.MenuImages;
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
    aForm: TForm;
begin
    if FormBuilder.RebuildingRightNow then
        exit;

    // todo: get a matching sub-Form in separate window mode (i.e. the top left one, the bottom right one, ...)
    aForm := Nemp_MainForm;

    if FixedBackGround then
    begin
        case AlignCompleteBackground of

            0: begin // left-center
                  aPoint :=  aForm.ClientToScreen(Point(0, aForm.ClientHeight Div 2));
                  PlayerPageOffsetX := aPoint.X ;
                  PlayerPageOffsetY := aPoint.Y - (CompleteBitmap.Height Div 2);
            end;
            1: begin // right-center
                  aPoint := aForm.ClientToScreen(Point(aForm.ClientWidth, aForm.ClientHeight Div 2));
                  PlayerPageOffsetX := aPoint.X - CompleteBitmap.Width;
                  PlayerPageOffsetY := aPoint.Y - (CompleteBitmap.Height Div 2);
            end;
            2: begin // align to MainControls (use PlayerPageOffset<X/Y>Orig in that case)
                  // PlayerPageOffsetX/Y is some point in the image, "where the painting should start with"
                  // useful when background is aligned with the PlayerControls (but not that useful in 4.11 anymore)
                  aPoint := Nemp_MainForm._ControlPanel.ClientToScreen(Point(0,0));

                  PlayerPageOffsetX := aPoint.X - PlayerPageOffsetXOrig;
                  PlayerPageOffsetY := aPoint.Y - PlayerPageOffsetYOrig;
            end;
            3: begin // left-top
                  aPoint := aForm.ClientToScreen(Point(0,0)); //Nemp_MainForm.ClientToScreen(Point(0,0));
                  PlayerPageOffsetX := aPoint.X ;
                  PlayerPageOffsetY := aPoint.Y ;
            end;
            4: begin //right-top
                  //aPoint := Nemp_MainForm.ClientToScreen(Point(Nemp_MainForm.Width, 0));
                  aPoint := aForm.ClientToScreen(Point(aForm.ClientWidth, 0));

                  PlayerPageOffsetX := aPoint.X - CompleteBitmap.Width;
                  PlayerPageOffsetY := aPoint.Y ;
            end;

            5: begin //left-bottom
                  aPoint := aForm.ClientToScreen(Point(0, aForm.ClientHeight));
                  PlayerPageOffsetX := aPoint.X ;
                  PlayerPageOffsetY := aPoint.Y - CompleteBitmap.Height;
            end;
            6: begin //right-bottom
                  aPoint := aForm.ClientToScreen(Point(aForm.ClientWidth, aForm.ClientHeight));
                  PlayerPageOffsetX := aPoint.X - CompleteBitmap.Width;
                  PlayerPageOffsetY := aPoint.Y - CompleteBitmap.Height;
            end;
        end;

    end else
    begin
        // 2019: This should be the same as in all the "OffsetPoints" in later methods. Or not?
        aPoint := Nemp_MainForm.PlayerControlPanel.ClientToScreen(Point(0,0));
        PlayerPageOffsetX := aPoint.X + PlayerPageOffsetXOrig;
        PlayerPageOffsetY := aPoint.Y + PlayerPageOffsetYOrig;
    end;
end;


procedure TNempSkin.fSetTreeLocalOffsetPoint(aTree: TVirtualStringTree; aAlignment: Integer; DoTile: Boolean; aBitmap: TBitmap; aParent: TWinControl = Nil);
var aPoint: TPoint;
begin

// noch eine Option mit Parent-control. das dann clientToParent nutzen für weiteren offset point, den dann mit dem aPoint verrechnen
// oder so ähnlich ----

    if assigned(aParent) then
    begin
        case aAlignment of
            // left-center
            0: aPoint :=  Point(0 - aTree.Left, (aTree.ClientHeight Div 2) - (aBitmap.Height Div 2) );
            // right-center
            1: aPoint := Point(- aTree.Left + aParent.ClientWidth - aBitmap.Width, (aTree.ClientHeight Div 2) - (aBitmap.Height Div 2) );
            // align to MainControls (use PlayerPageOffset<X/Y>Orig in that case), doesnt make sense here - use "center-center"
            2: aPoint := Point(aTree.Left + (aParent.ClientWidth Div 2) - (aBitmap.Width Div 2), (aTree.ClientHeight Div 2) - (aBitmap.Height Div 2) );
            // left-top
            3: aPoint := Point(0 - aTree.Left,0);
            //right-top
            4: aPoint := Point(-aTree.Left + aParent.ClientWidth - aBitmap.Width, 0);
            //left-bottom
            5: aPoint := Point (0 - aTree.Left, aTree.ClientHeight - aBitmap.Height);
            //right-bottom
            6: aPoint :=  Point (-aTree.Left + aParent.ClientWidth - aBitmap.Width, aTree.ClientHeight - aBitmap.Height);
        end;
    end else
    begin
         aPoint := fGetControlLocalOffsetPoint(aTree, aBitmap, aAlignment);
        {
        case aAlignment of
            // left-center
            0: aPoint :=  Point(0, (aTree.Height Div 2) - (aBitmap.Height Div 2) );
            // right-center
            1: aPoint := Point(aTree.Width - aBitmap.Width, (aTree.Height Div 2) - (aBitmap.Height Div 2) );
            // align to MainControls (use PlayerPageOffset<X/Y>Orig in that case), doesnt make sense here - use "center-center"
            2: aPoint := Point((aTree.Width Div 2) - (aBitmap.Width Div 2), (aTree.Height Div 2) - (aBitmap.Height Div 2) );
            // left-top
            3: aPoint := Point(0,0);
            //right-top
            4: aPoint := Point(aTree.Width - aBitmap.Width, 0);
            //left-bottom
            5: aPoint := Point (0, aTree.Height - aBitmap.Height);
            //right-bottom
            6: aPoint :=  Point (aTree.Width - aBitmap.Width, aTree.Height - aBitmap.Height);
        end;
         }
    end;

    if DoTile then
    begin
        aTree.TreeOptions.PaintOptions := aTree.TreeOptions.PaintOptions - [toStaticbackground];
        aTree.BackgroundOffsetX := - aPoint.X;
        aTree.BackgroundOffsetY := - aPoint.Y;
    end
    else begin
        aTree.TreeOptions.PaintOptions := aTree.TreeOptions.PaintOptions + [toStaticbackground];
        aTree.BackgroundOffsetX :=  aPoint.X;
        aTree.BackgroundOffsetY :=  aPoint.Y;
    end;

end;

procedure TNempSkin.fSetATreeOffset(aVST: TVirtualStringTree);
var pnlPoint: TPoint;
begin
    pnlPoint := aVST.ClientToScreen(Point(0,0));

    if TileBackground then
    begin
        aVST.TreeOptions.PaintOptions := aVST.TreeOptions.PaintOptions - [toStaticbackground];
        aVST.BackgroundOffsetX :=  pnlPoint.X - PlayerPageOffsetX;
        aVST.BackgroundOffsetY :=  pnlPoint.Y - PlayerPageOffsetY;

    end
    else begin
        aVST.TreeOptions.PaintOptions := aVST.TreeOptions.PaintOptions + [toStaticbackground];
        aVST.BackgroundOffsetX := - pnlPoint.X + PlayerPageOffsetX;
        aVST.BackgroundOffsetY := - pnlPoint.Y + PlayerPageOffsetY;
    end;
end;


Procedure TNempSkin.SetArtistAlbumOffsets;
var pnlPoint: TPoint;
begin
    if FormBuilder.RebuildingRightNow then
        exit;

    if self.fBrowseBitmapLoaded then
    begin
        // Todo....a little bit more complicated. 1 Bitmap, but 2 trees
        fSetTreeLocalOffsetPoint(Nemp_MainForm.ArtistsVST, AlignBackgroundBrowse, TileBackgroundBrowse, BrowseBitmap, Nemp_MainForm.PanelStandardBrowse);
        fSetTreeLocalOffsetPoint(Nemp_MainForm.AlbenVST, AlignBackgroundBrowse, TileBackgroundBrowse, BrowseBitmap, Nemp_MainForm.PanelStandardBrowse);


        pnlPoint := fGetControlLocalOffsetPoint(Nemp_MainForm.PanelTagCloudBrowse, BrowseBitmap, AlignBackgroundBrowse);

        // Nemp_MainForm.PanelTagCloudBrowse.ClientToScreen(Point(0,0));
        TagCustomizer.OffsetX :=  - pnlPoint.X;
        TagCustomizer.OffsetY :=  - pnlPoint.Y;
    end else
    begin
        fSetATreeOffset(Nemp_MainForm.ArtistsVST);
        fSetATreeOffset(Nemp_MainForm.AlbenVST);

        pnlPoint := Nemp_MainForm.PanelTagCloudBrowse.ClientToScreen(Point(0,0));
        TagCustomizer.OffsetX :=  pnlPoint.X - PlayerPageOffsetX;
        TagCustomizer.OffsetY :=  pnlPoint.Y - PlayerPageOffsetY;
    end;

end;

procedure TNempSkin.SetVSTOffsets;
var ImgPoint: TPoint;
begin
    if FormBuilder.RebuildingRightNow then
        exit;


    if fMedialistBitmapLoaded then
        fSetTreeLocalOffsetPoint(Nemp_MainForm.VST, self.AlignBackgroundMedialist, self.TileBackgroundMedialist, self.MedialistBitmap)
    else
        fSetATreeOffset(Nemp_MainForm.VST);

    ImgPoint := Nemp_MainForm.ImgBibRating.ClientToScreen(Point(0,0));
    // The "FileOverview"-RatingImage
    Nemp_MainForm.BibRatingHelper.BackGroundBitmap.Width := Nemp_MainForm.ImgBibRating.Width;
    Nemp_MainForm.BibRatingHelper.BackGroundBitmap.Height := Nemp_MainForm.ImgBibRating.Height;
    TileGraphic(CompleteBitmap, TileBackground,
          Nemp_MainForm.BibRatingHelper.BackGroundBitmap.Canvas,
           + ImgPoint.X -  PlayerPageOffsetX,
           + ImgPoint.Y -  PlayerPageOffsetY );

    Nemp_MainForm.BibRatingHelper.ReDrawRatingInStarsOnBitmap(Nemp_MainForm.ImgBibRating.Picture.Bitmap);
end;

Procedure TNempSkin.SetPlaylistOffsets;
begin
    if FormBuilder.RebuildingRightNow then
        exit;

    if fPlaylistBitmapLoaded then
        fSetTreeLocalOffsetPoint(Nemp_MainForm.PlaylistVST, AlignBackgroundPlaylist, TileBackgroundPlaylist, PlaylistBitmap)
    else
        fSetATreeOffset(Nemp_MainForm.PlayListVST);
end;

procedure TNempSkin.SetVSTHeaderSettings;
begin
      if UseAdvancedSkin and NempOptions.GlobalUseAdvancedSkin and not (TreeClientPaintedBySkin) then
      begin
          Nemp_MainForm.ArtistsVST.Header.Options  := Nemp_MainForm.ArtistsVST.Header.Options - [hoOwnerDraw];
          Nemp_MainForm.AlbenVST.Header.Options    := Nemp_MainForm.AlbenVST.Header.Options - [hoOwnerDraw];
          Nemp_MainForm.PlaylistVST.Header.Options := Nemp_MainForm.PlaylistVST.Header.Options - [hoOwnerDraw];
          Nemp_MainForm.VST.Header.Options         := Nemp_MainForm.VST.Header.Options - [hoOwnerDraw];
      end else
      begin
          Nemp_MainForm.ArtistsVST.Header.Options  := Nemp_MainForm.ArtistsVST.Header.Options + [hoOwnerDraw];
          Nemp_MainForm.AlbenVST.Header.Options    := Nemp_MainForm.AlbenVST.Header.Options + [hoOwnerDraw];
          Nemp_MainForm.PlaylistVST.Header.Options := Nemp_MainForm.PlaylistVST.Header.Options + [hoOwnerDraw];
          Nemp_MainForm.VST.Header.Options         := Nemp_MainForm.VST.Header.Options + [hoOwnerDraw];
      end;

      if UseAdvancedSkin and (TreeClientPaintedBySkin or (not NempOptions.GlobalUseAdvancedSkin))  then
      begin
          Nemp_MainForm.PlaylistVST.StyleElements := [seBorder];
          Nemp_MainForm.VST.StyleElements         := [seBorder];
          Nemp_MainForm.ArtistsVST.StyleElements  := [seBorder];
          Nemp_MainForm.AlbenVST.StyleElements    := [seBorder];
      end else
      begin
          Nemp_MainForm.PlaylistVST.StyleElements := [seClient, seBorder];
          Nemp_MainForm.VST.StyleElements         := [seClient, seBorder];
          Nemp_MainForm.ArtistsVST.StyleElements  := [seClient, seBorder];
          Nemp_MainForm.AlbenVST.StyleElements    := [seClient, seBorder];
      end;
end;



procedure TNempSkin.ActivateSkin(NotTheFirstActivation: Boolean = True);
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

        if assigned(DeleteSelection) then
            DeleteSelection.ReloadScheckBoxImages(path, true);

        case SlideButtonMode of
           0,1: begin
                  for i := 0 to High(SlideButtons) do
                  begin
                      SlideButtons[i].Button.DrawMode := dm_Windows;
                      SlideButtons[i].Button.CustomRegion := False;
                      SlideButtons[i].Button.Glyph.Assign(Nil);
                      SlideButtons[i].Button.Refresh;
                  end;
           end;

           2: begin
                  for i := 0 to High(SlideButtons) do
                  begin

                      AssignNemp3Glyph(SlideButtons[i].Button,
                            path + '\' + SlideButtons[i].GlyphFile, True);

                      SlideButtons[i].Button.DrawMode := dm_Skin;

                      {$IFDEF USESTYLES}
                      SlideButtons[i].Button.StyleElements := [];
                      {$ENDIF}

                      SlideButtons[i].Button.CustomRegion := True;
                      SlideButtons[i].Button.Refresh;
                  end;
           end;
        end;

        
        // Buttons / Images konfigurieren.
        AssignButtonSizes;

        AssignStarGraphics;
        AssignABGraphics;
        AssignOtherGraphics;
        RefreshStarGraphicsAllForms;

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
                        AuswahlForm.CloseImageA,
                        Path + '\' + ControlButtonData[ctrlCloseBtn].Name,
                        True);
                    AuswahlForm.CloseImageA.GlyphLine := AuswahlForm.CloseImageA.GlyphLine;
                AssignNemp3Glyph(
                        MedienListeForm.CloseImageM,
                        Path + '\' + ControlButtonData[ctrlCloseBtn].Name,
                        True);
                    MedienListeForm.CloseImageM.GlyphLine := MedienListeForm.CloseImageM.GlyphLine;
                AssignNemp3Glyph(
                        PlaylistForm.CloseImageP,
                        Path + '\' + ControlButtonData[ctrlCloseBtn].Name,
                        True);
                    PlaylistForm.CloseImageP.GlyphLine := PlaylistForm.CloseImageP.GlyphLine;

                AssignNemp3Glyph(
                        ExtendedControlForm.CloseImageE,
                        Path + '\' + ControlButtonData[ctrlCloseBtn].Name,
                        True);
                    ExtendedControlForm.CloseImageE.GlyphLine := ExtendedControlForm.CloseImageE.GlyphLine;

                AssignNemp3Glyph(BtnLoadHeadset,  Path + '\BtnLoadHeadset', True);
                BtnLoadHeadset.GlyphLine := BtnLoadHeadset.GlyphLine;

                AssignNemp3Glyph(BtnHeadsetToPlaylist,  Path + '\BtnHeadsetToPlaylist', True);
                BtnHeadsetToPlaylist.GlyphLine := BtnHeadsetToPlaylist.GlyphLine;

                if FileExists(Path + '\BtnHeadsetPlaynow.bmp')
                or FileExists(Path + '\BtnHeadsetPlaynow.png')
                or FileExists(Path + '\BtnHeadsetPlaynow.jpg')
                then
                    AssignNemp3Glyph(BtnHeadsetPlaynow,  Path + '\BtnHeadsetPlaynow', True)
                else
                    AssignNemp3Glyph(BtnHeadsetPlaynow,  Path + '\BtnPlayPauseHeadset', True);
                BtnHeadsetPlaynow.GlyphLine := BtnHeadsetPlaynow.GlyphLine;

                //AssignNemp3Glyph(PlayPauseHeadSetBtn,  Path + '\BtnPlayPauseHeadset', True);
                AssignNemp3Glyph(PlayPauseHeadSetBtn,  Path + '\BtnPlayPause', True);
                PlayPauseHeadSetBtn.GlyphLine := PlayPauseHeadSetBtn.GlyphLine;

                AssignNemp3Glyph(StopHeadSetBtn,  Path + '\BtnStop', True);
                StopHeadSetBtn.GlyphLine := StopHeadSetBtn.GlyphLine;

                AssignSkinTabGlyphs;
            end;
        end;
  end;

  // Eigenschaften der Bäume
  with Nemp_MainForm do
  begin

      {
      // for skinning the [+] and [-] Buttons in teh Treeview
      if UseDefaultTreeImages then
      begin
          Nemp_MainForm.ArtistsVST.OnAfterCellPaint := Nil;
          Nemp_MainForm.AlbenVST.OnAfterCellPaint := Nil;
          Nemp_MainForm.ArtistsVST.TreeOptions.PaintOptions := Nemp_MainForm.ArtistsVST.TreeOptions.PaintOptions + [toShowButtons];
          Nemp_MainForm.AlbenVST.TreeOptions.PaintOptions := Nemp_MainForm.AlbenVST.TreeOptions.PaintOptions + [toShowButtons];
      end else
      begin
          Nemp_MainForm.ArtistsVST.OnAfterCellPaint := Nemp_MainForm.ArtistsVSTAfterCellPaint;
          Nemp_MainForm.AlbenVST.OnAfterCellPaint := Nemp_MainForm.ArtistsVSTAfterCellPaint;
          Nemp_MainForm.ArtistsVST.TreeOptions.PaintOptions := Nemp_MainForm.ArtistsVST.TreeOptions.PaintOptions - [toShowButtons];
          Nemp_MainForm.AlbenVST.TreeOptions.PaintOptions := Nemp_MainForm.AlbenVST.TreeOptions.PaintOptions - [toShowButtons];
      end;
      }


      Nemp_MainForm.BibRatingHelper.UsebackGround := True;

      if (UseBackGroundImageVorauswahl)  then
      begin
            if self.fBrowseBitmapLoaded then
            begin
                ArtistsVST.Background.Assign(BrowseBitmap);
                AlbenVST.Background.Assign(BrowseBitmap)
            end else
            begin
                ArtistsVST.Background.Assign(CompleteBitmap);
                AlbenVST.Background.Assign(CompleteBitmap);
            end;
      end else
      begin
          ArtistsVST.Background.Assign(Nil);
          AlbenVST.Background.Assign(Nil)
      end;

      if (UseBackgroundImagePlaylist) then
      begin
          if self.fPlaylistBitmapLoaded then
              PlaylistVST.Background.Assign(PlaylistBitmap)
          else
              PlaylistVST.Background.Assign(CompleteBitmap);
      end else
          PlaylistVST.Background.Assign(Nil);


      if (UseBackgroundImageMedienliste) then
      begin
          if self.fMedialistBitmapLoaded then
              VST.Background.Assign(MedialistBitmap)
          else
              VST.Background.Assign(CompleteBitmap)
      end else
          VST.Background.Assign(Nil);

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
      begin
          if self.fBrowseBitmapLoaded then
              TagCustomizer.BackgroundImage := BrowseBitmap
          else
              TagCustomizer.BackgroundImage := CompleteBitmap
      end
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

      // VST-Header
      SetVSTHeaderSettings;

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

        DestVST.Colors.UnfocusedColor                  := SkinColorScheme.Tree_UnfocusedColor[idx]      ;
        DestVST.Colors.SelectionTextColor              := SkinColorScheme.Tree_FontSelectedColor[idx];
        // activate Skin

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
      {if Nemp_MainForm.Components[i] is TLabel then
      begin
        TLabel(Nemp_MainForm.Components[i]).Color := SkinColorScheme.LabelBackGroundCL;
        TLabel(Nemp_MainForm.Components[i]).Font.Color := SkinColorScheme.LabelCL;
        TLabel(Nemp_MainForm.Components[i]).Transparent := DrawTransparentLabel;
      end else   }
      if Nemp_MainForm.Components[i] is TShape then
      begin
          TShape(Nemp_MainForm.Components[i]).Brush.Color := SkinColorScheme.ShapeBrushCL;
          TShape(Nemp_MainForm.Components[i]).Pen.Color := SkinColorScheme.ShapePenCL;
          if Nemp_MainForm.Components[i] is TProgressShape then
          begin
              TProgressShape(Nemp_MainForm.Components[i]).ProgressBrush.Color := SkinColorScheme.ShapeBrushProgressCL;
              TProgressShape(Nemp_MainForm.Components[i]).ProgressPen.Color := SkinColorScheme.ShapePenProgressCL;
          end;
      end
  end;

  // Weitere Eigenschaften der Form setzen
  with Nemp_MainForm do
  begin

    if NotTheFirstActivation then
        // Dont do this on startup. On some systems the complete Desktop is painted
        MedienBib.NewCoverFlow.SetColor(SkinColorScheme.FormCL);

    Color := SkinColorScheme.FormCL;
    MainSplitter.Color := SkinColorScheme.SplitterColor;
    SubSplitter1.Color := SkinColorScheme.SplitterColor;
    SubSplitter2.Color := SkinColorScheme.SplitterColor;
    SplitterBrowse.Color := SkinColorScheme.SplitterColor;
    SplitterFileOverview.Color := SkinColorScheme.SplitterColor;

    LyricsMemo.Color := SkinColorScheme.MemoBackGroundCL;
    LyricsMemo.Font.Color := SkinColorScheme.MemoTextCL;

    Spectrum.PreviewArtistColor := SkinColorScheme.PreviewArtistColor ;
    Spectrum.PreviewTitleColor  := SkinColorScheme.PreviewTitleColor  ;
    Spectrum.PreviewTimeColor   := SkinColorScheme.PreviewTimeColor   ;

    PlayerTimeLbl.Font.Color       := SkinColorScheme.SpecTimeCL;;
    PlayerArtistLabel.Font.Color   := SkinColorScheme.SpecArtistCL;
    PlayerTitleLabel.Font.Color    := SkinColorScheme.SpecTitelCL;

    Spectrum.PreviewShapePenColor           := SkinColorScheme.PreviewShapePenColor           ;
    Spectrum.PreviewShapeBrushColor         := SkinColorScheme.PreviewShapeBrushColor         ;
    Spectrum.PreviewShapeProgressPenColor   := SkinColorScheme.PreviewShapeProgressPenColor   ;
    Spectrum.PreviewShapeProgressBrushColor := SkinColorScheme.PreviewShapeProgressBrushColor ;

    Spectrum.Pen := SkinColorScheme.SpecPenCL;
    Spectrum.Pen2 := SkinColorScheme.SpecPen2CL;
    Spectrum.Peak := SkinColorScheme.SpecPeakCL;

    if (HideMainMenu) or (NempOptions.AnzeigeMode = 1) then
      Menu := NIL
    else
      Menu := Nemp_MainMenu;
  end;

  // Dann: Hintergrundgrafiken-Offsets für die Trees initialisieren
  RepairSkinOffset;
  SetArtistAlbumOffsets;
  SetVSTOffsets;
  SetPlaylistOffsets;

  if NempPartyMode.Active then
      Spectrum.SetScale(NempPartyMode.ResizeFactor)
  else
      Spectrum.SetScale(1);

  // Spectrum-Hintergrund setzen
  UpdateSpectrumGraphics;
  Nemp_MainForm.RepaintVisOnPause;

  {$IFDEF USESTYLES}
  if UseAdvancedSkin and NempOptions.GlobalUseAdvancedSkin then
  begin
      RevokeDragFiles;
      TStylemanager.TrySetStyle(self.AdvancedStyleName);
      //if NotTheFirstActivation then
        Nemp_MainForm.ReInitTaskbarManager(True);
  end
  else
  begin
      if NotTheFirstActivation then
        RevokeDragFiles;
      TStyleManager.TrySetStyle('Windows');
      if NotTheFirstActivation then
        Nemp_MainForm.ReInitTaskbarManager(True);
  end;
  {$ENDIF}

  Nemp_MainForm.CorrectSkinRegionsTimer.Enabled := True;
end;

procedure TNempSkin.SetRegionsAgain;
var i: Integer;
    j: TControlButtons;

begin
    with Nemp_MainForm do
    begin
        if NempOptions.AnzeigeMode = 1 then
            UpdateSmallMainForm;

        case SlideButtonMode of
           2: begin
                  for i := 0 to High(SlideButtons) do
                  begin
                      SlideButtons[i].Button.CustomRegion := True;
                      SlideButtons[i].Button.Refresh;
                  end;
           end;
        end;

        for j := low(Controlbuttons) to High(Controlbuttons) do
                begin
                        ControlButtons[j].CustomRegion := True;
                        ControlButtons[j].Refresh;
                end;

        for i := Low(TabButtons) to High(TabButtons) do
        begin
              TabButtons[i].Button.CustomRegion := True;
              TabButtons[i].Button.Refresh;
        end;


        BtnHeadsetPlaynow     .CustomRegion := True;
        BtnHeadsetToPlaylist  .CustomRegion := True;
        BtnLoadHeadset        .CustomRegion := True;
        PlayPauseHeadSetBtn   .CustomRegion := True;
        StopHeadSetBtn        .CustomRegion := True;

        BtnHeadsetPlaynow      .Refresh;
        BtnHeadsetToPlaylist   .Refresh;
        BtnLoadHeadset         .Refresh;
        PlayPauseHeadSetBtn    .Refresh;
        StopHeadSetBtn         .Refresh;

    end;

end;


procedure TNempSkin.DeActivateSkin(NotTheFirstActivation: Boolean = True);
var i, idx: integer;
  DestVST: TVirtualStringTree;

begin
  isActive := False;
  //zunächst: Ownerdraw der Boxen/Panels setzen
  with Nemp_MainForm do
  begin
      for i := 0 to Nemp_MainForm.ComponentCount - 1 do
      begin
          if Nemp_MainForm.Components[i] is TNempPanel then
            TNempPanel(Nemp_MainForm.Components[i]).OwnerDraw := False;
      end;
  end;

  if assigned(DeleteSelection) then
      DeleteSelection.ReloadScheckBoxImages(ExtractFilePath(ParamStr(0)) + 'Images\', false);

  AuswahlForm.ContainerPanelAuswahlform.OwnerDraw := False;
  MedienListeForm.ContainerPanelMedienBibForm.OwnerDraw := False;
  PlaylistForm.ContainerPanelPlaylistForm.OwnerDraw := False;
  ExtendedControlForm.ContainerPanelExtendedControlsForm.OwnerDraw := False;

  // Grafiken für die Buttons setzen
  with Nemp_MainForm do
  begin
        PlaylistVST.Images := PlayListImageList;
        VST.Images := PlayListImageList;

        Nemp_MainMenu             .Images := MenuImages;
        Medialist_View_PopupMenu  .Images := MenuImages;
        Medialist_Browse_PopupMenu.Images := MenuImages;
        PlayListPOPUP             .Images := MenuImages;
        Player_PopupMenu          .Images := MenuImages;
        PopupTools                .Images := MenuImages;

        SetDefaultButtonSizes;
        AssignButtonSizes;

        AssignWindowsGlyphs(False);
        AssignWindowsTabGlyphs(False);

        AssignStarGraphics;
        AssignABGraphics;
        AssignOtherGraphics;
        RefreshStarGraphicsAllForms;

        for i := 0 to High(SlideButtons) do
        begin
            SlideButtons[i].Button.DrawMode := dm_Windows;
            SlideButtons[i].Button.CustomRegion := False;
            SlideButtons[i].Button.Glyph.Assign(Nil);
            SlideButtons[i].Button.Refresh;
        end;

  end;


  // Eigenschaften der Bäume
  with Nemp_MainForm do
  begin
      {
      // for skinning the [+] and [-] Buttons in teh Treeview
      Nemp_MainForm.ArtistsVST.OnAfterCellPaint := Nil;
      Nemp_MainForm.AlbenVST.OnAfterCellPaint := Nil;
      Nemp_MainForm.ArtistsVST.TreeOptions.PaintOptions := Nemp_MainForm.ArtistsVST.TreeOptions.PaintOptions + [toShowButtons];
      Nemp_MainForm.AlbenVST.TreeOptions.PaintOptions := Nemp_MainForm.AlbenVST.TreeOptions.PaintOptions + [toShowButtons];
      }

      ArtistsVST.Background.Assign(Nil);
      AlbenVST.Background.Assign(Nil);
      PlaylistVST.Background.Assign(Nil);
      VST.Background.Assign(Nil);
      BibRatingHelper.UsebackGround := False;

      BibRatingHelper.ReDrawRatingInStarsOnBitmap(ImgBibRating.Picture.Bitmap);

      TagCustomizer.UseBackGround := False;
      TagCustomizer.TileBackGround:= False;
      TagCustomizer.BackgroundImage := Nil;

      // AlphaBlending
      ArtistsVST.TreeOptions.PaintOptions := ArtistsVST.TreeOptions.PaintOptions - [toUseBlendedSelection];
      AlbenVST.TreeOptions.PaintOptions := AlbenVST.TreeOptions.PaintOptions - [toUseBlendedSelection];
      PlaylistVST.TreeOptions.PaintOptions := PlaylistVST.TreeOptions.PaintOptions - [toUseBlendedSelection];
      VST.TreeOptions.PaintOptions := VST.TreeOptions.PaintOptions - [toUseBlendedSelection];
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

      ArtistsVST.SelectionBlendFactor  := 75 ;
      AlbenVST.SelectionBlendFactor    := 75 ;
      PlaylistVST.SelectionBlendFactor := 75 ;
      VST.SelectionBlendFactor         := 75 ;

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
        DestVST.Colors.UnfocusedSelectionBorderColor   := clInactiveCaption;
        DestVST.Colors.UnfocusedSelectionColor         := clInactiveCaption;

        DestVST.Colors.UnfocusedColor                  := clInactiveCaptionText;
        DestVST.Colors.SelectionTextColor              := clWindowText;
        // windows default skin

      end;
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
          if Nemp_MainForm.Components[i] is TProgressShape then
          begin
              TProgressShape(Nemp_MainForm.Components[i]).ProgressBrush.Color := clHighlight;
              TProgressShape(Nemp_MainForm.Components[i]).ProgressPen.Color := clHotlight;
          end;
      end
  end;

  if NotTheFirstActivation then
      // Dont do this on startup. On some systems the complete Desktop is painted white
      MedienBib.NewCoverFlow.SetColor(clWhite);
  
  // Weitere Eigenschaften der Form setzen
  with Nemp_MainForm do
  begin
    Color := clBtnFace;
    MainSplitter.Color := clBtnFace;
    SubSplitter1.Color := clBtnFace;
    SubSplitter2.Color := clBtnFace;
    SplitterBrowse.Color := clBtnFace;
    SplitterFileOverview.Color := clBtnFace;

    LyricsMemo.Color := clWindow;
    LyricsMemo.Font.Color := clWindowText;

    Spectrum.PreviewArtistColor := clGrayText;
    Spectrum.PreviewTitleColor  := clWindowText;
    Spectrum.PreviewTimeColor   := clWindowText;

    PlayerTimeLbl.Font.Color       := clWindowText;
    PlayerArtistLabel.Font.Color   := clWindowText;
    PlayerTitleLabel.Font.Color    := clWindowText;

    Spectrum.PreviewShapePenColor           := cl3DDkShadow ;
    Spectrum.PreviewShapeBrushColor         := clBtnFace    ;
    Spectrum.PreviewShapeProgressPenColor   := clHighLight  ;
    Spectrum.PreviewShapeProgressBrushColor := clHotLight   ;

    Spectrum.Pen := clBackground;
    Spectrum.Pen2 := clActiveCaption;
    Spectrum.Peak := clBackground;
    Spectrum.UseBackGround := False;
    Spectrum.SetGradientBitmap;
    Spectrum.DrawRating(RatingImage.Tag);
    RepaintVisOnPause;

    if NempOptions.AnzeigeMode = 0 then
        Menu := Nemp_MainMenu;

    {$IFDEF USESTYLES}
    if NotTheFirstActivation then
      RevokeDragFiles;
    TStyleManager.TrySetStyle('Windows');
    if NotTheFirstActivation then
      Nemp_MainForm.ReInitTaskbarManager(True);
    {$ENDIF}
    Nemp_MainForm.CorrectSkinRegionsTimer.Enabled := True;
  end;
end;


procedure TNempskin.TileGraphic(const ATile: TBitmap; aDoTile: Boolean; const ATarget: TCanvas; X, Y: Integer; Stretch: Boolean = False);
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

  if aDoTile{ AND UseBitmap} then
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
            if f=1 then
                ATarget.Draw(XLoop, YLoop, ATile)
            else
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

procedure TNempSkin.DrawAControlPanel(aPanel: TNempPanel; UseBackground: Boolean; JustInternal: Boolean);
var pnlPoint, SourceOffsetPoint: TPoint;
    tmp: TBitmap;
    sourceBmp: TBitmap;
begin
    if UseSeparatePlayerBitmap then
    begin
        tmp := TBitmap.Create;
        try
            tmp.Width := aPanel.Width;
            tmp.Height := aPanel.Height;

            // fallback-Bitmap:

            case AlignControlGenericBackground of
                0: begin
                    //align left
                    SourceOffsetPoint := Point(0,0);
                end;
                1: begin
                    // align right
                    SourceOffsetPoint := Point (Nemp_MainForm._ControlPanel.ClientWidth - ControlGenericBmp.Width, 0)
                end;
                2: begin
                    // align to main control, use also AlignControlGenericOffset
                    // !!!!!!!!!!! Check with Headset
                    if Nemp_MainForm.MainPlayerControlsActive then
                        SourceOffsetPoint := Nemp_MainForm.PlayerControlPanel.ClientToParent(Point(0,0), Nemp_MainForm._ControlPanel)
                    else
                        SourceOffsetPoint := Nemp_MainForm.HeadsetControlPanel.ClientToParent(Point(0,0), Nemp_MainForm._ControlPanel);
                    SourceOffsetPoint.X := SourceOffsetPoint.X - AlignControlGenericOffset;
                end;
            end;



            pnlPoint := aPanel.ClientToParent(Point(0,0), Nemp_MainForm._ControlPanel);
            sourceBmp := ControlGenericBmp;

            case aPanel.Tag of
                1: begin
                    //selection
                    if fControlSelectionLoaded then
                    begin
                        sourceBmp := ControlSelectionBmp;
                        pnlPoint := Point(0,0);
                        SourceOffsetPoint := Point(0,0);
                    end;
                end;

                2: begin
                    // cover
                    if fControCoverLoaded then
                    begin
                        sourceBmp := ControlCoverBmp;
                        pnlPoint := Point(0,0);
                        SourceOffsetPoint := Point(0,0);
                    end;
                end;

                3: begin
                    //MainPlayer/Headset
                    if fControlPlayerLoaded then
                    begin
                        sourceBmp := PlayerBitmap;
                        pnlPoint := Point(0,0);
                        SourceOffsetPoint := Point(0,0);
                    end;
                end;

                4: begin
                    // SlideControl, Title-Display
                    if fControlProgressLoaded then
                    begin
                        sourceBmp := ControlProgressBmp;
                        pnlPoint := Point(0,0);
                        case AlignControlProgressDisplay of
                            0: SourceOffsetPoint := Point(0,0);
                            1: SourceOffsetPoint := Point (Nemp_MainForm.NewPlayerPanel.ClientWidth - ControlProgressBmp.Width, 0)
                        end;
                    end;
                end;

                {
                5: begin
                    // Spectrum
                    if fControlVisLoaded then
                    begin
                        sourceBmp := ControlVisBmp;
                        pnlPoint := Point(0,0);
                        SourceOffsetPoint := Point(0,0);
                    end;
                end;
                }
            end;

            with Nemp_MainForm do
            begin
                if UseBackground then
                    TileGraphic(sourceBmp, TileControlBackground, tmp.Canvas,
                          pnlPoint.X - SourceOffsetPoint.X,
                          pnlPoint.Y - SourceOffsetPoint.Y,
                          false)
                else
                begin
                    tmp.Canvas.Brush.Style := bsSolid;
                    tmp.Canvas.Pen.Color :=  SkinColorScheme.FormCL;
                    tmp.Canvas.Brush.Color := SkinColorScheme.FormCL;
                    tmp.Canvas.FillRect(tmp.Canvas.ClipRect);
                end;
            end;


            if JustInternal then
                PaintedProgressBitmap.Assign(tmp)
            else
                BitBlt(aPanel.Canvas.Handle, 0,   0, tmp.Width, tmp.Height, tmp.Canvas.Handle, 0,  0, srccopy);
        finally
            tmp.Free;
        end;
    end else
        DrawARegularPanel(aPanel, UseBackground);
end;


function TNempSkin.fGetControlLocalOffsetPoint(aControl: TWinControl; aBitmap: TBitmap; aAlignment: Integer): TPoint;
begin
    case aAlignment of
        // left-center
        0: result :=  Point(0, (aControl.ClientHeight Div 2) - (aBitmap.Height Div 2) );
        // right-center
        1: result := Point(aControl.ClientWidth - aBitmap.Width, (aControl.ClientHeight Div 2) - (aBitmap.Height Div 2) );
        // align to MainControls (use PlayerPageOffset<X/Y>Orig in that case), doesnt make sense here - use "center-center"
        2: result := Point((aControl.ClientWidth Div 2) - (aBitmap.Width Div 2), (aControl.ClientHeight Div 2) - (aBitmap.Height Div 2) );
        // left-top
        3: result := Point(0,0);
        //right-top
        4: result := Point(aControl.ClientWidth - aBitmap.Width, 0);
        //left-bottom
        5: result := Point (0, aControl.ClientHeight - aBitmap.Height);
        //right-bottom
        6: result :=  Point (aControl.ClientWidth - aBitmap.Width, aControl.ClientHeight - aBitmap.Height);
    end;
end;



procedure TNempSkin.DrawArtistAlbumPanel(aPanel: TNempPanel; aBibCount: Integer; UseBackground: Boolean = True);
var pnlPoint: TPoint;
    tmp: TBitmap;
    sourceBmp: TBitmap;
begin
    if (aBibCount > 0) or (not self.fBrowseBitmapLoaded) then
        DrawARegularPanel(aPanel, UseBackground)
    else
    begin
        // draw the special BrowseBitmap, according to BrwoseAlignments
        tmp := TBitmap.Create;
        try
            tmp.Width := aPanel.Width;
            tmp.Height := aPanel.Height;
            sourceBmp := BrowseBitmap;
            pnlPoint := fGetControlLocalOffsetPoint(aPanel, sourceBmp, AlignBackgroundBrowse);

            with Nemp_MainForm do
            begin
                if UseBackground then
                    TileGraphic(sourceBmp, self.TileBackgroundBrowse, tmp.Canvas,
                          - pnlPoint.X, - pnlPoint.Y, False)
                else
                begin
                    tmp.Canvas.Brush.Style := bsSolid;
                    tmp.Canvas.Pen.Color :=  SkinColorScheme.FormCL;
                    tmp.Canvas.Brush.Color := SkinColorScheme.FormCL;
                    tmp.Canvas.FillRect(tmp.Canvas.ClipRect);
                end;
            end;

            BitBlt(aPanel.Canvas.Handle, 0,   0, tmp.Width, tmp.Height, tmp.Canvas.Handle, 0,  0, srccopy);
        finally
            tmp.Free;
        end;
    end;
end;


procedure TNempSkin.DrawARegularPanel(aPanel: TNempPanel; UseBackground: Boolean = True);
var pnlPoint: TPoint;
    tmp: TBitmap;
    sourceBmp: TBitmap;
begin
    tmp := TBitmap.Create;
    try
        tmp.Width := aPanel.Width;
        tmp.Height := aPanel.Height;

        pnlPoint := aPanel.ClientToScreen(Point(0,0));

        sourceBmp := CompleteBitmap;
        with Nemp_MainForm do
        begin
            if UseBackground then
                TileGraphic(sourceBmp, TileBackground, tmp.Canvas,
                      pnlPoint.X - PlayerPageOffsetX,
                      pnlPoint.Y - PlayerPageOffsetY,
                      False)
            else
            begin
                tmp.Canvas.Brush.Style := bsSolid;
                tmp.Canvas.Pen.Color :=  SkinColorScheme.FormCL;
                tmp.Canvas.Brush.Color := SkinColorScheme.FormCL;
                tmp.Canvas.FillRect(tmp.Canvas.ClipRect);
            end;
        end;

        BitBlt(aPanel.Canvas.Handle, 0,   0, tmp.Width, tmp.Height, tmp.Canvas.Handle, 0,  0, srccopy);
    finally
        tmp.Free;
    end;
end;



Procedure TNempSkin.UpdateSpectrumGraphics;
begin
    with Nemp_MainForm do
    begin
        // redraw the playerpanel, but only on the internal bitmap, not on the actual panel
        DrawAControlPanel(NewPlayerPanel, True, True);

        Spectrum.SetBackGround(True);
        Spectrum.SetStarBackGround(True);
        Spectrum.DrawRating(RatingImage.Tag);
        Spectrum.SetGradientBitmap;
    end;
end;

function TNempSkin.LoadListGraphic(aTargetBmp: TBitmap;
  aBaseFilename: UnicodeString): Boolean;
var tmpPNG : TPNGImage;
    tmpJPG : TJpegImage;
begin
    result := True;
    if FileExists(aBaseFilename + '.png') then
    begin
        tmpPNG := TPNGImage.Create;
        try
            tmpPNG.LoadFromFile(aBaseFilename + '.png');
            aTargetBmp.Assign(tmpPNG);
        finally
            tmpPNG.free;
        end;
    end else
        if FileExists(aBaseFilename + '.png') then
        begin
            tmpJPG := TJpegImage.Create;
            try
                tmpJPG.LoadFromFile(aBaseFilename + '.jpg');
                aTargetBmp.Assign(tmpJPG);
            finally
                tmpJPG.free;
            end;
        end else
            if FileExists(aBaseFilename + '.bmp') then
                aTargetBmp.LoadFromFile(aBaseFilename + '.bmp')
            else
                result := False;
end;

procedure TNempSkin.PaintFallbackImage(var aBitmap: TBitmap);
begin
    aBitmap.Width := 10;
    aBitmap.Height := 10;
    aBitmap.Canvas.Brush.Color := SkinColorScheme.FormCL;
    aBitmap.Canvas.Pen.Color := SkinColorScheme.LabelCL;
    aBitmap.Canvas.FillRect(CompleteBitmap.Canvas.ClipRect);
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
                  //                    aBmp.Assign(tmpPic.Graphic);

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



procedure TNempSkin.AssignButtonSizes;
var BtnArray: Array[0..7] of TSkinButton;

    i, j: Integer;
    r: TChangeProc;
    b: TControlButtons;

    procedure SwapButtons(a,b: Integer);
    var tmpBtn: TSkinButton;
    begin
        tmpBtn := BtnArray[a];
        BtnArray[a] := BtnArray[b];
        BtnArray[b] := tmpBtn;
    end;


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
    // System-Button
    NempPartyMode.SetButtonPos(ControlButtonData[ctrlCloseBtn]     , i);
    NempPartyMode.SetButtonPos(ControlButtonData[ctrlMinimizeBtn]  , i);

    r := NempPartyMode.ResizeProc;
    with Nemp_MainForm do
    begin
        for b := Low(TControlButtons) to ctrlHeadsetInsertToPlaylistBtn do // ctrlHeadsetInsertToPlaylistBtn do //High(TControlButtons) - 1 do
        begin
            ControlButtons[b].Left   := r(ControlButtonData[b].Left)  ;
            ControlButtons[b].Top    := r(ControlButtonData[b].Top) ;
            ControlButtons[b].Width  := r(ControlButtonData[b].Width) ;
            ControlButtons[b].Height := r(ControlButtonData[b].Height);

            // if b <= ctrlRecordBtn  then
                ControlButtons[b].Visible:= ControlButtonData[b].Visible or (ButtonMode <> 2);
        end;

        BtnArray[0] := PlayPauseBTN        ;
        BtnArray[1] := StopBTN             ;
        BtnArray[2] := PlayPrevBTN         ;
        BtnArray[3] := PlayNextBTN         ;
        BtnArray[4] := RandomBTN           ;
        //Bubblesort für TabOrder
        for i := 0 to 3 do
        begin
            for j := 0 to 3 - i do
            begin
                if (BtnArray[j].Left > BtnArray[j+1].Left) or
                   ((BtnArray[j].Left = BtnArray[j+1].Left) and
                    ((BtnArray[j].Top > BtnArray[j+1].Top))) then
                SwapButtons(j, j+1);
            end;
        end;
        // Buttons sortiert -> TabOrder setzen
        //SlideBarButton.TabOrder := 0;
        for i := 0 to 4 do
            BtnArray[i].TabOrder := i;
        VolButton.TabOrder := 5;

        // the same for HeadsetControls
        BtnArray[0] := PlayPauseHeadSetBtn        ;
        BtnArray[1] := StopHeadSetBtn             ;
        BtnArray[2] := BtnHeadsetPlaynow         ;
        BtnArray[3] := BtnHeadsetToPlaylist         ;
        //Bubblesort für TabOrder
        for i := 0 to 2 do
        begin
            for j := 0 to 2 - i do
            begin
                if (BtnArray[j].Left > BtnArray[j+1].Left) or
                   ((BtnArray[j].Left = BtnArray[j+1].Left) and
                    ((BtnArray[j].Top > BtnArray[j+1].Top))) then
                SwapButtons(j, j+1);
            end;
        end;

        for i := 0 to 3 do
            BtnArray[i].TabOrder := i;
        VolButtonHeadset.TabOrder := 4;
    end;
end;

procedure TNempSkin.SetDefaultButtonSizes;
var j: TControlbuttons;
begin
    for j := low(TControlbuttons) to High(TControlButtons)  do
    begin
      ControlButtonData[j].Visible     := DefaultButtonData[j].Visible;
      ControlButtonData[j].Left        := DefaultButtonData[j].Left        ;
      ControlButtonData[j].Top         := DefaultButtonData[j].Top         ;
      ControlButtonData[j].Width       := DefaultButtonData[j].Width       ;
      ControlButtonData[j].Height      := DefaultButtonData[j].Height      ;
    end;

    with Nemp_MainForm do
    begin
        PlayPauseBTN .TabOrder := 0;
        StopBTN      .TabOrder := 1;
        PlayPrevBTN  .TabOrder := 2;
        PlayNextBTN  .TabOrder := 3;
        RandomBTN    .TabOrder := 4;

        PlayPauseHeadSetBtn  .TabOrder := 0;
        StopHeadSetBtn       .TabOrder := 0;
        BtnHeadsetPlaynow    .TabOrder := 0;
        BtnHeadsetToPlaylist .TabOrder := 0;
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
            for b := Low(TabButtons) to High(TabButtons) do
                AssignWindowsTabGlyph(TabButtons[b].Button, BaseDir + TabButtons[b].GlyphFile, True);
        finally
            tmpBitmap.Free;
        end;
    end;
end;

procedure TNempSkin.AssignSkinTabGlyphs;
var BaseDir: String;
    b: Integer;
    //tmpBitmap: TBitmap;
begin
    with Nemp_MainForm do
    begin
        BaseDir := path + '\';
        for b := Low(TabButtons) to High(TabButtons) do
        begin
            TabButtons[b].Button.DrawMode := dm_Skin;

            if not AssignNemp3Glyph(TabButtons[b].Button, BaseDir + TabButtons[b].GlyphFile, True) then
                AssignWindowsTabGlyph(TabButtons[b].Button, ExtractFilePath(ParamStr(0)) + 'Images\' + TabButtons[b].GlyphFile, True);

            TabButtons[b].Button.Refresh;
        end;
    end;
end;

procedure TNempSkin.AssignABGraphics;
var BaseDir: String;
begin
    if isActive and (not UseDefaultStarBitmaps) then
        BaseDir := path + '\'
    else
        BaseDir := ExtractFilePath(ParamStr(0)) + 'Images\';

    // fallback
    if  (not (FileExists(BaseDir + 'ab-repeat-end.bmp') or FileExists(BaseDir + 'ab-repeat-end.png')))
       or (not (FileExists(BaseDir + 'ab-repeat-start.bmp') or FileExists(BaseDir + 'ab-repeat-start.png')))
    then
        BaseDir := ExtractFilePath(ParamStr(0)) + 'Images\';

    // no scaling here, as Stre
    LoadGraphicFromBaseName(ABRepeatBitmapA, BaseDir + 'ab-repeat-start', False);
    LoadGraphicFromBaseName(ABRepeatBitmapB, BaseDir + 'ab-repeat-end', False);

    with Nemp_MainForm do
    begin
        ab1.Picture.Assign(ABRepeatBitmapA);
        ab2.Picture.Assign(ABRepeatBitmapB);
    end;
end;


procedure TNempSkin.AssignOtherGraphics;
var BaseDir: String;
    tmpbmp: TBitmap;
begin
    if isActive and (not UseDefaultStarBitmaps) then
        BaseDir := path + '\'
    else
        BaseDir := ExtractFilePath(ParamStr(0)) + 'Images\';

    // fallback
    if not (FileExists(BaseDir + 'Volume.bmp')
        or FileExists(BaseDir + 'Volume.png'))
    then
        BaseDir := ExtractFilePath(ParamStr(0)) + 'Images\';

    tmpbmp := TBitmap.Create;
    try
        LoadGraphicFromBaseName(tmpbmp, BaseDir + 'Volume');
        Nemp_MainForm.VolumeImage.Picture.Bitmap.Assign(Nil);
        Nemp_MainForm.VolumeImage.Refresh;
        Nemp_MainForm.VolumeImage.Picture.Bitmap.Assign(tmpbmp);
        Nemp_MainForm.VolumeImageHeadset.Picture.Bitmap.Assign(tmpbmp);
    finally
        tmpbmp.Free;
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

    //if assigned(FDetails) then
    //    FDetails.LoadStarGraphics;
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

            BtnLoadHeadset .drawMode := dm_Windows;
            BtnLoadHeadset .NumGlyphs := 1;
            BtnLoadHeadset .NempGlyph.Assign(Nil);
            LoadGraphicFromBaseName(tmpBitmap, BaseDir + 'BtnLoadHeadset', True);
            BtnLoadHeadset.NempGlyph.Assign(tmpBitmap);
            BtnLoadHeadset.GlyphLine := BtnLoadHeadset.GlyphLine;
            BtnLoadHeadset.Refresh;

            BtnHeadsetToPlaylist .drawMode := dm_Windows;
            BtnHeadsetToPlaylist .NumGlyphs := 1;
            BtnHeadsetToPlaylist .NempGlyph.Assign(Nil);
            LoadGraphicFromBaseName(tmpBitmap, BaseDir + 'BtnHeadsetToPlaylist', True);
            BtnHeadsetToPlaylist.NempGlyph.Assign(tmpBitmap);
            BtnHeadsetToPlaylist.GlyphLine := BtnHeadsetToPlaylist.GlyphLine;
            BtnHeadsetToPlaylist.Refresh;

            BtnHeadsetPlaynow .drawMode := dm_Windows;
            BtnHeadsetPlaynow .NumGlyphs := 1;
            BtnHeadsetPlaynow .NempGlyph.Assign(Nil);
            LoadGraphicFromBaseName(tmpBitmap, BaseDir + 'BtnHeadsetPlaynow', True);
            BtnHeadsetPlaynow.NempGlyph.Assign(tmpBitmap);
            BtnHeadsetPlaynow.GlyphLine := BtnHeadsetPlaynow.GlyphLine;
            BtnHeadsetPlaynow.Refresh;

            PlayPauseHeadSetBtn .drawMode := dm_Windows;
            PlayPauseHeadSetBtn .NumGlyphs := 1;
            PlayPauseHeadSetBtn .NempGlyph.Assign(Nil);
            LoadGraphicFromBaseName(tmpBitmap, BaseDir + 'BtnPlayPauseHeadset', True);
            PlayPauseHeadSetBtn.NempGlyph.Assign(tmpBitmap);
            PlayPauseHeadSetBtn.GlyphLine := PlayPauseHeadSetBtn.GlyphLine;
            PlayPauseHeadSetBtn.Refresh;

            StopHeadSetBtn .drawMode := dm_Windows;
            StopHeadSetBtn .NumGlyphs := 1;
            StopHeadSetBtn .NempGlyph.Assign(Nil);
            LoadGraphicFromBaseName(tmpBitmap, BaseDir + 'BtnStopHeadSet', True);
            StopHeadSetBtn.NempGlyph.Assign(tmpBitmap);
            StopHeadSetBtn.GlyphLine := StopHeadSetBtn.GlyphLine;
            StopHeadSetBtn.Refresh;


            LoadGraphicFromBaseName(tmpBitmap, BaseDir + DefaultButtonData[ctrlCloseBtn].Name, True);
            AuswahlForm.CloseImageA.NempGlyph.Assign(tmpBitmap);
            //Buttons12ImageList.GetBitmap(1,AuswahlForm.CloseImage.NempGlyph);
            AuswahlForm.CloseImageA.NumGlyphsX := 1;
            AuswahlForm.CloseImageA.NumGlyphs := 1;

            //Buttons12ImageList.GetBitmap(1,MedienlisteForm.CloseImage.NempGlyph);
            MedienlisteForm.CloseImageM.NempGlyph.Assign(tmpBitmap);
            MedienlisteForm.CloseImageM.NumGlyphsX := 1;
            MedienlisteForm.CloseImageM.NumGlyphs := 1;

            //Buttons12ImageList.GetBitmap(1,PlaylistForm.CloseImage.NempGlyph);
            PlaylistForm.CloseImageP.NempGlyph.Assign(tmpBitmap);
            PlaylistForm.CloseImageP.NumGlyphsX := 1;
            PlaylistForm.CloseImageP.NumGlyphs := 1;

            ExtendedControlForm.CloseImageE.NempGlyph.Assign(tmpBitmap);
            ExtendedControlForm.CloseImageE.NumGlyphsX := 1;
            ExtendedControlForm.CloseImageE.NumGlyphs := 1;

        finally
            tmpBitmap.Free;
        end;
    end;
end;


function TNempSkin.AssignNemp3Glyph(aButton: TSkinButton; aFilename: UnicodeString; Scaled: Boolean=False): Boolean;
var tmpBitmap: TBitmap;
begin
    aButton.DrawMode := dm_Skin;
    {$IFDEF USESTYLES}
     aButton.StyleElements := [];
    {$ENDIF}
    aButton.NumGlyphsX := 5;
    tmpBitmap := TBitmap.Create;
    try
        result := LoadGraphicFromBaseName(tmpBitmap, aFilename, Scaled);
        aButton.NempGlyph.Assign(tmpBitmap);
        aButton.GlyphLine := aButton.GlyphLine;
    finally
        tmpBitmap.Free;
    end;
end;

function TNempSkin.AssignWindowsTabGlyph(aButton: TSkinButton; aFilename: UnicodeString; Scaled: Boolean=False): Boolean;
var tmpBitmap: TBitmap;
begin
    result := True;
    tmpBitmap := TBitmap.Create;
    try
        aButton.DrawMode := dm_Windows;
        aButton.NumGlyphsX := 1;
        aButton.NumGlyphs  := 1;
        aButton.Glyph.Assign(Nil);
        LoadGraphicFromBaseName(tmpBitmap, aFilename, Scaled);
        aButton.NempGlyph.Assign(tmpBitmap);
        aButton.CustomRegion := False;
        aButton.GlyphLine := aButton.GlyphLine;
    finally
        tmpBitmap.Free;
    end;
end;




{$IFDEF USESTYLES}  {
procedure UnSkinForm(aForm: TForm);
var i: Integer;
begin
    aForm.StyleElements := [];
    for i := 0 to aForm.ComponentCount - 1 do
    begin
        if aForm.Components[i] is TControl then
            TControl(aForm.Components[i]).StyleElements := [];

        if aForm.Components[i] is tGroupbox then
            tGroupbox(aForm.Components[i]).StyleElements := [];
    end;

end; }
{$ENDIF}



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
end;

*)

end.
