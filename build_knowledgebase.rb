require 'contentful'
require 'fileutils'
require 'getoptlong'
require 'rubygems'
require 'algoliasearch'

class Knowledgebase

	def initialize(buildIndex)
			
		@buildIndex = buildIndex

		Algolia.init(application_id: '2ESDTH812Y', api_key: ENV["ALGOLIA_CONTENTFUL_API_KEY"])
		@index = Algolia::Index.new('knowledgebase')

		# global directory for all KB articles
		FileUtils.rm_rf('./_content/_knowledgebase/')
		Dir.mkdir './_content/_knowledgebase/'

		@client = Contentful::Client.new(
			space: 'fv1w3r56dz7z',  # This is the space ID. A space is like a project folder in Contentful terms
			access_token: ENV['CONTENTFUL_KB_API_KEY'],  # This is the access token for this space. Normally you get both ID and the token in the Contentful web app
			include: 4,
			dynamic_entries: :auto
		)

		# collects all nav entries for main and subcategories
		@maincategories_nav = {}
	end

	def build_knowledgebase ()
		# get all main categories from contentful
		maincategories = @client.entries(content_type: 'maincategory', order: 'fields.order')

		maincategories.each { |maincategory|
			process_maincategory(maincategory)
		}	

		generate_navigation
	end

	def process_maincategory (maincategory)
		# for building nav and overview pages
		@maincategories_nav[maincategory] = []

