# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = "splunktronic"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Lincoln Ritter"]
  s.email       = ["lincoln@animoto.com"]
  s.homepage    = ""
  s.summary     = %q{Bridge Splunk and Leftronic}
  s.description = %q{Use the splunk API as a data source for Leftronic widgets}

  s.rubyforge_project = "splunktronic"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency( 'splunking' )
  s.add_dependency( 'leftronic')
  s.add_dependency( 'json')
end