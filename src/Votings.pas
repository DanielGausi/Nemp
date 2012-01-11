unit Votings;

interface

uses Windows, Classes, Messages, ContNrs, SysUtils, IniFiles,  StrUtils,
  DateUtils,
  MP3FileUtils, AudioFileClass, Hilfsfunktionen,
  Playlistclass, PlayerClass, Nemp_ConstantsAndTypes,
  MedienbibliothekClass;

type

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
            destructor Destroy;
            procedure CleanUpVotes;
            function VoteAllowed(aFileID: Integer): Boolean;
            procedure UpdateVotings(aFileID: Integer);
    end;

    TVoteMachine = class
        private
            fMainWindowHandle: DWord;
            function getUserforIP(aIP: String): TUser;
        public
            Users: TObjectList;
            LibraryList: TObjectList;

            constructor Create(Hnd: DWord);
            destructor Destroy;

            function GetLibFileFromID(aFileID: Integer): TAudioFile;

            function ProcessVote(aFileID: Integer; aIP: String ): Boolean;
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
function TUser.VoteAllowed(aFileID: Integer): Boolean;
var i: Integer;
begin
    result := True;
    if Votes.Count > 20 then
        // Hardcoded spam-limit: 20 votes in 60 seconds
        result := False
    else
    begin
        for i := 0 to Votes.Count - 1 do
            if TVote(Votes[i]).ID = aFileID then
                result := False;
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
begin


result := Nil;
    for i := 0 to fWebMedienBib.Count - 1 do
    begin
        if TAudioFile(fWebMedienBib[i]).WebServerID = aID then
        begin
            result := TAudioFile(fWebMedienBib[i]);
            break;
        end;
    end;


end;

{
    getUserforIP: returns a User with the current IP
    If no User can be found, a new obne is created
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

function TVoteMachine.ProcessVote(aFileID: Integer; aIP: String): Boolean;
var currentUser: TUser;
begin
    EnterCriticalSection(CS_Vote);
    currentUser := getUserforIP(aIP);
    currentUser.CleanUpVotes;
    if currentUser.VoteAllowed(aFileID) then
    begin
        // Vote allowed
        if SendMessage(fMainWindowHandle, WM_WebServer, WS_VoteID, aFileID) = 1 then
            // voting was successful, update users Votings
            currentUser.UpdateVotings(aFileID)
        else
        begin
            // voting was NOT successful
            // probable reason: User voted a FileID, which cannot be found in the playlist
            // => Get the file with aFileID from the Library-List
            //    Check, whether a file with the same FILENAME is in the playlist and get its ID
            //    Check VoteAllowed for this ID and Vote

        end;


    end else
    begin
        // vote not allowed
        result := False;
    end;



    // doing a lot of stuff ;-)

    LeaveCriticalSection(CS_Vote);
end;




initialization
    InitializeCriticalSection(CS_Vote);

finalization
    DeleteCriticalSection(CS_Vote);

end.
