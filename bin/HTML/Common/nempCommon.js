var currentProgress=0;
var t;
const successBtn = "<img src='images/success.png' width='24' height='24' alt='operation: success'>";
const failBtn = "<img src='images/fail.png' width='24' height='24' alt='operation: failed'>";
const votefailBtn = "<img src='images/vote_fail.png' width='24' height='24' alt='operation: failed'>";

var MainAudio;
var PlaylistPlayer;
var PlaylistIndex;
var Playlist = [];

document.addEventListener("DOMContentLoaded", function () {
	initPlayerSlider();
	initPlaylistSlider();
	initPlayerVolumeSlider();

	initBrowserVolume();
	initBrowserPlaylist();
});

function handleErrors(response) {
    if (!response.ok) {		
		return Promise.reject(response);
    }
    return response;
}


function initPlaylistSlider() {
	clearTimeout(t);
	const PlaylistSlider = document.getElementById('playlistprogress');	
	if (PlaylistSlider ) {		
		checkPlaylistProgress();
		PlaylistSlider.disabled = true;
		/* If changing progress should be allowed in the Playlist:
		PlaylistSlider.onchange = function () {
			clearTimeout(t);
			fetch("playercontrolJS?action=setprogress&value=" + this.value)
				.then(checkPlaylistProgress())
				.catch(error => console.log(error));
		}
		PlaylistSlider.oninput = function () {
			clearTimeout(t);			
		} */		
	};		
}

function initPlayerSlider() {	
	clearTimeout(t);
	const PlayerSlider = document.getElementById('playerprogress');
	if (PlayerSlider) {
		if (PlayerSlider.classList.contains('ControlsForbidden')) {
			PlayerSlider.disabled = true;
		} else {
			PlayerSlider.onchange = function () {
				clearTimeout(t);
				fetch("playercontrolJS?action=setprogress&value=" + this.value + "&data=progress")
					.then(handleErrors)
					.then(response => { return response.text(); })
					.then(text => SetPlayerProgressSlider(text))					
					.catch(error => console.log('SetProgress: ' + error.status + ':' + error.statusText));
			}
			PlayerSlider.oninput = function () {
				clearTimeout(t);
			}
		}
		checkPlayerProgress();
		// t=setTimeout("checkPlayerProgress()",1000);
	};
}
function initPlayerVolumeSlider() {
	const VolSlider = document.getElementById("volume");
	if (VolSlider) {
		VolSlider.oninput = function () {
			fetch("playercontrolJS?action=setvolume&value=" + this.value + "&data=volume")	
			.then(handleErrors)
			.catch(error => console.log('SetVolume: ' + error.status + ':' + error.statusText));
		}
		VolSlider.onchange = function () {
			fetch("playercontrolJS?action=setvolume&value=" + this.value + "&data=volume")
			.then(handleErrors)
			.catch(error => console.log('SetVolume: ' + error.status + ':' + error.statusText));
		}
		checkVolume();
	}
}

function checkVolume() {
	fetch("playerJS?data=volume")
		.then(response => { return response.text(); })
		.then(text => {	SetVolumeSlider(text); })
		.catch(error => console.log(error));
}

function SetVolumeSlider(vol) {
	const slider = document.getElementById("volume");
	if (slider) {
		slider.value = vol;
	}
}

function checkPlayerProgress() {	
	fetch("playerJS?data=progress")
		.then(response => { return response.text(); })
		.then(text => {			
			if (parseInt(currentProgress) > parseInt(text)) {
				currentProgress = -1;
				reloadPlayer();  //// wirklich neu laden ""
			} else {
				SetPlayerProgressSlider(text);				
			}
		})
		.catch(error => console.log(error));	
};

function SetPlayerProgressSlider(progress) {
	const slider = document.getElementById("playerprogress");
	if (slider) {
		currentProgress = progress;
		slider.value = progress;
		t = setTimeout("checkPlayerProgress()", 1000);
	}
}

function checkPlaylistProgress() {	
	
	fetch("playerJS?data=progress")
		.then(response => { return response.text(); })
		.then(text => {			
			if (parseInt(currentProgress) > parseInt(text)) {
				currentProgress = -1;
				reloadplaylist();
			} else {				
				const slider = document.getElementById("playlistprogress");
				if (slider) {
					currentProgress = text;
					slider.value = text;
					t = setTimeout("checkPlaylistProgress()", 1000);
				}
			}
		})
		.catch(error => console.log(error));	
};

function reloadPlayer() {
	fetch("playerJS")
		.then(response => { return response.text(); })
		.then(text => (replacePlayer(text)))
		.catch(error => console.log(error));
}	

