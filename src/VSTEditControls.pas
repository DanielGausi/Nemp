{

    Unit VSTEditControls

    Editors for the main VirtualStringTree
       - TModStringEditLink
         A modified Edit. The original one has some problems with
         small Nodeheights and Textcursor.
       - TRatingEditLink
         Editor for Ratings. Edit-Control is a TRatingControl
       - TRatingControl
         Descendant of TCustomControl. Draws little stars in OnPaint.
       - TRatingGraphics
         Small class with Background-Graphic, and 3 star-Bitmaps.
         Used by TRatingControl for Drawing.


    Note: Big parts of this Unit are taken from
          http://wiki.freepascal.org/VirtualTreeview_Example_for_Lazarus



          Temporary comment ???
          Got some AccessViolations in "GetRealParentForm" here.
          I changed, and it worked, where it doesnt all the time before. More testing needed.

          function TBaseVirtualTree.DoEndEdit: Boolean;
          begin
            StopTimer(EditTimer);
            Result := (tsEditing in FStates) and FEditLink.EndEdit;
            if Result then
            begin
              DoStateChange([], [tsEditing]);
              //FEditLink := nil;             // not here
              if Assigned(FOnEdited) then
                FOnEdited(Self, FFocusedNode, FEditColumn);
              FEditLink := nil;               // but here !!!
            end;
            DoStateChange([], [tsEditPending]);
          end;


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


unit VSTEditControls;


interface

uses
  windows, Classes, SysUtils, Forms, Controls, Graphics,
  VirtualTrees, messages, StdCtrls, ExtCtrls, RatingCtrls;

type

  // TRatingGraphics
  // The SetBackGround-method is called by VSTCreateEditor,
  // the SetStars (method of TRatingHelper) by the Nemp SkinSystem
  TRatingGraphics = class (TRatingHelper)
  private
      fRatingControlBackGround: TBitmap;
      fComplete: TBitmap;
  public
      Constructor Create;
      Destructor Destroy; Override;
      procedure SetBackGround(aCanvas: TCanvas; aRect: TRect);
      procedure DrawBackGround(aCanvas: tCanvas);
  end;


  // TRatingControl
  // A little new control component
  // Just a Canvas with a predefined Paint-Method, which draws the right amount
  // of Set/Unset stars. For saving this number, the Tag of TControl is used.
  TRatingControl = class(TCustomControl)
  protected
      procedure Paint; override;
  end;


  // TRatingEditLink
  // A Edit-Class for the VST.
  // Control is a TRatingControl. In OnMouseMove the Tag (e.g. Rating)
  // is set, in OnMouseLeave the Editing is cancelled, in OnClick it ends.
  TRatingEditLink = class(TInterfacedObject, IVTEditLink)
  private
    FEdit: TRatingControl; //TWinControl;        // TRatingControl here
    FTree: TVirtualStringTree;
    FNode: PVirtualNode;
    FColumn: Integer;
    fLastPaint: Cardinal;
    fOriginalRating: Byte;
    procedure RatingMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure RatingMouseLeave(Sender: TObject);
    procedure RatingClick(Sender: TObject);
    procedure RatingKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  protected
    //procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  public
    destructor Destroy; override;
    function BeginEdit: Boolean; virtual; stdcall;
    function CancelEdit: Boolean; virtual; stdcall;
    function EndEdit: Boolean; virtual; stdcall;
    function GetBounds: TRect; virtual; stdcall;
    function PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex): Boolean; stdcall;
    procedure ProcessMessage(var Message: TMessage); virtual; stdcall;
    procedure SetBounds(R: TRect); stdcall;
  end;


  // TModStringEditLink
  // A slightly modified version of the original TStringEditLink
  // defined within the VST-pack.
  // The original Editor sets the Height of the Edit to the NodeHeight of
  // the tree. That seems to be a good idea, but we have often to small
  // values for the height, which causes some annoying stuff, like a missing
  // text-cursor (this blinking "|" thingy)
