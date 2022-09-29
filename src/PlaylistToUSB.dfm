object PlaylistCopyForm: TPlaylistCopyForm
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Nemp: Copy playlist to USB'
  ClientHeight = 388
  ClientWidth = 415
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poMainFormCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    415
    388)
  TextHeight = 13
  object BtnCopyFiles: TButton
    AlignWithMargins = True
    Left = 300
    Top = 350
    Width = 107
    Height = 25
    Hint = 'Start copying the files into the specified directory'
    Anchors = [akRight, akBottom]
    Caption = 'Copy files'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnClick = BtnCopyFilesClick
  end
  object cbCloseWindow: TCheckBox
    AlignWithMargins = True
    Left = 8
    Top = 322
    Width = 374
    Height = 17
    Hint = 'Close this window when the copy process is completed'
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Close this window after copying'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
  end
  object GrpboxSettings: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 409
    Height = 185
    Align = alTop
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
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      Text = '<index> - <filename>'
      Items.Strings = (
        '<filename>'
        '<index> - <filename>'
        '<index> - <artist> - <title>'
        '<index> - <artist> - <title> - (<album>)')
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
      Text = ''
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
    AlignWithMargins = True
    Left = 3
    Top = 194
    Width = 409
    Height = 122
    Align = alTop
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
  object BtnClose: TButton
    Left = 194
    Top = 350
    Width = 87
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Close'
    TabOrder = 4
    OnClick = BtnCloseClick
  end
end
