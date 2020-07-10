#!/bin/bash -x

set -o errexit          
set -o errtrace        
set -o nounset         
set -o pipefail  

err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}


function run_terraform() {
  if ! terraform destroy --auto-approve; then
    err "Error in Terraform Operation. Exiting...."
    exit 1
  fi
}

run_terraform



