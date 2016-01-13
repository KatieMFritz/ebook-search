require_relative '../app'

EbookSearcher.environment = :test
Bundler.require :default, EbookSearcher.environment

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/cassettes'
  config.hook_into :webmock  
end
