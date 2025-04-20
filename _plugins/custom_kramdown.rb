# _plugins/custom_kramdown.rb

module Kramdown
  module Converter
    class Html
      # Save the original method if you want to call it for default behavior.
      alias_method :original_convert_codeblock, :convert_codeblock

      def convert_codeblock(el, indent)

        # Retrieve the specified language (if any)
        language = el.options[:lang] || "yaml"
        code = el.value

        # Build your custom HTML structure here.
        # For example, wrapping the code block in an extra div.
        custom_html =  "<div class=\"code-highlight\" data-label=\"\">\n"
        custom_html <<  "<span class=\"js-copy-to-clipboard copy-code\">copy</span>\n"
        custom_html << "<pre class=\"language-#{language}\"><code class=\"js-code language-#{language}\">#{code}</code></pre>"
      end
    end
  end
end
