#
# Barclamp: clouderamanager
# Recipe: clouderamanager_controller.rb
#
# Copyright (c) 2011 Dell Inc.
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

class ClouderamanagerController < BarclampController
  before_filter :set_service_object

  def set_service_object
    @service_object = ClouderamanagerService.new logger
    @service_object.bc_name = @bc_name
  end

  private :set_service_object

  def nodes
    nodeswithroles= NodeObject.all.find_all{ |n| n.roles != nil}
    @cmmasternamenodes              = nodeswithroles.find_all{ |n| n.roles.include?("clouderamanager-masternamenode" )}
    @cmsecondarynamenodenamenodes   = nodeswithroles.find_all{ |n| n.roles.include?("clouderamanager-secondarynamenode" )}
    @cmedgenodes                    = nodeswithroles.find_all{ |n| n.roles.include?("clouderamanager-edgenode" )}
    @cmslavenodes                   = nodeswithroles.find_all{ |n| n.roles.include?("clouderamanager-slavenode" )}
    @cmhafilernodes                 = nodeswithroles.find_all{ |n| n.roles.include?("clouderamanager-ha-filer" )}
    @cmwebappnodes                  = nodeswithroles.find_all{ |n| n.roles.include?("clouderamanager-webapp" )}
    
    respond_to do |format|
      format.html { render :template => 'barclamp/clouderamanager/nodes' }
      format.text {
        export = ["role, ip, name, cpu, ram, drives"]
        @cmmasternamenodes.sort_by{|n| n.name }.each do |node|
          export << I18n.t('.barclamp.clouderamanager.nodes.master_name_node') + ", #{node.ip}, #{node.name}, #{node.cpu}, #{node.memory}, #{node.number_of_drives}"
        end
        @cmsecondarynamenodenamenodes.sort_by{|n| n.name }.each do |node|
          export << I18n.t('.barclamp.clouderamanager.nodes.secondary_name_node') + ", #{node.ip}, #{node.name}, #{node.cpu}, #{node.memory}, #{node.number_of_drives}"
        end
        @cmedgenodes.sort_by{|n| n.name }.each do |node|
          export << I18n.t('.barclamp.clouderamanager.nodes.edge_node') + ", #{node.ip}, #{node.name}, #{node.cpu}, #{node.memory}, #{node.number_of_drives}"
        end
        @cmslavenodes.sort_by{|n| n.name }.each do |node|
          export << I18n.t('.barclamp.clouderamanager.nodes.slave_nodes') + ", #{node.ip}, #{node.name}, #{node.cpu}, #{node.memory}, #{node.number_of_drives}"
        end
        @cmwebappnodes.sort_by{|n| n.name }.each do |node|
          export << I18n.t('.barclamp.clouderamanager.nodes.web_app_node') + ", #{node.ip}, #{node.name}, #{node.cpu}, #{node.memory}, #{node.number_of_drives}"
        end
        @cmhafilernodes.sort_by{|n| n.name }.each do |node|
          export << I18n.t('.barclamp.clouderamanager.nodes.ha_filer_node') + ", #{node.ip}, #{node.name}, #{node.cpu}, #{node.memory}, #{node.number_of_drives}"
        end
        headers["Content-Disposition"] = "attachment; filename=\"#{I18n.t('nodes.dell.nodes.filename', :default=>'cloudera_inventory.txt')}\""
        render :text => export.join("\n"), :content_type => 'application/text'
      }
    end
  end
  
end

