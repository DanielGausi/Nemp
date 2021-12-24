{

    Unit CoverDownloads

    Class TCoverDownloadWorkerThread
        A Workerthread for downloading Covers from LastFM using its API

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2005-2019, Daniel Gaussmann
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
  Dialogs, StrUtils, ContNrs, Jpeg, PNGImage,  math, DateUtils,
  CoverHelper, ID3v2Tags, ID3v2Frames, NempAudioFiles, cddaUtils,
  Nemp_ConstantsAndTypes, SyncObjs, System.Types,
  LibraryOrganizer.Base, LibraryOrganizer.Files,
  // new method for downloading stuff
  System.Net.URLClient, System.Net.HttpClient;

const
    ccArtist     = 0;
    ccAlbum      = 1;
    ccDirectory  = 2;
    ccQueryCount = 3;
    ccLastQuery  = 4;
    ccDataEnd    = 255;

type



    TPicType = (ptNone, ptJPG, ptPNG);

    TQueryType = (qtCoverFlow, qtPlayer, qtTreeView);
    TSubQueryType = (sqtFile, sqtCDDA);





    TCoverDownloadItem = class
        ArchiveID: Integer;

        Artist: String;
        Album: String;
        Directory: String;
        //nö. CoverDestination: String; // Destination for the downloaded Coverfile.
                                  // = Directory for files, /Cover/ for CDDA
        QueryType: TQueryType;
        SubQueryType: TSubQueryType; // used for qtPlayer (file/cdda)
        FileType: String;       // On files: used to collect artist-album-data from other files
                                //           in current directory with the same extension
                                // On CDDA: the cddb-id of the disc
        Index: Integer;         // used in CoverFlow
        distance: Integer;      // distance to MostImportantIndex
        lastChecked: TDateTime; // time of last query for this Item
        queryCount: Integer;    // Used to increase the Cache-Interval
        Status: String;
        newFilename: String;

        procedure LoadFromStream(aStream: TStream); // loading/saving in Thread-Context
        procedure SaveToStream(aStream: TStream);
    end;

    TDownloadCompleteEvent = procedure(DownloadItem: TCoverDownloadItem; Bitmap: TBitmap) of object;
    TDownloadEvent = procedure(DownloadItem: TCoverDownloadItem) of object;

    TCoverDownloadWorkerThread = class(TThread)
        private
            { Private-Deklarationen }
            fHttpClient: THttpClient;

            //fSemaphore: THandle;
            fEvent: TEvent;

            // Thread-Copy for the Item that is currently processed
            fCurrentDownloadItem: TCoverDownloadItem;
            fCurrentDownloadComplete: Boolean;
            FWorkToDo: Boolean;

            fArchiveList: TAudioCollectionList;
            fArchiveIDCounter: Integer;
            // LastFM allows only 5 calls per Second
            // The GetTag-Method will be calles very often - so we need a speed-limit here!
            fLastCall: DWord;

            fJobList: TObjectList;   // Access only from VCL !!!

            fInternetConnectionLost: Boolean;
            fXMLData: String;        // API-Response
            fBestCoverURL: String;   // URL of the "extra-large" cover, if available
            fDataStream: TMemoryStream;  // Stream containing the Picture-Data
            fNewCoverFilename: String;   // Local Filename of the downloaded Coverfile
            fDataType: TPicType;

            fCacheFilename: String;
            fCacheList: TObjectList;   // Always use CriticalSection CSAccessCacheList to access this List!
                                       // The List is mainly used by the secondary thread, but can be deleted by the Settings-dialog.
                                       // ... which will directly cause a Deadlock m(
                                       // therefore: change it to ...
            fUserWantToClearCacheList: LongBool;

            fMostImportantIndex: Integer;

            fOnDownloadComplete: TDownloadCompleteEvent;
            fOnDownloadSaved: TDownloadEvent;

            procedure SetMostImportantIndex(Value: Integer);    // VCL

            // for player-picture: Get proper Album-Information
            procedure CollectFiles(aList: TStringList);
            procedure CollectAudioInformation(source: TStringList; Target: TAudioFileList);
            function IsProperAlbum(aAudioFileList: TAudioFileList): Boolean;
            function CollectAlbumInformation: Boolean;
            function CollectCDInformation: Boolean;

            // Thread-methods. Downloading, parsing, ...
            function QueryLastFMCoverXML: Boolean;
            function GetBestCoverUrlFromXML: Boolean;
            function DownloadBestCoverToStream: Boolean;
            procedure SavePicStreamToFile;

            // CacheList
            procedure LoadCacheList;
            procedure SaveCacheList;

            function GetUserWantToClearCacheList: LongBool;
            procedure SetUserWantToClearCacheList(aValue: LongBool);

            function GetMatchingCacheItem: TCoverDownloadItem;
            function CacheItemCanBeRechecked(aCacheItem: TCoverDownloadItem): Boolean;

            // VCL-methods
            function StreamToBitmap(TargetBMP: TBitmap): Boolean;

            procedure StartWorking;  // VCL

            procedure SetProperBitmapSize(aBmp: TBitmap; aQueryType: TQueryType);

            // Get next job, i.e. information about the next queried cover
            procedure SyncGetFirstJob; // VCL
            // Update the Cover in Coverflow (or: in Player?)
            procedure GetDefaultPic(aDCType: TEDefaultCoverType; aBitmap: TBitmap);
            procedure SyncUpdateCover; // VCL
            procedure SyncUpdateCoverCacheBlocked; // VCL
            procedure SyncUpdateInvalidCover; // VCL
            procedure AddLogoToBitmap(aLogo: String; Target: TBitmap);
            // Update CoverFlow-Data in Medialibrary
            procedure SyncUpdateMedialib;

            procedure DisregardCollection(aID: Integer);
            procedure DisregardCurrentCollection;

        protected

            procedure Execute; override;

        public
            property MostImportantIndex: Integer read fMostImportantIndex write SetMostImportantIndex;
            property UserWantToClearCacheList: LongBool read GetUserWantToClearCacheList write SetUserWantToClearCacheList;

            property OnDownloadComplete: TDownloadCompleteEvent read fOnDownloadComplete write fOnDownloadComplete;
            property OnDownloadSaved: TDownloadEvent read fOnDownloadSaved write fOnDownloadSaved;

            constructor Create;
            destructor Destroy; override;

            // procedure AddJob(aCover: TNempCover; Idx: Integer); overload;     // VCL
            procedure AddJob(aAudioFile: TAudioFile; Idx: Integer); overload; // VCL
            procedure AddJob(aCollection: TAudioCollection; Idx: Integer; QuerySource: TQueryType); overload; // VCL

            function GetArchivedCollection(aID: Integer): TAudioCollection;

            procedure ClearCacheList; // VCL
    end;

    function SortDownloadPriority(item1,item2: Pointer): Integer;

implementation

uses ScrobblerUtils, HtmlHelper, SystemHelper, Nemp_RessourceStrings, OneInst;


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
    inherited create(False);
    /// fIDHttp := TIdHttp.Create;
    fJobList := TObjectList.Create;
    fDataStream := TMemoryStream.Create;
    fCurrentDownloadItem := TCoverDownloadItem.Create;

    //fSemaphore := CreateSemaphore(Nil, 0, maxInt, Nil);
    fEvent := TEvent.Create(Nil, True, False, '');
    FreeOnTerminate := False;

    fHttpClient := THttpClient.Create;
    fHttpClient.UserAgent := 'Mozilla/3.0 (compatible; Nemp)' ;
    fHttpClient.ConnectionTimeout := 5000;
    fHttpClient.SecureProtocols := [THTTPSecureProtocol.TLS12, THTTPSecureProtocol.TLS11];

    fArchiveList := TAudioCollectionList.Create(False);
    fArchiveIDCounter := 1;

    UserWantToClearCacheList := False;
end;

destructor TCoverDownloadWorkerThread.Destroy;
var
  i: Integer;
begin
    for i := 0 to fArchiveList.Count - 1 do
      fArchiveList[i].Disregard;
    fArchiveList.Free;
    fHttpClient.Free;
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
    if UseUserAppData then
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
                    if UserWantToClearCacheList then
                    begin
                        fCacheList.Clear;
                        UserWantToClearCacheList := False;
                    end;

                    FWorkToDo := False;  // will be set to True again in SyncGetFirstJob
                    Synchronize(SyncGetFirstJob);
                    if FWorkToDo then
                    begin
                        if fCurrentDownloadItem.QueryType = qtPlayer then
                        begin
                            if fCurrentDownloadItem.SubQueryType = sqtFile then
                                ProperAlbum := CollectAlbumInformation
                            else
                                ProperAlbum := CollectCDInformation
                        end
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

                                      if not terminated then
                                          Synchronize(SyncUpdateCover);  // after this: Cover is really ok
                                                                        // i.e. downloaded Data is valid Picture-data

                                      if fCurrentDownloadComplete then
                                      begin
                                          if assigned(CurrentCacheItem) then
                                              fCacheList.Remove(CurrentCacheItem);
                                          if not terminated then
                                              Synchronize(SavePicStreamToFile); // save downloaded picture to a file
                                          if not terminated then
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
                                                  if (fCurrentDownloadItem.QueryType = qtPlayer)
                                                    and (fCurrentDownloadItem.SubQueryType = sqtCDDA)
                                                  then
                                                      NewCacheItem.Artist := fCurrentDownloadItem.FileType // i.e. the cddb-id of the disc
                                                  else
                                                      NewCacheItem.Artist := fCurrentDownloadItem.Artist;
                                                  NewCacheItem.Album  := fCurrentDownloadItem.Album ;
                                                  NewCacheItem.Directory := fCurrentDownloadItem.Directory;
                                                  NewCacheItem.queryCount := 1;
                                                  NewCacheItem.lastChecked := Now;
                                                  fCacheList.Add(NewCacheItem);
                                              end;
                                          end;
                                      end;

                                  end
                                  else
                                  begin
                                      if not terminated then
                                          Synchronize(SyncUpdateCoverCacheBlocked);  // cache blocks downloading
                                  end;

                        end // Proper Album
                        else
                        begin
                            if not terminated then
                                Synchronize(SyncUpdateInvalidCover);
                        end;

                        Synchronize(DisregardCurrentCollection);
                    end;
                end;
            end;
        end;
        SaveCacheList;
    finally
        fCacheList.Free;
    end;
end;

function TCoverDownloadWorkerThread.GetUserWantToClearCacheList: LongBool;
begin
    InterLockedExchange(Integer(Result), Integer(fUserWantToClearCacheList));
end;
procedure TCoverDownloadWorkerThread.SetUserWantToClearCacheList(aValue: LongBool);
begin
  InterLockedExchange(Integer(fUserWantToClearCacheList), Integer(aValue));
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
end;

procedure TCoverDownloadWorkerThread.SaveCacheList;
var Header: AnsiString;
    major,minor: Byte;
    aStream: TMemoryStream;
    i, Count: Integer;
begin
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
    UserWantToClearCacheList := True;
    fEvent.SetEvent;
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
    Path := fCurrentDownloadItem.Directory ;

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
  source: TStringList; Target: TAudioFileList);
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

