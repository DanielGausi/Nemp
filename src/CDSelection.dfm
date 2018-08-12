object FormCDDBSelect: TFormCDDBSelect
  Left = 0
  Top = 0
  Caption = 'Select CD'
  ClientHeight = 142
  ClientWidth = 425
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object BtnOK: TButton
    Left = 248
    Top = 111
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = BtnOKClick
  end
  object BtnCancel: TButton
    Left = 342
    Top = 111
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
    OnClick = BtnCancelClick
  end
  object lvSelectCD: TListBox
    Left = 8
    Top = 8
    Width = 409
    Height = 97
    ItemHeight = 13
    TabOrder = 2
    OnDblClick = lvSelectCDDblClick
  end
end
