{

    Unit MetTagSorting

    - Sort MetaTag-Frames by content

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2005-2022, Daniel Gaussmann
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

unit MetaTagSorting;

interface

uses System.Classes;

var SL_ID3_22, SL_ID3_23, SL_OGG, SL_APE, SL_M4A: TStringList;

implementation


initialization

SL_ID3_22 := TStringList.Create;
SL_ID3_23 := TStringList.Create;
SL_OGG    := TStringList.Create;
SL_APE    := TStringList.Create;
SL_M4A    := TStringList.Create;


///  ===================================================
///
///  M4A-keys
///
///  ===================================================
SL_M4A.Add('©ART');  // Artist
SL_M4A.Add('©nam');  // Title
SL_M4A.Add('©alb');  // Album
SL_M4A.Add('©day');  // Year, Date
SL_M4A.Add('©gen');  // Genre (User defined)
SL_M4A.Add('gnre');  // Genre-Index (like in ID3v1), (read-only)
SL_M4A.Add('trkn');  // Track
SL_M4A.Add('disk');  // Disk
SL_M4A.Add('©cmt');  // Comment
SL_M4A.Add('keyw');  // Keywords, Tagcloud
SL_M4A.Add('©wrt');  // Composer
SL_M4A.Add('©lyr');  // Lyrics
SL_M4A.Add('covr');  // Cover Art (Binary Data)
SL_M4A.Add('cprt');  // Copyright
SL_M4A.Add('aART');  // Album Artist
SL_M4A.Add('©grp');  // Grouping
SL_M4A.Add('tvsh');  // TV Show Name
SL_M4A.Add('tven');  // TV Episode ID
SL_M4A.Add('tvnn');  // TV Network
SL_M4A.Add('desc');  // Description
SL_M4A.Add('ldes');  // Long Description
SL_M4A.Add('sonm');  // Sort Name
SL_M4A.Add('soar');  // Sort Artist
SL_M4A.Add('soal');  // Sort Album
SL_M4A.Add('soco');  // Sort Composer
SL_M4A.Add('sosn');  // Sort Show
SL_M4A.Add('©too');  // Encoding Tool
SL_M4A.Add('©enc');  // Encoded by
SL_M4A.Add('purd');  // Purchase Date
SL_M4A.Add('catg');  // Category
SL_M4A.Add('apID');  // Purchase Account

///  ===================================================
///
///  Two similar Lists for OggVorbis- and APE-Comments
///
///  ===================================================
SL_OGG.Add('ARTIST');                 SL_APE.add('ARTIST');   // Artist
SL_OGG.Add('TITLE');                  SL_APE.add('TITLE');    // Titel
SL_OGG.Add('ALBUM');                  SL_APE.add('ALBUM');    // Album
SL_OGG.Add('YEAR');                   SL_APE.add('YEAR');     // Year
SL_OGG.Add('DATE');                   SL_APE.add('DATE');     // .. (?)
SL_OGG.Add('GENRE');                  SL_APE.add('GENRE');    // Genre

SL_OGG.Add('TRACKNUMBER');            SL_APE.Add('TRACK');    // Track
SL_OGG.Add('TRACKTOTAL');
SL_OGG.Add('DISCNUMBER');             SL_APE.Add('DISC');
SL_OGG.Add('DISCTOTAL');
SL_OGG.Add('COMMENT');                SL_APE.add('COMMENT');    // Comment
SL_OGG.Add('DESCRIPTION');            SL_APE.add('Abstract');
SL_OGG.Add('CATEGORIES');             SL_APE.Add('CATEGORIES'); // Tagcloud-Tags

SL_OGG.Add('PLAYCOUNT');              SL_APE.Add('PLAYCOUNT');  // Playcounter
SL_OGG.Add('RATING');                 SL_APE.Add('RATING');     // rating

SL_OGG.Add('PERFORMER');              SL_APE.Add('Composer');
                                      SL_APE.Add('Conductor');
                                      SL_APE.Add('Publisher');

SL_OGG.Add('REPLAYGAIN_TRACK_GAIN');  SL_APE.Add('REPLAYGAIN_TRACK_GAIN');
SL_OGG.Add('REPLAYGAIN_TRACK_PEAK');  SL_APE.Add('REPLAYGAIN_TRACK_PEAK');
SL_OGG.Add('REPLAYGAIN_ALBUM_GAIN');  SL_APE.Add('REPLAYGAIN_ALBUM_GAIN');
SL_OGG.Add('REPLAYGAIN_ALBUM_PEAK');  SL_APE.Add('REPLAYGAIN_ALBUM_PEAK');

SL_OGG.Add('UNSYNCEDLYRICS');         SL_APE.Add('UNSYNCEDLYRICS');   // Lyrics

SL_OGG.Add('COPYRIGHT');              SL_APE.Add('Copyright');
SL_OGG.Add('ISRC');                   SL_APE.Add('ISRC');

///  ===================================================
///
///  Two lists for ID3v2.2 and 2.3/2.4
///
///  ===================================================
SL_ID3_22.Add('TP1');    SL_ID3_23.Add('TPE1');   // Artist
SL_ID3_22.Add('TT2');    SL_ID3_23.Add('TIT2');   // Titel
SL_ID3_22.Add('TAL');    SL_ID3_23.Add('TALB');   // Album
SL_ID3_22.Add('TYE');    SL_ID3_23.Add('TDRC');   // Year
                         SL_ID3_23.Add('TYER');   // ..
SL_ID3_22.Add('TCO');    SL_ID3_23.Add('TCON');   // Genre

SL_ID3_22.Add('TRK');    SL_ID3_23.Add('TRCK');   // Track
SL_ID3_22.Add('TPA');    SL_ID3_23.Add('TPOS');   // CD, Part Of A Set
SL_ID3_22.Add('COM');    SL_ID3_23.Add('COMM');   // Comments
SL_ID3_22.Add('POP');    SL_ID3_23.Add('POPM');   // rating, Popularimeter

SL_ID3_22.Add('TP2');    SL_ID3_23.Add('TPE2');   // other "Artists"
SL_ID3_22.Add('TP3');    SL_ID3_23.Add('TPE3');   // ..
SL_ID3_22.Add('TP4');    SL_ID3_23.Add('TPE4');   // ..
SL_ID3_22.Add('TPB');    SL_ID3_23.Add('TPUB');   // Publisher
SL_ID3_22.Add('ULT');    SL_ID3_23.Add('USLT');   // Lyrics

SL_ID3_22.Add('WXX');    SL_ID3_23.Add('WXXX');   // URLs
SL_ID3_22.Add('WAF');    SL_ID3_23.Add('WOAF');   // ..
SL_ID3_22.Add('WAR');    SL_ID3_23.Add('WOAR');   // ..
SL_ID3_22.Add('WAS');    SL_ID3_23.Add('WOAS');   // ..
SL_ID3_22.Add('WCM');    SL_ID3_23.Add('WCOM');   // ..
SL_ID3_22.Add('WCP');    SL_ID3_23.Add('WCOP');   // ..
SL_ID3_22.Add('WPB');    SL_ID3_23.Add('WPUB');   // ..
                         SL_ID3_23.Add('WORS');   // ..
                         SL_ID3_23.Add('WPAY');   // ..

SL_ID3_22.Add('PIC');    SL_ID3_23.Add('APIC');   // Picture-Frames

SL_ID3_22.Add('TCM');    SL_ID3_23.Add('TCOM');   // Additional Text-Frames
SL_ID3_22.Add('TOA');    SL_ID3_23.Add('TOPE');
SL_ID3_22.Add('TCR');    SL_ID3_23.Add('TCOP');
SL_ID3_22.Add('TEN');    SL_ID3_23.Add('TENC');
SL_ID3_22.Add('TLA');    SL_ID3_23.Add('TLAN');
SL_ID3_22.Add('TSS');    SL_ID3_23.Add('TSSE');
SL_ID3_22.Add('TMT');    SL_ID3_23.Add('TMED');
SL_ID3_22.Add('TLE');    SL_ID3_23.Add('TLEN');
SL_ID3_22.Add('TOF');    SL_ID3_23.Add('TOFN');
SL_ID3_22.Add('TOL');    SL_ID3_23.Add('TOLY');
SL_ID3_22.Add('TOR');    SL_ID3_23.Add('TDOR');
SL_ID3_22.Add('TOT');    SL_ID3_23.Add('TOAL');
SL_ID3_22.Add('TBP');    SL_ID3_23.Add('TBPM');
SL_ID3_22.Add('TDY');    SL_ID3_23.Add('TDLY');
SL_ID3_22.Add('TFT');    SL_ID3_23.Add('TFLT');
SL_ID3_22.Add('TKE');    SL_ID3_23.Add('TKEY');
SL_ID3_22.Add('TRC');    SL_ID3_23.Add('TSRC');
SL_ID3_22.Add('TT1');    SL_ID3_23.Add('TIT1');
SL_ID3_22.Add('TT3');    SL_ID3_23.Add('TIT3');
SL_ID3_22.Add('TXT');    SL_ID3_23.Add('TEXT');
                         SL_ID3_23.Add('TOWN');
                         SL_ID3_23.Add('TRSN');
                         SL_ID3_23.Add('TRSO');
                         SL_ID3_23.Add('TDEN');
                         SL_ID3_23.Add('TDRL');
                         SL_ID3_23.Add('TDTG');
                         SL_ID3_23.Add('TMCL');
                         SL_ID3_23.Add('TMOO');
                         SL_ID3_23.Add('TPRO');
                         SL_ID3_23.Add('TSOA');
                         SL_ID3_23.Add('TSOP');
                         SL_ID3_23.Add('TSOT');
                         SL_ID3_23.Add('TSST');
SL_ID3_22.Add('TXX');    SL_ID3_23.Add('TXXX');  // User-defined Text


finalization

SL_ID3_22.Free;
SL_ID3_23.Free;
SL_OGG.Free;
SL_APE.Free;
SL_M4A.Free;

end.
