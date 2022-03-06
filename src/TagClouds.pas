{

    Unit TagClouds

    A class for managing the medialibrary in some kind of a tag-cloud

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2005-2019, Daniel Gaussmann
    http://www.gausi.de
    mail@gausi.de
    ---------------------------------------------------------------
    This program is free software; you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by the
    Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful, but
    WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
    for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin St, Fifth Floor, Boston, MA 02110, USA

    See license.txt for more information

    ---------------------------------------------------------------
}

unit TagClouds;

interface

uses windows, classes, Forms, SysUtils, Controls, Contnrs, NempAudioFiles, Math, stdCtrls,
    ComCtrls, Graphics, Messages, NempPanel,  StrUtils, System.Types,
    System.Generics.Collections, System.Generics.Defaults,
    LibraryOrganizer.Base, LibraryOrganizer.Files;

const

    BORDER_WIDTH = 4;
    BORDER_HEIGHT = 1;

    BREADCRUMB_VGAP = 4;
    BREADCRUMB_HGAP = 4;

    FONTSIZE_BREADCRUMB = 10;
    FIRST_BREADCRUMB_MARGIN = 28;
    TOP_MARGIN = 4;

type

  TBlendMode = (bm_Cloud, bm_Tag);


  // class containing some colors and other stuff.
  // can be changed by NempSkin
  // used by every single tag to get its colors.
  TTagCustomizer = class(TObject)
      public
          FontColor: TColor;         // Default Font color
          HoverFontColor: TColor;    // Hover (MouseOver)
          FocusFontColor: TColor;    // Focus
          FocusBorderColor: TColor;  // Focus Border
          FocusBackgroundColor: TColor; // FocusBackground;
          BackgroundColor: TColor;

          // Alphablend for whole cloud
          CloudUseAlphaBlend: Boolean;
          CloudBlendColor: TColor;
          CloudBlendIntensity: Integer;

          // Alphablend for SelectedTags
          TagUseAlphablend: Boolean;
          TagBlendColor: TColor;
          TagBlendIntensity: Integer;

          BackgroundImage: TBitmap;
          UseBackGround: Boolean;
          TileBackGround: Boolean;
          OffSetX: Integer;
          OffSetY: Integer;
          constructor Create;
          destructor Destroy; override;
          procedure TileGraphic(const ATarget: TCanvas; X, Y: Integer);
          procedure AlphaBlendCloud(TargetCanvas: TCanvas; Width, Height, Left, Top: Integer; Mode: TBlendMode);
  end;

  TTagLine = class;
  TPaintTag = class;
  TPaintTagList = class(TObjectList<TPaintTag>);
  TTagLineList = class(TObjectList<TTagLine>);

  // a single Tag on a Paintbox
  TPaintTag = class (TObject)
      private
        fLeft: Integer;    // left-position in a Tag-Line
        fTop: Integer;
        fWidth: Integer;
        fHeight: Integer;
        FontSize: Integer;

        fHover: Boolean;
        fFocussed: Boolean;

        fParentLine: TTagLine;
        fIsBreadCrumb: Boolean;
        fCollection: TAudioFileCollection;

        procedure PaintNormal(aCanvas: TCanvas);
        procedure PaintHover(aCanvas: TCanvas);
        procedure PaintFocussed(aCanvas: TCanvas);
        procedure Erase(aCanvas: TCanvas; Blend:Boolean);

        function GetCaption: String;
        function GetCount: Integer;
      protected
        property Caption: String read GetCaption;
        property Count: Integer read GetCount;


      public
        property Width: Integer read fWidth;
        property Height: Integer read fHeight;
        // Tags in the Breadcrumb-Line are painted differently
        property IsBreadCrumb: Boolean read fIsBreadCrumb write fIsBreadCrumb;

        constructor Create(aCollection: TAudioFileCollection);
        procedure MeasureOutput(aCanvas: TCanvas);
        procedure SetPosition(x, y: Integer);
        procedure Paint(aCanvas: TCanvas);
  end;

  // a Line of Tags in a Paintbox
  TTagLine = class
      private
          fGap: Integer;   // the needed gap between two tags for justification ("Blocksatz")
          fCanvasWidth: Integer;
          fWidth: Integer;
          fHeight: Integer;
          function fGetBreadCrumbline: Boolean;

      public
          Tags: TPaintTagList;     // the Tags in this line
          Top: Integer;
          property Width: Integer read fWidth;      // the width (of all Tags together)
          property Height: Integer read fheight;    // the Height (of the biggest Tag)
          property BreadCrumbline: Boolean read fGetBreadCrumbline;

          constructor Create(CanvasWidth: Integer);
          destructor Destroy; override;
          procedure FreeContainedTags;
          procedure Add(PaintTag: TPaintTag);
          procedure Paint(aCanvas: TCanvas);
  end;

  TCloudView = class;
  TCloudGetHintEvent = procedure(Sender: TCloudView; ac: TAudioFileCollection; var HintText: String) of object;

  TCloudView = class(TNempPanel)
      private
          fTotalBreadCrumbHeight: Integer;
          lastFontChangeAt: Integer;
          currentFontSize: Integer;

          fCollection: TAudioFileCollection;
          fBreadCrumbLines: TTagLineList;
          fTagLines: TTagLineList;
          fPaintBreadCrumbs: TPaintTagList;
          fPaintTags: TPaintTagList;


          fMouseOverTag: TPaintTag;
          fFocussedTag: TPaintTag;
          fLastFocussedCollectionKey: String;
          fLastKeypressTick: Int64;           // TickCount when the last keypress occured
          fSearchString: String;
          fOnGetHint: TCloudGetHintEvent;

          procedure SetMouseOverTag(Value: TPaintTag);
          procedure SetFocussedTag(Value: TPaintTag);
          function GetFocussedCollection: TAudioFileCollection;
          procedure SetFocussedCollection(Value: TAudioFileCollection);
          procedure SetCollection(Value: TAudioFileCollection);
          function GetCollection: TAudioFileCollection;

          // Painting
          function GetProperFontSize(aTag: TPaintTag):Integer;
          procedure PreparePaintBreadCrumbs;
          // first Stage: Choose as many tags as possible from the Count-Sorted Source
          procedure RawPaint1(SearchTerm: String);
          // second Stage: Paint tags String-Sorted, adjust amount of Tags if needed
          procedure RawPaint2(SearchTerm: String);
          // finally: Actually do paint the Tags on the Canvas
          procedure DoPaint;

          function GetOverLap(TagA, TagB: TPaintTag): Integer;
          function GetRootTag: TPainttag;
          function GetPreviousLine(aLine: TTagLine): TTagline;
          function GetNextLine(aLine: TTagLine): TTagline;

          function GetLeftTag: TPaintTag;
          function GetRightTag: TPaintTag;
          function GetOverlapTag(Source: TPaintTag; Dest: TTagLine): TPaintTag;
          function GetUpTag: TPaintTag;
          function GetDownTag: TPaintTag;

          function GetFirstTag: TPaintTag;
          function GetLastTag: TPaintTag;
          function GetFirstTagOfLine: TPaintTag;
          function GetLastTagOfLine: TPaintTag;

          function GetTopTag: TPaintTag;
          function GetBottomTag: TPaintTag;

          function GetTagByCollectionKey(aKey: String): TPaintTag;
          function IncrementalSearch(aKey: Word): TPaintTag;

      protected
          FLastHintCursorRect: TRect;
          procedure CMWantspecialKey(var Msg : TWMKey); message CM_WANTSpecialKey;
          procedure CMHintShow(var Message: TCMHintShow); message CM_HINTSHOW;
          procedure CMHintShowPause(var Message: TCMHintShowPause); message CM_HINTSHOWPAUSE;

      public
          property Collection: TAudioFileCollection read GetCollection write SetCollection;
          property MouseOverTag: TPaintTag read fMouseOverTag write SetMouseOverTag;
          property FocussedTag: TPaintTag read fFocussedTag write SetFocussedTag;
          property FocussedCollection: TAudioFileCollection read GetFocussedCollection write SetFocussedCollection;

          property OnGetHint: TCloudGetHintEvent read fOnGetHint write fOnGetHint;

          constructor Create(AOwner: TComponent); override;
          destructor Destroy; override;
          procedure Clear;

          // Paint the TagCloud.
          // Optional Parameter: Do not Paint "all of the Collection"
          // (but, maybe todo: a part of the Collections which matches a search term)
          procedure PaintCloud(SearchTerm: String = '');
          procedure ResizePaint(SearchTerm: String = '');
          procedure PaintAgain;

          // Navigate through the Cloud
          procedure NavigateCloud(aKey: Word; Shift: TShiftState);
          function GetTagAtMousePos(x,y: Integer): TPaintTag;
          function GetFirstNewTag: TPaintTag;
          function GetFirstNewCollection: TAudioFileCollection;

          function PainttagsCount: Integer;

      published
          property OnKeypress;
          property OnKeyDown;

  end;


