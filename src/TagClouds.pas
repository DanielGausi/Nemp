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

uses windows, classes, SysUtils, Controls, Contnrs, NempAudioFiles, Math, stdCtrls,
    ComCtrls, Graphics, Messages, NempPanel, IniFiles, dialogs, StrUtils, System.Types;

const

    BORDER_WIDTH = 4;
    BORDER_HEIGHT = 1;

    BREADCRUMB_GAP = 5;

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

  TTagLine = class; // forward declaration

  // a single Tag on a Paintbox
  TPaintTag = class(TTag)
      private
          fLeft: Integer;    // left-position in a Tag-Line
          fTop: Integer;
          fWidth: Integer;
          fHeight: Integer;
          FontSize: Integer;

          fHover: Boolean;
          fFocussed: Boolean;

          fLine: TTagLine;

          procedure PaintNormal(aCanvas: TCanvas);
          procedure PaintHover(aCanvas: TCanvas);
          procedure PaintFocussed(aCanvas: TCanvas);

          procedure Erase(aCanvas: TCanvas; Blend:Boolean);


      public
          property Width: Integer read fWidth;
          property Height: Integer read fheight;

          constructor Create(aKey: String; aTranslate: Boolean);

          procedure MeasureOutput(aCanvas: TCanvas);
          procedure Paint(aCanvas: TCanvas);



  end;

  // a Line of Tags in a Paintbox
  TTagLine = class
      private
          fGap: Integer;   // the needed gap between two tags for justification (Blocksatz)
          fCanvasWidth: Integer;

          fWidth: Integer;
          fHeight: Integer;

          function fGetBreadCrumbline: Boolean;

      public
          Tags: TObjectList;     // the Tags in this line

          Top: Integer;
          property Width: Integer read fWidth;      // the width (of all Tags together)
          property Height: Integer read fheight;    // the Height (of the biggest Tag)
          property BreadCrumbline: Boolean read fGetBreadCrumbline;

          constructor Create(CanvasWidth: Integer);
          destructor Destroy; override;
          procedure Paint(aCanvas: TCanvas);
  end;

  TCloudPainter = class
      private
          fWidth: Integer;
          fHeight: Integer;

          lastFontChangeAt: Integer;
          currentFontSize: Integer;
          visibleTags: TObjectList;

          // used do determine the forced LineBreak between Breadcrumb-tags
          // and "new" tags
          fForcedBreakDone: Boolean;

          function GetProperFontSize(aTag: TPaintTag):Integer;

          function GetMaxCount(Source: TObjectList): Integer;

          function ForceLineBreak(currentTag: TPaintTag): Boolean;
          // first Stage: Choose as many tags as possible from
          // the Count-Sorted Source
          // Line-Object not needed
          procedure RawPaint1(Source: TObjectList);

          // second Stage: Paint tags String-Sorted
          // use source for additional tags, if new painting requires less space
          // create Line-Objects
          procedure RawPaint2(Source: TObjectList);

          procedure DoPaint;

          procedure SetHeight(Value: Integer);
          procedure SetWidth(Value: Integer);

      public
          TagLines: TObjectList;
          Tags: TObjectList;

          maxCount: Integer;


          Canvas: TCanvas;
          property Width: Integer read fWidth write SetWidth;
          property Height: Integer read fHeight write SetHeight;

          constructor Create;
          destructor Destroy; override;


          procedure Paint(Source: TObjectList);

          procedure PaintAgain;

          procedure RePaintTag(aTag: TPaintTag; Active: Boolean);

          // Determine, whether a given Tag is visible tight now
          function IsVisible(aTag: TPaintTag): Boolean;

          function GetTagAtMousePos(x,y: Integer): TPaintTag;

          function GetFirstNewTag: TPaintTag;

  end;


  TTagCloud = class
      private
          // the main list with all Tags in the Cloud.
          Tags: TObjectList;
          ActiveTags: TObjectList;

          // fBackUpBreadCrumbs: Used to restore the Navigation after a
          // library update.
          fBackUpBreadCrumbs: TObjectlist;
          fBackupFocussedTag: TPaintTag;

          HashedTags: Array[0..1023] of TObjectList;

          fClearTag: TTag;

          fInitialising: Boolean;
          fBreadCrumbDepth: Integer;

          fMouseOverTag: TPaintTag;
          fFocussedTag: TPaintTag;

          fLastKeypressTick: Int64;           // TickCount when the last keypress occured
          fSearchString: String;

          procedure SetMouseOverTag(Value: TPaintTag);
          procedure SetFocussedTag(Value: TPaintTag);

          procedure ClearBreadCrumbs(Above: Integer);

          // Get a TTag-Object with a matching key
          function GetTag(aKey: String): TTag;

          function fGetTagList: TObjectList;

          procedure InitHashMap;

          // Insert all Tags from the AudioFile into the Taglist
          procedure AddAudioFileTags(aAudioFile: TAudioFile);

          // Generate a TagList from RawTag-Strings of the Audiofile.
          procedure AddAudioFileRAWTags(aAudioFile: TAudioFile; InsertInBreadcrumbs: Boolean=False);

          // Set Default-RawTags (like genre, artist, year)
          procedure GenerateAutoRawTags(aAudioFile: TAudioFile; Dest: TStringList);

          //
          procedure SetActivetags;

          function GetOverLap(TagA, TagB: TPaintTag): Integer;

          function GetDefaultTag: TPainttag;

          function GetLeftTag: TPaintTag;
          function GetRightTag: TPaintTag;
          function GetUpTag: TPaintTag;
          function GetDownTag: TPaintTag;

          function GetFirstTag: TPaintTag;
          function GetLastTag: TPaintTag;
          function GetFirstTagOfLine: TPaintTag;
          function GetLastTagOfLine: TPaintTag;

          function GetTopTag: TPaintTag;
          function GetBottomTag: TPaintTag;

          function GetNextMatchingTag(aKey: Word; f3pressed: Boolean): TPaintTag;
          function GetNextMatchingTagInLine(aLine: TTagLine; Offset: Integer): TPaintTag;


      public

          CloudPainter: TCloudPainter;

          property MouseOverTag: TPaintTag read fMouseOverTag write SetMouseOverTag;
          property FocussedTag: TPaintTag read fFocussedTag write SetFocussedTag;
          property CurrentTagList: TObjectList read fGetTagList;
          property ClearTag: TTag read fCleartag;

          constructor Create;
          destructor Destroy; override;

          procedure LoadFromIni(Ini: TMemIniFile);
          procedure SaveToIni(Ini: TMemIniFile);

          // Build a Tag-Cloud for the AudioFiles given in Source
          procedure BuildCloud(Source: TAudioFileList; aTag: TTag; FromScratch: Boolean);

          procedure GetTopTags(ResultCount: Integer; Offset: Integer; BibSource: TAudioFileList; Target: TObjectList; HideAutoTags: Boolean = False);

          // Show the Tags in the Cloud
          procedure ShowTags(Refocus: Boolean);

          // Backup/RestoreNavigation: Save the current Breadcrumbs and restore them after
          // a rebuild of the cloud (~RemarkOldNodes in Classic browsing)
          procedure BackUpNavigation;
          procedure RestoreNavigation(aList: TAudioFileList);
          procedure NavigateCloud(aKey: Word; Shift: TShiftState);

          // Add a file to the TagCloud
          procedure AddAudioFile(aAudioFile: TAudioFile);

          // Delete a File from the Cloud
          procedure DeleteAudioFile(aAudioFile: TAudioFile);

          // Update a File (change the Tags) in the Cloud
          procedure UpdateAudioFile(aAudioFile: TAudioFile);

          // Rename a Tag
          //procedure RenameTag(oldTag: TTag; NewKey: String);

          // Delete a Tag
          // (this will not destroy the TTag-Object, just clear the audiofiles)
          //procedure DeleteTag(aTag: TTag);

          // Reset the Tag to zero, i.e. Clear the Tag.AudioFileList
          procedure Reset;

          procedure _SaveTagsToFile(aFile: String);

          // Copy all Tags from self.Tags to Target
          // used for TagEditor
          // Note: Only references are copied, not the Tag-Objects themself!
          procedure CopyTags(Target: TObjectList; HideAutotags: Boolean; MinCount: Integer);

  end;

  TCloudViewer = class(TNempPanel)
  protected
      procedure CMWantspecialKey(var Msg : TWMKey); message CM_WANTSpecialKey;

  published
      property OnKeypress;
      property OnKeyDown;

  end;


