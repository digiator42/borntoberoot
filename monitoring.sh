#!/bin/bash
ARCH=$(uname -a)
phyCPU=$(grep "physical id"  /proc//cpuinfo | wc -l)
vCPU=$(grep "processor" /proc/cpuinfo | wc -l)
usedM=$(free -m | grep Mem | cut -d ' ' -f13)
freeM=$(free -m | grep Mem | awk '{print $3}')
memRes=$(free -m | grep Mem: | awk '{printf("(%.2f%)"), $3/$2*100}')
disUsg=$(df -Bg | grep "/dev" | grep -wv "/boot" | awk '{tot+=$2} {ud+=$3} END {print ud"/"tot"Gb"}')
disPrcnt=$(df -Bg | grep "/dev" | grep -wv "/boot" | awk '{tot+=$2} {ud+=$3} END {printf("(%d%)"), ud/tot*100}')
load=$(uptime | awk '{printf("%.1f\n"), $(NF-2)}')
lstBoat=$(who -b | awk '{print $3 " " $4}')
lvm=$(lsblk | grep lvm | awk '{if ($1) {print "yes";exit;} else {print "no"} }')
tcp=$(netstat -an | grep ESTABLISHED | wc -l)
chkTCP=$(if [ ${tcp} -eq 0 ]; then echo "NOT STABLISHED"; else echo "STABLISHED"; fi)
ip=$(ip link show | grep "link/ether" | awk '{print "(" $(NF-2) ")"}')
host=$(hostname -I)
sudo=$(grep 'sudo ' /var/log/auth.log | wc -l)

wall  $'#Architecture: '  ${ARCH} \
$'\n#CPU physical:'  ${phyCPU} \
$'\n#vCPU: ' ${vCPU} \
$'\n#Memory Usage:'  ${freeM}/${usedM}MB ${memRes} \
$'\n#Disk Usage:'  ${disUsg} ${disPrcnt} \
$'\n#CPU load:'  ${load}% \
$'\n#Last boot: ' ${lstBoat} \
$'\n#LVM use:' ${lvm} \
$'\n#Connections TCP :' ${tcp} ${chkTCP}\
$'\n#User log:'  `users | wc -w` \
$'\n#Network:'  IP ${host} ${ip} \
$'\n#Sudo:'  ${sudo} cmd \