//function Sort_Count(item1,item2:pointer):integer;
//function Sort_Name(item1,item2:pointer):integer;
//function Sort_Count_DESC(item1,item2:pointer):integer;
//function Sort_Name_DESC(item1,item2:pointer):integer;
// function Sort_TotalCount(item1,item2:pointer):integer;

var
    TagCustomizer: TTagCustomizer;

implementation

(*
function Sort_Count(item1,item2:pointer):integer;
begin
    result := CompareValue(TTag(item1).BreadCrumbIndex ,TTag(item2).BreadCrumbIndex);

    if result = 0 then
    begin
        result := CompareValue(TTag(item2).Count ,TTag(item1).Count);
        if result = 0 then
            result := AnsiCompareText(TTag(item1).Key ,TTag(item2).Key);
    end;
end;

function Sort_Name(item1,item2:pointer):integer;
begin
    result := CompareValue(TTag(item1).BreadCrumbIndex ,TTag(item2).BreadCrumbIndex);
    if result = 0 then
    begin
        result := AnsiCompareText(TTag(item1).Key ,TTag(item2).Key);
    end;
end;

function Sort_Count_DESC(item1,item2:pointer):integer;
begin
    result := CompareValue(TTag(item1).BreadCrumbIndex ,TTag(item2).BreadCrumbIndex);
    if result = 0 then
    begin
        result := CompareValue(TTag(item1).Count ,TTag(item2).Count);
        if result = 0 then
            result := AnsiCompareText(TTag(item1).Key ,TTag(item2).Key);
    end;
end;

function Sort_Name_DESC(item1,item2:pointer):integer;
begin
    result := CompareValue(TTag(item1).BreadCrumbIndex ,TTag(item2).BreadCrumbIndex);
    if result = 0 then
    begin
        result := AnsiCompareText(TTag(item2).Key ,TTag(item1).Key);
    end;
end;

function Sort_TotalCount(item1,item2:pointer):integer;
begin
    result := CompareValue(TTag(item2).TotalCount ,TTag(item1).TotalCount);
    if result = 0 then
        result := AnsiCompareText(TTag(item1).Key ,TTag(item2).Key);
end;
*)

(*
// ELF-Hash by alzaimar
// http://www.delphi-forum.de/viewtopic.php?p=590514#590514
function HashFromStr(Const Value: String): Cardinal; // ELF-Hash
var
  i: Integer;
  x: Cardinal;
begin
    Result := 0;
    for i := 1 to length(Value) do
    begin
        Result := (Result shl 4) + Ord(Value[i]);
        x := Result and $F0000000;
        if (x <> 0) then
            Result := Result xor (x shr 24);
        Result := Result and (not x);
    end;
    // modification: Use only the last 10 bits (= 1024 values)
    Result := Result AND $3FF;
end;
*)

{ TPaintTag }

constructor TPaintTag.Create(aCollection: TAudioFileCollection);
begin
  inherited create;
  fHover := False;
  fFocussed := False;
  fCollection := aCollection;
end;

function TPaintTag.GetCaption: String;
begin
  if fCollection.Content = ccRoot then
    result := fCollection.CategoryCaption
  else
    result := fCollection.Key;

  if result = '' then
    result := '- ? -';
end;

function TPaintTag.GetCount: Integer;
begin
  result := fCollection.Count;
end;


procedure TPaintTag.MeasureOutput(aCanvas: TCanvas);
begin
  aCanvas.Font.Size := FontSize;
  fWidth := aCanvas.TextWidth(Caption) + 4 * BORDER_WIDTH;
  fHeight := aCanvas.TextHeight(Caption) + 4 * BORDER_HEIGHT;
end;

procedure TPaintTag.SetPosition(x, y: Integer);
begin
  fLeft := x;
  fTop := y;
end;

{
  Erase:
  Erase the Tag-Rect and draw the matching part of the Background-Image
}
procedure TPaintTag.Erase(aCanvas: TCanvas; Blend:Boolean);
var tmp: TBitmap;
begin
  if not TagCustomizer.UseBackGround then begin
    aCanvas.Brush.Style := bsSolid;
    aCanvas.Brush.Color := TagCustomizer.BackgroundColor;
    aCanvas.FillRect(Rect(fLeft, fTop, fLeft + fWidth, fTop + fHeight));
  end else
  begin
    tmp := TBitmap.Create;
    try
      tmp.Width := fWidth;
      tmp.Height := fHeight;
      TagCustomizer.TileGraphic(tmp.Canvas, TagCustomizer.OffSetX + fLeft, TagCustomizer.OffSetY + fTop );
      aCanvas.Draw(fLeft, fTop, tmp);
    finally
      tmp.Free;
    end;
  end;
  if Blend then
    TagCustomizer.AlphaBlendCloud(aCanvas, fWidth, fHeight, fLeft, fTop, bm_Cloud);
