# Nemp - Noch ein Mp3-Player
*("Noch ein Mp3-Player" is german and translates to "Yet another mp3-player")*

Nemp is an MP3 player with a powerful media library to manage all the music files in your collection. It has a lot of standard features, but also some other things you won't find elsewhere.

![Nemp Player](/Screenshots/MainPlayer-5-0.jpg)

## Basic Features

Nemp can play, find and manage music files, playlists and web streams. Among others mp3, ogg, wma, wav, flac, ape, aac, m4a, m3u, m3u8, pls, asx, wax. You can browse in your collection by a Tree View (grouped by different properties, like Artist+Album, only Album, or directories), by a Cowerflow, or by a Tag Cloud, which is created automatically from the ID3-Tags, and can be expanded by a fully automated tag search from Last.fm. And of course you can enter your very own tags, like "Holiday 2018 on Ibiza" if you like.

![Nemp Coverflow](/Screenshots/Coverflow.jpg)

To avoid duplicate Tags with a similar meaning (like "90s" and "90ies"), you can define a list of synonyms that should be merged into one tag. And you can also ignore a list of tags you don't want in your Tag Cloud (for example, many titles are tagged with the starting letter in the Last.fm database)

![Nemp Tag Cloud](/Screenshots/TagCloud.jpg)

A key feature is the search function for the media library. It is pretty fast, and works while you type with no delay even on larger collections with tens of thousands titles. If you wish, a fuzzy search is performed as well. With that, you may find titles from "P!nk" when searching for "Pink".

## Integrated web server

Nemp has an integrated web server for remote control of the player in the local network, e.g. via a mobile phone in the same WiFi. You can define what the user can do. Should he simply be able to make requests for the playlist, or should he have full access to the player and the playlist? Or is he allowed to download individual titles to his phone?

![Nemp Webserver: Player](/Screenshots/WebserverCombined.jpg)

## Settings!
Nemp has a lot (and I mean a lot!) of settings. Some are very useful, others may have their use only for a few people. But: "in dubio pro setting". 
* You can define whether Nemp should start playback when it is started, or whether Nemp should remember the current position in the current track when it is closed (great for audio books).
* You can define usage of media keys, additionally install some global hotkeys, use the tabulator key for almost all controls, ...
* You can choose which properties are displayed in the main list, sort your music collection by whatever you want
* Activate fading between tracks and skip silence at the end of tracks
* Choose a default action when the user double-click a file in the Windows Explorer, like "play" or "enqueue"
* Automatically scan your music folder for new files when Nemp starts
* Use a fuzzy search (do you know how many R, S and T are in "Alanis Morissette"?)
* and many, many more!

![Nemp Settings](/Screenshots/Settings.jpg)

## The Nemp Wizard
Nemp does not change anything in your music files without your permission. It will not write any fancy meta data to your files - unless you allow it (or if you actually change some properties in the file details dialog). As some really nice features require it to write additional data into the music files (or your music folders), Nemp comes with a settings wizard which will ask for your permission for these actions.

![Nemp Wizard](/Screenshots/Wizard.jpg)

## more ...
* Nemp does not need to be installed. As a tool on an external disk it is immediately ready to use on any computer - including the media library.
* You can copy the playlist (Ctrl+C) and paste it to a new directory in the Windows Explorer (Ctrl+V) or a mobile device attached to your computer. Including a proper playlist file, if you want (Ctrl+Shift+C).
* Nemp can record webstreams (mp3 and aac only) and cut them automatically by length, file size or title (if the radio station send proper title information).
* Nemp can scrobble
* Nemp can search online for missing cover art
* Nemp can playback a second track on a second sound card (without disturbing the main playback)
* Nemp can shut down the computer after some time. This includes lowering the output volume during the last 30 seconds, so you won't wake up again due to a sudden change in the volume
* Nemp can play a birthday song at midnight automatically 
* You can customize the look of Nemp by the integrated skin system
* You can create random playlists based on genres and other tags
* Fun stuff: If Nemp runs on a device with low battery, it may happen that the playback wobbles a little bit - just as it did on these old portable cassette players ...

## Nemp API

For developers: Nemp comes with an API, so that other programs can communicate with Nemp. For example, you can write an app for your keyboard display which shows the current title and provides basic controls for the player. Such an app for the "Logitech G15" is included in the download archive.

If you already did something like that for Winamp: The Nemp API is very similar to use.

## Contribute
If you miss a function and want it to be implemented, or if you want to add some lines of code, just contact me: 

E-Mail: mail@gausi.de

Some features have already been added after user feedback - e.g. the search in the playlist, marks in the library, the player log file, or the weighted random playback.
