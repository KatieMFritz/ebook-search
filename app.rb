require 'sinatra'
require 'rest-client'
require 'nokogiri'

class MyWebApp < Sinatra::Base
  get '/' do
    @opac_records = opac("victor hugo")
    erb :form
  end

  helpers do
    def opac(keyword)
      keyword = keyword.split(/\s+/).join('+')
      page = RestClient.get("http://opac.cadl.org/search/X?SEARCH=#{keyword}&m=t&searchscope=15&a=&l=&Da=&Db=&p=&SORT=D")
      html = Nokogiri::HTML(page)
      html.css("div.briefcitDetails").map do |book|
        title = book.css("h2.briefcitTitle a").first
        author = book.css(".briefcitAuthor").first
        {
          title: title.text,
          author: author.text.gsub("\n", ""),
          link: title.attr('href')
        }
      end

    end

  end

end
