# A search of the database.
# Create this object with Search.new. Give it some parameters to search for, then
# use Search#[] to access results.
class DayOne::Search
  # Initialize the search. Takes a block, which allows
  # access to an array of +SearchEngine+ subclasses.
  def initialize(&blck)
    instance_eval(&blck) if block_given?
  end

  # Fetch the results by searching.
  # @return [Array] all entries matching your results
  def results
    unless @results
      # Fetch files + data
      @results = DayOne.entries.each_with_object({}) { |file, hash| hash[file] = File.read(file, external_encoding: 'UTF-8') }

      search_engines = active_search_engines
      @results = @results.select { |_k, v| search_engines.all? { |se| se.matches?(v) } }
      @results = @results.map { |file, data| DayOne::EntryImporter.new(data, file).to_entry }
    end
    @results
  end

  # Fetches a particular result
  # @param index [Integer] the index of the result to fetch
  # @return [DayOne::Entry] the entry
  def [](index)
    results[index]
  end

  # entry_text search engine
  def entry_text
    @entry_text ||= DayOne::EntryTextSearch.new
  end

  # starred search engine
  def starred
    @starred ||= DayOne::StarredSearch.new
  end

  # Tags search engine
  def tag
    @tag ||= DayOne::TagSearch.new
  end

  # Creation date search engine
  def creation_date
    @creation_date ||= DayOne::CreationDateSearch.new
  end

  # Returns an array of search engines which are defined and will actually do
  # filtering.
  def active_search_engines
    [@entry_text, @starred, @tag, @creation_date].compact
  end
end
