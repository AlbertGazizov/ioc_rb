require 'rubygems'
require 'bundler/setup'
require 'debugger'

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter = :documentation #:progress, :html, :textmate
end
