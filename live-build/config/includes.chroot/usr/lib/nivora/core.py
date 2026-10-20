#!/usr/bin/env python3
"""Nivora Core 0.1: intentionally tiny, local, and read-only."""

import json
import os
import signal
import socket
from pathlib import Path

SOCKET_PATH = Path("/run/nivora/core.sock")
VERSION = "0.1.0-alpha"

PERMISSIONS = {
    "read": True,
    "propose": False,
    "execute": False,
}

running = True


def handle_request(request):
    action = str(request.get("action", "status"))

    if action == "ping":
        return {"ok": True, "reply": "pong", "version": VERSION}

    if action == "permissions":
        return {
            "ok": True,
            "permissions": PERMISSIONS,
            "note": "Execution is disabled in Nivora 0.1.",
        }

    if action == "status":
        return {
            "ok": True,
            "name": "Nivora Core",
            "version": VERSION,
            "ai_provider": "disabled",
            "cloud_enabled": False,
            "permissions": PERMISSIONS,
        }

    return {
        "ok": False,
        "error": "unsupported_action",
        "message": f"Nivora Core 0.1 does not support '{action}'.",
    }


def stop(_signum, _frame):
    global running
    running = False


def main():
    signal.signal(signal.SIGTERM, stop)
    signal.signal(signal.SIGINT, stop)

    SOCKET_PATH.parent.mkdir(parents=True, exist_ok=True)
    try:
        SOCKET_PATH.unlink()
    except FileNotFoundError:
        pass

    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as server:
        server.bind(str(SOCKET_PATH))
        os.chmod(SOCKET_PATH, 0o666)
        server.listen(8)
        server.settimeout(1.0)

        while running:
            try:
                connection, _ = server.accept()
            except TimeoutError:
                continue

            with connection:
                try:
                    payload = connection.recv(65536)
                    request = json.loads(payload.decode("utf-8") or "{}")
                    response = handle_request(request)
                except Exception as exc:
                    response = {
                        "ok": False,
                        "error": "bad_request",
                        "message": str(exc),
                    }

                connection.sendall((json.dumps(response) + "\n").encode("utf-8"))

    try:
        SOCKET_PATH.unlink()
    except FileNotFoundError:
        pass


if __name__ == "__main__":
    main()
