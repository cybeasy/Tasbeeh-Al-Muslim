<?php
require_once __DIR__ . "/base.php";

header("Content-Type: application/json; charset=utf-8");

$info = [];

$temp = [
    "obj_itemid" => "1",
    "itemId"     => "1",
    "obj_title"  => "ليبلغن هذا الأمر ما بلغ الليل و النهار",
    "title"      => "ليبلغن هذا الأمر ما بلغ الليل و النهار",
    "obj_photo"  => $baseUrl . "/img/hqdefault.jpg",
    "photo"      => $baseUrl . "/img/hqdefault.jpg",
    "obj_url"    => $baseUrl . "/hades.php?id=3",
    "url"        => $baseUrl . "/hades.php?id=3",
    "obj_free"   => "yes",
    "free"       => "yes",
    "type"       => type_open,
    "subtype"    => subtype_view,
];
$info[] = $temp;

$temp = [
    "obj_itemid" => "4",
    "itemId"     => "4",
    "obj_title"  => "إن الله زوى ( أي جمع و ضم ) لي الأرض , فرأيت مشارقها و مغاربها",
    "title"      => "إن الله زوى ( أي جمع و ضم ) لي الأرض , فرأيت مشارقها و مغاربها",
    "obj_photo"  => $baseUrl . "/img/photo1374997048_153.jpg",
    "photo"      => $baseUrl . "/img/photo1374997048_153.jpg",
    "obj_url"    => $baseUrl . "/hades.php?id=2",
    "url"        => $baseUrl . "/hades.php?id=2",
    "obj_free"   => "yes",
    "free"       => "yes",
    "type"       => type_open,
    "subtype"    => subtype_view,
];
$info[] = $temp;

echo json_encode($info, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
