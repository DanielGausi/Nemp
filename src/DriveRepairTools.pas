{

    Unit DriveRepairTools

    - Tools for correcting Drives (e.g. e:\) in the medialibrary.

      Problem: Library is on an USB-Drive, Nemp also on this mobile drive.
             Connect the drive to different PCs -> Drive will get different Letters
             and the Library would be invalid.
      Solution: Get Device-Details like SerialNr., and search a drive with this details
             at startup (and: when a new drive is connecet to the computer)

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

unit DriveRepairTools;

interface

uses Windows, Messages, Classes, ContNrs, SysUtils, dialogs, Forms, Generics.Collections,
  NempAudioFiles, NempFileUtils;


const DriveTypeTexts: array[DRIVE_UNKNOWN..DRIVE_RAMDISK] of String =
   ('Unknown', 'No root', 'Removable drive', 'Harddisk', 'Shared directory', 'CDROM', 'RAMDisk');

      GUID_DEVINTERFACE_USB_DEVICE: TGUID = '{A5DCBF10-6530-11D2-901F-00C04FB951ED}';
      DBT_DEVICEARRIVAL          = $8000;          // system detected a new device
      DBT_DEVICEREMOVECOMPLETE   = $8004;          // device is gone
      DBT_CONFIGCHANGED          = $0018;

      DBT_DEVTYP_DEVICEINTERFACE = $00000005;      // device interface class
      DBTF_MEDIA                = $0001;
      DBT_DEVTYP_VOLUME          = $00000002;

      MP3DB_DriveString   = 1; // string
      MP3DB_DriveName     = 2; // String
      MP3DB_DriveTyp      = 3; // String
      MP3DB_DriveSerialNr = 4; // DWord
      MP3DB_DriveID       = 5; // Integer, basically the index of the drive in the List

type

    // type used in WM_DEVICECHANGE Message
    PDevBroadcastHdr  = ^DEV_BROADCAST_HDR;
    DEV_BROADCAST_HDR = packed record
      dbch_size: DWORD;
      dbch_devicetype: DWORD;
      dbch_reserved: DWORD;
    end;

    PDevBroadcastVolume = ^DEV_BROADCAST_VOLUME;
    DEV_BROADCAST_VOLUME = packed record
      dbcv_size: DWORD;
      dbcv_devicetype: DWORD;
      dbcv_reserved: DWORD;
      dbcv_unitmask: DWORD;
      dbcv_flags: Word;
    end;


  // a little Class for Drives.
  // Just GetInfo, and Load/Save-Method for some Properties
  TDrive = class
      Public

          Drive: String; // Drive is a String like "c:\"
          Name: String;  // The Name of the Device, like "System-Disk" or "Data"
          Typ: String;   // One of the DriveTypeTexts defined above
          SerialNr: DWord; // The SerialNr of the Device

          // OldChar: When Drives changed
          // (i.e. a mobile Device E:\ is not connected on Nemp-Start,
          //       then the user turns it on and...whoa - Windows call it F:\)
          // Nemp need to correct all paths in the library.
          // So files with "OldDrive" must be changed to "Drive"
          OldChar: Char;

          // The ID is used inside the *.gmp-File
          // First is a List with Drives used in the library
          ID: Integer;

          // Get the info...
          procedure GetInfo(s: String);
          // Copy a Drive
          procedure Assign(aDrive: TDrive);
          // Load/Save Data to a stream (= *.gmp-file)
          procedure LoadFromStream_DEPRECATED(aStream: TStream);
          procedure LoadFromStream(aStream: TStream);
          procedure SaveToStream(aStream: TStream);
  end;

  TDriveList = class(TObjectList<TDrive>);

  TDriveManager = class
      private
          // a list of drives currently available on the computer
          fPhysicalDrives: TDriveList;
          // a List of Drives currently "in use" by the media library (or a playlist)
          fManagedDrives: TDriveList;

          class var fEnableUSBMode  : LongBool;
          class var fEnableCloudMode: LongBool;

          class function fGetEnableUSBMode   : LongBool;         static;
          class function fGetEnableCloudMode : LongBool;         static;
          class procedure fSetEnableUSBMode(aValue: LongBool)  ; static;
          class procedure fSetEnableCloudMode(aValue: LongBool); static;

          function fGetDriveByChar(aList: TDriveList; c: Char): TDrive;
          function fGetDriveBySerialNr(aList: TDriveList; aSerial: DWord): TDrive;

          function fGetDrivesHaveChanged: Boolean;
          function fGetManagedDrivesCount: Integer;

          // collect Data from all Drives currently available on the computer
          // and store them in fPhysicalDrives
          // // (in previous versions: "GetLogicalDrives")
          procedure InitPhysicalDriveList;

      public
          class property EnableUSBMode  : LongBool read fGetEnableUSBMode    write fSetEnableUSBMode   ;
          class property EnableCloudMode: LongBool read fGetEnableCloudMode  write fSetEnableCloudMode ;

          constructor Create;
          destructor Destroy; override;

          class procedure LoadSettings;
          class procedure SaveSettings;

          property DrivesHaveChanged: Boolean read fGetDrivesHaveChanged;
          property ManagedDrivesCount: Integer read fGetManagedDrivesCount;

          procedure Clear;

          procedure LoadDrivesFromStream(aStream: TStream; DestinationList: TDriveList);
          procedure SaveDrivesToStream(aStream: TStream);


          // Add Drives used by Audiofiles or PlaylistFiles to the list of ManaggedDrives
          procedure AddDrivesFromAudioFiles(aList: TAudioFileList);
          procedure AddDrivesFromPlaylistFiles(aList: TLibraryPlaylistList);

          function GetPhysicalDriveBySerialNr(aSerial: DWord): TDrive;
          function GetManagedDriveBySerialNr(aSerial: DWord): TDrive;
          function GetPhysicalDriveByChar(c: Char): TDrive;
          function GetManagedDriveByChar(c: Char): TDrive;
          function GetManagedDriveByOldChar(c: Char): TDrive;
          function GetManagedDriveByIndex(aIndex: Integer): TDrive;


          // Merges a list of newDrives (loaded from a *.gmp or *.npl File) into
          // the list of ManagedDrives
          procedure SynchronizeDrives(newDrives: TDriveList);


          // When a new Drive is connected to the Computer, the List of ManagedFiles
          // should be rechecked again.
          //  - A previous missing Drive could now be present (that's good!)
          //    But: It may have not the correct Drive Letter assigned (we need to fix the AudioFiles then)
          //  - A previously chosen alternate DriveLetter for a missing drive could now
          //    collide with the new Drive (that's bad, as we need a new one)
          procedure ReSynchronizeDrives;


          procedure RepairDriveCharsAtAudioFiles(AudiFiles: TAudioFileList);
          procedure RepairDriveCharsAtPlaylistFiles(Playlists: TLibraryPlaylistList);

  end;



 (*
  // some helpers
  // Get all Drives in the system and store them in the ObjectList
  procedure GetLogicalDrives(Drives: TObjectList);

  // Get a Drive from the Drivelist used in the library
  function GetDriveFromListBySerialNr(aList: TObjectList; aSerial: DWord): TDrive;
  function GetDriveFromListByChar(aList: TObjectList; c: Char): TDrive;
  function GetDriveFromListByOldChar(aList: TObjectList; c: Char): TDrive;
  *)
  
implementation

uses BibHelper, Nemp_RessourceStrings, Nemp_ConstantsAndTypes;


{$REGION 'TDrive, Class for handling a single Drive'}
procedure TDrive.GetInfo(s: String);
var t: Integer;
    dummy, srnNr: DWord;
    Buffer, Buffer2 : array[0..MAX_PATH + 1] of Char;
begin
    if s <> '' then
    begin
        t := GetDriveType(PChar(s));
        if  {(t <> DRIVE_REMOVABLE) and} // Note: USB-Sticks are DRIVE_REMOVABLE
            (t <> DRIVE_CDROM) then
        begin
            FillChar(Buffer, sizeof(Buffer), #0);
            FillChar(Buffer2, sizeof(Buffer2), #0);
            if GetVolumeInformation(PChar(s), Buffer, sizeof(Buffer), @srnNr,
                      dummy, dummy, Buffer2, sizeof(Buffer2))
            then
            begin
                Drive := s;
                Name := Buffer;
                SerialNr := srnNr;
                Typ := DriveTypeTexts[t];
            end else
            begin
                // GetVolumeInformation failed
                Drive := s;
                Name := 'Unknown';
                SerialNr := Ord(s[1]);//0;
                Typ := DriveTypeTexts[t];
            end
        end else
        begin
            // Drive is CD/DVD, Floppy, CardReader, ...
            Drive := s;
            Name := 'Unknown';
            SerialNr := Ord(s[1]);//0;
            Typ := DriveTypeTexts[t];
        end;
    end;
end;

procedure TDrive.Assign(aDrive: TDrive);
begin
    Drive      := aDrive.Drive        ;
    Name       := aDrive.Name         ;
    Typ        := aDrive.Typ          ;
    SerialNr   := aDrive.SerialNr     ;
    ID         := aDrive.ID           ;
end;

procedure TDrive.LoadFromStream(aStream: TStream);
var c: Integer;
    dataID: Byte;
begin
    c := 0;
    repeat
        aStream.Read(dataID, sizeof(dataID));
        inc(c);
        case dataID of
            MP3DB_DriveString   : Drive    := ReadTextFromStream(aStream);
            MP3DB_DriveName     : Name     := ReadTextFromStream(aStream);
            MP3DB_DriveTyp      : Typ      := ReadTextFromStream(aStream);
            MP3DB_DriveSerialNr : SerialNr := ReadDWordFromStream(aStream);
            MP3DB_DriveID       : ID       := ReadIntegerFromStream(aStream);
            DATA_END_ID: ; // Explicitly do Nothing -  because of the ELSE path ;-)
        else
            begin
                // unknown DataID, use generic reading function
                // if this fails, then the file is invalid, stop reading
                if not ReadUnkownDataFromStream(aStream) then
                    c := DATA_END_ID;
            end;
        end;
    until (dataID = DATA_END_ID) OR (c >= DATA_END_ID);
    // DATA_END_ID = 255
end;

procedure TDrive.LoadFromStream_DEPRECATED(aStream: TStream);
var len: Integer;
begin
    aStream.Read(ID, SizeOf(Integer));
    aStream.Read(SerialNr, SizeOf(DWord));

    aStream.Read(len, SizeOf(len));
    setlength(Drive, len Div 2);
    aStream.Read(Drive[1], len);

    aStream.Read(len, SizeOf(len));
    setlength(Typ, len Div 2);
    aStream.Read(Typ[1], len);

    aStream.Read(len, SizeOf(len));
    setlength(Name, len Div 2);
    aStream.Read(Name[1], len);
end;

procedure TDrive.SaveToStream(aStream: TStream);
begin
    WriteTextToStream   (aStream, MP3DB_DriveString  , Drive    );
    WriteTextToStream   (aStream, MP3DB_DriveName    , Name     );
    WriteTextToStream   (aStream, MP3DB_DriveTyp     , Typ      );
    WriteIntegerToStream(aStream, MP3DB_DriveID      , ID       );
    WriteDWordToStream  (aStream, MP3DB_DriveSerialNr, SerialNr );
    WriteDataEnd(aStream);
end;
{$ENDREGION}


(*
{ Helpers
    - Used in MedienBibliothek to correct Drives.
    ** Removed => TDriveManager.InitPhysicalDriveList; }
procedure GetLogicalDrives(Drives: TObjectList);
var
  FoundDrives, CurrentDrive  : PChar;
  len   : DWord;
  NewDrive: TDrive;
begin
    Drives.Clear;
    GetMem(FoundDrives, 255);
    len := GetLogicalDriveStrings(255, FoundDrives);
    if len > 0 then
    begin
      try
          CurrentDrive := FoundDrives;
          while (CurrentDrive[0] <> #0) do
          begin
              NewDrive := TDrive.Create;
              NewDrive.GetInfo(CurrentDrive);
              Drives.Add(NewDrive);
              CurrentDrive := PChar(@CurrentDrive[lstrlen(CurrentDrive) + 1]);
          end;
      finally
          FreeMem(FoundDrives, len);
      end;
    end;
end;

// ** remove => function TDriveManager.GetPhysicalDriveBySerialNr(aSerial: DWord): TDrive;
function GetDriveFromListBySerialNr(aList: TObjectList; aSerial: DWord): TDrive;
var i: Integer;
begin
    result := NIL;
    for i := 0 to aList.Count - 1 do
    begin
        if TDrive(aList[i]).SerialNr = aSerial then
        begin
            result := TDrive(aList[i]);
            break;
        end;
    end;
end;

// ** remove => function TDriveManager.Get[Physical|Managed]DriveByChar
function GetDriveFromListByChar(aList: TObjectList; c: Char): TDrive;
var i: Integer;
begin
    result := NIL;
    for i := 0 to aList.Count - 1 do
    begin
        if (length(TDrive(aList[i]).Drive) > 0) and (TDrive(aList[i]).Drive[1] = c) then
        begin
            result := TDrive(aList[i]);
            break;
        end;
    end;
end;

// ** remove => function TDriveManager.GetManagedDriveByOldChar
function GetDriveFromListByOldChar(aList: TObjectList; c: Char): TDrive;
var i: Integer;
begin
    result := NIL;
    for i := 0 to aList.Count - 1 do
    begin
        if (TDrive(aList[i]).OldChar = c) then
        begin
            result := TDrive(aList[i]);
            break;
        end;
    end;
end;

*)

{ TDriveManager }

constructor TDriveManager.Create;
begin
    fPhysicalDrives := TDriveList.Create(True);
    fManagedDrives  := TDriveList.Create(True);
    InitPhysicalDriveList;
end;

destructor TDriveManager.Destroy;
begin
    fPhysicalDrives.Free;
    fManagedDrives .Free;

    inherited;
end;

procedure TDriveManager.Clear;
begin
    fManagedDrives.Clear;
end;

class procedure TDriveManager.LoadSettings;
begin
  EnableUSBMode   := NempSettingsManager.ReadBool('Nemp Portable','EnableUSBMode'   , True);
  EnableCloudMode := NempSettingsManager.ReadBool('Nemp Portable','EnableCloudMode' , True);
end;
class procedure TDriveManager.SaveSettings;
begin
  NempSettingsManager.WriteBool('Nemp Portable','EnableUSBMode'   , EnableUSBMode  );
  NempSettingsManager.WriteBool('Nemp Portable','EnableCloudMode' , EnableCloudMode);
end;


procedure TDriveManager.LoadDrivesFromStream(aStream: TStream; DestinationList: TDriveList);
var DriveCount, i: Integer;
    newDrive: TDrive;
begin
    aStream.Read(DriveCount, SizeOf(Integer));
    for i := 0 to DriveCount - 1 do
    begin
        newDrive := TDrive.Create;
        newDrive.LoadFromStream(aStream);
        DestinationList.Add(newDrive);
    end;
end;

procedure TDriveManager.SaveDrivesToStream(aStream: TStream);
var i: Integer;
begin
    aStream.Write(fManagedDrives.Count, SizeOf(Integer));
    for i := 0 to fManagedDrives.Count-1 do
    begin
        TDrive(fManagedDrives[i]).ID := i;
        TDrive(fManagedDrives[i]).SaveToStream(aStream);
    end;
end;



// *****************************************
// *** Get a Drive specified by Char
// *****************************************
function TDriveManager.fGetDriveByChar(aList: TDriveList; c: Char): TDrive;
var i: Integer;
begin
    result := NIL;
    for i := 0 to aList.Count - 1 do
    begin
        if (length(aList[i].Drive) > 0) and (aList[i].Drive[1] = c) then
        begin
            result := TDrive(aList[i]);
            break;
        end;
    end;
end;
function TDriveManager.GetPhysicalDriveByChar(c: Char): TDrive;
begin
    result := fGetDriveByChar(fPhysicalDrives, c);
end;
function TDriveManager.GetManagedDriveByChar(c: Char): TDrive;
begin
    result := fGetDriveByChar(fManagedDrives, c);
end;



// *****************************************
// *** Get a Drive by SerialNumber
// *****************************************
function TDriveManager.fGetDriveBySerialNr(aList: TDriveList; aSerial: DWord): TDrive;
var i: Integer;
begin
    result := NIL;
    for i := 0 to aList.Count - 1 do
    begin
        if aList[i].SerialNr = aSerial then
        begin
            result := aList[i];
            break;
        end;
    end;
end;
function TDriveManager.GetPhysicalDriveBySerialNr(aSerial: DWord): TDrive;
begin
    result := fGetDriveBySerialNr(fPhysicalDrives, aSerial);
end;
function TDriveManager.GetManagedDriveBySerialNr(aSerial: DWord): TDrive;
begin
    result := fGetDriveBySerialNr(fManagedDrives, aSerial);
end;


// *****************************************
// *** Get a Drive by its previous Char
// *** - used to fix AudioFiles
// *****************************************
function TDriveManager.GetManagedDriveByOldChar(c: Char): TDrive;
var i: Integer;
begin
    result := NIL;
    for i := 0 to fManagedDrives.Count - 1 do
    begin
        if fManagedDrives[i].OldChar = c then
        begin
            result := fManagedDrives[i];
            break;
        end;
    end;
end;


function TDriveManager.GetManagedDriveByIndex(aIndex: Integer): TDrive;
begin
    if aIndex < fManagedDrives.Count then
        result := fManagedDrives[aIndex]
    else
        result := Nil;
end;



// AddDrivesFromAudioFiles
// Used after the user selected some files to be inserted into the MediaLibrary or Playlist.
// The files are currently available on the PC, therefore the Drives are also existent
// But: The may not be already in the list of ManagedDrives, so we may need to add some Drives to this list
procedure TDriveManager.AddDrivesFromAudioFiles(aList: TAudioFileList);
var i: Integer;
    CurrentDrive: Char;
    NewDrive: TDrive;
begin
    CurrentDrive := '-';
    for i := 0 to aList.Count - 1 do
    begin
        if aList[i].Pfad[1] <> CurrentDrive then
        begin
            CurrentDrive := aList[i].Pfad[1];
            if CurrentDrive <> '\' then
            begin
                // Search for a TDrive-Object for the CurrentDrive in ManagedDrives
                // if it doesn't exist already: Create a new one and add it to the list of ManagedDrives
                if not Assigned(GetManagedDriveByChar(CurrentDrive)) then
                begin
                    NewDrive := TDrive.Create;
                    NewDrive.GetInfo(CurrentDrive + ':\');
                    fManagedDrives.Add(NewDrive);
                end;
            end;
        end;
    end;
end;
// AddDrivesFromPlaylistFiles
// The same as AddDrivesFromAudioFiles, but for PlaylistFiles
// Used only by the MediaLibrary
// Note: This has nothing to do with the files inside the Playlists,
//       just with the location of the playlists itself (*.m3u, *.pls, or maybe even *.npl)
procedure TDriveManager.AddDrivesFromPlaylistFiles(aList: TLibraryPlaylistList);
var i: Integer;
    CurrentDrive: Char;
    NewDrive: TDrive;
begin
    CurrentDrive := '-';
    for i := 0 to aList.Count - 1 do
    begin
        if aList[i].Path[1] <> CurrentDrive then
        begin
            CurrentDrive := aList[i].Path[1];
            if CurrentDrive <> '\' then
            begin
                if not Assigned(GetManagedDriveByChar(CurrentDrive)) then
                begin
                    NewDrive := TDrive.Create;
                    NewDrive.GetInfo(CurrentDrive + ':\');
                    fManagedDrives.Add(NewDrive);
                end;
            end;
        end;
    end;
end;


// InitPhysicalDriveList
// - Get all available Drives on the PC
// - Store them into the list fPhysicalDrives
procedure TDriveManager.InitPhysicalDriveList;
var FoundDrives, CurrentDrive: PChar;
    len: DWord;
    NewDrive: TDrive;
begin
    fPhysicalDrives.Clear;
    GetMem(FoundDrives, 255);
    len := GetLogicalDriveStrings(255, FoundDrives);
    if len > 0 then
    begin
      try
          CurrentDrive := FoundDrives;
          while CurrentDrive[0] <> #0 do
          begin
              NewDrive := TDrive.Create;
              NewDrive.GetInfo(CurrentDrive);
              fPhysicalDrives.Add(NewDrive);
              CurrentDrive := PChar(@CurrentDrive[lstrlen(CurrentDrive) + 1]);
          end;
      finally
          FreeMem(FoundDrives, len);
      end;
    end;
end;



// *****************************************
// *** SynchronizeDrives
// *** - after loading a list of Files from a *gmp or *.npl file,
// ***   we need to synch these information with the Drives actually connected to the computer
// ***   This is needed, as all AudioFiles-Object are stored with absolute Paths, including the leading "X:\"
// *****************************************
procedure TDriveManager.SynchronizeDrives(newDrives: TDriveList);
var i: Integer;
    currentNewDrive,
    matchingDrive,
    newManagedDrive: TDrive;
    c,  LastCheckedDriveChar: Char;
begin

    // first: Reset all "oldChars" in the TDrive objects.
    //        We are looking for "new" changes now
    //for i := 0 to fPhysicalDrives.Count - 1 do
    //    if length(fPhysicalDrives[i].Drive) > 0 then
    //        fPhysicalDrives[i].OldChar := fPhysicalDrives[i].Drive[1]
    //    else
    //        fPhysicalDrives[i].OldChar := '-';

    for i := 0 to fManagedDrives.Count - 1 do
        if length(fManagedDrives[i].Drive) > 0 then
            fManagedDrives[i].OldChar := fManagedDrives[i].Drive[1]
        else
            fManagedDrives[i].OldChar := '-';


    LastCheckedDriveChar := 'C';
    for i := 0 to newDrives.Count-1 do
    begin
        currentNewDrive := newDrives[i];

        // 1.) Look for the new Drive in the list of already ManagedDrives
        matchingDrive := GetManagedDriveBySerialNr(currentNewDrive.SerialNr);
        if assigned(matchingDrive) then
        begin
            // we are already "managing" this Drive in the MediaLibrary
            // but: The DriveChar of the "new Drive" could be different,
            //      and Audiofiles contained in the File we just loaded need to
            //      be fixed. Therefore
            // Note: If It's the same, it doesn't matter when we set it here ;-)
            matchingDrive.OldChar := currentNewDrive.Drive[1];

            // For fixing Audiofiles later we use only the newDrives,
            // - We use the "DriveID" of the AudioFiles for getting the correct Drive Letters,
            //   which is just the Index of the Drive in the saved list.
            // Note: This may change in a later version. It's not exactly elegant coding ...
            currentNewDrive.Assign(matchingDrive);

            // ... and we are done with this currentNewDrive
            continue;
        end;

        // 2.) Look for the new Drive in the List of physicalDrives
        matchingDrive := GetPhysicalDriveBySerialNr(currentNewDrive.SerialNr);
        if assigned(matchingDrive) then
        begin
            // create a new TDrive object with the values of the matchingDrive
            newManagedDrive := TDrive.Create;
            newManagedDrive.Assign(matchingDrive);
            // set the OldChar for fixing AudioFiles later (see comment above)
            newManagedDrive.OldChar := currentNewDrive.Drive[1];
            // add the newManagedDrive to the list of managed Drives
            fManagedDrives.Add(newManagedDrive);

            currentNewDrive.Assign(newManagedDrive);

            // ... and we are done with this currentNewDrive
            continue;
        end;

        // 3.) Now we have a TDrive Object, which is completely unknown so far.
        //     We need to add it to the List of ManagedDrives, but we need
        //     to be careful with the Drive Letter
        c := currentNewDrive.Drive[1];
        if (Not assigned(GetManagedDriveByChar(c))) AND
           (Not assigned(GetPhysicalDriveByChar(c))) then
        begin
            // the Drive Letter of the currentNewDrive is not in use right now,
            // therefore we can just add the currentNewDrive into the List of ManagedDrives
            newManagedDrive := TDrive.Create;
            newManagedDrive.Assign(currentNewDrive);
            // Set the OldChar to the original one => no fixing of these AudioFiles needed
            newManagedDrive.OldChar := c;
            // add the newManagedDrive to the list of managed Drives
            fManagedDrives.Add(newManagedDrive);

            currentNewDrive.Assign(newManagedDrive);
        end else
        begin
            // we don't have the currentNewDrive in our lists, but the
            // Drive Letter is already in use. We need to find another letter for it
            While ( assigned(GetManagedDriveByChar(LastCheckedDriveChar)) or
                    assigned(GetPhysicalDriveByChar(LastCheckedDriveChar)))
                      and (LastCheckedDriveChar <> 'Z')
            do
                // try next letter
                LastCheckedDriveChar := Chr(Ord(LastCheckedDriveChar) + 1);

            // create a new TDrive object
            newManagedDrive := TDrive.Create;
            newManagedDrive.Assign(currentNewDrive);
            // set the substitute Drive Letter we have just found
            newManagedDrive.Drive := LastCheckedDriveChar + ':\';
            // set the OldChar for fixing AudioFiles later (see comment above)
            newManagedDrive.OldChar := currentNewDrive.Drive[1];
            // add the newManagedDrive to the list of managed Drives
            fManagedDrives.Add(newManagedDrive);

            currentNewDrive.Assign(newManagedDrive);
        end;
    end;
end;

procedure TDriveManager.ReSynchronizeDrives;
var i: Integer;
    currentDrive,
    matchingDrive: TDrive;
    currentDriveChar, LastCheckedDriveChar: Char;
begin
    // clear the old List of PhysicalDrives and get the current one.
    InitPhysicalDriveList;
    // clear all OldChars information in the ManagedDrives
    for i := 0 to fManagedDrives.Count - 1 do
        if length(fManagedDrives[i].Drive) > 0 then
            fManagedDrives[i].OldChar := fManagedDrives[i].Drive[1]
        else
            fManagedDrives[i].OldChar := '-';

    LastCheckedDriveChar := 'C';
    for i := 0 to fManagedDrives.Count-1 do
    begin
        currentDrive := fManagedDrives[i];
        currentDriveChar := currentDrive.Drive[1];

        matchingDrive := GetPhysicalDriveBySerialNr(currentDrive.SerialNr);

        // 1.) Check, whether matchingDrive exists.
        //     if not, we may need to change the DriveLetter of the currentDrive,
        //     as it may collide with a new PhysicalDrive now.
        if not assigned(matchingDrive) then
        begin
            matchingDrive := GetPhysicalDriveByChar(currentDriveChar);
            if assigned(matchingDrive) then
            begin
                // we have a new collision here. We need to change the DriveLetter
                // of the current Drive to a new unused Letter
                While ( assigned(GetManagedDriveByChar(LastCheckedDriveChar)) or
                        assigned(GetPhysicalDriveByChar(LastCheckedDriveChar)))
                        and (LastCheckedDriveChar <> 'Z')
                do
                    // try next letter
                    LastCheckedDriveChar := Chr(Ord(LastCheckedDriveChar) + 1);
                // assign the unused Letter to the currentDrive
                currentDrive.OldChar := currentDrive.Drive[1];
                currentDrive.Drive := LastCheckedDriveChar + ':\';
            end;

            // anyway: we are done with currentDrive now
            continue;
        end;

        // 2.) If the currentDrive equals a matchingDrive: Everything's ok so far
        //     => no change needed here
        if currentDrive.Drive = matchingDrive.Drive then
            continue;

        // 3.) If the DriveLetters doesn't match, we need to fix them
        //     Note: This fix may collide with another ManagedDrive.
        //           But that doesn't matter, because:
        //           - the already handled Drives can't have the matchingDrive's letter, as it's a physicalDrive
        //             and we only synch managedDrives during (1) to Letters that are not in use right now.
        //           - if it collides with a following Drive, we will run the exact code here with that drive later.
        if currentDrive.Drive <> matchingDrive.Drive then
        begin
            currentDrive.OldChar := currentDrive.Drive[1];
            currentDrive.Drive := matchingDrive.Drive;
        end;
    end;
end;


procedure TDriveManager.RepairDriveCharsAtAudioFiles(AudiFiles: TAudioFileList);
var i: Integer;
    CurrentDriveChar, CurrentReplaceChar: WideChar;
    aAudioFile: TAudioFile;
    aDrive: TDrive;
begin
    CurrentDriveChar := '-';
    CurrentReplaceChar := '-';
    for i := 0 to AudiFiles.Count - 1 do
    begin
        aAudioFile := AudiFiles[i];
        if (aAudioFile.Ordner[1] <> CurrentDriveChar) then
        begin
            if aAudioFile.Ordner[1] <> '\' then
            begin
                aDrive := GetManagedDriveByOldChar(aAudioFile.Ordner[1]);
                if assigned(aDrive) and (aDrive.Drive <> '') then
                begin
                    // aktuelle Buchstaben merken
                    // und replaceChar neu setzen
                    CurrentDriveChar := aAudioFile.Ordner[1];
                    CurrentReplaceChar := WideChar(aDrive.Drive[1]);
                end else
                begin
                    MessageDLG((Medialibrary_DriveRepairError), mtError, [MBOK], 0);
                    exit;
                end;
            end else
            begin
                CurrentDriveChar := '\';
                CurrentReplaceChar := '\';
            end;
        end;
        aAudioFile.SetNewDriveChar(CurrentReplaceChar);
    end;
end;


procedure TDriveManager.RepairDriveCharsAtPlaylistFiles(Playlists: TLibraryPlaylistList);
var i: Integer;
    CurrentDriveChar, CurrentReplaceChar: WideChar;
    aDrive: TDrive;
begin
    CurrentDriveChar := '-';
    CurrentReplaceChar := '-';
    for i := 0 to Playlists.Count - 1 do
    begin
        if (Playlists[i].Path[1] <> CurrentDriveChar) then
        begin
            if (Playlists[i].Path[1] <> '\') then
            begin
                // Neues Laufwerk - Infos dazwischenschieben
                aDrive := self.GetManagedDriveByOldChar(Playlists[i].Path[1]);
                    // GetDriveFromListByOldChar(fUsedDrives, Char(aString.DataString[1]));
                if assigned(aDrive) and (aDrive.Drive <> '') then
                begin
                    // aktuelle Buchstaben merken
                    // und replaceChar neu setzen
                    CurrentDriveChar := Playlists[i].Path[1];
                    CurrentReplaceChar := WideChar(aDrive.Drive[1]);
                end else
                begin
                    MessageDLG((Medialibrary_DriveRepairError), mtError, [MBOK], 0);
                    exit;
                end;
            end else
            begin
                CurrentDriveChar := '\';
                CurrentReplaceChar := '\';
            end;
        end;
        Playlists[i].SetNewDriveChar(CurrentReplaceChar);
    end;
end;



// *****************************************
// *** After Synchronizing the DriveList, we need to fix all AudioFiles,
// *** if there was a change in on of the Drive Letters
// *****************************************
function TDriveManager.fGetDrivesHaveChanged: Boolean;
var i: Integer;
begin
    result := False;
    for i := 0 to fManagedDrives.Count - 1 do
    begin
        if fManagedDrives[i].Drive[1] <> fManagedDrives[i].OldChar then
        begin
            result := True;
            break;
        end;
    end;
end;

class function TDriveManager.fGetEnableCloudMode: LongBool;
begin
    InterLockedExchange(Integer(Result), Integer(fEnableCloudMode));
end;

class function TDriveManager.fGetEnableUSBMode: LongBool;
begin
    InterLockedExchange(Integer(Result), Integer(fEnableUSBMode));
end;

function TDriveManager.fGetManagedDrivesCount: Integer;
begin
    result := fManagedDrives.Count;
end;

class procedure TDriveManager.fSetEnableCloudMode(aValue: LongBool);
begin
    InterLockedExchange(Integer(fEnableCloudMode), Integer(aValue));
end;

class procedure TDriveManager.fSetEnableUSBMode(aValue: LongBool);
begin
    InterLockedExchange(Integer(fEnableUSBMode), Integer(aValue));
end;

end.
