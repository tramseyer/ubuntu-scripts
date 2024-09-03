#!/bin/bash -eux

cat > /etc/apparmor.d/bitbake <<-EOF
abi <abi/4.0>,
include <tunables/global>
/**/bitbake/bin/bitbake flags=(unconfined) {
    userns,
}
EOF

apparmor_parser -r /etc/apparmor.d/bitbake
aa-status | grep bitbake