{  TCloudViewer = class(TCustomControl)
  private
      FOnPaint: TNotifyEvent;

      procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
      procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
  protected
      procedure CMWantspecialKey(var Msg : TWMKey); message CM_WANTSpecialKey;

  published
      property OnEnter;
      property OnClick;
      property OnMouseDown;
      property OnMouseMove;
      property OnKeypress;
      property Canvas;
      property OnKeyDown;
      property OnResize;

      property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;
//      property OnPaint;
  end;


 }

function Sort_Count(item1,item2:pointer):integer;
function Sort_Name(item1,item2:pointer):integer;

function Sort_Count_DESC(item1,item2:pointer):integer;
function Sort_Name_DESC(item1,item2:pointer):integer;

function Sort_TotalCount(item1,item2:pointer):integer;

var
    TagCustomizer: TTagCustomizer;

implementation

uses NempMainUnit, Nemp_RessourceStrings, gnuGetText;


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


{ TTagCloud }



constructor TTagCloud.Create;
begin
    fInitialising := True;
    Tags := TObjectList.Create;
    ActiveTags := TObjectList.create(False);
//    BrowseHistory := TObjectList.Create;
    CloudPainter := TCloudPainter.Create;
    fBackUpBreadCrumbs := TObjectList.create(False);

    fClearTag := TPaintTag.Create('Your media library', True);
    //TPaintTag.Create(TagCloud_YourLibrary, True);  // this does not work properly ...


    fClearTag.BreadCrumbIndex := -2;
    Tags.Add(ClearTag);

    fSearchString := '';
    fLastKeypressTick := GetTickCount;

    InitHashMap;
end;

destructor TTagCloud.Destroy;
var i: Integer;
begin
    if assigned(HashedTags[0]) then
    begin
        for i := 0 to 1023 do
            Hashedtags[i].Free;
    end;
//    BrowseHistory.Free;
    CloudPainter.Free;
    Activetags.Free;
    fBackUpBreadCrumbs.Free;
    Tags.Extract(fClearTag);
    fCleartag.Free;
    Tags.free;

    inherited;
end;

procedure TTagCloud.LoadFromIni(Ini: TMemIniFile);
var NavDepth, i: Integer;
    aTagString: String;
    newTag: TTag;
begin
    NavDepth := Ini.ReadInteger('MedienBib', 'TagCloudNavDepth', 0);
    if NavDepth > 0 then
    begin
        fBackUpBreadCrumbs.Add(ClearTag);

        for i := 1 to NavDepth - 1 do
        begin
            aTagString := Ini.ReadString('MedienBib', 'TagCloudNav' + IntToStr(i), '');
            if aTagString <> '' then
            begin
                // on Nemp Start, we have probably no Tags yet.
                // But it doesnt matter, if we create some of them right now
                newTag := GetTag(aTagString);
                // use these new Tags as BackupBreadCrumbs
                // when we Refill the cloud after loading the library, this should work!
                fBackUpBreadCrumbs.Add(newTag);
            end;
        end;
        // get the backupped focussed Tag
        aTagString := Ini.ReadString('MedienBib', 'TagCloudNavFocus' , '');
        if aTagString <> '' then
            fBackupFocussedTag := TPaintTag(GetTag(aTagString))
        else
            fBackupFocussedTag := Nil;
    end;
end;

procedure TTagCloud.SaveToIni(Ini: TMemIniFile);
var i, NavDepth: Integer;
    goOn: Boolean;
begin
    NavDepth := 0;

    // Get the number of breadcrumb-tags
    for i := 0 to Tags.Count - 1 do
        if (Tags[i] as TTag).BreadCrumbIndex < High(Integer) then
            inc(NavDepth)
        else
            break;
    // write this number
    Ini.WriteInteger('MedienBib', 'TagCloudNavDepth', NavDepth);
    // write the keys of the breadcrumbtags
    for i := 1 to NavDepth - 1 do
        Ini.WriteString('MedienBib', 'TagCloudNav' + IntToStr(i), (Tags[i] as TTag).Key);

    // Delete further keys from Ini
    i := NavDepth;
    repeat
        Ini.DeleteKey('MedienBib', 'TagCloudNav' + IntToStr(i));
        inc(i);
        goOn := Ini.ValueExists('MedienBib', 'TagCloudNav' + IntToStr(i));
    until not GoOn;

    // write the key of the focussed tag
    if assigned(fFocussedTag) then
        Ini.WriteString('MedienBib', 'TagCloudNavFocus', fFocussedTag.Key)
    else
        Ini.DeleteKey('MedienBib', 'TagCloudNavFocus');
end;


function TTagCloud.fGetTagList: TObjectList;
begin
   result := Activetags;
end;


procedure TTagCloud.Reset;
var i: Integer;
begin
    // Reset the Tag-Counter to zero
    // so we can build a new Cloud.
    // But we do not need to rebuild AudioFile.Taglist by parsing RawTags as
    // the Tag-Objects are still there!
    for i := 0 to Tags.Count - 1 do
        if (Tags[i] as TTag).BreadCrumbIndex = High(Integer) then
           (Tags[i] as TTag).AudioFiles.Clear;
end;

procedure TTagCloud.SetActivetags;
var i: Integer;
begin
    ActiveTags.Clear;
    for i := 0 to Tags.Count - 1 do
        if (Tags[i] = fClearTag) or (TTag(Tags[i]).count > 2) then
            Activetags.Add(Tags[i]);
end;

procedure TTagCloud.SetFocussedTag(Value: TPaintTag);
begin
    if assigned(fFocussedTag) then
    begin
        fFocussedTag.fFocussed := False;
        fFocussedTag.Paint(CloudPainter.Canvas);
    end;

    fFocussedTag := Value;
    if assigned(fFocussedTag) then
    begin
        fFocussedTag.fFocussed := True;
        fFocussedTag.Paint(CloudPainter.Canvas);
    end;
end;

procedure TTagCloud.SetMouseOverTag(Value: TPaintTag);
begin
    if assigned(fMouseOverTag) then
    begin
        fMouseOverTag.fHover := False;
        fMouseOverTag.Paint(CloudPainter.Canvas);
    end;

    fMouseOverTag := Value;
    if assigned(fMouseOverTag) then
    begin
        fMouseOverTag.fHover := True;
        fMouseOverTag.Paint(CloudPainter.Canvas);
    end;
end;


function TTagCloud.GetOverLap(TagA, TagB: TPaintTag): Integer;
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

function TTagCloud.GetDefaultTag: TPainttag;
begin
    if Tags.Count > 0 then
        result := TPaintTag(Tags[0])
    else
        result := Nil;
end;

