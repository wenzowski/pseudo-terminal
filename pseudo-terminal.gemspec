$:.unshift File.expand_path("../lib", __FILE__)
require "pseudo-terminal/version"

Gem::Specification.new do |gem|
  gem.name    = "pseudo-terminal"
  gem.version = PseudoTerminal::VERSION

  gem.author      = "Alexander Wenzowski"
  gem.email       = "alexander@wenzowski.com"
  gem.homepage    = "http://github.com/wenzowski/pseudo-terminal"
  gem.summary     = "Pseudo terminal built on PTY."
  gem.description = "Pseudo terminal library to ease interaction with PTY."
  gem.executables = "pseudo-terminal"

  gem.files = %x{ git ls-files }.split("\n").select { |d| d =~ %r{^(README|bin/|data/|ext/|lib/|spec/|test/)} }
end
