object FormPlaylistDuplicates: TFormPlaylistDuplicates
  Left = 0
  Top = 0
  Caption = 'Nemp: Playlist duplicates'
  ClientHeight = 504
  ClientWidth = 584
  Color = clBtnFace
  Constraints.MinWidth = 600
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 13
  object pnlMain: TPanel
    Left = 0
    Top = 60
    Width = 584
    Height = 139
    Align = alClient
    BevelOuter = bvNone
    Constraints.MinHeight = 139
    TabOrder = 0
    object Splitter2: TSplitter
      Left = 295
      Top = 0
      Height = 139
      ResizeStyle = rsUpdate
      ExplicitLeft = 448
      ExplicitTop = 128
      ExplicitHeight = 100
    end
    object grpBoxDuplicates: TGroupBox
      AlignWithMargins = True
      Left = 301
      Top = 3
      Width = 280
      Height = 133
      Align = alClient
      Caption = 'Identified duplicates'
      Constraints.MinHeight = 80
      Constraints.MinWidth = 100
      TabOrder = 0
      DesignSize = (
        280
        133)
      object VstDuplicates: TVirtualStringTree
        AlignWithMargins = True
        Left = 10
        Top = 23
        Width = 260
        Height = 52
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 8
        Align = alTop
        Anchors = [akLeft, akTop, akRight, akBottom]
        BevelEdges = []
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Colors.UnfocusedSelectionColor = clHighlight
        Colors.UnfocusedSelectionBorderColor = clHighlight
        Ctl3D = True
        DefaultPasteMode = amInsertAfter
        DragImageKind = diMainColumnOnly
        DragWidth = 10
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Header.AutoSizeIndex = 1
        Header.Background = clWindow
        Header.MainColumn = 1
        Header.Options = [hoAutoResize, hoDrag]
        HintMode = hmHint
        Indent = 2
        Margin = 0
        ParentCtl3D = False
        ParentFont = False
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ScrollBarOptions.ScrollBars = ssVertical
        ShowHint = True
        TabOrder = 0
        TextMargin = 0
        TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScroll, toAutoScrollOnExpand, toAutoTristateTracking]
        TreeOptions.PaintOptions = [toShowBackground, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages, toUseBlendedSelection]
        TreeOptions.SelectionOptions = [toExtendedFocus, toFullRowSelect, toRightClickSelect]
        OnChange = VstDuplicatesChange
        OnColumnDblClick = VstDuplicatesColumnDblClick
        OnGetText = VstDuplicatesGetText
        OnPaintText = VstDuplicatesPaintText
        Touch.InteractiveGestures = [igPan, igPressAndTap]
        Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
        ExplicitLeft = 2
        ExplicitTop = 15
        ExplicitWidth = 276
        ExplicitHeight = 68
        Columns = <
          item
            Alignment = taRightJustify
            CaptionAlignment = taRightJustify
            Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
            Position = 0
            Text = 'Index'
            Width = 30
          end
          item
            Position = 1
            Spacing = 0
            Text = 'Title'
            Width = 190
          end
          item
            Alignment = taRightJustify
            Margin = 0
            Position = 2
            Spacing = 50
            Text = 'Time'
            Width = 40
          end>
      end
      object btnDeleteOriginal: TButton
        AlignWithMargins = True
        Left = 16
        Top = 97
        Width = 118
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'Delete original'
        TabOrder = 1
        OnClick = btnDeleteOriginalClick
      end
      object btnDeleteDuplicate: TButton
        AlignWithMargins = True
        Left = 140
        Top = 97
        Width = 118
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'Delete duplicate'
        TabOrder = 2
        OnClick = btnDeleteDuplicateClick
      end
    end
    object grpBoxCompare: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 289
      Height = 133
      Align = alLeft
      Caption = 'Summary'
      Constraints.MinWidth = 100
      TabOrder = 1
      DesignSize = (
        289
        133)
      object lblTracksBetweenCaption: TLabel
        Left = 16
        Top = 16
        Width = 108
        Height = 13
        Caption = 'Between these tracks:'
      end
      object lblTracksBetween: TLabel
        Left = 57
        Top = 35
        Width = 222
        Height = 13
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = '..............'
        ExplicitWidth = 225
      end
      object lblSummaryDuplicate: TLabel
        Left = 16
        Top = 72
        Width = 157
        Height = 13
        Caption = 'Identified as duplicate, because:'
      end
      object lblTimeBetween: TLabel
        Left = 57
        Top = 50
        Width = 222
        Height = 13
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = '..............'
        ExplicitWidth = 225
      end
      object imgDuplicateInfo: TVirtualImage
        AlignWithMargins = True
        Left = 16
        Top = 35
        Width = 32
        Height = 32
        ImageCollection = DataModuleGui.ICGraphics
        ImageWidth = 0
        ImageHeight = 0
        ImageIndex = 37
        ImageName = 'imgTime'
      end
      object imgDuplicateReason: TVirtualImage
        AlignWithMargins = True
        Left = 16
        Top = 91
        Width = 32
        Height = 32
        ImageCollection = DataModuleGui.ICGraphics
        ImageWidth = 0
        ImageHeight = 0
        ImageIndex = 15
        ImageName = 'imgAlert'
      end
      object lblDuplicateReason1: TLabel
        Left = 57
        Top = 91
        Width = 222
        Height = 13
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = '..............'
        ExplicitWidth = 225
      end
      object lblDuplicateReason2: TLabel
        Left = 57
        Top = 106
        Width = 222
        Height = 13
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = '..............'
        ExplicitWidth = 225
      end
    end
  end
  object PnlDetails: TPanel
    Left = 0
    Top = 199
    Width = 584
    Height = 264
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 295
      Top = 0
      Height = 264
      ResizeStyle = rsUpdate
      ExplicitLeft = 380
      ExplicitTop = -8
      ExplicitHeight = 230
    end
    object grpBoxDetailsPlaylist: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 289
      Height = 258
      Align = alLeft
      Caption = 'Currently selected file in the playlist'
      Constraints.MinWidth = 100
      TabOrder = 0
      DesignSize = (
        289
        258)
      object Bevel2: TBevel
        Left = 13
        Top = 103
        Width = 262
        Height = 5
        Anchors = [akLeft, akTop, akRight]
        Shape = bsBottomLine
        ExplicitWidth = 297
      end
      object LblAlbumPlaylist: TLabel
        Tag = 2
        Left = 16
        Top = 117
        Width = 104
        Height = 13
        Caption = '..........................'
        ShowAccelChar = False
      end
      object LblArtistPlaylist: TLabel
        Left = 16
        Top = 16
        Width = 78
        Height = 13
        Caption = '..........................'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ShowAccelChar = False
      end
      object lblDirectoryPlaylist: TLabel
        Tag = 6
        Left = 16
        Top = 65
        Width = 104
        Height = 13
        Caption = '..........................'
        ShowAccelChar = False
      end
      object LblDurationPlaylist: TLabel
        Left = 16
        Top = 168
        Width = 104
        Height = 13
        Caption = '..........................'
        ShowAccelChar = False
      end
      object lblFilenamePlaylist: TLabel
        Left = 16
        Top = 50
        Width = 104
        Height = 13
        Caption = '..........................'
        ShowAccelChar = False
      end
      object LblGenrePlaylist: TLabel
        Tag = 5
        Left = 16
        Top = 151
        Width = 104
        Height = 13
        Caption = '..........................'
        ShowAccelChar = False
      end
      object LblPlayCounterPlaylist: TLabel
        Left = 102
        Top = 205
        Width = 104
        Height = 13
        Caption = '..........................'
        ShowAccelChar = False
      end
      object LblQualityPlaylist: TLabel
        Left = 16
        Top = 185
        Width = 104
        Height = 13
        Caption = '..........................'
        ShowAccelChar = False
      end
      object LblReplayGainPlaylist: TLabel
        Left = 16
        Top = 224
        Width = 104
        Height = 13
        Hint = 'ReplayGain values'
        Caption = '..........................'
        ShowAccelChar = False
      end
      object LblTitlePlaylist: TLabel
        Tag = 1
        Left = 16
        Top = 31
        Width = 78
        Height = 13
        Caption = '..........................'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ShowAccelChar = False
      end
      object LblYearPlaylist: TLabel
        Tag = 4
        Left = 16
        Top = 134
        Width = 104
        Height = 13
        Caption = '..........................'
        ShowAccelChar = False
      end
      object LblPlaylistPositionPlaylist: TLabel
        Tag = 6
        Left = 16
        Top = 84
        Width = 81
        Height = 13
        Caption = '.......................... '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ShowAccelChar = False
      end
      object BtnRatingPlaylist: TRatingButton
        Left = 16
        Top = 204
        Width = 80
        Height = 16
        DoubleBuffered = True
        DrawMode = dm_Windows
        Images = vilIcons
        ParentDoubleBuffered = False
        TabOrder = 0
        TransparentBackground = True
        StyleElements = [seFont, seBorder]
        Rating = 120
        AllowChangeRating = False
        StarFullImageIndex = 29
        StarHalfImageIndex = 30
        StarEmptyImageIndex = 28
        StarFullImageName = 'MenuStarFull'
        StarHalfImageName = 'MenuStarHalf'
        StarEmptyImageName = 'MenuStarEmpty'
      end
    end
    object grpBoxDetailsDuplicate: TGroupBox
      AlignWithMargins = True
      Left = 301
      Top = 8
      Width = 280
      Height = 253
      Margins.Top = 8
      Align = alClient
      Caption = 'Currently selected possible duplicate'
      Constraints.MinWidth = 100
      TabOrder = 1
      ExplicitTop = 3
      ExplicitHeight = 258
      DesignSize = (
        280
        253)
      object LblAlbumDuplicate: TLabel
        Tag = 2
        Left = 16
        Top = 117
        Width = 107
        Height = 13
        Caption = '.......................... '
        ShowAccelChar = False
      end
      object LblArtistDuplicate: TLabel
        Left = 16
        Top = 16
        Width = 81
        Height = 13
        Caption = '.......................... '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ShowAccelChar = False
      end
      object lblDirectoryDuplicate: TLabel
        Tag = 6
        Left = 16
        Top = 65
        Width = 107
        Height = 13
        Caption = '.......................... '
        ShowAccelChar = False
      end
      object LblDurationDuplicate: TLabel
        Left = 16
        Top = 168
        Width = 107
        Height = 13
        Caption = '.......................... '
        ShowAccelChar = False
      end
      object lblFilenameDuplicate: TLabel
        Left = 16
        Top = 50
        Width = 107
        Height = 13
        Caption = '.......................... '
        ShowAccelChar = False
      end
      object LblGenreDuplicate: TLabel
        Tag = 5
        Left = 16
        Top = 151
        Width = 107
        Height = 13
        Caption = '.......................... '
        ShowAccelChar = False
      end
      object LblPlayCounterDuplicate: TLabel
        Left = 102
        Top = 205
        Width = 107
        Height = 13
        Caption = '.......................... '
        ShowAccelChar = False
      end
      object LblQualityDuplicate: TLabel
        Left = 16
        Top = 185
        Width = 107
        Height = 13
        Caption = '.......................... '
        ShowAccelChar = False
      end
      object LblReplayGainDuplicate: TLabel
        Left = 16
        Top = 224
        Width = 107
        Height = 13
        Hint = 'ReplayGain values'
        Caption = '.......................... '
        ShowAccelChar = False
      end
      object LblTitleDuplicate: TLabel
        Tag = 1
        Left = 16
        Top = 31
        Width = 81
        Height = 13
        Caption = '.......................... '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ShowAccelChar = False
      end
      object LblYearDuplicate: TLabel
        Tag = 4
        Left = 16
        Top = 134
        Width = 107
        Height = 13
        Caption = '.......................... '
        ShowAccelChar = False
      end
      object Bevel1: TBevel
        Left = 12
        Top = 103
        Width = 247
        Height = 5
        Anchors = [akLeft, akTop, akRight]
        Shape = bsBottomLine
        ExplicitWidth = 293
      end
      object LblPlaylistPositionDuplicate: TLabel
        Tag = 6
        Left = 16
        Top = 84
        Width = 81
        Height = 13
        Caption = '.......................... '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ShowAccelChar = False
      end
      object BtnRatingDuplicate: TRatingButton
        Left = 16
        Top = 204
        Width = 80
        Height = 16
        DoubleBuffered = True
        DrawMode = dm_Windows
        Images = vilIcons
        ParentDoubleBuffered = False
        TabOrder = 0
        TransparentBackground = True
        StyleElements = [seFont, seBorder]
        Rating = 120
        AllowChangeRating = False
        StarFullImageIndex = 29
        StarHalfImageIndex = 30
        StarEmptyImageIndex = 28
        StarFullImageName = 'MenuStarFull'
        StarHalfImageName = 'MenuStarHalf'
        StarEmptyImageName = 'MenuStarEmpty'
      end
    end
  end
  object PnlFooter: TPanel
    Left = 0
    Top = 463
    Width = 584
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      584
      41)
    object BtnOK: TButton
      AlignWithMargins = True
      Left = 497
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Ok'
      TabOrder = 0
      OnClick = BtnOKClick
    end
    object BtnRefresh: TButton
      Left = 5
      Top = 8
      Width = 121
      Height = 25
      Hint = 'Scan the playlist for duplicates again'
      Caption = 'Refresh'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = BtnRefreshClick
    end
  end
  object PnlPlaylistSelect: TPanel
    Left = 0
    Top = 0
    Width = 584
    Height = 60
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object grpBoxPlaylist: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 578
      Height = 54
      Align = alClient
      Caption = 'Selection in Nemp playlist'
      TabOrder = 0
      DesignSize = (
        578
        54)
      object imgPlaylist: TVirtualImage
        AlignWithMargins = True
        Left = 16
        Top = 15
        Width = 32
        Height = 32
        ImageCollection = DataModuleGui.ICGraphics
        ImageWidth = 0
        ImageHeight = 0
        ImageIndex = 8
        ImageName = 'imgNempLogo'
      end
      object LblPlaylistTitle: TLabel
        Left = 91
        Top = 20
        Width = 426
        Height = 19
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = '..........................'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitWidth = 430
      end
      object LblPlaylistTime: TLabel
        Left = 520
        Top = 20
        Width = 50
        Height = 19
        Alignment = taRightJustify
        Anchors = [akTop, akRight]
        AutoSize = False
        Caption = '.....'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitLeft = 528
      end
      object lblPlaylistIndex: TLabel
        Left = 54
        Top = 20
        Width = 30
        Height = 19
        Alignment = taRightJustify
        AutoSize = False
        Caption = '...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 447
    Top = 91
    object Deletethisduplicate1: TMenuItem
      Caption = 'Delete selected duplicate'
      ShortCut = 46
      OnClick = Deletethisduplicate1Click
    end
  end
  object vilIcons: TVirtualImageList
    AutoFill = True
    Images = <
      item
        CollectionIndex = 0
        CollectionName = 'MenuInfo'
        Name = 'MenuInfo'
      end
      item
        CollectionIndex = 1
        CollectionName = 'MenuAddFolder'
        Name = 'MenuAddFolder'
      end
      item
        CollectionIndex = 2
        CollectionName = 'MenuBirthday'
        Name = 'MenuBirthday'
      end
      item
        CollectionIndex = 3
        CollectionName = 'MenuCleanUp'
        Name = 'MenuCleanUp'
      end
      item
        CollectionIndex = 4
        CollectionName = 'MenuCloseNemp'
        Name = 'MenuCloseNemp'
      end
      item
        CollectionIndex = 5
        CollectionName = 'MenuConfigureLibrary'
        Name = 'MenuConfigureLibrary'
      end
      item
        CollectionIndex = 6
        CollectionName = 'MenuDelete'
        Name = 'MenuDelete'
      end
      item
        CollectionIndex = 7
        CollectionName = 'MenuEffects'
        Name = 'MenuEffects'
      end
      item
        CollectionIndex = 8
        CollectionName = 'MenuHeadphones'
        Name = 'MenuHeadphones'
      end
      item
        CollectionIndex = 9
        CollectionName = 'MenuHelp'
        Name = 'MenuHelp'
      end
      item
        CollectionIndex = 10
        CollectionName = 'MenuKeyboard'
        Name = 'MenuKeyboard'
      end
      item
        CollectionIndex = 11
        CollectionName = 'MenuLastFM'
        Name = 'MenuLastFM'
      end
      item
        CollectionIndex = 12
        CollectionName = 'MenuMarkAll'
        Name = 'MenuMarkAll'
      end
      item
        CollectionIndex = 13
        CollectionName = 'MenuMarkBlack'
        Name = 'MenuMarkBlack'
      end
      item
        CollectionIndex = 14
        CollectionName = 'MenuMarkBlue'
        Name = 'MenuMarkBlue'
      end
      item
        CollectionIndex = 15
        CollectionName = 'MenuMarkGreen'
        Name = 'MenuMarkGreen'
      end
      item
        CollectionIndex = 16
        CollectionName = 'MenuMarkRed'
        Name = 'MenuMarkRed'
      end
      item
        CollectionIndex = 17
        CollectionName = 'MenuNempLogo'
        Name = 'MenuNempLogo'
      end
      item
        CollectionIndex = 18
        CollectionName = 'MenuOpen'
        Name = 'MenuOpen'
      end
      item
        CollectionIndex = 19
        CollectionName = 'MenuPlay'
        Name = 'MenuPlay'
      end
      item
        CollectionIndex = 20
        CollectionName = 'MenuRefresh'
        Name = 'MenuRefresh'
      end
      item
        CollectionIndex = 21
        CollectionName = 'MenuReplayGain'
        Name = 'MenuReplayGain'
      end
      item
        CollectionIndex = 22
        CollectionName = 'MenuSave'
        Name = 'MenuSave'
      end
      item
        CollectionIndex = 23
        CollectionName = 'MenuSearch'
        Name = 'MenuSearch'
      end
      item
        CollectionIndex = 24
        CollectionName = 'MenuSettings'
        Name = 'MenuSettings'
      end
      item
        CollectionIndex = 25
        CollectionName = 'MenuShutdown'
        Name = 'MenuShutdown'
      end
      item
        CollectionIndex = 26
        CollectionName = 'MenuSkins'
        Name = 'MenuSkins'
      end
      item
        CollectionIndex = 27
        CollectionName = 'MenuSort'
        Name = 'MenuSort'
      end
      item
        CollectionIndex = 28
        CollectionName = 'MenuStarEmpty'
        Name = 'MenuStarEmpty'
      end
      item
        CollectionIndex = 29
        CollectionName = 'MenuStarFull'
        Name = 'MenuStarFull'
      end
      item
        CollectionIndex = 30
        CollectionName = 'MenuStarHalf'
        Name = 'MenuStarHalf'
      end
      item
        CollectionIndex = 31
        CollectionName = 'MenuStream'
        Name = 'MenuStream'
      end
      item
        CollectionIndex = 32
        CollectionName = 'MenuTagCloud'
        Name = 'MenuTagCloud'
      end
      item
        CollectionIndex = 33
        CollectionName = 'MenuWarning'
        Name = 'MenuWarning'
      end
      item
        CollectionIndex = 34
        CollectionName = 'Menuwinamp'
        Name = 'Menuwinamp'
      end
      item
        CollectionIndex = 35
        CollectionName = 'MenuWizard'
        Name = 'MenuWizard'
      end
      item
        CollectionIndex = 36
        CollectionName = 'MenuAddMusic'
        Name = 'MenuAddMusic'
      end
      item
        CollectionIndex = 37
        CollectionName = 'MenuCDDA'
        Name = 'MenuCDDA'
      end
      item
        CollectionIndex = 38
        CollectionName = 'MenuAddToLibrary'
        Name = 'MenuAddToLibrary'
      end
      item
        CollectionIndex = 39
        CollectionName = 'MenuUSB'
        Name = 'MenuUSB'
      end
      item
        CollectionIndex = 40
        CollectionName = 'MenuFileMissing'
        Name = 'MenuFileMissing'
      end
      item
        CollectionIndex = 41
        CollectionName = 'MenuInfoReplace'
        Name = 'MenuInfoReplace'
      end
      item
        CollectionIndex = 42
        CollectionName = 'MenuOk'
        Name = 'MenuOk'
      end
      item
        CollectionIndex = 43
        CollectionName = 'MenuPause'
        Name = 'MenuPause'
      end
      item
        CollectionIndex = 44
        CollectionName = 'MenuReplayGainDisabled'
        Name = 'MenuReplayGainDisabled'
      end
      item
        CollectionIndex = 45
        CollectionName = 'MenuStop'
        Name = 'MenuStop'
      end
      item
        CollectionIndex = 46
        CollectionName = 'MenuTimer'
        Name = 'MenuTimer'
      end
      item
        CollectionIndex = 47
        CollectionName = 'MenuWarningRed'
        Name = 'MenuWarningRed'
      end
      item
        CollectionIndex = 48
        CollectionName = 'MenuNempUpdate'
        Name = 'MenuNempUpdate'
      end
      item
        CollectionIndex = 49
        CollectionName = 'MenuEmpty'
        Name = 'MenuEmpty'
      end
      item
        CollectionIndex = 50
        CollectionName = 'MenuTreeCollapse'
        Name = 'MenuTreeCollapse'
      end
      item
        CollectionIndex = 51
        CollectionName = 'MenuTreeExpand'
        Name = 'MenuTreeExpand'
      end
      item
        CollectionIndex = 52
        CollectionName = 'ToolBtnBGDisabled'
        Name = 'ToolBtnBGDisabled'
      end
      item
        CollectionIndex = 53
        CollectionName = 'ToolBtnBGDown'
        Name = 'ToolBtnBGDown'
      end
      item
        CollectionIndex = 54
        CollectionName = 'ToolBtnBGHighlight'
        Name = 'ToolBtnBGHighlight'
      end
      item
        CollectionIndex = 55
        CollectionName = 'ToolBtnBGNormal'
        Name = 'ToolBtnBGNormal'
      end
      item
        CollectionIndex = 56
        CollectionName = 'ToolBtnBirthday'
        Name = 'ToolBtnBirthday'
      end
      item
        CollectionIndex = 57
        CollectionName = 'ToolBtnCloseNemp'
        Name = 'ToolBtnCloseNemp'
      end
      item
        CollectionIndex = 58
        CollectionName = 'ToolBtnLastFM'
        Name = 'ToolBtnLastFM'
      end
      item
        CollectionIndex = 59
        CollectionName = 'ToolBtnShutdown'
        Name = 'ToolBtnShutdown'
      end
      item
        CollectionIndex = 60
        CollectionName = 'ToolBtnWarning'
        Name = 'ToolBtnWarning'
      end
      item
        CollectionIndex = 61
        CollectionName = 'ToolBtnwinamp'
        Name = 'ToolBtnwinamp'
      end
      item
        CollectionIndex = 62
        CollectionName = 'SysBtnCloseForm'
        Name = 'SysBtnCloseForm'
      end
      item
        CollectionIndex = 63
        CollectionName = 'SysBtnCloseNemp'
        Name = 'SysBtnCloseNemp'
      end
      item
        CollectionIndex = 64
        CollectionName = 'SysBtnMinimize'
        Name = 'SysBtnMinimize'
      end
      item
        CollectionIndex = 65
        CollectionName = 'ToolBtnWebserver'
        Name = 'ToolBtnWebserver'
      end
      item
        CollectionIndex = 66
        CollectionName = 'BtnVolumeHigh'
        Name = 'BtnVolumeHigh'
      end
      item
        CollectionIndex = 67
        CollectionName = 'BtnVolumeLow'
        Name = 'BtnVolumeLow'
      end
      item
        CollectionIndex = 68
        CollectionName = 'BtnVolumeMute'
        Name = 'BtnVolumeMute'
      end
      item
        CollectionIndex = 69
        CollectionName = 'MenuPlayNext'
        Name = 'MenuPlayNext'
      end
      item
        CollectionIndex = 70
        CollectionName = 'MenuPlayPrev'
        Name = 'MenuPlayPrev'
      end
      item
        CollectionIndex = 71
        CollectionName = 'MenuCancel'
        Name = 'MenuCancel'
      end
      item
        CollectionIndex = 72
        CollectionName = 'TreeCleanChecked'
        Name = 'TreeCleanChecked'
      end
      item
        CollectionIndex = 73
        CollectionName = 'TreeCleanUnchecked'
        Name = 'TreeCleanUnchecked'
      end>
    ImageCollection = DataModuleGui.ICIcons
    Left = 329
    Top = 105
  end
end
