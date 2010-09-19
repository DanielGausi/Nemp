object PlaylistCopyForm: TPlaylistCopyForm
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Nemp: Copy playlist to USB'
  ClientHeight = 388
  ClientWidth = 419
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object BtnCopyFiles: TButton
    Left = 301
    Top = 351
    Width = 107
    Height = 25
    Hint = 'Start copying the files into the specified directory'
    Caption = 'Copy files'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnClick = BtnCopyFilesClick
  end
  object cbCloseWindow: TCheckBox
    Left = 24
    Top = 327
    Width = 241
    Height = 17
    Hint = 'Close this window when the copy process is completed'
    Caption = 'Close this window after copying'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
  end
  object GrpboxSettings: TGroupBox
    Left = 8
    Top = 8
    Width = 400
    Height = 185
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
      Hint = 'Select directory'
      Caption = '...'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = BtnSelectDirectoryClick
    end
    object cbRenameSetting: TComboBox
      Left = 16
      Top = 84
      Width = 265
      Height = 21
      Hint = 'Choose how the files should be renamed'
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 3
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      Text = '<No.> - <Artist> - <Title>'
      Items.Strings = (
        'Do not rename files'
        '<No.> - <Original filename>'
        '<Artist> - <Title>'
        '<No.> - <Artist> - <Title>')
    end
    object EditDirectory: TLabeledEdit
      Left = 16
      Top = 38
      Width = 313
      Height = 21
      EditLabel.Width = 100
      EditLabel.Height = 13
      EditLabel.Caption = 'Destination directory'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
    end
    object cbCreatePlaylistFile: TCheckBox
      Left = 16
      Top = 158
      Width = 371
      Height = 17
      Hint = 
        'Create a proper playlist-file (*.m3u) in the destination directo' +
        'ry'
      Caption = 
        'Create a proper playlist-file (*.m3u) in the destination directo' +
        'ry'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
    end
    object cbIncludeCuesheets: TCheckBox
      Left = 16
      Top = 135
      Width = 345
      Height = 17
      Hint = 'If present, copy also the matching cuesheet-file (*.cue)'
      Caption = 'Including cuesheets'
      Checked = True
      ParentShowHint = False
      ShowHint = True
      State = cbChecked
      TabOrder = 4
    end
    object cbConvertSpaces: TCheckBox
      Left = 16
      Top = 112
      Width = 345
      Height = 17
      Hint = 'Replace spaces in filenames by underscores'
      Caption = 'Convert spaces into "_"'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
    end
  end
  object GrpboxStatus: TGroupBox
    Left = 8
    Top = 199
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
end
