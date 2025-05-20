# Search Guard Documentation System

Welcome to the Search Guard Documentation System.

The latest online version can be found here:

[Search Guard Documentation](https://docs.search-guard.com/latest/)

## Technologies

The documentation is based on:

* [Ruby](https://www.ruby-lang.org/en/)
* [Jekyll static site generator](https://jekyllrb.com/)
* [VSDocs Documentation Templates](https://themeforest.net/item/vsdocs-online-documentation-template/11418861)
* [Algolia Search Engine](https://www.algolia.com/)

## Quickstart

Clone the repository and in the project directory execute:

```
bundle install
```

```
bundle exec jekyll serve --watch
```

The `watch` command line parameter tells Jekyll to watch the directories for file changes and regenerate the documentation upon changes.

After the command completes:

* A static version of the site is generated in the `_site` directory
* A version of the site is served under `localhost:4000`

## Main directory structure

```
search-guard-docs ~/Projects/search-guard-docs
├── _content
├── _data
├── _diagrams
├── _includes
├── _layouts
├── _plugins
├── css
├── fonts
├── img
├── js
├── sass
```

* **_content**: The actual documentation files in Markdown format. The files are organized in subfolders, which in Jekyll's terminology is called **collections**.
* **_data**: Additional data in YAML and/or JSON format that is related to the documentation. At the moment, these are primarily YAML files that represent the navigation structure.
* **_diagrams**: Diagrams that are being used in the docs, in PNG and [draw.io](https://app.diagrams.net/) format. The draw.io files are the source files to render the PNG version.
* **_includes**: Jekyll include files that can be included from various files. For example, contains the includes for rendering the navigation.
* **_layouts**: All layouts for the main sections of the docs:
    * Documentation
    * Changelogs
    * Search
    * Versionmatrix ("Search Guard Versions")
* **_plugins**: All plugins used for building the website and populating the Algolia search index.
* **css, fonts, img, js**: The name speaks for itself.
* **sass**: The final CSS is built with [Sass](https://sass-lang.com/). All Sass files go here.

## Adding content

### Adding a new main section

At the moment we have four main sections:

* Security
* Alerting
* Index Management
* Encryption at Rest

If you want to add a new main section to the docs, say, "My awesome new feature", do the following:

* Add a new collection folder in the `_content` directory. The name is not important but should resemble the content. So, we call it `docs_my_new_feature`. All documentation files go in this folder.
* Declare this new collection folder in the `config.yml` file, which is located at the top-level directory:

```
collections:
  docs_my_new_feature:
    output: true
    permalink: :name
    algolia_hierarchy: "Security > My New Feature"
    ...
``` 

The `algolia_hierarchy` key is used for rendering a unique and hierarchical identifier for the search result pages.

In the file `side_navigation_main_structure.yml`, add a new main navigation entry:

```
files:
  - side_navigation_security
  - side_navigation_alerting
  - side_navigation_index_management
  - side_navigation_encryption_at_rest
  - side_navigation_my_new_feature 
```

Create the file `side_navigation_my_new_feature.yaml` and define the navigation structure for the new main section.

### Adding pages to an existing section

For adding new pages to an existing section, create a markdown document in one of the existing collections, or create a new collection as described above.

*Note: It is not relevant in which collection the file is placed. We use collections only to structure the content on an abstract logical level.*

#### Frontmatter

At minimum, the frontmatter needs to include these settings:

```
---
title: Configuring TLS
permalink: configuring-tls
layout: docs
---
```

Choose the permalink wisely, since we will not change it later. The permalink is important for search engine optimization and should contain the keywords of the page while omitting stopwords like "and," "or," etc.

#### Navigation

Add the new page to the navigation.

```
    - title: Introduction to Search Guard
      slug: search-guard-introduction
      children:
        - title: Overview
          slug: security-for-elasticsearch
        - title: Configuring TLS
          slug: configuring-tls
```

The title here is used to render the item in the left navbar, and it can differ from the title in the frontmatter. **However, make sure that the "slug" value in the navigation file matches the permalink entry in the frontmatter 1:1!**


## Conventions

### Permalinks and Filenames
* Permalinks are lowercase and use a dash as word delimiter, like "troubleshooting-tls"
* Filenames are lowercase and use an underscore as word delimiter, like "troubleshooting_tls.md"
* **Never change a permalink without a 301 redirect!**

Permalinks are very relevant for SEO, so do not simply change them because you think another permalink sounds better. If you have a good reason to change the permalink, please contact your friendly colleagues from DevOps and request a 301 redirect.

### Navigation
* The "slug" in the navigation file must match the permalink entry in the frontmatter 1:1

### Linking
* When linking from one page to another, use the slug/permalink, and not the path to the file.
* Permalinks/slugs are unlikely to change (see above), so this is the more robust approach.

Instead of using this:

```
### [Search Guard FLX 3.0.0](../_changelogs/changelog_searchguard_flx_3_0_0.md)
```

Use the permalink like:

```
### [Search Guard FLX 3.0.0](changelog-searchguard-flx-3_0_0)
```

## Check for broken links

We are using HTMLProofer to check for broken links. This tool is integrated in the CI/CD pipeline. If a broken link is detected, the deployment is aborted. You will see the offending link in the pipeline output. Fix it, and try again ;)

At the moment HTMLProofer is not run automatically when you build the docs on your local machine, because that would slow down the build process tremendously. However, you can run it manually before committing and pushing:

```
# build the docs, the resulting HTML files can be found in the _site directory
bundle exec jekyll build

# Check for broken links
# --assume-extension: Needed because links use the permalink, but the files have HTML extension
# --url-ignore: ignore links to old versions
# --alt-ignore: ignore missing alt in images
# --allow_hash_href: <a href='#'> is valid
bundle exec htmlproofer ./_site --assume-extension .html --disable-external  --url-ignore "/^\/(latest|[67]\.x-\d{2}|v[25])(\/|$)/" --alt-ignore '/.*/' --allow_hash_href true

```

## Plugins and Extensions

We are using plugins and extensions to help build the site.

### Algolia

**Location: _plugins/search.rb**

We use Algolia as our search engine. Besides the documentation, we also index other content, like blog posts, to make them searchable.

Excerpt from Gemfile:

```
group :jekyll_plugins do
  gem 'algoliasearch-jekyll', '~> 0.9.0'
end
```

Note: The plugin is deprecated, but still works reliably. We need to switch to some alternative at some point.

We use a custom hook to help chunk the content of each page better than the built-in approach. We break down the page into chunks by using the headings (h1-h5) and index each chunk as a new document.

### Category Page Generator

**Location: _plugins/category_pages_generator.rb**

This is a Jekyll Generator that renders category pages automatically if missing. In the navigation structure, we oftentimes have nav items with children, e.g.:


```
    - title: Introduction to Search Guard
      slug: search-guard-introduction
      children:
        - title: Overview
          slug: security-for-elasticsearch
        - title: Configuring TLS
          slug: configuring-tls
```

In this example, the nav item "Introduction to Search Guard" may not have an actual documentation page backing it, so the slug "search-guard-introduction" would be a 404. This plugin would then generate a page for "search-guard-introduction" automatically, listing all the children.

### Breadcrumb Generator

This plugin generates an inverted version of our navigation file definitions. This is done so that the breadcrumb can be rendered more easily. The generated breadcrumb.yaml (located in the "data" directory) is git ignored.


Example:

```
security:
- &1
  title: Security
  slug: security
search-guard-introduction:
- *1
- &2
  title: Introduction to Search Guard
  slug: search-guard-introduction
security-for-elasticsearch:
- *1
- *2
- title: Overview
  slug: security-for-elasticsearch
```

### Code Blocks

**Location: _plugins/custom_kramdown.rb**

For fenced code blocks, we need to render a specific HTML structure so the code can be simply copied to clipboard with the push of a button. This is where the magic happens.
