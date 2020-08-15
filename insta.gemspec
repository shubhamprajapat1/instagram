require_relative 'lib/insta/version'

Gem::Specification.new do |s|
  s.name        = 'insta-api'
  s.version     = Insta::VERSION
  s.licenses    = ['MIT']
  s.summary     = "Instagram Basic API"
  s.description = "The Instagram Basic Display API allows users of your app to get basic profile information, photos, and videos in their Instagram accounts."
  s.authors     = ["Shubham Prajapat"]
  s.email       = 'spkumar7786@gmail.com'
  s.files       = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  s.homepage    = 'https://rubygems.org/gems/insta-api'
  s.metadata    = { "source_code_uri" => "https://github.com/shubhamprajapat1/instagram" }
end