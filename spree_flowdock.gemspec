# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_flowdock'
  s.version     = '0.0.1'
  s.summary     = 'Flowdock integration to Spree Commerce'
  s.description = 'This extensions adds Flowdock integration to Spree Commerce'
  s.required_ruby_version = '>= 1.9.3'

  s.author    = 'Christian'
  s.email     = 'christian@webionate.de'
  s.homepage  = 'http://www.webionate.de'

  #s.files       = `git ls-files`.split("\n")
  #s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 2.4.5'
  s.add_dependency 'spree_backend', '~> 2.4.5'
  s.add_dependency 'flowdock', '~> 0.5.0'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails', '~> 3.1'
  s.add_development_dependency 'capybara', '~> 2.4'
  s.add_development_dependency 'capybara-screenshot', '~> 1.0.4'
  s.add_development_dependency 'database_cleaner', '1.2.0'
  s.add_development_dependency 'capybara-webkit', '~> 1.3.0'
  s.add_development_dependency 'factory_girl', '~> 4.5'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sass-rails', '~> 4.0.2'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'poltergeist'
end
