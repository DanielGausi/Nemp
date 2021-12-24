object FDetails: TFDetails
  Left = 220
  Top = 125
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'File properties'
  ClientHeight = 545
  ClientWidth = 621
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  ShowHint = True
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnHide = FormHide
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object MainPageControl: TPageControl
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 615
    Height = 503
    ActivePage = Tab_MetaData
    Align = alClient
    TabOrder = 0
    OnChange = MainPageControlChange
    OnChanging = MainPageControlChanging
    object Tab_General: TTabSheet
      Caption = 'Summary'
      DoubleBuffered = False
      ParentDoubleBuffered = False
      object GrpBox_File: TGroupBox
        Left = 0
        Top = 0
        Width = 607
        Height = 169
        Align = alTop
        Caption = 'File'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 0
        DesignSize = (
          607
          169)
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
          Width = 335
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
          Width = 335
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
          Left = 449
          Top = 13
          Width = 150
          Height = 150
          Anchors = [akTop, akRight]
          Center = True
          OnDblClick = CoverIMAGEDblClick
        end
        object Btn_Explore: TButton
          Left = 16
          Top = 131
          Width = 102
          Height = 25
          Caption = 'Explorer'
          TabOrder = 0
          OnClick = Btn_ExploreClick
        end
        object Btn_Properties: TButton
          Left = 127
          Top = 131
          Width = 102
          Height = 25
          Caption = 'Properties'
          TabOrder = 1
          OnClick = Btn_PropertiesClick
        end
        object PnlWarnung: TPanel
          Left = 235
          Top = 128
          Width = 208
          Height = 35
          BevelOuter = bvNone
          TabOrder = 2
          object Image1: TImage
            Left = 0
            Top = 4
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
            Height = 35
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
        Top = 169
        Width = 607
        Height = 306
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object GrpBox_ID3v2: TGroupBox
          Left = 0
          Top = 0
          Width = 409
          Height = 306
          Align = alLeft
          Caption = 'Metadata'
          DoubleBuffered = False
          ParentDoubleBuffered = False
          TabOrder = 0
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
          object LblConst_Year: TLabel
            Left = 291
            Top = 123
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
          object LblConst_Genre: TLabel
            Left = 11
            Top = 123
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
          object LblConst_Track: TLabel
            Left = 62
            Top = 147
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
          object LblConst_Rating: TLabel
            Left = 8
            Top = 171
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
          object IMG_LibraryRating: TImage
            Left = 96
            Top = 171
            Width = 70
            Height = 14
            ParentShowHint = False
            ShowHint = False
            Transparent = True
            OnMouseDown = IMG_LibraryRatingMouseDown
            OnMouseLeave = IMG_LibraryRatingMouseLeave
            OnMouseMove = IMG_LibraryRatingMouseMove
          end
          object LblConst_CD: TLabel
            Left = 171
            Top = 147
            Width = 14
            Height = 13
            Alignment = taRightJustify
            Caption = 'CD'
          end
          object LblPlayCounter: TLabel
            Left = 179
            Top = 171
            Width = 12
            Height = 13
            Caption = '...'
          end
          object lblConst_ReplayGain: TLabel
            Left = 12
            Top = 218
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
          object LblReplayGainTitle: TLabel
            Left = 96
            Top = 218
            Width = 12
            Height = 13
            Caption = '...'
            ParentShowHint = False
            ShowAccelChar = False
            ShowHint = True
            Transparent = True
            OnClick = LBLPfadClick
          end
          object LblReplayGainAlbum: TLabel
            Left = 96
            Top = 237
            Width = 12
            Height = 13
            Caption = '...'
            ParentShowHint = False
            ShowAccelChar = False
            ShowHint = True
            Transparent = True
            OnClick = LBLPfadClick
          end
          object Edit_LibraryArtist: TEdit
            Left = 96
            Top = 24
            Width = 300
            Height = 21
            TabOrder = 0
            OnChange = EditLibraryChange
          end
          object Edit_LibraryTitle: TEdit
            Left = 96
            Top = 48
            Width = 300
            Height = 21
            TabOrder = 1
            OnChange = EditLibraryChange
          end
          object Edit_LibraryAlbum: TEdit
            Left = 96
            Top = 72
            Width = 300
            Height = 21
            TabOrder = 2
            OnChange = EditLibraryChange
          end
          object Edit_LibraryYear: TEdit
            Left = 345
            Top = 120
            Width = 51
            Height = 21
            NumbersOnly = True
            TabOrder = 5
            OnChange = Edit_LibraryYearChange
          end
          object Edit_LibraryComment: TEdit
            Left = 96
            Top = 96
            Width = 300
            Height = 21
            TabOrder = 3
            OnChange = EditLibraryChange
          end
          object Edit_LibraryTrack: TEdit
            Left = 96
            Top = 144
            Width = 51
            Height = 21
            TabOrder = 6
            OnChange = Edit_LibraryTrackChange
          end
          object BtnResetRating: TButton
            Left = 96
            Top = 191
            Width = 102
            Height = 25
            Hint = 'Set rating and playcounter to zero'
            Caption = 'Reset'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 8
            OnClick = BtnResetRatingClick
          end
          object CB_LibraryGenre: TComboBox
            Left = 96
            Top = 120
            Width = 146
            Height = 21
            AutoComplete = False
            Sorted = True
            TabOrder = 4
            OnChange = EditLibraryChange
          end
          object BtnSynchRatingLibrary: TButton
            Left = 207
            Top = 191
            Width = 142
            Height = 25
            Hint = 
              'Synchronize rating/playcounter in the Metadata of the file with ' +
              'the rating/playcounter in the library'
            Caption = 'Synchronize rating'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 9
            OnClick = BtnSynchRatingLibraryClick
          end
          object Edit_LibraryCD: TEdit
            Left = 191
            Top = 144
            Width = 51
            Height = 21
            TabOrder = 7
            OnChange = Edit_LibraryYearChange
          end
          object Btn_Refresh: TButton
            Left = 96
            Top = 256
            Width = 102
            Height = 25
            Caption = 'Refresh'
            TabOrder = 10
            OnClick = Btn_RefreshClick
          end
          object Btn_RenameTag: TButton
            AlignWithMargins = True
            Left = 344
            Top = 275
            Width = 27
            Height = 25
            Hint = 'Edit the selected tag'
            Caption = '[...]'
            TabOrder = 11
            Visible = False
            OnClick = Btn_RenameTagClick
          end
          object Btn_RemoveTag: TButton
            AlignWithMargins = True
            Left = 377
            Top = 272
            Width = 26
            Height = 25
            Hint = 'Remove the selected tag from the file'
            Caption = '[ - ]'
            TabOrder = 12
            Visible = False
            OnClick = Btn_RemoveTagClick
          end
        end
        object GrpBox_TagCloud: TGroupBox
          Left = 409
          Top = 0
          Width = 198
          Height = 306
          Align = alClient
          Caption = 'Tag cloud'
          TabOrder = 1
          DesignSize = (
            198
            306)
          object lb_Tags: TListBox
            AlignWithMargins = True
            Left = 8
            Top = 24
            Width = 179
            Height = 206
            Anchors = [akLeft, akTop, akRight]
            ItemHeight = 13
            PopupMenu = PM_EditExtendedTags
            TabOrder = 3
            OnDblClick = lb_TagsDblClick
          end
          object Btn_GetTagsLastFM: TButton
            AlignWithMargins = True
            Left = 102
            Top = 236
            Width = 85
            Height = 25
            Hint = 'Add Tags from LastFM'
            Anchors = [akTop, akRight]
            Caption = 'LastFM'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            OnClick = Btn_GetTagsLastFMClick
          end
          object btn_AddTag: TButton
            AlignWithMargins = True
            Left = 8
            Top = 236
            Width = 85
            Height = 25
            Hint = 'Add a new tag to the file'
            Caption = '[ + ]'
            TabOrder = 0
            OnClick = btn_AddTagClick
          end
          object Btn_TagCloudEditor: TButton
            AlignWithMargins = True
            Left = 6
            Top = 265
            Width = 181
            Height = 25
            Hint = 'Open tag cloud editor'
            Anchors = [akLeft, akTop, akRight]
            Caption = 'Cloud editor'
            TabOrder = 2
            OnClick = Btn_TagCloudEditorClick
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
        Width = 607
        Height = 475
        Align = alClient
        Caption = 'Lyrics'
        TabOrder = 0
        DesignSize = (
          607
          475)
        object Btn_DeleteLyricFrame: TButton
          Left = 451
          Top = 168
          Width = 144
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Delete lyrics'
          Enabled = False
          TabOrder = 4
          OnClick = Btn_DeleteLyricFrameClick
        end
        object BtnLyricWiki: TButton
          Left = 451
          Top = 22
          Width = 144
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Get Lyrics'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = BtnLyricWikiClick
        end
        object BtnLyricWikiManual: TButton
          Left = 451
          Top = 108
          Width = 144
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Manual search'
          TabOrder = 3
          OnClick = BtnLyricWikiManualClick
        end
        object Memo_Lyrics: TMemo
          AlignWithMargins = True
          Left = 8
          Top = 24
          Width = 437
          Height = 437
          Anchors = [akLeft, akTop, akRight, akBottom]
          Enabled = False
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
          OnChange = Memo_LyricsChange
          OnKeyDown = Memo_LyricsKeyDown
        end
        object cbLyricOptions: TComboBox
          Left = 451
          Top = 81
          Width = 144
          Height = 21
          Style = csDropDownList
          Anchors = [akTop, akRight]
          ItemIndex = 0
          TabOrder = 2
          Text = 'LyricWiki'
          Items.Strings = (
            'LyricWiki'
            'ChartLyrics')
        end
      end
    end
    object Tab_Pictures: TTabSheet
      Caption = 'Pictures (cover art)'
      ImageIndex = 3
      object PanelCoverArtFile: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 333
        Height = 469
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object gpBoxCurrentSelection: TGroupBox
          Left = 0
          Top = 159
          Width = 333
          Height = 310
          Align = alClient
          Caption = 'Current selection'
          TabOrder = 1
          DesignSize = (
            333
            310)
          object ImgCurrentSelection: TImage
            Left = 16
            Top = 24
            Width = 299
            Height = 268
            Anchors = [akLeft, akTop, akRight, akBottom]
            Center = True
            Proportional = True
            Stretch = True
            ExplicitHeight = 265
          end
        end
        object PanelCoverArtSelection: TPanel
          Left = 0
          Top = 0
          Width = 333
          Height = 159
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object GrpBox_Cover: TGroupBox
            Left = 167
            Top = 0
            Width = 166
            Height = 159
            Align = alClient
            Caption = 'Existing cover art (Files)'
            TabOrder = 1
            DesignSize = (
              166
              159)
            object Btn_OpenImage: TButton
              AlignWithMargins = True
              Left = 8
              Top = 51
              Width = 150
              Height = 25
              Hint = 'Open the image with the default image viewer'
              Anchors = [akLeft, akTop, akRight]
              Caption = 'Open'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
              OnClick = Btn_OpenImageClick
            end
            object cbCoverArtFiles: TComboBox
              AlignWithMargins = True
              Left = 8
              Top = 24
              Width = 150
              Height = 21
              AutoComplete = False
              Style = csDropDownList
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 0
              OnChange = cbCoverArtFilesChange
              OnEnter = cbCoverArtFilesChange
            end
          end
          object GrpBox_Pictures: TGroupBox
            Left = 0
            Top = 0
            Width = 167
            Height = 159
            Align = alLeft
            Caption = 'Existing cover art (Metadata)'
            TabOrder = 0
            object Btn_NewPicture: TButton
              AlignWithMargins = True
              Left = 8
              Top = 51
              Width = 150
              Height = 25
              Hint = 'Add a cover art to the metadata'
              Caption = 'New'
              Enabled = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
              OnClick = Btn_NewPictureClick
            end
            object Btn_DeletePicture: TButton
              AlignWithMargins = True
              Left = 8
              Top = 81
              Width = 150
              Height = 25
              Hint = 'Remove the selected cover art from the metadata'
              Caption = 'Delete'
              Enabled = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 2
              OnClick = Btn_DeletePictureClick
            end
            object Btn_SavePictureToFile: TButton
              AlignWithMargins = True
              Left = 8
              Top = 111
              Width = 150
              Height = 25
              Hint = 'Save the selected cover at into a file'
              Caption = 'Save to file'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 3
              OnClick = Btn_SavePictureToFileClick
            end
            object cbCoverArtMetadata: TComboBox
              AlignWithMargins = True
              Left = 8
              Top = 24
              Width = 150
              Height = 21
              Style = csDropDownList
              TabOrder = 0
              OnChange = cbCoverArtMetadataChange
              OnEnter = cbCoverArtMetadataChange
            end
          end
        end
      end
      object GrpBox_CoverLibrary: TGroupBox
        AlignWithMargins = True
        Left = 342
        Top = 3
        Width = 262
        Height = 469
        Align = alRight
        Caption = 'Cover art (Media library)'
        TabOrder = 1
        DesignSize = (
          262
          469)
        object CoverLibrary2: TImage
          AlignWithMargins = True
          Left = 8
          Top = 24
          Width = 240
          Height = 240
          Hint = 'The current cover art used in the media library'
          Center = True
          ParentShowHint = False
          Proportional = True
          ShowHint = True
          Stretch = True
        end
        object BtnChangeCoverArtInLibrary: TButton
          AlignWithMargins = True
          Left = 8
          Top = 301
          Width = 241
          Height = 25
          Hint = 'Use the currently selected image as cover art'
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Use current selection'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          WordWrap = True
          OnClick = BtnUseCurrentSelectionInLibraryClick
        end
        object BtnRemoveUserCover: TButton
          AlignWithMargins = True
          Left = 8
          Top = 332
          Width = 241
          Height = 25
          Hint = 
            'Remove a manually set cover art and let Nemp choose it automatic' +
            'ally'
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Reset'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          WordWrap = True
          OnClick = BtnRemoveUserCoverClick
        end
        object BtnLoadCoverArt: TButton
          AlignWithMargins = True
          Left = 8
          Top = 270
          Width = 241
          Height = 25
          Hint = 'Load an image file for cover art'
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Load cover art'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = BtnLoadAnotherImageClick
        end
        object rgChangeCoverArt: TRadioGroup
          Left = 8
          Top = 363
          Width = 241
          Height = 97
          Anchors = [akLeft, akTop, akRight, akBottom]
          Caption = 'Update cover art ...'
          ItemIndex = 0
          Items.Strings = (
            'just for this file'
            'for all files with this cover art'
            'for all files in the same directory')
          TabOrder = 3
        end
      end
    end
    object Tab_MetaData: TTabSheet
      Caption = 'Metadata'
      ImageIndex = 1
      object GrpBox_TextFrames: TGroupBox
        Left = 0
        Top = 0
        Width = 607
        Height = 286
        Align = alClient
        Caption = 'Metadata frames'
        TabOrder = 0
        DesignSize = (
          607
          286)
        object Btn_NewMetaFrame: TButton
          AlignWithMargins = True
          Left = 465
          Top = 16
          Width = 130
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'New frame'
          TabOrder = 0
          OnClick = Btn_NewMetaFrameClick
        end
        object BtnCopyFromV1: TButton
          Left = 465
          Top = 250
          Width = 130
          Height = 25
          Hint = 'Copy data from the ID3v1-Tag'
          Anchors = [akRight, akBottom]
          Caption = 'Copy from ID3 v1'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = BtnCopyFromV1Click
        end
        object cbFrameTypeSelection: TComboBox
          AlignWithMargins = True
          Left = 465
          Top = 47
          Width = 130
          Height = 21
          Style = csDropDownList
          Anchors = [akTop, akRight]
          ItemIndex = 0
          TabOrder = 2
          Text = 'ID3v2-Frame'
          Items.Strings = (
            'ID3v2-Frame'
            'Apev2-Frame')
        end
        object VST_MetaData: TVirtualStringTree
          Left = 8
          Top = 16
          Width = 434
          Height = 265
          Anchors = [akLeft, akTop, akBottom]
          BorderStyle = bsNone
          BorderWidth = 1
          Header.AutoSizeIndex = 0
          Header.MainColumn = 3
          Header.Options = [hoColumnResize, hoDrag, hoVisible]
          Indent = 0
          TabOrder = 3
          TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toWheelPanning, toEditOnClick, toEditOnDblClick]
          TreeOptions.PaintOptions = [toShowBackground, toShowRoot, toThemeAware, toUseBlendedImages]
          TreeOptions.SelectionOptions = [toFullRowSelect]
          OnCompareNodes = VST_MetaDataCompareNodes
          OnEditing = VST_MetaDataEditing
          OnFreeNode = VST_MetaDataFreeNode
          OnGetText = VST_MetaDataGetText
          OnPaintText = VST_MetaDataPaintText
          OnNewText = VST_MetaDataNewText
          OnNodeDblClick = VST_MetaDataNodeDblClick
          Columns = <
            item
              Position = 0
              WideText = 'Type'
            end
            item
              Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coStyleColor]
              Position = 1
              Width = 47
              WideText = 'Key'
            end
            item
              Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coStyleColor]
              Position = 2
              Width = 105
              WideText = 'Description'
            end
            item
              Position = 3
              Width = 220
              WideText = 'Value'
            end>
        end
      end
      object Pnl_ID3v1_MPEG: TPanel
        Left = 0
        Top = 286
        Width = 607
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
            Top = 17
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
            Top = 41
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
            Top = 63
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
            Top = 109
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
            Top = 104
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
            Top = 85
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
            Top = 85
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
          object BtnCopyFromV2: TButton
            Left = 216
            Top = 148
            Width = 130
            Height = 25
            Hint = 'Copy data from the ID3v2-Tag'
            Caption = 'Copy from ID3 v2'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 7
            OnClick = BtnCopyFromV2Click
          end
          object Lblv1Album: TEdit
            Tag = 3
            Left = 96
            Top = 60
            Width = 250
            Height = 21
            TabOrder = 2
            OnChange = Lblv1Change
          end
          object Lblv1Artist: TEdit
            Tag = 1
            Left = 96
            Top = 14
            Width = 250
            Height = 21
            TabOrder = 0
            OnChange = Lblv1Change
          end
          object Lblv1Titel: TEdit
            Tag = 2
            Left = 96
            Top = 38
            Width = 250
            Height = 21
            TabOrder = 1
            OnChange = Lblv1Change
          end
          object Lblv1Year: TEdit
            Tag = 7
            Left = 305
            Top = 104
            Width = 41
            Height = 21
            NumbersOnly = True
            TabOrder = 6
            OnChange = Lblv1YearChange
          end
          object Lblv1Comment: TEdit
            Tag = 4
            Left = 96
            Top = 82
            Width = 154
            Height = 21
            TabOrder = 3
            OnChange = Lblv1Change
          end
          object Lblv1Track: TEdit
            Tag = 5
            Left = 305
            Top = 82
            Width = 41
            Height = 21
            NumbersOnly = True
            TabOrder = 4
            OnChange = Lblv1TrackChange
          end
          object cbIDv1Genres: TComboBox
            Tag = 6
            Left = 96
            Top = 104
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
          Left = 369
          Top = 0
          Width = 238
          Height = 189
          Align = alRight
          Caption = 'MPEG'
          TabOrder = 1
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
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 512
    Width = 615
    Height = 30
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      615
      30)
    object Btn_Close: TButton
      Left = 370
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
      Left = 451
      Top = 0
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Undo'
      TabOrder = 1
      OnClick = BtnUndoClick
    end
    object BtnApply: TButton
      Left = 532
      Top = 0
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Apply'
      TabOrder = 2
      OnClick = BtnApplyClick
    end
    object BtnRefreshCoverflow: TButton
      Left = 197
      Top = 0
      Width = 157
      Height = 25
      Caption = 'Refresh Coverflow'
      TabOrder = 3
      Visible = False
      OnClick = BtnRefreshCoverflowClick
    end
    object cbStayOnTop: TCheckBox
      AlignWithMargins = True
      Left = 12
      Top = 4
      Width = 179
      Height = 17
      Caption = 'Stay on top'
      TabOrder = 4
      OnClick = cbStayOnTopClick
    end
  end
  object PM_URLCopy: TPopupMenu
    Left = 404
    Top = 64
    object PM_CopyURLToClipboard: TMenuItem
      Caption = 'Copy URL to clipboard'
      OnClick = PM_CopyURLToClipboardClick
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'jpg'
    Filter = 'Supported files (*.jpg;*.jpeg;*.png)|*.jpg;*.jpeg;*.png;'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 20
    Top = 456
  end
  object ReloadTimer: TTimer
    Enabled = False
    Interval = 50
    OnTimer = ReloadTimerTimer
    Left = 216
    Top = 440
  end
  object PM_EditExtendedTags: TPopupMenu
    Left = 280
    Top = 440
    object pm_AddTag: TMenuItem
      Caption = 'Add tag'
      OnClick = btn_AddTagClick
    end
    object pm_RenameTag: TMenuItem
      Caption = 'Rename tag'
      ShortCut = 113
      OnClick = Btn_RenameTagClick
    end
    object pm_RemoveTag: TMenuItem
      Caption = 'Remove tag'
      ShortCut = 46
      OnClick = Btn_RemoveTagClick
    end
  end
  object OpenDlgCoverArt: TOpenPictureDialog
    Filter = 
      'Supported files (*.jpg;*.jpeg;*.png;*.bmp)|*.jpg;*.jpeg;*.png;*.' +
      'bmp'
    Left = 392
    Top = 248
  end
end