function TTagCloud.GetLeftTag: TPaintTag;
var aLine, bLine: TTagLine;
    aIdx, bIdx: Integer;
begin
    if assigned(fFocussedTag) then
    begin
        aLine := fFocussedTag.fLine;
        aIdx := aLine.Tags.IndexOf(fFocussedTag);
        if aIdx > 0 then
            // get the tag left of the current Tag in this line
            result := TPainttag(aLine.Tags[aIdx - 1])
        else
        begin
            // Go one line Up and select the last one there
            bIdx := CloudPainter.TagLines.IndexOf(aLine);
            if  bIdx > 0  then
            begin
                bLine := TTagLine(CloudPainter.TagLines[bIdx - 1]);
                if bLine.Tags.Count > 0 then
                    result := TPainttag(bline.Tags[bLine.Tags.Count - 1])
                else
                    result := GetDefaultTag
            end else
                result := GetDefaultTag;
        end;
    end
    else
        result := GetDefaultTag;
end;


function TTagCloud.GetRightTag: TPaintTag;
var aLine, bLine: TTagLine;
    aIdx, bIdx: Integer;
begin
    if assigned(fFocussedTag) then
    begin
        aLine := fFocussedTag.fLine;
        aIdx := aLine.Tags.IndexOf(fFocussedTag);
        if aIdx < aLine.Tags.Count - 1 then
            // get the tag right of the current Tag in this line
            result := TPainttag(aLine.Tags[aIdx + 1])
        else
        begin
            // Go one line Down and select the last one there
            bIdx := CloudPainter.TagLines.IndexOf(aLine);
            if  bIdx < CloudPainter.TagLines.Count - 1  then
            begin
                bLine := TTagLine(CloudPainter.TagLines[bIdx + 1]);
                if bLine.Tags.Count > 0 then
                    result := TPainttag(bLine.Tags[0])
                else
                    result := fFocussedTag
            end else
                result := fFocussedTag;
        end;
    end
    else
        result := GetDefaultTag;
end;

function TTagCloud.GetUpTag: TPaintTag;
var aLine, bLine: TTagLine;
    oMax, oCurrent, aIdx, i: Integer;
begin
    if assigned(fFocussedTag) then
    begin
        oMax := -1;
        aLine := fFocussedTag.fLine;
        aIdx := CloudPainter.TagLines.IndexOf(aLine);
        result := fFocussedTag;
        if aIdx > 0 then
        begin
            bLine := TTagLine(CloudPainter.TagLines[aIdx-1]);
            if bLine.Tags.Count = 0 then
                result := Nil
            else
            begin
                for i := 0 to bLine.Tags.Count - 1 do
                begin
                    oCurrent := GetOverLap(fFocussedTag, TPaintTag(bLine.Tags[i]));
                    if oCurrent > oMax then
                    begin
                        result := TPaintTag(bLine.Tags[i]);
                        oMax := oCurrent;
                    end;
                end;
            end;
        end;
    end else
        result := GetDefaultTag;
end;

procedure TTagCloud.InitHashMap;
var i: Integer;
begin
    if Not assigned(HashedTags[0]) then
    begin
            // This should be done only once per Nemp-Instance!
            for i := 0 to 1023 do
                HashedTags[i] := TObjectList.Create(False);
    end;
end;

function TTagCloud.GetDownTag: TPaintTag;
var aLine, bLine: TTagLine;
    oMax, oCurrent, aIdx, i: Integer;
begin
    if assigned(fFocussedTag) then
    begin
        oMax := -1;
        aLine := fFocussedTag.fLine;
        aIdx := CloudPainter.TagLines.IndexOf(aLine);
        result := fFocussedTag;
        if aIdx < CloudPainter.TagLines.Count - 1 then
        begin
            bLine := TTagLine(CloudPainter.TagLines[aIdx+1]);
            if bLine.Tags.Count = 0 then
                result := Nil
            else
            begin
                for i := 0 to bLine.Tags.Count - 1 do
                begin
                    oCurrent := GetOverLap(fFocussedTag, TPaintTag(bLine.Tags[i]));
                    if oCurrent > oMax then
                    begin
                        result := TPaintTag(bLine.Tags[i]);
                        oMax := oCurrent;
                    end;
                end;
            end;
        end;
    end else
        result := GetDefaultTag;
end;

function TTagCloud.GetFirstTag: TPaintTag;
var aLine: TTagline;
begin
    if CloudPainter.TagLines.Count > 0 then
    begin
        aLine := TTagLine(CloudPainter.TagLines[0]);
        if aLine.Tags.Count > 0 then
            result := TPaintTag(aLine.Tags[0])
        else
            result := GetDefaultTag
    end else
        result := GetDefaultTag;
end;
function TTagCloud.GetLastTag: TPaintTag;
var aLine: TTagline;
begin
    if CloudPainter.TagLines.Count > 0 then
    begin
        aLine := TTagLine(CloudPainter.TagLines[CloudPainter.TagLines.Count-1]);
        if aLine.Tags.Count > 0 then
            result := TPaintTag(aLine.Tags[aLine.Tags.Count - 1])
        else
            result := GetDefaultTag
    end else
        result := GetDefaultTag;
end;

function TTagCloud.GetFirstTagOfLine: TPaintTag;
var aLine: TTagline;
begin
    if assigned(fFocussedTag) then
    begin
        aLine := fFocussedTag.fLine;

        if aLine.Tags.Count > 0 then
            result := TPaintTag(aLine.Tags[0])
        else
            result := GetDefaultTag
    end else
        result := GetDefaultTag;
end;
function TTagCloud.GetLastTagOfLine: TPaintTag;
var aLine: TTagline;
begin
    if assigned(fFocussedTag) then
    begin
        aLine := fFocussedTag.fLine;
        if aLine.Tags.Count > 0 then
            result := TPaintTag(aLine.Tags[aLine.Tags.Count - 1])
        else
            result := GetDefaultTag
    end else
        result := GetDefaultTag;
end;

function TTagCloud.GetTopTag: TPaintTag;
var bLine: TTagLine;
    oMax, oCurrent, i: Integer;
begin
    if assigned(fFocussedTag) then
    begin
        oMax := -1;
        result := fFocussedTag;
        if CloudPainter.TagLines.Count > 0 then
        begin
            bLine := TTagLine(CloudPainter.TagLines[0]);
            if bLine.Tags.Count = 0 then
                result := Nil
            else
            begin
                for i := 0 to bLine.Tags.Count - 1 do
                begin
                    oCurrent := GetOverLap(fFocussedTag, TPaintTag(bLine.Tags[i]));
                    if oCurrent > oMax then
                    begin
                        result := TPaintTag(bLine.Tags[i]);
                        oMax := oCurrent;
                    end;
                end;
            end;
        end else
            result := GetDefaultTag;
    end else
        result := GetDefaultTag;
end;


function TTagCloud.GetBottomTag: TPaintTag;
var bLine: TTagLine;
    oMax, oCurrent, i: Integer;
begin
    if assigned(fFocussedTag) then
    begin
        oMax := -1;
        result := fFocussedTag;
        if CloudPainter.TagLines.Count > 0 then
        begin
            bLine := TTagLine(CloudPainter.TagLines[CloudPainter.TagLines.Count - 1]);
            if bLine.Tags.Count = 0 then
                result := Nil
            else
            begin
                for i := 0 to bLine.Tags.Count - 1 do
                begin
                    oCurrent := GetOverLap(fFocussedTag, TPaintTag(bLine.Tags[i]));
                    if oCurrent > oMax then
                    begin
                        result := TPaintTag(bLine.Tags[i]);
                        oMax := oCurrent;
                    end;
                end;
            end;
        end else
            result := GetDefaultTag;
    end else
        result := GetDefaultTag;
