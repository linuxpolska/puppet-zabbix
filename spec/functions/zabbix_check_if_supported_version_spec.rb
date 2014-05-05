require 'spec_helper'

describe 'zabbix_check_if_supported_version' do
  it { should run.with_params().and_raise_error(ArgumentError) }
  it { should run.with_params('1').and_raise_error(ArgumentError) }
  it { should run.with_params(1, '2').and_raise_error(ArgumentError) }
  it { should run.with_params('1', '2').and_raise_error(ArgumentError) }
  it { should run.with_params('1', '2').and_raise_error(ArgumentError) }
  it { should run.with_params('1', ['2']).and_return(false) }
  it { should run.with_params('1.1', ['2', '1.2']).and_return(false) }
  it { should run.with_params('1.1.3', ['2', '1.2']).and_return(false) }
  it { should run.with_params('1.1.3', ['2', '1.2', '1.1']).and_return('1.1') }
  it { should run.with_params('1.2.3', ['2.0', '1.2', '1.1']).and_return('1.2') }
end
