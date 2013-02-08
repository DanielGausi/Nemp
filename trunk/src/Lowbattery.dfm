object FormLowBattery: TFormLowBattery
  Left = 0
  Top = 0
  Caption = 'Nemp Walkman mode: Low battery'
  ClientHeight = 230
  ClientWidth = 503
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 8
    Top = 8
    Width = 128
    Height = 117
  end
  object Lbl_Warning: TLabel
    Left = 152
    Top = 16
    Width = 98
    Height = 23
    Caption = 'Low battery'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object LblWhatNow: TLabel
    Left = 152
    Top = 131
    Width = 145
    Height = 13
    Caption = 'What do you want to do now?'
  end
  object st_Metadata: TStaticText
    Left = 152
    Top = 45
    Width = 337
    Height = 80
    AutoSize = False
    Caption = 
      'Nemp has detected a low battery status. As the "Walkman mode" is' +
      ' active, Nemp will flutter the playback (like these old portable' +
      ' cassette players). The fluttering will become worse on even low' +
      'er battery status. Fluttering will end, if you start charging th' +
      'e battery.'
    TabOrder = 0
  end
  object BtnOk: TButton
    Left = 414
    Top = 193
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object cb_ToDo: TComboBox
    Left = 152
    Top = 150
    Width = 337
    Height = 21
    Style = csDropDownList
    TabOrder = 2
    Items.Strings = (
      'Nothing, but thank you for the information.'
      
        'Stop fluttering now, I will go get a power cable as fast as I ca' +
        'n.'
      'Stop the "Walkman mode" completely.')
  end
  object BtnCancel: TButton
    Left = 333
    Top = 193
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
