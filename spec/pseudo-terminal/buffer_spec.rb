require "spec_helper"
require "pseudo-terminal/buffer"

describe PseudoTerminal::Buffer do
  context 'when string appended to buffer' do
    
    it 'is empty' do
      b = PseudoTerminal::Buffer.new
      (b << '').should == []
    end

    it 'contains newline (\r\n)' do
      b = PseudoTerminal::Buffer.new
      (b << "str\r\n").should == ['str']
    end

    it 'is truncated' do
      b = PseudoTerminal::Buffer.new
      (b << '1').should == []
      (b << '2').should == []
      (b << "3\r\n").should == ['123']
    end

    it 'lines are stored' do
      b = PseudoTerminal::Buffer.new
      (b << "a\r\nb\r\nc\r\n").should == ['a','b','c']
      (b << "1\r\n2\r\n3\r\n").should == ['1','2','3']
      b.lines.should == ['a','b','c','1','2','3']
      b.raw.should == "a\r\nb\r\nc\r\n1\r\n2\r\n3\r\n"
    end
  end
end
