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
  Vcl.Menus, System.Generics.Defaults, System.Generics.Collections, Vcl.ImgList, VCL.ImageCollection,
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
  IconIDX_SkipForward = 9;
  IconIDX_SkipBackward = 10;

const
  cScaleDirectories: Array[0..4] of String =
    ('100', '125', '150', '175', '200');

type

  TPanelList = TList<TNempPanel>;
  TMenuList = TList<TMenu>;
  TSkinButtonList = TList<TSkinButton>;


  // types and constants for Background image settings
  teNempBackroundImages = (nbiDefault, nbiBrowse, nbiMedialist, nbiPlaylist, nbiDetails, nbiPlayerControls, nbiPlayerCover);
  teNempAlignment = (nalLeftCenter, nalRightCenter, nalCenterCenter, nalLeftTop, nalRightTop, nalLeftBottom, nalRightBottom);

  TNempBackgroundSetting = record
    ImageLoaded: Boolean;
    UseTiledDefaultBackground: Boolean;
    UseImage: Boolean;
    UseImageHeader: Boolean;
    Tile: Boolean;
    Alignment: teNempAlignment;
  end;

  TNempBackgroundSettings = Array[teNempBackroundImages] of TNempBackgroundSetting;

  const
    // Skin Filenames: Changed in 5.3, also used as Keys for further settings in the IniFile
    CBackgroundImagesFilenames: Array[teNempBackroundImages] of string = (
      'BGMain', 'BGBrowse', 'BGMedialist', 'BGPlaylist', 'BGDetails', 'BGPlayerControls', 'BGPlayerCover'
    );

    CDefaultBackgroundSetting : Array[teNempBackroundImages] of TNempBackgroundSetting =
      (
        (ImageLoaded: False; UseTiledDefaultBackground: False; UseImage: True; UseImageHeader: True; Tile: True; Alignment: nalLeftTop),     // nbiDefault
        (ImageLoaded: False; UseTiledDefaultBackground: False; UseImage: True; UseImageHeader: True; Tile: True; Alignment: nalLeftBottom),  // nbiBrowse
        (ImageLoaded: False; UseTiledDefaultBackground: False; UseImage: True; UseImageHeader: True; Tile: True; Alignment: nalLeftBottom),  // nbiMedialist
        (ImageLoaded: False; UseTiledDefaultBackground: False; UseImage: True; UseImageHeader: True; Tile: True; Alignment: nalLeftBottom),  // nbiPlaylist
        (ImageLoaded: False; UseTiledDefaultBackground: False; UseImage: True; UseImageHeader: True; Tile: True; Alignment: nalRightBottom), // nbiDetails
        (ImageLoaded: False; UseTiledDefaultBackground: False; UseImage: True; UseImageHeader: True; Tile: True; Alignment: nalLeftCenter),  // nbiPlayerControls
        (ImageLoaded: False; UseTiledDefaultBackground: False; UseImage: True; UseImageHeader: True; Tile: True; Alignment: nalLeftCenter)   // nbiPlayerCover
      ) ;

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

 type
  // Eigentliche Skinklasse
  TNempSkin = class
      private
        fNempMainForm: TForm;

        fNempBackgroundSettings: TNempBackgroundSettings;
        fNempBackgrounds: Array[teNempBackroundImages] of TPicture;

        fPanelList: TPanelList;
        fMenuList: TMenuList;
        fControlButtonList: TSkinButtonList;
        fTabButtonList: TSkinButtonList;

        fMainVST: TVirtualStringTree;
        fPlaylistVST: TVirtualStringTree;
        fAlbenVST: TVirtualStringTree;
        fArtistsVST: TVirtualStringTree;

        fPath: UnicodeString;
        fVclMenuImages: TCustomImageList;
        fSkinMenuImages: TCustomImageList;
        fButtonMode: Integer;
        fTabButtonMode: Integer;

        procedure SetControlButtonLook;
        procedure SetTabButtonLook;

        function GetBackgroundIndex(aPanel: TNempPanel): teNempBackroundImages; overload;
        function GetBackgroundIndex(aTag: Integer): teNempBackroundImages; overload;
        function GetBackgroundBitmap(aPanel: TNempPanel): TGraphic;
        function GetBackgroundAlignment(aPanel: TNempPanel): teNempAlignment;
        function GetTileByTag(aTag: Integer): Boolean;

        function GetBackgroundBasePanel(aControl: TControl): TNempPanel;

        // GetDefaultOffset
        // Get the offset based to PlayerPageOffsetX/PlayerPageOffsetY
        function GetDefaultOffset(aControl: TWinControl): TPoint;
        // GetControlOffset
        // Get the Offset needed for AControl based on the size of the Bitmap and the Alignment
        function GetBaseControlOffset(aBaseControl: TWinControl; aBitmap: TGraphic; aAlignment: teNempAlignment): TPoint;
        // GetBackgroundOffset
        function GetBackgroundOffset(aControl: TWinControl; aBitmap: TGraphic; aAlignment: teNempAlignment): TPoint;

        // SetTreeBackgroundOffsetRefreshTreeBackground
        // Refresh the Background image of a Tree. Basically the same method used as in TNempPanel
        procedure RefreshTreeBackground(aTree: TVirtualStringTree);

        procedure SetTreeColors(aTree: TVirtualStringTree; aTreeColors: TTreeColors);

        // New Graphic Methods
        procedure SetImage(Dest, Backup: TImageCollection; ItemName: String; ItemIndex: Integer);
        procedure PrepareSkinImagesCollection(aDefaultCollection, aSkinCollection: TImageCollection);

        // procedure AssignStarGraphics;
        procedure AssignABGraphics;

        function GetPath: String;

        function GetBackgroundBitmapByIndex(const Index: teNempBackroundImages): TGraphic;
        procedure OnInternalPaintControlBackground(Sender: TWinControl; BasePanel: TNempPanel; var Graphic: TGraphic; var Offset: TPoint; var Tile: Boolean);

        procedure SetButtonMode(const Value: Integer);
        procedure SetTabButtonMode(const Value: Integer);

      public
        Name: UnicodeString;
        isActive: Boolean;

        // Bild für den Mittelteil (den eigentlichen Player)
        // Kann leer sein - Aber wenn vorhanden, dann ist hier der Offset klar. Nämlich 0/0
        // UseSeparatePlayerBitmap: Boolean;

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
        DrawTransparentLabel  : Boolean;
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

        UseDefaultListImages: Boolean;
        UseDefaultMenuImages: Boolean;

        //-------------------------------------------------
        SkinColorScheme: TNempColorScheme;
        DialogCustomColors: Array[0..15] of TColor;

        NempPartyMode: TNempPartyMode;
        FormLayout: TNempLayout;

        // ButtonMode:
        // 0: Windows default (this includes the VCL stlye of the skin!), Nemp default icons
        // 1: Button itself as in Windows, icons from the skin files
        // 2: Button background from the skin files as well
        property ButtonMode: Integer read fButtonMode write SetButtonMode;
        property TabButtonMode: Integer read fTabButtonMode write SetTabButtonMode;

        property PanelList: TPanelList read fPanelList;
        property MenuList: TMenuList read fMenuList;
        property ControlButtonList: TSkinButtonList read fControlButtonList;
        property TabButtonList: TSkinButtonList read fTabButtonList;

        property VclMenuImages: TCustomImageList read fVclMenuImages write fVclMenuImages;
        property SkinMenuImages: TCustomImageList read fSkinMenuImages write fSkinMenuImages;

        // (nbiDefault, nbiBrowse, nbiMedialist, nbiPlaylist, nbiDetails, nbiPlayerControls, nbiPlayerCover);
        property CompleteBitmap  : TGraphic index nbiDefault   read  GetBackgroundBitmapByIndex;
        property BrowseBitmap    : TGraphic index nbiBrowse    read  GetBackgroundBitmapByIndex;
        property MedialistBitmap : TGraphic index nbiMedialist read  GetBackgroundBitmapByIndex;
        property DetailBitmap    : TGraphic index nbiDetails   read  GetBackgroundBitmapByIndex;
        property PlaylistBitmap  : TGraphic index nbiPlaylist  read  GetBackgroundBitmapByIndex;

        property ArtistsVST : TVirtualStringTree read fArtistsVST  write fArtistsVST ;
        property AlbenVST   : TVirtualStringTree read fAlbenVST    write fAlbenVST   ;
        property MainVST    : TVirtualStringTree read fMainVST     write fMainVST    ;
        property PlaylistVST: TVirtualStringTree read fPlaylistVST write fPlaylistVST;

        property Path: String read GetPath;

        constructor create(aMainForm: TForm);
        destructor Destroy;  override;         //Complete:: Für die Optionen-Vorschau. Da z.B. nicht die SkinButtons ändern
        procedure LoadFromDir(DirName: UnicodeString; Complete: Boolean = True);
        procedure Reload;

        Procedure FitSkinToNewWindow;  // Setz den ganzen Skin bei Bedarf um
        Procedure FitPlayerToNewWindow; // Setzt nur den Player-Teil um

        procedure RepairSkinOffset;
        procedure RefreshTreeBackgrounds(aTree: TVirtualStringTree = Nil);

        procedure SetMenuImages(aUseSkin: Boolean);
        procedure SetTreeImages(aUseSkin: Boolean);
        procedure SetVSTHeaderSettings;

        procedure OnPaintControlBackground(Sender: TWinControl; var Graphic: TGraphic; var Offset: TPoint; var Tile: Boolean);
        procedure OnPaintControlBackgroundEx(Sender: TWinControl; var Graphic: TGraphic; var Offset: TPoint; var Tile: Boolean);

        procedure ActivateSkin(NotTheFirstActivation: Boolean = True);
        procedure DeActivateSkin(NotTheFirstActivation: Boolean = True);
        procedure SetRegionsAgain;

        // LoadGraphicFromBaseName: Load Graphic from a file
        // aFilename<Scale>.<Ext>
        // where <Scale> is a Scalefactor-Suffix (for alternate Graphics in Partymode)
        // and <Ext> is png, bmp or jpg
        function LoadGraphicFromBaseName(aBmp: TPicture; aFilename: UnicodeString; Scaled: Boolean=False): Boolean; overload;
        function LoadGraphicFromBaseName(aBmp: TBitmap; aFilename: UnicodeString; Scaled: Boolean=False): Boolean; overload;

        procedure PaintFallbackImage;

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
    VSTEditControls, MedienBibliothekClass, TagClouds, Systemhelper, DeleteSelect, dmGUI;

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
var
  iBackground: teNempBackroundImages;
