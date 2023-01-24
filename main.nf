#!/usr/bin/env nextflow

/*mamba create -n modbam2bed -c bioconda -c conda-forge -c epi2melabs modbam2bed
*modbam2bed [OPTION...] <reference.fasta> <reads.bam>  
*/

/*
 * The following pipeline parameters specify the reference genomes
 * and read pairs and can be provided as command line options
*/ 
params.reads = "data/bonito_10k.bam"
params.bai = "data/bonito_10k.bam.bai"
params.reference = "data/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna"
params.outdir = "results"
 
workflow {
    def reads_ch = Channel.fromPath(params.reads, checkIfExists: true )
    def bai_ch = Channel.fromPath(params.bai, checkIfExists: true )
    def ref_ch = Channel.fromPath(params.reference, checkIfExists: true )
    MODBAM2BED(ref_ch, reads_ch, bai_ch)
}
 
process MODBAM2BED {
    conda 'envs/modbam2bed.yml'
    publishDir params.outdir
 
    input:
    path reference
    path reads
    path bai
 
    output:
    path "modbam.bed"
 
    script:
    """
    modbam2bed $reference $reads > "modbam.bed"
    """
}
