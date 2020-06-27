[all]
ansible_user=centos
ansible_ssh_private_key_file= ~/.ssh/id_rsa
ansible_python_interpreter=/usr/bin/python

[mons]
${list_mons}


[osds]
${list_osds}

[mgrs]
${list_mgrs}

[grafana-server]
${list_grafana}