source :rubygems

gemspec

group :development do
  gem "rake",  ">= 0.9.2"
  gem "rspec", ">= 2.6.0"
  gem "simplecov", "~> 0.4.2"
  gem "rr",    "~> 1.0.2"
  gem "fakefs"
  gem "parka", ">= 0.6.2"
end

group :development, :guard do
  gem 'guard-bundler',          '~> 0.1.3'
  gem 'guard-rspec',            '~> 0.4.2'
  if RUBY_PLATFORM.downcase.include?('darwin')
    gem 'rb-fsevent',           '~> 0.4.3'
    gem 'growl',                '~> 1.0.3'
  end
end