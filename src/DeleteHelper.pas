{

    Unit DeleteHelper

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2005-2022, Daniel Gaussmann
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

unit DeleteHelper;

interface

uses windows, classes, SysUtils, Contnrs, strUtils,
    Nemp_ConstantsAndTypes, NempAudioFiles, NempFileUtils;

type

    TDeleteHint = (dh_DivePresent, dh_DriveMissing, dh_NetworkPresent, dh_NetworkMissing);

    TDeleteData = class
        public
            DriveString : String;    // i.e. "c:\" or "\\MyOtherPC\"
            DoDelete    : Boolean;   // User-Input
            DriveType   : String ;   // 'Removable drive', 'Harddisk', 'Shared directory', ...
            Hint: TDeleteHint;                      // ... and why?
            Files: TAudioFileList;
            PlaylistFiles: TLibraryPlaylistList;

            constructor Create;
            destructor Destroy; override;
    end;

implementation


{ TDeleteData }

constructor TDeleteData.Create;
begin
    Files := TAudioFileList.Create(False);
    PlaylistFiles := TLibraryPlaylistList.Create(False);
end;

destructor TDeleteData.Destroy;
begin
    Files.Free;
    PlaylistFiles.Free;
    inherited;
end;

end.
