require 'pseudo-terminal/string'

class PseudoTerminal::Buffer
  def initialize
    @lines = []
    @raw = ''
    @buff_a = []
    @segment = ''
  end

  def raw
    @raw
  end

  def lines
    @lines
  end

  def << str
    buffer = str.to_s
    @raw << buffer
    process_raw(buffer)
    # lines
  end

  private

  def process_raw buffer
    b = lines_from_raw(buffer)
    b.each {|l| @lines << l}
  end

  def lines_arr_from buffer
    buffer.lines.to_a.each {|l| begin l.chomp! end while l.end_with_any? "\r\n".chars }
  end

  def lines_from_raw buffer
    arr = lines_arr_from buffer
    arr = merge_line(arr) if !@segment.empty?
    @segment << arr.pop if truncated
    arr.each {|line| line.strip_ansi_escape_sequences!}
  end

  def new_line
    "\n"
  end

  def truncated
    !@raw.end_with?(new_line) && !@raw.empty?
  end

  def merge_line buff_a
    buff_a.first.prepend! @segment if buff_a.first
    @segment = ''
    buff_a
  end
end