# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the Search Guard Documentation System - a Jekyll-based static site generator for the official Search Guard documentation at https://docs.search-guard.com/latest/. Search Guard is an Enterprise Security Suite for Elasticsearch.

## Technology Stack

- **Jekyll 4.2.0** - Static site generator (Ruby 3.0)
- **Kramdown** - Markdown processor with GitHub Flavored Markdown (GFM)
- **Algolia** - Full-text search engine integration
- **Sass** - CSS preprocessing (compressed output)
- **HTMLProofer** - Link validation in CI/CD pipeline

## Common Commands

### Ruby version

For this project to build and run, you need to use a compatible Ruby version. This project is using rvm to manage ruby versions. Use this command to choose a compatible Ruby version:

```
rvm use ruby-3.0.7
```

### Development

Start the local development server with live reloading:
```bash
bundle install
bundle exec jekyll serve --watch
```

The site will be available at `localhost:4000` with a static version generated in `_site/`.

### Testing

Build the site and check for broken links:
```bash
# Build the site
bundle exec jekyll build

# Check for broken links (same command used in CI/CD)
bundle exec htmlproofer ./_site --assume-extension .html --disable-external --url-ignore "/^\/(latest|[67]\.x-\d{2}|v[25])(\/|$)/" --alt-ignore '/.*/' --allow_hash_href true
```

### Production Build

The CI/CD pipeline performs a 2-pass build to include auto-generated pages:
```bash
bundle exec jekyll build --config _config.yml,_versions.yml --incremental
bundle exec jekyll build --config _config.yml,_versions.yml --incremental
```

### Search Index

Rebuild the Algolia search index:
```bash
bundle exec jekyll algolia push --config _config.yml,_versions.yml
```

To skip search indexing in deployments, include "noindex" in the commit message.

## Architecture & Content Structure

### Collections-Based Organization

Documentation is organized into Jekyll collections (subdirectories in `_content/`), each representing a major feature area or category. Collections are configured in `_config.yml` with `algolia_hierarchy` settings for hierarchical search categorization.

Main collections include:
- `_docs_introduction/` - Getting started guides
- `_docs_installation/` - Installation documentation
- `_docs_tls/` - TLS/encryption configuration
- `_docs_auth_auth/` - Authentication and authorization
- `_docs_roles_permissions/` - RBAC documentation
- `_docs_kibana/` - Kibana integration
- `_docs_signals/` - Alerting (Signals feature)
- `_docs_aim/` - Automated Index Management
- `_docs_dls_fls/` - Document and Field-Level Security
- `_docs_audit_logging/` - Audit logging
- `_docs_encryption_at_rest/` - Encryption at rest
- `_docs_ad/` - Anomaly Detection
- `_changelogs/` - Release notes

**Note:** The collection a file is placed in is mainly for logical organization. The actual navigation structure and hierarchy are controlled by YAML files in `_data/`.

### Navigation System

Navigation is hierarchical and YAML-based:

1. **Main orchestrator**: `_data/side_navigation_main_structure.yml` lists all section navigation files
2. **Section navigation files**: `_data/side_navigation_security.yml`, `side_navigation_alerting.yml`, etc. define the actual navigation trees with nested children
3. **Navigation structure**: Unlimited nesting levels with `title`, `slug`, and `children` properties

Navigation structure example:
```yaml
- title: Introduction to Search Guard
  slug: search-guard-introduction
  children:
    - title: Overview
      slug: security-for-elasticsearch
    - title: Configuring TLS
      slug: configuring-tls
```

**Critical requirement**: The `slug` in navigation files MUST match the `permalink` in the page frontmatter exactly (1:1 match).

### Auto-Generated Content

**Category Pages** (`_plugins/category_pages_generator.rb`):
- Automatically generates landing pages for navigation items with children if no actual page exists
- Generated pages list all child pages
- Located in `_docs_category_pages/` collection

