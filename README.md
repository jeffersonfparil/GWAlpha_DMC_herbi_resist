# GWAlpha_DMC_herbi_resist
Evolutionary quantitative genetics of herbicde resistance in weeds

## Usage

1. Download this repository
```shell
git clone https://github.com/jeffersonfparil/GWAlpha_DMC_herbi_resist.git
```

2. Download GWAlpha and dmc repositories
```shell
git clone https://github.com/aflevel/GWAlpha.git
git clone https://github.com/kristinmlee/dmc.git
```

3. Setup the conda environment
```shell
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
sh ./Miniconda3-latest-Linux-x86_64.sh
echo "To finish the conda setup - log-out then log back in."
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge
conda env create -n gwalpha_dmc --file gwalpha_dmc.yml
```

3. Run per module
```shell
# time nextflow run modules/setup.nf -c config/params.config
# time nextflow run modules/gwalpha.nf -c config/params.config
# time nextflow run modules/peaks.nf -c config/params.config
time nextflow run gwalpha_dmc.nf -resume
```