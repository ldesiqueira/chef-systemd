#
# Cookbook Name:: systemd
# Library:: Chef::Resource::SystemdBootchart
#
# Copyright 2015 The Authors
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

require_relative 'resource_systemd_util'
require_relative 'systemd_bootchart'

# manage systemd-bootchart
# http://www.freedesktop.org/software/systemd/man/systemd-bootchart.html
class Chef::Resource
  class SystemdBootchart < Chef::Resource::SystemdUtil
    self.resource_name = :systemd_bootchart
    provides :systemd_bootchart

    def conf_type(_ = nil)
      :bootchart
    end

    option_attributes Systemd::Bootchart::OPTIONS
  end
end