function replacePlayer(data) {
	const currentPlayer = document.getElementById("jsPlayer");
	if (currentPlayer) {
		currentPlayer.outerHTML = data;		
		initPlayerSlider();		
		initPlayerVolumeSlider();
		initBrowserVolume();
	}
}

function reloadplaylist() {	
	fetch("playlistJS")
		.then(handleErrors)
		.then(response => { return response.text(); })
		.then(text => {			
			let playlist = document.getElementById("playlist");
			if (playlist) {
				playlist.innerHTML = text;
				initPlaylistSlider();				
			}
		})
		//.catch(error => console.log('wuppdi' + error));
		.catch(error => console.log('Playlist control: ' + error.status + ':' + error.statusText));
}

function doVolumeControl(value) {
	fetch("playercontrolJS?action=setvolume&value="+value+"&data=volume")
		.then(handleErrors)
		.then(response => { return response.text(); })		
		.then(text => SetVolumeSlider(text))
		.catch(error => console.log('Volume control: ' + error.status + ':' + error.statusText));
}
function playercontrol_VolumeUp() {
	doVolumeControl(1000);	
} 
function playercontrol_VolumeDown() {
	doVolumeControl(-1000);	
}  

function doPlayerControl(action) {
	fetch("playercontrolJS?action=" + action)  
		.then(handleErrors)
		.then(response => {return response.text();})
		.then(text => (replacePlayer(text)))
		.catch(error => console.log('Player remote control: ' + error.status + ':' + error.statusText));
}	
function playercontrol_playpause() {
	doPlayerControl("playpause");	
};
function playercontrol_stop() {
	doPlayerControl("stop");
};
function playercontrol_playnext() {
	doPlayerControl("next");	
};
function playercontrol_playprevious() {
	doPlayerControl("previous");
};		

function playtitle(aID) {	
	fetch("playlistcontrolJS?id=" + aID + "&action=file_playnow")
		.then(handleErrors)
		.then(response => { return response.text(); })
		.then(text => {			
			if (text == "0") {
				alert("Playing failed. Please reload this page and try again.");
			}
			const oldCurrent = document.getElementsByClassName("current");
			for (let i = 0; i < oldCurrent.length; i++) {
				oldCurrent[i].classList.remove("current");
			}
			const newCurrent = document.getElementById("js" + text);
			if (newCurrent) {
				newCurrent.classList.add("current");
			}
		})
		.catch(error => console.log('Playlist remote control (play): ' + error.status + ':' + error.statusText));
};

function moveup(aID) {
	fetch("playlistcontrolJS?id=" + aID + "&action=file_moveup")		
		.then(handleErrors)
		.then(response => { reloadplaylist();})	
		.catch(error => console.log('Playlist remote control (move): ' + error.status + ':' + error.statusText));
};

function movedown(aID) {	
	fetch("playlistcontrolJS?id=" + aID + "&action=file_movedown")		
		.then(handleErrors)		
		.then(response => { reloadplaylist(); })
		.catch(error => console.log('Playlist remote control (move): ' + error.status + ':' + error.statusText));
};

function filedelete(aID) {
	fetch("playlistcontrolJS?id=" + aID + "&action=file_delete")		
		.then(handleErrors)
		.then(response => { reloadplaylist(); })
		.catch(error => console.log('Playlist remote control (delete): ' + error.status + ':' + error.statusText));
}

function ReplaceButton(aID, aText) {
	let btn = document.getElementById(aID);	
	if (aText == "ok") {
		btn.outerHTML = successBtn;
	}
	else if (aText == "already voted") {
		btn.outerHTML = votefailBtn;
	}
	else if (aText == "spam") {
		btn.outerHTML = votefailBtn;
	}
	// else if (data == "exception") { alert("Failure. Please reload."); }
	else {
		btn.outerHTML = failBtn;
	}	
}

function HandleVote(aID, aText) {
	let playlist = document.getElementById("playlist");
	if (playlist) {
		reloadplaylist();
		// ReplaceButton(aID, aText);
	} else {
		ReplaceButton(aID, aText);
	}
}

function addnext(aID){
	fetch("playlistcontrolJS?id=" + aID + "&action=file_addnext")
		.then(handleErrors)
		.then(response => { return response.text(); })
		.then(text => ReplaceButton("btnAddNext" + aID, text))
		.catch(error => console.log('Playlist remote control (add): ' + error.status + ':' + error.statusText));
}

