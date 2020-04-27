object WebServerQRForm: TWebServerQRForm
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Nemp Webserver: QR-Codes'
  ClientHeight = 615
  ClientWidth = 551
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    551
    615)
  PixelsPerInch = 96
  TextHeight = 13
  object imgQRCode: TImage
    Left = 0
    Top = 64
    Width = 551
    Height = 551
    Align = alBottom
    Stretch = True
    ExplicitTop = 70
  end
  object lblIPs: TLabel
    AlignWithMargins = True
    Left = 8
    Top = 5
    Width = 61
    Height = 13
    Caption = 'Available IPs'
  end
  object lblPort: TLabel
    Left = 168
    Top = 5
    Width = 20
    Height = 13
    Caption = 'Port'
  end
  object cbURLs: TComboBox
    AlignWithMargins = True
    Left = 8
    Top = 24
    Width = 145
    Height = 21
    Style = csDropDownList
    TabOrder = 0
    StyleElements = []
    OnChange = DataChange
  end
  object cbAdmin: TCheckBox
    AlignWithMargins = True
    Left = 240
    Top = 25
    Width = 289
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Admin'
    TabOrder = 1
    OnClick = DataChange
  end
  object sePort: TSpinEdit
    Left = 168
    Top = 23
    Width = 57
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 2
    Value = 80
    OnChange = DataChange
  end
end
