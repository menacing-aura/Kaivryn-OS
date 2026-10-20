# Nivora OS

**Nivora OS** is an experimental AI-native Linux operating system exploring what happens when AI becomes a first-class desktop capability instead of a chatbot bolted onto the side.

Nivora is currently an independent community experiment. It is not an OpenAI product and does not ship with OpenAI credentials.

## Current milestone: 0.1 Alpha

The first milestone focuses on making Nivora a real, bootable operating system:

- Debian 13 (Trixie) base
- KDE Plasma desktop
- Hybrid live ISO for x86_64 PCs
- Nivora branding and default desktop
- `nivora-core`, a local sandboxed system service
- `nivora` command-line client
- GitHub Actions ISO builds

The AI layer starts in **read-only / local status mode**. Future releases will add permission-gated tools and optional cloud AI providers.

## Build an ISO

On Debian 13 or a compatible build environment:

```bash
sudo apt update
sudo apt install live-build xorriso isolinux syslinux-common grub-pc-bin grub-efi-amd64-bin mtools
sudo ./scripts/build.sh
```

The finished image is written to `dist/`.

Clean generated build files with:

```bash
sudo ./scripts/clean.sh
```

## Try Nivora Core

Inside the live system:

```bash
nivora status
nivora permissions
nivora ping
```

## Design rule

AI may **read**, **propose**, or **execute**. Execution must require an explicit permission boundary. Version 0.1 implements the foundation, not autonomous system modification.

See [docs/architecture.md](docs/architecture.md), [docs/security-model.md](docs/security-model.md), and [docs/roadmap.md](docs/roadmap.md).
