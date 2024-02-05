module Jekyll
    class AnchorBlock < Liquid::Block

        def initialize(tag_name, params, tokens)
            @params = eval("{#{params}}")
            super
        end

        def render(context)
            contents = super

            # pipe param through liquid to make additional replacements possible
            content = Liquid::Template.parse(contents).render context
            content = content.strip

            output = ""

            content.each_line.with_index do |line, index|

                # Render the version hint depending on whether we are rendering
                # a paragraph with a headline or not
                if index == 0
                     # Yes, the content starts with a headline
                     if line.start_with?("#")
                        output += line
                        output += "Available since Search Guard FLX " + @params[:version] + "\n"
                        output += "{: .available-since}\n"
                     # Content does not start with a headline
                     else
                        output += "Available since Search Guard FLX " + @params[:version] + "\n"
                        output += "{: .available-since}\n\n"
                        output += line
                     end
                else
                    # rest of the content, just append
                    output += line
                end
            end

            output
        end
    end
end

Liquid::Template.register_tag("availablesince", Jekyll::AnchorBlock)