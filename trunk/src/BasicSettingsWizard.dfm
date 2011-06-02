object Wizard: TWizard
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Wizard'
  ClientHeight = 294
  ClientWidth = 528
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    528
    294)
  PixelsPerInch = 96
  TextHeight = 13
  object pc_Wizard: TPageControl
    Left = 8
    Top = 8
    Width = 512
    Height = 278
    ActivePage = TabSheet5
    Anchors = [akLeft, akTop, akBottom]
    TabOrder = 0
    TabPosition = tpBottom
    object TabSheet1: TTabSheet
      Caption = '(welcome)'
      object Lbl_Welcome: TLabel
        Left = 160
        Top = 3
        Width = 250
        Height = 23
        Caption = 'Welcome to the Nemp Wizard'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object ImgWelcome: TImage
        Left = 16
        Top = 16
        Width = 128
        Height = 128
      end
      object Lbl_Version: TLabel
        Left = 160
        Top = 32
        Width = 12
        Height = 13
        Caption = '...'
      end
      object st_Introduction: TStaticText
        Left = 160
        Top = 51
        Width = 321
        Height = 126
        AutoSize = False
        Caption = 
          'Nemp has a lot of cool features. Some of these features create n' +
          'ew files on your disk or change files in the background. Some pe' +
          'ople (well-known klingon generals in particular) don'#39't like prog' +
          'rams that mess about with their system without being asked - and' +
          ' so do I.#13#10#13#10The Wizard will explain these features and ' +
          'ask for your permission to activate them.'
        TabOrder = 0
      end
      object BtnContinue: TButton
        Left = 416
        Top = 224
        Width = 75
        Height = 25
        Caption = 'Continue'
        TabOrder = 1
        OnClick = BtnContinueClick
      end
      object BtnCancel: TButton
        Left = 335
        Top = 224
        Width = 75
        Height = 25
        Caption = 'Cancel'
        TabOrder = 2
        OnClick = BtnCancelClick
      end
    end
    object TabSheet2: TTabSheet
      Caption = '(Updates)'
      ImageIndex = 1
      object Lbl_CheckUpdates: TLabel
        Left = 160
        Top = 3
        Width = 153
        Height = 23
        Caption = 'Check for Updates'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Lbl_QeryUpdate: TLabel
        Left = 160
        Top = 143
        Width = 284
        Height = 46
        Caption = 'Allow Nemp to check for Updates periodically?'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object ImageUpdate: TImage
        Left = 16
        Top = 16
        Width = 128
        Height = 128
      end
      object st_Updates: TStaticText
        Left = 160
        Top = 32
        Width = 329
        Height = 105
        AutoSize = False
        Caption = 
          'Nemp can check for updates and notify you if a newer version of ' +
          'Nemp is available. It will contact www.gausi.de once a week (def' +
          'ault setting, interval can be changed) and ask for the newest ve' +
          'rsion. There is no auto-installer - you have to download and ins' +
          'tall the new version by hand.'
        TabOrder = 0
      end
      object BtnUpdateYes: TButton
        Left = 416
        Top = 224
        Width = 75
        Height = 25
        Caption = 'Yes'
        TabOrder = 1
        OnClick = BtnUpdateYesClick
      end
      object BtnUpdateNo: TButton
        Left = 335
        Top = 224
        Width = 75
        Height = 25
        Caption = 'No'
        TabOrder = 2
        OnClick = BtnUpdateNoClick
      end
      object BtnUpdateBack: TButton
        Left = 152
        Top = 224
        Width = 75
        Height = 25
        Caption = 'Back'
        TabOrder = 3
        OnClick = BtnUpdateBackClick
      end
    end
    object TabSheet3: TTabSheet
      Caption = '(QuickAccess)'
      ImageIndex = 2
      object ImageMetaData: TImage
        Left = 16
        Top = 16
        Width = 128
        Height = 128
      end
      object Lbl_QueryMetadata: TLabel
        Left = 160
        Top = 143
        Width = 301
        Height = 46
        Caption = 'Allow Nemp to change metadata in audiofiles?'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Lbl_SaveMetadata: TLabel
        Left = 160
        Top = 3
        Width = 175
        Height = 23
        Caption = 'Metadata (ID3-Tags)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Btn_MetaBack: TButton
        Left = 152
        Top = 224
        Width = 75
        Height = 25
        Caption = 'Back'
        TabOrder = 0
        OnClick = BtnUpdateBackClick
      end
      object Btn_MetaYes: TButton
        Left = 416
        Top = 224
        Width = 75
        Height = 25
        Caption = 'Yes'
        TabOrder = 1
        OnClick = BtnUpdateYesClick
      end
      object st_Metadata: TStaticText
        Left = 162
        Top = 32
        Width = 329
        Height = 105
        AutoSize = False
        Caption = 
          'If you change the artist, album, rating, ... of a title, or sear' +
          'ch for lyrics or extended tags, Nemp can save these data in the ' +
          'metadata (e.g. ID3-Tags) of the file. This is pretty normal for ' +
          'an mp3-player. However, the files will be changed by this, which' +
          ' may collide with your backup or filesharing strategy.#13#10Note' +
          ': You can always change the metadata explicitly in the "Properti' +
          'es" window.'
        TabOrder = 2
      end
      object Btn_MetaNo: TButton
        Left = 335
        Top = 224
        Width = 75
        Height = 25
        Caption = 'No'
        TabOrder = 3
        OnClick = BtnUpdateNoClick
      end
    end
    object TabSheet4: TTabSheet
      Caption = '(Rating)'
      ImageIndex = 3
      object ImageRating: TImage
        Left = 16
        Top = 9
        Width = 128
        Height = 128
      end
      object Lbl_Rating: TLabel
        Left = 160
        Top = 3
        Width = 243
        Height = 23
        Caption = 'Automatic rating/playcounter'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Lbl_QueryRating: TLabel
        Left = 160
        Top = 143
        Width = 329
        Height = 92
        Caption = 'Automatically adjust the rating of your files?'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object st_Rating: TStaticText
        Left = 160
        Top = 32
        Width = 329
        Height = 105
        AutoSize = False
        Caption = 
          'Nemp can adjust the rating of your music files automatically. If' +
          ' you play a song, the rating will be increased. If a song is abo' +
          'rted, its rating will be decreased a little. This will have a le' +
          'sser extent, the more often a song was played.#13#10Note: This w' +
          'ill be saved within the file, if you answered the previous quest' +
          'ion with "yes", so the files are changed quite often then.'
        TabOrder = 0
      end
      object Btn_AutoBack: TButton
        Left = 152
        Top = 224
        Width = 75
        Height = 25
        Caption = 'Back'
        TabOrder = 1
        OnClick = BtnUpdateBackClick
      end
      object Btn_AutoNo: TButton
        Left = 335
        Top = 224
        Width = 75
        Height = 25
        Caption = 'No'
        TabOrder = 2
        OnClick = BtnUpdateNoClick
      end
      object Btn_AutoYes: TButton
        Left = 416
        Top = 224
        Width = 75
        Height = 25
        Caption = 'Yes'
        TabOrder = 3
        OnClick = BtnUpdateYesClick
      end
    end
    object TabSheet5: TTabSheet
      Caption = '(LastFM)'
      ImageIndex = 4
      object ImageLastFM: TImage
        Left = 16
        Top = 9
        Width = 128
        Height = 128
      end
      object Lbl_LastFM: TLabel
        Left = 160
        Top = 3
        Width = 120
        Height = 23
        Caption = 'Missing covers'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Lbl_QueryLastFM: TLabel
        Left = 160
        Top = 143
        Width = 261
        Height = 46
        Caption = 'Download missing covers from LastFM?'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object st_LastFM: TStaticText
        Left = 160
        Top = 32
        Width = 329
        Height = 105
        AutoSize = False
        Caption = 
          'Nemp can adjust the rating of your music files automatically. If' +
          ' you play a song, the rating will be increased. If a song is abo' +
          'rted, its rating will be decreased a little. This will have a le' +
          'sser extent, the more often a song was played.#13#10Note: This w' +
          'ill be saved within the file, if you answered the previous quest' +
          'ion with "yes", so the files are changed quite often then.'
        TabOrder = 0
      end
      object Btn_LastFMBack: TButton
        Left = 152
        Top = 224
        Width = 75
        Height = 25
        Caption = 'Back'
        TabOrder = 1
        OnClick = BtnUpdateBackClick
      end
      object Btn_LastFMNo: TButton
        Left = 335
        Top = 224
        Width = 75
        Height = 25
        Caption = 'No'
        TabOrder = 2
        OnClick = BtnUpdateNoClick
      end
      object Btn_LastFMYes: TButton
        Left = 416
        Top = 224
        Width = 75
        Height = 25
        Caption = 'Yes'
        TabOrder = 3
        OnClick = BtnUpdateYesClick
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'TabSheet6'
      ImageIndex = 5
      object ImageSummary: TImage
        Left = 16
        Top = 9
        Width = 128
        Height = 128
      end
      object Lbl_summary: TLabel
        Left = 160
        Top = 3
        Width = 80
        Height = 23
        Caption = 'Summary'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Lbl_QuerySummary: TLabel
        Left = 160
        Top = 143
        Width = 321
        Height = 115
        Caption = 'Save settings and close wizard?'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object StaticText1: TStaticText
        Left = 160
        Top = 32
        Width = 329
        Height = 105
        AutoSize = False
        Caption = 
          'Nemp can adjust the rating of your music files automatically. If' +
          ' you play a song, the rating will be increased. If a song is abo' +
          'rted, its rating will be decreased a little. This will have a le' +
          'sser extent, the more often a song was played.#13#10Note: This w' +
          'ill be saved within the file, if you answered the previous quest' +
          'ion with "yes", so the files are changed quite often then.'
        TabOrder = 0
      end
      object Btn_CompleteBack: TButton
        Left = 152
        Top = 224
        Width = 75
        Height = 25
        Caption = 'Back'
        TabOrder = 1
        OnClick = BtnUpdateBackClick
      end
      object Btn_CompleteCancel: TButton
        Left = 335
        Top = 224
        Width = 75
        Height = 25
        Caption = 'Cancel'
        TabOrder = 2
      end
      object Btn_CompleteOK: TButton
        Left = 416
        Top = 224
        Width = 75
        Height = 25
        Caption = 'Ok'
        TabOrder = 3
      end
    end
  end
end
