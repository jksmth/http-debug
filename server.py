# Description: A simple HTTP server that listens on a specified port and echos back the headers of the request.
# Usage: python server.py <port>

from http.server import SimpleHTTPRequestHandler
from socketserver import TCPServer
import sys

try:
    PORT = int(sys.argv[1])
except:
    PORT = 8000

class GetHandler(SimpleHTTPRequestHandler):

    def do_GET(self):
        self.send_response(200, self.headers)
        for h in self.headers:
            self.send_header(h, self.headers[h])
        self.end_headers()


Handler = GetHandler
httpd = TCPServer(('', PORT), Handler)

httpd.serve_forever()
