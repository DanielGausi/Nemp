object NewMetaFrameForm: TNewMetaFrameForm
  AlignWithMargins = True
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Nemp: Add new meta tag'
  ClientHeight = 196
  ClientWidth = 370
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    370
    196)
  TextHeight = 13
  object lbl_FrameType: TLabel
    Left = 16
    Top = 46
    Width = 106
    Height = 13
    Caption = 'Frame key/description'
  end
  object lbl_FrameValue: TLabel
    Left = 16
    Top = 95
    Width = 70
    Height = 13
    Caption = 'Frame content'
  end
  object lblNoMoreFrames: TLabel
    Left = 16
    Top = 140
    Width = 12
    Height = 13
    Caption = '...'
  end
  object cbFrameType: TComboBox
    AlignWithMargins = True
    Left = 16
    Top = 63
    Width = 334
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
  end
  object edt_FrameValue: TEdit
    AlignWithMargins = True
    Left = 16
    Top = 113
    Width = 334
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
  end
  object BtnOK: TButton
    AlignWithMargins = True
    Left = 275
    Top = 159
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
    Left = 186
    Top = 159
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = BtnCancelClick
  end
  object cbTagTypeSelection: TComboBox
    Left = 16
    Top = 16
    Width = 334
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
    OnChange = cbTagTypeSelectionChange
  end
end
