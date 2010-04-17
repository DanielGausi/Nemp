object RandomPlaylistForm: TRandomPlaylistForm
  Left = 861
  Top = 45
  Caption = 'Create random playlist'
  ClientHeight = 554
  ClientWidth = 504
  Color = clBtnFace
  Constraints.MinHeight = 500
  Constraints.MinWidth = 520
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  DesignSize = (
    504
    554)
  PixelsPerInch = 96
  TextHeight = 13
  object GrpBox_Date: TGroupBox
    Left = 312
    Top = 8
    Width = 185
    Height = 89
    Caption = 'Period'
    TabOrder = 1
    object LblConst_PeriodTo: TLabel
      Left = 104
      Top = 40
      Width = 10
      Height = 13
      Caption = 'to'
      Enabled = False
    end
    object LblConst_PeriodFrom: TLabel
      Left = 24
      Top = 40
      Width = 22
      Height = 13
      Caption = 'from'
      Enabled = False
    end
    object SE_PeriodTo: TSpinEdit
      Left = 104
      Top = 56
      Width = 57
      Height = 22
      Enabled = False
      MaxValue = 3000
      MinValue = 0
      TabOrder = 2
      Value = 2007
    end
    object cbIgnoreYear: TCheckBox
      Left = 8
      Top = 16
      Width = 161
      Height = 17
      Caption = 'Ignore'
      Checked = True
      ParentShowHint = False
      ShowHint = True
      State = cbChecked
      TabOrder = 0
      OnClick = cbIgnoreYearClick
    end
    object SE_PeriodFrom: TSpinEdit
      Left = 24
      Top = 56
      Width = 57
      Height = 22
      Enabled = False
      MaxValue = 3000
      MinValue = 0
      TabOrder = 1
      Value = 2000
    end
  end
  object GrpBox_Tags: TGroupBox
    Left = 8
    Top = 191
    Width = 492
    Height = 324
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Tags'
    TabOrder = 2
    DesignSize = (
      492
      324)
    object Lbl_Preselection: TLabel
      Left = 16
      Top = 159
      Width = 58
      Height = 13
      Alignment = taRightJustify
      Caption = 'Preselection'
    end
    object LblTagViewCount: TLabel
      Left = 16
      Top = 43
      Width = 108
      Height = 13
      Caption = 'Number of shown tags'
    end
    object LblTagMatchType: TLabel
      Left = 16
      Top = 97
      Width = 104
      Height = 13
      Caption = 'Audiofiles must match'
    end
    object cbIgnoreGenres: TCheckBox
      Left = 16
      Top = 20
      Width = 104
      Height = 17
      Caption = 'Ignore'
      Checked = True
      ParentShowHint = False
      ShowHint = True
      State = cbChecked
      TabOrder = 0
      OnClick = cbIgnoreGenresClick
    end
    object cbGenres: TCheckListBox
      Left = 132
      Top = 20
      Width = 348
      Height = 293
      Anchors = [akLeft, akTop, akRight, akBottom]
      Columns = 4
      Enabled = False
      ItemHeight = 13
      Sorted = True
      TabOrder = 2
    end
    object Btn_Save: TButton
      Left = 54
      Top = 205
      Width = 70
      Height = 21
      Caption = 'Save'
      TabOrder = 3
      OnClick = Btn_SaveClick
    end
    object cb_Preselection: TComboBox
      Left = 16
      Top = 178
      Width = 108
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
      OnChange = cb_PreselectionChange
    end
    object cbTagCountSelection: TComboBox
      Left = 16
      Top = 62
      Width = 108
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 5
      TabOrder = 4
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
    end
    object cbTagMatchType: TComboBox
      Left = 16
      Top = 116
      Width = 108
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 1
      TabOrder = 5
      Text = 'almost all tags'
      Items.Strings = (
        'all tags'
        'almost all tags'
        '50%'
        'some tags'
        'one tag')
    end
  end
  object GrpBox_General: TGroupBox
    Left = 8
    Top = 8
    Width = 297
    Height = 89
    Caption = 'General options'
    TabOrder = 0
    object LblConst_MaxCount: TLabel
      Left = 184
      Top = 20
      Width = 74
      Height = 13
      Caption = 'Maximum count'
    end
    object LblConst_TitlesFrom: TLabel
      Left = 16
      Top = 17
      Width = 68
      Height = 13
      Caption = 'Get titles from'
    end
    object seMaxCount: TSpinEdit
      Left = 184
      Top = 35
      Width = 97
      Height = 22
      Increment = 10
      MaxValue = 1000
      MinValue = 20
      TabOrder = 1
      Value = 100
    end
    object CBWholeBib: TComboBox
      Left = 16
      Top = 36
      Width = 144
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 0
      Text = 'whole media library'
      Items.Strings = (
        'whole media library'
        'actual listed titles')
    end
  end
  object Btn_Ok: TButton
    Left = 329
    Top = 521
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Ok'
    Default = True
    TabOrder = 3
    OnClick = Btn_OkClick
  end
  object Btn_Cancel: TButton
    Left = 413
    Top = 521
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object CBInsertMode: TComboBox
    Left = 8
    Top = 521
    Width = 217
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akBottom]
    ItemHeight = 13
    ItemIndex = 1
    TabOrder = 5
    Text = 'Play (and clear current playlist)'
    Items.Strings = (
      'Enqueue (at the end of the playlist)'
      'Play (and clear current playlist)'
      'Enqueue (at the end of the prebook-list)')
  end
  object GrpBox_Rating: TGroupBox
    Left = 312
    Top = 103
    Width = 186
    Height = 82
    Caption = 'Rating'
    TabOrder = 6
    object RatingImage: TImage
      Left = 8
      Top = 51
      Width = 70
      Height = 14
      Transparent = True
      OnMouseDown = RatingImageMouseDown
      OnMouseLeave = RatingImageMouseLeave
      OnMouseMove = RatingImageMouseMove
    end
    object CBRating: TComboBox
      Left = 8
      Top = 24
      Width = 148
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 1
      TabOrder = 0
      Text = 'equal or better than'
      Items.Strings = (
        'don'#39't care '
        'equal or better than'
        'equal to'
        'equal or worse than')
    end
  end
  object GrpBox_Duration: TGroupBox
    Left = 8
    Top = 103
    Width = 298
    Height = 82
    Caption = 'Duration'
    TabOrder = 7
    object LblMinLength: TLabel
      Left = 101
      Top = 43
      Width = 25
      Height = 13
      Caption = '0m0s'
    end
    object LblMaxLength: TLabel
      Left = 246
      Top = 43
      Width = 25
      Height = 13
      Caption = '0m0s'
    end
    object CBMinLength: TCheckBox
      Left = 16
      Top = 16
      Width = 122
      Height = 17
      Caption = 'minimum length'
      TabOrder = 0
      OnClick = CBMinLengthClick
    end
    object CBMaxLength: TCheckBox
      Left = 161
      Top = 16
      Width = 134
      Height = 17
      Caption = 'maximum length'
      TabOrder = 1
      OnClick = CBMaxLengthClick
    end
    object SE_MinLength: TSpinEdit
      Left = 32
      Top = 39
      Width = 63
      Height = 22
      MaxValue = 7200
      MinValue = 0
      TabOrder = 2
      Value = 0
      OnChange = SE_MinLengthChange
    end
    object SE_MaxLength: TSpinEdit
      Left = 176
      Top = 39
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
