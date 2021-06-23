
## using rocker/verse and adding some stuff for ARC

FROM rocker/verse:4.1.0

LABEL org.label-schema.license="GPL-2.0" \
      org.label-schema.vcs-url="https://github.com/rsettlag" \
      maintainer="Robert Settlage <rsettlag@vt.edu>"
## helpful read: https://divingintogeneticsandgenomics.rbind.io/post/run-rstudio-server-with-singularity-on-hpc/
ENV RSTUDIO_VERSION=${RSTUDIO_VERSION:-1.2.5042}
ENV PATH="${PATH}:/miniconda3/bin"

RUN apt update \
  && apt-get install -y curl wget gzip locate jags

RUN Rscript -e "install.packages(Ncpus=6,c('rjags', 'tidyverse', 'dplyr', 'devtools', 'data.table', 'reticulate', 'ggpubr', 'rlecuyer', 'pkgmaker', 'gtools', 'RcppEigen', 'ggrepel', 'gplots'))"
RUN tlmgr install harvard ctable multirow eurosym comment setspace enumitem \
      --repository http://ctan.math.illi­nois.edu/systems/texlive/tlnet\
  && tlmgr path add
RUN chown -R root:staff /opt/ \
  && chmod -R g+wx /opt/ \
  && tlmgr path add

RUN Rscript -e "library(reticulate); install_miniconda(path='/miniconda3',update=TRUE,force=TRUE)"

RUN apt-get clean
#RUN sed -i '/^R_LIBS_USER=/d' /usr/local/lib/R/etc/Renviron
#RUN echo 'R_ENVIRON=~/.Renviron.OOD \
RUN echo 'R_ENVIRON_USER=~/.Renviron.OOD \
      \n' >>/usr/local/lib/R/etc/Renviron
RUN rm /usr/local/lib/R/etc/Rprofile.site
#RUN echo 'auth-none=0' >>/etc/rstudio/disable_auth_rserver.conf 
