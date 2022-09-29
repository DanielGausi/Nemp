object FormPlaylistDuplicates: TFormPlaylistDuplicates
  Left = 0
  Top = 0
  Caption = 'Nemp: Playlist duplicates'
  ClientHeight = 507
  ClientWidth = 592
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 13
  object pnlMain: TPanel
    Left = 0
    Top = 60
    Width = 592
    Height = 140
    Align = alClient
    BevelOuter = bvNone
    Constraints.MinHeight = 140
    TabOrder = 0
    object Splitter2: TSplitter
      Left = 298
      Top = 0
      Height = 140
      ResizeStyle = rsUpdate
      ExplicitLeft = 448
      ExplicitTop = 128
      ExplicitHeight = 100
    end
    object grpBoxDuplicates: TGroupBox
      AlignWithMargins = True
      Left = 304
      Top = 3
      Width = 285
      Height = 134
      Align = alClient
      Caption = 'Identified duplicates'
      Constraints.MinHeight = 80
      Constraints.MinWidth = 100
      TabOrder = 0
      object VstDuplicates: TVirtualStringTree
        Left = 2
        Top = 15
        Width = 281
        Height = 82
        Align = alTop
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
        Touch.InteractiveGestures = [igPan, igPressAndTap]
        Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
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
            Width = 211
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
        Top = 103
        Width = 118
        Height = 25
        Caption = 'Delete original'
        TabOrder = 1
        OnClick = btnDeleteOriginalClick
      end
      object btnDeleteDuplicate: TButton
        AlignWithMargins = True
        Left = 140
        Top = 103
        Width = 118
        Height = 25
        Caption = 'Delete duplicate'
        TabOrder = 2
        OnClick = btnDeleteDuplicateClick
      end
    end
    object grpBoxCompare: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 292
      Height = 134
      Align = alLeft
      Caption = 'Summary'
      Constraints.MinWidth = 100
      TabOrder = 1
      DesignSize = (
        292
        134)
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
        Width = 225
        Height = 13
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = '..............'
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
        Width = 225
        Height = 13
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = '..............'
      end
      object imgDuplicateInfo: TImage
        AlignWithMargins = True
        Left = 16
        Top = 35
        Width = 32
        Height = 32
      end
      object imgDuplicateReason: TImage
        AlignWithMargins = True
        Left = 16
        Top = 91
        Width = 32
        Height = 32
      end
      object lblDuplicateReason1: TLabel
        Left = 57
        Top = 91
        Width = 225
        Height = 13
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = '..............'
      end
      object lblDuplicateReason2: TLabel
        Left = 57
        Top = 106
        Width = 225
        Height = 13
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = '..............'
      end
    end
  end
  object PnlDetails: TPanel
    Left = 0
    Top = 200
    Width = 592
    Height = 266
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 295
      Top = 0
      Height = 266
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
      Height = 260
      Align = alLeft
      Caption = 'Currently selected file in the playlist'
      Constraints.MinWidth = 100
      TabOrder = 0
      DesignSize = (
        289
        260)
      object Bevel2: TBevel
        Left = 13
        Top = 103
        Width = 262
        Height = 5
        Anchors = [akLeft, akTop, akRight]
        Shape = bsBottomLine
        ExplicitWidth = 297
      end
      object ImgRatingPlaylist: TImage
        Left = 16
        Top = 204
        Width = 70
        Height = 14
        Hint = 'Click to change rating'
        Transparent = True
        Visible = False
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
        Left = 92
        Top = 204
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
    end
    object grpBoxDetailsDuplicate: TGroupBox
      AlignWithMargins = True
      Left = 301
      Top = 3
      Width = 288
      Height = 260
      Align = alClient
      Caption = 'Currently selected possible duplicate'
      Constraints.MinWidth = 100
      TabOrder = 1
      DesignSize = (
        288
        260)
      object ImgRatingDuplicate: TImage
        Left = 16
        Top = 204
        Width = 70
        Height = 14
        Hint = 'Click to change rating'
        Transparent = True
        Visible = False
      end
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
        Left = 92
        Top = 204
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
        Width = 255
        Height = 5
        Anchors = [akLeft, akTop, akRight]
        Shape = bsBottomLine
        ExplicitWidth = 293
      end
      object imgDuplicateTitle: TImage
        Left = 289
        Top = 28
        Width = 16
        Height = 16
        ParentShowHint = False
        ShowHint = True
      end
      object imgDuplicatePath: TImage
        Left = 289
        Top = 50
        Width = 16
        Height = 16
        ParentShowHint = False
        ShowHint = True
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
    end
  end
  object PnlFooter: TPanel
    Left = 0
    Top = 466
    Width = 592
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      592
      41)
    object BtnOK: TButton
      AlignWithMargins = True
      Left = 509
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
    Width = 592
    Height = 60
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object grpBoxPlaylist: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 586
      Height = 54
      Align = alClient
      Caption = 'Selection in Nemp playlist'
      TabOrder = 0
      DesignSize = (
        586
        54)
      object imgPlaylist: TImage
        AlignWithMargins = True
        Left = 16
        Top = 15
        Width = 64
        Height = 32
        Proportional = True
        Stretch = True
      end
      object LblPlaylistTitle: TLabel
        Left = 123
        Top = 20
        Width = 402
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
      end
      object LblPlaylistTime: TLabel
        Left = 528
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
      end
      object lblPlaylistIndex: TLabel
        Left = 86
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
end