function TCoverDownloadWorkerThread.IsProperAlbum(aAudioFileList: TAudioFileList): Boolean;
var tmpCover: TNempCover;
begin
    tmpCover := TNempCover.Create;
    try
        tmpCover.ID := 'dummy';
        tmpCover.GetCoverInfos(aAudioFileList);
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
    AudioFileList: TAudioFileList;

begin

    FileList := TStringList.Create;
    try
        // search harddisk for files
        CollectFiles(FileList);

        if FileList.Count <= 100 then
        begin
            AudioFileList := TAudioFileList.Create;
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
    CollectCDInformation:
    - get proper Album-Information for the current AudioCD
    --------------------------------------------------------
}
function TCoverDownloadWorkerThread.CollectCDInformation: Boolean;
begin
    result := (fCurrentDownloadItem.Artist <> '') and (fCurrentDownloadItem.Album <> '');

    fCurrentDownloadItem.FileType := CddbIDFromCDDA(fCurrentDownloadItem.Directory);
    // Directory is complete path on cdda
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
    result := Nil;

    if (fCurrentDownloadItem.QueryType = qtPlayer)
       and (fCurrentDownloadItem.SubQueryType = sqtCDDA)
    then
    begin
        for i := 0 to fCacheList.Count - 1 do
        begin
            aItem := TCoverDownloadItem(fCacheList[i]);
            // in this case: Artist is the cddb-ID
            if (aItem.Artist = fCurrentDownloadItem.FileType) then
            begin
                result := aItem;
                break;
            end;
        end;
    end else
    begin
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
    end;
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
var //url: UTF8String;
    url: String;
    aResponse: IHttpResponse;
