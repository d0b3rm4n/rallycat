require 'nokogiri'

class HtmlToTextConverter

  def parse(html)
    html = html.gsub(/>\s+</, '><') # remove whitespace between tags
    html = html.gsub('&nbsp;', ' ') # replace nbsp with regular space

    fragment = Nokogiri::HTML.fragment(html)

    fragment.css('br, p, div, ul, ol').each { |node| node.after("\n") }

    fragment.xpath('.//text()').each do |node|
      if node.content =~ /\S/ # has non-whitespace characters
        node.content = node.text.gsub(/\s+/, ' ') # consolidate whitespace
        node.content = node.text.lstrip
      else
        # remove nodes that are only whitespace
        node.remove unless node.content.include?("\n")
      end
    end

    # Make lists pretty:
    #   * list item 1 
    #   * list item 2
    #   * list item 3
    fragment.css('li').each do |node| 
      node.content = "  * #{node.content}\n"
    end

    fragment.text
  end
end
