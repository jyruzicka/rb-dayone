require './spec/spec_helper'

describe DayOne::Entry do
  before :all do
    setup_working
  end
  
  after :all do
    clean_working
  end

  describe "#image=" do
    it "should correctly record a path to the assigned image" do
      e = DayOne::Entry.new
      e.image = spec_data('/sample_image.jpg')
      expect(e.image).to eq(spec_data('/sample_image.jpg'))
    end

    it "should error if linked to a non-jpg image (for now)" do
      e = DayOne::Entry.new
      expect{ e.image = spec_data('/sample_image.png') }.to raise_error(RuntimeError)
    end

    it "should error if the linked image does not exist" do
      e = DayOne::Entry.new
      expect{ e.image = 'nonexistant.jpg' }.to raise_error(RuntimeError)
    end

    it "should relocate the image when the entry is created" do
      e = DayOne::Entry.new
      e.image = spec_data('/sample_image.jpg')
      e.create!
      expect(File).to exist(spec_data("working/photos/#{e.uuid}.jpg"))
    end
  end
  
end