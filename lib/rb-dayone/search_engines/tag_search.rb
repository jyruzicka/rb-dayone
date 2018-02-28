# Searches the tags of a post
class DayOne::TagSearch < DayOne::SearchEngine
  # No-argument initializer, sets default ivars.
  def initialize
    @include = []
    @exclude = []
  end

  # Posts must have the following tag.
  def include(string)
    @include << to_tag(string)
  end

  # Posts cannot have the following tag.
  def exclude(string)
    @exclude << to_tag(string)
  end

  # Does this search widget match the tags of the given string?
  # @return [Boolean] Whether it matches or not
  def matches?(string)
    tag_string = string[%r{<key>Tags</key>\s+<array>(.*?)</array>}m, 1]

    # Edge case: no tags
    return true if @include.empty? && tag_string.nil?

    (tag_string &&
      @include.all? { |s| tag_string.include?(s) } &&
      @exclude.all? { |s| !tag_string.include?(s) }
    )
  end

  private

  def to_tag(s)
    "<string>#{s}</string>"
  end
end