end;

procedure TPaintTag.Paint(aCanvas: TCanvas);
begin
  aCanvas.Brush.Style := bsClear;
  Erase(aCanvas, (Not fFocussed) and TagCustomizer.TagUseAlphablend);
  if not (fFocussed or fHover) then
    PaintNormal(aCanvas)
  else
    if fFocussed then
      PaintFocussed(aCanvas)
    else
      PaintHover(aCanvas);
end;

procedure TPaintTag.PaintNormal(aCanvas: TCanvas);
begin
  // Draw a roundrect around the Breadcrumb-Tags
  if IsBreadCrumb then begin
    aCanvas.Pen.Color := TagCustomizer.FocusBorderColor;
    aCanvas.RoundRect(fLeft, fTop, fLeft + fWidth , fTop + fHeight , 6, 6);

    if TagCustomizer.TagUseAlphablend then
      TagCustomizer.AlphaBlendCloud(aCanvas, fWidth - 2, fHeight - 2,
                                  fLeft + 1, fTop + 1, bm_Tag)
    else
    begin
      aCanvas.Brush.Color := TagCustomizer.TagBlendColor;
      aCanvas.FillRect (Rect(fLeft + 1, fTop + 1, fLeft + fWidth - 1, fTop + fHeight - 1));
    end;
  end;

  aCanvas.Font.Color := TagCustomizer.FontColor;
  aCanvas.Font.Style := [];
  aCanvas.Font.Size := FontSize;
  aCanvas.TextOut(fLeft + 2*BORDER_WIDTH, fTop + 2*BORDER_Height, Caption);
end;


procedure TPaintTag.PaintHover(aCanvas: TCanvas);
begin
  if IsBreadCrumb then begin
    aCanvas.Pen.Color := TagCustomizer.FocusBorderColor;
    aCanvas.RoundRect(fLeft, fTop, fLeft + fWidth , fTop + fHeight , 6, 6);

    if TagCustomizer.TagUseAlphablend then
      TagCustomizer.AlphaBlendCloud(aCanvas, fWidth - 2, fHeight - 2,
                                  fLeft + 1, fTop + 1, bm_Tag)
    else
    begin
      aCanvas.Brush.Color := TagCustomizer.TagBlendColor;
      aCanvas.FillRect (Rect(fLeft + 1, fTop + 1, fLeft + fWidth - 1, fTop + fHeight - 1));
    end;
  end;

  // Draw the text
  aCanvas.Font.Color := TagCustomizer.HoverFontColor;
  aCanvas.Font.Style := [fsUnderline];
  aCanvas.Font.Size := FontSize;
  aCanvas.TextOut(fLeft + 2*BORDER_WIDTH, fTop + 2*BORDER_Height, Caption)
end;

procedure TPaintTag.PaintFocussed(aCanvas: TCanvas);
begin
  // Draw a roundrect (always)
  aCanvas.Pen.Color := TagCustomizer.FocusBorderColor;
  aCanvas.RoundRect(fLeft, fTop, fLeft + fWidth , fTop + fHeight , 6, 6);

  if TagCustomizer.TagUseAlphablend then
    TagCustomizer.AlphaBlendCloud(aCanvas, fWidth - 2, fHeight - 2,
                                fLeft + 1, fTop + 1, bm_Tag)
  else
  begin
    aCanvas.Brush.Color := TagCustomizer.TagBlendColor;
    aCanvas.FillRect (Rect(fLeft + 1, fTop + 1, fLeft + fWidth - 1, fTop + fHeight - 1));
  end;

  // Draw the text
  aCanvas.Font.Color := TagCustomizer.FocusFontColor;
  aCanvas.Font.Style := [];
  aCanvas.Font.Size := FontSize;
  aCanvas.TextOut(fLeft + 2*BORDER_WIDTH, fTop + 2*BORDER_Height, Caption);
end;


{ TTagLine }

constructor TTagLine.Create(CanvasWidth: Integer);
begin
  fCanvasWidth := CanvasWidth;
  Tags := TPaintTagList.Create(False);
end;

destructor TTagLine.Destroy;
begin
  Tags.Free;
  inherited;
end;

procedure TTagLine.FreeContainedTags;
var
  i: Integer;
begin
  for i := 0 to Tags.Count - 1 do
    Tags[i].Free;
end;

procedure TTagLine.Add(PaintTag: TPaintTag);
begin
  Tags.add(PaintTag);
  PaintTag.fParentLine := Self;
end;

function TTagLine.fGetBreadCrumbline: Boolean;
begin
  result := (Tags.Count > 0) and (Tags[0].IsBreadCrumb);
end;

{
  ------------------------------------
  Tagline.Paint
  - Paint all the Tags of the line.
    This is done in the final step of the drawing
  ------------------------------------
}
procedure TTagLine.Paint(aCanvas: TCanvas);
var i, x: Integer;
    pt: TPaintTag;
begin
  // determine horizontal gap for the alignment
  if (Tags.Count > 1) and (not Tags[0].IsBreadCrumb)  then
    fGap := (fCanvasWidth - Width) div (Tags.Count - 1)
  else
    fGap := BREADCRUMB_HGAP;

  x := 0;
  for i := 0 to Tags.Count - 1 do
  begin
    // Paint the tags and set their coordinates accoding to the draw coordinates
    pt := Tags[i];
    pt.fTop := Top + ((fHeight - pt.Height) div 2);
    pt.fLeft := x;
    pt.Paint(aCanvas);
    x := x + pt.Width + fGap;
  end;
end;


{ TCloudPainter }

constructor TCloudView.Create(AOwner: TComponent);
begin
  inherited create(AOwner);
  fCollection := Nil;
  fBreadCrumbLines := TTagLineList.Create(True); // OwnsObjects: TRUE
  fTagLines := TTagLineList.Create(True);  // OwnsObjects: True as well, but the contained Painttags are NOT freed automatically!

  fPaintBreadCrumbs := TPaintTagList.Create(True);
  fPaintTags := TPaintTagList.Create(True);
end;

destructor TCloudView.Destroy;
begin
  fBreadCrumbLines.Free;
  fTagLines.Free;

  fPaintBreadCrumbs.Free;
  fPaintTags.Free;

  inherited;
end;

procedure TCloudView.Clear;
begin
  fMouseOverTag := Nil;
  fFocussedTag := Nil;
  fBreadCrumbLines.Clear;
  fTagLines.Clear;
  fPaintBreadCrumbs.Clear;
  fPaintTags.Clear;
  fCollection := Nil;
end;

procedure TCloudView.SetCollection(Value: TAudioFileCollection);
begin
  fCollection := Value;