(*  TModStringEditLink = class(TInterfacedObject, IVTEditLink)
  private
    FEdit: TWinControl;
    FTree: TVirtualStringTree;
    FNode: PVirtualNode;
    FColumn: Integer;
  protected
    procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  public
    destructor Destroy; override;
    function BeginEdit: Boolean; stdcall;
    function CancelEdit: Boolean; stdcall;
    function EndEdit: Boolean; stdcall;
    function GetBounds: TRect; stdcall;
    function PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex): Boolean; stdcall;
    procedure ProcessMessage(var Message: TMessage); stdcall;
    procedure SetBounds(R: TRect); stdcall;
  end;
*)
   { TODO : Combobox-Editor zur Genre-Bearbeitung }


var RatingGraphics: TRatingGraphics ;
    PlayerRatingGraphics: TRatingGraphics;

    TestTimerID: Cardinal;


implementation

uses NempAudioFiles, NempMainUnit;//, NempMainUnit, mmSystem;

{
    --------------------------------------------------------
    TRatingGraphics, Basics
    - Create/Free the Bitmaps.
    --------------------------------------------------------
}
constructor TRatingGraphics.Create;
begin
    inherited;
    fRatingControlBackGround := TBitmap.Create;
    fComplete := TBitmap.Create;
end;
destructor TRatingGraphics.Destroy;
begin
    fRatingControlBackGround.Free;
    fComplete.Free;
    inherited;
end;
procedure TRatingGraphics.DrawBackGround(aCanvas: tCanvas);
begin
    aCanvas.Draw(0, 0, fRatingControlBackGround);
end;

{
    --------------------------------------------------------
    TRatingGraphics, SetBackGround
    - Set the Background of the Control.
      Copy it from the Tree
    --------------------------------------------------------
}
procedure TRatingGraphics.SetBackGround(aCanvas: TCanvas;
  aRect: TRect);
begin
    // Width, +1: We need one more pixel, mybe because of the splitter (?)
    fRatingControlBackGround.Width := aRect.Right - aRect.Left + 1;
    fRatingControlBackGround.Height := aRect.Bottom - aRect.Top;
    bitblt(fRatingControlBackGround.Canvas.Handle,
         0,0, fRatingControlBackGround.Width, fRatingControlBackGround.Height,
         aCanvas.Handle,
         aRect.Left, aRect.Top, SRCCOPY );
    fComplete.Width := aRect.Right - aRect.Left + 1;
    fComplete.Height := aRect.Bottom - aRect.Top;
    bitblt(fComplete.Canvas.Handle,
         0,0, fComplete.Width, fComplete.Height,
         aCanvas.Handle,
         aRect.Left, aRect.Top, SRCCOPY);
end;

{
    --------------------------------------------------------
    TRatingControl, Paint
    - Use the graphics of the TRatingGraphics-Class to draw the stars
    --------------------------------------------------------
}
procedure TRatingControl.Paint;
begin

  // Draw Background
  RatingGraphics.fComplete.Canvas.Draw(0, 0, RatingGraphics.fRatingControlBackGround);
  // Draw Stars
  RatingGraphics.DrawRatingInStars(tag, RatingGraphics.fComplete.Canvas, RatingGraphics.fComplete.height);
  // Copy to Control
  bitblt(Canvas.Handle, 0, 0,
            RatingGraphics.fComplete.Width, RatingGraphics.fComplete.Height,
            RatingGraphics.fComplete.Canvas.Handle, 0, 0, SRCCOPY);
end;


{
    --------------------------------------------------------
    TRatingEditLink
    See VST Tutorials, Demos, whatever for Details.
    --------------------------------------------------------
}
destructor TRatingEditLink.Destroy;
begin
  FEdit.Free;
  inherited;
end;

function TRatingEditLink.GetBounds: TRect;
begin
  Result := FEdit.BoundsRect;
end;

procedure TRatingEditLink.SetBounds(R: TRect);
var
  Dummy: Integer;
begin
  FTree.Header.Columns.GetColumnBounds(FColumn, Dummy, R.Right);
  FEdit.BoundsRect := R;
end;

procedure TRatingEditLink.ProcessMessage(var Message: TMessage);
begin
    if Assigned(FEdit) then
       FEdit.WindowProc(Message);
end;

