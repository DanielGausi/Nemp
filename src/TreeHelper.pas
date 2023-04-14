{

    Unit TreeHelper

    - Some Helper for Trees.

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
unit TreeHelper;

interface

uses Windows, Graphics, SysUtils, VirtualTrees, Forms, Controls, NempAudioFiles, Types, StrUtils,
  Contnrs, Classes, Jpeg, PNGImage, NempDragFiles, math, WinApi.ActiveX, ShlObj, ComObj,
  ShellApi,
  Id3v2Frames, dialogs, Hilfsfunktionen, LibraryOrganizer.Base, LibraryOrganizer.Files,
  Nemp_ConstantsAndTypes, CoverHelper, MedienbibliothekClass, BibHelper, RatingCtrls,
  gnuGettext, Nemp_RessourceStrings;

  function LengthToSize(len:integer; def:integer):integer;
  function MaxFontSize(default: Integer): Integer;

  function ModeToStyle(m:Byte):TFontstyles;

  function FontSelectorItemIndexToStyle(m: Integer):TFontstyles;

  procedure VSTColumns_SaveSettings(aVST: TVirtualStringTree);
  procedure VSTColumns_LoadSettings(aVST: TVirtualStringTree);

  function GetOldNode(ac: TAudioCollection; aTree: TVirtualStringTree): PVirtualNode; overload;
  function GetOldNode(lc: TLibraryCategory; aTree: TVirtualStringTree): PVirtualNode; overload;

  procedure ClearEmptyCollectionNodes(aTree: TVirtualStringTree);

  function GetNextNodeOrFirst(aTree: TVirtualStringTree; aNode: PVirtualNode): PVirtualNode;
  function GetNodeWithAudioFile(aTree: TVirtualStringTree; aAudioFile: TAudioFile): PVirtualNode;
  function GetNodeWithCueFile(aTree: TVirtualStringTree; aRootNode: PVirtualNode; aAudioFile: TAudioFile): PVirtualNode;
  function GetNodeWithIndex(aTree: TVirtualStringTree; aIndex: Cardinal; StartNode: PVirtualNode): PVirtualNode;

  procedure PrepareDragImage(DragDrop: TNempDragManager; aFile: TAudioFile);
  procedure InitiateDragDrop(SourceTree: TVirtualStringTree; DragDrop: TNempDragManager; DoExecute: Boolean; SourceIsPlayer: Boolean); overload;
  procedure InitiateDragDrop(Source: TAudioFileList; SourceControl: TControl; DragDrop: TNempDragManager; DoExecute: Boolean; SourceIsPlayer: Boolean); overload;

  function ValidPlaylistDropNode(Source: TVirtualStringTree; Node: PVirtualNode): Boolean;

  function InitiateFocussedPlay(aTree: TVirtualStringTree): Boolean;

  // Methods for TreeView-Hint with Coverart
  function MinHintHeight(RatingHelper: TRatingHelper): Integer;
  procedure VSTDrawCoverHint(Sender: TVirtualStringTree; HintCanvas: TCanvas; af: TAudioFile; R: TRect; RatingHelper: TRatingHelper);
  procedure VSTGetCoverHintSize(Sender: TVirtualStringTree; af: TAudioFile; var R: TRect; RatingHelper: TRatingHelper);


implementation

uses  NempMainUnit, PlayerClass, MainFormHelper, AudioDisplayUtils, Cover.ViewCache, VCL.Themes, VCL.GraphUtil;


function MaxFontSize(default: Integer): Integer;
begin
    // sync with function LengthToSize!
    result := default + 2;
end;

function LengthToSize(len:integer;def:integer):integer;
begin
  with Nemp_MainForm do
  begin
    //if len < NempOptions.MaxDauer[1] then result := NempOptions.FontSize[1]
    //else if len < NempOptions.MaxDauer[2] then result := NempOptions.FontSize[2]
    //else if len < NempOptions.MaxDauer[3] then result := NempOptions.FontSize[3]
    //else if len < NempOptions.MaxDauer[4] then result := NempOptions.FontSize[4]
    //else  result := NempOptions.FontSize[5]

    if len < NempOptions.MaxDauer[1] then result := def - 2
    else if len < NempOptions.MaxDauer[2] then result := def - 1
    else if len < NempOptions.MaxDauer[3] then result := def
    else if len < NempOptions.MaxDauer[4] then result := def + 1
    else  result := def + 2;

    if result < 4 then
        result := 4;
  end;
end;

function ModeToStyle(m:Byte):TFontstyles;
begin
  // ('S ','JS','DC','M ','--');
  case m of
    0,2: result := [fsbold];
    1,4: result := [];
    else result := [fsitalic];
  end;
end;

function FontSelectorItemIndexToStyle(m: Integer): TFontstyles;
begin
    case m of
        0: result := [];
        1: result := [fsbold];
        2: result := [fsitalic];
        3: result := [fsbold, fsitalic];
    else
        result := [];
    end;
end;

procedure VSTColumns_SaveSettings(aVST: TVirtualStringTree);
var
  i: Integer;
  rawVisible, rawPos, rawWidth: String;
begin
  rawPos := IntToStr(aVST.Header.Columns[0].Position);
  rawWidth :=   IntToStr(aVST.Header.Columns[0].Width);
  rawVisible := BoolToStr(coVisible in aVST.Header.Columns[0].Options);

  for i := 1 to cLibraryColumnCount - 1 do begin
    rawPos := rawPos + ';' + IntToStr(aVST.Header.Columns[i].Position);
    rawWidth   := rawWidth   + ';' + IntToStr(aVST.Header.Columns[i].Width);
    rawVisible := rawVisible + ';' + BoolToStr(coVisible in aVST.Header.Columns[i].Options);
  end;

  NempSettingsManager.WriteString('MediaListColumns', 'Position', rawPos);
  NempSettingsManager.WriteString('MediaListColumns', 'Width', rawWidth);
  NempSettingsManager.WriteString('MediaListColumns', 'Visible', rawVisible);

  // remove depecated ini section
  NempSettingsManager.EraseSection('Columns');
  NempSettingsManager.EraseSection('Spalten');
end;

procedure VSTColumns_LoadSettings(aVST: TVirtualStringTree);
var
  i: Integer;
  VisibleList, PosList, WidthList: TStringList;
begin
    NempSettingsManager.ReadString('MediaListColumns', 'Position', '');
    NempSettingsManager.ReadString('MediaListColumns', 'Width', '');
    NempSettingsManager.ReadString('MediaListColumns', 'Visible', '');
    PosList := TStringList.Create;
    WidthList := TStringList.Create;
    VisibleList := TStringList.Create;
    try
       PosList.Delimiter := ';';
       WidthList.Delimiter := ';';
       VisibleList.Delimiter := ';';
       PosList.DelimitedText     := NempSettingsManager.ReadString('MediaListColumns', 'Position', '');
       WidthList.DelimitedText   := NempSettingsManager.ReadString('MediaListColumns', 'Width', '');
       VisibleList.DelimitedText := NempSettingsManager.ReadString('MediaListColumns', 'Visible', '');

      if (PosList.Count <= cLibraryColumnCount) and (PosList.Count = WidthList.Count) and (WidthList.Count = VisibleList.Count) then
      begin
        for i := 0 to PosList.Count - 1 do
        begin
          aVST.Header.Columns[i].Position := StrToIntDef(PosList[i], DefaultColumns[i].Position);
          aVST.Header.Columns[i].Width := StrToIntDef(WidthList[i], DefaultColumns[i].width);
          if not StrToBool(VisibleList[i]) then
            aVST.Header.Columns[i].Options := aVST.Header.Columns[i].Options - [coVisible]
        end;

        // if there are more Columns than defined in the Inifile (due to a new version): Set Default values
        for i := PosList.Count to cLibraryColumnCount - 1 do
        begin
          aVST.Header.Columns[i].Position := DefaultColumns[i].Position;
          aVST.Header.Columns[i].Width := DefaultColumns[i].width;
          if not DefaultColumns[i].Visible then
            aVST.Header.Columns[i].Options := aVST.Header.Columns[i].Options - [coVisible]
        end;
      end else
      begin
        // set default values for all columns
        for i := 0 to cLibraryColumnCount-1 do
        begin
          aVST.Header.Columns[i].Position := DefaultColumns[i].Position;
          aVST.Header.Columns[i].Width := DefaultColumns[i].width;
          if not DefaultColumns[i].Visible then
            aVST.Header.Columns[i].Options := aVST.Header.Columns[i].Options - [coVisible]
        end;
      end;
    finally
      PosList.Free;
      WidthList.Free;
      VisibleList.Free;
    end;
end;


procedure ClearEmptyCollectionNodes(aTree: TVirtualStringTree);
var
  ac: TAudioCollection;
  nextNode, currentNode: PVirtualNode;

  function NextNodeNoChilds(aNode: PVirtualNode): PVirtualNode;
  begin
    result := aNode;
    // same method than in "GetNext" from the VirtualTrees.pas
    repeat
      // Is there a next sibling?
      if {(result <> aTree.RootNode) and} assigned(aTree.GetNextSibling(result)) then begin
        result := aTree.GetNextSibling(result);
        break
      end
      else begin
        // No sibling anymore, so use the parent's next sibling.
        if assigned(result.Parent) then
          result := result.Parent
        else begin
          // There are no further nodes to examine, hence there is no further visible node.
          result := Nil;
          break;
        end;
      end;
    until False or (result = aTree.RootNode);

    if (result = aNode) or (result = aTree.RootNode) then
      result := Nil;
  end;

begin
  currentNode := aTree.GetFirst;

  while assigned(currentNode) and (currentNode <> aTree.RootNode) do begin
    ac := aTree.GetNodeData<TAudioCollection>(currentNode);
    if (ac is TRootCollection) then
      currentNode := aTree.GetNext(currentNode)
    else begin
      if ac.Count > 0 then
        currentNode := aTree.GetNext(currentNode)
      else begin
        // currentNode contains NOT a RootCollection, and it's Count is zero => remove the Node (and all it's children)

        // 1. Get the next node we have to check
        nextNode := NextNodeNoChilds(currentNode);

        // 2. delete the current (empty) node
        aTree.DeleteNode(currentNode);
        // 3. check the next one (we may check a previous node again, but this shouldn't matter that much)
        currentNode := nextNode;
      end;
    end;
  end;
end;


function GetOldNode(ac: TAudioCollection; aTree: TVirtualStringTree): PVirtualNode; overload;
var
  currentAC: TAudioCollection;
begin
  result := aTree.GetFirst;
  currentAC := Nil;
  if not assigned(ac) then
    exit;

  if assigned(result) then
    currentAC := aTree.GetNodeData<TAudioCollection>(result);

  while assigned(result) and (currentAC <> ac) do begin
    result := aTree.GetNext(result);
    if assigned(result) then
      currentAC := aTree.GetNodeData<TAudioCollection>(result);
  end;
  if not assigned(result) then
    result := aTree.GetFirst;
end;

function GetOldNode(lc: TLibraryCategory; aTree: TVirtualStringTree): PVirtualNode; overload;
var
  currentLC: TLibraryCategory;
begin
  result := aTree.GetFirst;
  currentLC := Nil;
  if not assigned(lc) then
    exit;

  if assigned(result) then
    currentLC := aTree.GetNodeData<TLibraryCategory>(result);

  while assigned(result) and (currentLC <> lc) do begin
    result := aTree.GetNext(result);
    if assigned(result) then
      currentLC := aTree.GetNodeData<TLibraryCategory>(result);
  end;
  if not assigned(result) then
    result := aTree.GetFirst;
end;


function GetNextNodeOrFirst(aTree: TVirtualStringTree; aNode: PVirtualNode): PVirtualNode;
begin
  if not assigned(aNode) then
    result := Nil
  else begin
    if aTree.GetNodeLevel(aNode) > 0 then
      aNode := aNode.Parent;

    result := aTree.GetNextSibling(aNode); // aTree.GetNext(aNode);
    if not assigned(result) then
        result := aTree.GetFirst;
  end;
end;

function GetNodeWithAudioFile(aTree: TVirtualStringTree; aAudioFile: TAudioFile): PVirtualNode;
var aNode: PVirtualNode;
begin
    result := Nil;
    aNode := aTree.GetFirst;

    while assigned(aNode) and (Not assigned(result)) do
    begin
        if aTree.GetNodeData<TAudioFile>(aNode) = aAudioFile then
            result := aNode
        else
            aNode := aTree.GetNextSibling(aNode);
    end;
end;

function GetNodeWithCueFile(aTree: TVirtualStringTree; aRootNode: PVirtualNode; aAudioFile: TAudioFile): PVirtualNode;
var aNode: PVirtualNode;
begin
  result := Nil;
  aNode := aRootNode.FirstChild;
  while assigned(aNode) and (not assigned(result)) do
  begin
    if aTree.GetNodeData<TAudioFile>(aNode) = aAudioFile then
      result := aNode
    else
      aNode := aNode.NextSibling;
  end;
end;

function GetNodeWithIndex(aTree: TVirtualStringTree; aIndex: Cardinal; StartNode: PVirtualNode): PVirtualNode;
begin
    if assigned(StartNode) and (StartNode.Index <= aIndex) then
        result := StartNode
    else
        result := aTree.GetFirst;

    while assigned(result) and (result.Index <> aIndex) do
        result := aTree.GetNextSibling(result);
end;

function InitiateFocussedPlay(aTree: TVirtualStringTree): Boolean;
var MainNode, CueNode: PVirtualNode;
begin
    MainNode := aTree.FocusedNode;
    if not assigned(MainNode) then
    begin
          result := False;
          exit;
    end;

    NempPlaylist.UserInput;
    NempPlayer.LastUserWish := USER_WANT_PLAY;

    result := True;
    if aTree.GetNodeLevel(MainNode) = 0 then
    begin
        NempPlaylist.PlayFocussed(MainNode.Index, -1);
    end else
    begin
        CueNode := MainNode;
        MainNode := aTree.NodeParent[MainNode];
        NempPlaylist.PlayFocussed(MainNode.Index, CueNode.Index);
    end;
end;


procedure PrepareDragImage(DragDrop: TNempDragManager; aFile: TAudioFile);
var
  DragPicture: TPicture;
begin
  if assigned(aFile) then begin
    DragPicture := TPicture.Create;
    try
      DragPicture.Bitmap.Width := 80;
      DragPicture.Bitmap.Height := 80;
      TCoverArtSearcher.GetCover_Fast(aFile, DragPicture);
      DragDrop.SetDragGraphic(DragPicture)
    finally
      DragPicture.Free;
    end;
  end else
    DragDrop.SetDragGraphic(Nil);
end;

function ValidPlaylistDropNode(Source: TVirtualStringTree; Node: PVirtualNode): Boolean;
begin
  result := (assigned(Node) and (Source.GetNodeLevel(Node) = 0))
              or (not assigned(Node));
end;

procedure InitiateDragDrop(SourceTree: TVirtualStringTree; DragDrop: TNempDragManager;
  DoExecute: Boolean; SourceIsPlayer: Boolean);
var
  i: Integer;
  SelectedMp3s: TNodeArray;
begin
    DragDrop.InitDrag(SourceTree, SourceIsPlayer);
    SelectedMp3s := SourceTree.GetSortedSelection(False);
    for i := 0 to length(SelectedMp3s) - 1 do //maxC - 1 do
      DragDrop.AddFile(SourceTree.GetNodeData<TAudioFile>(SelectedMp3s[i]), True);

    if DoExecute and (DragDrop.FileNameCount > 0) then
    begin
      PrepareDragImage(DragDrop, SourceTree.GetNodeData<TAudioFile>(SelectedMp3s[0]));
      DragDrop.Execute;
    end;
end;


procedure InitiateDragDrop(Source: TAudioFileList; SourceControl: TControl; DragDrop: TNempDragManager;
  DoExecute: Boolean; SourceIsPlayer: Boolean);
var
  i: Integer;
begin
    DragDrop.InitDrag(SourceControl, SourceIsPlayer);
    for i := 0 to Source.Count - 1 do // maxC - 1 do
      DragDrop.AddFile(Source[i], True);

    if DoExecute and (DragDrop.FileNameCount > 0) then
    begin
      PrepareDragImage(DragDrop, Source[0]);
      DragDrop.Execute;
    end;
end;

function MinHintHeight(RatingHelper: TRatingHelper): Integer;
begin
  result :=  5 + CoverManagerHint.CoverSize + 3 * CoverManagerHint.VerticalMargin;
end;

procedure VSTGetCoverHintSize(Sender: TVirtualStringTree; af: TAudioFile; var R: TRect; RatingHelper: TRatingHelper);
var
  Bitmap: TBitmap;
  TM: TTextMetric;
  tmpR: TRect;
  fTextHeight, minHeight: Integer;
  HintText: String;
  DrawFormat: Cardinal;
begin
  Bitmap := TBitmap.Create;
  try
    Bitmap.Canvas.Font := Screen.HintFont;
    Bitmap.Canvas.Font.Height := MulDiv(Bitmap.Canvas.Font.Height, Sender.ScaledPixels(96), Screen.PixelsPerInch);

    GetTextMetrics(Bitmap.Canvas.Handle, TM);
    fTextHeight := TM.tmHeight;
    R := Rect(0, 0, Screen.Width, fTextHeight);
    tmpR := Rect(0, 0, Screen.Width, fTextHeight);
    DrawFormat := DT_CALCRECT or DT_TOP or DT_NOPREFIX {or DT_WORDBREAK};

    HintText := NempDisplay.HintText1(af);
    Winapi.Windows.DrawText(Bitmap.Canvas.Handle, PWideChar(HintText), Length(HintText), R, DrawFormat);

    HintText := NempDisplay.HintText2(af);
    if HintText <> '' then begin
      Winapi.Windows.DrawText(Bitmap.Canvas.Handle, PWideChar(HintText), Length(HintText), tmpR, DrawFormat);
      R.Height := R.Height + fTextHeight Div 2 + tmpR.Height;
      R.Width := max(R.Width, tmpR.Width);
    end;

    R.Width := R.Width + CoverManagerHint.CoverSize + 4 * CoverManagerHint.HorizontalMargin;
    if R.Width > 1000 then
      R.Width := 1000;

    if R.Width < 250 then
      R.Width := 250;

    // Height for Rating and PlayCounter
    if af.AudioType in [at_File, at_Cue] then
      R.Height := R.Height + 2 * RatingHelper.fSetStar.Height + 1 * CoverManagerHint.VerticalMargin + TM.tmHeight Div 2;

    minHeight := MinHintHeight(RatingHelper);
    if R.Height <  minHeight then
      R.Height := minHeight;

  finally
    Bitmap.Free;
  end;
end;

{
  VSTDrawCoverHint: Draw the AudioFile Information on the Canvas of the generated Hint Window.
  Several things copied from the VST code
}
procedure VSTDrawCoverHint(Sender: TVirtualStringTree; HintCanvas: TCanvas; af: TAudioFile; R: TRect; RatingHelper: TRatingHelper);
var
  HintText: String;
  rating: Integer;
  success, VclStyleEnabled: Boolean;

  StyleServices: TCustomStyleServices;

  DrawFormat: Cardinal;
  LColor: TColor;
  LDetails: TThemedElementDetails;
  LGradientStart: TColor;
  LGradientEnd: TColor;
  LClipRect, tmpRect, txtRect: TRect;

  TM: TTextMetric;
begin
    HintText := NempDisplay.HintText(af);
    VclStyleEnabled := Nemp_MainForm.NempSkin.isActive and Nemp_MainForm.NempSkin.UseAdvancedSkin and NempOptions.GlobalUseAdvancedSkin;
    with HintCanvas do begin
        StyleServices := Vcl.Themes.StyleServices{$if CompilerVersion >= 34}(Sender){$ifend};
        if VclStyleEnabled then begin

          InflateRect(R, -1, -1); // Fixes missing border when VCL styles are used
          LDetails := StyleServices.GetElementDetails(thHintNormal);
          if StyleServices.GetElementColor(LDetails, ecGradientColor1, LColor) and (LColor <> clNone) then
            LGradientStart := LColor
          else
            LGradientStart := clInfoBk;
          if StyleServices.GetElementColor(LDetails, ecGradientColor2, LColor) and (LColor <> clNone) then
            LGradientEnd := LColor
          else
            LGradientEnd := clInfoBk;
          if StyleServices.GetElementColor(LDetails, ecTextColor, LColor) and (LColor <> clNone) then
            Font.Color := LColor
          else
            Font.Color := Screen.HintFont.Color;
          GradientFillCanvas(HintCanvas, LGradientStart, LGradientEnd, R, gdVertical);
        end
        else
        begin
          // Still force tooltip back and text color.
          Font.Color := clInfoText;
          Pen.Color := clBlack;
          Brush.Color := clInfoBk;
          if IsWinVistaOrAbove and StyleServices.Enabled and ((toThemeAware in Sender.TreeOptions.PaintOptions) or
             (toUseExplorerTheme in Sender.TreeOptions.PaintOptions)) then
          begin
            if toUseExplorerTheme in Sender.TreeOptions.PaintOptions then // ToolTip style
              StyleServices.DrawElement(HintCanvas.Handle, StyleServices.GetElementDetails(tttStandardNormal), R {$IF CompilerVersion >= 34}, nil, Sender.CurrentPPI{$IFEND})
            else
              begin // Hint style
                LClipRect := R;
                InflateRect(R, 4, 4);
                StyleServices.DrawElement(Handle, StyleServices.GetElementDetails(tttStandardNormal), R, @LClipRect{$IF CompilerVersion >= 34}, Sender.CurrentPPI{$IFEND});
                R := LClipRect;
                StyleServices.DrawEdge(Handle, StyleServices.GetElementDetails(twWindowRoot), R, [eeRaisedOuter], [efRect]);
              end;
          end
          else
            if VclStyleEnabled then
              StyleServices.DrawElement(Handle, StyleServices.GetElementDetails(tttStandardNormal), R {$IF CompilerVersion >= 34}, nil, Sender.CurrentPPI{$IFEND})
            else
              Rectangle(R);
        end;
        // Determine text position and don't forget the border.
        InflateRect(R, -1, -1);
        DrawFormat := DT_TOP or DT_NOPREFIX or DT_WORD_ELLIPSIS;
        SetBkMode(HintCanvas.Handle, Winapi.Windows.TRANSPARENT);

        GetTextMetrics(HintCanvas.Handle, TM);
        tmpRect := R;
        tmpRect.Top := tmpRect.Top + 1;
        tmpRect.Left := tmpRect.Left + CoverManagerHint.CoverSize + 2*CoverManagerHint.HorizontalMargin;
        txtRect := tmpRect;
        tmpRect.Height := TM.tmHeight;
        HintCanvas.Pen.Color := HintCanvas.Font.Color;
        HintCanvas.Pen.Width := 1;

        // Draw first part of the Hint information: Artist, Title, Album, Year
        HintText := NempDisplay.HintText1(af);
        Winapi.Windows.DrawText(HintCanvas.Handle, PWideChar(HintText), Length(HintText), txtRect, DrawFormat);
        Winapi.Windows.DrawText(HintCanvas.Handle, PWideChar(HintText), Length(HintText), tmpRect, DT_CALCRECT or DrawFormat);
        txtRect.Top := txtRect.Top + tmpRect.Height;
        tmpRect.Height := TM.tmHeight;

        // Draw Cover (use Parent AudioFile for CueSheets)
        case af.AudioType of
          at_Undef: ;
          at_File,
          at_CDDA: HintCanvas.Draw(5, 5, CoverManagerHint.GetCachedCover(af.CoverID, success).Graphic);
          at_Stream: HintCanvas.Draw(5, 5, CoverManagerHint.GetCachedCover(cWebGenericWebRadioID, success).Graphic);
          at_CUE: begin
              if assigned(af.Parent) then
                HintCanvas.Draw(5, 5, CoverManagerHint.GetCachedCover(af.Parent.CoverID, success).Graphic)
              else
                HintCanvas.Draw(5, 5, CoverManagerHint.GetCachedCover(af.CoverID, success).Graphic)
          end;
        end;

        // Draw Rating and Playcounter, but only for Files and Cues
        if af.AudioType in [at_File, at_Cue] then begin
          rating := af.Rating;
          if rating = 0 then
            rating := 127;
          // Rating
          RatingHelper.DrawRatingInStars(rating, HintCanvas, RatingHelper.fSetStar.Height,
              txtRect.Left, txtRect.Top);
          // Play-Icon
          HintCanvas.Draw(txtRect.Left,
            txtRect.Top + RatingHelper.fSetStar.Height + 1 * CoverManagerHint.VerticalMargin,
            RatingHelper.fCountIcon);
          // actual counter
          HintCanvas.TextOut(
                txtRect.Left + RatingHelper.fCountIcon.Width + 2*CoverManagerHint.VerticalMargin,
                txtRect.Top + RatingHelper.fSetStar.Height + 1 * CoverManagerHint.VerticalMargin,
                NempDisplay.HintLinePlayCounter(af));
          txtRect.Top := txtRect.Top + RatingHelper.fSetStar.Height + RatingHelper.fCountIcon.Height + 2*CoverManagerHint.VerticalMargin;
        end;

        // Draw horizontal line
        HintCanvas.MoveTo(txtRect.Left, txtRect.Top  + TM.tmHeight Div 4);
        HintCanvas.LineTo(txtRect.Left + txtRect.Width - 10, txtRect.Top + TM.tmHeight Div 4);
        txtRect.Top := txtRect.Top + TM.tmHeight Div 2;

        // Draw second part of the Hint data: Quality, Duration, Size
        HintText := NempDisplay.HintText2(af);
        Winapi.Windows.DrawText(HintCanvas.Handle, PWideChar(HintText), Length(HintText), txtRect, DrawFormat);
        Winapi.Windows.DrawText(HintCanvas.Handle, PWideChar(HintText), Length(HintText), tmpRect, DT_CALCRECT or DrawFormat);
        // txtRect.Top := txtRect.Top + tmpRect.Height + TM.tmHeight Div 2;
        // tmpRect.Height := TM.tmHeight;
    end;
end;


end.
