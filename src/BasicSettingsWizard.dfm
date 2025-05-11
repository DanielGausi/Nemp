object Wizard: TWizard
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Nemp Configuration Wizard'
  ClientHeight = 295
  ClientWidth = 547
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 13
  object pnlButtons: TPanel
    Left = 0
    Top = 254
    Width = 547
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object LblProgress: TLabel
      AlignWithMargins = True
      Left = 16
      Top = 8
      Width = 27
      Height = 25
      Margins.Left = 16
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Align = alLeft
      Caption = '1/6'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Visible = False
      ExplicitHeight = 23
    end
    object BtnBack: TButton
      AlignWithMargins = True
      Left = 274
      Top = 8
      Width = 75
      Height = 25
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Align = alRight
      Caption = 'Back'
      TabOrder = 0
      OnClick = BtnUpdateBackClick
    end
    object BtnNo: TButton
      AlignWithMargins = True
      Left = 365
      Top = 8
      Width = 75
      Height = 25
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Align = alRight
      Caption = 'No'
      TabOrder = 1
      OnClick = BtnUpdateNoClick
    end
    object BtnYes: TButton
      AlignWithMargins = True
      Left = 456
      Top = 8
      Width = 75
      Height = 25
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 16
      Margins.Bottom = 8
      Align = alRight
      Caption = 'Yes'
      Default = True
      TabOrder = 2
      OnClick = BtnUpdateYesClick
    end
  end
  object pc_Wizard: TPageControl
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 541
    Height = 248
    ActivePage = TabSheet1
    Align = alClient
    MultiLine = True
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = '(welcome)'
      object Lbl_Welcome: TLabel
        Left = 152
        Top = 16
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
      object ImgWelcome: TVirtualImage
        Left = 8
        Top = 32
        Width = 128
        Height = 128
        ImageCollection = DataModuleGui.ICGraphics
        ImageWidth = 0
        ImageHeight = 0
        ImageIndex = 3
        ImageName = 'imgwizardmain'
      end
      object Lbl_Version: TLabel
        Left = 152
        Top = 48
        Width = 12
        Height = 13
        Caption = '...'
      end
      object st_Introduction: TLabel
        Left = 152
        Top = 64
        Width = 350
        Height = 161
        AutoSize = False
        Caption = 
          'Nemp has a lot of cool features. Some of these features create n' +
          'ew files on your disk or change files in the background. Some pe' +
          'ople don'#39't like programs that mess about with their system witho' +
          'ut being asked - and so do I.#13#10#13#10This Wizard will explai' +
          'n these features and ask for your permission to activate them.'
        WordWrap = True
      end
    end
    object TabSheet2: TTabSheet
      Caption = '(Updates)'
      ImageIndex = 1
      object Lbl_CheckUpdates: TLabel
        Left = 152
        Top = 16
        Width = 152
        Height = 23
        Caption = 'Check for updates'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Lbl_QeryUpdate: TLabel
        Left = 152
        Top = 172
        Width = 350
        Height = 70
        AutoSize = False
        Caption = 'Allow Nemp to check for updates periodically?'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object ImageUpdate: TVirtualImage
        Left = 8
        Top = 32
        Width = 128
        Height = 128
        ImageCollection = DataModuleGui.ICGraphics
        ImageWidth = 0
        ImageHeight = 0
        ImageIndex = 6
        ImageName = 'imgWizardUpate'
      end
      object st_Updates: TLabel
        Left = 152
        Top = 45
        Width = 350
        Height = 125
        AutoSize = False
        Caption = 
          'Nemp can check for updates and notify you if a newer version of ' +
          'Nemp is available. It will contact www.gausi.de once a week (def' +
          'ault setting, interval can be changed) and ask for the newest ve' +
          'rsion. There is no auto-installer - you have to download and ins' +
          'tall the new version by hand.'
        WordWrap = True
      end
    end
    object TabSheet3: TTabSheet
      Caption = '(QuickAccess)'
      ImageIndex = 2
      object ImageMetaData: TVirtualImage
        Left = 8
        Top = 32
        Width = 128
        Height = 128
        ImageCollection = DataModuleGui.ICGraphics
        ImageWidth = 0
        ImageHeight = 0
        ImageIndex = 4
        ImageName = 'imgWizardMetadata'
      end
      object Lbl_QueryMetadata: TLabel
        Left = 152
        Top = 172
        Width = 350
        Height = 70
        AutoSize = False
        Caption = 'Allow Nemp to change meta data in audio files?'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Lbl_SaveMetadata: TLabel
        Left = 150
        Top = 16
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
      object st_Metadata: TLabel
        Left = 152
        Top = 45
        Width = 350
        Height = 125
        AutoSize = False
        Caption = 
          'If you change the artist, album, rating, ... of a title, or sear' +
          'ch for lyrics or extended tags, Nemp can save these data in the ' +
          'metadata (e.g. ID3-Tags) of the file. This is pretty normal for ' +
          'an mp3-player. However, the files will be changed by this, which' +
          ' may collide with your backup or filesharing strategy.#13#10Note' +
          ': You can always change the metadata explicitly in the "Properti' +
          'es" window.'
        WordWrap = True
      end
    end
    object TabSheet4: TTabSheet
      Caption = '(Rating)'
      ImageIndex = 3
      object ImageRating: TVirtualImage
        Left = 8
        Top = 32
        Width = 128
        Height = 128
        ImageCollection = DataModuleGui.ICGraphics
        ImageWidth = 0
        ImageHeight = 0
        ImageIndex = 5
        ImageName = 'imgWizardRating'
      end
      object Lbl_Rating: TLabel
        Left = 152
        Top = 16
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
        Left = 152
        Top = 172
        Width = 350
        Height = 70
        AutoSize = False
        Caption = 'Automatically adjust the rating of your files?'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object st_Rating: TLabel
        Left = 152
        Top = 45
        Width = 350
        Height = 125
        AutoSize = False
        Caption = 
          'Nemp can adjust the rating of your music files automatically. If' +
          ' you frequently play a song, it will be rated better. On the oth' +
          'er side: If you abort a song in your playlist, its rating will b' +
          'e decreased a little.#13#10Note: This will be saved within the f' +
          'ile, if you answered the previous question with "yes", so the fi' +
          'les are changed quite often then.'
        WordWrap = True
      end
    end
    object TabSheet5: TTabSheet
      Caption = '(LastFM)'
      ImageIndex = 4
      object ImageLastFM: TVirtualImage
        Left = 3
        Top = 32
        Width = 128
        Height = 128
        ImageCollection = DataModuleGui.ICGraphics
        ImageWidth = 0
        ImageHeight = 0
        ImageIndex = 2
        ImageName = 'imgWizardLastFM'
      end
      object Lbl_LastFM: TLabel
        Left = 152
        Top = 16
        Width = 141
        Height = 23
        Caption = 'Missing cover art'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Lbl_QueryLastFM: TLabel
        Left = 152
        Top = 172
        Width = 350
        Height = 70
        AutoSize = False
        Caption = 'Automatically download missing cover art from last.fm?'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object st_LastFM: TLabel
        Left = 152
        Top = 45
        Width = 350
        Height = 125
        AutoSize = False
        Caption = 
          'Nemp tries to find a proper cover art for your audio files withi' +
          'n the ID3-Tag or the directory of the file. If no cover art was ' +
          'found, Nemp can try to download the missing cover art from last.' +
          'fm. This image will be saved within the directory of the respect' +
          'ive audio file. '
        WordWrap = True
      end
    end
    object TabSheet6: TTabSheet
      Caption = '(filetypes)'
      ImageIndex = 6
      object ImageFiletypes: TVirtualImage
        Left = 8
        Top = 32
        Width = 128
        Height = 128
        ImageCollection = DataModuleGui.ICGraphics
        ImageWidth = 0
        ImageHeight = 0
        ImageIndex = 1
        ImageName = 'imgWizardFiletypes'
      end
      object Lbl_Filetypes: TLabel
        Left = 152
        Top = 16
        Width = 195
        Height = 23
        Caption = 'Nemp as default player'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Lbl_QueryFiletypes: TLabel
        Left = 152
        Top = 172
        Width = 350
        Height = 70
        AutoSize = False
        Caption = 'Use Nemp as the default player for audio files?'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object st_filetypes: TLabel
        Left = 152
        Top = 45
        Width = 350
        Height = 125
        AutoSize = False
        Caption = 
          'Nemp can be installed as the default audio player. If you double' +
          ' click a music file or a playlist in the Windows Explorer, this ' +
          'file will be opened with Nemp.#13#10If you want to select the fi' +
          'le types associated with Nemp, you can do it later in the settin' +
          'gs dialog.'
        WordWrap = True
      end
    end
    object TSSummary: TTabSheet
      Caption = '(summary)'
      ImageIndex = 5
      OnShow = TSSummaryShow
      object ImgSummary: TVirtualImage
        Left = 8
        Top = 32
        Width = 128
        Height = 128
        ImageCollection = DataModuleGui.ICGraphics
        ImageWidth = 0
        ImageHeight = 0
        ImageIndex = 3
        ImageName = 'imgWizardMain'
      end
      object Lbl_summary: TLabel
        Left = 152
        Top = 16
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
        Left = 152
        Top = 172
        Width = 331
        Height = 70
        AutoSize = False
        Caption = 'Save settings and close wizard?'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object lbl_sumUpdates: TLabel
        Left = 184
        Top = 48
        Width = 88
        Height = 13
        Caption = 'Check for updates'
      end
      object lbl_sumFiletypes: TLabel
        Left = 184
        Top = 144
        Width = 173
        Height = 13
        Caption = 'Register Nemp as the default player'
      end
      object lbl_sumLastFM: TLabel
        Left = 184
        Top = 120
        Width = 192
        Height = 13
        Caption = 'Download missing cover art from last.fm'
      end
      object lbl_sumRating: TLabel
        Left = 184
        Top = 96
        Width = 133
        Height = 13
        Caption = 'Automatically adjust ratings'
      end
      object lbl_sumMetadata: TLabel
        Left = 184
        Top = 72
        Width = 154
        Height = 13
        Caption = 'Change metadata when needed'
      end
      object img_sumUpdates: TVirtualImage
        Left = 152
        Top = 48
        Width = 16
        Height = 16
        ImageCollection = DataModuleGui.ICIcons
        ImageWidth = 0
        ImageHeight = 0
        ImageIndex = -1
      end
      object img_sumFiletypes: TVirtualImage
        Left = 152
        Top = 144
        Width = 16
        Height = 16
        ImageCollection = DataModuleGui.ICIcons
        ImageWidth = 0
        ImageHeight = 0
        ImageIndex = -1
      end
      object img_sumLastFM: TVirtualImage
        Left = 152
        Top = 120
        Width = 16
        Height = 16
        ImageCollection = DataModuleGui.ICIcons
        ImageWidth = 0
        ImageHeight = 0
        ImageIndex = -1
      end
      object img_sumMetadata: TVirtualImage
        Left = 152
        Top = 72
        Width = 16
        Height = 16
        ImageCollection = DataModuleGui.ICIcons
        ImageWidth = 0
        ImageHeight = 0
        ImageIndex = -1
      end
      object img_sumRating: TVirtualImage
        Left = 152
        Top = 96
        Width = 16
        Height = 16
        ImageCollection = DataModuleGui.ICIcons
        ImageWidth = 0
        ImageHeight = 0
        ImageIndex = -1
      end
    end
  end
end
