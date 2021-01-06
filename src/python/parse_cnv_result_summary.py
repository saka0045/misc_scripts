#!/usr/bin/python3

"""
Script to parse the resultSummary_cnvRoI.csv for select chromosome
"""

__author__ = "Yuta Sakai"

import argparse
import os


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-i", dest="input_dir", required=True,
        help="Full path to the input directory with resultSummary_cnvRoI.csv files"
    )
    parser.add_argument(
        "-o", dest="output_dir", required=True,
        help="Full path to output directory to save the resulting csv file"
    )

    args = parser.parse_args()

    input_dir = os.path.normpath(args.input_dir)
    file_list = os.listdir(input_dir)
    output_dir = os.path.normpath(args.output_dir)

    # Make result file and write out headers
    result_file = open(output_dir + "/combined_resultSummary_cnvRoI.csv", "w")
    result_file.write("Chr,exonStart,exonStop,Transcript,Size,sampleID,lg2Ratio,zScore,Event\n")

    # Open up the resultSummary_cnvRoI.csv files and parse out the results
    for file in file_list:
        print("Opening file: " + file)
        cnv_file = open(input_dir + "/" + file, "r")
        # Get header information
        header_item = cnv_file.readline().split(",")
        # Parse out each line
        for line in cnv_file:
            line = line.rstrip()
            line_item = line.split(",")
            chromosome = line_item[header_item.index("Chr")]
            if chromosome == "chr7":
                sample_name = line_item[header_item.index("sampleID")].replace(".", "-")
                line_item[header_item.index("sampleID")] = sample_name
                result_file.write(",".join(line_item) + "\n")
        cnv_file.close()

    result_file.close()
    print("Script is done running")


if __name__ == "__main__":
    main()
