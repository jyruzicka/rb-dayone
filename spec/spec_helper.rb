require './lib/rb-dayone'

def spec_data(*path)
  File.join(File.dirname(__FILE__), 'data', *path)
end

def setup_working
  FileUtils.mkdir_p spec_data('working/entries')
  FileUtils.mkdir_p spec_data('working/photos')
  DayOne.journal_location = spec_data('working')
end

def clean_working
  FileUtils.rm_rf spec_data('working')
end
