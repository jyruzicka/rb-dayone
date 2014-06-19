# The PListReader is a class that reads PLists.
# It is used to read the DayOne preferences PList.
class DayOne::PlistReader
  
  # The path of the PList to read.
  attr_accessor :path
  
  # Initialize the PList Reader, given a path
  # @param path [String] the path to the PList; defaults to the standard DayOne preference plist
  def initialize path=nil
    default_paths = [ # There have been two default paths over the versions...
      File.join(ENV['HOME'], 'Library/Group Containers/5U8NS4GX82.dayoneapp/Data/Preferences/dayone.plist'), # From 1.7 on
      File.join(ENV['HOME'], 'Library/Preferences/com.dayoneapp.dayone.plist') # Pre-1.7
    ]


    @path = if path
      path
    else
      first_valid_default_path = default_paths.find{ |p| File.exists?(p) }
      if first_valid_default_path.nil?
        raise RuntimeError, "Cannot locate DayOne preference file"
      else
        first_valid_default_path
      end
    end
  end
  
  # Retrieve the body of the plist as an array, parsed through JSON
  # @return [Hash] the body of the plist as a hash.
  def body
    @body ||= Nokogiri::XML `plutil -convert xml1 -o - '#{path}'`
  end

  # Retrieves an array of Nokogiri XML objects representing the
  # keys of the plist
  # @return [Array] the keys in the plist
  def keys
    body.xpath('//dict/key')
  end

  # Retrieves a specific key's value, or nil
  # @return the value of the key, or nil if it doesn't exist
  def key key_value
    key_element = keys.find{ |e| e.content == key_value }
    if key_element
      key_element.next_element.content
    else
      nil
    end
  end

  # Retrieve the DayOne journal location
  # @return [String] the path to the current DayOne journal location
  def journal_location
    key('JournalPackageURL') || # First, try the 1.7 location...
    key('NSNavLastRootDirectory') # Then try the pre-1.7 location
  end
  
  # This allows us to access the body's method as well as the reader's.
  def method_missing sym, *args
    if self.body.respond_to? sym
      self.body.send(sym, *args)
    else
      super sym, *args
    end
  end
end