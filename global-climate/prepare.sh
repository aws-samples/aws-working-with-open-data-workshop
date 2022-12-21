#!/usr/bin/bash

BUCKET=your data bucket name

# download txt data
aws s3 cp --no-sign-request s3://noaa-ghcn-pds/ghcnd-stations.txt

# transform txt to csv
gawk '$1=$1' FIELDWIDTHS='11 9 10 7 3 31 4 4 6' OFS=, ghcnd-stations.txt > ghcnd-stations.csv

# add header
sed -i 1i"id,latitude,longitude,elevation,state,name,gsn_flag,hcn_flag,wmo_id" ghcnd-stations.csv

# upload to your bucket
aws s3 cp ghcnd-stations.csv s3://$BUCKET/stations_raw/ghcnd-stations.csv