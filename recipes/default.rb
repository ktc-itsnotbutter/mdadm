#
# Cookbook Name:: mdadm
# Recipe:: default
#
# Copyright 2013, Robert Choi <taeilchoi1@gmail.com>
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

package "mdadm" do
  action :install
end

node['mdadm']['raids'].each do |name, raid|
  mdadm name do
    devices raid['devices']
    level raid['level']
    chunk raid['chunk']
    action [ :create, :assemble ]
    not_if "test -f /var/lock/.mdadm_config_done"
  end
end

execute "create-mdadm-config" do
  command "(mdadm --detail --scan > /etc/mdadm/mdadm.conf) && touch /var/lock/.mdadm_config_done"
  creates "/var/lock/.mdadm_config_done"
  action :run
end

# In mdadm.conf, 'name' keyword should be removed.
ruby_block 'modify-mdadm-config' do
  block do
    conf_file = Chef::Util::FileEdit.new "/etc/mdadm/mdadm.conf"
    conf_file.search_file_delete(/name.*\ /)
  end
  action :nothing
  subscribes :create, "execute[create-mdadm-config]", :immediately
end

# Update initramfs so that mdadm.conf is included in it..
execute "update-initramfs" do
  command "update-initramfs -u && touch /var/lock/.mdadm_update_done"
  creates "/var/lock/.mdadm_update_done"
  action :nothing
  subscribes :run, "ruby_block[modify-mdadm-config]", :immediately
end

# Make sure to arrange for the arrays to be marked clean before shutdown.
execute "mdadm-wait-clean" do
  command "mdadm --wait-clean --scan"
  action :nothing
  subscribes :run, "execute[update-initramfs]", :immediately
end
