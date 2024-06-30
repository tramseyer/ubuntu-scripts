# Debloating
Helper script to cleanup fresh Ubuntu 22.04 and 24.04 servers:
```sh
wget -qO- https://raw.githubusercontent.com/tramseyer/ubuntu-scripts/master/setup.sh | bash
```
Credits to [Ubuntu 22.04 Annoyances](https://gist.github.com/jfeilbach/f4d0b19df82e04bea8f10cdd5945a4ff)
# Passmark
Helper script for getting and running Passmark without having to install dependencies on Ubuntu servers with default packages (such as the ones from Hetzner Cloud):
```sh
wget -qO- https://raw.githubusercontent.com/tramseyer/ubuntu-scripts/master/passmark.sh | bash
```
Also install dependencies (useful for Ubuntu Docker images):
```sh
wget -qO- https://raw.githubusercontent.com/tramseyer/ubuntu-scripts/master/passmark.sh | bash -s -- -i
```