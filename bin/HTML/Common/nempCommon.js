var currentProgress=0;
var t;
var successBtn = "<img src='images/success.png' width='24' height='24' alt='operation: success'>";
var failBtn = "<img src='images/fail.png' width='24' height='24' alt='operation: failed'>";
var MainAudio;
var PlaylistAudio;
var PlaylistIndex;
var AudioFiles = [];

$(document).ready(function() {			
	initSliders();
	initVolume();	
	GetFileIDs();
});

function initVolume() {
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

function initPlaylistSlider() {
	var prog = document.getElementById('playlistprogress');	
	if ( prog ) {		
		$("#playlistprogress").slider({animate: 1000, disabled: true} );		 
		checkPlaylistProgress();
		t=setTimeout("checkPlaylistProgress()",1000);
	};		
}

function initSliders() {
	var prog = document.getElementById('progress');	
	if ( prog ) {
		if (prog.classList.contains('ControlsForbidden')) {
			$("#progress").slider({animate: 1000, disabled: true} );
		} else {
			$("#progress").slider({ stop: function(event, ui) { 				
				$.ajax({url:"playercontrolJS?action=setprogress&value="+ui.value, dataType:"html"});},
				animate: 1000					
				} );
		}
		checkProgress();
		t=setTimeout("checkProgress()",1000);
	};	
	var vol = document.getElementById('volume');
	if ( vol ){
		$("#volume").slider( 
				{ stop: function(event, ui){$.ajax({url:"playercontrolJS?action=setvolume&value="+ui.value, dataType:"html"});},
				  slide: function(event, ui){$.ajax({url:"playercontrolJS?action=setvolume&value="+ui.value, dataType:"html"}) }
				} 
			);
		checkVolume();
	}	
	initPlaylistSlider();	
}

function GetFileIDs() {
	let items = document.getElementsByClassName("libraryitem");
	let numItems = items.length;

	for (let i=0; i<numItems; i++) {
		let title = items[i].getElementsByClassName("linetitle")[0].innerHTML;
		// todo: Mimetype/endung ins template bzw. ins HTML zum auslesen
		AudioFiles.push( { id: items[i].id.substring(2), name: title });
		
	}	
	console.log("Gefundene Files: ");
	AudioFiles.forEach(element => console.log(element));
	
	PlaylistAudio = document.getElementById('htmlaudioplaylist');	
	PlaylistIndex = -1;
	PlaylistAudio.addEventListener('ended', PlayNext, false);
	PlayNext();	
}

function PlayNext() {
   	if (PlaylistIndex === AudioFiles.length - 1) {
		PlaylistIndex = 0;
	} else {
		PlaylistIndex++;
	}	
	let source = document.getElementById('PlaylistSource');
	source.src = AudioFiles[PlaylistIndex].name+".mp3?id="+AudioFiles[PlaylistIndex].id+"&action=file_stream";
	source.type = 'audio/mpeg';			
		
	PlaylistAudio.load();
	PlaylistAudio.play();		
}

function checkVolume() {
	$.ajax({url:"playercontrolJS?action=getvolume", dataType:"text", success: 
		function(data, textStatus, jqXHR){$("#volume").slider( "value" , data);}
		});				
}

function checkProgress(){
	$.ajax({url:"playercontrolJS?action=getprogress", dataType:"text", success: setslider});
};

function checkPlaylistProgress(){
	$.ajax({url:"playercontrolJS?action=getprogress", dataType:"text", success: setPlaylistSlider});
};

function setslider(data, textStatus, jqXHR){
	if (parseInt(currentProgress) > parseInt(data)){
		// reload playerdata/controls			
		$.ajax({url:"playercontrolJS?part=controls", dataType:"html", success: reloadplayer});		
	}
	currentProgress = data;
	$("#progress").slider( "value" , data);
	
	if ( $("#progress").length > 0 ) {
		t=setTimeout("checkProgress()",1000);
	}
}

function setPlaylistSlider(data, textStatus, jqXHR){
	if (parseInt(currentProgress) > parseInt(data)){
		// reload playerlist
		reloadplaylist();
	}
	currentProgress = data;
	$("#playlistprogress").slider( "value" , data);
	
	if ( $("#playlistprogress").length > 0 ) {
		t=setTimeout("checkPlaylistProgress()",1000);
	}
}

function playercontrol_VolumeUp() {
	$.ajax({url:"playercontrolJS?action=setvolume&value=1000", dataType:"html", success: checkVolume});	
}
  
function playercontrol_VolumeDown() {
	$.ajax({url:"playercontrolJS?action=setvolume&value=-1000", dataType:"html", success: checkVolume});
}
  
function reloadplayer(data, textStatus, jqXHR){			
	var	$currentDOM = $("#jsPlayer");			
	$currentDOM.replaceWith(data);
	initSliders();
	initVolume();
}
		
function playercontrol_playpause(){			
	$.ajax({url:"playercontrolJS?action=playpause&part=controls", dataType:"html", success: reloadplayer});
};
function playercontrol_stop(){
	$.ajax({url:"playercontrolJS?action=stop&part=controls", dataType:"html", success: reloadplayer});		
};
function playercontrol_playnext(){
	$.ajax({url:"playercontrolJS?action=next&part=controls", dataType:"html", success: reloadplayer});		
};
function playercontrol_playprevious(){
	$.ajax({url:"playercontrolJS?action=previous&part=controls", dataType:"html", success: reloadplayer});
};		

function playtitle(aID){			
	$.ajax({url:"playlistcontrolJS?id="+aID+"&action=file_playnow", dataType:"html", success: showtest});			
	function showtest(data, textStatus, jqXHR)
	{ 				
		if (data == "0") {
			alert("Playing failed. Please reload this page and try again.");
		}				
		$(".current").removeClass("current");				
		$("#js"+data).addClass("current");
	}			
};

function reloadplaylist(){	
	$.ajax({url:"playlistcontrolJS?id=-1&action=loaditem", dataType:"html", success: replacePlaylist});
	function replacePlaylist(data, textStatus, jqXHR) {			
		$("#playlist").html(data);
		initPlaylistSlider();
	};
};		


function moveup(aID){
	$.ajax({url:"playlistcontrolJS?id="+aID+"&action=file_moveup", dataType:"text", success: moveup2});		
	function moveup2(data, textStatus, jqXHR) {		
		// moveup of a Prebooklist-Item. reloading playlist is recommended
		reloadplaylist();
	}		
};

function movedown(aID){	
	$.ajax({url:"playlistcontrolJS?id="+aID+"&action=file_movedown", dataType:"text", success: movedown2});		
	function movedown2(data, textStatus, jqXHR) {		
		// movedown of a Prebooklist-Item. reloading playlist is recommended
		reloadplaylist();
	}
};

function filedelete(aID){
	$.ajax({url:"playlistcontrolJS?id="+aID+"&action=file_delete", dataType:"text", success: filedelete2});
	function filedelete2(data, textStatus, jqXHR){
		if (data == "1") {
			// delete item from DOM
			$("#js"+aID).remove();				
		} else
		{	// invalid item or prebook-delete => reload playlist
			reloadplaylist();
		}				
	}		
};

function addnext(aID){
	$.ajax({url:"playlistcontrolJS?id="+aID+"&action=file_addnext", dataType:"text", success: fileaddnext2});
	function fileaddnext2(data, textStatus, jqXHR){						
		if (data == "ok") { 
			$("#btnAddNext"+aID).html(successBtn); } 
		else {
			$("#btnAddNext"+aID).html(failBtn); }
		$("#btnAddNext"+aID).removeAttr('onclick');
		}
}

function add(aID){
	$.ajax({url:"playlistcontrolJS?id="+aID+"&action=file_add", dataType:"text", success: fileadd2});
	function fileadd2(data, textStatus, jqXHR){
		if (data == "ok") { 
			$("#btnAdd"+aID).html(successBtn); } 
		else {
			$("#btnAdd"+aID).html(failBtn); }
		$("#btnAdd"+aID).removeAttr('onclick');
	}
}

function vote(aID){	
	$.ajax({url:"playlistcontrolJS?id="+aID+"&action=file_vote", dataType:"html", success: votereply});
	
	function votereply(data, textStatus, jqXHR){
		if (data == "ok") { 
			if ( $("#playlist").length > 0 ) {reloadplaylist();}
			else // replace ID with Success-button
				{ 
				$("#btnVote"+aID).html(successBtn);
				$("#btnVote"+aID).removeAttr('onclick');
				}
			} 
		else if (data == "already voted") { alert("You can't vote for the same file that fast again."); }
		else if (data == "spam") { alert("Don't you think you liked enough files for now? - Voting not accepted."); }
		else if (data == "exception") { alert("Failure. Please reload.");}
	}
}