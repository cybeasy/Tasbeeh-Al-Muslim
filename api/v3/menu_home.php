<?php
require_once __DIR__ . "/base.php";

header("Content-Type: application/json; charset=utf-8");

$Page = isset($_GET["page"]) ? $_GET["page"] : "1";

if ($Page !== "1") {
    echo json_encode([]);
    exit();
}

$info = [];

$temp = [
    "obj_itemid" => "RadioList",
    "itemId"     => "RadioList",
    "obj_title"  => "صوتيات",
    "title"      => "صوتيات",
    "obj_photo"  => $baseUrl . "/img/mic.png",
    "photo"      => $baseUrl . "/img/mic.png",
    "obj_url"    => $baseUrl . "/radio.php",
    "url"        => $baseUrl . "/radio.php",
    "obj_free"   => "yes",
    "free"       => "yes",
    "type"       => type_open,
    "subtype"    => subtype_radio_list,
];
$info[] = $temp;

$temp = [
    "obj_itemid" => "4",
    "itemId"     => "4",
    "obj_title"  => "القران الكريم (صوت)",
    "title"      => "القران الكريم (صوت)",
    "obj_photo"  => $baseUrl . "/img/quran.png",
    "photo"      => $baseUrl . "/img/quran.png",
    "obj_url"    => $baseUrl . "/mp3Quran_ver2.php",
    "url"        => $baseUrl . "/mp3Quran_ver2.php",
    "obj_free"   => "yes",
    "free"       => "yes",
    "type"       => type_open,
    "subtype"    => subtype_list,
];
$info[] = $temp;

$temp = [
    "obj_itemid" => "1",
    "itemId"     => "1",
    "obj_title"  => "تسبيح المسلم",
    "title"      => "تسبيح المسلم",
    "obj_photo"  => $baseUrl . "/img/zeker.png",
    "photo"      => $baseUrl . "/img/zeker.png",
    "obj_url"    => "",
    "url"        => "",
    "obj_free"   => "yes",
    "free"       => "yes",
    "type"       => type_open,
    "subtype"    => "Zeker",
];
$info[] = $temp;

$temp = [
    "obj_itemid" => "1",
    "itemId"     => "1",
    "obj_title"  => "أحاديث نبويه",
    "title"      => "أحاديث نبويه",
    "obj_photo"  => $baseUrl . "/img/hades.png",
    "photo"      => $baseUrl . "/img/hades.png",
    "obj_url"    => $baseUrl . "/hades.php",
    "url"        => $baseUrl . "/hades.php",
    "obj_free"   => "yes",
    "free"       => "yes",
    "type"       => type_open,
    "subtype"    => subtype_list,
];
$info[] = $temp;

$temp = [
    "obj_itemid" => "1",
    "itemId"     => "1",
    "obj_title"  => "دعاء من القرآن الكريم",
    "title"      => "دعاء من القرآن الكريم",
    "obj_photo"  => $baseUrl . "/img/doaa.png",
    "photo"      => $baseUrl . "/img/doaa.png",
    "obj_url"    => $baseUrl . "/doaaquran.php",
    "url"        => $baseUrl . "/doaaquran.php",
    "obj_free"   => "yes",
    "free"       => "yes",
    "type"       => type_open,
    "subtype"    => subtype_list,
];
$info[] = $temp;

$temp = [
    "obj_itemid" => "1",
    "itemId"     => "1",
    "obj_title"  => "الأوائل في الإسلام",
    "title"      => "الأوائل في الإسلام",
    "obj_photo"  => $baseUrl . "/img/first.png",
    "photo"      => $baseUrl . "/img/first.png",
    "obj_url"    => $baseUrl . "/firstinislam.php",
    "url"        => $baseUrl . "/firstinislam.php",
    "obj_free"   => "yes",
    "free"       => "yes",
    "type"       => type_open,
    "subtype"    => subtype_list,
];
$info[] = $temp;

$temp = [
    "obj_itemid" => "1",
    "itemId"     => "1",
    "obj_title"  => "أذكار اليوم و الليلة",
    "title"      => "أذكار اليوم و الليلة",
    "obj_photo"  => $baseUrl . "/img/azkar-elyome.png",
    "photo"      => $baseUrl . "/img/azkar-elyome.png",
    "obj_url"    => $baseUrl . "/azkar_elyome.php",
    "url"        => $baseUrl . "/azkar_elyome.php",
    "obj_free"   => "yes",
    "free"       => "yes",
    "type"       => type_open,
    "subtype"    => subtype_list,
];
$info[] = $temp;

$temp = [
    "obj_itemid" => "1",
    "itemId"     => "1",
    "obj_title"  => "أحداث إسلامية",
    "title"      => "أحداث إسلامية",
    "obj_photo"  => $baseUrl . "/img/events-islam.png",
    "photo"      => $baseUrl . "/img/events-islam.png",
    "obj_url"    => $baseUrl . "/islam_events.php",
    "url"        => $baseUrl . "/islam_events.php",
    "obj_free"   => "yes",
    "free"       => "yes",
    "type"       => type_open,
    "subtype"    => subtype_list,
];
$info[] = $temp;

$temp = [
    "obj_itemid" => "1",
    "itemId"     => "1",
    "obj_title"  => "تحويل التاريخ",
    "title"      => "تحويل التاريخ",
    "obj_photo"  => $baseUrl . "/img/convertdate.png",
    "photo"      => $baseUrl . "/img/convertdate.png",
    "obj_url"    => $baseUrl . "/convertdate.html",
    "url"        => $baseUrl . "/convertdate.html",
    "obj_free"   => "yes",
    "free"       => "yes",
    "type"       => type_open,
    "subtype"    => Open_url,
];
$info[] = $temp;

$temp = [
    "obj_itemid" => "1",
    "itemId"     => "1",
    "obj_title"  => "عن التطبيق",
    "title"      => "عن التطبيق",
    "obj_photo"  => $baseUrl . "/img/about.png",
    "photo"      => $baseUrl . "/img/about.png",
    "obj_url"    => $baseUrl . "/about.php",
    "url"        => $baseUrl . "/about.php",
    "obj_free"   => "yes",
    "free"       => "yes",
    "type"       => type_open,
    "subtype"    => subtype_list,
];
$info[] = $temp;

echo json_encode($info, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
