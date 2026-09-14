#!/usr/bin/env bash
# ==============================================================================
# Production Web Build Script for Tasbeeh Al Muslim
# Target Domain: cybeasy.com/Tasbeeh-Al-Muslim/
# Web App URL:   https://cybeasy.com/Tasbeeh-Al-Muslim/app/
# API URL:       https://cybeasy.com/Tasbeeh-Al-Muslim/api/v3/
# ==============================================================================

set -eo pipefail

GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
NC="\033[0m"

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

# Ensure Flutter and standard system binaries are in PATH
export PATH="/opt/flutter/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

# Options
APP_DIR="${PROJECT_ROOT}/app"
BASE_HREF="/Tasbeeh-Al-Muslim/app/"
SKIP_BUILD=false
TEST_API=true

usage() {
    cat << USAGE_END
Usage: $(basename "$0") [OPTIONS]

Options:
    -b, --base-href <HREF>    Base href for Flutter Web (Default: /Tasbeeh-Al-Muslim/app/)
    -s, --skip-build          Skip Flutter build step, only sync configs
    --no-test-api             Skip running API self-test
    -h, --help                Show this help message

Examples:
    # Build Flutter web into app/
    ./scripts/build_server.sh
USAGE_END
    exit 0
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -b|--base-href)
            BASE_HREF="$2"
            shift 2
            ;;
        -s|--skip-build)
            SKIP_BUILD=true
            shift
            ;;
        --no-test-api)
            TEST_API=false
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            error "Unknown option: $1"
            usage
            ;;
    esac
done

echo "===================================================================="
echo "  🚀 Tasbeeh Al Muslim Web App Build"
echo "  🌐 Domain: cybeasy.com"
echo "  📱 Target Web Directory: $APP_DIR"
echo "  🔗 Base Href:            $BASE_HREF"
echo "===================================================================="

# 1. Prerequisite Checks
info "Checking system requirements..."

if ! command -v php &>/dev/null; then
    error "PHP is not installed or not in PATH. Please install PHP 8.1+."
    exit 1
fi
PHP_VER=$(php -r "echo PHP_VERSION;")
info "Found PHP version: $PHP_VER"

if [ "$SKIP_BUILD" = false ]; then
    if ! command -v flutter &>/dev/null; then
        error "Flutter is not installed or not in PATH. Please install Flutter SDK."
        exit 1
    fi
    FLUTTER_VER=$(flutter --version 2>&1 | grep -m 1 "Flutter " || echo "Flutter Installed")
    info "Found Flutter: $FLUTTER_VER"
fi

# 2. Test API Health & Security
if [ "$TEST_API" = true ]; then
    info "Running API v3 self-tests and security checks..."
    php api/v3/api_test.php
    success "API v3 health & security verification passed!"
fi

# 3. Flutter Web Build (from code/)
if [ "$SKIP_BUILD" = false ]; then
    info "Navigating to code/ directory..."
    cd "$PROJECT_ROOT/code"

    info "Fetching Flutter dependencies (flutter pub get)..."
    flutter pub get

    info "Building Flutter Web release bundle (base-href: $BASE_HREF)..."
    flutter build web --release --base-href "$BASE_HREF" --no-tree-shake-icons
    success "Flutter Web build completed successfully!"

    cd "$PROJECT_ROOT"
else
    warn "Skipping Flutter build as requested."
fi

# 4. Populate App Directory (app/)
info "Updating $APP_DIR with release files..."
mkdir -p "$APP_DIR"

if [ -d "code/build/web" ]; then
    info "Copying Flutter Web assets into $APP_DIR..."
    cp -r code/build/web/* "$APP_DIR/"
fi

# Ensure sqlite3.wasm is in app/
if [ -f "code/web/sqlite3.wasm" ] && [ ! -f "$APP_DIR/sqlite3.wasm" ]; then
    info "Ensuring sqlite3.wasm is present in $APP_DIR..."
    cp code/web/sqlite3.wasm "$APP_DIR/sqlite3.wasm"
fi

# Generate SPA .htaccess inside app/
info "Generating SPA .htaccess inside $APP_DIR..."
cat << 'HTACCESS_APP' > "$APP_DIR/.htaccess"
<IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteBase /Tasbeeh-Al-Muslim/app/

    # Direct access to existing assets and files
    RewriteCond %{REQUEST_FILENAME} -f [OR]
    RewriteCond %{REQUEST_FILENAME} -d
    RewriteRule ^ - [L]

    # SPA Fallback: Route all subpaths to index.html
    RewriteRule ^ index.html [L]
</IfModule>

<IfModule mod_headers.c>
    # Security headers for web app
    Header set X-Content-Type-Options "nosniff"
    Header set X-Frame-Options "SAMEORIGIN"
</IfModule>

<IfModule mod_deflate.c>
    AddOutputFilterByType DEFLATE text/html text/plain text/xml text/css text/javascript application/javascript application/json application/wasm
</IfModule>
HTACCESS_APP

chmod +x "$PROJECT_ROOT/scripts/build_server.sh"
success "Web App bundle updated successfully at: $APP_DIR"

echo "===================================================================="
echo "  ✅ Web Build Completed!"
echo "  📱 Web App Folder:  $APP_DIR"
echo "  🌐 Production URLs:"
echo "     - Landing Page:  https://cybeasy.com/Tasbeeh-Al-Muslim/"
echo "     - Web App:       https://cybeasy.com/Tasbeeh-Al-Muslim/app/"
echo "     - API v3:        https://cybeasy.com/Tasbeeh-Al-Muslim/api/v3/"
echo "===================================================================="
