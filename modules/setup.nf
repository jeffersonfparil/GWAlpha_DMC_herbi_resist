// ///////////////////////////////////////////////////
// // SETUP THE REFERENCE GENOME AND JULIA PACKAGES //
// ///////////////////////////////////////////////////

// process GENOME_FIX {
//     label "HIGH_MEM_HIGH_CPU"
//     input:
//         val reference_genome
//     output:
//         val reference_genome
//     shell:
//     '''
//     #!/usr/bin/env bash
//     echo 'Fix the reference genome format.'
//     mv !{reference_genome} !{reference_genome}.bk
//     python3 !{projectDir}/../scripts/fix_reference_genome_format.py \
//         !{reference_genome}.bk \
//         !{reference_genome}
    
//     echo "Output:"
//     echo "  (1/2) {reference_genome}"
//     echo "  (2/2) {reference_genome}.bk"
//     '''
// }

// workflow {
//     GENOME_FIX(params.reference_genome) | \
//     (GENOME_BWA_INDEX & GENOME_SAMTOOLS_INDEX & GENOME_GATK4_INDEX)
//     JULIA_INSTALL_PACKAGES(params.dir_reads)
// }