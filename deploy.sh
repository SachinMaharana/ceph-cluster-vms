#!/bin/bash -x

# Unifies the all plays and provisioning of the ceph and kuberentes cluster creation

set -o errexit          
set -o errtrace        
set -o nounset         
set -o pipefail  

err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

function main() {
  declare_variables
  run_terraform
  copy_inventory_files
  run_ceph
  run_kubernetes
  run_extras
}

function declare_variables() {
  readonly ceph_dir=./ceph-ansible-custom/ceph-ansible
  readonly kube_dir=./playbooks
  readonly kube_host=./playbooks/inventories/development/
  readonly extras=./extras
}


function run_terraform() {
  if ! terraform apply --auto-approve; then
    err "Error in Terraform Operation. Exiting...."
    exit 1
  fi
}


function copy_inventory_files() {
  cp inventory "${ceph_dir}"
  cp kube "${kube_host}"
  cp inventory kube "${extras}"
}

function run_ceph() {
  pushd $ceph_dir || exit 1
  if ! ansible-playbook -i inventory site.yml; then
    err "Error in ansible ceph playbook.Exiting.."
    exit 1
  fi
  popd || exit 1
}


function run_kubernetes () {
  pushd $kube_dir || exit 1
  if ! ansible-playbook -i inventories/development/kube site.yml; then
    err "Error in ansible k8s playbook. Exiting.."
    exit 1
  fi
  popd || exit 1
}

function run_extras() {
  pushd $extras || exit 1
  if ! ansible-playbook extra.yml; then
    err "Error in Extras. Exiting.."
    exit 1
  fi
  popd || exit 1
}


main "$@"