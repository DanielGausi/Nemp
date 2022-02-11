object FormLibraryConfiguration: TFormLibraryConfiguration
  Left = 0
  Top = 0
  Caption = 'Library configuration'
  ClientHeight = 361
  ClientWidth = 684
  Color = clBtnFace
  Constraints.MinHeight = 400
  Constraints.MinWidth = 700
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PnlButtons: TPanel
    Left = 0
    Top = 320
    Width = 684
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      684
      41)
    object BtnOK: TButton
      Left = 407
      Top = 6
      Width = 85
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      TabOrder = 0
      OnClick = BtnOKClick
    end
    object BtnCancel: TButton
      Left = 589
      Top = 6
      Width = 85
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 2
      OnClick = BtnCancelClick
    end
    object BtnApply: TButton
      Left = 498
      Top = 6
      Width = 85
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Apply'
      TabOrder = 1
      OnClick = BtnApplyClick
    end
  end
  object PnlMain: TPanel
    Left = 0
    Top = 0
    Width = 684
    Height = 320
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 180
      Top = 0
      Height = 320
      ExplicitLeft = 201
      ExplicitHeight = 370
    end
    object grpBoxCategories: TGroupBox
      Left = 0
      Top = 0
      Width = 180
      Height = 320
      Align = alLeft
      Caption = 'Categories'
      Constraints.MinWidth = 180
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 0
      object VSTCategories: TVirtualStringTree
        Left = 2
        Top = 15
        Width = 176
        Height = 132
        Align = alClient
        DragOperations = [doMove]
        Header.AutoSizeIndex = 0
        Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs]
        Indent = 4
        PopupMenu = PopupCategories
        TabOrder = 0
        TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoChangeScale]
        TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning, toFullRowDrag, toEditOnClick]
        TreeOptions.PaintOptions = [toShowBackground, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
        OnDragAllowed = VSTCategoriesDragAllowed
        OnDragOver = VSTCategoriesDragOver
        OnDragDrop = VSTCategoriesDragDrop
        OnEditing = VSTCategoriesEditing
        OnGetText = VSTCategoriesGetText
        OnNewText = VSTCategoriesNewText
        Columns = <
          item
            Position = 0
            Width = 172
          end>
      end
      object pnlCategoryButtons: TPanel
        Left = 2
        Top = 147
        Width = 176
        Height = 62
        Align = alBottom
        BevelOuter = bvNone
        DoubleBuffered = True
        ParentDoubleBuffered = False
        TabOrder = 1
        object BtnAddCategory: TButton
          Left = 8
          Top = 8
          Width = 150
          Height = 25
          Action = ActionAddCategory
          TabOrder = 0
        end
        object BtnDeleteCategory: TButton
          Left = 8
          Top = 33
          Width = 150
          Height = 25
          Action = ActionDeleteCategory
          TabOrder = 1
        end
      end
      object pnlCategoryAdds: TPanel
        Left = 2
        Top = 209
        Width = 176
        Height = 109
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 2
        DesignSize = (
          176
          109)
        object lblDefaultCategory: TLabel
          Left = 8
          Top = 8
          Width = 81
          Height = 13
          Caption = 'Default category'
        end
        object cbDefaultCategory: TComboBox
          Left = 8
          Top = 27
          Width = 154
          Height = 21
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
          OnChange = cbDefaultCategoryChange
        end
        object cbNewFilesCategory: TComboBox
          Left = 8
          Top = 77
          Width = 154
          Height = 21
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 1
          OnChange = cbNewFilesCategoryChange
        end
        object checkBoxNewFilesCategory: TCheckBox
          Left = 8
          Top = 54
          Width = 150
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Add new files to'
          Checked = True
          State = cbChecked
          TabOrder = 2
          OnClick = checkBoxNewFilesCategoryClick
        end
      end
    end
    object grpBoxSortLevels: TGroupBox
      Left = 183
      Top = 0
      Width = 182
      Height = 320
      Align = alClient
      Caption = 'Category layers'
      Constraints.MinWidth = 180
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 1
      object VSTSortings: TVirtualStringTree
        Left = 2
        Top = 15
        Width = 178
        Height = 132
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        Colors.UnfocusedSelectionColor = clHighlight
        Colors.UnfocusedSelectionBorderColor = clHighlight
        DragOperations = [doMove]
        Header.AutoSizeIndex = 0
        Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs]
        PopupMenu = PopupLayers
        TabOrder = 0
        TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoChangeScale]
        TreeOptions.PaintOptions = [toShowBackground, toShowButtons, toShowDropmark, toShowRoot, toShowTreeLines, toThemeAware, toUseBlendedImages]
        OnDragAllowed = VSTSortingsDragAllowed
        OnDragOver = VSTSortingsDragOver
        OnDragDrop = VSTSortingsDragDrop
        OnFocusChanged = VSTSortingsFocusChanged
        OnGetText = VSTSortingsGetText
        Columns = <
          item
            Position = 0
            Width = 174
          end>
      end
      object pnlLayerButtons: TPanel
        Left = 2
        Top = 147
        Width = 178
        Height = 92
        Align = alBottom
        BevelOuter = bvNone
        DoubleBuffered = True
        ParentDoubleBuffered = False
        TabOrder = 1
        object BtnAddSubLayer: TButton
          Left = 8
          Top = 33
          Width = 150
          Height = 25
          Action = ActionAddLayer
          TabOrder = 1
        end
        object BtnDeleteLayer: TButton
          Left = 8
          Top = 58
          Width = 150
          Height = 25
          Action = ActionDeleteLayer
          TabOrder = 2
        end
        object BtnAddRootLayer: TButton
          Left = 8
          Top = 8
          Width = 150
          Height = 25
          Action = ActionAddRootLayer
          TabOrder = 0
        end
      end
      object pnlLayerAdds: TPanel
        Left = 2
        Top = 239
        Width = 178
        Height = 79
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 2
        DesignSize = (
          178
          79)
        object lblCoverFlowSorting: TLabel
          Left = 8
          Top = 28
          Width = 87
          Height = 13
          Caption = 'Sort Coverflow by'
        end
        object cbCoverFlowSorting: TComboBox
          Left = 8
          Top = 47
          Width = 150
          Height = 21
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
          OnChange = cbCoverFlowSortingChange
        end
      end
    end
    object PnlSettings: TPanel
      Left = 365
      Top = 0
      Width = 319
      Height = 320
      Align = alRight
      BevelOuter = bvNone
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 2
      object grpBoxAlbumSettings: TGroupBox
        Left = 0
        Top = 0
        Width = 319
        Height = 145
        Align = alTop
        Caption = 'Album settings'
        TabOrder = 0
        DesignSize = (
          319
          145)
        object lblAlbumDefinition: TLabel
          Left = 16
          Top = 18
          Width = 78
          Height = 13
          Caption = 'Define Album by'
        end
        object cbIgnoreCDDirectories: TCheckBox
          Left = 16
          Top = 64
          Width = 277
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Do not distinguish directories like "CD 1" and "CD 2"'
          TabOrder = 1
        end
        object editCDNames: TLabeledEdit
          Left = 16
          Top = 103
          Width = 285
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          EditLabel.Width = 199
          EditLabel.Height = 13
          EditLabel.Caption = 'Base names to ignore (comma separated)'
          TabOrder = 2
        end
        object cbAlbumKeymode: TComboBox
          Left = 16
          Top = 37
          Width = 201
          Height = 21
          Style = csDropDownList
          ItemIndex = 2
          TabOrder = 0
          Text = 'Property "Album" and Directory'
          Items.Strings = (
            'Property "Album"'
            'Properties "Album" and "Artist"'
            'Property "Album" and Directory'
            'Directory'
            'Cover')
        end
      end
      object grpBoxView: TGroupBox
        Left = 0
        Top = 145
        Width = 319
        Height = 175
        Align = alClient
        Caption = 'Display settings'
        TabOrder = 1
        DesignSize = (
          319
          175)
        object lblPlaylistCaptionMode: TLabel
          Left = 16
          Top = 86
          Width = 90
          Height = 13
          Caption = 'Display playlists by'
        end
        object cbShowCoverForAlbum: TCheckBox
          Left = 16
          Top = 24
          Width = 276
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Show cover art on layer "Album"'
          TabOrder = 0
        end
        object cbShowCollectionCount: TCheckBox
          Left = 16
          Top = 39
          Width = 292
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Show number of elements in collections'
          TabOrder = 1
        end
        object cbPlaylistCaptionMode: TComboBox
          Left = 16
          Top = 105
          Width = 201
          Height = 21
          Style = csDropDownList
          ItemIndex = 0
          TabOrder = 2
          Text = 'Filename'
          Items.Strings = (
            'Filename'
            'Folder'
            'Folder\Filename'
            'Complete path')
        end
        object cbShowCategoryCount: TCheckBox
          Left = 16
          Top = 55
          Width = 273
          Height = 17
          Caption = 'Show number of elements in categories'
          TabOrder = 3
        end
      end
    end
  end
  object ActionList1: TActionList
    Left = 12
    Top = 48
    object ActionAddCategory: TAction
      Category = 'Categories'
      Caption = 'Add category'
      OnExecute = ActionAddCategoryExecute
    end
    object ActionDeleteCategory: TAction
      Category = 'Categories'
      Caption = 'Delete category'
      OnExecute = ActionDeleteCategoryExecute
    end
    object ActionAddRootLayer: TAction
      Category = 'Layers'
      Caption = 'Add root layer'
      OnExecute = ActionAddRootLayerExecute
    end
    object ActionAddLayer: TAction
      Category = 'Layers'
      Caption = 'Add layer'
      OnExecute = ActionAddLayerExecute
    end
    object ActionDeleteLayer: TAction
      Category = 'Layers'
      Caption = 'Delete layer'
      OnExecute = ActionDeleteLayerExecute
    end
    object ActionEditLayer: TAction
      Category = 'Layers'
      Caption = 'Edit layer'
      OnExecute = ActionEditLayerExecute
    end
    object ActionEditCategory: TAction
      Category = 'Categories'
      Caption = 'Edit category'
      OnExecute = ActionEditCategoryExecute
    end
    object ActionLayerMoveDown: TAction
      Category = 'Layers'
      Caption = 'Move down'
      OnExecute = ActionLayerMoveDownExecute
    end
    object ActionLayerMoveUp: TAction
      Category = 'Layers'
      Caption = 'Move up'
      OnExecute = ActionLayerMoveUpExecute
    end
    object ActionMoveCategoryUp: TAction
      Category = 'Categories'
      Caption = 'Move up'
      OnExecute = ActionMoveCategoryUpExecute
    end
    object ActionMoveCategoryDown: TAction
      Category = 'Categories'
      Caption = 'Move down'
      OnExecute = ActionMoveCategoryDownExecute
    end
  end
  object PopupLayers: TPopupMenu
    OnPopup = PopupLayersPopup
    Left = 300
    Top = 40
    object Editlayer1: TMenuItem
      Action = ActionEditLayer
      ShortCut = 113
    end
    object Addrootlayer1: TMenuItem
      Action = ActionAddRootLayer
    end
    object Addlayer1: TMenuItem
      Action = ActionAddLayer
    end
    object Deletelayer1: TMenuItem
      Action = ActionDeleteLayer
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Moveup1: TMenuItem
      Action = ActionLayerMoveUp
    end
    object Movedown1: TMenuItem
      Action = ActionLayerMoveDown
    end
  end
  object PopupCategories: TPopupMenu
    OnPopup = PopupCategoriesPopup
    Left = 116
    Top = 40
    object Editcategory1: TMenuItem
      Action = ActionEditCategory
    end
    object Addcategory1: TMenuItem
      Action = ActionAddCategory
    end
    object Deletecategory1: TMenuItem
      Action = ActionDeleteCategory
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Moveup2: TMenuItem
      Action = ActionMoveCategoryUp
    end
    object Movedown2: TMenuItem
      Action = ActionMoveCategoryDown
    end
  end
end
