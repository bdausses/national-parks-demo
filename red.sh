#!/bin/bash

installed=`hab svc status|grep national-parks|cut -d " " -f1`

# Bump the package version number
echo
echo "Bumping the package version number..."
version=`grep pkg_version habitat/plan.sh | cut -d "=" -f2`
a=( ${version//./ } )
((a[2]++))
new_version=`echo "${a[0]}.${a[1]}.${a[2]}"`
sed -i "s/pkg_version.*/pkg_version=$new_version/" habitat/plan.sh

# Move new index into place
echo
echo "Replacing index.html with new version..."
cp red-index.html src/main/webapp/index.html

# Build new version of the webapp
echo
echo "Building new version of the webapp..."
build

# Unload old version of the webapp
echo
echo "Unload old version of the webapp..."
hab svc unload $installed

# Load new version of the webapp
echo
echo "Load new version of the webapp..."
. results/last_build.env
hab svc load $pkg_ident --bind database:mongodb.default

echo
echo "Loading is complete.  Your application should now be up and running."
echo "URLs:"
echo "Direct:  http://localhost:8080/national-parks"
echo "HAProxy: http://localhost:8085/national-parks"
echo
