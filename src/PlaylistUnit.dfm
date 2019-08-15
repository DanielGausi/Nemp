object PlaylistForm: TPlaylistForm
  Left = 218
  Top = 190
  BorderStyle = bsNone
  ClientHeight = 303
  ClientWidth = 420
  Color = clBtnFace
  Constraints.MinHeight = 200
  Constraints.MinWidth = 400
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
  object ContainerPanelPlaylistForm: TNempPanel
    Tag = 1
    Left = 0
    Top = 0
    Width = 420
    Height = 303
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    OnMouseDown = ContainerPanelPlaylistFormMouseDown
    OnMouseMove = ContainerPanelPlaylistFormMouseMove
    OnMouseUp = ContainerPanelPlaylistFormMouseUp
    OnPaint = ContainerPanelPlaylistFormPaint
    OwnerDraw = False
    ExplicitWidth = 244
    DesignSize = (
      420
      303)
    object CloseImageP: TSkinButton
      Left = 408
      Top = 0
      Width = 12
      Height = 12
      Hint = 'Close playlist window'
      Anchors = [akTop, akRight]
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TabStop = False
      OnClick = CloseImagePClick
      DrawMode = dm_Skin
      NumGlyphsX = 5
      NumGlyphsY = 1
      GlyphLine = 0
      CustomRegion = False
      FocusDrawMode = fdm_Windows
      Color1 = clBlack
      Color2 = clBlack
      ExplicitLeft = 232
    end
  end
end
