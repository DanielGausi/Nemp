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

uses
  Windows, Graphics, ExtCtrls, Controls, Types, Forms, dialogs, SysUtils, VirtualTrees,  StdCtrls,
  System.Generics.Defaults, System.Generics.Collections,
  iniFiles, jpeg, NempPanel, NempControls.Common, Classes, oneinst, SkinButtons, PNGImage, ProgressShape, MainFormLayout,
  Nemp_ConstantsAndTypes, PartyModeClass{$IFDEF USESTYLES}, vcl.themes, vcl.styles, Vcl.CheckLst {$ENDIF};

const MAX_MENUIMAGE_INDEX = 43;
      MAX_PLAYLIST_IMAGE_INDEX = 24;

const
  IconIDX_Play = 0;
  IconIDX_Pause = 1;
  IconIDX_Next = 2;
  IconIDX_Prev = 3;
  IconIDX_Stop = 4;
  IconIDX_RepeatAll = 5;
  IconIDX_RepeatTitle = 6;
  IconIDX_RepeatOff = 7;
  IconIDX_RepeatRandom = 8;
  IconIDX_SkipForward = 9;
  IconIDX_SkipBackward = 10;



type
    TPanelList = TList<TNempPanel>;


  // Achtung: Reihenfolge hier jetzt so lassen!!
  TControlButtons = (ctrlPlayPauseBtn,
                     ctrlStopBtn,
                     ctrlNextBtn,
                     ctrlPrevBtn,
                     ctrlSlideForwardBtn,
                     ctrlSlidebackwardBtn,
                     ctrlRandomBtn,
                     ctrlRecordBtn,
                     // SKIN_UMBAU_CHECK ctrlHeadsetPlayBtn,
                     // SKIN_UMBAU_CHECK ctrlHeadsetStopBtn,
                     // SKIN_UMBAU_CHECK ctrlHeadsetPlayNowBtn,
                     // SKIN_UMBAU_CHECK ctrlHeadsetInsertToPlaylistBtn,
                     ctrlMinimizeBtn,
                     ctrlCloseBtn
                     //ctrlMenuBtn
                     );
                     // Der Reverse-Button fällt hier raus. Größe und Position sind fest!!

  type

  TTreeColors = record
    Color,
    Font,
    FontSelected,
    HeaderBackground,
    HeaderFont,
    Border,
    Disabled,
    DropMark,
    DropTargetBorder,
    DropTarget,
    FocussedSelectionBorder,
    FocussedSelection,
    GridLine,
    HeaderHot,
    Hot,
    SelectionRectangleBlend,
    SelectionRectangleBorder,
    TreeLine,
    UnfocusedSelectionBorder,
    UnfocusedSelection,
    Unfocused: TColor;
  end;

const
  cDefaultTreeColors: TTreeColors = (
    Color                          : clWindow;
    Font                           : clWindowText;
    FontSelected                   : clWindowText;
    HeaderBackground               : clWindow;
    HeaderFont                     : clWindowText;
    Border                         : clBtnFace;
    Disabled                       : clBtnShadow;
    DropMark                       : clHighlight;
    DropTargetBorder               : clHighlight;
    DropTarget                     : clHighlight;
    FocussedSelectionBorder        : clHighlight;
    FocussedSelection              : clHighlight;
    GridLine                       : clBtnFace;
    HeaderHot                      : clBtnShadow;
    Hot                            : clWindowText;
    SelectionRectangleBlend        : clHighlight;
    SelectionRectangleBorder       : clHighlight;
    TreeLine                       : clBtnShadow;
    UnfocusedSelectionBorder       : clInactiveCaption;
    UnfocusedSelection             : clInactiveCaption;
    Unfocused                      : clInactiveCaptionText;
  );


type
  // Typ Zur Farbverwaltung des Skins
  TNempColorScheme = record
      FormCL: TColor;
      CoverFlowCl: TColor;
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

      TreeColorsArtist,
      TreeColorsAlbum,
      TreeColorsMain,
      TreeColorsPlaylist: TTreeColors;
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

        // SKIN_UMBAU_CHECK(Name: 'BtnPlayPauseHeadset'   ; Visible: True; Left: 8; Top: 30; Width: 24; Height: 24),  // '',
        // SKIN_UMBAU_CHECK(Name: 'BtnStopHeadSet'        ; Visible: True; Left: 32; Top: 30; Width: 24; Height: 24),  // '',
        // SKIN_UMBAU_CHECK(Name: 'BtnHeadsetPlaynow'     ; Visible: True; Left: 100; Top: 30; Width: 24; Height: 24),  // '',
        // SKIN_UMBAU_CHECK(Name: 'BtnHeadsetToPlaylist'  ; Visible: True; Left: 124; Top: 30; Width: 24; Height: 24),  // '',

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
        fNempMainForm: TForm;
        fCompleteBitmapLoaded,
        fControlGenericLoaded,
        fControlSelectionLoaded,
        fControCoverLoaded,
        fControlPlayerLoaded,
        fControlProgressLoaded : Boolean;
        //fControlVisLoaded

        fBrowseBitmapLoaded,
        fMedialistBitmapLoaded,
        fDetailBitmapLoaded,
        fPlaylistBitmapLoaded   : Boolean;

        fPanelList: TPanelList;

        fCompleteBitmap: TBitmap;
        fBrowseBitmap: TBitmap;
        fMedialistBitmap: TBitmap;
        fPlaylistBitmap: TBitmap;
        fDetailBitmap: TBitmap;
        fMainVST: TVirtualStringTree;
        fPlaylistVST: TVirtualStringTree;
        fAlbenVST: TVirtualStringTree;
        fArtistsVST: TVirtualStringTree;


        function LoadListGraphic(aTargetBmp: TBitmap; aBaseFilename: UnicodeString): Boolean;

        // Die alten Grafiken, bzw. die Default-Grafiken in das neue Glyph-Format bringen
        procedure AssignWindowsGlyphs(UseSkinGraphics: Boolean);
        procedure AssignWindowsTabGlyphs(UseSkinGraphics: Boolean);

        // bitmap offsets of the trees (global, align with CompleteBitmap)
        // procedure fSetATreeOffset(aVST: TVirtualStringTree);
        // bitmap offsets of the trees (align to local Tree-Bitmap)


        // procedure fSetTreeLocalOffsetPoint(aTree: TVirtualStringTree; aAlignment: Integer; DoTile: Boolean; aBitmap: TBitmap; aParent: TWinControl = Nil);

        function GetBackgroundBitmap(aPanel: TNempPanel): TBitmap;
        function GetBackgroundAlignment(aPanel: TNempPanel): Integer;
        function GetTileByTag(aTag: Integer): Boolean;

        function GetBackgroundBasePanel(aControl: TControl): TNempPanel;

        // GetDefaultOffset
        // Get the offset based to PlayerPageOffsetX/PlayerPageOffsetY
        function GetDefaultOffset(aControl: TWinControl): TPoint;
        // GetControlOffset
        // Get the Offset needed for AControl based on the size of the Bitmap and the Alignment
        function GetBaseControlOffset(aBaseControl: TWinControl; aBitmap: TBitmap; aAlignment: Integer): TPoint;
        // GetBackgroundOffset
        function GetBackgroundOffset(aControl: TWinControl; aBitmap: TBitmap; aAlignment: Integer): TPoint;
        // SetTreeBackgroundOffset
        // Set the Offsets of the TVirtualStringTree
        procedure SetTreeBackgroundOffset(aTree: TVirtualStringTree);

//        procedure AssignDefaultSystemButtons;

        procedure SetTreeColors(aTree: TVirtualStringTree; aTreeColors: TTreeColors);

        procedure AssignSkinTabGlyphs;

        procedure SetDefaultButtonSizes;
        // Setzt die Buttongrößen im Hauptfenster und sortiert die TabOrder
        procedure AssignButtonSizes;

        //procedure AssignClassicGlyph(aButton: TSkinButton; aFilename: UnicodeString);
        function AssignNemp3Glyph(aButton: TSkinButton; aFilename: UnicodeString; Scaled: Boolean=False): Boolean;
        function AssignWindowsTabGlyph(aButton: TSkinButton; aFilename: UnicodeString; Scaled: Boolean=False): Boolean;

        procedure AssignStarGraphics;
        procedure AssignABGraphics;

        function GetBrowseBitmap: TBitmap;
        function GetMedialistBitmap: TBitmap;
        function GetDetailBitmap: TBitmap;
        function GetPlaylistbitmap: TBitmap;

      public
        Name: UnicodeString;
        Path: UnicodeString;
        isActive: Boolean;

        PlayerBitmap: TBitmap;
        ControlSelectionBmp,
        ControlCoverBmp,
        ControlProgressBmp,
        ControlGenericBmp: TBitmap;

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
        AlignBackgroundDetail,
        AlignBackgroundPlaylist: Integer;



        // a copy of the Bitmap painted on the Progress-Panel
        // used for painting the backgrounds of Rating-Stars and Visualisation later
        // PaintedProgressBitmap: TBitmap;

        //ExtendedPlayerBitmap: TBitmap;
        SetStarBitmap: TBitmap;
        HalfStarBitmap: TBitmap;
        UnSetStarBitmap: TBitmap;
        CountStarBitmap: TBitmap;
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
        UseBackgroundImageDetails     : boolean;
        UseBackgroundTagCloud         : boolean;

        UseBackgroundImages: Array[0..4] of boolean;

        TileControlBackground: Boolean;
        TileBackground: Boolean;  // Hintergrund kacheln
        FixedBackGround: Boolean; // Hintergrund fixieren
        // FixedBackGround = 1 (True) means, that the background image is aligned to the NempForm
        // FixedBackGround = 0 (False) means, that the background image is aligned to the DESKTOP

        //Tile yes/no if a special background-image for these part is Loaded
        TileBackgroundBrowse,
        TileBackgroundMedialist,
        TileBackgroundPlaylist,
        TileBackgroundDetails: Boolean;

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

        TabButtons: Array [0..22] of SkinButtonRec;
        // SKIN_UMBAU_CHECK SlideButtons: Array [0..0] of SkinButtonRec;

        NempPartyMode: TNempPartyMode;

        FormLayout: TNempLayout;

        property ControlProgressLoaded: Boolean read fControlProgressLoaded;
        property PanelList: TPanelList read fPanelList;

        property CompleteBitmap  : TBitmap read  fCompleteBitmap;
        property BrowseBitmap    : TBitmap read  GetBrowseBitmap;
        property MedialistBitmap : TBitmap read  GetMedialistBitmap;
        property DetailBitmap    : TBitmap read  GetDetailBitmap;
        property PlaylistBitmap  : TBitmap read  GetPlaylistBitmap;

        property ArtistsVST : TVirtualStringTree read fArtistsVST  write fArtistsVST ;
        property AlbenVST   : TVirtualStringTree read fAlbenVST    write fAlbenVST   ;
        property MainVST    : TVirtualStringTree read fMainVST     write fMainVST    ;
        property PlaylistVST: TVirtualStringTree read fPlaylistVST write fPlaylistVST;



        constructor create(aMainForm: TForm);
        destructor Destroy;  override;         //Complete:: Für die Optionen-Vorschau. Da z.B. nicht die SkinButtons ändern
        procedure LoadFromDir(DirName: UnicodeString; Complete: Boolean = True);
        procedure Reload;
        //procedure SaveToDir(DirName: UnicodeString);
        //procedure copyFrom(aSkin: TNempskin);


        Procedure FitSkinToNewWindow;  // Setz den ganzen Skin bei Bedarf um
        Procedure FitPlayerToNewWindow; // Setzt nur den Player-Teil um
        procedure RepairSkinOffset;

        procedure RefreshTreeOffsets(aTree: TVirtualStringTree = Nil);

        //Procedure SetArtistAlbumOffsets;
        //procedure SetVSTOffsets;
        //Procedure SetPlaylistOffsets;

        procedure SetDefaultMenuImages;

        procedure SetVSTHeaderSettings;

        //procedure DrawPreview(aPanel: TNempPanel);

        //procedure DrawAPanel(aPanel: TNempPanel; UseBackground: Boolean = True);

        procedure OnPaintBackgroundControlPanel(Sender: TNempPanel; var Bitmap: TBitmap; var Offset: TPoint; var Tile: Boolean);
        procedure OnPaintBackgroundRegularPanel(Sender: TNempPanel; var Bitmap: TBitmap; var Offset: TPoint; var Tile: Boolean);
        // procedure OnPaintEmptyLibraryPanel(Sender: TNempPanel; var Bitmap: TBitmap; var Offset: TPoint; var Tile: Boolean);

        //procedure DrawARegularPanel(aPanel: TNempPanel; UseBackground: Boolean = True);
        // procedure DrawAControlPanel(aPanel: TNempPanel; UseBackground: Boolean; JustInternal: Boolean);
        // Special case: Empty Library - Draw BrowseBitmap on Panel, not on the Tree/whatever
        // procedure DrawArtistAlbumPanel(aPanel: TNempPanel; aBibCount: Integer; UseBackground: Boolean = True);

        //procedure DrawGroupboxFrame(aGroupbox: TNempGroupbox);

        function RepeatBtnImageIndex(aMode: Integer): Integer;

        // Procedure UpdateSpectrumGraphics;
        procedure ActivateSkin(NotTheFirstActivation: Boolean = True);
        procedure DeActivateSkin(NotTheFirstActivation: Boolean = True);
        procedure SetRegionsAgain;

        // procedure TileGraphic(const ATile: TBitmap; aDoTile: Boolean; const ATarget: TCanvas; X, Y: Integer; Stretch: Boolean = False);

        //function CreatePlayerBitmap: boolean;

        /// function SaveButton(aBmp: TBitmap; aFilename: String): boolean;
        //procedure CreateButtonFiles(CutMode: Integer);
        //procedure CorrectButtonFile(Cutmode: Integer; btnidx: Integer; BtnMode: Integer; Row: Integer);

        // LoadGraphicFromBaseName: Load Graphic from a file
        // aFilename<Scale>.<Ext>
        // where <Scale> is a Scalefactor-Suffix (for alternate Graphics in Partymode)
        // and <Ext> is png, bmp or jpg
        function LoadGraphicFromBaseName(aBmp: TBitmap; aFilename: UnicodeString; Scaled: Boolean=False): Boolean;

        // procedure PaintFallbackImage(var aBitmap: TBitmap);

        procedure AssignOtherGraphics; // Volume etc.



  end;

  function GetSkinDirFromSkinName(aName: String): String;

  {$IFDEF USESTYLES}
  // not used atm
  //procedure UnSkinForm(aForm: TForm);
  {$ENDIF}


