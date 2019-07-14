object NewStationForm: TNewStationForm
  Left = 1177
  Top = 178
  BorderStyle = bsSingle
  Caption = 'New station'
  ClientHeight = 222
  ClientWidth = 416
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    416
    222)
  PixelsPerInch = 96
  TextHeight = 13
  object GrpBox_NewStation: TGroupBox
    Left = 8
    Top = 8
    Width = 401
    Height = 176
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'New station data'
    TabOrder = 0
    object LblConst_Name: TLabel
      Left = 8
      Top = 24
      Width = 145
      Height = 13
      Caption = 'Name (e.g. "The Hit Channel")'
    end
    object LblConst_URL: TLabel
      Left = 8
      Top = 72
      Width = 354
      Height = 13
      Caption = 
        'URL (e.g. "http://myhits.com/tune_in.pls" or "http://123.12.34.5' +
        '6:5000")'
    end
    object LblConst_Format: TLabel
      Left = 8
      Top = 120
      Width = 34
      Height = 13
      Caption = 'Format'
    end
    object LblConst_Bitrate: TLabel
      Left = 96
      Top = 120
      Width = 32
      Height = 13
      Caption = 'Bitrate'
    end
    object LblConst_Genre: TLabel
      Left = 192
      Top = 120
      Width = 29
      Height = 13
      Caption = 'Genre'
    end
    object Edt_Name: TEdit
      Left = 8
      Top = 40
      Width = 377
      Height = 21
      TabOrder = 0
      OnChange = EdtChange
    end
    object Edt_URL: TEdit
      Left = 8
      Top = 88
      Width = 377
      Height = 21
      TabOrder = 1
      OnChange = EdtChange
    end
    object CB_Mediatype: TComboBox
      Left = 8
      Top = 136
      Width = 73
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 2
      Text = 'mp3'
      Items.Strings = (
        'mp3'
        'aac'
        'ogg'
        'wma'
        'other')
    end
    object CB_Bitrate: TComboBox
      Left = 96
      Top = 136
      Width = 81
      Height = 21
      Style = csDropDownList
      DropDownCount = 10
      ItemIndex = 11
      TabOrder = 3
      Text = '128'
      Items.Strings = (
        '10'
        '12'
        '16'
        '20'
        '24'
        '32'
        '48'
        '56'
        '64'
        '96'
        '112'
        '128'
        '160'
        '192'
        '256'
        '320')
    end
    object Edt_Genre: TEdit
      Left = 192
      Top = 136
      Width = 193
      Height = 21
      TabOrder = 4
    end
  end
  object Btn_OK: TButton
    Left = 328
    Top = 191
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Btn_Cancel: TButton
    Left = 248
    Top = 191
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
