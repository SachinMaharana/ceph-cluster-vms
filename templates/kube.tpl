[masters]
%{ for index,ip in list_master ~}
master-${index} ansible_host=${ip} ansible_user=centos
%{ endfor ~}


[workers]
%{ for index,ip in list_worker ~}
worker-${index} ansible_host=${ip} ansible_user=centos
%{ endfor }