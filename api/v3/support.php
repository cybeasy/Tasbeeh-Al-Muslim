<?php
require_once __DIR__ . "/base.php";

header("Content-Type: application/json; charset=utf-8");

$info = [];

$temp = [
    "obj_itemid" => "1",
    "itemId"     => "1",
    "obj_title"  => "انشر التطبيق",
    "title"      => "انشر التطبيق",
    "obj_photo"  => "",
    "photo"      => "",
    "obj_url"    => "",
    "url"        => "",
    "obj_free"   => "yes",
    "free"       => "yes",
    "type"       => type_open,
    "subtype"    => subtype_share,
    "obj_share"  => "تسبيح المسلم - تطبيق يساعدك على ذكر الله",
    "share"      => "تسبيح المسلم - تطبيق يساعدك على ذكر الله",
    "obj_shareurl" => "https://cybeasy.com/Tasbeeh-Al-Muslim/app",
    "shareurl"   => "https://cybeasy.com/Tasbeeh-Al-Muslim/app",
];
$info[] = $temp;

$temp = [
    "obj_itemid" => "2",
    "itemId"     => "2",
    "obj_title"  => "ارسل الى صديق",
    "title"      => "ارسل الى صديق",
    "obj_photo"  => "",
    "photo"      => "",
    "obj_url"    => "",
    "url"        => "",
    "obj_free"   => "yes",
    "free"       => "yes",
    "type"       => type_open,
    "subtype"    => subtype_email,
    "obj_sharetitle" => "تطبيق يساعدك على ذكر الله",
    "obj_share"  => "تسبيح المسلم \n https://cybeasy.com/Tasbeeh-Al-Muslim/app",
    "obj_shareurl" => "",
];
$info[] = $temp;

$temp = [
    "obj_itemid" => "3",
    "itemId"     => "3",
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
