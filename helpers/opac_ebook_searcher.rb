class OpacEbookSearcher

  attr_reader :query

  def initialize query
    @query = query
  end

  # replace spaces in query for proper URL syntax
  def sanitized_query
    @query.split(/\s+/).join('+')
  end

  def search_url
    "http://opac.cadl.org/search/X?SEARCH=#{sanitized_query}&m=t&searchscope=15&a=&l=&Da=&Db=&p=&SORT=D"
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
    if html.css("div.briefcitDetails").any?
      html.css("td.browseHeaderData").first.text[/(\d+.*)\)/, 1] + " results"
    elsif html.css("div.bibDisplayContentMain").any?
      "1 result"
    else
      "No results"
    end
  end

  def one_result_html
    html.css("div.bibDisplayContentMain")
  end

  def single_result
    one_result_html.map do |single_result_html|
      OpacSingleEbookResult.new(single_result_html)
    end
  end

  def results_html
    html.css("div.briefcitDetails")
  end

  def results
    results_html.map do |result_html|
      OpacMultiEbookResult.new(result_html)
    end
  end

end

class OpacSingleEbookResult

  def initialize(single_result_html)
    @single_result_html = single_result_html
  end

  def title
    @single_result_html.css("td.bibInfoData").first.text.gsub("\n", "")
  end

  def author
    @single_result_html.css("td.bibInfoData a").first.text
  end

  def link
    @single_result_html.css("table.bibLinks a").first.attr('href')
  end

end

class OpacMultiEbookResult

  def initialize(result_html)
    @result_html = result_html
  end

  def title
    @result_html.css("h2.briefcitTitle a").first.text
  end

  def author
    @result_html.css(".briefcitAuthor").first.text.gsub(/\.|\(|\)|(,  )?author|\,\s\d{4}|-|\d{4}/, "")
  end

  def link
    @result_html.css(".briefcitActions a").first.attr('href')
  end

end