end;

function TCloudView.GetCollection: TAudioFileCollection;
begin
  result := fCollection;
end;


procedure TCloudView.DoPaint;
var y, i: Integer;
  Buffer: TBitmap;
begin

//    Canvas.Brush.Color := TagCustomizer.BackgroundColor;
//    Canvas.Brush.Style := bsSolid;
//    Canvas.FillRect(Rect(0,0,width, Height));

    Buffer := TBitmap.Create;
    try
        Buffer.Width := Width;
        Buffer.Height := Height;

          if TagCustomizer.UseBackGround and assigned(TagCustomizer.BackgroundImage) then
          begin
              TagCustomizer.TileGraphic(Buffer.Canvas,
                    TagCustomizer.OffSetX, TagCustomizer.OffSetY);
              // Height of the actual Cloud
              y := fTotalBreadCrumbHeight;
              for i := 0 to fTagLines.Count - 1 do
                y := y + fTaglines[i].Height;

              TagCustomizer.AlphaBlendCloud(Buffer.Canvas, Width, y, 0, 0, bm_Cloud);
          end else
          begin
              Buffer.Canvas.Brush.Color := TagCustomizer.BackgroundColor;
              Buffer.Canvas.FillRect(Buffer.Canvas.ClipRect);
          end;

          // Paint BreadCrumbs
          for i := 0 to fPaintBreadCrumbs.Count - 1 do
            fPaintBreadCrumbs[i].Paint(Buffer.Canvas);

          // Paint other tags
          y := fTotalBreadCrumbHeight;
          for i := 0 to fTagLines.Count - 1 do
          begin
              fTaglines[i].Top := y;
              fTaglines[i].Paint(Buffer.Canvas);
              y := y + fTaglines[i].Height;
          end;

          Canvas.Draw(0,0, Buffer);
    finally
      Buffer.Free;
    end;
end;


procedure TCloudView.PaintCloud(SearchTerm: String = '');
begin
  PreparePaintBreadCrumbs;
  RawPaint1(SearchTerm);
  RawPaint2(SearchTerm);

  DoPaint;
end;

procedure TCloudView.ResizePaint(SearchTerm: String = '');
var
  reFocus: TPaintTag;
begin
  PreparePaintBreadCrumbs;
  RawPaint1(SearchTerm);
  RawPaint2(SearchTerm);

  if fLastFocussedCollectionKey <> '' then begin
    reFocus := GetTagByCollectionKey(fLastFocussedCollectionKey);
    if not assigned(reFocus) then
      reFocus := GetFirstNewTag;
  end else
    reFocus := GetRootTag;

  if assigned(reFocus) then begin
      fFocussedTag := reFocus;
      reFocus.fFocussed := True;
    end;

  DoPaint;
end;

procedure TCloudView.PaintAgain;
begin
  DoPaint;
end;


function TCloudView.GetProperFontSize(aTag: TPaintTag): Integer;
begin
  if (aTag.count < (0.9 * lastFontChangeAt)) then
  begin
      if currentFontSize > 8 then
          currentFontSize := currentFontSize - 1;
      lastFontChangeAt := aTag.count;
  end;
  result := currentFontSize;
end;


function TCloudView.GetTagAtMousePos(x, y: Integer): TPaintTag;
var
  line: TTagLine;
  i: Integer;
  CheckLines: TTagLineList;
begin
    result := Nil;
    line := Nil;
    if y < self.fTotalBreadCrumbHeight then
      CheckLines := fBreadCrumbLines
    else
      CheckLines := fTaglines;

    for i := CheckLines.Count - 1 downto 0 do
      if CheckLines[i].Top <= y then
      begin
          line := CheckLines[i];
          break;
      end;

    if assigned(line) and not ((y >= line.Top) and (y <= line.Top + line.Height)) then
      line := Nil;

    if assigned(line) then begin
      for i := line.Tags.Count - 1 downto 0 do begin
        if line.Tags[i].fLeft <= x then begin
          result := line.Tags[i];
          break;
        end;
      end;

      if  assigned(result) and not ((x > result.fLeft) and (x < result.fLeft + result.fWidth)) then
        result := NIL;
    end;
end;


function TCloudView.GetFirstNewCollection: TAudioFileCollection;
var
  aTag: TPaintTag;
begin
  aTag := GetFirstNewTag;
  if assigned(aTag) then
    result := aTag.fCollection
  else
    result := Nil;
end;

function TCloudView.GetFirstNewTag: TPaintTag;
begin
  if fPaintBreadCrumbs.Count > 0 then
    result := fPaintBreadCrumbs[fPaintBreadCrumbs.Count - 1]
  else
    result := Nil; // should never happen
end;

function TCloudView.PainttagsCount: Integer;
begin
  result := fPaintTags.Count;
end;


{
  ------------------------------------
  TCloudPainter.PreparePaintBreadCrumbs
  - Initial Step of the Painting.
    Measure the space needed for the Breadcrumbs, store the PaintObjects
    in fBreadCrumbLines.
  Executed only once after a new Collection is set
  ------------------------------------
}
procedure TCloudView.PreparePaintBreadCrumbs;
var
  i, x, y, lineHeight: Integer;
  colList: TAudioFileCollectionList;
  loopCollection: TAudioFileCollection;
  newTag: TPaintTag;
  newLine: TTagLine;

begin
  // Free the PaintObjects within the BreadCrumbLines
  fMouseOverTag := Nil;
  fFocussedTag := Nil;

  fBreadCrumbLines.Clear;
  fPaintBreadCrumbs.Clear;

  //for i := 0 to fBreadCrumbLines.Count - 1 do
  //  fBreadCrumbLines[i].FreeContainedTags;
  // Clear the Lines (and free the TagLine-Objects automatically)


  loopCollection := fCollection;
  if not assigned(loopCollection) then
    exit;     // nothing to do yet

  // get the BreadCrumb-Collection we need to Paint
  colList := TAudioFileCollectionList.Create(False);
  try

    colList.add(loopCollection);
    while assigned(loopCollection) and (loopCollection.Content <> ccRoot) do
    begin
      loopCollection := loopCollection.Parent;
      colList.add(loopCollection);
    end;

    // The very first Breadcrumb should be painted with a little margin for the Category-MenuButton
    x := FIRST_BREADCRUMB_MARGIN;
    y := TOP_MARGIN;

    newLine := TTagLine.Create(Width);
    newLine.Top := TOP_MARGIN;
    fBreadCrumbLines.Add(newLine);

    newTag := TPaintTag.Create(colList[colList.Count - 1]);
    newTag.IsBreadCrumb := True;
    newTag.FontSize := FONTSIZE_BREADCRUMB;
    newTag.MeasureOutput(Canvas);
    newTag.SetPosition(x, y);
    newLine.Add(newTag);
    newLine.fHeight := newTag.Height;
    fPaintBreadCrumbs.Add(newTag);
    x := x + newTag.Width + BREADCRUMB_HGAP;
    lineHeight := newTag.Height;

    for i := colList.Count - 2 downto 0 do begin
      newTag := TPaintTag.Create(colList[i]);
      newTag.IsBreadCrumb := True;
      newTag.FontSize := FONTSIZE_BREADCRUMB;
      newTag.MeasureOutput(Canvas);

      // Does the newTag fit into the current Line?
      // If not: Start a new one
      if ((x + newTag.Width <= Width) or (x = 0)) then begin
        newTag.SetPosition(x, y);
        x := x + newTag.Width + BREADCRUMB_HGAP;
      end
      else begin
        // Tag does NOT fit in the current line => start a new one
        newLine := TTagLine.Create(Width);
        fBreadCrumbLines.Add(newLine);
        y := y + lineHeight + BREADCRUMB_VGAP;
        newTag.SetPosition(FIRST_BREADCRUMB_MARGIN, y);
        newLine.Top := y;
        newLine.fHeight := newTag.Height;
        x := FIRST_BREADCRUMB_MARGIN + newTag.Width + BREADCRUMB_HGAP;
      end;


      newLine.Add(newTag);
      fPaintBreadCrumbs.Add(newTag);
    end;
    fTotalBreadCrumbHeight := y + lineHeight + BREADCRUMB_VGAP;
  finally
    colList.Free;
  end;
