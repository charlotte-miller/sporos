require 'rails_helper'

describe DeepStruct do
  let(:nested_hash) { {a:{b:{c:'d'}}} }
  let(:hash_w_array) { {a:{b:[{c:'d'},{e:'f'}],m:['n','o', 'p'],x:['y',z:{zz:'zed zed'}]}} }
  subject{ DeepStruct.new(@hash_override || nested_hash) }
  
  it 'provides chainable (dot)method access' do
    expect(subject.a.b.c).to eq('d')
  end
  
  it 'still dumps the original hash w/ #to_h' do
    expect(subject.to_h).to eq(nested_hash)
  end
  
  it 'returns nil if method not defined' do
    expect(subject.foo).to be_nil
  end
  
  it 'handles nested arrays' do
    @hash_override = hash_w_array
    expect(subject.a.b).to be_a Array
    expect(subject.a.b.first).to be_a DeepStruct
    expect(subject.a.b.last).to be_a DeepStruct
  end
  
  it 'handles an array of strings' do
    @hash_override = hash_w_array
    subject.a.m.each do |val|
      expect(val).to be_a String
    end
  end
  
  it 'handles a mixed array of values and hashes' do
    @hash_override = hash_w_array
    expect(subject.a.x.first).to be_a String
    expect(subject.a.x.last).to be_a DeepStruct
    expect(subject.a.x.last.z.zz).to eql 'zed zed'
  end
  
  describe '.from_json(json_str)' do
    let(:from_json) {DeepStruct.from_json( MultiJson.dump( nested_hash) )}
    let(:from_json_w_array) {DeepStruct.from_json( MultiJson.dump( hash_w_array) )}
    subject {from_json}

    it 'creates a DeepStruct' do
      expect(subject).to be_a DeepStruct
    end

    it 'uses the json_str' do
      expect(from_json.to_h).to eq(nested_hash)
      expect(from_json_w_array.to_h).to eq(hash_w_array)
    end
  end
end