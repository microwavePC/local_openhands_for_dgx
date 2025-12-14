#!/usr/bin/env bash

# このスクリプトを DGX Spark の端末上で実行することで、コーディング支援システムの構築とか動画完了します。
set -euo pipefail

OPENHANDS_CONFIG_DIR="${PWD}/.openhands"
HOSTNAME_SHORT="$(hostname -s)"
CANDIDATE_MDNS="${HOSTNAME_SHORT}.local"

# 使えるなら .local、ダメならメインIP
if getent hosts "${CANDIDATE_MDNS}" >/dev/null 2>&1; then
  PUBLIC_HOST_DEFAULT="${CANDIDATE_MDNS}"
else
  # デフォルト経路の送信元IPを採用（例: 192.168.x.y）
  PUBLIC_HOST_DEFAULT="$(ip route get 1.1.1.1 | awk '/src/ {print $7; exit}')"
fi

# 利用者が上書きしたい場合の逃げ道
PUBLIC_HOST="${OPENHANDS_PUBLIC_HOST:-$PUBLIC_HOST_DEFAULT}"

rm -f ./.env
cat > .env <<EOF
HOST_UID=$(id -u)
HOST_GID=$(id -g)

OPENHANDS_CONFIG_DIR=${OPENHANDS_CONFIG_DIR}

# OpenHands -> llama-server (OpenAI互換 /v1)
LLM_BASE_URL=http://llama-server:8080/v1
LLM_API_KEY=dummy-key
LLM_MODEL=devstral-small-2505

# runtime URL生成用
DOCKER_HOST_ADDR=${PUBLIC_HOST}
EOF

mkdir -p "${OPENHANDS_CONFIG_DIR}"
mkdir -p "$HOME/workspace" "$HOME/.openhands"

MODEL_DIR="$HOME/models/llm/Devstral-Small-2505"
MODEL_FILE="$MODEL_DIR/Devstral-Small-2505-Q8_0.gguf"
WORKSPACE_DIR="$HOME/workspace"
OPENHANDS_HOME_DIR="$HOME/.openhands"

#=========================================================
# STEP-1: Download LLM GGUF File (Devstral-Small-2505)
#=========================================================

mkdir -p "$MODEL_DIR" "$WORKSPACE_DIR" "$OPENHANDS_HOME_DIR"

if [[ ! -f "$MODEL_FILE" ]]; then
  tmp="${MODEL_FILE}.partial"
  wget -O "$tmp" "https://huggingface.co/unsloth/Devstral-Small-2505-GGUF/resolve/main/Devstral-Small-2505-Q8_0.gguf?download=true"
  mv "$tmp" "$MODEL_FILE"
fi

#=========================================================
# STEP-2: Launch containers
#=========================================================

# まず llama-server を起動
docker compose up -d --build llama-server

# health を待つ（ホスト側ポートで確認）
until curl -sf http://localhost:18000/health >/dev/null; do
  sleep 1
done

# その後 OpenHands を起動
export OPENHANDS_HOME="$OPENHANDS_HOME_DIR"
docker compose up -d --build openhands

#=========================================================
# STEP-3: OpenHands settubgs
#=========================================================

# TODO: ここを完成させる。