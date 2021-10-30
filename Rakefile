require 'html-proofer'
require 'jekyll'

task default: %w[test]

task :clean do
  puts 'Cleaning up _site...'.bold
  Jekyll::Commands::Clean.process({})
end

task :build => [:clean] do
  puts 'Building site...'.bold
  Jekyll::Commands::Build.process(profile: true)
end


task :test => [:build] do
    run_htmlproofer
end

def run_htmlproofer() # The function that will run the proofer, so that we can re-use it between our two rake tasks

    # bloody syntax, took me ages to figure it out.
    url_swap = {
        /^\/latest\// => "/"
    }

    options = {
      assume_extension: true, # Assumes html file extensions
      :typhoeus => { # need to disable verification of certificate, many CAs are not regognized for some reason
        :ssl_verifyhost => 0,
        :ssl_verifypeer => false
      },
      allow_hash_href: true, # for top-level navigation items we just have a hash as url
      empty_alt_ignore: true, # maybe enable in future
      enforce_https: true,
      # log_level: "debug",
      :url_swap => url_swap,
      url_ignore: [
      /6.x-[0-9]{2}/,
      /7.x-[0-9]{2}/,
      /v5/,
      /v2/,
      /resources/,
      /github.com/ # links to old issues and PRs don't work anymore
      ]
    }
    HTMLProofer.check_directory("./_site", options).run

    # FOR DEBUGGING:
    #HTMLProofer.check_file("./_site/changelog-searchguard-7x-36_0_0.html", options).run
end