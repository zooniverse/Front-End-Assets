Gem::Specification.new do |s|
  s.name = 'zoo'
  s.summary = 'Zooniverse project initializer'
  s.description = 'Initialize new projects for the Zooniverse'
  s.version = '0.0.7'
  s.author = 'Brian Carstensen'
  s.email = 'brian@zooniverse.org'
  s.homepage = 'http://www.zooniverse.org/'

  s.bindir = 'bin'
  s.executables = ['zoo']
  s.files = Dir.glob '{bin,lib,templates}/**/*', File::FNM_DOTMATCH

  s.add_dependency 'thor'
  s.add_dependency 'colored'
  s.add_dependency 'grabass'
  s.add_dependency 'bourbon'
  s.add_dependency 'foreman', '0.47'
  s.add_dependency 'coffee-script'
  s.add_dependency 'sass'
end