end;

{
    --------------------------------------------------------
    GetNextMatchingTagInLine
    - Get a tag with Prefix "fSearchString" in the given line
    --------------------------------------------------------
}
function TTagCloud.GetNextMatchingTagInLine(aLine: TTagLine; Offset: Integer): TPaintTag;
var i: integer;
    aTag: TPaintTag;
begin
    result := Nil;
    for i := Offset to aLine.Tags.Count - 1 do
    begin
        aTag := TPaintTag(aLine.Tags[i]);
        //if AnsiStartsText(fSearchString, aTag.Key) then
        if AnsiContainsText(aTag.Key, fSearchString) then
        begin
            result := aTag;
            break;
        end;
    end;
end;
function TTagCloud.GetNextMatchingTag(aKey: Word; f3pressed: Boolean): TPaintTag;
var aLine: TTagLine;
    tc: Int64;
    LineCount, LineIdx, TagIdx: Integer;

begin
    tc := GetTickCount;
    if not f3pressed then
    begin
        if (tc - fLastKeypressTick < 1000) then
            fSearchString := fSearchString + Char(aKey)
        else
            fSearchString := Char(aKey);
    end;
    fLastKeypressTick := tc;

    if assigned(fFocussedTag) then
    begin
        aLine := fFocussedTag.fLine;
        LineIdx := CloudPainter.TagLines.IndexOf(aLine);
        TagIdx := aLine.Tags.IndexOf(fFocussedTag);
        if f3pressed then
            inc(TagIdx);
        result := GetNextMatchingTagInLine(aLine, TagIdx);
        LineCount := 0;
        while (not assigned(result)) and (LineCount <= CloudPainter.TagLines.Count - 1) do
        begin
            inc(LineCount);
            LineIdx := (LineIdx + 1) mod (CloudPainter.TagLines.Count);
            aLine := TTagLine(CloudPainter.TagLines[LineIdx]);
            result := GetNextMatchingTagInLine(aLine, 0);
        end;
        if not assigned(result) then
            result := fFocussedTag;  //
    end else
        result := GetDefaultTag;
end;


procedure TTagCloud.ShowTags(Refocus: Boolean);
begin
    MouseOverTag := Nil;
    if Refocus then
        FocussedTag  := Nil;

    CloudPainter.Paint(CurrentTagList);

    if Refocus then
        FocussedTag := CloudPainter.GetFirstNewTag;

    if assigned(FocussedTag) then
        FocussedTag.PaintFocussed(CloudPainter.Canvas);
end;

procedure TTagCloud.ClearBreadCrumbs(Above: Integer);
var i: Integer;
begin
    for i := 0 to Tags.Count - 1 do
    begin
        if (TTag(Tags[i]).BreadCrumbIndex > Above)
            And (TTag(Tags[i]).BreadCrumbIndex < High(Integer))
        then
            TTag(Tags[i]).BreadCrumbIndex := High(Integer);
    end;
end;


procedure TTagCloud.CopyTags(Target: TObjectList; HideAutotags: Boolean; MinCount: Integer);
var
  i: Integer;
  aTag: TTag;
begin
    Target.Clear;
    for i := 0 to Tags.Count - 1 do
    begin
        aTag := TTag(Tags[i]);

        if ((aTag.count >= MinCount)
           and (Not (HideAutotags and aTag.IsAutoTag)))
           or ((aTag.BreadCrumbIndex < High(Integer)) and (aTag <> ClearTag))
        then
            Target.Add(Tags[i]);
    end;
end;

{
    --------------------------------------------------------
    GetTopTags
    - Parameters:
      ResultCount: maximum count of returned tags
      Offset: Minimum count a tag needs to be considered at all
      Source: the complete List of the Library
      Target: the Targetlist for the top tags
    Get the global to tags. Used e.g. for the random-playlist-form
    --------------------------------------------------------
}
procedure TTagCloud.GetTopTags(ResultCount: Integer; Offset: Integer;
    BibSource: TAudioFileList; Target: TObjectList; HideAutoTags: Boolean = False);
var tmpList: TObjectList;
    i: Integer;
begin
    tmpList := TObjectList.Create(False);
    try
        // copy all tags to temporary list
        for i := 0 to Tags.Count - 1 do
            if (TTag(Tags[i]).TotalCount >= Offset) then
            begin
                if (HideAutoTags and TTag(Tags[i]).IsAutoTag) then
                    // nothing
                else
                    tmpList.Add(Tags[i]);
            end;
        // sort list by totalcount
        tmplist.Sort(Sort_TotalCount);
        // ensure maxcount entries in the list
        if ResultCount > tmpList.Count - 1 then
            ResultCount := tmpList.Count - 1;
        // add maxCount entries to the target list
        Target.Clear;
        for i := 0 to ResultCount do
            Target.Add(tmpList[i]);
        // sort target list by name
        Target.Sort(Sort_Name);
    finally
        tmpList.Free;
    end;
end;

{
    --------------------------------------------------------
    BuildCloud
    - Parameters:
      Source: the complete List of the Library
      aTag: a TTag (or NIL)

      if aTag = "ClearTags"-Tag: Use Source
      else
      if aTag is "BreadCrumb": Use aTags.Tags, but do some more (clear some BreadcrumbTags)
      else Use aTag.Tags

    - Clear alltags.AudioFiles
    - Add all AdioFiles from the List into the Cloud
    If the SourceList is aTag.AudioFiles, we need to backup these Files
    --------------------------------------------------------
}
procedure TTagCloud.BuildCloud(Source: TAudioFileList; aTag: TTag; FromScratch: Boolean);
var i: Integer;
    properList: TAudioFileList;
begin
    if FromScratch then
    begin
        // We start complete new. Delete Browse-History.
        // BrowseHistory.Clear;
        ClearBreadCrumbs(-1);
//*//        Tags.Extract(fClearTag);
        properList := Source;
        fBreadCrumbDepth := 0;
        // clear all AudioFile.Tags
        for i := 0 to Source.Count - 1 do
            // we should use the (new) rawtags to rebuild the cloud
            Source[i].Taglist.Clear;

        InitHashMap;
    end else

    begin

        if assigned(aTag) then
        begin
            if aTag = fClearTag then
            begin
                // <Clear Tag> was chosen
                // so: Delete this from Tags (do not show it on Top-Level)
                //     Use Source (= MedienBib.FullList)
                //     Clear BreadCrumbs
//*//                Tags.Extract(fClearTag);
                properList := Source;
                ClearBreadCrumbs(-1);
                fBreadCrumbDepth := 0;
            end
            else
            begin
                if (aTag.BreadCrumbIndex > 0) and (aTag.BreadCrumbIndex < High(Integer)) then
                begin
                    // a "BreadCrumbTag" was chosen
                    // so: Clear BreadCrumbs above this Tag
                    //     Set the BreadCrumbWidth to this level
                    ClearBreadCrumbs(aTag.BreadCrumbIndex);
                    fBreadCrumbDepth := aTag.BreadCrumbIndex;
                end else
                begin
                    // a new Tag was chosen
                    // so: If we begin a tag-browsing: Add Cleartag
                    //     Increase BreadCrumbwidth
                    //     Set the Tags BreadCrumbindex (so its AudioFile-List will not be changed)
