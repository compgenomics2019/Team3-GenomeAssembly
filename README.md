# Team3-GenomeAssembly: Bacteria genome ASSembily (BASS) ><((('>

This pipeline is meant to assemble paired-end bacterial genomes that have short reads. The pipeline uses both SPADES (slow) and SKESA (fast) to assemble your genomes. We take in a directory of genome sequences, and output directory, whether you want quality anaysis or not, and preferred kmer sizes. [Check out our wiki page](https://compgenomics2019.biosci.gatech.edu/Team_III_Genome_Assembly_Group)

## Installing

This pipeline uses as conda based environment to ensure you have the appropriate dependencies. We recommend that you download and install Miniconda from https://conda.io/en/latest/miniconda.html 

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

Next create and activate a conda environment from the yml files provided in the lib directory.

```
### FOR LINUX ###
cd Team3-GenomeAssembly/
conda env create -f lib/bass_linux.yml -n your_env_name
source activate your_env_name

### FOR MAC ###
cd Team3-GenomeAssembly/
conda env create -f lib/bass_OS.yml -n your_env_name
source activate your_env_name
```

If you decline to create an environment with Miniconda, you will be responsible for your own dependencies for the following:
- [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)
- [MultiQC](https://multiqc.info/)
- [SPAdes](http://cab.spbu.ru/software/spades/)
- [ABYSS](http://www.bcgsc.ca/platform/bioinfo/software/abyss)
- [SKESA](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-018-1540-z)
- [Bowtie(dependency of lib/SSpace_basic)](http://bowtie-bio.sourceforge.net/index.shtml)
- [QUAST](http://quast.sourceforge.net/quast)


## Running 

### Prepping your data

Your forward and reverse reads for your genomes should be in an input folder alone. See example_data/ as a reference below:

```
Team3-GenomeAssembly/
   example_data/
      CGT3662_1.fq.gz
      CGT3662_2.fq.gz
```

### For Help...

Having trouble at any time running our pipeline? Feel free to try the following command within Team3-GenomeAssembly/

```
./pipeline.sh -h
```

and you will have the following printed:

```
Usage: sh pipeline.bash -i <input directory> -o <output directory> -[OPTIONS]
              Bacterial short reads genome assembly software. The options available are:
                        -i : Directory for genome sequences [required]
                        -o : Output directory [required]
                        -f : For fast assembly (uses skesa)
                        -q : Flag to perform quality analysis of assembly using Quast
                        -m : Flag to perform quality analysis of reads using FastQC+MultiQC
                        -k : Kmer range for spades (default=99,105,107,115)
                        -v : Flag to turn on verbose mode
                        -h : Print usage instructions
```

### Running example_data

For an example, we can assembly our example_data/ using SPAdes with kmer size 99 and 103 and produce a quast report using the following command within the Team3-GenomeAssembly/ directory:

```
./pipeline.sh -i example_data/ -o example_out -q -k 99, 103
```

