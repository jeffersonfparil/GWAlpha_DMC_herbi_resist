////////////////////////////////////////////////////
// INDENTIFY PEAKS AND ASSOCIATED ANNOTATED GENES //
////////////////////////////////////////////////////

process MANHATTAN_PEAKS_ANNOTATION {
    label "HIGH_MEM_HIGH_CPU"
    input:
        val dir_data
        val gff
        val window_kb
        val n_main_chrom
    output:
        val 0
    shell:
    '''
    #!/usr/bin/env bash
    echo 'GWAlpha'GWAlpha
    cd !{dir_data}
    parallel -j !{task.cpus} \
        Rscript !{projectDir}/../scripts/plot_GWAlpha_output.r \
            {} \
            !{gff} \
            !{window_kb} \
            !{n_main_chrom} \
        ::: $(ls GWAlpha_*_out*.csv)
    
    echo "Output:"
    echo "  (1/2) {GWAlpha_output_name}_Manhattan.png"
    echo "  (2/2) {GWAlpha_output_name}_PEAKS.png"
    '''
}

workflow {
    MANHATTAN_PEAKS_ANNOTATION(params.dir_data,
                               params.gff,
                               params.window_kb,
                               params.n_main_chrom)
}