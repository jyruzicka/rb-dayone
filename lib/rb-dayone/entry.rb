# A text-only journal entry for DayOne.
class DayOne::Entry
  # A list of image extensions allowed for attached images
  ALLOWED_IMAGES = ['.jpg', '.jpeg'].freeze

  # The date of the journal entry
  attr_accessor :creation_date
  alias created_at creation_date
  alias created_at= creation_date=

  # The journal entry's body text
  attr_accessor :entry_text

  # Whether the entry has been starred
  attr_accessor :starred

  # Whether the entry has been saved to file at all.
  attr_accessor :saved

  # Path to the entry image
  attr_accessor :image

  # An entry's tags
  attr_accessor :tags

  # The location of the entry.
  attr_accessor :location

  # The UUID of the entry. Auto-generated if it doesn't already exist, this
  # shouldn't be manually set.
  attr_accessor :uuid

  # The PList doctype, used for XML export
  DOCTYPE = [:DOCTYPE, :plist, :PUBLIC, '-//Apple//DTD PLIST 1.0//EN', 'http://www.apple.com/DTDs/PropertyList-1.0.dtd'].freeze

  # Initialise a journal entry, ready for inclusion into your journal
  # @param entry_text [String] the body text of the journal entry
  # @param hsh [Hash] a hash of options - allowed keys include `:creation_date`, `:entry_text` and `:starred`, others are ignored
  # @return [DayOne::Entry] the journal entry
  def initialize(entry_text = '', hsh = {})
    # Some defaults
    @creation_date = Time.now
    @starred = false
    @entry_text = entry_text
    @saved = false
    @tags = []
    @location = DayOne::Location.new hsh.delete(:location)

    hsh.each do |k, v|
      setter = "#{k}="
      send(setter, v) if respond_to? setter
    end
  end

  # Generate (or retrieve, if previously generatred) a UUID
  # for this entry.
  # @return [String] the entry's UUID
  def uuid
    @uuid ||= `uuidgen`.delete('-').strip
  end

  # The file where this entry should/will be saved
  def file
    @file ||= File.join(DayOne.journal_location, 'entries', "#{uuid}.doentry")
  end

  # Add a tag to the entry
  # @param str [String] The string tag to add to the list.
  def tag(str)
    @tags << str.to_s
  end

  alias add_tag tag

  # Remove a tag from the entry
  def remove_tag(str)
    @tags.delete(str)
  end

  # Searches the entry text for tags (#foo) and adds them to the entry's tags.
  # Only recognises letters, numbers and underscores in tags.
  def add_tags_from_entry_text
    @entry_text.scan(/(?<=[ \t\n])#([a-zA-Z0-9_]+)/) { |m| tag m.shift }
  end

  alias auto_tag add_tags_from_entry_text

  # The same as calling Entry#saved. Tells you if this entry has been saved to
  # file yet.
  def saved?
    saved
  end

  # Convert an entry to XML.
  # @return [String] the entry as XML
  def to_xml
    builder = Builder::XmlMarkup.new(indent: 2)
    builder.instruct! # Basic xml tag
    builder.declare! *DOCTYPE # PList doctype
    builder.plist(version: 1.0) do
      builder.dict do
        builder.key 'Creation Date'
        builder.date creation_date.utc.iso8601

        builder.key 'Entry Text'
        builder.string entry_text

        unless tags.empty?
          builder.key 'Tags'
          builder.array do
            tags.each do |t|
              builder.string t
            end
          end
        end

        location.to_xml(builder) unless location.left_blank?

        builder.key 'Starred'
        if starred
          builder.true
        else
          builder.false
        end

        builder.key 'UUID'
        builder.string uuid
      end
    end
    builder.target!
  end

  # Create a .doentry file with this entry.
  # This uses the #to_xml method to generate the entry proper.
  # It will also relocate its attached image, if required.
  # @return [Boolean] true if the operation was successful.
  def create!
    xml = to_xml
    File.open(file, 'w') { |io| io << xml }
    if image
      new_image_path = File.join(DayOne.journal_location, 'photos', "#{uuid}.jpg")
      FileUtils.cp(image, new_image_path)
      @image = new_image_path
    end
    true
  end

  alias save! create!

  # Deletes the .doentry file of this entry. This will remove the entry from
  # your database, although you can reinstate it by calling +#save!+ on this
  # object.
  def delete!
    FileUtils.rm file
  end

  # Check to make sure that we output valid xml
  def xml_valid?
    doc = Nokogiri::XML(to_xml)
    doc.errors.empty?
  end

  # Assign an image to the entry
  # For now, this will only accept jpeg images (extension is 'jpg' or 'jpeg', case-insensitive)
  # Later, may support conversion via the appropriate library
  # @param image_path [String] the path to the image
  def image=(image_path)
    if !File.exist?(image_path)
      raise "Tried to link a journal entry to the image #{image_path}, but it doesn't exist."
    elsif image_path =~ /\.[^.]+$/ && ALLOWED_IMAGES.include?($&.downcase)
      @image = image_path
    else
      raise "Tried to link a journal entry to the image #{image_path}, but it's not a supported image format (#{ALLOWED_IMAGES.join(', ')})."
    end
  end
end
