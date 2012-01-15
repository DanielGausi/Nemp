unit Votings;

interface

uses Windows, Classes, Messages, ContNrs, SysUtils, IniFiles,  StrUtils,
  DateUtils, VirtualTrees,
  MP3FileUtils, AudioFileClass, Hilfsfunktionen,
  Playlistclass, PlayerClass, Nemp_ConstantsAndTypes,
  MedienbibliothekClass;

type

    TVoteResult = (vr_Success, vr_TotalVotesExceeded, vr_FileVotesExceeded, vr_Exception);

    TVote = class
        private
            fID: Integer;
            fTime: TDateTime;
        public
            property ID: Integer read fID;  // ID of the TAudiofile in the Playlist
            property Time: TDateTime read fTime; // Time of the vote

            constructor Create(aID: Integer; aTime: TDateTime);
    end;

    TUser = class
        private
            fIP: String;

        public
            Votes: TObjectList;
            property IP: String read fIP;

            constructor Create(aIP: String);
            destructor Destroy; override;
            procedure CleanUpVotes;
            function VoteAllowed(aFileID: Integer): TVoteResult;
            procedure UpdateVotings(aFileID: Integer);
    end;

    TVoteMachine = class
        private
            fMainWindowHandle: DWord;
            fcurrentUser: TUser;  // global property. ONLY ONE THREAD VOTES AT A GIVEN TIME !!!
            function getUserforIP(aIP: String): TUser;
        public
            Users: TObjectList;
            LibraryList: TObjectList;

            constructor Create(Hnd: DWord);
            destructor Destroy; override;

            function GetLibFileFromID(aFileID: Integer): TAudioFile;

            function VCLDoVote(aFileID: Integer; aPlaylist: TNempPlaylist): Integer;
            function VCLDoVoteFilename(aFilename: String; aPlaylist: TNempPlaylist): Integer;
            function VCLAddAndVoteFile(aFile: TAudioFile; aPlaylist: TNempPlaylist): Integer;



            function ProcessVote(aFileID: Integer; aIP: String ): TVoteResult;
            /// ProcessVote is directly called from the webserver (i.e. secondary thread!)
            /// TODO:
            ///     Check aIP's VoteList for "aFileID"
            ///     if ok: SendMessage to MainThread "Vote this fileID"   (1)
            ///            return: true: ok, Update Users VoteList
            ///                    false: File is not in Playlist, so
            ///                           Get File with ID in the webservers filelist
            ///                           SendMessage to MainThread "Get ID for this filename"
            ///                           if file can be found: Check aIP's Votelist for THIS ID
            ///                                                  if ok: SendMessage to MainThread "Vote this fileID" (1)
            ///                                                         return: true: ok, Update Users VoteList
            ///                                                                 false: EXCEPTION
            ///                                                  else: CANCEL, Vote not allowed
            ///                           if File can NOT be found
            ///                              SendMessage(AddAndVoteThisFile)  (2)
            ///                              result: ID
            ///                                      Update Users VoteList
            ///     else : CANCEL, Vote not allowed
            ///
            ///  IN VCL:
            ///    (1) GetAudioFilename with ID
            ///        Vote +1
            ///        "resort"                             // these can be VCL-Methods of this class
            ///                                                like DoVote(aPlaylist, aID)
            ///    (2) AddfileToPlaylist                            DoVote(aPlaylist, aFilename)
            ///        Vote +5 (?)
            ///        "resort"


    end;


var
    CS_Vote: RTL_CRITICAL_SECTION;


implementation

uses WebServerClass;

{ TVote }

constructor TVote.Create(aID: Integer; aTime: TDateTime);
begin
    fID := aID;
    fTime := aTime;
end;


{ TUser }

constructor TUser.Create(aIP: String);
begin
    Votes := TObjectList.Create;
    fIP := aIP;
end;

destructor TUser.Destroy;
begin
    Votes.Free;
end;

{
    CleanUpVotes: Delete old Votes
}
procedure TUser.CleanUpVotes;
begin
    while (Votes.Count > 0) and ( SecondsBetween(TVote(Votes[0]).Time, Now) > 60 ) do
        Votes.Remove(Votes[0]);
end;

{
    VoteAllowed: Search for a Vote for the specified FileID
}
function TUser.VoteAllowed(aFileID: Integer): TVoteResult;
var i: Integer;
begin
    result := vr_Success;

    if Votes.Count > 20 then
        // Hardcoded spam-limit: 20 votes in 60 seconds
        result := vr_TotalVotesExceeded
    else
    begin
        for i := 0 to Votes.Count - 1 do
            if TVote(Votes[i]).ID = aFileID then
                result := vr_FileVotesExceeded;
    end;
end;

{
    UpdateVotings: Log the voting for aFileID
}
procedure TUser.UpdateVotings(aFileID: Integer);
var newVoting: TVote;
begin
      newVoting := TVote.Create(aFileID, Now);
      Votes.Add(newVoting);
end;


{ TVoteMachine }

constructor TVoteMachine.Create(Hnd: DWord);
begin
    fMainWindowHandle := Hnd;
    Users := TObjectList.Create;
end;

destructor TVoteMachine.Destroy;
begin
    Users.Free;
end;

