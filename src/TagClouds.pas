unit TagClouds;

interface

uses windows, classes, SysUtils,  Contnrs, AudioFileClass, Math, stdCtrls;

type

  TTagCloud = class
      private
          // the main list with all Tags in the Cloud.
          Tags: TObjectList;

          // A list of TObjectlists with AudioFiles
          BrowseHistory: TObjectList;


          // Get a TTag-Object with a matching key
          function GetTag(aKey: UTF8String): TTag;

          // Insert all Tags from the AudioFile into the Taglist
          procedure AddAudioFileTags(aAudioFile: TAudioFile);

          // Generate a TagList from RawTag-Strings of the Audiofile.
          procedure AddAudioFileRAWTags(aAudioFile: TAudioFile);

          // Set Default-RawTags (like genre, artist, year)
          procedure GenerateAutoRawTags(aAudioFile: TAudioFile; Dest: TStringList);


      public

        constructor Create;
        destructor Destroy; override;

        // Build a Tag-Cloud for the AudioFiles given in Source
        procedure BuildCloud(Source: TObjectList; aTag: TTag);

        procedure ShowTags(aMemo: TMemo);

        // Add a file to the TagCloud
        procedure AddAudioFile(aAudioFile: TAudioFile);

        // Delete a File from the Cloud
        procedure DeleteAudioFile(aAudioFile: TAudioFile);

        // Update a File (change the Tags) in the Cloud
        procedure UpdateAudioFile(aAudioFile: TAudioFile);

        // Reset the Tag to zero, i.e. Clear the Tag.AudioFileList
        procedure Reset;



  end;


function Sort_Count(item1,item2:pointer):integer;

implementation


function Sort_Count(item1,item2:pointer):integer;
begin
    result := CompareValue(TTag(item2).Count ,TTag(item1).Count);

    if result = 0 then
        result := AnsiCompareText(TTag(item1).Key ,TTag(item2).Key);



end;



{ TTagCloud }


constructor TTagCloud.Create;
begin
    Tags := TObjectList.Create;
end;

destructor TTagCloud.Destroy;
begin
    Tags.free;
    inherited;
end;



procedure TTagCloud.Reset;
var i: Integer;
begin
    // Reset the Tag-Counter to zero
    // so we can build a new Cloud.
    // But we do not need to rebuild AudioFile.Taglist by parsing RawTags as
    // the Tag-Objects are still there!
    for i := 0 to Tags.Count - 1 do
       (Tags[i] as TTag).AudioFiles.Clear;
end;



procedure TTagCloud.ShowTags(aMemo: TMemo);
var i: Integer;
begin

    aMemo.Clear;
    for i := 0 to Tags.Count - 1 do
      aMemo.lines.Add(TTag(Tags[i]).Key + ' (' + Inttostr(TTag(Tags[i]).count) + ')' );
end;

{
    --------------------------------------------------------
    BuildCloud
    - Clear alltags.AudioFiles
    - Add all AdioFiles from the List into the Cloud
    If the SourceList is aTag.AudioFiles, we need to backup these Files
    --------------------------------------------------------
}
procedure TTagCloud.BuildCloud(Source: TObjectList; aTag: TTag);
var i: Integer;
    backupList: TObjectList;
begin
    if assigned(aTag) then
        backupList := TObjectList.Create(False)
    else
        backupList := Source;


    {
    change:
    If aTag = Nil: Cloud of whole library - no backup of the List

    else
        if Tag in BreadCrumb: Load old AudioFile-List (Source should be Nil then)

        else // New tag clicked
            Store List in AudioFilesBackups


    }

    try
        if assigned(aTag) then
        begin
            // backup the source, as we will clear it ...
            backupList.Capacity := Source.Count;
            for i := 0 to Source.Count - 1 do
                backupList.Add(Source[i])
        end;

        Reset;    // ... here ;-)

        // Insert Files into the new Cloud
        for i := 0 to backupList.Count - 1 do
            AddAudioFile(TAudioFile(backupList[i]));


        // Sort Tags by Count
        Tags.Sort(Sort_Count);

        // todo: Clear the "BrowseTags", i.e. the previously clicked tags

    finally
        if assigned(aTag) then
            backupList.Free;
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
begin
    tmp := Nil;

    // Note: The Tag-Finding should be done much more efficient!
    // Use a aKey[1] and aKey[2] AND 31 to Hash the key into a 32x32 Array of TObjectList
    // and search only this List.
    // in Addition: Move the found key upwards , so that often used keys can be found faster.

    for i := 0 to Tags.Count - 1 do
        if TTag(Tags[i]).Key = aKey then
        begin
            tmp := TTag(Tags[i]);
            break;
        end;

    if assigned(tmp) then
        result := tmp
    else
    begin
        result := TTag.Create(aKey);
        // Add the new tag to the Taglist // todo !!! and the correct list in the Array of Lists!
        Tags.Add(result);
    end;
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

    if aAudioFile.Year <> '0' then
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

    // Save these Auto-Tags
    aAudioFile.RawTagAuto := Dest.Text;

    // ToDo: MedienBib.Changed := True; ??
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
        // Add the Tags from the three RawTag-Strings to allTag-List
        tmpTags.Text := aAudioFile.RawTagAuto;
        for i := 0 to tmpTags.Count - 1 do
            allTags.Add(tmptags[i]);

        tmpTags.Text := aAudioFile.RawTagLastFM;
        for i := 0 to tmpTags.Count - 1 do
            allTags.Add(tmptags[i]);

        tmpTags.Text := aAudioFile.RawTagUserDefined;
        for i := 0 to tmpTags.Count - 1 do
            allTags.Add(tmptags[i]);

        // if no Tags were found: Generate some from other properties
        if allTags.Count = 0 then
            GenerateAutoRawTags(aAudioFile, allTags);


        // Add/Insert every Tag into the af.TagList
        for i := 0 to allTags.Count - 1 do
        begin
            aTag := GetTag(allTags[i]);
            // ensure Uniquness - check whether the tag was just added to this file
            if  (aTag.count = 0) or (TAudioFile(aTag.AudioFiles[aTag.count-1]) <> aAudioFile) then
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
var i: Integer;
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

end.
