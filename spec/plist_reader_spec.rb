require './spec/spec_helper'

describe DayOne::PlistReader do
  describe '#initialize' do
    it 'should default to the normal preference file' do
      expect(File).to exist(subject.path)
    end
  end

  describe '#body' do
    it 'should correctly parse binary plists' do
      reader = DayOne::PlistReader.new(File.join(File.dirname(__FILE__), 'data', 'sample.plist'))

      expect(reader.key('foo')).to eq('bar')
      expect(reader.key('bing')).to be_nil
    end
  end
end
