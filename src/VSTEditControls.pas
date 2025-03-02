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
  VirtualTrees, messages, StdCtrls, ExtCtrls, Vcl.ImgList,
  SkinButtons;

type


  // TRatingEditLink
  // A Edit-Class for the VST.
  // Control is a TRatingButton.
  TRatingEditLink = class(TInterfacedObject, IVTEditLink)
  private
    FEdit: TRatingButton;
    FTree: TVirtualStringTree;
    FNode: PVirtualNode;
    FColumn: Integer;

    fImages: TCustomImageList;
    fBackGroundImage: TBitmap;
    fFullStarIndex: Integer;
    fHalfStarIndex: Integer;
    fEmptyStarIndex: Integer;

    procedure RatingClick(Sender: TObject);
    procedure RatingKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure RatingChanged(Sender: TRatingButton; aRating: Integer);
  protected

  public
    property Images: TCustomImageList read fImages write fImages;
    property StarFullImageIndex : Integer    read fFullStarIndex  write fFullStarIndex ;
    property StarHalfImageIndex : Integer    read fHalfStarIndex  write fHalfStarIndex ;
    property StarEmptyImageIndex: Integer    read fEmptyStarIndex write fEmptyStarIndex;

    constructor Create; //override;
    destructor Destroy; override;
    procedure CopyCustomBackGround(Source: TCanvas; aRect: TRect);

    function BeginEdit: Boolean; virtual; stdcall;
    function CancelEdit: Boolean; virtual; stdcall;
    function EndEdit: Boolean; virtual; stdcall;
    function GetBounds: TRect; virtual; stdcall;
    function PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex): Boolean; stdcall;
    procedure ProcessMessage(var Message: TMessage); virtual; stdcall;
    procedure SetBounds(R: TRect); stdcall;
  end;


implementation

uses NempAudioFiles, NempMainUnit, math;

{
    --------------------------------------------------------
    TRatingEditLink
    See VST Tutorials, Demos, whatever for Details.
    --------------------------------------------------------
}

constructor TRatingEditLink.Create;
begin
  inherited;
  fBackGroundImage := TBitmap.Create;
end;

destructor TRatingEditLink.Destroy;
begin
  fBackGroundImage.Free;
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

procedure TRatingEditLink.CopyCustomBackGround(Source: TCanvas; aRect: TRect);
begin
  // Width, +1: We need one more pixel, mybe because of the splitter (?)
  fBackGroundImage.Width := aRect.Right - aRect.Left + 1;
  fBackGroundImage.Height := aRect.Bottom - aRect.Top;
  bitblt(fBackGroundImage.Canvas.Handle,
       0,0, fBackGroundImage.Width, fBackGroundImage.Height,
       Source.Handle,
       aRect.Left, aRect.Top, SRCCOPY );
end;


function TRatingEditLink.PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex): Boolean;
var
  af: tAudioFile;
begin
  Result := True;
  FTree := Tree as TVirtualStringTree;
  FNode := Node;
  FColumn := Column;

  FEdit.Free;
  FEdit := nil;
  FEdit := TRatingButton.Create(Nil);

  fEdit.OnClick := RatingClick;              // Set new value
  fEdit.OnKeyDown := RatingKeyDown;          // cancel on ESC
  FEdit.OnRatingChanged := RatingChanged;

  FEdit.StyleElements := [seFont,seBorder];
  FEdit.TransparentBackground := False;
  FEdit.CustomBackground := fBackGroundImage;
  FEdit.Images := Images;
  FEdit.StarFullImageIndex := StarFullImageIndex;
  FEdit.StarHalfImageIndex := StarHalfImageIndex;
  FEdit.StarEmptyImageIndex := StarEmptyImageIndex;
  FEdit.Alignment := taLeftJustify;
  FEdit.WantArrowButtons := True;
  FEdit.Visible := False;
  FEdit.Parent := FTree;

  af := FTree.GetNodeData<TAudioFile>(FNode);
  if assigned(af) then
    FEdit.Rating := af.Rating
  else
    FEdit.Rating := 0;
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
      af.Rating := FEdit.Rating;
  end;
  FTree.InvalidateNode(FNode);
  try
    FTree.SetFocus;
  except
  end;
end;

procedure TRatingEditLink.RatingChanged(Sender: TRatingButton;
  aRating: Integer);
begin
  EndEdit;
  FTree.EndEditNode;
end;

procedure TRatingEditLink.RatingClick(Sender: TObject);
begin
  EndEdit;
  FTree.EndEditNode;
end;

procedure TRatingEditLink.RatingKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case key of
    vk_Escape: begin
        CancelEdit;
        FTree.CancelEditNode;
    end;
    vk_Return: begin
        EndEdit;
        FTree.EndEditNode;
    end;
    49, 97: FEdit.Rating := 1*50;   // 1
    50, 98: FEdit.Rating := 2*50;   // 2
    51, 99: FEdit.Rating := 3*50;   // 3
    52, 100: FEdit.Rating := 4*50;  // 4
    53, 101: FEdit.Rating := 5*50;  // 5
    187, 107, vk_right: FEdit.Rating := min(255, FEdit.Rating + 25);  // +
    189, 109, vk_left:  FEdit.Rating := max(1, FEdit.Rating - 25);   // -
  end;
end;

End.
