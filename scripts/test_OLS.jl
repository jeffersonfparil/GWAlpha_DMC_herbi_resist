fname_sync = "/home/jeffersonfparil/Documents/GWAlpha_DMC_herbi_resist/test/Lolium_ACC031_GLYPH.sync"
fname_phen = "/home/jeffersonfparil/Documents/GWAlpha_DMC_herbi_resist/test/Lolium_ACC031_GLYPH_pheno.py"

function load_phenotype(fname_phen::String)::Vector{Float64}
    file_py = open(fname_phen, "r")
    y = []
    while !eof(file_py)
        line = readline(file_py)
        if line[1] == 'q'
            y = parse.(Float64, split(replace(replace(line, "q=["=>""), "];"=>""), ","))
        end
    end
    close(file_py)
    return(y)
end


function load_genotype(fname_sync::String)::Vector{Matrix{Int64}}
    file = open(fname_sync, "r")
    npools = length(split(readline(file), "\t")) - 3
    seek(file, 0)

    OUT = []

    while !eof(file)
        line = split(readline(file), "\t")
        chr = line[1]
        pos = parse(Int64, line[2])
        ale = line[3]
        C = zeros(Int64, npools, 6)
        for i in 4:(npools+3)
            # i = 4
            C[i-3, :] = parse.(Int64, split(line[i], ":"))
        end
        push!(OUT, C)
    end
    close(file)
    return(OUT)
end


y = load_phenotype(fname_phen)
X = 