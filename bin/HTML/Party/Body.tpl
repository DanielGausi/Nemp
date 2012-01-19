<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
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
				$("#progress").slider({animate: 1000, disabled: true} );				
				t=setTimeout("checkProgress()",1000);
			};
		});
		
		
		function checkProgress(){
			$.ajax({url:"playercontrolJS?action=getprogress", dataType:"text", success: setslider});
		};
		
		function setslider(data, textStatus, jqXHR){
			if (currentProgress > data){
				// reload playerdata/controls
				$.ajax({url:"playercontrolJS?part=data", dataType:"html", success: loadplayerdata});
			}
			currentProgress = data;
			$("#progress").slider( "value" , data);
			
			if ( $("#progress").length > 0 ) {
					t=setTimeout("checkProgress()",1000);
				}
		}		
				
		function loadplayerdata(data, textStatus, jqXHR){			
			var	$currentDOM = $("#playerdata");
			$currentDOM.html(data);					
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
			if ( $("#playlist").length > 0 ) {
				$.ajax({url:"playlistcontrolJS?id=-1&action=loaditem", dataType:"html", success: replacePlaylist});
			}
		};		
		function replacePlaylist(data, textStatus, jqXHR) {		
			$("#playlist").html(data);			
		};
		
		function vote(aID){
				$.ajax({url:"playlistcontrolJS?id="+aID+"&action=file_vote", dataType:"html", success: votereply});
				
				function votereply(data, textStatus, jqXHR){
					if (data == "ok") { 
						if ( $("#playlist").length > 0 ) {reloadplaylist();}
						else // replace ID with Success-button
							{ $("#btnVote"+aID)[0].outerHTML = 
							"<a class='button btnsuccess' title='Operation complete.'><img src='images/success.png' width='24' height='24' alt='operation: success' /></a>";						
							}
						} 
					else if (data == "already voted") { alert("You can't vote for the same file that fast again."); }
					else if (data == "spam") { alert("Don't you think you liked enough files for now? - Voting not accepted."); }
					else if (data == "exception") { alert("Failure. Please reload.");}
				}
		}
	</script>
	
</head>
<body>
{{Content}}
</body> 
</html>