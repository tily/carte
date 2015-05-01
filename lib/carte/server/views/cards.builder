xml.instruct! :xml, version: '1.0'
xml.rss version: "2.0", :"xmlns:atom" => "http://www.w3.org/2005/Atom" do
  xml.channel do
    xml.tag! "atom:link", href: "http://#{request.host}/api/cards.xml?#{request.env['QUERY_STRING']}", rel: "self", type: "application/rss+xml"
    xml.title settings.carte['title']
    xml.description settings.carte['description']
    xml.link "http://#{request.host}/"
    @cards.each do |card|
      xml.item do
        xml.title(card.title)
        xml.description card.content
        xml.link("http://#{request.host}/#/#{URI.escape(card.title)}")
        xml.pubDate card.updated_at.rfc822
        xml.guid({isPermaLink: false}, "http://#{request.host}/#/#{URI.escape(card.title)}##{card.updated_at.to_i}")
      end
    end
  end
end
