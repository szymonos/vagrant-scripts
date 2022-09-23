# Vagrant

Repository for vagrant VM deployments using different hypervisor providers.
The main idea for writing Vagrantfiles is to make them as generic as possible, by separating all the provisioning scripts and triggers into separate files, that may be called from any box provisioning, and keeping inside Vagrantfile, only the code, that is specific to the used provider and box combo.

Vagranfile consists of the following sections:

- **Variables declaration**
  - hypervisor provider
  - VM specification
  - ...
- **Scripts**
  - box specific packages installation
  - box specific network configuration
- **VM Provisioning**
  - common configuration, that can be used among all boxes
  - node specific configuration
  - node installation scripts
  - reload trigger for applying network changes /*optional for specific box/provider*/

## SSH configuration

For convenience's sake, VMs are not using vagrant generated ssh keys, but rather the user's key pair from `~/.ssh` folder, to be able to use just ssh command and remote SSH on VSCode easily. The `id_rsa.pub` file is added to `authorized_keys` on the provisioned VM, and `id_rsa` is specified as private key used by vagrant.
After VM provisioning, its IP is added automatically via PowerShell script to `~/.ssh/config` on the host machine and its fingerprint to `known_hosts` file.[^1]

## Repository structure

``` sh
.
├── .assets         # All helper scripts and assets used for deployments
│   ├── config        # bash and PowerShell profiles along the themes, aliases, etc...
│   ├── playbooks     # ansible playbooks
│   ├── provision     # scripts used during vm provisioning for apps install, os setup, etc...
│   ├── scripts       # other scripts not used directly by vagrant
│   └── trigger       # scripts used externally to setup the VM in hypervisor, etc...
├── hyperv          # Hyper-V provider VM deployments
│   ├── ansible       # multiple VMs deployment for ansible testing
│   ├── FedoraHV      # Fedora VM with Gnome DE for kubernetes development
│   └── ...
├── libvirt         # libvirt provider VM deployments
│   ├── ansible       # multiple VMs deployment for ansible testing
│   ├── fedora        # Fedora VM with Gnome DE for kubernetes development
│   └── ...
└── virtualbox      # VirtualBox provider VM deployments
    ├── ansible       # multiple VMs deployment for ansible testing
    ├── FedoraVB      # Fedora VM with Gnome DE for kubernetes development
    └── ...
```

## Prerequisites

To provision any box using provided Vagrantfiles you need to have:

- RSA private/public ssh key generated on your host running vagrant commands. Can be generated using command:\
  `ssh-keygen`\
  with all the defaults by simply confirming any prompt with Enter,
- Reload vagrant plugin. Can be installed using command:\
  `vagrant plugin install vagrant-reload`

[^1]: As of now, adding ssh config entries to `.ssh/config` is not supported for libvirt provider.