begin
  inherited create;
  fNempMainForm := aMainForm;
  fPanelList := TPanelList.Create;
  fMenuList := TMenuList.Create;
  fControlButtonList := TSkinButtonList.Create;
  fTabButtonList := TSkinButtonList.Create;

  for iBackground := Low(teNempBackroundImages) to High(teNempBackroundImages) do
    fNempBackgrounds[iBackground] := TPicture.Create;

  NempPartyMode := TNempPartyMode.Create;
  NempPartymode.BackupOriginalPositions;

  ABrepeatBitmapA := TBitmap.Create;
  ABrepeatBitmapB := TBitmap.Create;

  ABrepeatBitmapA.Transparent := True;
  ABrepeatBitmapB.Transparent := True;
  ABrepeatBitmapA.Width := 13;
  ABrepeatBitmapA.Height := 14;
  ABrepeatBitmapA.Canvas.Rectangle(0,0,14,14);

  ABrepeatBitmapB.Width := 13;
  ABrepeatBitmapB.Height := 14;
  ABrepeatBitmapB.Canvas.Rectangle(0,0,14,14);

  isActive := False;

  RegisteredStyles := TStringList.Create;
end;

destructor TNempSkin.Destroy;
var
  iBackground: teNempBackroundImages;
begin
  RegisteredStyles.Free;
  fPanelList.Free;
  fMenuList.Free;
  fControlButtonList.Free;
  fTabButtonList.Free;
  for iBackground := Low(teNempBackroundImages) to High(teNempBackroundImages) do
    fNempBackgrounds[iBackground].Free;

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
  SkinVersion: Integer;
  iBackground: teNempBackroundImages;

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
  fPath := IncludeTrailingPathDelimiter(DirName);

  ini := TMeminiFile.Create(fPath + 'skin.ini', TEncoding.UTF8);
  try
        ini.Encoding := TEncoding.UTF8;
        SkinVersion := Ini.ReadInteger('Skin', 'Version', 1);
        for iBackground := Low(teNempBackroundImages) to High(teNempBackroundImages) do begin
          // UseImage
          fNempBackgroundSettings[iBackground].UseImage := Ini.ReadBool('BackGround', 'Use' + CBackgroundImagesFilenames[iBackground], CDefaultBackgroundSetting[iBackground].UseImage);
          fNempBackgroundSettings[iBackground].UseImageHeader := Ini.ReadBool('BackGround', 'UseHeader' + CBackgroundImagesFilenames[iBackground], CDefaultBackgroundSetting[iBackground].UseImageHeader);
          fNempBackgroundSettings[iBackground].UseTiledDefaultBackground := Ini.ReadBool('BackGround', 'UseTiledDefaultBackground' + CBackgroundImagesFilenames[iBackground], CDefaultBackgroundSetting[iBackground].UseTiledDefaultBackground);
          // TileImage
          fNempBackgroundSettings[iBackground].Tile := Ini.ReadBool('BackGround', 'Tile' + CBackgroundImagesFilenames[iBackground], CDefaultBackgroundSetting[iBackground].Tile);
          // Alignment
          fNempBackgroundSettings[iBackground].Alignment := teNempAlignment(Ini.ReadInteger('BackGround', 'Align' + CBackgroundImagesFilenames[iBackground], Integer(CDefaultBackgroundSetting[iBackground].Alignment)));
        end;

        PlayerPageOffsetXOrig := Ini.ReadInteger('BackGround','PlayerPageOffsetX', 0);
        PlayerPageOffsetYOrig := Ini.ReadInteger('BackGround','PlayerPageOffsetY', 0);
        PlayerPageOffsetX := PlayerPageOffsetXOrig;
        PlayerPageOffsetY := PlayerPageOffsetYOrig;
        //--------------------------
        DrawTransparentLabel             := Ini.ReadBool('Options','DrawTransparentLabel'            , True);
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
            StyleFilename := Path + AdvancedStyleFilename + '.vsf';
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

        ButtonMode       := Ini.ReadInteger('Options', 'ButtonMode', 1);
        TabButtonMode    := Ini.ReadInteger('Options', 'TabButtonMode', 1);

        UseDefaultListImages             := Ini.ReadBool('Options','UseDefaultListImages', False);
        //UseDefaultTreeImages             := Ini.ReadBool('Options','UseDefaultTreeImages', False);
        UseDefaultMenuImages             := Ini.ReadBool('Options','UseDefaultMenuImages', False);
        // UseSeparatePlayerBitmap          := Ini.ReadBool('Options', 'UseSeparatePlayerBitmap', False);

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

  finally
        ini.free;
  end;

  for iBackground := Low(teNempBackroundImages) to High(teNempBackroundImages) do
    fNempBackgroundSettings[iBackground].ImageLoaded := LoadGraphicFromBaseName(fNempBackgrounds[iBackground], fPath + CBackgroundImagesFilenames[iBackground], false) ;

  if not fNempBackgroundSettings[nbiDefault].ImageLoaded then
    PaintFallbackImage;

  if Not Complete then exit;


  PrepareSkinImagesCollection(DataModuleGui.ICIcons, DataModuleGui.ICSkinIcons);
  SkinMenuImages.Change;

  SetTreeImages(not UseDefaultListImages);
  SetMenuImages((not UseDefaultMenuImages) and NempOptions.GlobalUseAdvancedSkin)
