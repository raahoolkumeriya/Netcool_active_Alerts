#!/bin/bash

#----------------------------------------------------------------------------------------------------------------------------------------------------
#	
#	Author		: Rahul Kumeriya
#	Date		: Wed Jan 25 19:29:01 IST 2017
#	Desc		: Script to find the job status from NETCOOL
#	USAGES		: Paste NETCOOL data in input.txt file and trigger the script "netcool_active_alerts.sh" 
#	ENHANCEMENT 	: Hardcore update in netcool database whe job is SUCCESS so that manual workeffort will reduce to clear the alert from netcool 
#------------------------------------------------------------------------------------------------------------------------------------------------------

#calling autosys Agent from below location 

 # if autosys agent details path update in bash_profile file
. $HOME/.profile		

# AUTOSYS script are at below location 
export SCRIPT_PATH=$PWD    

#Cleanup function to clean the temparary files created during the ran of script
cleanup(){
	rm -rf output output.txt single instance job input1
}
trap cleanup EXIT


echo 
echo -e "\t\t\t\t $(tput setab 2) $(tput bold) NETCOOL ACTIVE ALERTS $(tput sgr0) "
echo 

netcool(){
	
#function to get autosys job status irrespective to all available instances

fetching_job_status()
{
	grep -e MAXRUNS -e FAILURE input.txt > input1

	awk -F ' ' '{print $9}' input1 | tail -n +2>instance
	awk -F ' ' '{print $13}' input1 | tail -n +2>job

chmod 777 input1 instance job 

# To fetech 1 1 element form instance and job respectiveily 
while true:
do
	read -r f1 <&3 || break
	read -r f2 >&4 || break
	export AUTOSYS_SERVER=$f1
	$SCRIPT_PATH/autosys_job_status.sh -j $f2 | grep -v Job | grep -v ______ | sed '/^$/d'
done 3<instance 4<job

}


fetching_job_status > output.txt

chmod 777 output.txt

#formating the output of job with there current job STATUS

grep -v '^ ' output.txt > output

chmod 777 output

count=`cat output | wc -l`

for i in `seq 1 $count`
do
	b = `sed -ne "$i p" output | cut -c 108,109`
	sed -ne "$i p" output > single 
	chmod 777 single
	
	case $b in 
		'FA')	
			job_name =`awk -F ' ' '{print $1}' single`
			inc = `grep $job_name input.txt | awk -F ' ' '{print $27}'`
			instance_name =`grep $job_name input.txt | awk -F ' ' '{print $9}'`
			echo -ne "$instance_name"
			echo -ne "`awk -F ' ' '{print $1}' single` FAILURE "
			if [[ $inc = "INC"* ]]
			then
				echo -e "\t\t\t $inc"
			else
				echo " "
			fi
			;;

		'TE')	
			job_name =`awk -F ' ' '{print $1}' single`
			inc = `grep $job_name input.txt | awk -F ' ' '{print $27}'`
			instance_name =`grep $job_name input.txt | awk -F ' ' '{print $9}'`
			echo -ne "$instance_name"
			echo -ne "`awk -F ' ' '{print $1}' single` TERMINATED "
			if [[ $inc = "INC"* ]]
			then
				echo -e "\t\t\t $inc"
			else
				echo " "
			fi
			;;

	
		 	
		'SU')	
			job_name =`awk -F ' ' '{print $1}' single`
			inc = `grep $job_name input.txt | awk -F ' ' '{print $27}'`
			instance_name =`grep $job_name input.txt | awk -F ' ' '{print $9}'`
			echo -ne "$instance_name"
			echo -ne "`awk -F ' ' '{print $1}' single` SUCCESS "
			if [[ $inc = "INC"* ]]
			then
				echo -e "\t\t\t $inc"
			else
				echo " "
			fi
			;;	
	
		'OH')	
			job_name =`awk -F ' ' '{print $1}' single`
			inc = `grep $job_name input.txt | awk -F ' ' '{print $27}'`
			instance_name =`grep $job_name input.txt | awk -F ' ' '{print $9}'`
			echo -ne "$instance_name"
			echo -ne "`awk -F ' ' '{print $1}' single` ON_HOLD "
			if [[ $inc = "INC"* ]]
			then
				echo -e "\t\t\t $inc"
			else
				echo " "
			fi
			;;

		'AC')	
			job_name =`awk -F ' ' '{print $1}' single`
			inc = `grep $job_name input.txt | awk -F ' ' '{print $27}'`
			instance_name =`grep $job_name input.txt | awk -F ' ' '{print $9}'`
			echo -ne "$instance_name"
			echo -ne "`awk -F ' ' '{print $1}' single` ACTIVATE "
			if [[ $inc = "INC"* ]]
			then
				echo -e "\t\t\t $inc"
			else
				echo " "
			fi
			;;
	
		'IN')	
			job_name =`awk -F ' ' '{print $1}' single`
			inc = `grep $job_name input.txt | awk -F ' ' '{print $27}'`
			instance_name =`grep $job_name input.txt | awk -F ' ' '{print $9}'`
			echo -ne "$instance_name"
			echo -ne "`awk -F ' ' '{print $1}' single` INACTIVE "
			if [[ $inc = "INC"* ]]
			then
				echo -e "\t\t\t $inc"
			else
				echo " "
			fi
			;;

		'RU')	
			job_name =`awk -F ' ' '{print $1}' single`
			inc = `grep $job_name input.txt | awk -F ' ' '{print $54}'`
			instance_name =`grep $job_name input.txt | awk -F ' ' '{print $9}'`
			echo -ne "$instance_name"
			echo -ne "`awk -F ' ' '{print $1}' single` RUNNING "
			if [[ $inc = "INC"* ]]
			then
				echo -e "\t\t\t $inc"
			else
				echo " "
			fi
			;;



		'OF')	
			job_name =`awk -F ' ' '{print $1}' single`
			inc = `grep $job_name input.txt | awk -F ' ' '{print $27}'`
			instance_name =`grep $job_name input.txt | awk -F ' ' '{print $9}'`
			echo -ne "$instance_name"
			echo -ne "`awk -F ' ' '{print $1}' single` OFF_HOLD "
			if [[ $inc = "INC"* ]]
			then
				echo -e "\t\t\t $inc"
			else
				echo " "
			fi
			;;


		'OI')	
			instance_name =`grep $job_name input.txt | awk -F ' ' '{print $9}'`
			echo -ne "$instance_name"
			echo -ne "`awk -F ' ' '{print $1}' single` ON_ICE "


		'ST')	
			instance_name =`grep $job_name input.txt | awk -F ' ' '{print $9}'`
			echo -ne "$instance_name"
			echo -ne "`awk -F ' ' '{print $1}' single` STARTING "
			;;
		
		'RE')	
			instance_name =`grep $job_name input.txt | awk -F ' ' '{print $9}'`
			echo -ne "$instance_name"
			echo -ne "`awk -F ' ' '{print $1}' single` RUNNING "
			;;

		
		'QU')	
			instance_name =`grep $job_name input.txt | awk -F ' ' '{print $9}'`
			echo -ne "$instance_name"
			echo -ne "`awk -F ' ' '{print $1}' single` QUE_WAIT "
			;;

		*)	
			echo -ne "`awk -F ' ' '{print $1}' single` $b "

	esac
done

}


netcool | awk -F ' ' '{if(length($7) != 0) print $0 }' | awk -v red="$(tput setaf 1)" -v yellow="$(tput setaf 3)" -v magenta="$(tput setaf 5)" -v green="$(tput setaf 2)" -v blue="$(tput setaf 4)" -v cyan="$(tput setaf 6)" -v reset="$(tput sgr0)"
'BEGIN {
print "-------------------------------------------------------------------------------------------"
printf ("%-10s %-60s %-15s %-15s\n", "INSTANCE","	JOB NAME","STATUS","INCIDENT")
print "-------------------------------------------------------------------------------------------"
}
{
if ($3 ~ /FAILURE/) color=red;
else if ($3 ~ /SUCCESS/) color=green;
else if ($3 ~ /ON_HOLD/) color=blue;
else if ($3 ~ /RUNNING/) color=yellow;
else if ($3 ~ /TERMINATED/) color=magenta;
else if ($3 ~ /INACTIVE/) color=cyan;
else if ($3 ~ /RESTART/) color=cyan;
else color=" "
printf("%-10s %-60s %s%-15s%s %_15s\n",$1,$2,color,$3,reset,$4)
}'

echo -----------------------------------------------------------------------------------------

echo;echo

trap cleanup EXIT