const CustomColorNames : Array [0..15] of string = ('ColorA','ColorB','ColorC','ColorD','ColorE','ColorF','ColorG','ColorH','ColorI','ColorJ','ColorK','ColorL','ColorM','ColorN','ColorO','ColorP');

implementation


uses NempMainUnit, PlayerClass, Details, OptionsComplete, Hilfsfunktionen, System.StrUtils,
    SplitForm_Hilfsfunktionen, PlaylistUnit, AuswahlUnit, MedienlisteUnit, ExtendedControlsUnit,
    VSTEditControls, MedienBibliothekClass, TagClouds, Systemhelper, DeleteSelect;

function GetSkinDirFromSkinName(aName: String): String;
begin
  result := ExtractFilePath(ParamStr(0)) + 'Skins\' + aName;

    {result := StringReplace(aName,
              '<public> ', ExtractFilePath(ParamStr(0)) + 'Skins\', []);

    result := StringReplace(result,
              '<private> ', GetShellFolder(CSIDL_APPDATA) + '\Gausi\Nemp\Skins\',[]);
    }
end;

constructor TNempSkin.create(aMainForm: TForm);
begin
  inherited create;
  fNempMainForm := aMainForm;

  fPanelList := TPanelList.Create;

  fCompleteBitmap := TBitmap.Create;
  PlayerBitmap := TBitmap.Create;

  fMedialistBitmap := TBitmap.Create;
  fBrowseBitmap := TBitmap.Create;
  fPlaylistbitmap := TBitmap.Create;
  fDetailBitmap := TBitmap.Create;


  ControlSelectionBmp := TBitmap.Create;
  ControlCoverBmp     := TBitmap.Create;
  ControlProgressBmp  := TBitmap.Create;
  // ControlVisBmp       := TBitmap.Create;
  ControlGenericBmp   := TBitmap.Create;
  // PaintedProgressBitmap := TBitmap.Create;

  NempPartyMode := TNempPartyMode.Create;
  NempPartymode.BackupOriginalPositions;

  SetStarBitmap := TBitmap.Create;
  HalfStarBitmap:= TBitmap.Create;
  UnSetStarBitmap := TBitmap.Create;
  CountStarBitmap := TBitmap.Create;
  ABrepeatBitmapA := TBitmap.Create;
  ABrepeatBitmapB := TBitmap.Create;


  SetStarBitmap.Transparent := True;
  HalfStarBitmap.Transparent := True;
  UnSetStarBitmap.Transparent := True;
  CountStarBitmap.Transparent := True;
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
  CountStarBitmap.Width := 14;
  CountStarBitmap.Height := 14;
  CountStarBitmap.Canvas.Rectangle(0,0,14,14);
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

  // SKIN_UMBAU_CHECKControlButtons[ctrlHeadsetPlayBtn            ] := Nemp_MainForm.PlayPauseHeadSetBtn  ;
  // SKIN_UMBAU_CHECKControlButtons[ctrlHeadsetStopBtn            ] := Nemp_MainForm.StopHeadSetBtn       ;
  // SKIN_UMBAU_CHECKControlButtons[ctrlHeadsetPlayNowBtn         ] := Nemp_MainForm.BtnHeadsetPlaynow    ;
  // SKIN_UMBAU_CHECKControlButtons[ctrlHeadsetInsertToPlaylistBtn] := Nemp_MainForm.BtnHeadsetToPlaylist ;

  ControlButtons[ctrlMinimizeBtn     ] :=  Nemp_MainForm.BtnMinimize     ;
  ControlButtons[ctrlCloseBtn        ] :=  Nemp_MainForm.BtnClose        ;
  //ControlButtons[ctrlMenuBtn         ] :=  Nemp_MainForm.BtnMenu         ;

  TabButtons[0].Button    :=  Nemp_MainForm.TabBtn_Cover         ;
  TabButtons[1].Button    :=  Nemp_MainForm.TabBtn_SummaryLock   ;
  TabButtons[2].Button    :=  Nemp_MainForm.TabBtn_Equalizer     ;
  TabButtons[3].Button    :=  Nemp_MainForm.TabBtn_MainPlayerControl    ; // main playback // Headset playback
  TabButtons[4].Button    :=  Nemp_MainForm.TabBtn_Playlist      ;
  TabButtons[5].Button    :=  Nemp_MainForm.TabBtn_Browse0        ;
  TabButtons[6].Button    :=  Nemp_MainForm.TabBtn_CoverFlow0     ;
  TabButtons[7].Button    :=  Nemp_MainForm.TabBtn_TagCloud0      ;
  TabButtons[8].Button    :=  Nemp_MainForm.TabBtn_Preselection0  ;
  TabButtons[9].Button    :=  Nemp_MainForm.TabBtn_Medialib      ;
  TabButtons[10].Button   :=  Nemp_MainForm.TabBtn_Headset       ; // headset playback
  TabButtons[11].Button   :=  Nemp_mainForm.TabBtn_Marker        ;
  TabButtons[12].Button   :=  Nemp_mainForm.TabBtn_Favorites     ;
  TabButtons[13].Button   :=  Nemp_mainForm.TabBtnCoverCategory     ;
  TabButtons[14].Button   :=  Nemp_mainForm.TabBtnTagCloudCategory  ;

  TabButtons[15].Button    :=  Nemp_MainForm.TabBtn_Browse1        ;
  TabButtons[16].Button    :=  Nemp_MainForm.TabBtn_CoverFlow1     ;
  TabButtons[17].Button    :=  Nemp_MainForm.TabBtn_TagCloud1      ;
  TabButtons[18].Button    :=  Nemp_MainForm.TabBtn_Preselection1  ;
  TabButtons[19].Button    :=  Nemp_MainForm.TabBtn_Browse2        ;
  TabButtons[20].Button    :=  Nemp_MainForm.TabBtn_CoverFlow2     ;
  TabButtons[21].Button    :=  Nemp_MainForm.TabBtn_TagCloud2      ;
  TabButtons[22].Button    :=  Nemp_MainForm.TabBtn_Preselection2  ;



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
  TabButtons[13].GlyphFile := 'TabBtnCategory'   ;
  TabButtons[14].GlyphFile := 'TabBtnCategory'   ;
  TabButtons[15].GlyphFile := 'TabBtnBrowse'      ;
  TabButtons[16].GlyphFile := 'TabBtnCoverflow'   ;
  TabButtons[17].GlyphFile := 'TabBtnTagCloud'    ;
  TabButtons[18].GlyphFile := 'TabBtnNemp'        ;
  TabButtons[19].GlyphFile := 'TabBtnBrowse'      ;
  TabButtons[20].GlyphFile := 'TabBtnCoverflow'   ;
  TabButtons[21].GlyphFile := 'TabBtnTagCloud'    ;
  TabButtons[22].GlyphFile := 'TabBtnNemp'        ;

  // SKIN_UMBAU_CHECK SlideButtons[0].Button  := Nemp_MainForm.SlideBarButton      ;
  // SKIN_UMBAU_CHECK SlideButtons[2].Button := Nemp_MainForm.VolButtonHeadset    ;
  // SKIN_UMBAU_CHECK SlideButtons[0].GlyphFile := 'SlideBtnLeftRight'; //'SlideBtnVolume';
  // SKIN_UMBAU_CHECK SlideButtons[2].GlyphFile := 'SlideBtnLeftRight';//'SlideBtnVolume';

  RegisteredStyles := TStringList.Create;
end;

destructor TNempSkin.Destroy;
begin
  RegisteredStyles.Free;
  fPanelList.Free;

  fCompleteBitmap.Free;
  fMedialistBitmap.Free;
  fPlaylistbitmap.Free;
  fDetailBitmap.Free;
  fBrowseBitmap.Free;


  PlayerBitmap.Free;
  ControlSelectionBmp  .Free;
  ControlCoverBmp      .Free;
  ControlProgressBmp   .Free;
  ControlGenericBmp    .Free;
  // PaintedProgressBitmap.Free;

  SetStarBitmap.Free;
  HalfStarBitmap.Free;
  UnSetStarBitmap.Free;
  CountStarBitmap.Free;
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
var i: integer;
  ini: TMemIniFile;
   n {$IFDEF USESTYLES}, StyleFilename{$ENDIF}: String;
  Buttontmp, ListenCompletebmp: TBitmap;
  aPoint: TPoint;
  j: TControlButtons;
  SkinVersion: Integer;

  {$IFDEF USESTYLES}StyleInfo: TStyleInfo;{$ENDIF}

  function ReadTreeColors(const aSection: String): TTreeColors;
  begin
    result.Color                    := StringToColor(Ini.ReadString(aSection, 'Tree_Color'                             , 'clWindow' ));
    result.Font                     := StringToColor(Ini.ReadString(aSection, 'Tree_FontColor'                         , 'clWindowText' ));
    result.FontSelected             := StringToColor(Ini.ReadString(aSection, 'Tree_FontColorSelected'                 , 'clWindow' ));
    result.HeaderBackground         := StringToColor(Ini.ReadString(aSection, 'Tree_HeaderBackgroundColor'             , 'clGradientActiveCaption'     ));
    result.HeaderFont               := StringToColor(Ini.ReadString(aSection, 'Tree_HeaderFontColor'                   , 'clWindowText' ));
    result.Border                   := StringToColor(Ini.ReadString(aSection, 'Tree_BorderColor'                       , 'clBtnFace'    ));
    result.Disabled                 := StringToColor(Ini.ReadString(aSection, 'Tree_DisabledColor'                     , 'clBtnShadow'  ));
    result.DropMark                 := StringToColor(Ini.ReadString(aSection, 'Tree_DropMarkColor'                     , 'clHighlight'  ));
    result.DropTargetBorder         := StringToColor(Ini.ReadString(aSection, 'Tree_DropTargetBorderColor'             , 'clHighlight'  ));
    result.DropTarget               := StringToColor(Ini.ReadString(aSection, 'Tree_DropTargetColor'                   , 'clHighlight'  ));
    result.FocussedSelectionBorder  := StringToColor(Ini.ReadString(aSection, 'Tree_FocussedSelectionBorder'           , 'clHighlight'  ));
    result.FocussedSelection        := StringToColor(Ini.ReadString(aSection, 'Tree_FocussedSelectionColor'            , 'clHighlight'  ));
    result.GridLine                 := StringToColor(Ini.ReadString(aSection, 'Tree_GridLineColor'                     , 'clBtnFace'    ));
    result.HeaderHot                := StringToColor(Ini.ReadString(aSection, 'Tree_HeaderHotColor'                    , 'clBtnShadow'  ));
    result.Hot                      := StringToColor(Ini.ReadString(aSection, 'Tree_HotColor'                          , 'clWindowText' ));
    result.SelectionRectangleBlend  := StringToColor(Ini.ReadString(aSection, 'Tree_SelectionRectangleBlendColor'      , 'clHighlight'  ));
    result.SelectionRectangleBorder := StringToColor(Ini.ReadString(aSection, 'Tree_SelectionRectangleBorderColor'     , 'clHighlight'  ));
    result.TreeLine                 := StringToColor(Ini.ReadString(aSection, 'Tree_TreeLineColor'                     , 'clBtnShadow'  ));
    result.UnfocusedSelectionBorder := StringToColor(Ini.ReadString(aSection, 'Tree_UnfocusedSelectionBorderColor'     , 'clBtnFace'    ));
    result.UnfocusedSelection       := StringToColor(Ini.ReadString(aSection, 'Tree_UnfocusedSelectionColor'           , 'clBtnFace'    ));
    result.Unfocused                := StringToColor(Ini.ReadString(aSection, 'Tree_UnfocusedColor'                    , 'clBtnFace'    ));
  end;

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
        UseBackgroundImageDetails       := Not Ini.ReadBool('BackGround','HideBackgroundImageDetails'      , False);

        UseBackgroundImages[0] := True; // Player immer!
        UseBackgroundImages[1] := UseBackgroundImagePlaylist;
        UseBackgroundImages[2] := UseBackGroundImageVorauswahl;
        UseBackgroundImages[3] := UseBackgroundImageMedienliste;
        UseBackgroundImages[4] := UseBackgroundImageDetails;
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
        AlignBackgroundDetail         := Ini.ReadInteger('BackGround','AlignBackgroundDetail'      , 5);
        AlignBackgroundPlaylist       := Ini.ReadInteger('BackGround','AlignBackgroundPlaylist'    , 5);

        TileBackgroundBrowse      := Ini.ReadBool('BackGround','TileBackgroundBrowse'      , False);
        TileBackgroundMedialist   := Ini.ReadBool('BackGround','TileBackgroundMedialist'   , False);
        TileBackgroundPlaylist    := Ini.ReadBool('BackGround','TileBackgroundPlaylist'    , False);
        TileBackgroundDetails     := Ini.ReadBool('BackGround','TileBackgroundDetails'     , False);


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
        if ini.ValueExists('Colors','CoverFlowCl') then
          SkinColorScheme.CoverFlowCl           := StringToColor(Ini.ReadString('Colors','CoverFlowCl'          , 'clWindow'   ))
        else
          SkinColorScheme.CoverFlowCl := SkinColorScheme.FormCL;
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

        // Colors for the Trees
        SkinColorScheme.TreeColorsArtist  := ReadTreeColors('ArtistColors');
        SkinColorScheme.TreeColorsAlbum   := ReadTreeColors('AlbenColors');
        SkinColorScheme.TreeColorsMain    := ReadTreeColors('MedienlisteColors');
        SkinColorScheme.TreeColorsPlaylist:= ReadTreeColors('PlaylistColors');

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
        // SKIN_UMBAU_CHECKif SkinVersion < 4 then
        // SKIN_UMBAU_CHECKbegin
        // SKIN_UMBAU_CHECK    for j := low(TControlbuttons) to ctrlHeadsetInsertToPlaylistBtn do //High(TControlButtons) - 1 do
        // SKIN_UMBAU_CHECK    begin
        // SKIN_UMBAU_CHECK      ControlButtonData[j].Left        := DefaultButtonData[j].Left   ;
        // SKIN_UMBAU_CHECK      ControlButtonData[j].Top         := DefaultButtonData[j].Top    ;
        // SKIN_UMBAU_CHECK      // Width/Height are ok
        // SKIN_UMBAU_CHECK    end;
        // SKIN_UMBAU_CHECK end;

  finally
        ini.free;
  end;

  //if Not LoadGraphicFromBaseName(CompleteBitmap, DirName + '\main', false) then
  //    PaintFallbackImage(CompleteBitmap);
  fCompleteBitmapLoaded := LoadGraphicFromBaseName(fCompleteBitmap, DirName + '\main', false) ;

  fBrowseBitmapLoaded     := LoadGraphicFromBaseName(fBrowseBitmap    , DirName + '\BackgroundBrowse'   , False);
  fMedialistBitmapLoaded  := LoadGraphicFromBaseName(fMedialistBitmap , DirName + '\BackgroundMedialist', False);
  fPlaylistBitmapLoaded   := LoadGraphicFromBaseName(fPlaylistbitmap  , DirName + '\BackgroundPlaylist' , False);
  fDetailBitmapLoaded     := LoadGraphicFromBaseName(fDetailBitmap    , DirName + '\BackgroundDetails'  , False);

  if UseSeparatePlayerBitmap then
  begin
      fControlPlayerLoaded     := LoadGraphicFromBaseName(PlayerBitmap        , DirName + '\player'          , True);
      fControlSelectionLoaded  := LoadGraphicFromBaseName(ControlSelectionBmp , DirName + '\ControlSelection', True);
      fControCoverLoaded       := LoadGraphicFromBaseName(ControlCoverBmp     , DirName + '\ControlCover'    , True);
      fControlProgressLoaded   := LoadGraphicFromBaseName(ControlProgressBmp  , DirName + '\ControlProgress' , True);
      // fControlVisLoaded        := LoadGraphicFromBaseName(ControlVisBmp       , DirName + '\ControlVis'      , True);

      //if not fControlPlayerLoaded    then PaintFallbackImage(PlayerBitmap);
      //if not fControlSelectionLoaded then PaintFallbackImage(ControlSelectionBmp);
      //if not fControCoverLoaded      then PaintFallbackImage(ControlCoverBmp);
      //if not fControlProgressLoaded  then PaintFallbackImage(ControlProgressBmp);
      // if not fControlVisLoaded       then PaintFallbackImage(ControlVisBmp);

      // this one will be always used in some way
      //if not LoadGraphicFromBaseName(ControlGenericBmp, DirName + '\ControlGeneric', True) then
      //    PaintFallbackImage(ControlGenericBmp);
      fControlGenericLoaded := LoadGraphicFromBaseName(ControlGenericBmp, DirName + '\ControlGeneric', True);
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
                  Nemp_MainForm.Medialist_Collection_PopupMenu.Images := Nemp_MainForm.MenuSkinImageList;
                  Nemp_MainForm.Medialist_Category_PopupMenu.Images := Nemp_MainForm.MenuSkinImageList;
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
    Nemp_MainForm.Medialist_Collection_PopupMenu.Images := Nemp_MainForm.MenuImages;
    Nemp_MainForm.Medialist_Category_PopupMenu.Images := Nemp_MainForm.MenuImages;
    Nemp_MainForm.Medialist_View_PopupMenu  .Images := Nemp_MainForm.MenuImages;
    Nemp_MainForm.PlayListPOPUP             .Images := Nemp_MainForm.MenuImages;
    Nemp_MainForm.Player_PopupMenu          .Images := Nemp_MainForm.MenuImages;
    Nemp_MainForm.PopupTools                .Images := Nemp_MainForm.MenuImages;
end;


Procedure TNempSkin.FitSkinToNewWindow;
begin
  RepairSkinOffset;
  RefreshTreeOffsets;
  //UpdateSpectrumGraphics;
end;

Procedure TNempSkin.FitPlayerToNewWindow;
begin
  RepairSkinOffset;
  //UpdateSpectrumGraphics;
end;


procedure TNempSkin.RepairSkinOffset;
var aPoint: TPoint;
    // aForm: TForm;
begin
    if FormLayout.BuildInProcess then
        exit;

    // todo: get a matching sub-Form in separate window mode (i.e. the top left one, the bottom right one, ...)
    // aForm := Nemp_MainForm;

    if FixedBackGround then
    begin
        case AlignCompleteBackground of

            0: begin // left-center
                  aPoint :=  fNempMainForm.ClientToScreen(Point(0, fNempMainForm.ClientHeight Div 2));
                  PlayerPageOffsetX := aPoint.X ;
                  PlayerPageOffsetY := aPoint.Y - (fCompleteBitmap.Height Div 2);
            end;
            1: begin // right-center
                  aPoint := fNempMainForm.ClientToScreen(Point(fNempMainForm.ClientWidth, fNempMainForm.ClientHeight Div 2));
                  PlayerPageOffsetX := aPoint.X - fCompleteBitmap.Width;
                  PlayerPageOffsetY := aPoint.Y - (fCompleteBitmap.Height Div 2);
            end;
            2: begin // align to MainControls (use PlayerPageOffset<X/Y>Orig in that case)
                  // PlayerPageOffsetX/Y is some point in the image, "where the painting should start with"
                  // useful when background is aligned with the PlayerControls (but not that useful in 4.11 anymore)
                  aPoint := Nemp_MainForm._ControlPanel.ClientToScreen(Point(0,0));

                  PlayerPageOffsetX := aPoint.X - PlayerPageOffsetXOrig;
                  PlayerPageOffsetY := aPoint.Y - PlayerPageOffsetYOrig;
            end;
            3: begin // left-top
                  aPoint := fNempMainForm.ClientToScreen(Point(0,0)); //Nemp_MainForm.ClientToScreen(Point(0,0));
                  PlayerPageOffsetX := aPoint.X ;
                  PlayerPageOffsetY := aPoint.Y ;
            end;
            4: begin //right-top
                  //aPoint := Nemp_MainForm.ClientToScreen(Point(Nemp_MainForm.Width, 0));
                  aPoint := fNempMainForm.ClientToScreen(Point(fNempMainForm.ClientWidth, 0));

                  PlayerPageOffsetX := aPoint.X - fCompleteBitmap.Width;
                  PlayerPageOffsetY := aPoint.Y ;
            end;

            5: begin //left-bottom
                  aPoint := fNempMainForm.ClientToScreen(Point(0, fNempMainForm.ClientHeight));
                  PlayerPageOffsetX := aPoint.X ;
                  PlayerPageOffsetY := aPoint.Y - fCompleteBitmap.Height;
            end;
            6: begin //right-bottom
                  aPoint := fNempMainForm.ClientToScreen(Point(fNempMainForm.ClientWidth, fNempMainForm.ClientHeight));
                  PlayerPageOffsetX := aPoint.X - fCompleteBitmap.Width;
                  PlayerPageOffsetY := aPoint.Y - fCompleteBitmap.Height;
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



procedure TNempSkin.RefreshTreeOffsets(aTree: TVirtualStringTree = Nil);
begin
  if FormLayout.BuildInProcess then
    exit;

  if assigned(aTree) then
    SetTreeBackgroundOffset(aTree)
  else begin
    // update all Trees
    SetTreeBackgroundOffset(ArtistsVST);
    SetTreeBackgroundOffset(AlbenVST);
    SetTreeBackgroundOffset(MainVST);
    SetTreeBackgroundOffset(PlaylistVST);
  end;
end;

     (*
Procedure TNempSkin.SetArtistAlbumOffsets;
var pnlPoint: TPoint;
begin
     if FormLayout.BuildInProcess then
        exit;

     SetTreeBackgroundOffset(Nemp_MainForm.ArtistsVST);
     SetTreeBackgroundOffset(Nemp_MainForm.AlbenVST);

    if fBrowseBitmapLoaded then
    begin
        // Todo....a little bit more complicated. 1 Bitmap, but 2 trees
        fSetTreeLocalOffsetPoint(Nemp_MainForm.ArtistsVST, AlignBackgroundBrowse, TileBackgroundBrowse, fBrowseBitmap, Nemp_MainForm.PanelStandardBrowse);
        fSetTreeLocalOffsetPoint(Nemp_MainForm.AlbenVST, AlignBackgroundBrowse, TileBackgroundBrowse, fBrowseBitmap, Nemp_MainForm.PanelStandardBrowse);

        pnlPoint := GetBaseControlOffset(Nemp_MainForm.PanelTagCloudBrowse, fBrowseBitmap, AlignBackgroundBrowse);

        // Nemp_MainForm.PanelTagCloudBrowse.ClientToScreen(Point(0,0));
        TagCustomizer.OffsetX :=  - pnlPoint.X;
        TagCustomizer.OffsetY :=  - pnlPoint.Y;
    end else
    begin
        fSetATreeOffset(Nemp_MainForm.ArtistsVST);
        fSetATreeOffset(Nemp_MainForm.AlbenVST);

        pnlPoint := Nemp_MainForm.PanelTagCloudBrowse.ClientToScreen(Point(0,0));
        TagCustomizer.OffsetX := PlayerPageOffsetX - pnlPoint.X ;
        TagCustomizer.OffsetY := PlayerPageOffsetY - pnlPoint.Y ;
    end;

end;
    *)

procedure TNempSkin.SetTreeColors(aTree: TVirtualStringTree; aTreeColors: TTreeColors);
begin
  aTree.Color                                  := aTreeColors.Color;
  aTree.Font.Color                             := aTreeColors.Font;
  aTree.Header.Background                      := aTreeColors.HeaderBackground;
  aTree.Header.Font.Color                      := aTreeColors.HeaderFont;
  aTree.Colors.BorderColor                     := aTreeColors.Border;
  aTree.Colors.DisabledColor                   := aTreeColors.Disabled;
  aTree.Colors.DropMarkColor                   := aTreeColors.DropMark;
  aTree.Colors.DropTargetBorderColor           := aTreeColors.DropTargetBorder;
  aTree.Colors.DropTargetColor                 := aTreeColors.DropTarget;
  aTree.Colors.FocusedSelectionBorderColor     := aTreeColors.FocussedSelectionBorder;
  aTree.Colors.FocusedSelectionColor           := aTreeColors.FocussedSelection;
  aTree.Colors.GridLineColor                   := aTreeColors.GridLine;
  aTree.Colors.HeaderHotColor                  := aTreeColors.HeaderHot;
  aTree.Colors.HotColor                        := aTreeColors.Hot;
  aTree.Colors.SelectionRectangleBlendColor    := aTreeColors.SelectionRectangleBlend;
  aTree.Colors.SelectionRectangleBorderColor   := aTreeColors.SelectionRectangleBorder;
  aTree.Colors.TreeLineColor                   := aTreeColors.TreeLine;
  aTree.Colors.UnfocusedSelectionBorderColor   := aTreeColors.UnfocusedSelectionBorder;
  aTree.Colors.UnfocusedSelectionColor         := aTreeColors.UnfocusedSelection;
  aTree.Colors.UnfocusedColor                  := aTreeColors.Unfocused;
  aTree.Colors.SelectionTextColor              := aTreeColors.FontSelected;
end;

procedure TNempSkin.SetVSTHeaderSettings;
begin
      if UseAdvancedSkin and NempOptions.GlobalUseAdvancedSkin and not (TreeClientPaintedBySkin) then
      begin
          ArtistsVST.Header.Options  := ArtistsVST.Header.Options - [hoOwnerDraw];
          AlbenVST.Header.Options    := AlbenVST.Header.Options - [hoOwnerDraw];
          PlaylistVST.Header.Options := PlaylistVST.Header.Options - [hoOwnerDraw];
          MainVST.Header.Options     := MainVST.Header.Options - [hoOwnerDraw];
      end else
      begin
          ArtistsVST.Header.Options  := ArtistsVST.Header.Options + [hoOwnerDraw];
          AlbenVST.Header.Options    := AlbenVST.Header.Options + [hoOwnerDraw];
          PlaylistVST.Header.Options := PlaylistVST.Header.Options + [hoOwnerDraw];
          MainVST.Header.Options     := MainVST.Header.Options + [hoOwnerDraw];
      end;

      if UseAdvancedSkin and (TreeClientPaintedBySkin or (not NempOptions.GlobalUseAdvancedSkin))  then
      begin
          PlaylistVST.StyleElements := [seBorder];
          MainVST.StyleElements     := [seBorder];
          ArtistsVST.StyleElements  := [seBorder];
          AlbenVST.StyleElements    := [seBorder];
      end else
      begin
          PlaylistVST.StyleElements := [seClient, seBorder];
          MainVST.StyleElements     := [seClient, seBorder];
          ArtistsVST.StyleElements  := [seClient, seBorder];
          AlbenVST.StyleElements    := [seClient, seBorder];
      end;
end;


procedure TNempSkin.ActivateSkin(NotTheFirstActivation: Boolean = True);
var i: integer;
  j: TControlButtons;

begin
  isActive := True;
  RevokeDragFiles;

  //zunächst: Ownerdraw der Boxen/Panels setzen
  for i := 0 to fPanelList.Count - 1 do begin
    fPanelList[i].DrawMode := dm_Skin;
    fPanelList[i].BackgroundColor := SkinColorScheme.FormCL;
    fPanelList[i].FrameColor := SkinColorScheme.GroupboxFrameCL;
  end;

  (*for i := 0 to Nemp_MainForm.ComponentCount - 1 do
  begin
    if Nemp_MainForm.Components[i] is TNempPanel then
    begin
      // TNempPanel(Nemp_MainForm.Components[i]).OwnerDraw := True;
      TNempPanel(Nemp_MainForm.Components[i]).DrawMode := dm_skin;
    end;
    // No Groupboxes any longer
    //if Nemp_MainForm.Components[i] is TNempGroupbox then
    //  TNempGroupbox(Nemp_MainForm.Components[i]).OwnerDraw := True;
  end;
  AuswahlForm.ContainerPanelAuswahlform.OwnerDraw := True;
  MedienListeForm.ContainerPanelMedienBibForm.OwnerDraw := True;
  PlaylistForm.ContainerPanelPlaylistForm.OwnerDraw := True;
  ExtendedControlForm.ContainerPanelExtendedControlsForm.OwnerDraw := True;*)

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

        // SKIN_UMBAU_CHECK // SKIN_UMBAU_CHECK  // SKIN_UMBAU_CHECK  // SKIN_UMBAU_CHECK
        (*case SlideButtonMode of
           0,1: begin
                  for i := 0 to High(SlideButtons) do
                  begin
                      SlideButtons[i].Button.DrawMode := dm_Windows;
                      // SKIN_UMBAU_CHECK SlideButtons[i].Button.CustomRegion := False;
                      // SKIN_UMBAU_CHECK SlideButtons[i].Button.Glyph.Assign(Nil);
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

                      // SKIN_UMBAU_CHECK SlideButtons[i].Button.CustomRegion := True;
                      // SKIN_UMBAU_CHECK SlideButtons[i].Button.Refresh;
                  end;
           end;
        end;
        // SKIN_UMBAU_CHECK // SKIN_UMBAU_CHECK // SKIN_UMBAU_CHECK // SKIN_UMBAU_CHECK
        *)

        
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
                    // SKIN_UMBAU_CHECK ControlButtons[j].GlyphLine := ControlButtons[j].GlyphLine;
                end;

                AssignNemp3Glyph(
                        AuswahlForm.CloseImageA,
                        Path + '\' + ControlButtonData[ctrlCloseBtn].Name,
                        True);
                    // SKIN_UMBAU_CHECK AuswahlForm.CloseImageA.GlyphLine := AuswahlForm.CloseImageA.GlyphLine;
                AssignNemp3Glyph(
                        MedienListeForm.CloseImageM,
                        Path + '\' + ControlButtonData[ctrlCloseBtn].Name,
                        True);
                    // SKIN_UMBAU_CHECK MedienListeForm.CloseImageM.GlyphLine := MedienListeForm.CloseImageM.GlyphLine;
                AssignNemp3Glyph(
                        PlaylistForm.CloseImageP,
                        Path + '\' + ControlButtonData[ctrlCloseBtn].Name,
                        True);
                    // SKIN_UMBAU_CHECK PlaylistForm.CloseImageP.GlyphLine := PlaylistForm.CloseImageP.GlyphLine;

                AssignNemp3Glyph(
                        ExtendedControlForm.CloseImageE,
                        Path + '\' + ControlButtonData[ctrlCloseBtn].Name,
                        True);
                    // SKIN_UMBAU_CHECK ExtendedControlForm.CloseImageE.GlyphLine := ExtendedControlForm.CloseImageE.GlyphLine;

                // SKIN_UMBAU_CHECKAssignNemp3Glyph(BtnLoadHeadset,  Path + '\BtnLoadHeadset', True);
                // SKIN_UMBAU_CHECK BtnLoadHeadset.GlyphLine := BtnLoadHeadset.GlyphLine;

                // SKIN_UMBAU_CHECKAssignNemp3Glyph(BtnHeadsetToPlaylist,  Path + '\BtnHeadsetToPlaylist', True);
                // SKIN_UMBAU_CHECK BtnHeadsetToPlaylist.GlyphLine := BtnHeadsetToPlaylist.GlyphLine;

                // SKIN_UMBAU_CHECKif FileExists(Path + '\BtnHeadsetPlaynow.bmp')
                // SKIN_UMBAU_CHECKor FileExists(Path + '\BtnHeadsetPlaynow.png')
                // SKIN_UMBAU_CHECKor FileExists(Path + '\BtnHeadsetPlaynow.jpg')
                // SKIN_UMBAU_CHECKthen
                // SKIN_UMBAU_CHECK    AssignNemp3Glyph(BtnHeadsetPlaynow,  Path + '\BtnHeadsetPlaynow', True)
                // SKIN_UMBAU_CHECKelse
                // SKIN_UMBAU_CHECK    AssignNemp3Glyph(BtnHeadsetPlaynow,  Path + '\BtnPlayPauseHeadset', True);
                // SKIN_UMBAU_CHECK BtnHeadsetPlaynow.GlyphLine := BtnHeadsetPlaynow.GlyphLine;

                //AssignNemp3Glyph(PlayPauseHeadSetBtn,  Path + '\BtnPlayPauseHeadset', True);
                // SKIN_UMBAU_CHECKAssignNemp3Glyph(PlayPauseHeadSetBtn,  Path + '\BtnPlayPause', True);
                // SKIN_UMBAU_CHECK PlayPauseHeadSetBtn.GlyphLine := PlayPauseHeadSetBtn.GlyphLine;

                // SKIN_UMBAU_CHECKAssignNemp3Glyph(StopHeadSetBtn,  Path + '\BtnStop', True);
                // SKIN_UMBAU_CHECK StopHeadSetBtn.GlyphLine := StopHeadSetBtn.GlyphLine;

                AssignSkinTabGlyphs;
            end;
        end;
  end;

  if (UseBackGroundImageVorauswahl)  then begin
        ArtistsVST.Background.Assign(BrowseBitmap);
        AlbenVST.Background.Assign(BrowseBitmap)
      end else begin
        ArtistsVST.Background.Assign(Nil);
        AlbenVST.Background.Assign(Nil)
      end;

      if (UseBackgroundImagePlaylist) then
        PlaylistVST.Background.Assign(Playlistbitmap)
      else
        PlaylistVST.Background.Assign(Nil);

      if (UseBackgroundImageMedienliste) then
        MainVST.Background.Assign(MedialistBitmap)
      else
        MainVST.Background.Assign(Nil);

      // Scrollbars
      if DisableArtistScrollbar then ArtistsVST.ScrollBarOptions.ScrollBars := ssNone
        else ArtistsVST.ScrollBarOptions.ScrollBars := ssVertical;
      if DisableAlbenScrollbar then AlbenVST.ScrollBarOptions.ScrollBars := ssNone
        else AlbenVST.ScrollBarOptions.ScrollBars := ssVertical;
      if DisablePlaylistScrollbar then PlaylistVST.ScrollBarOptions.ScrollBars := ssNone
        else PlaylistVST.ScrollBarOptions.ScrollBars := ssVertical;
      if DisableMedienListeScrollbar then MainVST.ScrollBarOptions.ScrollBars := ssNone
        else MainVST.ScrollBarOptions.ScrollBars := ssBoth;
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
        MainVST.TreeOptions.PaintOptions := MainVST.TreeOptions.PaintOptions + [toUseBlendedSelection]
      else MainVST.TreeOptions.PaintOptions := MainVST.TreeOptions.PaintOptions - [toUseBlendedSelection];

      ArtistsVST.SelectionBlendFactor  := BlendFaktorArtists     ;
      AlbenVST.SelectionBlendFactor    := BlendFaktorAlben       ;
      PlaylistVST.SelectionBlendFactor := BlendFaktorPlaylist    ;
      MainVST.SelectionBlendFactor         := BlendFaktorMedienliste ;

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

      // SKIN_UMBAU_CHECK Nemp_MainForm.BibRatingHelper.UsebackGround := True;

      RefreshCoverflowBackground;

      // TagCloud-Settings
      {TagCustomizer.UseBackGround    := UseBackgroundTagCloud;
      if UseBackgroundTagCloud then
      begin
          if self.fBrowseBitmapLoaded then begin
              // TagCustomizer.BackgroundImage := fBrowseBitmap;
              TagCustomizer.TileBackGround := TileBackgroundBrowse
          end
          else begin
              // TagCustomizer.BackgroundImage := fCompleteBitmap;
              TagCustomizer.TileBackGround := TileBackground;
          end;
      end
      else begin
          // TagCustomizer.BackgroundImage := Nil;
          TileBackgroundBrowse := False;
      end;}

      TagCustomizer.BackgroundColor  := SkinColorScheme.TreeColorsArtist.Color;
      TagCustomizer.FontColor        := SkinColorScheme.TreeColorsArtist.Font;
      TagCustomizer.FocusFontColor   := SkinColorScheme.TreeColorsArtist.FontSelected;
      TagCustomizer.FocusBorderColor := SkinColorScheme.TreeColorsArtist.FocussedSelectionBorder;
      TagCustomizer.FocusBackgroundColor := SkinColorScheme.TreeColorsArtist.FocussedSelection;
      TagCustomizer.HoverFontColor  := SkinColorScheme.TreeColorsArtist.FontSelected;

          TagCustomizer.CloudUseAlphaBlend := UseBlendedTagCloud ;
          TagCustomizer.CloudBlendColor := SkinColorScheme.TreeColorsArtist.Color;
          TagCustomizer.CloudBlendIntensity := BlendFaktorTagCloud2;

          TagCustomizer.TagUseAlphaBlend := self.UseBlendedSelectionTagCloud ;
          TagCustomizer.TagBlendColor := SkinColorScheme.TreeColorsArtist.SelectionRectangleBlend;
          TagCustomizer.TagBlendIntensity := BlendFaktorTagCloud; // as in the Trees (set in the Object-Inspector)

      // VST-Header
      SetVSTHeaderSettings;

      //Colors
      SetTreeColors(ArtistsVST, SkinColorScheme.TreeColorsArtist);
      SetTreeColors(AlbenVST, SkinColorScheme.TreeColorsAlbum);
      SetTreeColors(MainVST, SkinColorScheme.TreeColorsMain);
      SetTreeColors(PlaylistVST, SkinColorScheme.TreeColorsPlaylist);
  end;

  // Eigenschaften der Massenhaft auftretenden Sachen setzen
  // Hier jetzt auch in einer Schleife. Sollte leichter zu lesen sein.
  for i := 0 to fNempMainForm.ComponentCount - 1 do begin
    if fNempMainForm.Components[i] is TLabel then begin
      TLabel(fNempMainForm.Components[i]).Color := SkinColorScheme.LabelBackGroundCL;
      TLabel(fNempMainForm.Components[i]).Font.Color := SkinColorScheme.LabelCL;
      TLabel(fNempMainForm.Components[i]).Transparent := DrawTransparentLabel;
    end;
  end;

  // Weitere Eigenschaften der Form setzen
  with Nemp_MainForm do
  begin

    if NotTheFirstActivation then
        // Dont do this on startup. On some systems the complete Desktop is painted
        MedienBib.NewCoverFlow.SetColor(SkinColorScheme.CoverFlowCl);

    Color := SkinColorScheme.FormCL;
    SplitterBrowse.Color := SkinColorScheme.SplitterColor;
    SplitterFileOverview.Color := SkinColorScheme.SplitterColor;
    NempLayout.SplitterColor := NempSkin.SkinColorScheme.SplitterColor;

    LyricsMemo.Color := SkinColorScheme.MemoBackGroundCL;
    LyricsMemo.Font.Color := SkinColorScheme.MemoTextCL;

    NempPlayer.PreviewArtistColor := SkinColorScheme.PreviewArtistColor ;
    NempPlayer.PreviewTitleColor  := SkinColorScheme.PreviewTitleColor  ;
    NempPlayer.PreviewTimeColor   := SkinColorScheme.PreviewTimeColor   ;

    PlayerTimeLbl.Font.Color       := SkinColorScheme.SpecTimeCL;;
    PlayerArtistLabel.Font.Color   := SkinColorScheme.SpecArtistCL;
    PlayerTitleLabel.Font.Color    := SkinColorScheme.SpecTitelCL;

    NempPlayer.PreviewShapePenColor           := SkinColorScheme.PreviewShapePenColor           ;
    NempPlayer.PreviewShapeBrushColor         := SkinColorScheme.PreviewShapeBrushColor         ;
    NempPlayer.PreviewShapeProgressPenColor   := SkinColorScheme.PreviewShapeProgressPenColor   ;
    NempPlayer.PreviewShapeProgressBrushColor := SkinColorScheme.PreviewShapeProgressBrushColor ;

    // SKIN_UMBAU_CHECK // SKIN_UMBAU_CHECK // SKIN_UMBAU_CHECK // SKIN_UMBAU_CHECK
    NempSpectrum.ColorPeak := SkinColorScheme.SpecPeakCL;
    NempSpectrum.ColorBar1 := SkinColorScheme.SpecPenCL;
    NempSpectrum.ColorBar2 := SkinColorScheme.SpecPen2CL;
    // SKIN_UMBAU_CHECK // SKIN_UMBAU_CHECK // SKIN_UMBAU_CHECK // SKIN_UMBAU_CHECK


    if (HideMainMenu) or (NempOptions.AnzeigeMode = 1) then
      Menu := NIL
    else
      Menu := Nemp_MainMenu;
  end;

  // Dann: Hintergrundgrafiken-Offsets für die Trees initialisieren
  RepairSkinOffset;
  RefreshTreeOffsets;

  // SKIN_UMBAU_CHECK // SKIN_UMBAU_CHECK
  //if NempPartyMode.Active then
  //    Spectrum.SetScale(NempPartyMode.ResizeFactor)
  //else
  //    Spectrum.SetScale(1);

  // Spectrum-Hintergrund setzen
  // UpdateSpectrumGraphics;

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

        // SKIN_UMBAU_CHECK // SKIN_UMBAU_CHECK // SKIN_UMBAU_CHECK
        {case SlideButtonMode of
           2: begin
                  for i := 0 to High(SlideButtons) do
                  begin
                      // SKIN_UMBAU_CHECK SlideButtons[i].Button.CustomRegion := True;
                      SlideButtons[i].Button.Refresh;
                  end;
           end;
        end;}
        // SKIN_UMBAU_CHECK // SKIN_UMBAU_CHECK // SKIN_UMBAU_CHECK

        for j := low(Controlbuttons) to High(Controlbuttons) do
                begin
                        // SKIN_UMBAU_CHECK ControlButtons[j].CustomRegion := True;
                        ControlButtons[j].Refresh;
                end;

        for i := Low(TabButtons) to High(TabButtons) do
        begin
              // SKIN_UMBAU_CHECK TabButtons[i].Button.CustomRegion := True;
              TabButtons[i].Button.Refresh;
        end;


        // SKIN_UMBAU_CHECK BtnHeadsetPlaynow     .CustomRegion := True;
        // SKIN_UMBAU_CHECK BtnHeadsetToPlaylist  .CustomRegion := True;
        // SKIN_UMBAU_CHECK BtnLoadHeadset        .CustomRegion := True;
        // SKIN_UMBAU_CHECK PlayPauseHeadSetBtn   .CustomRegion := True;
        // SKIN_UMBAU_CHECK StopHeadSetBtn        .CustomRegion := True;

        // SKIN_UMBAU_CHECKBtnHeadsetPlaynow      .Refresh;
        // SKIN_UMBAU_CHECKBtnHeadsetToPlaylist   .Refresh;
        // SKIN_UMBAU_CHECKBtnLoadHeadset         .Refresh;
        // SKIN_UMBAU_CHECKPlayPauseHeadSetBtn    .Refresh;
        // SKIN_UMBAU_CHECKStopHeadSetBtn         .Refresh;

    end;

end;

procedure TNempSkin.DeActivateSkin(NotTheFirstActivation: Boolean = True);
var
  i: integer;

begin
  isActive := False;
  RevokeDragFiles;
  //zunächst: Ownerdraw der Boxen/Panels setzen
  for i := 0 to fPanelList.Count - 1 do
    fPanelList[i].DrawMode := dm_Windows;

  (*with Nemp_MainForm do
  begin
      for i := 0 to Nemp_MainForm.ComponentCount - 1 do
      begin
          if Nemp_MainForm.Components[i] is TNempPanel then
            TNempPanel(Nemp_MainForm.Components[i]).OwnerDraw := False;
      end;
  end;*)

  if assigned(DeleteSelection) then
      DeleteSelection.ReloadScheckBoxImages(ExtractFilePath(ParamStr(0)) + 'Images\', false);

  (*AuswahlForm.ContainerPanelAuswahlform.OwnerDraw := False;
  MedienListeForm.ContainerPanelMedienBibForm.OwnerDraw := False;
  PlaylistForm.ContainerPanelPlaylistForm.OwnerDraw := False;
  ExtendedControlForm.ContainerPanelExtendedControlsForm.OwnerDraw := False;*)

  // Grafiken für die Buttons setzen
  with Nemp_MainForm do
  begin
        PlaylistVST.Images := PlayListImageList;
        VST.Images := PlayListImageList;

        Nemp_MainMenu             .Images := MenuImages;
        Medialist_View_PopupMenu  .Images := MenuImages;
        Medialist_Collection_PopupMenu.Images := MenuImages;
        Medialist_Category_PopupMenu.Images := MenuImages;
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

        // SKIN_UMBAU_CHECK // SKIN_UMBAU_CHECK // SKIN_UMBAU_CHECK
        {for i := 0 to High(SlideButtons) do
        begin
            SlideButtons[i].Button.DrawMode := dm_Windows;
            // SKIN_UMBAU_CHECK SlideButtons[i].Button.CustomRegion := False;
            // SKIN_UMBAU_CHECK SlideButtons[i].Button.Glyph.Assign(Nil);
            SlideButtons[i].Button.Refresh;
        end;}
        // SKIN_UMBAU_CHECK // SKIN_UMBAU_CHECK // SKIN_UMBAU_CHECK

  end;

  ArtistsVST.Background.Assign(Nil);
  AlbenVST.Background.Assign(Nil);
  PlaylistVST.Background.Assign(Nil);
  MainVST.Background.Assign(Nil);
  // AlphaBlending
  ArtistsVST.TreeOptions.PaintOptions := ArtistsVST.TreeOptions.PaintOptions - [toUseBlendedSelection];
  AlbenVST.TreeOptions.PaintOptions := AlbenVST.TreeOptions.PaintOptions - [toUseBlendedSelection];
  PlaylistVST.TreeOptions.PaintOptions := PlaylistVST.TreeOptions.PaintOptions - [toUseBlendedSelection];
  MainVST.TreeOptions.PaintOptions := MainVST.TreeOptions.PaintOptions - [toUseBlendedSelection];
  // Scrollbars
  ArtistsVST.ScrollBarOptions.ScrollBars := ssVertical;
  AlbenVST.ScrollBarOptions.ScrollBars := ssVertical;
  PlaylistVST.ScrollBarOptions.ScrollBars := ssVertical;
  MainVST.ScrollBarOptions.ScrollBars := ssBoth;
  // Header
  ArtistsVST.Header.Options := ArtistsVST.Header.Options - [hoOwnerDraw];
  AlbenVST.Header.Options := AlbenVST.Header.Options - [hoOwnerDraw];
  PlaylistVST.Header.Options := PlaylistVST.Header.Options - [hoOwnerDraw];
  MainVST.Header.Options := MainVST.Header.Options - [hoOwnerDraw];

  ArtistsVST.SelectionBlendFactor  := 75 ;
  AlbenVST.SelectionBlendFactor    := 75 ;
  PlaylistVST.SelectionBlendFactor := 75 ;
  MainVST.SelectionBlendFactor         := 75 ;

  // Farben
  SetTreeColors(ArtistsVST, cDefaultTreeColors);
  SetTreeColors(AlbenVST, cDefaultTreeColors);
  SetTreeColors(MainVST, cDefaultTreeColors);
  SetTreeColors(PlaylistVST, cDefaultTreeColors);

  // Eigenschaften der Bäume
  //with Nemp_MainForm do
  //begin
      {
      // for skinning the [+] and [-] Buttons in teh Treeview
      Nemp_MainForm.ArtistsVST.OnAfterCellPaint := Nil;
      Nemp_MainForm.AlbenVST.OnAfterCellPaint := Nil;
      Nemp_MainForm.ArtistsVST.TreeOptions.PaintOptions := Nemp_MainForm.ArtistsVST.TreeOptions.PaintOptions + [toShowButtons];
      Nemp_MainForm.AlbenVST.TreeOptions.PaintOptions := Nemp_MainForm.AlbenVST.TreeOptions.PaintOptions + [toShowButtons];
      }

      // SKIN_UMBAU_CHECK  BibRatingHelper.UsebackGround := False;
      // SKIN_UMBAU_CHECK BibRatingHelper.ReDrawRatingInStarsOnBitmap(ImgBibRating.Picture.Bitmap);

      //TagCustomizer.UseBackGround := False;
      //TagCustomizer.TileBackGround:= False;
      // TagCustomizer.BackgroundImage := Nil;

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

  //end;

  // Eigenschaften der Massenhaft auftretenden Sachen setzen
  // Hier jetzt auch in einer Schleife. Sollte leichter zu lesen sein.
  for i := 0 to fNempMainForm.ComponentCount - 1 do begin
    if fNempMainForm.Components[i] is TLabel then begin
      TLabel(fNempMainForm.Components[i]).Color := clBtnFace;
      TLabel(fNempMainForm.Components[i]).Font.Color := clWindowText;
      TLabel(fNempMainForm.Components[i]).Transparent := True;
    end
  end;

  if NotTheFirstActivation then
      // Dont do this on startup. On some systems the complete Desktop is painted white
      MedienBib.NewCoverFlow.SetColor(MedienBib.NewCoverFlow.Settings.DefaultColor);

  // Weitere Eigenschaften der Form setzen
  with Nemp_MainForm do
  begin
    Color := clBtnFace;
    SplitterBrowse.Color := clBtnFace;
    SplitterFileOverview.Color := clBtnFace;
    NempLayout.SplitterColor := clBtnFace;

    LyricsMemo.Color := clWindow;
    LyricsMemo.Font.Color := clWindowText;

    NempPlayer.PreviewArtistColor := clGrayText;
    NempPlayer.PreviewTitleColor  := clWindowText;
    NempPlayer.PreviewTimeColor   := clWindowText;

    PlayerTimeLbl.Font.Color       := clWindowText;
    PlayerArtistLabel.Font.Color   := clWindowText;
    PlayerTitleLabel.Font.Color    := clWindowText;

    NempPlayer.PreviewShapePenColor           := cl3DDkShadow ;
    NempPlayer.PreviewShapeBrushColor         := clBtnFace    ;
    NempPlayer.PreviewShapeProgressPenColor   := clHighLight  ;
    NempPlayer.PreviewShapeProgressBrushColor := clHotLight   ;

    // SKIN_UMBAU_CHECK // SKIN_UMBAU_CHECK // SKIN_UMBAU_CHECK // SKIN_UMBAU_CHECK
    NempSpectrum.ColorPeak := clBackground;
    NempSpectrum.ColorBar1 := clBackground;
    NempSpectrum.ColorBar2 := clActiveCaption;

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


procedure TNempSkin.OnPaintBackgroundControlPanel(Sender: TNempPanel; var Bitmap: TBitmap;
  var Offset: TPoint; var Tile: Boolean);
var
  pnlPoint: TPoint;
begin
  if not UseSeparatePlayerBitmap then begin
    OnPaintBackgroundRegularPanel(Sender, Bitmap, Offset, Tile)
  end else begin

            // fallback-Bitmap:
            case AlignControlGenericBackground of
                0: Offset := Point(0,0); //align left
                1: Offset := Point (Nemp_MainForm._ControlPanel.ClientWidth - ControlGenericBmp.Width, 0); // align right
                2: begin
                    // align to main control, use also AlignControlGenericOffset
                    Offset := Nemp_MainForm.PlayerControlPanel.ClientToParent(Point(0,0), Nemp_MainForm._ControlPanel);
                    Offset.X := Offset.X - AlignControlGenericOffset;
                end;
            end;
            pnlPoint := Sender.ClientToParent(Point(0,0), Nemp_MainForm._ControlPanel);
            if fControlGenericLoaded then
              Bitmap := ControlGenericBmp;

            case Sender.Tag of
                1: begin //selection
                    if fControlSelectionLoaded then begin
                        Bitmap := ControlSelectionBmp;
                        pnlPoint := Point(0,0);
                        Offset := Point(0,0);
                    end;
                end;

                2: begin // cover
                    if fControCoverLoaded then begin
                        Bitmap := ControlCoverBmp;
                        pnlPoint := Point(0,0);
                        Offset := Point(0,0);
                    end;
                end;

                3: begin // MainPlayer/Headset
                    if fControlPlayerLoaded then begin
                        Bitmap := PlayerBitmap;
                        pnlPoint := Point(0,0);
                        Offset := Point(0,0);
                    end;
                end;

                4: begin // SlideControl, Title-Display
                    if fControlProgressLoaded then begin
                        Bitmap := ControlProgressBmp;
                        pnlPoint := Point(0,0);
                        case AlignControlProgressDisplay of
                            0: Offset := Point(0,0);
                            1: Offset := Point (Nemp_MainForm.NewPlayerPanel.ClientWidth - ControlProgressBmp.Width, 0)
                        end;
                    end;
                end;
            end;

            (*with Nemp_MainForm do
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
                *)
    end;

end;

(*
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
                    //if Nemp_MainForm.MainPlayerControlsActive then
                    SourceOffsetPoint := Nemp_MainForm.PlayerControlPanel.ClientToParent(Point(0,0), Nemp_MainForm._ControlPanel);
                    //else
                    //    SourceOffsetPoint := Nemp_MainForm.HeadsetControlPanel.ClientToParent(Point(0,0), Nemp_MainForm._ControlPanel);
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


            //if JustInternal then
            //    PaintedProgressBitmap.Assign(tmp)
            // else
                BitBlt(aPanel.Canvas.Handle, 0,   0, tmp.Width, tmp.Height, tmp.Canvas.Handle, 0,  0, srccopy);
        finally
            tmp.Free;
        end;
    end else
        DrawARegularPanel(aPanel, UseBackground);
end;   *)

function TNempSkin.GetBrowseBitmap: TBitmap;
begin
  if fBrowseBitmapLoaded then
    result := fBrowseBitmap
  else
    result := fCompleteBitmap;
end;

function TNempSkin.GetMedialistBitmap: TBitmap;
begin
  if fMedialistBitmapLoaded then
    result := fMedialistBitmap
  else
    result := fCompleteBitmap;
end;

function TNempSkin.GetDetailBitmap: TBitmap;
begin
  if fDetailBitmapLoaded then
    result := fDetailBitmap
  else
    result := fCompleteBitmap;
end;

function TNempSkin.GetPlaylistBitmap: TBitmap;
begin
  if fPlaylistBitmapLoaded then
    result := fPlaylistBitmap
  else
    result := fCompleteBitmap;
end;

function TNempSkin.GetBackgroundBasePanel(aControl: TControl): TNempPanel;
var
  aParent: TWinControl;
begin
  result := Nil;

  if (aControl is TNempPanel) and TNempPanel(aControl).BackgroundBasePanel then
    result := TNempPanel(aControl)
  else begin
    aParent := aControl.Parent;
    while assigned(aParent) do begin
      if (aParent is TNempPanel) and TNempPanel(aParent).BackgroundBasePanel then begin
        result := TNempPanel(aParent);
        break;
      end else
        aParent := aParent.Parent;
    end;
  end;
end;

function TNempSkin.GetBackgroundBitmap(aPanel: TNempPanel): TBitmap;
begin
  case aPanel.Tag of
    1: result := Playlistbitmap;   // Playlist
    2: result := BrowseBitmap;     // Browse (Tree, Coverflow, TagCloud)
    3: result := MedialistBitmap;  // MediaList
    4: result := DetailBitmap;     // Details (new in 5.3)
  else
    result := CompleteBitmap;
  end;
end;

function TNempSkin.GetBackgroundAlignment(aPanel: TNempPanel): Integer;
begin
  case aPanel.Tag of
    1: result := AlignBackgroundPlaylist;   // Playlist
    2: result := AlignBackgroundBrowse;     // Browse (Tree, Coverflow, TagCloud)
    3: result := AlignBackgroundMedialist;  // MediaList
    4: result := AlignBackgroundDetail;     // Details (new in 5.3)
  else
    result := AlignCompleteBackground;
  end;
end;

function TNempSkin.GetTileByTag(aTag: Integer): Boolean;
begin
  case aTag of
    1: result := TileBackgroundPlaylist;   // Playlist
    2: result := TileBackgroundBrowse;     // Browse (Tree, Coverflow, TagCloud)
    3: result := TileBackgroundMedialist;  // MediaList
    4: result := TileBackgroundDetails;     // Details (new in 5.3)
  else
    result := false;
  end;
end;

function TNempSkin.GetDefaultOffset(aControl: TWinControl): TPoint;
begin
  result := Point(PlayerPageOffsetX, PlayerPageOffsetY)- aControl.ClientToScreen(Point(0,0));
end;

function TNempSkin.GetBaseControlOffset(aBaseControl: TWinControl; aBitmap: TBitmap; aAlignment: Integer): TPoint;
begin
  case aAlignment of
    // left-center
    0: result :=  Point(0, (aBaseControl.ClientHeight Div 2) - (aBitmap.Height Div 2) );
    // right-center
    1: result := Point(aBaseControl.ClientWidth - aBitmap.Width, (aBaseControl.ClientHeight Div 2) - (aBitmap.Height Div 2) );
    // align to MainControls (use PlayerPageOffset<X/Y>Orig in that case), doesnt make sense here - use "center-center"
    2: result := Point((aBaseControl.ClientWidth Div 2) - (aBitmap.Width Div 2), (aBaseControl.ClientHeight Div 2) - (aBitmap.Height Div 2) );
    // left-top
    3: result := Point(0,0);
    //right-top
    4: result := Point(aBaseControl.ClientWidth - aBitmap.Width, 0);
    //left-bottom
    5: result := Point (0, aBaseControl.ClientHeight - aBitmap.Height);
    //right-bottom
    6: result :=  Point (aBaseControl.ClientWidth - aBitmap.Width, aBaseControl.ClientHeight - aBitmap.Height);
  end;
end;

function TNempSkin.GetBackgroundOffset(aControl: TWinControl; aBitmap: TBitmap; aAlignment: Integer): TPoint;
var
  BasePanel: TNempPanel;
begin
  BasePanel := GetBackgroundBasePanel(aControl);

  if not assigned(BasePanel) then
    // Fallback: treat aControl as a BasePanel
    result := GetBaseControlOffset(aControl, aBitmap, aAlignment)
  else
    result := GetBaseControlOffset(BasePanel, aBitmap, aAlignment)
        + BasePanel.ClientToScreen(Point(0,0)) - aControl.ClientToScreen(Point(0,0));
end;

procedure TNempSkin.SetTreeBackgroundOffset(aTree: TVirtualStringTree);
var
  Bitmap: TBitmap;
  OffSet: TPoint;
  Alignment: Integer;
  BasePanel: TNempPanel;

  function DoTileTree(useDefaultTile: Boolean): Boolean;
  begin
    if useDefaultTile then
      result := TileBackground
    else begin
      case BasePanel.Tag of
        1: result := TileBackgroundPlaylist;
        2: result := TileBackgroundBrowse;
        3: result := TileBackgroundMedialist;
      else
        result := false;
      end;
    end;
  end;

begin
  if (aTree.Tag < 0) or (aTree.Tag > 3) then begin
    // invalid Tag, should not happen
    aTree.TreeOptions.PaintOptions := aTree.TreeOptions.PaintOptions - [toStaticbackground];
    exit;
  end;

  BasePanel := GetBackgroundBasePanel(aTree);
  if not assigned(BasePanel) then
    // no BasePanel found (should not happen)
    aTree.TreeOptions.PaintOptions := aTree.TreeOptions.PaintOptions - [toStaticbackground]
  else begin
    if UseBackgroundImages[BasePanel.Tag] then begin
      // get a proper Background Bitmap for the Tree, based on the BasePanel it is located on
      Bitmap := GetBackgroundBitmap(BasePanel);
      if Bitmap = fCompleteBitmap then
        // if it's the MainBitmap:
        // Set Offset in relation to the MainControl
        OffSet := GetDefaultOffset(aTree)
      else begin
        // if it's a seperate Bitmap:
        // Set Offset in relation to the BasePanel, using it's Alignment setting
        Alignment := GetBackgroundAlignment(BasePanel);
        Offset := GetBackgroundOffset(aTree, Bitmap, Alignment);
      end;

      if DoTileTree(Bitmap = fCompleteBitmap) then begin
        aTree.TreeOptions.PaintOptions := aTree.TreeOptions.PaintOptions - [toStaticbackground];
        aTree.BackgroundOffsetX := - Offset.X;
        aTree.BackgroundOffsetY := - Offset.Y;
      end else begin
        aTree.TreeOptions.PaintOptions := aTree.TreeOptions.PaintOptions + [toStaticbackground];
        aTree.BackgroundOffsetX := Offset.X;
        aTree.BackgroundOffsetY := Offset.Y;
      end;
    end;
  end;
end;



(*procedure TNempSkin.OnPaintEmptyLibraryPanel(Sender: TNempPanel; var Bitmap: TBitmap;
  var Offset: TPoint; var Tile: Boolean);
begin
  if not fBrowseBitmapLoaded then
    OnPaintBackgroundRegularPanel(Sender, Bitmap, Offset, Tile)
  else
  begin
    if UseBackGroundImageVorauswahl then begin
      Bitmap := fBrowseBitmap;
      Offset := GetBaseControlOffset(Sender, fBrowseBitmap, AlignBackgroundBrowse);
    end;
  end;
end;*)

procedure TNempSkin.OnPaintBackgroundRegularPanel(Sender: TNempPanel; var Bitmap: TBitmap;
  var Offset: TPoint; var Tile: Boolean);
var
  Align: Integer;
begin
  //if not fCompleteBitmapLoaded then
  //  exit;

  if (Sender.Tag >= 0) and (Sender.Tag <= 4) then begin
    if UseBackgroundImages[Sender.Tag] then begin
      Bitmap := GetBackgroundBitmap(Sender); // Bitmap := fCompleteBitmap;

      if Bitmap = fCompleteBitmap then begin
        Tile := TileBackground;
        OffSet := GetDefaultOffset(Sender);
      end
      else begin
        Tile := GetTileByTag(Sender.Tag);
        Align := GetBackgroundAlignment(Sender);
        Offset := GetBackgroundOffset(Sender, Bitmap, Align); // OffSet := Point(PlayerPageOffsetX, PlayerPageOffsetY) - Sender.ClientToScreen(Point(0,0));
      end;
    end;
  end else begin
    Tile := TileBackground;
    Bitmap := fCompleteBitmap;
    OffSet := GetDefaultOffset(Sender);
      // Sender.ClientToScreen(Point(0,0)) - Point(PlayerPageOffsetX, PlayerPageOffsetY);
  end;
end;

(*
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
        //with Nemp_MainForm do
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

*)

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

(*
procedure TNempSkin.PaintFallbackImage(var aBitmap: TBitmap);
begin
    aBitmap.Width := 10;
    aBitmap.Height := 10;
    aBitmap.Canvas.Brush.Color := SkinColorScheme.FormCL;
    aBitmap.Canvas.Pen.Color := SkinColorScheme.LabelCL;
    aBitmap.Canvas.FillRect(CompleteBitmap.Canvas.ClipRect);
end;*)


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
          aBmp.Width := 14;
          aBmp.Height := 14;
          aBmp.Canvas.Brush.Style := bsSolid;
          aBmp.Canvas.Brush.Color := clWhite;
          aBmp.Canvas.FillRect(Rect(1,1,13,13));
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

        // SKIN_UMBAU_CHECKfor b := Low(TControlButtons) to ctrlHeadsetInsertToPlaylistBtn do // ctrlHeadsetInsertToPlaylistBtn do //High(TControlButtons) - 1 do
        // SKIN_UMBAU_CHECKbegin
        // SKIN_UMBAU_CHECK    ControlButtons[b].Left   := r(ControlButtonData[b].Left)  ;
        // SKIN_UMBAU_CHECK    ControlButtons[b].Top    := r(ControlButtonData[b].Top) ;
        // SKIN_UMBAU_CHECK    ControlButtons[b].Width  := r(ControlButtonData[b].Width) ;
        // SKIN_UMBAU_CHECK    ControlButtons[b].Height := r(ControlButtonData[b].Height);

            // if b <= ctrlRecordBtn  then
        // SKIN_UMBAU_CHECK        ControlButtons[b].Visible:= ControlButtonData[b].Visible or (ButtonMode <> 2);
        // SKIN_UMBAU_CHECKend;

        BtnArray[0] := PlayPauseBTN        ;
        BtnArray[1] := StopBTN             ;
        BtnArray[2] := PlayPrevBTN         ;
        BtnArray[3] := PlayNextBTN         ;
        BtnArray[4] := RandomBTN           ;
        //Bubblesort für TabOrder
        // SKIN_UMBAU_CHECK   noch nötig mit festen controls, nicht mehr konfigurierbar per Skin in Größe und Position?
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
  // SKIN_UMBAU_CHECK// SKIN_UMBAU_CHECK// SKIN_UMBAU_CHECK// SKIN_UMBAU_CHECK
  {
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
  }
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
        // SKIN_UMBAU_CHECK Nemp_MainForm.VolumeImageHeadset.Picture.Bitmap.Assign(tmpbmp);
    finally
        tmpbmp.Free;
    end;
end;


procedure TNempSkin.AssignStarGraphics;
var BaseDir: String;
begin
    // SKIN_UMBAU_CHECK // SKIN_UMBAU_CHECK // SKIN_UMBAU_CHECK // SKIN_UMBAU_CHECK
    if isActive and (not UseDefaultStarBitmaps) then
        BaseDir := path + '\'
    else
        BaseDir := ExtractFilePath(ParamStr(0)) + 'Images\';

        // todo: Var UseDefaultStars...

    LoadGraphicFromBaseName(SetStarBitmap, BaseDir + 'starset');
    LoadGraphicFromBaseName(UnSetStarBitmap, BaseDir + 'starunset');
    LoadGraphicFromBaseName(HalfStarBitmap, BaseDir + 'starhalfset');
    LoadGraphicFromBaseName(CountStarBitmap, BaseDir + 'starcount');
    SetStarBitmap.Transparent := True;
    UnSetStarBitmap.Transparent := True;
    HalfStarBitmap.Transparent := True;
    CountStarBitmap.Transparent := True;
    // SKIN_UMBAU_CHECK RatingGraphics.SetStars(SetStarBitmap, HalfStarBitmap, UnSetStarBitmap, CountStarBitmap);

    // SKIN_UMBAU_CHECK Nemp_MainForm.BibRatingHelper.SetStars(SetStarBitmap, HalfStarBitmap, UnSetStarBitmap, CountStarBitmap);
    //if Assigned(MedienBib.CurrentAudioFile) then
    // SKIN_UMBAU_CHECK     Nemp_MainForm.BibRatingHelper.DrawRatingInStarsOnBitmap(Nemp_MainForm.CurrentlySelectedFile.Rating, Nemp_MainForm.ImgBibRating.Picture.Bitmap, Nemp_MainForm.ImgBibRating.Width, Nemp_MainForm.ImgBibRating.Height);
    //else
    //    Nemp_MainForm.BibRatingHelper.DrawRatingInStarsOnBitmap(128, Nemp_MainForm.ImgBibRating.Picture.Bitmap, Nemp_MainForm.ImgBibRating.Width, Nemp_MainForm.ImgBibRating.Height);

    LoadGraphicFromBaseName(SetStarBitmap, BaseDir + 'starset', True);
    LoadGraphicFromBaseName(UnSetStarBitmap, BaseDir + 'starunset', True);
    LoadGraphicFromBaseName(HalfStarBitmap, BaseDir + 'starhalfset', True);
    LoadGraphicFromBaseName(CountStarBitmap, BaseDir + 'starcount', True);
    SetStarBitmap.Transparent := True;
    UnSetStarBitmap.Transparent := True;
    HalfStarBitmap.Transparent := True;
    CountStarBitmap.Transparent := True;

    // SKIN_UMBAU_CHECK PlayerRatingGraphics.SetStars(SetStarBitmap, HalfStarBitmap, UnSetStarBitmap, CountStarBitmap);

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
                // SKIN_UMBAU_CHECK ControlButtons[b].NumGlyphs := 1;
                // SKIN_UMBAU_CHECK ControlButtons[b].Glyph.Assign(Nil);
                ControlButtons[b].Refresh;
                LoadGraphicFromBaseName(tmpBitmap, BaseDir + DefaultButtonData[b].Name, True);

                // SKIN_UMBAU_CHECK ControlButtons[b].NempGlyph.Assign(tmpBitmap);
                // SKIN_UMBAU_CHECK ControlButtons[b].GlyphLine := ControlButtons[b].GlyphLine;
                ControlButtons[b].RePaint;
            end;

            // SKIN_UMBAU_CHECKBtnLoadHeadset .drawMode := dm_Windows;
            // SKIN_UMBAU_CHECK BtnLoadHeadset .NumGlyphs := 1;
            // SKIN_UMBAU_CHECK BtnLoadHeadset .NempGlyph.Assign(Nil);
            // SKIN_UMBAU_CHECKLoadGraphicFromBaseName(tmpBitmap, BaseDir + 'BtnLoadHeadset', True);
            // SKIN_UMBAU_CHECK BtnLoadHeadset.NempGlyph.Assign(tmpBitmap);
            // SKIN_UMBAU_CHECK BtnLoadHeadset.GlyphLine := BtnLoadHeadset.GlyphLine;
            // SKIN_UMBAU_CHECKBtnLoadHeadset.Refresh;

            // SKIN_UMBAU_CHECKBtnHeadsetToPlaylist .drawMode := dm_Windows;
            // SKIN_UMBAU_CHECK BtnHeadsetToPlaylist .NumGlyphs := 1;
            // SKIN_UMBAU_CHECK BtnHeadsetToPlaylist .NempGlyph.Assign(Nil);
            // SKIN_UMBAU_CHECKLoadGraphicFromBaseName(tmpBitmap, BaseDir + 'BtnHeadsetToPlaylist', True);
            // SKIN_UMBAU_CHECK BtnHeadsetToPlaylist.NempGlyph.Assign(tmpBitmap);
            // SKIN_UMBAU_CHECK BtnHeadsetToPlaylist.GlyphLine := BtnHeadsetToPlaylist.GlyphLine;
            // SKIN_UMBAU_CHECKBtnHeadsetToPlaylist.Refresh;

            // SKIN_UMBAU_CHECKBtnHeadsetPlaynow .drawMode := dm_Windows;
            // SKIN_UMBAU_CHECK BtnHeadsetPlaynow .NumGlyphs := 1;
            // SKIN_UMBAU_CHECK BtnHeadsetPlaynow .NempGlyph.Assign(Nil);
            // SKIN_UMBAU_CHECKLoadGraphicFromBaseName(tmpBitmap, BaseDir + 'BtnHeadsetPlaynow', True);
            // SKIN_UMBAU_CHECK BtnHeadsetPlaynow.NempGlyph.Assign(tmpBitmap);
            // SKIN_UMBAU_CHECK BtnHeadsetPlaynow.GlyphLine := BtnHeadsetPlaynow.GlyphLine;
            // SKIN_UMBAU_CHECKBtnHeadsetPlaynow.Refresh;

            // SKIN_UMBAU_CHECKPlayPauseHeadSetBtn .drawMode := dm_Windows;
            // SKIN_UMBAU_CHECK PlayPauseHeadSetBtn .NumGlyphs := 1;
           // SKIN_UMBAU_CHECK  PlayPauseHeadSetBtn .NempGlyph.Assign(Nil);
            // SKIN_UMBAU_CHECKLoadGraphicFromBaseName(tmpBitmap, BaseDir + 'BtnPlayPauseHeadset', True);
            // SKIN_UMBAU_CHECK PlayPauseHeadSetBtn.NempGlyph.Assign(tmpBitmap);
            // SKIN_UMBAU_CHECK PlayPauseHeadSetBtn.GlyphLine := PlayPauseHeadSetBtn.GlyphLine;
            // SKIN_UMBAU_CHECKPlayPauseHeadSetBtn.Refresh;

            // SKIN_UMBAU_CHECKStopHeadSetBtn .drawMode := dm_Windows;
           // SKIN_UMBAU_CHECK  StopHeadSetBtn .NumGlyphs := 1;
            // SKIN_UMBAU_CHECK StopHeadSetBtn .NempGlyph.Assign(Nil);
            // SKIN_UMBAU_CHECKLoadGraphicFromBaseName(tmpBitmap, BaseDir + 'BtnStopHeadSet', True);
            // SKIN_UMBAU_CHECK StopHeadSetBtn.NempGlyph.Assign(tmpBitmap);
            // SKIN_UMBAU_CHECK StopHeadSetBtn.GlyphLine := StopHeadSetBtn.GlyphLine;
            // SKIN_UMBAU_CHECKStopHeadSetBtn.Refresh;


            LoadGraphicFromBaseName(tmpBitmap, BaseDir + DefaultButtonData[ctrlCloseBtn].Name, True);
            // SKIN_UMBAU_CHECK AuswahlForm.CloseImageA.NempGlyph.Assign(tmpBitmap);
            //Buttons12ImageList.GetBitmap(1,AuswahlForm.CloseImage.NempGlyph);
            // SKIN_UMBAU_CHECK AuswahlForm.CloseImageA.NumGlyphsX := 1;
            // SKIN_UMBAU_CHECK AuswahlForm.CloseImageA.NumGlyphs := 1;

            //Buttons12ImageList.GetBitmap(1,MedienlisteForm.CloseImage.NempGlyph);
            // SKIN_UMBAU_CHECK MedienlisteForm.CloseImageM.NempGlyph.Assign(tmpBitmap);
            // SKIN_UMBAU_CHECK MedienlisteForm.CloseImageM.NumGlyphsX := 1;
            // SKIN_UMBAU_CHECK MedienlisteForm.CloseImageM.NumGlyphs := 1;

            //Buttons12ImageList.GetBitmap(1,PlaylistForm.CloseImage.NempGlyph);
            // SKIN_UMBAU_CHECK PlaylistForm.CloseImageP.NempGlyph.Assign(tmpBitmap);
            // SKIN_UMBAU_CHECK PlaylistForm.CloseImageP.NumGlyphsX := 1;
            // SKIN_UMBAU_CHECK PlaylistForm.CloseImageP.NumGlyphs := 1;

            // SKIN_UMBAU_CHECK ExtendedControlForm.CloseImageE.NempGlyph.Assign(tmpBitmap);
            // SKIN_UMBAU_CHECK ExtendedControlForm.CloseImageE.NumGlyphsX := 1;
            // SKIN_UMBAU_CHECK ExtendedControlForm.CloseImageE.NumGlyphs := 1;

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
    // SKIN_UMBAU_CHECK aButton.NumGlyphsX := 5;
    tmpBitmap := TBitmap.Create;
    try
        result := LoadGraphicFromBaseName(tmpBitmap, aFilename, Scaled);
        // SKIN_UMBAU_CHECK aButton.NempGlyph.Assign(tmpBitmap);
        // SKIN_UMBAU_CHECK aButton.GlyphLine := aButton.GlyphLine;
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
        // SKIN_UMBAU_CHECK aButton.NumGlyphsX := 1;
        // SKIN_UMBAU_CHECK aButton.NumGlyphs  := 1;
        // SKIN_UMBAU_CHECK aButton.Glyph.Assign(Nil);
        LoadGraphicFromBaseName(tmpBitmap, aFilename, Scaled);
        // SKIN_UMBAU_CHECK aButton.NempGlyph.Assign(tmpBitmap);
        // SKIN_UMBAU_CHECK aButton.CustomRegion := False;
        // SKIN_UMBAU_CHECK aButton.GlyphLine := aButton.GlyphLine;
    finally
        tmpBitmap.Free;
    end;
end;


function TNempSkin.RepeatBtnImageIndex(aMode: Integer): Integer;
begin
  case aMode of
    0: result := IconIDX_RepeatAll;
    1: result := IconIDX_RepeatTitle;
    2: result := IconIDX_RepeatRandom;
    3: result := IconIDX_RepeatOff;
  else
    result := IconIDX_RepeatOff;
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


end.
