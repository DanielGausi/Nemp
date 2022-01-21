{

    Unit TagHelper

    A class for merging/editing tags from lastfm

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 200-2019, Daniel Gaussmann
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

unit Taghelper;

interface

uses windows, classes, SysUtils, Contnrs, Messages, IniFiles, strUtils, dialogs,
  NempAudioFiles, System.Types, System.UITypes,
  System.Generics.Collections, System.Generics.Defaults;

// Flag constants for consistency-checking
const
    TAGFLAG_DUPLICATE = 1;
    TAGFLAG_IGNORE    = 2;
    // = 4
    // = 8
    // = 16

type

    TTagConsistencyError = (CONSISTENCY_OK,     // everthing is fine
                            CONSISTENCY_HINT,   // some Hints (tag already exists), no user action required
                            CONSISTENCY_WARNING // some warnings, user action recommended
                            );



    TTagError = ( TAGERR_NONE,                      // everthing's fine
                  TAGERR_Consistency,               // some problems with the Ignore/Merge lists
                  TAGERR_AddTagDuplicateFound,      // the (or one of the) tag to add was already in the file
                  TAGERR_AddTagOnlyDuplicatesFound, // all Tags were already in the file
                  TAGERR_AddTagIgnore,              // the new tag is on the "ignore List"
                  TAGERR_AddTagAllIgnore,           // all new tags are on the "ignore List"
                  TAGERR_AddTagMerge               // the new tag sould be renamed to another tag

    );

    TIgnoreTagString = class
    public
      DataString: UnicodeString;
      constructor create(aDataString: String);
    end;

    TTagMergeItem = class
        private
            fOriginalKey: String;
            fReplaceKey: String;
        public
            property OriginalKey: String read fOriginalKey;
            property ReplaceKey : String read fReplaceKey;
            constructor Create(OriginalKey, ReplaceKey: String);
    end;

    TIgnoreTagStringList = class(TObjectList<TIgnoreTagString>);
    TTagMergeItemList = class(TObjectList<TTagMergeItem>);


    TTagPostProcessor = class
        private
            fSavePath: String;         // Path for saving files
            fDefaultPath: String;      // Nemp-Path for Default-Files

            fIgnoreList: TStringList;  // List of Tag-Keys to ignore
            fMergeList: TObjectList;   // List of TTagMergeItems

            fLogList: TStrings;    // LogList for warnings from the consistency check


            procedure AddRawMergeString(aString: String);

            // Search the Lists for a matching key
            function fIgnoreTagExists(aKey: String):Boolean;
            function fMergeTagExists(aOriginalKey, aReplaceKey: String): Boolean;
            function fIndexOfMergeTag(aOriginalKey, aReplaceKey: String): Integer;

        public

            property IgnoreList: TStringList read fIgnoreList;
            property MergeList: TObjectList read fMergeList;
            property LogList: TStrings read fLogList;

            constructor Create;
            destructor Destroy; override;

            procedure LoadFiles;   // Load Data from the files
            procedure SaveFiles(silent: Boolean = True);   // Save Data back to the files

            function AddIgnoreRuleConsistencyCheck(newIgnoreTag: String): TTagConsistencyError;
            function AddMergeRuleConsistencyCheck(newOriginalTag, newReplaceTag: String): TTagConsistencyError;

            function AddIgnoreRule(newIgnoreTag: String; IgnoreWarnings: Boolean): Boolean;
            function AddMergeRule(newOriginalTag: string; var newReplaceTag: String; IgnoreWarnings: Boolean): Boolean;

            // delete a Tag from the List
            procedure DeleteIgnoreTag(aKey: String);
            procedure DeleteMergeTag(aOriginalKey, aReplaceKey: String);

            // check, whether aKey is in the Merge list and returns the replace-value
            //function GetRenamedTag(aKey: String): String;
    end;

const

    Def_IgnoreList = 'default_tag_ignore' ;
    Def_MergeList  = 'default_tag_merge'  ;
    Usr_IgnoreList = 'tag_ignore' ;
    Usr_MergeList  = 'tag_merge'  ;

// same as medienbib.addnewtag
//function ControlRawTag(af: TAudioFile; newTags: String;
//      aIgnoreList: TStringList; aMergeList: TObjectList): String;

function Sort_OriginalKey(item1, item2: Pointer): Integer;
function Sort_OriginalKey_DESC(item1, item2: Pointer): Integer;
function Sort_ReplaceKey(item1, item2: Pointer): Integer;
function Sort_ReplaceKey_DESC(item1, item2: Pointer): Integer;

function CommasInString(aString: String): Boolean;
function ReplaceCommasbyLinebreaks(aString: String): String;
function GetRenamedTag(aKey: String; aMergeList: tObjectList): String;


implementation

uses Systemhelper, Nemp_ConstantsAndTypes, OneInst, Nemp_RessourceStrings;


function Sort_OriginalKey(item1, item2: Pointer): Integer;
begin
    result := AnsiCompareText(TTagMergeItem(item1).OriginalKey ,TTagMergeItem(item2).OriginalKey);
    if result = 0 then
        result := AnsiCompareText(TTagMergeItem(item1).ReplaceKey ,TTagMergeItem(item2).ReplaceKey);
end;
function Sort_OriginalKey_DESC(item1, item2: Pointer): Integer;
begin
    result := AnsiCompareText(TTagMergeItem(item2).OriginalKey ,TTagMergeItem(item1).OriginalKey);
    if result = 0 then
        result := AnsiCompareText(TTagMergeItem(item2).ReplaceKey ,TTagMergeItem(item1).ReplaceKey);
end;
function Sort_ReplaceKey(item1, item2: Pointer): Integer;
begin
    result := AnsiCompareText(TTagMergeItem(item1).ReplaceKey ,TTagMergeItem(item2).ReplaceKey);
    if result = 0 then
        result := AnsiCompareText(TTagMergeItem(item1).OriginalKey ,TTagMergeItem(item2).OriginalKey);
end;
function Sort_ReplaceKey_DESC(item1, item2: Pointer): Integer;
begin
    result := AnsiCompareText(TTagMergeItem(item2).ReplaceKey ,TTagMergeItem(item1).ReplaceKey);
    if result = 0 then
        result := AnsiCompareText(TTagMergeItem(item2).OriginalKey ,TTagMergeItem(item1).OriginalKey);
end;

function CommasInString(aString: String): Boolean;
//var i, c: integer;
begin
    //change 2017: Do not allow a single comma in tags
    result := pos(',', aString) <> 0;
    //c := 0;
    //for i := 1 to length(aString) do
    //    if aString[i] = ',' then
    //        inc(c);
    // Idea: more than one comma or  only one and short string may
    // indicate an comma-separated input of tags.
    // result := (c >= 2) or ((c > 0) and (length(aString) < 15));
end;

function ReplaceCommasbyLinebreaks(aString: String): String;
var sl: TStringList;
    i: integer;
begin
    result := Stringreplace(aString, ',', #13#10, [rfReplaceAll]);
    sl := TStringList.Create;
    try
        sl.Text := result;
        // trim lines
        for i := 0 to sl.Count - 1 do
            sl[i] := Trim(sl[i]);
        // delete empty lines
        for i := sl.Count - 1 downto 0 do
            if sl[i] = '' then
                sl.Delete(i);

        result := sl.Text;
    finally
        sl.Free;
    end;
end;

// used in threaded and non-threaded methods
function GetRenamedTag(aKey: String; aMergeList: tObjectList): String;
var i: integer;
    aItem: TTagMergeItem;
begin
    result := '';
    for i := 0 to aMergeList.Count - 1 do
    begin
        aItem := TTagMergeItem(aMergeList[i]);
        if SameText(aItem.fOriginalKey, aKey) then
        begin
            result := aItem.fReplaceKey;
            break;
        end;
    end;
end;

{
    --------------------------------------------------------
    ControlRawtag
    // replaced with medienbib.addNewTag
    - Correct RawTags from lastFM
      af: Current AudioFile
      newTags: String with new tags (result from LastFM)
      aIgnorelist, aMergeList: Data how to change newTags
      Result: The new #13#10-seperated TagString, including the old ones
    --------------------------------------------------------

function ControlRawTag(af: TAudioFile; newTags: String;
  aIgnoreList: TStringList; aMergeList: TObjectList): String;
var oldTagList, newTagList: TStringList;
    i: Integer;
    aMergeItem: tTagMergeItem;

        function GetMatchingMergeItem(aKey: String): TTagMergeItem;
        var i: Integer;
        begin
            result := Nil;
            for i := 0 to aMergeList.Count - 1 do
            begin
                if AnsiSameText(TTagMergeItem(aMergeList[i]).OriginalKey, aKey) then
                begin
                    result := TTagMergeItem(aMergeList[i]);
                    break;
                end;
            end;
        end;

begin
    oldTagList := TStringList.Create;
    newTagList := TStringList.Create;
    try
        oldTagList.Text := String(af.RawTagLastFM);
        newTagList.Text := newTags;

        // 1.) delete duplicates, i.e. new tags, that are already there
        for i := newTagList.Count - 1 downto 0 do
            if oldTagList.IndexOf(newTagList[i]) >= 0 then
                newTagList.Delete(i);

        // 2.) delete ignored tags
        for i := newTagList.Count - 1 downto 0 do
            if aIgnoreList.IndexOf(newTagList[i]) >= 0 then
                newTagList.Delete(i);

        // 3.) Change Tags as described in aMergeList
        for i := 0 to newTagList.Count - 1 do
        begin
            aMergeItem := GetMatchingMergeItem(newTagList[i]);
            if assigned(aMergeItem) then
                // change key
                newTagList[i] := aMergeItem.ReplaceKey;
        end;

        // 4.) Add new Tags to oldTagList, check for duplicates EVERY time,
        //     as by 3.) we could have generated duplicates again.
        for i := 0 to newTagList.Count - 1 do
        begin
            if oldTagList.IndexOf(newTagList[i]) = -1 then
                oldTagList.Add(newtagList[i]);
        end;

        result := trim(oldTagList.Text);
    finally
        oldTagList.Free;
        newTagList.Free;
    end;
end;
}

{ TIgnoreTagString }

constructor TIgnoreTagString.create(aDataString: String);
begin
    DataString := aDataString;
end;


{ TTagMergeItem }

constructor TTagMergeItem.Create(OriginalKey, ReplaceKey: String);
begin
    inherited create;
    fOriginalKey := OriginalKey;
    fReplaceKey  := ReplaceKey;
end;



{ TTagPostProcessor }

{
    --------------------------------------------------------
    Create
    - Create the lists
    - Set Paths
    --------------------------------------------------------
}
constructor TTagPostProcessor.Create;
begin
    inherited create;
    // determine path for saving (and loading) files
    if UseUserAppData then
        fSavePath := GetShellFolder(CSIDL_APPDATA) + '\Gausi\Nemp\'
    else
        fSavePath := ExtractFilePath(ParamStr(0)) + 'Data\';

    fDefaultPath := ExtractFilePath(ParamStr(0)) + 'Data\';

    fIgnoreList := TStringList.Create;
    fIgnoreList.CaseSensitive := False;
    fIgnoreList.Sorted := True;
    fMergeList := TObjectList.Create;
    fLogList := TStringlist.Create;

    LoadFiles;
end;

destructor TTagPostProcessor.Destroy;
begin
    SaveFiles;
    fLogList.Free;
    fIgnoreList.Free;
    fMergeList.Free;
    inherited;
end;

{
    --------------------------------------------------------
    AddRawMergeString
    - Parse a string like 'key1@@key2' and add a matching
      TTagMergeItem to fMergeList
    --------------------------------------------------------
}
procedure TTagPostProcessor.AddRawMergeString(aString: String);
var a: Integer;
    s1, s2: String;
begin
    a := pos('@@', aString);
    if a > 1 then  // > 1, as we must have at least one char before the '@@'
    begin
        s1 := trim(copy(aString, 1, a-1));
        s2 := trim(copy(aString, a+2, length(aString))); // the rest of aString

        if (s1 <> '') and (s2 <> '') then
            fMergeList.Add(TTagMergeItem.Create(s1, s2));

        // {for testing} showmessage(aString + #13#10 + s1 + #13#10 + s2 ) ;
    end;
end;

{
    --------------------------------------------------------
    LoadFiles
    - Loadfiles, uses default-files if user-files are not found
    --------------------------------------------------------
}
procedure TTagPostProcessor.LoadFiles;
var tmpList: TStringList;
    i: Integer;
begin
    // 1. Ignore-List
    // --------------
    fIgnoreList.Sorted := False;
    if FileExists(fSavePath + Usr_IgnoreList) then
        // User defined list exists
        fIgnoreList.LoadFromFile(fSavePath + Usr_IgnoreList)
    else
    begin
        // UsrList does not exist
        // Load default list
        if FileExists(fDefaultPath + Def_IgnoreList) then
            fIgnoreList.LoadFromFile(fDefaultPath + Def_IgnoreList)
        else
            // No List found at all - clear list (just to be sure)
            fIgnoreList.Clear;
    end;
    fIgnoreList.Sorted := True;

    // 2. Merge-List
    // --------------
    tmpList := TStringList.Create;
    try
        // clear old list
        fMergeList.Clear;

        // load new list
        if FileExists(fSavePath + Usr_MergeList) then
            // User defined list exists
            tmpList.LoadFromFile(fSavePath + Usr_MergeList)
        else
        begin
            // UsrList does not exist
            // Load default list
            if FileExists(fDefaultPath + Def_MergeList) then
                tmpList.LoadFromFile(fDefaultPath + Def_MergeList)
            // else
            //    Nothing to do here
        end;
        for i := 0 to tmpList.Count - 1 do
        begin
            AddRawMergeString(tmpList[i]);
        end;
    finally
        tmpList.Free;
    end;
end;

procedure TTagPostProcessor.SaveFiles(silent: Boolean = True);
var tmpList: TStringList;
    i: Integer;
    s: String;
begin
    try
        ForceDirectories(fSavePath);

        // 1. IgnoreList
        // --------------
        fIgnoreList.SaveToFile(fSavePath + Usr_IgnoreList, TEncoding.UTF8);

        // 2. MergeList
        // --------------
        tmpList := TStringList.Create;
        try
            // build strings "<key1>@@<key2>"
            for i := 0 to fMergelist.Count - 1 do
            begin
                s := TTagMergeItem(fMergeList[i]).fOriginalKey
                    + '@@'
                    + TTagMergeItem(fMergeList[i]).fReplaceKey;
                tmpList.Add(s);
            end;
            // save the @@-List
            tmpList.SaveToFile(fSavepath + Usr_MergeList, TEncoding.UTF8);
        finally
            tmpList.Free;
        end;
    except
      on e: Exception do
          if not Silent then
              MessageDLG(E.Message, mtError, [MBOK], 0)
  end;
end;

{
    --------------------------------------------------------
    IgnoreTagExists, MergeTagExists
    - Search the Lists for a matchin key
    --------------------------------------------------------
}
function TTagPostProcessor.fIgnoreTagExists(aKey: String): Boolean;
begin
    result := fIgnoreList.IndexOf(aKey) >= 0;
end;

function TTagPostProcessor.fIndexOfMergeTag(aOriginalKey,
  aReplaceKey: String): Integer;
var i: integer;
    aItem: TTagMergeItem;
begin
    result := -1;
    for i := 0 to fMergeList.Count - 1 do
    begin
        aItem := TTagMergeItem(fMergeList[i]);
        if SameText(aItem.fOriginalKey, aOriginalKey)
            and SameText(aItem.fReplaceKey, aReplaceKey)
        then
        begin
            result := i;
            break;
        end;
    end;
end;

function TTagPostProcessor.fMergeTagExists(aOriginalKey,
  aReplaceKey: String): Boolean;
begin
    result := fIndexOfMergetag(aOriginalKey, aReplaceKey) >= 0;
end;

{
    --------------------------------------------------------
    AddIgnoreTag, AddMergeTag
    - Add Ignore/Mergetag to the lists
    --------------------------------------------------------
}

function TTagPostProcessor.AddIgnoreRuleConsistencyCheck(newIgnoreTag: String): TTagConsistencyError;
var aItem: TTagMergeItem;
    i: Integer;
begin
    // newIgnoreTag should be a single tag without commas
    result := CONSISTENCY_OK;
    LogList.Clear;

    // if IgnoreTagExists(newIgnoreTag) then // ok, fine. just don't add it again later

    for i := 0 to fMergeList.Count - 1 do
    begin
        aItem := TTagMergeItem(fMergeList[i]);

        // -a, a->b exists
        if SameText(aItem.fOriginalKey, newIgnoreTag) then
        begin
            result := CONSISTENCY_WARNING;
            LogList.Add(Format(TagManagement_IgnoreTagIsInRenameListOrig, [newIgnoreTag, aItem.fReplaceKey]));
        end;

        // -a, b->a exists
        if SameText(aItem.fReplaceKey, newIgnoreTag) then
        begin
            result := CONSISTENCY_WARNING;
            LogList.Add(Format(TagManagement_IgnoreTagIsInRenameListRename, [newIgnoreTag, aItem.fOriginalKey]));
        end;
    end;
end;

function TTagPostProcessor.AddMergeRuleConsistencyCheck(newOriginalTag, newReplaceTag: String): TTagConsistencyError;
var aItem: TTagMergeItem;
    i: Integer;
begin
    // newOriginalTag and newReplaceTag should be single tags without commas
    result := CONSISTENCY_OK;
    LogList.Clear;

    // check for Ignore-Rules
    // a->b, but -a already exists
    if fIgnoreTagExists(newOriginalTag) then
    begin
        result := CONSISTENCY_WARNING;
        LogList.Add(Format(TagManagement_RenameTagIsInIgnoreList, [newOriginalTag]));
        // solution: remove -a
        //           add a->b
    end;

    // a->b, but -b already exists
    if fIgnoreTagExists(newReplaceTag) then
    begin
        result := CONSISTENCY_WARNING;
        LogList.Add(Format(TagManagement_RenameTagIsInIgnoreList, [newReplaceTag]));
        // solution: remove -b
        //           add a->b
    end;

    // check for existing merge rules
    for i := 0 to fMergeList.Count - 1 do
    begin
        aItem := TTagMergeItem(fMergeList[i]);
        // a->b, and c->b already exists: Everything's fine, a is just another variant of c to replace with b

        // a->b, but b->c exists
        if SameText(newReplaceTag, aItem.fOriginalKey) then
        begin
            result := CONSISTENCY_WARNING;
            LogList.Add(Format(TagManagement_RenameTagIsInMergeListOriginal, [newReplaceTag, aItem.fReplaceKey]));
            // solution: CHANGE input a->b to a->c
        end;

        // a->b, but a->c already exists
        if SameText(newOriginalTag, aItem.fOriginalKey) then
        begin
            result := CONSISTENCY_WARNING;
            LogList.Add(Format(TagManagement_OriginalTagIsInMergeListOriginal, [newOriginalTag, aItem.fReplaceKey]));
            // solution: remove a->c
            //           add a->b
            //      <=>  change a->c to a->b
        end;

        // a->b, but c->a already exists
        if SameText(newOriginalTag, aItem.fReplaceKey) then
        begin
            result := CONSISTENCY_WARNING;
            LogList.Add(Format(TagManagement_OriginalTagIsInMergeListRename, [newOriginalTag, aItem.fOriginalKey]));
            // solution: change c->a to c->b
            //           add a->b
        end;
    end;
end;

function TTagPostProcessor.AddIgnoreRule(newIgnoreTag: String; IgnoreWarnings: Boolean): Boolean;
var aItem: TTagMergeItem;
    i: Integer;
begin
    // newIgnoreTag should be a single tag without commas
    if fIgnoreTagExists(newIgnoreTag) then
        // nothing to do.
        result := False
    else
    begin
        if Not IgnoreWarnings then
        begin
            //resolve Issues, cleanup Merge Lists
            for i := fMergeList.Count - 1 downto 0 do
            begin
                aItem := TTagMergeItem(fMergeList[i]);
                //    -a, a->b exists
                // or -a, b->a exists
                if SameText(aItem.fOriginalKey, newIgnoreTag)
                    OR SameText(aItem.fReplaceKey, newIgnoreTag)
                then
                    // delete existing Merge rule
                    fMergeList.Delete(i);
            end;
        end;

        // actually add the new tag to the ignore list
        result := true;
        fIgnoreList.Add(newIgnoreTag);
    end;
end;


// newReplaceTag is a VAR parameter, as it may be changed during the procedure to resolve inconsistencies
// this must also affect the value of newReplaceTag in the calling method, when other files are updated later
function TTagPostProcessor.AddMergeRule(newOriginalTag: string; var newReplaceTag: String; IgnoreWarnings: Boolean): Boolean;
var aItem: TTagMergeItem;
    flagToDeleteMergeItem: Boolean;
    i: Integer;
begin
    // newOriginalTag and newReplaceTag should be single tags without commas
    if Not IgnoreWarnings then
    begin
        // check for Ignore-Rules
        // a->b, but -a already exists
        if fIgnoreTagExists(newOriginalTag) then
            DeleteIgnoreTag(newOriginalTag);
            // solution: remove -a
            //           add a->b

        // a->b, but -b already exists
        if fIgnoreTagExists(newReplaceTag) then
            DeleteIgnoreTag(newReplaceTag);
            // solution: remove -b
            //           add a->b

        // check for existing merge rules
        for i := fMergeList.Count - 1 downto 0 do
        begin
            aItem := TTagMergeItem(fMergeList[i]);
            flagToDeleteMergeItem := False;
            // a->b, and c->b already exists: Everything's fine, a is just another variant of c to replace with b

            // a->b, but b->c exists
            if SameText(newReplaceTag, aItem.fOriginalKey) then
                newReplaceTag := aItem.fReplaceKey;
                // CHANGE input a->b to a->c           // !!!!!!!!!!!!!!!!!!!!!!!!!!!

            // a->b, but a->c already exists
            if SameText(newOriginalTag, aItem.fOriginalKey) then
                flagToDeleteMergeItem := True;
                // solution: remove a->c
                //           add a->b
                //      <=>  change a->c to a->b

            // a->b, but c->a already exists
            if SameText(newOriginalTag, aItem.fReplaceKey) then
                aItem.fReplaceKey := newReplaceTag;
                // solution: change c->a to c->b
                //           add a->b

            if flagToDeleteMergeItem then
                fMergeList.Delete(i);
        end;
    end;

    // actually add the new rule to the list
    if not fMergeTagExists(newOriginalTag, newReplaceTag) then
    begin
        fMergeList.Add(TTagMergeItem.Create(newOriginalTag, newReplaceTag));
        result := True;
    end
    else
        result := False;

end;

{
    --------------------------------------------------------
    DeleteIgnoreTag, DeleteMergeTag
    - Delete Ignore/Mergetag from the lists
    --------------------------------------------------------
}
procedure TTagPostProcessor.DeleteIgnoreTag(aKey: String);
var idx: integer;
begin
    idx := fIgnoreList.IndexOf(aKey);
    if idx >= 0 then
        fIgnoreList.Delete(idx);
end;

procedure TTagPostProcessor.DeleteMergeTag(aOriginalKey, aReplaceKey: String);
var idx: integer;
begin
    idx := fIndexOfMergeTag(aOriginalKey, aReplaceKey);
    if idx >= 0 then
        fMergeList.Delete(idx);
end;



end.
