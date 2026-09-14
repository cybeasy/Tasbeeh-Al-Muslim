<?php
$root = realpath($_SERVER["DOCUMENT_ROOT"]);

include "$root/APPS/gsdk/connection/connection.php";
include "$root/APPS/constants.php";
 
    $Page = isset($_GET['page']) ? $_GET['page'] : '1';
      $id = $_GET['id'] ;
     $categid =  isset($_GET['categid']) ? $_GET['categid'] : '';

    $connection = new createConnection("tsbeh"); 
     
       if ($id != "") {
       GetRowByid($id);
     }
     else
     {
     GetListByPage($Page-1,$categid);
}


     $connection->closeConnection();

function GetListByPage($Page , $categid){
      $Page = $Page *10;
      $sql = "select DISTINCT categid, categ from azkar_elyome    ";
       
       if ($categid <> "") {
               $sql = "select * from azkar_elyome where categid=$categid  ORDER BY id ASC  limit $Page,10";
       }
       else
       {

        if ($Page >= 10) {
                   $Page = '-1';
        }

       }

        //execute the SQL query and return records
        $result = mysql_query( $sql);
    
       //$rows = mysql_fetch_array($result);
      
       
       $info  = array();
       
   while($row = mysql_fetch_array($result, MYSQL_ASSOC))  
    {      
        $temp = array();
       
       // Data
       $temp[obj_itemid]=$row['categid'];
    

     //  $temp[obj_photo] = $row['photo'];
       //$temp[description] = $row["description"];
      // $temp[html] = $row["html"];
        if ($categid <> "") {
                 $temp[subtype]= subtype_view ;
                 $temp[obj_title] =  $row['title'];
                 $temp[obj_url] =  "http://api.4topapps.com/APPS/tsbeh/v2/azkar_elyome.php?id=" . $row['id'];
        }
        else
        {
                 $temp[subtype]= subtype_list ;
                 $temp[obj_title] =  $row['categ'];
              $temp[obj_url] =  "http://api.4topapps.com/APPS/tsbeh/v2/azkar_elyome.php?categid=" . $row['categid'];   
        }

       $temp[obj_free] = "yes" ;
       $temp[type]= type_open ;


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
   
 

      if (count($info) == 0   ) {
         $dictionary = array('status'=>'error','message'=>'error');
         echo json_encode($dictionary);
   }
   else if(   $Page == '-1')
   {
         $dictionary = array('status'=>'error','message'=>'error');
         echo json_encode($dictionary);
   }
   else
   {
      echo json_encode($info);

   }
 
}

function GetRowByid($qid){
        
             $sql = "select * from azkar_elyome where id=$qid   ";
      
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
        $temp[obj_html] =  $row['title']; //$row["html"];
    $temp[obj_html] = "<body dir = 'rtl'>" . $temp[obj_html] . "</body>" ;
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

