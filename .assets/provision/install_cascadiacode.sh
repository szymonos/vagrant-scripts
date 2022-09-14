#!/bin/bash
: '
.assets\provision\install_cascadiacode.sh
'

while [[ -z $REL ]]; do
  REL=$(curl -sk https://api.github.com/repos/microsoft/cascadia-code/releases/latest | grep -Po '"tag_name": *"v\K.*?(?=")')
done

echo "Install CascadiaCode v$REL"
curl -Lsk -o CascadiaCode.zip "https://github.com/microsoft/cascadia-code/releases/download/v${REL}/CascadiaCode-${REL}.zip"
unzip -q CascadiaCode.zip
mkdir -p /usr/share/fonts/cascadia-code
mv ./ttf/* /usr/share/fonts/cascadia-code/
rm -fr otf ttf woff2 CascadiaCode.zip
