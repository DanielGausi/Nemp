{

    Unit Nemp_RessourceStrings

    - Strings used in Nemp.
      They are translated by GnuGetText

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
    or a modified version of these libraries, the licensors of this Program
    grant you additional permission to convey the resulting work.

    ---------------------------------------------------------------
}
Unit Nemp_RessourceStrings;

interface

Resourcestring

//TreeEntry_All = '<All>';

// Optionen-Baum
OptionsTree_Filetypes = 'Filetypes (Windows Registry)';
OptionsTree_Controls = 'Controls';
OptionsTree_Taskbar = 'Taskbar';
OptionsTree_ListsAndColumns = 'Lists and Columns';
OptionsTree_PlayerSettings = 'Player settings';
OptionsTree_Playlist = 'Playlist';
OptionsTree_LastFM = 'LastFM (scrobble)';
OptionsTree_Extended = 'Extended settings';

                                               
TreeHeader_Artists = 'Artists';
TreeHeader_Albums= 'Albums';
TreeHeader_Directories = 'Directories';
TreeHeader_Genres = 'Genres';
TreeHeader_Years = 'Years';
TreeHeader_Titles = 'Titles';
TreeHeader_Playlists = 'Playlists';
TreeHeader_Webradio = 'Webradio';

Time_HoursLong = 'hours';
Time_DaysLong = 'days';
Time_SecShort = 's';
Time_MinuteShort = 'm';
Time_HourShort = 'h';

// Detail-Form
DetailForm_Caption = 'File properties';
DetailForm_InfoLblWebStream = 'URL';
DetailForm_InfoLblDescription = 'Description';
DetailForm_InfoLblHint     = 'Hint:';
DetailForm_InfoLblHinttext = 'Some information could be obsolete or wrong.';

DetailForm_InfoLblPath     = 'Path';
DetailForm_InfoLblFilename = 'Filename';
DetailForm_InfoLblFileSize = 'Filesize';
DetailForm_ID3v2Info = '%d Bytes (%d used)';

Warning_FileNotFound = 'File not found';
Warning_FileNotFound_Hint = 'The specified file can not be found. Maybe it is on an external drive which is not connected.';
Warning_Coverbox_NoCover = 'No coverfile found';
Error_CoverInvalid = 'The file cannot be displayed. The most common reason for this is an improper filename-extension (e.g. ".gif", but the file is actually a JPEG-file).';

Warning_ReadError = 'Read error';
Warning_ReadError_Hint = 'The file could not be opened to get information. The file is maybe in use by another program.';

Warning_InvalidMp3file = 'Invalid mp3-file';
Warning_InvalidMp3file_Hint = 'The specified file with the extension ".mp3" is not a valid mp3-file.';


Warning_DownloadDirNotFound   = 'The download directory could not be found.';
Warning_RecordingDirNotFound  = 'The recording directory for webstreams could not be found.';
Warning_DataDirNotFound       = 'The data directory could not be found.';

Bitrate_Constant = 'Constant bitrate';
Bitrate_Variable = 'Variable bitrate';

Warning_MedienBibIsBusy = 'The operation could not be processed, because the medialibrary is busy. Please try again later or cancel the running operation by pressing ESC.';
Warning_MedienBibIsBusy_Options
           = 'Some settings could not be changed, because the medialibrary is busy. Please try again later or cancel the running operation by pressing ESC.';

Warning_MedienBibIsBusyRating = 'The medialibrary is busy at the moment, so your rating could not be set there. (If the current file is not in your library at all, you can ignore this message.)';
Warning_MedienBibIsBusyEdit = 'The medialibrary is busy at the moment, so your input could not be saved. Please try again in a few seconds.';
Warning_MedienBibBusyThread = 'The library blocked this very file by an automated background-process right now. Please try again in a few seconds.'  + #13#10
                 + 'Note: The probability for this message is almost zero (unless Gausi made some bad mistakes). You should play Lotto this week!';

MedienBib_ConfirmResetRatings = 'This will reset the rating of all files in the library. Ratings within the ID3-tags will not be changed. Continue?';           

Warning_TooManyFiles = 'Operation cancelled: Too many files for drag&&drop and copy&&paste respectively.'
                      + #13#10 +
                      'You can use the pop-up menu to put all these files into the playlist or just select fewer files.'
                      ;

