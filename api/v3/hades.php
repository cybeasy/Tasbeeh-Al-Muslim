<?php
$root = realpath($_SERVER["DOCUMENT_ROOT"]);

include "$root/APPS/gsdk/connection/connection.php";
include "$root/APPS/constants.php";
include 'base.php';

    $Page = isset($_GET['page']) ? $_GET['page'] : '1';
      $id = $_GET['id'] ;

    $connection = new createConnection("tsbeh"); 
     
       if ($id != "") {
       GetHadesByid($id,$baseUrl);
     }
     else
     {
     GetHadesByPage($Page-1,$baseUrl);
}


     $connection->closeConnection();

function GetHadesByPage($Page,$baseUrl){
        $Page = $Page *10;
      $sql = "select * from hades ORDER BY id ASC  limit $Page,10   ";
      
        //execute the SQL query and return records
        $result = mysql_query( $sql);
    
       //$rows = mysql_fetch_array($result);
      
       
       $info  = array();
       
   while($row = mysql_fetch_array($result, MYSQL_ASSOC))  
    {      
        $temp = array();
       
       // Data
       $temp[obj_itemid]=$row['id'];
       
        $tit = $row['title'];
    
       $temp[obj_title] =    $tit . " ..." ;
     //  $temp[obj_photo] = $row['photo'];
       //$temp[description] = $row["description"];
      // $temp[html] = $row["html"];
       $temp[obj_url] = $baseUrl . "/hades.php?id=" . $row['id'];
       $temp[obj_free] = "yes" ;
       $temp[type]= type_open ;
       $temp[subtype]= subtype_view ;

       /*
       // Share
       $temp[share] = $row["share"];
       $temp[shareurl] = $row["shareurl"];

       // Design
       $temp[type] = $row["type"];  // categ , list , item , url , page ,open,header
       $temp[celltype] = $row["celltype"]; // one,two or three item on row for type (categ,list)

       // Action
       $temp[open] = $row["open"]; // facebook,twitter,email,safari,google+,skype,sms,share
       $temp[open_id] = $row["open_id"];  // such facebook id
       $temp[open_name] = $row["open_name"];  // socail username
*/
       

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

function GetHadesByid($qid,$baseUrl){
        
             $sql = "select * from hades where id=$qid   ";
      
        //execute the SQL query and return records
        $result = mysql_query( $sql);
    
       //$rows = mysql_fetch_array($result);
      
       
       $info  = array();
       
   while($row = mysql_fetch_array($result, MYSQL_ASSOC))  
    {      
        $temp = array();
        $temp[obj_itemid]=$row['id'];
        $temp[obj_title] = $row['title'];
        $temp[obj_photo] = (is_null($row['photo'])) ? "" : $row['photo']; 
       // $temp[description] = $row["description"];
        $temp[obj_html] = $row["html"];
    
      // $temp[obj_share] = $row['title'] . '  '. strip_tags($row["html"] )    ;

       $temp[type]= type_open ;
       $temp[subtype]= subtype_view ;
           
 

       $sharefinale =  preg_replace('/<br\s?\/?>/i', "\r\n", $row["html"]); 

     $temp[obj_share] = $row['title'] . "\n" . strip_tags($sharefinale ) . "\n\n" . 'تم النشر بواسطه تطبيق تسبيح المسلم ' . "\n\n". "#تسبيح_المسلم";
     $temp[obj_shareurl] = "https://itunes.apple.com/us/app/tsbyh-almslm/id739018955?ls=1&mt=8";
      
        array_push($info, $temp);   
        
    }
   
      echo json_encode($info);
 
   }

