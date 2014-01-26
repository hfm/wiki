#!/usr/bin/env ruby
require 'rubygems'
require 'settingslogic'
require 'gollum/app'

# load auth file
class Settings < Settingslogic
  source "auth.yml"
end

# authentication
module Precious
  class App < Sinatra::Base
    use Rack::Auth::Basic, "Restricted Area" do |username, password|
      [username, password] == [Settings.username, Settings.password]
    end
  end
end

# gollum
gollum_path = File.expand_path(File.dirname(__FILE__)) # CHANGE THIS TO POINT TO YOUR OWN WIKI REPO
Precious::App.set(:gollum_path, gollum_path)
Precious::App.set(:default_markup, :markdown)
Precious::App.set(:wiki_options, {:universal_toc => false})
run Precious::App
