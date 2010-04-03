{

    Unit TagHelper

    A class for merging/editing tags from lastfm

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2009, Daniel Gaussmann
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

    Additional permissions

    If you modify this Program, or any covered work, by linking or combining it
    with
        - the bass.dll and it addons
          (including, but not limited to the bass_fx.dll)
        - MadExcept
        - DGL-OpenGL
        - FSPro Windows 7 Taskbar Components
    or a modified version of these libraries, the licensors of this Program
    grant you additional permission to convey the resulting work.

    ---------------------------------------------------------------
}

unit Taghelper;

interface

uses windows, classes, SysUtils, Contnrs, Messages, IniFiles, strUtils, dialogs;

type

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


    TTagPostProcessor = class
        private
            fSavePath: String;         // Path for saving files
            fDefaultPath: String;      // Nemp-Path for Default-Files

            fIgnoreList: TStringList;  // List of Tag-Keys to ignore
            fMergeList: TObjectList;   // List of TTagMergeItems


            procedure AddRawMergeString(aString: String);

            // Search the Lists for a matching key
            function IgnoreTagExists(aKey: String):Boolean;
            function MergeTagExists(aOriginalKey, aReplaceKey: String): Boolean;
            function IndexOfMergeTag(aOriginalKey, aReplaceKey: String): Integer;

        public

            property IgnoreList: TStringList read fIgnoreList;
            property MergeList: TObjectList read fMergeList;

            constructor Create;
            destructor Destroy; override;

            procedure LoadFiles;   // Load Data from the files
            procedure SaveFiles;   // Save Data back to the files

            // Add new Tag to Ignore/Merge
            // result: False if Tag already existed
            function AddIgnoreTag(aKey: String): Boolean;
            function AddMergeTag(aOriginalKey, aReplaceKey: String): Boolean;

            // delete a Tag from the List
            procedure DeleteIgnoreTag(aKey: String);
            procedure DeleteMergeTag(aOriginalKey, aReplaceKey: String);
    end;

const

    Def_IgnoreList = 'default_tag_ignore' ;
    Def_MergeList  = 'default_tag_merge'  ;
    Usr_IgnoreList = 'tag_ignore' ;
    Usr_MergeList  = 'tag_merge'  ;

function Sort_OriginalKey(item1, item2: Pointer): Integer;
function Sort_OriginalKey_DESC(item1, item2: Pointer): Integer;
function Sort_ReplaceKey(item1, item2: Pointer): Integer;
function Sort_ReplaceKey_DESC(item1, item2: Pointer): Integer;


implementation

uses Systemhelper, Nemp_ConstantsAndTypes;


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
    if AnsiStartsText(GetShellFolder(CSIDL_PROGRAM_FILES), Paramstr(0)) then
        fSavePath := GetShellFolder(CSIDL_APPDATA) + '\Gausi\Nemp\'
    else
        fSavePath := ExtractFilePath(ParamStr(0)) + 'Data\';

    fDefaultPath := ExtractFilePath(ParamStr(0)) + 'Data\';

    fIgnoreList := TStringList.Create;
    fIgnoreList.CaseSensitive := False;
    fIgnoreList.Sorted := True;
    fMergeList := TObjectList.Create;
end;

destructor TTagPostProcessor.Destroy;
begin
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

procedure TTagPostProcessor.SaveFiles;
var tmpList: TStringList;
    i: Integer;
    s: String;
begin
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
end;

{
    --------------------------------------------------------
    IgnoreTagExists, MergeTagExists
    - Search the Lists for a matchin key
    --------------------------------------------------------
}
function TTagPostProcessor.IgnoreTagExists(aKey: String): Boolean;
begin
    result := fIgnoreList.IndexOf(aKey) >= 0;
end;

function TTagPostProcessor.IndexOfMergeTag(aOriginalKey,
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

function TTagPostProcessor.MergeTagExists(aOriginalKey,
  aReplaceKey: String): Boolean;
begin
    result := IndexOfMergetag(aOriginalKey, aReplaceKey) >= 0;
end;

{
    --------------------------------------------------------
    AddIgnoreTag, AddMergeTag
    - Add Ignore/Mergetag to the lists
    --------------------------------------------------------
}
function TTagPostProcessor.AddIgnoreTag(aKey: String): Boolean;
begin
    if not IgnoreTagExists(aKey) then
    begin
        fIgnoreList.Add(aKey);
        result := True;
    end
    else
        result := False;
end;
function TTagPostProcessor.AddMergeTag(aOriginalKey,
  aReplaceKey: String): Boolean;
begin
    if not MergeTagExists(aOriginalKey, aReplaceKey) then
    begin
        fMergeList.Add(TTagMergeItem.Create(aOriginalKey, aReplaceKey));
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
    idx := IndexOfMergeTag(aOriginalKey, aReplaceKey);
    if idx >= 0 then
        fMergeList.Delete(idx);
end;


end.
