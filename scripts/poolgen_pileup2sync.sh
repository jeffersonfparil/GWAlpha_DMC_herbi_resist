#!/bin/bash

### POOLGEN PILEUP TO SYNC
time \
for f in $(ls Lolium_*_*.pileup)
do
echo "@@@@@@@@@@@@@@@@@@@@@@"
time \
./poolgen pileup2sync \
    --fname ${f} \
    --output ${f%.pileup*}.sync.tmp \
    --pool-names pool_names.txt \
    --min-cov 10 \
    --n-threads 32
tail -n+2 ${f%.pileup*}.sync.tmp > ${f%.pileup*}.sync
rm ${f%.pileup*}.sync.tmp
echo "######################"
done
