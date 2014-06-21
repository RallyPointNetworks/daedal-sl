require 'spec_helper'

describe DaedalSL::DisMaxQuery do

  subject do
    DaedalSL::DisMaxQuery.new(:parent, {})
  end

  let(:query) do
    Daedal::Queries::MatchQuery.new(field: :foo, query: :bar)
  end

  context '#query' do
    before { subject.query { query } }
    it "adds the query given by executing the block to the bool query's query list" do
      expect(subject.base.queries.first).to eq query
    end
  end

end