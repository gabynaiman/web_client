require 'spec_helper'

describe String do

  it 'Titleize single word' do
    'hello'.titleize.should eq 'Hello'
  end

  it 'Titleize phrase' do
    'hello world'.titleize.should eq 'Hello world'
  end

  it 'Titleize titleized word' do
    'Hello'.titleize.should eq 'Hello'
  end

end
