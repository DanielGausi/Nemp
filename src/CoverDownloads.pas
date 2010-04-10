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
        distance: Integer;      // distance to MostImportantIndex
        lastChecked: TDateTime; // time of last query for this Item
        queryCount: Integer;    // Used to increase the Cache-Interval

        procedure LoadFromStream(aStream: TStream); // loading/saving in Thread-Context
        procedure SaveToStream(aStream: TStream);
    end;

    TPicType = (ptNone, ptJPG, ptPNG);

    TCoverDownloadWorkerThread = class(TThread)
        private
            { Private-Deklarationen }
            fSemaphore: THandle;
            fIDHttp: TIdHttp;

            // Thread-Copy for the Item that is currently processed
            fCurrentDownloadItem: TCoverDownloadItem;

            // LastFM allows only 5 calls per Second
            // The GetTag-Method will be calles very often - so we need a speed-limit here!
            fLastCall: DWord;

            fJobList: TObjectList;   // Access only from VCL !!!

            fXMLData: AnsiString;        // API-Response
            fBestCoverURL: AnsiString;   // URL of the "extra-large" cover, if available
            fDataStream: TMemoryStream;  // Stream containing the Picture-Data
            fDataType: TPicType;

            fMostImportantIndex: Integer;
            procedure SetMostImportantIndex(Value: Integer);    // VCL


            // Thread-methods. Downloading, parsing, ...
            function QueryLastFMCoverXML: Boolean;
            function GetBestCoverUrlFromXML: Boolean;
            function DownloadBestCoverToStream: Boolean;
            // CacheList
            procedure LoadCacheList;
            procedure SaveCacheList;


            // VCL-methods
            function StreamToBitmap(TargetBMP: TBitmap): Boolean;

            procedure StartWorking;  // VCL
            // Get next job, i.e. information about the next queried cover
            function SyncGetFirstJob: Boolean; // VCL
            // Update the Cover in Coverflow (or: in Player?)
            function SyncUpdateCover: Boolean; // VCL

        protected
            procedure Execute; override;

        public
            property MostImportantIndex: Integer read fMostImportantIndex write SetMostImportantIndex;

            constructor Create;
            destructor Destroy; override;

            procedure AddJob(aCover: TNempCover; Idx: Integer); // VCL
    end;

    function SortDownloadPriority(item1,item2: Pointer): Integer;

implementation

uses NempMainUnit, ScrobblerUtils, Hilfsfunktionen;


function SortDownloadPriority(item1,item2: Pointer): Integer;
begin
    result := CompareValue(TCoverDownloadItem(item1).Distance, TCoverDownloadItem(item2).Distance);
end;

{ TCoverDownloadItem }

procedure TCoverDownloadItem.LoadFromStream(aStream: TStream);
begin
      // ToDo
end;

procedure TCoverDownloadItem.SaveToStream(aStream: TStream);
begin
      // ToDo
end;


{ TCoverDownloadWorkerThread }

constructor TCoverDownloadWorkerThread.Create;
begin
    inherited create(True);
    fIDHttp := TIdHttp.Create;
    fJobList := TObjectList.Create;
    fDataStream := TMemoryStream.Create;
    fCurrentDownloadItem := TCoverDownloadItem.Create;
    fSemaphore := CreateSemaphore(Nil, 0, maxInt, Nil);
    FreeOnTerminate := False;

    fIDHttp.ConnectTimeout:= 5000;
    fIDHttp.ReadTimeout:= 5000;
    fIDHttp.Request.UserAgent := 'Mozilla/3.0';
    fIDHttp.HTTPOptions :=  [];

    Resume;
end;

destructor TCoverDownloadWorkerThread.Destroy;
begin
    fIDHttp.Free;
    fDataStream.Free;
    fJobList.Free;
    fCurrentDownloadItem.Free;
    inherited;
end;

procedure TCoverDownloadWorkerThread.Execute;
var n: DWord;
    CacheList: TObjectList;
