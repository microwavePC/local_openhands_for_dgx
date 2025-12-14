#!/usr/bin/env bash
# このスクリプトを DGX Spark の端末上で実行することで、コーディング支援システムの構築とか動画完了します。
set -euo pipefail

cat > .env <<EOF
HOST_UID=$(id -u)
HOST_GID=$(id -g)
EOF

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
export OPENHANDS_HOME="$OPENHANDS_HOME_DIR"
docker compose up -d --build

#=========================================================
# STEP-3: OpenHands settubgs
#=========================================================

# TODO: ここを完成させる。