begin
    url := 'https://ws.audioscrobbler.com/2.0/?method=album.getinfo'
        + '&api_key=' + '542ec0c3e5e7b84030181176f3d0f264' //String(NempPlayer.NempScrobbler.ApiKey)
        //+ '&artist=' + StringToURLStringAnd(UTF8String(AnsiLowerCase(fCurrentDownloadItem.Artist)))
        //+ '&album='  + StringToURLStringAnd(UTF8String(AnsiLowerCase(fCurrentDownloadItem.Album)));
        + '&artist=' + URLEncode_LastFM(AnsiLowerCase(fCurrentDownloadItem.Artist))
        + '&album='  + URLEncode_LastFM(AnsiLowerCase(fCurrentDownloadItem.Album));

    try
        //fXMLData := fIDHttp.Get(url);
        aResponse := fHttpClient.Get(url);

        if (aResponse.StatusCode = 400) then
        begin
            // lastFM seems to send a "400-Bad Request" when an album is not found
            // but a "no connection" logo on the cover would be wrong here
            fInternetConnectionLost := False;
            fXMLData := '';
            result := False;
        end else
        begin
            // success!!!
            fXMLData := aResponse.ContentAsString();
            fInternetConnectionLost := False;
            result := True;
        end;

    except
        /// note: that may be too general.
        /// ??? todo ??? handle some exceptions and status codes seperately?
        on E: Exception do
        begin
            fInternetConnectionLost := True;
            fXMLData := '';
            result := False;
        end;
        {
        on E: EidIOHandlerPropInvalid  do
        begin
            fInternetConnectionLost := True;
            fXMLData := '';
            result := False;
        end;

        on E: EIDHttpProtocolException do
        begin
            // lastFM seems to send a "400-Bad Request" when an album is not found
            // but a "no connection" logo on the cover would be wrong here
            fInternetConnectionLost := False;
            fXMLData := '';
            result := False;
        end;
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
        end; }
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
var aResponse: IHttpResponse;
begin
    result := True;
    if fBestCoverURL <> '' then
    begin
        fDataStream.Clear;
        try
            // fIDHttp.Get(fBestCoverURL, fDataStream);
            aResponse := fHttpClient.Get(fBestCoverURL);
            fDataStream.CopyFrom(aResponse.ContentStream, 0);

            // ??? todo ??? proper error-handling?
        except
            on E: Exception do
            begin
                fInternetConnectionLost := True;
                fXMLData := '';
                fDataType := ptNone;
                fDataStream.Clear;
                result := False;
            end;

            {
            on E: EidIOHandlerPropInvalid  do
            begin
                fInternetConnectionLost := True;
                fXMLData := '';
                result := False;
            end;
            on E: EIDHttpProtocolException do
            begin
                fInternetConnectionLost := True;
                fXMLData := '';
                result := False;
            end;
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
            }
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
    if (fCurrentDownloadItem.QueryType = qtPlayer) and
       (fCurrentDownloadItem.SubQueryType = sqtCDDA)
    then begin
        case fDataType of
            ptJPG:  fNewCoverFilename := TCoverArtSearcher.SavePath + CoverFilenameFromCDDA(fCurrentDownloadItem.Directory) + '.jpg';
            ptPNG:  fNewCoverFilename := TCoverArtSearcher.SavePath + CoverFilenameFromCDDA(fCurrentDownloadItem.Directory) + '.png';
        else
            fNewCoverFilename := '';
        end;
    end else
    begin
        case fDataType of
            ptJPG:  fNewCoverFilename := fCurrentDownloadItem.Directory + 'front (NempAutoCover).jpg';
            ptPNG:  fNewCoverFilename := fCurrentDownloadItem.Directory + 'front (NempAutoCover).png';
        else
            fNewCoverFilename := '';
        end;
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
(*
procedure TCoverDownloadWorkerThread.AddJob(aCover: TNempCover; Idx: Integer);
var NewDownloadItem: TCoverDownloadItem;
begin
    NewDownloadItem := TCoverDownloadItem.Create;
    NewDownloadItem.Artist    := aCover.Artist;
    NewDownloadItem.Album     := aCover.Album;
    NewDownloadItem.Directory := IncludeTrailingPathDelimiter(aCover.Directory);
    NewDownloadItem.QueryType := qtCoverFlow;
    NewDownloadItem.SubQueryType := sqtFile;
    NewDownloadItem.FileType  := '';
    NewDownloadItem.Index     := Idx;
    fJobList.Insert(0, NewDownloadItem);
    if fJobList.Count > 50 then
        fJobList.Delete(fJobList.Count-1);

    StartWorking;
end;
*)

