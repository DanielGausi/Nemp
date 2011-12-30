<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>Nemp Webserver</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=320">
	<script type="text/javascript" src="jquery.js"></script>
	<script type="text/javascript" src="nemp.js"></script>
	<link href="main.css" rel="stylesheet" type="text/css">
	<script>			
	
		function playtitle(aID){			
			$.ajax({url:"playlistcontrolJS?id="+aID+"&action=file_playnow", dataType:"html", success: showtest});		
			
			function showtest(data, textStatus, jqXHR)
			{ 
				$(".current").removeClass("current");				
				$("#js"+data).addClass("current");
			}
			
		};
		
		function moveup(aID){
			$.ajax({url:"playlistcontrolJS?id="+aID+"&action=file_moveupcheck", dataType:"html", success: moveup2});
				
			function moveup2(data, textStatus, jqXHR) {		
				var $current = $("#js"+aID).prev();
				
				if ($current[0].outerHTML == data) 
					{alert("gleich");}
				else
					{alert("upsi");}
				
				alert($current[0].outerHTML);
				//alert(aID);
				alert(data);
			}
			
		};
		
		
		
		
	</script>
	
</head>
<body>
{{Content}}
</body> 
</html>