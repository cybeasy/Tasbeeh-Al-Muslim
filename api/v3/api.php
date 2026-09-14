<?php
   //include 'header.php';
 

 
   $app =  $_POST['app'];     // application name
   $wsver =  $_POST['wsver'];     // webservice Ver
   $secver =  $_POST['secver'];  // Secure code
      
   
//    if($secver == "askdfjai09384weiru0kdjha2389472073fsah8rf43")
//    {

    $mod = $_GET["mod"];
    
    if($mod == "hades"  )
    {

       include 'hades.php';
     
    }
    else if ($mod =="azkar") {
        include 'azkar.php';
    }
    else if ($mod =="menu_home") {
         include 'menu_home.php';
    }
    else if ($mod =="menu_side") {
         include 'menu_side.php';
    }
    else if ($mod =="slider") {
         include 'slider.php';
    }








     
//   }
//  else {
       
    
//       $dictionary = array(status=>error,message=>"you don't app"  );
    
//       echo json_encode($dictionary);
     
//  }

 
 