end;

procedure TNempSkin.SetMenuImages(aUseSkin: Boolean);
var
  aList: TCustomImageList;
  i: Integer;
begin
  if aUseSkin then aList := SkinMenuImages
  else aList := VclMenuImages;

  for i := 0 to MenuList.Count - 1 do
    MenuList[i].Images := aList;
end;

procedure TNempSkin.SetTreeImages(aUseSkin: Boolean);
var
  aList: TCustomImageList;
begin
  if aUseSkin then aList := SkinMenuImages
  else aList := VclMenuImages;

  PlaylistVST.Images := aList;
  MainVST.Images     := aList;
end;


Procedure TNempSkin.FitSkinToNewWindow;
begin
  RepairSkinOffset;
  RefreshTreeBackgrounds;
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

    if (not fNempBackgroundSettings[nbiDefault].UseImage) or  (not fNempBackgroundSettings[nbiDefault].ImageLoaded) then
      exit;

    // todo: get a matching sub-Form in separate window mode (i.e. the top left one, the bottom right one, ...)
    // aForm := Nemp_MainForm;

    //if FixedBackGround then
    //begin
        //case AlignCompleteBackground of
        case fNempBackgroundSettings[nbiDefault].Alignment of
            nalLeftCenter: begin // left-center
                  aPoint :=  fNempMainForm.ClientToScreen(Point(0, fNempMainForm.ClientHeight Div 2));
                  PlayerPageOffsetX := aPoint.X ;
                  PlayerPageOffsetY := aPoint.Y - (CompleteBitmap.Height Div 2);
            end;
            nalRightCenter: begin // right-center
                  aPoint := fNempMainForm.ClientToScreen(Point(fNempMainForm.ClientWidth, fNempMainForm.ClientHeight Div 2));
                  PlayerPageOffsetX := aPoint.X - CompleteBitmap.Width;
                  PlayerPageOffsetY := aPoint.Y - (CompleteBitmap.Height Div 2);
            end;
            nalCenterCenter: begin // align to MainControls (use PlayerPageOffset<X/Y>Orig in that case)
                  // PlayerPageOffsetX/Y is some point in the image, "where the painting should start with"
                  // useful when background is aligned with the PlayerControls (but not that useful in 4.11 anymore)
                  aPoint := Nemp_MainForm._ControlPanel.ClientToScreen(Point(0,0));

                  PlayerPageOffsetX := aPoint.X - PlayerPageOffsetXOrig;
                  PlayerPageOffsetY := aPoint.Y - PlayerPageOffsetYOrig;
            end;
            nalLeftTop: begin // left-top
                  aPoint := fNempMainForm.ClientToScreen(Point(0,0)); //Nemp_MainForm.ClientToScreen(Point(0,0));
                  PlayerPageOffsetX := aPoint.X ;
                  PlayerPageOffsetY := aPoint.Y ;
            end;
            nalRightTop: begin //right-top
                  //aPoint := Nemp_MainForm.ClientToScreen(Point(Nemp_MainForm.Width, 0));
                  aPoint := fNempMainForm.ClientToScreen(Point(fNempMainForm.ClientWidth, 0));

                  PlayerPageOffsetX := aPoint.X - CompleteBitmap.Width;
                  PlayerPageOffsetY := aPoint.Y ;
            end;

            nalLeftBottom: begin //left-bottom
                  aPoint := fNempMainForm.ClientToScreen(Point(0, fNempMainForm.ClientHeight));
                  PlayerPageOffsetX := aPoint.X ;
                  PlayerPageOffsetY := aPoint.Y - CompleteBitmap.Height;
            end;
            nalRightBottom: begin //right-bottom
                  aPoint := fNempMainForm.ClientToScreen(Point(fNempMainForm.ClientWidth, fNempMainForm.ClientHeight));
                  PlayerPageOffsetX := aPoint.X - CompleteBitmap.Width;
                  PlayerPageOffsetY := aPoint.Y - CompleteBitmap.Height;
            end;
        end;

    //end else
    //begin
    //    // 2019: This should be the same as in all the "OffsetPoints" in later methods. Or not?
    //    aPoint := Nemp_MainForm.PlayerControlPanel.ClientToScreen(Point(0,0));
    //    PlayerPageOffsetX := aPoint.X + PlayerPageOffsetXOrig;
    //    PlayerPageOffsetY := aPoint.Y + PlayerPageOffsetYOrig;
    //end;
