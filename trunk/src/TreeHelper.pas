{

    Unit TreeHelper

    - Some Helper for Trees.

    Note: Probably every function/procedure was copied from "the internet", mostly
             www.entwickler-ecke.de
             www.delphipraxis.net
             www.delphi-treff.de
          It is assumed that these functions are kinda "public domain".
          If you want your credits here, give me a notice.

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2005-2010, Daniel Gaussmann
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

uses Windows, Graphics, SysUtils, VirtualTrees, Forms, Controls, AudioFileClass, Types, StrUtils,
  Contnrs, Classes, Jpeg, PNGImage, GifImg,
  Mp3FileUtils, Id3v2Frames, dialogs, Hilfsfunktionen,
  Nemp_ConstantsAndTypes, CoverHelper, MedienbibliothekClass, BibHelper,
  gnuGettext, Nemp_RessourceStrings;


type
  TStringTreeData = record
      FString : TJustaString;
  end;
  PStringTreeData = ^TStringTreeData;

  function LengthToSize(len:integer; def:integer):integer;
  function ModeToStyle(m:Byte):TFontstyles;

  function GetColumnIDfromPosition(aVST:TVirtualStringTree; position:LongWord):integer;
  function GetColumnIDfromContent(aVST:TVirtualStringTree; content:integer):integer;

  function AddVSTString(AVST: TCustomVirtualStringTree; aNode: PVirtualNode; aString: TJustaString): PVirtualNode;
  function AddVSTMp3(AVST: TCustomVirtualStringTree; aNode: PVirtualNode; aAudioFile: TAudioFile): PVirtualNode;
  function AddVDTCover(AVDT: TCustomVirtualDrawTree; aNode: PVirtualNode; aAudioFile: TAudioFile; Complete: Boolean = False): PVirtualNode;

  procedure FillStringTree(Liste: TObjectList; aTree: TVirtualStringTree; Playlist: Boolean = False);
  procedure FillStringTreeWithSubNodes(Liste: TObjectList; aTree: TVirtualStringTree; Playlist: Boolean = False);

  function GetOldNode(aString: UnicodeString; aTree: TVirtualStringTree): PVirtualNode;
  //function GetOldCoverIdx(oldID: String; oldIDX: Integer): Integer;


implementation

USes  NempMainUnit;

// Diese Listen brauche ich bei der Ordner-Ansicht:
// Da gibts ja u.U. mehr Knoten, als ich tatsächlich Ordner habe, um die Unterordner-Struktur mit aufzubauen
var  ZusatzJustaStringsArtists: TObjectlist;
     ZusatzJustaStringsAlben: TObjectlist;



function LengthToSize(len:integer;def:integer):integer;
begin
  with Nemp_MainForm do
  begin
    if len < NempOptions.MaxDauer[1] then result := NempOptions.FontSize[1]
    else if len < NempOptions.MaxDauer[2] then result := NempOptions.FontSize[2]
    else if len < NempOptions.MaxDauer[3] then result := NempOptions.FontSize[3]
    else if len < NempOptions.MaxDauer[4] then result := NempOptions.FontSize[4]
    else  result := NempOptions.FontSize[5]
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


function GetColumnIDfromPosition(aVST:TVirtualStringTree; position:LongWord):integer;
var i:integer;
begin
  result := 0;
  for i:=0 to aVST.Header.Columns.Count-1 do
    if aVST.Header.Columns[i].Position = position then
      result := i;
end;

function GetColumnIDfromContent(aVST:TVirtualStringTree; content:integer):integer;
var i:integer;
begin
  result := 0;
  for i:=0 to aVST.Header.Columns.Count-1 do
    if aVST.Header.Columns[i].Tag = content then
      result := i;
end;

function AddVSTMp3(AVST: TCustomVirtualStringTree; aNode: PVirtualNode; aAudioFile: TAudioFile): PVirtualNode;
var Data: PTreeData;
begin
  Result:= AVST.AddChild(aNode); // meistens wohl Nil

  Data:=AVST.GetNodeData(Result);
  Data^.FAudioFile:=aAudioFile;

  AVST.ValidateNode(Result,false); // validate at the end, as we check FAudioFile on InitNode
end;


function AddVDTCover(AVDT: TCustomVirtualDrawTree; aNode: PVirtualNode; aAudioFile: TAudioFile; Complete: Boolean = False): PVirtualNode;
var Data: PCoverTreeData;
begin
  Result:= AVDT.AddChild(aNode);
  AVDT.ValidateNode(Result,false);

  Data:=AVDT.GetNodeData(Result);
  Data^.Image := TBitmap.Create;


  if Complete then
      GetCover(aAudioFile, Data^.Image)
  else
      GetCoverLight(aAudioFile, Data^.Image)


end;

function AddVSTString(AVST: TCustomVirtualStringTree; aNode: PVirtualNode; aString: TJustaString): PVirtualNode;
var Data: PStringTreeData;
begin
  Result:= AVST.AddChild(aNode); // meistens wohl Nil
  AVST.ValidateNode(Result,false); // ?? was macht das??
  Data:=AVST.GetNodeData(Result);
  Data^.FString := aString;
end;


procedure FillStringTree(Liste: TObjectList; aTree: TVirtualStringTree; Playlist: Boolean = False);
var i, cAdd, startIdx: integer;
  HeaderStr: String;
  rn: PVirtualNode;
begin
  aTree.BeginUpdate;
  aTree.Clear;

  if aTree = Nemp_MainForm.ArtistsVST then
  begin
      startIdx := 3;
      if Liste.Count > 0 then
          AddVSTString(aTree, Nil, TJustaString(Liste[0])); // All Playlists
      if Liste.Count > 1 then
          AddVSTString(aTree, Nil, TJustaString(Liste[1])); // <Webradio>
      if Liste.Count > 2 then
          rn := AddVSTString(aTree, Nil, TJustaString(Liste[2])) // <All>
      else
          rn := NIL;  // Dann ist aber was falsch!!!
  end else
  begin
      startIdx := 1;
      if Liste.Count > 0 then
        AddVSTString(aTree,Nil,TJustaString(Liste[0]));
      //else
        rn := NIL; // Das sollte aber niemals auftreten!!
  end;


  for i := startIdx to Liste.Count-1 do
    AddVSTString(aTree, rn, TJustaString(Liste[i]));



  if (MedienBib.CurrentArtist = BROWSE_PLAYLISTS) and (aTree.Tag = 2) then // d.h. es ist der alben-Tree
  begin
      HeaderStr := TreeHeader_Playlists;
      cAdd := 1;
  end else
  if (MedienBib.CurrentArtist = BROWSE_RADIOSTATIONS) and (aTree.Tag = 2) then
  begin
      HeaderStr := TreeHeader_Webradio;
      cAdd := 1;
  end
  else
  begin
      cAdd := 0;
      case MedienBib.NempSortArray[aTree.Tag] of
        siAlbum:  HeaderStr := (TreeHeader_Albums);
        siArtist: HeaderStr := (TreeHeader_Artists);
        siOrdner: HeaderStr := (TreeHeader_Directories);
        siGenre:  HeaderStr := (TreeHeader_Genres);
        siJahr:   HeaderStr := (TreeHeader_Years);
        siFileAge:HeaderStr := (TreeHeader_FileAges);
        else HeaderStr := '(N/A)';
      end;
  end;
  if Liste.Count > 0 then
    aTree.Header.Columns[0].Text := HeaderStr + ' (' + inttostr(Liste.Count-1 + cAdd) + ')'
  else
    aTree.Header.Columns[0].Text := HeaderStr;

  aTree.FullExpand;
  aTree.EndUpdate;
end;

procedure FillStringTreeWithSubNodes(Liste: TObjectList; aTree: TVirtualStringTree; Playlist: Boolean = False);
var i,n,ncount,max, cAdd, startIdx: integer;
  NewOrdner: UnicodeString;
  Ordnerstruktur: TStringList;
  NewCheckNode, CheckNode, rn: PVirtualNode;
  Data : PStringTreeData;
  subOrdner: UnicodeString;
  jas: TJustAString;
  HeaderStr: String;
  aObjectList: TObjectlist;
begin
  aTree.BeginUpdate;
  aTree.Clear;
  if aTree = Nemp_MainForm.ArtistsVST then
    aObjectlist := ZusatzJustaStringsArtists
  else
    aObjectList := ZusatzJustaStringsAlben;

  aObjectList.Clear;

  if aTree = Nemp_MainForm.ArtistsVST then
  begin
      startIdx := 3;
      if Liste.Count > 0 then
          AddVSTString(aTree, Nil, TJustaString(Liste[0])); // All Playlists
      if Liste.Count > 1 then
          AddVSTString(aTree, Nil, TJustaString(Liste[1])); // Webradio
      if Liste.Count > 2 then
          rn := AddVSTString(aTree, Nil, TJustaString(Liste[2])) // <All>
      else
          rn := NIL;  // Dann ist aber was falsch!!!
  end else
  begin
      startIdx := 1;
      if Liste.Count > 0 then
        rn := AddVSTString(aTree,Nil,TJustaString(Liste[0]))
      else
        rn := NIL; // Das sollte aber niemals auftreten!!
  end;

  for i := startIdx to Liste.Count - 1 do
  begin
    // Newordner ist der neue Ordner, der in die Baumansicht eingefügt werden soll
    NewOrdner := TJustaString(Liste[i]).DataString;

    Ordnerstruktur := Explode('\', NewOrdner);

    if (Ordnerstruktur.Count >= 3) and (Ordnerstruktur[0] = '') and (Ordnerstruktur[1] = '') then
    begin
        Ordnerstruktur[2] := '\\' + Ordnerstruktur[2];
        Ordnerstruktur.Delete(0); // die beiden ersten wieder löschen
        Ordnerstruktur.Delete(0); // die beiden ersten wieder löschen
        //showmessage(Ordnerstruktur[0]);
    end;

    max := Ordnerstruktur.Count - 1;

    // Das ist der Knoten, an den ich anhängen muss
    CheckNode := rn;
    n := 0;

    subOrdner := '';
    // Das ist der Knoten, mit dem ich vergleichen muss
    // stimmen die Daten dort überein, kann ich dort (oder weiter unten anhängen)
    NewCheckNode := atree.GetLastChild(CheckNode);

    if assigned(NewChecknode) then
    begin
        Data := aTree.GetNodeData(NewCheckNode);
        // solange der Ordner übereinstimmt, kann ich eine Stufe tiefer gehen.
        while (n <= max) AND (assigned(NewChecknode)) AND (Data^.FString.AnzeigeString = Ordnerstruktur[n] + '\') do
        begin
            SubOrdner := SubOrdner + Ordnerstruktur[n] + '\';
            Checknode := NewChecknode;
            NewChecknode := aTree.GetLastChild(CheckNode);
            if assigned(NewChecknode) then
              Data := aTree.GetNodeData(NewCheckNode);
            inc(n);
        end;
    end;

    // n kann eigentlich niemals gleich max werden. Denke ich zumindest.

    // Jetzt ist checknode der Knoten, an den ich anhängen muss
    // Aber: nicht einfach den neuen String, sondern erstmal ggf. Unterverzeichnisse

    // Ordnerstruktur[n] ist der erste Ordner in der Hierarchie, der noch nicht im Baum ist
    for ncount := n to max-1 do
    begin
      //hier müssen wird noch JustaStrings erzeugen.
      SubOrdner := SubOrdner + Ordnerstruktur[ncount] + '\';
      jas := TJustaString.create(SubOrdner, Ordnerstruktur[ncount] + '\');
      aObjectList.Add(jas);
      CheckNode := AddVSTString(aTree,Checknode,jas);
    end;
    // am Ende das richtige einfürgen
    jas := TJustaString.create(NewOrdner, Ordnerstruktur[max] + '\');
    aObjectList.Add(jas);
    AddVSTString(aTree,Checknode,jas);
    Ordnerstruktur.Free;
  end;
  if rn <> NIl then
      aTree.Expanded[rn] := True;

  if (MedienBib.CurrentArtist = BROWSE_PLAYLISTS) and (aTree.Tag = 2) then // d.h. es ist der alben-Tree
  begin
      HeaderStr := TreeHeader_Playlists;
      cAdd := 1;
  end else
  if (MedienBib.CurrentArtist = BROWSE_RADIOSTATIONS) and (aTree.Tag = 2) then
  begin
      HeaderStr := TreeHeader_Webradio;
      cAdd := 1;
  end
  else
  begin
      cAdd := 0;
      case MedienBib.NempSortArray[aTree.Tag] of
        siAlbum:  HeaderStr := (TreeHeader_Albums); 
        siArtist: HeaderStr := (TreeHeader_Artists);
        siOrdner: HeaderStr := (TreeHeader_Directories);
        siGenre:  HeaderStr := (TreeHeader_Genres);
        siJahr:   HeaderStr := (TreeHeader_Years);
        siFileAge:HeaderStr := (TreeHeader_FileAges);
        else HeaderStr := '(N/A)';
      end;
  end;
  if Liste.Count > 0 then
    aTree.Header.Columns[0].Text := HeaderStr + ' (' + inttostr(Liste.Count-1 + cAdd) + ')'
  else
    aTree.Header.Columns[0].Text := HeaderStr;

  aTree.EndUpdate;
end;


function GetOldNode(aString: UnicodeString; aTree: TVirtualStringTree): PVirtualNode;
var aData: PStringTreeData;
    currentString: UnicodeString;
begin
    result := aTree.GetFirst;
    if assigned(result) then
    begin
        repeat
            aData := aTree.GetNodeData(result);
            currentString := TJustAstring(aData^.FString).DataString;
            if AnsiCompareText(currentString, aString) < 0 then
                result := aTree.GetNext(result);
        until (Not assigned(result)) OR
                          (AnsiCompareText(currentString, aString) >= 0);

        if assigned(result) and ((currentString = AUDIOFILE_UNKOWN) and (aString <> AUDIOFILE_UNKOWN) )  then
        begin
            result := aTree.GetNext(result);
            aData := aTree.GetNodeData(result);
            currentString := TJustAstring(aData^.FString).DataString;
            // weitersuchen
            while Assigned(result) and (AnsiCompareText(currentString, aString) < 0) do
            begin
                result := aTree.GetNext(result);
                aData := aTree.GetNodeData(result);
                currentString := TJustAstring(aData^.FString).DataString;
            end;
        end;
    end
end;
  (*
function GetOldCoverIdx(oldID: String; oldIDX: Integer): Integer;
var i: Integer;
begin
    result := -1;
    for i := 0 to MedienBib.Coverlist.Count -  1 do
    if tNempCover(MedienBib.Coverlist[i]).ID = oldID then
    begin
        result := i;
        break;
    end;
    if result = -1 then
        result := oldIdx;
    if result >= MedienBib.Coverlist.Count then
        result := 0;
end;
     *)


initialization
  ZusatzJustaStringsArtists := TObjectlist.Create;
  ZusatzJustaStringsAlben := TObjectlist.Create;


finalization
  try
  ZusatzJustaStringsArtists.Free;
  ZusatzJustaStringsAlben.Free;
  except end;

end.
