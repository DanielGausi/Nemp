object NewMetaFrameForm: TNewMetaFrameForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Nemp: Add new meta tag'
  ClientHeight = 142
  ClientWidth = 367
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
  PixelsPerInch = 96
  TextHeight = 13
  object lbl_FrameType: TLabel
    Left = 16
    Top = 8
    Width = 106
    Height = 13
    Caption = 'Frame key/description'
  end
  object lbl_FrameValue: TLabel
    Left = 16
    Top = 55
    Width = 70
    Height = 13
    Caption = 'Frame content'
  end
  object cbFrameType: TComboBox
    Left = 16
    Top = 27
    Width = 337
    Height = 21
    Style = csDropDownList
    TabOrder = 0
  end
  object edt_FrameValue: TEdit
    Left = 16
    Top = 74
    Width = 337
    Height = 21
    TabOrder = 1
  end
  object BtnOK: TButton
    Left = 278
    Top = 104
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    TabOrder = 2
    OnClick = BtnOKClick
  end
  object BtnCancel: TButton
    Left = 189
    Top = 104
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = BtnCancelClick
  end
end
