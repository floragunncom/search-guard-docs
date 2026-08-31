module Jekyll
  # The individual changelog entries live in their own data files,
  # _data/side_navigation_changelog_*.yml. Each of those files holds a single root
  # whose slug matches a childless node in a section navigation, for example
  # "changelogs-kibana" under Changelogs in side_navigation_security.yml.
  #
  # Nothing ever referenced those files, so the entries never reached any
  # navigation: a changelog page rendered its section's navigation, failed to find
  # its own slug in it, and was left with a fully collapsed sidebar and no
  # breadcrumbs.
  #
  # Attach every changelog tree to the node carrying the same slug. Runs before the
  # breadcrumb and category page generators so both see the completed tree.
  class ChangelogNavigationGenerator < Generator
    safe true
    priority :high

    NAV_PREFIX = 'side_navigation_'.freeze
    CHANGELOG_PREFIX = 'side_navigation_changelog_'.freeze

    def generate(site)
      changelog_navs = site.data.select { |key, _| key.start_with?(CHANGELOG_PREFIX) }
      return if changelog_navs.empty?

      section_navs = site.data.select do |key, value|
        value.is_a?(Array) && key.start_with?(NAV_PREFIX) && !key.start_with?(CHANGELOG_PREFIX)
      end

      changelog_navs.each do |file_key, roots|
        next unless roots.is_a?(Array)

        roots.each { |root| attach(site, section_navs, file_key, root) }
      end
    end

    private

    def attach(site, section_navs, file_key, root)
      return unless root.is_a?(Hash) && root['slug']

      children = root['children']
      return if children.nil? || children.empty?

      target = nil
      section_navs.each_value do |nav|
        target = find_by_slug(nav, root['slug'])
        break if target
      end

      if target.nil?
        Jekyll.logger.warn 'Changelog nav:',
                           "no navigation entry with slug '#{root['slug']}' for #{file_key}, skipping"
        return
      end

      # Never overwrite a subtree somebody maintains by hand.
      unless target['children'].nil? || target['children'].empty?
        Jekyll.logger.warn 'Changelog nav:',
                           "'#{root['slug']}' already has children, leaving #{file_key} unattached"
        return
      end

      target['children'] = children
      Jekyll.logger.info 'Changelog nav:',
                         "attached #{children.size} entries from #{file_key} to '#{root['slug']}'"
    end

    def find_by_slug(items, slug)
      return nil unless items.is_a?(Array)

      items.each do |item|
        next unless item.is_a?(Hash)
        return item if item['slug'] == slug

        found = find_by_slug(item['children'], slug)
        return found if found
      end

      nil
    end
  end
end
