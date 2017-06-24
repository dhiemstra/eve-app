module EveApp
  class Engine < ::Rails::Engine
    isolate_namespace EveApp
    config.generators.api_only = true
  end
end
