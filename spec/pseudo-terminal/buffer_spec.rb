require "spec_helper"
require "pseudo-terminal/buffer"

describe PseudoTerminal::Buffer do
  it 'should be instantiated without arguments' do
    lambda { t = PseudoTerminal::Buffer.new(ready='> ') }.should_not raise_error
    lambda { t = PseudoTerminal::Buffer.new(ready='', mask=[]) }.should_not raise_error
    lambda { t = PseudoTerminal::Buffer.new }.should raise_error
  end

  context 'when string appended to buffer' do
    before :each do
      @ready='> '
      @b = PseudoTerminal::Buffer.new @ready
    end

    it 'is empty' do
      (@b << '').should be_kind_of(Array)
      (@b << '').should be_empty
    end

    it 'is ready' do
      (@b << @ready).should be_empty
    end

    it 'has masked lines' do
      @b.masks = ['error line 1', 'error line 2']
      masks_str = ''
      @b.masks.each {|mask| masks_str << "#{mask}\r\n"}
      (@b << masks_str).should == []
    end

    it 'contains newline (\r\n)' do
      (@b << "str\r\n").should == ['str']
    end

    it 'is truncated' do
      (@b << '1').should be_empty
      (@b << '2').should be_empty
      (@b << "3\r\n").should == ['123']
    end

    it 'lines are stored' do
      (@b << "a\r\nb\r\nc\r\n").should == ['a','b','c']
      (@b << "1\r\n2\r\n3\r\n").should == ['1','2','3']
      @b.lines.should == ['a','b','c','1','2','3']
      @b.raw.should == "a\r\nb\r\nc\r\n1\r\n2\r\n3\r\n"
    end
  end
end
