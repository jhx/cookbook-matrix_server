# encoding: utf-8
#
# Cookbook Name:: matrix_server
# Recipe:: passenger_nginx
#
# Author:: Doc Walker (<doc.walker@jameshardie.com>)
#
# Copyright 2013-2014, James Hardie Building Products, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#-------------------------------------------- template[/etc/rc.d/init.d/nginx]
template '/etc/rc.d/init.d/nginx' do # or is it /etc/rc.d/init.d/nginx?
  owner     'root'
  group     'root'
  mode      '0755'
  notifies  :reload, 'service[nginx]'
end # template

#--------------------------------------------------- directory[/var/log/nginx]
directory '/var/log/nginx' do
  owner     'root'
  group     'root'
  mode      '0755'
  recursive true
end # directory

#-------------------------------------------------------- logrotate_app[nginx]
logrotate_app 'nginx' do
  cookbook      'logrotate'
  template_mode '0644'
  path          '/var/log/nginx/*.log'
  frequency     'daily'
  rotate        30
  options       %w(missingok compress delaycompress sharedscripts)
  postrotate    '[ ! -f /var/run/nginx.pid ] || ' \
    'kill -USR1 `cat /var/run/nginx.pid`'
end # logrotate_app

#----------------------------------------------------------------- user[nginx]
user node['passenger']['nginx']['user'] do
  system  true
  shell   '/bin/nologin'
  home    '/var/www'
end # user

#----------------------------------- rvm_shell[passenger-install-nginx-module]
passenger_root = "/usr/local/rvm/gems/#{node['passenger']['ruby_string']}" \
  "/gems/passenger-#{node['passenger']['version']}"
passenger_ruby = '/usr/local/rvm/wrappers/' \
  "#{node['passenger']['ruby_string']}/ruby"

nginx_signature = {
  'version' =>
    node['passenger']['version_map'].fetch(node['passenger']['version']),
  'passenger_version' => node['passenger']['version'],
  'prefix' => node['passenger']['nginx']['prefix'],
  'ruby_string' => node['passenger']['ruby_string'],
  'with' => [
    'http_ssl_module',
    'cc-opt=-Wno-error',
    *node['passenger']['nginx']['modules']
  ].sort
}

extra_configure_flags =
  node['passenger']['nginx']['modules'].map { |flag| "--with-#{flag}" }

configure_flags =
  node['passenger']['nginx']['configure_flags'].map { |flag| "--#{flag}" }

rvm_shell "#{passenger_root}/bin/passenger-install-nginx-module" do
  ruby_string node['passenger']['ruby_string']
  code [
    "#{passenger_root}/bin/passenger-install-nginx-module",
    *configure_flags,
    "--extra-configure-flags=\"#{extra_configure_flags.join(' ')}\""
  ].join(' ')
  not_if do
    node.automatic_attrs.fetch('passenger') { {} }
      .fetch('nginx_signature') { '' } == nginx_signature
  end
  notifies :restart, 'service[nginx]'
  # /opt/nginx/sbin/nginx -t # test configuration and exit
end # rvm_shell

#-------------------------------------------------------------- service[nginx]
service 'nginx' do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end # service

#---------------------------------------- template[/opt/nginx/conf/nginx.conf]
# TODO: need to fail if passenger_root or passenger_ruby is nil
# TODO: try rvm_shell verify version for above?
template node['passenger']['nginx']['conf_path'] do
  owner     'root'
  group     'root'
  mode      '0644'
  variables :passenger_root => passenger_root,
            :passenger_ruby => passenger_ruby
  notifies  :reload, 'service[nginx]'
end # template
