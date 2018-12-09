#!/bin/bash
#############################################################3
rpm -ivh  flash-plugin-11.2.202.341-release.x86_64.rpm  ntfs-3g_ntfsprogs-2013.1.13-1.el6.x86_64.rpm
####################################################################
yum -y install charm/google-chrome-stable_current_x86_64.rpm &> /dev/null
sed -i '108s/^/#/' /usr/share/applications/google-chrome.desktop
sed -i '108a Exec=/usr/bin/google-chrome-stable %U --user-data-dir --no-sandbox' /usr/share/applications/google-chrome.desktop
mkdir /root/桌面
cp /usr/share/applications/google-chrome.desktop /root/桌面
chmod +x /root/桌面/google-chrome.desktop
sed -i '55c exec -a "$0" "$HERE/chrome" "$@" --user-data-dir --no-sandbox' /opt/google/chrome/google-chrome
echo -e 'Google\033[32m success \033[0m'
#########################################################################
rm -rf /etc/yum.repos.d/google*
cp -r rpm /opt
cp rpm.repo /etc/yum.repos.d
yum -y install  rpm/stardict-3.0.1-22.puias6.x86_64.rpm &> /dev/null
tar -xPf stardict.tar.gz
echo -e 'xing ji ci wang\033[32m success \033[0m'
###########################################################################
mkdir /root/.ssh
cp stu_rsa/*  /root/.ssh
cp rsa/id_rsa.pub /root/.ssh/authorized_keys
echo -e 'id_rsa\033[32m success \033[0m'
###########################################################################
# 安装WPS软件
yum  -y  install  wps-2018-1-10/wps-office-10.1.0.5672-1.a21.x86_64.rpm &> /dev/null
# 安装微软office字体
yum  -y  install  fontconfig &> /dev/null
tar  xpPf  wps-2018-1-10/msfonts.tar.gz 
fc-cache
echo -e 'wps\033[32m success \033[0m'
############################################################################
tar -xf  python/crack.tar.gz -C  /usr/bin/
echo '/usr/bin/crack_pycharm &' >> /etc/rc.d/rc.local
chmod 755 /etc/rc.d/rc.local
tar -xf python/py3soft.tar.gz -C /opt
rm -rf /etc/yum.repos.d/google*
wget ftp://192.168.10.1/CentOS.repo -O /etc/yum.repos.d/CentOS.repo
yum install -y gcc gcc-c++ openssl-devel libffi-devel readline-devel zlib-devel
#########################################################################################
tar -xPf python/pycharm.tar.gz 
ln -s /root/bin/pycharm2017/bin/pycharm.sh /root/bin/pycharm
echo -e 'pycharm\033[32m success \033[0m'
####################################################################################
tar xf /opt/pysoft/py3env/Python-3.6.1.tar.xz -C /opt
cd /opt/Python-3.6.1
./configure --prefix=/usr/local
make && make install
echo "安装python3成功，请运行python3"

