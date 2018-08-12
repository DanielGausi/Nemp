=================================================================
Nemp Skin System
=================================================================

If you want to modify the existing skins or create your own ones, you can 
just edit some image files or change some values in the skin.ini file.

Some parts of the ini file, and some image files as well, have no meaning 
anymore. These "unused parts" are just remainders from older versions.

The optional *.vsf file is a Delphi-VCL-Style used in newer versions of the
Delphi IDE from Embarcadero.



=================================================================
Image files
=================================================================
Supported file formats: PNG, JPG, BMP

The pixel in the upper left corner is considered as transparent. All pixels 
with this color will not be part of the button, i.e. not clickable. 

Every button file needs 5 columns for the following variants
	1. regular
	2. mouse over
	3. (unused, was pressed and *not* mouse over in older versions of the skin system)
	4. pressed + mouse over
	5. disabled

Some buttons have several modes. For each mode, a new line is needed.

BtnPlayPause: 	1. Play
		2. Pause
BtnStop: 	1. regular
		2. Player will stop after the current file
BtnRecord:	1. not recording
		2. recording
BtnRandom: 	1. repeat all
		2. repeat title
		3. random 
		4. no repeat
BtnReverse: 	1. backwards 
		2. forward
TabBtn<..>:	1. regular
		2. active tab
		3. active tab with warning indicator:
		   medienbib has changed, some browsing results may be inaccurate
		   (only TabBtnTagCloud and TabBtnBrowse)	
TabBtnMarker:	1: no marker
		2: marker blue
		3: marker red
		4: marker green
		2: marker red/blue/green


Addtional image files:
----------------------

