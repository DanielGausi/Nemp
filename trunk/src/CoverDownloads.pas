{

    Unit CoverDownloads

    Class TCoverDownloadWorkerThread
        A Workerthread for downloading Covers from LastFM using its API

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2009, Daniel Gaussmann
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

    Additional permissions

    If you modify this Program, or any covered work, by linking or combining it
    with
        - the bass.dll and it addons
          (including, but not limited to the bass_fx.dll)
        - MadExcept
        - DGL-OpenGL
        - FSPro Windows 7 Taskbar Components
    or a modified version of these libraries, the licensors of this Program
    grant you additional permission to convey the resulting work.

    ---------------------------------------------------------------
}
unit CoverDownloads;

interface

uses
  Windows, Messages, SysUtils,  Classes, Graphics,
  Dialogs, StrUtils, ContNrs, Jpeg, PNGImage, GifImg, math,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IdStack, IdException,
  CoverHelper, MP3FileUtils, ID3v2Frames, AudioFileClass, Nemp_ConstantsAndTypes;

type

    TCoverDownloadItem = class
        Artist: String;
        Album: String;
        Directory: String;
        Index: Integer;
    end;


    TCoverDownloadWorkerThread = class(TThread)
        private
            { Private-Deklarationen }
            fSemaphore: THandle;
            fIDHttp: TIdHttp;

            // Thread-Copy for the Item that is currently processed
            fCurrentDownloadItem: TCoverDownloadItem;

            fJobList: TObjectList;   // Access only from VCL

            procedure StartWorking;  // executed in VCL
            // Get next job, i.e. information about the next queried cover
            function SyncGetFirstJob: Boolean;
            // Update the Cover in Coverflow (or: in Player?)
            function SyncUpdateCover: Boolean;

        protected
            procedure Execute; override;

        public
            DataStream: TMemoryStream;
            constructor Create;
            destructor Destroy; override;

            // called from VCL
            procedure AddJob(aCover: TNempCover; Idx: Integer);

    end;

implementation

uses NempMainUnit;

{ Wichtig: Methoden und Eigenschaften von Objekten in visuellen Komponenten dürfen 
  nur in einer Methode namens Synchronize aufgerufen werden, z.B.

      Synchronize(UpdateCaption);

  und UpdateCaption könnte folgendermaßen aussehen:

    procedure TCoverDownloadWorkerThread.UpdateCaption;
    begin
      Form1.Caption := 'Aktualisiert in einem Thread';
    end; }

{ TCoverDownloadWorkerThread }



constructor TCoverDownloadWorkerThread.Create;
begin
    inherited create(True);
    fIDHttp := TIdHttp.Create;
    fJobList := TObjectList.Create;
    DataStream := TMemoryStream.Create;
    fCurrentDownloadItem := TCoverDownloadItem.Create;
    fSemaphore := CreateSemaphore(Nil, 0, maxInt, Nil);
    FreeOnTerminate := False;

    Resume;
end;

destructor TCoverDownloadWorkerThread.Destroy;
begin
    fIDHttp.Free;
    DataStream.Free;
    fJobList.Free;
    fCurrentDownloadItem.Free;
    inherited;
end;

procedure TCoverDownloadWorkerThread.Execute;
begin
    While Not Terminated do
    begin
        if (WaitforSingleObject(fSemaphore, 1000) = WAIT_OBJECT_0) then
        if not Terminated then
        begin
            if SyncGetFirstJob then
            begin
                // work with fCurrentDownloadItem
                sleep (500);
                !!!

                SyncUpdateCover;
            end;
        end;
    end;
end;

{
    AddJob: Called from the VCL
}
procedure TCoverDownloadWorkerThread.AddJob(aCover: TNempCover; Idx: Integer);
var NewDownloadItem: TCoverDownloadItem;
begin
    NewDownloadItem := TCoverDownloadItem.Create;
    NewDownloadItem.Artist    := aCover.Artist;
    NewDownloadItem.Album     := aCover.Album;
    NewDownloadItem.Directory := aCover.Directory;
    NewDownloadItem.Index     := Idx;
    fJobList.Insert(0, NewDownloadItem);
    if fJobList.Count > 50 then
        fJobList.Delete(fJobList.Count-1);

    StartWorking;
end;

procedure TCoverDownloadWorkerThread.StartWorking;
begin
    ReleaseSemaphore(fSemaphore, 1, Nil);
end;

function TCoverDownloadWorkerThread.SyncGetFirstJob: Boolean;
var fi: TCoverDownloadItem;
begin
    // result: True if there is something to do
    if fJobList.Count > 0 then
    begin
        // Copy the Item from the List, so the Thread can savely work on this
        fi := TCoverDownloadItem(fJobList.Items[0]);
        fCurrentDownloadItem.Artist      := fi.Artist    ;
        fCurrentDownloadItem.Album       := fi.Album     ;
        fCurrentDownloadItem.Directory   := fi.Directory ;
        fCurrentDownloadItem.Index       := fi.Index     ;
        fJobList.Delete(0);
        result := True;
    end
    else
        result := False;
end;

function TCoverDownloadWorkerThread.SyncUpdateCover: Boolean;
var bmp: TBitmap;
begin
    // result: Cover has been updated
    // false, if something has changed (i.e. cover artist/album does not match idx any more)

    result := True;

    bmp := TBitmap.Create;
    try
        bmp.PixelFormat := pf24bit;
        bmp.Height := 240;
        bmp.Width := 240;

        bmp.Canvas.Font.Size := 16;
        bmp.Canvas.TextOut(10, 10, fCurrentDownloadItem.Artist);
        bmp.Canvas.TextOut(10, 80, fCurrentDownloadItem.Album);

        Medienbib.NewCoverFlow.SetPreview (fCurrentDownloadItem.Index, bmp.Width, bmp.Height, bmp.Scanline[bmp.Height-1]);

        MedienBib.NewCoverFlow.Paint(1);
    finally
        bmp.free;
    end;
end;

end.
