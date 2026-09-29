<?php
$root = realpath($_SERVER["DOCUMENT_ROOT"]);

include "$root/APPS/gsdk/connection/connection.php";
include "$root/APPS/constants.php";
 
    $Page = isset($_GET['page']) ? $_GET['page'] : '1';
  
    $connection = new createConnection("tsbeh"); 
  
     GetazkarByPage($Page-1);
 
     $connection->closeConnection();

function GetazkarByPage($Page){
           // $Page = $Page * 10;
      $sql = "select * from azkar ORDER BY catid,id ASC    ";
      
        //execute the SQL query and return records
        $result = mysql_query( $sql);
    
       //$rows = mysql_fetch_array($result);
      
       
       $info  = array();
       $categ = '';

   while($row = mysql_fetch_array($result, MYSQL_ASSOC))  
    {      
        $temp = array();

        $temp[obj_categ] = $row['catname'];
      if ($categ == '' || $categ <> $temp[obj_categ]) {
     	$categ = $temp[obj_categ];
     	$temp[obj_title] =$categ;
     	$temp[type]= type_header ;
        array_push($info, $temp); 

          $temp = array();
      }


       // Data
       $temp[obj_itemid]=$row['id'];
       $temp[obj_title] = $row['title'];
      $temp[description] = $row["zeker_time"];
      // $temp[html] = $row["html"];
       $temp[obj_url] = "http://api.4topapps.com/APPS/tsbeh/sound/" . $row["filename"];
       $temp[obj_free] = 'yes';
       $temp[type]= type_open ;
       $temp[subtype]= subtype_view ;
       $temp["filename"] =   $row["filename"];
 
  

        array_push($info, $temp);   
        
    }
   
    if (count($info) == 0 ) {
         $dictionary = array('status'=>'error','message'=>'error');
         echo json_encode($dictionary);
   }
   else
   {
      echo json_encode($info);

   }
 
 
}
 
