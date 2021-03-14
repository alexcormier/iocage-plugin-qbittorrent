#!/bin/sh

. /root/vars

# make sure qBittorrent only uses the wireguard interface
sed -i '' 's/^Connection\\Interface=.*$/Connection\\Interface='${WG_IFACE}'/' "${CONFIG}"
sed -i '' 's/^Connection\\InterfaceName=.*$/Connection\\InterfaceName=Wireguard/' "${CONFIG}"

sysrc wireguard_enable="YES"
sysrc wireguard_interfaces="${WG_IFACE}"

sysrc qbittorrent_enable="YES"

/usr/local/bin/plugin start

echo "Default credentials: admin/adminadmin" >> /root/PLUGIN_INFO
echo "Place your wireguard config at ${wireguard_config}" >> /root/PLUGIN_INFO
