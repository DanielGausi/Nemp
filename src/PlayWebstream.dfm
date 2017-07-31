object FPlayWebstream: TFPlayWebstream
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Nemp: Play webstream'
  ClientHeight = 101
  ClientWidth = 430
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  DesignSize = (
    430
    101)
  PixelsPerInch = 96
  TextHeight = 13
  object lblURL: TLabel
    Left = 8
    Top = 8
    Width = 414
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    Caption = 
      'URL (e.g. "http://myhits.com/tune_in.pls" or "http://123.12.34.5' +
      '6:5000")'
    ExplicitWidth = 441
  end
  object BtnCancel: TButton
    Left = 325
    Top = 68
    Width = 97
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 0
  end
  object BtnOK: TButton
    Left = 222
    Top = 68
    Width = 97
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object BtnFavorites: TButton
    Left = 8
    Top = 68
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Favorites'
    ModalResult = 4
    TabOrder = 2
    ExplicitTop = 256
  end
  object edtURL: TEdit
    Left = 8
    Top = 27
    Width = 414
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
    Text = 'http://'
    ExplicitWidth = 441
  end
end
