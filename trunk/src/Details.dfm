object FDetails: TFDetails
  Left = 850
  Top = 53
  BorderStyle = bsDialog
  Caption = 'File properties'
  ClientHeight = 512
  ClientWidth = 475
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  ScreenSnap = True
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnHide = FormHide
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Btn_Close: TButton
    Left = 232
    Top = 480
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 0
    OnClick = Btn_CloseClick
  end
  object MainPageControl: TPageControl
    Left = 8
    Top = 8
    Width = 462
    Height = 465
    ActivePage = Tab_General
    TabOrder = 1
    object Tab_General: TTabSheet
      Caption = 'General'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GrpBox_File: TGroupBox
        Left = 8
        Top = 0
        Width = 441
        Height = 105
        Caption = 'File'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 0
        object LBLName: TLabel
          Left = 88
          Top = 32
          Width = 3
          Height = 13
          ShowAccelChar = False
          Transparent = True
        end
        object LBLSize: TLabel
          Left = 88
          Top = 48
          Width = 3
          Height = 13
          ShowAccelChar = False
          Transparent = True
        end
        object LlblConst_FileSize: TLabel
          Left = 8
          Top = 48
          Width = 70
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
          Width = 70
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
          Width = 70
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
          Left = 88
          Top = 16
          Width = 3
          Height = 13
          ParentShowHint = False
          ShowAccelChar = False
          ShowHint = True
          Transparent = True
          OnClick = LBLPfadClick
        end
        object Btn_Explore: TButton
          Left = 8
          Top = 72
          Width = 81
          Height = 21
          Caption = 'Explorer'
          TabOrder = 0
          OnClick = Btn_ExploreClick
        end
        object Btn_Properties: TButton
          Left = 96
          Top = 72
          Width = 81
          Height = 21
          Caption = 'Properties'
          TabOrder = 1
          OnClick = Btn_PropertiesClick
        end
        object PnlWarnung: TPanel
          Left = 248
          Top = 56
          Width = 185
          Height = 41
          BevelOuter = bvNone
          TabOrder = 2
          object Image1: TImage
            Left = 8
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
            Left = 40
            Top = 2
            Width = 137
            Height = 31
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
      object GrpBox_Title: TGroupBox
        Left = 8
        Top = 112
        Width = 209
        Height = 185
        Caption = 'Title'
        TabOrder = 1
        object LBLArtist: TLabel
          Left = 88
          Top = 16
          Width = 3
          Height = 13
          ShowAccelChar = False
          Transparent = True
        end
        object LBLTitel: TLabel
          Left = 88
          Top = 32
          Width = 3
          Height = 13
          ShowAccelChar = False
          Transparent = True
        end
        object LBLAlbum: TLabel
          Left = 88
          Top = 48
          Width = 3
          Height = 13
          ShowAccelChar = False
          Transparent = True
        end
        object LBLYear: TLabel
          Left = 88
          Top = 80
          Width = 3
          Height = 13
          ShowAccelChar = False
          Transparent = True
        end
        object LBLGenre: TLabel
          Left = 88
          Top = 96
          Width = 3
          Height = 13
          ShowAccelChar = False
          Transparent = True
        end
        object LlblConst_Artist: TLabel
          Left = 8
          Top = 16
          Width = 70
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
          Transparent = True
        end
        object LlblConst_Title: TLabel
          Left = 8
          Top = 32
          Width = 70
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
          Transparent = True
        end
        object LlblConst_Album: TLabel
          Left = 8
          Top = 48
          Width = 70
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
          Transparent = True
        end
        object LlblConst_Year: TLabel
          Left = 8
          Top = 80
          Width = 70
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
          Transparent = True
        end
        object LlblConst_Genre: TLabel
          Left = 8
          Top = 96
          Width = 70
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
          Transparent = True
        end
        object LBLDauer: TLabel
          Left = 88
          Top = 112
          Width = 3
          Height = 13
          ShowAccelChar = False
          Transparent = True
        end
        object LlblConst_Duration: TLabel
          Left = 8
          Top = 112
          Width = 70
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
        object LlblConst_Comment: TLabel
          Left = 8
          Top = 128
          Width = 70
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
          Transparent = True
        end
        object LBLKommentar: TLabel
          Left = 88
          Top = 128
          Width = 3
          Height = 13
          Transparent = True
        end
        object LlblConst_Track: TLabel
          Left = 8
          Top = 64
          Width = 70
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
          Transparent = True
        end
        object LBLTrack: TLabel
          Left = 88
          Top = 64
          Width = 3
          Height = 13
          ShowAccelChar = False
          Transparent = True
        end
        object Btn_Actualize: TButton
          Left = 8
          Top = 152
          Width = 81
          Height = 21
          Caption = 'Refresh'
          TabOrder = 0
          OnClick = Btn_ActualizeClick
        end
      end
      object GrpBox_Quality: TGroupBox
        Left = 8
        Top = 304
        Width = 209
        Height = 121
        Caption = 'Quality'
        TabOrder = 2
        object RatingImageRO: TImage
          Left = 84
          Top = 52
          Width = 70
          Height = 14
          Transparent = True
        end
        object LBLBitrate: TLabel
          Left = 88
          Top = 16
          Width = 3
          Height = 13
          ShowAccelChar = False
          Transparent = True
        end
        object LBLSamplerate: TLabel
          Left = 88
          Top = 32
          Width = 3
          Height = 13
          ShowAccelChar = False
          Transparent = True
        end
        object LlblConst_Samplerate: TLabel
          Left = 8
          Top = 32
          Width = 70
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
          Top = 16
          Width = 70
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
        object LblConst_Rating: TLabel
          Left = 8
          Top = 51
          Width = 70
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
        object LblRating: TLabel
          Left = 176
          Top = 56
          Width = 3
          Height = 13
          ShowAccelChar = False
          Transparent = True
        end
        object LblPlayCounter: TLabel
          Left = 84
          Top = 72
          Width = 3
          Height = 13
        end
      end
      object GrpBox_Cover: TGroupBox
        Left = 224
        Top = 112
        Width = 225
        Height = 313
        Caption = 'Cover'
        TabOrder = 3
        object CoverIMAGE: TImage
          Left = 8
          Top = 16
          Width = 209
          Height = 209
          Center = True
          Proportional = True
          Stretch = True
          OnDblClick = CoverIMAGEDblClick
        end
        object Lbl_FoundCovers: TLabel
          Left = 8
          Top = 264
          Width = 79
          Height = 13
          Caption = 'Found coverfiles'
          Transparent = True
        end
        object Btn_OpenImage: TButton
          Left = 8
          Top = 232
          Width = 81
          Height = 21
          Caption = 'Open'
          TabOrder = 1
          OnClick = Btn_OpenImageClick
        end
        object CoverBox: TComboBox
          Left = 3
          Top = 283
          Width = 209
          Height = 21
          AutoComplete = False
          Style = csDropDownList
          ItemHeight = 0
          TabOrder = 0
          OnChange = CoverBoxChange
        end
      end
    end
    object Tab_MpegInformation: TTabSheet
      Caption = 'ID3-Tags'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GrpBox_ID3v1: TGroupBox
        Left = 8
        Top = 0
        Width = 441
        Height = 169
        Caption = 'ID3 v1'
        TabOrder = 0
        object LblConst_ID3v1Artist: TLabel
          Left = 8
          Top = 43
          Width = 54
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
          Top = 67
          Width = 54
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
          Top = 91
          Width = 54
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
          Left = 222
          Top = 139
          Width = 38
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
          Top = 139
          Width = 54
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
          Top = 115
          Width = 54
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
          Left = 304
          Top = 139
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
        object pnlIDv1Genre: TPanel
          Left = 64
          Top = 136
          Width = 153
          Height = 21
          BevelOuter = bvNone
          Enabled = False
          TabOrder = 4
          DesignSize = (
            153
            21)
          object cbIDv1Genres: TComboBox
            Left = 0
            Top = 0
            Width = 145
            Height = 21
            AutoCloseUp = True
            Style = csDropDownList
            Anchors = [akLeft, akTop, akRight]
            ItemHeight = 0
            Sorted = True
            TabOrder = 0
            OnChange = Lblv1Change
          end
        end
        object CBID3v1: TCheckBox
          Left = 64
          Top = 16
          Width = 97
          Height = 17
          Caption = 'ID3 v1'
          TabOrder = 7
          OnClick = CBID3v1Click
        end
        object BtnCopyFromV2: TButton
          Left = 240
          Top = 14
          Width = 139
          Height = 21
          Caption = 'Copy from ID3 v2'
          TabOrder = 8
          OnClick = BtnCopyFromV2Click
        end
        object Lblv1Album: TEdit
          Left = 64
          Top = 88
          Width = 313
          Height = 21
          ReadOnly = True
          TabOrder = 2
          OnChange = Lblv1Change
        end
        object Lblv1Artist: TEdit
          Left = 64
          Top = 40
          Width = 313
          Height = 21
          ReadOnly = True
          TabOrder = 0
          OnChange = Lblv1Change
        end
        object Lblv1Titel: TEdit
          Left = 64
          Top = 64
          Width = 313
          Height = 21
          ReadOnly = True
          TabOrder = 1
          OnChange = Lblv1Change
        end
        object Lblv1Year: TEdit
          Left = 264
          Top = 136
          Width = 33
          Height = 21
          ReadOnly = True
          TabOrder = 6
          OnChange = Lblv1YearChange
        end
        object Lblv1Comment: TEdit
          Left = 64
          Top = 112
          Width = 313
          Height = 21
          ReadOnly = True
          TabOrder = 3
          OnChange = Lblv1Change
        end
        object Lblv1Track: TEdit
          Left = 336
          Top = 136
          Width = 41
          Height = 21
          ReadOnly = True
          TabOrder = 5
          OnChange = Lblv1TrackChange
        end
      end
      object GrpBox_ID3v2: TGroupBox
        Left = 8
        Top = 176
        Width = 441
        Height = 249
        Caption = 'ID3 v2'
        TabOrder = 1
        object LblConst_ID3v2Artist: TLabel
          Left = 8
          Top = 43
          Width = 54
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
        object LblConst_ID3v2Title: TLabel
          Left = 8
          Top = 67
          Width = 54
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
        object LblConst_ID3v2Album: TLabel
          Left = 8
          Top = 91
          Width = 54
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
        object LblConst_ID3v2Year: TLabel
          Left = 222
          Top = 139
          Width = 38
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
        object LblConst_ID3v2Genre: TLabel
          Left = 8
          Top = 139
          Width = 54
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
        object LblConst_ID3v2Comment: TLabel
          Left = 8
          Top = 115
          Width = 54
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
        object LblConst_ID3v2Track: TLabel
          Left = 304
          Top = 139
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
        object LblRatingImage: TLabel
          Left = -12
          Top = 163
          Width = 70
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
        object RatingImage: TImage
          Left = 64
          Top = 163
          Width = 70
          Height = 14
          Transparent = True
          OnMouseDown = RatingImageMouseDown
          OnMouseLeave = RatingImageMouseLeave
          OnMouseMove = RatingImageMouseMove
        end
        object pnlIDv2Genre: TPanel
          Left = 64
          Top = 136
          Width = 153
          Height = 21
          BevelOuter = bvNone
          Enabled = False
          TabOrder = 4
          DesignSize = (
            153
            21)
          object cbIDv2Genres: TComboBox
            Left = 0
            Top = 0
            Width = 145
            Height = 21
            AutoComplete = False
            Anchors = [akLeft, akTop, akRight, akBottom]
            ItemHeight = 0
            Sorted = True
            TabOrder = 0
            OnChange = Lblv2Change
          end
        end
        object CBID3v2: TCheckBox
          Left = 64
          Top = 16
          Width = 97
          Height = 17
          Caption = 'ID3 v2'
          TabOrder = 7
          OnClick = CBID3v2Click
        end
        object BtnCopyFromV1: TButton
          Left = 240
          Top = 14
          Width = 139
          Height = 21
          Caption = 'Copy from ID3 v1'
          TabOrder = 8
          OnClick = BtnCopyFromV1Click
        end
        object Lblv2Copyright: TLabeledEdit
          Left = 64
          Top = 216
          Width = 313
          Height = 21
          EditLabel.Width = 47
          EditLabel.Height = 13
          EditLabel.Caption = 'Copyright'
          LabelPosition = lpLeft
          LabelSpacing = 1
          ReadOnly = True
          TabOrder = 9
          OnChange = Lblv2Change
        end
        object Lblv2URL: TLabeledEdit
          Left = 64
          Top = 189
          Width = 313
          Height = 21
          EditLabel.Width = 19
          EditLabel.Height = 13
          EditLabel.Caption = 'URL'
          LabelPosition = lpLeft
          LabelSpacing = 1
          ReadOnly = True
          TabOrder = 10
          OnChange = Lblv2Change
        end
        object Lblv2Artist: TEdit
          Left = 64
          Top = 40
          Width = 313
          Height = 21
          ReadOnly = True
          TabOrder = 0
          OnChange = Lblv2Change
        end
        object Lblv2Titel: TEdit
          Left = 64
          Top = 64
          Width = 313
          Height = 21
          ReadOnly = True
          TabOrder = 1
          OnChange = Lblv2Change
        end
        object Lblv2Album: TEdit
          Left = 64
          Top = 88
          Width = 313
          Height = 21
          ReadOnly = True
          TabOrder = 2
          OnChange = Lblv2Change
        end
        object Lblv2Year: TEdit
          Left = 264
          Top = 136
          Width = 33
          Height = 21
          ReadOnly = True
          TabOrder = 6
          OnChange = Lblv2YearChange
        end
        object Lblv2Comment: TEdit
          Left = 64
          Top = 112
          Width = 313
          Height = 21
          ReadOnly = True
          TabOrder = 3
          OnChange = Lblv2Change
        end
        object Lblv2Track: TEdit
          Left = 336
          Top = 136
          Width = 41
          Height = 21
          ReadOnly = True
          TabOrder = 5
          OnChange = Lblv2TrackChange
        end
        object BtnResetRating: TButton
          Left = 147
          Top = 163
          Width = 81
          Height = 21
          Caption = 'Reset'
          TabOrder = 11
          OnClick = BtnResetRatingClick
        end
      end
    end
    object Tab_Lyrics: TTabSheet
      Caption = 'Lyrics && Pictures '
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GrpBox_Lyrics: TGroupBox
        Left = 8
        Top = 0
        Width = 441
        Height = 169
        Caption = 'Lyrics'
        TabOrder = 0
        object Btn_DeleteLyricFrame: TButton
          Left = 344
          Top = 16
          Width = 89
          Height = 21
          Caption = 'Delete lyrics'
          Enabled = False
          TabOrder = 0
          OnClick = Btn_DeleteLyricFrameClick
        end
        object BtnLyricWiki: TButton
          Left = 344
          Top = 40
          Width = 89
          Height = 21
          Caption = 'LyricWiki.org'
          TabOrder = 1
          OnClick = BtnLyricWikiClick
        end
        object BtnLyricWikiManual: TButton
          Left = 344
          Top = 64
          Width = 89
          Height = 21
          Caption = 'Manual search'
          TabOrder = 3
          OnClick = BtnLyricWikiManualClick
        end
        object Memo_Lyrics: TMemo
          Left = 8
          Top = 16
          Width = 321
          Height = 145
          Enabled = False
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 2
          OnKeyDown = Memo_LyricsKeyDown
        end
      end
      object GrpBox_Pictures: TGroupBox
        Left = 8
        Top = 176
        Width = 441
        Height = 257
        Caption = 'Pictures'
        TabOrder = 1
        object Bevel1: TBevel
          Left = 8
          Top = 40
          Width = 321
          Height = 210
          Shape = bsFrame
        end
        object ID3Image: TImage
          Left = 10
          Top = 42
          Width = 315
          Height = 205
          Center = True
          Proportional = True
          Stretch = True
        end
        object Btn_NewPicture: TButton
          Left = 344
          Top = 16
          Width = 89
          Height = 21
          Caption = 'New'
          Enabled = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = Btn_NewPictureClick
        end
        object Btn_DeletePicture: TButton
          Left = 344
          Top = 40
          Width = 89
          Height = 21
          Caption = 'Delete'
          Enabled = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnClick = Btn_DeletePictureClick
        end
        object Btn_SavePictureToFile: TButton
          Left = 344
          Top = 72
          Width = 89
          Height = 21
          Caption = 'Save to file'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          OnClick = Btn_SavePictureToFileClick
        end
        object cbPictures: TComboBox
          Left = 8
          Top = 16
          Width = 321
          Height = 21
          Style = csDropDownList
          ItemHeight = 0
          TabOrder = 0
          OnChange = cbPicturesChange
        end
      end
    end
    object Tab_ExtendedID3v2: TTabSheet
      Caption = 'More'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GrpBox_Mpeg: TGroupBox
        Left = 8
        Top = 8
        Width = 441
        Height = 105
        Caption = 'MPEG'
        TabOrder = 0
        object LblConst_MpegBitrate: TLabel
          Left = 8
          Top = 48
          Width = 70
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
          Width = 70
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
          Left = 224
          Top = 64
          Width = 70
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
          Left = 224
          Top = 80
          Width = 70
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
          Width = 70
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
          Left = 224
          Top = 48
          Width = 70
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
          Left = 224
          Top = 16
          Width = 70
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
          Width = 70
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
          Left = 224
          Top = 32
          Width = 70
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
          Width = 70
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
          Left = 88
          Top = 48
          Width = 3
          Height = 13
          ShowAccelChar = False
          Transparent = True
        end
        object LblDETSamplerate: TLabel
          Left = 88
          Top = 64
          Width = 3
          Height = 13
          ShowAccelChar = False
          Transparent = True
        end
        object LblDETDauer: TLabel
          Left = 88
          Top = 80
          Width = 3
          Height = 13
          ShowAccelChar = False
          Transparent = True
        end
        object LblDETVersion: TLabel
          Left = 88
          Top = 16
          Width = 3
          Height = 13
          ShowAccelChar = False
          Transparent = True
        end
        object LblDETHeaderAt: TLabel
          Left = 88
          Top = 32
          Width = 3
          Height = 13
          ShowAccelChar = False
          Transparent = True
        end
        object LblDETProtection: TLabel
          Left = 304
          Top = 16
          Width = 3
          Height = 13
          ShowAccelChar = False
          Transparent = True
        end
        object LblDETExtension: TLabel
          Left = 304
          Top = 32
          Width = 3
          Height = 13
          ShowAccelChar = False
          Transparent = True
        end
        object LblDETCopyright: TLabel
          Left = 304
          Top = 48
          Width = 3
          Height = 13
          ShowAccelChar = False
          Transparent = True
        end
        object LblDETOriginal: TLabel
          Left = 304
          Top = 64
          Width = 3
          Height = 13
          ShowAccelChar = False
          Transparent = True
        end
        object LblDETEmphasis: TLabel
          Left = 304
          Top = 80
          Width = 3
          Height = 13
          ShowAccelChar = False
          Transparent = True
        end
      end
      object GrpBox_TextFrames: TGroupBox
        Left = 8
        Top = 168
        Width = 441
        Height = 257
        Caption = 'Additional Id3v2-Frames'
        TabOrder = 1
        DesignSize = (
          441
          257)
        object LvFrames: TListView
          Left = 8
          Top = 16
          Width = 425
          Height = 233
          Anchors = [akLeft, akTop, akRight, akBottom]
          Columns = <
            item
              Caption = 'Type'
              Width = 150
            end
            item
              Caption = 'Content'
              Width = 255
            end>
          ReadOnly = True
          RowSelect = True
          TabOrder = 0
          ViewStyle = vsReport
          OnDblClick = LvFramesDblClick
        end
      end
      object GrpBox_ID3v2Info: TGroupBox
        Left = 8
        Top = 120
        Width = 441
        Height = 41
        Caption = 'ID3v2-Info'
        TabOrder = 2
        object LblConst_Id3v2Version: TLabel
          Left = 8
          Top = 16
          Width = 67
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
        end
        object LblConst_Id3v2Size: TLabel
          Left = 120
          Top = 16
          Width = 65
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Size'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          ShowAccelChar = False
        end
        object Lblv2_Size: TLabel
          Left = 192
          Top = 16
          Width = 3
          Height = 13
          ShowAccelChar = False
        end
        object Lblv2_Version: TLabel
          Left = 88
          Top = 16
          Width = 3
          Height = 13
          ShowAccelChar = False
        end
      end
    end
  end
  object ___CB_StayOnTop: TCheckBox
    Left = 16
    Top = 480
    Width = 169
    Height = 17
    Caption = 'Stay on top'
    Checked = True
    State = cbChecked
    TabOrder = 2
    Visible = False
  end
  object BtnApply: TButton
    Left = 392
    Top = 479
    Width = 75
    Height = 25
    Caption = 'Apply'
    TabOrder = 3
    OnClick = BtnApplyClick
  end
  object BtnUndo: TButton
    Left = 312
    Top = 480
    Width = 75
    Height = 25
    Caption = 'Undo'
    TabOrder = 4
    OnClick = BtnUndoClick
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 250
    OnTimer = Timer1Timer
    Left = 384
  end
  object IdHTTP1: TIdHTTP
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Left = 340
  end
  object PM_URLCopy: TPopupMenu
    Left = 420
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
    Left = 420
  end
  object ReloadTimer: TTimer
    Enabled = False
    Interval = 50
    OnTimer = ReloadTimerTimer
    Left = 424
    Top = 128
  end
end