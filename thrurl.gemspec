Gem::Specification.new do |s|
  s.name        = 'thrurl'
  s.version     = '0.0.3'
  s.licenses    = ['MIT']
  s.summary     = "Call Thrift services from the command line, as easily as a cURL"
  s.description = "Call Thrift services from the command line, as easily as a cURL"
  s.authors     = ["Herval Freire"]
  s.email       = 'hervalfreire@gmail.com'
  s.files       = Dir.glob("{bin,lib}/**/*") + %w(README.md)
  s.executables = ['thrurl']
  s.homepage    = 'https://github.com/herval/thrurl'
  s.require_paths = ["lib"]
  s.add_runtime_dependency "thrift"
end