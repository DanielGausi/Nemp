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

unit DriveRepairTools;

interface

uses Windows, Messages, Classes, ContNrs, SysUtils, dialogs, Forms;


const  DriveTypeTexts: array[DRIVE_UNKNOWN..DRIVE_RAMDISK] of String =
   ('Unbekannt', 'Kein Wurzelverzeichnis', 'Diskette', 'Festplatte', 'Netzlaufwerk', 'CDROM', 'RAMDisk');

type


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
          procedure LoadFromStream(aStream: TStream);
          procedure SaveToStream(aStream: TStream);
  end;


  // type used in WM_DEVICECHANGE Message
  PDevBroadcastHdr  = ^DEV_BROADCAST_HDR;
  DEV_BROADCAST_HDR = packed record
    dbch_size: DWORD;
    dbch_devicetype: DWORD;
    dbch_reserved: DWORD;
  end;


  const
      GUID_DEVINTERFACE_USB_DEVICE: TGUID = '{A5DCBF10-6530-11D2-901F-00C04FB951ED}';
      DBT_DEVICEARRIVAL          = $8000;          // system detected a new device
      DBT_DEVICEREMOVECOMPLETE   = $8004;          // device is gone
      DBT_CONFIGCHANGED          = $0018;

      DBT_DEVTYP_DEVICEINTERFACE = $00000005;      // device interface class
      DBT_DEVTYP_VOLUME          = $00000002;


  // some helpers
  // Get all Drives in the system and store them in the ObjectList
  procedure GetLogicalDrives(Drives: TObjectList);

  // Get a Drive from the Drivelist used in the library
  function GetDriveFromListBySerialNr(aList: TObjectList; aSerial: DWord): TDrive;
  function GetDriveFromListByChar(aList: TObjectList; c: Char): TDrive;
  function GetDriveFromListByOldChar(aList: TObjectList; c: Char): TDrive;

  
implementation


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
var len: Integer;
begin
    aStream.Read(ID, SizeOf(Integer));
    aStream.Read(SerialNr, SizeOf(DWord));

    aStream.Read(len, SizeOf(len));
    setlength(Drive, len);
    aStream.Read(Drive[1], len);

    aStream.Read(len, SizeOf(len));
    setlength(Typ, len);
    aStream.Read(Typ[1], len);

    aStream.Read(len, SizeOf(len));
    setlength(Name, len);
    aStream.Read(Name[1], len);
end;

procedure TDrive.SaveToStream(aStream: TStream);
var len: Integer;
begin
    aStream.Write(ID, SizeOf(Integer));
    aStream.Write(SerialNr, SizeOf(DWord));

    len := length(Drive);
    aStream.Write(len, SizeOf(len));
    aStream.Write(Drive[1], len);

    len := length(Typ);
    aStream.Write(len, SizeOf(len));
    aStream.Write(Typ[1], len);

    len := length(Name);
    aStream.Write(len, SizeOf(len));
    aStream.Write(Name[1], len);
end;



{
    --------------------------------------------------------
    Helpers
    - Used in MedienBibliothek to correct Drives.
    --------------------------------------------------------
}
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

end.
