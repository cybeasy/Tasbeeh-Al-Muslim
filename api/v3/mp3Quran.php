<?php
header('Content-Type: application/json');

$root = realpath($_SERVER["DOCUMENT_ROOT"]);
include "$root/APPS/constants.php";
include 'base.php';

 $string = curl_get_contents($baseUrl ."/mp3Quran.json");
$json_a = json_decode($string, true);

//$json_a = json_decode(file_get_contents('mp3Quran.json'), true);

$arr = $json_a[reciters] ;
  //print_r( $arr );

  $Page = isset($_GET['page']) ? $_GET['page'] : '1';
      $id = $_GET['id'] ;

   if ($id != "") {
      GetQraa_sura($Page-1,$id,$arr,$baseUrl);
     }
     else
     {
    GetQraa($Page-1,$arr,$baseUrl);
   }
 
function GetQraa($Page,$arr,$baseUrl)
{
 $Page = $Page *10;

$info  = array();
$len = count($arr );

// echo $len;

for($i = 0; $i < $len; $i++) {
 
    $temp = array();

     $id = $arr[$i]['id'] ;
     $name = $arr[$i]['name'] ;
     $Server = $arr[$i]['Server'] ;
      $rewaya = $arr[$i]['rewaya'] ;
      $count = $arr[$i]['count'] ;
      $letter = $arr[$i]['letter'] ;
      $suras = $arr[$i]['suras'] ;

     $temp[obj_itemid]=$id;
     $temp[obj_title] =     $name ;
     //  $temp[obj_photo] = $row['photo'];
     $temp[description] =   $count .' سورة رواية  ( ' . $rewaya .' )'  ;
      // $temp[html] = $row["html"];
       $temp[obj_url] = $baseUrl . "/mp3Quran.php?id=" . $id;
       $temp[obj_free] = "yes" ;
       $temp[type]= type_open ;
       $temp[subtype]= subtype_list ;

 array_push($info, $temp);   

 }

       if (count($info) == 0 ) {
         $dictionary = array('status'=>'error','message'=>'error');
         echo json_encode($dictionary);
   }
   else if ($Page >=10) {
              $dictionary = array('status'=>'error','message'=>'error');
         echo json_encode($dictionary);
   }
   else
   {
      echo json_encode($info);

   } 
 
}


function GetQraa_sura($Page,$qid,$arr,$baseUrl)
{
 $Page =  $Page * 10;

$info  = array();
$len = count($arr );

 //echo $len;

for($i = 0; $i < $len; $i++) {
 


     $id = $arr[$i]['id'] ;
     
     if ($id == $qid ) {
     


   
     $name = $arr[$i]['name'] ;
     $Server = $arr[$i]['Server'] ;
      $rewaya = $arr[$i]['rewaya'] ;
      $count = $arr[$i]['count'] ;
      $letter = $arr[$i]['letter'] ;
      $suras = $arr[$i]['suras'] ;
   $suras_arr = explode(",",   $suras);

 $len_suras = count($suras_arr );

for($j = 0; $j < $len_suras; $j++) {

       $sura_id = $suras_arr[$j];

      $temp = array(); 
     $temp[obj_itemid]=$sura_id;
    
    $surainfo = GetSura( $sura_id,$baseUrl);
    
    $tit = $surainfo['name'];
    $countaya = $surainfo['countaya'];
    
     $temp[obj_title] = 'سورة ' . $tit;
    $temp[description] =  $countaya . '  آية' ;
    
     if (strlen($sura_id) ==1) {
        $sura_id = "00" . $sura_id;
     }
     else if  (strlen($sura_id) ==2)  {
        $sura_id = "0" . $sura_id;
     }
       $temp[obj_url] =   $Server . '/'. $sura_id . ".mp3";
       $temp[obj_free] = "yes" ;
       $temp[type]= type_open ;
       $temp[subtype]= subtype_sound ;
       $temp[obj_share] = 'القرآن الكريم بصوت ' . $name  . ' ما تييسر من سوره ' . $tit . "\n\n" . 'تم النشر بواسطه تطبيق تسبيح المسلم ' . "\n\n". "#تسبيح_المسلم";
       $temp[obj_shareurl] =  $temp[obj_url] ;
    
      array_push($info, $temp);  
}


  break;
     }

 }

  //  echo json_encode($info);

     if (count($info) == 0 ) {
          $dictionary = array('status'=>'error','message'=>'error');
          echo json_encode($dictionary);
    }
    else if ($Page >=10) {
               $dictionary = array('status'=>'error','message'=>'error');
          echo json_encode($dictionary);
    }
    else
    {
       echo json_encode($info);

    } 
 
}

function GetSura($suraid,$baseUrl)
{
      $string = curl_get_contents($baseUrl . "/suranames.json");
     $suranames = json_decode($string, true);
      $len = count($suranames );

for($j = 0; $j < $len; $j++) {

     $sura_id = $suranames[$j]["id"];
     $name = $suranames[$j]["sn"];
     $countaya =$suranames[$j]["countaya"];
     
     if ($suraid == $sura_id) {
        return array('sura_id' => $sura_id,  'name' => $name, 'countaya' => $countaya);

  break;
     }
      
}

}



function curl_get_contents($url)
{
  $ch = curl_init($url);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
  curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
  curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
  $data = curl_exec($ch);
  curl_close($ch);
  return $data;
}


 