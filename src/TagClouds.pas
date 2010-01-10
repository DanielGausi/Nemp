{

todo here:
- (done) keys only lowercase
- backup list of audiofiles
- hash keys for faster Tagcloud-build
}

unit TagClouds;

interface

uses windows, classes, SysUtils, Controls, Contnrs, AudioFileClass, Math, stdCtrls,
    ComCtrls, Graphics, Messages;

type

  TTagLine = class; // forward declaration

  // a single Tag on a Paintbox
  TPaintTag = class(TTag)
      private
          fLeft: Integer;    // left-position in a Tag-Line
          fTop: Integer;
          fWidth: Integer;
          fHeight: Integer;
          FontSize: Integer;
          fActiveColor: TColor;
          fColor: TColor;
          fFocusColor: TColor;
          fFocusBorderColor: TColor;

          fHover: Boolean;
          fFocussed: Boolean;

          fLine: TTagLine;

          procedure PaintNormal(aCanvas: TCanvas);
          procedure PaintActive(aCanvas: TCanvas);
          procedure PaintFocussed(aCanvas: TCanvas);


      public
          property Width: Integer read fWidth;
          property Height: Integer read fheight;

          constructor Create(aKey: UTF8String);

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
      public
          Tags: TObjectList;     // the Tags in this line

          Top: Integer;
          property Width: Integer read fWidth;      // the width (of all Tags together)
          property Height: Integer read fheight;    // the Height (of the biggest Tag)

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

          function GetProperFontSize(aTag: TPaintTag):Integer;

          function GetMaxCount(Source: TObjectList): Integer;

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

          function GetTagAtMousePos(x,y: Integer): TPaintTag;

  end;


  TTagCloud = class
      private
          // the main list with all Tags in the Cloud.
          Tags: TObjectList;
          ActiveTags: TObjectList;

          HashedTags: Array[0..31,0..31] of TObjectList;

          fClearTag: TTag;

          // A list of TObjectlists with AudioFiles
          ///BrowseHistory: TObjectList;

          fBreadCrumbDepth: Integer;



          fMouseOverTag: TPaintTag;
          fFocussedTag: TPaintTag;

          procedure SetMouseOverTag(Value: TPaintTag);
          procedure SetFocussedTag(Value: TPaintTag);



          procedure ClearBreadCrumbs(Above: Integer);

          // Get a TTag-Object with a matching key
          function GetTag(aKey: UTF8String): TTag;

          function fGetTagList: TObjectList;

          // Insert all Tags from the AudioFile into the Taglist
          procedure AddAudioFileTags(aAudioFile: TAudioFile);

          // Generate a TagList from RawTag-Strings of the Audiofile.
          procedure AddAudioFileRAWTags(aAudioFile: TAudioFile);

          // Set Default-RawTags (like genre, artist, year)
          procedure GenerateAutoRawTags(aAudioFile: TAudioFile; Dest: TStringList);

          //
          procedure SetActivetags;

          function GetOverLap(TagA, TagB: TPaintTag): Integer;

          function GetFirstNewTag: TPaintTag;

          function GetDefaultTag: TPainttag;


          function GetLeftTag: TPaintTag;
          function GetRightTag: TPaintTag;
          function GetUpTag: TPaintTag;
          function GetDownTag: TPaintTag;




      public

        CloudPainter: TCloudPainter;

        property MouseOverTag: TPaintTag read fMouseOverTag write SetMouseOverTag;
        property FocussedTag: TPaintTag read fFocussedTag write SetFocussedTag;


        property CurrentTagList: TObjectList read fGetTagList;

        property ClearTag: TTag read fCleartag;

        constructor Create;
        destructor Destroy; override;

        // Build a Tag-Cloud for the AudioFiles given in Source
        procedure BuildCloud(Source: TObjectList; aTag: TTag; FromScratch: Boolean);

        procedure ShowTags;//(aListView: TListView);

        procedure NavigateCloud(aKey: Word);

        // Add a file to the TagCloud
        procedure AddAudioFile(aAudioFile: TAudioFile);

        // Delete a File from the Cloud
        procedure DeleteAudioFile(aAudioFile: TAudioFile);

        // Update a File (change the Tags) in the Cloud
        procedure UpdateAudioFile(aAudioFile: TAudioFile);

        // Reset the Tag to zero, i.e. Clear the Tag.AudioFileList
        procedure Reset;

  end;

  TCloudViewer = class(TCustomControl)
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




function Sort_Count(item1,item2:pointer):integer;
function Sort_Name(item1,item2:pointer):integer;

implementation


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



{ TTagCloud }



constructor TTagCloud.Create;
begin
    Tags := TObjectList.Create;
    ActiveTags := TObjectList.create(False);
