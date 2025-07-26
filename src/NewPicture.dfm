object FNewPicture: TFNewPicture
  Left = 1209
  Top = 114
  BorderStyle = bsDialog
  Caption = 'Add a picture'
  ClientHeight = 309
  ClientWidth = 559
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 13
  object pnlButtons: TPanel
    Left = 0
    Top = 279
    Width = 559
    Height = 30
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 551
    object Btn_Cancel: TButton
      AlignWithMargins = True
      Left = 454
      Top = 4
      Width = 97
      Height = 22
      Margins.Left = 8
      Margins.Top = 4
      Margins.Right = 8
      Margins.Bottom = 4
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 0
      ExplicitLeft = 446
    end
    object Btn_OK: TButton
      AlignWithMargins = True
      Left = 341
      Top = 4
      Width = 97
      Height = 22
      Margins.Left = 8
      Margins.Top = 4
      Margins.Right = 8
      Margins.Bottom = 4
      Align = alRight
      Caption = 'Ok'
      Default = True
      Enabled = False
      TabOrder = 1
      OnClick = Btn_OKClick
      ExplicitLeft = 333
    end
  end
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 559
    Height = 279
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitWidth = 551
    object grpData: TGroupBox
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 281
      Height = 271
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alLeft
      Caption = 'Select image'
      TabOrder = 0
      DesignSize = (
        281
        271)
      object LblConst_PictureDescription: TLabel
        Left = 8
        Top = 122
        Width = 153
        Height = 13
        Caption = 'Short description for the picture'
      end
      object LblConst_PictureFilename: TLabel
        Left = 8
        Top = 24
        Width = 42
        Height = 13
        Caption = 'Filename'
      end
      object LblConst_PictureType: TLabel
        Left = 8
        Top = 74
        Width = 58
        Height = 13
        Hint = 'Select image'
        Caption = 'Picture type'
      end
      object Btn_ChoosePicture: TButton
        Left = 244
        Top = 42
        Width = 30
        Height = 21
        Hint = 'Select image'
        Anchors = [akTop, akRight]
        Caption = '...'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = Btn_ChoosePictureClick
      end
      object cbPictureType: TComboBox
        Left = 8
        Top = 92
        Width = 266
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 1
      end
      object EdtFilename: TEdit
        Left = 8
        Top = 42
        Width = 227
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 2
        OnEnter = EdtFilenameEnter
        OnExit = EdtFilenameExit
      end
      object EdtPictureDescription: TEdit
        Left = 8
        Top = 140
        Width = 266
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 3
        OnChange = EdtPictureDescriptionChange
      end
      object PnlWarnung: TPanel
        Left = 2
        Top = 176
        Width = 277
        Height = 93
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 4
        object ImageWarning: TVirtualImage
          Left = 8
          Top = 0
          Width = 24
          Height = 24
          ImageCollection = DataModuleGui.ICIcons
          ImageWidth = 0
          ImageHeight = 0
          ImageIndex = 33
          ImageName = 'MenuWarning'
        end
        object Lbl_Warnings: TLabel
          AlignWithMargins = True
          Left = 40
          Top = 0
          Width = 229
          Height = 85
          Margins.Left = 8
          Margins.Top = 0
          Margins.Right = 8
          Margins.Bottom = 8
          Align = alRight
          AutoSize = False
          Caption = 'Duplicate description'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = False
          WordWrap = True
          ExplicitTop = 29
          ExplicitHeight = 91
        end
      end
    end
    object grpPreview: TGroupBox
      AlignWithMargins = True
      Left = 293
      Top = 4
      Width = 262
      Height = 271
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      Caption = 'Preview'
      TabOrder = 1
      ExplicitWidth = 254
      object ImageCover: TImage
        AlignWithMargins = True
        Left = 10
        Top = 23
        Width = 242
        Height = 238
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 8
        Align = alClient
        Picture.Data = {
          0954506E67496D61676589504E470D0A1A0A0000000D49484452000001000000
          010008060000005C72A866000000017352474200AECE1CE90000000467414D41
          0000B18F0BFC6105000000097048597300000EC100000EC101B8916BED000008
          B64944415478DAEDDD894E14591FC6E1C21D44DCC035D1BBFBAED75B70571454
          DC70C3C9E9F9CEB801364D559D3AE7FF3C891927990C0DF1FD75577575B974EF
          DEBDFF7540484B02007109000426001098004060020081090004260010980040
          6002008109000426001098004060020081090004260010980040600200810900
          0426001098004060020081090004260010980040600200810900042600109800
          4060020081090004260010980040600200810900042600109800406002008109
          0004260010980040600200810900042600109800406002008109000426001098
          0040600200810900042600109800406002008109000426001098004060020081
          0900042600109800406002008109000426001098004060020081090004260010
          98004060020081850CC0D2D25277F2E4C9FFFEFDDBB76FDDF7EFDF4B3F2C185D
          8800A4B1AFACAC74CBCBCBDD993367BA53A74EFDF1DF7CFDFAB5DBDDDD9DFDFA
          F0E143B7B7B757FA61C3E09A0E401AFBC58B1767E34FCFFAF34AE37FF7EE5DB7
          B3B3330B03B4AAC900A4B15FBE7CB9BB70E1C29186FFBB1482376FDECC42E010
          8116351780D3A74F77D7AE5D9BFDB32FE9B0E0C58B17B37305D092A60270F6EC
          D9D9F87F3EC1D7972F5FBE74CF9F3F774840539A09403ADEBF71E34677E2C489
          C1BE468AC0B367CFBC12A0194D04208DFEE6CD9BBDBEEC3F483A1C4811801634
          1180F5F5F56E757575B4AFF7EAD5ABD9C941A85DF50148C7FDE9D97F4CE9DD81
          274F9E381F40F5AA0FC0F5EBD76717F88C2DBD35B8BDBD5DFADB8763A93A00E9
          98FFF6EDDB45BE767A15F0F0E143D70750B5AA0370E9D2A5D9AF52D2B501EFDF
          BF2FFD638085551D8074EC9FCE0194922E177EF9F265E91F032CACDA00A44B7C
          EFDCB973AC4B7D8F2B5D17F0F8F1E3D23F0A5858B5012879FC9FA5E3FF070F1E
          380F40B5AA0DC0B973E76657FE95964E04BA32905A551B80F4D65F7A0BB0B474
          08900E05A046D506602AAF001E3D7AE48220AA556D00D2877F6EDDBA55FA6174
          F7EFDF770E806A551B8074F6FFEEDDBB451F437AE64FAF00A056D5062049AF00
          D22B8152D24540E96220A855D501B872E54AB7B6B656ECEB6F6D6D756FDFBE2D
          FD638085551D80129F04CCD2717F7A0BD0DD83A959D501484A5D0EEC32605A50
          7D00D22DBFD37D00C7949EFDD3FD00BCFF4FEDAA0F40920290423016F702A015
          4D0420DD0538BD2330C4DD807FF7F9F3E7EEE9D3A7DEFBA7094D0420495706A6
          4B8387FC7460BAE63FDD10D44B7F5AD14C00927418B0B1B1314804D2F8373737
          BB4F9F3E95FE36A1374D052049AF045204FA3C1C48CFF869FC9EF9694D730148
          D2F8AF5EBDDACB89C174A14FBA0DB8F7FB69519301C8D24786D33D0317B94EE0
          E3C78FDDEBD7AFBDE4A7694D07204B01387FFEFCECF0E0A0CF0EA4B3FAE90C7F
          1A7EBAC6DFCB7D220811805FBEE1A5A5D9EDC4D25F27967E9F869F4EF0A54FF6
          796B8F68C20500F8410020300180C00400021300084C0020300180C004000213
          00084C0020300180C00400021300084C0020300180C00400021300084C002030
          01A057E9DE8BE91E8CFEEAB43A0800BD49E35F5F5F9FDD6B31DD4E7D6B6BABF4
          43E22F04805EFC3CFE4C04A64F0038B6FDC69F89C0B40900C772D8F83311982E
          016061F38C3F1381691200167294F16722303D02C0912D32FE4C04A645003892
          E38C3F1381E91000E6D6C7F83311980601602E7D8E3F1381F20480BF1A62FC99
          089425001C6AC8F16722508E0070A031C69F89401902C0BEC61C7F2602E31300
          FE5062FC99088C4B00F845C9F16722301E01E03F53187F2602E3100066A634FE
          4C048627004C72FC99080C4B00829BF2F83311188E000456C3F8331118860004
          55D3F83311E89F000454E3F83311E897000453F3F83311E88F0004D2C2F83311
          E887001C511A4F1A51FA03B8BBBB5BFAE1CCADA5F16722707C027004693C1B1B
          1BDDCACA4AB7B7B7D76D6E6E56118116C79F89C0F108C09C7E1E7F5643045A1E
          7F26028B138039EC37FE6CCA118830FE4C041623007F71D8F8B3294620D2F833
          11383A0138C43CE3CFA6148188E3CF44E06804E00047197F368508441E7F2602
          F313807D2C32FEAC64048CFF0711988F00FCE638E3CF4A44C0F8FF24027F2700
          3FE963FCD9981130FE8389C0E104E0FFFA1C7F3646048CFFEF44E06002D00D33
          FE6CC80818FFFC44607FE10330E4F8B3212260FC4727027F0A1D8031C69FF519
          01E35F9C08FC2A6C00C61C7FD647048CFFF844E08790012831FEEC381130FEFE
          88C0BFC205A0E4F8B3452260FCFD1381600198C2F8B3A344C0F887133D026102
          30A5F167F344C0F887173902210230C5F1678745C0F8C7133502CD0760CAE3CF
          F68B80F18F2F62049A0E400DE3CF7E8E80F197132D02CD06A0A6F1672902E90F
          E0DADA9AF117B4B3B3D36D6F6F977E18A3683200358E9F6989F24AA0B900183F
          7D891081A60260FCF4ADF508341300E367282D47A08900183F436B3502D507C0
          F8194B8B11A83A00C6CFD85A8B40B501307E4A6929025506C0F829AD95085417
          00E3672A5A88405501307EA6A6F608541300E367AA6A8E401501307EA6AED608
          4C3E00C64F2D6A8CC0A40360FCD4A6B6084C3600C64FAD6A8AC0240360FCD4AE
          96084C2E00C64F2B6A88C0A40260FCB466EA11984C008C9F564D3902930880F1
          D3BAA946A078008C9F28A61881A201307EA2995A048A05C0F8896A4A11281200
          E327BAA94460F400183FFC6B0A11183500C60FBF2A1D81D10260FCB0BF921118
          2500C60F872B1581C10360FC309F1211183400C60F47337604060B80F1C362C6
          8CC02001307E389EB122D07B008C1FFA3146047A0D80F143BF868E406F01307E
          18C69011E82D00ABABABDDF2F2F2A83F18882245607777B7F7FF6FF1FB0100E5
          0800042600109800406002008109000426001098004060020081090004260010
          9800406002008109000426001098004060020081090004260010980040600200
          8109000426001098004060020081090004260010980040600200810900042600
          1098004060020081090004260010980040600200810900042600109800406002
          008109000426001098004060020081090004260010D83FE01AC15BB173CC2200
          00000049454E44AE426082}
        Proportional = True
        Stretch = True
        Transparent = True
        OnDblClick = ImageCoverDblClick
        ExplicitLeft = 8
        ExplicitTop = 24
        ExplicitWidth = 256
        ExplicitHeight = 256
      end
    end
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Filter = 'Supported files (*.jpg;*.jpeg;*.png)|*.jpg;*.jpeg;*.png;'
    Left = 400
    Top = 48
  end
end
