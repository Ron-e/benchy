#!/bin/bash

# temporarily urls!
# wget https://raw.githubusercontent.com/Ron-e/benchy/master/benchy.sh -O - -o /dev/null|bash
# bash <(curl -L -Ss https://raw.githubusercontent.com/Ron-e/benchy/master/benchy.sh)

stime=$(date +"%m-%d-%Y %T")
cstime=`date +%s`

BENCHY_VERSION="0.1Alpha"

clear
echo ""
echo "============================================================"
echo "Benchy BenchMark Suite v$BENCHY_VERSION"
echo "============================================================"
echo "A little tool to test your Linux VPS or Server"
echo ""
echo "For more information please visit http://benchy.tk/"
echo "============================================================"

echo ""
echo "Starting Benchy BenchMark Suite..."
echo ""

echo "(1/27)  Searching Distro version..."
distro=$( cat /etc/issue | awk 'NR==1' )
echo "(2/27)  Searching CPU model..."
#cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
cname=$( cat /proc/cpuinfo |grep -m 1 "model name"|cut -d' ' -f 4- )
echo "(3/27)  Searching Number of cores..."
cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
#cores=$(cat /proc/cpuinfo |grep -m 1 "model name"|cut -d' ' -f 4-)
echo "(4/27)  Searching CPU frequency..."
#freq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )
freq=$( cat /proc/cpuinfo |grep -m 1 "cpu MHz"|cut -d' ' -f 3- )
echo "(5/27)  Searching Architecture..."
arch=$( uname -i )
echo "(6/27)  Searching Total amount of RAM..."
tram=$( free -m | awk 'NR==2 {print $2}' )
echo "(7/27)  Searching Free amount of RAM..."
#fram=$( ( cat /proc/meminfo | awk 'NR==2 {print $2}' ) | awk '{ sum=$1 ; hum[1024**3]="Gb";hum[1024**2]="Mb";hum[1024]="Kb"; for (x=1024**3; x>=1024; x/=1024){ if (sum>=x) { printf "%.2f %s\n",sum/x,hum[x];break } }}' )
fram=$( cat /proc/meminfo | grep MemFree|cut -d' ' -f 2- | awk '{ sum=$1 ; hum[1024**3]="Gb";hum[1024**2]="Mb";hum[1024]="Kb"; for (x=1024**3; x>=1024; x/=1024){ if (sum>=x) { printf "%.2f %s\n",sum/x,hum[x];break } }}' )
echo "(8/27)  Searching Total amount of SWAP..."
swap=$( free -m | awk 'NR==4 {print $2}' )
echo "(9/27)  Searching Free amount of SWAP..."
#fswap=$( ( cat /proc/meminfo | awk 'NR==16 {print $2}' ) | awk '{ sum=$1 ; hum[1024**3]="Gb";hum[1024**2]="Mb";hum[1024]="Kb"; for (x=1024**3; x>=1024; x/=1024){ if (sum>=x) { printf "%.2f %s\n",sum/x,hum[x];break } }}' )
fswap=$( cat /proc/meminfo | grep MemFree|cut -d' ' -f 2- | awk '{ sum=$1 ; hum[1024**3]="Gb";hum[1024**2]="Mb";hum[1024]="Kb"; for (x=1024**3; x>=1024; x/=1024){ if (sum>=x) { printf "%.2f %s\n",sum/x,hum[x];break } }}')

echo "(10/27) Searching uptime..."
up=$(uptime|awk '{ $1=$2=$(NF-6)=$(NF-5)=$(NF-4)=$(NF-3)=$(NF-2)=$(NF-1)=$NF=""; print }')

echo "(11/27) Searching Total amount of drive space..."
disk=$( df -h | awk 'NR==2 {print $2}' )
echo "(12/27) Searching Used amount of drive space..."
udisk=$( df -h | awk 'NR==2 {print $3}' )
updisk=$( df -h | awk 'NR==2 {print $5}' )
echo "(13/27) Searching Free amount of drive space..."
fdisk=$( df -h | awk 'NR==2 {print $4}' )

