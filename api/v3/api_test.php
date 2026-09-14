<?php
/**
 * Automated Self-Test Harness for Tasbeeh Al Muslim API v3
 * Runs locally via CLI or via HTTP GET
 */

require_once __DIR__ . "/base.php";

$tests = [
    "Radio Stations" => [
        "file" => "radio.php",
        "params" => [],
        "min_items" => 10,
    ],
    "Quran Reciters" => [
        "file" => "mp3Quran_ver2.php",
        "params" => [],
        "min_items" => 10,
    ],
    "Quran Moshaf for Reciter 1" => [
        "file" => "mp3Quran_ver2.php",
        "params" => ["moshaf_id" => "1"],
        "min_items" => 1,
    ],
    "Quran Surahs for Reciter 1 Moshaf 1" => [
        "file" => "mp3Quran_ver2.php",
        "params" => ["id" => "1", "moshaf_id" => "1"],
        "min_items" => 10,
    ],
    "Tafasir List" => [
        "file" => "mp3Quran_tafser.php",
        "params" => [],
        "min_items" => 1,
    ],
    "Tafsir Audio Tracks (id=1)" => [
        "file" => "mp3Quran_tafser.php",
        "params" => ["tafsir" => "1"],
        "min_items" => 1,
    ],
    "About App" => [
        "file" => "about.php",
        "params" => [],
        "min_items" => 2,
    ],
    "Home Menu" => [
        "file" => "menu_home.php",
        "params" => [],
        "min_items" => 5,
    ],
    "Slider Items" => [
        "file" => "slider.php",
        "params" => [],
        "min_items" => 1,
    ],
    "Support Items" => [
        "file" => "support.php",
        "params" => [],
        "min_items" => 1,
    ],
];

$results = [];
$allPassed = true;

foreach ($tests as $title => $test) {
    $_GET = $test["params"];
    ob_start();
    try {
        include __DIR__ . "/" . $test["file"];
        $output = ob_get_clean();
        $decoded = json_decode($output, true);
        $count = is_array($decoded) ? count($decoded) : 0;
        $passed = ($count >= $test["min_items"]);

        if (!$passed) {
            $allPassed = false;
        }

        $results[] = [
            "test" => $title,
            "file" => $test["file"],
            "status" => $passed ? "PASS" : "FAIL",
            "items_count" => $count,
            "min_required" => $test["min_items"],
            "sample" => is_array($decoded) && isset($decoded[0]) ? ($decoded[0]["title"] ?? ($decoded[0]["obj_title"] ?? "N/A")) : "No items",
        ];
    } catch (Throwable $e) {
        ob_end_clean();
        $allPassed = false;
        $results[] = [
            "test" => $title,
            "file" => $test["file"],
            "status" => "ERROR",
            "error" => $e->getMessage(),
        ];
    }
}

if (php_sapi_name() === "cli") {
    echo "=== Tasbeeh API v3 Self-Test Results ===\n";
    foreach ($results as $res) {
        $badge = $res["status"] === "PASS" ? "[[32mPASS[0m]" : "[[31m" . $res["status"] . "[0m]";
        echo sprintf("%s %-35s (Items: %d, Sample: %s)\n", $badge, $res["test"], $res["items_count"] ?? 0, $res["sample"] ?? "");
    }
    echo "========================================\n";
    if ($allPassed) {
        echo "[32mALL API V3 ENDPOINTS WORKING PERFECTLY![0m\n";
        exit(0);
    } else {
        echo "[31mSOME API V3 ENDPOINTS FAILED![0m\n";
        exit(1);
    }
} else {
    header("Content-Type: application/json; charset=utf-8");
    echo json_encode([
        "status" => $allPassed ? "success" : "failure",
        "results" => $results,
    ], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
}