end;
{
  ------------------------------------
  TCloudPainter.RawPaint1
  - First Step of the Painting.
    Sort SubCollections by Count and add as many as fit into the Canvas
    to the list of fPaintTags

  ------------------------------------
}
procedure TCloudView.RawPaint1(SearchTerm: String);
var x, y, i, lineHeight, maxCount: Integer;
    newTag: TPaintTag;
    CanvasFull: Boolean;
begin
  if not assigned(fCollection) then
    exit;

  // Sort CurrentCollection by Count: We want to paint the collections with the highest Count
  fCollection.ReSort(csCount, sd_Descending);

  // Clear all existing PaintObjects
  fMouseOverTag := Nil;
  fFocussedTag := Nil;

  fPaintTags.Clear;
  fTagLines.Clear;

  // init local variables
  CanvasFull := False;
  i := 0;
  x := 0;
  y := fTotalBreadCrumbHeight;
  lineHeight := 0;
  if fCollection.CollectionCount > 0 then
    maxCount := fCollection.Collection[0].Count
  else
    maxCount := 0;
  lastFontChangeAt := maxCount;
  case maxCount of
    0..10: currentFontSize := 12;
    11..25: currentFontSize := 13;
    26..50: currentFontSize := 14;
    51..75: currentFontSize := 15;
    76..100: currentFontSize := 16;
    101..125: currentFontSize := 17;
    126..150: currentFontSize := 18;
    151..175: currentFontSize := 19;
  else
    currentFontSize := 20;
  end;

    while (i < fCollection.CollectionCount) and not CanvasFull do
    begin
      if (searchTerm <> '') and (not AnsiContainsText(fCollection.Collection[i].Key, SearchTerm)) then begin
        inc(i);
        continue;
      end;

      newTag := TPaintTag.Create(TAudioFileCollection(fCollection.Collection[i]));
      inc(i);

      // Set the FontSize used to display the tag
      newTag.FontSize := GetProperFontSize(newTag);
      // get the size of the Tag on the Canvas
      newTag.MeasureOutput(Canvas);

      // Does the newTag fit into the current Line?
      if ((x + newTag.Width <= Width) or (x = 0)) then begin
        x := x + newTag.Width;
        lineHeight := max(lineHeight, newTag.Height);
        fPaintTags.add(newTag);
      end
      else begin
        // Tag does NOT fit in the current line => start a new one
        y := y + lineHeight;
        if (y + newTag.Height < Height - 8) then
        begin
            lineHeight := newTag.Height;
            x := newTag.Width;
            fPaintTags.add(newTag);
        end else
        begin
            // Canvas is full, stop adding more SubCollections/Tags
            newTag.Free;
            CanvasFull := True;
        end;
      end;
    end;  // while
end;

procedure TCloudView.RawPaint2(SearchTerm: String);
var i, x, y: Integer;
    currentLine: TTagLine;
    currentTag: TPaintTag;
    CanvasFull: Boolean;
    SuccessfullyPaintItems: Integer;
    Fail: Boolean;
begin

    fTagLines.Clear;
    // Sort the List of PaintTags (collected in the first painting stage) by Name
    fPaintTags.Sort(TComparer<TPaintTag>.Construct(
        function (const item1, item2: TPaintTag): Integer
        begin
          result := AnsiCompareText(item1.Caption, item2.Caption);
        end));

    x := 0;
    y := fTotalBreadCrumbHeight;
    i := 0;
    CanvasFull := False;
    Fail := False;
    SuccessfullyPaintItems := 0;

    currentLine := TTagLine.Create(Width);
    fTagLines.Add(currentLine);

    //for i := 0 to Tags.Count - 1 do
    while (i < fPaintTags.Count) and Not CanvasFull do
    begin
        currentTag := fPaintTags[i];

        if (x + currentTag.Width <= Width) or (x = 0) then
        begin
            // Tag fits in currentLine, so add it to it
            currentLine.Add(currentTag);
            currentLine.fHeight := max(currentLine.Height, currentTag.Height);
            currentLine.fWidth := currentLine.Width + currentTag.Width;
            x := x + currentTag.Width;
        end else
        begin
            // Tag does not fit any more, start a new TagLine
            y := y + currentLine.Height;
            if y > Height - 8 then
            begin
                // The currentLine has grown to much in Height
                // => it cannot be painted on the canvas
                CanvasFull := True;
                Fail := True;
            end else
            begin
                // The currentLine fits into the Canvas
                SuccessfullyPaintItems := i-1;
                // Start a new one
                currentLine := TTagLine.Create(Width);
                fTagLines.Add(currentLine);
                currentLine.Add(currentTag);
                currentLine.fHeight := currentTag.Height;
                currentLine.fWidth := currentTag.Width;
                x := currentTag.Width ;
            end;
        end;
        inc(i);
    end;

    if y + currentLine.Height > Height - 8 then
        Fail := True;

    if Fail and (fPaintTags.Count > 0) then
    begin
        // we have to much in our TagList. So: Delete some tags
        // - Sort the PaintedTags by Count again and remove the ones with the smallest Values
        // - Try again
        fPaintTags.Sort(TComparer<TPaintTag>.Construct(
        function (const item1, item2: TPaintTag): Integer
        begin
          result := CompareValue(item2.Count, item1.Count); // reverse sort order
        end));

        for i := fPaintTags.Count - 1 downto SuccessfullyPaintItems do
          fPaintTags.Delete(i);

        RawPaint2(SearchTerm);
    end;