echo "(14/27) Testing I/O Speed..."
io=$( ( dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -F, '{io=$NF} END { print io}' )

echo "(15/27) Testing Ping..."
ping=$( ping -c 10 cachefly.cachefly.net 2>&1 | awk 'NR==14' )

echo "(16/27) Testing Download Speed From CacheFly..."
cachefly=$( wget -O /dev/null http://cachefly.cachefly.net/100mb.test 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo "(17/27) Testing Download Speed From Linode, Atlanta GA, US..."
linodeatl=$( wget -O /dev/null http://speedtest.atlanta.linode.com/100MB-atlanta.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo "(18/27) Testing Download Speed From Linode, Dallas, TX, US..."
linodedltx=$( wget -O /dev/null http://speedtest.dallas.linode.com/100MB-dallas.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo "(19/27) Testing Download Speed From Linode, Tokyo, JP..."
linodejp=$( wget -O /dev/null http://speedtest.tokyo.linode.com/100MB-tokyo.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo "(20/27) Testing Download Speed From Linode, London, UK..."
linodeuk=$( wget -O /dev/null http://speedtest.london.linode.com/100MB-london.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo "(21/27) Testing Download Speed From Leaseweb, Haarlem, NL..."
leasewebnl=$( wget -O /dev/null http://mirror.nl.leaseweb.net/speedtest/100mb.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo "(22/27) Testing Download Speed From Leaseweb, Frankfurt, DE..."
leasewebde=$( wget -O /dev/null http://mirror.de.leaseweb.net/speedtest/100mb.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo "(23/27) Testing Download Speed From Leaseweb, Wilmington, DE, US..."
leasewebus=$( wget -O /dev/null http://mirror.us.leaseweb.net/speedtest/100mb.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo "(24/27) Testing Download Speed From Softlayer, Singapore..."
slsg=$( wget -O /dev/null http://speedtest.sng01.softlayer.com/downloads/test100.zip 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo "(25/27) Testing Download Speed From Softlayer, Seattle, WA ,US..."
slwa=$( wget -O /dev/null http://speedtest.sea01.softlayer.com/downloads/test100.zip 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo "(26/27) Testing Download Speed From Softlayer, San Jose, CA, US..."
slsjc=$( wget -O /dev/null http://speedtest.sjc01.softlayer.com/downloads/test100.zip 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo "(27/27) Testing Download Speed From Softlayer, Washington, DC, US..."
slwdc=$( wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test100.zip 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )

echo ""
echo "Completed..."
etime=$(date +"%m-%d-%Y %T")
cetime=`date +%s`
runtime=$((cetime-cstime))

#echo ""
#echo "Preparing to send data..."
#ip=$( ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' )
#hostname=$( hostname )

#echo ""
#echo "Sending data..."
#send=$( curl -s -d "stime=$stime&etime=$etime&runtime=$runtime&ip=$ip&hostname=$hostname&distro=$distro&cname=$cname&cores=$cores&freq=$freq&arch=$arch&tram=$tram&fram=$fram&swap=$swap&fswap=$fswap&up=$up&disk=$disk&udisk=$udisk&updisk=$updisk&fdisk=$fdisk&io=$io&ping=$ping&cachefly=$cachefly&linodeatl=$linodeatl&linodedltx=$linodedltx&linodejp=$linodejp&linodeuk=$linodeuk&leasewebnl=$leasewebnl&leasewebde=$leasewebde&leasewebus=$leasewebus&slsg=$slsg&slwa=$slwa&slsjc=$slsjc&slwdc=$slwdc" http://benchy.tk/results.php )


#clear
echo ""
echo "============================================================"
echo "============================================================"
echo "Results of Benchy BenchMark Suite v$BENCHY_VERSION"
echo "============================================================"
echo "Start Time: $stime"
echo "End Time: $etime"
echo "Total runtime: $(($runtime / 60)) minutes and $(($runtime % 60)) seconds"
echo "Distro Version: $distro"
echo "CPU model: $cname"
echo "Number of cores: $cores"
echo "CPU frequency: $freq MHz"
echo "CPU architecture: $arch"
echo "Total amount of RAM: $tram MB"
echo "Total amount of free RAM: $fram"
echo "Total amount of SWAP: $swap MB"
echo "Total amount of free SWAP: $swap"
echo "System uptime: $up"
echo "Total amount of drive space: $disk"
echo "Total amount of Used drive space: $udisk"
echo "Total amount of Used drive space(percentage): $updisk"
echo "Total amount of Free drive space: $fdisk"
echo "I/O speed: $io"
echo "Ping (10 packets): $ping"
echo "Download speed from CacheFly: $cachefly "
echo "Download speed from Linode, Atlanta GA, US: $linodeatl "
echo "Download speed from Linode, Dallas, TX, US: $linodedltx "
echo "Download speed from Linode, Tokyo, JP: $linodejp "
echo "Download speed from Linode, London, UK: $linodeuk "
echo "Download speed from Leaseweb, Haarlem, NL: $leasewebnl "
echo "Download speed from Leaseweb, Frankfurt, DE: $leasewebde "
echo "Download speed from Leaseweb, Wilmington, DE, US: $leasewebus "
echo "Download speed from Softlayer, Singapore: $slsg "
echo "Download speed from Softlayer, Seattle, WA, US: $slwa "
echo "Download speed from Softlayer, San Jose, CA, US: $slsjc "
echo "Download speed from Softlayer, Washington, DC, US: $slwdc "
echo "============================================================"
#echo "Share your results with the world! => $send"
echo "============================================================"
echo ""