require 'spec_helper'

describe DaedalSL::BlockQuery do

  let(:parent_class) do
    class ParentClass
      def data
        :data
      end
    end
    ParentClass
  end

  subject do
    class DummyClass < DaedalSL::BlockQuery
      def initialize(data, options)
        @query_type = Daedal::Queries::MatchQuery
        super
      end
    end
    DummyClass.new(parent_class.new, {field: :foo, query: :bar})
  end

  context '#initialize' do
    it 'sets @data, makes it readable' do
      expect(subject.data).to eq :data
    end
    it 'sets @base, makes it readable' do
      expect(subject.base.to_hash).to eq(Daedal::Queries::MatchQuery.new(field: :foo, query: :bar).to_hash)
    end
  end

  context 'class method #build' do
    it 'creates a new instance of the class, instance_evals a block, returns' do
      expect(DummyClass).to receive(:new).with(parent_class, {field: :foo, query: :bar}).and_return(subject)
      expect(subject).to receive(:foo)
      DummyClass.build(parent_class, {field: :foo, query: :bar}) do
        foo
      end
    end
  end

end