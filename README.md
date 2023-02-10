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

3. Run per module
```shell
time nextflow run modules/setup.nf -c config/params.config
time nextflow run modules/gwalpha.nf -c config/params.config
```