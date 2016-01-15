require File.join( File.dirname(__FILE__), 'app' )

require 'sass/plugin/rack'
use Sass::Plugin::Rack

run EbookSearcher
