object BirthdayForm: TBirthdayForm
  AlignWithMargins = True
  Left = 537
  Top = 348
  Margins.Right = 10
  BorderStyle = bsSingle
  Caption = 'Nemp: Congratulations!'
  ClientHeight = 350
  ClientWidth = 418
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    418
    350)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    AlignWithMargins = True
    Left = 3
    Top = 167
    Width = 412
    Height = 98
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = 
      'The playlist was interrupted automatically for this special song' +
      '. Congratulations to whatever you are celebrating! Have a good t' +
      'ime with your guests and enjoy the party!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label2: TLabel
    AlignWithMargins = True
    Left = 3
    Top = 271
    Width = 412
    Height = 26
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = '(Close this window to continue with the regular playlist)'
    WordWrap = True
    ExplicitLeft = 14
    ExplicitTop = 276
    ExplicitWidth = 396
  end
  object imgParty: TImage
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 412
    Height = 158
    Align = alTop
    Center = True
    ExplicitLeft = 8
    ExplicitTop = 8
    ExplicitWidth = 400
  end
  object VolumeImage: TImage
    Left = 8
    Top = 313
    Width = 20
    Height = 18
  end
  object BtnClose: TButton
    Left = 277
    Top = 313
    Width = 128
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Close'
    TabOrder = 0
    OnClick = BtnCloseClick
  end
  object tbVolume: TNempTrackBar
    Left = 34
    Top = 303
    Width = 103
    Height = 40
    Max = 100
    PageSize = 10
    Frequency = 20
    TabOrder = 1
    TickMarks = tmBoth
    OnChange = tbVolumeChange
  end
end
