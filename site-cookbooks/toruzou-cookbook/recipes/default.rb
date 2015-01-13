#
# Cookbook Name:: toruzou-cookbook
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute

log "Oshigoto Toruzou!"

include_recipe "toruzou-cookbook::install_pg"

user 'ops' do
  action :create
  supports manage_home: true
  shell '/bin/bash'
end

directory '/opt/toruzou' do
  owner 'ops'
  action :create
  recursive true
end

git '/opt/toruzou' do
  repository 'https://github.com/toruzou/toruzou.git'
  reference 'master'
  action :checkout
end

rbenv_ruby "2.0.0-p598"

gem_package "bundler" do
  action :install
end

script "use 2.0.0-p598" do
  interpreter 'bash'
  user 'root'
  code "rbenv global 2.0.0-p598"
end

execute "rails bundler update" do
  cwd '/opt/toruzou'
  command "bin/bundle install"
end

execute 'DB Create' do
  cwd '/opt/toruzou'
  command 'bin/rake db:create RAILS_ENV=production && touch .db_created'
  creates '.db_created'
end

execute "DB Migrate" do
  cwd '/opt/toruzou'
  command "bin/rake db:migrate RAILS_ENV=production"
end

=begin
  application "toruzou" do
    path    "/opt/toruzou"

    repository "https://github.com/toruzou/toruzou.git"

    rails do
      database do
        database "hoge"
        username "fuga"
        password "password"
      end
    end
  end
=end
