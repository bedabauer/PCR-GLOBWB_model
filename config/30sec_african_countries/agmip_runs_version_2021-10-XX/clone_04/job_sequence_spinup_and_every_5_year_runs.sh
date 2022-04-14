#!/bin/bash

#~ # Submit the first job and save the JobID as JOBONE
#~ JOBONE=$(qsub program1.pbs)
#~ # Submit the second job, use JOBONE as depend, save JobID
#~ JOBTWO=$(qsub -W depend=afterok:$JOBONE program2.pbs)
#~ # Submit last job using JOBTWO as depend, do not need to save the JobID
#~ qsub -W depend=afterok:$JOBTWO program3.pbs

set -x


JOB_NAME="agmpc04"
INI_FILE="setup_30sec_agmip_clone_04_version_2021-10-20.ini"

# - using Edwinś output folder
GENERAL_MAIN_OUTPUT_DIR="/rds/general/user/esutanud/projects/arise/live/HydroModelling/edwin/pcrglobwb_output_africa_agmip/version_2021-10-XX/clone_04_30sec/"

#~ # - using Jannis output folder
#~ GENERAL_MAIN_OUTPUT_DIR="/rds/general/user/esutanud/projects/arise/live/HydroModelling/jhoch/pcrglobwb_output_africa_agmip/version_2021-10-XX/clone_04_30sec/"


STARTING_YEAR=1981
END_YEAR=2019


# initial conditions
MAIN_INITIAL_STATE_FOLDER="/rds/general/user/esutanud/projects/arise/live/HydroModelling/edwin/pcrglobwb_output_africa/version_2021-05-31/africa_05min/africa_accutraveltime/states/"
DATE_FOR_INITIAL_STATES="1981-12-31"


# spinup 1st - 5 years - get the average recharge

SUB_JOBNAME=${JOB_NAME}_spinup_get_rch
MAIN_OUTPUT_DIR=${GENERAL_MAIN_OUTPUT_DIR}/_spinup/0_get_avg_rch/with_${STARTING_YEAR}/
STARTING_DATE=${STARTING_YEAR}-01-01
END_DATE=${STARTING_YEAR}-12-31
NUMBER_OF_SPINUP_YEARS="5"
USE_MAXIMUM_STOR_GROUNDWATER_FOSSIL_INI="True"
ESTIMATE_STOR_GROUNDWATER_INI_FROM_RECHARGE="False"
DAILY_GROUNDWATER_RECHARGE_INI="NONE"

sleep 0.1

SPIN_UP_FIRST=$(qsub -N "${SUB_JOBNAME}" -v INI_FILE="${INI_FILE}",MAIN_OUTPUT_DIR="${MAIN_OUTPUT_DIR}",STARTING_DATE="${STARTING_DATE}",END_DATE="${END_DATE}",MAIN_INITIAL_STATE_FOLDER="${MAIN_INITIAL_STATE_FOLDER}",DATE_FOR_INITIAL_STATES="${DATE_FOR_INITIAL_STATES}",NUMBER_OF_SPINUP_YEARS="${NUMBER_OF_SPINUP_YEARS}",USE_MAXIMUM_STOR_GROUNDWATER_FOSSIL_INI=${USE_MAXIMUM_STOR_GROUNDWATER_FOSSIL_INI},ESTIMATE_STOR_GROUNDWATER_INI_FROM_RECHARGE=${ESTIMATE_STOR_GROUNDWATER_INI_FROM_RECHARGE},DAILY_GROUNDWATER_RECHARGE_INI=${DAILY_GROUNDWATER_RECHARGE_INI} pbs_job_script_for_a_clone_run.sh)

#~ # - a dummy job (for skipping it, but keep the dependency for the next one)
#~ SPIN_UP_FIRST=$(qsub -N "${SUB_JOBNAME}" -v INI_FILE="${INI_FILE}",MAIN_OUTPUT_DIR="${MAIN_OUTPUT_DIR}",STARTING_DATE="${STARTING_DATE}",END_DATE="${END_DATE}",MAIN_INITIAL_STATE_FOLDER="${MAIN_INITIAL_STATE_FOLDER}",DATE_FOR_INITIAL_STATES="${DATE_FOR_INITIAL_STATES}",NUMBER_OF_SPINUP_YEARS="${NUMBER_OF_SPINUP_YEARS}",USE_MAXIMUM_STOR_GROUNDWATER_FOSSIL_INI=${USE_MAXIMUM_STOR_GROUNDWATER_FOSSIL_INI},ESTIMATE_STOR_GROUNDWATER_INI_FROM_RECHARGE=${ESTIMATE_STOR_GROUNDWATER_INI_FROM_RECHARGE},DAILY_GROUNDWATER_RECHARGE_INI=${DAILY_GROUNDWATER_RECHARGE_INI} pbs_job_script_for_a_clone_run_dummy.sh)

