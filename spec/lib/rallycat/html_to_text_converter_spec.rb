require 'spec_helper'

describe HtmlToTextConverter do

  it 'strips away <p> tags and adds a newline to the end of the paragraph' do
    html = '<p>This is a one sentence paragraph.</p>'
    text = HtmlToTextConverter.new(html).parse
    text.should == "This is a one sentence paragraph.\n"
  end

  it 'returns an empty string when given nil' do
    text = HtmlToTextConverter.new(nil).parse
    text.should == ''
  end

  it 'strips away <p> tags and adds a newline to the end of each paragraph' do
    html = '<p>Paragraph 1</p><p>Paragraph 2</p>'
    text = HtmlToTextConverter.new(html).parse
    text.should == "Paragraph 1\nParagraph 2\n"
  end

  it 'strips away spaces in between tags' do
    html = '<p>Paragraph 1</p>  <p>Paragraph 2</p>'
    text = HtmlToTextConverter.new(html).parse
    text.should == "Paragraph 1\nParagraph 2\n"
  end

  it 'consolidates whitespace' do
    html = '<p>I like         <b>hot sauce</b>.</p>'
    text = HtmlToTextConverter.new(html).parse
    text.should == "I like hot sauce.\n"
  end

  it 'converts nbsp to a regular space' do
    html = ' hello&nbsp;world '
    text = HtmlToTextConverter.new(html).parse
    text.should == " hello world "
  end

  it 'turns <br /> into \n' do
    html = '<div>foo<br /> bar</div>'
    text = HtmlToTextConverter.new(html).parse
    text.should == "foo\nbar\n"
  end

  it 'indents and stars items in a list' do
    html = '<ol><li>Item 1</li><li>Item 2</li><li>Item 3</li></ol>'
    text = HtmlToTextConverter.new(html).parse
    text.should == "  * Item 1\n  * Item 2\n  * Item 3\n\n"
  end

  it 'converts complex HTML to clean plain text' do
    html = "<div>This is a story:</div>  <div><br /></div>  <div>  <ul>  <li>list item 1</li>  <li>list item 2</li>  </ul>  </div>  <div>We need to do something important.</div>  <div><br /></div>  <div>NOTE:</div>  <div>- a note with the word <b><font color=\"#ff0000\">red</font></b>:</div>  <div>Some more text.</div>  <div><br /></div>  <div><b>QA:</b></div>  <div>Instructions for QA.</div>"

    expected = <<-TEXT
This is a story:


  * list item 1
  * list item 2


We need to do something important.


NOTE:
- a note with the word red:
Some more text.


QA:
Instructions for QA.
TEXT

    text = HtmlToTextConverter.new(html).parse
    text.should == expected
  end
end
