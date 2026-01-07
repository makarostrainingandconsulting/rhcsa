# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # ----------------------------------------------------------------------------
  # GLOBAL CONFIGURATION
  # ----------------------------------------------------------------------------

  # Check for RHEL 10 box availability. If not available, use a compatible alternative.
  # The user requested to use RHEL 10. Since an official RHEL 10 box may not be
  # publicly available yet, we use a modern AlmaLinux 9 box as a stand-in,
  # which is highly compatible with RHEL. The user should replace this with
  # a certified RHEL 10 box when it becomes available.
  config.vm.box = "almalinux/9-minimal"
  config.vm.synced_folder ".", "/vagrant", disabled: true # Disable default sync
  config.ssh.insert_key = false # Use vagrant's default key management

  # Required Vagrant Plugins
  config.vm.provision "shell", inline: "vagrant plugin install vagrant-vbguest vagrant-hostmanager --local || true"

  # ----------------------------------------------------------------------------
  # NODE DEFINITIONS
  # ----------------------------------------------------------------------------

  # Define the three required nodes: master, client, and storage
  nodes = {
    "master" => "192.168.56.10",
    "client" => "192.168.56.20",
    "storage" => "192.168.56.30"
  }

  nodes.each do |hostname, ip|
    config.vm.define hostname do |node|
      node.vm.hostname = hostname
      node.vm.network "private_network", ip: ip
      node.vm.network "forwarded_port", guest: 9090, host: 9090, id: "cockpit", disabled: (hostname != "master")

      # Resource allocation (adjust as needed for RHEL 10)
      node.vm.provider "virtualbox" do |v|
        v.memory = 2048
        v.cpus = 2
        v.name = "RHCSA-RHEL10-#{hostname}"

        # Add secondary disk for LVM practice on the 'master' node
        if hostname == "master"
          v.customize ["createhd", "--filename", "#{hostname}_disk2.vdi", "--size", 5 * 1024] # 5GB in MB
          v.customize ["storageattach", :id, "--storagectl", "SATA", "--port", 1, "--device", 0, "--type", "hdd", "--medium", "#{hostname}_disk2.vdi"]
        end
      end

      # Provisioning
      node.vm.provision "shell", path: "scripts/provision.sh", args: [hostname], privileged: true
    end
  end

  # ----------------------------------------------------------------------------
  # POST-PROVISIONING HOOKS
  # ----------------------------------------------------------------------------

  # Ensure hostnames are correctly managed
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false

end
