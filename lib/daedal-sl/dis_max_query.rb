module DaedalSL
  class DisMaxQuery < BlockQuery

    def initialize(parent, options)
      @query_type = Daedal::Queries::DisMaxQuery
      super
    end

    def query
      if (result = yield)
        @base.queries << result
      end
    end

  end
end