require 'nokogiri'
require 'htmlentities'

Awestruct::Extensions::Pipeline.new do
  if Gem::Version.new(RUBY_VERSION) < Gem::Version.new('1.9.3') then
    raise 'Upgrade your Ruby to the latest stable version. The current version is: ' + RUBY_VERSION
  end

  extension Awestruct::Extensions::Posts.new( '/news', :posts )
  extension Awestruct::Extensions::Atomizer.new( :posts, '/news/index.atom' )
  extension Awestruct::Extensions::Disqus.new()
end

