#!/bin/bash
#该脚本使用guestmount 工具，centos7.2中安装libguestfs-tools-c 可以获得guestmount工具
#脚本在不登录虚拟机的情况下，修改虚拟机的IP地址信息
#在某些环境下，虚拟机没有IP或IP地址与真实主机不在一个网段
#真实主机在没有virt-manger图形的情况下，远程连接虚拟机很麻烦
#该脚本可以解决类似的问题
virsh list --all


read -p "请输入虚拟机名称：" name
if virsh domstate $name | grep -q running ;then
  echo "修改虚拟机网卡数据，需要关闭虚拟机"
  virsh destroy $name
fi

mountpoint="/media/virtimage"
[ ! -d $mountpoint ] && mkdir $mountpoint
echo "请稍后...."
if mount |  grep -q "$mountpoint" ; then
  umount $mountpoint
fi 

guestmount -d $name -i $mountpoint

read -p "请输入需要修改的网卡名称：" dev
read -p "请输入IP地址：" addr
read -p "请输入需要修改的主机名：" HOSTname

#修改主机名
echo $HOSTname  >  $mountpoint/etc/hostname

#判断要修改ip的网卡是否存在，存在即开始修改，不存在即创建一个文件
if [ -f $mountpoint/etc/sysconfig/network-scripts/ifcfg-$dev ];then
    #判断原本网卡配置文件中是否有IP地址，有，就修改IP，没有，就添加一个新的IP地址
    if grep -q "IPADDR" $mountpoint/etc/sysconfig/network-scripts/ifcfg-$dev ; then
      sed -i "/IPADDR/s/=.*/=$addr/"  $mountpoint/etc/sysconfig/network-scripts/ifcfg-$dev
      echo "NETMASK=255.255.255.0" >> $mountpoint/etc/sysconfig/network-scripts/ifcfg-$dev
      sed -i "/BOOTPROTO/s/=.*/=static/"  $mountpoint/etc/sysconfig/network-scripts/ifcfg-$dev
      sed -i "/ONBOOT/s/=.*/=yes/"  $mountpoint/etc/sysconfig/network-scripts/ifcfg-$dev
    else
      echo "IPADDR=$addr" >> $mountpoint/etc/sysconfig/network-scripts/ifcfg-$dev
      echo "NETMASK=255.255.255.0" >> $mountpoint/etc/sysconfig/network-scripts/ifcfg-$dev
      sed -i "/BOOTPROTO/s/=.*/=static/"  $mountpoint/etc/sysconfig/network-scripts/ifcfg-$dev
      sed -i "/ONBOOT/s/=.*/=yes/"  $mountpoint/etc/sysconfig/network-scripts/ifcfg-$dev
    fi
else
    echo 'TYPE=Ethernet
BOOTPROTO=static
DEFROUTE=yes
ONBOOT=yes' > $mountpoint/etc/sysconfig/network-scripts/ifcfg-$dev
    echo "NAME=$dev" >>  $mountpoint/etc/sysconfig/network-scripts/ifcfg-$dev
    echo "DEVICE=$dev" >>  $mountpoint/etc/sysconfig/network-scripts/ifcfg-$dev
    echo "IPADDR=$addr" >>  $mountpoint/etc/sysconfig/network-scripts/ifcfg-$dev
    echo "NETMASK=255.255.255.0" >> $mountpoint/etc/sysconfig/network-scripts/ifcfg-$dev
fi
#如果网卡配置文件中有客户配置的IP地址，则脚本提示修改IP完成
awk -F= -v x=$addr '$2==x{print "完成..."}'  $mountpoint/etc/sysconfig/network-scripts/ifcfg-$dev

#将原来挂载的镜像取消挂载
umount $mountpoint
virsh start $name
