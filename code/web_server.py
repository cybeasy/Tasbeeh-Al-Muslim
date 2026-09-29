#!/usr/bin/env python3
import http.server
import socketserver
import urllib.request
import urllib.parse
import urllib.error
import os
import sys

PORT = 8080
DIRECTORY = os.path.abspath("build/web")

class WebProxyHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)

    def end_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', '*')
        super().end_headers()

    def do_OPTIONS(self):
        self.send_response(200)
        self.end_headers()

    def do_GET(self):
        if self.path.startswith('/APPS/'):
            self._proxy_request('GET')
        else:
            req_path = urllib.parse.urlparse(self.path).path
            local_path = os.path.join(DIRECTORY, req_path.lstrip('/'))
            if not os.path.exists(local_path) and req_path.startswith('/assets/'):
                alt_path = os.path.join(DIRECTORY, 'assets', req_path.lstrip('/'))
                if os.path.exists(alt_path):
                    self.path = '/assets' + req_path
            super().do_GET()

    def do_POST(self):
        if self.path.startswith('/APPS/'):
            self._proxy_request('POST')
        else:
            super().do_POST()

    def _proxy_request(self, method):
        target_url = 'https://api.4topapps.com' + self.path
        body = None
        content_length = self.headers.get('Content-Length')
        if content_length:
            try:
                body = self.rfile.read(int(content_length))
            except Exception:
                body = None

        req_headers = {
            'User-Agent': self.headers.get('User-Agent', 'Mozilla/5.0 (Tasbeeh Web Proxy)'),
            'Content-Type': self.headers.get('Content-Type', 'application/json'),
            'Accept': '*/*',
        }

        try:
            req = urllib.request.Request(target_url, data=body, headers=req_headers, method=method)
            with urllib.request.urlopen(req, timeout=20) as resp:
                resp_data = resp.read()
                self.send_response(resp.status)
                self.send_header('Content-Type', resp.headers.get('Content-Type', 'application/json; charset=utf-8'))
                self.send_header('Content-Length', str(len(resp_data)))
                self.end_headers()
                self.wfile.write(resp_data)
        except urllib.error.HTTPError as e:
            err_data = e.read()
            self.send_response(e.code)
            self.send_header('Content-Type', 'application/json')
            self.send_header('Content-Length', str(len(err_data)))
            self.end_headers()
            self.wfile.write(err_data)
        except Exception as e:
            err_msg = str(e).encode('utf-8')
            self.send_response(502)
            self.send_header('Content-Type', 'text/plain')
            self.send_header('Content-Length', str(len(err_msg)))
            self.end_headers()
            self.wfile.write(err_msg)

if __name__ == '__main__':
    socketserver.TCPServer.allow_reuse_address = True
    with socketserver.TCPServer(("", PORT), WebProxyHandler) as httpd:
        print(f"Serving at http://localhost:{PORT} from {DIRECTORY}")
        httpd.serve_forever()
