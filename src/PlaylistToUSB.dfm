object PlaylistCopyForm: TPlaylistCopyForm
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Nemp: Copy playlist to USB'
  ClientHeight = 347
  ClientWidth = 391
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
  TextHeight = 13
  object GrpboxSettings: TGroupBox
    Left = 0
    Top = 0
    Width = 391
    Height = 185
    Align = alTop
    Caption = 'Settings'
    TabOrder = 0
    ExplicitLeft = 3
    ExplicitTop = 3
    ExplicitWidth = 385
    DesignSize = (
      391
      185)
    object LblRenameSetting: TLabel
      Left = 16
      Top = 65
      Width = 61
      Height = 13
      Caption = 'Rename files'
    end
    object BtnSelectDirectory: TButton
      Left = 339
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
      ExplicitLeft = 333
    end
    object cbRenameSetting: TComboBox
      Left = 16
      Top = 84
      Width = 349
      Height = 21
      Hint = 'Choose how the files should be renamed'
      Anchors = [akLeft, akTop, akRight]
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      Text = '<index> - <filename>'
      Items.Strings = (
        '<filename>'
        '<index> - <filename>'
        '<index> - <artist> - <title>'
        '<index> - <artist> - <title> - (<album>)')
      ExplicitWidth = 343
    end
    object EditDirectory: TLabeledEdit
      Left = 16
      Top = 38
      Width = 317
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      EditLabel.Width = 100
      EditLabel.Height = 13
      EditLabel.Caption = 'Destination directory'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Text = ''
      ExplicitWidth = 311
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
    Left = 0
    Top = 185
    Width = 391
    Height = 122
    Align = alClient
    Caption = 'Status'
    TabOrder = 1
    ExplicitLeft = 3
    ExplicitTop = 194
    ExplicitWidth = 385
    DesignSize = (
      391
      122)
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
      Width = 351
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      ExplicitWidth = 345
    end
    object PBComplete: TProgressBar
      Left = 16
      Top = 88
      Width = 351
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      ExplicitWidth = 345
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 307
    Width = 391
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      391
      40)
    object BtnCopyFiles: TButton
      AlignWithMargins = True
      Left = 286
      Top = 8
      Width = 97
      Height = 24
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Align = alRight
      Caption = 'Copy files'
      Default = True
      TabOrder = 0
      OnClick = BtnCopyFilesClick
      ExplicitLeft = 274
      ExplicitTop = 6
      ExplicitHeight = 21
    end
    object cbCloseWindow: TCheckBox
      AlignWithMargins = True
      Left = 16
      Top = 11
      Width = 249
      Height = 17
      Hint = 'Close this window when the copy process is completed'
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Close this window after copying'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
  end
end
