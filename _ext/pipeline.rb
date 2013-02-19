
Awestruct::Extensions::Pipeline.new do
  extension Awestruct::Extensions::Posts.new( '/news', :posts )
  extension Awestruct::Extensions::Atomizer.new( :posts, '/news/index.atom' )
  extension Awestruct::Extensions::Disqus.new()
end

