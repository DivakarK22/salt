#/bin/bash

yum install wget -y

mkdir /opt/node-export/

cd /opt/node-export/

wget https://github.com/prometheus/node_exporter/releases/download/v1.0.0-rc.1/node_exporter-1.0.0-rc.1.linux-amd64.tar.gz

tar -xzf node_exporter-1.0.0-rc.1.linux-amd64.tar.gz

cd node_exporter-1.0.0-rc.1.linux-amd64

# CREATING SYSMD FILE TO CREATE A SERVICE CALLED node_exporter

sudo cat <<EOF > /etc/systemd/system/node_exporter.service
        [Unit]
        Description=node_exporter
        Wants=network-online.target
        After=network-online.target
        [Service]
        User=root
        Group=root
        Type=simple
        ExecStart=/opt/node-export/node_exporter-1.0.0-rc.1.linux-amd64/node_exporter
        [Install]
        WantedBy=multi-user.target
EOF

#staring and enabling services 

systemctl disable firewalld

systemctl stop firewalld

systemctl daemon-reload

systemctl start node_exporter

systemctl enable node_exporter
