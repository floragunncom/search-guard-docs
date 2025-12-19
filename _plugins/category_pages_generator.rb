module Jekyll
  class CategoryPagesGenerator < Generator
    safe true
    priority 5

    def generate(site)
      # Get main navigation structure file
      main_nav_file = nil

      # Find the main navigation structure file from the data directory
      site.data.each do |key, value|
        if key == 'side_navigation_main_structure'
          main_nav_file = value
          break
        end
      end

      if main_nav_file.nil?
          raise "Main nav file not found, exit"
      end

      # Ensure the category pages directory exists
      category_dir = File.join(site.source, '_content', '_docs_category_pages')

      # Delete all existing files in the category directory if it exists
      if Dir.exist?(category_dir)
        # Only delete markdown files to avoid removing other important files
        Dir.glob(File.join(category_dir, '*.md')).each do |file|
          File.delete(file)
        end
      else
        # Create the directory if it doesn't exist
        FileUtils.mkdir_p(category_dir)
      end

      # Load section mappings from main_navigation_sections.yml
      section_mappings = build_section_mappings(site)

      # Process each navigation file listed in the main structure
      main_nav_file['files'].each do |file_key|
        next unless site.data.key?(file_key)

        nav_data = site.data[file_key]
        section_key = section_mappings[file_key]
        process_nav_items(site, nav_data, category_dir, section_key)
      end
    end

    private

    def build_section_mappings(site)
      # Build a mapping from navigation file names to section keys
      # e.g., "side_navigation_security" => "security"
      mappings = {}

      if site.data.key?('main_navigation_sections')
        sections = site.data['main_navigation_sections']['sections']
        sections.each do |section|
          # Map nav_file to section key
          mappings[section['nav_file']] = section['key']
        end
      end

      mappings
    end

    def process_nav_items(site, items, category_dir, section_key = nil)
      # Array of navigation items or single item
      items_array = items.is_a?(Array) ? items : [items]

      items_array.each do |item|
        # Skip if item doesn't have a slug
        next unless item.key?('slug')

        # Create a category page if this item has children
        if item.key?('children') && !item['children'].nil? && !item['children'].empty?
          create_category_page(site, item, category_dir, section_key)

          # Process children recursively
          process_nav_items(site, item['children'], category_dir, section_key)
        end
      end
    end

    def create_category_page(site, item, category_dir, section_key = nil)
      # Create the file path, replacing hyphens with underscores in the filename
      filename = "#{item['slug'].gsub('-', '_')}.md"
      file_path = File.join(category_dir, filename)

      # Check if a file with the same slug exists in any other _content subdirectory
      existing_file = find_existing_content_file(site, item['slug'])
      if existing_file
        puts "Found existing file: #{existing_file}, skipping"
      end

      # Only generate the category page if no existing content file was found
      unless existing_file
        # Build content for the file
        content = build_category_page_content(item, section_key)

        # Write the file
        File.open(file_path, 'w') do |file|
          file.write(content)
        end
        puts "Generated page for slug #{item['slug']} with section #{section_key}: #{file_path}"
      end
    end

    def find_existing_content_file(site, slug)
      content_dir = File.join(site.source, '_content')
      category_dir = File.join(content_dir, '_docs_category_pages')

      # Look in all subdirectories of _content except _docs_category_pages
      Dir.glob(File.join(content_dir, '**', '*.md')).each do |file_path|
        # Skip files in the _docs_category_pages directory
        next if file_path.start_with?(category_dir)

        # Check if this file has the matching permalink in frontmatter
        content = File.read(file_path)
        if content =~ /^---\s*$.*?^permalink:\s*#{slug}\s*$.*?^---\s*$/m
          return file_path
        end

        # Also check if the filename (with hyphens replaced by underscores) matches the slug
        filename_base = File.basename(file_path, '.md')
        if filename_base == slug || filename_base == slug.gsub('-', '_')
          return file_path
        end
      end

      # No existing file found
      nil
    end

    def build_category_page_content(item, section_key = nil)
      # Build the frontmatter with section field if available
      frontmatter = "---\n"
      frontmatter += "title: #{item['title']}\n"
      frontmatter += "html_title: #{item['title']}\n"
      frontmatter += "permalink: #{item['slug']}\n"
      frontmatter += "layout: docs\n"
      frontmatter += "section: #{section_key}\n" if section_key
      frontmatter += "index: false\n"
      frontmatter += "description: All pages in the category #{item['title']}\n"
      frontmatter += "---\n"

      # Start building the content with the frontmatter
      content = frontmatter

      # Add a title header
      content += "# #{item['title']}\n\n"

      # Add a description
      content += "Browse all documentation pages in the #{item['title']} category:\n\n"

      # Build the list of children
      if item.key?('children') && !item['children'].nil?
        item['children'].each do |child|
          # Skip if child doesn't have a slug or title
          next unless child.key?('slug') && child.key?('title')

          # Add a list item with a link to the child page
          content += "* [#{child['title']}](#{child['slug']})\n"

          # If this child has nested children, add them as a nested list
          if child.key?('children') && !child['children'].nil? && !child['children'].empty?
            child['children'].each do |grandchild|
              # Skip if grandchild doesn't have a slug or title
              next unless grandchild.key?('slug') && grandchild.key?('title')

              # Add a nested list item
              content += "  * [#{grandchild['title']}](#{grandchild['slug']})\n"
            end
          end
        end
      end

      content
    end
  end
end