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

Instead of using `vagrant ssh` for SSH communication, all VMs have copied the user's id_rsa file, and are added automatically via PowerShell script to ssh `config` and its fingerprint to `known_hosts` file.[^1]

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

[^1]: as of now, ssh config entries are added only on Hyper-V and Virtualbox machines
