<?php
require_once __DIR__ . "/config.php";
require_once __DIR__ . "/constants.php";

$protocol = (!empty($_SERVER["HTTPS"]) && $_SERVER["HTTPS"] !== "off" || (isset($_SERVER["HTTP_X_FORWARDED_PROTO"]) && $_SERVER["HTTP_X_FORWARDED_PROTO"] === "https")) ? "https" : "http";
$host = $_SERVER["HTTP_HOST"] ?? "cybeasy.com";

// Dynamically resolve directory path (e.g. /Tasbeeh-Al-Muslim/api/v3 or /api/v3)
if (isset($_SERVER["SCRIPT_NAME"])) {
    $dir = rtrim(dirname($_SERVER["SCRIPT_NAME"]), '/\\');
} else {
    $dir = "/Tasbeeh-Al-Muslim/api/v3";
}

$baseUrl = "$protocol://$host$dir";
