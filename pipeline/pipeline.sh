#!/usr/bin/env bash

###Starting in /projects/team3/
mkdir genomeassembly
mkdir genomeassembly/fastqc_out
mkdir genomeassembly/trimmed_reads

#Quality Control on dataset
fastqc dataset/* --outdir genomeassembly/fastqc_out/
multiqc genomeassembly/fastqc_out/*

#Make directory for trimmed reads(not done on server yet, but I think it should be done this way)
cd trimmed_reads

#Trim reads
trimmomatic PE CGT3027_1.fq CGT3027_2.fq CGT3027_1_P.fq CGT3027__1_UP.fq CGT3027_2_P.fq CGT3027_2_UP.fq HEADCROP:40 SLIDINGWINDOW:4:15 MINLEN:100 AVGQUAL:20

cat genome_list | xargs -L2 bash -c ‘java -jar /Users/yiniyang/Desktop/BIO7210/Trimmomatic-0.38/trimmomatic-0.38.jar PE $0.fq $1.fq trimmed_reads/$0_P.fq trimmed_reads/$0_UP.fq trimmed_reads/$1_P.fq trimmed_reads/$1_UP.fq HEADCROP:40 SLIDINGWINDOW:4:15 MINLEN:100 AVGQUAL:20’

#Trim galore command
cat ../sorted_genome_list | xargs -L2 bash -c 'trim_galore --length 100 --paired --retain_unpaired --fastqc ../raw_reads/$0.fq ../raw_reads/$1.fq -q 18'

#FastQC post assembly
mkdir ../PostTrim_FastQC
cd ../PostTrim_FastQC

#Do fastqc
fastqc ../trimmed_reads/*_P.fq

#Assemble using AbySS
abyss-pe name=abyss_results/pqc_abyss k=96 in='file1.fq file2.fq'

#Assemble using unicycler
unicycler --short1 CGT3027_1.fq --short2 CGT3027_2.fq -o uni_27

#Assemble usig IDBA
idba --read CGT3018_1.fq --read_level_2 CGT3018_2.fq -o idba --mink 70


