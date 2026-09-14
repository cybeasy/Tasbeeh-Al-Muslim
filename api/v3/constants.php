<?php
/**
 * Global Constants & Security configuration for Tasbeeh Al Muslim API v3
 * Domain: cybeasy.com/Tasbeeh-Al-Muslim/api/v3
 */

// 1. Enforce Multi-Layer Anti-Bot & CORS Security
require_once __DIR__ . "/security.php";

// 2. ApiType Constants
if (!defined("type_open")) define("type_open", "open");
if (!defined("type_email")) define("type_email", "Open_email");
if (!defined("type_list")) define("type_list", "Open_list");
if (!defined("type_radio")) define("type_radio", "Open_radio");
if (!defined("type_radio_list")) define("type_radio_list", "Open_radio_list");
if (!defined("type_share")) define("type_share", "Open_share");
if (!defined("type_sound")) define("type_sound", "Open_sound");
if (!defined("type_url")) define("type_url", "Open_url");
if (!defined("type_view")) define("type_view", "Open_view");
if (!defined("type_header")) define("type_header", "Open_header");

// 3. ApiSubType Direct Constants
if (!defined("Open_url")) define("Open_url", "Open_url");
if (!defined("Open_list")) define("Open_list", "Open_list");
if (!defined("Open_view")) define("Open_view", "Open_view");
if (!defined("Open_radio")) define("Open_radio", "Open_radio");
if (!defined("Open_radio_list")) define("Open_radio_list", "Open_radio_list");
if (!defined("Open_sound")) define("Open_sound", "Open_sound");
if (!defined("Open_share")) define("Open_share", "Open_share");
if (!defined("Open_email")) define("Open_email", "Open_email");
if (!defined("Open_buy")) define("Open_buy", "Open_buy");

// 4. SubType Aliases
if (!defined("subtype_list")) define("subtype_list", "Open_list");
if (!defined("subtype_view")) define("subtype_view", "Open_view");
if (!defined("subtype_sound")) define("subtype_sound", "Open_sound");
if (!defined("subtype_radio")) define("subtype_radio", "Open_radio");
if (!defined("subtype_radio_list")) define("subtype_radio_list", "Open_radio_list");
if (!defined("subtype_url")) define("subtype_url", "Open_url");
if (!defined("subtype_email")) define("subtype_email", "Open_email");
if (!defined("subtype_share")) define("subtype_share", "Open_share");

// 5. Shared Utility Functions
if (!function_exists("curl_get_contents")) {
    function curl_get_contents($url) {
        $ch = curl_init($url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
        curl_setopt($ch, CURLOPT_TIMEOUT, 15);
        $data = curl_exec($ch);
        curl_close($ch);
        return $data;
    }
}

if (!function_exists("clean_repeated_text")) {
    function clean_repeated_text($text) {
        $parts = preg_split("/\\s*[-–—]\\s*/u", $text);
        if (count($parts) == 2 && trim($parts[0]) == trim($parts[1])) {
            return trim($parts[0]);
        }
        return $text;
    }
}
