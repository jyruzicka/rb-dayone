gem_title = 'rb-dayone'

def pkg
  p = Dir['pkg/*.gem'].sort[-1]
  if p.nil?
    warn "ERROR: Can't find pkg file."
  else
    p
  end
end

task :build do
  specfile = "#{gem_title}.gemspec"
  sh "gem build '#{specfile}'"

  gem_file = Dir["#{gem_title}-*.gem"]
  gem_file.each do |f|
    sh "mv '#{f}' pkg/#{f}"
  end
end

task install: [:build] do
  sh "gem install #{pkg}"
end

task push: [:build] do
  sh "gem push #{pkg}"
end

task :spec do
  sh 'rspec'
end

task default: :spec
