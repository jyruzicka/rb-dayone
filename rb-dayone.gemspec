Gem::Specification.new do |s|
  s.name = 'rb-dayone'
  s.version = File.read('version.txt')

  s.summary = 'Create DayOne journal entries in ruby.'
  s.description = 'Create or search DayOne.app journal entries simply and easily in ruby.'
  s.license = 'MIT'

  s.author = 'Jan-Yves Ruzicka'
  s.email = 'janyves.ruzicka@gmail.com'
  s.homepage = 'https://github.com/jyruzicka/rb-dayone'

  s.files = File.read('Manifest').split("\n").select { |l| !l.start_with?('#') && l != '' }
  s.require_paths << 'lib'
  s.extra_rdoc_files = ['README.md', 'LICENSE.md']

  s.executables << 'dayone'

  s.add_runtime_dependency 'builder', '~> 3.2'
  s.add_runtime_dependency 'commander', '~> 4.4'
  s.add_runtime_dependency 'libxml-ruby', '~> 3.1'
  s.add_runtime_dependency 'nokogiri', '~> 1.8'
end
