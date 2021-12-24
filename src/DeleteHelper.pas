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
