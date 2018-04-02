#!/bin/bash
export DEV_ENV=true
zypper in -y salt-master
systemctl enable salt-master.service
systemctl start salt-master.service
zypper in -y salt-minion
systemctl enable salt-minion.service
systemctl start salt-minion.service
for n in `cat cluster.lst`;
do
       ssh root@$n "zypper in -y salt-minion;systemctl enable salt-minion.service;systemctl start salt-minion.service"
done
for i in `cat osdnodes.lst`;
do
if [ $1 != 'nozero' ];then
       ssh root@$i "for j in {a..z};do dd if=/dev/zero of=/dev/sd$j bs=1M count=1024 oflag=direct;sgdisk -Z --clear -g /dev/sd$j;sgdisk -Z --clear -g /dev/sd$j;partprobe;done"
       ssh root@$i "dd if=/dev/zero of=/dev/sdaa bs=1M count=1024 oflag=direct;sgdisk -Z --clear -g /dev/sdaa;sgdisk -Z --clear -g /dev/sdaa;partprobe"
       ssh root@$i "dd if=/dev/zero of=/dev/sdab bs=1M count=1024 oflag=direct;sgdisk -Z --clear -g /dev/sdab;sgdisk -Z --clear -g /dev/sdab;partprobe"
fi
done
sleep 15s
salt-key --accept-all
zypper in -y deepsea
sleep 15s
salt '*' grains.append deepsea default
sleep 15s
deepsea stage run ceph.stage.0
deepsea stage run ceph.stage.1
salt-run proposal.populate name=default ratio=6 target='4*' format=bluestore wal-size=2g db-size=50g db=400-500 wal=400-500 data=3000-8000
rm -rf /srv/pillar/ceph/proposals/profile-default
#cp -rp /tmp/backup/* /srv/pillar/ceph/proposals