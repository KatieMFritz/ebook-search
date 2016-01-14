require_relative '../../helpers/opac_ebook_searcher'

# to run this, bundle exec rspec

describe OpacSingleEbookResult do

  context 'when passed a query of "katie friedman texting" (single result)' do

    before(:each) do
      search = OpacEbookSearcher.new("katie friedman texting")
      # record and save the API request as a cassette instead of getting it each time
      VCR.use_cassette "opac_ebook_search/#{search.query}" do
        search.page
      end
      @result = OpacSingleEbookResult.new(search.one_result_html.first)
    end

    describe '#title' do
      it 'returns "Katie Friedman gives up texting! (and lives to tell about it.) And Lives to Tell About It"' do
        expect( @result.title ).to eq("Katie Friedman gives up texting! (and lives to tell about it.) And Lives to Tell About It")
      end
    end

    describe '#author' do
      it 'returns "Greenwald, Tom."' do
        expect( @result.author ).to eq("Greenwald, Tom.")
      end
    end

    describe '#link' do
      it 'returns ""http://ebooks.mcls.org/ContentDetails.htm?ID=91D50454-9A37-4BA6-8752-01D8837971F0"' do
        expect( @result.link ).to eq("http://ebooks.mcls.org/ContentDetails.htm?ID=91D50454-9A37-4BA6-8752-01D8837971F0")
      end
    end

  end #end context - single result

end
