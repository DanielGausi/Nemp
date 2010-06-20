object MedienlisteForm: TMedienlisteForm
  Left = 689
  Top = 113
  BorderStyle = bsNone
  ClientHeight = 180
  ClientWidth = 574
  Color = clBtnFace
  Constraints.MinHeight = 180
  Constraints.MinWidth = 230
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
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
    Height = 180
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    OnMouseDown = ContainerPanelMedienBibFormMouseDown
    OnMouseMove = ContainerPanelMedienBibFormMouseMove
    OnMouseUp = ContainerPanelMedienBibFormMouseUp
    OnPaint = ContainerPanelMedienBibFormPaint
    OwnerDraw = False
    DesignSize = (
      574
      180)
    object CloseImage: TSkinButton
      Left = 562
      Top = 0
      Width = 12
      Height = 12
      Hint = 'Close medialist window'
      Anchors = [akTop, akRight]
      DoubleBuffered = True
      ParentDoubleBuffered = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TabStop = False
      OnClick = CloseImageClick
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
