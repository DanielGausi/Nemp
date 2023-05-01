{

    Unit AudioExportUtils

    - Export a List of AudioFiles based on a Template file

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

unit AudioExportUtils;

interface

uses
  windows, classes, SysUtils, StrUtils, IniFiles, NempAudioFiles, AudioDisplayUtils;

const
  DefaultTemplateFilenameCSV = 'csv.nxp';
  DefaultTemplateFilenameHTML = 'html.nxp';
  DefaultTemplateFilenameJSON = 'json.nxp';

  cMetaStart = '%<META>%';
  cMetaEnd   = '%</META>%';
  cFilesStart = '%<FILES>%';
  cFilesEnd   = '%</FILES>%';

type

  TAudioExport = class
    private
      fMetaLines: TStringList;
      fHeaderStrings: TStringList;
      fFooterStrings: TStringList;
      fTemplateLines: TStringList;
      fEscapeLines: TStringList;

      fEncoding: TEncoding;
      fExtension: String;
      fTemplateFilename: String;
      fTemplateDirectory: String;

      procedure ParseTemplateFile(Filename: String);
      procedure ParseMetaBlock;
      function ParseTemplateLine(Template: String; AudioFile: TAudioFile): String;
      function EscapedAudioProperty(aAudioFile: TAudioFile; aPlaceHolder: string): string;
      procedure SetTemplateFilename(Value: String);
      function GetTemplateFilename: String;
      function StringToEncoding(Encoding: String): TEncoding;
      procedure CreateDefaultTemplate(resID: String; TargetFilename: String);
      function EscapeProperty(Value: String): String;

    public
      property TemplateDirectory: String read fTemplateDirectory;
      property TemplateFilename: String read GetTemplateFilename write SetTemplateFilename;
      property Encoding: TEncoding read fEncoding;
      property Extension: String read fExtension;

      constructor Create(BaseDir: String);
      destructor Destroy; override;

      procedure CreateDefaultExportTemplates;
      function CreateEmptyTemplate(newTemplateName: String): String;
      function DuplicateTemplate(originalTemplate, newTemplateName: String): String;
      function ExportFiles(AudioFiles: TAudioFileList; TargetFilename: String): Boolean;
  end;

implementation

uses HilfsFunktionen, StringHelper;

function AddDot(ext: String): String;
begin
  if ext = '' then
    result := ''
  else begin
    if ext[1] = '.' then
      result := ext
    else
      result := '.' + ext;
  end;
end;


{ TAudioExport }

constructor TAudioExport.Create(BaseDir: String);
begin
  inherited Create;

  fTemplateDirectory := IncludeTrailingPathDelimiter(BaseDir) + 'Export\';
  // Try to create the Directory
  try
    ForceDirectories(fTemplateDirectory);
  except
    if not DirectoryExists(fTemplateDirectory) then
      fTemplateDirectory := IncludeTrailingPathDelimiter(BaseDir);
  end;

  fMetaLines := TStringList.Create;
  fHeaderStrings := TStringList.Create;
  fFooterStrings := TStringList.Create;
  fTemplateLines := TStringList.Create;
  fEscapeLines := TStringList.Create;

  fEncoding := TEncoding.UTF8;
  fExtension := '.csv';
end;

destructor TAudioExport.Destroy;
begin
  fMetaLines.Free;
  fHeaderStrings.Free;
  fFooterStrings.Free;
  fTemplateLines.Free;
  fEscapeLines.Free;

  inherited;
end;

procedure TAudioExport.CreateDefaultExportTemplates;
begin
  if not FileExists(fTemplateDirectory + DefaultTemplateFilenameCSV) then
    CreateDefaultTemplate('nxpCSV', fTemplateDirectory + DefaultTemplateFilenameCSV);

  if not FileExists(fTemplateDirectory + DefaultTemplateFilenameHTML) then
    CreateDefaultTemplate('nxpHTML', fTemplateDirectory + DefaultTemplateFilenameHTML);

  if not FileExists(fTemplateDirectory + DefaultTemplateFilenameJSON) then
    CreateDefaultTemplate('nxpJson', fTemplateDirectory + DefaultTemplateFilenameJSON);
end;

function TAudioExport.CreateEmptyTemplate(newTemplateName: String): String;
begin
  newTemplateName := TemplateDirectory + ConvertToFileName(newTemplateName) + '.nxp';
  if FileExists(newTemplateName) then
    newTemplateName := UniqueFilename(newTemplateName);

  CreateDefaultTemplate('nxpEmpty', newTemplateName);
  result := newTemplateName;
end;

function TAudioExport.DuplicateTemplate(originalTemplate, newTemplateName: String): String;
var
  Stream: TMemoryStream;
begin
  newTemplateName := TemplateDirectory + ConvertToFileName(newTemplateName) + '.nxp';
  if FileExists(newTemplateName) then
    newTemplateName := UniqueFilename(newTemplateName);
  Stream := TMemoryStream.Create;
  try
    Stream.LoadFromFile(originalTemplate);
    Stream.SaveToFile(newTemplateName);
  finally
    Stream.Free;
  end;
  result := newTemplateName;
end;

procedure TAudioExport.CreateDefaultTemplate(resID, TargetFilename: String);
var
  Stream: TResourceStream;
begin
  Stream := TResourceStream.Create(HInstance, resID, RT_RCDATA);
  try
    Stream.SaveToFile(TargetFilename);
  finally
    Stream.Free;
  end;
end;

function TAudioExport.StringToEncoding(Encoding: String): TEncoding;
begin
  if Encoding = 'utf8' then
    result := TEncoding.UTF8
  else if Encoding = 'utf16' then
    result := TEncoding.Unicode
  else if Encoding = 'ansi' then
    result := TEncoding.ANSI
  else
    result := TEncoding.UTF8;
end;

procedure TAudioExport.ParseMetaBlock;
var
  i, PosSpace: Integer;
  escLine: String;
begin
  for i := 0 to fMetaLines.Count - 1 do begin
    if SameText(fMetaLines.Names[i], '%EXTENSION%') then
      fExtension := AddDot(fMetaLines.ValueFromIndex[i])
    else
      if SameText(fMetaLines.Names[i], '%ENCODING%') then
        fEncoding := StringToEncoding(AnsiLowercase(fMetaLines.ValueFromIndex[i]))
      else
        if SameText(fMetaLines.Names[i], '%ESCAPE%') then begin
          escLine := fMetaLines.ValueFromIndex[i];
          PosSpace := pos(' ', escLine);
          if PosSpace >= 1 then
            fEscapeLines.AddPair(Trim(Copy(escLine, 1, PosSpace-1)), Trim(Copy(escLine, PosSpace+1, length(escLine))));
        end;
  end;
end;

procedure TAudioExport.ParseTemplateFile(Filename: String);
var
  sl: TStringList;
  i, idxFilesBegin, idxFilesEnd, idxMetaBegin, idxMetaEnd: Integer;
begin
  fMetaLines.Clear;
  fHeaderStrings.Clear;
  fFooterStrings.Clear;
  fTemplateLines.Clear;
  fEscapeLines.Clear;

  sl := TStringList.Create;
  try
    sl.LoadFromFile(Filename);
    sl.CaseSensitive := False;
    idxFilesBegin := sl.IndexOf(cFilesStart);
    idxFilesEnd := sl.IndexOf(cFilesEnd);
    idxMetaBegin := sl.IndexOf(cMetaStart);
    idxMetaEnd := sl.IndexOf(cMetaEnd);

    for i := idxMetaBegin + 1 to idxMetaEnd - 1 do
      fMetaLines.Add(sl[i]);
    for i := idxMetaEnd + 1 to idxFilesBegin - 1 do
      fHeaderStrings.Add(sl[i]);
    for i := idxFilesBegin + 1 to idxFilesEnd - 1 do
      fTemplateLines.Add(sl[i]);
    for i := idxFilesEnd + 1 to sl.Count - 1 do
      fFooterStrings.Add(sl[i]);

    ParseMetaBlock;
  finally
    sl.Free;
  end;
end;

function TAudioExport.ExportFiles(AudioFiles: TAudioFileList; TargetFilename: String): Boolean;
var
  sl: TStringList;
  i, iFile: Integer;
  totalCount: Integer;
  totalSize: Int64;
  totalDuration: Int64;

  function ParseGeneralLine(Value: String): String;
  begin
    result := Value;
    result := StringReplace(result, phTotalCount, totalCount.ToString, [rfReplaceAll, rfIgnoreCase]);
    result := StringReplace(result, phTotalBytes, totalSize.ToString, [rfReplaceAll, rfIgnoreCase]);
    result := StringReplace(result, phTotalSeconds, totalDuration.ToString, [rfReplaceAll, rfIgnoreCase]);
  end;

begin
  ParseTemplateFile(fTemplateFilename); // parse it again, if the user changed the file in the meantime

  totalCount := AudioFiles.Count;
  totalSize := 0;
  totalDuration := 0;
  for i := 0 to AudioFiles.Count - 1 do begin
    totalSize := totalSize + AudioFiles[i].Size;
    totalDuration := totalDuration + AudioFiles[i].Duration;
  end;

  result := True;
  sl := TStringList.Create;
  try
    sl.Capacity :=
        fHeaderStrings.Count +
        fFooterStrings.Count +
        AudioFiles.Count * (fTemplateLines.Count);

    for i := 0 to fHeaderStrings.Count - 1 do
      sl.Add(ParseGeneralLine(fHeaderStrings[i]));

    for iFile := 0 to AudioFiles.Count - 1 do begin
      for i := 0 to fTemplateLines.Count - 1 do
        sl.Add(ParseTemplateLine(fTemplateLines[i], AudioFiles[iFile]));
    end;

    for i := 0 to fFooterStrings.Count - 1 do
      sl.Add(ParseGeneralLine(fFooterStrings[i]));

    sl.SaveToFile(TargetFilename, fEncoding);
  finally
    FreeAndNil(sl);
  end;
end;

function TAudioExport.GetTemplateFilename: String;
begin
  result := fTemplateFilename;
end;

procedure TAudioExport.SetTemplateFilename(Value: String);
begin
  if Value <> fTemplateFilename then begin
    fTemplateFilename := Value;
    ParseTemplateFile(fTemplateFilename);
  end;
end;

function TAudioExport.EscapeProperty(Value: String): String;
begin
  result := Value;
  for var i: Integer := 0 to fEscapeLines.Count - 1 do
    result := StringReplace(result, fEscapeLines.Names[i], fEscapeLines.ValueFromIndex[i], [rfReplaceAll, rfIgnoreCase]);
end;

function TAudioExport.EscapedAudioProperty(aAudioFile: TAudioFile; aPlaceHolder: string): string;
var
  i: TEAudioProperty;
begin
  result := aPlaceHolder;
  for i := Low(TEAudioProperty) to High(TEAudioProperty) do begin
    if SameText(PlaceHolders[i], aPlaceHolder) then begin
      result := EscapeProperty(GetAudioProperty(aAudioFile, i));
      break;
    end;
  end;
end;

// Parse a single line in the Template; replace <placeholder> with matching property from the audiofile
function TAudioExport.ParseTemplateLine(Template: String;
  AudioFile: TAudioFile): String;
var
  CurrentSegment: String;
  offset: Integer;
  IsPlaceHolder: Boolean;

  function GetNextSegment: String;
  var
    start: Integer;
  begin
    IsPlaceHolder := Template[offset] = '<';
    start := Offset;
    inc(offset);
    while (offset <= Length(Template)) do begin
      if IsPlaceHolder then begin
          // segment is (or at least could be) a placeholder
          if Template[offset] = '<' then begin
            IsPlaceHolder := False;
            break; // segment finished; but it is not a placeholder.
          end else
          if Template[offset] = '>' then begin
            inc(offset);
            break; // Segment finished; PlaceHoder seems to be valid so far.
          end else
            inc(offset); // go on
      end else begin
          // segment is not a placeholder, go on until we find a '<'
          if Template[offset] = '<' then
            break // a PlaceHolder may start here.
          else
            inc(offset); // go on
      end;
    end; // while
    result := Copy(Template, start, offset-start);
  end;

begin
  offset := 1;
  result := '';

  while (offset <= Length(Template)) do begin
    CurrentSegment := GetNextSegment;
    if IsPlaceHolder then begin
      // check, whether it is actually a valid Placeholder
      result := result + EscapedAudioProperty(AudioFile, CurrentSegment);
    end else begin
      result := result + CurrentSegment;
    end;
  end;

end;

end.
