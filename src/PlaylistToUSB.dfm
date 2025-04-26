object PlaylistCopyForm: TPlaylistCopyForm
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Nemp: Copy playlist to USB'
  ClientHeight = 357
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
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 385
    Height = 185
    Align = alTop
    Caption = 'Settings'
    TabOrder = 0
    DesignSize = (
      385
      185)
    object LblRenameSetting: TLabel
      Left = 16
      Top = 65
      Width = 61
      Height = 13
      Caption = 'Rename files'
    end
    object BtnSelectDirectory: TButton
      Left = 333
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
      Width = 343
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
    end
    object EditDirectory: TLabeledEdit
      Left = 16
      Top = 38
      Width = 311
      Height = 21
      Anchors = [akLeft, akTop, akRight]
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
    Width = 385
    Height = 122
    Align = alTop
    Caption = 'Status'
    TabOrder = 1
    DesignSize = (
      385
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
      Width = 345
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
    end
    object PBComplete: TProgressBar
      Left = 16
      Top = 88
      Width = 345
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 322
    Width = 391
    Height = 35
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitTop = 333
    DesignSize = (
      391
      35)
    object BtnCopyFiles: TButton
      Left = 274
      Top = 6
      Width = 97
      Height = 21
      Anchors = [akTop, akRight]
      Caption = 'Copy files'
      Default = True
      TabOrder = 0
      OnClick = BtnCopyFilesClick
    end
    object cbCloseWindow: TCheckBox
      AlignWithMargins = True
      Left = 19
      Top = 8
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