# save and use the following variables for the next run/job
PREVIOUS_JOB=${SPIN_UP_FIRST}
PREVIOUS_OUTPUT_DIR=${MAIN_OUTPUT_DIR}
MAIN_INITIAL_STATE_FOLDER=${PREVIOUS_OUTPUT_DIR}/states/
DATE_FOR_INITIAL_STATES=${END_DATE}


# spinup 2nd - 5 years - use the average recharge

SUB_JOBNAME=${JOB_NAME}_spinup_use_rch
MAIN_OUTPUT_DIR=${GENERAL_MAIN_OUTPUT_DIR}/_spinup/0_use_avg_rch/with_${STARTING_YEAR}/
STARTING_DATE=${STARTING_YEAR}-01-01
END_DATE=${STARTING_YEAR}-12-31
NUMBER_OF_SPINUP_YEARS="5"
USE_MAXIMUM_STOR_GROUNDWATER_FOSSIL_INI="True"
ESTIMATE_STOR_GROUNDWATER_INI_FROM_RECHARGE="True"
DAILY_GROUNDWATER_RECHARGE_INI=${PREVIOUS_OUTPUT_DIR}/netcdf/gwRecharge_annuaAvg_output.nc


sleep 0.1

SPIN_UP=$(qsub -N "${SUB_JOBNAME}" -W depend=afterany:${PREVIOUS_JOB} -v INI_FILE="${INI_FILE}",MAIN_OUTPUT_DIR="${MAIN_OUTPUT_DIR}",STARTING_DATE="${STARTING_DATE}",END_DATE="${END_DATE}",MAIN_INITIAL_STATE_FOLDER="${MAIN_INITIAL_STATE_FOLDER}",DATE_FOR_INITIAL_STATES="${DATE_FOR_INITIAL_STATES}",NUMBER_OF_SPINUP_YEARS="${NUMBER_OF_SPINUP_YEARS}",USE_MAXIMUM_STOR_GROUNDWATER_FOSSIL_INI=${USE_MAXIMUM_STOR_GROUNDWATER_FOSSIL_INI},ESTIMATE_STOR_GROUNDWATER_INI_FROM_RECHARGE=${ESTIMATE_STOR_GROUNDWATER_INI_FROM_RECHARGE},DAILY_GROUNDWATER_RECHARGE_INI=${DAILY_GROUNDWATER_RECHARGE_INI} pbs_job_script_for_a_clone_run.sh)

# save and use the following variables for the next run/job
PREVIOUS_JOB=${SPIN_UP}
PREVIOUS_OUTPUT_DIR=${MAIN_OUTPUT_DIR}
MAIN_INITIAL_STATE_FOLDER=${PREVIOUS_OUTPUT_DIR}/states/
DATE_FOR_INITIAL_STATES=${END_DATE}



# repeat spinup runs
NUMOFSUBSPINUPRUNS=5
NUMBER_OF_SPINUP_YEARS="5"

for i in $( eval echo {1..$NUMOFSUBSPINUPRUNS} )

do

SUB_JOBNAME=${JOB_NAME}_spinup_${i}
MAIN_OUTPUT_DIR=${GENERAL_MAIN_OUTPUT_DIR}/_spinup/${i}/with_${STARTING_YEAR}/
STARTING_DATE=${STARTING_YEAR}-01-01
END_DATE=${STARTING_YEAR}-12-31
USE_MAXIMUM_STOR_GROUNDWATER_FOSSIL_INI="True"
ESTIMATE_STOR_GROUNDWATER_INI_FROM_RECHARGE="False"
DAILY_GROUNDWATER_RECHARGE_INI="NONE"

sleep 0.1

