require 'test_helper'
require 'rexml/document'

class EntryTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    source  = <<-XML
   <?PI context?>
<feed xmlns:google="http://base.google.com/ns/1.0" xml:lang="en-US" xmlns:openSearch="http://a9.com/-/spec/opensearch/1.1/" xmlns="http://www.w3.org/2005/Atom" xmlns:twitter="http://api.twitter.com/">
  <id>tag:search.twitter.com,2005:search/tiger</id>
  <entry>
    <id>tag:search.twitter.com,2005:24851760434647040</id>
    <published>2011-01-11T15:34:56Z</published>
    <link type="text/html" rel="alternate" href="http://twitter.com/kardinal69/statuses/24851760434647040"/>
    <title>RT @FreeTonyTiger: RT @actionforplanet: AFOP: Check out member blog post by @FreeTonyTiger on an imprisoned #tiger in #Louisiana http://ow.ly/3BQDt</title>
    <content type="html">RT &lt;a href=&quot;http://twitter.com/FreeTonyTiger&quot;&gt;@FreeTonyTiger&lt;/a&gt;: RT &lt;a href=&quot;http://twitter.com/actionforplanet&quot;&gt;@actionforplanet&lt;/a&gt;: AFOP: Check out member blog post by &lt;a href=&quot;http://twitter.com/FreeTonyTiger&quot;&gt;@FreeTonyTiger&lt;/a&gt; on an imprisoned &lt;a href=&quot;http://search.twitter.com/search?q=%23tiger&quot; onclick=&quot;pageTracker._setCustomVar(2, 'result_type', 'recent', 3);pageTracker._trackPageview('/intra/hashtag/#tiger');&quot;&gt;#&lt;b&gt;tiger&lt;/b&gt;&lt;/a&gt; in &lt;a href=&quot;http://search.twitter.com/search?q=%23Louisiana&quot; onclick=&quot;pageTracker._setCustomVar(2, 'result_type', 'recent', 3);pageTracker._trackPageview('/intra/hashtag/#Louisiana');&quot;&gt;#Louisiana&lt;/a&gt; &lt;a href=&quot;http://ow.ly/3BQDt&quot;&gt;http://ow.ly/3BQDt&lt;/a&gt;</content>
    <updated>2011-01-11T15:34:56Z</updated>
    <link type="image/png" rel="image" href="http://a1.twimg.com/a/1294279085/images/default_profile_5_normal.png"/>
    <twitter:geo>
    </twitter:geo>
    <twitter:metadata>
      <twitter:result_type>recent</twitter:result_type>
    </twitter:metadata>
    <twitter:source>&lt;a href=&quot;http://www.hootsuite.com&quot; rel=&quot;nofollow&quot;&gt;HootSuite&lt;/a&gt;</twitter:source>
    <twitter:lang>en</twitter:lang>
    <author>
      <name>kardinal69 (kardinal69)</name>
      <uri>http://twitter.com/kardinal69</uri>
    </author>
  </entry>
</feed>
XML
doc = REXML::Document.new source
    e = doc.elements["feed/entry"]
    author = e.elements['author/name'].text.split(' ').first
            assert_equal "kardinal69", author
            url =  e.elements['link'].attributes["href"]
            puts url
           date = e.elements['updated'].text
puts date
           image = REXML::XPath.first(e, "link/attribute::href[2]").value
        assert_equal   "http://a1.twimg.com/a/1294279085/images/default_profile_5_normal.png", image
        
           puts image
  end
end