{
    GetLibFileFromID: Search in the Library for a File with this ID
}
function TVoteMachine.GetLibFileFromID(aFileID: Integer): TAudioFile;
var i: Integer;
begin
    result := Nil;
    for i := 0 to LibraryList.Count - 1 do
        if TAudioFile(LibraryList[i]).WebServerID = aFileID then
        begin
            result := TAudioFile(LibraryList[i]);
            break;
        end;
end;

{
    getUserforIP: returns a User with the current IP
    If no User can be found, a new one is created
}
function TVoteMachine.getUserforIP(aIP: String): TUser;
var i: Integer;
    aUser: TUser;
begin
    result := Nil;

    for i := 0 to Users.Count - 1 do
    begin
        aUser := TUser(Users[i]);
        if aUser.IP = aIP then
        begin
            result := aUser;
            break;
        end;
    end;

    if not assigned(result) then
    begin
        Result := TUser.Create(aIP);
        Users.Add(Result);
    end;

end;

// this is called from the Messagehandler for "WS_VoteID"
function TVoteMachine.VCLDoVote(aFileID: Integer; aPlaylist: TNempPlaylist): Integer;
var i: integer;
    af: TAudioFile;
begin
    result := 0;  // fail
    for i := 0 to aPlaylist.Playlist.Count - 1 do
    begin
        af := TAudioFile(aPlaylist.Playlist[i]);
        if af.WebServerID = aFileID then
        begin
            af.VoteCounter := af.VoteCounter + 1;   // user clicked a "vote" on a playlist-Item   +1
            fcurrentUser.UpdateVotings(aFileID);
            aPlaylist.ResortVotedFile(af, i);
            result := 1;  // success
            break;
        end;
    end;


end;

function TVoteMachine.VCLDoVoteFilename(aFilename: String; aPlaylist: TNempPlaylist): Integer;
var i: integer;
    af: TAudioFile;
begin
    result := 0;  // fail
    for i := 0 to aPlaylist.Playlist.Count - 1 do
    begin
        af := TAudioFile(aPlaylist.Playlist[i]);
        if af.Pfad = aFilename then
        begin
            case fCurrentUser.VoteAllowed(af.WebServerID) of
                vr_TotalVotesExceeded: result := 3;
                vr_FileVotesExceeded : result := 2;
                vr_success:  begin
                    // vote is allowed
                    af.VoteCounter := af.VoteCounter + 1;  // user searched in the library for an existing file: +1
                    fcurrentUser.UpdateVotings(af.WebServerID);
                    aPlaylist.ResortVotedFile(af, i);
                    result := 1;  // success
                end;
            else
                result := 4;
            end;
            break;
        end;
    end;
    // todo:
    // resort Playlist
end;

function TVoteMachine.VCLAddAndVoteFile(aFile: TAudioFile; aPlaylist: TNempPlaylist): Integer;
var newFile: TAudioFile;
begin
    newFile := aPlaylist.AddFileToPlaylistWebServer(aFile);
    newFile.VoteCounter := newFile.VoteCounter + 1;
    aPlaylist.ResortVotedFile(newFile, aPlaylist.Count - 1);
    result := 1;
    // todo:
    // resort Playlist
end;



function TVoteMachine.ProcessVote(aFileID: Integer; aIP: String): TVoteResult;
var aFile: TAudioFile;
    voteResult: TVoteResult;
begin
    EnterCriticalSection(CS_Vote);
    fcurrentUser := getUserforIP(aIP);
    fcurrentUser.CleanUpVotes;
    result := vr_Success; // thin positive. ;-)

    voteResult := fcurrentUser.VoteAllowed(aFileID);
    if voteResult = vr_Success then
    begin// Vote allowed
        // WS_VoteID will call VCLDoVote
        if SendMessage(fMainWindowHandle, WM_WebServer, WS_VoteID, aFileID) = 1 then
            result := vr_Success // voting was successful
        else
        begin
            // voting was NOT successful
            // probable reason: User voted a FileID, which cannot be found in the playlist
            // => search it in the library and vote this file
            aFile := GetLibFileFromID(aFileID);
            if assigned(aFile) then
            begin
                // WS_VoteFilename will call VCLDoVoteFilename
                case SendMessage(fMainWindowHandle, WM_WebServer, WS_VoteFilename, lParam(PWideChar(aFile.Pfad))) of
                    1: result := vr_Success;  // voting was successful
                    2: result := vr_FileVotesExceeded; // vote NOT allowed
                    3: result := vr_TotalVotesExceeded;
                    4: result := vr_Exception;
                    0: begin
                          // filename not in playlist
                          // => add it to the playlist and vote for it
                          //    (this will call VCLAddAndVoteFile )
                          if SendMessage(fMainWindowHandle, WM_WebServer, WS_AddAndVoteThisFile, LParam(aFile)) = 1 then
                              result := vr_Success   // voting was successful
                          else
                              result := vr_Exception; // insert/voting failed
                    end;
                end;
            end
            else
                // File with this ID neither in Playlist nor in Library
                result := vr_Exception; // file deleted from playlist?
        end;
    end else
        result := voteResult;

    LeaveCriticalSection(CS_Vote);
end;



initialization
    InitializeCriticalSection(CS_Vote);

finalization
    DeleteCriticalSection(CS_Vote);

end.
