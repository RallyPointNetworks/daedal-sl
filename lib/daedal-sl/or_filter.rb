module DaedalSL
  class OrFilter < BlockQuery

    def initialize(parent, options)
      @query_type = Daedal::Filters::OrFilter
      super
    end

    def filter
      if (result = yield)
        @base.filters << result
      end
    end

  end
end