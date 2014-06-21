require 'spec_helper'
require 'hashie'

describe DaedalSL do

  context 'creating a complex query' do
    it 'works' do
      expected_result = {
        query: {
          bool: {
            should: [
              {
                fuzzy: {
                  foofoo: {
                    value: "barbar"
                  }
                }
              },
              {
                multi_match: {
                  query: "barbar",
                  fields: [:field1, :field2]
                }
              }
            ],
            must: [
              {
                nested: {
                  path: :path,
                  query: {
                    bool: {
                      should: [
                        {
                          match: {
                            foofoo: {
                              query: "barbar"
                            }
                          }
                        }
                      ], 
                      must: [
                        {
                          match: {
                            foofoo: {
                              query: "barbar"
                            }
                          }
                        }
                      ],
                      must_not: []
                    }
                  }
                }
              }, 
              {
                nested: {
                  path: :path,
                  query: {
                    dis_max: {
                      queries: [
                        {
                          match: {
                            foofoo: {
                              query: "barbar"
                            }
                          }
                        },
                        {
                          match: {
                            foofoo: {
                              query: "barbar"
                            }
                          }
                        }
                      ]
                    }
                  }
                }
              }
            ],
            must_not: [
              {
                match: {
                  foofoo: {
                    query: "barbar"
                  }
                }
              }
            ],
            boost: 100.0
          }
        }, 
        filter: {
          bool: {
            should: [
              {
                and: [
                  {
                    term: {
                      foofoo: "barbar"
                    }
                  },
                  {
                    terms: {
                      foofoo: ["term1", "term2"]
                    }
                  }
                ]
              }
            ],
            must: [
              {
                nested: {
                  path: :path,
                  filter: {
                    bool: {
                      should: [
                        {
                          term: {
                            foofoo: "barbar"
                          }
                        }
                      ],
                      must: [
                        {
                          term: {
                            foofoo: "barbar"
                          }
                        }
                      ],
                      must_not: []
                    }
                  }
                }
              }
            ],
            must_not: [
              {
                range: {
                  foofoo: {
                    lt: 2,
                    gt: 1
                  }
                }
              }
            ]
          }
        },
        fields: [:foo, :bar],
        :from=>0,
        :size=>10
      }
      data = Hashie::Mash.new({
        foo: 'foofoo',
        bar: 'barbar'
      })
      result = DaedalSL.build(data) do
        query do
          bool_query boost: 100 do
            must do
              nested_bool_query path: 'path' do
                must { match field: data.foo, query: data.bar }
                should { match field: data.foo, query: data.bar }
              end
            end
            must do
              nested_dis_max_query path: 'path' do
                query { match field: data.foo, query: data.bar }
                query { match field: data.foo, query: data.bar }
              end
            end
            should { fuzzy field: data.foo, query: data.bar }
            should { multi_match fields: ['field1', 'field2'], query: data.bar }
            must_not { match field: data.foo, query: data.bar }
          end
        end
        filter do
          bool_filter do
            must do
              nested_bool_filter path: 'path' do
                must { term_filter field: data.foo, term: data.bar }
                should { term_filter field: data.foo, term: data.bar }
              end
            end
            should do
              and_filter do
                filter { term_filter field: data.foo, term: data.bar }
                filter { terms_filter field: data.foo, terms: ['term1', 'term2'] }
              end
            end
            must_not { range_filter field: data.foo, gt: 1, lt: 2 }
          end
        end
        fields :foo, :bar
        paginate page: 1, per_page: 10
      end
      expect(result).to eq expected_result
    end
  end

end