#!/bin/bash

# Copy chrony conf file
cp files/chrony.conf /etc

# Start the service
systemctl enable chronyd
systemctl start chronyd

# Manually update system time
chronyc -a makestep
