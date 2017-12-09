class AlgoliaSearchRecordExtractor

  
  # Returns a unique string of hierarchy from title to h6, used for distinct
  def unique_hierarchy(data)
    headings = %w(h1 h2 h3 h4 h5 h6)
    headings.map { |heading| data[heading.to_sym] }.compact.join(' > ')
  end

  def custom_hook_each(item, node)
    # `node` is a Nokogiri HTML node, so you can access its type through `node.name`
    # or its classname through `node.attr('class')` for example

    
    # Just return `nil` instead of `item` if you want to discard this record
    return nil unless @file.respond_to?(:collection)
    return nil if item[:category] == "changelogs"

    collection_name = @file.collection.label

    # In Jekyll v3, posts are actually a collection
    return item if collection_name == 'posts'
    item[:collection_name] = @file.site.config["labels"]["collections"][collection_name]
    item[:category_name] = @file.site.config["labels"]["navigation"][item[:category]]
    item[:unique_hierarchy] = item[:collection_name] + " > " + item[:unique_hierarchy]
    item[:text_all_raw] = node_text_all_raw(node)
    item[:text_all] = node_text_all(node)
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