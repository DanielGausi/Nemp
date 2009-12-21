program CloseNemp;

{$APPTYPE CONSOLE}

uses Windows;

const WM_CLOSE = $0010;

var hwndNemp: THandle;
begin
    hwndNemp := FindWindow(PChar('TNemp_MainForm.UnicodeClass'), nil);
    if hwndNemp <> 0 then SendMessage(hwndNemp, WM_Close, 0, 0);
end.
