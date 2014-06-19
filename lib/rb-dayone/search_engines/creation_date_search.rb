# Searches posts with a given creation date
class DayOne::CreationDateSearch < DayOne::SearchEngine

  # No-argument initializer, sets default ivars.
  def initialize
    @before = nil
    @after = nil
  end

  # Post must have occured before a given date
  def before date
    @before = date
  end

  # Post must have occured after a given date
  def after date
    @after = date
  end
  
  # Does this search widget match the date value of the given string?
  # @return [Boolean] Whether it matches or not
  def matches? string
    return true if !(@before || @after)

    t = Time.parse string[%r|<key>Creation Date</key>\s+<date>(.*?)</date>|,1]

    return (
      !(@before && t >= @before) &&  # NOT (@before defined and event occurs after @before)
      !(@after  && t <= @after)
    )
  end
end