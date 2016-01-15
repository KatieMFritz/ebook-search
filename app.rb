require 'sinatra'
require 'rest-client'
require 'nokogiri'

require_relative 'helpers/kindle_unlimited_ebook_searcher'
require_relative 'helpers/opac_ebook_searcher'

class EbookSearcher < Sinatra::Base
  get '/' do
    query = params[:query].to_s
    @kindle_unlimited_ebook_search = KindleUnlimitedEbookSearcher.new(query)
    @opac_ebook_search = OpacEbookSearcher.new(query)
    erb :results
  end

end
