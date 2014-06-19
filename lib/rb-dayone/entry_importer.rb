# Imports DayOne entries from XML files or plain text
class DayOne::EntryImporter
  
  # Raw data as provided in initialize
  attr_accessor :data
  
  # File (if supplied)
  attr_accessor :file
  
  # Create a new entry based on a string. To import from a file,
  # use EntryImporter.from_file.
  # @param data [String] The raw data for the importer to process
  # @param file [String] The file this data came from. Defaults to +nil+.
  def initialize data, file=nil
    @data = data
    @file = file
  end
  
  # Create a new entry from a file
  # @param file [String] The file to import
  def self.from_file file
    new(File.read(file), file)
  end
  
  # Access entry data by key
  # @param key [String, Symbol] The key to retrieve 
  # @return the value stored in the file, or nil
  def [] key
    processed_data[key]
  end
  
  # Generate and return the data contained within the doentry file, as a hash
  # @return [Hash] the processed data
  def processed_data
    @processed_data ||= process_dict(Nokogiri::XML(data).xpath('//plist/dict').first)
  end
  
  # Generate an entry from this importer
  # @return a DayOne::Entry based on this importer
  def to_entry
    DayOne::Entry.new(
      self['Entry Text'],
      starred: self['Starred'],
      creation_date: self['Creation Date'],
      saved: true,
      tags: self['Tags']||[],
      location: self['Location']||{},
      uuid: self["UUID"]
    )
  end

  private

  # TODO Import images

  # Process an XML tag. Returns a the value of the tag as a ruby value.
  # @param element [Nokogiri::XML::Element] The element to process
  # @return The values contained within the element
  def process_value element
    case element.name
    when 'date'
      Time.parse(element.content)
    when 'string'
      element.content
    when 'real'
      element.content.to_f
    when 'true'
      true
    when 'false'
      false
    when 'array'
      element.xpath('*').map{ |e| process_value(e) }
    when 'dict'
      process_dict(element)
    end
  end

  # Process an XML dict element. Returns a hash of values
  # @param dict [Nokogiri::XML::Element] The dictionary element to process
  # @return [Hash] The values contained within the element
  def process_dict dict
    processed_data = {}
    key = nil

    dict.xpath('*').each do |elem|
      if elem.name == 'key'
        key = elem.content
      else
        processed_data[key] = process_value(elem)
      end
    end
    processed_data
  end
end