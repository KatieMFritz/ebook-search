require_relative '../../helpers/opac_ebook_searcher'

# to run this, bundle exec rspec

describe OpacEbookSearcher do

  context 'when passed a query of "csaiafudsafaskm" (no results)' do

    before(:each) do
      @search = OpacEbookSearcher.new("csaiafudsafaskm")
      # record and save the API request as a cassette instead of getting it each time
      VCR.use_cassette "opac_ebook_search/#{@search.query}" do
        @search.page
      end
    end

    describe '#sanitized_query' do
      it 'returns "csaiafudsafaskm"' do
        expect( @search.sanitized_query ).to eq("csaiafudsafaskm")
      end
    end

    describe '#search_url' do
      it 'returns "http://opac.cadl.org/search/X?SEARCH=csaiafudsafaskm&m=t&searchscope=15&a=&l=&Da=&Db=&p=&SORT=D"' do
        expect( @search.search_url ).to eq("http://opac.cadl.org/search/X?SEARCH=csaiafudsafaskm&m=t&searchscope=15&a=&l=&Da=&Db=&p=&SORT=D")
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
        expect( @search.total_results_count ).to eq("No results")
      end
    end

  end #end context - no results

##############################################################################

  context 'when passed a query of "katie friedman texting" (single result)' do

    before(:each) do
      @search = OpacEbookSearcher.new("katie friedman texting")
      # record and save the API request as a cassette instead of getting it each time
      VCR.use_cassette "opac_ebook_search/#{@search.query}" do
        @search.page
      end
    end

    describe '#sanitized_query' do
      it 'returns "katie+friedman+texting"' do
        expect( @search.sanitized_query ).to eq("katie+friedman+texting")
      end
    end

    describe '#search_url' do
      it 'returns "http://opac.cadl.org/search/X?SEARCH=katie+friedman+texting&m=t&searchscope=15&a=&l=&Da=&Db=&p=&SORT=D"' do
        expect( @search.search_url ).to eq("http://opac.cadl.org/search/X?SEARCH=katie+friedman+texting&m=t&searchscope=15&a=&l=&Da=&Db=&p=&SORT=D")
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

    describe '#single_result' do

      it 'returns an array' do
        expect( @search.single_result ).to be_an(Array)
      end

      describe 'each item' do
        it 'is a OpacSingleEbookResult' do
          @search.single_result.each do |single_result|
            expect( single_result ).to be_a(OpacSingleEbookResult)
          end
        end
      end
    end

  end #end context - single result

###############################################################################

  context 'when passed a query of "octavia butler" (one page of results)' do

    before(:each) do
      @search = OpacEbookSearcher.new("octavia butler")
      # record and save the API request as a cassette instead of getting it each time
      VCR.use_cassette "opac_ebook_search/#{@search.query}" do
        @search.page
      end
    end

    describe '#sanitized_query' do
      it 'returns "octavia+butler"' do
        expect( @search.sanitized_query ).to eq("octavia+butler")
      end
    end

    describe '#search_url' do
      it 'returns "http://opac.cadl.org/search/X?SEARCH=octavia+butler&m=t&searchscope=15&a=&l=&Da=&Db=&p=&SORT=D"' do
        expect( @search.search_url ).to eq("http://opac.cadl.org/search/X?SEARCH=octavia+butler&m=t&searchscope=15&a=&l=&Da=&Db=&p=&SORT=D")
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
        it 'is a OpacMultiEbookResult' do
          @search.results.each do |result|
            expect( result ).to be_a(OpacMultiEbookResult)
          end
        end
      end
    end

  end #end context - one page of results

  ###############################################################################

    context 'when passed a query of "magic tree house" (many pages of results)' do

      before(:each) do
        @search = OpacEbookSearcher.new("magic tree house")
        # record and save the API request as a cassette instead of getting it each time
        VCR.use_cassette "opac_ebook_search/#{@search.query}" do
          @search.page
        end
      end

      describe '#sanitized_query' do
        it 'returns "magic+tree+house"' do
          expect( @search.sanitized_query ).to eq("magic+tree+house")
        end
      end

      describe '#search_url' do
        it 'returns "http://opac.cadl.org/search/X?SEARCH=magic+tree+house&m=t&searchscope=15&a=&l=&Da=&Db=&p=&SORT=D"' do
          expect( @search.search_url ).to eq("http://opac.cadl.org/search/X?SEARCH=magic+tree+house&m=t&searchscope=15&a=&l=&Da=&Db=&p=&SORT=D")
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
          it 'is a OpacMultiEbookResult' do
            @search.results.each do |result|
              expect( result ).to be_a(OpacMultiEbookResult)
            end
          end
        end
      end

    end #end context - many pages of results

end
