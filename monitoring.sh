#!/bin/bash
ARCH=`uname -a`
phyCPU=`grep "physical id"  /proc//cpuinfo | wc -l`
vCPU=`grep "processor" /proc/cpuinfo | wc -l`
usedM=`free -m | grep Mem | cut -d ' ' -f13`
freeM=`free -m | grep Mem | awk '{print $3}'`
memRes=`free -m | grep Mem: | awk '{printf("(%.2f%)"), $3/$2*100}'`
disUsg=`df -Bg | grep "/dev" | grep -wv "/boot" | awk '{tot+=$2} {ud+=$3} END {print ud"/"tot"Gb"}'`
disPrcnt=`df -Bg | grep "/dev" | grep -wv "/boot" | awk '{tot+=$2} {ud+=$3} END {printf("(%d%)"), ud/tot*100}'`
load=`uptime | awk '{printf("%.1f\n"), $(NF-2)}'`
lstBoat=`who -b | awk '{print $3 " " $4}'`
lvm=`lsblk | grep lvm | awk '{if ($1) {print "yes";exit;} else {print "no"} }'`
tcp=`netstat -an | grep ESTABLISHED | wc -l`
ip=`(ip link show | grep "link/ether" | awk '{print "(" $(NF-2) ")"}')`
host=`hostname -I`
sudo=`grep 'sudo ' /var/log/auth.log | wc -l`

echo $'#Architecture:\t' ${ARCH}
echo $'#CPU physical:\t' ${phyCPU}
echo $'#vCPU:\t' ${vCPU}
echo $'#Memory Usage:\t' ${freeM}/${usedM}MB ${memRes}
echo $'#Disk Usage:\t' ${disUsg} $disPrcnt
echo $'#CPU load:\t' $load%
echo $'#Last boot:\t' $lstBoat
echo $'#LVM use:' $lvm
echo $'#Connections TCP :\t'$tcp `if [ $tcp -eq 0 ]
	then
	  echo "NOT Established"
  	else
	  echo "STABLISHED"
	fi`
echo $'#User log:\t' `users | wc -w`
echo $'#Network:\t' IP ${host} ${ip}
echo $'#Sudo:\t' $sudo cmd
