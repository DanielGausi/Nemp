object RandomPlaylistForm: TRandomPlaylistForm
  Left = 861
  Top = 45
  Caption = 'Nemp: Random playlist'
  ClientHeight = 532
  ClientWidth = 508
  Color = clBtnFace
  Constraints.MinHeight = 500
  Constraints.MinWidth = 520
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  TextHeight = 13
  object GrpBox_Tags: TGroupBox
    AlignWithMargins = True
    Left = 8
    Top = 194
    Width = 492
    Height = 298
    Margins.Left = 8
    Margins.Top = 4
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alClient
    Caption = 'Tags'
    TabOrder = 2
    ExplicitHeight = 297
    DesignSize = (
      492
      298)
    object LblTagViewCount: TLabel
      Left = 206
      Top = 269
      Width = 200
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      AutoSize = False
      Caption = 'Number of shown tags'
      ExplicitTop = 268
    end
    object LblTagMatchType: TLabel
      Left = 130
      Top = 46
      Width = 169
      Height = 13
      Caption = 'required to be added to the playlist'
    end
    object cbRestrictTags: TCheckBox
      Left = 16
      Top = 20
      Width = 337
      Height = 17
      Caption = 'Restrict tags'
      Checked = True
      ParentShowHint = False
      ShowHint = True
      State = cbChecked
      TabOrder = 0
      OnClick = cbRestrictTagsClick
    end
    object cbGenres: TCheckListBox
      Left = 16
      Top = 70
      Width = 461
      Height = 188
      Anchors = [akLeft, akTop, akRight, akBottom]
      Columns = 4
      Enabled = False
      ItemHeight = 17
      Sorted = True
      TabOrder = 2
      ExplicitHeight = 187
    end
    object Btn_Save: TButton
      Left = 130
      Top = 264
      Width = 70
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Save'
      TabOrder = 4
      OnClick = Btn_SaveClick
      ExplicitTop = 263
    end
    object cb_Preselection: TComboBox
      Left = 16
      Top = 266
      Width = 108
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akBottom]
      TabOrder = 3
      OnChange = cb_PreselectionChange
      ExplicitTop = 265
    end
    object cbTagCountSelection: TComboBox
      Left = 412
      Top = 266
      Width = 65
      Height = 21
      Style = csDropDownList
      Anchors = [akRight, akBottom]
      ItemIndex = 5
      TabOrder = 5
      Text = '150'
      OnChange = cbTagCountSelectionChange
      Items.Strings = (
        '10'
        '25'
        '50'
        '75'
        '100'
        '150'
        '200'
        '250'
        '300'
        '400'
        '500')
      ExplicitTop = 265
    end
    object cbTagMatchType: TComboBox
      Left = 16
      Top = 43
      Width = 108
      Height = 21
      Style = csDropDownList
      ItemIndex = 4
      TabOrder = 1
      Text = 'one tag'
      Items.Strings = (
        'all tags'
        'almost all tags'
        '~50% of the tags'
        'some tags'
        'one tag')
    end
    object BtnRefreshTags: TButton
      Left = 376
      Top = 19
      Width = 101
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Refresh'
      TabOrder = 6
      OnClick = BtnRefreshTagsClick
    end
  end
  object pnlRow1: TPanel
    Left = 0
    Top = 0
    Width = 508
    Height = 100
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object GrpBox_Date: TGroupBox
      AlignWithMargins = True
      Left = 314
      Top = 4
      Width = 186
      Height = 92
      Margins.Left = 8
      Margins.Top = 4
      Margins.Right = 8
      Margins.Bottom = 4
      Align = alRight
      Caption = 'Period'
      TabOrder = 1
      object LblConst_PeriodTo: TLabel
        Left = 96
        Top = 44
        Width = 10
        Height = 13
        Caption = 'to'
        Enabled = False
      end
      object LblConst_PeriodFrom: TLabel
        Left = 16
        Top = 44
        Width = 22
        Height = 13
        Caption = 'from'
        Enabled = False
      end
      object SE_PeriodTo: TSpinEdit
        Left = 96
        Top = 60
        Width = 57
        Height = 22
        Enabled = False
        MaxValue = 3000
        MinValue = 0
        TabOrder = 2
        Value = 2007
      end
      object cbRestrictTime: TCheckBox
        Left = 16
        Top = 20
        Width = 161
        Height = 17
        Caption = 'Restrict time'
        Checked = True
        ParentShowHint = False
        ShowHint = True
        State = cbChecked
        TabOrder = 0
        OnClick = cbRestrictTimeClick
      end
      object SE_PeriodFrom: TSpinEdit
        Left = 16
        Top = 60
        Width = 57
        Height = 22
        Enabled = False
        MaxValue = 3000
        MinValue = 0
        TabOrder = 1
        Value = 2000
      end
    end
    object GrpBox_General: TGroupBox
      AlignWithMargins = True
      Left = 8
      Top = 4
      Width = 290
      Height = 92
      Margins.Left = 8
      Margins.Top = 4
      Margins.Right = 8
      Margins.Bottom = 4
      Align = alClient
      Caption = 'General options'
      TabOrder = 0
      object LblConst_MaxCount: TLabel
        Left = 184
        Top = 24
        Width = 74
        Height = 13
        Caption = 'Maximum count'
      end
      object LblConst_TitlesFrom: TLabel
        Left = 16
        Top = 21
        Width = 68
        Height = 13
        Caption = 'Get titles from'
      end
      object seMaxCount: TSpinEdit
        Left = 184
        Top = 39
        Width = 97
        Height = 22
        Increment = 10
        MaxValue = 50000
        MinValue = 1
        TabOrder = 1
        Value = 100
      end
      object CBWholeBib: TComboBox
        Left = 16
        Top = 40
        Width = 153
        Height = 21
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 0
        Text = 'Media library'
        OnChange = CBWholeBibChange
        Items.Strings = (
          'Media library'
          'Current category'
          'Current titles in main view')
      end
    end
  end
  object pnlRow2: TPanel
    Left = 0
    Top = 100
    Width = 508
    Height = 90
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object GrpBox_Rating: TGroupBox
      AlignWithMargins = True
      Left = 314
      Top = 4
      Width = 186
      Height = 82
      Margins.Left = 8
      Margins.Top = 4
      Margins.Right = 8
      Margins.Bottom = 4
      Align = alRight
      Caption = 'Rating'
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 1
      object CBRating: TComboBox
        Left = 8
        Top = 24
        Width = 148
        Height = 21
        Style = csDropDownList
        ItemIndex = 1
        TabOrder = 0
        Text = 'equal or better than'
        Items.Strings = (
          'don'#39't care '
          'equal or better than'
          'equal to'
          'equal or worse than')
      end
      object RatingButton: TRatingButton
        Left = 8
        Top = 51
        Width = 80
        Height = 16
        DoubleBuffered = True
        DoubleBufferedMode = dbmRequested
        DrawMode = dm_Windows
        Images = vilIcons
        ParentDoubleBuffered = False
        TabOrder = 1
        TabStop = False
        TransparentBackground = True
        StyleElements = [seFont, seBorder]
        Rating = 120
        AllowChangeRating = True
        OnRatingChanged = RatingButtonRatingChanged
        StarFullImageIndex = 29
        StarHalfImageIndex = 30
        StarEmptyImageIndex = 28
        StarFullImageName = 'MenuStarFull'
        StarHalfImageName = 'MenuStarHalf'
        StarEmptyImageName = 'MenuStarEmpty'
      end
    end
    object GrpBox_Duration: TGroupBox
      AlignWithMargins = True
      Left = 8
      Top = 4
      Width = 290
      Height = 82
      Margins.Left = 8
      Margins.Top = 4
      Margins.Right = 8
      Margins.Bottom = 4
      Align = alClient
      Caption = 'Duration'
      TabOrder = 0
      object LblMinLength: TLabel
        Left = 85
        Top = 47
        Width = 25
        Height = 13
        Caption = '0m0s'
      end
      object LblMaxLength: TLabel
        Left = 231
        Top = 47
        Width = 25
        Height = 13
        Caption = '0m0s'
      end
      object CBMinLength: TCheckBox
        Left = 16
        Top = 20
        Width = 139
        Height = 17
        Caption = 'minimum length'
        TabOrder = 0
        OnClick = CBMinLengthClick
      end
      object CBMaxLength: TCheckBox
        Left = 161
        Top = 20
        Width = 120
        Height = 17
        Caption = 'maximum length'
        TabOrder = 2
        OnClick = CBMaxLengthClick
      end
      object SE_MinLength: TSpinEdit
        Left = 16
        Top = 43
        Width = 63
        Height = 22
        MaxValue = 7200
        MinValue = 0
        TabOrder = 1
        Value = 0
        OnChange = SE_MinLengthChange
      end
      object SE_MaxLength: TSpinEdit
        Left = 161
        Top = 43
        Width = 64
        Height = 22
        MaxValue = 7200
        MinValue = 0
        TabOrder = 3
        Value = 0
        OnChange = SE_MaxLengthChange
      end
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 492
    Width = 508
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    object Btn_Cancel: TButton
      AlignWithMargins = True
      Left = 425
      Top = 8
      Width = 75
      Height = 24
      Margins.Left = 4
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 2
      OnClick = Btn_CancelClick
      ExplicitHeight = 25
    end
    object Btn_Ok: TButton
      AlignWithMargins = True
      Left = 342
      Top = 8
      Width = 75
      Height = 24
      Margins.Left = 4
      Margins.Top = 8
      Margins.Right = 4
      Margins.Bottom = 8
      Align = alRight
      Caption = 'Ok'
      Default = True
      TabOrder = 1
      OnClick = Btn_OkClick
      ExplicitHeight = 25
    end
    object CBInsertMode: TComboBox
      AlignWithMargins = True
      Left = 24
      Top = 8
      Width = 217
      Height = 21
      Margins.Left = 24
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Align = alLeft
      Style = csDropDownList
      ItemIndex = 1
      TabOrder = 0
      Text = 'Play (and clear current playlist)'
      Items.Strings = (
        'Enqueue (at the end of the playlist)'
        'Play (and clear current playlist)'
        'Enqueue (at the end of the prebook-list)')
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
    Left = 457
    Top = 201
  end
end