begin
    // LoadCacheList
    CacheList := TObjectList.Create;

    try
        While Not Terminated do
        begin
            if (WaitforSingleObject(fSemaphore, 1000) = WAIT_OBJECT_0) then
            if not Terminated then
            begin
                if SyncGetFirstJob then
                begin
                    n := GetTickCount;
                    if n - fLastCall < 250 then
                        sleep(250);
                    fLastCall := GetTickCount;

                    QueryLastFMCoverXML;
                    GetBestCoverUrlFromXML;
                    DownloadBestCoverToStream;

                    SyncUpdateCover;
                end;
            end;
        end;

    finally
        CacheList.Free;
    end;
end;

{
    --------------------------------------------------------
    LoadCacheList:
    -
    --------------------------------------------------------
}
procedure TCoverDownloadWorkerThread.LoadCacheList;
begin

end;

procedure TCoverDownloadWorkerThread.SaveCacheList;
begin

end;

{
    --------------------------------------------------------
    fDownloadXML:
    - download the XML-Reply from the LastFM API
      save the reply in Self.fXMLData
    --------------------------------------------------------
}
function TCoverDownloadWorkerThread.QueryLastFMCoverXML: Boolean;
var url: UTF8String;
begin

    url := 'http://ws.audioscrobbler.com/2.0/?method=album.getinfo'
        + '&api_key=' + api_key
        + '&artist=' + StringToURLStringAnd(AnsiLowerCase(fCurrentDownloadItem.Artist))
        + '&album='  + StringToURLStringAnd(AnsiLowerCase(fCurrentDownloadItem.Album));
    try
        fXMLData := fIDHttp.Get(url);
        result := True;
    except
        on E: Exception do
        begin
          fXMLData := E.Message;
          result := False;
        end;
    end;
end;

{
    --------------------------------------------------------
    GetBestCoverUrlFromXML:
    - Parse the fXMLData and get a Cover URL
      save the URL in Self.fBestCoverURL
    --------------------------------------------------------
}
function TCoverDownloadWorkerThread.GetBestCoverUrlFromXML: Boolean;
var s, e: Integer;
    offset: Integer;
begin
    s := Pos('<image size="extralarge">', fXMLData);
    offset := length('<image size="extralarge">');

    if s = 0 then
    begin
        s := Pos('<image size="large">', fXMLData);
        offset := length('<image size="large">');
    end;

    if s > 0 then
    begin
        e := PosEx('</image>', fXMLData, s);
        fBestCoverURL := Copy(fXMLData, s + offset, e - (s + offset));
        result := True;
    end else
    begin
        result := False;
        fBestCoverURL := '';
    end;
end;


{
    --------------------------------------------------------
    DownloadBestCoverToStream:
    - Download Cover from fBestCoverURL
    --------------------------------------------------------
}
function TCoverDownloadWorkerThread.DownloadBestCoverToStream: Boolean;
begin
    if fBestCoverURL <> '' then
    begin
        fDataStream.Clear;
        try
            fIDHttp.Get(fBestCoverURL, fDataStream);
        except
            fDataStream.Clear;
            result := False;
            fDataType := ptNone;
        end;

        if AnsiEndsText('.jpg', fBestCoverURL) then
            fDataType := ptJPG
        else
        if AnsiEndsText('.png', fBestCoverURL) then
            fDataType := ptPNG
        else
        if AnsiEndsText('.jpeg', fBestCoverURL) then
            fDataType := ptJPG
        else
            fDataType := ptNone;
    end else
    begin
        result := False;
        fDataType := ptNone;
        fDataStream.Clear;
    end;
end;

{
    --------------------------------------------------------
    StreamToBitmap:
    - Load StreamData into the Bitmap.
      VCL-THREAD ONLY !!!
    --------------------------------------------------------
}
function TCoverDownloadWorkerThread.StreamToBitmap(TargetBMP: TBitmap): Boolean;
var jp: TJPEGImage;
    png: TPNGImage;
    localBMP: TBitmap;
