FROM jupyter/minimal-notebook

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends octave \
        octave-symbolic octave-miscellaneous \
        python-sympy \
        gnuplot ghostscript && \
        fonts-humor-sans && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
# R pre-requisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    fonts-dejavu \
    unixodbc \
    unixodbc-dev \
    r-cran-rodbc \
    gfortran \
    gcc && \
    rm -rf /var/lib/apt/lists/*

# Fix for devtools https://github.com/conda-forge/r-devtools-feedstock/issues/4
RUN ln -s /bin/tar /bin/gtar

USER $NB_UID

# R packages
RUN conda install --quiet --yes \
    'r-base=3.5.1' \
    'r-rodbc=1.3*' \
    'unixodbc=2.3.*' \
    'r-irkernel=0.8*' \
    'r-plyr=1.8*' \
    'r-devtools=2.0*' \
    'r-tidyverse=1.2*' \
    'r-shiny=1.2*' \
    'r-rmarkdown=1.11*' \
    'r-forecast=8.2*' \
    'r-rsqlite=2.1*' \
    'r-reshape2=1.4*' \
    'r-nycflights13=1.0*' \
    'r-caret=6.0*' \
    'r-rcurl=1.95*' \
    'r-crayon=1.3*' \
    'r-randomforest=4.6*' \
    'r-htmltools=0.3*' \
    'r-sparklyr=0.9*' \
    'r-htmlwidgets=1.2*' \
    'r-hexbin=1.27*' && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR
    
# Octave
RUN conda install --quiet --yes \
    'octave_kernel' && \
    conda clean -tipsy

# Python 
RUN conda install --quiet --yes -c conda-forge ipywidgets && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR

RUN pip install numpy scipy matplotlib pandas ipywidgets && \
    jupyter nbextension enable --py widgetsnbextension && \
    jupyter labextension install @jupyter-widgets/jupyterlab-manager