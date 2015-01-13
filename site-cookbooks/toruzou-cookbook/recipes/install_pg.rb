execute "download_pg" do
  cwd '/tmp'
  user 'ops'
  not_if { File.exists?('/tmp/postgresql-9.4.0.tar.gz') }
  command 'wget https://ftp.postgresql.org/pub/source/v9.4.0/postgresql-9.4.0.tar.gz'
end

execute 'unzip package' do
  cwd '/tmp'
  user 'ops'
  only_if { File.exists?('/tmp/postgresql-9.4.0.tar.gz') }
  creates '/tmp/postgresql-9.4.0'
  command 'tar xvfz postgresql-9.4.0.tar.gz'
end

directory '/opt/toruzou_infla' do
  action :create
  mode '777'
end

execute 'configure' do
  cwd '/tmp/postgresql-9.4.0'
  user 'root'
  only_if { File.exists?('/tmp/postgresql-9.4.0') }
  command './configure --prefix=/opt/postgres; make; make install; touch /opt/toruzou_infla/postgres_installed'
  creates '/opt/toruzou_infla/postgres_installed'
end

file '/opt/toruzou_infla/postgres_installed' do
  action :delete
end

user 'postgres' do
  action :create
end

execute 'init db' do
  user 'postgres'
  command '/opt/postgres/bin/initdb -D /usr/local/var/postgres'
  creates '/usr/local/var/postgres/PG_VERSION'
end

execute 'create user' do
  creates '/opt/toruzou_infla/db_user_created'
  command 'createuser -d -U postgres toruzou-production && touch /opt/toruzou_infla/db_user_created'
end

execute 'create root user' do
  creates '/opt/toruzou_infla/db_root_created'
  command 'createuser -d -U postgres root && touch /opt/toruzou_infla/db_root_created'
end

execute 'create schema' do
  creates '/opt/toruzou_infla/db_schema_created'
  command 'createdb -U postgres toruzou-production && touch /opt/toruzou_infla/db_schema_created'
end


template '/etc/profile.d/pg_path.sh' do
  mode '755'
end

template '/etc/init.d/init_pg' do
  mode '755'
end

execute 'start postgres' do
  user 'postgres'
  command '/opt/postgres/bin/pg_ctl -D /usr/local/var/postgres start'
end
