#! /bin/bash

#run variantbam and also generate a bai file for it.
variant -i $1 -b -o $2 -l $3 -l $4 -l $5 -r $6 && samtools index $2
