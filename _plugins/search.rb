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

    # excluded documents
    if !item[:index_algolia].nil? && !item[:index_algolia]
      return nil
    end

    algolia_hierarchy = @file.site.config["collections"][@file.collection.label]["algolia_hierarchy"]


    # In Jekyll v3, posts are actually a collection
    return item if @file.collection.label == 'posts'
    item[:unique_hierarchy] = algolia_hierarchy + " > " + unique_hierarchy(item)
    item[:text_all_raw] = node_text_all_raw(node)
    item[:text_all] = node_text_all(node)

    if item.to_s.bytesize > 20000
      puts "Item with permalink #{item[:permalink]} is too large (> 20K). Probably the headings are not on hierarchy."
      item
    end
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
