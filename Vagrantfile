# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/xenial64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL

  # Salt Provisioner
  config.vm.provision :salt do |salt|
    # Relative location of configuration file to use for minion
    # since we need to tell our minion to run in masterless mode
    salt.minion_config = "tests/etc/salt/minion"

    # On provision, run state.highstate (which installs packages, services, etc).
    # Highstate basicly means "comapre the VMs current machine state against
    # what it should be and make changes if necessary".
    salt.run_highstate = false

    # What version of salt to install, and from where.
    # Because by default it will install the latest, its better to explicetly
    # choose when to upgrade what version of salt to use.

    # I also prefer to install from git so I can specify a version.
    salt.install_type = "git"
    salt.install_args = "v2018.3.0"

    # Run in verbose mode, so it will output all debug info to the console.
    # This is nice to have when you are testing things out. Once you know they
    # work well you can comment this line out.
    salt.verbose = true
  end

  config.vm.provision "shell", inline: <<-SHELL
    salt-call --local state.sls python.pip
    salt-call --local state.sls reclass
    salt-call --local state.sls reclass.managed_tops
    salt-call --local state.highstate
    service nomad stop
    /usr/local/bin/nomad agent -server -config /etc/nomad/config -config /etc/nomad/conf.d/ -bootstrap-expect 1 &
    # consul need sudo because it's owner of all his files instead of root
    sudo consul members || true
    nomad server members || true
    nomad status || true
    vault version || true
    vault init; || true;
    sleep 2
    vault status || true
    echo "DONE! ssh in and get hacking: vagrant ssh"
  SHELL

end
