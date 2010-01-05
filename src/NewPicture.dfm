object FNewPicture: TFNewPicture
  Left = 1209
  Top = 114
  BorderStyle = bsDialog
  Caption = 'Add a picture'
  ClientHeight = 148
  ClientWidth = 469
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 8
    Top = 8
    Width = 129
    Height = 129
    Center = True
    Proportional = True
    Stretch = True
    Visible = False
  end
  object LblConst_PictureType: TLabel
    Left = 152
    Top = 8
    Width = 59
    Height = 13
    Caption = 'Picture-type'
  end
  object LblConst_PictureDescription: TLabel
    Left = 152
    Top = 56
    Width = 153
    Height = 13
    Caption = 'Short description for the picture'
  end
  object cbPictureType: TComboBox
    Left = 152
    Top = 24
    Width = 193
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
  end
  object EdtPictureDescription: TEdit
    Left = 152
    Top = 72
    Width = 193
    Height = 21
    TabOrder = 2
  end
  object PnlWarnung: TPanel
    Left = 152
    Top = 104
    Width = 185
    Height = 33
    BevelOuter = bvNone
    TabOrder = 5
    object Image2: TImage
      Left = 8
      Top = 0
      Width = 24
      Height = 24
      Picture.Data = {
        07544269746D617076060000424D760600000000000036040000280000001800
        000018000000010008000000000040020000C30E0000C30E0000000100000001
        00000800000008080800310010004A08180031101800391821005A1821004A18
        290063292900522131006B21310039314200843142001042420018394A001042
        4A008C524A0031395200084252006B4A5200085252005A525200845252005A5A
        5A00635A5A006B5A5A00845A5A008C5A5A00635A6300845A63005A6363008463
        6300946363008C6B6B00A56B6B00086B7300426B730094737300396B7B009C7B
        7B00A57B7B00AD848400187B9400188C9C00298C9C0029949C002994A500B5A5
        A500218CAD00089CAD0021A5AD0021ADAD009CA5B5007BB5B500089CBD00219C
        BD0021B5BD00089CC60008BDC60010A5CE0018B5CE0008BDD60000B5DE0008B5
        DE0010B5DE0008DEDE0000BDE70008BDE70000C6E70008C6E70018C6E70008CE
        E70052CEE70000D6E70000DEE70018E7E70000BDEF0000C6EF0000CEEF0000D6
        EF0018D6EF0000DEEF0008DEEF0063DEEF0000E7EF0008E7EF0010E7EF004AE7
        EF0063E7EF0000EFEF004AEFEF0000C6F70000CEF7006BDEF70000E7F70094E7
        F7009CE7F70000EFF70008F7F70010F7F700FF00FF0000D6FF0000DEFF0008DE
        FF0000E7FF0008E7FF0000EFFF0008EFFF0010EFFF0000F7FF0008F7FF0010F7
        FF0018F7FF0000FFFF0008FFFF0010FFFF0018FFFF0031FFFF0052FFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF006464646464646464646464646464646464646464646464646464642F1F1A
        1D1D1D1D1D1D1D1D1D1D1D1D1D1D161B64646464483B36363636363636393636
        36363636363930081B6464483F3E42424242424D3F37404C4242424242425B26
        10646453434D655C5C5C654E0F073446655C5C5C655C5C2429646464464D6765
        656565440104093C656565656C65431364646464534467676565654F12000E47
        656565676C5C2C276464646464464E69666565665E495E666565667067451C64
        64646464645D4E6769666666662A666666666970662E2964646464646464504F
        6C666666490B4F68666670674F1964646464646464645344676966683A063D6A
        666C6C662C28646464646464646464474F6B686A310C2B6A686F694715646464
        6464646464646453496B6B61230A26616B70682D286464646464646464646464
        505E6E540F0311496F6C5418646464646464646464646464585162410102053A
        706A322264646464646464646464646464526141000204386E52176464646464
        64646464646464646457515514010D4B6D332164646464646464646464646464
        646456616E4A746E551E6464646464646464646464646464646458546E72746D
        382064646464646464646464646464646464644B627573611E64646464646464
        64646464646464646464645A5975713825646464646464646464646464646464
        64646464636E6335646464646464646464646464646464646464646453765364
        6464646464646464646464646464646464646464645364646464646464646464
        6464}
      Transparent = True
    end
    object Lbl_Warnings: TLabel
      Left = 40
      Top = 2
      Width = 137
      Height = 15
      Hint = 
        'A picture with this description already exists. Change the descr' +
        'iption or the type of the picture.'
      AutoSize = False
      Caption = 'Duplicate description'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      WordWrap = True
    end
  end
  object Btn_ChoosePicture: TButton
    Left = 360
    Top = 16
    Width = 97
    Height = 21
    Caption = 'Choose Picture'
    TabOrder = 1
    OnClick = Btn_ChoosePictureClick
  end
  object Btn_OK: TButton
    Left = 360
    Top = 96
    Width = 97
    Height = 21
    Caption = 'Ok'
    Enabled = False
    TabOrder = 3
    OnClick = Btn_OKClick
  end
  object Btn_Cancel: TButton
    Left = 360
    Top = 120
    Width = 97
    Height = 21
    Caption = 'Cancel'
    TabOrder = 4
    OnClick = Btn_CancelClick
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Filter = 'Supported files (*.jpg;*.jpeg;*.png)|*.jpg;*.jpeg;*.png;'
    Left = 400
    Top = 48
  end
end