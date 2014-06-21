module DaedalSL
  class BlockQuery
    attr_reader :parent
    attr_reader :base

    def initialize(parent, options)
      @parent = parent
      @base = @query_type.new(options)
    end

    def method_missing(method, *args, &block)
      @parent.send(method, *args, &block)
    end

    class << self
      def build(parent, options, &block)
        result = new(parent, options)
        if block
          result.instance_eval(&block)
        end
        result.base
      end
    end

  end
end