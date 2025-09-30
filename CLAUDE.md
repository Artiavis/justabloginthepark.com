# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

**Build and serve locally:**
```bash
hugo server
```

**Build for production:**
```bash
hugo --minify
```

**Publish to production:**
```bash
./publish.sh
```
This script cleans the public directory (preserving .git and CNAME) and rebuilds the site with minification.

## Architecture

This is a Hugo static site blog using the "hemingway" theme. Key architectural components:

**Content Structure:**
- Blog posts are in `content/post/YYYY/MM/DD/` format with TOML front matter
- Gallery photos are managed through a special `content/photos.html` with TOML arrays defining photo metadata
- Front matter uses TOML format with `+++` delimiters

**Photo Gallery System:**
- Photos stored in `assets/img/gallery/` and `static/img/` 
- Gallery uses PhotoSwipe for lightbox functionality
- Custom shortcode `mygallery` integrates with Hugo's image processing (resize, thumbnails)
- Photos require size metadata (e.g. "2160x1440") in the TOML configuration

**Theme Customization:**
- Uses custom "hemingway" theme with Bulma CSS framework
- Custom layouts in `layouts/` override theme defaults
- Gallery-specific templates in `layouts/gallery/`
- PhotoSwipe integration via custom JavaScript in `assets/js/`

**Configuration:**
- Site config in `config.toml` with custom permalinks, social links, and privacy settings
- Disqus commenting disabled via privacy settings
- Image processing configured with Lanczos resampling and 90% quality

## Deployment Constraints

**GitHub Pages Limitations:**
- The `public/` directory is a separate Git repository deployed to GitHub Pages (Artiavis.github.io)
- **DO NOT use Git LFS** - GitHub Pages does not support it and will serve LFS pointer files instead of actual images
- All images must be committed as regular Git blobs in both source and public repos
- Current approach: Store images directly in Git (~30-50MB total, acceptable for this use case)

**Why No LFS:**
- Hugo processes images from `assets/img/gallery/` during build
- Built site in `public/` gets deployed to GitHub Pages
- GitHub Pages serves files directly from Git without LFS support
- Using LFS would result in browsers downloading 131-byte text pointers instead of actual images