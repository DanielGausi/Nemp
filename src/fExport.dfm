object FormExport: TFormExport
  Left = 0
  Top = 0
  Caption = 'Nemp: Export'
  ClientHeight = 240
  ClientWidth = 491
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenuExport
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 15
  object pnlButtons: TPanel
    Left = 0
    Top = 200
    Width = 491
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object imgHelp: TVirtualImage
      AlignWithMargins = True
      Left = 8
      Top = 4
      Width = 32
      Height = 32
      Margins.Left = 8
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alLeft
      ImageCollection = DataModuleGui.ICGraphics
      ImageWidth = 0
      ImageHeight = 0
      ImageIndex = 21
      ImageName = 'imgHelp'
      OnClick = ImgHelpClick
      ExplicitLeft = 0
      ExplicitTop = 5
      ExplicitHeight = 33
    end
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 404
      Top = 8
      Width = 79
      Height = 24
      Margins.Left = 4
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 0
    end
    object btnOK: TButton
      AlignWithMargins = True
      Left = 313
      Top = 8
      Width = 79
      Height = 24
      Margins.Left = 4
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Align = alRight
      Caption = 'Ok'
      Default = True
      TabOrder = 1
      OnClick = btnOKClick
    end
  end
  object pnlSettings: TPanel
    Left = 0
    Top = 0
    Width = 491
    Height = 140
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object grpBoxTemplateSelection: TGroupBox
      AlignWithMargins = True
      Left = 8
      Top = 8
      Width = 166
      Height = 124
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 4
      Margins.Bottom = 8
      Align = alLeft
      Caption = 'Export template'
      TabOrder = 0
      object lbTemplates: TListBox
        Left = 2
        Top = 17
        Width = 162
        Height = 105
        Align = alClient
        ItemHeight = 15
        PopupMenu = PopupMenuTemplates
        TabOrder = 0
        OnClick = lbTemplatesClick
        OnDblClick = ActionEditTemplateExecute
      end
    end
    object rgExportSelection: TRadioGroup
      AlignWithMargins = True
      Left = 182
      Top = 8
      Width = 301
      Height = 124
      Margins.Left = 4
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Align = alClient
      Caption = 'Files for export'
      ItemIndex = 0
      Items.Strings = (
        'Complete Media Library'
        'Current Category'
        'Currently displayed files'
        'The Playlist')
      TabOrder = 1
    end
  end
  object pnlFilename: TPanel
    Left = 0
    Top = 140
    Width = 491
    Height = 60
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object btnSelectExportFilename: TButton
      AlignWithMargins = True
      Left = 449
      Top = 23
      Width = 34
      Height = 23
      Margins.Left = 8
      Margins.Top = 4
      Margins.Right = 8
      Margins.Bottom = 4
      Caption = '...'
      TabOrder = 0
      OnClick = btnSelectExportFilenameClick
    end
    object edtExportFileName: TLabeledEdit
      Left = 8
      Top = 23
      Width = 430
      Height = 23
      EditLabel.Width = 92
      EditLabel.Height = 15
      EditLabel.Caption = 'Export file save as'
      TabOrder = 1
      Text = ''
      OnChange = edtExportFileNameChange
    end
  end
  object saveDlgExport: TSaveDialog
    Left = 424
    Top = 40
  end
  object ActionListExport: TActionList
    Left = 416
    object ActionEditTemplate: TAction
      Caption = 'Edit template'
      ShortCut = 16453
      OnExecute = ActionEditTemplateExecute
    end
    object ActionNewTemplate: TAction
      Caption = 'New template'
      ShortCut = 16462
      OnExecute = ActionNewTemplateExecute
    end
    object ActionDuplicateTemplate: TAction
      Caption = 'Duplicate template'
      ShortCut = 16452
      OnExecute = ActionDuplicateTemplateExecute
    end
    object ActionDeleteTemplate: TAction
      Caption = 'Delete template'
      ShortCut = 16430
      OnExecute = ActionDeleteTemplateExecute
    end
    object ActionOpenDirectory: TAction
      Caption = 'Open template directory'
      OnExecute = ActionOpenDirectoryExecute
    end
    object ActionCreateDefaultTemplates: TAction
      Caption = 'Create default templates'
      OnExecute = ActionCreateDefaultTemplatesExecute
    end
  end
  object MainMenuExport: TMainMenu
    AutoHotkeys = maManual
    Left = 320
    object mmItemFile: TMenuItem
      Caption = 'File'
      OnClick = mmItemFileClick
      object mmItemNewTemplate: TMenuItem
        Action = ActionNewTemplate
      end
      object mmItemEditTemplate: TMenuItem
        Action = ActionEditTemplate
      end
      object mmItemDuplicateTemplate: TMenuItem
        Action = ActionDuplicateTemplate
      end
      object mmItemDeleteTemplate: TMenuItem
        Action = ActionDeleteTemplate
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mmItemOpenTemplateDirectory: TMenuItem
        Action = ActionOpenDirectory
      end
      object mmItemCreateDefaultTemplates: TMenuItem
        Action = ActionCreateDefaultTemplates
      end
    end
  end
  object PopupMenuTemplates: TPopupMenu
    OnPopup = mmItemFileClick
    Left = 320
    Top = 72
    object pmItemNewTemplate: TMenuItem
      Action = ActionNewTemplate
    end
    object pmItemEditTemplate: TMenuItem
      Action = ActionEditTemplate
    end
    object pmItemDuplicateTemplate: TMenuItem
      Action = ActionDuplicateTemplate
    end
    object pmItemDeleteTemplate: TMenuItem
      Action = ActionDeleteTemplate
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object pmItemOpenTemplateDirectory: TMenuItem
      Action = ActionOpenDirectory
    end
    object pmItemCreateDefaultTemplates: TMenuItem
      Action = ActionCreateDefaultTemplates
    end
  end
end
