require 'sinatra'
require 'rest-client'
require 'nokogiri'

class MyWebApp < Sinatra::Base
  get '/' do
    erb :search
  end
  get '/results' do
    keyword = params[:keyword]
    @opac_records = opac("#{keyword}")
    @ku_records = [] #ku("#{keyword}")
    erb :results
  end

  helpers do
    def opac(keyword)
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

    def ku(keyword)
      keyword = keyword.split(/\s+/).join('+')
      @ku_url = "http://www.amazon.com/s/?url=node%3D9069934011&field-keywords=#{keyword}"
      page = RestClient.get(@ku_url)
      html = Nokogiri::HTML(page)
      @ku_count = html.css("h2#s-result-count").text[/(\d+.*results)/, 1]
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
