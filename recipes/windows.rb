#
# Author:: Benoit Caron (<benoit@patentemoi.ca>)
# Cookbook Name:: java
# Recipe:: windows
#
# Copyright 2012, Benoit Caron
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
#

java_home = node['java']["java_home"]
arch = node['java']['arch']
jdk_version = node['java']['jdk_version']

#convert version number to a string if it isn't already
if jdk_version.instance_of? Fixnum
  jdk_version = jdk_version.to_s
end

# FIXME this does nothing: should be used to set the java-home
# correctly for 32-bit java installed on 64bit OS
# if node['java']['arch'] == "win62" and node ??? is 64 bit 
#   node['java']['java_home'] = "C:\Progra~2\Java\jre6"
# end

case jdk_version
when "6"
  installer_url = node['java']['jdk']['6'][arch]['url']
when "7"
  installer_url = node['java']['jdk']['7'][arch]['url']
end

if installer_url =~ /example.com/
  Chef::Application.fatal!("You must change the download link to your private repository. You can no longer download java directly from http://download.oracle.com without a web broswer")
end

# FIXME: set this to the correct name for full idempotency
windows_package "Java " do
  source installer_url
  installer_type :custom
  options "/quiet" 
  action :install
end

# Set Java home
env "JAVA_HOME" do
  action :create
  value node['java']['java_home']
end

env "PATH" do
  action :modify
  delim ';'
  value "#{node['java']['java_home']}\\bin"
end