procedure TCoverDownloadWorkerThread.AddJob(aAudioFile: TAudioFile;
  Idx: Integer);
var NewDownloadItem: TCoverDownloadItem;
begin
    NewDownloadItem := TCoverDownloadItem.Create;
    NewDownloadItem.Artist    := aAudioFile.Artist;
    NewDownloadItem.Album     := aAudioFile.Album;

    NewDownloadItem.QueryType := qtPlayer;
    if aAudioFile.IsFile then
    begin
        NewDownloadItem.SubQueryType := sqtFile;
        NewDownloadItem.Directory := aAudioFile.Ordner + '\';     // including the "\"
    end;
    if aAudioFile.isCDDA then
    begin
        NewDownloadItem.SubQueryType := sqtCDDA;
        NewDownloadItem.Directory := aAudioFile.Pfad;     // complete Path on CDDA
    end;

    NewDownloadItem.FileType  := aAudioFile.Extension;  // i.e. "mp3", without the leading "."
    NewDownloadItem.Index     := 0;

    fJobList.Insert(0, NewDownloadItem);
    if fJobList.Count > 50 then
        fJobList.Delete(fJobList.Count-1);

    StartWorking;
end;


procedure TCoverDownloadWorkerThread.AddJob(aCollection: TAudioCollection; Idx: Integer; QuerySource: TQueryType);
var NewDownloadItem: TCoverDownloadItem;
  afc: tAudioFileCollection;
