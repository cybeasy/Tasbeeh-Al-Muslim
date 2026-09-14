<?php
require_once __DIR__ . "/base.php";

header("Content-Type: application/json; charset=utf-8");

$info = [];

$temp = [
    "obj_itemid" => "1",
    "itemId"     => "1",
    "obj_title"  => "المشاركون فى التطبيق",
    "title"      => "المشاركون فى التطبيق",
    "obj_photo"  => "",
    "photo"      => "",
    "obj_url"    => $baseUrl . "/pages/appmaker.php",
    "url"        => $baseUrl . "/pages/appmaker.php",
    "obj_free"   => "yes",
    "free"       => "yes",
    "type"       => type_open,
    "subtype"    => Open_url,
];
$info[] = $temp;

$temp = [
    "obj_itemid" => "2",
    "itemId"     => "2",
    "obj_title"  => "موقع تسبيح المسلم",
    "title"      => "موقع تسبيح المسلم",
    "obj_photo"  => "",
    "photo"      => "",
    "obj_url"    => "https://cybeasy.com/Tasbeeh-Al-Muslim/",
    "url"        => "https://cybeasy.com/Tasbeeh-Al-Muslim/",
    "obj_free"   => "yes",
    "free"       => "yes",
    "type"       => type_open,
    "subtype"    => Open_url,
];
$info[] = $temp;

$temp = [
    "obj_itemid" => "3",
    "itemId"     => "3",
    "obj_title"  => "قيم التطبيق",
    "title"      => "قيم التطبيق",
    "obj_photo"  => "",
    "photo"      => "",
    "obj_url"    => "https://play.google.com/store/apps/details?id=com.tsbeh",
    "url"        => "https://play.google.com/store/apps/details?id=com.tsbeh",
    "obj_free"   => "yes",
    "free"       => "yes",
    "type"       => type_open,
    "subtype"    => Open_url,
];
$info[] = $temp;

$temp = [
    "obj_itemid" => "4",
    "itemId"     => "4",
    "obj_title"  => "راسلنا",
    "title"      => "راسلنا",
    "obj_photo"  => "",
    "photo"      => "",
    "obj_emailto"=> "info@cybeasy.com",
    "emailto"    => "info@cybeasy.com",
    "obj_free"   => "yes",
    "free"       => "yes",
    "type"       => type_open,
    "subtype"    => subtype_email,
    "obj_sharetitle" => "",
];
$info[] = $temp;

echo json_encode($info, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