//    BrowseHistory := TObjectList.Create;
    CloudPainter := TCloudPainter.Create;

    fClearTag := TPaintTag.Create('<Clear tags>');
    fClearTag.BreadCrumbIndex := -2;
end;

destructor TTagCloud.Destroy;
var i,j: Integer;
begin
    if assigned(HashedTags[0,0]) then
    begin
        for i := 0 to 31 do
          for j := 0 to 31 do
            Hashedtags[i,j].Free;
    end;
//    BrowseHistory.Free;
    CloudPainter.Free;
    Activetags.Free;
    Tags.Extract(fClearTag);
    fCleartag.Free;
    Tags.free;

    inherited;
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
        if (Tags[i] = fClearTag) or (TTag(Tags[i]).count > 0) then
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
                    result := Nil
            end else
                result := Nil;
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
        end else
            result := fFocussedTag;
    end else
        result := GetDefaultTag;
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
        end else
            result := fFocussedTag;
    end else
        result := GetDefaultTag;
end;

function TTagCloud.GetFirstNewTag: TPaintTag;
var i: Integer;
begin
    if ActiveTags.Count > 0 then
        Result := TPaintTag(Activetags[0])
    else
        Result := Nil;

    for i := 1 to Activetags.Count - 1 do
        if TPainttag(Activetags[i]).BreadCrumbIndex = High(Integer) then
        begin
            result := TPainttag(Activetags[i]);
            break;
        end;
end;




procedure TTagCloud.ShowTags;//(aListView: TListView);
var i: Integer;
    newItem: TListItem;
    m: Integer;
begin

    MouseOverTag := Nil;
    FocussedTag  := Nil;

    CloudPainter.Paint(CurrentTagList);

    FocussedTag := GetFirstNewTag;

    if assigned(FocussedTag) then
        FocussedTag.PaintFocussed(CloudPainter.Canvas);


  {  aListView.Items.BeginUpdate;
    aListView.Clear;

    m := Activetags.Count - 1;
    if m > 100 then m := 100;


    for i := 0 to m do
    begin
        if  TTag(Activetags[i]).count >0 then
        begin
            newItem := aListView.Items.Add;
            newItem.Caption := TTag(Activetags[i]).Key + ' (' + Inttostr(TTag(Activetags[i]).count) + ')';
            newItem.Data := TTag(Activetags[i]);
        end;

    end;
    aListView.Items.EndUpdate;
   }
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
procedure TTagCloud.BuildCloud(Source: TObjectList; aTag: TTag; FromScratch: Boolean);
var i,j: Integer;
    //backupList: TObjectList;
    properList: TObjectList;
begin
    if FromScratch then
    begin
        // We start complete new. Delete Browse-History.
        // BrowseHistory.Clear;
        ClearBreadCrumbs(-1);
        Tags.Extract(fClearTag);
        properList := Source;
        fBreadCrumbDepth := 0;
        if Not assigned(HashedTags[0,0]) then
        begin
            // This should be done only once per Nemp-Instance!
            for i := 0 to 31 do
              for j := 0 to 31 do
                HashedTags[i,j] := TObjectList.Create(False);
        end;
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
                Tags.Extract(fClearTag);
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
                    if fBreadCrumbDepth = 0 then
                        Tags.Add(fClearTag);

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
    {

    if assigned(aTag) then
    begin
        // Create a new List and store the Audiofiles from the clicked Tag
        // in this list.
        backupList := TObjectList.Create(False);
        backupList.Capacity := Source.Count;

        for i := 0 to Source.Count - 1 do
            backupList.Add(Source[i]);

        // Add the List to the BrowseHistory
        BrowseHistory.Add(backUpList);
    end
    else
    begin
        // user clicked a Breadcrumb-Tag... ????
        /// .... todo
        backupList := Source;
    end;

     }

    try
        // Clear the cloud, i.e. set the Count of all Tags to Zero
        Reset;

        // Insert Files into the new Cloud
        for i := 0 to properList.Count - 1 do
            AddAudioFile(TAudioFile(properList[i]));

        // Sort Tags by Count
        Tags.Sort(Sort_Count);

         self.SetActivetags;


        // Copy Tags with Count > 0 to Currenttag-List ???



        // todo: Clear the "BrowseTags", i.e. the previously clicked tags
    finally
       // if assigned(aTag) then
       //     backupList.Free;
    end;

end;

{
    --------------------------------------------------------
    GetTag
    - Search the TTags for a specified key
    - Create a new Tag if no Tag with this key exists
    --------------------------------------------------------
}

function TTagCloud.GetTag(aKey: UTF8String): TTag;
var i: Integer;
    tmp: TTag;
    KeyHashList: TObjectList;
    x,y: Integer;
