{

    Unit CoverDownloads

    Class TCoverDownloadWorkerThread
        A Workerthread for downloading Covers from LastFM using its API

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2005-2010, Daniel Gaussmann
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
unit CoverDownloads;

interface

uses
  Windows, Messages, SysUtils,  Classes, Graphics,
  Dialogs, StrUtils, ContNrs, Jpeg, PNGImage, GifImg, math, DateUtils,
  IdBaseComponent, IdComponent,  IdHTTP, IdStack, IdException,
  CoverHelper, MP3FileUtils, ID3v2Frames, AudioFileClass, Nemp_ConstantsAndTypes, SyncObjs;

const
    ccArtist     = 0;
    ccAlbum      = 1;
    ccDirectory  = 2;
    ccQueryCount = 3;
    ccLastQuery  = 4;
    ccDataEnd    = 255;

type



    TPicType = (ptNone, ptJPG, ptPNG);

    TQueryType = (qtCoverFlow, qtPlayer);

    TCoverDownloadItem = class
        Artist: String;
        Album: String;
        Directory: String;
        QueryType: TQueryType;
        FileType: String;
        Index: Integer;         // used in CoverFlow
        distance: Integer;      // distance to MostImportantIndex
        lastChecked: TDateTime; // time of last query for this Item
        queryCount: Integer;    // Used to increase the Cache-Interval

        procedure LoadFromStream(aStream: TStream); // loading/saving in Thread-Context
        procedure SaveToStream(aStream: TStream);
    end;


    TCoverDownloadWorkerThread = class(TThread)
        private
            { Private-Deklarationen }
            fIDHttp: TIdHttp;

            //fSemaphore: THandle;
            fEvent: TEvent;

            // Thread-Copy for the Item that is currently processed
            fCurrentDownloadItem: TCoverDownloadItem;
            fCurrentDownloadComplete: Boolean;
            FWorkToDo: Boolean;

            // LastFM allows only 5 calls per Second
            // The GetTag-Method will be calles very often - so we need a speed-limit here!
            fLastCall: DWord;

            fJobList: TObjectList;   // Access only from VCL !!!

            fInternetConnectionLost: Boolean;
            fXMLData: AnsiString;        // API-Response
            fBestCoverURL: AnsiString;   // URL of the "extra-large" cover, if available
            fDataStream: TMemoryStream;  // Stream containing the Picture-Data
            fNewCoverFilename: String;   // Local Filename of the downloaded Coverfile
            fDataType: TPicType;

            fCacheFilename: String;
            fCacheList: TObjectList;   // Always use CriticalSection CSAccessCacheList to access this List!
                                       // The List is mainly used by the secondary thread, but can be deleted by the Settings-dialog.

            fMostImportantIndex: Integer;
            procedure SetMostImportantIndex(Value: Integer);    // VCL

            // for player-picture: Get proper Album-Information
            procedure CollectFiles(aList: TStringList);
            procedure CollectAudioInformation(source: TStringList; Target: TObjectList);
            function IsProperAlbum(aAudioFileList: TObjectList): Boolean;
            function CollectAlbumInformation: Boolean;


            // Thread-methods. Downloading, parsing, ...
            function QueryLastFMCoverXML: Boolean;
            function GetBestCoverUrlFromXML: Boolean;
            function DownloadBestCoverToStream: Boolean;
            procedure SavePicStreamToFile;

            // CacheList
            procedure LoadCacheList;
            procedure SaveCacheList;

            function GetMatchingCacheItem: TCoverDownloadItem;
            function CacheItemCanBeRechecked(aCacheItem: TCoverDownloadItem): Boolean;


            // VCL-methods
            function StreamToBitmap(TargetBMP: TBitmap): Boolean;

            procedure StartWorking;  // VCL

            procedure SetProperBitmapSize(aBmp: TBitmap; aQueryType: TQueryType);

            function DownloadItemStillMatchesCoverFlow: Boolean;  // VCL (called in Sync-methods)
            function DownloadItemStillMatchesPlayer: Boolean;  // VCL (called in Sync-methods)

            // Get next job, i.e. information about the next queried cover
            procedure SyncGetFirstJob; // VCL
            // Update the Cover in Coverflow (or: in Player?)
            procedure SyncUpdateCover; // VCL
            procedure SyncUpdateCoverCacheBlocked; // VCL
            procedure SyncUpdateInvalidCover; // VCL
            procedure AddLogoToBitmap(aLogo: String; Target: TBitmap);
            // Update CoverFlow-Data in Medialibrary
            procedure SyncUpdateMedialib;


        protected
            procedure Execute; override;

        public
            property MostImportantIndex: Integer read fMostImportantIndex write SetMostImportantIndex;

            constructor Create;
            destructor Destroy; override;

            procedure AddJob(aCover: TNempCover; Idx: Integer); overload;     // VCL
            procedure AddJob(aAudioFile: TAudioFile; Idx: Integer); overload; // VCL

            procedure ClearCacheList; // VCL
    end;

    function SortDownloadPriority(item1,item2: Pointer): Integer;

var
    CSAccessCacheList: RTL_CRITICAL_SECTION;

implementation

uses NempMainUnit, ScrobblerUtils, HtmlHelper, SystemHelper, Nemp_RessourceStrings, OneInst;


function SortDownloadPriority(item1,item2: Pointer): Integer;
begin
    result := CompareValue(TCoverDownloadItem(item1).Distance, TCoverDownloadItem(item2).Distance);
end;

{ TCoverDownloadItem }


{
    --------------------------------------------------------
    LoadFromStream:
    - Load a CacheItem from a Stream
      String information is stored as UTF8
    --------------------------------------------------------
}
procedure TCoverDownloadItem.LoadFromStream(aStream: TStream);
var c: Integer;
    id: Byte;

        function ReadTextFromStream: String;
        var len: Integer;
            tmputf8: UTF8String;
        begin
            aStream.Read(len,sizeof(len));
            setlength(tmputf8, len);
            aStream.Read(PAnsiChar(tmputf8)^, len);
            result := UTF8ToString(tmputf8);
        end;

begin
    c := 0;
    repeat
        aStream.Read(id, sizeof(ID));
        inc(c);
        case ID of
            ccArtist     : Artist := ReadTextFromStream;
            ccAlbum      : Album  := ReadTextFromStream;
            ccDirectory  : Directory  := ReadTextFromStream;
            ccQueryCount : aStream.Read(queryCount, SizeOf(queryCount));
            ccLastQuery  : aStream.Read(lastChecked, SizeOf(LastChecked));
            ccDataEnd    : ;  // Nothing to do
        else
            ID := ccDataEnd;  // Somthing was wrong, abort
        end;
    until (ID = ccDataEnd) or (c >= ccDataEnd);
end;
{
    --------------------------------------------------------
    SaveToStream:
    - Save the data
      String information is stored as UTF8
    --------------------------------------------------------
}
procedure TCoverDownloadItem.SaveToStream(aStream: TStream);
var ID: Byte;

        procedure WriteTextToStream(ID: Byte; wString: UnicodeString);
        var len: integer;
            tmpStr: UTF8String;
        begin
            aStream.Write(ID,sizeof(ID));
            tmpstr := UTF8Encode(wString);
            len := length(tmpstr);
            aStream.Write(len,SizeOf(len));
            aStream.Write(PAnsiChar(tmpstr)^,len);
        end;

begin
    WriteTextToStream(ccArtist   , Artist);
    WriteTextToStream(ccAlbum    , Album );
    WriteTextToStream(ccDirectory, Directory);

    ID := ccQueryCount;
    aStream.Write(ID, sizeof(ID));
    aStream.Write(QueryCount, sizeOf(QueryCount));

    ID := ccLastQuery;
    aStream.Write(ID, sizeof(ID));
    aStream.Write(lastChecked, sizeOf(lastChecked));

    ID := ccDataEnd;
    aStream.Write(ID, sizeof(ID));
end;


{ TCoverDownloadWorkerThread }

constructor TCoverDownloadWorkerThread.Create;
begin
    inherited create(True);
    fIDHttp := TIdHttp.Create;
    fJobList := TObjectList.Create;
    fDataStream := TMemoryStream.Create;
    fCurrentDownloadItem := TCoverDownloadItem.Create;

    //fSemaphore := CreateSemaphore(Nil, 0, maxInt, Nil);
    fEvent := TEvent.Create(Nil, True, False, '');


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
    fEvent.Free;
    inherited;
end;

procedure TCoverDownloadWorkerThread.Execute;
var n: DWord;
    CurrentCacheItem: TCoverDownloadItem;
    NewCacheItem: TCoverDownloadItem;
    ProperAlbum: Boolean;
begin
    // LoadCacheList
    fCacheList := TObjectList.Create;
    if IsExeInProgramSubDir then
        fCacheFilename := GetShellFolder(CSIDL_APPDATA) + '\Gausi\Nemp\CoverCache'
    else
        fCacheFilename := ExtractFilePath(ParamStr(0)) + 'Data\CoverCache';
    LoadCacheList;

    try
        While Not Terminated do
        begin

            //if (WaitforSingleObject(fSemaphore, 1000) = WAIT_OBJECT_0) then
            if fEvent.WaitFor(1000) = wrSignaled then
            begin
                if not Terminated then
                begin
                    FWorkToDo := False;  // will be set to True again in SyncGetFirstJob
                    Synchronize(SyncGetFirstJob);
                    if FWorkToDo then
                    begin
                        // Block CacheList
                        EnterCriticalSection(CSAccessCacheList);

                        if fCurrentDownloadItem.QueryType = qtPlayer then
                            ProperAlbum := CollectAlbumInformation
                        else
                            ProperAlbum := True;

                        // Check, for Cache-time here
                        if ProperAlbum then
                        begin
                                  CurrentCacheItem := GetMatchingCacheItem;
                                  if CacheItemCanBeRechecked(CurrentCacheItem) then
                                  begin
                                      n := GetTickCount;
                                      if n - fLastCall < 300 then
                                          sleep(300);
                                      fLastCall := GetTickCount;
                                      // we start the download now
                                      fCurrentDownloadComplete := False;
                                      fInternetConnectionLost := False;  // assume there is a connection

                                      QueryLastFMCoverXML;         // Get XML-File from API
                                      GetBestCoverUrlFromXML;      // Get a Cover-URL from the XML-File
                                      DownloadBestCoverToStream;   // download the Cover from the URL

                                      Synchronize(SyncUpdateCover);  // after this: Cover is really ok
                                                                     // i.e. downloaded Data is valid Picture-data

                                      if fCurrentDownloadComplete then
                                      begin
                                          if assigned(CurrentCacheItem) then
                                              fCacheList.Remove(CurrentCacheItem);
                                          SavePicStreamToFile;             // save downloaded picture to a file
                                          Synchronize(SyncUpdateMedialib); // update Medialibrary
                                      end else
                                      begin
                                          // the current job was not completed
                                          if assigned(CurrentCacheItem) then
                                          begin
                                              // the job was already in the cache-list
                                              if not fInternetConnectionLost then
                                              begin
                                                  CurrentCacheItem.queryCount := CurrentCacheItem.queryCount + 1;
                                                  CurrentCacheItem.lastChecked := Now;
                                              end;
                                          end else
                                          begin
                                              if not fInternetConnectionLost then
                                              begin
                                                  // create new cache entry
                                                  NewCacheItem := TCoverDownloadItem.Create;
                                                  NewCacheItem.Artist := fCurrentDownloadItem.Artist;
                                                  NewCacheItem.Album  := fCurrentDownloadItem.Album ;
                                                  NewCacheItem.Directory := fCurrentDownloadItem.Directory;
                                                  NewCacheItem.queryCount := 1;
                                                  NewCacheItem.lastChecked := Now;
                                                  fCacheList.Add(NewCacheItem);
                                              end;
                                          end;
                                      end;

                                  end else
                                      Synchronize(SyncUpdateCoverCacheBlocked);  // cache blocks downloading

                        end // Proper Album
                        else
                        begin
                            Synchronize(SyncUpdateInvalidCover);
                        end;
                        LeaveCriticalSection(CSAccessCacheList);

                    end;
                end;
            end;
        end;
        SaveCacheList;
    finally
        fCacheList.Free;
    end;
end;

{
    --------------------------------------------------------
    LoadCacheList:
    - Load the Cache from the CacheFile
      Store the CoverDownloadItems in the Target-List
    --------------------------------------------------------
}
procedure TCoverDownloadWorkerThread.LoadCacheList;
var Header: AnsiString;
    major,minor: Byte;
    aStream: TMemoryStream;
    i, Count: Integer;
    NewItem: TCoverDownloadItem;
begin
    EnterCriticalSection(CSAccessCacheList);
    aStream := TMemoryStream.Create;
    try
        if FileExists(fCacheFilename) then
        begin
            aStream.LoadFromFile(fCacheFilename);
            aStream.Position := 0;

            SetLength(Header, Length('NempCoverCache'));
            aStream.Read(Header[1], length(Header));
            aStream.Read(major, sizeOf(Byte));
            aStream.Read(minor, sizeOf(Byte));

            if (Header = 'NempCoverCache')
                and (major = 1)
                and (minor = 0)
            then
            begin
                aStream.Read(Count, SizeOf(Count));
                for i := 0 to Count - 1 do
                begin
                    NewItem := TCoverDownloadItem.Create;
                    NewItem.LoadFromStream(aStream);
                    fCacheList.Add(NewItem);
                end;
            end;
        end;
    finally
        aStream.Free;
    end;
    LeaveCriticalSection(CSAccessCacheList);
end;

procedure TCoverDownloadWorkerThread.SaveCacheList;
var Header: AnsiString;
    major,minor: Byte;
    aStream: TMemoryStream;
    i, Count: Integer;
begin
    EnterCriticalSection(CSAccessCacheList);
    aStream := TMemoryStream.Create;
    try
        Header := 'NempCoverCache';
        major  := 1;
        minor  := 0;
        Count  := fCacheList.Count;

        aStream.Write(Header[1], length(Header));
        aStream.Write(major, sizeOf(Byte));
        aStream.Write(minor, sizeOf(Byte));

        aStream.Write(Count, SizeOf(Count));

        for i := 0 to Count - 1 do
            TCoverDownloadItem(fCacheList[i]).SaveToStream(aStream);

        try
            aStream.SaveToFile(fCacheFilename);
        except
            // Do nothing, saving failed
            //on E: Exception do
            //    if not Silent then
            //        MessageDLG(E.Message, mtError, [mbOK], 0);
        end;
    finally
        aStream.Free;
    end;
    LeaveCriticalSection(CSAccessCacheList);
end;

{
    --------------------------------------------------------
    ClearCacheList:
    - Clear the Cache
      Called from the Settings-dialog
    --------------------------------------------------------
}
procedure TCoverDownloadWorkerThread.ClearCacheList;
begin
    EnterCriticalSection(CSAccessCacheList);
    fCacheList.Clear;
    LeaveCriticalSection(CSAccessCacheList);
end;

{
    --------------------------------------------------------
    CollectFiles:
    - Collect *.mp3-files in current job-directory
    --------------------------------------------------------
}
procedure TCoverDownloadWorkerThread.CollectFiles(aList: TStringList);
var sr : TSearchrec;
    Path:string;
begin
    Path := fCurrentDownloadItem.Directory;

    if Findfirst(Path + '*.' + fCurrentDownloadItem.FileType, FaAnyfile, sr) = 0 then
    repeat
        if (sr.name<>'.') AND (sr.name<>'..') then
            aList.Add(Path + sr.Name);
    until (Findnext(sr) <> 0) or (aList.Count > 100);
    Findclose(sr);
end;
{
    --------------------------------------------------------
    CollectAudioInformation:
    - get AudioFiles for Source-List
    --------------------------------------------------------
}
procedure TCoverDownloadWorkerThread.CollectAudioInformation(
  source: TStringList; Target: TObjectList);
var i: Integer;
    newAudioFile: TAudioFile;

begin
    for i := 0 to source.Count - 1 do
    begin
        newAudioFile := TAudioFile.Create;
        newAudioFile.GetAudioData(source[i], 0); // get no cover-information
                                                 // as we are in a secondary thread here, this would be dangerous
                                                 // and it is not needed. ;-)
        //if newAudiofile.Pfad <> NempPlayer.MainAudioFile.Pfad then

        Target.Add(newAudioFile);
    end;
end;
function TCoverDownloadWorkerThread.IsProperAlbum(aAudioFileList: TObjectList): Boolean;
var tmpCover: TNempCover;
begin
    tmpCover := TNempCover.Create;
    try
        tmpCover.ID := 'dummy';
        GetCoverInfos(aAudioFileList, tmpCover);
        if (tmpCover.Album <> 'Unknown compilation')
            and (not UnKownInformation(tmpCover.Artist))
            and (not UnKownInformation(tmpCover.Album))
        then
        begin
            fCurrentDownloadItem.Artist := tmpCover.Artist;
            fCurrentDownloadItem.Album  := tmpCover.Album;
            result := True;
        end else
        begin
            fCurrentDownloadItem.Artist := AUDIOFILE_UNKOWN; // "invalidate" CurrentItem
            fCurrentDownloadItem.Album  := AUDIOFILE_UNKOWN;
            result := False;
        end;
    finally
        tmpCover.Free;
    end;
end;
{
    --------------------------------------------------------
    CollectAlbumInformation:
    - get proper Album-Information for a single Audiofile
    --------------------------------------------------------
}
function TCoverDownloadWorkerThread.CollectAlbumInformation: Boolean;
var FileList: TStringList;
    AudioFileList: TObjectList;

begin

    FileList := TStringList.Create;
    try
        // search harddisk for files
        CollectFiles(FileList);
        if FileList.Count <= 100 then
        begin
            AudioFileList := TObjectList.Create;
            try
                CollectAudioInformation(FileList, AudioFileList);
                // Check for a proper album-name (fCurrentDownloadItem-data is set there)
                result := IsProperAlbum(AudioFileList);
            finally
                AudioFileList.Free;
            end;
        end
        else
        begin
            // too much files. Very properly just a big directory with unsorted files
            fCurrentDownloadItem.Artist := AUDIOFILE_UNKOWN; // "invalidate" CurrentItem
            result := False;
        end;
    finally
        FileList.Free;
    end;
end;




{
    --------------------------------------------------------
    GetMatchingCacheItem:
    - Search an Item in the Cache-List, which matches Self.fCurrentDownloadItem
    --------------------------------------------------------
}
function TCoverDownloadWorkerThread.GetMatchingCacheItem: TCoverDownloadItem;
var i: Integer;
    aItem: TCoverDownloadItem;
begin
    // Block CacheList
    EnterCriticalSection(CSAccessCacheList);
    result := Nil;
    for i := 0 to fCacheList.Count - 1 do
    begin
        aItem := TCoverDownloadItem(fCacheList[i]);
        if (aItem.Artist = fCurrentDownloadItem.Artist)
            and (aItem.Album = fCurrentDownloadItem.Album)
        then
        begin
            result := aItem;
            break;
        end;
    end;
    LeaveCriticalSection(CSAccessCacheList);
end;

{
    --------------------------------------------------------
    CacheItemCanBeRechecked:
    - Check, whether a new Request for this item does make sense
      i.e. last check is some time ago
    --------------------------------------------------------
}
function TCoverDownloadWorkerThread.CacheItemCanBeRechecked(
  aCacheItem: TCoverDownloadItem): Boolean;
begin
    result :=
        (not assigned(aCacheItem))
        or
        (
            (DaysBetween(now, aCacheItem.lastChecked) >= 7) // one week ago
            or
            // one day ago and not very often tested yet (better for brandnew albums?)
            ((HoursBetween(now, aCacheItem.lastChecked) >= 24) and (aCacheItem.queryCount <= 10))
        );
end;


{
    --------------------------------------------------------
    QueryLastFMCoverXML:
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
        on E: EIdSocketError do
        begin
            fInternetConnectionLost := True;
            fXMLData := '';
            result := False;
        end;
        else
        begin
            fXMLData := '';
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
    result := True;
    if fBestCoverURL <> '' then
    begin
        fDataStream.Clear;
        try
            fIDHttp.Get(fBestCoverURL, fDataStream);
        except
            on E: EIdSocketError do
            begin
                fDataStream.Clear;
                result := False;
                fDataType := ptNone;
                fInternetConnectionLost := True;
            end;
            else
            begin
                fDataStream.Clear;
                result := False;
                fDataType := ptNone;
            end;
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
        begin
            fDataType := ptNone;
            fDataStream.Clear;
            result := False;
        end;
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
        else
            result := False;
        end;
    finally
        localBMP.Free;
    end;
end;

{
    --------------------------------------------------------
    SavePicStreamToFile:
    - Save the downloaded Stream to a file
    --------------------------------------------------------
}
procedure TCoverDownloadWorkerThread.SavePicStreamToFile;
begin
    case fDataType of
        ptJPG:  fNewCoverFilename := fCurrentDownloadItem.Directory + 'front (NempAutoCover).jpg';
        ptPNG:  fNewCoverFilename := fCurrentDownloadItem.Directory + 'front (NempAutoCover).png';
    else
        fNewCoverFilename := '';
    end;

    if fNewCoverFilename <> '' then
    try
        fDataStream.SaveToFile(fNewCoverFilename);
    except
        // nothing. saving failed
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
    NewDownloadItem.QueryType := qtCoverFlow;
    NewDownloadItem.FileType  := '';
    NewDownloadItem.Index     := Idx;
    fJobList.Insert(0, NewDownloadItem);
    if fJobList.Count > 50 then
        fJobList.Delete(fJobList.Count-1);

    StartWorking;
end;

procedure TCoverDownloadWorkerThread.AddJob(aAudioFile: TAudioFile;
  Idx: Integer);
var NewDownloadItem: TCoverDownloadItem;
begin
    NewDownloadItem := TCoverDownloadItem.Create;
    NewDownloadItem.Artist    := aAudioFile.Artist;
    NewDownloadItem.Album     := aAudioFile.Album;
    NewDownloadItem.Directory := aAudioFile.Ordner;     // including the "\"
    NewDownloadItem.QueryType := qtPlayer;
    NewDownloadItem.FileType  := aAudioFile.Extension;  // i.e. "mp3", without the leading "."
    NewDownloadItem.Index     := 0;

    fJobList.Insert(0, NewDownloadItem);
    if fJobList.Count > 50 then
        fJobList.Delete(fJobList.Count-1);

    StartWorking;
end;

procedure TCoverDownloadWorkerThread.StartWorking;
begin
    //ReleaseSemaphore(fSemaphore, 1, Nil);
    fEvent.SetEvent;
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


{
    --------------------------------------------------------
    DownloadItemStillMatchesCoverFlow
    - After a Resort of the Coverflow, our downloaded data may be useless/wrong
    --------------------------------------------------------
}
function TCoverDownloadWorkerThread.DownloadItemStillMatchesCoverFlow: Boolean;
var aCover: TNempCover;
begin
    if fCurrentDownloadItem.Index <= MedienBib.Coverlist.Count - 1 then
    begin
        aCover := TNempCover(MedienBib.CoverList[fCurrentDownloadItem.Index]);
        result := (aCover.Artist = fCurrentDownloadItem.Artist)
                  and (aCover.Album = fCurrentDownloadItem.Album);
    end else
        result := False;
end;

function TCoverDownloadWorkerThread.DownloadItemStillMatchesPlayer: Boolean;
begin
    result := assigned(NempPlayer.MainAudioFile)
            and
            (NempPlayer.MainAudioFile.Ordner = fCurrentDownloadItem.Directory);
end;

{
    --------------------------------------------------------
    SyncGetFirstJob
    - Get the first item in the Joblist
    --------------------------------------------------------
}
procedure TCoverDownloadWorkerThread.SyncGetFirstJob;
var fi: TCoverDownloadItem;
begin
    // result: True if there is something to do
    if fJobList.Count > 0 then
    begin
        FWorkToDo := True;
        // Copy the Item from the List, so the Thread can savely work on this
        fi := TCoverDownloadItem(fJobList.Items[0]);
        fCurrentDownloadItem.Artist      := fi.Artist    ;
        fCurrentDownloadItem.Album       := fi.Album     ;
        fCurrentDownloadItem.Directory   := fi.Directory ;
        fCurrentDownloadItem.Index       := fi.Index     ;
        fCurrentDownloadItem.QueryType   := fi.QueryType ;
        fCurrentDownloadItem.FileType    := fi.FileType  ;
        fJobList.Delete(0);
    end else
        fEvent.ResetEvent;
end;

procedure TCoverDownloadWorkerThread.SetProperBitmapSize(aBmp: TBitmap; aQueryType: TQueryType);
begin
    if aQueryType = qtPlayer then
    begin
        aBmp.Height := 180;
        aBmp.Width := 180;
    end else
    begin
        aBmp.Height := 240;
        aBmp.Width := 240;
    end;
end;

{
    --------------------------------------------------------
    SyncUpdateCover
    - After the Cover-Download has completed, copy the DataStream into a Bitmap
      and call SetPreview (paint it on the CoverFlow)
    --------------------------------------------------------
}
procedure TCoverDownloadWorkerThread.SyncUpdateCover;
var bmp: TBitmap;
    HintString: String;
begin

    bmp := TBitmap.Create;
    try
        HintString := '';
        bmp.PixelFormat := pf24bit;
        SetProperBitmapSize(bmp, fCurrentDownloadItem.QueryType);

        if fInternetConnectionLost then
        begin
            GetDefaultCover(dcNoCover, bmp, 0);
            AddLogoToBitmap('lastfmConnectError', bmp);
            fCurrentDownloadComplete := False;
            HintString := CoverFlowLastFM_HintConnectError;
        end else
        begin
            fCurrentDownloadComplete := StreamToBitmap(bmp);

            if Not fCurrentDownloadComplete then
            begin
                GetDefaultCover(dcNoCover, bmp, 0);
                AddLogoToBitmap('lastfmFail', bmp);
                HintString := CoverFlowLastFM_HintFail;
            end else
            begin
                AddLogoToBitmap('lastfmOK', bmp);
                HintString := CoverFlowLastFM_HintOK;
            end;
        end;

        if fCurrentDownloadItem.QueryType = qtPlayer then
        begin
            if DownloadItemStillMatchesPlayer then
            begin
                NempPlayer.CoverBitmap.Assign(bmp);
                Nemp_MainForm.CoverImage.Picture.Bitmap.Assign(NempPlayer.CoverBitmap);
                Nemp_MainForm.CoverImage.Hint := HintString;
            end;
        end
        else
        begin
            if DownloadItemStillMatchesCoverFlow then
            begin
                Medienbib.NewCoverFlow.SetPreview (fCurrentDownloadItem.Index, bmp.Width, bmp.Height, bmp.Scanline[bmp.Height-1]);
                MedienBib.NewCoverFlow.Paint(1);
            end;
        end;
    finally
        bmp.free;
    end;
end;


procedure TCoverDownloadWorkerThread.AddLogoToBitmap(aLogo: String; Target: TBitmap);
var logoBmp: TBitmap;
    filename: String;
begin
    // Add Icon to Image
    filename := ExtractFilePath(ParamStr(0)) + 'Images\' + aLogo + '.bmp';
    if FileExists(filename) then
    begin
        logoBmp := TBitmap.Create;
        try
            logoBmp.LoadFromFile(filename);
            Target.Canvas.Draw(Target.Width - LogoBmp.Width - 2, 3, logoBmp);
        finally
            logoBmp.Free;
        end;
    end;
end;


procedure TCoverDownloadWorkerThread.SyncUpdateCoverCacheBlocked;
var bmp: TBitmap;
begin
    bmp := TBitmap.Create;
    try
        bmp.PixelFormat := pf24bit;
        SetProperBitmapSize(bmp, fCurrentDownloadItem.QueryType);

        GetDefaultCover(dcNoCover, bmp, 0);
        AddLogoToBitmap('lastfmCache', bmp);

        //bmp.Canvas.Brush.Style := bsClear;
        //bmp.Canvas.Font.Size := 6;
        //bmp.Canvas.TextOut(5,5, 'Cover-download blocked by cache');

        if fCurrentDownloadItem.QueryType = qtPlayer then
        begin
            if DownloadItemStillMatchesPlayer then
            begin
                NempPlayer.CoverBitmap.Assign(bmp);
                Nemp_MainForm.CoverImage.Picture.Bitmap.Assign(NempPlayer.CoverBitmap);
                Nemp_MainForm.CoverImage.Hint := CoverFlowLastFM_HintCache;
            end;
        end
        else
        begin
            if DownloadItemStillMatchesCoverFlow then
            begin
                Medienbib.NewCoverFlow.SetPreview (fCurrentDownloadItem.Index, bmp.Width, bmp.Height, bmp.Scanline[bmp.Height-1]);
                MedienBib.NewCoverFlow.Paint(1);
            end;
        end;
    finally
        bmp.free;
    end;

end;

procedure TCoverDownloadWorkerThread.SyncUpdateInvalidCover;
var bmp: TBitmap;
begin
    bmp := TBitmap.Create;
    try
        bmp.PixelFormat := pf24bit;
        SetProperBitmapSize(bmp, fCurrentDownloadItem.QueryType);

        if (fCurrentDownloadItem.QueryType = qtPlayer)
            and DownloadItemStillMatchesPlayer
        then
        begin
            GetDefaultCover(dcNoCover, bmp, 0);
            AddLogoToBitmap('lastfmInvalid', bmp);

            NempPlayer.CoverBitmap.Assign(bmp);
            Nemp_MainForm.CoverImage.Picture.Bitmap.Assign(NempPlayer.CoverBitmap);
            Nemp_MainForm.CoverImage.Hint := CoverFlowLastFM_HintInvalid;
        end;
    finally
        bmp.Free;
    end;
end;

{
    --------------------------------------------------------
    SyncUpdateMedialib
    - compute MD5-Hash of the saved Coverfile, copy it to the library's Cover-Dir
    - get the matching "NempCoverItem"
    - get all of its AudioFiles
    - change the CoverIDs of these files (and from the NempCover-Object)

    ///  passendes NempCover (wieder)finden
    ///  AudioFileListe generieren
    ///  Neue ID setzen

    --------------------------------------------------------
}
procedure TCoverDownloadWorkerThread.SyncUpdateMedialib;
var OldID, NewID: String;
    i: Integer;
    afList: TObjectList;
begin
    if  (MedienBib.BrowseMode = 1)         // we are still in CoverFlow
        and (fCurrentDownloadItem.QueryType = qtCoverFlow)
        and FileExists(fNewCoverFilename)  // the downloaded file exists
        and DownloadItemStillMatchesCoverFlow
    then
    begin
        NewID := Medienbib.InitCoverFromFilename(fNewCoverFilename);
        // as DownloadItemStillMatchesCoverFlow, the access to this index is ok
        OldID := TNempCover(MedienBib.CoverList[fCurrentDownloadItem.Index]).ID;

        // Get List of all Files with the old ID
        afList := TObjectList.Create(False);
        try
            MedienBib.GetTitelListFromCoverID(afList, OldID);
            for i := 0 to afList.Count - 1 do
                // set the new ID
                TAudioFile(afList[i]).CoverID := NewID;

            // set the new ID on the NempCover-Object
            TNempCover(MedienBib.CoverList[fCurrentDownloadItem.Index]).ID := NewID;

            if  MedienBib.NewCoverFlow.CurrentCoverID = OldID then
                MedienBib.NewCoverFlow.CurrentCoverID := NewID;

            MedienBib.HandleChangedCoverID;
            MedienBib.Changed := True;
        finally
            afList.Free;
        end;
    end;// else
        //Nemp_MainForm.Caption := 'Upsa, Coverflow changed? ' + OldID;
end;

initialization

  InitializeCriticalSection(CSAccessCacheList);

finalization

  DeleteCriticalSection(CSAccessCacheList);

end.
