# Installation from scratch

1. Install conda
```shell
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
sh ./Miniconda3-latest-Linux-x86_64.sh
echo "To finish the conda setup - log-out then log back in."
```
2. Configure conda
```shell
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge
```

3. Create a new conda environment
```shell
conda create --name "gwalpha_dmc"
conda env list
conda activate gwalpha_dmc
```

4. Install software
```shell
conda install -y parallel
conda install -y -c bioconda nextflow
conda install -y -c bioconda 'python=2.7'
conda install -y -c bioconda numpy scipy
conda install -y -c bioconda r-base


```

5. Export environment and create a new environment based on the exported settings
```shell
conda env export -n gwalpha_dmc > gwalpha_dmc.yml
```

6. Import conda environment
```shell
conda env create -n gwalpha_dmc_import --file gwalpha_dmc.yml
```