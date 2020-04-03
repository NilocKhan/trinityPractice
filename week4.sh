#! /bin/bash

#download fastq files
nohup fastq-dump --gzip --split-files SRR8655916

#check raw read quality with fastqc
/opt/FastQC/fastqc SRR8655916_1.fastq.gz SRR8655916_1.fastq.gz

#use Trimmomatic to clean reads
java -jar /opt/Trimmomatic-0.38/trimmomatic \
	PE \
	-phred33 \
	-threads 6 \
	SRR8655916_1.fastq.gz \
	SRR8655916_2.fastq.gz \
	clean_1.fastq.gz \
	unp_1.fastq.gz \
	clean_2.fastq.gz \
	unp_2.fastq.gz \
	ILLUMINACLIP:/opt/Trimmomatic-0.38/adapters/allAdapter.fas:2:30:10 \
	LEADING:30 \
	TRAILING:30 \
	HEADCROP:5 \
	SLIDINGWINDOW:5:30 \
	MINLEN:50 \

#check clean reads quality with fastqc
/opt/FastQC/fastqc clean_1.fasta.gz clean_2.fas.gz

#use Trinity to assemble transcripts
/opt/trinity/Trinity --seqType fq --max_memory 50G --left clean_1.fastq.gz --right clean_2.fastq.gz --CPU 6 --SS_lib_type RF
