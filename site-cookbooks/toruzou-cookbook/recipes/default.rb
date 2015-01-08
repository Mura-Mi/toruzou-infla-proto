#
# Cookbook Name:: toruzou-cookbook
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute

include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"

log "Oshigoto Toruzou!"

rbenv_ruby "2.0.0-p598"

rbenv_gem "bundler" do
  ruby_version "2.0.0-p598"
end

script "use 2.0.0-p598" do
  interpreter 'bash'
  user 'vagrant'
  code "rbenv global 2.0.0-p598"
end
