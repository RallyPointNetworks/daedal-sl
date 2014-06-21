module DaedalSL
  class BoolFilter < BlockQuery

    def initialize(parent, options)
      @query_type = Daedal::Filters::BoolFilter
      super
    end

    def must
      if (result = yield)
        @base.must << result
      end
    end

    def should
      if (result = yield)
        @base.should << result
      end
    end

    def must_not
      if (result = yield)
        @base.must_not << result
      end
    end

  end
end