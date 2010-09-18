object PlaylistCopyForm: TPlaylistCopyForm
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Nemp: Copy playlist to USB'
  ClientHeight = 622
  ClientWidth = 424
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object BtnCopyFiles: TButton
    Left = 301
    Top = 311
    Width = 107
    Height = 25
    Caption = 'Copy files'
    TabOrder = 0
    OnClick = BtnCopyFilesClick
  end
  object cbCloseWindow: TCheckBox
    Left = 24
    Top = 315
    Width = 241
    Height = 17
    Caption = 'Close this window after copying'
    TabOrder = 1
  end
  object GrpboxSettings: TGroupBox
    Left = 8
    Top = 8
    Width = 400
    Height = 169
    Caption = 'Settings'
    TabOrder = 2
    object LblRenameSetting: TLabel
      Left = 16
      Top = 65
      Width = 61
      Height = 13
      Caption = 'Rename files'
    end
    object BtnSelectDirectory: TButton
      Left = 335
      Top = 36
      Width = 26
      Height = 25
      Caption = '...'
      TabOrder = 0
      OnClick = BtnSelectDirectoryClick
    end
    object cbRenameSetting: TComboBox
      Left = 16
      Top = 84
      Width = 265
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 2
      TabOrder = 1
      Text = 'Rename to <No.> - <Artist> - <Album>'
      Items.Strings = (
        'Do not rename files'
        'Rename to <Artist> - <Album>'
        'Rename to <No.> - <Artist> - <Album>')
    end
    object EditDirectory: TLabeledEdit
      Left = 16
      Top = 38
      Width = 313
      Height = 21
      EditLabel.Width = 74
      EditLabel.Height = 13
      EditLabel.Caption = 'Copy playlist to'
      TabOrder = 2
    end
    object cbCreatePlaylistFile: TCheckBox
      Left = 16
      Top = 134
      Width = 371
      Height = 17
      Caption = 
        'Create a proper playlist-file (*.m3u) in the destination directo' +
        'ry'
      TabOrder = 3
    end
    object cbIncludeCuesheets: TCheckBox
      Left = 16
      Top = 111
      Width = 345
      Height = 17
      Caption = 'Including cuesheets'
      Checked = True
      State = cbChecked
      TabOrder = 4
    end
  end
  object GrpboxStatus: TGroupBox
    Left = 8
    Top = 183
    Width = 400
    Height = 122
    Caption = 'Status'
    TabOrder = 3
    object LblProgressFile: TLabel
      Left = 18
      Top = 20
      Width = 18
      Height = 13
      Caption = 'Idle'
    end
    object LblCompleteProgress: TLabel
      Left = 18
      Top = 69
      Width = 79
      Height = 13
      Caption = 'Overall progress'
    end
    object PBCurrentFile: TProgressBar
      Left = 18
      Top = 39
      Width = 369
      Height = 17
      TabOrder = 0
    end
    object PBComplete: TProgressBar
      Left = 18
      Top = 88
      Width = 369
      Height = 17
      TabOrder = 1
    end
  end
  object Memo1: TMemo
    Left = 8
    Top = 352
    Width = 400
    Height = 262
    Lines.Strings = (
      'Memo1')
    TabOrder = 4
  end
end
