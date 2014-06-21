require 'spec_helper'

describe DaedalSL::NestedDisMaxQuery do

  subject do
    DaedalSL::NestedDisMaxQuery.new(:parent, path: :foo)
  end

  let(:query) do
    Daedal::Queries::MatchQuery.new(field: :foo, query: :bar)
  end

  context '#query' do
    before { subject.query { query } }
    it "adds the query given by executing the block to the bool query's query list" do
      expect(subject.base.query.queries.first).to eq query
    end
  end

end