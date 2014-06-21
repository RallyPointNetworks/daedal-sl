require 'spec_helper'

describe DaedalSL::OrFilter do

  subject do
    DaedalSL::OrFilter.new(:parent, {})
  end

  let(:filter) do
    Daedal::Filters::TermFilter.new(field: :foo, term: :bar)
  end

  context '#filter' do
    before { subject.filter { filter } }
    it "adds the filter given by executing the block to the and filter's filter list" do
      expect(subject.base.filters.first).to eq filter
    end
  end

end