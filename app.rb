require 'sinatra'
require 'rest-client'
require 'nokogiri'

class MyWebApp < Sinatra::Base
  get '/' do
    @opac_records = opac("octavia butler")
    @ku_records = ku("octavia butler")
    erb :results
  end

  helpers do
    def opac(keyword)
      keyword = keyword.split(/\s+/).join('+')
      page = RestClient.get("http://opac.cadl.org/search/X?SEARCH=#{keyword}&m=t&searchscope=15&a=&l=&Da=&Db=&p=&SORT=D")
      html = Nokogiri::HTML(page)
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
    end

    def ku(keyword)
      keyword = keyword.split(/\s+/).join('+')
      url = "http://www.amazon.com/s/?url=node%3D9069934011&field-keywords=#{keyword}"
      page = RestClient.get(url)
      html = Nokogiri::HTML(page)
      count = html.css("h2#s-result-count").text
      html.css("li.s-result-item").map do |book|
        title = book.css("h2.s-access-title").first
        author = book.css("span.a-size-small.a-color-secondary")[3]
        link = book.css("a.a-link-normal").first
        {
          title: title.text,
          author: author.text,
          link: link.attr('href')
        }
      end
    end

  end

end
