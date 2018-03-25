#!/usr/bin/env sh

# Recursively traverse folder, delete all files, then delete all folders
# Will intelligently exclude the .git and CNAME items
find public -type f -not -iwholename '*CNAME*' -not -iwholename '*.git*' -print -delete
find public -type d -mindepth 1 -not -path '*.git*' -print -delete

# Rebuild the site
hugo
