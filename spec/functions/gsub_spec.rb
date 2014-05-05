require 'spec_helper'

describe 'gsub' do
  it { should run.with_params().and_raise_error(ArgumentError) }
  it { should run.with_params('1').and_raise_error(ArgumentError) }
  it { should run.with_params('1', '2').and_raise_error(ArgumentError) }
  it { should run.with_params('1', '2', '3').and_return('1') }
  it { should run.with_params('.', '.', '\.').and_return('\.') }
  it { should run.with_params('..', '.', '\.').and_return('\.\.') }
  it { should run.with_params('test.', '.', '\.').and_return('test\.') }
  it { should run.with_params(1, '2', '3').and_raise_error(ArgumentError) }
  it { should run.with_params('1', 2, '3').and_raise_error(ArgumentError) }
  it { should run.with_params('1', '2', 3).and_raise_error(ArgumentError) }
end
