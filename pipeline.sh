#!/bin/bash

get_input () {
    # Function to parse arguments
    # Specifying usage message
    usage="Usage: bash pipeline.bash -i <input directory> -o <output directory> -e <conda env name> -[OPTIONS]
              Bacterial short reads genome assembly software. The options available are:
                        -i : Directory for genome sequences [required]
                        -o : Location of second reads file [required]
                        -e : Conda environment name [required]
                        -a : Assembler name (spades/skesa, default is both:spades,skesa)
                        -q : Flag to perform quality analysis of assembly using Quast
                        -m : Flag to perform quality analysis of reads using FastQC+MultiQC
                        -t : Temp directory name (default=temp)
                        -k : Kmer size (default=103)
                        -v : Flag to turn on verbose mode
                        -h : Print usage instructions"
  #Specifying deafult Arguments
  a="skesa,spades"
  quast=0
  multiqc=0
  temp_directory="temp"
  kmer_length=103
  v=0
  z=0
    #Getopts block, will take in the arguments as inputs and assign them to variables
        while getopts "i:o:a:e:zqmtk:vh" option; do
                case $option in
                        i) input_directory=$OPTARG;;
                        o) output_directory=$OPTARG;;
                        e) env_name=$OPTARG;;
                        a) assembler=$OPTARG;;
                        z) z=1;;
                        q) quast=1;;
                        m) multiqc=1;;
                        t) temp_directory=$OPTARG;;
                        k) kmer_length=1;;
                        v) v=1;;
                              h) echo "$usage"
                                    exit 0;;
                             \?) echo "Invalid option."
                                "$usage"
                                         exit 1;;
                esac
        done

  #Check for presence of required arguments
  if [ ! "$input_directory" ] || [ ! "$output_directory" ] || [ ! "$env_name" ]
  then
    echo "ERROR: Required arguments missing!"
    echo "$usage"
    exit 1
  fi

  #Check if i is a directory

  if [ ! -d $input_directory ]
  then echo "ERROR: Not a valid directory"
  echo "$usage"
  exit 1
  fi

  #Check if output file is already present, give option to rewrite.
	if [ -f $output_directory ]
        then
		echo "Output directory already exists, would you like to overwrite? Reply with y/n"
		read answer
		case $answer in
			y) echo "Overwriting file $output n subsequent steps";;
			n) echo "File overwrite denied, exiting SNP pipeline"
				exit 1;;
			\?) echo "Incorrect option specified, exiting SNP pipeline"
				exit 1;;
		esac
	fi



}

main() {
	# Function that defines the order in which functions will be called

	get_input "$@"
  if [ "$v" == 1 ]
  then
          echo "Parsed input arguments..."
  fi

  if [ "$v" == 1 ]
  then
          echo "Preparing temp_directory..."
  fi

	prepare_temp
  if [ "$v" == 1 ]
  then
          echo "Temp directory created"
  fi
  if [ "$multiqc" == 1 ] then do
    if [ "$v" == 1 ]
    then
            echo "Quality analysis of reads intiated..."
    fi
    quality_control
    if [ "$v" == 1 ]
    then
            echo "Quality analysis of reads completed..."
    fi
  fi

	if [ "$assembler" =~ "spades" ] then do
    if [ "$v" == 1 ]
    then
            echo "SPAdes assemblies intiated..."
    fi
    spades_assembly
    if [ "$v" == 1 ]
    then
            echo "SPAdes assemblies completed..."
    fi

  fi
  if [ "$assembler" =~ "skesa"] then do
    if [ "$v" == 1 ]
    then
            echo "SKESA assemblies intiated..."
    fi
    skesa_assembly
    if [ "$v" == 1 ]
    then
            echo "SKESA assemblies completed..."
    fi
  fi

  if [ "$quast" == 1 ] then do
    if [ "$v" == 1 ]
    then
            echo "Quality analysis of assemblies initiated.."
    fi
    quality_analysis
    if [ "$v" == 1 ]
    then
            echo "Quality analysis of assemblies completed.."
    fi
	fi

  if [ "$v" == 1 ]
  then
          echo "Assembly pipeline complete!"
  fi

	#rm -r temp
}

# Calling the main function
main "$@"
