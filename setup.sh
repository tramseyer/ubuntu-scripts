#!/bin/bash -eux
export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get install -y byobu htop update-notifier-common btop nmon slurm
apt-get autoremove -y && apt-get purge -y $(dpkg --list |grep '^rc' |awk '{print $2}') && purge-old-kernels -y && apt-get update || true && apt-get upgrade -y && apt-get dist-upgrade -y

# https://gist.github.com/jfeilbach/f4d0b19df82e04bea8f10cdd5945a4ff

chmod -x /etc/update-motd.d/10-help-text
chmod -x /etc/update-motd.d/50-motd-news

# Expanded Security Maintenance for Applications is not enabled.
#
# 0 updates can be applied immediately.
#
# Enable ESM Apps to receive additional future security updates.
# See https://ubuntu.com/esm or run: sudo pro status
/usr/lib/update-notifier/apt_check.py --human-readable
sed -Ezi.orig \
  -e 's/(def _output_esm_service_status.outstream, have_esm_service, service_type.:\n)/\1    return\n/' \
  -e 's/(def _output_esm_package_alert.*?\n.*?\n.:\n)/\1    return\n/' \
  /usr/lib/update-notifier/apt_check.py
/usr/lib/update-notifier/apt_check.py --human-readable
/usr/lib/update-notifier/update-motd-updates-available --force

# Get more security updates through Ubuntu Pro with 'esm-apps' enabled:
#   ...
# Learn more about Ubuntu Pro at https://ubuntu.com/pro
systemctl mask apt-news.service
systemctl mask esm-cache.service
mv /etc/apt/apt.conf.d/20apt-esm-hook.conf /etc/apt/apt.conf.d/20apt-esm-hook.conf.disabled

# News about significant security updates, features and services will
# appear here to raise awareness and perhaps tease /r/Linux ;)
# Use 'pro config set apt_news=false' to hide this and future APT news.
pro config set apt_news=false
