module DaedalSL
  class AndFilter < BlockQuery

    def initialize(parent, options)
      @query_type = Daedal::Filters::AndFilter
      super
    end

    def filter
      if (result = yield)
        @base.filters << result
      end
    end

  end
end