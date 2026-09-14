<?php
/**
 * Global Configuration for Tasbeeh Al Muslim API v3
 */

if (!defined('APP_DOMAIN')) define('APP_DOMAIN', 'cybeasy.com');
if (!defined('APP_BASE_PATH')) define('APP_BASE_PATH', '/Tasbeeh-Al-Muslim/api/v3');
if (!defined('RATE_LIMIT_MAX_REQUESTS')) define('RATE_LIMIT_MAX_REQUESTS', 60);
if (!defined('RATE_LIMIT_WINDOW_SECONDS')) define('RATE_LIMIT_WINDOW_SECONDS', 60);

// Domain Whitelist for CORS
$GLOBALS['ALLOWED_ORIGIN_PATTERNS'] = [
    '/^https:\/\/(www\.)?cybeasy\.com$/i',
    '/^https:\/\/tasbeeh\.cybeasy\.com$/i',
    '/^http:\/\/(localhost|127\.0\.0\.1)(:[0-9]+)?$/i'
];
