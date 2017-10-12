# How to install Open edX on a single Ubuntu 16.04 64-bit server from scratch

Launch your Ubuntu 16.04 64-bit server and log in to it as a user that has full sudo privileges.

Update your Ubuntu package sources:

```
sudo apt-get update -y
sudo apt-get upgrade -y
sudo reboot
```

### Download EDX Deployment Script

```
git clone https://github.com/skilluptech/edx_deployment.git
cd edx_deployment
```

### EDX Dev Server Install

```
bash edx_install dev
```

### EDX Single Server Installation

```
bash edx_install full
```

Note: You can change or add default configuration values in COMMON_VARS.json, DEV_VARS.json, PROD_VARS.json before executing the above command