begin
    tmp := Nil;

    // Note: The Tag-Finding should be done much more efficient!
    // Use a aKey[1] and aKey[2] AND 31 to Hash the key into a 32x32 Array of TObjectList
    // and search only this List.
    // in Addition: Move the found key upwards , so that often used keys can be found faster.

    aKey := AnsiLowerCase(aKey);

    // Hash the first two Chars of aKey
    x := 0;
    y := 0;
    if length(aKey) > 0 then
        x := Ord(aKey[1]) mod 32;
    if length(aKey) > 1 then
        y := Ord(aKey[2]) mod 32;

    KeyHashList := HashedTags[x,y];


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
        result := TPaintTag.Create(aKey);
        // Add the new tag to the Taglist // todo !!! and the correct list in the Array of Lists!
        Tags.Add(result);
        KeyHashList.Add(result);
    end;
end;



procedure TTagCloud.NavigateCloud(aKey: Word);
begin
    case aKey of
        vk_up:    FocussedTag := GetUpTag;
        vk_Down:  FocussedTag := GetDownTag;
        vk_Left:  FocussedTag := GetLeftTag;
        vk_right: FocussedTag := GetRightTag;
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
    if aAudioFile.Artist <> AUDIOFILE_UNKOWN then
        Dest.Add(aAudioFile.Artist);

    if aAudioFile.Album <> AUDIOFILE_UNKOWN then
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
procedure TTagCloud.AddAudioFileRAWTags(aAudioFile: TAudioFile);
var allTags, tmpTags: TStringList;
    i: Integer;
    aTag: TTag;
begin
    allTags := TStringList.Create;
    tmpTags := TStringList.Create;
    try

        //tmpTags.Text := aAudioFile.RawTagAuto;
        //for i := 0 to tmpTags.Count - 1 do
        //    allTags.Add(tmptags[i]);

        // Generate Auto-Tags from Audiofile-Info
        // ToDo: Settings like "UseYear", "UseDecade", ...
        GenerateAutoRawTags(aAudioFile, allTags);

        // Add the Tags from the two RawTag-Strings to allTag-List
        tmpTags.Text := aAudioFile.RawTagLastFM;
        for i := 0 to tmpTags.Count - 1 do
            allTags.Add(tmptags[i]);

        tmpTags.Text := aAudioFile.RawTagUserDefined;
        for i := 0 to tmpTags.Count - 1 do
            allTags.Add(tmptags[i]);


        // Add/Insert every Tag into the af.TagList
        for i := 0 to allTags.Count - 1 do
        begin
            aTag := GetTag(allTags[i]);
            // ensure Uniquness - check whether the tag was just added to this file
            if  (aTag.BreadCrumbIndex = High(Integer)) AND
                ((aTag.count = 0) or (TAudioFile(aTag.AudioFiles[aTag.count-1]) <> aAudioFile))
            then
            begin
                // Add the AudioFile into the Filelist of the Tag
                aTag.AudioFiles.Add(aAudioFile);
                // Add the Tag into the Taglist of the AudioFile
                aAudioFile.Taglist.Add(aTag);


                // if aTag.count = 1 then AddTag to "currenttagCloudList"
                // NO. We dont need the Tags of Previous Clouds, but the List of AudioFiles
                //   => Backup these in BuildCloud
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

procedure TTagCloud.DeleteAudioFile(aAudioFile: TAudioFile);
begin
    // Todo
end;



procedure TTagCloud.UpdateAudioFile(aAudioFile: TAudioFile);
begin
     // ToDo
end;

{ TPaintTag }

constructor TPaintTag.Create(aKey: UTF8String);
begin
    inherited Create(aKey);
    fColor := clBlack;
    fActiveColor := clRed;

    fFocusColor := clGray;
    fFocusBorderColor := clBlue;

    fHover := False;
    fFocussed := False;

end;

procedure TPaintTag.MeasureOutput(aCanvas: TCanvas);
begin
    aCanvas.Font.Size := FontSize;
    fWidth := aCanvas.TextWidth(Key);
    fHeight := aCanvas.TextHeight(Key);
end;

procedure TPaintTag.Paint(aCanvas: TCanvas);
begin
    if not (fFocussed or fHover) then
        PaintNormal(aCanvas)
    else
        if self.fFocussed then
            PaintFocussed(aCanvas)
        else
            PaintActive(aCanvas);
end;

procedure TPaintTag.PaintNormal(aCanvas: TCanvas);
begin
    aCanvas.Brush.Color := clWhite;

    aCanvas.Font.Color := fColor;
    aCanvas.Font.Style := [];
    aCanvas.Font.Size := FontSize;
    aCanvas.TextOut(fLeft, fTop, Key);
end;


