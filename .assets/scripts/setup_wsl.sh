#!/bin/bash
# *parameter variables
distro=$1
user=$2
gh_user=$3
IFS=',' read -a repos <<<"$4"

# *setup ssh
if [ -n $WSL_DISTRO_NAME ]; then
  \mkdir -p ~/.ssh
  \cp /mnt/c/Users/$user/.ssh/id_* ~/.ssh/ 2>/dev/null
  chmod 400 ~/.ssh/id_*
fi

# *setup source folder
# create folders
\mkdir -p ~/source/repos/${gh_user}
\mkdir -p ~/source/workspaces
# create workspace file
echo -e "{\n\t\"folders\": [\n\t]\n}" >~/source/workspaces/${distro}-devops.code-workspace
# clone repositories and add them to workspace file
cd ~/source/repos/$gh_user
for repo in ${repos[@]}; do
  git clone "git@github.com:$gh_user/$repo.git" 2>/dev/null
  if ! grep -w "$repo" ~/source/workspaces/$distro-devops.code-workspace; then
    folder="\t{\n\t\t\t\"name\": \"$repo\",\n\t\t\t\"path\": \"..\/repos\/$gh_user\/$repo\"\n\t\t},\n\t"
    sed -i "s/\(\]\)/$folder\1/" ~/source/workspaces/$distro-devops.code-workspace
  fi
done
