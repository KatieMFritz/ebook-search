class KindleUnlimitedEbookSearcher

  attr_reader :query

  def initialize query
    @query = query
  end

  # replace spaces in query for proper URL syntax
  def sanitized_query
    @query.split(/\s+/).join('+')
  end

  # add query to search URL
  def search_url
    "http://www.amazon.com/s/?url=node%3D9069934011&field-keywords=#{sanitized_query}"
  end

  # get page contents using rest-client gem
  # after the first time, it's stored as an instance variable called @page (this is called memo-ization)
  def page
    @page ||= RestClient.get(search_url)
  end

  # parse page contents as html
  def html
    Nokogiri::HTML(page)
  end

  # get text saying how many total results and clean it up
  def total_results_count
    if html.css("h2#s-result-count").any?
      html.css("h2#s-result-count").text[/(\d+.*results?)/, 1]
    else
      "No results"
    end
  end

  # get the array of result html chunks
  def results_html
    html.css("li.s-result-item")
  end

  # map each chunk of result html into KindleUnlimitedEbookResult
  def results
    results_html.map do |result_html|
      KindleUnlimitedEbookResult.new(result_html)
    end
  end

end

class KindleUnlimitedEbookResult

  def initialize(result_html)
    @result_html = result_html
  end

  def title
    if @result_html.css("h2.s-access-title").any?
      @result_html.css("h2.s-access-title").first.text
    else
      "Advertisement"
    end
  end

  def author_tag
    @result_html.css("span.a-size-small.a-color-secondary")
  end

  def author
    if author_tag.any?
      if author_tag[3].text.include? "and"
        author_tag[3].text + author_tag[4].text
      else
        author_tag[3].text
      end
    else
      "Amazon"
    end
  end

  def link
    # puts @result_html
    if @result_html.css("h2.s-access-title").any?
      @result_html.css("a.a-link-normal").first.attr('href')
    else
      "#"
    end
  end

end
