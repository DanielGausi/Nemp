object CDOpenDialog: TCDOpenDialog
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Play CD-Audio'
  ClientHeight = 401
  ClientWidth = 373
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 13
  object BtnCancel: TButton
    Left = 286
    Top = 367
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 0
  end
  object BtnOk: TButton
    Left = 205
    Top = 367
    Width = 75
    Height = 25
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 1
    OnClick = BtnOkClick
  end
  object GrpBoxDrives: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 367
    Height = 65
    Align = alTop
    Caption = 'CD/DVD drives'
    TabOrder = 2
    object BtnRefresh: TButton
      Left = 263
      Top = 24
      Width = 75
      Height = 21
      Caption = 'Refresh'
      TabOrder = 0
      OnClick = BtnRefreshClick
    end
    object cb_Drives: TComboBox
      Left = 9
      Top = 24
      Width = 248
      Height = 21
      Style = csDropDownList
      TabOrder = 1
      OnChange = cb_DrivesChange
    end
  end
  object GrpBoxTracklist: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 74
    Width = 367
    Height = 282
    Align = alTop
    Caption = 'Tracklist'
    TabOrder = 3
    object LblSelectionMode: TLabel
      Left = 9
      Top = 247
      Width = 138
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Add to playlist'
    end
    object BtnCDDB: TButton
      Left = 9
      Top = 22
      Width = 75
      Height = 25
      Hint = 'Get track information from cddb/freedb'
      Caption = 'freedb'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = BtnCDDBClick
    end
    object cb_AutoCddb: TCheckBox
      Left = 90
      Top = 26
      Width = 248
      Height = 17
      Caption = 'automatically get data from cddb/freedb'
      TabOrder = 1
      Visible = False
      OnClick = cb_AutoCddbClick
    end
    object lbTracks: TListBox
      Left = 9
      Top = 59
      Width = 329
      Height = 182
      ItemHeight = 13
      MultiSelect = True
      TabOrder = 2
      OnKeyDown = lbTracksKeyDown
    end
    object cbInsertMode: TComboBox
      Left = 153
      Top = 247
      Width = 185
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 3
      Text = 'All tracks on the CD'
      Items.Strings = (
        'All tracks on the CD'
        'Only selected')
    end
  end
end
