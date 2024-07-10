#!/usr/bin/env bash

SERVICE_NAME="${1:-fake-service}"
SERVICE_ADDR="${2:-0.0.0.0}"
SERVICE_PORT="${3:-9090}"

FAKE_VERSION="${FAKE_VERSION:="0.25.2"}"
ARCH="$( [[ "$(uname -m)" == aarch64 ]] && echo arm64 || echo amd64)"
PLATFORM=$(uname | tr '[:upper:]' '[:lower:]')

URL="https://github.com/nicholasjackson/fake-service/releases/download/v${FAKE_VERSION}/fake_service_${PLATFORM}_${ARCH}.zip"

install_fake_svc() {
  echo "Installing nicholasjackson/fake-service v${FAKE_VERSION} binary *==> /usr/local/bin"
  wget -q "${URL}" -O /tmp/fake-service.zip
  unzip \
    -o /tmp/fake-service.zip \
    -d /tmp 1>/dev/null
  chmod a+x /tmp/fake-service
  sudo mv /tmp/fake-service /usr/local/bin/fake-service
}

install_fake_systemd() {
    local name="$1"
    local listen_addr="$2"
    local message; message="$(echo "$name" | tr '[:lower:]' '[:upper:]')"

    echo "Installing systemd unit *==> /etc/systemd/system/$name.service"
    cat <<-EOF | sudo tee /etc/systemd/system/"$name".service
[Unit]
Description="$name Service"
Documentation=https://github.com/nicholasjackson/fake-service
Requires=network-online.target
After=network-online.target

[Service]
Type=simple
Environment=SERVER_TYPE=http
Environment=LISTEN_ADDR="$listen_addr"
Environment=NAME=$name-service
Environment=MESSAGE="$message $message $message"
ExecStart=/usr/local/bin/fake-service
ExecReload=/bin/kill --signal HUP $MAINPID
KillMode=process
KillSignal=SIGTERM
RestartSec=60
LimitNOFILE=65536
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
}

if ! command -v fake-service >/dev/null 2>&1; then
  install_fake_svc
fi

install_fake_systemd "${SERVICE_NAME}" "${SERVICE_ADDR}:${SERVICE_PORT}"

echo "Running 'systemctl daemon reload'"
sudo systemctl daemon-reload

echo "Running 'systemctl enable ${SERVICE_NAME}.service"
sudo systemctl enable "${SERVICE_NAME}".service

echo "$SERVICE_NAME installation complete and running on $SERVICE_ADDR:$SERVICE_PORT"


