#!/bin/bash 

# we use one core
#SBATCH -N 1

# within a core, 96 cores will be used
#SBATCH -n 96

# wall clock time
#SBATCH -t 119:59:59

# the type of node
#SBATCH -p genoa

# job name
#SBATCH -J pcrglobwb

#~ # mail alert at start, end and abortion of execution
#~ #SBATCH --mail-type=ALL
#~ # send mail to this address
#~ #SBATCH --mail-user=XXX@gmail.com



set -x


# configuration (.ini) file - PLEASE MODIFY THIS!
# - historical
INI_FILE="/home/edwinoxy/github/bedabauer/PCR-GLOBWB_model/config/beda_thesis/setup_05min_beda_thesis.ini"


# starting and end dates
# - historical
STARTING_DATE="1981-01-01"
END_DATE="2022-12-31"
# - PS: for continuing runs (including the transition from the historical to SSP runs), plese use the output files from previous model runs.


# location/folder, where you will store output files of your - PLEASE MODIFY THIS 
# - historical
MAIN_OUTPUT_DIR="/scratch-shared/edwinoxy/pcrglobwb_run_for_beda_thesis_test/"


# meteorological forcing files
# - already defined in the configuration file


# initial conditions
MAIN_INITIAL_STATE_FOLDER="/projects/0/dfguu/users/edwin/data/pcrglobwb_input_aqueduct/version_2021-09-16/initial_conditions/"
DATE_FOR_INITIAL_STATES="2019-12-31"
# - PS: for continuing runs (including the transition from the historical to SSP runs), plese use the output files from the previous period model runs.


# number of spinup years
NUMBER_OF_SPINUP_YEARS="25"
#~ # - PS: For continuing runs, please set it to zero
#~ NUMBER_OF_SPINUP_YEARS="0"


# location of your pcrglobwb model scripts - PLEASE MODIFY THIS
PCRGLOBWB_MODEL_SCRIPT_FOLDER="/home/edwinoxy/github/bedabauer/PCR-GLOBWB_model/model/"


# load all software, conda etc
. /home/edwin/load_all_default.sh


# unset pcraster working threads
unset PCRASTER_NR_WORKER_THREADS


# test pcraster
pcrcalc


# go to the folder that contain PCR-GLOBWB scripts
cd ${PCRGLOBWB_MODEL_SCRIPT_FOLDER}
pwd


# run the model for all clones, from 1 to 53

#~ # - for testing
#~ for i in {2..2}

# - loop through all clones
for i in {1..53}

do

CLONE_CODE=${i}
python3 deterministic_runner_with_arguments.py ${INI_FILE} debug_parallel ${CLONE_CODE} -mod ${MAIN_OUTPUT_DIR} -sd ${STARTING_DATE} -ed ${END_DATE} -misd ${MAIN_INITIAL_STATE_FOLDER} -dfis ${DATE_FOR_INITIAL_STATES} -num_of_sp_years ${NUMBER_OF_SPINUP_YEARS} &


done


# process for merging files at the global extent
python3 deterministic_runner_merging_with_arguments.py ${INI_FILE} parallel -mod ${MAIN_OUTPUT_DIR} -sd ${STARTING_DATE} -ed ${END_DATE} &


# wait until process is finished
wait


echo "end of model runs (please check your results)"

