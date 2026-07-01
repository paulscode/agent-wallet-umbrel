# Agent Wallet Community App Store

An [Umbrel](https://umbrel.com) community app store for
[Agent Wallet](https://github.com/paulscode/agent-wallet) — a self-custodial
Bitcoin & Lightning wallet with an automation API for AI agents.

## Apps in this store

### Agent Wallet

A self-custodial Bitcoin and Lightning wallet that connects to your Umbrel's
**Lightning Node (LND)** and exposes a dashboard plus a programmatic API designed
for AI agents to initiate payments within configured limits. It uses your
installed Electrum indexer (Electrs **or** Fulcrum) for on-chain lookups, and an
optional Mempool explorer for fee estimates and links. It also includes a
BOLT 12 onion-message gateway and an optional, experimental Anonymize feature
(with an optional Liquid hop).

> ⚠️ Anyone holding the dashboard password or an issued API key can spend from
> the connected LND node up to its limits. Treat the dashboard password and API
> keys like cash.

The wallet bundles its own PostgreSQL, Redis, and Tor (supervised by s6-overlay)
in a single container — the same image contract as the StartOS package.

## Requirements

- **Umbrel** (umbrelOS 1.x or later)
- **Lightning Node (LND)** — required; Agent Wallet connects to it over REST.
- **Electrs** — required (the on-chain indexer). **Fulcrum** also works: it
  re-exports the same connection variables, so either indexer satisfies the app.
- **Mempool** — optional. If the official **Mempool** app or the **Mempool
  BIP-110** app is installed, Agent Wallet uses it for fee estimates **and** for
  the dashboard's explorer links (your LAN Mempool at `http://<device>.local`);
  otherwise it falls back to the public mempool.space API and explorer.

## How to add this store to your Umbrel

1. Open your Umbrel dashboard.
2. Go to **App Store**.
3. Click the ellipsis (⋯) in the upper-right, then **Community App Stores**.
4. Paste the URL of this repo:
   ```
   https://github.com/paulscode/agent-wallet-umbrel
   ```
5. Click **Add**.
6. The **Agent Wallet Community App Store** now appears under its own heading.
7. Make sure **Lightning Node** and an indexer (**Electrs** or **Fulcrum**) are
   installed, then install **Agent Wallet**.

## Using it

- Get your dashboard password: right-click the Agent Wallet tile and choose
  **Show default credentials** (or it's offered the first time you open the app).
  That value is your login.
- Open Agent Wallet from your Umbrel home screen and sign in with it.
- The wallet drives **your** LND node — back up your Umbrel and your LND seed.

### Advanced configuration

Umbrel has no per-app settings form, so feature toggles default to sensible
values (BOLT 12 on, Braiins deposits on, Anonymize off, Liquid off). To change
them, edit the `environment:` block of the `web` service in this app's
`docker-compose.yml` and restart the app:

| Variable | Default | Effect |
|----------|---------|--------|
| `AGENT_WALLET_BOLT12` | `true` | BOLT 12 onion-message gateway |
| `AGENT_WALLET_BRAIINS_DEPOSIT` | `true` | Braiins deposit tab |
| `AGENT_WALLET_ANONYMIZE` | `false` | Experimental Anonymize feature (needs Tor; bundled) |
| `AGENT_WALLET_LIQUID` | `false` | Liquid hop for Anonymize (needs the Electrs Liquid app) |
| `AGENT_WALLET_LOG_LEVEL` | `INFO` | `ERROR` / `WARN` / `INFO` / `DEBUG` / `TRACE` |

## Support

- Agent Wallet issues: https://github.com/paulscode/agent-wallet/issues
- This store: https://github.com/paulscode/agent-wallet-umbrel/issues
- Umbrel (general): https://community.umbrel.com

## License

MIT — see [LICENSE](LICENSE).

## Notes

- **Image:** the `paulscode/agent-wallet-umbrel` container image is built from the
  [agent-wallet-startos](https://github.com/paulscode/agent-wallet-startos)
  repository (`Dockerfile.umbrel`) and published multi-arch (linux/amd64 +
  linux/arm64). See [`build-umbrel-images.sh`](build-umbrel-images.sh). It pins
  the same app + gateway base images as the 0.4.6.0 StartOS release.
- **Architecture:** the arm64 build has not been hardware-tested by the author;
  please report issues if you hit any.
