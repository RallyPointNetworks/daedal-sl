module DaedalSL
  module QueryHelpers
    include Daedal::Queries
    include Daedal::Filters

    def and_filter(options={}, &block)
      DaedalSL::AndFilter.build(self, options, &block)
    end

    def bool_filter(options={}, &block)
      DaedalSL::BoolFilter.build(self, options, &block)
    end

    def bool_query(options={}, &block)
      DaedalSL::BoolQuery.build(self, options, &block)
    end

    def constant_score(options)
      ConstantScoreQuery.new(options)
    end

    def dis_max(options={}, &block)
      DaedalSL::DisMaxQuery.build(self, options, &block)
    end

    def exists_filter(options)
      ExistsFilter.new(options)
    end

    def filtered_query(options)
      FilteredQuery.new(options)
    end

    def fuzzy(options)
      FuzzyQuery.new(options)
    end

    def geo_distance_filter(options)
      GeoDistanceFilter.new(options)
    end

    def match(options)
      MatchQuery.new(options)
    end

    def match_all
      MatchAllQuery.new
    end

    def multi_match(options)
      MultiMatchQuery.new(options)
    end

    def nested_bool_query(options={}, &block)
      DaedalSL::NestedBoolQuery.build(self, options, &block)
    end

    def nested_bool_filter(options={}, &block)
      DaedalSL::NestedBoolFilter.build(self, options, &block)
    end

    def nested_dis_max_query(options={}, &block)
      DaedalSL::NestedDisMaxQuery.build(self, options, &block)
    end

    def or_filter(options={}, &block)
      DaedalSL::OrFilter.build(self, options, &block)
    end

    def prefix(options)
      PrefixQuery.new(options)
    end

    def query_string(options)
      QueryStringQuery.new(options)
    end

    def range_filter(options)
      RangeFilter.new(options)
    end

    def term_filter(options)
      TermFilter.new(options)
    end

    def terms_filter(options)
      TermsFilter.new(options)
    end

  end
end