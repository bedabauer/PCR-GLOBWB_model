#!/bin/bash 
#PBS -N pgb-set5
#PBS -q nf
#PBS -l EC_total_tasks=15
#PBS -l EC_hyperthreads=2
#PBS -l EC_memory_per_task=4GB
#PBS -l EC_billing_account=c3s432l3
#PBS -l walltime=48:00:00

#PBS -v INI_FILE="test.ini",MAIN_OUTPUT_DIR="/scratch/ms/copext/cyes/tmp_pbs_edwin/"

#PBS -M hsutanudjajacchms99@yahoo.com

# load modules, etc 
#
#~ # - using conda (NOT RECOMMENDED)
#~ . /home/ms/copext/cyes/load_miniconda_pcrglobwb-py3-env_pcraster430.sh
#
# - using modules on cca
module load python3/3.6.10-01
module load pcraster/4.3.0
module load gdal/3.0.4

# go to the folder that contain PCR-GLOBWB scripts
cd /home/ms/copext/cyes/github/edwinkost/PCR-GLOBWB_model_edwin-private-development/model/

#~ INI_FILE="/home/ms/copext/cyes/github/edwinkost/PCR-GLOBWB_model_edwin-private-development/config/ulysses/version_2020-08-14/setup_6arcmin_test_version_2020-08-14.ini"
#~ MAIN_OUTPUT_DIR="/scratch/ms/copext/cyes/pcrglobwb_output_version_2020-08-14/"

# run the model for every clone
python3 deterministic_runner_parallel_for_ulysses.py ${INI_FILE} debug_parallel 15 -mod ${MAIN_OUTPUT_DIR} &
python3 deterministic_runner_parallel_for_ulysses.py ${INI_FILE} debug_parallel 32 -mod ${MAIN_OUTPUT_DIR} &
python3 deterministic_runner_parallel_for_ulysses.py ${INI_FILE} debug_parallel 37 -mod ${MAIN_OUTPUT_DIR} &
python3 deterministic_runner_parallel_for_ulysses.py ${INI_FILE} debug_parallel 41 -mod ${MAIN_OUTPUT_DIR} &
python3 deterministic_runner_parallel_for_ulysses.py ${INI_FILE} debug_parallel 42 -mod ${MAIN_OUTPUT_DIR} &
python3 deterministic_runner_parallel_for_ulysses.py ${INI_FILE} debug_parallel 48 -mod ${MAIN_OUTPUT_DIR} &
python3 deterministic_runner_parallel_for_ulysses.py ${INI_FILE} debug_parallel 50 -mod ${MAIN_OUTPUT_DIR} &
python3 deterministic_runner_parallel_for_ulysses.py ${INI_FILE} debug_parallel 51 -mod ${MAIN_OUTPUT_DIR} &
python3 deterministic_runner_parallel_for_ulysses.py ${INI_FILE} debug_parallel 52 -mod ${MAIN_OUTPUT_DIR} &
python3 deterministic_runner_parallel_for_ulysses.py ${INI_FILE} debug_parallel 53 -mod ${MAIN_OUTPUT_DIR} &
python3 deterministic_runner_parallel_for_ulysses.py ${INI_FILE} debug_parallel 54 -mod ${MAIN_OUTPUT_DIR} &

wait

