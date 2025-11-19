#!/bin/sh

update_xray_core() {
    TARGETARCH="$1"
    WORKDIR="$2"
    XRAY_VERSION="$3"

    OLD_DIR=$(pwd)
    trap 'cd "$OLD_DIR"' EXIT

    echo "[$(date)] Running update_xray_core"

    case $1 in
      amd64)
          ARCH="64"
          FNAME="amd64"
          ;;
      i386)
          ARCH="32"
          FNAME="i386"
          ;;
      armv8 | arm64 | aarch64)
          ARCH="arm64-v8a"
          FNAME="arm64"
          ;;
      armv7 | arm | arm32)
          ARCH="arm32-v7a"
          FNAME="arm32"
          ;;
      armv6)
          ARCH="arm32-v6"
          FNAME="armv6"
          ;;
      *)
          ARCH="64"
          FNAME="amd64"
          ;;
    esac

    if [ ! -d "$WORKDIR" ]; then
      mkdir -p "$WORKDIR"
    fi
    cd "$WORKDIR"

    wget -q "https://github.com/XTLS/Xray-core/releases/download/${XRAY_VERSION}/Xray-linux-${ARCH}.zip"
    unzip "Xray-linux-${ARCH}.zip" -d ./xray-unzip
    cp ./xray-unzip/xray ./"xray-linux-${FNAME}"
    rm -r xray-unzip
    rm "Xray-linux-${ARCH}.zip"

    echo "[$(date)] Finished update_xray_core"
}

update_geodata() {
    WORKDIR="$1"
    OLD_DIR=$(pwd)
    trap 'cd "$OLD_DIR"' EXIT

    echo "[$(date)] Running update_geodata"

    if [ ! -d "$WORKDIR" ]; then
      mkdir -p "$WORKDIR"
    fi
    cd "$WORKDIR"

    wget -q -O geoip.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat
    echo "[$(date)] geoip.dat downloaded"
    wget -q -O geosite.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat
    echo "[$(date)] geosite.dat downloaded"
    wget -q -O geoip_IR.dat https://github.com/chocolate4u/Iran-v2ray-rules/releases/latest/download/geoip.dat
    echo "[$(date)] IR geoip.dat downloaded"
    wget -q -O geosite_IR.dat https://github.com/chocolate4u/Iran-v2ray-rules/releases/latest/download/geosite.dat
    echo "[$(date)] IR geosite.dat downloaded"
    wget -q -O geoip_RU.dat https://github.com/runetfreedom/russia-v2ray-rules-dat/releases/latest/download/geoip.dat
    echo "[$(date)] RU geoip.dat downloaded"
    wget -q -O geosite_RU.dat https://github.com/runetfreedom/russia-v2ray-rules-dat/releases/latest/download/geosite.dat
    echo "[$(date)] RU geosite.dat downloaded"

    echo "[$(date)] Finished update_geodata"
}


# --- dispatcher: call functions by name ---
cmd="$1"
shift || true

case "$cmd" in
  update_xray_core)
    # args: TARGETARCH WORKDIR XRAY_VERSION
    update_xray_core "$@"
    ;;
  update_geodata)
    # args: WORKDIR
    update_geodata "$@"
    ;;
  ""|help|-h|--help)
    echo "Usage:"
    echo "  $0 update_xray_core TARGETARCH WORKDIR XRAY_VERSION"
    echo "  $0 update_geodata WORKDIR"
    exit 1
    ;;
  *)
    echo "Unknown command: $cmd" >&2
    echo "Try: $0 help" >&2
    exit 1
    ;;
esac