require 'pty'
require 'pseudo-terminal/buffer'

module PseudoTerminal::Client
  attr_accessor :r, :w, :b, :timeout

  def initialize opt={}
    opt[:ready] ||= '> '
    opt[:sh] ||= "env PS1='#{opt[:ready]}' TERM=dumb sh -i"
    opt[:timeout] ||= 1
    @timeout = opt[:timeout]
    @r, @w, @pid = PTY.spawn opt[:sh]
    @b = PseudoTerminal::Buffer.new opt[:ready]
    read
    @b.mask << @b.lines.pop while @b.lines.empty? == false
  end

  def << command, &block
    @w.puts command
    read &block
  end

  def is_running?
    begin
      Process.getpgid @pid
      true
    rescue Errno::ESRCH
      false
    end
  end

  def kill!
    @r.close
    @w.close
    begin
      Process.wait @pid
    rescue PTY::ChildExited
    end
  end

  def read &block
    begin
      read_loop &block
    rescue IO::WaitReadable
      t = IO.select([@r], nil, nil, @timeout)
      retry unless t.nil?
      @b.lines
    rescue IOError
      nil
    end
  end

  private

  def read_loop &block
    begin
      if block_given?
        (@b << @r.read_nonblock(1024)).each {|line| yield(line)}
      else
        @b << @r.read_nonblock(1024)
      end
    end while true
  end
end
