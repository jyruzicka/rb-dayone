# Searches starred or unstarred posts
class DayOne::StarredSearch < DayOne::SearchEngine

  # No-argument initializer, sets default ivars.
  def initialize
    @is = nil
  end

  # Posts must be starred true or false.
  def is bool
    @is = bool
  end

  # Unset search criterion
  def unset
    @is = nil
  end

  # Does this search widget match the starred value of the given string?
  # @return [Boolean] Whether it matches or not
  def matches? string
    return true if @is.nil?

    starred_string = string[%r|<key>Starred</key>\s+<(.*)/>|m,1]

    return (starred_string &&
      (starred_string == "true") == @is
    )
  end
end