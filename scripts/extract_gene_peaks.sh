#!/bin/bash
### EXTRACT Ras-group-related LRR protein 4-like loci
### CONSISTENT WITHIN GENE PEAKS IN ACC13-CLETH and URANA-TERBU

grep "NW_025900209.1" Lolium_ACC013_CLETH.sync | grep "49079" -B10 -A10
grep "NW_025900908.1" Lolium_ACC013_CLETH.sync | grep "9924" -B10 -A10
grep "NC_061514.1" Lolium_ACC013_CLETH.sync | grep "212554791" -B10 -A10