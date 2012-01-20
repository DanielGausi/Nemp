<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>Nemp Webserver</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=320">
	<script type="text/javascript" src="jquery.js"></script>
	<script type="text/javascript" src="jquery-ui.min.js"></script>
	<script type="text/javascript" src="nemp.js"></script>
	<link href="main.css" rel="stylesheet" type="text/css">
	<link href="jquery-ui.css" rel="stylesheet" type="text/css">	
	<script type="text/javascript">		
	
		var currentProgress=0;
		var t;
		
		$(document).ready(function() {			
			if ( $("#progress").length > 0 ) {
				$("#progress").slider({ stop: function(event, ui) { 				
					$.ajax({url:"playercontrolJS?action=setprogress&value="+ui.value, dataType:"html"});},
					animate: 1000					
					} );				
				t=setTimeout("checkProgress()",1000);
			};
			
			if ( $("#volume").length > 0 ){
				$("#volume").slider( 
						{ stop: function(event, ui){$.ajax({url:"playercontrolJS?action=setvolume&value="+ui.value, dataType:"html"});},
						  slide: function(event, ui){$.ajax({url:"playercontrolJS?action=setvolume&value="+ui.value, dataType:"html"});}						
						} );
				checkVolume();
			}
		});
		
		function checkVolume() {
			$.ajax({url:"playercontrolJS?action=getvolume", dataType:"text", success: 
				function(data, textStatus, jqXHR){$("#volume").slider( "value" , data);}
				});				
		}
		
		function checkProgress(){
			$.ajax({url:"playercontrolJS?action=getprogress", dataType:"text", success: setslider});
		};
		
		function setslider(data, textStatus, jqXHR){
			if (currentProgress > data){
				// reload playerdata/controls
				$.ajax({url:"playercontrolJS?part=controls", dataType:"html", success: loadplayercontrols});
			}
			currentProgress = data;
			$("#progress").slider( "value" , data);
			
			if ( $("#progress").length > 0 ) {
					t=setTimeout("checkProgress()",1000);
				}
		}
		
		function loadplayercontrols(data, textStatus, jqXHR){			
			var	$currentDOM = $("#playercontrol");			
			$currentDOM.html(data);		
			$.ajax({url:"playercontrolJS?part=data", dataType:"html", success: loadplayerdata});						
		};
				
		function loadplayerdata(data, textStatus, jqXHR){			
			var	$currentDOM = $("#playerdata");
			$currentDOM.html(data);					
		};
				
		function playercontrol_playpause(){			
			$.ajax({url:"playercontrolJS?action=playpause&part=controls", dataType:"html", success: loadplayercontrols});					
		};
		function playercontrol_stop(){
			$.ajax({url:"playercontrolJS?action=stop&part=controls", dataType:"html", success: loadplayercontrols});		
		};
		function playercontrol_playnext(){
			$.ajax({url:"playercontrolJS?action=next&part=controls", dataType:"html", success: loadplayercontrols});		
		};
		function playercontrol_playprevious(){
			$.ajax({url:"playercontrolJS?action=previous&part=controls", dataType:"html", success: loadplayercontrols});		
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
			// alert("lade playlist neu");
			//document.location.reload(true);
			// document.location="playlist";
			$.ajax({url:"playlistcontrolJS?id=-1&action=loaditem", dataType:"html", success: replacePlaylist});
		};		
		function replacePlaylist(data, textStatus, jqXHR) {			
			$("#playlist").html(data);			
		};
		
		function moveup(aID){
			var $newHtml1;
			var $newHtml2;
		
			$.ajax({url:"playlistcontrolJS?id="+aID+"&action=file_moveupcheck", dataType:"text", success: moveup2});
				
			function moveup2(data, textStatus, jqXHR) {		
				
				function moveup3(data, textStatus, jqXHR) {
					// store data ...
					$newHtml1 = data;
					// ... and load second element
					$.ajax({url:"playlistcontrolJS?id="+$domID.substr(2)+"&action=loaditem", dataType:"text", success: moveup4});					
				}
				
				function moveup4(data, textStatus, jqXHR) {
					$newHtml2 = data;					
					// both new parts are loaded - swap them
					var	$currentDOM = $("#js"+aID);
					var	$prevDOM = $("#js"+aID).prev();					
					$currentDOM[0].outerHTML = $newHtml2;
					$prevDOM[0].outerHTML = $newHtml1;
				}
			
				if (data == "-1") {
					// moveup of a Prebooklist-Item. reloading playlist is recommended
					reloadplaylist();
				} else
				{
				if (data == "-2") {
					// moveup of first item, no further action required
					alert("Item ist schon ganz oben");					
				} else
				{
					// check, whether previous element in NEMP has the same ID as the
					// previous element in DOM
					var $domID = $("#js"+aID).prev().attr("id");
					var $nempID = "js"+data;
					
					if ($domID == $nempID) {
						// load first new element
						$.ajax({url:"playlistcontrolJS?id="+aID+"&action=loaditem", dataType:"text", success: moveup3});
					}
					else {
						//alert("reload");					
						reloadplaylist();						
					}
				}}
			}
			
		};
		
		
		
		function movedown(aID){
			var $newHtml1;
			var $newHtml2;
		
			$.ajax({url:"playlistcontrolJS?id="+aID+"&action=file_movedowncheck", dataType:"text", success: movedown2});
				
			function movedown2(data, textStatus, jqXHR) {		
				
				function movedown3(data, textStatus, jqXHR) {
					// store data ...
					$newHtml1 = data;
					// ... and load second element
					$.ajax({url:"playlistcontrolJS?id="+$domID.substr(2)+"&action=loaditem", dataType:"text", success: movedown4});					
				}
				
				function movedown4(data, textStatus, jqXHR) {
					$newHtml2 = data;					
					// both new parts are loaded - swap them
					var	$currentDOM = $("#js"+aID);
					var	$prevDOM = $("#js"+aID).next();					
					$currentDOM[0].outerHTML = $newHtml2;
					$prevDOM[0].outerHTML = $newHtml1;
				}
			
				if (data == "-1") {
					// movedown of a Prebooklist-Item. reloading playlist is recommended
					reloadplaylist();
				} else
				{
				if (data == "-2") {
					// movedown of lasst item, no further action required
					alert("Item ist schon ganz unten");					
				} else
				{
					// check, whether previous element in NEMP has the same ID as the
					// previous element in DOM
					var $domID = $("#js"+aID).next().attr("id");
					var $nempID = "js"+data;
					
					if ($domID == $nempID) {
						// load first new element
						$.ajax({url:"playlistcontrolJS?id="+aID+"&action=loaditem", dataType:"text", success: movedown3});
					}
					else {
						//alert("reload");					
						reloadplaylist();
					}
				}}
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
					$("#btnAddNext"+aID)[0].outerHTML = data;
				}
		}
		
		function add(aID){
			$.ajax({url:"playlistcontrolJS?id="+aID+"&action=file_add", dataType:"text", success: fileadd2});
			function fileadd2(data, textStatus, jqXHR){
				$("#btnAdd"+aID)[0].outerHTML = data;
			}
		};
		
		
	</script>
	
</head>
<body>
<h1> DAS IST DER ADMIN BEREICH</h1>
{{Content}}
</body> 
</html>