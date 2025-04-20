module Jekyll
  class FilenameNormalizer < Generator
    safe false  # This plugin modifies files on disk, so it's not safe for GitHub Pages
    priority :highest

    # Debug mode switch - set to true to only print changes without renaming files
    DEBUG_MODE = true

    def generate(site)
      content_dir = File.join(site.source, '_content')

      # Make sure the content directory exists
      return unless Dir.exist?(content_dir)

      # Get all markdown files in all subdirectories of _content
      markdown_files = Dir.glob(File.join(content_dir, '**', '*.md'))

      # Process each markdown file
      markdown_files.each do |file_path|
        process_file(file_path)
      end
    end

    private

    def process_file(file_path)
      begin
        content = File.read(file_path)

        # Check if file has frontmatter (starts with ---)
        unless content.start_with?('---')
          puts "WARNING: File #{file_path} does not contain frontmatter, skipping."
          return
        end

        # Extract frontmatter
        frontmatter_match = content.match(/\A---\s*\n(.*?)\n---\s*\n/m)
        unless frontmatter_match
          puts "WARNING: File #{file_path} has invalid frontmatter, skipping."
          return
        end

        frontmatter = frontmatter_match[1]

        # Extract permalink from frontmatter
        permalink_match = frontmatter.match(/^permalink:\s*(.+?)\s*$/m)
        unless permalink_match
          puts "WARNING: File #{file_path} has no permalink in frontmatter, skipping."
          return
        end

        permalink = permalink_match[1].strip

        # Generate the expected filename from permalink
        expected_filename = "#{permalink.gsub('-', '_')}.md"
        expected_path = File.join(File.dirname(file_path), expected_filename)

        # Get the current filename
        current_filename = File.basename(file_path)

        # If the filenames don't match, rename the file
        if current_filename != expected_filename
          if DEBUG_MODE
            puts "DEBUG: Would rename #{file_path} to #{expected_path}"
          else
            begin
              # Check if target file already exists to avoid overwriting
              if File.exist?(expected_path)
                puts "WARNING: Cannot rename #{file_path} to #{expected_path} - target file already exists."
                return
              end

              # Rename the file
              File.rename(file_path, expected_path)
              puts "Renamed #{file_path} to #{expected_path}"
            rescue => e
              puts "ERROR: Failed to rename #{file_path} to #{expected_path}: #{e.message}"
            end
          end
        end
      rescue => e
        puts "ERROR: Failed to process #{file_path}: #{e.message}"
      end
    end
  end
end