# 第一步创建系统盘文件
cd /var/lib/libvirt/images
qemu-img create -b node.qcow2 -f qcow2 openstack.img 50G
qemu-img create -b node.qcow2 -f qcow2 nova01.img 50G
qemu-img create -f qcow2 disk.img 20G

# 拷贝 openstack.xml  nova01.xml 到  /etc/libvirt/qemu/ 下
virsh  define  /etc/libvirt/qemu/openstack.xml
virsh  define  /etc/libvirt/qemu/nova01.xml

virsh  start  openstack
virsh  start  nova01

# 第二步进入虚拟机配置 ip 地址
# /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE="eth0"
ONBOOT="yes"
NM_CONTROLLED="no"
TYPE="Ethernet"
BOOTPROTO="static"
IPADDR="192.168.1.10"
NETMASK="255.255.255.0"
GATEWAY="192.168.1.254"

# ifcfg-eth1
DEVICE="eth1"
ONBOOT="yes"
NM_CONTROLLED="no"
TYPE="Ethernet"
BOOTPROTO="static"
IPADDR="192.168.4.10"
NETMASK="255.255.255.0"

# 第三步修改  /etc/hosts   
# /etc/hosts
192.168.1.10	openstack
192.168.1.11	nova01

# 重启机器
# nova01  做同样的修改， ip配置为 192.168.1.11  192.168.4.11

# 在真机上 mount iso 
# 在虚拟机上配置12个yum 源 [1个系统源，1个扩展源，10个openstack软件源]
# 共 10731 包
[root@openstack ~]# yum repolist
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
repo id                         repo name                        status
local_repo                      CentOS-7 - Base                  9,591
openstack-10                    openstack-10                       680
openstack-10-devtools           openstack-10-devtools                3
openstack-10-optools            openstack-10-optools                99
openstack-10-tools              openstack-10-tools                  84
openstack-ext                   openstack extras                    76
rhceph-2-mon                    rhceph-2-mon                        41
rhceph-2-osd                    rhceph-2-osd                        28
rhceph-2-tools                  rhceph-2-tools                      35
rhscon-2-agent                  rhscon-2-agent                      19
rhscon-2-installer              rhscon-2-installer                  46
rhscon-2-main                   rhscon-2-main                       29
repolist: 10,731