#		# one directory for each main cat
#		Dir.mkdir './_content/_kb_' + maincategory.id
#		# one overview file for each main category
#		f = File.new('./_content/_kb_' + maincategory.id + "/" + maincategory.id + "-overview.md", 'a')

		# one overview file for each main category
		f = File.new('_content/_knowledgebase/' + maincategory.id + "-overview-kb.md", 'a')
		f.write("---\n")
		f.write("title: #{maincategory.title}\n")
		f.write("html_title: #{maincategory.title}\n")
		f.write("slug: #{maincategory.id}-overview-kb\n")
		f.write("category: #{maincategory.id}\n")
		f.write("order: #{maincategory.order}\n")
		f.write("layout: knowledgebase\n")
		f.write("description: \n")
		f.write("---\n\n")

		f.write("# #{maincategory.title}\n\n")

		f.close

		# get all sub categories for this main category
		subcategories = @client.entries(content_type: 'subcategory', 'fields.maincategory.sys.contentType.sys.id' => "maincategory", 'fields.maincategory.fields.id' => maincategory.id, order: 'fields.order')  #add sorting   		
   		subcategories.each { |subcategory|
   			@maincategories_nav[maincategory].push(subcategory)
			process_subcategory(maincategory, subcategory)
		}
		
	end

	def process_subcategory (maincategory, subcategory)
		
		articles = @client.entries(content_type: 'knowledge-base-article', 'fields.subcategory.sys.contentType.sys.id' => "subcategory", 'fields.subcategory.fields.id' => subcategory.id)  #add sorting   		
	
		# append subcategory and all articles to main category overview
		maincategoryoverview = File.open('_content/_knowledgebase/' + maincategory.id + "-overview-kb.md", 'a')

		# generate one overview file for the subcategory as welll
		subcategoryoverview = File.new('_content/_knowledgebase/' + subcategory.id + "-overview-kb.md", 'a')
		
		subcategoryoverview.write("---\n")
		subcategoryoverview.write("title: #{subcategory.title}\n")
		subcategoryoverview.write("html_title: #{subcategory.title}\n")
		subcategoryoverview.write("slug: #{subcategory.id}-overview-kb\n")
		subcategoryoverview.write("category: #{maincategory.id}\n")
		subcategoryoverview.write("subcategory: #{subcategory.id}\n")
		subcategoryoverview.write("order: #{subcategory.order}\n")
		subcategoryoverview.write("layout: knowledgebase\n")
		subcategoryoverview.write("description: \n")
		subcategoryoverview.write("---\n\n")


		maincategoryoverview.write("\n## [#{subcategory.title}](#{subcategory.id}-overview-kb)\n\n")
		
		subcategoryoverview.write("\n# #{subcategory.title}\n\n")
		subcategoryoverview.write("[#{maincategory.title}](#{maincategory.id}-overview-kb) > #{subcategory.title}\n")
		subcategoryoverview.write("{: .breadcrumb}\n\n")

		articles.each { |article|
   			generate_article(maincategory, subcategory, article)
   			maincategoryoverview.write("* [#{article.question}](#{article.slug}-kb)\n")	 
   			subcategoryoverview.write("* [#{article.question}](#{article.slug}-kb)\n")	 
		}
		maincategoryoverview.close
		subcategoryoverview.close
	end


	
	def generate_article (maincategory, subcategory, article)

		puts "Generating article: #{article.question}"

		f = File.new('_content/_knowledgebase/' + article.slug + "-kb.md", 'a')
		f.write("---\n")
		f.write("title: #{article.question}\n")
		f.write("html_title: #{article.question}\n")
		f.write("slug: #{article.slug}-kb\n")
		f.write("category: #{maincategory.id}\n")
		f.write("subcategory: #{subcategory.id}\n")
		f.write("order: 50\n")
		f.write("layout: knowledgebase\n")
		f.write("description: \n")
		f.write("---\n\n")

		f.write("Search Guard Knowledgebase\n")
		f.write("\n")

		f.write("# #{article.question}\n")

		f.write("[#{maincategory.title}](#{maincategory.id}-overview-kb) > [#{subcategory.title}](#{subcategory.id}-overview-kb)\n")
		f.write("{: .breadcrumb}\n\n")
		
		f.write("#{article.answer}\n\n")
		f.close

		generate_additional_resources(maincategory, subcategory, article)

		if (@buildIndex == true) 
			index(maincategory, subcategory, article)
		end

	end

	def generate_additional_resources (maincategory, subcategory, article)
		f = File.open('_content/_knowledgebase/' + article.slug + "-kb.md", 'a')

		# if there are no related questions or resources, the contentful API throws an exception, thus the resce blocks here

		# related questions
		begin			
			if article.relatedquestions.any?
				f.write('<div class="faq-table-of-contents">')
				f.write('<p class="faq-table-of-contents-title">Related questions</p>')
				f.write('<ul style="list-style-type: none">')
				article.relatedquestions.each { |question|
					f.write("<li><a href='#{question.slug}-kb'>#{question.question}</a></li>")	 
				}
				f.write('</ul>')
				f.write('</div>')
			end
		rescue
		end
		
		# Additional resources
		begin			
			if article.additionalresources.any?

				f.write('<div class="faq-table-of-contents">')
				f.write('<p class="faq-table-of-contents-title">Additional resources</p>')
				f.write('<ul style="list-style-type: none">')

				article.additionalresources.each { |resource|
					f.write("<li><a href='#{resource.url}' target='_blank'>#{resource.title}</a></li>")	 
				}

				f.write('</ul>')
				f.write('</div>')
			end
		rescue StandardError => e  
			#puts e.message  			
		end
	end

	def generate_navigation ()
		FileUtils.rm_rf('./_kb.yml');
		f = File.new('./_kb.yml', 'a')
		
		f.write("kb:\n")
		f.write("  navigation:\n")

		@maincategories_nav.each_key { |maincategory|
			f.write("    #{maincategory.title}: #{maincategory.id}\n")
		}	
		f.close
	end

	def index(maincategory, subcategory, article)
		puts "Indexing article: #{article.question}"

		alternativequestions = []
		begin
			alternativequestions = article.alternativequestions
		rescue
		end
		
		obj = {
  			question: "#{article.question}",
  			alternativequestions:  alternativequestions,
  			answer:  "#{article.answer}",
			slug:  "#{article.slug}-kb",
  			maincategory:  "#{maincategory.title}",
  			maincategory_id:  "#{maincategory.id}",
  			subcategory:  "#{subcategory.title}",
  			subcategory_id:  "#{subcategory.id}"
		}

#		puts obj
		res = @index.add_object(obj ,"#{article.sys['id']}")
	end
end

opts = GetoptLong.new(
  [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
  [ '--index', '-i', GetoptLong::OPTIONAL_ARGUMENT ]
)

index = false

opts.each do |opt, arg|
  case opt
    when '--help'
      puts <<-EOF
./build_knowledgebase.rb  [OPTION] 

-h, --help:
   show help

--index, -i:
   index articles in Algolia

You need to set CONTENTFUL_KB_API_KEY as environment variable. This key needs to have permissions to read the knowledgebase contentful colllection.

You need to set ALGOLIA_API_KEY as environment variable. This key needs to have permissions to write to Algolia.

EOF
    when '--index'
      index = true
   end
end

kb = Knowledgebase.new(index)
kb.build_knowledgebase