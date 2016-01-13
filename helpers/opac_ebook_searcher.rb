module OpacEbookSearcher

  def opac_search(keyword)
    keyword = keyword.split(/\s+/).join('+')
    @opac_url = "http://opac.cadl.org/search/X?SEARCH=#{keyword}&m=t&searchscope=15&a=&l=&Da=&Db=&p=&SORT=D"
    page = RestClient.get(@opac_url)
    html = Nokogiri::HTML(page)
    if html.css("div.briefcitDetails").any?
      @opac_count = html.css("td.browseHeaderData").first.text[/(\d+.*)\)/, 1]
      html.css("div.briefcitDetails").map do |book|
        title = book.css("h2.briefcitTitle a").first
        author = book.css(".briefcitAuthor").first
        link = book.css(".briefcitActions a").first
        {
          title: title.text,
          author: author.text.gsub("\n", ""),
          link: link.attr('href')
        }
      end
    elsif html.css("div.bibDisplayContentMain").any?
      @opac_count = "One"
      html.css("div.bibDisplayContentMain").map do |book|
        title = book.css("td.bibInfoData").first
        author = book.css("td.bibInfoData a").first
        link = book.css("table.bibLinks a").first
        {
          title: title.text,
          author: author.text.gsub("\n", ""),
          link: link.attr('href')
        }
      end
    else
      @opac_count = "No"
    end
  end

end
