# Netcool_active_Alerts

Netcool is a Monitoring tool for failure and Long running jobs running on schedular ( say we have autosys agent here).

The unix based autosys script which fetch the job status of 1000+ jobs in a less than 2 mins. 

This script has advantage over manual monitoring of each job status and clearing form netcool.

### Enhancement Suggested to this script:
  - Get update table access on netcool database to clear the SUCCESS job from netcool tool ( with this way we can save time on monitoring SUCCESS JOB ).
  - Knowledge base or small note also be added with job failure in the script ( with this way imporvement over troubleshoot time) 
  
### Pre-requisites:
  - Autosys agent install on Unix server
  - Copy the Netcool screen content in file `input.txt` ( as tentative requirement ) ( suppose to take input from netcool database )
Trigger `./netcool_active_alerts.sh` to get the job status.
