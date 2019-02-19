# Team3-GenomeAssembly: Bacteria genome ASSembily (BASS)

This pipeline is meant to assemble paired-end bacterial genomes that have short 
reads. The pipeline uses both SPADES and SKESA to assemble your genomes. We take
 in a directory of genome sequences, trimming parameters, whether you want FastQ
C and MultiQC reports, and preferred kmer size.

## Installing

This pipeline uses as conda based environment to ensure you have the appropriate
 dependencies. We recommend that you download and in stall Miniconda from https:
//conda.io/en/latest/miniconda.html 

Example for installing Miniconda for Linux :

```
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
./Miniconda3-latest-Linux-x86_64.sh
rm  Miniconda3-latest-Linux-x86_64.sh
```

Next to clone the repository into your current directory (http version):

```
git clone  https://github.gatech.edu/compgenomics2019/Team3-GenomeAssembly.git
```

If you need the ssh version:

```
git clone git@github.gatech.edu:compgenomics2019/Team3-GenomeAssembly.git
```

Next create and activate a conda environment  from the yml file provides in the 
lib directory. Multiqc clashes with the yml file and you will need to pip instal
l after activating your environment.

```
cd Team3-GenomeAssembly/
conda env create -f lib/lassie.yml -n your_env_name
source activate your_env_name
```

If you decline to create an environment with Miniconda, you will be responsible 
for your own dependencies including the following:
- [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)
- [MultiQC](https://multiqc.info/)
- [SPAdes](http://cab.spbu.ru/software/spades/)
- [ABYSS](http://www.bcgsc.ca/platform/bioinfo/software/abyss)
- [SKESA](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-018-15
40-z)
- [Bowtie(dependency of lib/SSpace_basic)](http://bowtie-bio.sourceforge.net/ind
ex.shtml)
- [QUAST](http://quast.sourceforge.net/quast)


## Running 

### Prepping your data

Your forward and reverse reads for your genomes should be in an input folder alo
ne. See example_data/ as a reference below:

```
Team3-GenomeAssembly/
   example_data/
      CGT3826_1.fq.gz
      CGT3826_2.fq.gz
```

### For Help...

Having trouble at any time running our pipeline? Feel free to try inside Team3-G
enomeAssembly/:

```
./pipeline -f
```

and you will have the following printed:

```
Usage: sh pipeline.bash -i <input directory> -o <output directory> -[OPTIONS]
              Bacterial short reads genome assembly software. The options availa
ble are:
                        -i : Directory for genome sequences [required]
                        -o : Output directory [required]
                        -a : Option for selecting Assembler (spades/skesa, defau
lt is both:spades,skesa)
                        -q : Flag to perform quality analysis of assembly using 
Quast
                        -m : Flag to perform quality analysis of reads using Fas
tQC+MultiQC
                        -k : Kmer size (default=103)
                        -v : Flag to turn on verbose mode
                        -h : Print usage instructions
```
