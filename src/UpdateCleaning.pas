unit UpdateCleaning;

interface

uses
  System.Classes, System.SysUtils, System.IOUtils;

const
  cCurrentCleanUpdate = 501; // version 5.1

  OutdatedFiles: Array[1..161] of String =
    ( // Help
      'HTML\WebServer-Readme.pdf',
      // Default Images
      'HTML\Default\images\add.png',
      'HTML\Default\images\addnext.png',
      'HTML\Default\images\delete.png',
      'HTML\Default\images\download.png',
      'HTML\Default\images\fail.png',
      'HTML\Default\images\info.png',
      'HTML\Default\images\library.png',
      'HTML\Default\images\list.png',
      'HTML\Default\images\move-down.png',
      'HTML\Default\images\move-up.png',
      'HTML\Default\images\pause.png',
      'HTML\Default\images\playback-start.png',
      'HTML\Default\images\playback-stop.png',
      'HTML\Default\images\search.png',
      'HTML\Default\images\skip-backward.png',
      'HTML\Default\images\skip-forward.png',
      'HTML\Default\images\success.png',
      'HTML\Default\images\volume-down.png',
      'HTML\Default\images\volume-up.png',
      'HTML\Default\images\vote.png',
      'HTML\Default\images\votesmall.png',
      // Default Files
      'HTML\Default\default_cover.png',
      'HTML\Default\favicon.ico',
      'HTML\Default\help.html',
      'HTML\Default\jquery-1.7.1.min.js',
      'HTML\Default\jquery-ui.css',
      'HTML\Default\jquery-ui.min.js',
      'HTML\Default\main.css',
      'HTML\Default\nemp.js',
      // Removed Templates
      'HTML\Default\PaginationMain.tpl',
      'HTML\Default\PaginationOther.tpl',
      'HTML\Default\PaginationNextPage.tpl',
      'HTML\Default\PaginationPrevPage.tpl',
      'HTML\Default\PlayerControls.tpl',
      'HTML\Default\BtnControlNext.tpl',
      'HTML\Default\BtnControlPlay.tpl',
      'HTML\Default\BtnControlPause.tpl',
      'HTML\Default\BtnControlPrev.tpl',
      'HTML\Default\BtnControlStop.tpl',
      // Renamed Templates
      'HTML\Default\ItemSearchResult.tpl',
      'HTML\Default\ItemPlaylist.tpl',
      'HTML\Default\ItemPlaylistDetails.tpl',
      'HTML\Default\ItemSearchDetails.tpl',
      'HTML\Default\Menu.tpl',
      'HTML\Default\MenuLibraryBrowse.tpl',
      'HTML\Default\ItemPlayer.tpl',

      // No JS images
      'HTML\No Javascript\images\add.png',
      'HTML\No Javascript\images\addnext.png',
      'HTML\No Javascript\images\delete.png',
      'HTML\No Javascript\images\download.png',
      'HTML\No Javascript\images\info.png',
      'HTML\No Javascript\images\library.png',
      'HTML\No Javascript\images\list.png',
      'HTML\No Javascript\images\move-down.png',
      'HTML\No Javascript\images\move-up.png',
      'HTML\No Javascript\images\pause.png',
      'HTML\No Javascript\images\playback-start.png',
      'HTML\No Javascript\images\playback-stop.png',
      'HTML\No Javascript\images\search.png',
      'HTML\No Javascript\images\skip-backward.png',
      'HTML\No Javascript\images\skip-forward.png',
      'HTML\No Javascript\images\vote.png',
      'HTML\No Javascript\images\votesmall.png',
      // NoJS Files
      'HTML\No Javascript\default_cover.png',
      'HTML\No Javascript\favicon.ico',
      'HTML\No Javascript\help.html',
      'HTML\No Javascript\main.css',
      // Removed Templates
      'HTML\No Javascript\PaginationMain.tpl',
      'HTML\No Javascript\PaginationOther.tpl',
      'HTML\No Javascript\PaginationNextPage.tpl',
      'HTML\No Javascript\PaginationPrevPage.tpl',
      'HTML\No Javascript\PlayerControls.tpl',
      'HTML\No Javascript\BtnControlNext.tpl',
      'HTML\No Javascript\BtnControlPlay.tpl',
      'HTML\No Javascript\BtnControlPause.tpl',
      'HTML\No Javascript\BtnControlPrev.tpl',
      'HTML\No Javascript\BtnControlStop.tpl',
      // Renamed Templates
      'HTML\No Javascript\ItemSearchResult.tpl', // => ItemFileLibrary
      'HTML\No Javascript\ItemPlaylist.tpl', // => ItemFilePlaylist
      'HTML\No Javascript\ItemPlaylistDetails.tpl', // => ItemFilePlaylistDetails
      'HTML\No Javascript\ItemSearchDetails.tpl', // => ItemFileLibraryDetails
      'HTML\No Javascript\Menu.tpl', // => MenuMain
      'HTML\No Javascript\MenuLibraryBrowse.tpl', // => MenuLibrary
      'HTML\No Javascript\ItemPlayer.tpl', // ItemFilePLayer

      // Remove Party-Theme completely
      // images
      'HTML\Party\images\add.png',
      'HTML\Party\images\addnext.png',
      'HTML\Party\images\delete.png',
      'HTML\Party\images\download.png',
      'HTML\Party\images\fail.png',
      'HTML\Party\images\info.png',
      'HTML\Party\images\library.png',
      'HTML\Party\images\list.png',
      'HTML\Party\images\move-down.png',
      'HTML\Party\images\move-up.png',
      'HTML\Party\images\nemp.png',
      'HTML\Party\images\pause.png',
      'HTML\Party\images\playback-start.png',
      'HTML\Party\images\playback-stop.png',
      'HTML\Party\images\search.png',
      'HTML\Party\images\skip-backward.png',
      'HTML\Party\images\skip-forward.png',
      'HTML\Party\images\success.png',
      'HTML\Party\images\volume-down.png',
      'HTML\Party\images\volume-up.png',
      'HTML\Party\images\vote.png',
      'HTML\Party\images\votesmall.png',
      // admin
      'HTML\Party\admin\Body.tpl',
      'HTML\Party\admin\BtnControlNext.tpl',
      'HTML\Party\admin\BtnControlPause.tpl',
      'HTML\Party\admin\BtnControlPlay.tpl',
      'HTML\Party\admin\BtnControlPrev.tpl',
      'HTML\Party\admin\BtnControlStop.tpl',
      'HTML\Party\admin\BtnFileAdd.tpl',
      'HTML\Party\admin\BtnFileAddNext.tpl',
      'HTML\Party\admin\BtnFileDelete.tpl',
      'HTML\Party\admin\BtnFileDownload.tpl',
      'HTML\Party\admin\BtnFileMoveDown.tpl',
      'HTML\Party\admin\BtnFileMoveUp.tpl',
      'HTML\Party\admin\BtnFilePlayNow.tpl',
      'HTML\Party\admin\ItemPlaylist.tpl',
      'HTML\Party\admin\ItemPlaylistDetails.tpl',
      'HTML\Party\admin\ItemSearchDetails.tpl',
      'HTML\Party\admin\ItemSearchResult.tpl',
      'HTML\Party\admin\PagePlayer.tpl',
      'HTML\Party\admin\PlayerControls.tpl',
      // user
      'HTML\Party\Body.tpl',
      'HTML\Party\BtnFileDownload.tpl',
      'HTML\Party\BtnFileVote.tpl',
      'HTML\Party\default_cover.png',
      'HTML\Party\favicon.ico',
      'HTML\Party\help.html',
      'HTML\Party\ItemBrowseAlbum.tpl',
      'HTML\Party\ItemBrowseArtist.tpl',
      'HTML\Party\ItemBrowseGenre.tpl',
      'HTML\Party\ItemPlayer.tpl',
      'HTML\Party\ItemPlaylist.tpl',
      'HTML\Party\ItemPlaylistDetails.tpl',
      'HTML\Party\ItemSearchDetails.tpl',
      'HTML\Party\ItemSearchResult.tpl',
      'HTML\Party\jquery-1.7.1.min.js',
      'HTML\Party\jquery-ui.css',
      'HTML\Party\jquery-ui.min.js',
      'HTML\Party\main.css',
      'HTML\Party\main_admin.css',
      'HTML\Party\Menu.tpl',
      'HTML\Party\MenuLibraryBrowse.tpl',
      'HTML\Party\PageError.tpl',
      'HTML\Party\PageLibrary.tpl',
      'HTML\Party\PageLibraryDetails.tpl',
      'HTML\Party\PagePlayer.tpl',
      'HTML\Party\PagePlaylist.tpl',
      'HTML\Party\PagePlaylistDetails.tpl',
      'HTML\Party\Pagination.tpl',
      'HTML\Party\PaginationMain.tpl',
      'HTML\Party\PaginationNextPage.tpl',
      'HTML\Party\PaginationOther.tpl',
      'HTML\Party\PaginationPrevPage.tpl',
      'HTML\Party\party.js',
      'HTML\Party\party_admin.js',
      'HTML\Party\WarningNoFiles.tpl'
    );

    OutdatedDirectories: Array[1..5] of String = (
      'HTML\No Javascript\images\',
      'HTML\Default\images\',
      'HTML\Party\admin\',
      'HTML\Party\images\',
      'HTML\Party\'
    ) ;


