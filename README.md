# vagrant

Repository for vagrant VM deployments.

## Repository structure

``` sh
.
├── .assets         # All helper scripts and assets used for deployments
│   ├── config        # bash and PowerShell profiles along the themes, aliases, etc...
│   ├── provision     # scripts used during vm provisioning for apps install, os setup, etc...
│   ├── scripts       # other scripts not used directly by vagrant
│   └── trigger       # scripts used externally to setup the VM in hypervisor, etc...
├── hyperv          # Hyper-V provider virtual machine deployments
│   ├── FedoraHV
│   └── ...
└── virtualbox      # VirtualBox provider virtual machine deployments
    ├── FedoraVB
    └── ...
```
