#encoding: UTF-8

require './spec/spec_helper'

describe DayOne::EntryImporter do
  let(:sample_entry){ DayOne::EntryImporter::from_file spec_data('sample.doentry') }
  
  describe "#initialize" do
    it "should accept a string or file" do
      ei = DayOne::EntryImporter.new('foo')
      expect(ei.data).to eq('foo')
      
      file_ei = DayOne::EntryImporter::from_file spec_data('foo.doentry')
      expect(file_ei.data).to eq('foo')
    end
  end

  describe "#processed_data" do
    let(:data){ DayOne::EntryImporter.from_file spec_data('entry_importer_parse_test.xml')  }

    it "should accept strings" do
      expect(data['String test']).to eq('Sample string')
    end

    it "should accept reals" do
      expect(data['Real test']).to eq(3.141)
    end

    it "should accept dates" do
      expect(data['Date test'].year).to eq(1997)
    end

    it "should accept booleans" do
      expect(data['Bool test']).to eq(true)
      expect(data['Bool test 2']).to eq(false)
    end

    it "should accept arrays" do
      arr = data['Array test']
      expect(arr).to be_a(Array)
      expect(arr.size).to eq(2)
      expect(arr[0]).to eq('A string')
      expect(arr[1]).to eq(1.234)
    end

    it "should accept dictionaries" do
      dict = data['Dict test']
      expect(dict).to be_a(Hash)
      expect(dict.keys.size).to eq(1)
      expect(dict['Sample dict key']).to eq(2.345)
    end
  end
  
  describe "#[]" do
    
    def wrap str
      <<-end
<plist>
  <dict>
    <key>element</key>
    <string>#{str}</string>
  </dict>
</plist>
      end
    end
    
    it "should accept ampersands" do
      importer = DayOne::EntryImporter.new(wrap('&amp;'))
      expect(importer['element']).to eq('&')
    end
    
    it "should accept UTF-8" do
      importer = DayOne::EntryImporter.new(wrap('æ'))
      expect(importer['element']).to eq('æ')
    end
    
    it "should accept UTF-8 from file" do
      importer = DayOne::EntryImporter.from_file spec_data('utf.doentry')
      expect(importer['Entry Text']).to eq('æ')
    end
  end
  
  describe "#to_entry" do
    it "should make a valid entry" do
      entry = sample_entry.to_entry
      expect(entry.entry_text).to eq('Hello, world!')
      expect(entry.starred).to eq(true)
      expect(entry.creation_date.year).to eq(1997)
      expect(entry.location.country).to eq('New Zealand')
      expect(entry).to be_saved      
    end
  end
end