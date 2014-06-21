require 'daedal'

require 'daedal-sl/version'
require 'daedal-sl/block_query'
require 'daedal-sl/bool_query'
require 'daedal-sl/dis_max_query'
require 'daedal-sl/bool_filter'
require 'daedal-sl/nested_bool_query'
require 'daedal-sl/nested_bool_filter'
require 'daedal-sl/nested_dis_max_query'
require 'daedal-sl/and_filter'
require 'daedal-sl/or_filter'
require 'daedal-sl/query_helpers'
require 'daedal-sl/builder'

module DaedalSL
  class << self
    def build(data=nil, &block)
      result = DaedalSL::Builder.new(data)
      if block
        result.instance_eval(&block)
      end
      result.to_hash
    end
  end
end