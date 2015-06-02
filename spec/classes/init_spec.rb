require 'spec_helper'
describe 'uge' do

  context 'with defaults for all parameters' do
    it { should contain_class('uge') }
  end
end
