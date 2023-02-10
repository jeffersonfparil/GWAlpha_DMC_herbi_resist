/////////////
// GWAlpha //
/////////////

process GWALPHA {
    label "HIGH_MEM_HIGH_CPU"
    input:
        val dir_data
    output:
        val 0
    shell:
    '''
    #!/usr/bin/env bash
    echo 'GWAlpha'
    cd !{dir_data}
    for f in $(ls *.sync)
    do
        echo ${f%.sync*}_pheno.py >> test.tmp 
        julia !{projectDir}/../scripts/gwalpha.jl \
            ${f} \
            ${f%.sync*}_pheno.py
    done
    
    echo "Output:"
    echo "  (1/2) {sync_name}-GWAlpha-OUTPUT.csv"
    echo "  (2/2) {sync_name}-GWAlpha-OUTPUT.png"
    '''
}

workflow {
    GWALPHA(params.dir_data)
}