end;

(*procedure TCloudPainter.RePaintTag(aTag: TPaintTag; Active: Boolean);
begin
    if assigned(aTag) then
    begin
        aTag.Paint(Canvas);
    end;
end;*)

procedure TCloudView.SetFocussedTag(Value: TPaintTag);
begin
    if assigned(fFocussedTag) then
    begin
        fFocussedTag.fFocussed := False;
        fFocussedTag.Paint(Canvas);
    end;

    fFocussedTag := Value;
    if assigned(fFocussedTag) then
    begin
        fLastFocussedCollectionKey := Value.fCollection.Key;
        fFocussedTag.fFocussed := True;
        fFocussedTag.Paint(Canvas);
    end else
        fLastFocussedCollectionKey := '';
end;

procedure TCloudView.SetMouseOverTag(Value: TPaintTag);
begin
  if Value = fMouseOverTag then
    exit;

  if assigned(fMouseOverTag) then
  begin
      fMouseOverTag.fHover := False;
      fMouseOverTag.Paint(Canvas);
  end;

  fMouseOverTag := Value;
  if assigned(fMouseOverTag) then
  begin
      fMouseOverTag.fHover := True;
      fMouseOverTag.Paint(Canvas);
  end;
end;

function TCloudView.GetFocussedCollection: TAudioFileCollection;
begin
  if assigned(fFocussedTag) then
    result := fFocussedTag.fCollection
  else
    result := Nil;
end;

procedure TCloudView.SetFocussedCollection(Value: TAudioFileCollection);
var
  i: Integer;
  done: Boolean;
begin
  if not assigned(Value) then
    exit;

  done := False;
  for i := 0 to fPaintBreadCrumbs.Count - 1 do
    if fPaintBreadCrumbs[i].fCollection.Key = Value.Key then begin
      FocussedTag := fPaintBreadCrumbs[i];
      done := True;
      break;
    end;

  if not done then begin
    for i := 0 to fPaintTags.Count - 1 do
      if fPaintTags[i].fCollection.Key = Value.Key then begin
        FocussedTag := fPaintTags[i];
        break;
      end;
  end;

end;

function TCloudView.GetOverLap(TagA, TagB: TPaintTag): Integer;
var aRight, bRight, aLeft, bLeft: Integer;
begin
    aLeft := TagA.fLeft;
    bLeft := TagB.fLeft;

    aRight := TagA.fLeft + TagA.fWidth;
    bRight := TagB.fLeft + TagB.fWidth;

    if (aLeft <= bLeft) and (aRight >= bLeft) and (aRight <= bRight)  then
        result := aRight - bLeft

    else

    if (aLeft >= bLeft) and (aRight <= bRight)  then
        result := 10000 //aRight - aLeft

    else

    if (aLeft >= bLeft) and (aLeft <= bRight) and (aRight >= bRight)  then
        result := bRight - aLeft

    else

    if (aLeft <= bLeft) and (aRight >= bRight)  then
        result := 10000 //bRight - bLeft

    else
        result := 0;

end;

function TCloudView.GetRootTag: TPainttag;
begin
  if fPaintBreadCrumbs.Count > 0 then
    result := fPaintBreadCrumbs[0]
  else
    result := Nil;
end;

function TCloudView.GetPreviousLine(aLine: TTagLine): TTagline;
var
  idx: Integer;
begin
  idx := fTagLines.IndexOf(aLine);
  if idx = 0 then
    result := fBreadCrumbLines[fBreadCrumbLines.Count-1]
  else
    if idx > 0 then
      result := fTagLines[idx - 1]
    else begin
      idx := fBreadCrumbLines.IndexOf(aLine);
      if idx > 0 then
        result := fBreadCrumbLines[idx - 1]
      else
        result := Nil; // or fBreadCrumbLines[0]; // or NIL?
    end;
end;

function TCloudView.GetNextLine(aLine: TTagLine): TTagline;
var
  idx: Integer;
begin
  idx := fBreadCrumbLines.IndexOf(aLine);

  if (idx = fBreadCrumbLines.Count - 1) then begin
    if fTagLines.Count > 0 then
      result := fTagLines[0]
    else
      result := Nil;
  end else
    if idx >= 0 then begin
      result := fBreadCrumbLines[idx + 1]
    end else
    begin
      idx := fTagLines.IndexOf(aLine);
      if (idx >= 0) and (idx < fTagLines.Count - 1) then
        result := fTagLines[idx + 1]
      else
        result := Nil;
    end;
end;


function TCloudView.GetLeftTag: TPaintTag;
var aLine, bLine: TTagLine;
    aIdx: Integer;
begin
  if assigned(fFocussedTag) then
  begin
    aLine := fFocussedTag.fParentLine;
    aIdx := aLine.Tags.IndexOf(fFocussedTag);
    if aIdx > 0 then
      // get the tag left of the current Tag in this line
      result := aLine.Tags[aIdx - 1]
    else
    begin
      // Go one line up and select the last one there
      bline := GetPreviousLine(aLine);
      if assigned(bLine) and (bLine.Tags.Count > 0) then
        result := bline.Tags[bLine.Tags.Count - 1]
      else
        result := GetRootTag;
    end;
  end
  else
    result := GetRootTag;
end;


function TCloudView.GetRightTag: TPaintTag;
var aLine, bLine: TTagLine;
    aIdx: Integer;
begin
  if assigned(fFocussedTag) then
  begin
    aLine := fFocussedTag.fParentLine;
    aIdx := aLine.Tags.IndexOf(fFocussedTag);
    if aIdx < aLine.Tags.Count - 1 then
      // get the tag right of the current Tag in this line
      result := TPainttag(aLine.Tags[aIdx + 1])
    else
    begin
      // Go one line down and select the first one there
      bLine := GetNextLine(aLine);
      if assigned(bLine) and (bLine.Tags.Count > 0) then
        result := bLine.Tags[0]
      else
        result := fFocussedTag;
    end;
  end
  else
    result := GetRootTag;
end;

function TCloudView.GetOverlapTag(Source: TPaintTag; Dest: TTagLine): TPaintTag;
var
  oMax, oCurrent, i: Integer;
begin
  result := Nil;
  oMax := -1;
  for i := 0 to Dest.Tags.Count - 1 do
  begin
    oCurrent := GetOverLap(Source, Dest.Tags[i]);
    if oCurrent > oMax then
    begin
      result := Dest.Tags[i];
      oMax := oCurrent;
    end;
  end;
end;

function TCloudView.GetUpTag: TPaintTag;
var
  bLine: TTagLine;
begin
  if assigned(fFocussedTag) then
  begin
    bLine := GetPreviousLine(fFocussedTag.fParentLine);
    if assigned(bLine) and (bLine.Tags.Count > 0)  then
      result := GetOverlapTag(fFocussedTag, bLine)
    else
      result := fFocussedTag
  end else
    result := GetRootTag;
