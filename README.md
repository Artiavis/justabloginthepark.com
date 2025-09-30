# Just a Blog in the Park

Hugo-powered static blog deployed to GitHub Pages.

## Deployment Architecture

This repository uses a dual-repo setup:
- **Source repo**: `justabloginthepark.com` (this repo) - Hugo source files
- **Public repo**: `Artiavis.github.io` (in `./public/` submodule) - Built site for GitHub Pages

### Important Constraints

**Do not use Git LFS in this project.** GitHub Pages doesn't support it - LFS pointer files would be served instead of actual images, breaking the site.

## Quick Start

**Local development:**
```bash
hugo server
```

**Build for production:**
```bash
hugo --minify
```

**Publish to GitHub Pages:**
```bash
./publish.sh
```

See [CLAUDE.md](CLAUDE.md) for detailed architecture and development guidance.
