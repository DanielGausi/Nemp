object MedienlisteForm: TMedienlisteForm
  Left = 689
  Top = 113
  BorderStyle = bsNone
  ClientHeight = 250
  ClientWidth = 574
  Color = clBtnFace
  Constraints.MinHeight = 200
  Constraints.MinWidth = 300
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnHide = FormHide
  OnKeyDown = FormKeyDown
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object ContainerPanelMedienBibForm: TNempPanel
    Tag = 3
    Left = 0
    Top = 0
    Width = 574
    Height = 250
    Align = alClient
    BevelOuter = bvNone
    DoubleBuffered = False
    ParentDoubleBuffered = False
    TabOrder = 0
    OnMouseDown = ContainerPanelMedienBibFormMouseDown
    OnMouseMove = ContainerPanelMedienBibFormMouseMove
    OnMouseUp = ContainerPanelMedienBibFormMouseUp
    OnPaint = ContainerPanelMedienBibFormPaint
    OwnerDraw = False
    DesignSize = (
      574
      250)
    object CloseImageM: TSkinButton
      Left = 562
      Top = 0
      Width = 12
      Height = 12
      Hint = 'Close medialist window'
      Anchors = [akTop, akRight]
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TabStop = False
      OnClick = CloseImageMClick
      DrawMode = dm_Skin
      NumGlyphsX = 5
      NumGlyphsY = 1
      GlyphLine = 0
      CustomRegion = False
      FocusDrawMode = fdm_Windows
      Color1 = clBlack
      Color2 = clBlack
    end
  end
end