function CountOutDatedFiles: Integer;
function CountOutDatedDirectories: Integer;


procedure ListOutdatedFiles(Dest: TStrings);
procedure ListOutdatedDirectories(Dest: TStrings);

function DeleteOutdatedFiles: Boolean;
function DeleteOutdatedDirectories: Boolean;

implementation

function CountOutDatedFiles: Integer;
var
  i: Integer;
  localPath: String;
begin
  result := 0;
  localPath := ExtractFilePath(ParamStr(0));
  for i := Low(OutdatedFiles) to High(OutdatedFiles) do
    if TFile.Exists(localPath + OutdatedFiles[i]) then
      inc(result);
end;

function CountOutDatedDirectories: Integer;
var
  i: Integer;
  localPath: String;
begin
  result := 0;
  localPath := ExtractFilePath(ParamStr(0));
  for i := Low(OutdatedDirectories) to High(OutdatedDirectories) do
    if TDirectory.Exists(localPath + OutdatedDirectories[i]) then
      inc(result);
end;

procedure ListOutdatedFiles(Dest: TStrings);
var
  i: Integer;
  localPath: String;
begin
  Dest.Clear;
  localPath := ExtractFilePath(ParamStr(0));
  for i := Low(OutdatedFiles) to High(OutdatedFiles) do
    if TFile.Exists(localPath + OutdatedFiles[i]) then
      Dest.Add(OutdatedFiles[i]);
