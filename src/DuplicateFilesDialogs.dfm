object DuplicateFilesDialog: TDuplicateFilesDialog
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Warning: Duplicate files'
  ClientHeight = 232
  ClientWidth = 382
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    382
    232)
  TextHeight = 13
  object rgQuery: TRadioGroup
    AlignWithMargins = True
    Left = 3
    Top = 55
    Width = 376
    Height = 110
    Align = alTop
    Caption = 'How do you want to progress?'
    ItemIndex = 0
    Items.Strings = (
      'Skip this file'
      'Rename this file'
      'Overwrite existing file'
      'Cancel copying')
    TabOrder = 0
  end
  object cbForAll: TCheckBox
    AlignWithMargins = True
    Left = 11
    Top = 171
    Width = 345
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Apply to all files in this playlist'
    TabOrder = 1
  end
  object BtnCancel: TButton
    AlignWithMargins = True
    Left = 282
    Top = 199
    Width = 92
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object BtnOk: TButton
    AlignWithMargins = True
    Left = 179
    Top = 199
    Width = 92
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 376
    Height = 46
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 4
    DesignSize = (
      376
      46)
    object lblDuplicateFile: TLabel
      AlignWithMargins = True
      Left = 5
      Top = 8
      Width = 339
      Height = 13
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'The following file already exists:'
    end
    object lblFilename: TLabel
      AlignWithMargins = True
      Left = 5
      Top = 27
      Width = 339
      Height = 13
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = '...'
    end
  end
end
