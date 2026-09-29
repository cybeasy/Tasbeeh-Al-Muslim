<?php
$root = realpath($_SERVER["DOCUMENT_ROOT"]);


include "$root/APPS/gsdk/connection/connection.php";
include "$root/APPS/constants.php";
include 'base.php';

    $Page = isset($_GET['page']) ? $_GET['page'] : '1';
      $id = $_GET['id'] ;
     $categid =  isset($_GET['categid']) ? $_GET['categid'] : '';

    $connection = new createConnection("tsbeh"); 
     
       if ($id != "") {
       GetRowByid($id,$baseUrl);
     }
     else
     {
     GetListByPage($Page-1,$categid,$baseUrl);
    }


     $connection->closeConnection();

function GetListByPage($Page , $categid,$baseUrl){
      $Page = $Page *10;
      $sql = "SELECT * FROM ( select   id,h_month_number,h_month from islam_events group by h_month_number ) as temp order by h_month_number ";
       
       if ($categid <> "") {
               $sql = "select   * from islam_events where h_month_number =$categid  ORDER BY id ASC  limit $Page,10";
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

    

     //  $temp[obj_photo] = $row['photo'];
       //$temp[description] = $row["description"];
      // $temp[html] = $row["html"];
        if ($categid <> "") {
                $temp[obj_itemid]=$row['id'];
                 $temp[subtype]= subtype_view ;
                 $tit = $row['title']  ;
                 $temp[obj_title] =  $row['h_date']  ;
                 $temp[description] =$tit;
                 $temp[obj_url] =  $baseUrl . "/islam_events.php?id=" . $row['id'];
        }
        else
        {
                 $temp[obj_itemid]=$row['h_month_number'];
                 $temp[subtype]= subtype_list ;
                 $temp[obj_title] =trim( $row['h_month'] ," ") ;
              $temp[obj_url] = $baseUrl . "/islam_events.php?categid=" . $row['h_month_number'];   
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

function GetRowByid($qid,$baseUrl){
        
             $sql = "select * from islam_events where id=$qid   ";
      
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
        $temp[obj_html] =   $row["html"];
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

