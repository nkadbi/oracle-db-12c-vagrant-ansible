#!/bin/bash
# give oracle some time to start....
sleep 10
UNIT=`grep Hugepagesize /proc/meminfo | awk '{print $3}'`
# Find out the HugePage size
HPG_SZ=`grep Hugepagesize /proc/meminfo | awk '{print $2}'`
# Start from 1 pages to be on the safe side and guarantee 1 free HugePage
NUM_PG=1
# Cumulative number of pages required to handle the running shared memory segments
for SEG_BYTES in `ipcs -m | awk '{print $5}' | grep "[0-9][0-9]*"`
do
MIN_PG=`echo "$SEG_BYTES/($HPG_SZ*1024)" | bc -q`
if [ $MIN_PG -gt 0 ]; then
NUM_PG=`echo "$NUM_PG+$MIN_PG+1" | bc -q`
fi
done
# Finish with results
case $UNIT in 
'kB') MEM_LOCK=`echo "$NUM_PG*$HPG_SZ" | bc -q`;
#echo "Recommended setting within the kernel boot command line: hugepages = $NUM_PG"
echo "$NUM_PG"
echo "oracle soft memlock $MEM_LOCK" >> /etc/security/limits.d/99-oracle-limits.conf
echo "oracle hard memlock $MEM_LOCK" >> /etc/security/limits.d/99-oracle-limits.conf ;;
*) echo "expecting Hugepagesize from /proc/meminfo in kB got $UNIT, please adapt script Exiting." ;;
esac

