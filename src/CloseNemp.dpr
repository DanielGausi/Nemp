program CloseNemp;

{$APPTYPE CONSOLE}

uses Windows;

const WM_CLOSE = $0010;

var hwndNemp: THandle;
begin
    //hwndNemp :=  FindWindow('TNemp_MainForm', 'Nemp - Noch ein MP3-Player');
    hwndNemp :=  FindWindow('TNemp_MainForm', Nil);
    if hwndNemp <> 0 then SendMessage(hwndNemp, WM_Close, 0, 0);
end.
