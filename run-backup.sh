#!/bin/sh

cp -r /usr/lib/unifi/data/backup/autobackup/ ~/s3-backups
aws s3 cp --recursive ~/s3-backups/ s3://your_bucket_id/
rm -rf ~/s3-backups/*
