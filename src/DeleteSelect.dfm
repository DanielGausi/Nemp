object DeleteSelection: TDeleteSelection
  Left = 0
  Top = 0
  Caption = 'Nemp: Cleanup media library'
  ClientHeight = 471
  ClientWidth = 684
  Color = clBtnFace
  Constraints.MinHeight = 400
  Constraints.MinWidth = 700
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 13
  object Splitter2: TSplitter
    Left = 0
    Top = 190
    Width = 684
    Height = 3
    Cursor = crVSplit
    Align = alTop
    ExplicitTop = 193
    ExplicitWidth = 330
  end
  object grpBoxDrives: TGroupBox
    AlignWithMargins = True
    Left = 8
    Top = 76
    Width = 668
    Height = 110
    Margins.Left = 8
    Margins.Top = 4
    Margins.Right = 8
    Margins.Bottom = 4
    Align = alTop
    Caption = 'Affected drives'
    TabOrder = 0
    DesignSize = (
      668
      110)
    object DriveImage: TVirtualImage
      Left = 589
      Top = 24
      Width = 64
      Height = 64
      Margins.Right = 8
      Anchors = [akTop, akRight]
      ImageCollection = DataModuleGui.ICGraphics
      ImageWidth = 0
      ImageHeight = 0
      ImageIndex = 24
      ImageName = 'imgHDDMount'
      ExplicitLeft = 583
    end
    object LblExplaination: TLabel
      Left = 215
      Top = 24
      Width = 9
      Height = 13
      Caption = '...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LblWhatToDo: TLabel
      Left = 215
      Top = 59
      Width = 360
      Height = 27
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = '...'
      WordWrap = True
      ExplicitWidth = 354
    end
    object LblExplaination2: TLabel
      Left = 215
      Top = 40
      Width = 9
      Height = 13
      Caption = '...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object VSTDrives: TVirtualStringTree
      Left = 8
      Top = 24
      Width = 193
      Height = 76
      Anchors = [akLeft, akTop, akBottom]
      Colors.UnfocusedSelectionColor = clHighlight
      Colors.UnfocusedSelectionBorderColor = clHighlight
      DefaultNodeHeight = 24
      Header.AutoSizeIndex = 0
      Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowImages, hoShowSortGlyphs]
      Indent = 0
      TabOrder = 0
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning, toEditOnClick]
      TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toThemeAware, toUseBlendedImages]
      OnChange = VSTDrivesChange
      OnChecked = VSTDrivesChecked
      OnGetText = VSTDrivesGetText
      Touch.InteractiveGestures = [igPan, igPressAndTap]
      Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
      Columns = <
        item
          Position = 0
          Text = 'Files'
          Width = 189
        end>
    end
  end
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 684
    Height = 72
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object HintImage: TVirtualImage
      AlignWithMargins = True
      Left = 16
      Top = 4
      Width = 64
      Height = 64
      Margins.Left = 16
      Margins.Top = 4
      Margins.Right = 8
      Margins.Bottom = 4
      Align = alLeft
      ImageCollection = DataModuleGui.ICGraphics
      ImageWidth = 0
      ImageHeight = 0
      ImageIndex = 15
      ImageName = 'imgAlert'
      ParentShowHint = False
      ShowHint = True
      ExplicitLeft = 17
      ExplicitTop = 8
    end
    object lblMainExplanation: TLabel
      AlignWithMargins = True
      Left = 96
      Top = 4
      Width = 572
      Height = 64
      Margins.Left = 8
      Margins.Top = 4
      Margins.Right = 16
      Margins.Bottom = 4
      Align = alClient
      AutoSize = False
      Caption = '...'
      WordWrap = True
      ExplicitLeft = 104
      ExplicitTop = 8
      ExplicitWidth = 534
      ExplicitHeight = 65
    end
  end
  object pnlFiles: TPanel
    Left = 0
    Top = 193
    Width = 684
    Height = 230
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object LblFiles: TLabel
      AlignWithMargins = True
      Left = 8
      Top = 8
      Width = 668
      Height = 13
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Align = alTop
      Caption = 
        'Missing files on the selected drive (will be removed from the li' +
        'brary, if the drive is checked)'
      ExplicitWidth = 433
    end
    object Panel1: TPanel
      AlignWithMargins = True
      Left = 8
      Top = 29
      Width = 668
      Height = 197
      Margins.Left = 8
      Margins.Top = 0
      Margins.Right = 8
      Margins.Bottom = 4
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object Splitter1: TSplitter
        Left = 429
        Top = 0
        Height = 197
        Align = alRight
        ExplicitLeft = 383
        ExplicitHeight = 179
      end
      object VSTPlaylistFiles: TVirtualStringTree
        Left = 432
        Top = 0
        Width = 236
        Height = 197
        Align = alRight
        Colors.UnfocusedSelectionColor = clHighlight
        Colors.UnfocusedSelectionBorderColor = clHighlight
        Header.AutoSizeIndex = 0
        Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
        Indent = 0
        TabOrder = 0
        TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
        OnGetText = VSTPlaylistFilesGetText
        Touch.InteractiveGestures = [igPan, igPressAndTap]
        Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
        Columns = <
          item
            Position = 0
            Text = 'Playlists on the selected drive'
            Width = 232
          end>
      end
      object VSTFiles: TVirtualStringTree
        Left = 0
        Top = 0
        Width = 429
        Height = 197
        Align = alClient
        Colors.UnfocusedSelectionColor = clHighlight
        Colors.UnfocusedSelectionBorderColor = clHighlight
        Header.AutoSizeIndex = 0
        Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
        Indent = 0
        TabOrder = 1
        TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
        OnGetText = VSTFilesGetText
        Touch.InteractiveGestures = [igPan, igPressAndTap]
        Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
        Columns = <
          item
            Position = 0
            Text = 'Audio files on the selected drive'
            Width = 425
          end>
      end
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 423
    Width = 684
    Height = 48
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    ExplicitTop = 425
    object ImgHelp: TVirtualImage
      AlignWithMargins = True
      Left = 8
      Top = 8
      Width = 32
      Height = 32
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 4
      Margins.Bottom = 8
      Align = alLeft
      ImageCollection = DataModuleGui.ICGraphics
      ImageWidth = 0
      ImageHeight = 0
      ImageIndex = 21
      ImageName = 'imgHelp'
      OnClick = BtnHelpClick
      ExplicitTop = 14
    end
    object Btncancel: TButton
      AlignWithMargins = True
      Left = 368
      Top = 8
      Width = 106
      Height = 32
      Hint = 'Cancel - do not remove any files from the library'
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
    object BtnHelp: TButton
      AlignWithMargins = True
      Left = 48
      Top = 12
      Width = 89
      Height = 24
      Margins.Left = 4
      Margins.Top = 12
      Margins.Right = 8
      Margins.Bottom = 12
      Align = alLeft
      Caption = 'Help'
      ImageIndex = 9
      ImageName = 'MenuHelp'
      TabOrder = 1
      Visible = False
      OnClick = BtnHelpClick
    end
    object BtnOk: TButton
      AlignWithMargins = True
      Left = 490
      Top = 8
      Width = 186
      Height = 32
      Hint = 'Remove missing files from checked drives'
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Align = alRight
      Caption = 'Cleanup library'
      Default = True
      ModalResult = 1
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
    end
  end
  object checkImages: TVirtualImageList
    Images = <>
    ImageCollection = DataModuleGui.ICIcons
    Width = 24
    Height = 24
    Left = 280
    Top = 80
  end
end
