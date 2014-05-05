require 'spec_helper'

describe('zabbix', :type => :class) do
  let(:node) { 'test.example.com' }

  describe 'when called with no parameters on redhat' do
    let(:facts) { { 
      :osfamily => 'Redhat', 
      :operatingsystemmajrelease => '5', 
      :architecture => 'i386' 
    } }
    it {
      should contain_package('zabbix-agent').with({
        'ensure' => 'present',
      })
    }
  end
end
