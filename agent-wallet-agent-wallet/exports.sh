#!/bin/bash

# Agent Wallet exports.
#
# Static IP for this app's container on Umbrel's Docker network, plus optional
# wiring to a local Mempool explorer if one is installed. 10.21.21.60 is in the
# high end of the range to avoid colliding with the official apps (electrs
# 10.21.21.10, fulcrum 10.21.21.200, mempool 10.21.21.26-28, electrs-liquid
# 10.21.21.50, bip110-mempool 10.21.21.240-242).

export APP_AGENT_WALLET_IP="10.21.21.60"

# Mempool is OPTIONAL for Agent Wallet (it falls back to the public mempool.space
# API and the local indexer for fees). umbrelOS only injects the env of an app's
# *required* dependencies, so we detect an installed Mempool here (host-side) and
# point the wallet at its backend API by its known static IP — the same pattern
# the official Mempool app uses to optionally wire to Lightning. The official
# Mempool and the Mempool BIP-110 fork both serve their backend API on :8999.
installed="$("${UMBREL_ROOT}/scripts/app" ls-installed 2>/dev/null | tr ' ' '\n' || true)"
if echo "${installed}" | grep -qxF "mempool"; then
  export APP_AGENT_WALLET_MEMPOOL_API="http://10.21.21.27:8999"
elif echo "${installed}" | grep -qxF "bip110-mempool"; then
  export APP_AGENT_WALLET_MEMPOOL_API="http://10.21.21.241:8999"
fi