begin
    if not (aCollection is TAudioFileCollection) then
      exit;

    afc := tAudioFileCollection(aCollection);
    if not (afc.CollectionType = ctAlbum) then
      exit;

    if (afc.Album = CoverFlowText_VariousArtists)
      or UnKownInformation(afc.Artist)
      or UnKownInformation(afc.Album)
    then
      exit;

    NewDownloadItem := TCoverDownloadItem.Create;
    NewDownloadItem.Artist    := afc.Artist;
    NewDownloadItem.Album     := afc.Album;
    NewDownloadItem.Directory := IncludeTrailingPathDelimiter(afc.Directory);
    NewDownloadItem.QueryType := QuerySource; //qtCoverFlow;
    NewDownloadItem.SubQueryType := sqtFile;
    NewDownloadItem.FileType  := '';
    NewDownloadItem.Index     := Idx;
    inc(fArchiveIDCounter);
    NewDownloadItem.ArchiveID := fArchiveIDCounter;
    afc.Archive(fArchiveList, fArchiveIDCounter);
    fJobList.Insert(0, NewDownloadItem);
    if fJobList.Count > 50 then begin
        DisregardCollection(TCoverDownloadItem(fJobList[fJobList.Count-1]).ArchiveID);
        fJobList.Delete(fJobList.Count-1);
    end;
    StartWorking;
end;

procedure TCoverDownloadWorkerThread.DisregardCurrentCollection;
begin
  if assigned(fCurrentDownloadItem) then
    DisregardCollection(fCurrentDownloadItem.ArchiveID);
end;

procedure TCoverDownloadWorkerThread.DisregardCollection(aID: Integer);
var
  ac: TAudioCollection;
begin
  ac := GetArchivedCollection(aID);
  if assigned(ac) then
    ac.Disregard;
end;