main:		Bckground for the major part of the main form
player:		Background of the player part
extendedplayer:	Background for lyrics, equalizer, effects, ... (if
Win7PreviewBackground: Background image for the Taskbar preview (Windows 7 or later)


ListenBilder:	16x16 icons for use in the playlist and media list
		0: playlist, default icon
		1: playlist, lyrics (actually unused)
		2, 
		3,
		4: playlist, current file (play, pause, stop)
		5: playlist, file not found
		6,
		7: medialist: lyrics existing / not existing
		8: playlist, unknown audio file
		9: playlist, webstream
		10: playlist, CD-DA
		11: medialist, extended tags 
		12,
		13,
		14,
		15: medialist, markers


MenuImages: 16x16 icons for use in the menus (main menu and context menus)
	    (only in Nemp 4.9 or later)			
		0: load
		1: save
		2: birthday mode
		3: search audio files
		4: help
		5: preferences
		6: properties
		7: play in headset
		8: skins
		9: webserver
		10: search
		11: sort
		12: delete media library
		13: <unused>
		14: <unused>
		15: search
		16: shutdown timer
		17: about Nemp
		18: scrobbling
		19: tag cloud editor
		20: rating (full star)
		21: close Nemp
		22: search for updates
		23: rating (empty star)
		24: rating (half star)
		25: get lyrics
		26: play (unused?)
		27: stop (unused?)
		28: <unused> 
		29: <unused>
		30: <unused>
		31: keyboard display
		32: wizard
		33: warning
		34,
		35,
		36,
		37: marker

unused images:
--------------
BtnQuickSearch
BtnMinimize
BtnMenu

=================================================================
Sections in the skin.ini file
=================================================================
Boolean Values:		0: False
			1: True
valid color format:	$ggrrbb
			$00ggrrbb
			$FF<6-digit-ID> (not recommended)

Note: Color values are G-B-R, *not* R-G-B as in most image editing software, html, etc.


[BackGround]
-----------------------------------------------------------------
HideBackgroundImageVorauswahl,
HideBackgroundImagePlaylist,
HideBackgroundImageMedienliste	: Don't use the background image in these parts
PlayerPageOffsetX,
PlayerPageOffsetY:	Offset where the background image starts
TileBackground:		Tile the background image (repeat-x-y)
FixedBackGround:	1: offset is relative to the main window
			0: offset is relative to the desktop
not used anymore:
-----------------
HideBackgroundImageArtists
HideBackgroundImageAlben



[Options]
-----------------------------------------------------------------
DrawTransparentLabel: 	Draw transparent labels
DrawTransparentTitel,
DrawTransparentTime:	Draw transparent information in the main part
boldFont:		use bold font for title and time in the main part
DisableBitrateColorsPlaylist,
DisableBitrateColorsMedienliste:	disable the color coding for bitrates in the lists
DisableArtistScrollbar,
DisableAlbenScrollbar,
DisablePlaylistScrollbar,
DisableMedienListeScrollbar:	don't show scrollbars in the lists
UseBlendedSelectionArtists,
UseBlendedSelectionAlben,
UseBlendedSelectionPlaylist,
UseBlendedSelectionTagCloud,
UseBlendedSelectionMedienliste: use a semi-transparent selection in the lists
UseBlendedArtists,
UseBlendedAlben,
UseBlendedPlaylist,
UseBlendedTagCloud,
UseBlendedMedienliste: 	use a semi-transparent background in the lists
HideMainMenu:		don't show the main menu
UseDefaultListImages,
UseDefaultStarBitmaps,
UseDefaultMenuImages,
UseDefaultTreeImages: 	use the default images, not the ones in the skin directory
BlendFaktorArtists,
BlendFaktorAlben,
BlendFaktorPlaylist,
BlendFaktorMedienliste,
BlendFaktorTagCloud:	value for selection transparency in the lists
BlendFaktorArtists2,
BlendFaktorAlben2,
BlendFaktorPlaylist2,
BlendFaktorMedienliste2,
BlendFaktorTagCloud2:	value for transparency in the lists
ButtonMode:		Mode how to paint the player buttons
			0: Windows
			1: Windows with skin graphics
			2: Full skin graphics
SlideButtonMode:	Mode how to paint the slide buttons (position, volume, effects, equalizer)
UseSeparatePlayerBitmap:	Use graphic "extendedplayer" for effects/lyrics/equalizer/..
UseAdvancedSkin:		Use the advanced skin system (include a *.vsf file)
AdvancedStyleFilename:		Filename of the advanced skin file (*.vsf)

not used anymore:
-----------------
DrawGroupboxFrames
DrawGroupboxFramesMain
HideTabText
DrawTransparentTabText
UseDefaultButtons
UseDefaultSlideButtons



[Colors]
-----------------------------------------------------------------
FormCL			Background color of the main form
SpecTitelCL,
SpecTimeCL: 		Font colors for time and title in main part
SpecTitelBackGroundCL,
SpecTimeBackGroundCL:	Background colors for time and title (if not transparent)
SpecPenCL,
SpecPen2CL:		Color of the jumping bars (linear gradient between these two)
SpecPeakCL:		Peak color for these bars
LabelCL:		Font color of labels in the main form
LabelBackGroundCL:	background color of labels (if not transparent)
GroupboxFrameCL:	Color of frames
MemoBackGroundCL:	Background of the lyrics part
MemoTextCL:		Font color of the lyrics part
ShapeBrushCL,
ShapePenCL:		Colors for the slide shapes for time, volume, effects, equalizer
Splitter1,
Splitter2,
Splitter3:		Colors for the splitters to resize several parts of the main window
PlaylistPlayingFileColor: Font color of the file currently playing in the playlist
MinFontColor,
MiddleFontColor,
MaxFontColor:		Colors for bitrate coding
MiddleToMinComputing,
MiddleToMaxComputing:	paramater for the gradient of the bitrate coding
			0: squared
			1: linear
			2: square root
PreviewTimeColor,
PreviewTitelColor,
PreviewArtistColor: Font colors for the Windows7 preview in the taskbar

not used anymore
-----------------
TabTextCL
TabTextBackGroundCL
ControlImagesColor



[DialogColors]
-----------------------------------------------------------------
Not used anymore 
(was used for the skin editor, which is not part of Nemp anymore)



[Buttons]
-----------------------------------------------------------------
Note: Only the buttons in the player part are customizable in that way
      Buttons for equalizer and headphones, as well as the "tab buttons"
      for selections are fixed in size and position.
<..>Visible:	Button is visible
<..>Left,
<..>Top: 	Position of the button
<..>Width,
<..>Height:	Dimension of the button

not used anymore
-----------------
<..>Transparent
BtnMinimize<..>
BtnMenu<..>



[ArtistColors],[AlbenColors],[PlaylistColors],[MedienlisteColors]
-----------------------------------------------------------------
Tree_Color: 			Background of the list (*)
Tree_FontColor: 		Font color in the list. (*)
Tree_FontColorSelected: 	Font color of a selected item. 
Tree_HeaderBackgroundColor: 	Background of the header. 
Tree_HeaderFontColor: 		Font of the header. (*)
Tree_BorderColor: 		little gap between header columns. 
Tree_DropTargetBorderColor, 
Tree_DropTargetColor: 		Color for the Drag&Drop target
Tree_FocussedSelectionBorder,
Tree_FocussedSelectionColor: 	Background color of the selection. 
Tree_SelectionRectangleBlendColor,
Tree_SelectionRectangleBorderColor: Colors for a selection (mouse Click&Drag, probably rarely used)
Tree_UnfocusedSelectionBorderColor,
Tree_UnfocusedSelectionColor: 	Background color of the selection without focus

(*): These color ar not used whith the "advanced skin system" and will be repleaced with the colors  
     defined in the *.vsf file

currently unused:
-----------------
Tree_DisabledColor
Tree_DropMarkColor
Tree_HeaderHotColor
Tree_HotColor
Tree_TreeLineColor
Tree_GridLineColor

