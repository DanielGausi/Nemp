object AboutForm: TAboutForm
  Left = 1157
  Top = 122
  BorderStyle = bsDialog
  Caption = 'About Nemp'
  ClientHeight = 393
  ClientWidth = 367
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnHide = FormHide
  OnShow = FormShow
  DesignSize = (
    367
    393)
  TextHeight = 13
  object NempCredits: TACredits
    AlignWithMargins = True
    Left = 8
    Top = 8
    Width = 339
    Height = 345
    Cursor = crDefault
    Images = ImageList1
    Credits.Strings = (
      '[img="0"]'
      ''
      '[b]Nemp - Noch ein Mp3-Player[/b]'
      ''
      'Copyright '#169' 2005-2024 Daniel '#39'Gausi'#39' Gaussmann'
      ' '
      'Website: [url="https://www.gausi.de"]https://www.gausi.de[/url]'
      'e-Mail: [url="mailto:mail@gausi.de"]mail@gausi.de[/url]'
      ''
      
        '[url="https://www.facebook.com/pages/Nemp-Noch-ein-mp3-Player/17' +
        '2590512836097"]Nemp on Facebook[/url]'
      ''
      ''
      '[row="250"]'
      ''
      '[b]Nemp is Free Software[/b]'
      ''
      'You can redistribute it and/or modify it under the terms of the '
      '[anchor="gpl"]GNU General Public License (GPL)[/anchor].'
      ''
      ''
      '[row="250"]'
      ''
      'If you like it, please send me a postcard to '
      ''
      '[Offset="100"]Daniel Gaussmann'
      '[Offset="100"]Oppelner Weg 27'
      '[Offset="100"]40627 Duesseldorf'
      '[Offset="100"]Germany'
      ''
      '[row="200"]'
      ''
      ''
      'Programmed with CodeGear Delphi 2009 - 11.3'
      ''
      ''
      '[b]Used components/units[/b]'
      ''
      'The [url="http://www.un4seen.com"]bass.dll[/url] and add-ons'
      ''
      
        '[url="https://gausi.de/awb.html"]Audio Werkzeuge Bibliothek[/url' +
        ']'
      ''
      
        '[url="https://www.jam-software.de/virtual-treeview"]Virtual Tree' +
        'view[/url]'
      ''
      
        '[url="http://sourceforge.net/projects/flyingcow/"]Flying Cow[/ur' +
        'l] by Mat'#237'as Andr'#233's Moreno'
      ''
      
        '[url="https://www.delphi-forum.de/viewtopic.php?t=48936"]SearchT' +
        'ools[/url] by Heiko Thiel'
      ''
      
        '[url="https://www.entwickler-ecke.de/viewtopic.php?t=100088"]Fas' +
        'tFileStream[/url] by Flamefire et al.'
      ''
      '[url="http://dybdahl.dk/dxgettext/"]GNU gettext for Delphi[/url]'
      ''
      
        '[url="https://www.delphipraxis.net/topic114228.html"]TACredits[/' +
        'url] (this scrolling thing)'
      ''
      
        '[url="https://www.delphipraxis.net/topic116695_kompo+twindowsver' +
        'sionsinfo+kompo+zur+windowserkennung.html"]TWindowsVersionInfo[/' +
        'url] by MagicAndre1981'
      ''
      '[url="https://www.last.fm/api/intro"]The LastFM API[/url]'
      ''
      '[url="http://www.madshi.net/"]MadExcept[/url] by Mathias Rauen'
      ''
      ''
      '... and many short snips from "the internet"'
      ''
      ''
      '[b]Icons and Graphics[/b]'
      ''
      'Chrystal Project Icons by Everaldo Coelho'
      ''
      
        'Silk Icon Set by [url="https://github.com/legacy-icons/famfamfam' +
        '-silk"]famfamfam.com[/url]'
      ''
      
        '[url="https://github.com/nigeltao/tango-icon-library-pngs"]Tango' +
        ' Icon Library[/url]'
      ''
      'Nemp Logo and default skin by J'#252'rgen Poley'
      ''
      ''
      '[row="200"]'
      ''
      ''
      '[b]Thanks to all who helped me ...[/b]'
      ''
      '... by solving programming problems'
      ''
      '... by testing and sending bugreports'
      ''
      '... by nagging about peanuts'
      ''
      '... by sending test material'
      ''
      
        '... just by saying "thank you, this is a fine piece of software"' +
        ' '
      ''
      ''
      '[b]Special thanks to[/b]'
      ''
      'J'#252'rgen W. for a lively exchange of ideas during development'
      ''
      ''
      '[row="200"]')
    LinkFont.Charset = DEFAULT_CHARSET
    LinkFont.Color = clGray
    LinkFont.Height = -11
    LinkFont.Name = 'Tahoma'
    LinkFont.Style = [fsUnderline]
    AnchorFont.Charset = DEFAULT_CHARSET
    AnchorFont.Color = clGray
    AnchorFont.Height = -11
    AnchorFont.Name = 'Tahoma'
    AnchorFont.Style = [fsUnderline]
    BorderColor = clSilver
    Interval = 75
    OnAnchorClicked = NempCreditsAnchorClicked
    BackgroundImage.Data = {07544269746D617000000000}
    ForeGroundImage.Data = {07544269746D617000000000}
    ShowBorder = False
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clSilver
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    position = 0
    EnableDragging = True
    Smooth = [spTop, spBottom]
    TextOffset = 1
    ExplicitWidth = 353
  end
  object BtnOK: TButton
    AlignWithMargins = True
    Left = 280
    Top = 361
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Ok'
    Default = True
    TabOrder = 0
    OnClick = BtnOKClick
  end
  object BtnDonate: TButton
    Left = 8
    Top = 359
    Width = 75
    Height = 25
    Caption = 'Donate'
    TabOrder = 1
    OnClick = BtnDonateClick
  end
  object ImageList1: TImageList
    Height = 122
    Width = 200
    Left = 24
    Top = 272
  end
end
