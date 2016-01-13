require_relative '../../helpers/kindle_unlimited_ebook_searcher'

# to run this, bundle install rspec

describe KindleUnlimitedEbookResult do

  context 'when passed a query of "afrofuturism womack" (single result)' do

    before(:each) do
      search = KindleUnlimitedEbookSearcher.new("afrofuturism womack")
      # record and save the API request as a cassette instead of getting it each time
      VCR.use_cassette "kindle_unlimited_ebook_search/#{search.query}" do
        search.page
      end
      @result = KindleUnlimitedEbookResult.new(search.results_html.first)
    end

    describe '#title' do
      it 'returns "Afrofuturism: The World of Black Sci-Fi and Fantasy Culture"' do
        expect( @result.title ).to eq("Afrofuturism: The World of Black Sci-Fi and Fantasy Culture")
      end
    end

    describe '#author' do
      it 'returns "Ytasha L. Womack"' do
        expect( @result.author ).to eq("Ytasha L. Womack")
      end
    end

    describe '#link' do
      it 'returns "http://www.amazon.com/Afrofuturism-World-Sci-Fi-Fantasy-Culture-ebook/dp/B00F21UDUY"' do
        expect( @result.link ).to eq("http://www.amazon.com/Afrofuturism-World-Sci-Fi-Fantasy-Culture-ebook/dp/B00F21UDUY")
      end
    end

  end #end context - single result

####################################################################################

  context 'when passed a query of "octavia butler" (one page of results)' do

    before(:each) do
      search = KindleUnlimitedEbookSearcher.new("octavia butler")
      # record and save the API request as a cassette instead of getting it each time
      VCR.use_cassette "kindle_unlimited_ebook_search/#{search.query}" do
        search.page
      end
      @result = KindleUnlimitedEbookResult.new(search.results_html.first)
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
      it 'returns a link starting with "http://www.amazon.com/"' do
        expect( @result.link ).to match(/http\:\/\/www\.amazon\.com\/.*/)
      end
    end

  end #end context - one page of results

  ####################################################################################

    context 'when passed a query of "charles dickens" (many pages of results)' do

      before(:each) do
        search = KindleUnlimitedEbookSearcher.new("charles dickens")
        # record and save the API request as a cassette instead of getting it each time
        VCR.use_cassette "kindle_unlimited_ebook_search/#{search.query}" do
          search.page
        end
        @result = KindleUnlimitedEbookResult.new(search.results_html.first)
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
        it 'returns a link starting with "http://www.amazon.com/"' do
          expect( @result.link ).to match(/http\:\/\/www\.amazon\.com\/.*/)
        end
      end

    end #end context - many pages of results

end
