require 'spec_helper'
describe 'rsync' do

  context 'with defaults for all parameters' do
    it { should contain_class('rsync') }
  end
end
