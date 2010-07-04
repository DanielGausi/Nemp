program NempSafemode;

{.$APPTYPE CONSOLE}

{$R *.dres}

uses
  SysUtils, ShellApi;

const SW_SHOWNORMAL = 1;

{
    ok, this can be done with a small .bat-file, but we can use an icon here. ;-)
}

begin
    ShellExecute(0, 'open', PChar( ExtractFilePath(ParamStr(0)) + 'nemp.exe'), '/safemode', Nil, SW_SHOWNORMAL );
end.
