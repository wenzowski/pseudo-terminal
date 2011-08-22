class String
  def prepend! s
    self.insert 0, s
  end

  def end_with_any? arr
    r = false
    arr.each {|str| r = true if self.end_with? str }
    r
  end

  def strip_ansi_escape_sequences!
    self.gsub!(/\e\]\d;(.*)\a/, '')
    self.gsub!(/\e\[[^m]*m/, '')
  end
end
