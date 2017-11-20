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
REPOS=( "my-hn-project" "my-hn-api-node-js" "my-hn-app-vanilla-js" "my-hn-tests" "my-hn-crawler-importer-node-js" )

for r in "${REPOS[@]}"
do
    echo ""
  
    # Clone repo
    [ ! -d "./$r" ] && echo "Repository $r not found. Cloning..." && git clone git@github.com:andyfleming/$r.git
    [ -d "./$r" ] && printf "\xE2\x9C\x94  $r is already cloned.\n"

    echo ""

    # Change into the directory
    cd $r

    # Run the project build script if there is one
    [ -e "./bin/build.sh" ] && echo "Running build script..." && ./bin/build.sh

    # Build and tag the docker container (if a Dockerfile is present)
    [[ -f Dockerfile ]] && docker build -t andyfleming/$r .

    # Exit the directory
    cd ..

done

echo ""
echo "All projects cloned and built."
echo ""
