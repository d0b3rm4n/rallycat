require 'nokogiri'

class HtmlToTextConverter

  def parse(html)
    html = html.gsub(/>\s+</, '><') # remove whitespace between tags
    html = html.gsub('&nbsp;', ' ') # replace nbsp with regular space

    fragment = Nokogiri::HTML.fragment(html)

    fragment.css('p, div, ul, ol, br').each { |node| node.after("\n") }

    fragment.xpath('.//text()').each do |node|
      if node.content =~ /\S/
        node.content = node.text.gsub(/\s+/, ' ') # consolidate whitespace
      else
        node.remove # remove nodes that are only whitespace
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
