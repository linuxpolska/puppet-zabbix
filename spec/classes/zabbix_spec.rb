require 'spec_helper'

describe('zabbix', :type => :class) do
  let(:node) { 'test.example.com' }

  describe 'when called with no parameters on redhat' do
    let(:facts) { { :osfamily => 'Redhat' } }
    it {
      should contain_package('zabbix').with({
        'ensure' => 'present',
      })
    }

    it {
      should contain_package('zabbix-agent').with({
        'ensure' => 'present',
      })
    }
  end
end
