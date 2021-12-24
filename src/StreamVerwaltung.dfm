object FormStreamVerwaltung: TFormStreamVerwaltung
  Left = 885
  Top = 308
  Caption = 'Nemp - Stream selection'
  ClientHeight = 454
  ClientWidth = 712
  Color = clBtnFace
  Constraints.MinHeight = 420
  Constraints.MinWidth = 712
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu_StreamSelection
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    712
    454)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 384
    Top = 416
    Width = 3
    Height = 13
  end
  object Btn_Ok: TButton
    Left = 619
    Top = 419
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Ok'
    TabOrder = 0
    OnClick = Btn_OkClick
  end
  object Btn_Shoutcast: TButton
    Left = 499
    Top = 419
    Width = 113
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'www.Shoutcast.com'
    TabOrder = 1
    OnClick = Btn_ShoutcastClick
  end
  object Btn_Icecast: TButton
    Left = 379
    Top = 419
    Width = 113
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'www.Icecast.org'
    TabOrder = 2
    OnClick = Btn_IcecastClick
  end
  object PC_Streams: TPageControl
    Left = 8
    Top = 8
    Width = 692
    Height = 405
    ActivePage = Tab_Favourites
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 3
    object Tab_Favourites: TTabSheet
      Caption = 'Favorites'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        684
        377)
      object VST_Favorites: TVirtualStringTree
        Left = 31
        Top = 34
        Width = 650
        Height = 309
        Anchors = [akLeft, akTop, akRight, akBottom]
        Header.AutoSizeIndex = 0
        Header.DefaultHeight = 17
        Header.Height = 17
        Header.Options = [hoColumnResize, hoDrag, hoVisible]
        Indent = 0
        PopupMenu = PM_Favorites
        TabOrder = 0
        TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning]
        TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toExtendedFocus, toFullRowSelect, toRightClickSelect]
        OnChange = VST_FavoritesChange
        OnColumnDblClick = VST_ShoutcastQueryColumnDblClick
        OnGetText = VST_FavoritesGetText
        OnHeaderClick = VST_FavoritesHeaderClick
        OnKeyDown = VST_FavoritesKeyDown
        Columns = <
          item
            Position = 0
            Width = 240
            WideText = 'Name'
          end
          item
            Position = 1
            Width = 100
            WideText = 'Format'
          end
          item
            Position = 2
            Width = 100
            WideText = 'Genre'
          end
          item
            Position = 3
            Width = 240
            WideText = 'URL'
          end>
      end
      object BtnExport: TButton
        Left = 142
        Top = 349
        Width = 105
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'Export'
        TabOrder = 1
        OnClick = PM_Fav_ExportClick
      end
      object BtnImport: TButton
        Left = 253
        Top = 349
        Width = 105
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'Import'
        TabOrder = 2
        OnClick = PM_Fav_ImportClick
      end
      object udSortFavorites: TUpDown
        Left = 3
        Top = 34
        Width = 22
        Height = 54
        Hint = 'Move selected item up/downwards'
        Min = -1000
        Max = 1000
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        OnClick = udSortFavoritesClick
      end
      object cbSortMode: TComboBox
        Left = 31
        Top = 7
        Width = 145
        Height = 21
        Style = csDropDownList
        ItemIndex = 5
        TabOrder = 4
        Text = 'Unsorted'
        OnChange = cbSortModeChange
        Items.Strings = (
          'Name'
          'Format'
          'Genre'
          'URL'
          'Custom'
          'Unsorted')
      end
      object BtnSetCustomSort: TButton
        Left = 182
        Top = 3
        Width = 207
        Height = 25
        Caption = 'Use current sorting'
        TabOrder = 5
        OnClick = BtnSetCustomSortClick
      end
      object BtnNewStation: TButton
        Left = 31
        Top = 349
        Width = 105
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'New station'
        TabOrder = 6
        OnClick = Btn_NewClick
      end
    end
    object Tab_Shoutcast: TTabSheet
      Caption = 'Shoutcast.com'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        684
        377)
      object LblConst_Limit: TLabel
        Left = 480
        Top = 376
        Width = 3
        Height = 13
        Enabled = False
      end
      object lblShoutcastAPIchanged: TLabel
        Left = 16
        Top = 3
        Width = 657
        Height = 32
        AutoSize = False
        Caption = 
          'Shoutcast changed the API and its terms of use. Therefore OpenSo' +
          'urce-Software like Nemp can no longer use it.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object VST_ShoutcastQuery: TVirtualStringTree
        Left = 8
        Top = 96
        Width = 668
        Height = 241
        Anchors = [akLeft, akTop, akRight, akBottom]
        Enabled = False
        Header.AutoSizeIndex = 0
        Header.DefaultHeight = 17
        Header.Height = 17
        Header.Options = [hoColumnResize, hoDrag, hoVisible]
        Indent = 0
        TabOrder = 0
        TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning]
        TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toExtendedFocus, toFullRowSelect, toMultiSelect, toRightClickSelect]
        Columns = <
          item
            Position = 0
            Width = 200
            WideText = 'Name'
          end
          item
            Position = 1
            Width = 200
            WideText = 'Current title'
          end
          item
            Position = 2
            Width = 100
            WideText = 'Format'
          end
          item
            Position = 3
            Width = 100
            WideText = 'Genre'
          end
          item
            Position = 4
            Width = 60
            WideText = 'Listener'
          end>
      end
      object GrpBox_GeneralSearch: TGroupBox
        Left = 8
        Top = 41
        Width = 281
        Height = 49
        Caption = 'General search'
        Enabled = False
        TabOrder = 2
        object Edt_Search: TEdit
          Left = 8
          Top = 16
          Width = 185
          Height = 21
          Enabled = False
          TabOrder = 0
        end
        object Btn_Search: TButton
          Left = 200
          Top = 16
          Width = 73
          Height = 21
          Caption = 'Ok'
          Enabled = False
          TabOrder = 1
        end
      end
      object GrpBox_SearchGenre: TGroupBox
        Left = 296
        Top = 41
        Width = 241
        Height = 49
        Caption = 'Search by genre'
        Enabled = False
        TabOrder = 3
        object CB_SearchGenre: TComboBox
          Left = 8
          Top = 16
          Width = 143
          Height = 21
          Style = csDropDownList
          DropDownCount = 23
          Enabled = False
          ItemIndex = 0
          TabOrder = 0
          Text = '70s'
          Items.Strings = (
            '70s'
            '80s'
            'Alternative'
            'Classical'
            'Country'
            'Electronic'
            'Gospel'
            'Hip-Hop'
            'House'
            'Jazz'
            'Metal'
            'Oldies'
            'Pop'
            'R&B'
            'Reggae'
            'Rock'
            'Spiritual'
            'Spoken'
            'Techno'
            'Top 40'
            'Trance'
            'World')
        end
        object Btn_SearchGenre: TButton
          Left = 160
          Top = 16
          Width = 73
          Height = 21
          Caption = 'Ok'
          Enabled = False
          TabOrder = 1
        end
      end
      object Btn_AddSelected: TButton
        Left = 8
        Top = 343
        Width = 153
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'Add selected to favorites'
        Enabled = False
        TabOrder = 1
      end
    end
  end
  object xxx_ProgressBar1: TProgressBar
    Left = 224
    Top = 419
    Width = 137
    Height = 17
    Anchors = [akLeft, akBottom]
    TabOrder = 4
    Visible = False
  end
  object XXXX_CB_ParseStreamURL: TCheckBox
    Left = 8
    Top = 419
    Width = 105
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Parse Stream-Playlist and add all contained streams to playlist'
    TabOrder = 5
    Visible = False
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
  object PM_Shoutcast: TPopupMenu
    Left = 408
    Top = 104
    object PM_SC_AddToPlaylist: TMenuItem
      Caption = 'Add to playlist'
      OnClick = PM_SC_AddToPlaylistClick
    end
    object PM_SC_AddToFavorites: TMenuItem
      Caption = 'Add to favorites'
      ShortCut = 16454
    end
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
    object MM_Shoutcast: TMenuItem
      Caption = 'Shoutcast'
      Visible = False
      object MM_SC_AddToPlaylist: TMenuItem
        Caption = 'Add to playlist'
        OnClick = PM_SC_AddToPlaylistClick
      end
      object MM_SC_AddToFavorites: TMenuItem
        Caption = 'Add to favorites'
        ShortCut = 16454
      end
    end
  end
end
