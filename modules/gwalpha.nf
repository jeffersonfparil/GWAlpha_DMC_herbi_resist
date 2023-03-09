/////////////
// GWAlpha //
/////////////

process GWALPHA {
    label "HIGH_MEM_HIGH_CPU"
    publishDir params.dir_data, mode: 'symlink', overwrite: true
    input:
        path dir_data
        path dir_gwalpha
        val maf
    output:
        path "GWAlpha_*_out_*.csv"
    shell:
    '''
    #!/usr/bin/env bash
    echo 'GWAlpha'
    for f in $(find !{dir_data}/ -name '*.sync') $(find !{dir_data}/ -name '*_pheno.py')
    do
        bname=$(basename $f)
        ln -s $f $bname
    done
    parallel -j !{task.cpus} \
         python !{dir_gwalpha}/GWAlpha.py \
             {} \
             ML \
             -MAF !{maf} \
         ::: $(ls *.sync)
    '''
}

// workflow {
//     GWALPHA(Channel.fromPath(params.dir_data),
//             Channel.fromPath(params.dir_gwalpha),
//             params.maf)
// }
