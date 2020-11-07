module Jekyll
  module Algolia
    module Hooks

      # Returns a unique string of hierarchy from title to h6, used for distinct
      def unique_hierarchy(data)
        headings = %w(h1 h2 h3 h4 h5 h6)
        headings.map { |heading| data[heading.to_sym] }.compact.join(' > ')
      end

      def self.should_be_excluded?(filepath)
        puts filepath

        false
      end

      def self.before_indexing_each(item, node, context)
        # `node` is a Nokogiri HTML node, so you can access its type through `node.name`
        # or its classname through `node.attr('class')` for example


        # Just return `nil` instead of `item` if you want to discard this record
#         return nil unless @file.respond_to?(:collection)

        #collection_name = @file.collection.label
        puts item.to_s

        # excluded documents
        if !item[:index_algolia].nil? && !item[:index_algolia]
          return nil
        end

        collection_name = @file.collection.label

        # In Jekyll v3, posts are actually a collection
        return item if collection_name == 'posts'
        # for docs, the main category is the collection name, which is the top element of the hierarchy
        # see unified search model for every Search Guard content
        item[:category] = @file.site.config["labels"]["collections"][collection_name]

        # subcategory, not all entries have one. If it is the same as the collection name
        # this means this article is on first level and does not have a dedicated subcategory
        subcategory =  @file.site.config["labels"]["navigation"][item[:category]]
        item[:subcategory] = subcategory unless subcategory == item[:category]


        item[:unique_hierarchy] = item[:category]
        item[:unique_hierarchy] = item[:unique_hierarchy] + " > " + item[:subcategory] unless item[:subcategory].blank?
        item[:unique_hierarchy] = item[:unique_hierarchy] + " > " + item[:html_title]

        item[:text_all_raw] = node_text_all_raw(node)
        item[:text_all] = node_text_all(node)

        puts "lala"
        puts item[:unique_hierarchy]
        item
      end

      def node_text(node)
        node.content.gsub('<', '&lt;').gsub('>', '&gt;')
      end

      def node_text_all(node)
        text = ""
        nodes = node.xpath("./following-sibling::*")
        nodes.each do |node|
          break if node_heading?(node)
          text = text + " " + node.content # or node.content
        end
        text = text.gsub("\n", ' ')
        text = text.gsub("\\", ' ')
        text = text.gsub("\"", '"')
        text
      end

      def node_text_all_raw(node)
        text = ""
        nodes = node.xpath("./following-sibling::*")
        nodes.each do |node|
          break if node_heading?(node)
          text = text + " " + node.to_s # or node.content
        end
        text
      end

    end
  end
end