Error_ID3OnlyInMp3Files = 'ID3-tags can only be written to mp3-files.';
//Error_EvilLyricsNotFound1 = 'This function needs another program called "EvilLyrics". Start this program and try again.';
//Error_EvilLyricsNotFound2 = 'This program can easily be found on freeware-sites in the internet.';
//Error_EvilLyricsIncompatible = 'If you started this program already, your version is maybe incompatible to Nemp.';
//Error_EvilLyricsIncompatible2 = 'Your version of EvilLyrics is incompatible to Nemp.';
//EvilLyrics_ManualHint = 'If you found proper lyrics, copy it to this window and click "save".';

LyricsSearch_NotFoundMessage = 'No lyrics found. Do you want to search them manually?';

//ErrorSavingPlaylist = 'An error occured while saving the playlist. This should not happen.';
//ErrorSavingMediaLib = 'An error occured while saving the medialibrary. This should not happen.';
ErrorLoadingMediaLib = 'An error occured while loading the medialibrary. This should not happen.';

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
CoverFlowText_NoCover           = 'Albums without cover';
CoverFlowText_AllArtists        = 'All artists';
CoverFlowText_WholeLibrary      = 'Your media-library';

    Warning_No_PNG = 'PNG-Images are not supported.';

MediaKeys_Status_Standard = 'Windows standard';
MediaKeys_Status_Hook     = 'Mediakeys are hooked by Nemp';

FloatingPointChannels_On = 'Current status: On';
FloatingPointChannels_Off = 'Current status: Off';

// in den Optionen gibts ne Kopie hiervon, die zum initialien Füllen der Bäume benutzt wird!
// Ne, nicht mehr. oder war das nötig???
    //OptionsTree_SystemMediaKeys  = 'Media keys';
    //OptionsTree_SystemOther      = 'Shutdown';
    //OptionsTree_ViewFontColor    = 'Font color';
    //OptionsTree_ViewFontsize     = 'Font size';
    //OptionsTree_ViewSkins        = 'Skins';
    //OptionsTree_AudioMain        = 'Audio options';
    //OptionsTree_AudioDevices     = 'Devices';
    //OptionsTree_AudioPlayer      = 'Player';
    //OptionsTree_PlayerMedialibrary = 'Media library';
    //OptionsTree_PlayerWebradio    = 'Webstreams';
    //OptionsTree_PlayerEffects     = 'Effects';
    //OptionsTree_PlayerEvents      = 'Events';
    //OptionsTree_MediabibList         = 'Media list';
    //OptionsTree_MediabibDirectories  = 'Directories';
    //OptionsTree_MediabibView         = 'View';
    //OptionsTree_AudioJingles     = 'Jingles';
    //OptionsTree_SystemMain       = 'System';

    OptionsTree_SystemGeneral     = 'General options';
    OptionsTree_SystemFiletyps    = 'File types registration';
    OptionsTree_SystemControl     = 'Controls';
    OptionsTree_SystemTaskbar     = 'Taskbar and tray';

    OptionsTree_ViewMain          = 'Viewing options';
    OptionsTree_ViewPlayer        = 'Player and Cover';
    OptionsTree_ViewView          = 'View';
    OptionsTree_ViewFonts         = 'Fonts';
    OptionsTree_PartyMode         = 'PartyMode';

    OptionsTree_PlayerMain        = 'Player settings';
    OptionsTree_PlayerPlaylist    = 'Playlist';
    OptionsTree_AudioPlaylist     = 'Playlist';
    OptionsTree_PlayerMedialibrary= 'Media library';
    OptionsTree_PlayerAutomaticRating = 'Automatic rating';
    OptionsTree_PlayerWebradio    = 'Webstreams';
    OptionsTree_PlayerEffects     = 'Effects';
    OptionsTree_PlayerEvents      = 'Events';
    OptionsTree_PlayerScrobbler   = 'LastFM (scrobble)';
    OptionsTree_PlayerWebServer   = 'WebServer';

    OptionsTree_ExtendedMain      = 'Extended settings';
    OptionsTree_MediabibSearch    = 'Search options';
    OptionsTree_MediabibUnicode   = 'Unicode';

    Warning_NoSkinFound = 'No skins found';
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

    Scrobble_Active = 'Scrobble Log (Status: Sending data...)';
    Scrobble_InActive = 'Scrobble Log (Status: Idle)';
    Scrobble_Offline = 'Scrobble Log (Status: Offline)';

    ScrobbleFailureWait = 'Something is wrong with scrobbling. See the log-entries within the settings-dialog for details.';

    ScrobbleSettings_Incomplete = 'Settings for Scrobbling are incomplete. Do you want to configure it now?';
    


