#!/bin/bash

dir=../ceph-ansible-custom/ceph-ansible 
kube_dir=~/blackhole/kube-vms-playbook/playbooks/inventories/development/
playbook=~/blackhole/kube-vms-playbook/playbooks

terraform apply --auto-approve


if [ $? -ne 0 ]
then
  echo "Error in Terraform." >&2
  exit 1
fi

cp inventory "$dir"
cp kube "$kube_dir"
  

pushd $dir 

if [ $? -ne 0 ]
then
  echo "Error in ansible epel." >&2
  exit 1
fi


if [ $? -ne 0 ]
then
  echo "Error in ansible mosh" >&2
  exit 1
fi

ansible-playbook -i inventory site.yml
if [ $? -ne 0 ]
then
  echo "Error in ansible playbook." >&2
  exit 1
fi
popd

pushd $playbook 
if [ $? -ne 0 ]
then
  echo "Error in ansible epel." >&2
  exit 1
fi

if [ $? -ne 0 ]
then
  echo "Error in ansible mosh." >&2
  exit 1
fi

ansible-playbook -i inventories/development/kube site.yml
if [ $? -ne 0 ]
then
  echo "Error in ansible k8s playbook." >&2
  exit 1
fi
popd