function TRatingEditLink.PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex): Boolean;
var af: tAudioFile;
begin
  Result := True;
  FTree := Tree as TVirtualStringTree;
  FNode := Node;
  FColumn := Column;
  fLastPaint := 0;

  af := FTree.GetNodeData<TAudioFile>(FNode);
  if assigned(af) then
  begin
      fOriginalRating := af.Rating;
  end else
      fOriginalRating := 0;

  FEdit.Free;
  FEdit := nil;
  FEdit := TRatingControl.Create(nil);
  with FEdit as TRatingControl do
  begin
      // Set Mouse-Events for the Control
      OnMouseMove := RatingMouseMove;      // Change Rating
      OnMouseLeave := RatingMouseLeave;    // Cancel Edit
      OnClick := RatingClick;              // Set new value
      OnKeyDown := RatingKeyDown;          // cancel on ESC
      Visible := False;
      Parent := FTree;
      Tag := fOriginalRating;
  end;
end;

function TRatingEditLink.BeginEdit: Boolean;
begin
  Result := True;
  FEdit.Show;
  FEdit.SetFocus;
end;

function TRatingEditLink.CancelEdit: Boolean;
begin
  Result := True;
  //FEdit.Hide;

  try
      FTree.SetFocus;
  except
  end;
end;

function TRatingEditLink.EndEdit: Boolean;
var af: tAudioFile;
begin
  Result := True;
  // Get the Audiofile
  af := FTree.GetNodeData<TAudioFile>(FNode);
  if assigned(af) then
  begin
      // Set the rating
      // Note to self: This should be ok and Threadsafe.
      // If something goes wrong, the user will probably notice that directly
      // and think "wtf? Misclicked."
      // The only possible situation: PostProcessor wants to set the rating just in this moment
      af.Rating := FEdit.Tag;
  end;
  FTree.InvalidateNode(FNode);
  try
    FTree.SetFocus;
  except
  end;
end;

procedure TRatingEditLink.RatingMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var c: Cardinal;
  begin
    FEdit.Tag := RatingGraphics.MousePosToRating(X, 70);

    c := GetTickCount;
    if c - self.fLastPaint > 50 then
    begin
        // Repaint the Control
        (FEdit as TRatingControl).Repaint;
        fLastPaint := GetTickCount;
    end;
end;

procedure TRatingEditLink.RatingClick(Sender: TObject);
begin
    EndEdit;
    FTree.EndEditNode;
end;

procedure TRatingEditLink.RatingKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var tmp: Integer;
begin
    case key of
        vk_Escape: begin
            CancelEdit;
            FTree.CancelEditNode;
        end;

        49,97: begin  // 1
            FEdit.Tag := 1*50;
            (FEdit as TRatingControl).Repaint;
        end;

        50,98: begin  // 2
            FEdit.Tag := 2*50;
            (FEdit as TRatingControl).Repaint;
        end;
        51,99: begin  // 3
            FEdit.Tag := 3*50;
            (FEdit as TRatingControl).Repaint;
        end;
        52,100: begin  // 4
            FEdit.Tag := 4*50;
            (FEdit as TRatingControl).Repaint;
        end;
        53,101: begin // 5
            FEdit.Tag := 5*50;
            (FEdit as TRatingControl).Repaint;
        end;

        187, 107: begin  // +
            tmp := FEdit.Tag + 25;
            if tmp > 255 then
                tmp := 255;
            FEdit.Tag := tmp;
            (FEdit as TRatingControl).Repaint;
        end;

        189,109: begin // -
            tmp := FEdit.Tag - 25;
            if tmp < 1 then
                tmp := 1;
            FEdit.Tag := tmp;
            (FEdit as TRatingControl).Repaint;
        end;

        vk_Return: begin
            EndEdit;
            FTree.EndEditNode;
        end;
    else
      ;
    end;
end;


procedure TRatingEditLink.RatingMouseLeave(Sender: TObject);
begin
    // Set Original Rating
    FEdit.Tag := fOriginalRating;
    (FEdit as TRatingControl).Repaint;
end;



initialization

    RatingGraphics := TRatingGraphics.Create;
    PlayerRatingGraphics := TRatingGraphics.Create;

finalization

    RatingGraphics.Free;
    PlayerRatingGraphics.Free;

End.
