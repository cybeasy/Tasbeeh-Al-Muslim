<?php
require_once __DIR__ . "/base.php";

header("Content-Type: application/json; charset=utf-8");

if (!function_exists("GetTafsirList")) {
    function GetTafsirList($arr, $baseUrl)
    {
        $info = [];
        foreach ($arr as $item) {
            $id = (string)($item["id"] ?? "");
            $name = trim($item["name"] ?? "");
            $url = trim($item["url"] ?? "");

            $temp = [
                "obj_itemid"      => $id,
                "itemId"          => $id,
                "obj_title"       => $name,
                "title"           => $name,
                "obj_free"        => "yes",
                "free"            => "yes",
                "type"            => type_open,
                "subtype"         => subtype_sound,
                "obj_description" => "",
                "description"     => "",
                "obj_url"         => $url,
                "url"             => $url,
            ];
            $info[] = $temp;
        }

        echo json_encode($info, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    }
}

if (!function_exists("GetList")) {
    function GetList($arr, $baseUrl)
    {
        $info = [];
        foreach ($arr as $item) {
            $id = (string)($item["id"] ?? "");
            $name = trim($item["name"] ?? "");
            $targetUrl = $baseUrl . "/mp3Quran_tafser.php?tafsir=" . urlencode($id) . "&language=ar";

            $temp = [
                "obj_itemid"      => $id,
                "itemId"          => $id,
                "obj_title"       => $name,
                "title"           => $name,
                "obj_free"        => "yes",
                "free"            => "yes",
                "type"            => type_open,
                "subtype"         => subtype_list,
                "obj_description" => "",
                "description"     => "",
                "obj_url"         => $targetUrl,
                "url"             => $targetUrl,
            ];
            $info[] = $temp;
        }

        echo json_encode($info, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    }
}

$tafsir = $_GET["tafsir"] ?? "";
$parm = "";
if (!empty($tafsir)) {
    $parm = "&tafsir=" . urlencode($tafsir);
    $url = "https://mp3quran.net/api/v3/tafsir?language=ar" . $parm;
    $string = curl_get_contents($url);
    $json_a = json_decode($string, true);
    $dic = $json_a["tafasir"] ?? [];
    $arr = $dic["soar"] ?? [];
    GetTafsirList($arr, $baseUrl);
} else {
    $url = "https://mp3quran.net/api/v3/tafasir?language=ar";
    $string = curl_get_contents($url);
    $json_a = json_decode($string, true);
    $arr = $json_a["tafasir"] ?? [];
    GetList($arr, $baseUrl);
}
