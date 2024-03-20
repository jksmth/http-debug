# HTTP Debug - Docker Image

A simple HTTP server that prints out the request headers.

The container runs a Python HTTP server that listens on port 8000. When a request is received, the server prints out the request headers.

The entrypoint is wrapped in the `tini` init system, runs as a non-root user, on unprivileged ports by default.

# Usage

## Docker Run

By default, the server listens on port 8000.

Run the container with the following command:
```none
$ docker run --rm -it -p8000:8000 jksmth/http-debug:latest
```

# Curl Example

Use `curl` to send a request to the server:
```none
$ curl -H "x-test-header: foo" localhost:8000

Server: SimpleHTTP/0.6 Python/3.11.8
Date: Wed, 20 Mar 2024 12:22:43 GMT
Host: localhost:8000
User-Agent: curl/8.1.2
Accept: */*
x-test-header: foo
```