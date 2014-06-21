module DaedalSL
  class NestedBoolQuery < BlockQuery

    def initialize(parent, options)
      @parent = parent
      @base = Daedal::Queries::NestedQuery.new(options.merge(query: Daedal::Queries::BoolQuery.new))
    end

    def must
      if (result = yield)
        @base.query.must << result
      end
    end

    def should
      if (result = yield)
        @base.query.should << result
      end
    end

    def must_not
      if (result = yield)
        @base.query.must_not << result
      end
    end

  end
end