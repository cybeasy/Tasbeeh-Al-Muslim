<?php
$root = realpath($_SERVER["DOCUMENT_ROOT"]);
 
include "$root/APPS/constants.php";

$temp = array();
        $temp[obj_itemid] = 'test';
        $temp[obj_title] = 'test';
        $temp[obj_photo] = '';
 
        $temp[obj_html] ="
             
<html>
<head>
	<title></title>
</head>
<body><script type='text/javascript' >
 var palyed =0 ;

function PlayStearm()
{
var yourElement = document.getElementById('sound');
  if(palyed ==0)
{

 yourElement.setAttribute('href', 'playstream://http://live.mp3quran.net:9944/;stream.nsv&type=mp3&volume=50&autostart=false');
 yourElement.innerHTML='Stop' ;
     
palyed =1;
}
else
{
 
 yourElement.setAttribute('href', 'stopstream://');
 yourElement.innerHTML='play' ;
palyed =0;
}
}
</script>
<h2>Test</h2>

 
<ul>
	  
	<li>Open In Safari <a href='safari://http://www.google.com'> Google.com </a></li>
	<li>Play Stream file  <a id='sound' href='#' onclick='PlayStearm()'>Stream</a></li>
	<li>Create a bulleted list...</li>
	 
</ul>
 
</body>
</html>

                
";
     
       $temp[type]= type_open ;
       $temp[subtype]= subtype_view ;
       
       
     echo json_encode($temp);