//*//                    if fBreadCrumbDepth = 0 then
//*//                        Tags.Add(fClearTag);

                    fBreadCrumbDepth := fBreadCrumbDepth + 1;
                    aTag.BreadCrumbIndex := fBreadCrumbDepth;
                end;
                // anyway, when we chose a tag, we should use it
                properList := aTag.AudioFiles;
            end;
        end else
        begin
            // no Tag was clicked
            properList := Source;
            // to be sure: Clear all Breadcrumbs
            ClearBreadCrumbs(-1);
        end;

    end;


    try
        // Clear the cloud, i.e. set the Count of (almost) all Tags to Zero
        // All references to AudioFiles are deleted here
        // (except the Breadcrumb-Tags, if existing)
        Reset;

        // Insert Files into the new Cloud
        for i := 0 to properList.Count - 1 do
            AddAudioFile(properList[i]);

        // Sort Tags by Count
        Tags.Sort(Sort_Count);

        SetActivetags;

    finally

    end;

    if FromScratch then
    begin
        // we started a new Cloud, so: Count = TotalCount
        // this is used when we need the top tags, e.g.
        for i := 0 to Tags.Count - 1 do
            TTag(Tags[i]).TotalCount := TTag(Tags[i]).Count;
    end;
end;

{
    --------------------------------------------------------
    BackUpNavigation
    RestoreNavigation
    - Save the current Breadcrumbs and restore them after
      a rebuild of the cloud (~RemarkOldNodes in Classic browsing)
    --------------------------------------------------------
}
procedure TTagCloud.BackUpNavigation;
var i: Integer;
begin
    //
    if fInitialising then
        fInitialising := False
        // we are loading nemp.
        // Do not overwrite the data from the inifile
    else
    begin
        // clear old list
        fBackUpBreadCrumbs.Clear;
        // add current Breadcrumbs to the list
        for i := 0 to Tags.Count - 1 do
            if (Tags[i] as TTag).BreadCrumbIndex < High(Integer) then
                fBackUpBreadCrumbs.Add(Tags[i])
            else
                break; // we need only the first few tags.

        // Backup focussed Tag
        fBackupFocussedTag := fFocussedTag;
    end;
end;

procedure TTagCloud.RestoreNavigation(aList: TAudioFileList);
var i: Integer;
begin
    // Initialisation done.
    fInitialising := False;

    // use the backupBreadcrumbs to navigate through the new cloud
    for i := 0 to fBackUpBreadCrumbs.Count - 1 do
    begin
        BuildCloud(aList, TTag(fBackUpBreadCrumbs[i]), False);
    end;

    // Paint the new Cloud
    MouseOverTag := Nil;
    FocussedTag := Nil;
    CloudPainter.Paint(CurrentTagList);

    // is old focussed Tag visible? The set the new one!
    if assigned(fBackupFocussedTag) and (CloudPainter.IsVisible(fBackupFocussedTag)) then
        FocussedTag := fBackupFocussedTag
    else
        // otherwise: Get default-Tag
        FocussedTag := CloudPainter.GetFirstNewTag;

    if assigned(fFocussedTag) then
        FocussedTag.PaintFocussed(CloudPainter.Canvas);
end;

{
    --------------------------------------------------------
    GetTag
    - Search the TTags for a specified key
    - Create a new Tag if no Tag with this key exists
    --------------------------------------------------------
}

function TTagCloud.GetTag(aKey: String): TTag;
var i: Integer;
    tmp: TTag;
    KeyHashList: TObjectList;
    //x,y: Integer;
begin
    tmp := Nil;

    // Note: The Tag-Finding should be done much more efficient!
    // Use a aKey[1] and aKey[2] AND 31 to Hash the key into a 32x32 Array of TObjectList
    // and search only this List.
    // in Addition: Move the found key upwards , so that often used keys can be found faster.

    aKey := AnsiLowerCase(aKey);

    // Hash the first two Chars of aKey
  {  x := 0;
    y := 0;
    if length(aKey) > 0 then
        x := Ord(aKey[1]) mod 32;
    if length(aKey) > 1 then
        y := Ord(aKey[2]) mod 32;
    }

    KeyHashList := HashedTags[HashFromStr(aKey)];

    for i := 0 to KeyHashList.Count - 1 do
        if TTag(KeyHashList[i]).Key = aKey then
        begin
            tmp := TTag(KeyHashList[i]);
            // move one item up
            if (i > 0) and(TTag(KeyHashList[i]).count >= TTag(KeyHashList[i-1]).Count)  then
                KeyHashList.Exchange(i, i-1);
            break;
        end;


    if assigned(tmp) then
        result := tmp
    else
    begin
        result := TPaintTag.Create(aKey, False);
        // Add the new tag to the Taglist // todo !!! and the correct list in the Array of Lists!
        Tags.Add(result);
        KeyHashList.Add(result);
    end;
end;



procedure TTagCloud.NavigateCloud(aKey: Word; Shift: TShiftState);
begin
    case aKey of
        vk_up:    FocussedTag := GetUpTag;
        vk_Down:  FocussedTag := GetDownTag;
        vk_Left:  FocussedTag := GetLeftTag;
        vk_right: FocussedTag := GetRightTag;

        vk_Escape: begin
              if (fBreadCrumbDepth > 0) then
                  FocussedTag := GetDefaultTag
              else
                  FocussedTag := Nil;
        end;

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
              if (fBreadCrumbDepth > 0) then
                  FocussedTag := TPaintTag(ActiveTags[fbreadCrumbDepth-1])
              else
                  FocussedTag := Nil;
        end;
        vk_F3: FocussedTag := GetNextMatchingTag(aKey, True);
    else
        FocussedTag := GetNextMatchingTag(aKey, False);
    end;

    //CloudPainter.DoPaint;
end;

{
    --------------------------------------------------------
    GenerateAutoRawTags
    - Generate RawTagString from other properties
    - add the Tags to the destination-list
    --------------------------------------------------------
}
procedure TTagCloud.GenerateAutoRawTags(aAudioFile: TAudioFile;
  Dest: TStringList);
var decade, year: Integer;
begin
    // use Artist, Year, Decade and Genre as "Auto-Tags"
    if Not UnKownInformation(aAudioFile.Artist) then
        Dest.Add(aAudioFile.Artist);

    if not UnKownInformation(aAudioFile.Album) then
        Dest.Add(aAudioFile.Album);

//    if aAudioFile.Titel <> AUDIOFILE_UNKOWN then
//        Dest.Add(aAudioFile.Titel);

    if (aAudioFile.Year <> '0') and (trim(aAudioFile.Year) <> '')  then
    begin
        Dest.Add(aAudioFile.Year);
        year := StrToIntDef(aAudioFile.Year, -1);
        if year <> -1 then
        begin
            decade := (Year Mod 100) Div 10;
            Dest.Add(IntToStr(decade) + '0s'); // e.g. 80s, 90s, 00s
        end;
    end;

    if aAudioFile.Genre <> '' then
        Dest.Add(aAudioFile.Genre);

end;


{
    --------------------------------------------------------
    AddAudioFileTags
    Insert the AudioFile into all Tag.Audiofile-Lists of its Tags
    (i.e. Increase the Count of these Tags)
    --------------------------------------------------------
}
procedure TTagCloud.AddAudioFileTags(aAudioFile: TAudioFile);
var i: Integer;
begin
    for i := 0 to aAudioFile.TagList.Count - 1 do
    begin
        // Test for "= High(Integer)":
        // We do not want the file added to tags in the breadcrumblist, as
        // it is already in these lists (as a go-back-navigation)
        if (TTag(aAudioFile.TagList[i]).BreadCrumbIndex = High(Integer)) then
            TTag(aAudioFile.TagList[i]).AudioFiles.Add(aAudioFile);

        // todo if aTag.count = 1 then AddTag to "currenttagCloudList"
        // NO. We dont need the Tags of Previous Clouds, but the List of AudioFiles
        //   => Backup these in BuildCloud
    end;
