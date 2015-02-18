require 'rails_helper'

describe DeepStruct do
  let(:nested_hash) { {a:{b:{c:'d'}}} }
  subject{ DeepStruct.new(nested_hash) }
  
  it 'provides chainable (dot)method access' do
    expect(subject.a.b.c).to eq('d')
  end
  
  it 'still dumps the original hash w/ #to_h' do
    expect(subject.to_h).to eq(nested_hash)
  end
  
  it 'returns nil if method not defined' do
    expect(subject.foo).to be_nil
  end
end