{*******************************************************}
{                                                       }
{                   fspWintaskbar  v 0.8                }
{                                                       }
{                                                       }
{             Copyright (c) 2010 FSPro Labs             }
{              http://delphi.fsprolabs.com              }
{                                                       }
{*******************************************************}


unit fspTaskbarCommon;

{$I fspWinTaskbar.inc}

interface

uses Windows, Forms;

var
  fspTaskbarMainAppWnd : THandle;

implementation

begin
  {$IFNDEF FSP_VER_2007}
    fspTaskbarMainAppWnd := Application.Handle;
  {$ELSE}
    fspTaskbarMainAppWnd := 0; // for 2007 we will check MainFormOnTaskBar
  {$ENDIF}

end.
