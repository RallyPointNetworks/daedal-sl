require 'spec_helper'

describe DaedalSL::Builder do

  subject { DaedalSL::Builder.new }

  context '#query' do
    context 'with a block' do
      before do
        subject.query { :foo }
      end
      it 'will yield the block and set that to @query' do
        expect(subject.instance_variable_get(:@query)).to eq :foo
      end
    end
  end

  context '#filter' do
    context 'with a block' do
      before do
        subject.filter { :foo }
      end
      it 'will yield the block and set that to @filter' do
        expect(subject.instance_variable_get(:@filter)).to eq :foo
      end
    end
  end

  context '#from' do
    before do
      subject.from(5)
    end
    it 'will set the from parameter in the base hash correctly' do
      expect(subject.instance_variable_get(:@options)[:from]).to eq 5
    end
  end

  context '#size' do
    before do
      subject.size(5)
    end
    it 'will set the size parameter in the base hash correctly' do
      expect(subject.instance_variable_get(:@options)[:size]).to eq 5
    end
  end

  context '#paginate' do
    it 'will convert the page and per_page into from and size, and call those methods' do
      expect(subject).to receive(:from).with(14)
      expect(subject).to receive(:size).with(7)
      subject.paginate page: 3, per_page: 7
    end
  end

  context '#fields' do
    before { subject.fields(:foo, :bar) }
    it 'will set the fields for the query' do
      expect(subject.instance_variable_get(:@options)[:fields]).to eq [:foo, :bar]
    end
  end

  context '#to_hash' do
    context 'when a query is given' do
      before do
        subject.instance_variable_set(:@query, Daedal::Queries::MatchQuery.new(field: :foo, query: :bar))
      end
      it 'will convert @query to a hash' do
        expect(subject.to_hash).to eq({query: {match: {foo: {query: :bar}}}})
      end
    end
    context 'when a query is not given' do
      it 'will use the default match_all query' do
        expect(subject.to_hash).to eq({query: {match_all: {}}})
      end
    end
    context 'when a filter is given' do
      before do
        subject.instance_variable_set(:@filter, Daedal::Filters::TermFilter.new(field: :foo, term: :bar))
      end
      it 'will convert @filter to a hash' do
        expect(subject.to_hash).to eq({query: {match_all: {}}, filter: {term: {foo: :bar}}})
      end
    end
    context 'when from and size were specified' do
      before do
        subject.from 3
        subject.size 10
      end
      it 'will set them up appropriately in the query' do
        expect(subject.to_hash).to eq({query: {match_all: {}}, from: 3, size: 10})
      end
    end
  end

end