function add(aID) {
	fetch("playlistcontrolJS?id=" + aID + "&action=file_add")
		.then(handleErrors)
		.then(response => { return response.text(); })
		.then(text => ReplaceButton("btnAdd" + aID, text))
		.catch(error => console.log('Playlist remote control (add): ' + error.status + ':' + error.statusText));
}

function vote(aID) {	
	fetch("playlistcontrolJS?id=" + aID + "&action=file_vote")
		.then(handleErrors)
		.then(response => { return response.text(); })
		.then(text => HandleVote("btnVote" + aID, text))
		.catch(error => console.log('Playlist remote control (vote): ' + error.status + ':' + error.statusText));
}

/*
 ******************************************
 * Methods to play Audio in the Browser 
 ******************************************
*/
function initBrowserVolume() {
	MainAudio = document.querySelector('audio');
	if (MainAudio) {
		MainAudio.onvolumechange = (event) => {
			localStorage.setItem('volume', MainAudio.volume);
		};
		if (localStorage.getItem('volume') != null) {
			MainAudio.volume = parseFloat(localStorage.getItem('volume'));
		};
	}
}

function initBrowserPlaylist() {
	let items = document.getElementsByClassName("listitem");
	if (items) {
		for (let i = 0; i < items.length; i++) {
			let title = items[i].getElementsByClassName("title")[0];
			if (title) {
				title = title.innerHTML;
			} else {
				title = '';
			}			
			Playlist.push({
				id: items[i].id.substring(2),
				name: title,
				filename: items[i].dataset.filename,
				mime: items[i].dataset.mime,
				extension: items[i].dataset.extension				
			});
		}
		// console.log("Found Files: ");
		// Playlist.forEach(element => console.log(element));
	}
	PlaylistPlayer = document.getElementById('htmlaudioplaylist');
	if (PlaylistPlayer) {
		PlaylistIndex = 0;
		PlaylistPlayer.addEventListener('ended', PlayNextItemInBrowser, false);
		PlaylistPlayer.addEventListener('pause', AutoRefreshIcon, false);
		PlaylistPlayer.addEventListener('play', AutoRefreshIcon, false);
		PlaylistPlayer.addEventListener('playing', AutoRefreshIcon, false);
		if (Playlist.length > 0) {
			loadItemIntoBrowserPlayer(Playlist[0].id)
		}		
	}
}

function AutoRefreshIcon() {
	RefreshAnimationIcon(-1);
}

function RefreshAnimationIcon(aID) {
	if (aID == -1) {
		aID = Playlist[PlaylistIndex].id;
	}
	
	let items = document.getElementsByClassName("nowPlayingIcon");
	if (items) {
		for (let i = 0; i < items.length; i++) {
			items[i].classList.remove("nowPlaying");
		}
	}

	if (!PlaylistPlayer.paused) {
		let currentTrack = document.getElementById("nowPlaying" + aID);
		if (currentTrack) {			
			currentTrack.classList.add("nowPlaying");
		}
	}
}

function RefreshPlaylistIndex(aID) {
	for (let i = 0; i < Playlist.length; i++) {
		if (Playlist[i].id == aID) {
			PlaylistIndex = i;
			return;
		}		
	}
}

function loadItemIntoBrowserPlayer(aID) {
	const source = document.getElementById('PlaylistSource');
	source.src = Playlist[PlaylistIndex].filename + "?id=" + aID + "&action=file_stream";
	source.type = Playlist[PlaylistIndex].mime;
	PlaylistPlayer.load();
}

function SameIdClickedAgain(aID) {
	if (PlaylistIndex == -1) {
		return false;
	}
	if (PlaylistIndex > Playlist.length - 1) {
		return false;
	}
	if (Playlist[PlaylistIndex].id == aID) {
		return true;
	} else {
		return false;
	}
}

function TogglePlayPause() {
	return PlaylistPlayer.paused ? PlaylistPlayer.play() : PlaylistPlayer.pause();	
}

function playItemInBrowser(aID) {
	// The user clicked on an item in the Browsers Playlist
	// Get the Index of the Item in the Playlist
	if (SameIdClickedAgain(aID) == true) {
		TogglePlayPause();
		RefreshAnimationIcon(aID);
	} else {
		RefreshPlaylistIndex(aID);
		// Load it into the Player
		loadItemIntoBrowserPlayer(aID);
		// play it!
		PlaylistPlayer.play();
		RefreshAnimationIcon(aID);
	}
}

function PlayNextItemInBrowser() {
	if (PlaylistIndex === Playlist.length - 1) {
		PlaylistIndex = 0;
	} else {
		PlaylistIndex++;
	}
	playItemInBrowser(Playlist[PlaylistIndex].id);
}