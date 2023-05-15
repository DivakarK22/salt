fstab:
  cmd.run:
    - name: Update fstab
    - name: cp /etc/fstab $PWD && sudo sed  '/UUID/ i ftp:/nfs /nfs nfs defaults 0 0' $PWD/fstab > /etc/test &&  sudo uniq /etc/test /etc/fstab
    - check_cmd:
      - /bin/true
fstab_copy:
   cmd.run:
    - name: Update fstab
    - name: cp /etc/fstab $PWD && sudo sed  '/ftp/ i ftp:/usr/local/rvm /usr/local/rvm nfs defaults 0 0' $PWD/fstab > /etc/test &&  sudo uniq /etc/test /etc/fstab
    - check_cmd:
      - /bin/true