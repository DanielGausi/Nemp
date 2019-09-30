{*******************************************************}
{                                                       }
{                   fspWintaskbar  v 0.8                }
{                    Registration unit                  }
{                                                       }
{             Copyright (c) 2010 FSPro Labs             }
{              http://delphi.fsprolabs.com              }
{                                                       }
{                                                       }
{*******************************************************}
unit fspWinTaskbarReg;

interface

///{$R *.dcr}

procedure Register;

implementation
uses Classes, fspTaskbarMgr, fspTaskbarTabMgr, fspTaskbarPreviews;

procedure Register;
begin
  RegisterComponents('FSPro', [TfspTaskbarMgr, TfspTaskbarTabMgr, TfspTaskbarPreviews]);
end;

end.