end;


{
    --------------------------------------------------------
    AddAudioFileRAWTags
    - Split the RawTags into seperate Strings
    - Get the matching TTag-Object (or create a new one)
    - Add the Tag to the Audiofile and vice versa
    --------------------------------------------------------
}
procedure TTagCloud.AddAudioFileRAWTags(aAudioFile: TAudioFile; InsertInBreadcrumbs: Boolean=False);
var allTags, tmpTags: TStringList;
    i: Integer;
    autoCount: Integer;
    aTag: TTag;
begin
    allTags := TStringList.Create;
    tmpTags := TStringList.Create;
    try
        // Generate Auto-Tags from Audiofile-Info
        // ToDo: Settings like "UseYear", "UseDecade", ...
        GenerateAutoRawTags(aAudioFile, allTags);

        autoCount := alltags.Count;

        // Add the Tags from the two RawTag-Strings to allTag-List
        tmpTags.Text := String(aAudioFile.RawTagLastFM);
        for i := 0 to tmpTags.Count - 1 do
            if trim(tmpTags[i]) <> '' then
                allTags.Add(trim(tmptags[i]));

        //tmpTags.Text := String(aAudioFile.RawTagUserDefined);
        //for i := 0 to tmpTags.Count - 1 do
        //    if trim(tmpTags[i]) <> '' then
        //        allTags.Add(trim(tmptags[i]));


        // Add/Insert every Tag into the af.TagList
        for i := 0 to allTags.Count - 1 do
        begin
            aTag := GetTag(allTags[i]);

            if i < autoCount then
                aTag.IsAutoTag := True;

            // ensure Uniquness - check whether the tag was just added to this file
            if  ((aTag.BreadCrumbIndex = High(Integer)) or (InsertInBreadcrumbs)) AND
                // Test for "= High(Integer)":
                // We do not want the file added to tags in the breadcrumblist, as
                // it is already in these lists (as a go-back-navigation)
                // But after an update, we MUST skip this first test
                ((aTag.count = 0) or (aTag.AudioFiles[aTag.count-1] <> aAudioFile))
            then
            begin

                // Add the AudioFile into the Filelist of the Tag
                aTag.AudioFiles.Add(aAudioFile);
                // Add the Tag into the Taglist of the AudioFile
                aAudioFile.Taglist.Add(aTag);
            end;
        end;

    finally
        allTags.Free;
        tmpTags.Free;
    end;
end;


procedure TTagCloud.AddAudioFile(aAudioFile: TAudioFile);
begin
    if aAudioFile.TagList.Count = 0 then
    begin
        // generate RawTag-Stringlist and create new TTag-Objects (if necessary)
        // => Fill aAudioFile.TagList
        // and insert them (as in AddAudioFileTags)
        AddAudioFileRAWTags(aAudioFile);

    end else
        // Insert Tags in af.TagList into the Cloud
        AddAudioFileTags(aAudioFile);

end;

{
    --------------------------------------------------------
    RenameTag
    - Rename a Tag (i.e. create a new tag Object and move Audiofiles to the new one)
    --------------------------------------------------------
}(*
procedure TTagCloud.RenameTag(oldTag: TTag; NewKey: String);
var NewTag: TTag;
    i, oi: Integer;
    af: TAudioFile;
    sl: TStringList;
begin
    // 1. Get Tag with NewKey
    Newtag := GetTag(NewKey); // if needed, it is created there and Added to Cloud.Tags

    // 2. Move all AudioFiles from OldTag to NewTag
    for i := 0 to oldTag.AudioFiles.Count - 1 do
    begin
        af := oldTag.AudioFiles[i];
        if af.Taglist.Count = 0 then
            // to be sure, but this should not happen
            AddAudioFileRAWTags(af);
        // add newTag into the Taglist of the current AudioFile
        if af.Taglist.IndexOf(NewTag) = -1 then
        begin
            // add New Tag-Object to the audiofile
            af.Taglist.Add(NewTag);
            // add Audiofile to the NewTag
            NewTag.AudioFiles.Add(af);
        end;
        // remove old Tag from AudioFile
        af.Taglist.Extract(oldTag);

        // Do the same as above, but with the RawTagLastFM-String
        // Split the RawTagString. Use Stringlist for that purpose
        sl := TStringList.Create;
        try
            sl.Text := String(af.RawTagLastFM);
            // Delete OldKey
            oi := sl.IndexOf(oldTag.Key);
            if (oi >= 0) and (oi < sl.Count) then
                sl.Delete(oi);
            // Insert NewKey
            if sl.IndexOf(NewKey) = -1 then
                sl.Add(NewKey);
            // Set RawTag
            af.RawTagLastFM := UTF8String(sl.Text);
        finally
            sl.Free;
        end;

        // Mark this audiofile, to rewrite its ID3Tag later
        af.ID3TagNeedsUpdate := True;

        // generate New RawTagString from current tags
        // (this should be easier than pos, copy, ...)
        // But it is WRONG!!! in af.Tags are also the AUTO-tags!!
        {
        // we added newtag, so Count is >0
        newRawString := TTag(af.Taglist[0]).key;
        for t := 1 to af.TagList.Count - 1 do
            newRawString := newRawString + #13#10 + TTag(af.Taglist[t]).key;  // See NempScrobbler.ParseRawTag
        af.RawTagLastFM := newRawString;
        }
    end;
    // clear the oldTag
    oldTag.AudioFiles.Clear;
end;    *)

{
    --------------------------------------------------------
    DeleteTag
    - Clear a Tags AudioFile-List
    --------------------------------------------------------
}          (*
procedure TTagCloud.DeleteTag(aTag: TTag);
var i, oi: Integer;
    af: TAudioFile;
    sl: TStringList;
begin
    for i := 0 to aTag.AudioFiles.Count - 1 do
    begin
        af := aTag.AudioFiles[i];
        if af.Taglist.Count = 0 then
            // to be sure, but this should not happen
            AddAudioFileRAWTags(af);
        // remove Tag from the AudioFile's Taglist
        af.Taglist.Extract(aTag);


        // Do the same as above, but with the RawTagLastFM-String
        // Split the RawTagString. Use Stringlist for that purpose
        sl := TStringList.Create;
        try
            sl.Text := String(af.RawTagLastFM);
            // Delete OldKey
            oi := sl.IndexOf(aTag.Key);
            if (oi >= 0) and (oi < sl.Count) then
                sl.Delete(oi);
            // Set RawTag
            if sl.Count > 0 then
                af.RawTagLastFM := UTf8String(sl.Text)
            else
                af.RawTagLastFM := ''; // just to be sure, empty Stringlist my return "#13#10"?
        finally
            sl.Free;
        end;

        af.ID3TagNeedsUpdate := True;
        {
        // build new RawTag-String
        if af.Taglist.Count > 0 then
        begin
            newRawString := TTag(af.Taglist[0]).key;
            for t := 1 to af.TagList.Count - 1 do
                newRawString := newRawString + #13#10 + TTag(af.Taglist[t]).key;  // See NempScrobbler.ParseRawTag
            af.RawTagLastFM := newRawString;
        end else
            // nor Tags any more
            af.RawTagLastFM := '';
        }
    end;
    aTag.AudioFiles.Clear;
end;    *)


procedure TTagCloud.DeleteAudioFile(aAudioFile: TAudioFile);
begin
    // Todo
end;


procedure TTagCloud.UpdateAudioFile(aAudioFile: TAudioFile);
var i: Integer;
    aTag: TTag;
