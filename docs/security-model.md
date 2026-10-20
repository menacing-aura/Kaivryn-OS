# Security Model

Nivora is an experiment, but the permission boundary is not optional.

## Principles

- Nivora must work without an AI provider.
- No API keys or user secrets belong in the repository or ISO.
- Language-model output is untrusted input.
- The model does not get unrestricted shell or root access.
- Read access and write access are separate capabilities.
- Destructive or privileged operations require explicit user approval.
- Proposed actions should be inspectable before execution.
- Tools should expose narrow operations rather than a universal "run anything" interface.

## 0.1 implementation

The initial `nivora-core` daemon:

- accepts local Unix-socket requests only;
- has no Internet access requirement;
- exposes status information only;
- runs with systemd hardening;
- cannot execute arbitrary commands through its protocol.

This is intentionally small. A safe empty capability is better than an impressive root-shaped security hole.

## Future work

Before enabling system-changing AI tools, Nivora needs:

- a capability manifest;
- per-tool authorization;
- visible approval prompts;
- audit logging;
- secret storage integration;
- revocation controls;
- tests for prompt-injection boundaries.
