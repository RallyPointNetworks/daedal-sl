require 'spec_helper'

describe DaedalSL do

  context 'class method #build' do
    it 'works' do
      data = {foo: :bar}
      result = DaedalSL.build(data) do
        query { match field: :foo, query: data[:foo] }
        filter { {hi: :bye} }
        paginate page: 3, per_page: 7
      end
      expect(result).to eq({query: {match: {foo: {query: :bar}}}, filter: {hi: :bye}, from: 14, size: 7})
    end
  end

end