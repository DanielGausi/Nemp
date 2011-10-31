unit DeleteHelper;

interface

uses windows, classes, SysUtils, Contnrs, strUtils,
    Nemp_ConstantsAndTypes;

type

    TDeleteHint = (dh_DivePresent, dh_DriveMissing, dh_NetworkPresent, dh_NetworkMissing);

    TDeleteData = class
        public
            DriveString : String;    // i.e. "c:\" or "\\MyOtherPC\"
            DoDelete    : Boolean;   // User-Input
            Hint: TDeleteHint;                      // ... and why?
            Files: TObjectList;

            constructor Create;
            destructor Destroy; override;
    end;

implementation


{ TDeleteData }

constructor TDeleteData.Create;
begin
    Files := TObjectList.Create(False);
end;

destructor TDeleteData.Destroy;
begin
    Files.Free;
    inherited;
end;

end.
