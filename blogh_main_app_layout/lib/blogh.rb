require "blogh/version"
require "blogh/engine"

require "importmap-rails"

module Blogh
  class << self
    attr_accessor :configuration
  end

  class Configuration
    attr_reader :importmap

    def initialize
      @importmap = Importmap::Map.new
      @importmap.draw(Engine.root.join("config/importmap.rb"))
    end
  end

  def self.init_config
    self.configuration ||= Configuration.new
  end
end

# Initialize configuration when engine loads
Blogh.init_config