object FormStreamVerwaltung: TFormStreamVerwaltung
  Left = 885
  Top = 308
  Caption = 'Nemp - Stream selection'
  ClientHeight = 489
  ClientWidth = 727
  Color = clBtnFace
  Constraints.MinHeight = 420
  Constraints.MinWidth = 590
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
    727
    489)
  PixelsPerInch = 96
  TextHeight = 13
  object Btn_Ok: TButton
    Left = 634
    Top = 419
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Ok'
    TabOrder = 0
    OnClick = Btn_OkClick
    ExplicitTop = 399
  end
  object Btn_Shoutcast: TButton
    Left = 514
    Top = 419
    Width = 113
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'www.Shoutcast.com'
    TabOrder = 1
    OnClick = Btn_ShoutcastClick
    ExplicitTop = 399
  end
  object Btn_Icecast: TButton
    Left = 394
    Top = 419
    Width = 113
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'www.Icecast.org'
    TabOrder = 2
    OnClick = Btn_IcecastClick
    ExplicitTop = 399
  end
  object PC_Streams: TPageControl
    Left = 8
    Top = 8
    Width = 707
    Height = 404
    ActivePage = Tab_Favourites
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 3
    ExplicitHeight = 384
    object Tab_Favourites: TTabSheet
      Caption = 'Favorites'
      ExplicitHeight = 356
      DesignSize = (
        699
        376)
      object VST_Favorites: TVirtualStringTree
        Left = 12
        Top = 9
        Width = 684
        Height = 331
        Anchors = [akLeft, akTop, akRight, akBottom]
        Header.AutoSizeIndex = 0
        Header.DefaultHeight = 17
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.Options = [hoColumnResize, hoDrag, hoVisible]
        Indent = 0
        PopupMenu = PM_Favorites
        TabOrder = 0
        TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning]
        TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toExtendedFocus, toFullRowSelect, toRightClickSelect]
        OnColumnDblClick = VST_ShoutcastQueryColumnDblClick
        OnGetText = VST_FavoritesGetText
        OnKeyDown = VST_FavoritesKeyDown
        ExplicitHeight = 311
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
        Left = 8
        Top = 346
        Width = 105
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'Export'
        TabOrder = 1
        OnClick = PM_Fav_ExportClick
        ExplicitTop = 326
      end
      object BtnImport: TButton
        Left = 120
        Top = 346
        Width = 105
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'Import'
        TabOrder = 2
        OnClick = PM_Fav_ImportClick
        ExplicitTop = 326
      end
    end
    object Tab_Shoutcast: TTabSheet
      Caption = 'Shoutcast.com'
      ImageIndex = 1
      ExplicitHeight = 356
      DesignSize = (
        699
        376)
      object LblConst_Limit: TLabel
        Left = 480
        Top = 376
        Width = 3
        Height = 13
      end
      object VST_ShoutcastQuery: TVirtualStringTree
        Left = 8
        Top = 64
        Width = 683
        Height = 272
        Anchors = [akLeft, akTop, akRight, akBottom]
        Header.AutoSizeIndex = 0
        Header.DefaultHeight = 17
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.Options = [hoColumnResize, hoDrag, hoVisible]
        Indent = 0
        PopupMenu = PM_Shoutcast
        TabOrder = 0
        TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning]
        TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toExtendedFocus, toFullRowSelect, toMultiSelect, toRightClickSelect]
        OnColumnDblClick = VST_ShoutcastQueryColumnDblClick
        OnGetText = VST_ShoutcastQueryGetText
        OnHeaderClick = VST_ShoutcastQueryHeaderClick
        OnKeyDown = VST_ShoutcastQueryKeyDown
        ExplicitHeight = 252
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
        Top = 8
        Width = 281
        Height = 49
        Caption = 'General search'
        TabOrder = 2
        object Edt_Search: TEdit
          Left = 8
          Top = 16
          Width = 185
          Height = 21
          TabOrder = 0
          OnKeyPress = Edt_SearchKeyPress
        end
        object Btn_Search: TButton
          Left = 200
          Top = 16
          Width = 73
          Height = 21
          Caption = 'Ok'
          TabOrder = 1
          OnClick = Btn_SearchClick
        end
      end
      object GrpBox_SearchGenre: TGroupBox
        Left = 296
        Top = 8
        Width = 241
        Height = 49
        Caption = 'Search by genre'
        TabOrder = 3
        object CB_SearchGenre: TComboBox
          Left = 8
          Top = 16
          Width = 143
          Height = 21
          Style = csDropDownList
          DropDownCount = 23
          ItemHeight = 13
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
          TabOrder = 1
          OnClick = Btn_SearchGenreClick
        end
      end
      object Btn_AddSelected: TButton
        Left = 8
        Top = 342
        Width = 153
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'Add selected to favorites'
        TabOrder = 1
        OnClick = Btn_AddSelectedClick
        ExplicitTop = 322
      end
    end
  end
  object ProgressBar1: TProgressBar
    Left = 88
    Top = 447
    Width = 201
    Height = 17
    Anchors = [akLeft, akBottom]
    TabOrder = 4
    Visible = False
    ExplicitTop = 427
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 470
    Width = 727
    Height = 19
    Panels = <
      item
        Width = 200
      end
      item
        Width = 200
      end>
    ExplicitTop = 450
  end
  object CB_ParseStreamURL: TCheckBox
    Left = 8
    Top = 404
    Width = 353
    Height = 17
    Caption = 'Parse Stream-Playlist and add all contained streams to playlist'
    TabOrder = 6
  end
  object IdHTTP1: TIdHTTP
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0'
    HTTPOptions = [hoForceEncodeParams]
    Left = 436
  end
  object HideTimer: TTimer
    Enabled = False
    Interval = 1500
    OnTimer = HideTimerTimer
    Left = 340
    Top = 400
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Nemp webstream list (*.nwl)|*.nwl'
    Left = 144
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'nwl'
    Filter = 'Nemp webstream list (*.nwl)|*.nwl'
    Left = 176
  end
  object PM_Shoutcast: TPopupMenu
    Left = 400
    object PM_SC_AddToPlaylist: TMenuItem
      Caption = 'Add to playlist'
      OnClick = PM_SC_AddToPlaylistClick
    end
    object PM_SC_AddToFavorites: TMenuItem
      Caption = 'Add to favorites'
      ShortCut = 16454
      OnClick = PM_SC_AddToFavoritesClick
    end
  end
  object PM_Favorites: TPopupMenu
    Left = 352
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
    Left = 276
    Top = 8
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
      object MM_SC_AddToPlaylist: TMenuItem
        Caption = 'Add to playlist'
        OnClick = PM_SC_AddToPlaylistClick
      end
      object MM_SC_AddToFavorites: TMenuItem
        Caption = 'Add to favorites'
        ShortCut = 16454
        OnClick = PM_SC_AddToFavoritesClick
      end
    end
  end
end
