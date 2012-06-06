Gem::Specification.new do |s|
  s.name = 'Zoo'
  s.summary = 'Zooniverse project initializer'
  s.version = '0.0.1'

  s.bindir = 'bin'
  s.executables = ['zoo']
  s.files = Dir.glob '{bin,lib,templates}/**/*', File::FNM_DOTMATCH # TODO

  s.add_dependency 'thor'
  s.add_dependency 'colored'
  s.add_dependency 'grabass'
end