begin
     // 1.) Delete this file from the file-lists of all of its tags
     for i := 0 to aAudioFile.Taglist.Count - 1 do
     begin
        aTag := TTag(aAudioFile.Taglist[i]);
        aTag.AudioFiles.Extract(aAudioFile);
     end;
     // 2.) Clear this files taglist
     aAudioFile.Taglist.Clear;
     // 3.) Generate tag-list from RawTag
     AddAudioFileRAWTags(aAudioFile, True);
end;

procedure TTagCloud._SaveTagsToFile(aFile: String);
var s: tStringList;
    i: Integer;
begin
    s := TStringList.Create;
    try
        Tags.Sort(Sort_Name);
        for i := 0 to Tags.Count - 1 do
          s.Add(TTag(Tags[i]).Key + ' - ' + IntToStr(TTag(Tags[i]).Count));

        s.SaveToFile(aFile);
    finally
        s.Free;
    end;

end;

{ TPaintTag }

constructor TPaintTag.Create(aKey: String; aTranslate: Boolean);
begin
    inherited Create(aKey, aTranslate);
    fHover := False;
    fFocussed := False;
    fTranslate := aTranslate;
    if fTranslate then
        fKey := aKey;
end;


procedure TPaintTag.MeasureOutput(aCanvas: TCanvas);
begin
    aCanvas.Font.Size := FontSize;
    if self.fTranslate then
    begin
        fWidth := aCanvas.TextWidth(_(Key)) + 4 * BORDER_WIDTH;
        fHeight := aCanvas.TextHeight(_(Key)) + 4 * BORDER_HEIGHT;
    end else
    begin
        fWidth := aCanvas.TextWidth(Key) + 4 * BORDER_WIDTH;
        fHeight := aCanvas.TextHeight(Key) + 4 * BORDER_HEIGHT;
    end;
end;

{
  Erase:
  Erase the Tag-Rect and Draw the matching part of the background-image
}
procedure TPaintTag.Erase(aCanvas: TCanvas; Blend:Boolean);
var tmp: TBitmap;
begin
    if Not TagCustomizer.UseBackGround then
    begin
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
        if self.fFocussed then
            PaintFocussed(aCanvas)
        else
            PaintHover(aCanvas);
end;

procedure TPaintTag.PaintNormal(aCanvas: TCanvas);
begin
    // Draw a roundrect
    if self.BreadCrumbIndex < High(Integer) then
    begin
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
    if fTranslate then
        aCanvas.TextOut(fLeft + 2*BORDER_WIDTH, fTop + 2*BORDER_Height, _(Key))
    else
        aCanvas.TextOut(fLeft + 2*BORDER_WIDTH, fTop + 2*BORDER_Height, Key);
end;


procedure TPaintTag.PaintHover(aCanvas: TCanvas);
begin
    // Draw a roundrect
    if self.BreadCrumbIndex < High(Integer) then
    begin
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
    if fTranslate then
        aCanvas.TextOut(fLeft + 2*BORDER_WIDTH, fTop + 2*BORDER_Height, _(Key))
    else
        aCanvas.TextOut(fLeft + 2*BORDER_WIDTH, fTop + 2*BORDER_Height, Key)
end;

procedure TPaintTag.PaintFocussed(aCanvas: TCanvas);
begin
    // Draw a roundrect
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
    if fTranslate then
        aCanvas.TextOut(fLeft + 2*BORDER_WIDTH, fTop + 2*BORDER_Height, _(Key))
    else
        aCanvas.TextOut(fLeft + 2*BORDER_WIDTH, fTop + 2*BORDER_Height, Key);
end;


{ TTagLine }

constructor TTagLine.Create(CanvasWidth: Integer);
begin
  fCanvasWidth := CanvasWidth;
  Tags := TObjectList.Create(False);
end;

destructor TTagLine.Destroy;
begin
  Tags.Free;
  inherited;
end;

function TTagLine.fGetBreadCrumbline: Boolean;
begin
    result := (Tags.Count > 0) and (TPaintTag(Tags[0]).BreadCrumbIndex < High(Integer));
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
    if (Tags.Count > 1) And (TPaintTag(Tags[0]).BreadCrumbIndex = High(Integer))  then
        fGap := (fCanvasWidth - Width) Div (Tags.Count - 1)
    else
        fGap := 0;

    x := 0;
    for i := 0 to Tags.Count - 1 do
    begin
        pt := TPaintTag(Tags[i]);
        pt.fTop := Top;
        pt.fLeft := x;

        pt.Paint(aCanvas);

        x := x + pt.Width + fGap ;
    end;

end;

{ TCloudPainter }

constructor TCloudPainter.Create;
begin
    TagLines := TObjectList.Create;
    Tags := TObjectList.Create(False);
    visibleTags := TObjectList.Create(False);
end;

destructor TCloudPainter.Destroy;
begin
    visibleTags.Free;
    TagLines.Free;
    Tags.Free;
    inherited;
end;


procedure TCloudPainter.DoPaint;
var y, i, t: Integer;
begin

//    Canvas.Brush.Color := TagCustomizer.BackgroundColor;
//    Canvas.Brush.Style := bsSolid;
//    Canvas.FillRect(Rect(0,0,width, Height));

    if TagCustomizer.UseBackGround and assigned(TagCustomizer.BackgroundImage) then
    begin
        TagCustomizer.TileGraphic(Canvas,
              TagCustomizer.OffSetX, TagCustomizer.OffSetY);

        y := BREADCRUMB_GAP;
        for i := 0 to TagLines.Count - 1 do
            y := y + TTagLine(Taglines[i]).Height;


        TagCustomizer.AlphaBlendCloud(Canvas, Width, y, 0, 0, bm_Cloud);
    end else
    begin
        Canvas.Brush.Color := TagCustomizer.BackgroundColor;
        Canvas.FillRect(Canvas.ClipRect);
    end;

    visibleTags.Clear;

    y := 0;
    for i := 0 to TagLines.Count - 1 do
    begin
        TTagLine(Taglines[i]).Top := y;
        TTagLine(Taglines[i]).Paint(Canvas);
        for t := 0 to TTagLine(Taglines[i]).Tags.Count - 1 do
            visibleTags.Add(TTagLine(Taglines[i]).Tags[t]);

        y := y + TTagLine(Taglines[i]).Height;
        if (TTagLine(Taglines[i]).BreadCrumbline)
           and ((i < TagLines.Count - 1) and Not (TTagLine(Taglines[i+1]).BreadCrumbline))
        then
            y := y + BREADCRUMB_GAP;
    end;

    visibleTags.Sort(Sort_Count);
end;


procedure TCloudPainter.Paint(Source: TObjectList);

begin

if not assigned(source) then Exit;


    RawPaint1(Source);
    RawPaint2(Source);
    DoPaint;

  {
compute Top-offset
drawlines

}

end;



procedure TCloudPainter.PaintAgain;
begin
  DoPaint;
end;

function TCloudPainter.GetMaxCount(Source: TObjectList): Integer;
var i: integer;
begin
    result := 0;
    for i := 0 to Source.Count - 1 do
        if TTag(Source[i]).BreadCrumbIndex = High(Integer) then
        begin
            result := TTag(Source[i]).count;
            break;
        end;
end;

function TCloudPainter.GetProperFontSize(aTag: TPaintTag): Integer;
begin
    if aTag.BreadCrumbIndex = High(Integer)  then
    begin
        if (aTag.count < (0.9 * lastFontChangeAt)) then
        begin
            if currentFontSize > 8 then
                currentFontSize := currentFontSize - 1;
            lastFontChangeAt := aTag.count;
        end;
        result := currentFontSize;
    end else
        result := 10;
