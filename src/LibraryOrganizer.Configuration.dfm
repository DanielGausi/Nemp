object FormLibraryConfiguration: TFormLibraryConfiguration
  Left = 0
  Top = 0
  Caption = 'Library configuration'
  ClientHeight = 415
  ClientWidth = 723
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
    Top = 374
    Width = 723
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitTop = 464
    ExplicitWidth = 758
    DesignSize = (
      723
      41)
    object BtnOK: TButton
      Left = 446
      Top = 6
      Width = 85
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      TabOrder = 0
      OnClick = BtnOKClick
      ExplicitLeft = 481
    end
    object BtnCancel: TButton
      Left = 628
      Top = 6
      Width = 85
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
      OnClick = BtnCancelClick
      ExplicitLeft = 663
    end
    object BtnApply: TButton
      Left = 537
      Top = 6
      Width = 85
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Apply'
      TabOrder = 2
      OnClick = BtnApplyClick
      ExplicitLeft = 572
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 723
    Height = 374
    ActivePage = tsCategories
    Align = alClient
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 1
    ExplicitWidth = 758
    ExplicitHeight = 464
    object tsCategories: TTabSheet
      Caption = 'Categories'
      ExplicitWidth = 750
      ExplicitHeight = 436
      object grpBoxCategories: TGroupBox
        Left = 0
        Top = 0
        Width = 200
        Height = 346
        Align = alLeft
        Caption = 'Categories'
        DoubleBuffered = True
        ParentDoubleBuffered = False
        TabOrder = 0
        ExplicitLeft = -4
        ExplicitTop = -2
        ExplicitHeight = 539
        object VSTCategories: TVirtualStringTree
          Left = 2
          Top = 15
          Width = 196
          Height = 158
          Align = alClient
          Header.AutoSizeIndex = 0
          Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs]
          PopupMenu = PopupCategories
          TabOrder = 0
          TreeOptions.PaintOptions = [toShowBackground, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
          OnEditing = VSTCategoriesEditing
          OnGetText = VSTCategoriesGetText
          OnPaintText = VSTCategoriesPaintText
          OnNewText = VSTCategoriesNewText
          ExplicitHeight = 43
          Columns = <
            item
              Position = 0
              Width = 192
            end>
        end
        object pnlCategoryButtons: TPanel
          Left = 2
          Top = 173
          Width = 196
          Height = 62
          Align = alBottom
          BevelOuter = bvNone
          DoubleBuffered = True
          ParentDoubleBuffered = False
          TabOrder = 1
          ExplicitTop = 366
          object BtnAddCategory: TButton
            Left = 45
            Top = 8
            Width = 137
            Height = 25
            Action = ActionAddCategory
            TabOrder = 0
          end
          object BtnDeleteCategory: TButton
            Left = 45
            Top = 33
            Width = 137
            Height = 25
            Action = ActionDeleteCategory
            TabOrder = 1
          end
          object BtnMoveCategories: TUpDown
            Left = 8
            Top = 8
            Width = 32
            Height = 50
            Min = -1000000
            Max = 1000000
            TabOrder = 2
            OnClick = BtnMoveCategoriesClick
          end
        end
        object pnlCategoryAdds: TPanel
          Left = 2
          Top = 235
          Width = 196
          Height = 109
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 2
          ExplicitTop = 428
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
            Width = 174
            Height = 21
            Style = csDropDownList
            TabOrder = 0
            OnChange = cbDefaultCategoryChange
          end
          object cbNewFilesCategory: TComboBox
            Left = 8
            Top = 77
            Width = 174
            Height = 21
            Style = csDropDownList
            TabOrder = 1
            OnChange = cbNewFilesCategoryChange
          end
          object checkBoxNewFilesCategory: TCheckBox
            Left = 8
            Top = 54
            Width = 150
            Height = 17
            Caption = 'Add new files to'
            Checked = True
            State = cbChecked
            TabOrder = 2
          end
        end
      end
      object grpBoxSortLevels: TGroupBox
        Left = 200
        Top = 0
        Width = 200
        Height = 346
        Align = alLeft
        Caption = 'Category layers'
        DoubleBuffered = True
        ParentDoubleBuffered = False
        TabOrder = 1
        ExplicitLeft = 204
        ExplicitTop = -3
        ExplicitHeight = 436
        object VSTSortings: TVirtualStringTree
          Left = 2
          Top = 15
          Width = 196
          Height = 158
          Align = alClient
          BevelInner = bvNone
          BevelOuter = bvNone
          Header.AutoSizeIndex = 0
          Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs]
          PopupMenu = PopupLayers
          TabOrder = 0
          TreeOptions.PaintOptions = [toShowBackground, toShowButtons, toShowDropmark, toShowRoot, toShowTreeLines, toThemeAware, toUseBlendedImages]
          OnFocusChanged = VSTSortingsFocusChanged
          OnGetText = VSTSortingsGetText
          ExplicitHeight = 213
          Columns = <
            item
              Position = 0
              Width = 192
            end>
        end
        object pnlLayerButtons: TPanel
          Left = 2
          Top = 173
          Width = 196
          Height = 92
          Align = alBottom
          BevelOuter = bvNone
          DoubleBuffered = True
          ParentDoubleBuffered = False
          TabOrder = 1
          ExplicitTop = 357
          object BtnAddSubLayer: TButton
            Left = 45
            Top = 33
            Width = 137
            Height = 25
            Action = ActionAddLayer
            TabOrder = 0
          end
          object BtnDeleteLayer: TButton
            Left = 45
            Top = 58
            Width = 137
            Height = 25
            Action = ActionDeleteLayer
            TabOrder = 1
          end
          object BtnMoveLayer: TUpDown
            Left = 8
            Top = 8
            Width = 32
            Height = 50
            ArrowKeys = False
            Min = -100000
            Max = 1000000
            TabOrder = 2
            TabStop = True
            OnClick = BtnMoveLayerClick
          end
          object BtnAddRootLayer: TButton
            Left = 45
            Top = 8
            Width = 137
            Height = 25
            Action = ActionAddRootLayer
            TabOrder = 3
          end
        end
        object pnlLayerAdds: TPanel
          Left = 2
          Top = 265
          Width = 196
          Height = 79
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 2
          ExplicitTop = 459
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
            Width = 174
            Height = 21
            Style = csDropDownList
            TabOrder = 0
          end
        end
      end
      object PnlSettings: TPanel
        Left = 400
        Top = 0
        Width = 315
        Height = 346
        Align = alClient
        BevelOuter = bvNone
        DoubleBuffered = True
        ParentDoubleBuffered = False
        TabOrder = 2
        ExplicitWidth = 350
        ExplicitHeight = 436
        object grpBoxAlbumSettings: TGroupBox
          Left = 0
          Top = 0
          Width = 315
          Height = 145
          Align = alTop
          Caption = 'Album settings'
          TabOrder = 0
          ExplicitWidth = 350
          DesignSize = (
            315
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
            Width = 273
            Height = 17
            Anchors = [akLeft, akTop, akRight]
            Caption = 'Do not distinguish directories like "CD 1" and "CD 2"'
            TabOrder = 0
            ExplicitWidth = 329
          end
          object editCDNames: TLabeledEdit
            Left = 16
            Top = 103
            Width = 281
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            EditLabel.Width = 199
            EditLabel.Height = 13
            EditLabel.Caption = 'Base names to ignore (comma separated)'
            TabOrder = 1
            ExplicitWidth = 316
          end
          object cbAlbumKeymode: TComboBox
            Left = 16
            Top = 37
            Width = 201
            Height = 21
            Style = csDropDownList
            ItemIndex = 2
            TabOrder = 2
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
          Width = 315
          Height = 201
          Align = alClient
          Caption = 'Display settings'
          TabOrder = 1
          ExplicitWidth = 350
          ExplicitHeight = 291
          DesignSize = (
            315
            201)
          object lblPlaylistCaptionMode: TLabel
            Left = 16
            Top = 70
            Width = 90
            Height = 13
            Caption = 'Display playlists by'
          end
          object cbShowCoverForAlbum: TCheckBox
            Left = 16
            Top = 24
            Width = 272
            Height = 17
            Anchors = [akLeft, akTop, akRight]
            Caption = 'Show cover art on layer "Album"'
            TabOrder = 0
            ExplicitWidth = 307
          end
          object cbShowCount: TCheckBox
            Left = 16
            Top = 47
            Width = 288
            Height = 17
            Anchors = [akLeft, akTop, akRight]
            Caption = 'Show number of elements in tree view'
            TabOrder = 1
            ExplicitWidth = 323
          end
          object cbPlaylistCaptionMode: TComboBox
            Left = 16
            Top = 89
            Width = 201
            Height = 21
            Style = csDropDownList
            ItemIndex = 0
            TabOrder = 2
            Text = 'Filename'
            Items.Strings = (
              'Filename'
              'Folder + Filename')
          end
        end
      end
    end
    object tsSettings: TTabSheet
      Caption = 'General settings'
      ImageIndex = 2
      ExplicitWidth = 750
      ExplicitHeight = 436
    end
  end
  object ActionList1: TActionList
    Left = 12
    Top = 48
    object ActionAddCategory: TAction
      Caption = 'Add category'
      OnExecute = ActionAddCategoryExecute
    end
    object ActionDeleteCategory: TAction
      Caption = 'Delete category'
      OnExecute = ActionDeleteCategoryExecute
    end
    object ActionAddRootLayer: TAction
      Caption = 'Add root layer'
      OnExecute = ActionAddRootLayerExecute
    end
    object ActionAddLayer: TAction
      Caption = 'Add layer'
      OnExecute = ActionAddLayerExecute
    end
    object ActionDeleteLayer: TAction
      Caption = 'Delete layer'
      OnExecute = ActionDeleteLayerExecute
    end
    object ActionEditLayer: TAction
      Caption = 'Edit layer'
      OnExecute = ActionEditLayerExecute
    end
    object ActionEditCategory: TAction
      Caption = 'Edit category'
      OnExecute = ActionEditCategoryExecute
    end
  end
  object PopupLayers: TPopupMenu
    Left = 300
    Top = 40
    object Editlayer1: TMenuItem
      Action = ActionEditLayer
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
  end
  object PopupCategories: TPopupMenu
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
  end
end
