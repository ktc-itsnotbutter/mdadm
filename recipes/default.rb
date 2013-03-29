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
  end
end

# In mdadm.conf, 'name' keyword should be removed.
ruby_block 'create mdadm config file' do
  block do
    cmd = "mdadm --detail --scan > /etc/temp_mdadm_conf"
    if system(cmd)
      text = File.open('/etc/temp_mdadm_conf').read
      text.gsub!(/name.*\ /,'')
      File.open('/etc/mdadm/mdadm.conf','w') {|file| file.write(text)}
      system('rm /etc/temp_mdadm_conf')
    else
      raise "failed to create mdadm config file."
    end
  end
end

# Update initramfs so that mdadm.conf is included in it..
execute 'update-initramfs -u' do
end

# Make sure to arrange for the arrays to be marked clean before shutdown.
execute 'mdadm --wait-clean --scan' do
end
