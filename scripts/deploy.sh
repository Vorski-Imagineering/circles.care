#!/usr/bin/env bash
set -euo pipefail

REMOTE_USER="vorski"
REMOTE_HOST="162.215.121.122"
REMOTE_DIR="/public_html/circles.care"
LOCAL_DIR="$(cd "$(dirname "$0")/.." && pwd)/public"

# ── connectivity check ────────────────────────────────────────────────────────
echo "→ Checking SSH access to ${REMOTE_USER}@${REMOTE_HOST} ..."
if ! ssh -o ConnectTimeout=10 -o BatchMode=yes \
        "${REMOTE_USER}@${REMOTE_HOST}" "ls ${REMOTE_DIR}" > /dev/null 2>&1; then
  echo "✗ Cannot reach ${REMOTE_USER}@${REMOTE_HOST} or ${REMOTE_DIR} does not exist."
  echo "  Make sure your SSH key is authorised and the remote directory exists."
  exit 1
fi
echo "✓ Connected. Remote directory accessible."

# ── deploy ────────────────────────────────────────────────────────────────────
echo "→ Deploying ${LOCAL_DIR}/ → ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/"

scp -r "${LOCAL_DIR}/." "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/"

echo "✓ Deploy complete."

# ── verify ────────────────────────────────────────────────────────────────────
echo "→ Remote listing:"
ssh "${REMOTE_USER}@${REMOTE_HOST}" "ls -lh ${REMOTE_DIR}"