function TCoverDownloadWorkerThread.GetArchivedCollection(aID: Integer): TAudioCollection;
var
  i: Integer;
begin
  result := Nil;
  for i := 0 to fArchiveList.Count - 1 do
    if fArchiveList[i].ArchiveID = aID then begin
      result := fArchiveList[i];
      break;
    end;
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
        fCurrentDownloadItem.Artist       := fi.Artist      ;
        fCurrentDownloadItem.Album        := fi.Album       ;
        fCurrentDownloadItem.Directory    := fi.Directory   ;
        fCurrentDownloadItem.Index        := fi.Index       ;
        fCurrentDownloadItem.QueryType    := fi.QueryType   ;
        fCurrentDownloadItem.SubQueryType := fi.SubQueryType;
        fCurrentDownloadItem.FileType     := fi.FileType    ;
        fCurrentDownloadItem.ArchiveID    := fi.ArchiveID   ;
        fJobList.Delete(0);
    end else
        fEvent.ResetEvent;
end;

procedure TCoverDownloadWorkerThread.SetProperBitmapSize(aBmp: TBitmap; aQueryType: TQueryType);
begin
    if aQueryType = qtPlayer then
    begin
        aBmp.Height := NEMP_PLAYER_COVERSIZE;
        aBmp.Width := NEMP_PLAYER_COVERSIZE;
    end else
    begin
        aBmp.Height := TCoverArtSearcher.CoverSize;
        aBmp.Width := TCoverArtSearcher.CoverSize;
    end;
end;

{
    --------------------------------------------------------
    SyncUpdateCover
    - After the Cover-Download has completed, copy the DataStream into a Bitmap
      and call SetPreview (paint it on the CoverFlow)
    --------------------------------------------------------
}

procedure TCoverDownloadWorkerThread.GetDefaultPic(aDCType: TEDefaultCoverType; aBitmap: TBitmap);
var pic: TPicture;
begin
    pic := TPicture.Create;
    try
        TCoverArtSearcher.GetDefaultCover(aDCType, pic, 0);
        FitBitmapIn(aBitmap, pic.Graphic)
    finally
        pic.Free;
    end;
end;

procedure TCoverDownloadWorkerThread.SyncUpdateCover;
var bmp: TBitmap;
    // HintString: String;

begin
    bmp := TBitmap.Create;
    try
        fCurrentDownloadItem.Status := '';
        bmp.PixelFormat := pf24bit;
        SetProperBitmapSize(bmp, fCurrentDownloadItem.QueryType);

        if fInternetConnectionLost then
        begin
            //GetDefaultCover(dcFile, pic, 0);
            GetDefaultPic(dcFile, bmp);
            AddLogoToBitmap('lastfmConnectError', bmp);
            fCurrentDownloadComplete := False;
            fCurrentDownloadItem.Status := CoverFlowLastFM_HintConnectError;
        end else
        begin
            fCurrentDownloadComplete := StreamToBitmap(bmp);

            if Not fCurrentDownloadComplete then
            begin
                //GetDefaultCover(dcFile, pic, 0);
                GetDefaultPic(dcFile, bmp);
                AddLogoToBitmap('lastfmFail', bmp);
                fCurrentDownloadItem.Status := CoverFlowLastFM_HintFail;
            end else
            begin
                AddLogoToBitmap('lastfmOK', bmp);
                fCurrentDownloadItem.Status := CoverFlowLastFM_HintOK;
            end;
        end;

        if assigned(fOnDownloadComplete) then
          fOnDownloadComplete(fCurrentDownloadItem, bmp);

    finally
        bmp.free;
    end;
end;


procedure TCoverDownloadWorkerThread.AddLogoToBitmap(aLogo: String; Target: TBitmap);
var logoPic: TPicture;
    logoBmp: TBitmap;
    filename: String;
    SizeX, relevantCoverSize: Integer;