**Breadcrumbs** (`_plugins/breadcrumbs_generator.rb`):
- Inverts the navigation structure to enable efficient breadcrumb rendering
- Generates `_data/breadcrumbs.yml` (git-ignored)
- Uses YAML anchors and references for compact representation

### Custom Jekyll Plugins

**Code Block Rendering** (`_plugins/custom_kramdown.rb`):
- Enhances fenced code blocks with special HTML structure for copy-to-clipboard functionality

**Algolia Search Hook** (`_plugins/search.rb`):
- Chunks content by headings (h1-h5) for better search granularity
- Each chunk becomes a separate searchable document
- 20KB size limit per item
- Hierarchical categorization via collection `algolia_hierarchy`

## File Naming & Permalink Conventions

**Critical SEO requirements:**

1. **Permalinks**: lowercase with dashes (e.g., `configuring-tls`)
2. **Filenames**: lowercase with underscores (e.g., `configuring_tls.md`)
3. **Navigation slugs**: MUST match permalinks exactly

**NEVER change a permalink without coordinating a 301 redirect with DevOps** - permalinks are critical for SEO.

## Page Frontmatter

Minimum required frontmatter:
```yaml
---
title: Configuring TLS
permalink: configuring-tls
layout: docs
---
```

Optional fields:
```yaml
html_title: Custom SEO Title
description: Meta description for search engines
resources: [list of external links]
index_algolia: true  # Controls searchability (default: true)
```

## Linking Between Pages

Always use the permalink/slug, NOT the file path:

**Correct:**
```markdown
[Search Guard FLX 3.0.0](changelog-searchguard-flx-3_0_0)
```

**Incorrect:**
```markdown
[Search Guard FLX 3.0.0](../_changelogs/changelog_searchguard_flx_3_0_0.md)
```

Permalinks are stable and less likely to change than file paths.

## Version Management

- `_config.yml` contains current Elasticsearch and Search Guard versions
- `_versions.yml` contains alternate version configurations for separate documentation roots
- `sgversions` in `_config.yml` defines the compatibility matrix displayed on the version matrix page

## Adding New Content

### Adding a New Main Section

1. Create collection folder: `_content/_docs_my_new_feature/`
2. Declare collection in `_config.yml`:
   ```yaml
   collections:
     docs_my_new_feature:
       output: true
       permalink: :name
       algolia_hierarchy: "Security > My New Feature"
   ```
3. Add to main navigation in `_data/side_navigation_main_structure.yml`:
   ```yaml
   files:
     - side_navigation_my_new_feature
   ```
4. Create navigation file: `_data/side_navigation_my_new_feature.yml`

### Adding Pages to Existing Sections

1. Create markdown file in appropriate collection
2. Add required frontmatter (title, permalink, layout)
3. Add entry to relevant navigation YAML file
4. Ensure slug in navigation matches permalink in frontmatter

## CI/CD Pipeline

**Build Stage:**
- Runs merge conflict detection
- Performs 2-pass Jekyll build to include auto-generated pages
- Validates all internal links with HTMLProofer

**Deploy Stage:**
- Uploads to production via SFTP
- Purges Cloudflare cache
- Rebuilds Algolia search index (unless commit message contains "noindex")

## Directory Structure Reference

- `_content/` - All documentation markdown files organized by collection
- `_data/` - YAML navigation structures and metadata
- `_includes/` - Reusable template fragments (navigation, breadcrumbs, footer, etc.)
- `_layouts/` - Page layouts (docs, changelogs, search, versionmatrix)
- `_plugins/` - Custom Jekyll generators and extensions
- `_diagrams/` - Visual diagrams (PNG and draw.io source files)
- `sass/` - Sass source files (60+ SCSS modules)
- `css/`, `js/`, `fonts/`, `img/` - Static assets
- `_site/` - Generated output (git-ignored)

## Formatting Rules

* Every table should be formatted as a config-table. To do so, add the following line at the end of the table: {: .config-table}