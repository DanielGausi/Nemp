{*******************************************************************************

The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in
compliance with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/

Alternatively, you may redistribute this library, use and/or modify 
it under the terms of the GNU Lesser General Public License as published
by the Free Software Foundation; either version 2.1 of the License, or 
(at your option) any later version.
You may obtain a copy of the LGPL at http://www.gnu.org/copyleft/.

Software distributed under the License is distributed on an "AS IS"
basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
License for the specific language governing rights and limitations
under the License.

The Original Code is Credits.PAS, released on 2007-07-13.

The Initial Developer of the Original Code is Maximilian Sachs.
All Rights Reserved.

You may retrieve the latest version of this file at the Aviant home page,
located at http://www.aviant.net

Known Issues:
  None.

Special Thanks
  Lukas Erlacher: Cursor-Bug (Cursor got lost sometime due to links/anchors).
  Sko: PNG-Support (Foreground & Background), Foreground pictures

@Author Maximilian Sachs  
@Version Version 1.2 RC 1 (2008-04-27)
*******************************************************************************

Slightly modified by Daniel Gauﬂmann for Nemp:
 - added property position: Integer read TPos write TPos; in class TACredits
 - enabled {$DEFINE NOPNGSUPPORT}
}

{ #Todo(Normal): Check the "Known Issues"-Zone }

// Do NOT Change
{$INCLUDE Compilers.inc} // Thx to Mike Lischke!
{$IFNDEF DELPHI_9_UP}
  {$DEFINE NO_UNICODE}
  {$DEFINE ORIENTATION_NOTAVAILABLE}
  {$DEFINE DELPHI7_TAGFIX}
{$ENDIF}     

// Changes may be made down here
// Remove the comment below to DISABLE Unicode-Support
// {$DEFINE NO_UNICODE}
// As far as I know the Font.Orientation was first introduced in BDS 2005
// {$DEFINE ORIENTATION_NOTAVAILABLE}
// {$DEFINE DELPHI7_TAGFIX}
 {$DEFINE NOPNGSUPPORT}
unit Credits;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StrUtils, ShellAPI {$IFNDEF NO_UNICODE}, WideStrings{$ENDIF} {$IFNDEF NOPNGSUPPORT}, PNGImage{$ENDIF};

type
  {$IFDEF NO_UNICODE}
  {*
  Event which can be called for various reasons.
  @param Sender The instance of the calling object.
  @param CreditText The current content of the component (credits).
  *}
  TCreditEvent = procedure(Sender: TObject; CreditText: string) of
    object;
  {*
  This event will be called if an [anchor=""] tag was clicked.
  @param Sender The instance of the calling object.
  @param Anchor The name(identifier) of the clicked anchor
  *}
  TOnAnchorClicked = procedure(Sender: TObject; Anchor: string) of
    object;
  {*
  This event will be called if a [row] is going to be drawn.
  In this event one could take over the drawing (custom layout)
  @param Sender The instance of the calling object.
  @param CurrentLine The line of text which the [row] will be drawn in.
  @param DrawRect The rect where the [row] should be drawn in
  @param Color The current color. But you might use another one.
  @param TargetCanvas The canvas where the [row] is being drawn on.
  *}
  TOnDrawRow = procedure(Sender: TObject; CurrentLine: string; DrawRect:
    TRect; Color: TColor; TargetCanvas: TCanvas) of object;
  {*
  Event which can be called if something happens with the cursor.
  @param Sender The instance of the calling object.
  @param CreditText The current content of the component (credits).
  @param Button The pressed mousebutton.
  @param Shift Determines if any Shift-Keys are active.
  @param X The X-Coordinate.
  @param Y The Y-Coordinate.
  *}
  TCreditMouseEvent = procedure(Sender: TObject; CreditText: string;
    Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  {$ELSE}
  {*
  Event which can be called for various reasons.
  @param Sender The instance of the calling object.
  @param CreditText The current content of the component (credits).
  *}
  TCreditEvent = procedure(Sender: TObject; CreditText: WideString) of
    object;
  {*
  This event will be called if an [anchor=""] tag was clicked.
  @param Sender The instance of the calling object.
  @param Anchor The name(identifier) of the clicked anchor
  *}
  TOnAnchorClicked = procedure(Sender: TObject; Anchor: WideString) of
    object;
  {*
  This event will be called if a [row] is going to be drawn.
  In this event one could take over the drawing (custom layout)
  @param Sender The instance of the calling object.
  @param CurrentLine The line of text which the [row] will be drawn in.
  @param DrawRect The rect where the [row] should be drawn in
  @param Color The current color. But you might use another one.
  @param TargetCanvas The canvas where the [row] is being drawn on.
  *}
  TOnDrawRow = procedure(Sender: TObject; CurrentLine: WideString; DrawRect:
    TRect; Color: TColor; TargetCanvas: TCanvas) of object;
  {*
  Event which can be called if something happens with the cursor.
  @param Sender The instance of the calling object.
  @param CreditText The current content of the component (credits).
  @param Button The pressed mousebutton.
  @param Shift Determines if any Shift-Keys are active.
  @param X The X-Coordinate.
  @param Y The Y-Coordinate.
  *}
  TCreditMouseEvent = procedure(Sender: TObject; CreditText: WideString;
    Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  {$ENDIF}
  {*
  TCommonEvent is just a simple (the simpliest) event.
  @param Sender The instance of the calling object.
  *}
  TCommonEvent = procedure(Sender: TObject) of object;
  {*
  Will be called if a picture is being drawn. If the picture is smaller than
  the others (in the imagelist) and the rest of it might be transparent you can
  redefine the height/width here. The picture will be fully drawn, but the
  changes will affect any other tags/text in that line.
  @param Sender The instance of the calling object.
  @param ImageIndex The ImageIndex of the picture this procedure was called for.
  @param NewWidth Overwrite this parameter to redefine the Width.
  @param NewHeight Overwrite this parameter to redefine the Height.
  *}
  TCustomPicSizeEvent = procedure(Sender: TObject; ImageIndex: Integer;
    out NewWidth: Integer; out NewHeight: Integer) of object;
  /// Defines the direction in which the text is scrolling
  TScrollingDirection = (sdForward, sdBackward);
  /// Defines the position of a Smooth-Line either on top or on bottom
  TSmoothPosition = (spTop, spBottom);
  /// A set of position because both can be enabled at a time
  TEnableSmooth = set of TSmoothPosition;
  /// How big is a full formatted text line? It's stored in this record.
  TLineConstraint = record
    /// Determines the height of the line.
    Height: Integer;
    /// Determines the width of the line.
    Width: Integer;
  end;
  /// Defines where the text is rendered
  TTextAlign = (taLeft, taRight, taCenter);
  /// Used for preprocessing the lines
  TPaintAction = (paPreProcessor, paPainter, paFinished);
  /// Determines if this is a Single, End or Begin - Tag.
  TSmartTagConstraint = (tcBeginTag, tcEndTag, tcSingleTag);
  /// All supported tags are mentioned in TSmartTag.
  TSmartTag = (stBold, stItalic, stUnderline, stColor, stFont, stUrl, stAnchor,
    stStrikeOut, stSize, stImage, stOffset, stRow);
  /// The Smart-Tag with full information, ready for the list.
  TFullSmartTag = record
    /// Determines if this is a Single, End or Begin - Tag.
    TagContraint: TSmartTagConstraint;
    /// Determines which tags we have to deal with here.
    SmartTag: TSmartTag;
    /// If the SmartTag has parameters HasParemeter is set to TRUE.
    HasParameter: Boolean;
    /// Additional Paremeters, only filled when HasParemeter is set to true.
    {$IFDEF NO_UNICODE}
    Parameter: string;
    {$ELSE}
    Parameter: WideString;
    {$ENDIF}
  end;
  /// Either a link or an anchor is stored in here.
  TAnchorLink = record
    /// This is the current position on the canvas.
    Position: TRect;
    /// Just stored to determine if this is a link or an anchor.
    SmartTag: TSmartTag;
    /// Additional paremeters (Anchor-Name or URL)
    {$IFDEF NO_UNICODE}
    Parameter: string;
    {$ELSE}
    Parameter: WideString;
    {$ENDIF}
  end;
  /// For the list... (Pointer to TFullSmartTag)
  PFullSmartTag = ^TFullSmartTag;
  /// This is the basic class of the component, where all the magic happens.
  TACredits = class(TGraphicControl)
  private
    /// Height of the complete text including formatting etc.
    FFullTextSize: Integer;
    /// Here is all of the unformatted text stored.
    {$IFDEF NO_UNICODE}
    FCredits: TStringList;
    {$ELSE}
    FCredits: TWideStringList;
    {$ENDIF}
    /// The font which is used to display the normal text
    FFont: TFont;
    /// The font which is used to display the links
    FLinkFont: TFont;
    /// The font which is used to display the anchor
    FAnchorFont: TFont;
    /// The offset of the text. Useless when the TEXT is aligned to center
    FTextOffset: Integer;
    /// The alignment of the text. Allowed is left/center/right
    FTextAlign: TTextAlign;
    /// Set to true to enable stopping on mouseover
    FStopAniOnMouseOver: Boolean;
    /// Defines if Dragging of the text is enabled
    FEnableDragging: Boolean;
    /// The Background color.
    FBackgroundColor: TColor;
    /// The Background image
    FBackgroundImage: TPicture;
    /// Can be either the background color or the background image. Don't touch!
    FBackGroundBitmap: TBitmap;
    /// Foreground Image, overlays the Text
    FForegroundImage: TPicture;
    /// Defines the bordercolor
    FBorderColor: TColor;
    /// If set to true the display will be animated, if not it will not.
    FAnimate: Boolean;
    /// Defines the interval in which the timer is set. Useless if FAnimate is false
    FInterval: Integer;
    /// The actual scrolling direction. Allowed: sdForeward, sdBackward
    FDirection: TScrollingDirection;
    /// This is the internal timer. Do not touch unless you know what you are doing
    FTimer: TTimer;
    /// Just to temporary store the Text-position. Used for dragging.
    FOriginalTPos: Integer;
    /// The current Y-Corrdinate of the text.
    YPos: Integer;
    /// The current Y-Corrdinate of the text.
    TPos: Integer;
    /// Temporary to determine if the mouse is being held down. (For dragging)
    FMouseDown: Boolean;
    /// The bitmap which is used for drawing.
    FBitmap: TBitmap;
    /// Will be called if a credit is shown.
    FOnShowCredit: TCreditEvent;
    /// Will be called if an anchor was clicked.
    FOnAnchorClicked: TOnAnchorClicked;
    /// Will be called when the last credit was displayed.
    FAfterLastCredit: TNotifyEvent;
    /// Can be used to redefine the width of a picture
    FCustomPicSizeEvent: TCustomPicSizeEvent;
    /// The image list which holds the images one can embed with [img=""]
    FImageList: TImageList;
    /// Describes the visibility of the component.
    FVisible: Boolean;
    /// The index of the last shown credit
    LastShownIndex: Integer;
    /// If set to true a border will be drawn otherwise it won't
    FShowBorder: Boolean;
    /// Determines which smooth lines should be drawn
    FEnableSmooth: TEnableSmooth;
    /// Temporary var. Used for dragging.
    FCurrentPosLeft: Integer;
    /// The height of the upper smooth line.
    FSmoothTop: Integer;
    /// The height of the smooth line at the bottom.
    FSmoothBottom: Integer;
    /// The array which holds all active links.
    FAnchorLinkList: array of TAnchorLink;
    /// The cursor which will be shown above the component.
    FCursor: TCursor;
    /// The cursor which will be shown above links.
    FLinkCursor: TCursor;
    /// The cursor which will be shown above anchors.
    FAnchorCursor: TCursor;
    /// In this procedure [row]-tags can be customized.
    FOnDrawRow: TOnDrawRow;
    /// A mouse event which will be called if the cursor enters the component
    FOnMouseEnter: TCommonEvent;
    /// A mouse event which will be called if the cursor leaves the component
    FOnMouseLeave: TCommonEvent;  

    procedure SetVisible(Value: boolean);
    procedure ResetAnimation;
    procedure InvalidateTrigger(Sender: TObject);
    procedure SetBackgroundImage(Value: TPicture);
    procedure SetForegroundImage(Value: TPicture);
    procedure SetLinkFont(const Value: TFont);
    procedure SetAnchorFont(const Value: TFont);
    procedure SetEnableSmooth(const Value: TEnableSmooth);
    procedure SetSmoothBottom(Value: Integer);
    procedure SetSmoothTop(Value: Integer);
  protected
    procedure MouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure MouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMRButtonDown(var Message: TWMRButtonDown); message WM_RBUTTONDOWN;
    procedure WMMButtonDown(var Message: TWMMButtonDown); message WM_MBUTTONDOWN;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure WMRButtonDblClk(var Message: TWMRButtonDblClk); message WM_RBUTTONDBLCLK;
    procedure WMMButtonDblClk(var Message: TWMMButtonDblClk); message WM_MBUTTONDBLCLK;
    procedure WMMouseMove(var Message: TWMMouseMove); message WM_MOUSEMOVE;
    procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
    procedure WMRButtonUp(var Message: TWMRButtonUp); message WM_RBUTTONUP;
    procedure WMMButtonUp(var Message: TWMMButtonUp); message WM_MBUTTONUP;


    {$IFDEF NO_UNICODE}
    procedure SetCredits(Value: TStringList);
    {$ELSE}
    procedure SetCredits(Value: TWideStringList);
    {$ENDIF}
    procedure SetFont(Value: TFont);
    procedure SetCursor(Value: TCursor);
    procedure SetBackgroundColor(Value: TColor);
    procedure SetBorderColor(Value: TColor);
    procedure SetAnimate(Value: Boolean);
    procedure SetInterval(Value: Integer);
    procedure SetDirection(ADirection: TScrollingDirection);
    {$IFDEF NO_UNICODE}
    procedure DoShowCredit(const ACredit: string); virtual;
    {$ELSE}
    procedure DoShowCredit(const ACredit: WideString); virtual;
    {$ENDIF}

    procedure DoAfterLastCredit; virtual;                            
    procedure SetShowBorder(Value: boolean);

    procedure SetTextOffset(AOffset: Integer);
    procedure SetTextAlign(ATextAlign: TTextAlign);
    procedure AddPossibleLink(ATagList: TList; APosition: TRect);
    procedure ClearLinkList;
    {$IFDEF NO_UNICODE}
    function CheckTag(ATag: string; out AFoundTag: TFullSmartTag): Boolean;
    {$ELSE}
    function CheckTag(ATag: WideString; out AFoundTag: TFullSmartTag): Boolean;
    {$ENDIF}
    procedure SetFormatting(ATagList: TList; ACanvas: TCanvas);
    procedure GetFullTextSize(Sender: TObject);
    procedure RenderText(Y: Integer; ABitmap: TBitmap; ASizeOnly: Boolean);
    procedure DrawRow(ARect: TRect; AColor: TColor; ACanvas: TCanvas);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure TimerFired(Sender: TObject);
    procedure Reset;
    procedure DrawSmoothLine(APosition: TSmoothPosition; AHeight: Integer;
      ABitmap: TBitmap);
    procedure SetBounds(ALeft: Integer; ATop: Integer; AWidth: Integer;
      AHeight: Integer); override;
  published
    property Images: TImageList read FImageList write FImageList;
    {$IFDEF NO_UNICODE}
    property Credits: TStringList Read FCredits Write SetCredits;
    {$ELSE}
    property Credits: TWideStringList Read FCredits Write SetCredits;
    {$ENDIF}
    property LinkFont: TFont Read FLinkFont Write SetLinkFont;
    property AnchorFont: TFont Read FAnchorFont Write SetAnchorFont;
    property Color: TColor Read FBackgroundColor
      Write SetBackgroundColor default clBlack;
    property BorderColor: TColor Read FBorderColor Write SetBorderColor
      default clWhite;
    property Animate: Boolean Read FAnimate Write SetAnimate default False;
    property Interval: Integer Read FInterval Write SetInterval default 50;
    property OnShowCredit: TCreditEvent Read FOnShowCredit Write FOnShowCredit;
    property OnAnchorClicked: TOnAnchorClicked read FOnAnchorClicked write
      FOnAnchorClicked;
    property AfterLastCredit: TNotifyEvent
      Read FAfterLastCredit Write FAfterLastCredit;
    property OnGetCustumPictureSize: TCustomPicSizeEvent
      read FCustomPicSizeEvent write FCustomPicSizeEvent;
    property OnDrawRow: TOnDrawRow read FOnDrawRow write FOnDrawRow;
    property Visible: boolean Read FVisible Write SetVisible default True;
    property BackgroundImage: TPicture Read FBackgroundImage
      Write SetBackgroundImage;
    property ForeGroundImage: TPicture read FForeGroundImage
      write SetForeGroundImage;
    property ShowBorder: boolean Read FShowBorder Write SetShowBorder default
      True;
    /// Will be called if the component was clicked.
    property OnClick;
    /// Will be called if the component was double clicked.
    property OnDblClick;
    /// Will be called if a mouse button is being held down above the component.
    property OnMouseDown;
    /// Will be called if the mouse was released above the component.
    property OnMouseUp;
    /// Will be called if the mouse moves above the component.
    property OnMouseMove;
    /// Decribes the alignment of the whole component
    property Align;
    /// Anchors which bind the component to specific directions can be set here
    property Anchors;
    /// A PopUp-Menu (Right-Click) can be defined here.
    property PopUpMenu;
    property Font: TFont Read FFont Write SetFont;
    /// If set to true, hints will be shown, otherwise they won't
    property ShowHint;
    /// If set to true, the showhint-value of the parent will be used.
    property ParentShowHint;

    property Cursor: TCursor read FCursor write SetCursor;

    property position: Integer read TPos write TPos;
    property OnMouseEnter: TCommonEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TCommonEvent read FOnMouseLeave write FOnMouseLeave;
    property Direction: TScrollingDirection Read FDirection
      write SetDirection default sdBackward;
    property StopAnimationOnMouseOver: Boolean read FStopAniOnMouseOver write
      FStopAniOnMouseOver default False;
    property EnableDragging: Boolean read FEnableDragging write FEnableDragging
      default False;
    property Smooth: TEnableSmooth read FEnableSmooth write SetEnableSmooth
      default [];
    property SmoothTop: Integer read FSmoothTop write SetSmoothTop default 20;
    property SmoothBottom: Integer read FSmoothBottom write SetSmoothBottom
      default 20;
    property TextOffset: Integer read FTextOffset write SetTextOffset
      default 10;
    property TextAlign: TTextAlign read FTextAlign write SetTextAlign default
      taCenter;
    property LinkCursor: TCursor read FLinkCursor write FLinkCursor
      default crhandPoint;
    property AnchorCursor: TCursor read FAnchorCursor write FAnchorCursor
      default crhandPoint;
  end;

procedure Register;

implementation

{*------------------------------------------------------------------------------
  Just the common registering procedure. This procedure will install the
  component into the IDE.
------------------------------------------------------------------------------*}
procedure Register;
begin
  RegisterComponents('Aviant', [TACredits]);
end;

{*------------------------------------------------------------------------------
  This function is used to determine the exact font height/width in pixels.

  @param AFont The font in which the text will be measured.
  @param AText The text which will be measured.
  @param AHeight Set to true to determine the height of the text, for the width
  use false.
  @return The exact width or height of the text (using AFont) in pixels.
------------------------------------------------------------------------------*}
{$IFDEF NO_UNICODE}
function TrueFontSize(AFont: TFont; const AText: string;
  AHeight: Boolean = False): Integer;
{$ELSE}
function TrueFontSize(AFont: TFont; const AText: Widestring;
  AHeight: Boolean = False): Integer;
{$ENDIF}
var
  ldc: HDC;
  lTextSize: Windows.TSize;
  lFont: TFont;
begin
  lFont := TFont.Create;
  try
    lFont.Assign(AFont);
    ldc := GetDC(0);
    SelectObject(lDC, lFont.Handle);
    {$IFDEF NO_UNICODE}
    GetTextExtentPoint32(ldc, PChar(AText), Length(AText), lTextSize);
    {$ELSE}
    GetTextExtentPoint32W(ldc, PWideChar(AText), Length(AText), lTextSize);
    {$ENDIF}
    ReleaseDC(0, lDC);
    if AHeight then
    begin
      Result := lTextSize.cy;
    end
    else
    begin
      Result := lTextSize.cx;
    end;
  finally
    lFont.Free;
  end;
end;

{*------------------------------------------------------------------------------
  The CheckTag function will check a tag (in form of a (wide)string, from "[" to
  "]"). If the tag is supported it fills a TFullSmartTag record with it
  (parameters will be stored also!) and write it into the OUT parameter
  "AFoundTag".

  @param ATag The Smart-tag from the [ to the ].
  @param AFoundTag OUT parameter. If successful this parameter will be filled.
  @return True if successful(tag is supported), otherwise false.
------------------------------------------------------------------------------*}
{$IFDEF NO_UNICODE}
function TACredits.CheckTag(ATag: string;
  out AFoundTag: TFullSmartTag): Boolean;
{$ELSE}
function TACredits.CheckTag(ATag: WideString;
  out AFoundTag: TFullSmartTag): Boolean;
{$ENDIF}
var
  I: Integer;
begin
  Result := False;
  // Bold
  if Lowercase(ATag) = '[b]' then
  begin
    AFoundTag.TagContraint := tcBeginTag;
    AFoundTag.SmartTag := stBold;
    AFoundTag.HasParameter := False;
    AFoundTag.Parameter := '';
    Result := True;
  end;
  if Lowercase(ATag) = '[/b]' then
  begin
    AFoundTag.TagContraint := tcEndTag;
    AFoundTag.SmartTag := stBold;
    AFoundTag.HasParameter := False;
    AFoundTag.Parameter := '';
    Result := True;
  end;
  // StrikeOut
  if Lowercase(ATag) = '[s]' then
  begin
    AFoundTag.TagContraint := tcBeginTag;
    AFoundTag.SmartTag := stStrikeOut;
    AFoundTag.HasParameter := False;
    AFoundTag.Parameter := '';
    Result := True;
  end;
  if Lowercase(ATag) = '[/s]' then
  begin
    AFoundTag.TagContraint := tcEndTag;
    AFoundTag.SmartTag := stStrikeOut;
    AFoundTag.HasParameter := False;
    AFoundTag.Parameter := '';
    Result := True;
  end;
  // Italic
  if Lowercase(ATag) = '[i]' then
  begin
    AFoundTag.TagContraint := tcBeginTag;
    AFoundTag.SmartTag := stItalic;
    AFoundTag.HasParameter := False;
    AFoundTag.Parameter := '';
    Result := True;
  end;
  if Lowercase(ATag) = '[/i]' then
  begin
    AFoundTag.TagContraint := tcEndTag;
    AFoundTag.SmartTag := stItalic;
    AFoundTag.HasParameter := False;
    AFoundTag.Parameter := '';
    Result := True;
  end;
  // Underlined
  if Lowercase(ATag) = '[u]' then
  begin
    AFoundTag.TagContraint := tcBeginTag;
    AFoundTag.SmartTag := stUnderline;
    AFoundTag.HasParameter := False;
    AFoundTag.Parameter := '';
    Result := True;
  end;
  if Lowercase(ATag) = '[/u]' then
  begin
    AFoundTag.TagContraint := tcEndTag;
    AFoundTag.SmartTag := stUnderline;
    AFoundTag.HasParameter := False;
    AFoundTag.Parameter := '';
    Result := True;
  end;
  // Color
  if Lowercase(Copy(ATag, 1, 8)) = '[color="' then
  begin
    AFoundTag.TagContraint := tcBeginTag;
    AFoundTag.SmartTag := stColor;
    AFoundTag.HasParameter := True;
    // Hexadecimal
    if ATag[9] = '#' then
    begin
      AFoundTag.Parameter := '$' + Copy(ATag, 14, 2) + Copy(ATag, 12, 2) +
        Copy(ATag, 10, 2);
    end;
    // Delphi
    if ATag[9] = '$' then
    begin
      AFoundTag.Parameter := '$' + Copy(ATag, 10, PosEx('"', ATag, 10) - 10);
    end;
    // Constant
    if (ATag[9] <> '$') and (ATag[9] <> '#') then
    begin
      AFoundTag.Parameter := Copy(ATag, 9, PosEx('"', ATag, 9) - 9);
    end;
    Result := True;
  end;
  if Lowercase(ATag) = '[/color]' then
  begin
    AFoundTag.TagContraint := tcEndTag;
    AFoundTag.SmartTag := stColor;
    AFoundTag.HasParameter := False;
    AFoundTag.Parameter := '';
    Result := True;
  end;
  // Font
  if Lowercase(Copy(ATag, 1, 7)) = '[font="' then
  begin
    AFoundTag.TagContraint := tcBeginTag;
    AFoundTag.SmartTag := stFont;
    AFoundTag.HasParameter := True;
    AFoundTag.Parameter := Copy(ATag, 8, PosEx('"', ATag, 8) - 8);
    Result := True;
  end;
  if Lowercase(ATag) = '[/font]' then
  begin
    AFoundTag.TagContraint := tcEndTag;
    AFoundTag.SmartTag := stFont;
    AFoundTag.HasParameter := False;
    AFoundTag.Parameter := '';
    Result := True;
  end;
  // Size
  if Lowercase(Copy(ATag, 1, 7)) = '[size="' then
  begin
    AFoundTag.TagContraint := tcBeginTag;
    AFoundTag.SmartTag := stSize;
    AFoundTag.HasParameter := True;
    AFoundTag.Parameter := Copy(ATag, 8, PosEx('"', ATag, 8) - 8);
    Result := TryStrToInt(AFoundTag.Parameter, I);
  end;
  if Lowercase(ATag) = '[/size]' then
  begin
    AFoundTag.TagContraint := tcEndTag;
    AFoundTag.SmartTag := stSize;
    AFoundTag.HasParameter := False;
    AFoundTag.Parameter := '';
    Result := True;
  end;
  // URL
  if Lowercase(Copy(ATag, 1, 6)) = '[url="' then
  begin
    AFoundTag.TagContraint := tcBeginTag;
    AFoundTag.SmartTag := stUrl;
    AFoundTag.HasParameter := True;
    AFoundTag.Parameter := Copy(ATag, 7, PosEx('"', ATag, 7) - 7);
    Result := True;
  end;
  if Lowercase(ATag) = '[/url]' then
  begin
    AFoundTag.TagContraint := tcEndTag;
    AFoundTag.SmartTag := stUrl;
    AFoundTag.HasParameter := False;
    AFoundTag.Parameter := '';
    Result := True;
  end;
  // Anchor
  if Lowercase(Copy(ATag, 1, 9)) = '[anchor="' then
  begin
    AFoundTag.TagContraint := tcBeginTag;
    AFoundTag.SmartTag := stAnchor;
    AFoundTag.HasParameter := True;
    AFoundTag.Parameter := Copy(ATag, 10, PosEx('"', ATag, 10) - 10);
    Result := True;
  end;
  if Lowercase(ATag) = '[/anchor]' then
  begin
    AFoundTag.TagContraint := tcEndTag;
    AFoundTag.SmartTag := stAnchor;
    AFoundTag.HasParameter := False;
    AFoundTag.Parameter := '';
    Result := True;
  end;
  // Image
  if Lowercase(Copy(ATag, 1, 6)) = '[img="' then
  begin
    AFoundTag.TagContraint := tcSingleTag;
    AFoundTag.SmartTag := stImage;
    AFoundTag.HasParameter := True;
    AFoundTag.Parameter := Copy(ATag, 7, PosEx('"', ATag, 7) - 7);
    Result := True;
  end;
  // Offset
  if Lowercase(Copy(ATag, 1, 9)) = '[offset="' then
  begin
    AFoundTag.TagContraint := tcSingleTag;
    AFoundTag.SmartTag := stOffset;
    AFoundTag.HasParameter := True;
    AFoundTag.Parameter := Copy(ATag, 10, PosEx('"', ATag, 10) - 10);
    Result := True;
  end;
  // Row
  if Lowercase(Copy(ATag, 1, 6)) = '[row="' then
  begin
    AFoundTag.TagContraint := tcSingleTag;
    AFoundTag.SmartTag := stRow;
    AFoundTag.HasParameter := True;
    AFoundTag.Parameter := Copy(ATag, 7, PosEx('"', ATag, 7) - 7);
    Result := True;
  end;
end;

{*------------------------------------------------------------------------------
  The ClearLinkList Procedure is used to just clear the complete LinkList.
  When speaking of LinkList the FAnchorArray is meant (of course). Afterwards
  the array will be empty and the length will be 0.
------------------------------------------------------------------------------*}
procedure TACredits.ClearLinkList;
var
  I: Integer;
begin
  for I := 0 to Length(FAnchorLinkList) - 1 do
  begin
    FAnchorLinkList[I].Parameter := '';
  end;
  SetLength(FAnchorLinkList, 0);
end;

{*------------------------------------------------------------------------------
  Constructor of the TAcredits class. This procedure will set some initial
  values.

  @param AOwner Owner of the component. (TForm for example)
------------------------------------------------------------------------------*}
constructor TACredits.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 305;
  Height := 201;
  FCursor := crDefault;
  FMouseDown := False;
  FEnableDragging := False;
  FStopAniOnMouseOver := False;
  {$IFDEF NO_UNICODE}
  FCredits := TStringList.Create;
  {$ELSE}
  FCredits := TWideStringList.Create;
  {$ENDIF}
  FCredits.OnChange := GetFullTextSize;
  FFont := TFont.Create;
  FLinkFont := TFont.Create;
  FAnchorFont := TFont.Create;
  FTimer := TTimer.Create(Self);
  FBitmap := TBitmap.Create;
  FBitmap.PixelFormat := pf24bit;
  // Whitespace because of a possible crash without them in D7PE
  FCredits.Add(' ');
  FCredits.Add(' ');
  FCredits.Add('[b][u]Aviant Credits[/u][/b]');
  FCredits.Add('Copyright ©2007 Maximilian Sachs');
  FCredits.Add(' ');
  FCredits.Add('[b][i]http://www.Aviant.net[/i][/b]');
  FCredits.Add(' ');
  FCredits.Add(' ');
  FCredits.Add('For further informations [b]and[/b] licencing, see the help-' +
    'file!');   
  FFont.Color := clWhite;
  FFont.Name := 'Tahoma';
  FTimer.Interval := 50;
  FTimer.Enabled := False;
  FTimer.OnTimer := TimerFired;
  FBitmap.Width := Width;
  FBitmap.Height := Height;
  FBackgroundColor := clBlack;
  FDirection := sdBackWard;
  FBorderColor := clWhite;
  FAnimate := False;
  FInterval := 50;
  FEnableSmooth := [];
  FSmoothTop := 20;
  FSmoothBottom := 20;
  FTextOffset := 10;
  FTextAlign := taCenter;
  YPos := 4;
  TPos := 0;
  FVisible := True;
  FBackGroundBitmap := TBitmap.Create;
  FBackGroundBitmap.PixelFormat := pf24bit;
  FBackgroundImage := TPicture.Create;
  FBackgroundImage.Bitmap.PixelFormat := pf24bit;
  FBackgroundImage.OnChange := InvalidateTrigger;
  FForegroundImage := TPicture.Create;
  FForegroundImage.Bitmap.PixelFormat := pf24bit;
  FForegroundImage.OnChange := InvalidateTrigger;
  FShowBorder := True;
  FLinkFont.Assign(FFont);
  FAnchorFont.Assign(FFont);
  FLinkFont.OnChange := InvalidateTrigger;
  FAnchorFont.OnChange := InvalidateTrigger;
  FFont.OnChange := InvalidateTrigger;
  FAnchorCursor := crHandpoint;
  FLinkCursor := crHandPoint;
end;

{*------------------------------------------------------------------------------
  Destructor of the component. Makes sure everything is freed and destroys
  the component afterwards.
------------------------------------------------------------------------------*}
destructor TACredits.Destroy;
begin
  FBitmap.Free;
  FTimer.Free;
  FFont.Free;
  FLinkFont.Free;
  FAnchorFont.Free;
  FCredits.Free;
  FBackgroundImage.Free;
  FForegroundImage.Free;
  FBackGroundBitmap.Free;
  inherited Destroy;
end;

{*------------------------------------------------------------------------------
  The heart of the Smart-tag parser. The Paint procedure handles all drawing
  and should not be called directly but through "invalidate;" inside of the
  class.
------------------------------------------------------------------------------*}
procedure TACredits.Paint;
var
  Y: integer;
begin
  if Visible then
  begin
    inherited Paint;
    with FBitmap do
    begin
      Width := Self.Width;
      Height := Self.Height;
      Canvas.Font := FFont;
      if (FBackgroundImage.Graphic <> nil) and
        (not FBackgroundImage.Graphic.Empty) then
      begin
        {$IFNDEF NOPNGSUPPORT}
        if FBackgroundImage.Graphic.ClassType = TPNGObject then
        begin
          (FBackgroundImage.Graphic as TPNGObject).Draw(Canvas,Canvas.ClipRect);
        end
        else
        begin
          Canvas.StretchDraw(Canvas.ClipRect,
            FBackgroundImage.Graphic);
        end;
        {$ELSE}
        Canvas.StretchDraw(Canvas.ClipRect,
          FBackgroundImage.Graphic);
        {$ENDIF}
        FBackGroundBitmap.Assign(FBitmap);
      end
      else
      begin
        FBackGroundBitmap.Width := FBitmap.Width;
        FBackGroundBitmap.Height := FBitmap.Height;
        FBackGroundBitmap.Canvas.Brush.Style := bsSolid;
        FBackGroundBitmap.Canvas.Brush.Color := FBackgroundColor;
        FBackGroundBitmap.Canvas.FillRect(Rect(0, 0, Width, Height));
        BitBlt(Canvas.Handle, 0, 0, Width, Height,
          FBackGroundBitmap.Canvas.Handle, 0, 0, SRCCOPY);
      end;

      Canvas.Brush.Style := bsClear;

      if (not Animate) or ((Animate) and (FMouseDown)) then
      begin
        if TPos < (0 - FFulltextSize) then
        begin
          TPos := Height;
        end
        else
        begin
          if TPos > Height then
          begin
            TPos := 0 - 15 - FFulltextSize;
          end;
        end;
      end;
      Y := TPos;

      RenderText(Y, FBitmap, False);

      if FShowBorder then
      begin
        Canvas.Pen.Color := FBorderColor;
        Canvas.Rectangle(0, 0, Width, Height);
      end;
    end;

    if spTop in FEnableSmooth then
    begin
      DrawSmoothLine(spTop, SmoothTop, FBitmap);
    end;

    if spBottom in FEnableSmooth then
    begin
      DrawSmoothLine(spBottom, SmoothBottom, FBitmap);
    end;
    // Foreground Image
    if (FForegroundImage.Graphic <> nil) and
      (not FForegroundImage.Graphic.Empty) then
    begin
      {$IFNDEF NOPNGSUPPORT}
      if FForegroundImage.Graphic.ClassType = TPNGObject then
      begin
        (FForegroundImage.Graphic as TPNGObject).Draw(FBitmap.Canvas,
          Rect(0, 0, FForegroundImage.Graphic.Width,
          FForegroundImage.Graphic.Height));
      end
      else
      begin
        FBitmap.Canvas.StretchDraw(Rect(0, 0, FForegroundImage.Graphic.Width,
          FForegroundImage.Graphic.Height), FForegroundImage.Graphic);
      end;
      {$ELSE}
        FBitmap.Canvas.StretchDraw(Rect(0, 0, FForegroundImage.Graphic.Width,
          FForegroundImage.Graphic.Height), FForegroundImage.Graphic);
      {$ENDIF}
    end;
  
    BitBlt(Self.Canvas.Handle, 0, 0, FBitmap.Width, FBitmap.Height,
      FBitmap.Canvas.Handle, 0, 0, SRCCOPY);
  end
  else
  begin
    if csDesigning in ComponentState then
    begin
      Self.Canvas.FrameRect(Rect(0, 0, Width, Height));
    end;
  end;
end;

{*------------------------------------------------------------------------------
  The SetCredits procedure is used to set the credits (text).
  Do not call this procedure directly but through it's property!

  @param Value The new (Wide)StringList which will be assigned.
------------------------------------------------------------------------------*}
{$IFDEF NO_UNICODE}
procedure TACredits.SetCredits(Value: TStringList);
{$ELSE}
procedure TACredits.SetCredits(Value: TWideStringList);
{$ENDIF}
begin
  FCredits.Assign(Value);
  GetFullTextSize(Self);
  Invalidate;
end;

{*------------------------------------------------------------------------------
  The SetCursor procedure is used to set the default cursor which is displayed
  above the component. Do not call this procedure directly but through it's
  property!

  @param Value The cursor which will be assigned to the FCursor var.
------------------------------------------------------------------------------*}
procedure TACredits.SetCursor(Value: TCursor);
begin
  FCursor := Value;
end;

{*------------------------------------------------------------------------------
  The SetFont procedure is used to set the font in which the unformatted text
  will be painted. Do not call this procedure directly but through it's
  property!

  @param Value The font which will be assigned to the FFont var.
------------------------------------------------------------------------------*}
procedure TACredits.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
  Invalidate;
end;

{*------------------------------------------------------------------------------
  This procedure is used to apply the current formatting (in ATagList) to a
  Canvas. This is another part which is extremly important for the parser.

  @param ATagList A List with all of the current Tags
  @param ACanvas The Canvas where the changes will be applied to
------------------------------------------------------------------------------*}
procedure TACredits.SetFormatting(ATagList: TList; ACanvas: TCanvas);
var
  I: Integer;
  lTmp: Integer;
begin
  // Set the standards
  ACanvas.Font := FFont;
  // Set Formatting
  for I := 0 to ATagList.Count - 1 do
  begin
    case PFullSmartTag(ATagList.Items[I]).SmartTag of
      stBold:
      begin
        ACanvas.Font.Style := ACanvas.Font.Style + [fsBold];
      end;
      stItalic:
      begin
        ACanvas.Font.Style := ACanvas.Font.Style + [fsItalic];
      end;
      stUnderline:
      begin
        ACanvas.Font.Style := ACanvas.Font.Style + [fsUnderLine];
      end;
      stColor:
      begin
        ACanvas.Font.Color := StringToColor(PFullSmartTag(ATagList.Items[I
          ]).Parameter);
      end;
      stFont:
      begin
        ACanvas.Font.Name := PFullSmartTag(ATagList.Items[I]).Parameter;
      end;
      stStrikeOut:
      begin
        ACanvas.Font.Style := ACanvas.Font.Style + [fsStrikeOut];
      end;
      stSize:
      begin
        if TryStrToInt(PFullSmartTag(ATagList.Items[I]).Parameter, lTmp) then
        begin
          ACanvas.Font.Size := lTmp;
        end;
      end;
      stUrl:
      begin
        // If someone has a better method for this: Tell me, PLEASE! ;)
        if ACanvas.Font.Charset <> FLinkFont.Charset then
        begin
          ACanvas.Font.Charset := FLinkFont.Charset;
        end;
        if ACanvas.Font.Color <> FLinkFont.Color then
        begin
          ACanvas.Font.Color := FLinkFont.Color;
        end;
        if ACanvas.Font.Height <> FLinkFont.Height then
        begin
          ACanvas.Font.Height := FLinkFont.Height;
        end;
        if ACanvas.Font.Name <> FLinkFont.Name then
        begin
          ACanvas.Font.Name := FLinkFont.Name;
        end;
        {$IFNDEF ORIENTATION_NOTAVAILABLE}
        if ACanvas.Font.Orientation <> FLinkFont.Orientation then
        begin
          ACanvas.Font.Orientation := FLinkFont.Orientation;
        end;
        {$ENDIF}
        if ACanvas.Font.Pitch <> FLinkFont.Pitch then
        begin
          ACanvas.Font.Pitch := FLinkFont.Pitch;
        end;
        if ACanvas.Font.Size <> FLinkFont.Size then
        begin
          ACanvas.Font.Size := FLinkFont.Size;
        end;
        if fsBold in FLinkFont.Style then
        begin
          ACanvas.Font.Style := ACanvas.Font.Style + [fsBold];
        end;
        if fsItalic in FLinkFont.Style then
        begin
          ACanvas.Font.Style := ACanvas.Font.Style + [fsItalic];
        end;
        if fsUnderline in FLinkFont.Style then
        begin
          ACanvas.Font.Style := ACanvas.Font.Style + [fsUnderline];
        end;
        if fsStrikeOut in FLinkFont.Style then
        begin
          ACanvas.Font.Style := ACanvas.Font.Style + [fsStrikeOut];
        end;
      end;
      stAnchor:
      begin
        if ACanvas.Font.Charset <> FAnchorFont.Charset then
        begin
          ACanvas.Font.Charset := FAnchorFont.Charset;
        end;
        if ACanvas.Font.Color <> FAnchorFont.Color then
        begin
          ACanvas.Font.Color := FAnchorFont.Color;
        end;
        if ACanvas.Font.Height <> FAnchorFont.Height then
        begin
          ACanvas.Font.Height := FAnchorFont.Height;
        end;
        if ACanvas.Font.Name <> FAnchorFont.Name then
        begin
          ACanvas.Font.Name := FAnchorFont.Name;
        end;
        {$IFNDEF ORIENTATION_NOTAVAILABLE}
        if ACanvas.Font.Orientation <> FAnchorFont.Orientation then
        begin
          ACanvas.Font.Orientation := FAnchorFont.Orientation;
        end;
        {$ENDIF}
        if ACanvas.Font.Pitch <> FAnchorFont.Pitch then
        begin
          ACanvas.Font.Pitch := FAnchorFont.Pitch;
        end;
        if ACanvas.Font.Size <> FAnchorFont.Size then
        begin
          ACanvas.Font.Size := FAnchorFont.Size;
        end;
        if fsBold in FAnchorFont.Style then
        begin
          ACanvas.Font.Style := ACanvas.Font.Style + [fsBold];
        end;
        if fsItalic in FAnchorFont.Style then
        begin
          ACanvas.Font.Style := ACanvas.Font.Style + [fsItalic];
        end;
        if fsUnderline in FAnchorFont.Style then
        begin
          ACanvas.Font.Style := ACanvas.Font.Style + [fsUnderline];
        end;
        if fsStrikeOut in FAnchorFont.Style then
        begin
          ACanvas.Font.Style := ACanvas.Font.Style + [fsStrikeOut];
        end;
      end;
    end;
  end;
end;

{*------------------------------------------------------------------------------
  This procedure can be used to set the background color.
  Do not call this procedure directly but through it's property!

  @param Value The new background color.
------------------------------------------------------------------------------*}
procedure TACredits.SetBackgroundColor(Value: TColor);
begin
  FBackgroundColor := Value;
  Invalidate;
end;

{*------------------------------------------------------------------------------
  This procedure can be used to set the bordercolor.
  Do not call this procedure directly but through it's property!

  @param Value The new bordercolor.
------------------------------------------------------------------------------*}
procedure TACredits.SetBorderColor(Value: TColor);
begin
  FBorderColor := Value;
  Invalidate;
end;

{*------------------------------------------------------------------------------
  This procedure is used to prevent the component from the shrink-of-death.
  It can't be smaller than 50x50 now.

  @param ALeft The new Left-Value of the form
  @param ATop The new Top-Value of the form
  @param AWidth The new Width-Value of the form
  @param AHeight The new Height-Value of the form
------------------------------------------------------------------------------*}
procedure TACredits.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  if (AWidth < 50) then
  begin
    AWidth := 50;
  end;
  if (AHeight < 50) then
  begin
    AHeight := 50;
  end;
  inherited;
end;

{*------------------------------------------------------------------------------
  The SetAnchorFont procedure is used to set the font in which the text
  tagged with "Anchor"-Tags will be painted. Do not call this procedure directly
  but through it's property!

  @param Value The font which will be assigned to the FAnchorFont var.
------------------------------------------------------------------------------*}
procedure TACredits.SetAnchorFont(const Value: TFont);
begin
  FAnchorFont := Value;
  Invalidate;
end;

{*------------------------------------------------------------------------------
  The SetAnimate procedure is used to either activate or deactivate the
  animation. Do not call this procedure directly but through it's property!

  @param Value If it is true the animation will be activated if not it will be
  deactivated.
------------------------------------------------------------------------------*}
procedure TACredits.SetAnimate(Value: boolean);
begin
  FAnimate := Value;
  Reset;
  FTimer.Enabled := Value;
  Invalidate;
end;

{*------------------------------------------------------------------------------
  This is an internal procedure, so don't call it unless you know exactly what
  you are doing. It is called by the timer anyways so don't touch!
  It is used for the drawing if the animated-property is enabled.

  @param Value The calling sender.
------------------------------------------------------------------------------*}
procedure TACredits.TimerFired(Sender: TObject);
begin
  Canvas.Font := FFont;
  if FDirection = sdBackward then
  begin
    if TPos < (0 - FFulltextSize) then
    begin
      DoAfterLastCredit;
      ResetAnimation;
    end
    else
    begin
      Dec(TPos);
    end;
  end
  else
  begin
    if TPos > (Height) then
    begin
      DoAfterLastCredit;
      ResetAnimation;
    end
    else
    begin
      Inc(TPos);
    end;
  end;
  Paint;
end;

{*------------------------------------------------------------------------------
  If this procedure is called the entire animation will be reset. It will
  be either above the top of the component or below the bottom line (depends
  on the scrolling direction).
------------------------------------------------------------------------------*}
procedure TACredits.ResetAnimation;
begin
  if Animate then
  begin
    if FDirection = sdBackward then
    begin
      TPos := Height + 15;
      //      start down below the visible window again
      LastShownIndex := -1;
    end
    else
    begin
      TPos := 0 - 15 - FFulltextSize;
      //      start up above the visible window again
      LastShownIndex := -1;
    end;
  end;
end;

{*------------------------------------------------------------------------------
  This procedure is used to set the interval of the timer (has no viewable
  effect if the timer is disabled, but the value is stored until it activates).
  You should avoid calling this procedure and use the property instead.

  @param Value The new interval.
------------------------------------------------------------------------------*}
procedure TACredits.SetInterval(Value: Integer);
begin
  // Just going the safe way...
  if Value < 1 then
  begin
    Value := 1;
  end;
  FInterval := Value;
  FTimer.Interval := Value;
end;

{*------------------------------------------------------------------------------
  The SetLinkFont procedure is used to set the font in which the text
  tagged with "url"-Tags will be painted. Do not call this procedure directly
  but through it's property!

  @param Value The font which will be assigned to the FLinkFont var.
------------------------------------------------------------------------------*}
procedure TACredits.SetLinkFont(const Value: TFont);
begin
  FLinkFont := Value;
  Invalidate;
end;

{*------------------------------------------------------------------------------
  This is by far the most important procedure for parsing the text. Basically
  this is where all of the magic happens.
  The only thing it needs is the Y-Coordinate where the lines will be drawn and
  a bitmap (which will be used to draw onto).

  @param Y The Y-Coordinate where the lines will be viewable later.
  @param ABitmap The bitmap where the formatted text will be drawn onto.
  @param ASizeOnly Set to true if you want to avoid drawing. The only reason
  someone would do this is to update FFullTextSize!
------------------------------------------------------------------------------*}
procedure TACredits.RenderText(Y: Integer; ABitmap: TBitmap;
  ASizeOnly: Boolean);
var
  lState: TPaintAction;
  lLineLengths: array of TLineConstraint;
  lTagList: TList;
  I: Integer;
  X: Integer;
  {$IFDEF NO_UNICODE}
  CurLine: string;
  lCurTagName: string;
  lNexTagName: string;
  T: string;
  {$ELSE}
  CurLine: WideString;
  lCurTagName: WideString;
  lNexTagName: WideString;
  T: WideString;
  {$ENDIF}
  CurPos: Integer;
  lCurTagBegin: Integer;
  lCurTagEnd: Integer;
  lNexTagBegin: Integer;
  lNexTagEnd: Integer;
  lCurTag: TFullSmartTag;
  lNexTag: TFullSmartTag;
  lNewTag: PFullSmartTag;
  lDrawYAxis: Integer;
  E: Integer;
  lTmpHeight, lTmpWidth: Integer;
begin
  with ABitmap do
  begin
    lState := paPreprocessor;
    ClearLinkList;
    SetLength(lLineLengths, FCredits.Count);

    while lState <> paFinished do
    begin
      // Create the list of current active tags
      lTagList := TList.Create;
      try
        for I := 0 to FCredits.Count - 1 do
        begin
          if lState = paPainter then
          begin
            case FTextAlign of
              taRight:
              begin
                X := Width - lLineLengths[I].Width - FTextOffset;
              end;
              taCenter:
              begin
                X := (Width div 2) - (lLineLengths[I].Width div 2);
              end
              else
              begin
                X := FTextOffset;
              end;
            end;
          end
          else
          begin
            X := 0;
          end;
          if lState = paPreprocessor then
          begin
            lLineLengths[I].Width := 0;
            lLineLengths[I].Height := TrueFontSize(Canvas.Font, 'A', True);
          end;
          // I have _no_ idea why Delphi 7 can't handle that.
          CurLine := {$IFDEF DELPHI7_TAGFIX}' ' + {$ENDIF}FCredits.Strings[I];

          // First of all: Get everything which comes before a possible tag
          // including unsupported tags
          CurPos := 1;
          lCurTagBegin := Length(CurLine);
          while not CheckTag(lCurTagName, lCurTag) do
          begin
            lCurTagName := '';
            CurPos := PosEx('[', CurLine, CurPos) + 1;
            lCurTagBegin := CurPos - 1;
            lCurTagEnd := PosEx(']', CurLine, lCurTagBegin);
            if (lCurTagBegin = 0) or (lCurTagEnd = 0) then
            begin
              Break;
            end
            else
            begin
              lCurTagName := Copy(CurLine, lCurTagBegin, lCurTagEnd -
                lCurTagBegin + 1);
            end;
          end;
          if lCurTagName = '' then
          begin
            CurPos := Length(CurLine);
          end
          else
          begin
            CurPos := lCurTagBegin - 1;
          end;
          SetFormatting(lTagList, Canvas);
          T := Copy(CurLine, 1, CurPos);
          if lState = paPainter then
          begin
            // Drawing
            if FAnimate then
            begin
              lDrawYAxis := Y;
            end
            else
            begin
              lDrawYAxis := YPos + Y;
            end;
            // If this part is smaller locate it at the bottom line anyway
            lDrawYAxis := lDrawYAxis + lLineLengths[I].Height -
              TrueFontSize(Canvas.Font, CurLine, True);
            // Draw the thing
            {$IFDEF NO_UNICODE}
            TextOut(Canvas.Handle, X, lDrawYAxis, PChar(T), Length(T));
            {$ELSE}
            TextOutW(Canvas.Handle, X, lDrawYAxis, PWideChar(T), Length(T));
            {$ENDIF}
            X := X + TrueFontSize(Canvas.Font, T);

          end;
          if lState = paPreprocessor then
          begin
            lLineLengths[I].Width := lLineLengths[I].Width +
              TrueFontSize(Canvas.Font, T);
            if FFont.Height < Canvas.Font.Height then
            begin
              lLineLengths[I].Height := TrueFontSize(Canvas.Font, CurLine,
                True);
            end;
          end;

          // Reset CurPos
          CurPos := 1;

          // Iterate thourhg the string
          // "[" is significant for a coming tag
          while CurPos <> 0 do
          begin
            // Check if any tags are in there
            CurPos := PosEx('[', CurLine, CurPos);
            if CurPos <> 0 then
            begin
              CurPos := CurPos + 1;
            end;

            lCurTagBegin := CurPos - 1;
            lCurTagEnd := PosEx(']', CurLine, lCurTagBegin);
            lCurTagName := Copy(CurLine, lCurTagBegin, lCurTagEnd -
              lCurTagBegin + 1);
            if CheckTag(lCurtagName, lCurTag) then
            begin
              lNexTagBegin := lCurTagEnd - 1;
              lNexTagName := '';
              while not CheckTag(lNexTagName, lNexTag) do
              begin
                lNexTagBegin := PosEx('[', CurLine, lNexTagBegin + 1);
                lNexTagEnd := PosEx(']', CurLine, lNexTagBegin);
                lNexTagName := Copy(CurLine, lNexTagBegin, lNexTagEnd -
                  lNexTagBegin + 1);
                if (lNexTagEnd = 0) or (lNexTagBegin = 0) then
                begin
                  lNexTagBegin := Length(CurLine) + 1;
                  Break;
                end;

              end;

              // We've got a tag two choices:
              // -- BeginTag: Add it to list (as last one)
              case lCurTag.TagContraint of
                tcBeginTag:
                begin
                  New(lNewTag);
                  lTagList.Add(lNewtag);
                  lNewTag^ := lCurTag;
                end;
                tcEndTag:
                begin
                  for E := lTagList.Count - 1 downto 0 do
                  begin
                    if PFullSmartTag(lTagList.Items[E]).SmartTag =
                      lCurTag.SmartTag then
                    begin
                      // Found the right one, delete 'em
                      lNewTag := PFullSmartTag(lTagList.Items[E]);
                      lTagList.Delete(E);
                      Dispose(lNewTag);
                    end;
                  end;
                end;
                tcSingleTag:
                begin
                  // Image
                  if (lCurTag.SmartTag = stImage) and
                    Assigned(FImageList) then
                  begin
                    if lState = paPainter then
                    begin
                      // Drawing
                      if FAnimate then
                      begin
                        lDrawYAxis := Y;
                      end
                      else
                      begin
                        lDrawYAxis := YPos + Y;
                      end;
                      // If this part is smaller locate it at the bottom line anyw.
                      lTmpWidth := FImageList.Width;
                      lTmpHeight := FImageList.Height;
                      if Assigned(FCustomPicSizeEvent) then
                      begin
                        FCustomPicSizeEvent(Self, StrToInt(lCurTag.Parameter),
                          lTmpWidth, lTmpHeight);
                      end;
                      lDrawYAxis := lDrawYAxis + lLineLengths[I].Height -
                        lTmpHeight;
                      // Draw the thing
                      FImageList.Draw(Canvas, X, lDrawYAxis,
                        StrToInt(lCurTag.Parameter));
                      // Add possible Anchor/Link
                      AddPossibleLink(lTagList,
                        Rect(X, lDrawYAxis, X + lTmpWidth,
                        lLineLengths[I].Height + lDrawYAxis));
                      // Reset Width
                      X := X + lTmpWidth;
                    end;
                    if lState = paPreprocessor then
                    begin
                      lTmpWidth := FImageList.Width;
                      lTmpHeight := FImageList.Height;
                      if Assigned(FCustomPicSizeEvent) then
                      begin
                        FCustomPicSizeEvent(Self, StrToInt(lCurTag.Parameter),
                          lTmpWidth, lTmpHeight);
                      end;
                      lLineLengths[I].Width := lLineLengths[I].Width +
                        lTmpWidth;
                      if lLineLengths[I].Height < lTmpHeight then
                      begin
                        lLineLengths[I].Height := lTmpHeight;
                      end;
                    end;
                  end;
                  // Offset
                  if lCurTag.SmartTag = stOffset then
                  begin
                    if lState = paPreProcessor then
                    begin
                      if lLineLengths[I].Width < StrToInt(lCurTag.Parameter) then
                      begin
                        // At least as long as the offset our lines must be
                        lLineLengths[I].Width := StrToInt(lCurTag.Parameter);
                      end;
                    end;
                    X := StrToInt(lCurTag.Parameter);
                  end;
                  // Row
                  if lCurTag.SmartTag = stRow then
                  begin
                    if lState = paPainter then
                    begin
                      // Drawing
                      if FAnimate then
                      begin
                        lDrawYAxis := Y;
                      end
                      else
                      begin
                        lDrawYAxis := YPos + Y;
                      end;
                      // Draw the row
                      if Assigned(FOnDrawRow) then
                      begin
                        FOnDrawRow(Self, CurLine, Rect(X, lDrawYAxis, X +
                          StrToInt(lCurTag.Parameter), lDrawYAxis +
                          lLineLengths[I].Height), Canvas.Font.Color, Canvas);
                      end
                      else
                      begin
                        DrawRow(
                          Rect(X, lDrawYAxis, X + StrToInt(lCurTag.Parameter),
                          lDrawYAxis + lLineLengths[I].Height),
                          Canvas.Font.Color, Canvas);
                      end;
                      // Add possible Anchor/Link
                      AddPossibleLink(lTagList,
                        Rect(X, lDrawYAxis, X + StrToInt(lCurTag.Parameter),
                        lDrawYAxis + lLineLengths[I].Height));
                      // Reset Width
                      X := X + StrToInt(lCurTag.Parameter);
                    end;
                    if lState = paPreprocessor then
                    begin
                      // Width is the only var we have to reset..
                      lLineLengths[I].Width := lLineLengths[I].Width +
                        StrToInt(lCurTag.Parameter);
                    end;
                  end;
                end;
              end;
              // Since the tags in the list might have changed at this point we
              // have to reset the entire thing!
              SetFormatting(lTagList, Canvas);
              T := Copy(CurLine, lCurTagEnd + 1, lNexTagBegin - lCurTagEnd - 1);
              if lState = paPainter then
              begin
                // Drawing
                if FAnimate then
                begin
                  lDrawYAxis := Y;
                end
                else
                begin
                  lDrawYAxis := YPos + Y;
                end;
                // If this part is smaller locate it at the bottom line anyw.
                lDrawYAxis := lDrawYAxis + lLineLengths[I].Height -
                  TrueFontSize(Canvas.Font, CurLine, True);
                // Draw the thing
                {$IFDEF NO_UNICODE}
                TextOut(Canvas.Handle, X, lDrawYAxis, PChar(T), Length(T));
                {$ELSE}
                TextOutW(Canvas.Handle, X, lDrawYAxis, PWideChar(T), Length(T));
                {$ENDIF}
                // Add possible Anchor/Link
                AddPossibleLink(lTagList,
                  Rect(X, lDrawYAxis, X + TrueFontSize(Canvas.Font, T),
                  lLineLengths[I].Height + lDrawYAxis));
                // Reset Width
                X := X + TrueFontSize(Canvas.Font, T);
              end;
              if lState = paPreprocessor then
              begin
                lLineLengths[I].Width := lLineLengths[I].Width +
                  TrueFontSize(Canvas.Font, T);
                if FFont.Size <> Canvas.Font.Size then
                begin
                  lLineLengths[I].Height := TrueFontSize(Canvas.Font, CurLine,
                    True);
                end;
              end;
            end;
          end;


          if lState = paPainter then
          begin
            if FAnimate then
            begin
              if (Y + lLineLengths[I].Height) > 0 then
              begin
                if I > LastShownIndex then
                begin
                  DoShowCredit(T);
                  LastShownIndex := I;
                end;
              end;
              Inc(Y, lLineLengths[I].Height);
              if Y > Height then
              begin
                Break;
              end;
            end
            else
            begin
              Y := Y + lLineLengths[I].Height;
            end;
          end;
        end;
        case lState of
          paPreProcessor:
          begin
            if ASizeOnly then
            begin
              // We need no painting here
              lState := paFinished;
            end
            else
            begin
              lState := paPainter;
            end;
          end;
          paPainter:
          begin
            lState := paFinished;
          end;
        end;
      finally
        lTagList.Free;
      end;
    end;
  end;
  FFullTextSize := 0;
  for I := 0 to Length(lLineLengths) - 1 do
  begin
    FFullTextSize := FFullTextSize + lLineLengths[I].Height;
  end;
end;

{*------------------------------------------------------------------------------
  Call this and the component will be resetted in it's appearence. This means:
  All the values will be kept but the component draws everything in the initial
  state (Animations on top/bottom; Unanimated text completely normal).
------------------------------------------------------------------------------*}
procedure TACredits.Reset;
begin
  Canvas.Font := FFont;
  if not Animate then
  begin
    TPos := 0;
  end
  else
  begin
    if Direction = sdBackward then
    begin
      TPos := Height + 15;
    end
    else
    begin
      TPos := 0 - 15 - FFulltextSize;
    end;
  end;
end;

{*------------------------------------------------------------------------------
  The OnAfterLastCredit event will be called in here.
------------------------------------------------------------------------------*}
procedure TACredits.DoAfterLastCredit;
begin
  if Assigned(FAfterLastCredit) then
  begin
    FAfterLastCredit(Self);
  end;
end;

{*------------------------------------------------------------------------------
  This procedure will be called when a line is displayed the first time.
  @param ACredit The credit which is shown at the moment.
------------------------------------------------------------------------------*}
{$IFDEF NO_UNICODE}
procedure TACredits.DoShowCredit(const ACredit: string);
{$ELSE}
procedure TACredits.DoShowCredit(const ACredit: WideString);
{$ENDIF}
begin
  if Assigned(FOnShowCredit) then
  begin
    FOnShowCredit(Self, ACredit);
  end;
end;

{*------------------------------------------------------------------------------
  This procedure simply draws a line in the middle of the given rect.

  @param ARect The rect in which the line will be drawn.
  @param AColor The color the line will be drawn in.
  @param ACanvas The canvas the line will be drawn on.
------------------------------------------------------------------------------*}
procedure TACredits.DrawRow(ARect: TRect; AColor: TColor; ACanvas: TCanvas);
var
  lBackupPen: TPen;
  lTmp: Integer;
begin
  lBackupPen := TPen.Create;
  try
    lBackupPen.Assign(ACanvas.Pen);
    ACanvas.Pen.Style := psSolid;
    ACanvas.Pen.Color := AColor;
    lTmp := (ARect.Bottom - ARect.Top) div 2;
    ACanvas.PenPos := Point(ARect.Left, ARect.Top + lTmp);
    ACanvas.LineTo(ARect.Right, ARect.Top + lTmp);
  finally
    lBackupPen.Free;
  end;
end;

{*------------------------------------------------------------------------------
  This procedure will be called at the end of the paint routine. It fades
  out a specific stripe at the bottom/top of the component.
  @param APosition The position of the line.
  @param AHeight The height of the line.
  @param ABitmap The Bitmap which will be used to draw on.
------------------------------------------------------------------------------*}
procedure TACredits.DrawSmoothLine(APosition: TSmoothPosition;
  AHeight: Integer; ABitmap: TBitmap);
var
  lLine: PByteArray;
  lHeight: Integer;
  lAlphaInc: Integer;
  lAlpha: Byte;
  lPoint: Integer;
  lBackGroundLine: PByteArray;
  lPositionInt: Integer;
begin
  lAlphaInc := 255 div AHeight;
  lAlpha := 255 mod AHeight;
  if APosition = spTop then
  begin
    if FShowBorder then
    begin
      lPositionInt := 1;
    end
    else
    begin
      // Now border, so start earlier
      lPositionInt := 0;
    end;
  end
  else
  begin
    if FShowBorder then
    begin
      lPositionInt := Height - AHeight - 1;
    end
    else
    begin
      lPositionInt := Height - AHeight;
    end;
    lAlpha := not lAlpha;
  end;
  // Produces a transparent gradient at top/bottom of a bitmap
  for lHeight := 0 + lPositionInt to AHeight + lPositionInt - 1 do
  begin
    lLine := ABitmap.ScanLine[lHeight];
    lBackGroundLine := FBackgroundBitmap.ScanLine[lHeight];

    lPoint := 3;
    while (lPoint < (ABitmap.width - 3) * 3) do
    begin
        // Scan it
        lLine[lPoint] := (lLine[lPoint] * lAlpha + lBackGroundLine[lPoint]
           * (not lAlpha)) shr 8;
        lLine[lPoint + 1] := (lLine[lPoint + 1] * lAlpha +
          lBackGroundLine[lPoint + 1] * (not lAlpha)) shr 8;
        lLine[lPoint + 2] := (lLine[lPoint + 2] * lAlpha +
          lBackGroundLine[lPoint + 2] * (not lAlpha)) shr 8;
      Inc(lPoint, 3);
    end;
    if APosition = spTop then
    begin
      Inc(lAlpha, lAlphaInc);
    end
    else
    begin
      Dec(lAlpha, lAlphaInc);
    end;
  end;
end;

{*------------------------------------------------------------------------------
  Call this procedure to fill the FFullTextSize var. It will fill it with
  the absolute textheight (including formatted text!).
  This is also the only (until now) procedure which might call RenderText
  with ASizeOnly set to TRUE.

  @param The calling object.
------------------------------------------------------------------------------*}
procedure TACredits.GetFullTextSize(Sender: TObject);
begin
  FBitmap.Width := Self.Width;
  FBitmap.Height := Self.Height;
  FBitmap.Canvas.Font := FFont;
  RenderText(0, FBitmap, True);
  ResetAnimation;
end;

{*------------------------------------------------------------------------------
  WMLButtonUp will be called if the left mouse button is released.
  It will also call the according property (OnMouseUp).

  @param Message Specific parameters for the determination of what happened.
------------------------------------------------------------------------------*}
procedure TACredits.WMLButtonUp(var Message: TWMLButtonUp);
var
  I: Integer;
begin
  if FEnableDragging then
  begin
    FMouseDown := False;
    if (not FStopAniOnMouseOver) and (FAnimate) then
    begin
      FTimer.Enabled := True;
    end;
    FCurrentPosLeft := Mouse.CursorPos.Y - TPos;
  end;
  // Links
  for I := 0 to Length(FAnchorLinkList) - 1 do
  begin
    if (message.XPos > FAnchorLinkList[I].Position.Left) and
      (message.XPos < FAnchorLinkList[I].Position.Right) and
      (message.YPos  > FAnchorLinkList[I].Position.Top) and
      (message.YPos  < FAnchorLinkList[I].Position.Bottom) then
    begin
      if FAnchorLinkList[I].SmartTag = stUrl then
      begin
        {$IFDEF NO_UNICODE}
        Shellexecute(0, 'open',
          PChar(FAnchorLinkList[I].Parameter), nil, nil, SW_SHOW);
        {$ELSE}
        ShellexecuteW(0, 'open',
          PWideChar(FAnchorLinkList[I].Parameter), nil, nil, SW_SHOW);
        {$ENDIF}
      end;
      if (FAnchorLinkList[I].SmartTag = stAnchor) and
        Assigned(FOnAnchorClicked) then
      begin
        FOnAnchorClicked(Self, FAnchorLinkList[I].Parameter);
      end;
      Break;
    end;
  end;
  if Assigned(OnClick) then
  begin
    OnClick(Self);
  end;
  if Assigned(OnMouseUp) then
  begin
    OnMouseUp(Self, mbLeft, KeyDataToShiftState(message.Keys),
      message.XPos, message.YPos);
  end;
end;

{*------------------------------------------------------------------------------
  WMMButtonDblClk will be called if the middle mouse button is double clicked.
  It will also call the according property (OnDblClick).

  @param Message Specific parameters for the determination of what happened.
------------------------------------------------------------------------------*}
procedure TACredits.WMMButtonDblClk(var Message: TWMMButtonDblClk);
begin
  if Assigned(OnDblClick) then
  begin
    OnDblClick(Self);
  end;
end;

{*------------------------------------------------------------------------------
  WMMButtonDown will be called if the middle mouse button is being hold down.
  It will also call the according property (OnMouseDown).

  @param Message Specific parameters for the determination of what happened.
------------------------------------------------------------------------------*}
procedure TACredits.WMMButtonDown(var Message: TWMMButtonDown);
begin
  if Assigned(OnMouseDown) then
  begin
    OnMouseDown(Self, mbMiddle, KeyDataToShiftState(message.Keys),
      message.XPos, message.YPos);
  end;
end;

{*------------------------------------------------------------------------------
  WMMButtonUp will be called if the middle mouse button is released.
  It will also call the according property (OnMouseUp).

  @param Message Specific parameters for the determination of what happened.
------------------------------------------------------------------------------*}
procedure TACredits.WMMButtonUp(var Message: TWMMButtonUp);
begin
  if Assigned(OnClick) then
  begin
    OnClick(Self);
  end;
  if Assigned(OnMouseUp) then
  begin
    OnMouseUp(Self, mbMiddle, KeyDataToShiftState(message.Keys),
      message.XPos, message.YPos);
  end;
end;

{*------------------------------------------------------------------------------
  WMMouseMove will be called if the mouse was moved above the surface of the
  component.
  It will also call the according property (OnMouseMove).

  @param Message Specific parameters for the determination of what happened.
------------------------------------------------------------------------------*}
procedure TACredits.WMMouseMove(var Message: TWMMouseMove);
var
  I: Integer;
  AnchorHit: Boolean;
  ActualCursor: TCursor;
begin
  if (FEnableDragging) and
    (FMouseDown) then
  begin
    TPos := FOriginalTPos + (Mouse.CursorPos.Y - FOriginalTPos) -
      FCurrentPosLeft;
    Paint;
  end;
  // Links
  AnchorHit := False;
  for I := 0 to Length(FAnchorLinkList) - 1 do
  begin
    if (message.XPos > FAnchorLinkList[I].Position.Left) and
      (message.XPos < FAnchorLinkList[I].Position.Right) and
      (message.YPos  > FAnchorLinkList[I].Position.Top) and
      (message.YPos  < FAnchorLinkList[I].Position.Bottom) then
    begin
      AnchorHit := True;
      Break;
    end;  end;
  // Cursor-Bug eliminated. Thx to Lukas Erlacher
  if AnchorHit then
  begin
    if FAnchorLinkList[I].SmartTag = stAnchor then
    begin
      ActualCursor := FAnchorCursor;
    end
    else
    begin
      ActualCursor := FLinkCursor;
    end;
  end
  else
  begin
    ActualCursor := Cursor;
  end;

  if Assigned(OnMouseMove) then
  begin
    OnMouseMove(Self, KeyDataToShiftState(message.Keys),
      message.XPos, message.YPos);
  end;
  TControl(self).Cursor := ActualCursor
end;

{*------------------------------------------------------------------------------
  WMRButtonDblClk will be called if the right mouse button is double clicked.
  It will also call the according property (OnDblClick).

  @param Message Specific parameters for the determination of what happened.
------------------------------------------------------------------------------*}
procedure TACredits.WMRButtonDblClk(var Message: TWMRButtonDblClk);
begin
  if Assigned(OnDblClick) then
  begin
    OnDblClick(Self);
  end;
end;

{*------------------------------------------------------------------------------
  WMRButtonDown will be called if the right mouse button is being hold down.
  It will also call the according property (OnMouseDown).

  @param Message Specific parameters for the determination of what happened.
------------------------------------------------------------------------------*}
procedure TACredits.WMRButtonDown(var Message: TWMRButtonDown);
begin
  if Assigned(OnMouseDown) then
  begin
    OnMouseDown(Self, mbRight, KeyDataToShiftState(message.Keys),
      message.XPos, message.YPos);
  end;
end;

{*------------------------------------------------------------------------------
  WMRButtonUp will be called if the right mouse button is released.
  It will also call the according property (OnMouseUp).

  @param Message Specific parameters for the determination of what happened.
------------------------------------------------------------------------------*}
procedure TACredits.WMRButtonUp(var Message: TWMRButtonUp);
begin
  if Assigned(OnClick) then
  begin
    OnClick(Self);
  end;
  if Assigned(OnMouseUp) then
  begin
    OnMouseUp(Self, mbRight, KeyDataToShiftState(message.Keys),
      message.XPos, message.YPos);
  end;
end;

{*------------------------------------------------------------------------------
  MouseEnter will be called if the mouse has just entered the surface of the
  component.
  It will also call the according property (OnMouseEnter).

  @param Message Specific parameters for the determination of what happened.
------------------------------------------------------------------------------*}
procedure TACredits.MouseEnter(var Message: TMessage);
begin
  if (FStopAniOnMouseOver) and (FAnimate) then
  begin
    FTimer.Enabled := False;
  end;
  if Assigned(FOnMouseEnter) then
  begin
    FOnMouseEnter(Self);
  end;
end;

{*------------------------------------------------------------------------------
  MouseLeave will be called if the mouse has just left the surface of the
  component.
  It will also call the according property (OnMouseLeave).

  @param Message Specific parameters for the determination of what happened.
------------------------------------------------------------------------------*}
procedure TACredits.MouseLeave(var Message: TMessage);
begin
  if FEnableDragging then
  begin
    FMouseDown := False;
    if (not FStopAniOnMouseOver) and (FAnimate) then
    begin
      FTimer.Enabled := True;
    end;
    FCurrentPosLeft := Mouse.CursorPos.Y - TPos;
  end;
  if (FStopAniOnMouseOver) and (FAnimate) then
  begin
    FTimer.Enabled := True;
  end;
  if Assigned(FOnMouseLeave) then
  begin
    FOnMouseLeave(Self);
  end;
end;

{*------------------------------------------------------------------------------
  WMLButtonDblClk will be called if the left mouse button is double clicked.
  It will also call the according property (OnDblClick).

  @param Message Specific parameters for the determination of what happened.
------------------------------------------------------------------------------*}
procedure TACredits.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
  if Assigned(OnDblClick) then
  begin
    OnDblClick(Self);
  end;
end;

{*------------------------------------------------------------------------------
  WMLButtonDown will be called if the left mouse button is being hold down.
  It will also call the according property (OnMouseDown).

  @param Message Specific parameters for the determination of what happened.
------------------------------------------------------------------------------*}
procedure TACredits.WMLButtonDown(var Message: TWMLButtonDown);
begin
  if FEnableDragging then
  begin
    FMouseDown := True;
    FTimer.Enabled := False;
    FOriginalTPos := TPos;
    FCurrentPosLeft := Mouse.CursorPos.Y - TPos;
  end;
  if Assigned(OnMouseDown) then
  begin
    OnMouseDown(Self, mbLeft, KeyDataToShiftState(message.Keys),
      message.XPos, message.YPos);
  end;
end;

{*------------------------------------------------------------------------------
  The SetVisible procedure will set the visibility of the component to the value
  which is located in the Value var. Do not call this procedure directly but
  through it's property!

  @param Value If set to true, the component will be visible, otherwise not.
------------------------------------------------------------------------------*}
procedure TACredits.SetVisible(Value: boolean);
begin
  if Visible <> Value then
  begin
    FVisible := Value;
    if Value then
    begin
      FTimer.Enabled := Animate
    end
    else
    begin
      FTimer.Enabled := False;
    end;
    ResetAnimation;
    if Parent <> nil then
    begin
      Parent.Invalidate;
    end;
  end;
end;

{*------------------------------------------------------------------------------
  AddPossibleLink is used to add a possible link to the linklist.
  If this is a link will be determined if the ATagList contains a current active
  link, if so, the rect will be stored as a link.

  @param ATagList The list of the current active tags.
  @param APosition The rect which will be stored as link if a link is active.
------------------------------------------------------------------------------*}
procedure TACredits.AddPossibleLink(ATagList: TList; APosition: TRect);
var
  I: Integer;
begin
  for I := ATagList.Count - 1 downto 0 do
  begin
    if (PFullSmartTag(ATagList.Items[I]).SmartTag = stAnchor) or
      (PFullSmartTag(ATagList.Items[I]).SmartTag = stUrl) then
    begin
      SetLength(FAnchorLinkList, Length(FAnchorLinkList) + 1);
      FAnchorLinkList[High(FAnchorLinkList)].Position := APosition;
      FAnchorLinkList[High(FAnchorLinkList)].SmartTag :=
        PFullSmartTag(ATagList.Items[I]).SmartTag;
      FAnchorLinkList[High(FAnchorLinkList)].Parameter :=
        PFullSmartTag(ATagList.Items[I]).Parameter;
      Break;
    end;
  end;
end;

{*------------------------------------------------------------------------------
  This is just a trigger for invalidation. It used used by other classes
  on the OnChange method. (If the font might change, this one will be called and
  make sure that the component will update).
  @param Sender The calling object.
------------------------------------------------------------------------------*}
procedure TACredits.InvalidateTrigger(Sender: TObject);
begin
  Invalidate;
end;

{*------------------------------------------------------------------------------
  This procedure is used to set the background image.
  You should avoid calling this procedure and use the property instead.

  @param Value The new picture.
------------------------------------------------------------------------------*}
procedure TACredits.SetBackgroundImage(Value: TPicture);
begin
  FBackgroundImage.Assign(Value);
  Invalidate;
end;

{*------------------------------------------------------------------------------
  This procedure is used to set the foreground image.
  You should avoid calling this procedure and use the property instead.

  @param Value The new picture.
------------------------------------------------------------------------------*}
procedure TACredits.SetForegroundImage(Value: TPicture);
begin
  FForegroundImage.Assign(Value);
  Invalidate;
end;

{*------------------------------------------------------------------------------
  This procedure is used to set the scrolling direction (forward/backward).
  You should avoid calling this procedure and use the property instead.

  @param Value The new direction.
------------------------------------------------------------------------------*}
procedure TACredits.SetDirection(ADirection: TScrollingDirection);
begin
  FDirection := ADirection;
  SetAnimate(FAnimate);
end;

{*------------------------------------------------------------------------------
  This procedure is used to set/activate the smoothlines.
  You should avoid calling this procedure and use the property instead.

  @param Value The activated smoothlines.
------------------------------------------------------------------------------*}
procedure TACredits.SetEnableSmooth(const Value: TEnableSmooth);
begin
  FEnableSmooth := Value;
  Invalidate;
end;

{*------------------------------------------------------------------------------
  This procedure is used to determine if a border should be drawn.
  You should avoid calling this procedure and use the property instead.

  @param Value If the value is false no border will be drawn otherwise it will.
------------------------------------------------------------------------------*}
procedure TACredits.SetShowBorder(Value: boolean);
begin
  FShowBorder := Value;
  Invalidate;
end;

{*------------------------------------------------------------------------------
  This procedure is used to set height of the bottom smooth line.
  If the bottom smoothline is deactivated this value has no viewable effect
  (but will be stored anyway).
  You should avoid calling this procedure and use the property instead.

  @param Value The new height of the bottom smoot hline.
------------------------------------------------------------------------------*}
procedure TACredits.SetSmoothBottom(Value: Integer);
begin
  // Just going the safe way...
  if Value < 1 then
  begin
    Value := 1;
  end;
  FSmoothBottom := Value;
  Invalidate;
end;

{*------------------------------------------------------------------------------
  This procedure is used to set height of the top smooth line.
  If the top smoothline is deactivated this value has no viewable effect
  (but will be stored anyway).
  You should avoid calling this procedure and use the property instead.

  @param Value The new height of the top smooth line.
------------------------------------------------------------------------------*}
procedure TACredits.SetSmoothTop(Value: Integer);
begin
  // Just going the safe way...
  if Value < 1 then
  begin
    Value := 1;
  end;
  FSmoothTop := Value;
  Invalidate;
end;

{*------------------------------------------------------------------------------
  This procedure is used to set the text-alignment (left/center/right).
  You should avoid calling this procedure and use the property instead.

  @param Value The new alignment.
------------------------------------------------------------------------------*}
procedure TACredits.SetTextAlign(ATextAlign: TTextAlign);
begin
  FTextAlign := ATextAlign;
  Invalidate;
end;

{*------------------------------------------------------------------------------
  This procedure is used to set the text offset. (space between the border and
  the actual text; Has no effect when text-alignment is center).
  You should avoid calling this procedure and use the property instead.

  @param Value The new offset in pixels.
------------------------------------------------------------------------------*}
procedure TACredits.SetTextOffset(AOffset: Integer);
begin
  // Just going the safe way...
  if AOffset < 1 then
  begin
    AOffset := 1;
  end;
  FTextOffset := AOffset;
  Invalidate;
end;

end.
