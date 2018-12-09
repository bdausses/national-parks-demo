#!/bin/bash

# Build the National Parks webapp
echo
echo "Building the National Parks webapp..."
build

# Source the last build info
echo
echo "Setting environment variables to results from the build..."
. results/last_build.env

# Load core/mongodb package from the public depot
echo
echo "Loading mongodb from Habitat core plan..."
hab svc load core/mongodb

# Override the default configuration of mongodb
echo
echo "Setting configuration for mongodb..."
hab config apply mongodb.default $(date +%s) mongo.toml

#Load the most recent build of national-parks
echo
echo "Load the build of the National Parks webapp that we built earlier, binding to the MongoDB we just loaded..."
hab svc load $pkg_ident --bind database:mongodb.default

#Load core/haproxy from the public depot
echo
echo "Loading HAProxy from Habitat core plan..."
hab svc load core/haproxy --bind backend:national-parks.default

#Override the default configuration of HAProxy
echo
echo "Setting configuration for HAProxy..."
hab config apply haproxy.default $(date +%s) haproxy.toml

echo
echo "Loading is complete.  Your application should now be up and running."
echo "URLs:"
echo "Direct:  http://localhost:8080/national-parks"
echo "HAProxy: http://localhost:8085/national-parks"
echo
