source 'https://rubygems.org'

gem 'sinatra', '~> 1.4.6'
gem 'nokogiri' #pull html from other sites
gem 'rest-client' #api stuff
gem 'sass'

group :development do
  gem 'restart' #don't have to rackup every single time
  gem 'wdm'#helps restart
end

group :test do
  gem 'rspec' #write awesome tests
  gem 'vcr' #record API responses and play them back so I don't get blacklisted
  gem 'webmock' #captures attempts to visit external (or internal) endpoints and returns something else instead
end
