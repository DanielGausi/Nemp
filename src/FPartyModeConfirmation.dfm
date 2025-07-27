object FormPartyModeConfirmation: TFormPartyModeConfirmation
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Nemp Party-Mode'
  ClientHeight = 375
  ClientWidth = 477
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object VirtualImage1: TVirtualImage
    Left = 8
    Top = 8
    Width = 64
    Height = 64
    ImageCollection = DataModuleGui.ICGraphics
    ImageWidth = 0
    ImageHeight = 0
    ImageIndex = 45
    ImageName = 'imgPartyMode'
  end
  object LabelMessage1: TLabel
    AlignWithMargins = True
    Left = 84
    Top = 8
    Width = 377
    Height = 45
    Margins.Left = 84
    Margins.Top = 8
    Margins.Right = 16
    Margins.Bottom = 8
    Align = alTop
    Caption = 
      'This will activate the Nemp Party-Mode. In this mode, some featu' +
      'res are disabled to prevent unwanted changes to the playlist and' +
      ' the media library.'
    WordWrap = True
    ExplicitWidth = 376
  end
  object LabelMessage2: TLabel
    AlignWithMargins = True
    Left = 84
    Top = 61
    Width = 377
    Height = 45
    Margins.Left = 84
    Margins.Top = 0
    Margins.Right = 16
    Margins.Bottom = 0
    Align = alTop
    Caption = 
      'However, since this is anything but '#8220'secure'#8221', you should conside' +
      'r locking the PC completely and using the Nemp Web Server for re' +
      'mote control.'
    WordWrap = True
    ExplicitWidth = 374
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 316
    Width = 477
    Height = 44
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object BtnCancel: TButton
      AlignWithMargins = True
      Left = 247
      Top = 8
      Width = 107
      Height = 28
      Margins.Left = 0
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 0
    end
    object BtnOK: TButton
      AlignWithMargins = True
      Left = 362
      Top = 8
      Width = 107
      Height = 28
      Margins.Left = 0
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Align = alRight
      Caption = 'Ok'
      Default = True
      ModalResult = 1
      TabOrder = 1
    end
  end
  object GroupBoxSettings: TGroupBox
    AlignWithMargins = True
    Left = 84
    Top = 114
    Width = 385
    Height = 194
    Margins.Left = 84
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 8
    Align = alTop
    Caption = 'Settings'
    TabOrder = 1
    ExplicitLeft = 89
    object cb_PartyMode_BlockCurrentTitleRating: TCheckBox
      AlignWithMargins = True
      Left = 18
      Top = 72
      Width = 349
      Height = 17
      Margins.Left = 16
      Margins.Top = 8
      Margins.Right = 16
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Block rating of current title'
      TabOrder = 1
      ExplicitTop = 70
    end
    object cb_PartyMode_BlockTools: TCheckBox
      AlignWithMargins = True
      Left = 18
      Top = 114
      Width = 349
      Height = 17
      Margins.Left = 16
      Margins.Top = 4
      Margins.Right = 16
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Block tools'
      TabOrder = 3
      ExplicitTop = 112
    end
    object cb_PartyMode_BlockTreeEdit: TCheckBox
      AlignWithMargins = True
      Left = 18
      Top = 93
      Width = 349
      Height = 17
      Margins.Left = 16
      Margins.Top = 4
      Margins.Right = 16
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Block editing file information in the media list'
      TabOrder = 2
      ExplicitTop = 91
    end
    object CB_PartyMode_ResizeFactor: TLabeledComboBox
      AlignWithMargins = True
      Left = 18
      Top = 155
      Width = 105
      Height = 23
      Margins.Left = 16
      Margins.Top = 24
      Margins.Right = 260
      Margins.Bottom = 0
      Align = alTop
      Style = csDropDownList
      ItemIndex = 2
      TabOrder = 4
      Text = '150%'
      Items.Strings = (
        '100%'
        '125%'
        '150%'
        '175%'
        '200%')
      EditLabel.Width = 175
      EditLabel.Height = 15
      EditLabel.Caption = 'Scaling factor (enlarged controls)'
      ExplicitTop = 153
    end
    object Edt_PartyModePassword: TLabeledEdit
      AlignWithMargins = True
      Left = 18
      Top = 41
      Width = 105
      Height = 23
      Margins.Left = 16
      Margins.Top = 24
      Margins.Right = 260
      Margins.Bottom = 0
      Align = alTop
      EditLabel.Width = 151
      EditLabel.Height = 15
      EditLabel.Caption = 'Password to exit Party-Mode'
      TabOrder = 0
      Text = ''
    end
  end
end
