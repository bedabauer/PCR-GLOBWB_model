#!/bin/bash 

set -x 

INI_FILE="/home/ms/copext/cyes/github/edwinkost/PCR-GLOBWB_model_edwin-private-development/config/ulysses/version_2020-08-14/continue_from_1996/setup_6arcmin_test_version_2020-08-14_continue_from_1996.ini"
MAIN_OUTPUT_DIR="/scratch/ms/copext/cyes/pcrglobwb_output_version_2020-08-14/continue_from_1996/"

qsub -v INI_FILE=${INI_FILE},MAIN_OUTPUT_DIR=${MAIN_OUTPUT_DIR} pbs_parallel_set_1.sh
qsub -v INI_FILE=${INI_FILE},MAIN_OUTPUT_DIR=${MAIN_OUTPUT_DIR} pbs_parallel_set_2.sh
qsub -v INI_FILE=${INI_FILE},MAIN_OUTPUT_DIR=${MAIN_OUTPUT_DIR} pbs_parallel_set_3.sh
qsub -v INI_FILE=${INI_FILE},MAIN_OUTPUT_DIR=${MAIN_OUTPUT_DIR} pbs_parallel_set_4.sh
qsub -v INI_FILE=${INI_FILE},MAIN_OUTPUT_DIR=${MAIN_OUTPUT_DIR} pbs_parallel_set_5.sh

#~ # -for test only
#~ qsub -v INI_FILE=${INI_FILE},MAIN_OUTPUT_DIR=${MAIN_OUTPUT_DIR} pbs_parallel_set_test.sh 

set +x