end;


function TCloudView.GetDownTag: TPaintTag;
var
  bLine: TTagLine;
begin
  if assigned(fFocussedTag) then
  begin
    bLine := GetNextLine(fFocussedTag.fParentLine);
    if assigned(bLine) and (bLine.Tags.Count > 0)  then
      result := GetOverlapTag(fFocussedTag, bLine)
    else
      result := fFocussedTag
  end else
    result := GetRootTag;
end;

function TCloudView.GetFirstTag: TPaintTag;
var aLine: TTagline;
begin
    if fTagLines.Count > 0 then
    begin
        aLine := fTagLines[0];
        if aLine.Tags.Count > 0 then
            result := aLine.Tags[0]
        else
            result := GetRootTag
    end else
        result := GetRootTag;
end;
function TCloudView.GetLastTag: TPaintTag;
var aLine: TTagline;
begin
    if fTagLines.Count > 0 then
    begin
        aLine := fTagLines[fTagLines.Count-1];
        if aLine.Tags.Count > 0 then
            result := aLine.Tags[aLine.Tags.Count - 1]
        else
            result := GetRootTag
    end else
        result := GetRootTag;
end;

function TCloudView.GetFirstTagOfLine: TPaintTag;
var aLine: TTagline;
begin
    if assigned(fFocussedTag) then
    begin
        aLine := fFocussedTag.fParentLine;

        if aLine.Tags.Count > 0 then
            result := aLine.Tags[0]
        else
            result := GetRootTag
    end else
        result := GetRootTag;
end;
function TCloudView.GetLastTagOfLine: TPaintTag;
var aLine: TTagline;
begin
    if assigned(fFocussedTag) then
    begin
        aLine := fFocussedTag.fParentLine;
        if aLine.Tags.Count > 0 then
            result := aLine.Tags[aLine.Tags.Count - 1]
        else
            result := GetRootTag
    end else
        result := GetRootTag;
end;

function TCloudView.GetTopTag: TPaintTag;
var
  bLine: TTagLine;
begin
    if assigned(fFocussedTag) then
    begin
      result := fFocussedTag;
      if fTagLines.Count > 0 then
      begin
        bLine := fTagLines[0];
        if bLine.Tags.Count = 0 then
          result := Nil
        else
          result := GetOverlapTag(fFocussedTag, bLine)
      end else
        result := GetRootTag;
    end else
      result := GetRootTag;
end;


function TCloudView.GetBottomTag: TPaintTag;
var
  bLine: TTagLine;
begin
  if assigned(fFocussedTag) then
  begin
    result := fFocussedTag;
    if fTagLines.Count > 0 then
    begin
      bLine := fTagLines[fTagLines.Count - 1];
      if bLine.Tags.Count = 0 then
        result := Nil
      else
        result := GetOverlapTag(fFocussedTag, bLine)
    end else
      result := GetRootTag;
  end else
    result := GetRootTag;
end;



function TCloudView.IncrementalSearch(aKey: Word): TPaintTag;
var aLine: TTagLine;
    tc: Int64;
    LineCount, LineIdx, TagIdx: Integer;

    function GetNextInLine(Offset: Integer): TPaintTag;
    var
      i: integer;
    begin
      result := Nil;
      for i := Offset to aLine.Tags.Count - 1 do
      begin
        if AnsiContainsText(aLine.Tags[i].Caption, fSearchString) then
        begin
          result := aLine.Tags[i];
          break;
        end;
      end;
    end;

begin
    tc := GetTickCount;
    if aKey <> vk_F3 then
    begin
        if (tc - fLastKeypressTick < 1000) then
            fSearchString := fSearchString + Char(aKey)
        else
            fSearchString := Char(aKey);
    end;
    fLastKeypressTick := tc;

    if assigned(fFocussedTag) then
    begin
        aLine := fFocussedTag.fParentLine;
        LineIdx := fTagLines.IndexOf(aLine);
        TagIdx := aLine.Tags.IndexOf(fFocussedTag);
        if aKey = vk_F3 then
            inc(TagIdx);
        result := GetNextInLine(TagIdx);
        LineCount := 0;
        while (not assigned(result)) and (LineCount <= fTagLines.Count - 1) do
        begin
            inc(LineCount);
            LineIdx := (LineIdx + 1) mod (fTagLines.Count);
            aLine := fTagLines[LineIdx];
            result := GetNextInLine(0);
        end;
        if not assigned(result) then
            result := fFocussedTag;  //
    end else
        result := GetRootTag;
end;

function TCloudView.GetTagByCollectionKey(aKey: String): TPaintTag;

  function GetFromList(aList: TPaintTagList): TPaintTag;
  var i: Integer;
  begin
    result := Nil;
    for i := 0 to aList.Count - 1 do begin
      if aList[i].fCollection.Key = aKey then begin
        result := aList[i];
        break;
      end;
    end;
  end;
begin
  result := GetFromList(fPaintBreadCrumbs);
  if not assigned(result) then
    result := GetFromList(fPaintTags);
end;

procedure TCloudView.NavigateCloud(aKey: Word; Shift: TShiftState);
begin
  case aKey of
        vk_up:    FocussedTag := GetUpTag;
        vk_Down:  FocussedTag := GetDownTag;
        vk_Left:  FocussedTag := GetLeftTag;
        vk_right: FocussedTag := GetRightTag;

        vk_Escape: FocussedTag := GetRootTag;

        vk_home: begin
                    if ssCtrl in Shift then
                        FocussedTag := GetFirstTag
                    else
                        FocussedTag := GetFirstTagOfLine
        end;

        vk_end: begin
                    if ssCtrl in Shift then
                        FocussedTag := GetLastTag
                    else
                        FocussedTag := GetLastTagOfLine;
        end;

        vk_Prior: FocussedTag := GetTopTag;

        vk_Next: FocussedTag := GetBottomTag;

        vk_Back: begin
              if fPaintBreadCrumbs.Count > 1 then
                FocussedTag := fPaintBreadCrumbs[fPaintBreadCrumbs.Count - 2]
              else
                FocussedTag := GetRootTag;
              {if (fBreadCrumbDepth > 0) then
                  FocussedTag := TPaintTag(ActiveTags[fbreadCrumbDepth-1])
              else
                  FocussedTag := Nil;}
        end;
        vk_F3: FocussedTag := IncrementalSearch(aKey);
    else
        FocussedTag := IncrementalSearch(aKey);
    end;
end;



{ TCloudViewer }

procedure TCloudView.CMWantspecialKey(var Msg: TWMKey);
begin
  inherited;
  with msg do
    case Charcode of
        vk_left, vk_up, vk_right, vk_down : Result := 1;
    end;