end;



procedure TNempSkin.RefreshTreeBackgrounds(aTree: TVirtualStringTree = Nil);
begin
  if FormLayout.BuildInProcess or not isActive then
    exit;

  if assigned(aTree) then
    RefreshTreeBackground(aTree)
  else begin
    // update all Trees
    RefreshTreeBackground(ArtistsVST);
    RefreshTreeBackground(AlbenVST);
    RefreshTreeBackground(MainVST);
    RefreshTreeBackground(PlaylistVST);
  end;
end;


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

procedure TNempSkin.SetButtonMode(const Value: Integer);
begin
  if (Value < 0) or (Value > 2) then
    fButtonMode := 0
  else
    fButtonMode := Value;
end;

procedure TNempSkin.SetTabButtonMode(const Value: Integer);
begin
  if (Value < 0) or (Value > 2) then
    fTabButtonMode := 0
  else
    fTabButtonMode := Value;
end;

procedure TNempSkin.SetControlButtonLook;
var
  i: Integer;
begin
  if (not isActive) or (ButtonMode = 0) then begin
    Nemp_MainForm.viPlayerButtons.ImageCollection := DataModuleGui.ICPlayerButtons;
    for i := 0 to ControlButtonList.Count - 1 do begin
      ControlButtonList[i].DrawMode := dm_Windows;
      ControlButtonList[i].StyleElements := [seFont, seClient, seBorder];
    end;
  end else begin
    PrepareSkinImagesCollection(DataModuleGui.ICPlayerButtons, DataModuleGui.ICSkinPlayerButtons);
    Nemp_MainForm.viPlayerButtons.ImageCollection := DataModuleGui.ICSkinPlayerButtons;

    case ButtonMode of
      1: begin
          for i := 0 to ControlButtonList.Count - 1 do begin
            ControlButtonList[i].DrawMode := dm_Windows;
            ControlButtonList[i].StyleElements := [seFont, seClient, seBorder];
          end;
      end;
      2: begin
        for i := 0 to ControlButtonList.Count - 1 do begin
          ControlButtonList[i].DrawMode := dm_Skin;
          {$IFDEF USESTYLES}
          ControlButtonList[i].StyleElements := [];
          {$ENDIF}
        end;
      end;
    end;
  end;