begin
    // Add Icon to Image
    filename := ExtractFilePath(ParamStr(0)) + 'Images\' + aLogo + '.png';
    if not FileExists(filename) then
      filename := ExtractFilePath(ParamStr(0)) + 'Images\' + aLogo + '.jpg';
    if not FileExists(filename) then
      filename := ExtractFilePath(ParamStr(0)) + 'Images\' + aLogo + '.bmp';

    relevantCoverSize := Target.width;
    if Target.Height > relevantCoverSize then
      relevantCoverSize := Target.Height;
    SizeX := relevantCoverSize Div 10;

    if FileExists(filename) then
    begin
        logoPic := TPicture.Create;
        logoBmp := TBitmap.Create;
        try
            logoPic.LoadFromFile(filename);
            logoBmp.Assign(logoPic.Graphic);
            StretchBlt(Target.Canvas.Handle,
                  Target.Width - SizeX, 0, SizeX, SizeX,
                  logoBmp.Canvas.Handle,
                  0, 0, logoBmp.Width, logoBmp.Height,
                  SRCCopy);
        finally
            logoBmp.Free;
            logoPic.Free;
        end;
    end;
end;


procedure TCoverDownloadWorkerThread.SyncUpdateCoverCacheBlocked;
var bmp: TBitmap;
    //pic: TPicture;
begin
    bmp := TBitmap.Create;
    try
        bmp.PixelFormat := pf24bit;
        SetProperBitmapSize(bmp, fCurrentDownloadItem.QueryType);

        GetDefaultPic(dcFile, bmp);
        AddLogoToBitmap('lastfmCache', bmp);

        //bmp.Canvas.Brush.Style := bsClear;
        //bmp.Canvas.Font.Size := 6;
        //bmp.Canvas.TextOut(5,5, 'Cover-download blocked by cache');
        fCurrentDownloadItem.Status := CoverFlowLastFM_HintCache;

        if assigned(fOnDownloadComplete) then
          fOnDownloadComplete(fCurrentDownloadItem, bmp);

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

        GetDefaultPic(dcFile, bmp);
        AddLogoToBitmap('lastfmInvalid', bmp);
        fCurrentDownloadItem.Status := CoverFlowLastFM_HintInvalid;

        if assigned(fOnDownloadComplete) then
          fOnDownloadComplete(fCurrentDownloadItem, bmp);

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
//var OldID, NewID: String;
//  ArchivedCollection: TAudioCollection;
begin
    if  // (MedienBib.BrowseMode = 1)         // we are still in CoverFlow
        // and (fCurrentDownloadItem.QueryType = qtCoverFlow)
        // and
        FileExists(fNewCoverFilename)  // the downloaded file exists
        //and DownloadItemStillMatchesCoverFlow
    then
    begin
        fCurrentDownloadItem.newFilename := fNewCoverFilename;

        {NewID := Medienbib.CoverArtSearcher.InitCoverFromFilename(fNewCoverFilename, tm_VCL);
        // as DownloadItemStillMatchesCoverFlow, the access to this index is ok
        // OldID := TAudioFileCollection(MedienBib.NewCoverFlow.Collection[fCurrentDownloadItem.Index]).CoverID;
        //TNempCover(MedienBib.CoverViewList[fCurrentDownloadItem.Index]).ID;

        ArchivedCollection := GetArchivedCollection(fCurrentDownloadItem.ArchiveID);
        if assigned(ArchivedCollection) then
          ArchivedCollection.ChangeCoverIDAfterDownload(newID);
          }

        if assigned(fOnDownloadSaved) then
          fOnDownloadSaved(fCurrentDownloadItem);


        //if (MedienBib.BrowseMode = 0) and (fCurrentDownloadItem.QueryType = qtTreeView) then
        //  Nemp_MainForm.AlbenVST.Invalidate;

        //MedienBib.ChangeCoverID(OldID, NewID);
        //das umbauen in Files der Collection ändern?
        // ArchivedCollection.  ChangeCoverIDAfterDownload(newID);

        // set the new ID on the NempCover-Object
        // TAudioFileCollection(MedienBib.NewCoverFlow.Collection[fCurrentDownloadItem.Index]).CoverID := NewID;
        // TNempCover(MedienBib.CoverViewList[fCurrentDownloadItem.Index]).ID := NewID;

        //if  MedienBib.NewCoverFlow.CurrentCoverID = OldID then
        //    MedienBib.NewCoverFlow.CurrentCoverID := NewID;
    end;
end;


end.
