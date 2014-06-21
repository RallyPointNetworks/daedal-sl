require 'spec_helper'

describe DaedalSL::NestedBoolQuery do

  subject do
    DaedalSL::NestedBoolQuery.new(:parent, path: :foo)
  end

  let(:query) do
    Daedal::Queries::MatchQuery.new(field: :foo, query: :bar)
  end

  context '#must' do
    before { subject.must { query } }
    it "adds the query given by executing the block to the bool query's must list" do
      expect(subject.base.query.must.first).to eq query
    end
  end

  context '#should' do
    before { subject.should { query } }
    it "adds the query given by executing the block to the bool query's should list" do
      expect(subject.base.query.should.first).to eq query
    end
  end

  context '#must_not' do
    before { subject.must_not { query } }
    it "adds the query given by executing the block to the bool query's must_not list" do
      expect(subject.base.query.must_not.first).to eq query
    end
  end

end