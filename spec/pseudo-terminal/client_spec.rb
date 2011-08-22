require "spec_helper"
require "pseudo-terminal"

describe PseudoTerminal do
  it 'should be instantiated without failures' do
    lambda { t = PseudoTerminal.new; t.kill! }.should_not raise_error
    lambda { t = PseudoTerminal.new({}); t.kill! }.should_not raise_error
    lambda { t = PseudoTerminal.new(1); t.kill! }.should raise_error
    lambda { t = PseudoTerminal.new(''); t.kill! }.should raise_error
    lambda { t = PseudoTerminal.new([]); t.kill! }.should raise_error
  end

  context 'terminal' do
    t = PseudoTerminal.new
    it 'is running' do
      t.is_running?.should be_true
    end
    it 'is killed' do
      t.kill!
      t.is_running?.should be_false
    end
  end

  context 'when spawned terminal' do
    before :each do
      @t = PseudoTerminal.new timeout: 0.1
    end

    after :each do
      @t.kill!
    end

    it 'has not been written to' do
      @t.read.should be_empty
    end

    it 'has a command written to it' do
      (@t << 'pwd').first.should == Dir.pwd
    end

    it 'has a command written to it while a block is passed to it' do
      @t.put('pwd') {|line| line.should == Dir.pwd}
    end
  end
end
