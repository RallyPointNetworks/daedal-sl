module DaedalSL
  class Builder
    include DaedalSL::QueryHelpers

    attr_reader :data

    def initialize(data=nil)
      @data = data
      @query = match_all
      @filter = nil
      @options = {}
    end

    def query
      if block_given?
        @query = yield
      end
    end

    def filter
      if block_given?
        @filter = yield
      end
    end

    def from(num)
      @options[:from] = num
    end

    def size(num)
      @options[:size] = num
    end

    def fields(*f)
      @options[:fields] = f
    end

    def paginate(options={})
      page = options[:page] || 1
      per_page = options[:per_page] || 10

      from ((page - 1) * per_page)
      size per_page
    end

    def to_hash
      result = {}
      unless @query.nil?
        result[:query] = @query.to_hash
      end
      unless @filter.nil?
        result[:filter] = @filter.to_hash
      end
      result.merge(@options)
    end

  end
end