begin
    localBMP := TBitmap.Create;
    try
        case fDataType of
            ptNone: begin
                result := False;
                // nothing mor to do. Unknown Picture-Data :(
            end;
            ptJPG: begin
                fDataStream.Seek(0, soFromBeginning);
                jp := TJPEGImage.Create;
                try
                    try
                        jp.LoadFromStream(fDataStream);
                        jp.DIBNeeded;
                        localBMP.Assign(jp);
                        SetStretchBltMode(TargetBMP.Canvas.Handle, HALFTONE);
                        StretchBlt(TargetBMP.Canvas.Handle, 0 ,0, TargetBMP.Width, TargetBMP.Height,
                                   localBMP.Canvas.Handle, 0, 0, localBMP.Width, localBMP.Height, SRCCopy);
                        result := True;
                    except
                        result := False;
                        TargetBMP.Assign(NIL);
                    end;
                finally
                    jp.Free;
                end;
            end;
            ptPNG: begin
                fDataStream.Seek(0, soFromBeginning);
                png := TPNGImage.Create;
                try
                    try
                        png.LoadFromStream(fDataStream);
                        localBMP.Assign(png);
                        SetStretchBltMode(TargetBMP.Canvas.Handle, HALFTONE);
                        StretchBlt(TargetBMP.Canvas.Handle, 0 ,0, TargetBMP.Width, TargetBMP.Height,
                                   localBMP.Canvas.Handle, 0, 0, localBMP.Width, localBMP.Height, SRCCopy);
                        result := True;
                    except
                        result := False;
                        TargetBMP.Assign(NIL);
                    end;
                finally
                    png.Free;
                end;
            end;
        end;
    finally
        localBMP.Free;
    end;

end;

{
    --------------------------------------------------------
    AddJob: Called from the VCL
    VCL-THREAD ONLY !!!
    --------------------------------------------------------
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

{
    --------------------------------------------------------
    SetMostImportantIndex
    - Used to download centered Covers in the Coverflow first
      called from CoverFlow.SetcurrentItem
    VCL-THREAD ONLY !!!
    --------------------------------------------------------
}
procedure TCoverDownloadWorkerThread.SetMostImportantIndex(Value: Integer);
var i: Integer;
    aDownloadItem: TCoverDownloadItem;

begin
    if fMostImportantIndex <> Value then
    begin
        fMostImportantIndex := Value;
        for i := 0 to fJobList.Count - 1 do
        begin
            aDownloadItem := TCoverDownloadItem(fJobList[i]);
            aDownloadItem.distance := abs(aDownloadItem.Index - Value);
        end;
        fJobList.Sort(SortDownloadPriority);
    end;
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
    r: TRect;
    s: String;
    success: Boolean;
begin
    // result: Cover has been updated
    // false, if something has changed (i.e. cover artist/album does not match idx any more)

    result := True;

    bmp := TBitmap.Create;
    try
        bmp.PixelFormat := pf24bit;

        bmp.Height := 240;
        bmp.Width := 240;

        success := StreamToBitmap(bmp);
        //if not success then
        begin
            if self.fXMLData <> '' then
            begin
                bmp.Canvas.Font.Size := 6;
                r := Rect(0,0,240,10);
                s := fBestCoverURL;//fXMLData;
                bmp.Canvas.TextRect(r, s, [tfWordBreak]);
            end else
            begin
                bmp.Canvas.Font.Size := 16;
                bmp.Canvas.TextOut(10, 10, fCurrentDownloadItem.Artist);
                bmp.Canvas.TextOut(10, 80, fCurrentDownloadItem.Album);
            end;
        end;

        Medienbib.NewCoverFlow.SetPreview (fCurrentDownloadItem.Index, bmp.Width, bmp.Height, bmp.Scanline[bmp.Height-1]);

        MedienBib.NewCoverFlow.Paint(1);
    finally
        bmp.free;
    end;
end;



end.
