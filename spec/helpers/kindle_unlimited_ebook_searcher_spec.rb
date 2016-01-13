require_relative '../../helpers/kindle_unlimited_ebook_searcher'

# to run this, bundle install rspec

describe KindleUnlimitedEbookSearcher do

  context 'when passed a query of "csaiafudsafaskm" (no results)' do

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

  end #end context - no results

###############################################################################

  context 'when passed a query of "afrofuturism womack" (single result)' do

    before(:each) do
      @search = KindleUnlimitedEbookSearcher.new("afrofuturism womack")
      # record and save the API request as a cassette instead of getting it each time
      VCR.use_cassette "kindle_unlimited_ebook_search/#{@search.query}" do
        @search.page
      end
    end

    describe '#sanitized_query' do
      it 'returns "afrofuturism+womack"' do
        expect( @search.sanitized_query ).to eq("afrofuturism+womack")
      end
    end

    describe '#search_url' do
      it 'returns "http://www.amazon.com/s/?url=node%3D9069934011&field-keywords=afrofuturism+womack"' do
        expect( @search.search_url ).to eq("http://www.amazon.com/s/?url=node%3D9069934011&field-keywords=afrofuturism+womack")
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

    describe '#total_results_count' do

      it 'returns the string with the results count' do
        expect( @search.total_results_count ).to be_a(String)
      end

      it 'returns "1 result"' do
        expect( @search.total_results_count ).to match("1 result")
      end

    end

    describe '#results' do

      it 'returns an array' do
        expect( @search.results ).to be_an(Array)
      end

      describe 'each item' do
        it 'is a KindleUnlimitedEbookResult' do
          @search.results.each do |result|
            expect( result ).to be_a(KindleUnlimitedEbookResult)
          end
        end
      end
    end

  end #end context - single result

###############################################################################

  context 'when passed a query of "octavia butler" (one page of results)' do

    before(:each) do
      @search = KindleUnlimitedEbookSearcher.new("octavia butler")
      # record and save the API request as a cassette instead of getting it each time
      VCR.use_cassette "kindle_unlimited_ebook_search/#{@search.query}" do
        @search.page
      end
    end

    describe '#sanitized_query' do
      it 'returns "octavia+butler"' do
        expect( @search.sanitized_query ).to eq("octavia+butler")
      end
    end

    describe '#search_url' do
      it 'returns "http://www.amazon.com/s/?url=node%3D9069934011&field-keywords=octavia+butler"' do
        expect( @search.search_url ).to eq("http://www.amazon.com/s/?url=node%3D9069934011&field-keywords=octavia+butler")
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

    describe '#total_results_count' do

      it 'returns the string with the results count' do
        expect( @search.total_results_count ).to be_a(String)
      end

      it 'ends with "results"' do
        expect( @search.total_results_count ).to match(/\d+.*results/)
      end

    end

    describe '#results' do

      it 'returns an array' do
        expect( @search.results ).to be_an(Array)
      end

      describe 'each item' do
        it 'is a KindleUnlimitedEbookResult' do
          @search.results.each do |result|
            expect( result ).to be_a(KindleUnlimitedEbookResult)
          end
        end
      end
    end

  end #end context - one page of results

  ###############################################################################

    context 'when passed a query of "charles dickens" (many pages of results)' do

      before(:each) do
        @search = KindleUnlimitedEbookSearcher.new("charles dickens")
        # record and save the API request as a cassette instead of getting it each time
        VCR.use_cassette "kindle_unlimited_ebook_search/#{@search.query}" do
          @search.page
        end
      end

      describe '#sanitized_query' do
        it 'returns "charles+dickens"' do
          expect( @search.sanitized_query ).to eq("charles+dickens")
        end
      end

      describe '#search_url' do
        it 'returns "http://www.amazon.com/s/?url=node%3D9069934011&field-keywords=charles+dickens"' do
          expect( @search.search_url ).to eq("http://www.amazon.com/s/?url=node%3D9069934011&field-keywords=charles+dickens")
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

      describe '#total_results_count' do

        it 'returns the string with the results count' do
          expect( @search.total_results_count ).to be_a(String)
        end

        it 'ends with "results"' do
          expect( @search.total_results_count ).to match(/\d+.*results/)
        end

      end

      describe '#results' do

        it 'returns an array' do
          expect( @search.results ).to be_an(Array)
        end

        describe 'each item' do
          it 'is a KindleUnlimitedEbookResult' do
            @search.results.each do |result|
              expect( result ).to be_a(KindleUnlimitedEbookResult)
            end
          end
        end
      end

    end #end context - many pages of results

end
