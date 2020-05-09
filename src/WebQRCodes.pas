{

    Unit WebQRCodes
    Form WebServerQRForm

    Display a QR-Code for the URLs used in the Webserver
    => quicker access to the Webserver with a smartphone using a QR-Code scanner

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2005-2020, Daniel Gaussmann
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
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure RefreshQRCode;

  end;

var
  WebServerQRForm: TWebServerQRForm;

implementation

uses RedeemerQR, gnuGettext, Hilfsfunktionen;

{$R *.dfm}



procedure TWebServerQRForm.DataChange(Sender: TObject);
begin
    RefreshQRCode;
end;

procedure TWebServerQRForm.FormCreate(Sender: TObject);
begin
    BackUpComboBoxes(self);
    TranslateComponent (self);
    RestoreComboboxes(self);
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
