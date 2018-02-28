require './spec/spec_helper'

describe DayOne::Search do
  describe '#results' do
    before :all do
      DayOne.journal_location = spec_data
    end

    it 'should find all posts when no search criteria are applied' do
      expect(subject.results.size).to eq(2)
    end

    it 'should find posts when searching by string' do
      search = DayOne::Search.new do
        entry_text.include 'foo'
      end
      expect(search.results.size).to eq(1)
      expect(search[0].entry_text).to eq('Yes, this is foo.')
    end

    it 'should perform logical AND when given >1 search include directive' do
      search = DayOne::Search.new do
        entry_text.include 'e'
        entry_text.include 'f'
      end

      expect(search.results.size).to eq(1)
      expect(search.results.first.entry_text).to eq('Yes, this is foo.')
    end

    it 'should include and exclude entry text as required' do
      search = DayOne::Search.new do
        entry_text.exclude 'foo'
      end

      expect(search.results.size).to eq(1)
      expect(search.results.first.entry_text).to eq('Hello bar.')
    end

    it 'should filter posts when searching by body and the string is elsewhere' do
      search = DayOne::Search.new { entry_text.include 'true' }
      expect(search.results.size).to eq(0)
    end

    it 'should find posts when searching by starred' do
      search = DayOne::Search.new { starred.is true }
      expect(search.results.size).to eq(1)
      expect(search[0].entry_text).to eq('Hello bar.')
    end

    it 'should find posts when searching by string and starred' do
      search = DayOne::Search.new do
        entry_text.include 'foo'
        starred.is true
      end
      expect(search.results).to be_empty
    end

    it 'should find posts when searching for tags' do
      search = DayOne::Search.new { tag.include 'tag' }
      expect(search.results.size).to eq(1)

      exc_search = DayOne::Search.new { tag.exclude 'tag' }
      expect(exc_search.results.size).to eq(1)
      expect(exc_search.results.first.entry_text).to eq('Hello bar.')

      no_search = DayOne::Search.new { tag.include 'does not exist' }
      expect(no_search.results).to be_empty
    end

    it 'should find posts after a given date' do
      time = Time.new(2012, 1, 1, 1, 1, 1)
      search = DayOne::Search.new { creation_date.after time }
      expect(search.results.size).to eq(1)
      expect(search.results.first.entry_text).to eq('Hello bar.')
    end

    it 'should find posts before a given date' do
      time = Time.new(2012, 1, 1, 1, 1, 1)
      search = DayOne::Search.new { creation_date.before time }
      expect(search.results.size).to eq(1)
      expect(search.results.first.entry_text).to eq('Yes, this is foo.')
    end

    it 'should find posts between given dates' do
      start_of_ten = Time.new(2010, 1, 1, 1, 1, 1)
      start_of_eleven = Time.new(2011, 1, 1, 1, 1, 1)
      start_of_twelve = Time.new(2012, 1, 1, 1, 1, 1)
      start_of_thirteen = Time.new(2013, 1, 1, 1, 1, 1)
      search1 = DayOne::Search.new do
        creation_date.before start_of_twelve
        creation_date.after start_of_eleven
      end
      search2 = DayOne::Search.new do
        creation_date.before start_of_eleven
        creation_date.after start_of_ten
      end

      expect(search1.results.size).to eq(1)
      expect(search1.results.first.entry_text).to eq('Yes, this is foo.')
      expect(search2.results).to be_empty
    end
  end
end
