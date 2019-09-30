unit NempTrackBar;

interface

uses
  Windows, SysUtils, Classes, Controls, Messages, VCL.extctrls, Vcl.Graphics, Vcl.ComCtrls ;

type
  //TMouseWheelEvent = procedure(Sender: TObject; delta: Word) of object;


  TNempTrackBar = class (TTrackBar)
        published
            property OnMouseDown;
            property OnMouseUp;
    end;


procedure Register;

implementation


procedure Register;
begin
  RegisterComponents('Beispiele', [TNempTrackBar]);
end;


end.