SelectDirectoryDialog_Caption = 'Select directory';
SelectDirectoryDialog_Webradio_Caption = 'Select download directory for webstreams';
SelectDirectoryDialog_RemoteNemp = 'Select download directory';

AutoScanDir_AlreadyExists = 'The selected directory (or a parent directory) is already in the list.';
AutoSacnDir_SubDirExisted = 'A subdirectory of the selected directory was removed from the list: ';

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

RemoteNemp_NempServerFound  = 'Nemp server found at %s.';
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

WebServer_StatusOnline     = 'Status: Online';
WebServer_StatusOffline    = 'Status: Offline';
WebServer_ActivateServer   = 'Activate server';
WebServer_DeActivateServer = 'Deactivate server';
// WebServer_GetIPFailes      = 'Cannot get IP-address. Please check your internet configuration.';
WebServer_GetIPFailedShort = 'Failed.';
WebServer_GettingIP        = 'Connecting...';

NempUpdate_ConnectError = 'Could not connect to server. Please check your internet configuration.';
NempUpdate_Error = 'Could not get update information from server.';
NempUpdate_UnkownError = 'An error occured while getting update information from server.';
NempUpdate_CurrentVersion = 'You are using the newest version of Nemp.';
NempUpdate_VersionError = 'Unable to extract version information from server.';
NempUpdate_NewerVersion = 'A newer Version of Nemp is available. Do you want to download it now?';

NempUpdate_TestVersionAvailable = 'You are using the newest stable version of Nemp, but there is a new unstable version available.' + #13#10 + 'Do you want to download and test it now?';
NempUpdate_NewerTestVersionAvailable = 'Thank you for beta-testing Nemp. There is a newer test-version of Nemp available.' + #13#10 + 'Do you want to download and test it now?';
NempUpdate_CurrentTestVersion = 'Thank you for beta-testing Nemp. You are using the newest version.';
NempUpdate_PrivateVersion = 'It seems that you are using an experimental version of Nemp. Thank you for testing it.';

NempUpdate_InfoYourVersion = 'Your version: %s';
NempUpdate_InfoNewestVersion = 'Newest version: %s';
NempUpdate_InfoLastRelease = 'Latest release: %s (%s)';
NempUpdate_InfoLastStableRelease = 'Latest stable release: %s';
NempUpdate_InfoNote = 'Note: %s';
NempUpdate_InfoFirstStart = 'It seems that you are using Nemp (or this version) for the first time. Nemp will now search for a newer version (even if it is probably up-to-date)' +#13#10 +
                            'to show you this function. After this Nemp will search once a week for an update without showing this message.'
                            + #13#10#13#10 +
                            'No personal information will be sent. You can deactivate this function within the preferences (and change the interval), or right now by clicking "Cancel".';

  NempShutDown_StopNemp  = 'Nemp will stop now.';
  NempShutDown_CloseNemp = 'Nemp will close now.';
  NempShutdown_Suspend   = 'Windows will suspend now. When you switch on your computer, the current session will be restored.';
  NempShutDown_Hibernate = 'Windows will hibernate now. When you switch on your computer, the current session will be restored.';
  NempShutDown_ShutDown  = 'Windows will shutdown now. Unsaved data could be lost.';
  NempShutDown_CountDownLbl = 'ShutDown in %d seconds';

  // NempShutDown_StopHint_AtEndOfPlaylist      = 'Nemp will stop in %s.'; // Not needed!
  NempShutDown_CloseHint_AtEndOfPlaylist     = 'Nemp will close at the end of the playlist.';
  NempShutDown_SuspendHint_AtEndOfPlaylist   = 'Windows will suspend at the end of the playlist.';
  NempShutDown_HibernateHint_AtEndOfPlaylist = 'Windows will hibernate at the end of the playlist.';
  NempShutDown_ShutDownHint_AtEndOfPlaylist  = 'Windows will shutdown at the end of the playlist.';
  NempShutDown_AtEndOfPlaylist_Hint = 'Note that this only makes sense with mode "Repeat off" and no webstreams in the playlist.';


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

  NempShutDown_StopPopupTime       = 'Stop Nemp (~%s)';
  NempShutDown_ClosePopupTime      = 'Close Nemp (~%s)';
  NempShutDown_SuspendPopupTime    = 'Suspend Windows (~%s)';
  NempShutDown_HibernatePopupTime  = 'Hibernate Windows (~%s)';
  NempShutDown_ShutDownPopupTime   = 'Shutdown Windows (~%s)';

  //NempShutDown_StopPopupTime_AtEndOfPlaylist       = 'Stop Nemp (after the last file)'; // Not needed!
  NempShutDown_ClosePopupTime_AtEndOfPlaylist      = 'Close Nemp (after the last file)';
  NempShutDown_SuspendPopupTime_AtEndOfPlaylist    = 'Suspend Windows (after the last file)';
  NempShutDown_HibernatePopupTime_AtEndOfPlaylist  = 'Hibernate Windows (after the last file)';
  NempShutDown_ShutDownPopupTime_AtEndOfPlaylist   = 'Shutdown Windows (after the last file)';


  BirthdayCountDown_Caption = 'Birthday in %s';
  BirthdayCountDown_Hint    = 'In %s the current playlist will be interrupted for a little birthday song.';
  BirthdaySettings_Incomplete = 'Settings for birthday mode are incomplete. Edit them now?';

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
MainForm_LocalQuickSearch     = 'Quicksearch (current list)';
MainForm_MoreSearchresults  = 'Additional results (not limited to current preselection)';

