require 'spec_helper'

describe DaedalSL::QueryHelpers do

  subject do
    class QueryHelpersDummyClass
      include DaedalSL::QueryHelpers
      def data
        :data
      end
    end
    QueryHelpersDummyClass.new
  end

  context '#match_all' do
    it 'will return a match all query' do
      expect(Daedal::Queries::MatchAllQuery).to receive(:new).and_return(:foo)
      expect(subject.match_all).to eq :foo
    end
  end

  context '#match' do
    it 'will return a match query' do
      expect(Daedal::Queries::MatchQuery).to receive(:new).with(:foo).and_return(:bar)
      expect(subject.match(:foo)).to eq :bar
    end
  end

  context '#fuzzy' do
    it 'will return a fuzzy query' do
      expect(Daedal::Queries::FuzzyQuery).to receive(:new).with(:foo).and_return(:bar)
      expect(subject.fuzzy(:foo)).to eq :bar
    end
  end

  context '#geo_distance_filter' do
    it 'will return a geo distance filter' do
      expect(Daedal::Filters::GeoDistanceFilter).to receive(:new).with(:foo).and_return(:bar)
      expect(subject.geo_distance_filter(:foo)).to eq :bar
    end
  end

  context '#multi_match' do
    it 'will return a multi match query' do
      expect(Daedal::Queries::MultiMatchQuery).to receive(:new).with(:foo).and_return(:bar)
      expect(subject.multi_match(:foo)).to eq :bar
    end
  end

  context '#prefix' do
    it 'will return a prefix query' do
      expect(Daedal::Queries::PrefixQuery).to receive(:new).with(:foo).and_return(:bar)
      expect(subject.prefix(:foo)).to eq :bar
    end
  end

  context '#query_string' do
    it 'will return a query string query' do
      expect(Daedal::Queries::QueryStringQuery).to receive(:new).with(:foo).and_return(:bar)
      expect(subject.query_string(:foo)).to eq :bar
    end
  end

  context '#term_filter' do
    it 'will return a term filter' do
      expect(Daedal::Filters::TermFilter).to receive(:new).with(:foo).and_return(:bar)
      expect(subject.term_filter(:foo)).to eq :bar
    end
  end

  context '#range_filter' do
    it 'will return a range filter' do
      expect(Daedal::Filters::RangeFilter).to receive(:new).with(:foo).and_return(:bar)
      expect(subject.range_filter(:foo)).to eq :bar
    end
  end

  context '#terms_filter' do
    it 'will return a terms filter' do
      expect(Daedal::Filters::TermsFilter).to receive(:new).with(:foo).and_return(:bar)
      expect(subject.terms_filter(:foo)).to eq :bar
    end
  end

  context '#exists_filter' do
    it 'will return an exists filter' do
      expect(Daedal::Filters::ExistsFilter).to receive(:new).with(:foo).and_return(:bar)
      expect(subject.exists_filter(:foo)).to eq :bar
    end
  end

  context '#filtered_query' do
    it 'will return a filtered query' do
      expect(Daedal::Queries::FilteredQuery).to receive(:new).with(:foo).and_return(:bar)
      expect(subject.filtered_query(:foo)).to eq :bar
    end
  end

  context '#bool_query' do
    it 'will return a bool query' do
      expect(DaedalSL::BoolQuery).to receive(:build).with(subject, {}).and_return(:bar)
      expect(subject.bool_query({}, &:foo)).to eq :bar
    end
    it 'sets up the parent correctly to allow @data and the other query helpers to be used' do
      expected_result = {:bool=>{:should=>[{:match=>{:foo=>{:query=>:bar}}}], :must=>[{:match=>{:data=>{:query=>:data}}}], :must_not=>[{:match=>{:foo=>{:query=>:bar}}}], :boost=>10.0}}
      result = subject.bool_query(boost: 10) do
        must { match field: data, query: data }
        should { match field: :foo, query: :bar }
        must_not { match field: :foo, query: :bar }
      end
      expect(result.to_hash).to eq expected_result
    end
  end

  context '#bool_filter' do
    it 'will return a bool filter' do
      expect(DaedalSL::BoolFilter).to receive(:build).with(subject, {}).and_return(:bar)
      expect(subject.bool_filter({}, &:foo)).to eq :bar
    end
    it 'sets up the parent correctly to allow @data and the other query helpers to be used' do
      expected_result = {:bool=>{:should=>[{:term=>{:foo=>:bar}}], :must=>[{:term=>{:data=>:data}}], :must_not=>[{:term=>{:foo=>:bar}}]}}
      result = subject.bool_filter do
        must { term_filter field: data, term: data }
        should { term_filter field: :foo, term: :bar }
        must_not { term_filter field: :foo, term: :bar }
      end
      expect(result.to_hash).to eq expected_result
    end
  end

  context '#dis_max' do
    it 'will return a dis max query' do
      expect(DaedalSL::DisMaxQuery).to receive(:build).with(subject, {}).and_return(:bar)
      expect(subject.dis_max({}, &:foo)).to eq :bar
    end
    it 'sets up the parent correctly to allow @data and the other query helpers to be used' do
      expected_result = {:dis_max=>{:queries=>[{:match=>{:data=>{:query=>:data}}}], :boost=>10.0}}
      result = subject.dis_max(boost: 10) do
        query { match field: data, query: data }
      end
      expect(result.to_hash).to eq expected_result
    end
  end

  context '#and_filter' do
    it 'will return a and filter' do
      expect(DaedalSL::AndFilter).to receive(:build).with(subject, {}).and_return(:bar)
      expect(subject.and_filter({}, &:foo)).to eq :bar
    end
    it 'sets up the parent correctly to allow @data and the other query helpers to be used' do
      expected_result = {:and=>[{:term=>{:data=>:data}}]}
      result = subject.and_filter(boost: 10) do
        filter { term_filter field: data, term: data }
      end
      expect(result.to_hash).to eq expected_result
    end
  end

  context '#or_filter' do
    it 'will return a and filter' do
      expect(DaedalSL::OrFilter).to receive(:build).with(subject, {}).and_return(:bar)
      expect(subject.or_filter({}, &:foo)).to eq :bar
    end
    it 'sets up the parent correctly to allow @data and the other query helpers to be used' do
      expected_result = {:or=>[{:term=>{:data=>:data}}]}
      result = subject.or_filter(boost: 10) do
        filter { term_filter field: data, term: data }
      end
      expect(result.to_hash).to eq expected_result
    end
  end

  context '#nested_bool_query' do
    it 'will return a nested bool query' do
      expect(DaedalSL::NestedBoolQuery).to receive(:build).with(subject, {path: :foo}).and_return(:bar)
      expect(subject.nested_bool_query({path: :foo}, &:foo)).to eq :bar
    end
    it 'sets up the parent correctly to allow @data and the other query helpers to be used' do
      expected_result = {:nested=>{:path=>:foo, :query=>{:bool=>{:should=>[{:match=>{:foo=>{:query=>:bar}}}], :must=>[{:match=>{:data=>{:query=>:data}}}], :must_not=>[{:match=>{:foo=>{:query=>:bar}}}]}}}}
      result = subject.nested_bool_query(path: :foo) do
        must { match field: data, query: data }
        should { match field: :foo, query: :bar }
        must_not { match field: :foo, query: :bar }
      end
      expect(result.to_hash).to eq expected_result
    end
  end

  context '#nested_bool_filter' do
    it 'will return a nested bool query' do
      expect(DaedalSL::NestedBoolFilter).to receive(:build).with(subject, {path: :foo}).and_return(:bar)
      expect(subject.nested_bool_filter({path: :foo}, &:foo)).to eq :bar
    end
    it 'sets up the parent correctly to allow @data and the other query helpers to be used' do
      expected_result = {:nested=>{:path=>:foo, :filter=>{:bool=>{:should=>[{:term=>{:foo=>:bar}}], :must=>[{:term=>{:data=>:data}}], :must_not=>[{:term=>{:foo=>:bar}}]}}}}
      result = subject.nested_bool_filter(path: :foo) do
        must { term_filter field: data, term: data }
        should { term_filter field: :foo, term: :bar }
        must_not { term_filter field: :foo, term: :bar }
      end
      expect(result.to_hash).to eq expected_result
    end
  end

  context '#nested_dis_max_query' do
    it 'will return a nested bool query' do
      expect(DaedalSL::NestedDisMaxQuery).to receive(:build).with(subject, {path: :foo}).and_return(:bar)
      expect(subject.nested_dis_max_query({path: :foo}, &:foo)).to eq :bar
    end
    it 'sets up the parent correctly to allow @data and the other query helpers to be used' do
      expected_result = {:nested=>{:path=>:foo, :query=>{:dis_max=>{:queries=>[{:match=>{:data=>{:query=>:data}}}]}}}}
      result = subject.nested_dis_max_query(path: :foo) do
        query { match field: data, query: data }
      end
      expect(result.to_hash).to eq expected_result
    end
  end

end