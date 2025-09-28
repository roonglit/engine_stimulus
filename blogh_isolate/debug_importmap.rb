#!/usr/bin/env ruby

# Add the lib directory to load path
$LOAD_PATH.unshift File.join(__dir__, 'lib')

require 'bundler/setup'
require 'importmap-rails'

# Load the engine 
require 'blogh'

# Create a simple resolver class
class SimpleResolver
  def asset_path(path)
    "/assets/#{path}"
  end
end

# Get the importmap and output it
importmap = Blogh.configuration.importmap
resolver = SimpleResolver.new

puts "=== IMPORTMAP JSON ==="
puts importmap.to_json(resolver: resolver)
puts

puts "=== IMPORTMAP PINS ==="
importmap.instance_variable_get(:@map).each do |name, pin|
  puts "#{name} => #{pin.name} (from: #{pin.path})"
end