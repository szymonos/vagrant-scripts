#!/usr/bin/env bash
: '
.assets/provision/setup_gh_repos.sh --repos "szymonos/vagrant-scripts szymonos/ps-modules" --user "szymo"
.assets/provision/setup_gh_repos.sh --repos "szymonos/vagrant-scripts szymonos/ps-modules" --user "szymo" --ws_suffix "scripts"
'
# parse named parameters
repos=${repos}
user=${user}
ws_suffix=${ws_suffix:-devops}
while [ $# -gt 0 ]; do
  if [[ $1 == *"--"* ]]; then
    param="${1/--/}"
    declare $param="$2"
  fi
  shift
done
# calculate variables
gh_repos=($repos)

# *copy ssh keys on WSL
if [ -n "$WSL_DISTRO_NAME" ]; then
  ID="$WSL_DISTRO_NAME"
  printf "\e[32mcopying ssh keys from the host\e[0m\n"
  mkdir -p ~/.ssh
  install -m 0400 /mnt/c/Users/$user/.ssh/id_* ~/.ssh/ 2>/dev/null
  github='git@github.com:'
else
  . /etc/os-release
  github='https://github.com/'
fi
ws_path="$HOME/source/workspaces/${ID,,}-${ws_suffix,,}.code-workspace"

# *add github.com to known_hosts
if ! grep -qw 'github.com' ~/.ssh/known_hosts 2>/dev/null; then
  printf "\e[32madding github fingerprint\e[0m\n"
  ssh-keyscan github.com 1>>~/.ssh/known_hosts 2>/dev/null
fi

# *setup source folder
# create folders
mkdir -p ~/source/repos
mkdir -p ~/source/workspaces
# create workspace file
if [ ! -f "$ws_path" ]; then
  printf "{\n\t\"folders\": [\n\t]\n}\n" >"$ws_path"
fi

# clone repositories and add them to workspace file
cd ~/source/repos
printf "\e[32mcloning repos\e[0m\n"
for repo in ${gh_repos[@]}; do
  IFS='/' read -ra gh_path <<< "$repo"
  mkdir -p "${gh_path[0]}"
  pushd "${gh_path[0]}" >/dev/null
  git clone "${github}${repo}.git" 2>/dev/null && echo $repo || true
  if ! grep -qw "$repo" "$ws_path" && [ -d "${gh_path[1]}" ]; then
    folder="\t{\n\t\t\t\"name\": \"${gh_path[1]}\",\n\t\t\t\"path\": \"..\/repos\/${repo/\//\\\/}\"\n\t\t},\n\t"
    sed -i "s/\(\]\)/$folder\1/" "$ws_path"
  fi
  popd >/dev/null
done
