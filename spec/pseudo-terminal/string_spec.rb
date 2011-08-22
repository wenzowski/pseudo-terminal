require "spec_helper"
require "pseudo-terminal/string"

describe String do
  it 'string.prepend!' do
    s = 'def'
    s.prepend! 'abc'
    s.should == 'abcdef'
  end

  context 'does str end with' do
    it 'null' do
      'abc'.end_with_any?([]).should == false
      ''.end_with_any?(['abc']).should == false
    end
    it 'single-character' do
      'abc'.end_with_any?(['c']).should == true
      'abc'.end_with_any?(['b']).should == false
    end
    it 'multi-character string' do
      'abc'.end_with_any?(['bc']).should == true
      'abc'.end_with_any?(['ab']).should == false
    end
  end
  it 'strips ansi escape codes from string' do
    s = "\e[34mtesting\e[39;49m\e[0m/\r\n\e]7;file://Alexanders-MacBook-Pro.local/private/tmp/refinerycms\a\e]7;file://Alexanders-MacBook-Pro.local/private/tmp/refinerycms\a\e[0;31m4805\e[0m \xE2\x98\x85 \e[1;30m01:13\e[0m \xE2\x98\x85 \e[0;32muser\e[0m@\e[0;32mdomain.com\e[0m:\e[0;36m~/code/pseudo-terminal\e[0m (\e[1;33mmaster\e[0m) \r\r\n\xC2\xBB "
    s.strip_ansi_escape_sequences!
    s.should == "testing/\r\n4805 \xE2\x98\x85 01:13 \xE2\x98\x85 user@domain.com:~/code/pseudo-terminal (master) \r\r\n\xC2\xBB "
  end
end
