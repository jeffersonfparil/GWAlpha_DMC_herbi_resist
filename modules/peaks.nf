////////////////////////////////////////////////////
// INDENTIFY PEAKS AND ASSOCIATED ANNOTATED GENES //
////////////////////////////////////////////////////

process MANHATTAN_PEAKS_ANNOTATION {
    label "HIGH_MEM_HIGH_CPU"
    publishDir params.dir_data, mode: 'symlink', overwrite: true
    input:
        path dir_data
        path gff
        val window_kb
        val n_main_chrom
        path gwalpha_output
    output:
        path "GWAlpha_*_out*-Manhattan.png", emit: manhattans
        path "GWAlpha_*_out*-PEAKS.csv", emit: peaks
    shell:
    '''
    #!/usr/bin/env bash
    echo 'Extract peaks'
    parallel -j !{task.cpus} \
        Rscript !{projectDir}/scripts/plot_GWAlpha_output.r \
            {} \
            !{dir_data}/!{gff} \
            !{window_kb} \
            !{n_main_chrom} \
        ::: $(ls !{gwalpha_output})

    '''
}

// workflow {
//     MANHATTAN_PEAKS_ANNOTATION(Channel.fromPath(params.dir_data),
//                                Channel.fromPath(params.gff),
//                                params.window_kb,
//                                params.n_main_chrom)
// }

