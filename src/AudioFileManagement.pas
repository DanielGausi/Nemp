{

    Unit AudioFileManagement

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2005-2025, Daniel Gaussmann
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

unit AudioFileManagement;

interface

uses
  System.Classes, System.Generics.Defaults, System.Generics.Collections,
  BasicClasses, NempAudioFiles;

type

  TAudioFileManager = class
  strict private
    class constructor Create;
    class destructor Destroy;
  private
    class var FFilesToChange: TAudioFileList;
    class var FOnAudioFileChanged: TEventList;
    class var FOnPrepareAudioFileChange: TEventList;

  public
    class property OnPrepareAudioFileChange: TEventList read FOnPrepareAudioFileChange;
    class property OnAudioFileChanged: TEventList read FOnAudioFileChanged;
    class property FilesToChange: TAudioFileList read FFilesToChange;

    class function SameFile(fileA, fileB: TAudioFile): Boolean;
    class function AddFileIfNeeded(NeededFile, newCandidate: TAudioFile): Boolean;

    // PrepareAudioFileChange:
    // - Fire all OnPrepareAudioFileChange-Events
    // - EventHandlers should fill FilesToChange as needed
    class procedure PrepareAudioFileChange(FileToChange: TAudioFile);

    // FinalizeAudioFileChange
    // - Fire all OnAudioFileChanged-Events
    // - EventHandlers should refresh the GUI as needed
    class procedure FinalizeAudioFileChange(ChangedFile: TAudioFile);

    class procedure SyncFilesAfterEdit(EditedFile: TAudioFile);

  end;

implementation

{ TAudioFileManager }

class constructor TAudioFileManager.Create;
begin
  FOnPrepareAudioFileChange := TEventList.Create;
  FOnAudioFileChanged := TEventList.Create;
  FFilesToChange := TAudioFileList.Create(False);
end;

class destructor TAudioFileManager.Destroy;
begin
  FOnAudioFileChanged.Free;
  FOnPrepareAudioFileChange.Free;
  FFilesToChange.Free;
end;

class function TAudioFileManager.SameFile(fileA, fileB: TAudioFile): Boolean;
begin
  result := assigned(fileA) and assigned(fileB) and (fileA.Pfad = fileB.Pfad);
end;

class function TAudioFileManager.AddFileIfNeeded(NeededFile,
  newCandidate: TAudioFile): Boolean;
begin
  result := SameFile(NeededFile, newCandidate);
  if result then
    FilesToChange.Add(newCandidate);
end;

{
    PrepareAudioFileChange
    Collect all Files within the Nemp-Universe with the same filename.
    These files must be updated when the user edits a file
    ( in the tree, in the detail-listing within the mainform, in the detailform
      or just the Player-rating )

    !!! Important Note !!!
    The MediaLibrary adds "GetAudioFileWithFilename(EditFile.Pfad);" to that.
    Therefore: Use this function only in VCL-Thread and only after a test for
     - Medienbib.status <= 1  (searching for new files or GetTags should be ok) and
     - MedienBib.CurrentThreadFilename
}
class procedure TAudioFileManager.PrepareAudioFileChange(
  FileToChange: TAudioFile);
begin
  FFilesToChange.Clear;
  FFilesToChange.Add(FileToChange);
  FOnPrepareAudioFileChange.Fire(FileToChange);
end;

class procedure TAudioFileManager.FinalizeAudioFileChange(
  ChangedFile: TAudioFile);
begin
  FOnAudioFileChanged.Fire(ChangedFile);
  FFilesToChange.Clear;
end;

class procedure TAudioFileManager.SyncFilesAfterEdit(EditedFile: TAudioFile);
var
  i: Integer;
begin
  PrepareAudioFileChange(EditedFile);
  for i := 0 to FilesToChange.Count - 1 do
    FilesToChange.Items[i].Assign(EditedFile);
  FinalizeAudioFileChange(EditedFile);
end;

end.
