#!/bin/sh
#
# copy figfiles from tvac_j3 on asl
#
# exclude (maybe) everything but fig and text files.  
# add "-n" for a dry run.
#

rsync -av $* ../tvac_j4/ \
  --exclude .git \
  --exclude cal_test \
  --exclude focal_fit \
  --exclude gas_calcs \
  --exclude inst_data \
  --exclude sergio \
  --exclude source \
  --exclude *.mat \
  --exclude *.m \
  --exclude *.m~ \
  --exclude *.png \
  --exclude *.tar \
  --exclude *.dat \
  --exclude *.sh \
  --exclude *.sh~ \
  --exclude *.txt~ \
  --exclude *.nfs* \
  --exclude COPYING \
   motteler.dyndns.org:asl/tvac_j4