MainForm_BtnEqualizerPresetsSelect = 'Select';
MainForm_BtnEqualizerPresetsCustom = 'Custom';
MainForm_BtnEqualizerSaveNewButton = 'New ...';
MainForm_BtnEqualizerSaveNewCaption = 'Name for the new preset';
MainForm_BtnEqualizerSaveNewPrompt = 'Please insert a name for the new preset.';

MainForm_BtnEqualizerDeleteQuery = 'This will delete the preset "%s". Continue?';
MainForm_BtnEqualizerOverwriteQuery = 'This will overwrite the preset "%s" with the current settings. Continue?';
Player_RestoreDefaultEqualizer = 'This will delete your personal settings for the default presets (e.g. "Full Bass" or "Reggae"). Other presets ("New preset") are not affected.';
MainForm_EqualizerInvalidInput = 'Invalid input. Only chars (a..z), numbers (0..9) and space ( ) are allowed. Please choose another name.';


MainForm_RepeatBtnHint_RepeatAll   = 'Repeat all';
MainForm_RepeatBtnHint_RepeatTitle = 'Repeat title';
MainForm_RepeatBtnHint_RandomMode  = 'Random mode';
MainForm_RepeatBtnHint_NoRepeat    = 'Repeat off';
MainForm_RecordBtnHint_Start       = 'Start recording';
MainForm_RecordBtnHint_Recording   = 'Recording...';

MainForm_StopBtn_NormalHint = 'Stop';
MainForm_StopBtn_StopAfterTitleHint = 'Nemp will stop playback after current title.';
MainForm_StopMenu_StopAfterTitle = 'Stop after title';
MainForm_StopMenu_NoStopAfterTitle = 'Do not stop after title';



MainForm_ReverseBtnHint_PlayNormal  = 'Play forwards';
MainForm_ReverseBtnHint_PlayReverse = 'Play backwards';

MainForm_ShuttingDownHint          = 'Shutting down...';
MainForm_ShuttingDownHint_MediaLib = 'Saving medialibrary...';

MainForm_NoSearchKeywords  = 'No search phrase';
SearchForm_CBAddRefineSearch = '(refined search)';
SearchForm_CBAddExtendSearch = '(extended search)';

MainForm_MenuCaptionsPlay      = 'Play (and clear current playlist)';
MainForm_MenuCaptionsEnqueue   = 'Enqueue';
MainForm_MenuCaptionsPlayNext  = 'Play next';
MainForm_MenuCaptionsPlayNow   = 'Enqueue and play now';

