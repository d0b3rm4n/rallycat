require 'nokogiri'

class HtmlToTextConverter

  def initialize(html_string)
    @html_string = html_string
  end

  def parse
    html = pre_parse

    @fragment = Nokogiri::HTML.fragment(html)

    add_newline_after_block_elements
    parse_whitespace
    parse_lists

    @fragment.content
  end

  private

  def pre_parse
    html = @html_string.gsub(/>\s+</, '><') # remove whitespace between tags
    html.gsub('&nbsp;', ' ')                # replace nbsp with regular space
  end

  def add_newline_after_block_elements
    @fragment.css('br, p, div, ul, ol').each { |node| node.after("\n") }
  end

  def parse_whitespace
    @fragment.xpath('.//text()').each do |node|
      if node.content =~ /\S/ # has non-whitespace characters
        node.content = node.content.squeeze(' ') # consolidate whitespace
        node.content = node.content.lstrip
      else
        # remove nodes that are only whitespace
        node.remove unless node.content.include?("\n")
      end
    end
  end

  def parse_lists
    # Make lists pretty:
    #   * list item 1
    #   * list item 2
    #   * list item 3
    @fragment.css('li').each do |node|
      node.content = "  * #{node.content}\n"
    end
  end

end
