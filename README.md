DaedalSL
=======================
[![Gem Version](https://badge.fury.io/rb/daedal-sl.svg)](http://badge.fury.io/rb/daedal-sl)

Ruby block DSL for writing ElasticSearch queries built on [Daedal](https://github.com/cschuch/daedal)

Installation
------------

From the terminal:
``` terminal
$ gem install daedal
```

or in your `Gemfile`:

``` ruby
gem 'daedal'
```

Then, it's as simple as including the line:

``` ruby
require 'daedal'
```

Usage
--------
Coming soon... but here's an example:

``` ruby
some_data = Hashie::Mash.new({
  foo: 'foofoo',
  bar: 'barbar'
})

query = DaedalSL.build(data) do
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
```

`query` now yields:

``` ruby
{
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
```

Contributing
-------------

Feel free to contribute! We just ask that you:

* Fork the project
* Make your changes or additions
* Add tests! Our goal is to keep DaedalSL a thoroughly tested project
* Send a pull request

Feedback or suggestions are also always welcome!

License
-------

The MIT License (MIT)

Copyright (c) 2014 RallyPointNetworks

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.