# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

ENV['LD_LIBRARY_PATH'] = "/app/.heroku/vendor/lib:#{ENV['LD_LIBRARY_PATH']}"

require File.expand_path("config/application", __dir__)

require "rake"
require "rake/testtask"
Bundler.require(:i18n_tools)

# Add debugging statements
puts "LD_LIBRARY_PATH: #{ENV['LD_LIBRARY_PATH']}"
puts "Contents of /app/.heroku/vendor/lib:"
puts `ls -l /app/.heroku/vendor/lib`
puts "Contents of /app/.apt/usr/lib/x86_64-linux-gnu:"
puts `ls -l /app/.apt/usr/lib/x86_64-linux-gnu`

CanvasRails::Application.load_tasks