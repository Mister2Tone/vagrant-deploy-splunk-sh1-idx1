# -*- mode: ruby -*-
# vi: set ft=ruby :

VM_MEMORY = 2048
VM_CPUS = 1
SPLUNK_PASS = "P@ssw0rd"
SPLUNK_HOME = "/opt/splunk"

Vagrant.configure("2") do |config|
	config.vm.box_check_update = false
	config.vm.synced_folder ".","/vagrant", disabled:true
	config.ssh.insert_key = false
	config.ssh.private_key_path = ["~/.vagrant.d/insecure_private_key","~/.ssh/id_rsa"]

	config.vm.define "indexer" do |idx|
		config.vm.box = "bento/ubuntu-18.04"
		idx.vm.hostname = "idx01"
		idx.vm.network "private_network", ip: "192.168.56.31"
		idx.vm.provision :hosts do |provisioner|
			provisioner.sync_hosts = true
			provisioner.imports = ['global']
			provisioner.exports = {
				'global' => [
				   ['@vagrant_private_networks', ['@vagrant_hostnames']],
			   ],
			}
		end

		idx.vm.provider "virtualbox" do |v|
			v.memory = "#{VM_MEMORY}"
			v.cpus = "#{VM_CPUS}"
			v.name = "idx01"
		end
		
		idx.vm.provision "file", after: "virtualbox", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/authorized_keys"
		idx.vm.provision "file", before: "bootstrap", source: "package/splunk.deb", destination: "/tmp/splunk.deb"

		idx.vm.provision "bootstrap", type: "shell" do |s|
			s.privileged = false
			s.name = "Bootstrap Provisioner"
			s.path = "scripts/provision.sh"
			s.env = {
				:SPLUNK_HOME => "#{SPLUNK_HOME}",
				:SPLUNK_BIN => "#{SPLUNK_HOME}/bin/splunk",
				:SPLUNK_PASS => "#{SPLUNK_PASS}"
			}
		end

		idx.vm.provision "startup", type: "shell" do |t|
			t.privileged = false
			t.name = "Start-up Provisioner"
			t.path = "scripts/start-splunk.sh"
			t.env = { :SPLUNK_BIN => "/opt/splunk/bin/splunk" }
		end

		idx.trigger.before :halt do |trigger|
			trigger.run_remote = { inline: "sudo -u splunk /opt/splunk/bin/splunk stop -f" }
		end
	end
	
	config.vm.define "search" do |sh|
		config.vm.box = "bento/ubuntu-18.04"
		sh.vm.hostname = "sh01"
		sh.vm.network "private_network", ip: "192.168.56.30"
		sh.vm.provision :hosts do |provisioner|
			provisioner.sync_hosts = true
			provisioner.imports = ['global']
			provisioner.exports = {
				'global' => [
				   ['@vagrant_private_networks', ['@vagrant_hostnames']],
			   ],
			}
		end

		sh.vm.provider "virtualbox" do |v|
			v.memory = "#{VM_MEMORY}"
			v.cpus = "#{VM_CPUS}"
			v.name = "sh01"
		end
		
		sh.vm.provision "file", after: "virtualbox", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/authorized_keys"
		sh.vm.provision "file", before: "bootstrap", source: "package/splunk.deb", destination: "/tmp/splunk.deb"

		sh.vm.provision "bootstrap", type: "shell" do |s|
			s.privileged = false
			s.name = "Bootstrap Provisioner"
			s.path = "scripts/provision.sh"
			s.env = {
				:SPLUNK_HOME => "#{SPLUNK_HOME}",
				:SPLUNK_BIN => "#{SPLUNK_HOME}/bin/splunk",
				:SPLUNK_PASS => "#{SPLUNK_PASS}"
			}
		end

		sh.vm.provision "startup", type: "shell" do |t|
			t.privileged = false
			t.name = "Start-up Provisioner"
			t.path = "scripts/start-splunk.sh"
			t.env = { :SPLUNK_BIN => "/opt/splunk/bin/splunk" }
		end
		
		sh.vm.provision "add peer", type: "shell" do |u|
			u.privileged = false
			u.name = "Adding peer node"
			u.path = "scripts/add_peer.sh"
			u.env = {
				:SPLUNK_HOME => "#{SPLUNK_HOME}",
				:SPLUNK_BIN => "#{SPLUNK_HOME}/bin/splunk",
				:SPLUNK_PASS => "#{SPLUNK_PASS}"
			}
		end
			
		sh.trigger.before :halt do |trigger|
			trigger.run_remote = { inline: "sudo -u splunk /opt/splunk/bin/splunk stop -f" }
		end
	end
end

