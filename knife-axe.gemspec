Gem::Specification.new do |s|
	s.name = "knife-axe"
	s.version = "0.1.3"
	s.date = "2015-02-02"
	s.summary = ""
	s.description = ""
	s.authors = ["Marcin Cabaj", "Sam Clements"]
	s.email = ["marcin.cabaj@datasift.com", "sam.clements@datasift.com"]
	s.homepage = "https://github.com/faja/knife-axe"
	s.license = ""
	s.files = Dir.glob("lib/**/*") + %w(README.md)
	s.add_dependency "diffy", "~> 3.0.1"
end
