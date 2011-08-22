require "rubygems"
require "bundler/setup"

require "simplecov"
SimpleCov.start do
  add_filter "/spec/"
end

require "rspec"
require "rr"

def prepare_command(klass)
  command = klass.new
  command.stub!(:app).and_return("myapp")
  command.stub!(:ask).and_return("")
  command.stub!(:display)
  command
end

def execute(command_line)
  extend RR::Adapters::RRMethods

  args = command_line.split(" ")
  command = args.shift

  PseudoTerminal::Command.load
  object, method = PseudoTerminal::Command.prepare_run(command, args)

  $command_output = ""

  def object.print(line=nil)
    $command_output << "#{line}"
  end

  def object.puts(line=nil)
    print("#{line}\n")
  end

  def object.error(line=nil)
    puts(line)
  end

  any_instance_of(PseudoTerminal::Command::Base) do |base|
    stub(base).extract_app.returns("myapp")
  end

  object.send(method)
end

def output
  $command_output.gsub(/\n$/, '')
end

def any_instance_of(klass, &block)
  extend RR::Adapters::RRMethods
  any_instance_of(klass, &block)
end

def run(command_line)
  cmd, *args = command_line.split(" ")
  capture_stdout { PseudoTerminal::Command.run(cmd, args) }
end

def capture_stdout(&block)
  original_stdout = $stdout
  $stdout = fake = StringIO.new
  begin
    yield
  ensure
    $stdout = original_stdout
  end
  fake.string
end

def fail_command(message)
  raise_error(PseudoTerminal::Command::CommandFailed, message)
end

def stub_core
  stubbed_core = nil
  any_instance_of(PseudoTerminal::Client) do |core|
    stubbed_core = stub(core)
  end
  stub(PseudoTerminal::Auth).user.returns("user")
  stub(PseudoTerminal::Auth).password.returns("pass")
  stub(PseudoTerminal::Client).auth.returns("apikey01")
  stubbed_core
end

def stub_rendezvous
  stubbed_rendezvous = nil
  any_instance_of(PseudoTerminal::Client::Rendezvous) do |rendezvous|
    stubbed_rendezvous = stub(rendezvous)
  end
  stubbed_rendezvous
end

module SandboxHelper
  def bash(cmd)
    `#{cmd}`
  end
end

module PseudoTerminal::Helpers
  def display(msg, newline=true)
  end
end

class String
  def undent
    indent = self.match(/^( *)/)[1].length
    self.split("\n").map { |l| l[indent..-1] }.join("\n")
  end
end

require "support/display_message_matcher"

RSpec.configure do |config|
  config.color_enabled = true
  config.include DisplayMessageMatcher
  config.after { RR.reset }
end

