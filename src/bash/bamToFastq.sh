#!/bin/bash

##################################################
# MANIFEST
##################################################

read -r -d '' MANIFEST <<MANIFEST
*******************************************
`readlink -m $0` ${@}
was called by: `whoami` on `date`
*******************************************
MANIFEST
echo "${MANIFEST}"

read -r -d '' DOCS <<DOCS

Script to convert BAM to FASTQ

<DEFINE PARAMETERS>
Parameters:
	-i [required] input sorted BAM - name of the sorted BAM file
	-o [required] output file name prefix - {sample_name}_L00#
	-h [optional] debug - option to print this menu option

Usage:
$0 -i {input_bam} -o {output_prefix}
DOCS

#Show help when no parameters are provided
if [ $# -eq 0 ];
then
    echo "${DOCS}" ; exit 1 ;
fi

##################################################
#GLOBAL VARIABLES
##################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_FILE="${SCRIPT_DIR}/$(basename "${BASH_SOURCE[0]}")"
SCRIPT_NAME="$(basename ${0})"
ROOT="$(cd "${SCRIPT_DIR}/../../" && pwd)"
BAM_TO_FASTQ="/usr/local/biotools/bedtools/2.29.1/bin/bamToFastq"
BAM_FILE=""
QSUB="/biotools8/biotools/soge/8.1.9b/bin/lx-amd64/qsub"
QSUB_ARGS="-q sandbox.q -l h_vmem=5G -b y -m ae -M sakai.yuta@mayo.edu -V -o /dlmp/sandbox/cgslIS/Yuta/logs/ -j y -wd $PWD"

##################################################
#Bash handling
##################################################

set -o errexit
set -o pipefail
set -o nounset

##################################################
#BEGIN PROCESSING
##################################################

while getopts "hi:o:" OPTION
do
    case $OPTION in
        h) echo "${DOCS}" ; exit ;;
        i) BAM_FILE=${OPTARG} ;;
        o) SAMPLE_PREFIX=${OPTARG} ;;
        ?) echo "${DOCS}" ; exit ;;
    esac
done

READ1_FASTQ="${SAMPLE_PREFIX}_R1_001.fastq"
READ2_FASTQ="${SAMPLE_PREFIX}_R2_001.fastq"

CMD="${QSUB} ${QSUB_ARGS} ${BAM_TO_FASTQ} -i ${BAM_FILE} -fq ${READ1_FASTQ} -fq2 ${READ2_FASTQ}"
echo "Executing ${CMD}"
eval ${CMD}