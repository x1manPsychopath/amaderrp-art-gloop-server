# Security notes

- Keep `config/floodgate/key.pem` private. Anyone with it may impersonate Floodgate data.
- Keep generated management secrets, worlds, player lists, logs, and runtime JARs out of Git. The root `.gitignore` denies all files except the reviewed server-kit sources.
- Keep `online-mode=true`, Geyser `auth-type: floodgate`, and `validate-bedrock-login: true`.
- Floodgate removes the requirement for a paid Java account; it does not remove Xbox/Microsoft identity verification.
- Do not expose RCON, JMX, query, or the management server unless there is a specific authenticated network design.
- Port forwarding and Windows Firewall changes are intentionally outside this repository and must be reviewed separately.

