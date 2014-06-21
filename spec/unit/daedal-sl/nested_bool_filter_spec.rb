require 'spec_helper'

describe DaedalSL::NestedBoolFilter do

  subject do
    DaedalSL::NestedBoolFilter.new(:parent, path: :foo)
  end

  let(:filter) do
    Daedal::Filters::TermFilter.new(field: :foo, term: :bar)
  end

  context '#must' do
    before { subject.must { filter } }
    it "adds the filter given by executing the block to the bool filter's must list" do
      expect(subject.base.filter.must.first).to eq filter
    end
  end

  context '#should' do
    before { subject.should { filter } }
    it "adds the filter given by executing the block to the bool filter's should list" do
      expect(subject.base.filter.should.first).to eq filter
    end
  end

  context '#must_not' do
    before { subject.must_not { filter } }
    it "adds the filter given by executing the block to the bool filter's must_not list" do
      expect(subject.base.filter.must_not.first).to eq filter
    end
  end

end