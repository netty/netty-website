require 'nokogiri'
require 'htmlentities'

class RelativeSiteUrl
  def execute(site)
    for p in site.pages
      if p.simple_name == '404'
        # Use the absolute path for 404
        p.site_url = site.base_url
      else
        p.output_path_depth = p.output_path.count('/\\') - 1;
        if p.output_path_depth == 0
          p.site_url = '.'
        else
          p.site_url = '../' * (p.output_path_depth - 1) + '..'
        end
      end
    end
  end
end

class ReleaseInfo
  def execute(site)
    simple_versions = Hash.new
    for r in site.releases
      r.site = site
      r.extend Release

      if r.stable and site.latest_stable_release.nil?
        site.latest_stable_release = r
      end

      if r.major_version.nil?
        r.major_version = r.version.sub(/^([0-9]+).*$/, '\1').to_i
      end
      if r.simple_version.nil?
        r.simple_version = r.version.sub(/^([0-9]+\.[0-9]+).*$/, '\1')
      end
      if not simple_versions.has_key?(r.simple_version)
        simple_versions[r.simple_version] = r
      end
      if r.filename.nil?
        if r.major_version > 3
          r.filename = 'netty-' + r.version + '.tar.bz2'
        else
          r.filename = 'netty-' + r.version + '-dist.tar.bz2'
        end
      end
      if r.branch.nil?
        r.branch = r.simple_version
      end
#      if r.example_url.nil?
#        if r.major_version > 3
#          r.example_url = site.base_url + r.simple_version + '/xref/io/netty/example'
#        else
#          r.example_url = site.base_url + r.simple_version + '/xref/io/netty/example'
#          r.example_url = 'https://github.com/netty/netty/tree/' + r.branch + '/src/main/java/org/jboss/netty/example'
#        end
#      end
    end

    site.major_releases = simple_versions.values
  end

  module Release
    def example_url(name = nil)
      if self.major_version > 3
        if name.nil?
          'https://github.com/netty/netty/tree/' + self.branch + '/example/src/main/java/io/netty/example'
        else
          site.base_url + '/' + self.simple_version + '/xref/io/netty/example/' + name + '/package-summary.html'
        end
      else
        # The WorldClock example was LocalTime in 3.
        if name == 'worldclock'
          name = 'localtime'
        end

        if name.nil?
          'https://github.com/netty/netty/tree/' + self.branch + '/src/main/java/org/jboss/netty/example'
        else
          site.base_url + '/' + self.simple_version + '/xref/org/jboss/netty/example/' + name + '/package-summary.html'
        end
      end
    end
  end
end

Awestruct::Extensions::Pipeline.new do
  if Gem::Version.new(RUBY_VERSION) < Gem::Version.new('1.9.3') then
    raise 'Upgrade your Ruby to the latest stable version. The current version is: ' + RUBY_VERSION
  end

  extension Awestruct::Extensions::Posts.new( '/news', :posts )
  extension Awestruct::Extensions::Disqus.new()

  extension ReleaseInfo.new()
  extension RelativeSiteUrl.new()

  extension Awestruct::Extensions::Atomizer.new( :posts, '/news/index.atom' )
end

