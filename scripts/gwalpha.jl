### Input files:
filename_sync = ARGS[1]
filename_phen_py = ARGS[2]
### Multi-threaded execution (parallel execution only applicable to model=="GWAlpha"):
using Distributed
Distributed.addprocs(length(Sys.cpu_info())-1)
@everywhere using GWAlpha
@time OUT_GWAS = GWAlpha.PoolGPAS(filename_sync=filename_sync,
                                  filename_phen=filename_phen_py,
                                  maf=0.001,
                                  depth=10,
                                  model="GWAlpha",
                                  fpr=0.01,
                                  plot=true)