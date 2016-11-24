#!/bin/bash

# Set up chrony

cp files/chrony.conf /etc

systemctl enable chronyd
systemctl start chronyd

chronyc -a makestep


# Set up Torque Scheduler

bash apps/torque.sh
