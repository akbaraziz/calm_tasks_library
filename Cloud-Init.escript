#cloud-config
chpasswd:
  list: |
    root:@@{LinuxAdmin.secret}
  expire: False
runcmd:
  - sed -i -e '/^PermitRootLogin/s/^.*$/PermitRootLogin yes/' /etc/ssh/sshd_config
  - sed -i -e '/^PasswordAuthentication/s/^.*$/PasswordAuthentication yes/' /etc/ssh/sshd_config
  - service sshd restart