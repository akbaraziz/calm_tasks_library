rm /home/centos/@@{cluster_name}@@-kubectl.cfg

echo "
# -*- mode: yaml; -*-
# vim: syntax=yaml
#
apiVersion: v1
kind: Config
clusters:
- name: @@{cluster_name}@@
  cluster:
    @@{src_server}@@
    @@{src_ca}@@
users:
- name: default-user-@@{cluster_name}@@
  user:
    @@{src_token}@@
contexts:
- context:
    cluster: @@{cluster_name}@@
    user: default-user-@@{cluster_name}@@
  name: @@{cluster_name}@@-context
current-context: @@{cluster_name}@@-context" > /home/centos/@@{cluster_name}@@-kubectl.cfg

#echo @@{src_kubeconfig}@@ > @@{SRC_KUBECONFIG_name}@@
#echo @@{dst_kubeconfig}@@ > @@{DST_KUBECONFIG_name}@@