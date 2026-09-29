<?php
require_once __DIR__ . "/base.php";

header("Content-Type: application/json; charset=utf-8");

$page = isset($_GET["page"]) ? (int)$_GET["page"] : 1;

if ($page > 1) {
    echo json_encode([]);
    exit();
}

$sharefooter = "\n\n" . "تم النشر بواسطة تطبيق تسبيح المسلم" . "\n\n" . "#تسبيح_المسلم";

$url = "https://mp3quran.net/api/v3/radios";
$response = curl_get_contents($url);

if ($response !== false && !empty($response)) {
    $decoded = json_decode($response, true);
    $radios = $decoded["radios"] ?? [];

    $type_open = type_open;
    $subtype_radio = subtype_radio;

    $transformed = array_map(function($radio) use ($sharefooter, $type_open, $subtype_radio) {
        $cleanLink = cleanUrl($radio["url"] ?? "");
        $name = trim($radio["name"] ?? "");
        $id = (string)($radio["id"] ?? "");
        return [
            "obj_itemid"   => $id,
            "itemId"       => $id,
            "obj_title"    => $name,
            "title"        => $name,
            "obj_share"    => $name . $sharefooter,
            "share"        => $name . $sharefooter,
            "obj_url"      => $cleanLink,
            "url"          => $cleanLink,
            "obj_shareurl" => $cleanLink,
            "shareurl"     => $cleanLink,
            "obj_free"     => "yes",
            "free"         => "yes",
            "type"         => $type_open,
            "subtype"      => $subtype_radio,
        ];
    }, $radios);

    echo json_encode($transformed, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
} else {
    echo json_encode(["status" => "error", "message" => "فشل الاتصال بمزود الإذاعات"]);
}

function cleanUrl($url) {
    $url = html_entity_decode($url, ENT_QUOTES | ENT_HTML5, "UTF-8");
    $url = stripslashes($url);
    return trim($url);
}
