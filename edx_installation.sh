#!/bin/bash
if [[ `lsb_release -rs` != "16.04" ]]; then
   echo "This script is only known to work on Ubuntu 16.04, exiting...";
   exit;
fi

current_folder=`pwd`

common_requirements_install()
{
  sudo apt-get install -y python-software-properties
  sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test

  sudo apt-get update -y
  sudo apt-get upgrade -y
  sudo apt-get install -y build-essential software-properties-common curl git-core libxml2-dev libxslt1-dev python-pip libmysqlclient-dev python-apt python-dev libxmlsec1-dev libfreetype6-dev swig gcc g++ python-libxml2

  sudo pip install --upgrade pip==8.1.2
  sudo pip install --upgrade setuptools==24.0.3
  sudo -H pip install --upgrade virtualenv==15.0.2
  source VERSION_VARS
  CONFIGURATION_VERSION=${CONFIGURATION_VERSION-${OPENEDX_RELEASE-master}}
  cd /var/tmp
  git clone $CONFIGURATION_REPO
  cd configuration
  git checkout $CONFIGURATION_VERSION
  git pull
  cd /var/tmp/configuration
  sudo -H pip install -r requirements.txt
}

configure_edx_dev_instance()
{
   cd /var/tmp/configuration/playbooks 
   sudo -E ansible-playbook -c local ./vagrant-devstack.yml -i "localhost," --extra-vars "@$current_folder/COMMON_VARS.json" --extra-vars "@$current_folder/DEV_VARS.json"
}

process_dev_install()
{
  common_requirements_install
  configure_edx_dev_instance
}

process_full_install()
{
  common_requirements_install
  cd /var/tmp/configuration/playbooks
   sudo -E ansible-playbook -c local ./edx_sandbox.yml -i "localhost," --extra-vars "@$current_folder/COMMON_VARS.json" --extra-vars "@$current_folder/FULL_STACK_VARS.json" 
}


stack=$1

if [[ $stack == "dev" ]]
then
   process_dev_install
elif [[ $stack == "full" ]] 
then
   process_full_install
else
   echo "Please provide correct options ex: bash edx_install dev|full"
fi
