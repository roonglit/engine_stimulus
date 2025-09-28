module Blogh
  class Engine < ::Rails::Engine
    isolate_namespace Blogh

    initializer "blogh.assets" do |app|
      app.config.assets.paths << root.join("app/javascript")
    end

    # Make sure engine's importmap is loaded after main app's importmap
    initializer "blogh.importmap", before: "importmap" do |app|
      app.config.importmap.paths << root.join("config/importmap.rb")
      app.config.importmap.cache_sweepers << root.join("app/javascript")
    end
  end
end
