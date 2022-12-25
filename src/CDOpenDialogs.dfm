object CDOpenDialog: TCDOpenDialog
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Play CD-Audio'
  ClientHeight = 442
  ClientWidth = 396
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
  object GrpBoxDrives: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 390
    Height = 65
    Align = alTop
    Caption = 'CD/DVD drives'
    TabOrder = 0
    DesignSize = (
      390
      65)
    object BtnRefreshDrives: TButton
      Left = 304
      Top = 22
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Refresh'
      TabOrder = 0
      OnClick = BtnRefreshDrivesClick
    end
    object cb_Drives: TComboBox
      Left = 9
      Top = 24
      Width = 282
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      OnChange = cb_DrivesChange
    end
  end
  object GrpBoxTracklist: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 74
    Width = 390
    Height = 329
    Align = alClient
    Caption = 'Tracklist'
    TabOrder = 1
    DesignSize = (
      390
      329)
    object LblSelectionMode: TLabel
      Left = 9
      Top = 290
      Width = 180
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akRight, akBottom]
      AutoSize = False
      Caption = 'Add to playlist'
      ExplicitTop = 298
      ExplicitWidth = 206
    end
    object BtnRefreshTracks: TButton
      Left = 304
      Top = 34
      Width = 75
      Height = 25
      Hint = 'Get track information from cddb/freedb'
      Anchors = [akTop, akRight]
      Caption = 'Refresh'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = BtnRefreshTracksClick
    end
    object cbUseCDDB: TCheckBox
      Left = 16
      Top = 24
      Width = 272
      Height = 17
      Caption = 'If no CD-Text available: Check online CDDB'
      Checked = True
      State = cbChecked
      TabOrder = 1
      OnClick = cbUseCDDBClick
    end
    object lbTracks: TListBox
      Left = 16
      Top = 65
      Width = 363
      Height = 216
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 13
      MultiSelect = True
      TabOrder = 2
      OnKeyDown = lbTracksKeyDown
    end
    object cbInsertMode: TComboBox
      Left = 195
      Top = 287
      Width = 185
      Height = 21
      Style = csDropDownList
      Anchors = [akRight, akBottom]
      ItemIndex = 0
      TabOrder = 3
      Text = 'All tracks on the CD'
      Items.Strings = (
        'All tracks on the CD'
        'Only selected')
    end
    object cbPreferOnlineData: TCheckBox
      Left = 16
      Top = 42
      Width = 275
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Prefer online data over CD-Text'
      TabOrder = 4
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 406
    Width = 396
    Height = 36
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      396
      36)
    object BtnCancel: TButton
      Left = 308
      Top = 4
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 0
    end
    object BtnOk: TButton
      Left = 227
      Top = 4
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Ok'
      Default = True
      ModalResult = 1
      TabOrder = 1
      OnClick = BtnOkClick
    end
  end
end
