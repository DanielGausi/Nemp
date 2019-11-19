object NewMetaFrameForm: TNewMetaFrameForm
  AlignWithMargins = True
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Nemp: Add new meta tag'
  ClientHeight = 145
  ClientWidth = 381
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
    381
    145)
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
    AlignWithMargins = True
    Left = 16
    Top = 27
    Width = 345
    Height = 21
    Style = csDropDownList
    TabOrder = 0
  end
  object edt_FrameValue: TEdit
    AlignWithMargins = True
    Left = 16
    Top = 74
    Width = 345
    Height = 21
    TabOrder = 1
  end
  object BtnOK: TButton
    AlignWithMargins = True
    Left = 286
    Top = 108
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Ok'
    Default = True
    TabOrder = 2
    OnClick = BtnOKClick
  end
  object BtnCancel: TButton
    AlignWithMargins = True
    Left = 197
    Top = 108
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = BtnCancelClick
  end
end
