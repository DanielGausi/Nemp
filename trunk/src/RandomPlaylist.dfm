object RandomPlaylistForm: TRandomPlaylistForm
  Left = 861
  Top = 45
  BorderStyle = bsSingle
  Caption = 'Create random playlist'
  ClientHeight = 497
  ClientWidth = 506
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    506
    497)
  PixelsPerInch = 96
  TextHeight = 13
  object GrpBox_Date: TGroupBox
    Left = 312
    Top = 8
    Width = 185
    Height = 121
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
  object GrpBox_Genre: TGroupBox
    Left = 8
    Top = 136
    Width = 489
    Height = 321
    Caption = 'Genres'
    TabOrder = 2
    DesignSize = (
      489
      321)
    object LblConst_Preselection: TLabel
      Left = 200
      Top = 22
      Width = 58
      Height = 13
      Alignment = taRightJustify
      Caption = 'Preselection'
    end
    object cbIgnoreGenres: TCheckBox
      Left = 8
      Top = 22
      Width = 97
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
      Left = 8
      Top = 48
      Width = 473
      Height = 265
      Anchors = [akLeft, akTop, akRight]
      Columns = 4
      Enabled = False
      ItemHeight = 13
      Sorted = True
      TabOrder = 2
    end
    object Btn_Save: TButton
      Left = 416
      Top = 16
      Width = 65
      Height = 21
      Caption = 'Save'
      TabOrder = 3
      OnClick = Btn_SaveClick
    end
    object cb_Preselection: TComboBox
      Left = 264
      Top = 16
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
      OnChange = cb_PreselectionChange
    end
  end
  object GrpBox_General: TGroupBox
    Left = 8
    Top = 8
    Width = 297
    Height = 121
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
      Left = 8
      Top = 20
      Width = 68
      Height = 13
      Caption = 'Get titles from'
    end
    object LblConst_Rating: TLabel
      Left = 8
      Top = 64
      Width = 31
      Height = 13
      Caption = 'Rating'
    end
    object RatingImage: TImage
      Left = 184
      Top = 83
      Width = 70
      Height = 14
      Transparent = True
      OnMouseDown = RatingImageMouseDown
      OnMouseLeave = RatingImageMouseLeave
      OnMouseMove = RatingImageMouseMove
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
      Left = 8
      Top = 36
      Width = 161
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
    object CBRating: TComboBox
      Left = 8
      Top = 80
      Width = 161
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 1
      TabOrder = 2
      Text = 'equal or better than'
      Items.Strings = (
        'don'#39't care '
        'equal or better than'
        'equal to'
        'equal or worse than')
    end
  end
  object Btn_Ok: TButton
    Left = 331
    Top = 464
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Ok'
    Default = True
    TabOrder = 3
    OnClick = Btn_OkClick
  end
  object Btn_Cancel: TButton
    Left = 415
    Top = 464
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object CBInsertMode: TComboBox
    Left = 104
    Top = 466
    Width = 217
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 1
    TabOrder = 5
    Text = 'Play (and delete playlist)'
    Items.Strings = (
      'Add to the playlist'
      'Play (and delete playlist)'
      'Insert after current position'
      'Insert after current position and play')
  end
end
