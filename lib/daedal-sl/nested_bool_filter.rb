module DaedalSL
  class NestedBoolFilter < BlockQuery

    def initialize(parent, options)
      @parent = parent
      @base = Daedal::Filters::NestedFilter.new(options.merge(filter: Daedal::Filters::BoolFilter.new))
    end

    def must
      if (result = yield)
        @base.filter.must << result
      end
    end

    def should
      if (result = yield)
        @base.filter.should << result
      end
    end

    def must_not
      if (result = yield)
        @base.filter.must_not << result
      end
    end

  end
end