end;


function TCloudPainter.GetTagAtMousePos(x, y: Integer): TPaintTag;
var line: TTagLine;
  i: Integer;
begin
    result := Nil;
    line  := Nil;
    for i := Taglines.Count - 1 downto 0 do
      if TTagLine(TagLines[i]).Top <= y then
      begin
          line := TTagLine(TagLines[i]);
          break;
      end;

    if assigned(line) then

    for i := line.Tags.Count - 1 downto 0 do
    begin
        if TPaintTag(line.Tags[i]).fLeft <= x then
        begin
            result := TPaintTag(line.Tags[i]);
            break;
        end;
    end;

end;

function TCloudPainter.IsVisible(aTag: TPaintTag): Boolean;
begin
    result := visibleTags.IndexOf(aTag) >= 0;
end;

function TCloudPainter.GetFirstNewTag: TPaintTag;
var i: Integer;
begin
    if visibleTags.Count > 0 then
        Result := TPaintTag(visibleTags[0])
    else
        Result := Nil;

    for i := 1 to visibleTags.Count - 1 do
        if TPainttag(visibleTags[i]).BreadCrumbIndex = High(Integer) then
        begin
            // Change in 2017. Focus on the last Breadcrumb-tag
            result := TPainttag(visibleTags[i-1]);
            break;
        end;
end;


function TCloudPainter.ForceLineBreak(currentTag: TPaintTag): Boolean;
begin
    if fForcedBreakDone then
        result := False
    else
    begin
        result := currentTag.BreadCrumbIndex = High(Integer);
        if result then
            fForcedBreakDone := True;
    end;
end;

{
  ------------------------------------
  TCloudPainter.RawPaint1
  - First Step of the Painting.
    Measure all Tags and fill the canvas
    Note: The tags are sorted by Count here!
  ------------------------------------
}
procedure TCloudPainter.RawPaint1(Source: TObjectList);
var x, y, i, lineHeight: Integer;
    aTag: TPaintTag;
    CanvasFull: Boolean;
    BreadCrumbEnd: Boolean;
begin
    Tags.Clear;
    CanvasFull := False;
    i := 0;
    x := 0;     // current x-Position
    y := 0;     // current y-Position
    lineHeight := 0;   // Height of the current "line"
    fForcedBreakDone := False;

    maxCount := GetMaxCount(Source);

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


    while (i < Source.Count) and Not CanvasFull do
    begin
        aTag := TPaintTag(Source[i]);
        // Set the FontSize used to display the tag          // !!!!!!!!!!!!!!!!!!!!!!!
        aTag.FontSize := GetProperFontSize(aTag);

        // get the size of the Tag on the Canvas
        aTag.MeasureOutput(Canvas);

        BreadCrumbEnd := ForceLineBreak(aTag);
        if (Not BreadCrumbEnd) and ((x + aTag.Width <= Width) or (x = 0)) then
        begin
            // Tag fits in the current line
            x := x + aTag.Width;
            lineHeight := max(lineHeight, aTag.Height);
            Tags.Add(aTag);
        end else
        begin
            // Tag does NOT fit in the current line => start a new one
            y := y + lineHeight;
            if BreadCrumbEnd then
                y := y + BREADCRUMB_GAP;

            if (y + aTag.Height < Height - 8) then
            begin
                lineHeight := aTag.Height;
                x := aTag.Width;
                Tags.Add(aTag);
            end else
            begin
                // Canvas is full.
                // Note: following Tags will have a smaller size, so this check
                // should be ok.
                CanvasFull := True;
            end;
        end;
        // get the next Tag in Source.
        inc(i);
    end;  // while
end;

procedure TCloudPainter.RawPaint2(Source: TObjectList);
var i, x, y: Integer;
    currentLine: TTagLine;
    currentTag: TPaintTag;
    CanvasFull: Boolean;
    SuccessfullyPaintItems: Integer;
    Fail: Boolean;
    BreadCrumbEnd: Boolean;
begin
    TagLines.Clear;
    // Sort Tags by Name
    Tags.Sort(Sort_Name);

    x := 0;
    y := 0;
    i := 0;
    CanvasFull := False;
    Fail := False;
    SuccessfullyPaintItems := 0;
    fForcedBreakDone := False;

    currentLine := TTagLine.Create(Width);
    TagLines.Add(currentLine);

    //for i := 0 to Tags.Count - 1 do
    while (i < Tags.Count) and Not CanvasFull do
    begin
        currentTag := TPaintTag(Tags[i]);
        BreadCrumbEnd := ForceLineBreak(currentTag);
        if (Not BreadCrumbEnd) and  ((x + currentTag.Width <= Width) or (x = 0)) then
        begin
            // Tag fits in currentLine
            currentLine.Tags.Add(currentTag);
            currentTag.fLine := currentLine;
            currentLine.fHeight := max(currentLine.Height, currentTag.Height);
            currentLine.fWidth := currentLine.Width + currentTag.Width;
            x := x + currentTag.Width;
        end else
        begin

            y := y + currentLine.Height;
            if BreadCrumbEnd then
                y := y + BREADCRUMB_GAP;

            // line is full. We need to start a new line
            // But: Maybe the currentline was to high for Canvas!
            if y > Height - 8 then
            begin
                // currentline has grown to much in Height
                // and so it cannot be painted on the canvas
                CanvasFull := True;
                Fail := True;
            end else
            begin
                SuccessfullyPaintItems := i-1;  // last line can be painted

                /////y := y + currentLine.Height;
                currentLine := TTagLine.Create(Width);
                TagLines.Add(currentLine);
                currentLine.Tags.Add(currentTag);
                currentTag.fLine := currentLine;
                currentLine.fHeight := currentTag.Height;
                currentLine.fWidth := currentLine.Width + currentTag.Width;
                x := currentTag.Width ;
            end;
        end;
        inc(i);
    end;

    if y + currentLine.Height > Height - 8 then
        Fail := True;

    if Fail and (Tags.Count > 0) then
    begin
        // we have to much in our TagList. So: Delete some tags
        Tags.Sort(Sort_Count);
        for i := Tags.Count - 1 downto SuccessfullyPaintItems do
            Tags.Delete(i);

        RawPaint2(Source);
    end;



    {
    ToDo: Check, ob das so ins canvas passt
    }
    {
    sort self.tags by Key
    Get a Tag from self.tags, insert it into a TTagLine-Object

    (+)
    if "passt noch mehr" fill canvas with source, starting at tags.count
    Do Rawpaint again

    (-)
    if "passt nicht" delete some Tags from self.tags
    Do RawPaint again (but set Stop-Flag, i.e. do not do (+) again)
    }

end;

procedure TCloudPainter.RePaintTag(aTag: TPaintTag; Active: Boolean);
begin
    if assigned(aTag) then
    begin
        aTag.Paint(Canvas);
    end;
end;

procedure TCloudPainter.SetHeight(Value: Integer);
begin
 //   if Value > 10 then
 //       fHeight := Value - 10
 //   else
        fHeight := value; //0;
end;

procedure TCloudPainter.SetWidth(Value: Integer);
begin
  //  if Value > 10 then
  //      fWidth := Value - 10
  //  else
        fWidth := value; //0;
end;

{ TCloudViewer }

procedure TCloudViewer.CMWantspecialKey(var Msg: TWMKey);
begin
  inherited;
      with msg do
        case Charcode of
            vk_left, vk_up, vk_right, vk_down : Result:=1;
        end;

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
