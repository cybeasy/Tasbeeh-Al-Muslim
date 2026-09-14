<?php
require_once __DIR__ . "/base.php";

header("Content-Type: application/json; charset=utf-8");

if (!function_exists("GetMoshafList")) {
    function GetMoshafList($Page, $qid, $arr, $baseUrl)
    {
        $info = [];
        foreach ($arr as $reciter) {
            if ((string)($reciter["id"] ?? "") === (string)$qid) {
                $moshafs = $reciter["moshaf"] ?? [];
                $reciter_name = trim($reciter["name"] ?? "");

                foreach ($moshafs as $moshaf) {
                    $surah_total = $moshaf["surah_total"] ?? 0;
                    $moshaf_id = $moshaf["id"] ?? "";
                    $moshaf_title = clean_repeated_text($moshaf["name"] ?? "") . " بصوت " . $reciter_name;
                    $url = $baseUrl . "/mp3Quran_ver2.php?id=" . urlencode($qid) . "&moshaf_id=" . urlencode($moshaf_id);

                    $temp = [
                        "obj_itemid"      => (string)$moshaf_id,
                        "itemId"          => (string)$moshaf_id,
                        "description"     => "سورة ( " . $surah_total . " )",
                        "obj_description" => "سورة ( " . $surah_total . " )",
                        "obj_title"       => $moshaf_title,
                        "title"           => $moshaf_title,
                        "obj_url"         => $url,
                        "url"             => $url,
                        "obj_free"        => "yes",
                        "free"            => "yes",
                        "type"            => type_open,
                        "subtype"         => subtype_list,
                    ];
                    $info[] = $temp;
                }
                break;
            }
        }

        if (empty($info) || $Page >= 10) {
            echo json_encode([]);
        } else {
            echo json_encode($info, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
        }
    }
}

if (!function_exists("GetQraa_sura_with_moshaf")) {
    function GetQraa_sura_with_moshaf($Page, $qid, $moshaf_id, $arr, $baseUrl)
    {
        $info = [];
        foreach ($arr as $reciter) {
            if ((string)($reciter["id"] ?? "") === (string)$qid) {
                $name = trim($reciter["name"] ?? "");
                foreach ($reciter["moshaf"] as $moshaf) {
                    if ((string)($moshaf["id"] ?? "") === (string)$moshaf_id) {
                        $server = rtrim($moshaf["server"] ?? "", "/") . "/";
                        $suras = explode(",", $moshaf["surah_list"] ?? "");

                        foreach ($suras as $sura_id) {
                            $sura_id = trim($sura_id);
                            if (empty($sura_id)) continue;

                            $surainfo = GetSura($sura_id, $baseUrl);
                            $tit = $surainfo["name"];
                            $countaya = $surainfo["countaya"];
                            $sura_mp3 = str_pad($sura_id, 3, "0", STR_PAD_LEFT) . ".mp3";
                            $audio_url = $server . $sura_mp3;
                            $share_text = "القرآن الكريم بصوت " . $name . " ما تيسر من سورة " . $tit . "\n\n" . "تم النشر بواسطة تطبيق تسبيح المسلم" . "\n\n" . "#تسبيح_المسلم";

                            $temp = [
                                "obj_itemid"      => (string)$sura_id,
                                "itemId"          => (string)$sura_id,
                                "obj_title"       => "سورة " . $tit,
                                "title"           => "سورة " . $tit,
                                "obj_description" => $countaya . " آية",
                                "description"     => $countaya . " آية",
                                "obj_url"         => $audio_url,
                                "url"             => $audio_url,
                                "obj_free"        => "yes",
                                "free"            => "yes",
                                "type"            => type_open,
                                "subtype"         => subtype_sound,
                                "obj_share"       => $share_text,
                                "share"           => $share_text,
                                "obj_shareurl"    => $audio_url,
                                "shareurl"        => $audio_url,
                            ];
                            $info[] = $temp;
                        }
                        break 2;
                    }
                }
            }
        }

        if (empty($info) || $Page >= 10) {
            echo json_encode([]);
        } else {
            echo json_encode($info, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
        }
    }
}

if (!function_exists("GetQraa")) {
    function GetQraa($Page, $arr, $baseUrl)
    {
        $info = [];
        foreach ($arr as $reciter) {
            $id = (string)($reciter["id"] ?? "");
            $name = trim($reciter["name"] ?? "");
            $moshafs = $reciter["moshaf"] ?? [];
            $moshaf_count = count($moshafs);
            if ($moshaf_count === 0) continue;

            $moshaf = $moshafs[0];
            $rewaya = trim($moshaf["name"] ?? "");
            $count = $moshaf["surah_total"] ?? 0;

            if ($moshaf_count === 1) {
                $url = $baseUrl . "/mp3Quran_ver2.php?id=" . urlencode($id) . "&moshaf_id=" . urlencode($moshaf["id"] ?? "");
                $desc = $count . " سورة ( رواية " . $rewaya . " )";
            } else {
                $url = $baseUrl . "/mp3Quran_ver2.php?moshaf_id=" . urlencode($id);
                $desc = "( " . $moshaf_count . " ) مصحف";
            }

            $temp = [
                "obj_itemid"      => $id,
                "itemId"          => $id,
                "obj_title"       => $name,
                "title"           => $name,
                "obj_free"        => "yes",
                "free"            => "yes",
                "type"            => type_open,
                "subtype"         => subtype_list,
                "moshafs"         => $moshaf_count,
                "obj_url"         => $url,
                "url"             => $url,
                "obj_description" => $desc,
                "description"     => $desc,
            ];
            $info[] = $temp;
        }

        if (empty($info) || $Page >= 10) {
            echo json_encode([]);
        } else {
            echo json_encode($info, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
        }
    }
}

if (!function_exists("GetSura")) {
    function GetSura($suraid, $baseUrl)
    {
        static $suranames = null;
        if ($suranames === null) {
            $localFile = __DIR__ . "/suranames.json";
            if (file_exists($localFile)) {
                $content = file_get_contents($localFile);
            } else {
                $content = curl_get_contents($baseUrl . "/suranames.json");
            }
            $suranames = json_decode($content, true) ?: [];
        }

        foreach ($suranames as $item) {
            if ((string)($item["id"] ?? "") === (string)$suraid) {
                return [
                    "sura_id"  => $item["id"],
                    "name"     => $item["sn"] ?? (string)$suraid,
                    "countaya" => $item["countaya"] ?? 0,
                ];
            }
        }

        return [
            "sura_id"  => $suraid,
            "name"     => (string)$suraid,
            "countaya" => 0,
        ];
    }
}

// Request processing
$Page = isset($_GET["page"]) ? (int)$_GET["page"] : 1;
$id = $_GET["id"] ?? "";
$moshaf_id = $_GET["moshaf_id"] ?? "";
$parm = "";

if (!empty($moshaf_id)) {
    $parm = "&reciter=" . urlencode($moshaf_id);
}

$url = "https://www.mp3quran.net/api/v3/reciters?language=ar" . $parm;
$string = curl_get_contents($url);
$json_a = json_decode($string, true);
$arr = $json_a["reciters"] ?? [];

if (!empty($id) && !empty($moshaf_id)) {
    GetQraa_sura_with_moshaf($Page - 1, $id, $moshaf_id, $arr, $baseUrl);
} elseif (!empty($moshaf_id)) {
    GetMoshafList($Page - 1, $moshaf_id, $arr, $baseUrl);
} else {
    GetQraa($Page - 1, $arr, $baseUrl);
}
