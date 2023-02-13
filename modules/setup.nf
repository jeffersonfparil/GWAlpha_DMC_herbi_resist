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

// process INSTALL_JULIA_PACKAGES {
//     label "HIGH_MEM_HIGH_CPU"
//     input:
//         val dir
//     output:
//         val 0
//     shell:
//     '''
//     #!/usr/bin/env bash
//     cd !{dir}
//     echo 'using Pkg; Pkg.add(PackageSpec(url="https://github.com/jeffersonfparil/GWAlpha.jl.git", rev="master"))' > install_julia_packages.jl
//     julia install_julia_packages.jl
//     rm install_julia_packages.jl
//     '''
// }


// workflow {
//     INSTALL_JULIA_PACKAGES(params.dir_data)
// }