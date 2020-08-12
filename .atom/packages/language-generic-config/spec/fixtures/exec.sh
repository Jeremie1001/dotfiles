#!/bin/sh

# Test comment
echo "^ This guy"

# Another comment + harvesting search results
wget -P files -i urls.log --rejected-log error.log --no-verbose

#EOF
