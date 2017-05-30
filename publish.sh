#!/usr/bin/env sh

# Recursively traverse folder, delete all files, then delete all folders
# Will intelligently exclude the .git and CNAME items
find . ! -name "CNAME" ! -path "*.git" -print -delete

# Rebuild the site
hugo
