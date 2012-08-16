require './spec/spec_helper'

describe DayOne::EntryImporter do
  let(:sample_entry){ DayOne::EntryImporter::from_file spec_data('sample.doentry') }
  
  describe "#initialize" do
    it "should accept a string or file" do
      ei = DayOne::EntryImporter.new('foo')
      ei.data.should == 'foo'
      
      file_ei = DayOne::EntryImporter::from_file spec_data('foo.doentry')
      file_ei.data.should == 'foo'
    end
  end
  
  describe "#[]" do    
    it "should parse strings" do
      sample_entry['Entry Text'].should == 'Hello, world!'
    end
    
    it "should parse booleans" do
      sample_entry['Starred'].should == true
    end
    
    it "should parse dates" do
      sample_entry['Creation Date'].should == Time.new(1997, 8, 29, 2, 14, 0)
    end
  end
  
  describe "#to_entry" do
    it "should make a valid entry" do
      entry = sample_entry.to_entry
      entry.entry_text.should == 'Hello, world!'
      entry.starred.should be_true
      entry.creation_date.year.should == 1997
      entry.should be_saved      
    end
  end
end