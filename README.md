# vagrant

Repository for vagrant VM deployments.

## Repository structure

``` sh
.
├── hyperv          # Hyper-V provider virtual machine deployments
│   ├── FedoraHV
│   └── ...
├── scripts         # All helper scripts used for provisioning
│   ├── config      # bash and PowerShell profiles along the themes, aliases, etc...
│   ├── other       # other scripts not used directly by vagrant
│   ├── provision   # scripts used during vm provisioning for apps install, os setup, etc...
│   └── trigger     # scripts used externally to setup the VM in hypervisor, etc...
└── virtualbox      # VirtualBox provider virtual machine deployments
    ├── FedoraVB
    └── ...
```
