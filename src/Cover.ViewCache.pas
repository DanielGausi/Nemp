{

    Unit Cover.ViewCache

    - Caching Cover Art for TreeView

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2005-2022, Daniel Gaussmann
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
unit Cover.ViewCache;

interface

uses
  Windows, System.Classes, System.SysUtils, System.Generics.Collections, System.Generics.Defaults,
  VCL.Graphics;


type

  TCachedCover = class
    private
      fPicture: TPicture;
      fAge: Integer;
      // fID: String;
    public
      constructor Create(aWidth, aHeight: Integer);
      destructor Destroy; override;
  end;

  TCoverDict = class (TDictionary<string, TCachedCover>);
  TCoverKeyValue = TPair<string, TCachedCover>;

  TCoverManager = class
    private
      fCoverDict: TCoverDict;
      fDefaultCover: TPicture;

      fCapacity: Integer;
      fCoverSize: Integer;
      fCoverOffset,
      fVerticalMargin,
      fHorizontalMargin: Integer;

      procedure IncCoverAges;
      procedure CheckMaxCapacity;
      procedure SetCoverSize(aValue: Integer);
      procedure SetVerticalMargin(aValue: Integer);
      procedure SetHorizontalMargin(aValue: Integer);

    public
      property CoverOffset: Integer read fCoverOffset;
      property CoverSize: Integer read fCoverSize write SetCoverSize;
      property VerticalMargin: Integer read fVerticalMargin write SetVerticalMargin;
      property HorizontalMargin: Integer read fHorizontalMargin write SetHorizontalMargin;

      constructor Create;
      destructor Destroy; override;

      procedure LoadSettings;
      procedure LoadSettingsHintCover;
      procedure SaveSettings;

      function GetCachedCover(aID: String; out success: Boolean): TPicture;
  end;

function CoverManager: TCoverManager;
function CoverManagerHint: TCoverManager;


implementation

uses
  Nemp_ConstantsAndTypes, CoverHelper;

var
  fCoverManager: TCoverManager;
  fCoverManagerHint: TCoverManager;

function CoverManager: TCoverManager;
begin
  if not assigned(fCoverManager) then
    fCoverManager := TCoverManager.Create;

  result := fCoverManager;
end;

function CoverManagerHint: TCoverManager;
begin
  if not assigned(fCoverManagerHint) then
    fCoverManagerHint := TCoverManager.Create;

  result := fCoverManagerHint;
end;

{ TCachedCover }

constructor TCachedCover.Create(aWidth, aHeight: Integer);
begin
  inherited create;
  fPicture := TPicture.Create;
  fPicture.Bitmap.Width := aWidth;
  fPicture.Bitmap.Height := aHeight;
  fAge := 0;
end;

destructor TCachedCover.Destroy;
begin
  fPicture.Free;
  inherited;
end;


{ TCoverManager }

constructor TCoverManager.Create;
begin
  inherited;
  fCoverDict := TCoverDict.Create(150);  // Size: Load it from IniFile, // ToDo
  fDefaultCover := TPicture.Create;
  fVerticalMargin := 2;
  fHorizontalMargin := 5;
end;

destructor TCoverManager.Destroy;
var
  aValue: TCachedCover;
begin
  for aValue in fCoverDict.Values do
    aValue.Free;

  fCoverDict.Free;
  fDefaultCover.Free;
  inherited;
end;

procedure TCoverManager.LoadSettings;
begin
  fCapacity := NempSettingsManager.ReadInteger('CoverCache', 'Capacity', 150);
  CoverSize := NempSettingsManager.ReadInteger('CoverCache', 'CoverSize', 48);
end;

procedure TCoverManager.LoadSettingsHintCover;
begin
  fCapacity := NempSettingsManager.ReadInteger('CoverCache', 'CapacityHint', 30);
  CoverSize := NempSettingsManager.ReadInteger('CoverCache', 'CoverSizeHint', 96);
  //fVerticalMargin := 5;
end;

procedure TCoverManager.SaveSettings;
begin
  NempSettingsManager.WriteInteger('CoverCache', 'Capacity', fCapacity);
  NempSettingsManager.WriteInteger('CoverCache', 'CoverSize', fCoverSize);
end;

procedure TCoverManager.SetCoverSize(aValue: Integer);
begin
  if (fCoverSize <> aValue) then begin
    fCoverSize := aValue;
    fCoverOffset := fCoverSize + fHorizontalMargin;
    fDefaultCover.Bitmap.Width  := CoverSize;
    fDefaultCover.Bitmap.Height := CoverSize;
    TCoverArtSearcher.GetDefaultCover(dcFile, fDefaultCover, 0);
  end;
end;

procedure TCoverManager.SetHorizontalMargin(aValue: Integer);
begin
  fHorizontalMargin := aValue;
  fCoverOffset := fCoverSize + fHorizontalMargin;
end;

procedure TCoverManager.SetVerticalMargin(aValue: Integer);
begin
  fVerticalMargin := aValue;
end;

function TCoverManager.GetCachedCover(aID: String; out success: Boolean): TPicture;
var aCachedCover, newCachedCover: TCachedCover;
begin
  if fCoverDict.TryGetValue(aID, aCachedCover) then begin
    IncCoverAges;
    aCachedCover.fAge := 0;
    result := aCachedCover.fPicture;
    success := True;
    //FormOrganizerTest.Caption := aID + 'Count = ' + IntToStr(fCoverDict.Count);
  end
  else begin
    newCachedCover := TCachedCover.Create(fCoverSize, fCoverSize);
    if TCoverArtSearcher.GetCover_Fast(aID, newCachedCover.fPicture) then begin
      IncCoverAges;
      CheckMaxCapacity;
      fCoverDict.Add(aID, newCachedCover);
      result := newCachedCover.fPicture;
      success := True;
    end
    else begin
      newCachedCover.Free;
      result := fDefaultCover;
      success := False;
    end;
  end;
end;

{
  CheckMaxCapacity
  Remove the oldest Item in the Dictionary, if the max. Capacity is reached
}
procedure TCoverManager.CheckMaxCapacity;
var
  oldest: Integer;
  loopPair, oldestPair: TCoverKeyValue;
begin
  if fCoverDict.Count >= fCapacity then begin
    // determine the oldest item in the Cache
    oldest := -1;
    for loopPair in fCoverDict do begin
      if loopPair.Value.fAge > oldest then begin
        oldest := loopPair.Value.fAge;
        oldestPair := loopPair;
      end;
    end;
    // remove it from the Dictionary and free the Object
    fCoverDict.Remove(oldestPair.Key);
    oldestPair.Value.Free;
  end;
end;

{
  Increase the Age of each Item in the Dictionary
}
procedure TCoverManager.IncCoverAges;
var
  aValue: TCachedCover;
begin
  for aValue in fCoverDict.Values do
    inc(aValue.fAge);
end;




initialization

  fCoverManager := Nil;
  fCoverManagerHint := Nil;

finalization

  if assigned(fCoverManager) then
    fCoverManager.Free;

  if assigned(fCoverManagerHint) then
    fCoverManagerhint.Free;

end.
