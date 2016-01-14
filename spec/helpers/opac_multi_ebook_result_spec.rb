require_relative '../../helpers/opac_ebook_searcher'

# to run this, bundle exec rspec

describe OpacMultiEbookResult do

###################################################################################

  context 'when passed a query of "octavia butler" (one page of results)' do

    before(:each) do
      search = OpacEbookSearcher.new("octavia butler")
      # record and save the API request as a cassette instead of getting it each time
      VCR.use_cassette "opac_ebook_search/#{search.query}" do
        search.page
      end
      @result = OpacMultiEbookResult.new(search.results_html.first)
    end

    describe '#title' do
      it 'returns a string' do
        expect( @result.title ).to be_a(String)
      end
    end

    describe '#author' do
      it 'returns a string' do
        expect( @result.author ).to be_a(String)
      end
    end

    describe '#link' do
      it 'returns a link starting with "http://ebooks.mcls.org/ContentDetails or http://mcl.lib.overdrive.com"' do
        expect( @result.link ).to match(/http\:\/\/(ebooks\.mcls\.org|mlc\.lib\.overdrive\.com)\/ContentDetails.*/)
      end
    end

  end #end context - one page of results

  ####################################################################################

    context 'when passed a query of "agile" (many pages of results)' do

      before(:each) do
        search = OpacEbookSearcher.new("agile")
        # record and save the API request as a cassette instead of getting it each time
        VCR.use_cassette "opac_ebook_search/#{search.query}" do
          search.page
        end
        @result = OpacMultiEbookResult.new(search.results_html.first)
      end

      describe '#title' do
        it 'returns a string' do
          expect( @result.title ).to be_a(String)
        end
      end

      describe '#author' do
        it 'returns a string' do
          expect( @result.author ).to be_a(String)
        end
      end

      describe '#link' do
        it 'returns a link starting with "http://ebooks.mcls.org/ContentDetails or http://mcl.lib.overdrive.com"' do
          expect( @result.link ).to match(/http\:\/\/(ebooks\.mcls\.org|mlc\.lib\.overdrive\.com)\/ContentDetails.*/)
        end
      end

    end #end context - many pages of results

end
