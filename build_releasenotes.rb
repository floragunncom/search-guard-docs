require 'rubygems'
require 'pp'
require 'jira-ruby'
require 'getoptlong'
require 'fileutils'

class Releasenotes

	def initialize(esversion, sgversion)
			
		@esversion = esversion
		@sgversion = sgversion

		versionAsInt = @sgversion.gsub(/\./, '').to_i
		@order = 4700 - versionAsInt

		@rn_field = "customfield_11326"
		
		puts "Building changelogs for ES version #{esversion} and SG version #{sgversion}"

		options = {
					:username => ENV['JIRA_USERNAME'],
					:password => ENV['JIRA_API_KEY'],
					:site     => 'https://floragunn.atlassian.net/', 
					:context_path => '', 
					:auth_type => :basic,
					:read_timeout => 120
				  }
		
		@client = JIRA::Client.new(options)

		@issueTypes = {
			"New Feature" => "New Features", 
			"Improvement" => "Improvements", 
			"Bug" => "Bug Fixes", 
			"Security Issue" => "Security Fixes",
			"Documentation" => "Documentation",
			"Task" => "Other"
		}

	end

	def generate	

		core_epics = fetch_epics("Search Guard Core")
		kibana_epics = fetch_epics("Search Guard Kibana Plugin")
		
		puts "Fetched Search Guard Core Epics:"

		core_epics.each { |epicKey, epicName| 
			puts "#{epicKey} - #{epicName}"
		}
		
		puts "Fetched Search Guard Kibana Plugin Epics:"

		kibana_epics.each { |epicKey, epicName| 
		puts "#{epicKey} - #{epicName}"
		}

		generate_changelog(core_epics, true)
		generate_changelog(kibana_epics, false)
	end

	def fetch_epics(productname)
		epics_map = Hash.new
		epics = @client.Issue.jql("project = SGD AND issuetype = Epic AND status = \"To Do\" AND Product = \"#{productname}\" ORDER BY issuekey ASC", max_results: 500) 
		epics.each do |epic|
			epics_map[epic.key] = epic.summary
		end
		return epics_map
	end

	def generate_changelog (epics, isCore)		
		filename = "./_content/_changelogs/changelog_#{isCore ? 'searchguard' : 'kibana'}_#{@esversion}_x_#{@sgversion.gsub(/\./, '_')}.md"
		# remove previous version
		FileUtils.rm_f(filename)
		puts filename
		file = File.new(filename, 'a')
		generate_file_header(file, isCore)

		generate_changelog_entries(file, epics)
	ensure
		file.close
	end

	def generate_file_header (file, isCore)
		
		t = Time.now

		pluginName = isCore ? "Search Guard" : "Kibana" 
		pluginNameLower = isCore ? "searchguard" : "kibana" 

		file.write("---\n")
		file.write("title: #{pluginName} #{@esversion}.x-#{@sgversion}\n")
		file.write("slug: changelog-#{pluginNameLower}-#{@esversion}.x-#{@sgversion.gsub(/\./, '_')}\n")
		file.write("category: changelogs-#{pluginNameLower}\n")
		file.write("order: #{@order}\n")
		file.write("layout: changelogs\n")
		file.write("description: Changelog for #{pluginName} #{@esversion}.x-#{@sgversion}	\n")
		file.write("---\n\n")

		file.write("<!--- Copyright #{t.year} floragunn GmbH -->\n\n")

		file.write("**Release Date: #{t.strftime("%d.%m.%Y")}**\n\n")

		file.write("* [Upgrade Guide from 6.x to 7.x](../_docs_installation/installation_upgrading_6_7.md)\n\n")

	end

	def generate_changelog_entries (file, epics)

		version = "SG#{@esversion} #{@sgversion}"
		
		@issueTypes.each { |issueType, issueTypeDisplayName| 
			
			holder = Hash.new

			epics.each { |epicKey, epicName| 
	
				issuesByTypeAndEpic = fetchIssues(version, epicKey, epicName, issueType)

				puts "Found #{issuesByTypeAndEpic.length} issues for type #{issueType} and epic #{epicName}" unless issuesByTypeAndEpic.nil?
				puts "Found no issued for #{issuesByTypeAndEpic.length} for type #{issueType} and epic #{epicName}" if issuesByTypeAndEpic.nil?

				unless issuesByTypeAndEpic.nil? || issuesByTypeAndEpic.empty? 
					holder[epicName] = issuesByTypeAndEpic
				end
			
			}
			
			# render section if we have any issues in this category
			unless holder.empty?
				generate_issues_for_type(file, issueTypeDisplayName, holder)
			end
		}
	end

	def generate_issues_for_type(file, issueTypeDisplayName, holder)
		
		file.write("## #{issueTypeDisplayName}\n\n")
		
		holder.each { |epicName, issues|
			file.write("\n\n")
			file.write("### #{epicName}\n\n")

			issues.each do |issue|
				
				level = 0
				# RN field, honor new lines
				rnotes = issue.fields['customfield_11326']
				unless rnotes.nil?					
					    rnotes.split("\n").each do |linernote|
                            indentation = level == 0 ? "* " : "  * "
                            file.write("#{indentation}#{linernote}\n") unless linernote.blank?
                            level += 1
					end
				end
				file.write ("<p />\n")
			end
		} 
		file.write("\n\n")
	end

	def fetchIssues(version, epicKey, epicName, issueType)
		query = "fixVersion=\"#{version}\" AND project=\"SGD\" AND status=Done AND \"Epic Link\" = \"#{epicKey}\" AND type = \"#{issueType}\" ORDER BY issuekey DESC "		
		issues = @client.Issue.jql(query, max_results: 500)
		return issues
	end

end

esversion = nil
sgversion = nil
help = false

opts = GetoptLong.new(
  [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
  [ '--esversion', '-e', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--sgversion', '-s', GetoptLong::REQUIRED_ARGUMENT ]
)

opts.each do |opt, arg|
  case opt
	when '--help'
	  help = true
      puts <<-EOF
./build_releasenptes.rb  [OPTION] 

-h, --help:
   show help

--esversion, -e:
The major version of Elasticsearch / Kbana


--sgversion, -s:
   The release version as used in JIRA

You need to set the following environment variables:

JIRA_USERNAME: The JIRA username
JIRA_API_KEY: The API key to use with this username

EOF

	when '--esversion'
		esversion = arg

	when '--sgversion'
		sgversion = arg

	end

end

if help
	exit 0
end


if !esversion 
	puts "Missing --esversion argument (try --help)"
	puts 'Example: ruby build_releasenotes.rb -e 7 -s 41.0.0'
	exit 0
end

if !sgversion 
	puts "Missing --sgversion argument (try --help)"
	puts 'Example: ruby build_releasenotes.rb -e 7 -s 41.0.0'
	exit 0
end

rn = Releasenotes.new(esversion, sgversion)
rn.generate()