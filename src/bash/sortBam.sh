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

Script to sort the BAM file

<DEFINE PARAMETERS>
Parameters:
	-i [required] input BAM - name of the BAM file
	-h [optional] debug - option to print this menu option

Usage:
$0 -i {input_bam}
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
BAM_FILE=""
SAMTOOLS="/usr/local/biotools/samtools/1.3.1/samtools"
QSUB="/biotools8/biotools/soge/8.1.9b/bin/lx-amd64/qsub"
QSUB_ARGS="-q sandbox.q -l h_vmem=5G -b y -m ae -M sakai.yuta@mayo.edu -N sortBam -V -o /dlmp/sandbox/cgslIS/Yuta/logs/ -j y -wd $PWD"

##################################################
#Bash handling
##################################################

set -o errexit
set -o pipefail
set -o nounset

##################################################
#BEGIN PROCESSING
##################################################

while getopts "hi:" OPTION
do
    case $OPTION in
        h) echo "${DOCS}" ; exit ;;
        i) BAM_FILE=${OPTARG} ;;
        ?) echo "${DOCS}" ; exit ;;
    esac
done

SORTED_BAM_FILE="sorted_${BAM_FILE}"

CMD="${QSUB} ${QSUB_ARGS} ${SAMTOOLS} sort -n -o ${SORTED_BAM_FILE} ${BAM_FILE}"
echo "Executing ${CMD}"
eval ${CMD}