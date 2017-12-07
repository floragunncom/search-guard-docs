require 'addressable/uri'
require 'css_parser'
require 'nokogiri'

require 'jekyll_sanity_checker/errors'

module JekyllSanityChecker
  def process
    super

    # Check that the Jekyll config has the stuff we'll need.
    begin
      config['sanity_check']['host']
    rescue
      raise Jekyll::Errors::FatalException, 'need to fix up your Jekyll configuration for this plugin to work! Please see README.md'
    end

    JekyllSanityChecker.load_redirects(@config)

    Jekyll.logger.info('checking for dumb mistakes!')

    run_success = true

    Dir.glob("#{dest}/**/*.html") do |html|
      run_success = JekyllSanityChecker.check_html(@config, html) && run_success
    end

    Dir.glob("#{dest}/**/*.css") do |css|
      run_success = JekyllSanityChecker.check_css(@config, css) && run_success
    end

    # If Jekyll is run with --watch , don't raise FatalException, just warn. Fixes #4 .
    raise Jekyll::Errors::FatalException, 'checks failed' if !config.fetch('watch', false) && !run_success
  end

  def self.aggregate_errors(page, el = nil)
    yield
    true
  rescue CheckFailed => e
    if el.nil?
      Jekyll.logger.error("\nproblem on #{page}")
    else
      Jekyll.logger.error("\nproblem on #{page} , line #{el.line}")
      Jekyll.logger.error(el.to_s.strip)
    end
    Jekyll.logger.error(e.message)
    false
  end

  def check_html(config, page)
    success = true
    doc = Nokogiri::HTML::Document.parse File.read(page)

    doc.css('a').each do |link|
      success = aggregate_errors(page, link) do
        # Does the link have an href atttribute?
        raise LinkNoHref unless link.keys.include? 'href'

        # If it's a hash-only URL then that's fine.
        next if link['href'].start_with? '#'

        # What's the URL of this page when it's deployed?
        absolute_destination = File.expand_path(config['destination'])
        from_url = File.expand_path(page)
        raise 'terrible problem' unless from_url.slice!(absolute_destination) == absolute_destination

        check_resource(config, link['href'], %w(mailto), true, from_url)
      end && success
    end

    doc.css('img').each do |img|
      success = aggregate_errors(page, img) do
        # Does the img have a src attribute?
        raise ImgNoSrc unless img.keys.include? 'src'
        check_resource(config, img['src'], %w(data))
      end && success
    end

    success
  end
  module_function :check_html

  def check_css(config, stylesheet)
    parser = CssParser::Parser.new
    parser.load_file! stylesheet
    success = true
    parser.each_rule_set do |rule_set, _|
      rule_set.each_declaration do |_, value, _|
        match = /url\((.*?)\)/.match value
        next if match.nil?
        success = aggregate_errors(stylesheet) do
          check_resource(config, match[1].tr('\'"', ''), %w(data))
        end && success
      end
    end
    success
  end
  module_function :check_css

  def load_redirects(config)
    apache_redirects = nil
    begin
      apache_redirects = config['sanity_check']['apache_redirects']
    rescue
    end
    @redirects = {}
    unless apache_redirects.nil?
      File.open(apache_redirects, 'r:UTF-8').each_line do |line|
        m = /Redirect (\S+) (\S+) (\S+)/.match line
        @redirects[m[2]] = m[3] unless m.nil?
      end
    end
    @redirects
  end
  module_function :load_redirects

  def self.check_resource(config, src, shortcircuit_valid_schemes = [], loose_html = false, from_url = nil)
    # Parse the URL,
    begin
      uri = Addressable::URI.parse(src)
    rescue Addressable::URI::InvalidURIError
      raise InvalidURL, src
    end

    # Maybe the scheme tells us that the URI is okay.
    return if shortcircuit_valid_schemes.include? uri.scheme

    # Otherwise the scheme should be http or https.
    raise InvalidScheme, uri.scheme unless [nil, 'http', 'https'].include? uri.scheme

    # Only absolute URLs please.
    this_host = config['sanity_check']['host']
    raise FullyQualifiedURL, uri if uri.host == this_host

    # Resolve redirects..
    if @redirects.include? uri.path
      redirect_uri = Addressable::URI.parse(@redirects[uri.path])
      # .. if redirect is just a path, use that,
      if redirect_uri.host.nil?
        uri.path = redirect_uri.path
      else
        # otherwise use redirect host/path .
        uri = redirect_uri
      end
    end

    # And if it's a local resource,
    if uri.host.nil?
      # Check that it's not a relative url.
      raise RelativeURL.new(uri, from_url) unless uri.path.start_with? '/'

      parts = URI.unescape(uri.path).split('/').reject { |s| s.empty? }
      path = ([File.expand_path(config['destination'])] + parts).join(File::SEPARATOR)

      if loose_html
        if self.file?(path) && File.directory?(path)
          # We treat links to directories special: if there is a directory/index.html, it is ok.
          raise NoIndexHTML, path unless self.file? "#{path}/index.html"
        else
          # A bla.html can be referenced as bla.
          raise FileDoesNotExist, path unless self.file?(path) || self.file?("#{path}.html")
        end
      else
        # Check that the file exists.
        raise FileDoesNotExist, path unless self.file? path
      end
    end
  end

  def self.file?(fn)
    # This relies on a not-obvious property of File.{dirname,basename}: for
    # files, those functions behave as you would expect. For directories,
    # File.dirname('lib') returns '.' and File.basename('lib') returns 'lib'.
    Dir.entries(File.dirname(fn)).include? File.basename(fn)
  end
end

module Jekyll
  class Site
    prepend JekyllSanityChecker
  end
end