end;

procedure TNempSkin.SetTabButtonLook;
var
  i: Integer;
begin
  if (not isActive) or (TabButtonMode = 0) then begin
    Nemp_MainForm.viTabButtons.ImageCollection := DataModuleGui.ICTabButtons;
    for i := 0 to TabButtonList.Count - 1 do begin
      TabButtonList[i].DrawMode := dm_Windows;
      TabButtonList[i].StyleElements := [seFont, seClient, seBorder];
    end;
  end else begin
    PrepareSkinImagesCollection(DataModuleGui.ICTabButtons, DataModuleGui.ICSkinTabButtons);
    Nemp_MainForm.viTabButtons.ImageCollection := DataModuleGui.ICSkinTabButtons;
    case TabButtonMode of
      1: begin
          for i := 0 to TabButtonList.Count - 1 do begin
            TabButtonList[i].DrawMode := dm_Windows;
            TabButtonList[i].StyleElements := [seFont, seClient, seBorder];
          end;
      end;
      2: begin
        for i := 0 to TabButtonList.Count - 1 do begin
          TabButtonList[i].DrawMode := dm_Skin;
          {$IFDEF USESTYLES}
          TabButtonList[i].StyleElements := [];
          {$ENDIF}
        end;
      end;
    end;
  end;

end;


procedure TNempSkin.ActivateSkin(NotTheFirstActivation: Boolean = True);
var
  i: integer;
