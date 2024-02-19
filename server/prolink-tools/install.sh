#/bin/bash
../beat-link-trigger/lxc-debian-gui.sh
apt-get install -y tar
openssl req -x509 -nodes -newkey ec:<(openssl ecparam -name prime256v1) -keyout novnc.pem -out novnc.pem -days 3650 -subj "/C=JP/ST=Aichi/L=Toyohashi/O=TechnoTUT/OU=NOC/CN=prolink.intra.technotut.net"
websockify -D --web /usr/share/novnc/ --cert novnc.pem 443 localhost:5901
cd ~ && https://github.com/evanpurkhiser/prolink-tools/releases/download/main-build/prolink-tools-dev-a7e78b9-linux.tar.gz && tar -xvf prolink-tools-dev-a7e78b9-linux.tar.gz && mv prolink-tools-dev-a7e78b9-linux prolink-tools && rm -f prolink-tools-dev-a7e78b9-linux.tar.gz
