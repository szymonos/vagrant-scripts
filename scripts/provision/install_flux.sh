#!/bin/bash
: '
scripts/provision/install_flux.sh
'

curl -sk https://fluxcd.io/install.sh | bash
