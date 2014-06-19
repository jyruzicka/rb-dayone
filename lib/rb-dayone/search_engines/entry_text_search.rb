# Searches the entry_text of a post
class DayOne::EntryTextSearch < DayOne::SearchEngine

  # No-argument initializer, sets default ivars.
  def initialize
    @include = []
    @exclude = []
  end

  # Posts must contain the following string in their entry text.
  def include string
    @include << string
  end

  # Posts cannot contain the following string in their entry text
  def exclude string
    @exclude << string
  end

  # Does this search widget match the entry text of the given string?
  # @return [Boolean] Whether it matches or not
  def matches? string
    entry_text = string[%r|<key>Entry Text</key>\s+<string>(.*?)</string>|m,1]

    # Edge case: no entry text
    return true if entry_text.nil? && @include.empty?

    return (entry_text &&
      @include.all?{ |s| entry_text.include?(s) } &&
      @exclude.all?{ |s| !entry_text.include?(s) }
    )
  end
end