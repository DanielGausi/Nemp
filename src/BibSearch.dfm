object FormBibSearch: TFormBibSearch
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Nemp: Search in the library'
  ClientHeight = 449
  ClientWidth = 595
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    595
    449)
  TextHeight = 13
  object Btn_ExtendedSearch: TButton
    AlignWithMargins = True
    Left = 495
    Top = 418
    Width = 90
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Search'
    Default = True
    TabOrder = 0
    OnClick = Btn_ExtendedSearchClick
  end
  object BtnCancel: TButton
    AlignWithMargins = True
    Left = 399
    Top = 418
    Width = 90
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = BtnCancelClick
  end
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 44
    Width = 589
    Height = 365
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object GRPErweiterteSucheEdit: TGroupBox
      Tag = 2
      Left = 0
      Top = 0
      Width = 353
      Height = 365
      Align = alLeft
      Caption = 'Keywords'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      DesignSize = (
        353
        365)
      object LblConst_SearchArtist: TLabel
        Left = 14
        Top = 76
        Width = 26
        Height = 13
        Caption = 'Artist'
      end
      object LblConst_SearchTitle: TLabel
        Left = 14
        Top = 101
        Width = 20
        Height = 13
        Caption = 'Title'
      end
      object LblConst_SearchAlbum: TLabel
        Left = 14
        Top = 128
        Width = 29
        Height = 13
        Caption = 'Album'
      end
      object LblConst_SearchComment: TLabel
        Left = 14
        Top = 182
        Width = 45
        Height = 13
        Caption = 'Comment'
      end
      object LblConst_SearchPath: TLabel
        Left = 14
        Top = 155
        Width = 22
        Height = 13
        Caption = 'Path'
      end
      object LblConst_GeneralSearchHint: TLabel
        Left = 14
        Top = 49
        Width = 89
        Height = 13
        Caption = 'General search for'
      end
      object LblConst_LyricSearchHint: TLabel
        Left = 14
        Top = 258
        Width = 27
        Height = 13
        Caption = 'Lyrics'
      end
      object LblConst_SearchGenre: TLabel
        Left = 14
        Top = 211
        Width = 29
        Height = 13
        Caption = 'Genre'
      end
      object ArtistEDIT: TEdit
        Left = 82
        Top = 71
        Width = 260
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 1
      end
      object TitelEDIT: TEdit
        Left = 82
        Top = 98
        Width = 260
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 2
      end
      object AlbumEDIT: TEdit
        Left = 82
        Top = 125
        Width = 260
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 3
      end
      object KommentarEDIT: TEdit
        Left = 82
        Top = 181
        Width = 260
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 5
      end
      object PathEDIT: TEdit
        Left = 82
        Top = 152
        Width = 260
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 4
      end
      object GeneralEdit: TEdit
        Left = 121
        Top = 44
        Width = 221
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
      end
      object LyricEdit: TMemo
        Left = 82
        Top = 255
        Width = 260
        Height = 96
        Anchors = [akLeft, akTop, akRight]
        Lines.Strings = (
          '')
        TabOrder = 6
      end
      object CBFehlerToleranz: TCheckBox
        Left = 14
        Top = 21
        Width = 124
        Height = 17
        Caption = 'Fuzzy search'
        Checked = True
        ParentShowHint = False
        ShowHint = True
        State = cbChecked
        TabOrder = 7
      end
      object BtnClear: TButton
        Left = 229
        Top = 13
        Width = 113
        Height = 25
        Caption = 'Clear inputs'
        TabOrder = 8
        OnClick = BtnClearClick
      end
      object GenreEdit: TEdit
        Left = 82
        Top = 210
        Width = 260
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 9
      end
    end
    object Panel2: TPanel
      Left = 353
      Top = 0
      Width = 236
      Height = 365
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object GrpBox_ExtendedSearchGenres: TGroupBox
        Tag = 2
        Left = 0
        Top = 0
        Width = 236
        Height = 255
        Align = alClient
        Caption = 'Genres'
        TabOrder = 0
        DesignSize = (
          236
          255)
        object cbGenres: TCheckListBox
          AlignWithMargins = True
          Left = 8
          Top = 40
          Width = 217
          Height = 186
          Anchors = [akLeft, akTop, akRight, akBottom]
          Columns = 2
          Enabled = False
          ItemHeight = 13
          Sorted = True
          TabOrder = 1
        end
        object cbIgnoreGenres: TCheckBox
          Left = 8
          Top = 16
          Width = 89
          Height = 17
          Caption = 'Ignore'
          Checked = True
          ParentShowHint = False
          ShowHint = True
          State = cbChecked
          TabOrder = 0
          OnClick = cbIgnoreGenresClick
        end
        object cbIncludeUnkownGenres: TCheckBox
          AlignWithMargins = True
          Left = 8
          Top = 232
          Width = 209
          Height = 17
          Hint = 'Include titles with unknown genre'
          Anchors = [akLeft, akBottom]
          Caption = 'N/A, unknown'
          Enabled = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
        end
      end
      object GrpBox_ExtendedSearchDate: TGroupBox
        Tag = 2
        Left = 0
        Top = 255
        Width = 236
        Height = 110
        Align = alBottom
        Caption = 'Date'
        TabOrder = 1
        object LblConst_SearchExtendedYear: TLabel
          Left = 8
          Top = 77
          Width = 41
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Year'
          Enabled = False
        end
        object LblConst_SearchExtendedPeriod: TLabel
          Left = 8
          Top = 45
          Width = 41
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Period'
          Enabled = False
        end
        object seJahr: TSpinEdit
          Left = 56
          Top = 72
          Width = 57
          Height = 22
          Enabled = False
          MaxValue = 3000
          MinValue = 0
          TabOrder = 2
          Value = 2000
        end
        object cbIgnoreYear: TCheckBox
          Left = 11
          Top = 17
          Width = 105
          Height = 17
          Caption = 'Ignore'
          Checked = True
          ParentShowHint = False
          ShowHint = True
          State = cbChecked
          TabOrder = 0
          OnClick = cbIgnoreYearClick
        end
        object cbIncludeNA: TCheckBox
          Left = 134
          Top = 41
          Width = 51
          Height = 17
          Hint = 'Include titles with no information about the year'
          Caption = 'N/A'
          Enabled = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
        end
        object cbInclude0: TCheckBox
          Left = 134
          Top = 73
          Width = 67
          Height = 17
          Hint = 'Include titles with year=0'
          Caption = '0'
          Enabled = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
        end
        object cb_ExtendedSearchPeriod: TComboBox
          Left = 56
          Top = 40
          Width = 57
          Height = 21
          Style = csDropDownList
          Enabled = False
          ItemIndex = 0
          TabOrder = 1
          Text = 'Before'
          Items.Strings = (
            'Before'
            'After'
            'During')
        end
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 595
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    DesignSize = (
      595
      41)
    object CB_SearchHistory: TComboBox
      AlignWithMargins = True
      Left = 8
      Top = 11
      Width = 573
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      OnChange = CB_SearchHistoryChange
    end
  end
end
