#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

if [[ "$PWD" != *my-hn-dev-env ]] ; then
 echo "Not in the correct directory. Exiting..."
 exit 1
fi

# Exit if node is not installed or not version 9.*
if [[ ! $(node --version) == v9* ]] ; then
    echo "WARNING: Node version is NOT v9.*"
fi

# Exit if docker is not installed or not version 17.*
if [[ ! $(docker --version) == "Docker version 17."* ]] ; then
    echo "WARNING: Docker version is NOT v17.*"
fi

cd repos

#REPOS=( "my-hn-spec" "my-hn-app-react" )
REPOS=( "my-hn-spec" )

for r in "${REPOS[@]}"
do
    echo ""
  
    # Clone repo
    [ ! -d "./$r" ] && echo "Repository $r not found. Cloning..." && git clone git@github.com:andyfleming/$r.git
    [ -d "./$r" ] && printf "\xE2\x9C\x94  $r is already cloned.\n"

    # Run build script if there is one
    [ -e "./$r/bin/build.sh" ] && echo "Running build script..." && ./$r/bin/build.sh
done

echo ""
echo "All projects cloned and built."
echo ""