end;

procedure ListOutdatedDirectories(Dest: TStrings);
var
  i: Integer;
  localPath: String;
begin
  Dest.Clear;
  localPath := ExtractFilePath(ParamStr(0));
  for i := Low(OutdatedDirectories) to High(OutdatedDirectories) do
    if TDirectory.Exists(localPath + OutdatedDirectories[i]) then
      Dest.Add(OutdatedDirectories[i]);
end;


function DeleteOutdatedFiles: Boolean;
var
  i: Integer;
  localPath, currentFile: String;
begin
  localPath := ExtractFilePath(ParamStr(0));
  Result := True;
  for i := Low(OutdatedFiles) to High(OutdatedFiles) do begin
    currentFile := localPath + OutdatedFiles[i];
    if TFile.Exists(currentFile) then begin
      if not DeleteFile(currentFile) then
        Result := False;
    end;
  end;
end;

function DeleteOutdatedDirectories: Boolean;
var
  i: Integer;
  localPath, iDir: String;
begin
  localPath := ExtractFilePath(ParamStr(0));
  Result := True;
  for i := Low(OutdatedDirectories) to High(OutdatedDirectories) do begin
    iDir := localPath + OutdatedDirectories[i];
    if TDirectory.Exists(iDir) then begin
      if TDirectory.IsEmpty(iDir) then begin
        // try to delete the Directory
        TDirectory.Delete(iDir);
        // check if it is deleted now
        if TDirectory.Exists(iDir) then
          Result := False;
      end
      else
        // Directory is not empty. Do not delete it automatically
        Result := False;
    end;
  end;
end;

end.
