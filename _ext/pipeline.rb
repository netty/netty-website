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
    for r in site.releases
      if r.simple_version.nil?
        r.simple_version = r.version.sub(/^([0-9]+\.[0-9]+).*$/, '\1')
      end
      if r.filename.nil?
        if r.version.start_with?("3.")
          r.filename = 'netty-' + r.version + '-dist.tar.bz2'
        else
          r.filename = 'netty-' + r.version + '.tar.bz2'
        end
      end
      if r.branch.nil?
        r.branch = r.simple_version
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

