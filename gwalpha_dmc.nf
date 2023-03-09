include { GWALPHA } from './modules/gwalpha.nf'
include { MANHATTAN_PEAKS_ANNOTATION } from './modules/peaks.nf'

workflow {
    gwalpha_output = GWALPHA(Channel.fromPath(params.dir_data),
                             Channel.fromPath(params.dir_gwalpha),
                             params.maf)

    qtl = MANHATTAN_PEAKS_ANNOTATION(Channel.fromPath(params.dir_data),
                                     Channel.fromPath(params.gff),
                                     params.window_kb,
                                     params.n_main_chrom,
                                     gwalpha_output)
}