end;


// Hints by https://www.delphipraxis.net/1098737-post7.html
procedure TCloudView.CMHintShow(var Message: TCMHintShow);
var
   HintCollection: TAudioCollection;
   HintPaintTag: TPaintTag;
   MinHintPosY: Integer;
   HintInfo: PHintInfo;
begin
   Message.Result := 1; // 1 verhindert und 0 erlaubt die Erstellung des Hints
   HintInfo := Message.HintInfo;

   if PtInRect(FLastHintCursorRect, HintInfo.CursorPos) then
    exit;

   HintPaintTag := GetTagAtMousePos(HintInfo.CursorPos.X, HintInfo.CursorPos.Y);
   if not Assigned(HintPaintTag) then //and HintTile.ShowHint) then
    exit;

   FLastHintCursorRect :=
      Rect(HintPaintTag.fLeft, HintPaintTag.fParentLine.Top,
           HintPaintTag.fLeft + HintPaintTag.fWidth,
           HintPaintTag.fParentLine.Top + HintPaintTag.fParentLine.fHeight );

   HintInfo.CursorRect := FLastHintCursorRect;
   HintInfo.HintWindowClass := THintWindow; //GetHintWindowClass; // Beliebige THintWindow-Klasse

   if assigned(fOnGetHint) then
    fOnGetHint(self, HintPaintTag.fCollection, HintInfo.HintStr)
   else
     HintInfo.HintStr := HintPaintTag.fCollection.Caption;

   // Beliebiger Pointer: siehe 3. Parameter von THintWindow.ActivateHintData
   HintInfo.HintData := Nil; //Pointer(HintTile);

   //HintInfo.HideTimeout := 5; // -1 = kein Timeout
   HintInfo.ReshowTimeout := 0;

   HintInfo.HintPos.X := HintInfo.CursorPos.X + 20; //FLastHintCursorRect.Right;
   HintInfo.HintPos.Y := FLastHintCursorRect.Bottom;
   HintInfo.HintPos := ClientToScreen(HintInfo.HintPos);
   MinHintPosY := ClientToScreen(Point(0, 0)).Y;
   HintInfo.HintPos.Y := Max(HintInfo.HintPos.Y, MinHintPosY);

   Message.Result := 0; // Erstellung erlauben
end;

procedure TCloudView.CMHintShowPause(var Message: TCMHintShowPause);
begin
   Message.Pause^ := 50; // Pause in Millisekunden bevor der Hint angezeigt wird
end;
                        (*
procedure TCloudViewer.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  if Assigned(FOnPaint) then
      Message.Result := 1
  else
      inherited
end;

procedure TCloudViewer.WMPaint(var Message: TWMPaint);
begin
  if Message.DC = 0 then
    // WM_PAINT sent for normal painting
    inherited
  else
  begin
      if Assigned(FOnPaint) then
        FOnPaint(Self)
  end;

end;     *)


{ TTagCustomizer }

constructor TTagCustomizer.Create;
begin
    inherited;
    {Color := 0;
    ActiveColor := clRed;

    FocusColor := clGray;
    FocusBorderColor := clBlue;}
    //BackgroundImage := TBitmap.Create;
end;

destructor TTagCustomizer.Destroy;
begin
    //BackgroundImage.Free;
    inherited destroy;
end;

// This is (almost) a copy of NempSkin.TileGraphic,
// but without the Stretch-stuff
procedure TTagCustomizer.TileGraphic(
  const ATarget: TCanvas; X, Y: Integer);
var
  xstart, xloop, yloop: Integer;
begin
  if BackgroundImage.Width * BackgroundImage.Height = 0 then exit;

  if TileBackground then
  begin
      xloop := X Mod BackgroundImage.Width;
      if xloop < 0 then xloop := xloop + BackgroundImage.Width;

      xloop := -xloop;
      xstart := xloop;

      Yloop := Y Mod BackgroundImage.Height;
      if yloop < 0 then yloop := yloop + BackgroundImage.Height;

      yloop := - yloop;

      while Yloop < ATarget.ClipRect.Bottom  do
      begin
        Xloop := xstart;
        while Xloop < ATarget.ClipRect.Right do
        begin
            ATarget.StretchDraw(Rect(XLoop, YLoop, XLoop + Round(BackgroundImage.Width), yLoop + Round(BackgroundImage.Height) ), BackgroundImage);
            Inc(Xloop, Round(BackgroundImage.Width));
        end;
        Inc(Yloop, Round(BackgroundImage.Height));
      end;
  end else
  begin
    ATarget.Brush.Color := BackgroundColor;
    ATarget.FillRect(ATarget.ClipRect);
    ATarget.Draw(-x, -y, BackgroundImage);
  end;
end;

procedure TTagCustomizer.AlphaBlendCloud(TargetCanvas: TCanvas; Width, Height, Left, Top: Integer; Mode: TBlendMode);
var lBlendParams: TBlendFunction;
    AlphaBlendBMP: TBitmap;
    localIntensity: Integer;
    localBlendColor: TColor;
    localDoBlend: Boolean;
begin


    case Mode of
        bm_Cloud: begin
            localIntensity  := CloudBlendIntensity;
            localBlendColor := CloudBlendColor;
            localDoBlend    := CloudUseAlphaBlend
        end;
        bm_Tag: begin
            localIntensity  := TagBlendIntensity;
            localBlendColor := TagBlendColor;
            localDoBlend    := TagUseAlphaBlend;
        end;
    else
        begin
            localIntensity  := 0;
            localBlendColor := clWhite;
            localDoBlend    := False;
        end;
    end;

    if localDoBlend then
    begin
        // correction. This does not work with clBlack - I don't know why...
        if localBlendColor = clBlack then
            localBlendColor := localBlendColor + 1;

        AlphaBlendBMP := TBitmap.Create;
        try
            with lBlendParams do
            begin
                BlendOp := AC_SRC_OVER;
                BlendFlags := 0;
                SourceConstantAlpha := localIntensity;
                AlphaFormat := 0;
            end;


            AlphaBlendBMP.Canvas.Brush.Color := localBlendColor;

            // Bitmap-Größe einstellen, Bitmap einfärben
            AlphaBlendBMP.Width := Width;
            AlphaBlendBMP.Height := Height;
            AlphaBlendBMP.Canvas.FillRect (Rect(0, 0, Width, Height));
            // Alphablending durchführen
            Windows.AlphaBlend(TargetCanvas.Handle, Left, Top, Width, Height,
                               AlphaBlendBMP.Canvas.Handle, 0, 0, AlphaBlendBMP.Width, AlphaBlendBMP.Height, lBlendParams);

        finally
            AlphaBlendBMP.Free;
        end;
    end;
end;


initialization

    TagCustomizer := TTagCustomizer.Create;

finalization

    TagCustomizer.Free;

end.

