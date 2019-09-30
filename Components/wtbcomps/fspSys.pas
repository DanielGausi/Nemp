{*******************************************************}
{                                                       }
{                   fspWintaskbar  v 0.8                }
{                                                       }
{                                                       }
{             Copyright (c) 2010 FSPro Labs             }
{              http://delphi.fsprolabs.com              }
{                                                       }
{*******************************************************}

unit fspSys;

interface

uses classes;

// Verifies is Obj is of class ClassName - similar to IS operator, but
// ClassName is String
function fspObjectIsClass(Obj : TObject; ClassName : String) : Boolean; overload;
function fspObjectIsClass(Obj : TObject; ClassNames : TStringList) : Boolean; overload;

implementation

function fspClassDerivedFrom(Cls : TClass; ClassName : String) : Boolean;
begin
  Result := False;
  while Cls <> nil do begin
    if Cls.ClassNameIs(ClassName) then begin
      Result := True;
      Exit;
    end;
    Cls := Cls.ClassParent;
  end;
end;

function fspObjectIsClass(Obj : TObject; ClassName : String) : Boolean;
begin
  Result := fspClassDerivedFrom(Obj.ClassType, ClassName);
end;

function fspClassDerivedFromClasses(Cls : TClass; ClassNames : TStringList) : Boolean;
var
  Index : Integer;
begin
  Result := False;
  while Cls <> nil do begin
    if ClassNames.Find(Cls.ClassName, Index) then begin
      Result := True;
      Exit;
    end;
    Cls := Cls.ClassParent;
  end;
end;

function fspObjectIsClass(Obj : TObject; ClassNames : TStringList) : Boolean;
begin
  Result := fspClassDerivedFromClasses(Obj.ClassType, ClassNames);
end;

end.
