#!/bin/bash
#
# Purpose :: Run config for mongo servers.
# Author :: Shailesh Sutar 
# Date :: November 25th, 2017
#
# Setting readhead to 32 on /dev/xvdh1 and /dev/xvdg1
sudo blockdev --setra 32 /dev/xvdh1
sudo blockdev --setra 32 /dev/xvdg1
# setting transparent_hugepage/defrag and transparent_hugepage/enabled to never
sudo bash -c "echo 'never' > /sys/kernel/mm/transparent_hugepage/defrag"
sudo bash -c "echo 'never' > /sys/kernel/mm/transparent_hugepage/enabled"