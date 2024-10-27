object FDetails: TFDetails
  Left = 220
  Top = 125
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'File properties'
  ClientHeight = 541
  ClientWidth = 605
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  Position = poMainFormCenter
  ShowHint = True
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnHide = FormHide
  TextHeight = 13
  object MainPageControl: TPageControl
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 599
    Height = 499
    ActivePage = Tab_MetaData
    Align = alClient
    MultiLine = True
    TabOrder = 0
    object Tab_General: TTabSheet
      Caption = 'Overview'
      DoubleBuffered = False
      ParentDoubleBuffered = False
      PopupMenu = PM_FileOverview
      object GrpBox_File: TGroupBox
        Left = 0
        Top = 0
        Width = 591
        Height = 145
        Align = alTop
        Caption = 'File properties'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 0
        DesignSize = (
          591
          145)
        object LBLName: TLabel
          Left = 103
          Top = 31
          Width = 335
          Height = 13
          AutoSize = False
          Caption = '...'
          EllipsisPosition = epWordEllipsis
          ShowAccelChar = False
          Transparent = True
        end
        object LBLSize: TLabel
          Left = 103
          Top = 47
          Width = 335
          Height = 13
          AutoSize = False
          Caption = '...'
          ShowAccelChar = False
          Transparent = True
        end
        object LlblConst_FileSize: TLabel
          Left = 8
          Top = 48
          Width = 80
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Filesize'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          Transparent = True
        end
        object LlblConst_Filename: TLabel
          Left = 8
          Top = 32
          Width = 80
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Filename'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          Transparent = True
        end
        object LlblConst_Path: TLabel
          Left = 8
          Top = 16
          Width = 80
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Path'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          Transparent = True
        end
        object LBLPfad: TLabel
          Left = 103
          Top = 16
          Width = 335
          Height = 13
          AutoSize = False
          Caption = '...'
          EllipsisPosition = epPathEllipsis
          ParentShowHint = False
          ShowAccelChar = False
          ShowHint = True
          Transparent = True
          OnClick = LBLPfadClick
        end
        object LBLSamplerate: TLabel
          Left = 103
          Top = 79
          Width = 335
          Height = 13
          AutoSize = False
          Caption = '...'
          ShowAccelChar = False
          Transparent = True
        end
        object LlblConst_Samplerate: TLabel
          Left = 8
          Top = 80
          Width = 80
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Samplerate'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          Transparent = True
        end
        object LlblConst_Bitrate: TLabel
          Left = 8
          Top = 96
          Width = 80
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Bitrate'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          Transparent = True
        end
        object LblFormat: TLabel
          Left = 103
          Top = 111
          Width = 126
          Height = 13
          AutoSize = False
          Caption = '...'
          ShowAccelChar = False
          Transparent = True
        end
        object LblConst_Format: TLabel
          Left = 8
          Top = 112
          Width = 80
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Format'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          Transparent = True
        end
        object LBLBitrate: TLabel
          Left = 103
          Top = 95
          Width = 126
          Height = 13
          AutoSize = False
          Caption = '...'
          ShowAccelChar = False
          Transparent = True
        end
        object LblConst_Duration: TLabel
          Left = 8
          Top = 64
          Width = 80
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Duration'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          Transparent = True
        end
        object LblDuration: TLabel
          Left = 103
          Top = 63
          Width = 335
          Height = 13
          AutoSize = False
          Caption = '...'
          ShowAccelChar = False
          Transparent = True
        end
        object CoverLibrary1: TImage
          AlignWithMargins = True
          Left = 456
          Top = 13
          Width = 120
          Height = 120
          Anchors = [akTop, akRight]
          Center = True
          OnDblClick = CoverIMAGEDblClick
          ExplicitLeft = 476
        end
        object PnlWarnung: TPanel
          Left = 235
          Top = 101
          Width = 208
          Height = 24
          BevelOuter = bvNone
          TabOrder = 0
          object Image1: TImage
            Left = 0
            Top = 0
            Width = 24
            Height = 24
            Picture.Data = {
              07544269746D617076060000424D760600000000000036040000280000001800
              000018000000010008000000000040020000C30E0000C30E0000000100000001
              00000800000008080800310010004A08180031101800391821005A1821004A18
              290063292900522131006B21310039314200843142001042420018394A001042
              4A008C524A0031395200084252006B4A5200085252005A525200845252005A5A
              5A00635A5A006B5A5A00845A5A008C5A5A00635A6300845A63005A6363008463
              6300946363008C6B6B00A56B6B00086B7300426B730094737300396B7B009C7B
              7B00A57B7B00AD848400187B9400188C9C00298C9C0029949C002994A500B5A5
              A500218CAD00089CAD0021A5AD0021ADAD009CA5B5007BB5B500089CBD00219C
              BD0021B5BD00089CC60008BDC60010A5CE0018B5CE0008BDD60000B5DE0008B5
              DE0010B5DE0008DEDE0000BDE70008BDE70000C6E70008C6E70018C6E70008CE
              E70052CEE70000D6E70000DEE70018E7E70000BDEF0000C6EF0000CEEF0000D6
              EF0018D6EF0000DEEF0008DEEF0063DEEF0000E7EF0008E7EF0010E7EF004AE7
              EF0063E7EF0000EFEF004AEFEF0000C6F70000CEF7006BDEF70000E7F70094E7
              F7009CE7F70000EFF70008F7F70010F7F700FF00FF0000D6FF0000DEFF0008DE
              FF0000E7FF0008E7FF0000EFFF0008EFFF0010EFFF0000F7FF0008F7FF0010F7
              FF0018F7FF0000FFFF0008FFFF0010FFFF0018FFFF0031FFFF0052FFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF006464646464646464646464646464646464646464646464646464642F1F1A
              1D1D1D1D1D1D1D1D1D1D1D1D1D1D161B64646464483B36363636363636393636
              36363636363930081B6464483F3E42424242424D3F37404C4242424242425B26
              10646453434D655C5C5C654E0F073446655C5C5C655C5C2429646464464D6765
              656565440104093C656565656C65431364646464534467676565654F12000E47
              656565676C5C2C276464646464464E69666565665E495E666565667067451C64
              64646464645D4E6769666666662A666666666970662E2964646464646464504F
              6C666666490B4F68666670674F1964646464646464645344676966683A063D6A
              666C6C662C28646464646464646464474F6B686A310C2B6A686F694715646464
              6464646464646453496B6B61230A26616B70682D286464646464646464646464
              505E6E540F0311496F6C5418646464646464646464646464585162410102053A
              706A322264646464646464646464646464526141000204386E52176464646464
              64646464646464646457515514010D4B6D332164646464646464646464646464
              646456616E4A746E551E6464646464646464646464646464646458546E72746D
              382064646464646464646464646464646464644B627573611E64646464646464
              64646464646464646464645A5975713825646464646464646464646464646464
              64646464636E6335646464646464646464646464646464646464646453765364
              6464646464646464646464646464646464646464645364646464646464646464
              6464}
            Transparent = True
          end
          object Lbl_Warnings: TLabel
            Left = 30
            Top = 0
            Width = 170
            Height = 24
            AutoSize = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            Transparent = True
            WordWrap = True
          end
        end
      end
      object PnlLibraryMetadata: TPanel
        Left = 0
        Top = 145
        Width = 591
        Height = 326
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object GrpBox_MetaDataLibrary: TGroupBox
          Left = 0
          Top = 0
          Width = 591
          Height = 326
          Align = alClient
          Caption = 'Metadata overview'
          DoubleBuffered = False
          ParentDoubleBuffered = False
          TabOrder = 0
          object pnlExtendedTags: TPanel
            Left = 409
            Top = 15
            Width = 180
            Height = 309
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 1
            DesignSize = (
              180
              309)
            object lblExtendedTags: TLabel
              Left = 6
              Top = 8
              Width = 80
              Height = 13
              AutoSize = False
              Caption = 'Extended tags'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              ShowAccelChar = False
              Transparent = True
            end
            object lb_Tags: TListBox
              AlignWithMargins = True
              Left = 6
              Top = 27
              Width = 159
              Height = 268
              Anchors = [akLeft, akTop, akRight, akBottom]
              ItemHeight = 13
              PopupMenu = PM_EditExtendedTags
              TabOrder = 0
              OnDblClick = lb_TagsDblClick
            end
          end
          object pnlMetadataOverview: TPanel
            Left = 2
            Top = 15
            Width = 407
            Height = 309
            Align = alLeft
            BevelOuter = bvNone
            TabOrder = 0
            object IMG_LibraryRating: TImage
              Left = 96
              Top = 222
              Width = 70
              Height = 14
              ParentShowHint = False
              ShowHint = False
              Transparent = True
              OnMouseDown = IMG_LibraryRatingMouseDown
              OnMouseLeave = IMG_LibraryRatingMouseLeave
              OnMouseMove = IMG_LibraryRatingMouseMove
            end
            object lblAlbumArtist: TLabel
              Left = 14
              Top = 123
              Width = 80
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Album-Artist'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              ShowAccelChar = False
              Transparent = True
            end
            object lblComposer: TLabel
              Left = 14
              Top = 147
              Width = 80
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Composer'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              ShowAccelChar = False
              Transparent = True
            end
            object LblConst_Album: TLabel
              Left = 12
              Top = 75
              Width = 80
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Album'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              ShowAccelChar = False
              Transparent = True
            end
            object LblConst_Artist: TLabel
              Left = 10
              Top = 29
              Width = 80
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Artist'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              ShowAccelChar = False
              Transparent = True
            end
            object LblConst_CD: TLabel
              Left = 171
              Top = 195
              Width = 14
              Height = 13
              Alignment = taRightJustify
              Caption = 'CD'
            end
            object LblConst_Comment: TLabel
              Left = 14
              Top = 99
              Width = 80
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Comment'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              ShowAccelChar = False
              Transparent = True
            end
            object LblConst_Genre: TLabel
              Left = 10
              Top = 171
              Width = 80
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Genre'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              ShowAccelChar = False
              Transparent = True
            end
            object LblConst_Rating: TLabel
              Left = 8
              Top = 222
              Width = 80
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Rating'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object lblConst_ReplayGain: TLabel
              Left = 12
              Top = 242
              Width = 80
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'ReplayGain'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object LblConst_Title: TLabel
              Left = 12
              Top = 51
              Width = 80
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Title'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              ShowAccelChar = False
              Transparent = True
            end
            object LblConst_Track: TLabel
              Left = 62
              Top = 195
              Width = 30
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Track'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              ShowAccelChar = False
              Transparent = True
            end
            object LblConst_Year: TLabel
              Left = 289
              Top = 171
              Width = 48
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Year'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              ShowAccelChar = False
              Transparent = True
            end
            object LblPlayCounter: TLabel
              Left = 179
              Top = 222
              Width = 12
              Height = 13
              Caption = '...'
            end
            object LblReplayGainAlbum: TLabel
              Left = 96
              Top = 261
              Width = 12
              Height = 13
              Caption = '...'
              ParentShowHint = False
              ShowAccelChar = False
              ShowHint = True
              Transparent = True
              OnClick = LBLPfadClick
            end
            object LblReplayGainTitle: TLabel
              Left = 96
              Top = 242
              Width = 12
              Height = 13
              Caption = '...'
              ParentShowHint = False
              ShowAccelChar = False
              ShowHint = True
              Transparent = True
              OnClick = LBLPfadClick
            end
            object CB_LibraryGenre: TComboBox
              Left = 96
              Top = 168
              Width = 146
              Height = 21
              AutoComplete = False
              Sorted = True
              TabOrder = 6
              OnChange = EditLibraryChange
              OnExit = Edit_LibraryExit
            end
            object Edit_LibraryAlbum: TEdit
              Left = 96
              Top = 72
              Width = 300
              Height = 21
              TabOrder = 2
              OnChange = EditLibraryChange
              OnExit = Edit_LibraryExit
            end
            object Edit_LibraryArtist: TEdit
              Left = 96
              Top = 24
              Width = 300
              Height = 21
              TabOrder = 0
              OnChange = EditLibraryChange
              OnExit = Edit_LibraryExit
            end
            object Edit_LibraryCD: TEdit
              Left = 191
              Top = 192
              Width = 51
              Height = 21
              TabOrder = 9
              OnChange = Edit_LibraryYearChange
              OnExit = Edit_LibraryExit
            end
            object Edit_LibraryComment: TEdit
              Left = 96
              Top = 96
              Width = 300
              Height = 21
              TabOrder = 3
              OnChange = EditLibraryChange
              OnExit = Edit_LibraryExit
            end
            object Edit_LibraryTitle: TEdit
              Left = 96
              Top = 48
              Width = 300
              Height = 21
              TabOrder = 1
              OnChange = EditLibraryChange
              OnExit = Edit_LibraryExit
            end
            object Edit_LibraryTrack: TEdit
              Left = 96
              Top = 192
              Width = 51
              Height = 21
              TabOrder = 8
              OnChange = Edit_LibraryTrackChange
              OnExit = Edit_LibraryExit
            end
            object Edit_LibraryYear: TEdit
              Left = 345
              Top = 168
              Width = 51
              Height = 21
              NumbersOnly = True
              TabOrder = 7
              OnChange = Edit_LibraryYearChange
              OnExit = Edit_LibraryExit
            end
            object Edit_LibraryAlbumArtist: TEdit
              Left = 96
              Top = 120
              Width = 300
              Height = 21
              TabOrder = 4
              OnChange = EditLibraryChange
              OnExit = Edit_LibraryExit
            end
            object Edit_LibraryComposer: TEdit
              Left = 96
              Top = 144
              Width = 300
              Height = 21
              TabOrder = 5
              OnChange = EditLibraryChange
              OnExit = Edit_LibraryExit
            end
          end
        end
      end
    end
    object Tab_Lyrics: TTabSheet
      Caption = 'Lyrics'
      ImageIndex = 2
      object GrpBox_Lyrics: TGroupBox
        Left = 0
        Top = 0
        Width = 595
        Height = 472
        Align = alClient
        Caption = 'Lyrics'
        TabOrder = 0
        object Memo_Lyrics: TMemo
          AlignWithMargins = True
          Left = 5
          Top = 18
          Width = 585
          Height = 410
          Align = alClient
          ScrollBars = ssVertical
          TabOrder = 0
          OnChange = Memo_LyricsChange
          OnExit = Memo_LyricsExit
          OnKeyDown = Memo_LyricsKeyDown
        end
        object pnlSearchLyrics: TPanel
          AlignWithMargins = True
          Left = 5
          Top = 434
          Width = 585
          Height = 33
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 1
          object lblLyricSearchEngines: TLabel
            AlignWithMargins = True
            Left = 8
            Top = 3
            Width = 413
            Height = 27
            Margins.Left = 8
            Margins.Right = 8
            Align = alClient
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Search Lyrics'
            Layout = tlCenter
            ExplicitLeft = 3
            ExplicitTop = 5
            ExplicitWidth = 444
            ExplicitHeight = 13
          end
          object btnSearchLyrics: TButton
            AlignWithMargins = True
            Left = 433
            Top = 4
            Width = 144
            Height = 25
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 8
            Margins.Bottom = 4
            Align = alRight
            Caption = 'Search Lyrics'
            DropDownMenu = PM_SearchEngines
            Style = bsSplitButton
            TabOrder = 0
            OnClick = btnSearchLyricsClick
          end
        end
      end
    end
    object Tab_Pictures: TTabSheet
      Caption = 'Pictures (cover art)'
      ImageIndex = 3
      PopupMenu = PM_CoverArt
      object PanelCoverArtFile: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 341
        Height = 465
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object gpBoxExistingCoverArt: TGroupBox
          Left = 0
          Top = 0
          Width = 341
          Height = 465
          Align = alClient
          Caption = 'Cover art (meta data and image files)'
          TabOrder = 0
          DesignSize = (
            341
            465)
          object lblCoverInfo: TLabel
            Left = 16
            Top = 430
            Width = 12
            Height = 13
            Caption = '...'
          end
          object VSTCover: TVirtualStringTree
            Left = 16
            Top = 19
            Width = 303
            Height = 94
            Anchors = [akLeft, akRight, akBottom]
            Colors.UnfocusedSelectionColor = clHighlight
            Colors.UnfocusedSelectionBorderColor = clHighlight
            Header.AutoSizeIndex = 0
            Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs]
            Images = imgListCovertypes
            Indent = 4
            TabOrder = 0
            TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
            TreeOptions.SelectionOptions = [toFullRowSelect]
            OnFocusChanged = VSTCoverFocusChanged
            OnFreeNode = VSTCoverFreeNode
            OnGetText = VSTCoverGetText
            OnPaintText = VSTCoverPaintText
            OnGetImageIndex = VSTCoverGetImageIndex
            Touch.InteractiveGestures = [igPan, igPressAndTap]
            Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
            ExplicitTop = 20
            ExplicitWidth = 307
            Columns = <
              item
                Position = 0
                Width = 307
              end>
          end
          object pnlCoverCurrentSelection: TPanel
            Left = 16
            Top = 124
            Width = 323
            Height = 300
            BevelKind = bkFlat
            BevelOuter = bvNone
            TabOrder = 1
            object ImgCurrentSelection: TImage
              Left = 0
              Top = 0
              Width = 319
              Height = 296
              Align = alClient
              Center = True
              Proportional = True
              Stretch = True
              OnDblClick = ImgCurrentSelectionDblClick
              ExplicitLeft = 33
              ExplicitTop = 24
              ExplicitWidth = 263
              ExplicitHeight = 127
            end
          end
        end
      end
      object GrpBox_CoverLibrary: TGroupBox
        AlignWithMargins = True
        Left = 350
        Top = 3
        Width = 238
        Height = 465
        Align = alRight
        Caption = 'Cover art for the Media library'
        TabOrder = 1
        DesignSize = (
          238
          465)
        object CoverLibrary2: TImage
          AlignWithMargins = True
          Left = 19
          Top = 126
          Width = 201
          Height = 197
          Hint = 'The current cover art used in the media library'
          Center = True
          ParentShowHint = False
          Proportional = True
          ShowHint = True
          Stretch = True
        end
        object lblChangeCoverArt: TLabel
          Left = 19
          Top = 330
          Width = 98
          Height = 13
          Caption = 'Apply changes to ...'
        end
        object cbChangeCoverArt: TComboBox
          Left = 19
          Top = 350
          Width = 201
          Height = 21
          Style = csDropDownList
          Anchors = [akTop, akRight]
          ItemIndex = 0
          TabOrder = 0
          Text = 'this file only'
          Items.Strings = (
            'this file only'
            'all files with this cover art'
            'all files in the same directory')
        end
      end
    end
    object Tab_MetaData: TTabSheet
      Caption = 'Metadata structure'
      ImageIndex = 1
      PopupMenu = PM_TagStructure
      object GrpBox_TextFrames: TGroupBox
        Left = 0
        Top = 0
        Width = 591
        Height = 282
        Align = alClient
        Caption = 'Metadata frames'
        TabOrder = 0
        ExplicitWidth = 595
        ExplicitHeight = 283
        object VST_MetaData: TVirtualStringTree
          Left = 2
          Top = 15
          Width = 591
          Height = 266
          Align = alClient
          BorderStyle = bsNone
          BorderWidth = 1
          Colors.UnfocusedSelectionColor = clHighlight
          Colors.UnfocusedSelectionBorderColor = clHighlight
          Header.AutoSizeIndex = 3
          Header.MainColumn = 3
          Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoVisible]
          Indent = 0
          TabOrder = 0
          TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toWheelPanning, toEditOnClick, toEditOnDblClick]
          TreeOptions.PaintOptions = [toShowBackground, toShowRoot, toThemeAware, toUseBlendedImages]
          TreeOptions.SelectionOptions = [toFullRowSelect]
          OnCompareNodes = VST_MetaDataCompareNodes
          OnEditing = VST_MetaDataEditing
          OnFreeNode = VST_MetaDataFreeNode
          OnGetText = VST_MetaDataGetText
          OnPaintText = VST_MetaDataPaintText
          OnNewText = VST_MetaDataNewText
          Touch.InteractiveGestures = [igPan, igPressAndTap]
          Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
          Columns = <
            item
              Position = 0
              Text = 'Type'
              Width = 59
            end
            item
              Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coStyleColor]
              Position = 1
              Text = 'Key'
              Width = 56
            end
            item
              Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coStyleColor]
              Position = 2
              Text = 'Description'
              Width = 105
            end
            item
              Position = 3
              Text = 'Value'
              Width = 371
            end>
        end
      end
      object Pnl_ID3v1_MPEG: TPanel
        Left = 0
        Top = 282
        Width = 591
        Height = 189
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        object GrpBox_ID3v1: TGroupBox
          Left = 0
          Top = 0
          Width = 353
          Height = 189
          Align = alLeft
          Caption = 'ID3 v1'
          TabOrder = 0
          object LblConst_ID3v1Artist: TLabel
            Left = 8
            Top = 27
            Width = 83
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Artist'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ShowAccelChar = False
            Transparent = True
          end
          object LblConst_ID3v1Title: TLabel
            Left = 8
            Top = 51
            Width = 83
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Title'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ShowAccelChar = False
            Transparent = True
          end
          object LblConst_ID3v1Album: TLabel
            Left = 8
            Top = 73
            Width = 83
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Album'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ShowAccelChar = False
            Transparent = True
          end
          object LblConst_ID3v1Year: TLabel
            Left = 256
            Top = 119
            Width = 43
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Year'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ShowAccelChar = False
            Transparent = True
          end
          object LblConst_ID3v1Genre: TLabel
            Left = 8
            Top = 114
            Width = 83
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Genre'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ShowAccelChar = False
            Transparent = True
          end
          object LblConst_ID3v1Comment: TLabel
            Left = 8
            Top = 95
            Width = 83
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Comment'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ShowAccelChar = False
            Transparent = True
          end
          object LblConst_ID3v1Track: TLabel
            Left = 269
            Top = 95
            Width = 30
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Track'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ShowAccelChar = False
            Transparent = True
          end
          object Lblv1Album: TEdit
            Tag = 3
            Left = 96
            Top = 70
            Width = 250
            Height = 21
            TabOrder = 2
            OnChange = edtID3v1Change
            OnExit = edtID3v1Exit
          end
          object Lblv1Artist: TEdit
            Tag = 1
            Left = 96
            Top = 24
            Width = 250
            Height = 21
            TabOrder = 0
            OnChange = edtID3v1Change
            OnExit = edtID3v1Exit
          end
          object Lblv1Titel: TEdit
            Tag = 2
            Left = 97
            Top = 46
            Width = 250
            Height = 21
            TabOrder = 1
            OnChange = edtID3v1Change
            OnExit = edtID3v1Exit
          end
          object Lblv1Year: TEdit
            Tag = 7
            Left = 305
            Top = 114
            Width = 41
            Height = 21
            NumbersOnly = True
            TabOrder = 6
            OnChange = Lblv1YearChange
            OnExit = edtID3v1Exit
          end
          object Lblv1Comment: TEdit
            Tag = 4
            Left = 96
            Top = 92
            Width = 154
            Height = 21
            TabOrder = 3
            OnChange = edtID3v1Change
            OnExit = edtID3v1Exit
          end
          object Lblv1Track: TEdit
            Tag = 5
            Left = 305
            Top = 92
            Width = 41
            Height = 21
            NumbersOnly = True
            TabOrder = 4
            OnChange = Lblv1TrackChange
            OnExit = edtID3v1Exit
          end
          object cbIDv1Genres: TComboBox
            Tag = 6
            Left = 97
            Top = 119
            Width = 154
            Height = 21
            AutoCloseUp = True
            Style = csDropDownList
            Sorted = True
            TabOrder = 5
            OnChange = cbIDv1GenresChange
          end
        end
        object GrpBox_Mpeg: TGroupBox
          Left = 353
          Top = 0
          Width = 238
          Height = 189
          Align = alRight
          Caption = 'MPEG'
          TabOrder = 1
          ExplicitLeft = 357
          object LblConst_MpegBitrate: TLabel
            Left = 8
            Top = 48
            Width = 82
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Bitrate'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ShowAccelChar = False
            Transparent = True
          end
          object LblConst_MpegSamplerate: TLabel
            Left = 8
            Top = 64
            Width = 82
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Samplerate'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ShowAccelChar = False
            Transparent = True
          end
          object LblConst_MpegOriginal: TLabel
            Left = 8
            Top = 147
            Width = 82
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Original'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ShowAccelChar = False
            Transparent = True
          end
          object LblConst_MpegEmphasis: TLabel
            Left = 8
            Top = 163
            Width = 82
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Emphasis'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ShowAccelChar = False
            Transparent = True
          end
          object LblConst_MpegVersion: TLabel
            Left = 8
            Top = 16
            Width = 82
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Version'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ShowAccelChar = False
            Transparent = True
          end
          object LblConst_MpegCopyright: TLabel
            Left = 8
            Top = 131
            Width = 82
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Copyright'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ShowAccelChar = False
            Transparent = True
          end
          object LblConst_MpegProtection: TLabel
            Left = 8
            Top = 99
            Width = 82
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Protection'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ShowAccelChar = False
            Transparent = True
          end
          object LblConst_MpegHeader: TLabel
            Left = 8
            Top = 32
            Width = 82
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Header at '
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ShowAccelChar = False
            Transparent = True
          end
          object LblConst_MpegExtension: TLabel
            Left = 8
            Top = 115
            Width = 82
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Extension'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ShowAccelChar = False
            Transparent = True
          end
          object LblConst_MpegDuration: TLabel
            Left = 8
            Top = 80
            Width = 82
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Duration'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ShowAccelChar = False
            Transparent = True
          end
          object LblDETBitrate: TLabel
            Left = 100
            Top = 48
            Width = 12
            Height = 13
            Caption = '...'
            ShowAccelChar = False
            Transparent = True
          end
          object LblDETSamplerate: TLabel
            Left = 100
            Top = 64
            Width = 12
            Height = 13
            Caption = '...'
            ShowAccelChar = False
            Transparent = True
          end
          object LblDETDauer: TLabel
            Left = 100
            Top = 80
            Width = 12
            Height = 13
            Caption = '...'
            ShowAccelChar = False
            Transparent = True
          end
          object LblDETVersion: TLabel
            Left = 100
            Top = 16
            Width = 12
            Height = 13
            Caption = '...'
            ShowAccelChar = False
            Transparent = True
          end
          object LblDETHeaderAt: TLabel
            Left = 100
            Top = 32
            Width = 12
            Height = 13
            Caption = '...'
            ShowAccelChar = False
            Transparent = True
          end
          object LblDETProtection: TLabel
            Left = 100
            Top = 99
            Width = 12
            Height = 13
            Caption = '...'
            ShowAccelChar = False
            Transparent = True
          end
          object LblDETExtension: TLabel
            Left = 100
            Top = 115
            Width = 12
            Height = 13
            Caption = '...'
            ShowAccelChar = False
            Transparent = True
          end
          object LblDETCopyright: TLabel
            Left = 100
            Top = 131
            Width = 12
            Height = 13
            Caption = '...'
            ShowAccelChar = False
            Transparent = True
          end
          object LblDETOriginal: TLabel
            Left = 100
            Top = 147
            Width = 12
            Height = 13
            Caption = '...'
            ShowAccelChar = False
            Transparent = True
          end
          object LblDETEmphasis: TLabel
            Left = 100
            Top = 163
            Width = 12
            Height = 13
            Caption = '...'
            ShowAccelChar = False
            Transparent = True
          end
        end
      end
    end
  end
  object pnlButtons: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 508
    Width = 599
    Height = 30
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      599
      30)
    object Btn_Close: TButton
      Left = 350
      Top = 0
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 0
      OnClick = Btn_CloseClick
    end
    object BtnUndo: TButton
      Left = 431
      Top = 0
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Undo'
      TabOrder = 1
      OnClick = BtnUndoClick
    end
    object BtnApply: TButton
      Left = 512
      Top = 0
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Apply'
      TabOrder = 2
      OnClick = BtnApplyClick
    end
    object BtnRefreshCoverflow: TButton
      Left = 177
      Top = 0
      Width = 157
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Refresh Coverflow'
      TabOrder = 3
      Visible = False
      OnClick = BtnRefreshCoverflowClick
    end
    object cbQuickRefresh: TCheckBox
      Left = 12
      Top = 0
      Width = 167
      Height = 17
      Hint = 
        'Refresh this form whenever you select another file in the main w' +
        'indow.'
      Caption = 'Quick refresh'
      TabOrder = 4
      OnClick = cbQuickRefreshClick
    end
  end
  object PM_URLCopy: TPopupMenu
    Left = 144
    Top = 115
    object PM_CopyURLToClipboard: TMenuItem
      Caption = 'Copy URL to clipboard'
      OnClick = PM_CopyURLToClipboardClick
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'jpg'
    Filter = 'Supported files (*.jpg;*.jpeg;*.png)|*.jpg;*.jpeg;*.png;'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 508
    Top = 96
  end
  object ReloadTimer: TTimer
    Enabled = False
    Interval = 50
    OnTimer = ReloadTimerTimer
    Left = 320
    Top = 40
  end
  object PM_EditExtendedTags: TPopupMenu
    Left = 48
    Top = 163
    object pm_AddTag: TMenuItem
      Action = ActionTagAdd
    end
    object pm_RenameTag: TMenuItem
      Action = ActionTagRename
    end
    object pm_RemoveTag: TMenuItem
      Action = ActionTagRemove
    end
    object Getextendedtagsfromlastfm1: TMenuItem
      Action = ActionTagGetLastFM
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Opencloudeditor1: TMenuItem
      Action = ActionTagOpenCloudEditor
    end
  end
  object OpenDlgCoverArt: TOpenPictureDialog
    Filter = 
      'Supported files (*.jpg;*.jpeg;*.png;*.bmp)|*.jpg;*.jpeg;*.png;*.' +
      'bmp'
    Left = 504
    Top = 40
  end
  object PM_SearchEngines: TPopupMenu
    Left = 47
    Top = 210
  end
  object MainMenu1: TMainMenu
    Left = 144
    Top = 67
    object mmFile: TMenuItem
      Caption = 'File'
      OnClick = mmFileClick
      object mmShowInExplorer: TMenuItem
        Action = ActionShowInExplorer
      end
      object mmWindowsProperties: TMenuItem
        Action = ActionWindowsProperties
      end
      object mmResetRating: TMenuItem
        Action = ActionResetRating
      end
      object mmSynchronizeRating: TMenuItem
        Action = ActionSynchronizeRating
      end
      object mmRefresh: TMenuItem
        Action = ActionRefreshFile
      end
    end
    object mmExtendedTags: TMenuItem
      Caption = 'Extended tags'
      OnClick = mmExtendedTagsClick
      object mmAddTag: TMenuItem
        Action = ActionTagAdd
      end
      object mmEditTag: TMenuItem
        Action = ActionTagRename
      end
      object mmRemoveTag: TMenuItem
        Action = ActionTagRemove
      end
      object mmGetExtendedTagsFromLastFM: TMenuItem
        Action = ActionTagGetLastFM
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mmOpenCloudEditor: TMenuItem
        Action = ActionTagOpenCloudEditor
      end
    end
    object mmLyrics: TMenuItem
      Caption = 'Lyrics'
      OnClick = mmLyricsClick
    end
    object mmCoverArt: TMenuItem
      Caption = 'Cover art'
      OnClick = PM_CoverArtPopup
      object mmAddCoverToMetadata: TMenuItem
        Action = ActionCoverNewMetaData
      end
      object mmCoverDelete: TMenuItem
        Action = ActionCoverDeleteMetaData
      end
      object mmCoverSaveToFile: TMenuItem
        Action = ActionCoverMetaDataSaveToFile
      end
      object mmOpenSelectedFile: TMenuItem
        Action = ActionCoverMetaDataOpenFile
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object mmCoverUseSelectedForLibrary: TMenuItem
        Action = ActionCoverUseCurrentSelectionForMediaLibrary
      end
      object mmCoverLoadLibrary: TMenuItem
        Action = ActionCoverLoadLibrary
      end
      object mmCoverReset: TMenuItem
        Action = ActionCoverResetMediaLibrary
      end
    end
    object mmMetaData: TMenuItem
      Caption = 'Metadata structure'
      OnClick = mmMetaDataClick
      object mmNewDataFrame: TMenuItem
        Action = ActionMetaNewFrame
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object mmCopyfromID3v1: TMenuItem
        Action = ActionMetaCopyFromID3v1
      end
      object mmCopyfromID3v2: TMenuItem
        Action = ActionMetaCopyFromID3v2
      end
    end
  end
  object imgListCovertypes: TImageList
    ColorDepth = cd32Bit
    DrawingStyle = dsTransparent
    Left = 509
    Top = 158
    Bitmap = {
      494C010102000800040010001000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F8F8F8FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBF9F9FFFBF9F9FFFBF9F9FFFBF9
      F9FFFBF9F9FFFBF9F9FFFBF9F9FFFBF9F9FFFBF9F9FFFBF9F9FFFBF9F9FFFBF9
      F9FFFBF9F9FFFBF9F9FFFBF9F9FFFBF9F9FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F9F9F9FFC8C5C3FFC1C3BEFFB9C0
      B9FFBABCBBFFC7C7C6FFD9DAD6FFD7D6D6FFD7D4D5FFD7D4D4FFDAD8D9FFDEDD
      DEFFE4E3E3FFD3D8D6FFC5CECBFFFFFFFFFFFBF9F9FF34544DFF41524EFF3454
      4DFF698F83FF8AA79FFF475750FF405650FF507063FF537D77FF6F9296FF779A
      9AFF416762FF29423FFF29423FFFFBF9F9FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FAFAFAFFE1E1E1FFDFDFDFFFDEDE
      DEFFE4E4E4FFE6E6E7FFE5E5E6FFDBDBDCFFD8D8D9FFDCDDDEFFDEDFE0FFDFE1
      E1FFE0E1E1FFDCDAD8FFD8D4D2FFFFFFFFFFFBF9F9FF29423FFF29423FFF4167
      62FF779A9AFF6F9296FF537D77FF507063FF405650FF475750FF8AA79FFF698F
      83FF34544DFF41524EFF34544DFFFBF9F9FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FBFBFBFFCFD0D0FFCFCFD0FFCFCE
      D0FFCFCCD0FFD4D2D6FFE0DFE1FFECEBECFFEEEEEEFF543732FF3B0D00FF3C27
      1CFF320E00FF47200CFF531F00FFFFFFFFFFFBF9F9FF845F55FF845F55FF543E
      37FF271A1EFF311B11FF50363EFF727585FF4F464CFF352130FF2B2233FF664F
      73FF3E3039FF5C4C61FF3E3039FFFBF9F9FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FDFDFDFFCCCCC9FFCBCBC9FFC9C9
      C9FFC7C7C9FFCECED0FFDFDFE0FFF0F0F0FFF3F3F3FFB6A195FF936F5BFF7E65
      5AFF8B614AFFA98263FFBC987CFFFFFFFFFFFBF9F9FFFFEFC3FFFFEFC3FFFFF1
      BEFF9392A6FF5F6480FF554F4DFF2A373FFF000000FF201601FF6E665DFF524D
      72FF575889FF3F446AFF575889FFFBF9F9FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FEFEFEFFE1E1E1FFE0E0E0FFDEDE
      DEFFDCDCDCFFDFE0E0FFE7E8E8FFEFF0F0FFF1F2F2FFE8D5B6FFE5CBACFFB592
      7BFFAB7E5EFFCDAC8EFFD2B8A5FFFFFFFFFFFBF9F9FFFEC593FFFEC593FFFFD7
      9DFFFFE0A3FF6F7095FF7387BBFF886462FFFFD995FFFFF6BCFFFFFBB9FFFFD6
      99FFB69A75FF4B4339FFB69A75FFFBF9F9FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFD0D1D1FFCFD0D0FFCCCB
      CCFFC8C6C8FFCECCCEFFDDDCDDFFECECECFFEFEFEFFFF8E0B8FFF8E0B6FFF6E5
      CAFFF8DEB5FFF9E0B7FFF9E1B9FFFFFFFFFFFBF9F9FFF8BA84FFF8BA84FFF8BB
      87FFFFCA87FFF6C091FF46527CFFE0A070FFFFE3A2FFFFC28DFFFDBE8CFFFFCD
      95FFFFE09FFFFFDE98FFFFE09FFFFBF9F9FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFE9E9E9FFE7E7E7FFE7E7
      E7FFF1F1F1FFF3F3F1FFF2F0EDFFF6F3EEFFF7F4EFFFF7F4EFFFF7F4F1FFF7F5
      F2FFF7F5F2FFF9F8F6FFFCFBF9FFFFFFFFFFFBF9F9FFF0AC72FFF0AC72FFF0B2
      78FFF0B077FFFFBA78FFFFBD7AFFFFBD81FFF1AF77FFF2B37CFFEFB47DFFF2B4
      7DFFF3B47EFFF6B279FFF3B47EFFFBF9F9FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFD1CECEFFCDCBC9FFC8C8
      C4FFC7C6C7FFD3D2D5FFE7E7E8FFE8E8E9FFE9E9EAFFEBEBEBFFEEEEEEFFF1F1
      F1FFF4F4F4FFF2F2F2FFF1F1F1FFFFFFFFFFFBF9F9FFE79E66FFE79E66FFEAA4
      6AFFEAA46CFFE9A36BFFF0A86DFFEAA46CFFEAA46EFFEAA66CFFECA970FFECA7
      71FFEDAB70FFECA56AFFEDAB70FFFBF9F9FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFEAEAEAFFE8E8E8FFE7E7
      E7FFE9E9E9FFEDEDEDFFF0F0F0FFEEEEEEFFEDEDEDFFEDEDEDFFEFEFEFFFF1F1
      F1FFF4F4F4FFEFEFEFFFEBEBEBFFFFFFFFFFFBF9F9FFDD925CFFDD925CFFE097
      63FFE19761FFDF9763FFDF9762FFDF9764FFDF9965FFE09864FFE19966FFE29A
      65FFE49D67FFE09561FFE49D67FFFBF9F9FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFDAE0DEFFD9DAD9FFD6D1
      D1FFC4C5C4FFC9CBCAFFDDDCDCFFCFCFD0FFC5C7C8FFC0C5C3FFC7C8C9FFD0CE
      D0FFDBD9D8FFC4C6C5FFB0B4B4FFFFFFFFFFFBF9F9FFDD925CFFDD925CFFE097
      63FFE19761FFDF9763FFDF9762FFDF9764FFDF9965FFE09864FFE19966FFE29A
      65FFE49D67FFE09561FFE49D67FFFBF9F9FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBF9F9FFFBF9F9FFFBF9F9FFFBF9
      F9FFFBF9F9FFFBF9F9FFFBF9F9FFFBF9F9FFFBF9F9FFFBF9F9FFFBF9F9FFFBF9
      F9FFFBF9F9FFFBF9F9FFFBF9F9FFFBF9F9FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
  object ActionList1: TActionList
    Left = 227
    Top = 67
    object ActionShowInExplorer: TAction
      Category = 'File'
      Caption = 'Show in Explorer'
      OnExecute = ActionShowInExplorerExecute
    end
    object ActionWindowsProperties: TAction
      Category = 'File'
      Caption = 'Windows properties'
      OnExecute = ActionWindowsPropertiesExecute
    end
    object ActionResetRating: TAction
      Category = 'File'
      Caption = 'Reset rating and play counter'
      OnExecute = ActionResetRatingExecute
    end
    object ActionSynchronizeRating: TAction
      Category = 'File'
      Caption = 'Synchronize rating'
      OnExecute = ActionSynchronizeRatingExecute
    end
    object ActionRefreshFile: TAction
      Category = 'File'
      Caption = 'Refresh'
      OnExecute = ActionRefreshFileExecute
    end
    object ActionTagAdd: TAction
      Category = 'ExtendedTags'
      Caption = 'Add tag'
      OnExecute = ActionTagAddExecute
    end
    object ActionTagRename: TAction
      Category = 'ExtendedTags'
      Caption = 'Edit tag'
      OnExecute = ActionTagRenameExecute
    end
    object ActionTagRemove: TAction
      Category = 'ExtendedTags'
      Caption = 'Remove tag'
      OnExecute = ActionTagRemoveExecute
    end
    object ActionTagGetLastFM: TAction
      Category = 'ExtendedTags'
      Caption = 'Get extended tags from last.fm'
      OnExecute = ActionTagGetLastFMExecute
    end
    object ActionTagOpenCloudEditor: TAction
      Category = 'ExtendedTags'
      Caption = 'Open cloud editor'
      OnExecute = ActionTagOpenCloudEditorExecute
    end
    object ActionCoverNewMetaData: TAction
      Category = 'Cover'
      Caption = 'Add cover to metadata'
      OnExecute = ActionCoverNewMetaDataExecute
    end
    object ActionCoverDeleteMetaData: TAction
      Category = 'Cover'
      Caption = 'Delete selected cover from metadata'
      OnExecute = ActionCoverDeleteMetaDataExecute
    end
    object ActionCoverMetaDataSaveToFile: TAction
      Category = 'Cover'
      Caption = 'Save selected cover to file'
      OnExecute = ActionCoverMetaDataSaveToFileExecute
    end
    object ActionCoverMetaDataOpenFile: TAction
      Category = 'Cover'
      Caption = 'Open selected image file'
      OnExecute = ActionCoverMetaDataOpenFileExecute
    end
    object ActionCoverLoadLibrary: TAction
      Category = 'Cover'
      Caption = 'Load cover for Media library'
      OnExecute = ActionCoverLoadLibraryExecute
    end
    object ActionCoverUseCurrentSelectionForMediaLibrary: TAction
      Category = 'Cover'
      Caption = 'Use selected cover for Media library'
      OnExecute = ActionCoverUseCurrentSelectionForMediaLibraryExecute
    end
    object ActionCoverResetMediaLibrary: TAction
      Category = 'Cover'
      Caption = 'Reset cover in Media library'
      OnExecute = ActionCoverResetMediaLibraryExecute
    end
    object ActionMetaNewFrame: TAction
      Category = 'MetaData Structure'
      Caption = 'New data frame'
      OnExecute = ActionMetaNewFrameExecute
    end
    object ActionMetaCopyFromID3v1: TAction
      Category = 'MetaData Structure'
      Caption = 'Copy ID3v2/APE from ID3v1'
      OnExecute = ActionMetaCopyFromID3v1Execute
    end
    object ActionMetaCopyFromID3v2: TAction
      Category = 'MetaData Structure'
      Caption = 'Copy ID3v1 from ID3v2/APE'
      OnExecute = ActionMetaCopyFromID3v2Execute
    end
  end
  object PM_CoverArt: TPopupMenu
    OnPopup = PM_CoverArtPopup
    Left = 47
    Top = 257
    object Addcovertometadata1: TMenuItem
      Action = ActionCoverNewMetaData
    end
    object Deleteselectedcoverfrommetadata1: TMenuItem
      Action = ActionCoverDeleteMetaData
    end
    object Saveselectedcovertofile1: TMenuItem
      Action = ActionCoverMetaDataSaveToFile
    end
    object Openselectedimagefile1: TMenuItem
      Action = ActionCoverMetaDataOpenFile
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object LoadcoverforMedialibrary1: TMenuItem
      Action = ActionCoverLoadLibrary
    end
    object UseselectedcoverforMedialibrary1: TMenuItem
      Action = ActionCoverUseCurrentSelectionForMediaLibrary
    end
    object ResetcoverinMedialibrary1: TMenuItem
      Action = ActionCoverResetMediaLibrary
    end
  end
  object PM_TagStructure: TPopupMenu
    Left = 47
    Top = 115
    object Newdataframe1: TMenuItem
      Action = ActionMetaNewFrame
    end
    object CopyID3v2APEfromID3v11: TMenuItem
      Action = ActionMetaCopyFromID3v1
    end
    object CopyID3v1fromID3v2APE1: TMenuItem
      Action = ActionMetaCopyFromID3v2
    end
  end
  object PM_FileOverview: TPopupMenu
    Left = 49
    Top = 67
    object ShowinExplorer1: TMenuItem
      Action = ActionShowInExplorer
    end
    object Windowsproperties1: TMenuItem
      Action = ActionWindowsProperties
    end
    object Resetratingandplaycounter1: TMenuItem
      Action = ActionResetRating
    end
    object Synchronizerating1: TMenuItem
      Action = ActionSynchronizeRating
    end
    object Refresh1: TMenuItem
      Action = ActionRefreshFile
    end
  end
end
