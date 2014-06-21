module DaedalSL
  class NestedDisMaxQuery < BlockQuery

    def initialize(parent, options)
      @parent = parent
      @base = Daedal::Queries::NestedQuery.new(options.merge(query: Daedal::Queries::DisMaxQuery.new))
    end

    def query
      if (result = yield)
        @base.query.queries << result
      end
    end

  end
end