SPIN_UP=$(qsub -N "${SUB_JOBNAME}" -W depend=afterany:${PREVIOUS_JOB} -v INI_FILE="${INI_FILE}",MAIN_OUTPUT_DIR="${MAIN_OUTPUT_DIR}",STARTING_DATE="${STARTING_DATE}",END_DATE="${END_DATE}",MAIN_INITIAL_STATE_FOLDER="${MAIN_INITIAL_STATE_FOLDER}",DATE_FOR_INITIAL_STATES="${DATE_FOR_INITIAL_STATES}",NUMBER_OF_SPINUP_YEARS="${NUMBER_OF_SPINUP_YEARS}",USE_MAXIMUM_STOR_GROUNDWATER_FOSSIL_INI=${USE_MAXIMUM_STOR_GROUNDWATER_FOSSIL_INI},ESTIMATE_STOR_GROUNDWATER_INI_FROM_RECHARGE=${ESTIMATE_STOR_GROUNDWATER_INI_FROM_RECHARGE},DAILY_GROUNDWATER_RECHARGE_INI=${DAILY_GROUNDWATER_RECHARGE_INI} pbs_job_script_for_a_clone_run.sh)

# save and use the following variables for the next run/job
PREVIOUS_JOB=${SPIN_UP}
PREVIOUS_OUTPUT_DIR=${MAIN_OUTPUT_DIR}
MAIN_INITIAL_STATE_FOLDER=${PREVIOUS_OUTPUT_DIR}/states/
DATE_FOR_INITIAL_STATES=${END_DATE}


done 


# actual runs after spinup

# number of years
let NUMOFYEARS=${END_YEAR}-${STARTING_YEAR}+1

#~ # we will run for every 3-year period
#~ let NUMOFSUBRUNS=${NUMOFYEARS}/3

#~ # we will run for every 10-year period ; NUMOFSUBRUNS = (2019-1981+1) / 10 = 4
#~ let NUMOFSUBRUNS=4

# we will run for every 5-year period ; 
let NUMOFSUBRUNS=8

# the run for every period
for i in $( eval echo {1..$NUMOFSUBRUNS} )

do

NUMBER_OF_SPINUP_YEARS="0"

ESTIMATE_STOR_GROUNDWATER_INI_FROM_RECHARGE="False"
DAILY_GROUNDWATER_RECHARGE_INI="NONE"

USE_MAXIMUM_STOR_GROUNDWATER_FOSSIL_INI="False"
# for the first year, you start with USE_MAXIMUM_STOR_GROUNDWATER_FOSSIL_INI
if [ ${i} -eq 1 ]
then
USE_MAXIMUM_STOR_GROUNDWATER_FOSSIL_INI="True"
fi

#~ # every 10 year period
#~ let STAYEAR=${STARTING_YEAR}+${i}*10-10
#~ let ENDYEAR=${STAYEAR}+10-1

# every 5 year period
let STAYEAR=${STARTING_YEAR}+${i}*5-5
let ENDYEAR=${STAYEAR}+5-1

if [ ${ENDYEAR} -gt 2019 ]
then
let ENDYEAR=2019
fi

SUB_JOBNAME=${JOB_NAME}_${STAYEAR}-${ENDYEAR}
MAIN_OUTPUT_DIR=${GENERAL_MAIN_OUTPUT_DIR}/${STAYEAR}-${ENDYEAR}/
STARTING_DATE=${STAYEAR}-01-01
END_DATE=${ENDYEAR}-12-31

sleep 0.1

CURRENT_JOB=$(qsub -N "${SUB_JOBNAME}" -W depend=afterany:${PREVIOUS_JOB} -v INI_FILE="${INI_FILE}",MAIN_OUTPUT_DIR="${MAIN_OUTPUT_DIR}",STARTING_DATE="${STARTING_DATE}",END_DATE="${END_DATE}",MAIN_INITIAL_STATE_FOLDER="${MAIN_INITIAL_STATE_FOLDER}",DATE_FOR_INITIAL_STATES="${DATE_FOR_INITIAL_STATES}",NUMBER_OF_SPINUP_YEARS=${NUMBER_OF_SPINUP_YEARS},USE_MAXIMUM_STOR_GROUNDWATER_FOSSIL_INI=${USE_MAXIMUM_STOR_GROUNDWATER_FOSSIL_INI},ESTIMATE_STOR_GROUNDWATER_INI_FROM_RECHARGE=${ESTIMATE_STOR_GROUNDWATER_INI_FROM_RECHARGE},DAILY_GROUNDWATER_RECHARGE_INI=${DAILY_GROUNDWATER_RECHARGE_INI}  pbs_job_script_for_a_clone_run.sh)

# save and use the following variables for the next run/job
PREVIOUS_JOB=${CURRENT_JOB}
MAIN_INITIAL_STATE_FOLDER=${MAIN_OUTPUT_DIR}/states/
DATE_FOR_INITIAL_STATES=${END_DATE}

done


set +x
