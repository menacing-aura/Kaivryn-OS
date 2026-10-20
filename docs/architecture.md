# Nivora OS Architecture

## Goal

Nivora explores an AI-native desktop while preserving a normal Linux system underneath. The machine must remain useful if every AI feature is disabled.

## Layers

```text
Applications / KDE Plasma
        |
     nivora CLI
        |
  /run/nivora/core.sock
        |
   Nivora Core
        |
 Permission boundary
        |
 Future providers and tools
        |
 Debian 13 / systemd / Linux
```

## Base system

Nivora 0.1 uses Debian 13 (Trixie) and KDE Plasma. Debian supplies the kernel, hardware support, package management, networking, and standard userspace. Nivora adds its own defaults, services, tools, and visual identity.

## Nivora Core

`nivora-core` is a small local service using a Unix socket. In 0.1 it supports only introspection commands:

- `status`
- `ping`
- `permissions`

There is no network API, AI provider, shell executor, or privileged action engine in the first version.

The service is started by systemd with hardening enabled and communicates only over `AF_UNIX`.

## Permission model

Nivora's long-term permission model has three levels:

1. **Read** - inspect information explicitly exposed to the AI layer.
2. **Propose** - prepare a change and show the user exactly what would happen.
3. **Execute** - perform an approved action through a constrained tool.

The AI model itself should never receive unrestricted root access.

## Provider model

Cloud AI is optional. Future provider adapters should live above Nivora Core and receive only the context allowed for the current request. API credentials must be user-supplied at runtime and never baked into the ISO.

## Build system

`scripts/build.sh` creates a clean live-build workspace under `.build/live`, copies the Nivora live-build profile into it, configures Debian Trixie, and produces a hybrid ISO under `dist/`.