MainForm_MenuCaptionsPlayAllArtist      = 'Play all tracks of this artist (and delete current playlist)';
MainForm_MenuCaptionsPlayAllAlbum       = 'Play all tracks of this album (and delete current playlist)';
MainForm_MenuCaptionsPlayAllDirectory   = 'Play all tracks of this directory (and delete current playlist)';
MainForm_MenuCaptionsPlayAllGenre       = 'Play all tracks of this genre (and delete current playlist)';
MainForm_MenuCaptionsPlayAllYear        = 'Play all tracks of this year (and delete current playlist)';

MainForm_MenuCaptionsPlayAllPlaylist = 'Play all tracks of this playlist (and delete current playlist)';
MainForm_MenuCaptionsPlayAllWebradio = 'Play all tracks of this webradio station (and delete current playlist)';

MainForm_MenuCaptionsEnqueueAll   = 'Enqueue these tracks';
MainForm_MenuCaptionsPlayNextAll  = 'Play these tracks next';
MainForm_MenuCaptionsPlayNowAll   = 'Enqueue and play these tracks now';
MainForm_MenuCaptionsSearchForVar    = 'Search for ''%s''';
MainForm_MenuCaptionsSearchForTitle  = 'Search for this title';
MainForm_MenuCaptionsSearchForArtist = 'Search for this artist';
MainForm_MenuCaptionsSearchForAlbum  = 'Search for this album';


MainForm_Summary_FileCount  = '%d file(s); ' ;
MainForm_Summary_SelectedFileCount = '%d file(s) selected; ';
MainForm_Summary_PlaylistCount = '%d playlist(s)';
MainForm_Summary_WebradioCount = '%d webradio station(s)';


MainForm_Cover_NoCover   = 'No cover available';
MainForm_Lyrics_NoLyrics = 'No lyrics available';

    SplashScreen_Loading            = 'Loading...';
    SplashScreen_LoadingPreferences = 'Loading preferences...';
    SplashScreen_Loadingplaylist    = 'Loading playlist...';
    SplashScreen_SearchSkins        = 'Searching for skins...';
    SplashScreen_InitPlayer         = 'Initializing player...';
    SplashScreen_LoadingMediaLib    = 'Loading medialibrary...';
    SplashScreen_GenerateWindows    = 'Generating windows...';
    SplashScreen_PleaseWaitaMoment  = 'Please wait a moment...';
    SplashScreen_NewDriveConnected  = 'New drive connected. Please wait...';
    SplashScreen_NewDriveConnected2 = 'Rebuilding library...';

// Warning_NempDidntShutDownRegular = 'Nemp didn''t shutdown tidily last time.';
// Warning_NempDidntShutDownRegular_NoBackup = 'Nemp didn''t shutdown tidily. A backup of the playlist couldn''t be found.';

MediaLibrary_Preparing  = 'Preparing medialibrary...';
Medialibrary_Sorting    = 'Sorting data...';
MediaLibrary_AlmostDone = 'Almost done...';
MediaLibrary_SearchingExactMatchings = 'Searching exact matchings (%d%%)';
MediaLibrary_SearchingFuzzyMatchings = 'Searching fuzzy matchings (%d%%)';
MediaLibrary_RefreshingFiles         = 'Refreshing file information (%d%%)';
MediaLibrary_SearchingMissingFiles   = 'Searching missing files (%d%%)';
MediaLibrary_SearchingNewFiles       = '(%d) Searching %s';
MediaLibrary_StartSearchingNewFiles  = 'Start searching...';
MediaLibrary_PreciseQuery            = 'Please precise your query. Too many matchings found.';
MediaLibrary_FilesNotFound           = 'There are %d missing files. You should execute the function "delete missing files" now to cleanup your library.';
MediaLibrary_FilesNotFoundExternalDrive = 'There are %d missing files. Probably there is an external drive not connected to your computer.';
MediaLibrary_DuplicatesWarning       = 'Nemp found some duplicate entries in your medialibrary. This is not supposed to happen. If this message appears frequently feel free to contact me via e-mail. Thank you!';
MediaLibrary_SearchingLyrics         = 'Searching lyrics for %s %s';
MediaLibrary_LyricsFailed            = 'Connection to LyricWiki.org failed. Please check your internet configuration.';
MediaLibrary_SearchLyricsStats       = ' (found %d/%d)';
MediaLibrary_SearchLyricsComplete_SingleNotFound = 'Sorry, the lyrics for this file cannot be found.';
MediaLibrary_SearchLyricsComplete_AllFound = 'Lyricsearch complete. All Lyrics found.';
MediaLibrary_SearchLyricsComplete_ManyFound = 'Lyricsearch complete. %d of %d lyrics found. You can try to find some of the missing lyrics by a manual search on Lyricwiki.org or other lyrics sites on the net.';
MediaLibrary_SearchLyricsComplete_FewFound = 'Lyricsearch complete. Only %d of %d lyrics found. Either the files are not properly tagged, they are instrumental only, or you have a special taste in music.';
MediaLibrary_SearchLyricsComplete_NoneFound = 'Lyricsearch complete. Sorry, but nothing found. Either the files are not properly tagged, they are instrumental only, or you have a special taste in music.';

