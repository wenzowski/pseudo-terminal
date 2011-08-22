require "spec_helper"
require "pseudo-terminal"

describe PseudoTerminal do
  context 'when terminal spawned' do
    t = PseudoTerminal.new

    it 'is running' do
      t.is_running?.should be_true
    end

    it 'has not been written to' do
      t.read.should be_empty
    end

    pending 'run pwd without block' do
      (t << 'pwd').first.should == Dir.pwd
    end

    it 'is killed' do
      t.kill!
      t.is_running?.should be_false
    end
  end
end