procedure TPaintTag.PaintActive(aCanvas: TCanvas);
begin
    aCanvas.Brush.Color := clWhite;

    aCanvas.Font.Color := fActiveColor;
    aCanvas.Font.Style := [fsUnderline];
    aCanvas.Font.Size := FontSize;
    aCanvas.TextOut(fLeft, fTop, Key);
end;

procedure TPaintTag.PaintFocussed(aCanvas: TCanvas);
begin
    aCanvas.Font.Color := fFocusColor;
    aCanvas.Brush.Color := fFocusBorderColor;
    aCanvas.Font.Style := [];
    aCanvas.Font.Size := FontSize;
    aCanvas.TextOut(fLeft, fTop, Key);
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
    if Tags.Count > 1 then
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

        x := x + pt.Width + fGap + 10;
    end;

end;

{ TCloudPainter }

constructor TCloudPainter.Create;
begin
    TagLines := TObjectList.Create;
    Tags := TObjectList.Create(False);
end;

destructor TCloudPainter.Destroy;
begin
    TagLines.Free;
    Tags.Free;
    inherited;
end;


procedure TCloudPainter.DoPaint;
var y, i: Integer;

begin
    canvas.Brush.Color := ClWhite;
    canvas.Brush.Style := bsSolid;
    Canvas.FillRect(Rect(0,0,width, Height));

    y := 0;
    for i := 0 to TagLines.Count - 1 do
    begin
        TTagLine(Taglines[i]).Top := y;
        TTagLine(Taglines[i]).Paint(Canvas);
        y := y + TTagLine(Taglines[i]).Height;
    end;
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
        result := 12;

  { result :=  round(

   FontFactor * (maxCount - aTag.count)) + 20;

   if result < 8 then
      result := 8;

   if result > 20 then
      result := 20;

      }

end;


function TCloudPainter.GetTagAtMousePos(x, y: Integer): TPaintTag;
var line: TTagLine;
  i: Integer;
begin
    result := Nil;

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
begin
    Tags.Clear;
    CanvasFull := False;
    i := 0;
    x := 0;     // current x-Position
    y := 0;     // current y-Position
    lineHeight := 0;   // Height of the current "line"

//    if Source.Count > 1 then
//        maxCount := TTag(Source[1]).count;

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
    // FontFactor := - 12 *4 / (3 * maxCount);

    while (i < Source.Count) and Not CanvasFull do
    begin
        aTag := TPaintTag(Source[i]);
        // Set the FontSize used to display the tag          // !!!!!!!!!!!!!!!!!!!!!!!
        aTag.FontSize := GetProperFontSize(aTag);

        // get the size of the Tag on the Canvas
        aTag.MeasureOutput(Canvas);

        if (x + aTag.Width <= Width) or (x = 0) then
        begin
            // Tag fits in the current line
            x := x + aTag.Width + 10;     // add some space
            lineHeight := max(lineHeight, aTag.Height);
            Tags.Add(aTag);
        end else
        begin
            // Tag does NOT fit in the current line => start a new one
            y := y + lineHeight;

            if (y + aTag.Height < Height - 8) then
            begin
                lineHeight := aTag.Height;
                x := aTag.Width + 10;
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

    currentLine := TTagLine.Create(Width);
    TagLines.Add(currentLine);

    //for i := 0 to Tags.Count - 1 do
    while (i < Tags.Count) and Not CanvasFull do
    begin
        currentTag := TPaintTag(Tags[i]);
        if (x + currentTag.Width <= Width) or (x = 0) then
        begin
            // Tag fits in currentLine
            currentLine.Tags.Add(currentTag);
            currentTag.fLine := currentLine;
            currentLine.fHeight := max(currentLine.Height, currentTag.Height);
            currentLine.fWidth := currentLine.Width + currentTag.Width + 10;
            x := x + currentTag.Width + 10;
        end else
        begin
            // line is full. We need to start a new line
            // But: Maybe the currentline was to high for Canvas!
            if y + currentLine.Height > Height - 8 then
            begin
                // currentline has grown to much in Height
                // and so it cannot be painted on the canvas
                CanvasFull := True;
                Fail := True;
            end else
            begin
                SuccessfullyPaintItems := i-1;  // last line can be painted

                y := y + currentLine.Height;
                currentLine := TTagLine.Create(Width);
                TagLines.Add(currentLine);
                currentLine.Tags.Add(currentTag);
                currentTag.fLine := currentLine;
                currentLine.fHeight := currentTag.Height;
                currentLine.fWidth := currentLine.Width + currentTag.Width + 10;
                x := currentTag.Width + 10;
            end;
        end;
        inc(i);
    end;

    if y + currentLine.Height > Height - 8 then
        Fail := True;

    if Fail then
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

end;

end.
