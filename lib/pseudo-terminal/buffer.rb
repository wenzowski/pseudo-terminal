require 'pseudo-terminal/string'

class PseudoTerminal::Buffer
  attr_accessor :masks, :raw, :lines, :segment

  def initialize str_ready, masks=[]
    @raw = ''
    @segment = ''
    @lines = []
    @buff_a = []
    @masks = masks
    @ready = str_ready.to_s
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

  def lines_from buffer
    buffer.lines.to_a.each {|l| begin l.chomp! end while l.end_with_any? "\r\n".chars }
  end

  def lines_from_raw buffer
    lines = lines_from buffer
    lines = merge_line(lines) if !@segment.empty?
    @segment << lines.pop if truncated
    lines.each {|line| line.strip_ansi_escape_sequences!}
    lines.each_with_index {|line, key| lines.delete_at key if line.match /^#{@ready}/}
    @masks.each do |mask|
      lines.each_with_index {|line, key| lines.delete_at key if line.match /^#{mask}/}
    end
    lines
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