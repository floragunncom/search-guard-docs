module Jekyll
  class BreadcrumbGenerator < Generator
    safe true
    priority 3

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

      # Create a new hash to store breadcrumb paths
      breadcrumbs = {}

      # Process each navigation file listed in the main structure
      main_nav_file['files'].each do |file_key|
        next unless site.data.key?(file_key)

        nav_data = site.data[file_key]
        process_nav_items(nav_data, breadcrumbs)
      end

      # Save the breadcrumb data to the site data
      site.data['breadcrumbs'] = breadcrumbs

      # Write to _data/breadcrumbs.yml file for persistence
      write_breadcrumbs_file(site, breadcrumbs)
    end

    private

    def process_nav_items(items, breadcrumbs, ancestors = [])
      # Array of navigation items or single item
      items_array = items.is_a?(Array) ? items : [items]

      items_array.each do |item|
        # Skip if item doesn't have a slug
        next unless item.key?('slug')

        # Current path includes the item itself and all its ancestors
        current_path = ancestors.dup

        # Create a simplified item with only title and slug
        current_item = {
          'title' => item['title'],
          'slug' => item['slug']
        }

        # Add current item to the path
        current_path.push(current_item)

        # Register this path in breadcrumbs hash
        breadcrumbs[item['slug']] = current_path

        # Process children recursively if they exist
        if item.key?('children') && !item['children'].nil?
          process_nav_items(item['children'], breadcrumbs, current_path)
        end
      end
    end

    def write_breadcrumbs_file(site, breadcrumbs)
      # Ensure _data directory exists
      data_dir = File.join(site.source, '_data')
      Dir.mkdir(data_dir) unless Dir.exist?(data_dir)

      # Write breadcrumbs to YAML file
      File.open(File.join(data_dir, 'breadcrumbs.yml'), 'w') do |file|
        file.write(breadcrumbs.to_yaml)
      end
    end
  end
end