#!/bin/bash

get_input () {
    # Function to parse arguments
    # Specifying usage message
    usage="Usage: sh pipeline.bash -i <input directory> -o <output directory> -e <conda env name> -[OPTIONS]
              Bacterial short reads genome assembly software. The options available are:
                        -i : Directory for genome sequences [required]
                        -o : Output directory [required]
                        -e : Conda environment name [required]
                        -a : Assembler name (spades/skesa, default is both:spades,skesa)
                        -q : Flag to perform quality analysis of assembly using Quast
                        -m : Flag to perform quality analysis of reads using FastQC+MultiQC
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
        while getopts "i:o:a:e:zqmk:vh" option; do
                case $option in
                        i) input_directory=$OPTARG;;
                        o) output_directory=$OPTARG;;
                        e) env_name=$OPTARG;;
                        a) assembler=$OPTARG;;
                        z) z=1;;
                        q) quast=1;;
                        m) multiqc=1;;
                        k) kmer_length=1;;
			t) trimming==1;;
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
	if [ -d $output_directory ]
        then
		echo "Output directory already exists, would you like to overwrite? Reply with y/n"
		read answer
		case $answer in
			y) echo "Overwriting folder $output in subsequent steps";;
			n) echo "Folder overwrite denied, exiting SNP pipeline"
				exit 1;;
			\?) echo "Incorrect option specified, exiting SNP pipeline"
				exit 1;;
		esac
	fi



}


      prepare_temp(){
      if  [ "$v" == 1 ]
      then
	    echo "Preparing temp directory"
      fi
      mkdir -p temp
      mkdir -p results
      }

perform_trimming()
{ 
	echo "Trimming with trimmomatic"
	mkdir -p temp/trim
	for k in $(ls $i)
        do
		R=${k%_*}
                E=${k#*.}
		f=$R"_1."$E
		if [ $(find temp/trim -name '$f' | wc -l) -eq 0 ];then
		file1=$R"_1."$E
		file2=$R"_2."$E		
		file3=$R"_1UP."$E
		file4=$R"_2UP."$E
		file5=$R"_UP."$E
		trimmomatic PE $i/$file1 $i/$file2 temp/trim/$file1 temp/trim/$file3 temp/trim/$file2 temp/trim/$file4 SLIDINGWINDOW:12:18 MINLEN:100 AVGQUAL:18
		cat temp/trim/$file3 temp/trim/$file4 > temp/trim/$file5
	rm temp/trim/$file3
	rm temp/trim/$file4
fi
done
}		
	     
      spades_assembly(){
      echo "Spades assembly"
      mkdir -p temp/spades
	if [ trimming==1 ];
	then
		dir="temp/trim"
	#else 
	#	dir=$i
	#fi

        for k in $(ls $dir)
        do
		R=${k%_*}
                E=${k#*.}
                f="$R""_spades.fa"
                if [ $(find temp/spades/ -name '$f' | wc -l) -eq 0 ];then
                file1=$dir"/"$R"_1."$E
                file2=$dir"/"$R"_2."$E
		file3=$dir"/"$R"_UP."$E	
		#echo "$file1"
		#echo $file1
		#echo "$file2"
		#echo $file2
		#/projects/home/sac8/miniconda2/envs/g_3/bin/spades.py 
                spades.py -1 $file1 -2 $file2 -s $file3 ----careful --cov-cutoff auto -o temp/spades
                #skesa --fastq $file1,$file2 --contigs_out temp/skesa/$f
		
        fi
        done
	else
                $i
		######add spades function old one####
	        

fi


        mv temp/spades/  results/
        }

      quality_analysis(){
      echo “Quast: Quality Assessment Tool for Genome Assemblies”
      mkdir -p temp/quast
      if [ "$assembler" as "skesa" ]
        then
        echo "skesa"
      fi

      
      }



quality_control(){
        #input directory i
        #output is created in the fastqc_output 
        echo "quality control function here"
	mkdir temp/fastqc_output
	fastqc $i/* -o temp/fastqc_output
        #input fastqc_output folder
        #output generated in multiqc_output folder
	multiqc temp/fastqc_output/*.zip -o temp/multiqc_output
}

skesa_assembly(){
	echo "Skesa: assembly function here"
	mkdir -p temp/skesa
	if [ trimming==1 ];
        then
                dir="temp/trim"
        else
                dir=$i
        fi

        #for k in $(ls $dir)
        #do

	for k in $(ls $dir)
        do
		R=${k%_*}
                E=${k#*.}
		f="$R""_skesa.fa"
		if [ $(find temp/skesa/ -name '$f' | wc -l) -eq 0 ];then
		file1=$i"/"$R"_1."$E
		file2=$i"/"$R"_2."$E
                skesa --fastq $file1,$file2 --contigs_out temp/skesa/$f
	fi        
	done
	mv temp/skesa results/
        }




main() {
	# Function that defines the order in which functions will be called

	get_input "$@"
	#i = "/projects/team3/genomeassembly/Mani/new-dir/running-skesa-gz/subset-testing"

if [ "$trimming" == 1 ]
then
 	echo "performing trimming..."
	perform_trim $i
fi  
  
if  [ "$v" == 1 ]
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

  if [ "$multiqc" == 1 ]
  then
    if [ "$v" == 1 ]
    then
            echo "Quality analysis of reads intiated..."
    fi
    quality_control $i
    if [ "$v" == 1 ]
    then
            echo "Quality analysis of reads completed..."
    fi
  fi


  if [ "$assembler" == "spades" ]
  then
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

  if [ "$assembler" == "skesa" ]
  then
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

  if [ "$quast" == 1 ]
  then
    if [ "$v" == 1 ]
    then
            echo "Quality analysis of assemblies initiated.."
    fi
    ##quality_analysis
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

