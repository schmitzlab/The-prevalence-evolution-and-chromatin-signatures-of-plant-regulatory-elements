#!/bin/bash

for i in $(ls *.teACR.bed | rev |cut -c 11- | rev | uniq); do
	echo "$i"
	perl estimate_per_family_ACR_ave.pl ${i}.fa.out.fcon.bed.sorted ${i}.teACR.bed > ${i}.teACRnormFAM.bed
done

cat *.teACRnormFAM.bed > all_teACR_normStats.txt
