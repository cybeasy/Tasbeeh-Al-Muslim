<?php
require_once __DIR__ . "/config.php";
/**
 * Multi-Layer Anti-Bot & Security Engine for Tasbeeh Al Muslim API v3
 * 
 * Layers:
 * 1. IP Detection & Environment Classification
 * 2. Origin & CORS Enforcement (Domain Whitelist)
 * 3. Bad Bot & Automated Scraper Detection
 * 4. IP-Based Sliding Window Rate Limiting (60 req/min)
 */

if (!function_exists('get_client_ip')) {
    function get_client_ip(): string {
        if (!empty($_SERVER['HTTP_CF_CONNECTING_IP'])) {
            $ip = $_SERVER['HTTP_CF_CONNECTING_IP'];
        } elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
            $ips = explode(',', $_SERVER['HTTP_X_FORWARDED_FOR']);
            $ip = trim($ips[0]);
        } elseif (!empty($_SERVER['REMOTE_ADDR'])) {
            $ip = $_SERVER['REMOTE_ADDR'];
        } else {
            $ip = '127.0.0.1';
        }
        return filter_var($ip, FILTER_VALIDATE_IP) ? $ip : '127.0.0.1';
    }
}

if (!function_exists('is_local_or_cli')) {
    function is_local_or_cli(string $ip): bool {
        if (php_sapi_name() === 'cli') {
            return true;
        }
        $localPrefixes = ['127.', '10.', '192.168.', '172.16.', '172.17.', '172.18.', '172.19.', '172.20.', '172.21.', '172.22.', '172.23.', '172.24.', '172.25.', '172.26.', '172.27.', '172.28.', '172.29.', '172.30.', '172.31.', '::1'];
        foreach ($localPrefixes as $prefix) {
            if (str_starts_with($ip, $prefix)) {
                return true;
            }
        }
        return false;
    }
}

$clientIp = get_client_ip();
$isLocal = is_local_or_cli($clientIp);

// -----------------------------------------------------------------------------
// 1. CORS Policy Enforcement
// -----------------------------------------------------------------------------
$origin = $_SERVER['HTTP_ORIGIN'] ?? '';
$allowedOriginPatterns = [
    '/^https:\/\/(www\.)?cybeasy\.com$/i',
    '/^https:\/\/tasbeeh\.cybeasy\.com$/i',
    '/^http:\/\/(localhost|127\.0\.0\.1)(:[0-9]+)?$/i'
];

$isAllowedOrigin = false;
if (!empty($origin)) {
    foreach ($allowedOriginPatterns as $pattern) {
        if (preg_match($pattern, $origin)) {
            $isAllowedOrigin = true;
            break;
        }
    }

    if ($isAllowedOrigin) {
        if (!headers_sent()) {
            header("Access-Control-Allow-Origin: $origin");
            header("Vary: Origin");
        }
    } else {
        if (!$isLocal) {
            http_response_code(403);
            header("Content-Type: application/json; charset=UTF-8");
            echo json_encode([
                "status" => "error",
                "code" => 403,
                "message" => "CORS policy violation: Unauthorized origin ($origin)."
            ]);
            exit();
        }
    }
} else {
    // If no Origin header (standard for native Android/iOS apps or direct curl)
    if (!headers_sent()) {
        header("Access-Control-Allow-Origin: *");
    }
}

if (!headers_sent()) {
    header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
    header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With, Origin, Accept, X-App-Platform, X-App-Version, X-Request-Timestamp, X-Request-Signature");
    header("Access-Control-Max-Age: 86400");
}

if (isset($_SERVER["REQUEST_METHOD"]) && $_SERVER["REQUEST_METHOD"] === "OPTIONS") {
    http_response_code(200);
    exit();
}

// -----------------------------------------------------------------------------
// 2. Bad Bot & Automated Scraper Blocker
// -----------------------------------------------------------------------------
if (!$isLocal) {
    $userAgent = trim($_SERVER['HTTP_USER_AGENT'] ?? '');
    $appPlatform = trim($_SERVER['HTTP_X_APP_PLATFORM'] ?? '');

    // Reject requests with zero User-Agent and zero App Header
    if (empty($userAgent) && empty($appPlatform)) {
        http_response_code(403);
        header("Content-Type: application/json; charset=UTF-8");
        echo json_encode([
            "status" => "error",
            "code" => 403,
            "message" => "Access denied: Missing client identifier."
        ]);
        exit();
    }

    // Match known bad bot and scraping libraries unless verified app platform
    $botPattern = '/(curl|python-requests|aiohttp|scrapy|sqlmap|nikto|wpscan|go-http-client|httpclient|wget|masscan|zgrab|nmap|havij)/i';
    if (empty($appPlatform) && preg_match($botPattern, $userAgent)) {
        http_response_code(403);
        header("Content-Type: application/json; charset=UTF-8");
        echo json_encode([
            "status" => "error",
            "code" => 403,
            "message" => "Access denied: Automated scraper or bot signature detected."
        ]);
        exit();
    }
}

// -----------------------------------------------------------------------------
// 3. Sliding Window Rate Limiting (60 requests per 60 seconds per IP)
// -----------------------------------------------------------------------------
if (!$isLocal) {
    $rateLimitWindow = 60; // seconds
    $maxRequests = 60;     // maximum requests allowed in window

    $cacheFile = sys_get_temp_dir() . '/tasbeeh_rl_' . md5($clientIp) . '.json';
    $now = time();
    $timestamps = [];

    if (file_exists($cacheFile)) {
        $raw = @file_get_contents($cacheFile);
        $decoded = json_decode($raw, true);
        if (is_array($decoded)) {
            // Keep only timestamps within the sliding window
            foreach ($decoded as $ts) {
                if ($ts > ($now - $rateLimitWindow)) {
                    $timestamps[] = $ts;
                }
            }
        }
    }

    if (count($timestamps) >= $maxRequests) {
        http_response_code(429);
        header("Content-Type: application/json; charset=UTF-8");
        header("Retry-After: $rateLimitWindow");
        echo json_encode([
            "status" => "error",
            "code" => 429,
            "message" => "Too many requests. Rate limit exceeded. Please wait."
        ]);
        exit();
    }

    $timestamps[] = $now;
    @file_put_contents($cacheFile, json_encode($timestamps), LOCK_EX);
}
