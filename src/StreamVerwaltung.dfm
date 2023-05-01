object FormStreamVerwaltung: TFormStreamVerwaltung
  Left = 885
  Top = 308
  Caption = 'Nemp - Internet radio'
  ClientHeight = 481
  ClientWidth = 718
  Color = clBtnFace
  Constraints.MinHeight = 420
  Constraints.MinWidth = 712
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu_StreamSelection
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 13
  object Label1: TLabel
    Left = 384
    Top = 416
    Width = 3
    Height = 13
  end
  object pnlMain: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 712
    Height = 431
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 706
    ExplicitHeight = 404
    object VST_Favorites: TVirtualStringTree
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 706
      Height = 425
      Align = alClient
      Colors.UnfocusedSelectionColor = clHighlight
      Colors.UnfocusedSelectionBorderColor = clHighlight
      DragOperations = [doMove]
      Header.AutoSizeIndex = 0
      Header.DefaultHeight = 17
      Header.Height = 17
      Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
      Indent = 0
      PopupMenu = PM_Favorites
      TabOrder = 0
      TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoChangeScale]
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning]
      TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
      TreeOptions.SelectionOptions = [toExtendedFocus, toFullRowSelect, toRightClickSelect]
      OnColumnDblClick = VST_ShoutcastQueryColumnDblClick
      OnDragAllowed = VST_FavoritesDragAllowed
      OnDragOver = VST_FavoritesDragOver
      OnDragDrop = VST_FavoritesDragDrop
      OnGetText = VST_FavoritesGetText
      OnPaintText = VST_FavoritesPaintText
      OnHeaderClick = VST_FavoritesHeaderClick
      OnKeyDown = VST_FavoritesKeyDown
      Touch.InteractiveGestures = [igPan, igPressAndTap]
      Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
      ExplicitWidth = 700
      ExplicitHeight = 398
      Columns = <
        item
          Position = 0
          Text = 'Name'
          Width = 240
        end
        item
          Position = 1
          Text = 'Format'
          Width = 100
        end
        item
          Position = 2
          Text = 'Genre'
          Width = 100
        end
        item
          Position = 3
          Text = 'URL'
          Width = 240
        end>
    end
  end
  object pnlButtons: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 440
    Width = 712
    Height = 38
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      712
      38)
    object Btn_Icecast: TButton
      AlignWithMargins = True
      Left = 114
      Top = 6
      Width = 113
      Height = 25
      Caption = 'www.Icecast.org'
      TabOrder = 0
      OnClick = Btn_IcecastClick
    end
    object Btn_Ok: TButton
      AlignWithMargins = True
      Left = 634
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Ok'
      TabOrder = 1
      OnClick = Btn_OkClick
      ExplicitLeft = 628
    end
    object BtnNewStation: TButton
      AlignWithMargins = True
      Left = 3
      Top = 6
      Width = 105
      Height = 25
      Caption = 'New station'
      TabOrder = 2
      OnClick = Btn_NewClick
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Webstream lists|*.nwl;*.pls'
    Left = 128
    Top = 192
  end
  object SaveDialogFavorites: TSaveDialog
    DefaultExt = 'pls'
    Filter = 'Regular playlist (*.pls)|*.pls|Nemp webstream list (*.nwl)|*.nwl'
    OnTypeChange = SaveDialogFavoritesTypeChange
    Left = 128
    Top = 248
  end
  object PM_Favorites: TPopupMenu
    Left = 336
    Top = 104
    object PM_Fav_NewStation: TMenuItem
      Caption = 'Add new station'
      ShortCut = 16462
      OnClick = PM_Fav_NewStationClick
    end
    object PM_Fav_AddToPlaylist: TMenuItem
      Caption = 'Add to playlist'
      OnClick = PM_Fav_AddToPlaylistClick
    end
    object PM_Fav_Edit: TMenuItem
      Caption = 'Edit'
      ShortCut = 113
      OnClick = PM_Fav_EditClick
    end
    object PM_Fav_Delete: TMenuItem
      Caption = 'Delete'
      ShortCut = 46
      OnClick = PM_Fav_DeleteClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object PM_Fav_Export: TMenuItem
      Caption = 'Export'
      ShortCut = 16453
      OnClick = PM_Fav_ExportClick
    end
    object PM_Fav_Import: TMenuItem
      Caption = 'Import'
      ShortCut = 16457
      OnClick = PM_Fav_ImportClick
    end
  end
  object MainMenu_StreamSelection: TMainMenu
    AutoHotkeys = maManual
    Left = 132
    Top = 104
    object MM_Favorites: TMenuItem
      Caption = 'Favorites'
      object MM_Fav_NewStatio: TMenuItem
        Caption = 'Add new station'
        ShortCut = 16462
        OnClick = PM_Fav_NewStationClick
      end
      object MM_Fav_AddToPlaylist: TMenuItem
        Caption = 'Add to playlist'
        OnClick = PM_Fav_AddToPlaylistClick
      end
      object MM_Fav_Edit: TMenuItem
        Caption = 'Edit'
        ShortCut = 113
        OnClick = PM_Fav_EditClick
      end
      object MM_Fav_Delete: TMenuItem
        Caption = 'Delete'
        OnClick = PM_Fav_DeleteClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object MM_Fav_Export: TMenuItem
        Caption = 'Export'
        ShortCut = 16453
        OnClick = PM_Fav_ExportClick
      end
      object MM_Fav_Import: TMenuItem
        Caption = 'Import'
        ShortCut = 16457
        OnClick = PM_Fav_ImportClick
      end
    end
  end
end
