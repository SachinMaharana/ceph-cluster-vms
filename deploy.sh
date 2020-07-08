#!/bin/bash

dir=../ceph-ansible-custom/ceph-ansible 
kube_dir=~/blackhole/kube-vms-playbook/playbooks/inventories/development/
kube_playbook=~/blackhole/kube-vms-playbook/playbooks
extras=./extras


#terraform apply --auto-approve


if [ $? -ne 0 ]
then
  echo "Error in Terraform." >&2
  exit 1
fi

cp inventory "$dir"
cp kube "$kube_dir"
  

pushd $dir 
#ansible-playbook -i inventory site.yml
if [ $? -ne 0 ]
then
  echo "Error in ansible playbook." >&2
  exit 1
fi
popd

pushd $kube_playbook 

ansible-playbook -i inventories/development/kube site.yml

if [ $? -ne 0 ]
then
  echo "Error in ansible k8s playbook." >&2
  exit 1
fi

popd

cp inventory "$extras"
cp kube "$extras"

pushd $extras

ansible-playbook  extra.yml

if [ $? -ne 0 ]
then
  echo "Error in Extras." >&2
  exit 1
fi

popd
