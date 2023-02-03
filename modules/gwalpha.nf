/////////////
// GWAlpha //
/////////////

process GWALPHA {
    label "HIGH_MEM_HIGH_CPU"
    input:
        val dir_data
        val dir_gwalpha
    output:
        val 0
    shell:
    '''
    #!/usr/bin/env bash
    echo 'GWAlpha'
    cd !{dir_data}
    parallel -j !{task.cpus} \
        python !{dir_gwalpha}/GWAlpha.py \
            {} \
            ML \
        ::: $(ls *.sync)
    
    echo "Output:"
    echo "  (1/1) GWAlpha_{sync_name}_out.csv"
    '''
}

workflow {
    GWALPHA(params.dir_data, params.dir_gwalpha)
}
