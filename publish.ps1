# Recursively traverse folder, delete all files, then delete all folders
# Will intelligently exclude the .git and CNAME items
Get-ChildItem -Path '.\public' -Recurse -Exclude 'CNAME' | 
    Select-Object -ExpandProperty FullName |
    Sort-Object length -Descending |
    Remove-Item -Verbose

# Regenerate site
hugo.exe
