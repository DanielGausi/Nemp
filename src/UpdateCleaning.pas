unit UpdateCleaning;

interface

const
  OutdatedFiles: Array[1..140] of String =
    ( // Default Images
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
      'HTML\Default\',
      'HTML\Default\',
      'HTML\Default\',
      'HTML\Default\',
      'HTML\Default\',
      'HTML\Default\',
      'HTML\Default\',

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





      // Party images
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

      // Party Files
          'HTML\Party\default_cover.png',
          'HTML\Party\favicon.ico',
          'HTML\Party\help.html',
          'HTML\Party\jquery-1.7.1.min.js',
          'HTML\Party\jquery-ui.css',
          'HTML\Party\jquery-ui.min.js',
          'HTML\Party\main.css',
      'HTML\Party\main_admin.css', // ???
      'HTML\Party\party.js', // ???
      'HTML\Party\party_admin.js', // ???

      // Removed Templates
            'HTML\Party\PaginationMain.tpl',
            'HTML\Party\PaginationOther.tpl',
            'HTML\Party\PaginationNextPage.tpl',
            'HTML\Party\PaginationPrevPage.tpl',

            // admin only: Control buttons
            'HTML\Party\admin\PlayerControls.tpl',
            'HTML\Party\admin\BtnControlNext.tpl',
            'HTML\Party\admin\BtnControlPlay.tpl',
            'HTML\Party\admin\BtnControlPause.tpl',
            'HTML\Party\admin\BtnControlPrev.tpl',
            'HTML\Party\admin\BtnControlStop.tpl',
      // Renamed Templates
            'HTML\Party\ItemSearchResult.tpl', // => ItemFileLibrary
            'HTML\Party\ItemPlaylist.tpl', // => ItemFilePlaylist
            'HTML\Party\ItemPlaylistDetails.tpl', // => ItemFilePlaylistDetails
            'HTML\Party\ItemSearchDetails.tpl', // => ItemFileLibraryDetails
            'HTML\Party\Menu.tpl', // => MenuMain
            'HTML\Party\MenuLibraryBrowse.tpl', // => MenuLibrary
            'HTML\Party\ItemPlayer.tpl' // ItemFilePLayer




    );

implementation

end.
