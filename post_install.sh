#!/bin/sh

. /root/vars

: ${port="8080"}
: ${wireguard_config="${DEFAULT_WG_CONFIG}"}

# make sure qBittorrent only uses the wireguard interface
if [ -f "${CONFIG}" ]; then
    sed -i '' 's/^Connection\\Interface=.*$/Connection\\Interface='${WG_IFACE}'/' "${CONFIG}"
    sed -i '' 's/^Connection\\InterfaceName=.*$/Connection\\InterfaceName=Wireguard/' "${CONFIG}"
else
    mkdir -p "$(dirname "${CONFIG}")"
    cat > "${CONFIG}" <<EOF
[Preferences]
Connection\\Interface=${WG_IFACE}
Connection\\InterfaceName=Wireguard
WebUI\\Port=${port}
EOF
    chown -R qbittorrent:qbittorrent "${CONF_DIR}"
fi

sysrc wireguard_enable="YES"
sysrc wireguard_interfaces="${WG_IFACE}"

sysrc qbittorrent_enable="YES"

/usr/local/bin/plugin start

echo "Default credentials: admin/adminadmin" >> /root/PLUGIN_INFO
echo "Place your wireguard config at ${wireguard_config}" >> /root/PLUGIN_INFO
