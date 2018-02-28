require './spec/spec_helper'

describe DayOne::Location do
  describe '#initialize' do
    it 'should set via symbol' do
      l = DayOne::Location.new(administrative_area: 'foo')
      expect(l.administrative_area).to eq('foo')
    end

    it 'should set via string' do
      l = DayOne::Location.new('Administrative Area' => 'foo')
      expect(l.administrative_area).to eq('foo')
    end
  end

  describe '#left_blank?' do
    it "should return true if all values are nil, '' or 0" do
      l = DayOne::Location.new
      expect(l).to be_left_blank
      l.country = ''
      l.latitude = 0.0
      l.longitude = 0
      expect(l).to be_left_blank
      l.place_name = '!'
      expect(l).to_not be_left_blank
    end
  end

  describe '#to_xml' do
    it 'should export correctly to xml' do
      b = double('Builder')
      expect(b).to receive(:key).exactly(7).times
      expect(b).to receive(:string).exactly(4).times
      expect(b).to receive(:real).exactly(2).times
      expect(b).to receive(:dict) { |&blck| blck.call }
      expect(DayOne::Location.new(country: 'New Zealand').to_xml(b)).to eq(true)
    end
  end
end
