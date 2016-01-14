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
      OpacEbookResult.new(single_result_html)
    end
  end
  #
  # def multi_results_html
  #   if html.css("div.briefcitDetails").any?
  #     html.css("div.briefcitDetails")
  #   end
  # end
  #
  # def multi_results
  #   multi_results_html.map do |result_html|
  #     OpacEbookResult.new(result_html)
  #   end
  # end

end

class OpacEbookResult

  def initialize(single_result_html)
    @single_result_html = single_result_html
  end
#
#   def initialize(result_html)
#     @result_html = result_html
#   end
#
#   def title
#     if @result_html.css("h2.briefcitTitle a").any?
#       @result_html.css("h2.briefcitTitle a").first.text
#     elsif @single_result_html.css("td.bibInfoData").any?
#       @single_result_html.css("td.bibInfoData").first.text
#     end
#   end
#
#   def author
#     if @result_html.css(".briefcitAuthor").any?
#       @result_html.css("h2.briefcitTitle a").first.text.gsub("\n", "")
#     elsif @single_result_html.css("td.bibInfoData a").any?
#       @single_result_html.css("td.bibInfoData a").first.text
#     end
#   end
#
#   def link
#     if @result_html.css(".briefcitActions a").any?
#       @result_html.css(".briefcitActions a").first.attr('href')
#     elsif @single_result_html.css("table.bibLinks a").any?
#       @single_result_html.css("table.bibLinks a").first.attr('href')
#     end
  end
