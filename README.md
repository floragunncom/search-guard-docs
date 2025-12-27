# Search Guard Documentation System

Welcome to the Search Guard Documentation System.

The latest online version can be found here: [Search Guard Documentation](https://docs.search-guard.com/latest/)

## Table of Contents

- [Technologies](#technologies)
- [Quick Start](#quick-start)
- [Available Commands](#available-commands)
- [Project Structure](#project-structure)
- [Navigation System](#navigation-system)
- [Adding Content](#adding-content)
- [Adding Changelogs](#adding-changelogs)
- [Conventions](#conventions)
- [Jekyll Plugins](#jekyll-plugins)
- [CI/CD Pipeline](#cicd-pipeline)
- [Troubleshooting](#troubleshooting)

## Technologies

The documentation is based on:

* **[Ruby 3.0](https://www.ruby-lang.org/en/)** - Programming language
* **[Jekyll 4.2.0](https://jekyllrb.com/)** - Static site generator
* **[Kramdown](https://kramdown.gettalong.org/)** - Markdown parser with GitHub Flavored Markdown (GFM) support
* **[Sass](https://sass-lang.com/)** - CSS preprocessor
* **[Algolia](https://www.algolia.com/)** - Full-text search engine
* **[HTMLProofer](https://github.com/gjtorikian/html-proofer)** - Link validation tool
* **[VSDocs Documentation Templates](https://themeforest.net/item/vsdocs-online-documentation-template/11418861)** - Base template

## Quick Start

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd search-guard-docs
```

2. Install Ruby dependencies:
```bash
bundle install
```

3. Start the development server:
```bash
bundle exec jekyll serve --watch
```

The site will be available at `http://localhost:4000`. The `--watch` flag tells Jekyll to automatically regenerate the site when files change.

## Available Commands

### Development

**Start development server:**
```bash
bundle exec jekyll serve --watch
```

**Build the site (production):**
```bash
bundle exec jekyll build
```

**Build with version configuration:**
```bash
bundle exec jekyll build --config _config.yml,_versions.yml
```

### Testing

**Check for broken links:**
```bash
# Build the site first
bundle exec jekyll build

# Run HTMLProofer
bundle exec htmlproofer ./_site --assume-extension .html --disable-external \
  --url-ignore "/^\/(latest|[67]\.x-\d{2}|v[25])(\/|$)/" \
  --alt-ignore '/.*/' --allow_hash_href true
```

### Search Index

**Rebuild Algolia search index:**
```bash
bundle exec jekyll algolia push --config _config.yml,_versions.yml
```

**Note:** To skip search indexing during deployment, include "noindex" in your commit message.

### Helper Scripts

**Add section fields to all pages (bulk update):**
```bash
./add_section_fields.sh
```

## Project Structure

```
search-guard-docs/
├── _content/                   # All documentation markdown files
│   ├── _changelogs/           # Changelog entries
│   ├── _docs_introduction/    # Introduction documentation
│   ├── _docs_installation/    # Installation guides
│   ├── _docs_tls/            # TLS/encryption configuration
│   ├── _docs_auth_auth/      # Authentication and authorization
│   ├── _docs_roles_permissions/ # RBAC documentation
│   ├── _docs_kibana/         # Kibana integration
│   ├── _docs_signals/        # Alerting (Signals feature)
│   ├── _docs_aim/            # Automated Index Management
│   ├── _docs_dls_fls/        # Document and Field-Level Security
│   ├── _docs_audit_logging/  # Audit logging
│   ├── _docs_encryption_at_rest/ # Encryption at rest
│   ├── _docs_ad/             # Anomaly Detection
│   ├── _docs_category_pages/ # Auto-generated category pages
│   └── ...                   # Other collections
├── _data/                     # YAML/JSON data files
│   ├── main_navigation_sections.yml  # Main nav section definitions
│   ├── side_navigation_main_structure.yml # Side nav orchestrator
│   ├── side_navigation_security.yml # Security section navigation
│   ├── side_navigation_alerting.yml # Alerting section navigation
│   ├── side_navigation_index_management.yml
│   ├── side_navigation_encryption_at_rest.yml
│   ├── side_navigation_anomaly_detection.yml
│   ├── sgversions_docroots.yml # Version dropdown data
│   └── breadcrumbs.yml        # Auto-generated (git-ignored)
├── _diagrams/                 # Diagrams (PNG + draw.io sources)
├── _includes/                 # Reusable template fragments
│   ├── main_navigation.html   # Top navigation bar
│   ├── left_navigation.html   # Side navigation
│   ├── left_navigation_item.html # Recursive nav item renderer
│   ├── breadcrumbs.html       # Breadcrumb navigation
│   └── ...                    # Other includes
├── _layouts/                  # Page layout templates
│   ├── docs.html             # Main documentation layout
│   ├── search.html           # Search results layout
│   └── versionmatrix.html    # Version compatibility layout
├── _plugins/                  # Custom Jekyll plugins
│   ├── category_pages_generator.rb # Auto-generate category pages
│   ├── breadcrumbs_generator.rb    # Generate breadcrumb data
│   ├── search.rb                   # Algolia search integration
│   ├── custom_kramdown.rb          # Custom code block rendering
│   └── file_normalizer.rb          # File name normalization
├── sass/                      # Sass/SCSS source files
│   ├── _sg_navigation.scss   # Navigation styles
│   ├── _sg_code.scss         # Code block styles
│   └── ...                   # 60+ other style modules
├── css/                       # Compiled CSS output
├── js/                        # JavaScript files
├── fonts/                     # Font files
├── img/                       # Images and graphics
├── _site/                     # Generated static site (git-ignored)
├── _config.yml               # Main Jekyll configuration
├── _versions.yml             # Version-specific configuration
├── Gemfile                   # Ruby dependencies
└── index.md                  # Homepage
```

### Key Directories

**`_content/`** - All documentation markdown files organized by Jekyll collections. Each subdirectory represents a logical grouping of related documentation.

**`_data/`** - YAML files containing structured data, primarily navigation structures and metadata.

**`_includes/`** - Reusable template components that can be included in layouts and pages.

**`_layouts/`** - Page templates that wrap content with HTML structure.

**`_plugins/`** - Custom Ruby plugins that extend Jekyll's functionality.

**`sass/`** - Sass source files that compile to CSS.

**`_site/`** - Generated static HTML (not tracked in git).

## Navigation System

The documentation uses a **section-based navigation system** with two levels:

### Main Navigation (Top Bar)

Displays 5 clickable section tabs plus Versions and Contact:

**Security | Alerting | Index Management | Encryption at Rest | Anomaly Detection | Versions | Contact**

Configuration: `_data/main_navigation_sections.yml`

```yaml
sections:
  - title: Security
    slug: security              # Landing page permalink
    key: security               # Used in page frontmatter
    nav_file: side_navigation_security  # Side nav file to load

  - title: Alerting
    slug: elasticsearch-alerting
    key: alerting
    nav_file: side_navigation_alerting

  # ... additional sections
```

### Side Navigation (Left Sidebar)

Shows a hierarchical tree of pages within the active section. The displayed navigation is determined by the page's `section` field.

**Behavior:**
- **Pages with `section` field**: Shows only that section's navigation tree
- **Homepage (`isroot: true`)**: Shows a flat list of the 5 main sections
- **Pages without section**: Fallback to showing all sections

**Configuration:** Each section has its own navigation YAML file in `_data/`:
- `side_navigation_security.yml`
- `side_navigation_alerting.yml`
- `side_navigation_index_management.yml`
- `side_navigation_encryption_at_rest.yml`
- `side_navigation_anomaly_detection.yml`

**Navigation Structure:**
```yaml
- title: Security
  slug: security
  children:
    - title: Introduction to Search Guard
      slug: search-guard-introduction
      children:
        - title: Overview
          slug: security-for-elasticsearch
        - title: Main Concepts
          slug: main-concepts
    - title: TLS Setup
      slug: search-guard-security-tls-setup
      children:
        - title: Configuring TLS
          slug: configuring-tls
```

**Important:** The `slug` in navigation files MUST match the `permalink` in page frontmatter exactly (1:1 match).

### Breadcrumbs

Breadcrumbs are auto-generated from the navigation structure by the `breadcrumbs_generator.rb` plugin. The plugin inverts the navigation tree to create a lookup table mapping each page to its ancestor path.

## Adding Content

### Adding a New Page to an Existing Section

1. **Create a markdown file** in the appropriate collection directory:
   - Security pages → `_content/_docs_*` (auth_auth, tls, roles_permissions, etc.)
   - Alerting pages → `_content/_docs_signals/`
   - Index Management → `_content/_docs_aim/`
   - Encryption at Rest → `_content/_docs_encryption_at_rest/`
   - Anomaly Detection → `_content/_docs_ad/`

2. **Add frontmatter** to the markdown file:

```yaml
---
title: Configuring TLS
html_title: TLS Configuration Guide  # Optional
permalink: configuring-tls            # Required, lowercase with dashes
layout: docs                          # Required
section: security                     # Required (security, alerting, index_management, encryption_at_rest, anomaly_detection)
description: How to configure TLS for Search Guard  # Optional but recommended
edition: enterprise                   # Optional (community or enterprise)
---
```

3. **Add the page to navigation** in the appropriate `_data/side_navigation_*.yml` file:

```yaml
- title: TLS Setup
  slug: search-guard-security-tls-setup
  children:
    - title: Configuring TLS
      slug: configuring-tls    # Must match permalink exactly!
```

4. **Write your content** using Markdown with GitHub Flavored Markdown (GFM) syntax.

### Adding a New Main Section

To add a new main section (e.g., "Machine Learning"):

1. **Create a collection directory:**
```bash
mkdir _content/_docs_ml
```

2. **Declare the collection** in `_config.yml`:

```yaml
collections:
  docs_ml:
    output: true
    permalink: :name
    algolia_hierarchy: "Machine Learning"
```

3. **Add section to main navigation** in `_data/main_navigation_sections.yml`:

```yaml
sections:
  # ... existing sections ...

  - title: Machine Learning
    slug: machine-learning
    key: machine_learning
    nav_file: side_navigation_machine_learning
```

4. **Create side navigation file** `_data/side_navigation_machine_learning.yml`:

```yaml
- title: Machine Learning
  slug: machine-learning
  children:
    - title: Getting Started
      slug: ml-getting-started
    - title: Configuration
      slug: ml-configuration
```

5. **Add to side navigation orchestrator** in `_data/side_navigation_main_structure.yml`:

```yaml
files:
  - side_navigation_security
  - side_navigation_alerting
  - side_navigation_index_management
  - side_navigation_encryption_at_rest
  - side_navigation_anomaly_detection
  - side_navigation_machine_learning  # Add here
```

6. **Create the landing page** at `_content/_docs_category_pages/machine_learning.md`:

```yaml
---
title: Machine Learning
html_title: Machine Learning
permalink: machine-learning
layout: docs
section: machine_learning
index: false
description: All pages in the category Machine Learning
---
# Machine Learning

Browse all documentation pages in the Machine Learning category:

* [Getting Started](ml-getting-started)
* [Configuration](ml-configuration)
```

7. **Create your documentation pages** in `_content/_docs_ml/` with `section: machine_learning` in their frontmatter.

## Adding Changelogs

Changelogs are integrated into the Security section's navigation.

### Adding a New Changelog Entry

1. **Create a markdown file** in `_content/_changelogs/`:

```bash
_content/_changelogs/changelog_searchguard_flx_4_0_0.md
```

2. **Add frontmatter:**

```yaml
---
title: Search Guard FLX 4.0.0
permalink: changelog-searchguard-flx-4_0_0
layout: docs
section: security
description: Changelog for Search Guard FLX 4.0.0
index: false
sitemap: false
---
```

3. **Write changelog content** using markdown.

4. **Add to changelog navigation** in the appropriate changelog main page (e.g., `_content/_changelogs/changelogs_searchguard_main.md`).

### Changelog Organization

Changelogs are accessible via:
- **Main Navigation:** Security → Changelogs (in side nav)
- **Side Navigation Structure:** Defined in `_data/side_navigation_security.yml`:

```yaml
- title: Changelogs
  slug: changelogs-section
  children:
    - title: Search Guard Security
      slug: changelogs-searchguard
    - title: Kibana
      slug: changelogs-kibana
    - title: TLS Tool
      slug: changelogs-tlstool
    - title: Encryption at Rest
      slug: changelogs-ear
```

## Conventions

### Permalinks and Filenames

**Permalinks:**
- Lowercase only
- Use dashes (`-`) as word delimiters
- Example: `configuring-tls`
- **NEVER change a permalink without coordinating a 301 redirect!**

**Filenames:**
- Lowercase only
- Use underscores (`_`) as word delimiters
- Example: `configuring_tls.md`

**SEO Importance:** Permalinks are critical for SEO. Do not change them unless absolutely necessary and only after coordinating with DevOps for 301 redirect setup.

### Section Field Values

Use these exact values for the `section` field in frontmatter:

- `security` - Security documentation
- `alerting` - Alerting/Signals documentation
- `index_management` - Index Management documentation
- `encryption_at_rest` - Encryption at Rest documentation
- `anomaly_detection` - Anomaly Detection documentation

### Navigation Slugs

**Critical Rule:** The `slug` value in navigation YAML files MUST match the `permalink` in the page's frontmatter exactly (1:1 match).

Navigation file:
```yaml
- title: Configuring TLS
  slug: configuring-tls
```

Page frontmatter:
```yaml
permalink: configuring-tls
```

### Internal Linking

Always use the permalink/slug, NOT the file path:

**✅ Correct:**
```markdown
[Search Guard FLX 3.0.0](changelog-searchguard-flx-3_0_0)
```

**❌ Incorrect:**
```markdown
[Search Guard FLX 3.0.0](../_changelogs/changelog_searchguard_flx_3_0_0.md)
```

### Frontmatter Fields

**Required:**
- `title` - Page title
- `permalink` - URL slug
- `layout` - Usually `docs`
- `section` - Section identifier

**Optional but Recommended:**
- `html_title` - SEO-optimized title
- `description` - Meta description for search engines
- `edition` - `community` or `enterprise`
- `resources` - Array of external resource links
- `index_algolia` - Set to `false` to exclude from search (default: `true`)

## Jekyll Plugins

### 1. Category Pages Generator

**Location:** `_plugins/category_pages_generator.rb`

**Purpose:** Automatically generates landing pages for navigation items that have children but no corresponding content file.

**How it works:**
1. Reads all navigation YAML files
2. For each nav item with children, checks if a content file exists with that permalink
3. If no file exists, generates a category page listing all children
4. **NEW:** Automatically adds the correct `section` field to generated pages based on which navigation file they belong to

**Generated pages are placed in:** `_content/_docs_category_pages/`

**Example:** If your navigation has:
```yaml
- title: Introduction to Search Guard
  slug: search-guard-introduction
  children:
    - title: Overview
      slug: security-for-elasticsearch
```

And no file exists with `permalink: search-guard-introduction`, the plugin auto-generates one.

### 2. Breadcrumbs Generator

**Location:** `_plugins/breadcrumbs_generator.rb`

**Purpose:** Generates an inverted lookup table of the navigation structure for efficient breadcrumb rendering.

**How it works:**
1. Reads `side_navigation_main_structure.yml`
2. Recursively processes each navigation tree
3. Creates a hash mapping each slug to its full ancestor path
4. Writes to `_data/breadcrumbs.yml` (git-ignored)

**Example output:**
```yaml
security:
  - title: Security
    slug: security
search-guard-introduction:
  - title: Security
    slug: security
  - title: Introduction to Search Guard
    slug: search-guard-introduction
```

### 3. Algolia Search Integration

**Location:** `_plugins/search.rb`

**Purpose:** Custom hook to chunk documentation content for better search granularity.

**How it works:**
1. Breaks down each page into chunks by headings (h1-h5)
2. Each chunk becomes a separate searchable record in Algolia
3. Records include hierarchical categorization via `algolia_hierarchy`
4. 20KB size limit per chunk

**Note:** The `algoliasearch-jekyll` gem is deprecated but still functional.

### 4. Custom Kramdown Renderer

**Location:** `_plugins/custom_kramdown.rb`

**Purpose:** Renders fenced code blocks with special HTML structure for copy-to-clipboard functionality.

**Features:**
- Adds wrapper elements around code blocks
- Enables "Copy Code" button functionality
- Preserves syntax highlighting

### 5. File Normalizer

**Location:** `_plugins/file_normalizer.rb`

**Purpose:** Normalizes file names to ensure consistency.

## CI/CD Pipeline

**Location:** `.gitlab-ci.yml`

### Build Stage

1. **Merge conflict detection:** Checks for merge markers
2. **Clean build:** Removes old `_site` directory
3. **2-pass Jekyll build:**
   - First pass generates basic pages
   - Second pass includes auto-generated category pages
4. **Link validation:** Runs HTMLProofer to check for broken internal links

### Deploy Stage

**Triggers:** Only on `release` branch

1. **SFTP Upload:** Deploys `_site` to production server
2. **Cloudflare Cache Purge:** Clears CDN cache
3. **Algolia Index Rebuild:** Updates search index (unless commit message contains "noindex")

### Environment Variables

- `sftp_server` - SFTP server address
- `sftp_user_name` - SFTP username
- `sftp_user_private_key_base64` - SSH private key (base64 encoded)
- `SG_CLOUDFLARE_ZONEID` - Cloudflare zone ID
- `SG_CLOUDFLARE_DECACHE_TOKEN` - Cloudflare API token
- `ALGOLIA_APPLICATION_ID` - Algolia application ID
- `ALGOLIA_API_KEY` - Algolia admin API key

## Troubleshooting

### Ruby Version Issues

Jekyll 4.2.0 is compatible with Ruby 3.0-3.2. If you have Ruby 3.3+, you may encounter errors.

**Solution:**
```bash
# Use rbenv or rvm to switch Ruby version
rvm use 3.0.0
# or
rbenv local 3.0.0

# Reinstall dependencies
bundle install
```

### Build Errors

**Common issues:**

1. **Missing gems:** Run `bundle install`
2. **Sass compilation errors:** Check syntax in `sass/*.scss` files
3. **Plugin errors:** Check Ruby syntax in `_plugins/*.rb` files
4. **YAML parsing errors:** Validate YAML files in `_data/` directory

### Navigation Not Displaying

**Checklist:**
1. Verify `section` field in page frontmatter matches a key in `main_navigation_sections.yml`
2. Check that navigation YAML file is listed in `side_navigation_main_structure.yml`
3. Ensure `slug` in navigation matches `permalink` in page frontmatter exactly
4. Rebuild the site to regenerate breadcrumbs

### Search Not Working

1. Rebuild Algolia index: `bundle exec jekyll algolia push`
2. Check that `index_algolia: false` is not set in frontmatter
3. Verify Algolia credentials in `_config.yml`

### Broken Links

Run HTMLProofer:
```bash
bundle exec jekyll build
bundle exec htmlproofer ./_site --assume-extension .html --disable-external \
  --url-ignore "/^\/(latest|[67]\.x-\d{2}|v[25])(\/|$)/" \
  --alt-ignore '/.*/' --allow_hash_href true
```

### CSS Changes Not Appearing

1. **Rebuild the site:** Sass files need recompilation
2. **Hard refresh browser:** Ctrl+F5 or Cmd+Shift+R
3. **Check file location:** Ensure changes are in `sass/` not `css/`
4. **Verify import:** Check that SCSS file is imported in main stylesheet

## Additional Resources

- [Jekyll Documentation](https://jekyllrb.com/docs/)
- [Kramdown Syntax](https://kramdown.gettalong.org/syntax.html)
- [Sass Documentation](https://sass-lang.com/documentation)
- [Algolia Jekyll Plugin](https://community.algolia.com/jekyll-algolia/)
- [HTMLProofer](https://github.com/gjtorikian/html-proofer)

## Support

For issues or questions:
- Internal documentation team
- [Search Guard Forum](https://forum.search-guard.com)
- [Search Guard Contact](https://search-guard.com/contacts/)
