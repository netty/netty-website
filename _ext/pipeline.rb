
Awestruct::Extensions::Pipeline.new do
  extension Awestruct::Extensions::Posts.new( '/news', :posts )
  extension Awestruct::Extensions::Disqus.new()
end

