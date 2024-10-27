object PlaylistCopyForm: TPlaylistCopyForm
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Nemp: Copy playlist to USB'
  ClientHeight = 374
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
    374)
  TextHeight = 13
  object GrpboxSettings: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 409
    Height = 185
    Align = alTop
    Caption = 'Settings'
    TabOrder = 0
    ExplicitWidth = 405
    DesignSize = (
      409
      185)
    object LblRenameSetting: TLabel
      Left = 16
      Top = 65
      Width = 61
      Height = 13
      Caption = 'Rename files'
    end
    object BtnSelectDirectory: TButton
      Left = 361
      Top = 38
      Width = 26
      Height = 21
      Hint = 'Select directory'
      Anchors = [akTop, akRight]
      Caption = '...'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = BtnSelectDirectoryClick
    end
    object cbRenameSetting: TComboBox
      Left = 16
      Top = 84
      Width = 339
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
      Width = 339
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
    TabOrder = 1
    ExplicitWidth = 405
    object LblProgressFile: TLabel
      Left = 16
      Top = 20
      Width = 18
      Height = 13
      Caption = 'Idle'
    end
    object LblCompleteProgress: TLabel
      Left = 16
      Top = 69
      Width = 79
      Height = 13
      Caption = 'Overall progress'
    end
    object PBCurrentFile: TProgressBar
      Left = 16
      Top = 39
      Width = 369
      Height = 17
      TabOrder = 0
    end
    object PBComplete: TProgressBar
      Left = 16
      Top = 88
      Width = 369
      Height = 17
      TabOrder = 1
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 339
    Width = 415
    Height = 35
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitTop = 136
    ExplicitWidth = 375
    DesignSize = (
      415
      35)
    object BtnCopyFiles: TButton
      Left = 302
      Top = 6
      Width = 97
      Height = 21
      Anchors = [akTop, akRight]
      Caption = 'Copy files'
      Default = True
      TabOrder = 0
      OnClick = BtnCopyFilesClick
    end
  end
  object cbCloseWindow: TCheckBox
    AlignWithMargins = True
    Left = 19
    Top = 322
    Width = 370
    Height = 17
    Hint = 'Close this window when the copy process is completed'
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Close this window after copying'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
  end
end
