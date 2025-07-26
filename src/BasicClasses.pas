{

    Unit BasicClasses
    - Some Basic Classes

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2005-2025, Daniel Gaussmann
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
unit BasicClasses;

interface

uses
  System.Classes, System.Generics.Defaults, System.Generics.Collections;

type
  TEventClass = class
  private
    FNotifyEvent: TNotifyEvent;
  public
    constructor Create(ANotifyEvent: TNotifyEvent);
    property NotifyEvent: TNotifyEvent read FNotifyEvent write FNotifyEvent;
  end;

  TEventList = class
  private
    FList: TObjectList<TEventClass>;
    function IndexOf(EventHandler: TNotifyEvent): Integer;
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(EventHandler: TNotifyEvent);
    procedure Delete(AIndex: Integer); overload;
    procedure Delete(EventHandler: TNotifyEvent); overload;
    procedure Fire(Sender: TObject);
    property Count: Integer read GetCount;
  end;

implementation

constructor TEventClass.Create(ANotifyEvent: TNotifyEvent);
begin
  inherited Create;
  FNotifyEvent := ANotifyEvent;
end;

{ TEventList }

constructor TEventList.Create;
begin
  inherited Create;
  FList := TObjectList<TEventClass>.create(True);
end;

destructor TEventList.Destroy;
begin
  FList.Free;
  inherited;
end;

function TEventList.GetCount: Integer;
begin
  Result := FList.Count;
end;

procedure TEventList.Add(EventHandler: TNotifyEvent);
begin
  if IndexOf(EventHandler) = -1 then
    FList.Add(TEventClass.Create(EventHandler));
end;

function TEventList.IndexOf(EventHandler: TNotifyEvent): Integer;
var
  i: Integer;
  ACode, AData: Pointer;
begin
  Result := -1;
  ACode := TMethod(EventHandler).Code;
  AData := TMethod(EventHandler).Data;
  for i := 0 to FList.Count - 1 do begin
    if (ACode = TMethod(FList[i].NotifyEvent).Code) and (AData = TMethod(FList[i].NotifyEvent).Data) then begin
      Result := i;
      break;
    end;
  end;
end;

procedure TEventList.Delete(AIndex: Integer);
begin
  if AIndex <> -1 then
    FList.Delete(AIndex);
end;

procedure TEventList.Delete(EventHandler: TNotifyEvent);
begin
  Delete(IndexOf(EventHandler));
end;

procedure TEventList.Fire(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to FList.Count - 1 do
    FList[i].NotifyEvent(Sender);
end;

end.
