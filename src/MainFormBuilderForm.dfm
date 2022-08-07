object MainFormBuilder: TMainFormBuilder
  Left = 0
  Top = 0
  Caption = 'Nemp: Form designer'
  ClientHeight = 608
  ClientWidth = 961
  Color = clBtnFace
  Constraints.MinHeight = 540
  Constraints.MinWidth = 800
  DragMode = dmAutomatic
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu
  Visible = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDragDrop = pnlDefaultContainerDragDrop
  OnShow = FormShow
  TextHeight = 13
  object pnlButtons: TPanel
    Left = 0
    Top = 567
    Width = 961
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      961
      41)
    object BtnApply: TButton
      Left = 856
      Top = 8
      Width = 96
      Height = 25
      Hint = 'Assign the current layout to the Nemp window'
      Anchors = [akTop, akRight]
      Caption = 'Apply'
      TabOrder = 0
      OnClick = BtnApplyClick
    end
    object BtnOK: TButton
      Left = 652
      Top = 8
      Width = 96
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'OK'
      TabOrder = 1
      OnClick = BtnOKClick
    end
    object BtnCancel: TButton
      Left = 754
      Top = 8
      Width = 96
      Height = 25
      Hint = 'Revert to current layout in the Nemp window'
      Anchors = [akTop, akRight]
      Caption = 'Cancel'
      TabOrder = 2
      OnClick = BtnCancelClick
    end
    object BtnHelp: TButton
      Left = 8
      Top = 8
      Width = 105
      Height = 25
      Caption = 'Help'
      TabOrder = 3
      OnClick = BtnHelpClick
    end
  end
  object pnlConstruction: TPanel
    Left = 0
    Top = 0
    Width = 961
    Height = 567
    Align = alClient
    TabOrder = 1
    object pnlNempWindowEdit: TPanel
      Left = 1
      Top = 1
      Width = 710
      Height = 565
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object grpBoxNempElements: TGroupBox
        Left = 0
        Top = 492
        Width = 710
        Height = 73
        Align = alBottom
        Caption = 'Nemp GUI elements'
        TabOrder = 0
        OnDragDrop = pnlDefaultContainerDragDrop
        OnDragOver = pnlDefaultContainerDragOver
        object pnlCloud: TNempPanel
          Tag = 208
          Left = 206
          Top = 16
          Width = 97
          Height = 50
          Caption = 'Tag cloud'
          Constraints.MinHeight = 10
          Constraints.MinWidth = 10
          DragMode = dmAutomatic
          ParentBackground = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 0
          TabStop = True
          Ratio = 0
          OwnerDraw = False
          DesignSize = (
            97
            50)
          object btnRemoveCloud: TButton
            Left = 68
            Top = 2
            Width = 25
            Height = 25
            Hint = 'Remove from form'
            Anchors = [akTop, akRight]
            Caption = #10799
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -16
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = BtnResetPanelClick
          end
        end
        object pnlControls: TNempPanel
          Tag = 608
          Left = 606
          Top = 16
          Width = 97
          Height = 35
          Caption = 'Controls'
          Constraints.MinHeight = 10
          Constraints.MinWidth = 10
          DragMode = dmAutomatic
          ParentBackground = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 1
          TabStop = True
          Ratio = 0
          FixedHeight = True
          OwnerDraw = False
          DesignSize = (
            97
            35)
          object btnRemoveControls: TButton
            Left = 68
            Top = 4
            Width = 25
            Height = 25
            Hint = 'Remove from form'
            Anchors = [akTop, akRight]
            Caption = #10799
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -16
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = BtnResetPanelClick
          end
        end
        object pnlCoverflow: TNempPanel
          Tag = 108
          Left = 106
          Top = 16
          Width = 97
          Height = 50
          Caption = 'Coverflow'
          Constraints.MinHeight = 10
          Constraints.MinWidth = 10
          DragMode = dmAutomatic
          ParentBackground = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 2
          TabStop = True
          Ratio = 0
          OwnerDraw = False
          DesignSize = (
            97
            50)
          object btnRemoveCoverflow: TButton
            Left = 68
            Top = 2
            Width = 25
            Height = 25
            Hint = 'Remove from form'
            Anchors = [akTop, akRight]
            Caption = #10799
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -16
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = BtnResetPanelClick
          end
        end
        object pnlDetails: TNempPanel
          Tag = 508
          Left = 506
          Top = 16
          Width = 97
          Height = 50
          Caption = 'File overview'
          Constraints.MinHeight = 10
          Constraints.MinWidth = 10
          DragMode = dmAutomatic
          ParentBackground = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 3
          TabStop = True
          Ratio = 0
          OwnerDraw = False
          DesignSize = (
            97
            50)
          object btnRemoveDetails: TButton
            Left = 68
            Top = 2
            Width = 25
            Height = 25
            Hint = 'Remove from form'
            Anchors = [akTop, akRight]
            Caption = #10799
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -16
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = BtnResetPanelClick
          end
        end
        object pnlMedialist: TNempPanel
          Tag = 408
          Left = 406
          Top = 16
          Width = 97
          Height = 50
          Caption = 'Medialist'
          Constraints.MinHeight = 10
          Constraints.MinWidth = 10
          DragMode = dmAutomatic
          ParentBackground = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 4
          TabStop = True
          Ratio = 0
          OwnerDraw = False
          DesignSize = (
            97
            50)
          object btnRemoveMediaList: TButton
            Left = 68
            Top = 2
            Width = 25
            Height = 25
            Hint = 'Remove from form'
            Anchors = [akTop, akRight]
            Caption = #10799
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -16
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = BtnResetPanelClick
          end
        end
        object pnlPlaylist: TNempPanel
          Tag = 308
          Left = 306
          Top = 16
          Width = 97
          Height = 50
          Caption = 'Playlist'
          Constraints.MinHeight = 10
          Constraints.MinWidth = 10
          DragMode = dmAutomatic
          ParentBackground = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 5
          TabStop = True
          Ratio = 0
          OwnerDraw = False
          DesignSize = (
            97
            50)
          object btnRemovePlaylist: TButton
            Left = 68
            Top = 2
            Width = 25
            Height = 25
            Hint = 'Remove from form'
            Anchors = [akTop, akRight]
            Caption = #10799
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -16
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = BtnResetPanelClick
          end
        end
        object pnlTree: TNempPanel
          Tag = 8
          Left = 6
          Top = 16
          Width = 97
          Height = 50
          Caption = 'Tree view'
          Constraints.MinHeight = 10
          Constraints.MinWidth = 10
          DragMode = dmAutomatic
          Padding.Left = 4
          ParentBackground = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 6
          TabStop = True
          Ratio = 0
          OwnerDraw = False
          DesignSize = (
            97
            50)
          object btnRemoveTree: TButton
            Left = 69
            Top = 2
            Width = 25
            Height = 25
            Hint = 'Remove from form'
            Anchors = [akTop, akRight]
            Caption = #10799
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -16
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = BtnResetPanelClick
          end
        end
      end
      object grpBoxNempConstruction: TGroupBox
        Left = 0
        Top = 0
        Width = 710
        Height = 492
        Align = alClient
        Caption = 'Nemp main window'
        TabOrder = 1
        object MainContainer: TNempContainerPanel
          Left = 2
          Top = 69
          Width = 706
          Height = 421
          Align = alClient
          BorderWidth = 3
          Constraints.MinWidth = 50
          ParentBackground = False
          TabOrder = 0
          OnDragDrop = NempContainerDragDrop
          OnDragOver = NempContainerDragOver
          OnResize = MainContainerResize
          Ratio = 0
          OwnerDraw = False
          HierarchyLevel = 0
          SplitterMinSize = 120
          DesignSize = (
            706
            421)
          object lblMainContainer: TLabel
            Left = 11
            Top = 46
            Width = 662
            Height = 43
            Anchors = [akLeft, akTop, akRight]
            AutoSize = False
            Caption = '-'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            Visible = False
            WordWrap = True
          end
        end
        object pnlConstructionHint: TPanel
          Left = 2
          Top = 15
          Width = 706
          Height = 54
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
          DesignSize = (
            706
            54)
          object lblElementCount: TLabel
            Left = 56
            Top = 8
            Width = 646
            Height = 36
            Anchors = [akLeft, akTop, akRight]
            AutoSize = False
            Caption = '-'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ShowAccelChar = False
            WordWrap = True
          end
          object imgInfo: TImage
            Left = 11
            Top = 10
            Width = 32
            Height = 32
          end
        end
      end
    end
    object pnlSettings: TPanel
      Left = 711
      Top = 1
      Width = 249
      Height = 565
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object grpBoxVisibleElements: TGroupBox
        Left = 0
        Top = 0
        Width = 249
        Height = 131
        Align = alTop
        Caption = 'Visible elements in Nemp'
        TabOrder = 0
        DesignSize = (
          249
          131)
        object lblPlaylistAlwaysVisible: TLabel
          Left = 16
          Top = 87
          Width = 217
          Height = 34
          Hint = 
            'Select how you want to align the two tree views in the main wind' +
            'ow'
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 'Playlist and Controls are always visible.'
        end
        object cbeDetails: TCheckBox
          Tag = 2
          Left = 16
          Top = 64
          Width = 217
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          Caption = 'File overview (details)'
          Checked = True
          State = cbChecked
          TabOrder = 2
          OnClick = cbSelectionClick
        end
        object cbMedialist: TCheckBox
          Tag = 1
          Left = 16
          Top = 44
          Width = 217
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Medialist'
          Checked = True
          State = cbChecked
          TabOrder = 1
          OnClick = cbSelectionClick
        end
        object cbSelection: TCheckBox
          Left = 16
          Top = 24
          Width = 217
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Treeview / Coverflow / Tag cloud'
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = cbSelectionClick
        end
      end
      object grpBoxAdditionalConfig: TGroupBox
        Left = 0
        Top = 131
        Width = 249
        Height = 222
        Align = alTop
        Caption = 'Additional configuration'
        TabOrder = 1
        DesignSize = (
          249
          222)
        object lblTreeViewOrientation: TLabel
          Left = 16
          Top = 24
          Width = 102
          Height = 13
          Caption = 'Tree view orientation'
        end
        object lblFileOverview: TLabel
          Left = 16
          Top = 82
          Width = 63
          Height = 13
          Caption = 'File overview'
        end
        object cbControlPanelShowCover: TCheckBox
          Left = 16
          Top = 188
          Width = 225
          Height = 17
          Hint = 'Show or hide the small cover art next to the player controls'
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Show cover on Control Panel'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
        end
        object cbTreeViewOrientation: TComboBox
          Left = 16
          Top = 43
          Width = 145
          Height = 21
          Hint = 
            'Select how you want to align the two tree views in the main wind' +
            'ow'
          Style = csDropDownList
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          Items.Strings = (
            'Side by side'
            'Stacked')
        end
        object cbFileOverviewOrientation: TComboBox
          Left = 16
          Top = 128
          Width = 145
          Height = 21
          Hint = 
            'Select how you want to align cover art and text in the section "' +
            'File overview"'
          Style = csDropDownList
          ItemIndex = 0
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          Text = 'Side by side'
          Items.Strings = (
            'Side by side'
            'Stacked')
        end
        object cbFileOverviewMode: TComboBox
          Left = 16
          Top = 101
          Width = 145
          Height = 21
          Hint = 'Select what you want to see in the section "File overview"'
          Style = csDropDownList
          ItemIndex = 0
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          Text = 'Cover and Text'
          OnChange = cbFileOverviewModeChange
          Items.Strings = (
            'Cover and Text'
            'Only Cover'
            'Only Text')
        end
        object cbShowCategorySelection: TCheckBox
          Left = 16
          Top = 168
          Width = 217
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Show category selection'
          TabOrder = 3
        end
      end
    end
  end
  object MainMenu: TMainMenu
    AutoHotkeys = maManual
    Left = 43
    Top = 203
    object mmLayout: TMenuItem
      AutoHotkeys = maManual
      Caption = 'Layout'
      object mmSplit1: TMenuItem
        Caption = '-'
      end
      object mmClear: TMenuItem
        AutoHotkeys = maManual
        Caption = 'New layout'
        Hint = 'Create a new Form Layout from scratch'
        OnClick = BtnNewLayoutClick
      end
      object mmUndo: TMenuItem
        AutoHotkeys = maManual
        Caption = 'Undo all changes'
        Hint = 'Undo all changes and restore the currently used Form Layout '
        OnClick = mmUndoClick
      end
      object mmResetToDefault: TMenuItem
        AutoHotkeys = maManual
        Caption = 'Reset to default'
        Hint = 'Restore the Nemp default Layout'
        OnClick = BtnResetToDefaultClick
      end
    end
    object mmExampleLayouts: TMenuItem
      Caption = 'Example layouts'
    end
  end
end
