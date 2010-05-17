{
Funktionen, die das Deskband benötigt, um sich korrekt auszurichten
}

unit TaskbarStuff;

interface


uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs  ;


Type TTaskbarposition = (tbBottom, tbTop, tbLeft, tbRight);

function GetTaskbarPosition: TTaskbarposition;

implementation

function GetTaskbarPosition: TTaskbarposition;
var H: Hwnd;
    TaskBarRect: tRect;
    sHeight, sWidth: Integer;
begin
    H := FindWindow('Shell_TrayWnd', Nil);
    if H <> 0 then
    begin
        sHeight := Screen.Height;
        sWidth := Screen.Width;

        GetWindowRect(H, TaskBarRect);
        // zuerst: Taskbar unten?  => Top muss weit unten liegen!
        if TaskBarRect.Top > (sHeight DIV 2) then
          result := tbBottom
        else
        begin
           // nächster Versuch: Taskleiste oben? => Bottom liegt weit oben
           if TaskBarRect.Bottom < (sHeight DIV 2) then
             result := tbTop
           else
           begin
              // Taskleiste links? => Right ist weit links
              if TaskBarRect.Right < (sWidth Div 2) then
                result := tbLeft
              else
                // Jetzt bleibt nur noch right übrig.
                result := tbright;
           end;
        end;
    end
    else result := tbleft;
end;

end.
