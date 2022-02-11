{

    Unit Nemp_RessourceStrings

    - Strings used in Nemp.
      They are translated by GnuGetText

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
Unit Nemp_RessourceStrings;

interface

Resourcestring

//TreeEntry_All = '<All>';

  // for Dialogs (copy of myDialogs.pas)
  XcmbYes = '&Yes'; //'&Yes';
  XcmbNo = '&No';
  XcmbOK = 'OK';
  XcmbCancel = 'Cancel';
  XcmbHelp = '&Help';
  XcmbAbort = '&Abort';
  XcmbRetry = '&Retry';
  XcmbIgnore = '&Ignore';
  XcmbAll = '&All';
  XcmbNoToAll = 'N&o to All';
  XcmbYesToAll = 'Yes to &All';

// Optionen-Baum
OptionsTree_Filetypes = 'Filetypes (Windows Registry)';
OptionsTree_Controls = 'Controls';
OptionsTree_Taskbar = 'Taskbar';
OptionsTree_ListsAndColumns = 'Lists and Columns';
OptionsTree_PlayerSettings = 'Player settings';
OptionsTree_Playlist = 'Playlist';
OptionsTree_LastFM = 'LastFM (scrobble)';
OptionsTree_Extended = 'Extended settings';


TreeHeader_Categories = 'Categories';
TreeHeader_CatFiles = 'Music files';
TreeHeader_CatPlaylists = 'Playlists';
TreeHeader_CatWebRadio = 'Webradio stations';

TreeHeader_Artists = 'Artists';
TreeHeader_Albums= 'Albums';
TreeHeader_Directories = 'Directories';
TreeHeader_Genres = 'Genres';
TreeHeader_Years = 'Years';
TreeHeader_Decades = 'Decades';
TreeHeader_Titles = 'Titles';
TreeHeader_FileAges = 'Fileage';
TreeHeader_FileAgesMonth = 'Fileage (by month)';
TreeHeader_PlayCounter = 'Play counter';
TreeHeader_Playlists = 'Playlists';
TreeHeader_Playlist = 'Playlist';
TreeHeader_Webradio = 'Webradio';
TreeHeader_Marker = 'Marker';

Time_HoursLong = 'hours';
Time_DaysLong = 'days';
Time_SecShort = 's';
Time_MinuteShort = 'm';
Time_HourShort = 'h';

// Detail-Form
DetailForm_Caption = 'File properties';
DetailForm_Caption_FileNotFound = '(File not found)';
DetailForm_Caption_WriteProtected = '(write protected)';

DetailForm_InfoLblWebStream = 'URL';
DetailForm_InfoLblDescription = 'Description';
DetailForm_InfoLblHint     = 'Hint:';
DetailForm_InfoLblHinttext = 'Some information could be obsolete or wrong.';
DetailForm_PlayCounter     = 'Played %d times';


DetailForm_InfoLblPath     = 'Path';
DetailForm_InfoLblFilename = 'Filename';
DetailForm_InfoLblFileSize = 'Filesize';
DetailForm_ID3v2Info = '%d Bytes (%d used)';

//DetailForm_VorbisCaption = 'Vorbis Comments';
//DetailForm_ApeCaption    = 'Apev2 Tags';
//DetailForm_iTunesCaption = 'iTunes Tags';

DetailForm_OnlyOneM4ACover = '(only one cover supported)';

DetailForm_SaveChanges = 'Do you want to save the changes in the current file?';
DetailForm_HighPlayCounter = 'This file was played %d times. This information will be irretrievably deleted if you reset the rating.';

DetailForm_LibraryTagChanged = 'You have changed some properties of the audiofile, but these changes have not been saved yet.'
          + 'If you make changes on this page as well, this may result in inconsistencies or unexpected behavior upon saving.'
          + #13#10 + #13#10
          + 'Would you like to save your changes now before you continue?';

DetailForm_NoNewFramesPossible = 'All supported meta frames are already set. There''s nothing Nemp could add to the file here.';
DetailForm_CurrentLibraryCover = 'Current cover art';
DetailForm_CoverflowNotActive = 'The Coverflow will update automatically when you activate it';
DetailForm_NoPictureInOggMetaDataSuppotred = 'Not supported';
DetailForm_CopyFromID3v2 = 'Copy from ID3 v2';
DetailForm_CopyFromAPE = 'Copy from APE';


Warning_FileNotFound = 'File not found';
Warning_FileNotFound_Hint = 'The specified file can not be found. Maybe it is on an external drive which is not connected.';
Warning_Coverbox_NoCover = 'No coverfile found';
Error_CoverInvalid = 'Can''t open file.';

Warning_ReadError = 'Read error';
Warning_ReadError_Hint = 'Nemp can''t gather any further information from the file.';
//'The file could not be opened to get information. The file is maybe in use by another program.';

Warning_InvalidMp3file = 'Invalid mp3-file';
Warning_InvalidMp3file_Hint = 'The specified file with the extension ".mp3" is not a valid mp3-file.';

Warning_InvalidBaseApefile = 'Invalid audiofile';
Warning_InvalidBaseApefile_Hint = 'The specified file is not a valid audiofile.';

Warning_NotSupportedFileType = 'No information available';
Warning_NotSupportedFileType_Hint = 'Nemp can''t gather any further information from the file, as metadata for this type of file is not supported.';


Warning_DownloadDirNotFound   = 'The download directory could not be found.';
Warning_RecordingDirNotFound  = 'The recording directory for webstreams could not be found.';
Warning_RecordingDirNotFoundCreationFailed  = 'The current recording directory for webstreams could not be found, and could also not be created.';
Warning_DataDirNotFound       = 'The data directory could not be found.';

Bitrate_Constant = 'Constant bitrate';
Bitrate_Variable = 'Variable bitrate';

Warning_MedienBibIsBusy = 'The operation could not be processed, because the media library is busy. Please try again later or cancel the running operation.';
Warning_MedienBibIsBusyOnPartyMode = 'The Nemp Partymode can''t be activated, if the media library is busy. Please stop the current operation and try again.';
Warning_MedienBibIsBusyOnClose = 'Nemp is searching for new files or updating the library. Do you really want to quit now?';
Warning_MedienBibIsBusyCritical = 'The library is in a critical update-process right now. Editing files is not possible. Please try again in a few seconds.';
Warning_MedienBibIsBusy_Options
           = 'Some settings could not be changed, because the media library is busy. Please try again later or cancel the running operation by pressing ESC.';

Warning_MedienBibIsBusyRating = 'The media library is busy at the moment, so your rating could not be set there. (If the current file is not in your library at all, you can ignore this message.)';
Warning_MedienBibIsBusyEdit = 'The media library is busy at the moment, so your input could not be saved. Please try again in a few seconds.';
Warning_MedienBibBusyThread = 'The library blocked this very file by an automated background-process right now. Please try again in a few seconds.'  + #13#10
                 + 'Note: The probability for this message is almost zero (unless Gausi made some bad mistakes). You should play Lotto this week!';

// // MedienBib_ConfirmResetRatings = 'This will reset the rating of all files in the library. Ratings within the ID3-tags will not be changed. Continue?';

Warning_TooManyFiles = 'Warning: Too many files for Drag&Drop and Copy&Paste respectively. Only %d files were included.';

Warning_MagicCopyFailed = 'Extended Copy&Paste failed. This method doesn''t work from write-protected drives (e.g. CD/DVD).';

Error_ID3OnlyInMp3Files = 'ID3-tags can only be written to mp3-files.';
//Error_EvilLyricsNotFound1 = 'This function needs another program called "EvilLyrics". Start this program and try again.';
//Error_EvilLyricsNotFound2 = 'This program can easily be found on freeware-sites in the internet.';
//Error_EvilLyricsIncompatible = 'If you started this program already, your version is maybe incompatible to Nemp.';
//Error_EvilLyricsIncompatible2 = 'Your version of EvilLyrics is incompatible to Nemp.';
//EvilLyrics_ManualHint = 'If you found proper lyrics, copy it to this window and click "save".';

LyricsSearch_NotFoundMessage = 'No lyrics found. Do you want to search them manually?';

//ErrorSavingPlaylist = 'An error occured while saving the playlist. This should not happen.';
//ErrorSavingMediaLib = 'An error occured while saving the medialibrary. This should not happen.';
ErrorLoadingMediaLib = 'An error occured while loading the media library. This should not happen.';

Error_HelpFileNotFound = 'The helpfile could not be found.';
Error_ReadmeFileNotFound = 'The readme.txt could not be found.';
Error_LGPLFileNotFound = 'The licence.txt could not be found.';

Error_ID3EditDenied = 'Edit of ID3-Tags denied. You can allow this by Preferences -> System -> Other.';



    BASS_ERRORSTR_INIT       = 'Initialization of the bass.dll failed';
    BASS_ERRORSTR_NOTAVAIL   = 'Invalid device (no sound)';
    BASS_ERRORSTR_NONET      = 'Not connected';
    BASS_ERRORSTR_ILLPARAM   = 'Invalid parameter';
    BASS_ERRORSTR_TIMEOUT    = 'Timeout';
    BASS_ERRORSTR_FILEOPEN   = 'File can not be opened';
    BASS_ERRORSTR_FILEFORM   = 'Unknown format';
    BASS_ERRORSTR_FORMAT     = 'Invalid format';
    BASS_ERRORSTR_SPEAKER    = 'Invalid speaker';
    BASS_ERRORSTR_MEM        = 'Not enough memory';
    BASS_ERRORSTR_NO3D       = 'No 3D-support';
    BASS_ERRORSTR_CODEC      = 'Invalid codec';
    BASS_ERRORSTR_UNKNOWN    = 'Unknown error';
    BASS_ERRORSTR_NOERROR    = 'Allright, no error';
    BASS_ERRORSTR_UNEXPECTED = 'Unexpected error';

    Bass_ErrorStr_BassNotFound = 'Could not find bass.dll version 2.3. Player will probably not work.';
    Bass_Warning_FloatoingPoint = 'Floating points channels are not supported (DirectX 9 required). ';

// wird nur indirekt benötigt. Die Strings im Programm dürfen nicht über diese Bezeichner gesetzt werden, da sie sonst
// automatisch übersetzt werden!!!
CoverFlowText_VariousArtists    = 'Various artists';
CoverFlowText_UnkownCompilation = 'Unknown compilation';
CoverFlowText_VariousGenres     = 'Various genres';
//CoverFlowText_NoCover           = 'Albums without cover';
CoverFlowText_AllArtists        = 'All artists';
CoverFlowText_WholeLibrary      = 'Your media library';
CoverFlowText_WholeLibrarySearchResults = 'Your media library (curent search results)';

TagCloud_YourLibrary = 'Your media library';
TagCloud_MoreFiles = '... and %d more';

//CoverFlowLastFM_Confirmation    = 'Nemp can download missing covers using a webservice from LastFM. Is this ok for you?';
CoverFlowLastFM_HintConnectError = 'Downloading a cover from LastFM failed.' +#13#10 + 'There is a problem with your internet connection.';
CoverFlowLastFM_HintFail         = 'Downloading a cover from LastFM failed.' +#13#10 + 'No proper cover found.';
CoverFlowLastFM_HintOK           = 'This cover was just downloaded from LastFM.';
CoverFlowLastFM_HintCache        = 'Downloading a cover from LastFM cancelled.' + #13#10 + 'This cover was not found a short time ago.' + #13#10  + 'You can clear the cover-cache to retry.';
CoverFlowLastFM_HintInvalid      = 'Downloading a cover from LastFM cancelled.' + #13#10 + 'No proper album information found.' + #13#10 + 'Try to update the ID3-Tags.';


    //Warning_No_PNG = 'PNG-Images are not supported.';

FloatingPointChannels_On = 'Current status: On';
FloatingPointChannels_Off = 'Current status: Off';


    OptionsTree_SystemGeneral     = 'General settings';
    OptionsTree_SystemFiletyps    = 'File types registration';
    OptionsTree_SystemControl     = 'Controls';
    OptionsTree_SystemSystem      = 'System';
    OptionsTree_SystemTaskbar     = 'Taskbar and tray';
    OptionsTree_SystemHibernate   = 'Hibernate / Stand by';

    OptionsTree_ViewMain          = 'Viewing settings';
    OptionsTree_ViewPlayer        = 'Player';
    //OptionsTree_ViewView          = 'View';
    OptionsTree_ViewFonts         = 'Fonts';
    OptionsTree_PartyMode         = 'Party-Mode';
    OptionsTree_ViewExtended      = 'Extended viewing settings';
    OptionsTree_CoverFlow         = 'Coverflow';

    OptionsTree_PlayerMain        = 'Player settings';
    OptionsTree_PlayerPlaylist    = 'Playlist';
    OptionsTree_AudioPlaylist     = 'Playlist';
    OptionsTree_PlayerMedialibrary= 'Media library';
    OptionsTree_PlayerMetaDataAccess = 'Metadata (e.g. ID3Tags)';
    OptionsTree_PlayerWebradio    = 'Web radio';
    OptionsTree_PlayerEffects     = 'Effects and ReplayGain';
    OptionsTree_PlayerEvents      = 'Birthday mode';
    OptionsTree_PlayerScrobbler   = 'LastFM (scrobble)';
    OptionsTree_PlayerWebServer   = 'WebServer';
    OptionsTree_PlayerExtendedPlayer   = 'Extended player settings';
    OptionsTree_PlayerExtendedPlaylist = 'Extended playlist settings';
    OptionsTree_PlayerRandom      = 'Random playback';

    OptionsTree_FilesMain         = 'File management';
    OptionsTree_FilesCover        = 'Cover & Lyrics';


    OptionsTree_ExtendedMain      = 'Extended settings';
    OptionsTree_MediabibSearch    = 'Search options';
    OptionsTree_MediabibUnicode   = 'Unicode';

    OptionsForm_DefaultCoverResetFailed = 'The default cover cannot be restored because the original file "default_cover.jpg" was not found.';
    OptionsForm_DefaultCoverChangeFailed = 'Sorry, some error occured while saving the new default cover art in the Nemp cover archive.';
    OptionsForm_InvalidTime = 'Invalid time. Try something between 00:00 and 23:59.';

    OptionsForm_UnratedFilesHint = '* Including %d unrated files.';

    Warning_NoSkinFound = 'No skins found';
    AdvancedSkinActivateHint = 'Note: The current skin does not support advanced skinning.';
    FiletypeRegistration_AudioFileEnqueue  = 'Enqueue in Nemp';
    FiletypeRegistration_AudioFilePlay     = 'Play in Nemp';
    FiletypeRegistration_PlaylistEnqueue   = 'Enqueue in Nemp';
    FiletypeRegistration_PlaylistPlay      = 'Play in Nemp';
    FiletypeRegistration_DirEnqueue        = 'Enqueue in Nemp';
    FiletypeRegistration_DirPlay           = 'Play in Nemp';

    ScrobbleWizardIntro = 'Nemp can scrobble what you hear to your account on LastFM. To do this, Nemp needs your permission to access your LastFM user-profile. Click "Start" to begin the configuration.';
    ScrobbleWizardGetToken = 'Step 1/4. Connect your computer with the internet and click "Next" to contact LastFM for authorization.';
    ScrobbleWizardAuthorize = 'Step 2/4. Nemp will now direct you to the LastFM-site in a browser window. Login with your LastFM username/password, click "Yes, allow access" and return to this window.';
    ScrobbleWizardYesIDid = 'Step 3/4. Click "Next" when you have granted Nemp permission to use your LastFM account.';
    ScrobbleWizardGetSessionKey = 'Step 4/4. Thank you. To finish the configuration Nemp will contact LastFM for your username and a sessionkey which will be used for scrobbling. Click Next to continue.';
    ScrobbleWizardComplete ='Nemp is now ready to scrobble. Have fun.';

    ScrobbleWizardError = 'An error occured. See log below and try again.';
    ScrobbleWizardIntroRestart = 'In case Scrobbling does not work (see Log below) you can try to restart the configuration.';

    Scrobble_ConnectError = 'Could not connect to server. Please check your internet configuration.';
    Scrobble_ProtocolError = 'Could not get proper information from server.';
    Scrobble_UnkownError = 'An error occured while connecting LastFM server.';
    Scrobble_ErrorPleaseReport = 'Please report this error.';

    Scrobble_Active = 'Scrobble Log (Status: Sending data...)';
    Scrobble_InActive = 'Scrobble Log (Status: Idle)';
    Scrobble_Offline = 'Scrobble Log (Status: Offline)';

    ScrobblingSkipped = 'Scrobbling skipped for approx  %d minutes. ';
    ScrobbleFailureWait = 'Something is wrong with scrobbling. Nemp will disable it for approx %d minutes. '
      +#13#10+'See the log entries within the settings dialog for details.';

    ScrobbleSettings_Incomplete = 'Your LastFM Session Key is missing or invalid. Do you want to (re)authenticate scrobbling now?';

    ScrobbleException = 'Something is terribly wrong with scrobbling - Nemp will disable it now permanently. See the log entries within the settings dialog for details.'
    +#13#10+'If this message occurs continuously, please report this to mail@gausi.de. Thank you.';


SelectDirectoryDialog_BibCaption = 'Please select the root directory of the audiofiles you want to add to the media library.';
SelectDirectoryDialog_PlaylistCaption = 'Please select the root directory of the audiofiles you want to add to the playlist.';
SelectDirectoryDialog_Webradio_Caption = 'Select download directory for webstreams';
SelectDirectoryDialog_RemoteNemp = 'Select download directory';

AutoScanDir_AlreadyExists = 'The selected directory (or a parent directory) is already in the list.';
AutoSacnDir_SubDirExisted = 'A subdirectory of the selected directory was removed from the list: ';

WinX64WarningDeskband = 'You are using a 64Bit-Version of Windows. Installing a Deskband is unfortunately not possible.';
WinVistaWarningDeskband = 'The Nemp Deskband is not compatible with Windows Vista or later.';
Win7WarningDeskband = 'The Nemp Deskband is not compatible with Windows Vista or later. Use the buttons in the Windows Taskbar-preview instead.';

    EQSetting_Custom = '(Custom)';
    Infostring_Webstream = 'Webstream';
    Infostring_Bitrate   = 'Bitrate';
    Infostring_Duration  = 'Duration';
    Infostring_Samplerate = 'Samplerate';
    Infostring_NoLyrics   = 'No lyrics found';

BadError_Play = 'An error occured while getting new playing file. This should not happen.' ;
BadError_Play1 = 'An error occured while starting playback of a new track. This should not happen.';
BadError_Play2 = 'An error occured while initializing the player. This should not happen.';

    Hint_RandomPlaylist_NotEnoughTitlesFound =
       'Only %d titles found with these settings. Take these files as new playlist?';

{RemoteNemp_NempServerFound  = 'Nemp server found at %s.';
RemoteNemp_StatusOnline     = 'Status: Online';
RemoteNemp_StatusOffline    = 'Status: Offline';
RemoteNemp_ActivateServer   = 'Activate server';
RemoteNemp_DeActivateServer = 'Deactivate server';
NempRemote_ConnectionOK     = 'Successfully connected to %s.';
NempRemote_InvalidUsername  = 'Invalid username or password.';
NempRemote_ErrorOnLogin     = 'Login failed.';
NempRemote_LoginDenied      = 'Login denied.';
NempRemote_AlreadyConnected = 'You are already connected with %s.';
NempRemote_LogoutOK         = 'Logout successful.';
NempRemote_AlreadyLoggedOut = 'You are already logged out.';
NempRemote_NotConnected     = 'You are not connected to a remote Nemp.';
NempRemote_SearchDenied     = 'Search query denied.';
NempRemote_SearchFailed     = 'Search failed.';
NempRemote_SearchFailed2    = 'Search failed for unknown reason.';
NempRemote_DownloadProgress = 'Downloading file %d of %d';
NempRemote_DownloadDenied   = 'Download denied.';
NempRemote_DownloadDeniedMediaLib = 'Download denied. The queried file can not be found in the media library. You evil hack0r!';
NempRemote_DownloadDFailedFileNotFound = 'Download failed. The queried file %s can not be found on the remote system.';
NempRemote_DownloadFailedAccessError = 'Download failed. The queried file %s can not be opened by the remote system.';
}

WebServer_StatusOnline     = 'Status: Online';
WebServer_StatusOffline    = 'Status: Offline';
WebServer_ActivateServer   = 'Activate server';
WebServer_DeActivateServer = 'Deactivate server';
// WebServer_GetIPFailes      = 'Cannot get IP-address. Please check your internet configuration.';
WebServer_GetIPFailedShort = 'Failed.';
WebServer_GettingIP        = 'Connecting...';
WebServer_PortChangeFailed = 'The Nemp Webserver is running. The new Port is not valid until you restart it.';

WebServer_UnknownError = 'Unknown error';
WebServer_SomeError = 'Some error occured. Please try again.';
WebServer_RemoteControlDenied = 'Remote control denied.';
WebServer_DownloadDenied = 'Download denied.';
WebServer_LibraryAccessDenied = 'Library access denied.';
WebServer_AccessDenied = 'Access denied.';
WebServer_FileNotFound = 'File not found.';
WebServer_InvalidParameter = 'Invalid parameter.';
// WebServer_NoFile = 'No file loaded.';
WebServer_EmptyPlaylist = 'No files to display. The playlist is empty.';
WebServer_PlayerNotReady = 'The Player is not ready: No file was loaded.';
WebServer_EmptyLibrary = 'Nothing to display. The library is empty.';

NempUpdate_ConnectError = 'Could not connect to server. Please check your internet configuration.';
NempUpdate_Error = 'Could not get update information from server.';
NempUpdate_UnkownError = 'An error occured while getting update information from server.';
NempUpdate_CurrentVersion = 'You are using the newest version of Nemp.';
NempUpdate_VersionError = 'Unable to extract version information from server.';
/// NempUpdate_NewerVersion = 'A newer Version of Nemp is available. Do you want to download it now?';

/// NempUpdate_TestVersionAvailable = 'You are using the newest stable version of Nemp, but there is a new unstable version available.' + #13#10 + 'Do you want to download and test it now?';
/// NempUpdate_NewerTestVersionAvailable = 'Thank you for beta-testing Nemp. There is a newer test-version of Nemp available.' + #13#10 + 'Do you want to download and test it now?';
NempUpdate_CurrentTestVersion = 'Thank you for beta-testing Nemp. You are using the newest version.';
NempUpdate_PrivateVersion = 'It seems that you are using an experimental version of Nemp. Thank you for testing it.';

NempUpdate_InfoNewVersionAvailable = 'New version available: %s';
NempUpdate_InfoNewBetaVersionAvailable = 'New beta version available: %s';
NempUpdate_InfoDeveloperVersion = 'Developer version (Latest release: %s)';
NempUpdate_InfoYourVersion = 'Your current version: %s';
// NempUpdate_InfoNewestVersion = 'Newest version: %s';
NempUpdate_InfoLastBetaRelease = 'Latest release: %s (%s)';
NempUpdate_InfoLastStableRelease = 'Latest stable release: %s';
// NempUpdate_InfoNote = 'Note: %s';
//NempUpdate_InfoFirstStart = 'It seems that you are using Nemp (or this version) for the first time. Nemp will now search for a newer version (even if it is probably up-to-date)' +#13#10
//                            + 'to show you this function. After this Nemp will search once a week for an update without showing this message.'
//                            + #13#10#13#10
//                            + 'No personal information will be sent. You can deactivate this function within the preferences (and change the interval), or right now by clicking "Cancel".';


  NempShutDown_StopNemp  = 'Nemp will stop now.';
  NempShutDown_CloseNemp = 'Nemp will close now.';
  NempShutdown_Suspend   = 'Windows will suspend now. When you switch on your computer, the current session will be restored.';
  NempShutDown_Hibernate = 'Windows will hibernate now. When you switch on your computer, the current session will be restored.';
  NempShutDown_ShutDown  = 'Windows will shutdown now. Unsaved data could be lost.';
  NempShutDown_CountDownLbl = 'ShutDown in %d seconds';

  NempShutDown_StopHint_AtEndOfPlaylist      = 'Nemp will stop at the end of the playlist.';
  NempShutDown_CloseHint_AtEndOfPlaylist     = 'Nemp will close at the end of the playlist.';
  NempShutDown_SuspendHint_AtEndOfPlaylist   = 'Windows will suspend at the end of the playlist.';
  NempShutDown_HibernateHint_AtEndOfPlaylist = 'Windows will hibernate at the end of the playlist.';
  NempShutDown_ShutDownHint_AtEndOfPlaylist  = 'Windows will shutdown at the end of the playlist.';
  NempShutDown_AtEndOfPlaylist_Hint = 'Note that this only makes sense with mode "Repeat off" and no webstreams in the playlist.';
  NempShutDown_AtEndOfPlaylist_Dlg = 'Shutting down at the end of the playlist only works with "Repeat off". Therefore Nemp will change the playback mode if you continue.';


  NempShutDown_StopHint     = 'Nemp will stop in %s.';
  NempShutDown_CloseHint     = 'Nemp will close in %s.';
  NempShutDown_SuspendHint   = 'Windows will suspend in %s.';
  NempShutDown_HibernateHint = 'Windows will hibernate in %s.';
  NempShutDown_ShutDownHint  = 'Windows will shutdown in %s.';

  NempShutDown_CountDownLblMainForm = 'Shutdown in %s.';
  NempShutDown_AtEndOfPlaylist = 'Shutdown after the last file.';


  NempShutDown_StopPopupBlank      = 'Stop Nemp';
  NempShutDown_ClosePopupBlank     = 'Close Nemp';
  NempShutDown_SuspendPopupBlank   = 'Suspend Windows';
  NempShutDown_HibernatePopupBlank = 'Hibernate Windows';
  NempShutDown_ShutDownPopupBlank  = 'Shutdown Windows';


  NempShutDown_PopupNotActive      = 'Current status: not active';
  NempShutDown_StopPopupTime       = 'Current status: Stop Nemp in ~%s';
  NempShutDown_ClosePopupTime      = 'Current status: Close Nemp in ~%s';
  NempShutDown_SuspendPopupTime    = 'Current status: Suspend Windows in ~%s';
  NempShutDown_HibernatePopupTime  = 'Current status: Hibernate Windows in ~%s';
  NempShutDown_ShutDownPopupTime   = 'Current status: Shutdown Windows in ~%s';

  NempShutDown_StopPopupTime_AtEndOfPlaylist       = 'Current status: Stop Nemp after the last file'; // Not needed!
  NempShutDown_ClosePopupTime_AtEndOfPlaylist      = 'Current status: Close Nemp after the last file';
  NempShutDown_SuspendPopupTime_AtEndOfPlaylist    = 'Current status: Suspend Windows after the last file';
  NempShutDown_HibernatePopupTime_AtEndOfPlaylist  = 'Current status: Hibernate Windows after the last file';
  NempShutDown_ShutDownPopupTime_AtEndOfPlaylist   = 'Current status: Shutdown Windows after the last file';


  BirthdayCountDown_Caption = 'Birthday in %s';
  BirthdayCountDown_Hint    = 'In %s the current playlist will be interrupted for a little birthday song.';
  BirthdaySettings_Incomplete = 'Settings for birthday mode are incomplete. Edit them now?';
  BirthdaySettings_IncompleteSettingsDialog = 'Settings for birthday mode are incomplete. Please correct them first.';

(*
SkinEditor_QueryDeleteMainBMP   = 'Preferred image file "main.bmp" already exists and must be deleted first. Continue?';
SkinEditor_QueryReplaceOldFiles = 'Image file already exists. Do you want to replace this file with the new one?';
SkinEditor_NewSkinDefaultName   = 'New skin';
SkinEditor_NewSkinCaption       = 'Create new skin';
SkinEditor_NewSkinLabel         = 'Name of the new skin';
SkinEditor_WarningForbiddenChars= 'The following chars are not allowed: %s';
SkinEditor_SkinAlreadyExists    = 'A skin with this name already exists.';
SkinEditor_SkinDirFailed        = 'Creating the skin directory failed. Try to create a private skin.';
SkinEditor_ButtonCreateSuccess  = 'Button templates created.';
SkinEditor_ButtonCreateFailed   = 'Failed to create button templates.';
 *)

HeadSetForm_NoAudioFile = 'Select an audiofile in the main window first.';

MainForm_NoSearchHistory = 'Previous searchs';
MainForm_GlobalQuickSearch    = 'Quicksearch (library)';
// MainForm_LocalQuickSearch     = 'Quicksearch (current list)';
/// MainForm_MoreSearchresults  = 'Additional results (not limited to current preselection)';
MainForm_NoSearchresults    = 'Nothing found. Try another search.';
MainForm_EmptyCategory      = 'There are no files in the current category.';
MainForm_SearchQueryTooShort = 'Search query too short. Please enter at least 2 characters.';
MainForm_NoFavorites = 'No files flagged with this marker.';
// DummyFile for browsing Playlists/Webradio
MainForm_NoTitleInformationAvailable = 'No title information available.';

MainForm_GlobalQuickSearchHint = 'Search in the media library';

MainForm_DoublClickToSearchTags   = 'Doubleclick to show all files tagged with "%s"';
MainForm_DoublClickToSearchArtist = 'Doubleclick to show all files from the artist "%s"';
MainForm_DoublClickToSearchTitle  = 'Doubleclick to show all files with the title "%s"';
MainForm_DoublClickToSearchAlbum  = 'Doubleclick to show all files from the album "%s"';
MainForm_DoublClickToSearchYear   = 'Doubleclick to show all files from the year "%s"';
MainForm_DoublClickToSearchGenre  = 'Doubleclick to show all files from the genre "%s"';
MainForm_DoublClickToSearchDirectory = 'Doubleclick to show all files in this directory';
MainForm_DoublClickToAddTagHint   = 'Doubleclick to add a new tag';
MainForm_DoublClickToAddTag       = '[Add a tag]';
MainForm_AddTagQueryCaption = 'Nemp: Add tags';
MainForm_AddTagQueryLabel = 'New tag to add:';
MainForm_RenameTagQueryCaption = 'Nemp: Rename tag';
MainForm_RenameTagQueryLabel = 'Rename "%s" to:';


MainForm_TagAlreadyExists = 'The file was already tagged with "%s".';
MainForm_DuplicateTagsFound = 'Some duplicate tags has been removed.';
MainForm_OnlyDuplicateTagsFound = 'The file was already tagged with all the tags you entered.';
MainForm_TagNotSupportedFileFormat = 'Sorry. This file does not support additional tags.';
MainForm_AddTagCommasFound = 'It looks like you entered more than one tag at once. Do you want Nemp to treat your input as a comma-separated list of tags?';

TagManagement_TagDuplicateInput = 'Hint: The tag "%s" was entered more than once.';
TagManagement_TagAlreadyExists = 'Hint: The file was already tagged with "%s".';
TagManagement_TagIsOnIgnoreList = 'Warning: The tag "%s" is on the "Ignore list".';
TagManagement_TagIsOnRenameList = 'Warning: The tag "%s" is on the "Rename list" and should be replaced with "%s".';
TagManagement_RenameTagNoCommas = 'Pleaser enter only one tag, and not a comma separated list of tags.';

TagManagement_FileCountWarning = 'This will affect up to %d files in your media library. Do you want to continue?';

TagManagement_IgnoreTagIsInRenameListOrig      = 'Warning: The tag "%s" is already part of a "Rename rule" and is replaced with "%s".';
TagManagement_IgnoreTagIsInRenameListRename    = 'Warning: The tag "%s" is already part of a "Rename rule" and is the replacement for "%s".';
TagManagement_RenameTagIsInIgnoreList          = 'Warning: The tag "%s" is already on the "Ignore list".';
TagManagement_RenameTagIsInMergeListOriginal   = 'Warning: The tag "%s" is already part of a "Rename rule" and is replaced with "%s".';
TagManagement_OriginalTagIsInMergeListOriginal = 'Warning: The tag "%s" is already part of a "Rename rule" and is replaced with "%s".';
TagManagement_OriginalTagIsInMergeListRename   = 'Warning: The tag "%s" is already part of a "Rename rule" and is the replacement for "%s".';

TagManagementDialog_Caption = 'Confirmation';
TagManagementDialog_Text    = 'Nemp recognized some inconsistencies with the new tags (details below).'
            +#13#10 + 'Click "OK" to resolve the inconsistencies automatically or'
            +#13#10 + 'Click "Ignore" to ignore the warnings and set the new tags anyway.'
            +#13#10 + #13#10;
TagManagementDialog_ShowAgain = 'Save selection and do not show this dialog again.';

TagManagementDialog_TextRules = 'Nemp recognized some inconsistencies with the new tag rules (details below).'
            +#13#10 + 'Click "OK" to resolve the inconsistencies by removing/changing the existing rules or'
            +#13#10 + 'Click "Ignore" to ignore the warnings and add the new tag rules anyway.'
            +#13#10
            +#13#10 + 'WARNING: Ignoring these inconsistencies could lead to unpredictable behavior when adding new tags to audio files.'
            +#13#10 + #13#10;

TagManagementDialogOnlyHint_Caption = 'Information';
TagManagementDialogOnlyHint_Text = 'Nemp recognized and resolved some inconsistencies with the new tags (details below).'
            +#13#10 + #13#10;

TagManagementDialogOnlyHint_ShowAgain = 'Do not show this dialog again.';

//TagManagement_ChangeArtist = 'Edit artist';
//TagManagement_ChangeTitle  = 'Edit title';
//TagManagement_ChangeAlbum  = 'Edit album';


MainForm_PlaylistSearch    = 'Search';
MainForm_PlaylistSearchHint = 'Search in the playlist';

MainForm_RecentQuickSearchresults = 'Recent searches';
MainForm_NoRecentQuickSearchresults = 'No recent searches';

MainForm_MarkerBtnHint = 'Show only files flagged with one of the markers.';
MainForm_MarkerErrorPlaylistFiles = 'Hint: This audiofile is part of a playlist, but it is not part of the Media Library itself. - The marker will disappear as soon as the displayed list of audio files changes.';

//MainForm_FavoriteBtnHint = 'Show all files marked as favorites'
//                    + #13#10 + '- use F4 to add a file to favorites'
//                    + #13#10 + '- use Ctrl+F4 to remove a file from favorites';

MainForm_BtnEqualizerPresetsSelect = 'Select';
MainForm_BtnEqualizerPresetsCustom = 'Custom';
MainForm_BtnEqualizerSaveNewButton = 'New ...';
MainForm_BtnEqualizerSaveNewCaption = 'Name for the new preset';
MainForm_BtnEqualizerSaveNewPrompt = 'Please insert a name for the new preset.';

MainForm_BtnEqualizerDeleteQuery = 'This will delete the preset "%s". Continue?';
MainForm_BtnEqualizerOverwriteQuery = 'This will overwrite the preset "%s" with the current settings. Continue?';
Player_RestoreDefaultEqualizer = 'This will delete your personal settings for the default presets (e.g. "Full Bass" or "Reggae").'+#13#10#13#10+' Other presets ("New preset") are not affected.';
MainForm_EqualizerInvalidInput = 'Invalid input. Only chars (a..z), numbers (0..9) and space ( ) are allowed. Please choose another name.';


MainForm_RepeatBtnHint_RepeatAll   = 'Repeat all';
MainForm_RepeatBtnHint_RepeatTitle = 'Repeat title';
MainForm_RepeatBtnHint_RandomMode  = 'Random mode';
MainForm_RepeatBtnHint_NoRepeat    = 'Repeat off';
MainForm_RecordBtnHint_Start       = 'Start recording';
MainForm_RecordBtnHint_Recording   = 'Recording...';

MainForm_StopBtn_NormalHint = 'Stop';
MainForm_StopBtn_StopAfterTitleHint = 'Nemp will stop playback after current title.';
MainForm_StopMenu_StopAfterTitle = 'Stop after current title (Shift+Click)';
MainForm_StopMenu_NoStopAfterTitle = 'Do not stop after current title (Shift+Click)';
MainForm_PlaylistMenu_StopAfterTitle = 'Stop after current title';
MainForm_PlaylistMenu_NoStopAfterTitle = 'Do not stop after current title';


MainForm_ReverseBtnHint_PlayNormal  = 'Play forwards';
MainForm_ReverseBtnHint_PlayReverse = 'Play backwards';

MainForm_ABRepeatBtnHint_Show = 'Show controls for A-B-Repeat';
MainForm_ABRepeatBtnHint_Hide = 'Disable A-B-Repeat';

MainForm_ShuttingDownHint          = 'Shutting down...';
MainForm_ShuttingDownHint_MediaLib = 'Saving media library...';

MainForm_NoSearchKeywords  = 'No search phrase';
SearchForm_CBAddRefineSearch = '(refined search)';
SearchForm_CBAddExtendSearch = '(extended search)';

MainForm_MenuCaptionsPlay      = 'Play (and clear current playlist)';
MainForm_MenuCaptionsEnqueue   = 'Enqueue (at the end of the playlist)';
MainForm_MenuCaptionsPlayNext  = 'Enqueue (after the current title)'; //'Enqueue (at the end of the prebook-list)';
MainForm_MenuCaptionsPlayNow   = 'Just play focussed file (no playlist change)';
MainForm_MenuCaptionsSortLayerBy = 'Sort layer "%s" by';
MainForm_MenuCaptionsSortDirectoriesBy = 'Sort Directories by';
MainForm_MenuCaptionsSortTagCloudBy = 'Sort Tags by';

MainForm_MenuCaptionsSortCollectionBy = 'Sort "%s" by';

MainForm_MenuCaptionsPlayAllArtist      = 'Play all tracks of this artist (and delete current playlist)';
MainForm_MenuCaptionsPlayAllAlbum       = 'Play all tracks of this album (and delete current playlist)';
MainForm_MenuCaptionsPlayAllDirectory   = 'Play all tracks of this directory (and delete current playlist)';
MainForm_MenuCaptionsPlayAllGenre       = 'Play all tracks of this genre (and delete current playlist)';
MainForm_MenuCaptionsPlayAllYear        = 'Play all tracks of this year (and delete current playlist)';
MainForm_MenuCaptionsPlayAllTag         = 'Play all tracks with this tag (and delete current playlist)';

MainForm_MenuCaptionsPlayAllPlaylist = 'Play all tracks of this playlist (and delete current playlist)';
MainForm_MenuCaptionsPlayAllWebradio = 'Play all tracks of this webradio station (and delete current playlist)';



MainForm_MenuCaptionsEnqueueAllArtist      = 'Enqueue all tracks of this artist (at the end of the playlist)';
MainForm_MenuCaptionsEnqueueAllAlbum       = 'Enqueue all tracks of this album (at the end of the playlist)';
MainForm_MenuCaptionsEnqueueAllDirectory   = 'Enqueue all tracks of this directory (at the end of the playlist)';
MainForm_MenuCaptionsEnqueueAllGenre       = 'Enqueue all tracks of this genre (at the end of the playlist)';
MainForm_MenuCaptionsEnqueueAllYear        = 'Enqueue all tracks of this year (at the end of the playlist)';
MainForm_MenuCaptionsEnqueueAllTag         = 'Enqueue all tracks with this tag (at the end of the playlist)';
MainForm_MenuCaptionsEnqueueAllDate        = 'Enqueue all tracks from this month (at the end of the playlist)';

MainForm_MenuCaptionEnqueueAll = 'Enqueue all tracks in category "%s"';
MainForm_MenuCaptionEnqueueCollection = 'Enqueue all tracks from "%s"';
MainForm_MenuCaptionEnqueuePlaylistCollection = 'Enqueue playlist "%s"';
MainForm_MenuCaptionEnqueueWebradioCollection = 'Enqueue webradio station "%s"';

MainForm_MenuCaptionsEnqueueAllPlaylist = 'Enqueue all tracks of this playlist (at the end of the playlist)';
MainForm_MenuCaptionsEnqueueAllWebradio = 'Enqueue all tracks of this webradio station (at the end of the playlist)';

MainForm_SavePlaylistAsExistingFavorite = 'Save playlist "%s"';
MainForm_SavePlaylistNotAvailable = 'Save current playlist';


MainForm_MenuCaptionsPlayAll   = 'Play (and clear current playlist)';
MainForm_MenuCaptionsEnqueueAll   = 'Enqueue (at the end of the playlist)';
MainForm_MenuCaptionsPlayNextAll  = 'Enqueue (after the current title)';
//MainForm_MenuCaptionsPlayNowAll   = 'Enqueue and play these tracks now'; // not possible any more
MainForm_MenuCaptionsSearchForVar    = 'Search for ''%s''';
MainForm_MenuCaptionsSearchForTitle  = 'Search for this title';
MainForm_MenuCaptionsSearchForArtist = 'Search for this artist';
MainForm_MenuCaptionsSearchForAlbum  = 'Search for this album';

MainForm_MenuCaptionsSearchForEmptyTitle  = 'Show all files where "Title" is missing';
MainForm_MenuCaptionsSearchForEmptyArtist = 'Show all files where "Artist" is missing';
MainForm_MenuCaptionsSearchForEmptyAlbum  = 'Show all files where "Album" is missing';

MainForm_LibraryIsEmpty = 'You music library is empty. Drop some files here to start.';
MainForm_LibraryIsLoading = 'Loading library. Please wait...';

// MainForm_MainMenu_Messages = 'Messages (%d)';
MainForm_MainMenu_NoMessages = 'Messages';
ErrorForm_NoMessages = 'No new messages, everything is fine. :)';

MainForm_Summary_FileCountSingle         = '%d file; ' ;
MainForm_Summary_SelectedFileCountSingle = '%d file selected; ';
MainForm_Summary_PlaylistCountSingle     = '%d playlist';
MainForm_Summary_WebradioCountSingle     = '%d webradio station';

MainForm_Summary_FileCountMulti         = '%d files; ' ;
MainForm_Summary_SelectedFileCountMulti = '%d files selected; ';
MainForm_Summary_FileCountTotal         = '%d files in total';
MainForm_Summary_PlaylistCountMulti     = '%d playlists';
MainForm_Summary_WebradioCountMulti     = '%d webradio stations';

MainForm_Summary_SelectedFileCueCountSingle       = '%d cue sheet track selected';
MainForm_Summary_SelectedFileCueCountMulti        = '%d files (and cue sheet tracks); ';
MainForm_Summary_SelectedFileCueCountMultiOnlyCue = '%d cue sheet tracks selected';


MainForm_Cover_NoCover   = 'No cover available';
MainForm_Lyrics_NoLyrics = 'No lyrics available';

    SplashScreen_Loading            = 'Loading';
    SplashScreen_LoadingPreferences = 'Loading preferences';
    SplashScreen_Loadingplaylist    = 'Loading playlist';
    SplashScreen_SearchSkins        = 'Searching for skins';
    SplashScreen_InitPlayer         = 'Initializing player';
    SplashScreen_LoadingMediaLib    = 'Loading media library';
    SplashScreen_GenerateWindows    = 'Generating windows';
    SplashScreen_PleaseWaitaMoment  = 'Preparing media library';
    SplashScreen_NewDriveConnected  = 'New drive connected: Collecting data.';
    SplashScreen_NewDriveConnected2 = 'Preparing media library';

// Warning_NempDidntShutDownRegular = 'Nemp didn''t shutdown tidily last time.';
// Warning_NempDidntShutDownRegular_NoBackup = 'Nemp didn''t shutdown tidily. A backup of the playlist couldn''t be found.';

MediaLibrary_Preparing  = 'Preparing media library...';
Medialibrary_Sorting    = 'Sorting data...';
MediaLibrary_AlmostDone = 'Almost done...';
// MediaLibrary_SearchingExactMatchings = 'Searching exact matchings (%d%%)';
// MediaLibrary_SearchingFuzzyMatchings = 'Searching fuzzy matchings (%d%%)';
MediaLibrary_RefreshingFiles         = 'Refreshing file information (%d%%)';
MediaLibrary_RefreshingFilesInDir    = 'Refreshing file information ... %s';
MediaLibrary_RefreshingFilesPreparingLibrary = 'Refreshing files complete. Preparing media library ...';
MediaLibrary_RefreshingFilesCompleteFinished = 'Refreshing files complete.';

MediaLibrary_ScanningFilesInDir    = 'Reading file information ... %s';
MediaLibrary_ScanningFilesCount    = 'Scanning music files for metadata ... %d/%d';
//ProgressForm_ScanNewFiles    = 'Nemp is Scanning the new music files for meta data. This may take a while.';

//MediaLibrary_SearchingMissingFiles   = 'Searching missing files (%d%%)';
MediaLibrary_SearchingMissingFilesDir= 'Searching missing files ... %s'; // %s: current Directory
MediaLibrary_SearchingMissingPlaylist= '(Playlists)'; // this will replace the %s just above, when serching for dead playlists
MediaLibrary_SearchingNewFiles       = '(%d) Searching %s';
MediaLibrary_SearchingNewFilesDir    = 'Searching for new files ... %s';
MediaLibrary_SearchingNewFilesBigLabel = 'Searching for audio files ... %d found';
MediaLibrary_StartSearchingNewFiles  = 'Searching for new files ...';
MediaLibrary_SearchingNewFilesComplete = 'Searching for new files completed. The new files have been added to your media library.';
MediaLibrary_SearchingNewFiles_NothingFound = 'Operation complete. No new files have been added to the media library.';
MediaLibrary_SearchingNewFiles_Aborted = 'Searching for new files aborted. No new files have been added to the media library.';

// MediaLibrary_PreciseQuery            = 'Please precise your query. Too many matchings found.';
MediaLibrary_SearchingMissingFilesComplete_AnalysingData = 'Search complete, preparing data ...';
MediaLibrary_SearchingMissingFilesComplete_PrepareUserInput = 'Waiting for user input ...';

DeleteSelect_FilesWillBeDeleted = 'The following files will be removed from the library when you click on "Cleanup library"';
DeleteSelect_FilesWillRemain = 'The following files will remain in the library when you click on "Cleanup library"';
DeleteSelect_DeletingFiles = 'Removing files from the media library...';
DeleteSelect_DeletingFilesAborted = 'No files have been removed from the library.';
DeleteSelect_DeletingFilesComplete = 'The selected files have been removed from the media library.';

// MediaLibrary_FilesNotFound           = 'There are %d missing files. Please select the files you want to keep or delete from the library.';
// MediaLibrary_FilesNotFoundJustHint   = 'Some of the selected files are missing. You may cleanup your library now to remove the missing files.';
// MediaLibrary_FilesNotFound           = 'There are %d missing files. You should execute the function "delete missing files" now to cleanup your library.';
// MediaLibrary_FilesNotFoundExternalDrive = 'There are %d missing files. Probably there is an external drive not connected to your computer.';

MediaLibrary_DuplicatesWarning       = 'Nemp found some duplicate entries in your media library. This is not supposed to happen, unless you just added the current playlist to the media library. - If this message appears frequently, please contact me via e-mail. Thank you!';
// MediaLibrary_SearchingLyrics         = 'Searching lyrics for %s %s';
MediaLibrary_SearchingLyrics_JustFile= 'Searching lyrics for %s';
// MediaLibrary_SearchingTags           = 'Searching tags for %s %s';
MediaLibrary_SearchingTags_JustFile  = 'Searching tags for %s';
MediaLibrary_LyricsFailed            = 'Connection to lyrics.wikia.com failed. Please check your internet configuration.';
MediaLibrary_GetTagsFailed           = 'No additional Tags found.';
MediaLibrary_SearchLyricsStats       = ' (found %d/%d)';
MediaLibrary_SearchTagsStats         = ' (found %d/%d)';

MediaLibrary_RatingComplete = 'All ratings have been successfully updated.';

MediaLibrary_PermissionToChangeTagsRequired = 'You denied quick access to metadata (e.g. ID3-Tags), to protect your files from unintented changes.'
                    +#13#10+'However, this function only works properly, if changing metadata is allowed.'
                    +#13#10
                    +#13#10+'Do you want to allow Nemp changing metadata in the selected files?';

MediaLibrary_OperationCancelled = 'Operation cancelled';
MediaLibrary_SearchLyricsComplete_SingleNotFound = 'Sorry, the lyrics for this file could not be found.';
MediaLibrary_SearchLyricsComplete_AllFound = 'Lyric search complete. All lyrics found.';
MediaLibrary_SearchLyricsComplete_ManyFound = 'Lyric search complete. %d of %d lyrics could be found.'#13#10#13#10'You can try to find some of the missing lyrics by a manual search on lyrics.wikia.com or other lyrics sites on the net.';
MediaLibrary_SearchLyricsComplete_FewFound = 'Lyric search complete. Only %d of %d lyrics could be found.'#13#10#13#10'Either the files are not properly tagged, they are instrumental only, or you have a special taste in music.'#13#10#13#10'Please note, that lyrics are not supported for some audio formats.';
MediaLibrary_SearchLyricsComplete_NoneFound = 'Lyric search complete. Sorry, but nothing could be found.'#13#10#13#10'Either the files are not properly tagged, they are instrumental only, or you have a special taste in music.'#13#10#13#10'Please note, that lyrics are not supported for some audio formats.';
MediaLibrary_SearchLyricsComplete_SomeErrors = 'Lyric search complete. Some unexpected errors appeared during the process.'#13#10#13#10'Please view the Error-Log for details.';

MediaLibrary_SearchTagsComplete_SingleNotFound = 'Sorry, for this file are no additional Tags available.';
MediaLibrary_SearchTagsComplete_AllFound = 'Tag search complete. Added some Tags for every file.';
MediaLibrary_SearchTagsComplete_ManyFound = 'Tag search complete. Found Tags for %d of %d files.';
MediaLibrary_SearchTagsComplete_FewFound = 'Tag search complete. Found Tags for only %d of %d files.'#13#10#13#10'Either the files are not properly tagged, or you have a special taste in music.'#13#10#13#10'Please note, that additional Tags are not supported for some audio formats.';
MediaLibrary_SearchTagsComplete_NoneFound = 'Tag search complete. Sorry, no additional Tags could be found.'#13#10#13#10'Either the files are not properly tagged, or you have a special taste in music.'#13#10#13#10'Please note, that additional Tags are not supported for some audio formats.';
MediaLibrary_SearchTagsComplete_SomeErrors = 'Tag search complete. Some unexpected errors appeared during the process.'#13#10#13#10'Please view the Error-Log for details.';


MediaLibrary_OperationComplete_CloseWindowNow = 'You can close this window now.';
MediaLibrary_OperationComplete_CBClose_NoTimer = 'Close window after completion';
MediaLibrary_OperationComplete_CBClose_TimerActive = 'Close window after completion (%d)';

MediaLibrary_SomeErrorsOccured = 'Some unexpected errors appeared during the process. Please view the Error-Log for details.';

MediaLibrary_CloudUpdateStatus = 'Updating ID3-Tags ... %s';
MediaLibrary_InconsistentFilesWarning = 'You have changed some tags in the library, but the mp3-files have not been updated yet.'
          +#13#10 + 'If you close Nemp now, these files remain inconsistent to the data in the library.'
          +#13#10+#13#10 + 'Do you really want to close Nemp now?';
MediaLibrary_InconsistentFilesCaption = 'Warning: %d file(s) need an update. Click here to start.';
MediaLibrary_InconsistentFiles_Completed_Success = 'All ID3-Tags have been successfully updated.';
MediaLibrary_InconsistentFiles_Completed_SomeFailed = 'Some ID3-Tags could not been updated. There are still %d files that are inconsistent to the data in the library.';
MediaLibrary_InconsistentFiles_Abort = 'Some ID3-Tags have not been updated due to user abort. There are still %d files that are inconsistent to the data in the library.';
MediaLibrary_InconsistentFiles_SomeErrors = 'ID3-Tag update complete. Some unexpected errors appeared during the process.'#13#10#13#10'Please view the Error-Log for details.';
//MediaLibrary_InconsistentFilesHintCount = 'You have changed some tags in the library, but the mp3-files have not been updated yet. Do you want to update the %d changed files now?';


MediaLibrary_Deleting                = 'Deleting from media library (%d%%)';
Medialibrary_QueryReallyDelete       = 'This will delete your complete media library. Continue?';
Medialibrary_LoadingFile             = 'Loading media library (%s)';
Medialibrary_InvalidLibFile          = 'Invalid media library-file.';
Medialibrary_LibFileTooYoung         = 'The media library was probably created by a newer version of Nemp. This version of Nemp doesn''t know how to read this file.';
Medialibrary_LibFileTooOld           = 'Media library of Nemp 2.4 or earlier detected. This is not supported any more.';
Medialibrary_OldFileHint        = 'You are loading a media library of an earlier version of Nemp. Please connect all relevant drives to your computer before you proceed. '
                                 + 'Otherwise some files will be deleted from the library.';
Medialibrary_OldFileHint2       = 'Some problems occured while converting the old library and some audiofiles were ignored. You should rebuild it by searching your harddrives for new files.';

Medialibrary_SaveException1 = 'An error occured while saving the media library. Please report this error.';
//Medialibrary_SaveException = 'Saving failed. Probably the directory is write protected or there is not enough available free space.';
Medialibrary_QuickSearchError1 = 'Tried to fill the Quicksearchlist while displaying playlists. This should never occur - please report this error. ';
Medialibrary_GUIError1 = 'This function (1) shouldn''t be accessible now. Please report this error.';
Medialibrary_GUIError2 = 'Tried to fill search history with playlist files. This should never occur - please report this error.';
Medialibrary_GUIError3 = 'The current view shows files from a playlist-file. You can not delete these files frome the library.';
Medialibrary_GUIError4 = 'This function (4) shouldn''t be accessible now. Please report this error.';
Medialibrary_GUIError5 = 'The current view shows files from a playlist-file. Getting lyrics or additional tags is not possible.';
Medialibrary_GUIError6 = 'The current view shows files from a playlist-file. Operation cancelled.';
Medialibrary_DriveRepairError = 'An Error occured while updating drivelist. Please report this error.';

Medialibrary_DialogFilter            = 'Nemp media library';
Medialibrary_AddingPlaylist          = 'Adding the playlist to the media library...';
MediaLibrary_CSVFilter               = 'CSV files';

MediaLibrary_OutOfMemoryAccelerateSearchReduced       = 'Not enough memory. The settings for the accelerated search have been reduced to a minimum.';
MediaLibrary_OutOfMemoryAccelerateSearchDisabled      = 'Not enough memory. Accelerated search has been disabled.';
MediaLibrary_OutOfMemoryAccelerateLyricSearchDisabled = 'Not enough memory. The accelerated search for lyrics has been disabled.';
MediaLibrary_OutOfMemoryBuildingStringError           = 'An error occurred while preparing the accelerated search. That was never supposed to happen.';
MediaLibrary_OutOfMemoryBuildingLyricStringError      = 'An error occurred while preparing the accelerated search for lyrics. That was never supposed to happen.';



    Playlist_QueryReallyDelete    = 'This will clear your current playlist with %d tracks and replace it with only %d new tracks. Do you really want to clear the playlist?'
                                    + #13#10#13#10 + 'Note: You can change the default action for adding files into the playlist within the settings dialog.';
    Playlist_NotEverything        = 'No. Nemp will not add *everything* to the playlist.';
    Playlist_FileNotFound         = 'The specified file can not be found. Do you want to delete it from the list?';
    Playlist_NoRecentlists        = 'empty';


Player_FilenameWebradioTooLong = 'The filename for this stream is to long and automatic abbreviation failed.' +#13#10
                                  + 'Please change the directory for webradio downloads.';
Player_NoReversePossible = 'It seems that you deleted the playing file from the playlist. Therefore this function cannot be executed.';

Player_UnkownArtist = '(Unknown Artist)';
Player_NoTitleLoaded = 'Nothing to play ... drop a music file here to start';
//Player_NoTitleLoadedDropHereToStart = 'Drop an audiofile here to start playback';

AudioFileProperty_Webstream   = 'Webstream';
AudioFileProperty_Name        = 'Name';
AudioFileProperty_URL         = 'URL';
AudioFileProperty_Artist      = 'Artist';
AudioFileProperty_Title       = 'Title';
AudioFileProperty_Album       = 'Album';
AudioFileProperty_Duration    = 'Duration';
AudioFileProperty_Bitrate     = 'Bitrate';
AudioFileProperty_Filesize    = 'Filesize';
AudioFileProperty_Directory   = 'Directory';
AudioFileProperty_Filename    = 'Filename';
AudioFileProperty_CbrVbr      = 'cbr/vbr';
AudioFileProperty_ChannelMode = 'Channelmode';
AudioFileProperty_Samplerate  = 'Samplerate';
AudioFileProperty_Comment     = 'Comment';
AudioFileProperty_Path        = 'Path';
AudioFileProperty_Year        = 'Year';
AudioFileProperty_Genre       = 'Genre';
AudioFileProperty_Lyrics      = 'Lyrics';
AudioFileProperty_Track       = 'Track';
//Audiofile_PlayCounterHint     = 'Played %d times';
//Audiofile_RatingHintNoRating  = 'Rating: N/A';


ReplayGain_CalculateSingleTracks = 'Calculating ReplayGain values (TrackGain only) for %d files ...';
ReplayGain_CalculateSingleAlbum  = 'Calculating ReplayGain values (with AlbumGain) for %d files ...';
ReplayGain_UnknownAlbum = '<Unknown Album>';
ReplayGain_CalculateMultipleAlbums = 'Calculating ReplayGain values for album "%s" with %d files ...';
ReplayGain_StartSynchronizing = 'Calculating complete, synchronizing %d files ...';
ReplayGain_RemoveFromFiles = 'Removing ReplayGain values from %d files ...';
ReplayGain_Complete = 'ReplayGain calculation complete' ;
ReplayGain_Abort = 'ReplayGain calculation aborted by user' ;
ReplayGain_AlbumComplete = 'Calculation AlbumGain complete.';
ReplayGain_ScanningFile = 'Scanning file "%s"' ;
ReplayGain_UnexpectedError = 'Some unexpected Error occured (Errorcode: %d)';
ReplayGain_ErrorTooManyChannels        = 'Error: Too many channels (%s)' ;
ReplayGain_ErrorAlbumGainFreqChanged   = 'Warning: AlbumGain calculation cancelled (%s)';
ReplayGain_ErrorInitGainAnalysisError  = 'Error: Failed initializing ReplayGain calculation (%s)';
ReplayGain_TrackSummary = 'Track %d: %6.2f dB, Peak %6.6f (%s)';
ReplayGain_AlbumSummary = 'AlbumGain: %6.2f dB, Peak %6.6f';

Progressform_ReplayGain = 'Nemp is calculating ReplayGain values right now. This may take a while.';
Progressform_ReplayGain_Complete = 'Calculation of ReplayGain complete. The values have been written to the metadata of the files.';
Progressform_ReplayGain_Cancelled = 'Calculation of ReplayGain aborted. Some values may have been already written to the metadata of the files.';

Progressform_ReplayGain_AlreadyRunning = 'ReplayGain calculation is already running. Please wait until the current calculation is finished.';


    AutoScanDirsDialog_Caption = 'Confirmation';
    AutoScanDirsDialog_Text    = 'Do you want Nemp to monitor this directoy?' +#13#10 + #13#10
                                 + 'Nemp will scan this directory for new files on startup. You can edit the monitored directorys within the preferences.';

    AutoScanDirsDialog_ShowAgain = 'Save selection and do not show this dialog again.';

Shoutcast_Error_ConnectionFailed = 'Connection failed. Please check your internet configuration.';
Shoutcast_Error_DownloadFailed = 'Download failed. If the stream is available in other players, disable the parsing of the playlist in the settings dialog and try again.';
Shoutcast_Connecting = 'Connecting to shoutcast.com ...';
Shoutcast_Connecting_MainForm = 'Connecting...';
Shoutcast_Downloading = 'Downloading stationlist...';
Shoutcast_ParsingXMLData = 'Download complete. Parsing XML-Data...';
Shoutcast_DownloadingPlaylist = 'Downloading playlist...';
Shoutcast_DownloadComplete = 'Download complete.';
Shoutcast_OK     = 'OK';
Shoutcast_Cancel = 'Cancel';
Shoutcast_MainForm_BibError = 'Cannot find station data. This should not happen.';
Shoutcast_UnknownFormat = 'Unknown format';

Shoutcast_InputStreamCaption = 'Nemp: Play Webstream';
Shoutcast_InputStreamLabel   = 'URL (e.g. "http://myhits.com/tune_in.pls" or "http://123.12.34.56:5000")';

TabBtnBrowse_OriginalHint = 'Browse your media library through a tree view';
TabBtnCoverFlow_OriginalHint = 'Browse your media library through a coverflow';
TabBtnTagCloud_OriginalHint = 'Browse your media library through a tag cloud';
TabBtnBrowse_RepairHint = 'Some files have been edited.';
TabBtnBrowse_DirtySearch = '- The search function may not find all titles.';
TabBtnBrowse_DirtyCollections = '- The grouping of titles by artist/album/tags/... may not be up to date.';
TabBtnBrowse_RepairHint2 = 'Click to resolve these inconsistencies.';


// TabBtnBrowse_Hint1 = 'Browse your media library';
// TabBtnBrowse_Hint2 = 'Click to resort';
// TabBtnTagCloud_Hint1 = 'Tag cloud';
// TabBtnTagCloud_Hint2 = 'Click to rebuild';

//TagEditor_RenameTag_Caption = 'Rename Tag';
//TagEditor_RenameTag_Prompt = 'Enter a new name for the tag. If it already exists, the two tags are merged.';

TagEditor_RenameTagQueryLabel = 'Rename the selected tags to:';
TagEditor_SelectTagRenameHint = 'Please select the tag you want to rename in the list.';
TagEditor_SelectTagRemoveHint = 'Please select the tag you want to ignore in the list.';

TagEditor_LabelExplainTagList = 'A list of all tags in the media library. Changes will affect each audio file, which is marked with the selected tags. '
            + #13#10 + #13#10 + 'Adding "Rename" and "Ignore" rules will rename (remove) these tags in all files of the media library and prevent adding these tags later. ';
TagEditor_LabelExplainRenameList = 'A list of all "Rename rules". '
+ #13#10 + #13#10 + 'When you try to add one of these tags to an audio file (manually or automatically from last.fm), it is automatically replaced. This is done to avoid multiple similar tags with the same actual meaning.'
+ #13#10 + #13#10 + 'You can remove some of these rules here. To add a new one, use the buttons on the first page of this window.';

TagEditor_LabelExplainIgnoreList = 'A list of all "Ignore rules". '
+ #13#10 + #13#10 + 'When you try to add one of these tags to an audio file (manually or automatically from last.fm), it is automatically ignored. This is done to avoid tags with actual no meaning.'
+ #13#10 + #13#10 + 'You can remove some of these rules here. To add a new one, use the buttons on the first page of this window.';


//TagEditor_Merge_Caption = 'Merge Tags';
//TagEditor_Merge_Prompt = 'Enter a new common name for the selected tags. If it already exists, the tags are merged with this one.';

TagEditor_Delete_Query = 'This will remove the selected tags from all files in the media library.'
  +#13#10 + #13#10 + 'Do you want to continue?';

TagEditor_AddIgnoreRule_Query = 'This will add an "Ignore rule" for the selected tags and remove them from all files in the media library.'
  +#13#10 + #13#10 + 'Do you want to continue?';


TagEditor_FilesNeedUpdate = 'The ID3-Tags of %d files should be updated.';

TagEditor_FilesUpdateComplete = 'All ID3-Tags have been updated.';

Tags_AddTags = 'No additional Tags set. Click here to add some.';
Tags_NoTagsAccessDenied = 'No additional Tags set.';
//Tags_AddTagsNotPossible = 'No additional Tags set. (Only available for *.mp3, *.ogg and *.flac-files.)';
Tags_CommasFound = 'It looks like you entered a comma-separated list of tags. However, tags should be entered line by line here. Do you want Nemp to treat your input as a comma-separated list?';

MenuItem_Partymode = 'Activate Party-Mode';
MenuItem_PartymodeExit = 'Exit Party-Mode';

MenuItem_Activate = 'Activate';
MenuItem_Deactivate = 'Deactivate';

ParrtyMode_WrongPassword = 'Invalid password. Try again if you should know it. Or go back to the party and have some fun.';
ParrtyMode_Password_Caption = 'Nemp Party-Mode';
ParrtyMode_Password_Prompt = 'Please enter the password to exit the Nemp Party-Mode';
ParrtyMode_Password_PromptOnActivate = 'Note: The password to exit the Nemp Party-Mode is "%s".';
ParrtyMode_ActivationHint =
'This will activate the Nemp Party-Mode. In this mode, some features are disabled to prevent'+#13#10+
'unwanted changes to the playlist and media library.'  + #13#10 +
'However, if you don''t trust your party guests, you might want to lock the computer completely'+#13#10+
'and use the Nemp web server for remote control.';

HeadSetLabel_Default1 = 'Headphones (no title loaded)';
HeadSetLabel_Default2 = '(no title loaded)';

PlayerBtn_Pause = 'Pause';
PlayerBtn_Play = 'Play';

CopyToUSB_Copy = 'Copy files';
CopyToUSB_Abort = 'Abort';
CopyToUSB_FileProgress = 'Copying file %s';
CopyToUSB_Complete = 'Completed';
CopyToUSB_Aborted = 'Aborted by user';
CopyToUSB_Idle = 'Idle';
CopyToUSB_AbortQuery = 'Copying in progress. Do you want to cancel the copy process?';
CopyToUSB_SavingPlaylistFailed = 'Could not save the playlist: %s';
CopyToUSB_ChooseDestination = 'You have to choose a destination directory where the playlist should be copied to.';
CopyToUSB_DestinationDirDoesNotexist = 'The destination directory does not exist. Do you want to create it?';
CopyToUSB_DestinationDirCreateFailed = 'The specified destination directory could not be created. Please verify that the directory name is valid.';


CopyToUSB_ERROR_UNKOWN = 'Copying file failed for an unknown reason (Errorcode: %d). Choose OK to continue with next file, or cancel the copying process.';

CopyToUSB_ERROR_FILE_NOT_FOUND = 'The current file can not be found. Choose OK to continue with next file, or cancel the copying process.';
CopyToUSB_ERROR_PATH_NOT_FOUND = 'The destination path can not be found. Choose OK to continue with next file, or cancel the copying process.';
CopyToUSB_ERROR_TOO_MANY_OPEN_FILES = 'Too many open files. Choose OK to continue with next file, or cancel the copying process.';
CopyToUSB_ERROR_ACCESS_DENIED = 'Access denied. Choose OK to continue with next file, or cancel the copying process.';
CopyToUSB_ERROR_NOT_ENOUGH_MEMORY  = 'Not enough memory. Choose OK to continue with next file, or cancel the copying process.';

WizardCancel = 'You cancelled the Nemp Wizard. Some features may be disabled.';

Wizard_NewSkin = 'Nemp 4.6 comes with a new default skin. Do you want to use the new one?';

StartG15ToolQuestion = 'If you have a Logitech G15 keyboard, Nemp can display the current title (and some other stuff) on it.'
                      +#13#10+#13#10
                      +'It is possible to use other apps for other keyboards. However, I only own a G15, so I can test only this one.'
                      +#13#10
                      +'If you want to create an app for your keyboard, feel free to contact me.'
                      +#13#10+#13#10
                      +'So, do you want to start the G15 App now?';
StartG15AppNotFound = 'The app for the keyboard display could not be found';

CDDA_NoDrivesFound = 'No CD drives found.';
CDDA_NoHeadsetPossible = 'Nemp is currently playing a track from this CD. Playing another one at the same time is not possible.';

//DeleteHelper_DrivePresent   = 'The drive is available, but some files are not.' + #13#10 + #13#10 + 'Recommendation: Remove the missing files from the library.';
//DeleteHelper_DriveMissing   = 'The drive is missing. Probably the external drive is not connected at the moment.' + #13#10 + #13#10 + 'Recommendation: Keep the files in the library and connect the drive to your PC.';
//DeleteHelper_NetworkPresent = 'The network ressource seems to be available, but some files can''t be found.' + #13#10 + #13#10 + 'Recommendation: Remove the missing files from the library.';
//DeleteHelper_NetworkMissing = 'None of the files on this network ressource can be found - it may be not available at the moment.' + #13#10 + #13#10 + 'Recommendation: Keep the files in the library and check your network settings.';

DeleteHelper_DrivePresent   = 'The drive is available.';
DeleteHelper_DriveMissing   = 'The drive is NOT available.';
DeleteHelper_NetworkPresent = 'The network ressource is available.';
DeleteHelper_NetworkMissing = 'The network ressource seems to be offline.';

DeleteHelper_DrivePresentFileMissing  = 'Some files are definitely missing.';
//DeleteHelper_DriveMissingFileMissing  = 'It is unknown whether the files still exist.';


DeleteHelper_DoWithDrivePresent   = 'You should remove the missing files from the library.';
DeleteHelper_DoWithDriveMissing   = 'You should keep files in the library, connect the drive to your computer and try again later.';
DeleteHelper_DoWithNetworkPresent = 'You should remove the missing files from the library.';
DeleteHelper_DoWithNetworkMissing = 'You should keep the files in the library, check your network settings and try again later.';

DeleteHelper_Readme = 'Sometimes it is not appropriate to remove every missing file from the library. '
    + 'E.g.: If you store large parts of your music files on an external harddrive which is currently not connected to your PC.'
    + #13#10 + #13#10
    + 'In this dialog you can choose what to do with the missing files on the specified drives.' + #13#10
    + 'Missing files from the checked drives will be removed from the library, the others will not be removed.'
    ;

DeleteHelper_Explanation = 'Nemp has detected several files in your library that are currently missing.'
              +#13#10#13#10
              +'Please choose which files you want to remove from the media library (check the corresponding drive) and which files you want to keep in your media library (uncheck the corresponding drive).';

AutoDeleteInfo_DeletedFiles   = 'Nemp detected %d missing file(s) and %d missing playlist(s) and removed these entries from the media library.';
AutoDeleteInfo_PreservedFiles = 'Nemp detected %d file(s) and %d playlist(s) on %d missing drive(s). These entries will remain in the media library until further notice.';
AutoDeleteInfo_MessageHint = 'Note: You can turn off this message in the settings dialog -> File management.';

Hint_BatteryLow = 'Low battery (%d%%). Click for more information.';

Playlist_LogAborted = 'aborted';

Warning_LyricsUsage = 'Ignoring lyrics will remove all collected lyrics from the media library, but they will remain'
            +#13#10 + 'in the ID3-Tags. Once the lyrics have been removed from the library, they can no longer be'
            +#13#10 + 'used by the search function unless you rescan the files in your library.'
         +#13#10+#13#10 + 'Currently there are %d files with lyrics stored in the library (out of %d total files), using '
         +#13#10 + 'approximately %s of memory.'
         +#13#10 + #13#10 + 'Do you want to continue and remove all lyrics from you media library?';

//MediaLibrarySize_Summary = 'Estimated library size: %s';

Options_LyricPriority_LYRICWIKI   = 'LyricWiki (recommended)';
Options_LyricPriority_CHARTLYRICS = 'ChartLyrics (beta)';
Hint_LyricPriorities              = 'Search online for lyrics. Current settings: '+ #13#10 + '%s';

ProgressForm_DefaultHint = 'Some functions are disabled during this process. You can cancel the current operation at any time.';
ProgressForm_DefaultAction  = 'Nemp is updating your media library right now.';
ProgressForm_SearchFiles    = 'Nemp is searching your computer for new music files.';
ProgressForm_SearchFilesPlaylist = 'Nemp is searching your computer for new files to add to your playlist.';
ProgressForm_RefreshFiles   = 'Nemp is refreshing your media library.';
ProgressForm_CleanUp        = 'Nemp is searching for missing files in your media library. ';
ProgressForm_Searchlyrics   = 'Nemp is searching for lyrics for your music files.';
ProgressForm_SearchTags     = 'Nemp is searching for some additional tags for your music files.';
ProgressForm_UpdateMetaData = 'Nemp is updating the meta data (ID3tags) of your music files.';
ProgressForm_DeleteFiles    = 'Nemp is removing the selected files from your media library.';
ProgressForm_ScanNewFiles    = 'Nemp is scanning the new music files for metadata. This may take a while.';

ProgressForm_WorkingCaption = 'Nemp: Work in progress ...';
ProgressForm_CompleteCaption = 'Nemp: Process completed.';


Playlist_StartSearchingFiles  = 'Searching for music files ...';
Playlist_SearchingNewFilesDir    = 'Searching for music files ... %s';
Playlist_SearchingNewFilesComplete = 'Searching for music files completed. The new files have been added to your playlist.';

HTTP_Connection_Error = 'Error connecting %s: %s';

FormBuilder_SeparateWindowWarning = 'The form layout cannot be applied in separate window mode.';


PlaylistManagerAutoSave_Caption = 'Confirmation';
PlaylistManagerAutoSave_Text    = 'The current playlist "%s" has been changed since it has been saved.' +#13#10 + #13#10
                                 + 'Do you want to save it now?';

PlaylistManagerAutoSave_ShowAgain = 'Save selection and do not show this dialog again.';

PlaylistManager_ReloadPlaylist = 'The current playlist "%s" has been changed since it has been saved. ' +#13#10 + #13#10
                                 + 'Do you want to reload it and go back to the previously saved version?';

//PlaylistManager_SwitchToDefaultPlaylist = 'The current playlist "%s" has been changed since it has been saved. ' +#13#10 + #13#10
//                                 + 'Do you want to save it now and switch to the default playlist?';

PlaylistManager_PlaylistNoFound = 'The playlist file could not be found.';

PlaylistManager_DeleteFavorite = 'This will delete the playlist "%s" from your favorites. This cannot be undone.' +#13#10 + #13#10
                                + 'Are you sure you want to delete the list?';

PlaylistManager_FileExists = 'Check: Fail. Filename already exists';
PlaylistManager_NameExists = 'Check: Fail. Description already exists';
PlaylistManager_EmptyFilename = 'Check: Fail: Empty or invalid filename';
PlaylistManager_Duplicate  = 'Check: Fail. Duplicate description and filename';
PlaylistManager_CheckOK    = 'Check: Ok';
Playlist_Saved             = 'Playlist saved.';
PlaylistManager_Saved      = 'Playlist saved: "%s"';

PlaylistAutoDelay = 'A little break before the next track starts.' + #13#10#13#10 + 'You can change this behavior in the player settings.';

PlaylistDuplicates_NoDuplicatesFound = 'No duplicates found in the playlist.';
PlaylistDuplicates_NoFileSelected = 'No file selected';
PlaylistDuplicates_BetweenTracksCaption = 'Between these tracks:';
PlaylistDuplicates_NoDuplicateInformation = 'No duplicate information available';

PlaylistDuplicates_WarningArtistTitle = 'Same artist and title';
PlaylistDuplicates_WarningFilename = 'Same filename (but different directories)';
PlaylistDuplicates_WarningPath = 'Same file';

PlaylistDuplicates_TracksBetween  = '%d tracks';
PlaylistDuplicates_TracksBetweenZero = 'Direct repetition - no pause in between';
//PlaylistDuplicates_TrackBeforeOriginal = 'The selected duplicate comes %d tracks before the original track.';
PlaylistDuplicates_TimeBetween = '%s play time';
PlaylistDuplicates_TimeBetweenStream = 'At least %s play time (+ webstream)';
PlaylistDuplicates_TimeBetweenOnlyStream = 'Unknown play time (only webstream)';
PlaylistDuplicates_PositionInPlaylist = 'Position in playlist: %d';

LibraryOrganizer_NoMoreCategoriesPossible =
  'There is a limit of 32 categories, and currently all available slots are used. '
  + #13#10+#13#10
  + 'If you want to reuse one of the category slots you have just deleted, you need to apply the current settings first. After Nemp has rebuilt the Media Library, there should be a category slot available again.';
  // Note that the category-system is not intended for tagging your music files.

DragDropCategoryMove = 'Move to category %1';
DragDropCategoryCopy = 'Copy to category %1';
DragDropLibrary = 'Add to Media Library';
DragDropHintTargetPlaylistOrCategory = 'Drop the files into the Playlist or another Category.';
DragDropHintTargetPlaylist = 'Drop the files into the Playlist.';
DragDropLibraryInternFailCategory = 'You can''t add files into this category';

DragDropLibraryCategory = 'Add to Media Library, category %1';
DragDropPlaylistAdd = 'Add to Playlist here';
DragDropPlaylistMove = 'Move here';
DragDropPlaylistCopy = 'Copy here';
DragDropPlayerMain = 'Play Now';
DragDropPlayerHeadset = 'Play in Headset';

ChangeCategoryForm_CurrentCategory = 'Current category: "%s"';
ChangeCategoryForm_MoreFiles = '... and %d more';
ChangeCategoryForm_AffectedFiles = 'Affected files: %d';

implementation

end.
