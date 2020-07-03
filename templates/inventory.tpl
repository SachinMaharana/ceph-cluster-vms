[all:vars]
ansible_user=centos
ansible_ssh_private_key_file= ~/.ssh/id_rsa
ansible_python_interpreter=/usr/bin/python

[mons]
%{for ip in list_mons ~}
${ip} monitor_interface=eth0
%{ endfor ~}

[osds]
%{for ip in list_osds ~}
${ip} monitor_interface=eth0
%{ endfor ~}

[grafana-server]
${list_grafana}