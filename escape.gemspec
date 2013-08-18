require "./lib/escape"

Gem::Specification.new do |s|
  s.name              = "escape"
  s.version           = Escape::VERSION
  s.summary           = "escape library"
  s.description       = "escape library provides several HTML/URI/shell escaping functions."
  s.authors           = ["Tanaka Akira"]
  s.email             = ["akr@fsij.org"]
  s.homepage          = "http://github.com/akr/escape"

  s.files = Dir[
    "ChangeLog",
    "README",
    "lib/**/*.rb",
    "*.gemspec",
    "test/**/*.*"
  ]

end