begin
  isActive := True;
  RevokeDragFiles;

  //zunächst: Ownerdraw der Boxen/Panels setzen
  for i := 0 to fPanelList.Count - 1 do begin
    fPanelList[i].DrawMode := dm_Skin;
    fPanelList[i].BackgroundColor := SkinColorScheme.FormCL;
    fPanelList[i].FrameColor := SkinColorScheme.GroupboxFrameCL;
  end;

  LoadGraphicFromBaseName(NempPlayer.PreviewBackGround, Path + 'Win7PreviewBackground', false);
  // Grafiken für die Buttons setzem
  with Nemp_MainForm do begin
    if assigned(DeleteSelection) then
      DeleteSelection.ReloadScheckBoxImages(path, true);

    // Buttons / Images konfigurieren.
    AssignABGraphics;
    RefreshStarGraphicsAllForms;

    SetControlButtonLook;
    SetTabButtonLook;
  end;


  if fNempBackgroundSettings[nbiBrowse].UseImage then begin
    ArtistsVST.Background.Assign(BrowseBitmap);
    AlbenVST.Background.Assign(BrowseBitmap)
  end else begin
    ArtistsVST.Background.Assign(Nil);
    AlbenVST.Background.Assign(Nil)
  end;

  if fNempBackgroundSettings[nbiPlaylist].UseImage then
    PlaylistVST.Background.Assign(Playlistbitmap)
  else
    PlaylistVST.Background.Assign(Nil);

  if fNempBackgroundSettings[nbiMediaList].UseImage then
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
      RefreshCoverflowBackground;

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

    NempSpectrum.ColorPeak := SkinColorScheme.SpecPeakCL;
    NempSpectrum.ColorBar1 := SkinColorScheme.SpecPenCL;
    NempSpectrum.ColorBar2 := SkinColorScheme.SpecPen2CL;

    if (HideMainMenu) or (NempOptions.AnzeigeMode = 1) then
      Menu := NIL
    else
      Menu := Nemp_MainMenu;
  end;

  // Dann: Hintergrundgrafiken-Offsets für die Trees initialisieren
  RepairSkinOffset;
  RefreshTreeBackgrounds;

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
begin
    with Nemp_MainForm do begin
      if NempOptions.AnzeigeMode = 1 then
         UpdateSmallMainForm;
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

  if assigned(DeleteSelection) then
      DeleteSelection.ReloadScheckBoxImages(ExtractFilePath(ParamStr(0)) + 'Images\', false);

  // Grafiken für die Buttons setzen
  with Nemp_MainForm do begin
    viPlayerButtons.ImageCollection := DataModuleGui.ICPlayerButtons;
    SetMenuImages(False);
    SetTreeImages(False);
    SetControlButtonLook;
    SetTabButtonLook;
    AssignABGraphics;
    RefreshStarGraphicsAllForms;
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
  MainVST.SelectionBlendFactor     := 75 ;

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


function TNempSkin.GetBackgroundBitmapByIndex(const Index: teNempBackroundImages): TGraphic;
begin
  if fNempBackgroundSettings[Index].ImageLoaded then
    result := fNempBackgrounds[Index].Graphic
  else
    result := fNempBackgrounds[nbiDefault].Graphic;
end;

function TNempSkin.GetPath: String;
begin
  result := IncludeTrailingPathDelimiter(fPath);
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

function TNempSkin.GetBackgroundIndex(aTag: Integer): teNempBackroundImages;
begin
  case aTag of
    1: result := nbiPlaylist;   // Playlist
    2: result := nbiBrowse;     // Browse (Tree, Coverflow, TagCloud)
    3: result := nbiMedialist;  // MediaList
    4: result := nbiDetails;     // Details (new in 5.3)
    5: result := nbiPlayerControls;
    6: result := nbiPlayerCover;
  else
    result := nbiDefault;
  end;
end;

function TNempSkin.GetBackgroundIndex(aPanel: TNempPanel): teNempBackroundImages;
begin
  result := GetBackgroundIndex(aPanel.Tag);
end;

function TNempSkin.GetBackgroundBitmap(aPanel: TNempPanel): TGraphic;
var
  bgIndex: teNempBackroundImages;
begin
  bgIndex := GetBackgroundIndex(aPanel);

  case aPanel.PanelType of
    ptNormal,
    ptContainer: result := GetBackgroundBitmapByIndex(bgIndex);
    ptHeader: begin
      if fNempBackgroundSettings[bgIndex].UseImageHeader then
        result := GetBackgroundBitmapByIndex(bgIndex)
      else
        result := fNempBackgrounds[nbiDefault].Graphic;
    end;
  else
    GetBackgroundBitmapByIndex(bgIndex)
  end;
end;

function TNempSkin.GetBackgroundAlignment(aPanel: TNempPanel): teNempAlignment;
var
  bgIndex: teNempBackroundImages;
begin
  bgIndex := GetBackgroundIndex(aPanel);
  if fNempBackgroundSettings[bgIndex].ImageLoaded then
    result := fNempBackgroundSettings[bgIndex].Alignment
  else
    result := fNempBackgroundSettings[nbiDefault].Alignment
end;

function TNempSkin.GetTileByTag(aTag: Integer): Boolean;
var
  bgIndex: teNempBackroundImages;
begin
  bgIndex := GetBackgroundIndex(aTag);
  if fNempBackgroundSettings[bgIndex].ImageLoaded then
    result := fNempBackgroundSettings[bgIndex].Tile
  else
    result := fNempBackgroundSettings[nbiDefault].Tile
end;

function TNempSkin.GetDefaultOffset(aControl: TWinControl): TPoint;
begin
  result := Point(PlayerPageOffsetX, PlayerPageOffsetY)- aControl.ClientToScreen(Point(0,0));
end;

function TNempSkin.GetBaseControlOffset(aBaseControl: TWinControl; aBitmap: TGraphic; aAlignment: teNempAlignment): TPoint;
begin
  case aAlignment of
    nalLeftCenter   : result :=  Point(0, (aBaseControl.ClientHeight Div 2) - (aBitmap.Height Div 2) );
    nalRightCenter  : result := Point(aBaseControl.ClientWidth - aBitmap.Width, (aBaseControl.ClientHeight Div 2) - (aBitmap.Height Div 2) );
    // nalCenterCenter: align to MainControls (use PlayerPageOffset<X/Y>Orig in that case), doesnt make sense here - use "center-center"
    nalCenterCenter : result := Point((aBaseControl.ClientWidth Div 2) - (aBitmap.Width Div 2), (aBaseControl.ClientHeight Div 2) - (aBitmap.Height Div 2) );
    nalLeftTop      : result := Point(0,0);
    nalRightTop     : result := Point(aBaseControl.ClientWidth - aBitmap.Width, 0);
    nalLeftBottom   : result := Point (0, aBaseControl.ClientHeight - aBitmap.Height);
    nalRightBottom  : result :=  Point (aBaseControl.ClientWidth - aBitmap.Width, aBaseControl.ClientHeight - aBitmap.Height);
  end;
end;

function TNempSkin.GetBackgroundOffset(aControl: TWinControl; aBitmap: TGraphic; aAlignment: teNempAlignment): TPoint;
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


procedure TNempSkin.RefreshTreeBackground(aTree: TVirtualStringTree);
var
  TreeOffset: TPoint;
  Tile: Boolean;
  SourceGraphic: TGraphic;
  tmpBmp: TBitmap;
  BasePanel: TNempPanel;
  BGS: TNempBackgroundSetting;
begin
  BasePanel := GetBackgroundBasePanel(aTree);
  if not assigned(BasePanel) then
    exit;

  BGS := fNempBackgroundSettings[GetBackgroundIndex(BasePanel)];
  if (not BGS.UseImage) and (not BGS.UseTiledDefaultBackground) and (not BGS.ImageLoaded) then
    exit;

  tmpBmp := TBitmap.Create;
  try
    tmpBmp.Width := aTree.Width;
    tmpBmp.Height := aTree.Height;

    // First Round
    TreeOffset := Point(0,0);
    Tile := False;
    SourceGraphic := Nil;
    OnPaintControlBackground(aTree, SourceGraphic, TreeOffset, Tile);
    if not Assigned(SourceGraphic) then
      TNempPanel.PaintSimpleBackground(tmpBmp.Canvas, aTree.Color)
    else
      TNempPanel.PaintGraphicBackground(aTree.Color, SourceGraphic, tmpBmp.Canvas, TreeOffset, Tile, True);

    // Second round: Paint another Graphic, maybe an overlay symbol
    TreeOffset := Point(0,0);
    Tile := False;
    SourceGraphic := Nil;
    OnPaintControlBackgroundEx(aTree, SourceGraphic, TreeOffset, Tile);
    if assigned(SourceGraphic) then
      TNempPanel.PaintGraphicBackground(aTree.Color, SourceGraphic, tmpBmp.Canvas, TreeOffset, False, False);
    // else: nothing to do here, no additional painting wanted

    // Finally assign the Bitmap to the Tree
    aTree.Background.Assign(tmpBmp);
    aTree.Invalidate;
  finally
    tmpBmp.Free
  end;
end;

procedure TNempSkin.OnInternalPaintControlBackground(Sender: TWinControl; BasePanel: TNempPanel;
  var Graphic: TGraphic; var Offset: TPoint; var Tile: Boolean);
var
  Alignment: teNempAlignment;
begin
  if fNempBackgroundSettings[GetBackgroundIndex(Basepanel)].UseImage then begin
    // get a proper Background Bitmap for the Tree, based on the BasePanel it is located on
    Graphic := GetBackgroundBitmap(BasePanel);
    if Graphic = CompleteBitmap then begin
      // if it's the MainBitmap:
      // Set Offset in relation to the MainControl
      Offset := GetDefaultOffset(Sender);
      // Tile := fNempBackgroundSettings[nbiDefault].Tile;
    end else begin
      // if it's a seperate Bitmap:
      // Set Offset in relation to the BasePanel, using it's Alignment setting
      Alignment := GetBackgroundAlignment(BasePanel);
      Offset := GetBackgroundOffset(Sender, Graphic, Alignment);
    end;
    if Graphic = CompleteBitmap then
      Tile := fNempBackgroundSettings[nbiDefault].Tile
    else
      Tile := fNempBackgroundSettings[GetBackgroundIndex(Basepanel)].Tile;
  end;
end;

procedure TNempSkin.OnPaintControlBackground(Sender: TWinControl; var Graphic: TGraphic;
  var Offset: TPoint; var Tile: Boolean);
var
  BasePanel: TNempPanel;
begin
  BasePanel := GetBackgroundBasePanel(Sender);
  if not assigned(BasePanel) then
    exit;

  // This is the first round of Background-Painting for the Panel.
  if fNempBackgroundSettings[GetBackgroundIndex(BasePanel)].UseTiledDefaultBackground then begin
    // we want to Tile the background with the default graphic
    // There will be a second round of Background-Painting for the Panel, where an Overlay image can be painted
    Graphic := CompleteBitmap;
    Tile := True;
    OffSet := GetDefaultOffset(Sender);
  end else
    // we DO NOT want to Tile the background with the default graphic
    // There will be NO second round of Background-Painting for the Panel.
    OnInternalPaintControlBackground(Sender, BasePanel, Graphic, Offset, Tile);
end;

procedure TNempSkin.OnPaintControlBackgroundEx(Sender: TWinControl; var Graphic: TGraphic; var Offset: TPoint; var Tile: Boolean);
var
  BasePanel: TNempPanel;
begin
  BasePanel := GetBackgroundBasePanel(Sender);
  if not assigned(BasePanel) then
    exit;

  // This is the second round of Background-Painting for the Panel.
  // !! Do it only if UseTiledDefaultBackground
  if fNempBackgroundSettings[GetBackgroundIndex(BasePanel)].UseTiledDefaultBackground then
    OnInternalPaintControlBackground(Sender, BasePanel, Graphic, Offset, Tile);
end;

procedure TNempSkin.PaintFallbackImage;
var
  aBitmap: TBitmap;
begin
  aBitmap := TBitmap.Create;
  try
    aBitmap.Width := 10;
    aBitmap.Height := 10;
    aBitmap.Canvas.Brush.Color := SkinColorScheme.FormCL;
    aBitmap.Canvas.Pen.Color := SkinColorScheme.LabelCL;
    aBitmap.Canvas.FillRect(aBitmap.Canvas.ClipRect);
    fNempBackgrounds[nbiDefault].Assign(aBitmap);
  finally
    aBitmap.Free;
  end;
end;


function TNempSkin.LoadGraphicFromBaseName(aBmp: TBitmap; aFilename: UnicodeString; Scaled: Boolean=False): Boolean;
var
  tmpPic: TPicture;
begin
  result := False;
  tmpPic := TPicture.Create;
  try
    if LoadGraphicFromBaseName(tmpPic, aFilename, Scaled) then begin
      aBmp.Assign(tmpPic.Graphic);
      result := True;
    end;
  finally
    tmpPic.Free;
  end;

end;

function TNempSkin.LoadGraphicFromBaseName(aBmp: TPicture; aFilename: UnicodeString; Scaled: Boolean=False): Boolean;
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
  result := False;
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

  if FileExists(NewName) then begin
    result := True;
    try
      aBmp.LoadFromFile(NewName);
    except
      result := False;
    end;
  end;

  (*
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
  *)
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

procedure TNempSkin.SetImage(Dest, Backup: TImageCollection; ItemName: String; ItemIndex: Integer);
var
  newCollectionItem, backupCollectionItem : TImageCollectionItem;
  newImageCollectionSourceItem : TImageCollectionSourceItem;
  newItemFilename: String;
  i: Integer;
  success: Boolean;

  function GetExistingImageFile(ScaleDir: String; var FileName: String): Boolean;
  var
    fn: String;
  begin
    result := True;
    FileName := '';
    fn := IncludeTrailingPathDelimiter(Path + ScaleDir) + ItemName;
    if FileExists(fn + '.png') then FileName := fn + '.png'
    else if FileExists(fn + '.bmp') then FileName := fn + '.bmp'
    else if FileExists(fn + '.jpg') then FileName := fn + '.jpg'
    else
      result := False;
  end;

begin
  //create "place" for new image
  newCollectionItem := Dest.Images.Add;
  newCollectionItem.Name := ItemName;
  //create item to put source of new image
  success := False;
  for i := Low(cScaleDirectories) to High(cScaleDirectories) do begin
    if GetExistingImageFile(cScaleDirectories[i], newItemFilename) then begin
      newImageCollectionSourceItem := newCollectionItem.SourceImages.Add;
      newImageCollectionSourceItem.Image.LoadFromFile(newItemFilename);
      success := True;
    end;
  end;
  if assigned(Backup) and not Success then
    newCollectionItem.Assign(Backup.Images[ItemIndex]);
end;

procedure TNempSkin.PrepareSkinImagesCollection(aDefaultCollection, aSkinCollection: TImageCollection);
var
  i: Integer;
begin
  aSkinCollection.Images.BeginUpdate;
  try
    aSkinCollection.Images.Clear;
    for i := 0 to aDefaultCollection.Images.Count - 1 do
      SetImage(aSkinCollection, aDefaultCollection, aDefaultCollection.Images[i].Name, i);
  finally
    aSkinCollection.Images.EndUpdate;
    aSkinCollection.Change;
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
