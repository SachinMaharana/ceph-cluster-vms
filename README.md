# ceph-cluster-vms

A configurable terraform files to create a cluster of mons and osds in AWS to be used while exploring ceph installation.

Should not be used for production as all VM's are in public subnet and have an associated public ip address.

## Useful Commands

Make sure Access and Secret environment key is provided. It can be obtained from AWS console of your root account.

```
export AWS_ACCESS_KEY_ID=*********************
export AWS_SECRET_ACCESS_KEY=******************
```

```
terraform plan
```

```
terraform apply
```

```
terraform destroy
```

### Note

ebs volume somehow is not being deleted, even though delete_on_termination is given. Yet to identify the solution.
