unit WebQRCodes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Samples.Spin;

type
  TWebServerQRForm = class(TForm)
    imgQRCode: TImage;
    cbURLs: TComboBox;
    lblIPs: TLabel;
    cbAdmin: TCheckBox;
    sePort: TSpinEdit;
    lblPort: TLabel;
    procedure DataChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure RefreshQRCode;

  end;

var
  WebServerQRForm: TWebServerQRForm;

implementation

uses RedeemerQR;

{$R *.dfm}



procedure TWebServerQRForm.DataChange(Sender: TObject);
begin
    RefreshQRCode;
end;

procedure TWebServerQRForm.FormShow(Sender: TObject);
begin
    if cbURLs.Items.Count = 0 then
        cbURLs.Text := 'localhost';

    RefreshQRCode;
end;

procedure TWebServerQRForm.RefreshQRCode;
var QR: TRedeemerQR;
    s: String;
    QRBitmap: TBitmap;
begin
    QR := TRedeemerQR.Create();
    try
        s := 'http://' + cbURLs.Text;

        if sePort.Value <> 80 then
            s := s + ':' + IntToStr(sePort.Value);

        if cbAdmin.Checked then
            s := s + '/admin';

        QR.LoadFromString(AnsiString(s), ecHigh);
        QRBitmap := TBitmap.Create;
        try
            QRBitmap.Width := QR.Width + 2;
            QRBitmap.Height := QR.Height + 2;
            QRBitmap.Canvas.Draw(1,1, QR);
            imgQRCode.Picture.Assign(QRBitmap);
        finally
            QRBitmap.Free;
        end;

    finally
        QR.Free();
    end;
end;

end.
