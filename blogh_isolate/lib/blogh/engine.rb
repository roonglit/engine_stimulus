module Blogh
  class Engine < ::Rails::Engine
    isolate_namespace Blogh

    initializer "blog.assets" do |app|
      # Add engine's JavaScript path to Propshaft load paths
      app.config.assets.paths << root.join("app/javascript")
    end
  end
end
