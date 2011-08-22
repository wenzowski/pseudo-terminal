module PseudoTerminal::Client
  attr_accessor :r, :w

  def initialize(opt = { sh: 'env PS1=">" TERM=dumb sh -i', timeout: 1})
    @r, @w, @pid = PTY.spawn opt[:sh]
  end

  def close
    @r.close
    @w.close
    begin
      Process.wait @pid
    rescue PTY::ChildExited
    end
  end
end