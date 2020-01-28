# vagrant-deploy-splunk-sh1-idx1
## My Environment
- Windows Linux Subsystem (Ubuntu 18.04 LTS)
- Vagrant 2.2.6 (both WSL & Windows side)
- VirtualBox Version 6.0.14 r133895 (Qt5.6.2)

## Prerequisite
- Splunk Package Deb store at `package` directory (you can follow README inside the directory)
- Vagrant Plugin 
  - vagrant-hosts
- SSH RSA public key store at `~/.ssh/id_rsa.pub` (you need to generate RSA Key in WSL Environment)
  - remark: Need to forward key manually because of WSL Environment conflict with automatically forward key by Vagrant
- Virtual Box have already installed
- Host-only Interface provide IP Pool= 192.168.56.0/24

## Boxes
- indexer
  - IP 192.168.56.31
  - CPU 1 core
  - RAM 2048 MB
- search
  - IP 192.168.56.30
  - CPU 1 core
  - RAM 2048 MB
- Default user admin:P@ssw0rd on both box
