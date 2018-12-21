# Clinical Heme Panel Optimisation

**Study of the unreported indels/substitutions in the pan-myeloid dataset in order to optimise the clinical heme pannel.**

***

## Working with this repository

### Clone the repository

To clone this repository on your local computer please run:
```shell
$ git clone https://github.com/PierreGuilmin/chpo.git
```

### Python requirements
Built with Python 3.6.6 working with JupyterLab, see requirements in [`conda-env_requirements.yml`](conda-env_requirements.yml), the main packages used are:
- `numpy`
- `pandas`
- `matplotlib`
- `seaborn`
- `requests`
- `nb_conda_kernels`

To create an appropriate conda environment to work with you can use:
```bash
conda env create --name chpo_env --file conda-env_requirements.yml
```

Some useful command lines to work with this conda-env:
```bash
# activate the conda-env
$ source activate chpo_env

# deactivate the conda-env
$ source deactivate

# remove the conda-env
$ conda env remove --name chpo_env
```

Then to run a jupyter lab instance within this environment run:
```bash
source activate chpo_env
jupyter lab
```

> :warning: Make sure to have `nb_conda_kernels` installed in your base conda environment to handle conda environments in Jupyter Lab.
> ```bash
> # go back to base environment
> source deactivate
> 
> # install nb_conda_kernels
> conda install nb_conda_kernels
> ```

Note: the environment and the `.yml` requirement file were created with the following commands:
```bash
# create conda-env
$ conda create --name chpo_env numpy pandas matplotlib seaborn requests nb_conda_kernels

# export requirements as .yml
conda env export > conda-env_requirements.yml
```

### R requirements
Built with `R 3.5.1` working with JupyterLab.

To work with this repository please make sure to have the following R packages installed:

- `RColorBrewer`
- `tidyverse`
- `survival`
- `survminer`

```R
# run in an R console
install.packages('RColorBrewer', repos = 'http://cran.us.r-project.org')
install.packages('tidyverse',    repos = 'http://cran.us.r-project.org')
install.packages('survival',     repos = 'http://cran.us.r-project.org')
install.packages('survminer',    repos = 'http://cran.us.r-project.org')
```

### `data/` requirements
The `data/` folder should contain:
- `raw/clinical_exons.txt`: selected exons list
- `raw/cinical_final.txt`: pan-myeloid data
- `raw/hostpots.txt`: selected hotspots list
- `raw/refFlat.canonical_all_coding_exons_aa.interval_list`: transcript info list

> :warning: This folder should not be versionned after you get the data.

## todo list

- [x] rename and format github
- [ ] OS plots for missense vs truncating
- [ ] lolliplots height issue
- [ ] lolliplots comment in notebook + `get_label()` issue
