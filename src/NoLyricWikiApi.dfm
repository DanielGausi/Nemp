object NoLyricWikiApiForm: TNoLyricWikiApiForm
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'LyricWiki-API is down'
  ClientHeight = 350
  ClientWidth = 340
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 8
    Top = 7
    Width = 48
    Height = 19
    Caption = 'Sorry, '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Bevel1: TBevel
    Left = 24
    Top = 176
    Width = 289
    Height = 9
    Shape = bsBottomLine
  end
  object Memo1: TMemo
    Left = 24
    Top = 79
    Width = 289
    Height = 58
    BevelOuter = bvSpace
    Color = clBtnFace
    Ctl3D = False
    Lines.Strings = (
      'Unfortunately, due to licensing restrictions from some '
      'of the major music publishers we can no longer return'
      'lyrics through the LyricWiki API (where this application'
      'gets [...] its lyrics).')
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 1
  end
  object Memo2: TMemo
    Left = 8
    Top = 32
    Width = 321
    Height = 41
    BevelOuter = bvNone
    BorderStyle = bsNone
    Color = clBtnFace
    Ctl3D = False
    Lines.Strings = (
      'This functionality is (temporarily) disabled. '
      ''
      'Quote from LyricWiki.org:')
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 0
  end
  object Memo3: TMemo
    Left = 8
    Top = 143
    Width = 321
    Height = 27
    BevelOuter = bvNone
    BorderStyle = bsNone
    Color = clBtnFace
    Ctl3D = False
    Lines.Strings = (
      'I'#39'm working on an alternative to bypass these inconvenience, '
      'but for now it is just disabled.')
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 2
  end
  object Memo4: TMemo
    Left = 8
    Top = 198
    Width = 321
    Height = 96
    BevelOuter = bvNone
    BorderStyle = bsNone
    Color = clBtnFace
    Ctl3D = False
    Lines.Strings = (
      'Auf Deutsch:'
      ''
      
        'Die Lyric-Suche funktioniert nicht mehr, weil die sehr verehrten' +
        ' '
      'Damen und Herren einiger Major-Labels das nicht mehr wollen.'
      ''
      'Ich arbeite daran, dieses Problem zu umgehen, aber f'#252'rs erste '
      'ist das hier abgeschaltet.')
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 3
  end
  object Button1: TButton
    Left = 120
    Top = 312
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 4
  end
end
