object PlaylistForm: TPlaylistForm
  Left = 218
  Top = 190
  BorderStyle = bsNone
  ClientHeight = 303
  ClientWidth = 420
  Color = clBtnFace
  Constraints.MinHeight = 200
  Constraints.MinWidth = 300
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnHide = FormHide
  OnKeyDown = FormKeyDown
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  OnResize = FormResize
  OnShow = FormShow
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
    Ratio = 0
    OnPaint = ContainerPanelPlaylistFormPaint
    OwnerDraw = False
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
    end
    object pnlSplit: TPanel
      AlignWithMargins = True
      Left = 7
      Top = 2
      Width = 406
      Height = 294
      Margins.Left = 7
      Margins.Top = 2
      Margins.Right = 7
      Margins.Bottom = 7
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
    end
  end
end
