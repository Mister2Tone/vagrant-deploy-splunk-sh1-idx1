#!/usr/bin/env bash

set -x

# following lines are useful if using a Vagrant base box other than the badarsebard Splunk boxes
#wget -q -O splunk.deb 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=7.3.2&product=splunk&filename=splunk-7.3.2-c60db69f8e32-linux-2.6-amd64.deb&wget=true'
#wget -O splunk.deb 'https://www.splunk.com/page/download_track?file=7.3.4/linux/splunk-7.3.4-13e97039fb65-linux-2.6-amd64.deb&ac=&wget=true&name=wget&platform=Linux&architecture=x86_64&version=7.3.4&product=splunk&typed=release'
sudo dpkg -i /tmp/splunk.deb

# set timezone and some conveniences
sudo timedatectl set-timezone Asia/Bangkok
sudo -u splunk cp /home/vagrant/.bashrc ${SPLUNK_HOME}/.bashrc
sudo -u splunk cp /home/vagrant/.profile ${SPLUNK_HOME}/.profile
echo "alias splunk=${SPLUNK_BIN}" | sudo tee -a ${SPLUNK_HOME}/.bashrc > /dev/null
echo "splunk:${SPLUNK_PASS}" | sudo chpasswd

# set Splunk logging levels
sudo -u splunk tee -a ${SPLUNK_HOME}/etc/log-local.cfg << 'EOF'
EOF

# remove first login warning 
sudo -u splunk touch ${SPLUNK_HOME}/etc/.ui_login

# initial Splunk start with license accept
sudo -i -u splunk ${SPLUNK_BIN} start --accept-license --accept-yes --no-prompt --seed-passwd changeme

# lower the minimal free space required to 1GB
sudo -i -u splunk ${SPLUNK_BIN} set minfreemb 1000 -auth admin:changeme

# change addmin default password
sudo -i -u splunk ${SPLUNK_BIN} edit user admin -password ${SPLUNK_PASS} -auth admin:changeme