MediaLibrary_Deleting                = 'Deleting from medialibrary (%d%%)';
Medialibrary_QueryReallyDelete       = 'This will delete your complete medialibrary. Continue?';
Medialibrary_LoadingFile             = 'Loading medialibrary (%s)';
Medialibrary_InvalidLibFile          = 'Invalid medialibrary-file.';
Medialibrary_LibFileTooOld           = 'Medialibrary of Nemp 2.4 or earlier detected. This is not supported any more.';
Medialibrary_OldFileHint        = 'You are loading a medialibrary of an earlier version of Nemp. Please connect all relevant drives to your computer before you proceed. '
                                 + 'Otherwise some files will be deleted from the library.';
Medialibrary_OldFileHint2       = 'Some problems occured while converting the old library and some audiofiles were ignored. You should rebuild it by searching your harddrives for new files.';

Medialibrary_SaveException1 = 'An error occured while saving the medialibrary. Please report this error.';
//Medialibrary_SaveException = 'Saving failed. Probably the directory is write protected or there is not enough available free space.';
Medialibrary_QuickSearchError1 = 'Tried to fill the Quicksearchlist while displaying playlists. This should never occur - please report this error. ';
Medialibrary_GUIError1 = 'This function (1) shouldn''t be accessible now. Please report this error.';
Medialibrary_GUIError2 = 'Tried to fill searchhistory with playlist files. This should never occur - please report this error.';
Medialibrary_GUIError3 = 'This function (3) shouldn''t be accessible now. Please report this error.';
Medialibrary_GUIError4 = 'This function (4) shouldn''t be accessible now. Please report this error.';
Medialibrary_GUIError5 = 'This function (5) shouldn''t be accessible now. Please report this error.';
Medialibrary_DriveRepairError = 'An Error occured while updating drivelist. Please report this error.';

Medialibrary_DialogFilter            = 'Nemp medialibrary';
Medialibrary_AddingPlaylist          = 'Adding the playlist to the medialibrary...';
MediaLibrary_CSVFilter               = 'CSV files';


    Playlist_QueryReallyDelete    = 'This will delete your current playlist. Continue?';
    Playlist_NotEverything        = 'No. Nemp will not add _everything_ to the playlist.';
    Playlist_FileNotFound         = 'The specified file can not be found.';
    Playlist_NoRecentlists        = 'empty';


Player_FilenameWebradioTooLong = 'The filename for this stream is to long and automatic abbreviation failed.' +#13#10
                                  + 'Please change the directory for webradio downloads.';
Player_NoReversePossible = 'It seems that you deleted the playing file from the playlist. Therefore this function cannot be executed.';



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


    AutoScanDirsDialog_Caption = 'Confirmation';
    AutoScanDirsDialog_Text    = 'Do you want Nemp to monitor this directoy?' +#13#10 + #13#10 +
                                 'Nemp will scan this directory for new files on startup. You can edit the monitored directorys within the preferences.';
    AutoScanDirsDialog_ShowAgain = 'Save selection and do not show this dialog again.';

Shoutcast_Error_ConnectionFailed = 'Connection failed. Please check your internet configuration.';
Shoutcast_Error_DownloadFailed = 'Download failed. Please check your internet configuration.';
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

TabBtnBrowse_Hint1 = 'Browse your medialibrary';
TabBtnBrowse_Hint2 = 'Click to resort';


implementation

end.
