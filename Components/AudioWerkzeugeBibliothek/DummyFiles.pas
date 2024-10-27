{
    -----------------------------------
    Audio Werkzeuge Bibliothek
    -----------------------------------
    (c) 2012-2020, Daniel Gaussmann
              Website : www.gausi.de
              EMail   : mail@gausi.de
    -----------------------------------

    Unit DummyFiles

    A Dummy file class for "not supported" audiotypes
    Can be created by the Factory to simplify the handling for files that are supported by a player
    but not by this library.
    (read only)

    ---------------------------------------------------------------------------

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

    ---------------------------------------------------------------------------

    Alternatively, you may use this unit under the terms of the
    MOZILLA PUBLIC LICENSE (MPL):

    The contents of this file are subject to the Mozilla Public License
    Version 1.1 (the "License"); you may not use this file except in
    compliance with the License. You may obtain a copy of the License at
    http://www.mozilla.org/MPL/

    Software distributed under the License is distributed on an "AS IS"
    basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
    License for the specific language governing rights and limitations
    under the License.

    ---------------------------------------------------------------------------
}

unit DummyFiles;

interface

uses Classes, SysUtils, AudioFiles.Base, AudioFiles.Declarations, AudioFiles.BaseTags;


type

    TDummyFile = class(TBaseAudioFile)
        private
            procedure fResetData;
        protected
            procedure fSetTitle           (aValue: UnicodeString); override;
            procedure fSetArtist          (aValue: UnicodeString); override;
            procedure fSetAlbum           (aValue: UnicodeString); override;
            procedure fSetYear            (aValue: UnicodeString); override;
            procedure fSetTrack           (aValue: UnicodeString); override;
            procedure fSetGenre           (aValue: UnicodeString); override;
            procedure fSetAlbumArtist (value: UnicodeString); override;
            procedure fSetLyrics          (aValue: UnicodeString); override;

            function fGetTitle            : UnicodeString; override;
            function fGetArtist           : UnicodeString; override;
            function fGetAlbum            : UnicodeString; override;
            function fGetYear             : UnicodeString; override;
            function fGetTrack            : UnicodeString; override;
            function fGetGenre            : UnicodeString; override;
            function fGetFileType            : TAudioFileType; override;
            function fGetFileTypeDescription : String;         override;
            function fGetAlbumArtist : UnicodeString; override;
            function fGetLyrics           : UnicodeString;  override;

        public
            { Public declarations }
            constructor Create; override;
            function ReadFromFile(aFilename: UnicodeString): TAudioError;   override;
            function WriteToFile(aFilename: UnicodeString): TAudioError;    override;
            function RemoveFromFile(aFilename: UnicodeString): TAudioError; override;
            // dummy methods
            procedure GetTagList(Dest: TTagItemList; ContentTypes: TTagContentTypes = cDefaultTagContentTypes); override;
            procedure DeleteTagItem(aTagItem: TTagItem); override;
            function GetUnusedTextTags: TTagItemInfoDynArray; override;
            function AddTextTagItem(aKey, aValue: UnicodeString): TTagItem; override;
            function SetPicture(Source: TStream; Mime: AnsiString; PicType: TPictureType; Description: UnicodeString): Boolean; override;
        end;

implementation

function TDummyFile.AddTextTagItem(aKey, aValue: UnicodeString): TTagItem;
begin
  result := Nil;
end;

constructor TDummyFile.Create;
begin
    inherited;
    fResetData;
end;

function TDummyFile.fGetFileType: TAudioFileType;
begin
    result := at_Invalid;

end;

function TDummyFile.fGetFileTypeDescription: String;
begin
    result := cAudioFileType[at_Invalid];
end;

procedure TDummyFile.FResetData;
begin
    // Reset variables
    fValid := false;
    fFileSize := 0;
    fSampleRate := 0;
    fChannels := 0;
    fDuration := 0;
    fBitRate := 0;
end;

procedure TDummyFile.fSetAlbum(aValue: UnicodeString);
begin
  inherited;
  // nothing. This Unit is read-Only
end;

procedure TDummyFile.fSetAlbumArtist(value: UnicodeString);
begin
  inherited;
  // nothing. This Unit is read-Only
end;

procedure TDummyFile.fSetArtist(aValue: UnicodeString);
begin
  inherited;
  // nothing. This Unit is read-Only
end;

procedure TDummyFile.fSetGenre(aValue: UnicodeString);
begin
  inherited;
  // nothing. This Unit is read-Only
end;

procedure TDummyFile.fSetLyrics(aValue: UnicodeString);
begin
  inherited;
  // nothing. This Unit is read-Only
end;

procedure TDummyFile.fSetTitle(aValue: UnicodeString);
begin
  inherited;
  // nothing. This Unit is read-Only
end;

procedure TDummyFile.fSetTrack(aValue: UnicodeString);
begin
  inherited;
  // nothing. This Unit is read-Only
end;

procedure TDummyFile.fSetYear(aValue: UnicodeString);
begin
  inherited;
  // nothing. This Unit is read-Only
end;

procedure TDummyFile.GetTagList(Dest: TTagItemList;
  ContentTypes: TTagContentTypes);
begin
  inherited;
  // nothing. This Unit is read-Only
end;

function TDummyFile.GetUnusedTextTags: TTagItemInfoDynArray;
begin
  SetLength(result, 0);
end;

{ --------------------------------------------------------------------------- }

procedure TDummyFile.DeleteTagItem(aTagItem: TTagItem);
begin
  inherited;
  // nothing. This Unit is read-Only
end;

function TDummyFile.fGetAlbum: UnicodeString;
begin
    result := '';
end;

function TDummyFile.fGetAlbumArtist: UnicodeString;
begin
  result := '';
end;

function TDummyFile.fGetArtist: UnicodeString;
begin
    result := '';
end;

function TDummyFile.fGetGenre: UnicodeString;
begin
    result := '';
end;

function TDummyFile.fGetLyrics: UnicodeString;
begin
  result := '';
end;

function TDummyFile.fGetTitle: UnicodeString;
begin
    result := '';
end;

function TDummyFile.fGetTrack: UnicodeString;
begin
    result := '';
end;

function TDummyFile.fGetYear: UnicodeString;
begin
    result := '';
end;


{ --------------------------------------------------------------------------- }

function TDummyFile.ReadFromFile(aFilename: UnicodeString): TAudioError;
var fs: TAudioFileStream;
begin
    inherited ReadFromFile(aFilename);

    fResetData;
    result := FileErr_NotSupportedFileType;

    if AudioFileExists(aFilename) then
    begin
        try
            fs := TAudioFileStream.Create(aFilename, fmOpenRead or fmShareDenyWrite);
            try
                fFileSize := fs.Size;
            finally
                fs.Free;
            end;
        except
            result := FileErr_FileOpenR;
        end;
    end
    else
        result := FileErr_NoFile;
end;

function TDummyFile.RemoveFromFile(aFilename: UnicodeString): TAudioError;
begin
    inherited RemoveFromFile(aFilename);
    result := FileErr_NotSupportedFileType;
end;

function TDummyFile.SetPicture(Source: TStream; Mime: AnsiString;
  PicType: TPictureType; Description: UnicodeString): Boolean;
begin
  result := false;
end;

function TDummyFile.WriteToFile(aFilename: UnicodeString): TAudioError;
begin
    inherited WriteToFile(aFilename);
    result := FileErr_NotSupportedFileType;
end;


end.
