require_relative '../../helpers/kindle_unlimited_ebook_searcher'

# to run this, bundle install rspec

describe KindleUnlimitedEbookSearcher do

  context 'when passed a query of "csaiafudsafaskm"' do

    before(:each) do
      @search = KindleUnlimitedEbookSearcher.new("csaiafudsafaskm")
      # record and save the API request as a cassette instead of getting it each time
      VCR.use_cassette "kindle_unlimited_ebook_search/#{@search.query}" do
        @search.page
      end
    end

    describe '#sanitized_query' do
      it 'returns "csaiafudsafaskm"' do
        expect( @search.sanitized_query ).to eq("csaiafudsafaskm")
      end
    end

    describe '#search_url' do
      it 'returns "http://www.amazon.com/s/?url=node%3D9069934011&field-keywords=csaiafudsafaskm"' do
        expect( @search.search_url ).to eq("http://www.amazon.com/s/?url=node%3D9069934011&field-keywords=csaiafudsafaskm")
      end
    end

    describe '#page' do
      it 'returns the page contents from the search_url' do
        expect( @search.page ).to be_a(String)
      end
    end

    describe '#html' do
      it 'returns parse-able HTML' do
        expect( @search.html ).to be_a(Nokogiri::HTML::Document)
      end
    end

    #later i want to add an error message here
    describe '#total_results_count' do
      it 'is nil' do
        expect( @search.total_results_count ).to be_nil
      end
    end

    describe '#results' do
      it 'returns an empty array' do
        expect( @search.results ).to eq([])
      end
    end

  end


end
