Gem::Specification.new do |s|
  s.name        = 'daedal-sl'
  s.version     = '0.0.0'
  s.summary     = "Ruby block DSL for writing ElasticSearch queries"
  s.description = "Ruby block DSL for writing ElasticSearch queries"
  s.authors     = ["Christopher Schuch"]
  s.email       = 'cas13091@gmail.com'
  s.files       = `git ls-files`.split("\n")
  s.require_paths = ['lib']
  s.license     = 'MIT'
  s.homepage    = 'https://github.com/RallyPointNetworks/daedal-sl'

  s.add_dependency('daedal', '>= 0.0.12')
end