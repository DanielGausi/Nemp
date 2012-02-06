object AboutForm: TAboutForm
  Left = 1157
  Top = 122
  BorderStyle = bsDialog
  Caption = 'About Nemp'
  ClientHeight = 394
  ClientWidth = 371
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnHide = FormHide
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object NempCredits: TACredits
    Left = 8
    Top = 8
    Width = 353
    Height = 345
    Cursor = crDefault
    Images = ImageList1
    Credits.Strings = (
      '[img="0"]'
      ''
      '[b]Nemp - Noch ein Mp3-Player[/b]'
      ''
      'Copyright '#169' 2005-2012 Daniel '#39'Gausi'#39' Gaussmann'
      ' '
      'Website: [url="http://www.gausi.de"]http://www.gausi.de[/url]'
      'e-Mail: [url="mailto:mail@gausi.de"]mail@gausi.de[/url]'
      ''
      
        '[url="http://www.facebook.com/pages/Nemp-Noch-ein-mp3-Player/172' +
        '590512836097"]Nemp on Facebook[/url]'
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
      'Programmed with CodeGear Delphi 2009'
      ''
      ''
      '[b]Used components/units[/b]'
      ''
      '[url="http://www.soft-gems.net/"]Virtual Treeview[/url]'
      ''
      'The [url="http://www.un4seen.com"]bass.dll[/url] and add-ons'
      ''
      
        'Slightly [url="http://www.gausi.de/wmatags.html"]modified parts[' +
        '/url] of the [url="http://mac.sourceforge.net/atl/"]ATL[/url]'
      ''
      
        '[url="http://www.gausi.de/mp3fileutils.html"]Mp3FileUtils 0.6a[/' +
        'url]'
      ''
      
        '[url="http://www.delphi-forum.de/viewtopic.php?t=48936"]SearchTo' +
        'ols[/url] by Heiko Thiel'
      ''
      '[url="http://dybdahl.dk/dxgettext/"]GNU gettext for Delphi[/url]'
      ''
      
        '[url="http://www.delphipraxis.net/topic114228.html"]TACredits[/u' +
        'rl] (this scrolling thing)'
      ''
      
        '[url="http://www.delphipraxis.net/topic116695_kompo+twindowsvers' +
        'ionsinfo+kompo+zur+windowserkennung.html"]TWindowsVersionInfo[/u' +
        'rl] by MagicAndre1981'
      ''
      
        '[url="http://angusj.com/delphi/"]Drag&Drop-Component[/url] (modi' +
        'fied) by Angus Johnson'
      ''
      
        '[url="http://delphi.fsprolabs.com/"]FSPro Windows 7 Taskbar Comp' +
        'onents[/url]'
      ''
      
        '[url="http://sourceforge.net/projects/flyingcow/"]Flying Cow[/ur' +
        'l] by Mat'#237'as Andr'#233's Moreno'
      ''
      '[url="http://www.last.fm/api/intro"]The LastFM API[/url]'
      ''
      '[url="http://www.shoutcast.com/"]The SHOUTcast API[/url]'
      ''
      '[url="http://www.madshi.net/"]MadExcept[/url] by Mathias Rauen'
      ''
      ''
      '... and many short snips from "the internet"'
      ''
      ''
      '[b]Icons and Graphics[/b]'
      ''
      '[url="http://everaldo.com/crystal"]Chrystal Project Icons[/url]'
      ''
      
        'Silk Icon Set by [url="http://www.famfamfam.com/lab/icons/silk"]' +
        'famfamfam.com[/url]'
      ''
      
        '[url="http://tango.freedesktop.org/Tango_Icon_Library"]Tango Ico' +
        'n Library[/url]'
      ''
      'Nemp Logo by Danny aka Mantis'
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
      
        '... just by saying "thank you, this is a fine piece of software"' +
        ' '
      ''
      ''
      '[b]Special Thanks to[/b]'
      ''
      'pol... for his "concrete feedback"'
      ''
      ''
      '[row="200"]'
      ''
      ''
      '[b]Some music I listened to during coding[/b]'
      ''
      'The Avatar Soundtrack'
      ''
      
        '[url="http://www.jamendo.com/de/album/78275"]Kendra Springer - H' +
        'ope[/url]'
      ''
      'I think its ok to mention some amazing billion-dollar-stuff '
      'and a wonderful creative-commons-work in one sentence...'
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
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clSilver
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    position = 0
    EnableDragging = True
    Smooth = [spTop, spBottom]
    TextOffset = 1
  end
  object BtnOK: TButton
    Left = 288
    Top = 360
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
    Top = 360
    Width = 75
    Height = 25
    Caption = 'Donate'
    TabOrder = 1
    OnClick = BtnDonateClick
  end
  object ImageList1: TImageList
    Height = 112
    Width = 155
    Left = 24
    Top = 272
  end
end
